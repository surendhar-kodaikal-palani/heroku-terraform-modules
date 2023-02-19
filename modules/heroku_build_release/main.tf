######################################## BUILD, PACKAGE, RELEASE ##############
data "heroku_team" "team" {
  name = "DevOps"
}

data "heroku_team_members" "team_members" {
  team_id = data.heroku_team.team.id
  roles = ["admin", "member", "viewer", "collaborator", "owner"]
}

resource "heroku_app" "single_app" {
  count            = length(var.single_app_name) > 0 ? 1 : 0

  name             = var.single_app_name
  region           = var.single_app_region
  stack            = var.single_app_stack # Which stack to be used heroku-20, container(if app is containerized)
  buildpacks       = var.single_app_buildpacks
  space            = var.single_app_enable_private_space ? var.single_app_space : null
  internal_routing = var.single_app_enable_private_space ? var.single_app_internal_routing : false # If it is is set as false, by default application will be pubic facing
  acm              = var.single_app_acm #SSL Cert For custom Domain
  
  dynamic "organization" {
    for_each = var.single_app_organization

    content {
      name     = single_app_organization.key
      locked   = single_app_organization.value.locked
      personal = single_app_organization.value.personal
    }
  }

  dynamic "config_vars" {
    for_each = var.single_app_config_vars

    content {
      name  = single_app_config_vars.key
      value = single_app_config_vars.value
    }
  }

  dynamic "sensitive_config_vars" {
    for_each = var.single_app_config_vars

    content {
      name  = single_app_sensitive_config_vars.key
      value = single_app_sensitive_config_vars.value
    }
  }
  
}

resource "heroku_config" "common" {
    count          = length(var.enable_common_config) > 0 ? 1 : 0

    vars           = var.config_vars
    sensitive_vars = var.config_sensitive_vars
}

resource "heroku_app_config_association" "common" {
  count          = length(var.enable_common_config) > 0 ? 1 : 0

  app_id         = length(var.single_app_name) > 0 ? heroku_app.single_app.id : heroku_app.existing.id
  vars           = heroku_config.common.vars
  sensitive_vars = heroku_config.common.sensitive_vars
}

resource "heroku_build" "existing_app" {
  app_id     = heroku_app.single_app.id
  buildpacks = var.buildpacks

  source {
    checksum = var.checksum
    path = var.path
    url     = var.repo_url
    version = var.version
  }
}

#This resource supports uploading a pre-generated archive file of executable code
resource "heroku_slug" "my_app" {
  app_id                            = heroku_app.single_app.id
  buildpack_provided_description    = var.buildpack_provided_description
  checksum                          = var.checksum
  commit                            = var.commit
  commit_description                = var.commit_description
  file_path                         = var.file_path
  file_url                          = var.file_url
  process_types                     = var.process_types
  stack                             = var.slug_stack
}

resource "heroku_pipeline" "pipeline" {
  name        = var.pipeline_name

  owner {
    id = data.heroku_team.example_team.id
    type = var.owner_type #team or user
  }
}

resource "heroku_pipeline_coupling" "review" {
  count = var.pipeline_stage == "review" ? 1: 0

  app_id        = heroku_app.single_app.id
  pipeline_id   = heroku_pipeline.pipeline.id
  stage         = var.pipeline_stage
}

resource "heroku_pipeline_coupling" "development" {
  count = var.pipeline_stage == "development" ? 1: 0

  app_id        = heroku_app.single_app.id
  pipeline_id   = heroku_pipeline.pipeline.id
  stage         = var.pipeline_stage
}

resource "heroku_pipeline_coupling" "staging" {
  count = var.pipeline_stage == "staging" ? 1: 0

  app_id        = heroku_app.single_app.id
  pipeline_id   = heroku_pipeline.pipeline.id
  stage         = var.pipeline_stage
}

resource "heroku_pipeline_coupling" "production" {
  count = var.pipeline_stage == "production" ? 1: 0

  app_id        = heroku_app.single_app.id
  pipeline_id   = heroku_pipeline.pipeline.id
  stage         = var.pipeline_stage
}

resource "heroku_app_release" "release" {
    app_id = heroku_app.single_app.id
    slug_id = heroku_slug.my_app.id
    description = var.app_release_description
}

resource "heroku_formation" "formation" {
    app_id = heroku_app.single_app.id
    type = var.fomation_type
    quantity = var.fomation_quantity
    size = var.formation_size

    # Tells Terraform that this formation must be created/updated only after the app release has been created
    depends_on = ["heroku_app_release.release"]
}