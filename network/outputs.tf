
output "network_name" {
  description = "Network name"
  value = google_compute_network.mi_vpc.name
}

output "subnet_id" {
  description = "subnet ID"
  value = google_compute_subnetwork.mi_subnet.id
}

