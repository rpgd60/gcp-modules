
output "project_name" {
  value = data.google_project.my_proj.name
}

output "project_number" {
  value = data.google_project.my_proj.number
}

output "project_id" {
  value = data.google_project.my_proj.id
}

output "project_info" {
  value = data.google_project.my_proj
}


output "vmu_public_ip" {
  value = google_compute_instance.vmu[*].network_interface[0].access_config[0].nat_ip
}
output "vmd_public_ip" {
  value = google_compute_instance.vmd[*].network_interface[0].access_config[0].nat_ip
}

output "vmu_private_ip" {
  value = google_compute_instance.vmu[*].network_interface[0].network_ip
}
output "vmd_private_ip" {
  value = google_compute_instance.vmd[*].network_interface[0].network_ip
}


output "ssh_u" {
  value = [for i in range(var.num_ubuntu_vms) : "gcloud compute ssh --zone ${google_compute_instance.vmu[i].zone} ${google_compute_instance.vmu[i].name} --project ${data.google_project.my_proj.project_id}"]
}


output "ssh_d" {
  value = [for i in range(var.num_debian_vms) : "gcloud compute ssh --zone ${google_compute_instance.vmd[i].zone} ${google_compute_instance.vmd[i].name} --project ${data.google_project.my_proj.project_id}"]
}

output "app_u" {
  value = [for i in range(var.num_ubuntu_vms) : "curl ${google_compute_instance.vmu[i].network_interface[0].access_config[0].nat_ip}:${var.app_port}/"]
}

output "app_d" {
  value = [for i in range(var.num_debian_vms) : "curl ${google_compute_instance.vmd[i].network_interface[0].access_config[0].nat_ip}:${var.app_port}/"]
}

# output "ssh_test" {
#   value = [for i in range(var.num_debian_vms) : "gcloud compute ssh ${i}"]
# }

# output "ssh_c" {
#   value = [for i in range(var.num_vms) : "gcloud compute ssh --zone ${google_compute_instance.vmc[i].zone} ${google_compute_instance.vmc[i].name} --project ${data.google_project.my_proj.project_id}"]
# }
# gcloud compute ssh --zone "europe-west4-a" "vma-0" --project "meteo-376317"