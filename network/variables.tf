
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

variable "enable_fw_logging" {
  description = "If true, will enable logging for firewall rules"
  type = bool
  default = false  ## Default value - variable is optional
}


