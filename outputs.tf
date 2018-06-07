output "version" {
  description = "Slack event publisher module version"
  value       = "${local.version}"
}

output "interactive_component_url" {
  description = "Endpoint for interactive components to configure in Slack."
  value       = "${google_cloudfunctions_function.function.https_trigger_url}"
}
