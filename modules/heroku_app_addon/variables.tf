variable "app_and_addons_config" {
  type = map(object({
    name                  = string
    region                = string
    stack                 = string
    space                 = string
    internal_routing      = bool
    acm                   = bool
    organization          = map(string)
    buildpacks            = list(string)
    config_vars           = map(string)
    sensitive_config_vars = map(string)
    addons = map(object({
      plan   = string
      config = map(string)
    }))
  }))

  default = {
    "comms-app" = {
      name             = "comms-service"
      region           = "us"
      stack            = "heroku-20"
      space            = "private-sapce"
      internal_routing = false
      acm              = "true"
      organization     = "Health"
      buildpacks = [
        "https://github.com/heroku/heroku-buildpack-ruby",
        "heroku/nodejs",
        "heroku/ruby"
      ]
      config_vars = {
        DATABASE_URL = "postgres://user:password@hostname:port/database"
        SECRET_KEY   = "example-secret-key"
        ENVIRONMENT  = "production"
      }
      sensitive_config_vars = {
        DATABASE_URL = "postgres://user:password@hostname:port/database"
        SECRET_KEY   = "example-secret-key"
        ENVIRONMENT  = "production"
      }

      addons = {
        "addon1" = {
          plan = "heroku-postgresql:mini"
          config = {
            ENV       = "dev"
            TERRAFORM = true
          }
        },
        "addon2" = {
          plan = "heroku-redis:standard-0"
          config = {
            ENV       = "dev"
            TERRAFORM = true
          }
        }
      }


    },
    "users-app" = {
      name             = "users-service"
      region           = "us"
      stack            = "heroku-20"
      space            = "private-sapce"
      internal_routing = false
      acm              = "true"
      organization     = "Health"
      buildpacks = [
        "https://github.com/heroku/heroku-buildpack-ruby",
        "heroku/nodejs",
        "heroku/ruby"
      ]
      config_vars = {
        DATABASE_URL = "postgres://user:password@hostname:port/database"
        SECRET_KEY   = "example-secret-key"
        ENVIRONMENT  = "production"
      }
      sensitive_config_vars = {
        DATABASE_URL = "postgres://user:password@hostname:port/database"
        SECRET_KEY   = "example-secret-key"
        ENVIRONMENT  = "production"
      }
      addons = {
        "addon1" = {
          plan = "heroku-postgresql:standard-0"
          config = {
            ENV       = "dev"
            TERRAFORM = true
          }
        },
        "addon2" = {
          plan = "heroku-redis:mini"
          config = {
            ENV       = "dev"
            TERRAFORM = true
          }
        }
      }

    }
  }
}


#####

variable "single_app_name" {
  type        = string
  description = "Name of the single app"
  default     = ""
}

variable "single_app_region" {
  type        = string
  description = "Heroku region for the app"
  default     = "us"
}

variable "single_app_stack" {
  type        = string
  description = "Heroku stack for the app"
  default     = "heroku-20"
}

variable "single_app_buildpacks" {
  type        = list(string)
  description = "List of Heroku buildpacks for the app"
  default     = []
}

variable "single_app_enable_private_space" {
  type        = bool
  description = "Enable a Heroku private space for the app"
  default     = false
}

variable "single_app_space" {
  type        = string
  description = "Heroku private space for the app"
  default     = ""
}

variable "single_app_internal_routing" {
  type        = bool
  description = "Enable internal routing for the app in the Heroku private space"
  default     = false
}

variable "single_app_acm" {
  type        = bool
  description = "Enable automatic certificate management (ACM) for the app"
  default     = false
}

variable "single_app_organization" {
  type = map(object({
    locked   = bool
    personal = bool
  }))
  description = "Map of Heroku app organizations for the app"
  default     = {}
}

variable "single_app_config_vars" {
  type        = map(string)
  description = "Map of Heroku app config vars for the app"
  default     = {}
}

variable "single_app_sensitive_config_vars" {
  type        = map(string)
  description = "Map of Heroku app sensitive config vars for the app"
  default     = {}
}

variable "existing_addon" {
  type    = bool
  default = false
}

variable "existing_app" {
  type    = bool
  default = false
}


###

variable "single_addon_name" {
  type    = string
  default = ""
}

variable "single_addon_plan" {
  type    = string
  default = ""
}

variable "single_addon_config" {
  type    = map(string)
  default = {}
}

variable "addon_attachment_name" {
  type    = string
  default = ""
}

variable "namespace" {
  type    = string
  default = ""
}

variable "enable_common_config" {
  type    = bool
  default = false
}

variable "config_vars" {
  type    = map(string)
  default = {}
}

variable "config_sensitive_vars" {
  type    = map(string)
  default = {}
}
