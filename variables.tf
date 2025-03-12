variable "project_name" {
  type    = string
  default = "terraform-pekao"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "vm_name" {
  type = string
  default = "vm1-f"
}

variable "vm_type" {
  type = string
  default = "e2-micro"
}

variable "vm_zone" {
  type = string
  default = "us-central1-a"
}

variable "vm_os" {
  type = string
  default = "debian-cloud/debian-11"
}

variable "ssh_user" {
  type = string
  default = "student"
}

variable "ssh_public_key" {
  type = string
  default = "/home/student/.ssh/gcp_key.pub"
}

variable "disk_name" {
  type = string
  default = "diskf"
}

variable "disk_type" {
  type = string
  default = "pd-standard"
}

variable "disk_size" {
  type = number
  default = 10
}
