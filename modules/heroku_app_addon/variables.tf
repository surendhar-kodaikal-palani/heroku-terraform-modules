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
    addons                = map(object({
      plan = string
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
            ENV = "dev"
            TERRAFORM = true
          }
        },
        "addon2" = {
          plan = "heroku-redis:standard-0"
          config = {
            ENV = "dev"
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
      buildpacks   = [    
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
            ENV = "dev"
            TERRAFORM = true
          }
        },
        "addon2" = {
          plan = "heroku-redis:mini"
          config = {
            ENV = "dev"
            TERRAFORM = true
          }
        }        
      }

    }
  }
}