
variable "network_name" {
  description = "Name of network"
  type = string
  ## Note - no default : this is a required variable
}

variable "subnet_cidr" {
  description = "CIDR (address range) for subnet in network"
  type = string 
  ## Note - no default : this is a required variable
}


