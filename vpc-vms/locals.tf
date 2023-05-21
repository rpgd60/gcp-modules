locals {
  common_labels = {
    "managed_by"  = "terraform"
    "environment" = var.environment
    "company"     = var.company
    "project"     = var.project
    "application" = var.app_name
  }
  name_prefix = "${var.company}-${var.app_name}-${var.environment}"

}