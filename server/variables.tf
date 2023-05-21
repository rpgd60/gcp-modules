variable "server_name" {
  description = "Name of server"
  type = string
## No default - variable is required

}

variable "machine_type" {
  description = "Machine type e.g. E2, N2, T2A"
  type        = string
## No default - variable is required
}

variable "image" {
  description = "Image for VM"
  type = string
  default = "debian11"
}

variable "network_name" {
  description = "name of Network for VM"
  type = string
}

variable "subnet_id" {
  description = "ID of subnet for VM"
  type = string
}


