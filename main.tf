provider "archive" {
  version = "~> 1.0"
}

provider "template" {
  version = "~> 1.0"
}

locals {
  version = "0.1.1"
}

data "template_file" "config" {
  template = "${file("${path.module}/src/config.tpl")}"

  vars {
    pubsub_topic       = "${var.pubsub_topic}"
    project            = "${var.project}"
    verification_token = "${var.verification_token}"
  }
}

data "archive_file" "archive" {
  type        = "zip"
  output_path = "${path.module}/dist/${var.function_name}-${local.version}.zip"

  source {
    # TODO!!!
    content  = "${file("client_secret.json")}"
    filename = "client_secret.json"
  }

  source {
    content  = "${data.template_file.config.rendered}"
    filename = "config.json"
  }

  source {
    content  = "${file("${path.module}/src/index.js")}"
    filename = "index.js"
  }

  source {
    content  = "${file("${path.module}/package.json")}"
    filename = "package.json"
  }
}

resource "google_storage_bucket_object" "archive" {
  bucket = "${var.bucket_name}"
  name   = "${var.bucket_prefix}${var.function_name}-${local.version}.zip"
  source = "${data.archive_file.archive.output_path}"
}

resource "google_pubsub_topic" "topic" {
  name = "${var.pubsub_topic}"
}

resource "google_cloudfunctions_function" "function" {
  name                  = "${var.function_name}"
  description           = "Slack interactive components"
  available_memory_mb   = "${var.memory}"
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  trigger_http          = true
  timeout               = "${var.timeout}"
  entry_point           = "publishEvent"

  labels {
    deployment-tool = "terraform"
  }
}