
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
  type = bool
  description = "Enable firewall rule logging"
  ## There is default value - variable is optional
  default = false
}

variable "iap_range" {
  description = "Range of IPs used by IAP"
  type        = string
  ## There is default value - variable is optional
  default     = "35.235.240.0/20"
}
