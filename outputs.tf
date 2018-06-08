output "version" {
  description = "Slack interactive components module version"
  value       = "${local.version}"
}

output "request_url" {
  description = "Slack interactive components Request URL."
  value       = "${google_cloudfunctions_function.function.https_trigger_url}"
}

output "pubsub_topics" {
  description = "Pub/Sub topics created."
  value       = "${google_pubsub_topic.topic.*.name}"
}
