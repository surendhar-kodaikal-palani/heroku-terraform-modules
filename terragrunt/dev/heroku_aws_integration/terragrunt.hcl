# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
include {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:surendhar-kodaikal-palani/heroku-terraform-modules.git//modules/heroku_space_and_aws_integration?ref=INFRA-first-pr"
}

inputs = {
   create_private_space = true
   space_name = "private-health"
   organization = "health"
   region = "us"
   shield = true
   cidr = "10.0.0.0/16"
   data_cidr = "10.1.0.0/16"

   add_team_members = true
   access = {
    "member1" = {
      email = "surendhar@example.com"
      permissions = ["create_apps"] 
    },
    "member2" = {
      email = "skodaikal@example.com" 
      permissions = [] 
    }
  }

  enable_inbound_ruleset = "false"

  vpc_name = "my-vpc"
  vpc_cidr = "10.51.0.0/16"
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  db_subnets      = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]

  db_name          = "my-rds-instance"
  db_engine        = "postgres"
  db_engine_version = "5.7.22"
  db instance_class = "db.t2.micro"  
  enable_vpn = false  
}