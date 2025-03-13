terraform {
  required_providers {
    google = {
      source  = "google"
      version = "6.24.0"
    }
  }
}

provider "google" {
  project = var.project_name
  region  = var.region
}

resource "google_storage_bucket" "bucket-kuba" {
  name     = "${var.project_name}-function-kuba"
  location = var.region
}

resource "google_storage_bucket_object" "archive" {
  name   = "function-source-zip"
  bucket = google_storage_bucket.bucket-kuba.name
  source = "./function-source.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "function-publish-kuba"
  description = "Funkcja do publikacji na serwis"
  runtime     = "nodejs18"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket-kuba.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "publishMessage"
  ingress_settings      = "ALLOW_ALL"
}
output "OutputURL" {
  value       = google_cloudfunctions_function.function.https_trigger_url
}
resource "google_pubsub_topic" "topic" {
  name = "message-topic-kuba"
}
resource "google_project_iam_binding" "function_pubsub_publisher" {
  project = var.project_name
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${var.project_name}@appspot.gserviceaccount.com"
  ]
}

resource "google_pubsub_subscription" "subscription" {
  name  = "subscription-kuba"
  topic = google_pubsub_topic.topic.name

  ack_deadline_seconds = 20

}
resource "google_storage_bucket_object" "pr2" {
  name   = "function-pr2-zip"
  bucket = google_storage_bucket.bucket-kuba.name
  source = "./function-pr2.zip"
} 
resource "google_cloudfunctions_function" "function-pr2" {
  name        = "function-pr2-kuba"
  description = "Funkcja do odczytu"
  runtime     = "nodejs18"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket-kuba.name
  source_archive_object = google_storage_bucket_object.pr2.name
  trigger_http          = true
  entry_point           = "retrieveMessage"
  ingress_settings      = "ALLOW_ALL"
}