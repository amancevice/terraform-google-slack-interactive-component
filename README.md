# Slack Interactive Messages

Send interactive Slack events to Google Cloud Pub/Sub using Cloud Functions.

## Quickstart

Download the credentials file from Google Cloud for your service account and rename to `client_secret.json`.

Create a `terraform.tfvars` file with your access keys & custom configuration:


```terraform
# terraform.tfvars

# Cloud Storage bucket for storing function source
bucket_name = "<cloud-storage-bucket>"

# Cloud Project ID
project = "<cloud-project-123456>"

# Slack verification token
verification_token = "<verification-token>"
```

Then, create a `terraform.tf` file with the following contents (filling in the module version):

```terraform
# terraform.tf

provider "google" {
  credentials = "${file("${var.client_secret}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.13"
}

module "slack_interactive_components" {
  source             = "amancevice/slack-interactive-components/google"
  version            = "<module-version>"
  bucket_name        = "${var.bucket_name}"
  client_secret      = "${var.client_secret}"
  project            = "${var.project}"
  verification_token = "${var.verification_token}"
  callback_ids       = [
    "my_callback1",
    "my_callback2"
  ]
}

variable "bucket_name" {
  description = "Cloud Storage bucket for storing Cloud Function code archives."
}

variable "client_secret" {
  description = "Google Cloud client secret JSON filepath."
  default     = "client_secret.json"
}

variable "project" {
  description = "The ID of the project to apply any resources to."
}

variable "region" {
  description = "The region to operate under, if not specified by a given resource."
  default     = "us-central1"
}

variable "verification_token" {
  description = "Slack verification token."
}

output "pubsub_topics" {
  description = "Pub/Sub topics created."
  value       = "${module.slack_interactive_component.pubsub_topics}"
}

output "request_url" {
  description = "Endpoint for event subscriptions to configure in Slack."
  value       = "${module.slack_interactive_component.request_url}"
}
```

In a terminal window, initialize the state:

```bash
terraform init
```

Then review & apply the changes

```bash
terraform apply
```
