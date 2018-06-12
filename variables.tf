// Google Cloud
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "client_secret" {
  description = "Google Cloud client secret JSON."
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

// Slack
variable "verification_token" {
  description = "Slack verification token."
}

// Pub/Sub Topics
variable "callback_ids" {
  description = "List of Pub/Sub topic names to create."
  type        = "list"
  default     = []
}

// Cloud Function
variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-interactive-components"
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 512
}

variable "timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 10
}
