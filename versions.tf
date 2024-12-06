terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "> 5.34.0"
    }
  }
  required_version = ">= 1.10.0"
}
