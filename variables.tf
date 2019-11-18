variable "gce_ssh_user" {
  default = ""
}

variable "pub_key_file" {
  default = ""
}

variable "network_interface" {
  default = []
}

variable "subnetwork" {
  default = ""
}

variable "compute_name" {
  default = ""
}

variable "instance_name_header" {
  default = ""
}

variable "count_compute" {
  default = ""
}

variable "count_start" {
  default = ""
}

variable "compute_labels" {
  type    = "map"
  default = {}
}

variable "compute_zones" {
  default = []
}

variable "tags_network" {
  default = []
}

variable "images_name" {
  default = ""
}

variable "size_root_disk" {
  default = ""
}

variable "type_root_disk" {
  default = ""
}

variable "compute_type" {
  default = ""
}

variable "compute_zone" {
  default = ""
}

variable "service_group" {
  default = ""
}

variable "service_name" {
  default = ""
}

variable "service_type" {
  default = ""
}

variable "skip_alert" {
  default = ""
}

variable "ansible_user" {
  default = ""
}

variable "ansible_port" {
  default = ""
}

variable "ip_forward" {
  default = "false"
}

variable "public_ip" {
  default = "true"
}

variable "additional_disk" {
  default = ""
}

variable "size_additional_disk" {
  default = ""
}

variable "type_additional_disk" {
  default = ""
}

variable "name_additional_disk" {
  default = ""
}

variable "startup_script" {
  default = ""
}

variable "healthcheck_port" {
  default = 443
}

variable "request_path" {
  default = "/"
}

variable "environment" {
  default = ""
}

variable "compute_count" {
  default = ""
}

variable "can_ip_forward" {
  default = ""
}

variable "subnetwork_project" {
  default = ""
}

variable "allow_stopping_for_update" {
  default = ""
}

variable "on_host_maintenance" {
  default = ""
}

variable "automatic_restart" {
  default = ""
}

variable "check_interval_sec" {
  default = ""
}

variable "timeout_sec" {
  default = ""
}

variable "healthy_threshold" {
  default = ""
}

variable "unhealthy_threshold" {
  default = ""
}

variable "region" {
  default = ""
}