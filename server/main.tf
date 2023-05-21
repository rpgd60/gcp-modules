# Ubuntu VMs
resource "google_compute_instance" "vm" {
  name         = var.server_name
  machine_type = var.machine_type
  tags         = var.network_tags
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    subnetwork = var.subnet_name
    stack_type = "IPV4_IPV6"

    access_config {
      # Include this section to give the VM an external IP address
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email  = google_service_account.default.email
    email=var.service_account_email
    scopes = ["cloud-platform"]
  }
  allow_stopping_for_update = true
}

