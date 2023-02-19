output "app_id" {
  value = [for app in heroku_app.this : app.id]
}

output "app_names" {
  value = [for app in heroku_app.this : app.name]
}

output "app_stack" {
  value = [for app in heroku_app.this : app.stack]
}

output "app_space" {
  value = [for app in heroku_app.this : app.space]
}

output "app_internal_routing" {
  value = [for app in heroku_app.this : app.internal_routing]
}

output "app_region" {
  value = [for app in heroku_app.this : app.region]
}

output "git_url" {
  value = [for app in heroku_app.this : app.git_url]
}

output "web_url" {
  value = [for app in heroku_app.this : app.web_url]
}

output "app_heroku_hostname" {
  value = [for app in heroku_app.this : app.heroku_hostname]
}

output "app_all_config_vars" {
  value = {
    for app in heroku_app.this : app.name => app.all_config_vars
  }
}

output "app_uuid" {
  value = [for app in heroku_app.this : app.uuid]
}