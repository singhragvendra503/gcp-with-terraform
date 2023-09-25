terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.79.0"
    }
  }
}

provider "google" {
  project     = "terraform-gcp-provider"
  region      = "us-west1"
  credentials = file("terraform-gcp-provider-64fbb35e93e3.json")
}
resource "google_compute_network" "vpc_network" {
  name                    = "my-custom-mode-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_firewall" "all_deny" {
  name    = "all-deny"
  network = google_compute_network.vpc_network.name

  deny {
    protocol = "all"
  }
  priority = "1000"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  priority = "999"
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-west1-a"
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.default.self_link
    access_config {

    }
  }
}
output "this" {
  value = google_compute_instance.default.network_interface
}