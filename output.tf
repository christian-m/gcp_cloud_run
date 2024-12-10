output "uri" {
  value = google_cloud_run_v2_service.default.uri
}

output "creator" {
  value = google_cloud_run_v2_service.default.creator
}

output "created_at" {
  value = google_cloud_run_v2_service.default.create_time
}

output "last_modifier" {
  value = google_cloud_run_v2_service.default.last_modifier
}

output "last_modified_at" {
  value = google_cloud_run_v2_service.default.update_time
}
