
output "id" {
  value       = module.label.enabled ? module.label.id : ""
  description = "Disambiguated ID restricted to `id_length_limit` characters in total"
}

output "id_full" {
  value       = module.label.enabled ? module.label.id_full : ""
  description = "Disambiguated ID not restricted in length"
}

output "enabled" {
  value       = module.label.enabled
  description = "True if module is enabled, false otherwise"
}

output "namespace" {
  value       = module.label.enabled ? module.label.namespace : ""
  description = "Normalized namespace"
}

output "environment" {
  value       = module.label.enabled ? module.label.environment : ""
  description = "Normalized environment"
}

output "name" {
  value       = module.label.enabled ? module.label.name : ""
  description = "Normalized name"
}

