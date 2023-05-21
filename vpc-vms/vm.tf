
# startup files
locals {
  ubuntu_startup = templatefile("${path.module}/startup_ubuntu.sh", { "application_port" : var.app_port } )
  debian_startup = templatefile("${path.module}/startup_debian.sh", { "application_port" : var.app_port } )
}
# Debian VMs
resource "google_compute_instance" "vmd" {
  count        = var.num_debian_vms
  name         = "vmd-${local.name_prefix}-${count.index + 1}"
  machine_type = var.machine_type
  ## TODO - parametrize
  tags         = var.network_tags
  labels       = merge(local.common_labels, { "os" = "debian" })
  zone         = element(var.zone, count.index)

  boot_disk {
    initialize_params {
      image = var.image_debian
    }
  }
  # metadata_startup_script = file("${path.module}/startup_debian.sh")
  metadata_startup_script = local.debian_startup

  network_interface {
    subnetwork = google_compute_subnetwork.sub2.id

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



# Ubuntu VMs
resource "google_compute_instance" "vmu" {
  count        = var.num_ubuntu_vms
  name         = "vmu-${local.name_prefix}-${count.index + 1}"
  machine_type = var.machine_type
  ## +1 so that when we have only two VMs (1 debian, 1 ubuntu) they are deployed in different zones
  zone         = element(var.zone, count.index + 1)
  ## TODO - parametrize
  tags         = var.network_tags
  labels       = merge(local.common_labels, { "os" = "ubuntu" })
  boot_disk {
    initialize_params {
      image = var.image_ubuntu
    }
  }
  # Install minimal web server
#  metadata_startup_script = file("${path.module}/startup_ubuntu.sh")
  metadata_startup_script = local.ubuntu_startup
  network_interface {
    subnetwork = google_compute_subnetwork.sub1.id
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

