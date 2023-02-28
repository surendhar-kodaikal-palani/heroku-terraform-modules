# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/heroku_app_addon"
}

inputs = {

  app_and_addons_config = {
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