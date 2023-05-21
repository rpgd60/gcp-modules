resource "google_compute_network" "mi_vpc" {
  name                     = var.network_name
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
  mtu                      = 1460
}

## Subnets


resource "google_compute_subnetwork" "mi_subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network          = google_compute_network.mi_vpc.id
}

## Firewall rules


resource "google_compute_firewall" "iap" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-iap-${count.index}"
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.mi_vpc.id
  priority      = 1000
  source_ranges = [var.iap_range]
  target_tags   = ["ssh"]
  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "ssh" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-ssh-${count.index}"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "ssh_v6" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-ssh-v6-${count.index}"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["::/0"]
  target_tags   = ["ssh"]
  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}
resource "google_compute_firewall" "web" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-web-${count.index}"
  allow {
    ports    = ["80", "443"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]

  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "app" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-app-${count.index}"
  allow {
    ports    = [var.app_port]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["app"]

  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "app_v6" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-app-v6-${count.index}"
  allow {
    ports    = [var.app_port]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["::/0"]
  target_tags   = ["app"]

  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}
resource "google_compute_firewall" "web_v6" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-web-v6-${count.index}"
  allow {
    ports    = ["80", "443"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["::/0"]
  target_tags   = ["web"]

  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}
resource "google_compute_firewall" "icmp" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-icmp-${count.index}"
  allow {
    protocol = "icmp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["icmp"]

  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "icmp_v6" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-icmp-v6-${count.index}"
  allow {
    ## 58 is protocol for ICMP-v6 
    protocol = "58"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
  source_ranges = ["::/0"]
  target_tags   = ["icmp"]
  dynamic  log_config {
    for_each = var.enable_fw_logging ? ["dummy"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}
