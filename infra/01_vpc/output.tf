
# Label

output "id" {
  value       = module.label.enabled ? module.label.id : ""
  description = "Disambiguated ID restricted to `id_length_limit` characters in total"
}

output "id_full" {
  value       = module.label.enabled ? module.label.id_full : ""
  description = "Disambiguated ID not restricted in length"
}
