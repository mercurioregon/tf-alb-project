# Define the locals here.  This names an expression for use multiple times in the code.check "name" {

locals {
  owners      = var.business_division
  environment = var.environment
  name        = "${var.business_division}-${var.environment}"
  common_tags = {
    owners      = "business_division"
    environment = "environment"
  }
}