variable "heroku_api_key" {
  type      = string
  sensitive = true
}

variable "space_name" {
  type        = string
  description = "The name of the Private Space"
}

variable "external_space_name" {
  type        = string
  description = "The name of the Private Space"
}

variable "organization" {
  type        = string
  description = "The name of the Heroku Team which will own the Private Space."
}

variable "region" {
  type        = string
  description = "The AWS region for the Private Space"
}

variable "cidr" {
  type        = string
  description = "The RFC-1918 CIDR the Private Space will use. It must be a /16 in 10.0.0.0/8, 172.16.0.0/12 or 192.168.0.0/16"
}

variable "data_cidr" {
  type        = string
  description = "The RFC-1918 CIDR that the Private Space will use for the Heroku-managed peering connection that’s automatically created when using Heroku Data add-ons. It must be between a /16 and a /20"
}

variable "shield" {
  type        = bool
  description = "Enable Shield for Private Space"
}

#Private Space Access

variable "add_team_members" {
  type        = bool
  description = "Add team members to the Prvate Space or not"
  default = false
}

variable "access" {
  type = list(object({
    email   = string
    permissions  = list(string)
  }))
  default = {
    "member1" = {
      email = "surendhar@example.com"
      permissions = ["create_apps"] # Give an existing team member create_apps permissions to the Private Space
    },
    "member2" = {
      email = "skodaikal@example.com" #Remove all permissions from an existing team member
      permissions = [] 
    }
  }
}

# Private Space with Inbound rules

variable "enable_inbound_ruleset" {
  type        = bool
  description = "Create a Private Space which has custom Inbound ruleset"
  default = false
}

variable "space_name_with_inbound_rules" {
  type        = string
  description = "The name the Heroku Private Space with inbound rules"
}

variable "enable_inbound_rules" {
  type        = bool
  description = "Should we expose Private Space to external world by using inbound ruleset"
  default = false
}

variable "rules" {
  description = "A map of inbound rules to create for the Heroku Space."
  type = map(object({
    action        = string
    source        = string
  }))
  default = {
    rule1 = {
      action     = "allow"
      source   = "10.0.0.0/16"
    },
    rule2 = {
      action     = "deny"
      source   = "172.0.0.0/16"
    }
  }
}

variable "existing_space_name" {
  type        = string
  description = "Existing Pivate Space Name which requires VPC peering"
}