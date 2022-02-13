resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  metadata {
    namespace   = var.project
    annotations = {
      "autoscaling.knative.dev/maxScale" = var.max_scale
      "serving.knative.dev/creator"      = var.gcr_creator
      "serving.knative.dev/lastModifier" = var.gcr_modifier
      "run.googleapis.com/ingress"       = "all"
    }
  }

  template {
    spec {
      containers {
        image = var.container_image

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value.name
            value = env.value.value
          }
        }

        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.mem_limit
          }
        }
      }
    }
  }

  traffic {
    latest_revision = true
    percent         = 100
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

module "dns_record" {
  source      = "git::git@bitbucket.org:christian_m/gcp_cloud_dns_resource_record.git?ref=v1.0"
  environment = var.environment
  zone_name   = var.domain_zone_name
  record      = {
    name   = "${var.domain_name}.",
    type   = "CNAME",
    ttl    = "600",
    values = ["ghs.googlehosted.com."],
  }
}

resource "google_cloud_run_domain_mapping" "default" {
  location = var.region
  name     = var.domain_name

  metadata {
    namespace = var.project
  }

  spec {
    route_name = google_cloud_run_service.default.name
  }

  depends_on = [module.dns_record]
}