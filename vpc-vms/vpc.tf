resource "google_compute_network" "vpc" {
  count                    = var.num_vpcs
  name                     = "${local.name_prefix}-${count.index+1}"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
  mtu                      = 1460
}

## Subnets


resource "google_compute_subnetwork" "sub1" {
  name          = "${local.name_prefix}-sub1"
  ip_cidr_range = var.sub1_cidr
  region        = var.region
  network          = google_compute_network.vpc[0].id
  ipv6_access_type = "INTERNAL"
  stack_type       = "IPV4_IPV6"

  log_config {
    aggregation_interval = "INTERVAL_1_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "sub2" {
  name          = "${local.name_prefix}-sub2"
  ip_cidr_range    = var.sub2_cidr
  region = var.region
  network          = google_compute_network.vpc[0].id
  ipv6_access_type = "INTERNAL"
  stack_type       = "IPV4_IPV6"
  log_config {
    aggregation_interval = "INTERVAL_1_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

## Firewall rules

# Firewall rules

resource "google_compute_firewall" "iap" {
  count = var.num_vpcs
  name  = "${local.name_prefix}-iap-${count.index}"
  allow {
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc[count.index].id
  priority      = var.def_fw_rule_priority
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
