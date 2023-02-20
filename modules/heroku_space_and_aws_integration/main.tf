resource "heroku_space" "private" {
  count = var.create_private_space ? 1 : 0

  name         = var.space_name
  organization = var.organization
  region       = var.region
  shield       = var.shield
  cidr         = var.cidr
  data_cidr    = var.data_cidr
}

##############################################################################################################################################

resource "heroku_space_app_access" "this" {

  for_each    = { for k, v in var.access : k => v if var.add_team_members }
  space       = heroku_space.this.id
  email       = each.value.email
  permissions = each.value.permissions
}

##############################################################################################################################################

resource "heroku_space" "expose_private_with_inbound_rules" {
  count = var.enable_inbound_rules ? 1 : 0

  name         = var.space_name_with_inbound_rules
  organization = var.organization
  region       = var.region
  shield       = var.shield
  cidr         = var.cidr
  data_cidr    = var.data_cidr
}

resource "heroku_space_inbound_ruleset" "this" {
  count = var.enable_inbound_ruleset ? 1 : 0

  space = heroku_space.expose_private_with_inbound_rules

  dynamic "rule" {
    for_each = var.rules
    content {
      action = rule.value["action"]
      source = rule.value["source"]
    }
  }
}

############## DEPLOY VPC WITH NAT GATEWAY, INTERNET GAYEWAY, PRIVATE SUBNET, DB SUBNET, PUBLIC SUBNET ############################################################

# Define AWS provider and VPC
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.16.0"

  name = var.vpc_name

  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  db_subnets      = var.db_subnets

  enable_nat_gateway = var.enable_nat_gateway

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
# Create RDS instance in DB subnet
module "rds" {
  source = "terraform-aws-modules/rds/aws"

  name           = var.db_name
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  subnet_ids = module.vpc.db_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# VPC Peering with AWS account for Multi Cloud functionality and use aws resources such as Elasticache, RDS, MSK with encrytion at rest
data "heroku_space_peering_info" "peer_space" {
  name = var.enable_inbound_rules ? heroku_space.expose_private_with_inbound_rules.name : var.create_private_space ? heroku_space.private.name : var.existing_space_name
}

resource "aws_vpc_peering_connection" "request" {
  peer_owner_id = data.heroku_space_peering_info.peer_space.aws_account_id
  peer_vpc_id   = data.heroku_space_peering_info.peer_space.vpc_id
  vpc_id        = module.vpc.id
}

resource "heroku_space_peering_connection_accepter" "accept" {
  space                     = heroku_space.peer_space.id
  vpc_peering_connection_id = aws_vpc_peering_connection.request.id
}

##############################################################################################################################################

# VPN Connection

resource "heroku_space_vpn_connection" "office" {
  count = var.enable_vpn > 0 ? 1 : 0

  name           = "office"
  space          = var.enable_inbound_rules ? heroku_space.expose_private_with_inbound_rules.name : var.create_private_space ? heroku_space.private.name : var.existing_space_name
  public_ip      = var.public_ip
  routable_cidrs = var.routable_cidrs
}
