provider "google" {
  credentials = "${file("${var.credentials_file}")}"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
}
resource "google_compute_network" "trix-public-vpc" {
  name                    = "${var.name_prefix}-public-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_network" "trix-cluster-vpc" {
  name                    = "${var.name_prefix}-cluster-vpc"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "trix-public" {
  name          = "${var.name_prefix}-public"
  ip_cidr_range = "${var.public_network}"
  network       = "${google_compute_network.trix-public-vpc.self_link}"
}

resource "google_compute_subnetwork" "trix-cluster" {
  name          = "${var.name_prefix}-cluster"
  ip_cidr_range = "${var.private_network}"
  network       = "${google_compute_network.trix-cluster-vpc.self_link}"
}

resource "google_compute_firewall" "trix-external-firewall" {
  name    = "${var.name_prefix}-external-firewall"
  network = "${google_compute_network.trix-public-vpc.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22","443"]
  }

  source_ranges = ["0.0.0.0/0"]
  depends_on = ["google_compute_network.trix-public-vpc"]
}

resource "google_compute_firewall" "trix-internal-firewall" {
  name    = "${var.name_prefix}-internal-firewall"
  network = "${google_compute_network.trix-cluster-vpc.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = ["google_compute_network.trix-cluster-vpc"]
}


resource "google_compute_address" "trix-static" {
  name = "${var.name_prefix}-ipv4-address"
}

resource "google_compute_instance" "trix-ctrl0" {
  name         = "${var.name_prefix}-ctrl0"
  machine_type = "${var.ctrl_size}"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "${var.ctrl_disk_size}"
    }
   
  }

  metadata {
   sshKeys = "${var.ctrl_user}:${file("~/.ssh/id_rsa.pub")}"
  }

  network_interface {
    subnetwork       = "${google_compute_subnetwork.trix-public.self_link}"
    access_config = {
      nat_ip = "${google_compute_address.trix-static.address}"
    }
  }

  network_interface {
    subnetwork       = "${google_compute_subnetwork.trix-cluster.self_link}"
    network_ip       = "${var.ctrl_ip}"
    access_config = {
    }
  }

  depends_on = [ "google_compute_address.trix-static" ]

}

output "ip" {
 value = "${google_compute_instance.trix-ctrl0.network_interface.0.access_config.0.nat_ip}"
}
output "ctrl_hostname" {
 value = "${google_compute_instance.trix-ctrl0.name}"
}
