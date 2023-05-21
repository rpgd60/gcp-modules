variable "region" {
  description = "GCP main region"
  default     = "us-central1"
  type        = string
}

variable "zone" {
  description = "Zones within region"
  type        = list(string)
  default = ["us-central1-a", "us-central1-b"]
}

variable "company" {
  type = string
  default = "acme"
}

## From parent module?
variable "project" {
  type    = string
}

variable "app_name" {
  description = "Application Name - used in resource naming"
  type        = string
  default = "app1"
}

variable "environment" {
  description = "Environment (prod, test, dev) -use d in resource naming"
  type        = string
}

variable "num_vpcs" {
  type    = number
  default = 1
  validation {
    condition     = var.num_vpcs >= 1 && var.num_vpcs <= 4
    error_message = "number of vpcs must be min 1 and max 4"
  }
}

variable "network_tags" {
  type =  list(string)
  description = "Network tags for VM - e.g. [\"ssh\", \"web\", \"icmp\", \"app\"]"
  default = []
}

variable "sub1_cidr" {
  type = string
}

variable "sub2_cidr" {
  type = string
}

variable "enable_fw_logging" {
  type = bool
  description = "Enable firewall rule logging"
  default = false
}

variable "num_ubuntu_vms" {
  description = "number of VMs per region"
  type        = number
  default     = 0
  validation {
    condition     = var.num_ubuntu_vms >= 0 && var.num_ubuntu_vms <= 4
    error_message = "number of vms per region must be min 0 and max 4"
  }
}

variable "num_debian_vms" {
  description = "number of debian VMs per region"
  type        = number
  default     = 0
  validation {
    condition     = var.num_debian_vms >= 0 && var.num_debian_vms <= 4
    error_message = "number of debian vms per region must be min 0 and max 4"
  }
}

## Note Ops Agent not supported in ARM processors as of May 2023
## https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent#supported_vms
variable "use_arm_proc" {
  type = bool
  default = false
}
variable "machine_type" {
  description = "Machine type e.g. E2, N2, T2A"
  type        = string
  default = "e2-small"
}


variable "def_fw_rule_priority" {
  description = "Default value for firewall rule priority"
  type        = number
  default     = 1000
}


variable "image_ubuntu" {
  description = "Ubuntu image to deploy"
  type        = string
}


variable "image_debian" {
  description = "Debian image to deploy"
  type        = string
}

variable "app_port" {
  description = "Port for flask app"
  type =string
  default = 4004
}
variable "iap_range" {
  description = "Range of IPs used by IAP"
  type        = string
  default     = "35.235.240.0/20"
}

variable "service_account_email" {
  description = "email that identifies the service account applied to the vm"
  type = string
}
