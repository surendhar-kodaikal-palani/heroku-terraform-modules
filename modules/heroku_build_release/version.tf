terraform {
  required_version = ">= 0.13.0"

  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = ">= 5.0.0"
      api_key = var.heroku_api_key # API KEY for authentication 
    }
  }
}