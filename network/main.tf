# VPC
resource "google_compute_network" "vpc" {
  name                     = var.network_name
  auto_create_subnetworks  = false
  mtu                      = 1460
}

## Subnet

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  network          = google_compute_network.vpc.id
}

## Firewall rules

resource "google_compute_firewall" "ssh" {
  name  = "${google_compute_network.vpc.name}-m04-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc.id
  priority      = "1000"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "web" {
  name  = "${google_compute_network.vpc.name}-m04-web"
  # name  = "m04-web"
  allow {
    ports    = ["80", "443"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc.id
  priority      = "1000"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]

  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "icmp" {
  name  = "${google_compute_network.vpc.name}-m04-icmp"
  allow {
    protocol = "icmp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc.id
  priority      = "1000"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["icmp"]

  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}


