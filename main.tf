terraform {
  # cloud {
  #   organization = "George-Terraform-bootcamp-2023"

  #   workspaces {
  #     name = "terraform-bootcamp"
  #   }
  # }
}

module "terrahouse_aws" {
  source = "./module/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
}