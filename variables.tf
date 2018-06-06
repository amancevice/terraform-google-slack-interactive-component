/**
 * Required Variables
 */
variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "client_secret" {
  description = "Google Cloud client secret JSON."
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

variable "verification_token" {
  description = "Slack verification token."
}

/**
 * Optional Variables
 */
variable "bucket_prefix" {
  description = "Prefix for Cloud Storage bucket."
  default     = ""
}

variable "pubsub_topic" {
  description = "Pub/Sub topic name."
  default     = "slack-interactions"
}

variable "function_name" {
  description = "Cloud Function for publishing events from Slack to Pub/Sub."
  default     = "slack-interactive-component"
}

variable "memory" {
  description = "Memory for Slack event listener."
  default     = 512
}

variable "region" {
  description = "The region to operate under, if not specified by a given resource."
  default     = "us-central1"
}

variable "response" {
  description = "Slack response object."
  type        = "map"

  default {
    text = "OK"
  }
}

variable "timeout" {
  description = "Timeout in seconds for Slack event listener."
  default     = 10
}
