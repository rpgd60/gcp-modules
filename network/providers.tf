## Terraform block in module in case the required versions are different
terraform {
  required_version = "~>1.4.0"

  # required_providers {
  #   google = {
  #     source  = "hashicorp/google"
  #     version = ">= 4.60.0"
  #   }
  # }
}

# provider "google" {
#   project = var.project
#   region  = var.region
#   # zone    = var.zone
# }

