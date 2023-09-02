variable "bucket_name" {
  type        = string
  description = "Bucket name for exporting AMIs."
  default     = "super-duper-doodle"
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
  default = {
    Project = "bobbins"
  }
}

variable "store_secret_creds" {
  description = "Store IAM creds for GCP to use to import AMIs"
  default     = false
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

