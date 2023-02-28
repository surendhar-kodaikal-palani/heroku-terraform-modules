# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket  = "heroku-dev-terraform-state"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "us-west-2"
  }
}
terraform {
  extra_arguments "bucket" {
    commands = "${get_terraform_commands_that_need_vars()}"
  }

}