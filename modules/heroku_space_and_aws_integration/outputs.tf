output "id" {
  value       = heroku_space.private.id
  description = "The ID of the Heroku space"
}

output "name" {
  value       = heroku_space.private.name
  description = "The name of the Heroku space"
}

output "organization" {
  value       = heroku_space.private.organization
  description = "The space's Heroku Team."
}

output "region" {
  value       = heroku_space.private.region
  description = "The AWS region for the Heroku space"
}

output "cidr" {
  value       = heroku_space.private.cidr
  description = "The space's CIDR"
}

output "data_cidr" {
  value       = heroku_space.private.data_cidr
  description = "The space's Data CIDR"
}

output "outbound_ips" {
  value       = heroku_space.private.outbound_ips
  description = "The space's stable outbound NAT IPs."
}
