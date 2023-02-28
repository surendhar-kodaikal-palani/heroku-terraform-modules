# The Module will cover scenarios such as:
# 1. Create Multiple APPS and each app will have it's own addons configured or skipped based on the inputs provided
# 2. Create Single APP and that app will be configured with new addon
# 3. Create Single APP and attach shared add-on which already exist 
# 4. Attach new add-on to already existing APP or attach shared addon to already existing APP
# 5. Attach new configs to the already existing APP

######################################## HEROKU CREATE MULTIPLE APPS ####################################################################### 

resource "heroku_app" "multiple_apps" {
  for_each = { for k, v in var.app_and_addons_config : k => v if var.create_multiple_apps }

  name             = each.key
  region           = each.value.region
  stack            = each.value.stack # Which stack to be used heroku-20, container(if app is containerized)
  buildpacks       = concat(each.value.buildpacks, ["heroku/python"])
  space            = var.enable_private_space ? each.value.space : null
  internal_routing = var.enable_private_space ? each.value.internal_routing : false # If it is is set as false, by default application will be pubic facing
  acm              = each.value.acm  #SSL Cert For custom Domain

  dynamic "organization" {
    for_each = each.value.organization

    content {
      name     = organization.key
      locked   = organization.value.locked
      personal = organization.value.personal
    }
  }

  dynamic "config_vars" {
    for_each = each.value.config_vars

    content {
      name  = config_vars.key
      value = config_vars.value
    }
  }

  dynamic "sensitive_config_vars" {
    for_each = each.value.config_vars

    content {
      name  = sensitive_config_vars.key
      value = sensitive_config_vars.value
    }
  }

}

######################################## ATTACH ADD-ONS FOR MULTIPLE APPS BASED ON THE REQUIREMENTS ####################################################################### 

# Below we are doing nested map to fetch the mapped variables from the key-value pair of addons which will be used for the current resource block.
# The block will get activate only when the <create_addon> condition is true because what if addon exist and you don't want to create one.
# This scenario can come when you want to attach already existing addon to the app such as shared DB. 

# for_each = { for k, v in var.heroku_addons : k => v if var.create_addon } # (KEY -> app_name, addon_name) , (VALUE -> app_config, addon_config)

resource "heroku_addon" "multiple_addons" {

  for_each = {
    for app_name, app_config in var.app_and_addons_config : app_name => {
      for addon_name, addon_config in app_config.addons : "${app_name}-${addon_name}" => {
        addon_name = addon_name
        app_id     = heroku_app.multiple_apps[app_name].id
        plan       = addon_config.plan
        config     = addon_config.config
      }
    } if var.create_addon
  }

  name   = each.value.addon_name
  app_id = each.value.app_id
  plan   = each.value.plan
  config = each.value.config

  depends_on = [heroku_app.multiple_apps]
}

############################ LOOKUP FOR EXISTING HEROKU ADD-ON, and APP | ATTACH A SINGLE ADD-ON to the APP ##########################################################

# Fetch existing heroku add-on and app by turning on the flag and passing the name. 
# Create a single App and Add-on in Heroku Platform by using below block with a flag to turn on.
# Integrate Addon with the application based on existing configuration or using the new configuration

data "heroku_addon" "existing" {
  count = length(var.existing_addon) > 0 ? 1 : 0

  name = var.existing_addon
}

data "heroku_app" "existing" {
  count = length(var.existing_app) > 0 ? 1 : 0

  name = var.existing_app
}

resource "heroku_app" "single_app" {
  count = length(var.single_app_name) > 0 ? 1 : 0

  name             = var.single_app_name
  region           = var.single_app_region
  stack            = var.single_app_stack # Which stack to be used heroku-20, container(if app is containerized)
  buildpacks       = var.single_app_buildpacks
  space            = var.single_app_enable_private_space ? var.single_app_space : null
  internal_routing = var.single_app_enable_private_space ? var.single_app_internal_routing : false # If it is is set as false, by default application will be pubic facing
  acm              = var.single_app_acm                                                            #SSL Cert For custom Domain

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

resource "heroku_addon" "single_addon" {
  count = length(var.single_addon_name) > 0 ? 1 : 0

  name   = var.single_addon_name
  app_id = heroku_app.single_app.id
  plan   = var.single_addon_plan
  config = var.single_addon_config

  depends_on = [heroku_app.single_app]
}

resource "heroku_addon_attachment" "this" {
  count = length(var.existing_addon) > 0 || length(var.single_addon_name) > 0 ? 1 : 0

  name      = var.addon_attachment_name
  app_id    = length(var.single_app_name) > 0 ? heroku_app.single_app.id : heroku_app.existing.id
  addon_id  = length(var.single_addon_name) > 0 ? heroku_addon.single_addon.id : heroku_addon.existing.id
  namespace = var.namespace
}

# Add configs and sensistive configs to an app which is already deployed OR it can be a global env configs which goes with all the apps

resource "heroku_config" "common" {
  count = length(var.enable_common_config) > 0 ? 1 : 0

  vars           = var.config_vars
  sensitive_vars = var.config_sensitive_vars
}

resource "heroku_app_config_association" "common" {
  count = length(var.enable_common_config) > 0 ? 1 : 0

  app_id         = length(var.single_app_name) > 0 ? heroku_app.single_app.id : heroku_app.existing.id
  vars           = heroku_config.common.vars
  sensitive_vars = heroku_config.common.sensitive_vars
}


