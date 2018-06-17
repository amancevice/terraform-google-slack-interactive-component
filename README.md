# Slack Interactive Messages

Send interactive Slack events to Google Cloud Pub/Sub using Cloud Functions.

## Quickstart

Download the credentials file from Google Cloud for your service account and rename to `client_secret.json`.

Then, create a `main.tf` file with the following contents (filling in the module version):

```terraform
# terraform.tf

provider "google" {
  credentials = "${file("client_secret.json")}"
  project     = "<your-project-id>"
  region      = "us-central1"
}

module "slack_interactive_components" {
  source             = "amancevice/slack-interactive-components/google"
  bucket_name        = "${var.bucket_name}"
  verification_token = "${var.verification_token}"
  callback_ids       = [
    # Your custom callback IDs here
  ]
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
