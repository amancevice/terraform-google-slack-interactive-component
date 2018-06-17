// Google Cloud
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "project" {
  description = "The ID of the project to apply any resources to."
  default     = ""
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
variable "description" {
  description = "Description of the function."
  default     = "Slack interactive components"
}

variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-interactive-components"
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the function."
  type        = "map"

  default {
    deployment-tool = "terraform"
  }
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 256
}

variable "timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 10
}
