provider "google" {
  credentials = "${file("${var.google_client_secret}")}"
  project     = "${var.google_project}"
  region      = "${var.google_region}"
  version     = "~> 1.14"
}

resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}"
  storage_class = "${var.bucket_storage_class}"
}

module "slack_interactive_components" {
  source             = "amancevice/slack-interactive-components/google"
  bucket_name        = "${google_storage_bucket.bucket.name}"
  callback_ids       = ["${var.slack_interactive_components_callback_ids}"]
  function_name      = "${var.slack_interactive_components_function_name}"
  memory             = "${var.slack_interactive_components_memory}"
  timeout            = "${var.slack_interactive_components_timeout}"
  verification_token = "${var.slack_interactive_components_verification_token}"
}
