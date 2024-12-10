resource "google_cloud_run_v2_service" "default" {
  deletion_protection = false
  name                = var.service_name
  location            = var.region

  ingress = "INGRESS_TRAFFIC_ALL"

  labels = {
    env = var.environment
  }

  template {
    annotations = {
      "serving.knative.dev/creator"      = var.gcr_creator
      "serving.knative.dev/lastModifier" = var.gcr_modifier
    }

    scaling {
      min_instance_count = var.min_scale
      max_instance_count = var.max_scale
    }

    containers {
      image = var.container_image

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.value.name
          value = env.value.value
        }
      }

      ports {
        container_port = var.container_port
      }

      startup_probe {
        initial_delay_seconds = var.initial_delay
        failure_threshold     = 2
        period_seconds        = 10
        timeout_seconds       = 1
        http_get {
          path = var.container_ready_path
          port = var.container_port
        }
      }
      resources {
        limits = {
          cpu    = var.cpu_limit
          memory = var.mem_limit
        }
        cpu_idle = true
      }
    }
  }
}

data "google_iam_policy" "no_auth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "no_auth" {
  project  = var.project
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name

  policy_data = data.google_iam_policy.no_auth.policy_data
}

module "dns_record" {
  source      = "git::git@github.com:christian-m/gcp_cloud_dns_resource_record.git?ref=v1.1"
  environment = var.environment
  zone_name   = var.domain_zone_name
  record = {
    name = "${var.domain_name}.",
    type = "CNAME",
    ttl  = "600",
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
    route_name = google_cloud_run_v2_service.default.name
  }

  depends_on = [module.dns_record]
}