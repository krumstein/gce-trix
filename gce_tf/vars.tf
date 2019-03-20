variable "credentials_file" {}
variable "project" {}
variable "region" {
    default = "europe-west1"
}
variable "zone" {
    default = "europe-west1-b"
}

variable "name_prefix" {}

variable "public_network" {
    default = "10.10.0.0/16"
}

variable "private_network" {
    default = "10.141.0.0/16"
}

variable "ctrl_size" {
    default = "n1-standard-1"
}

variable "ctrl_disk_size" {
    default = 50
}

variable "ctrl_user" {
    default = "centos"
}

variable "ctrl_ip" {
    default = "10.141.254.254"
}

