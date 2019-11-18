resource "google_compute_instance" "default" {
  count          = var.compute_count
  name           = format("vm-%s-%s-%d", var.instance_name_header, var.compute_name, count.index + var.count_start)
  machine_type   = var.compute_type
  zone           = element(var.compute_zones, count.index)
  can_ip_forward = var.can_ip_forward
	project				 = var.compute_project

  boot_disk {
    initialize_params {
      image = var.images_name
      size  = var.size_root_disk
      type  = var.type_root_disk
    }
  }

  lifecycle {
    ignore_changes = [ "attached_disk" ]
  }

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
  }

  labels = {
    environment        = var.environment
    service_group      = var.service_group
    service_name       = var.service_name
    service_type       = var.service_type
    name               = format("%s-%d", var.compute_name, count.index + var.count_start)
    created_by         = "terraform"
    skip_alert         = var.skip_alert
  }

  tags = [var.environment, var.service_group, var.service_name, var.service_type, var.compute_name, "terraform"]

  allow_stopping_for_update = var.allow_stopping_for_update

  scheduling {
    on_host_maintenance = var.on_host_maintenance
    automatic_restart   = var.automatic_restart
  }
}

resource "google_compute_instance_group" "default-instance-group" {
  # count     = min(google_compute_instance.default.count, length(var.compute_zones))
  count			= min(length(google_compute_instance.default))

  name      = format("%s-%s-group-%d", var.instance_name_header, var.compute_name, count.index + 1)
  instances = ["${google_compute_instance.default.*.self_link}"]
  # instances = matchkeys(google_compute_instance.default.*.self_link, google_compute_instance.default.*.zone, list(element(var.compute_zones, count.index)))
  #zone = "${var.compute_zone}"
  zone      = element(google_compute_instance.default.*.zone, count.index)
	project		= var.compute_project

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_backend_service" "default_region_backend_service" {
  name             = "${var.instance_name_header}-${var.compute_name}-ilb"
  protocol         = "TCP"
  timeout_sec      = 10
  session_affinity = "NONE"
  connection_draining_timeout_sec = "120"
	project					 = var.compute_project
	region					 = var.region

  backend {
		group = element(matchkeys(google_compute_instance_group.default-instance-group.*.self_link, google_compute_instance_group.default-instance-group.*.zone, list(element(var.compute_zones, 0))),0)
  }

  backend {
    group = element(matchkeys(google_compute_instance_group.default-instance-group.*.self_link, google_compute_instance_group.default-instance-group.*.zone, list(element(var.compute_zones, 1))),0)
  }

  backend {
    group = element(matchkeys(google_compute_instance_group.default-instance-group.*.self_link, google_compute_instance_group.default-instance-group.*.zone, list(element(var.compute_zones, 2))),0)
  }

  health_checks = ["${google_compute_health_check.default-health-check.self_link}"]
}

resource "google_compute_health_check" "default-health-check" {
  name                  = "${var.instance_name_header}-${var.compute_name}-hc"
  check_interval_sec    = var.check_interval_sec
  timeout_sec           = var.timeout_sec
  healthy_threshold     = var.healthy_threshold
  unhealthy_threshold   = var.unhealthy_threshold
	project								= var.compute_project

  tcp_health_check {
    port         = var.healthcheck_port
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "google_compute_subnetwork" "default-subnetwork" {
  name      = var.subnetwork_project
  region    = var.region
  project   = var.subnetwork_project
}

resource "google_compute_forwarding_rule" "default-forwarding-rule" {
  provider              = "google-beta"
  name                  = "${var.instance_name_header}-${var.compute_name}-fw-rule"
  service_label         = var.environment
  load_balancing_scheme = var.load_balancing_scheme
  ports                 = [var.healthcheck_port]
	project								= var.subnetwork_project
	region    						= var.region

  backend_service       = google_compute_region_backend_service.default_region_backend_service.self_link
  subnetwork            = data.google_compute_subnetwork.default-subnetwork.self_link
}