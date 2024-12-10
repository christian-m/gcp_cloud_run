variable "environment" {
  description = "environment where this resource is used"
  type        = string
}

variable "region" {
  description = "region of the Cloud Run service"
  type        = string
  default     = "europe-west4"
}

variable "project" {
  description = "name of the Google Cloud project"
  type        = string
}

variable "service_name" {
  description = "name of the Cloud Run service"
  type        = string
}

variable "domain_name" {
  description = "domain name where the Cloud Run service is accessible"
  type        = string
}

variable "domain_zone_name" {
  description = "domain zone where the domain name should be registered"
  type        = string
}

variable "container_image" {
  description = "registry url of the container image"
  type        = string
}

variable "container_port" {
  description = "port connecting to the container image"
  type        = number
  default     = 8080
}

variable "container_ready_path" {
  description = "ready path of the container image"
  type        = string
  default     = "/ready"
}

variable "env_vars" {
  description = "environment variables to pass to the container"
  type = set(object({
    name  = string,
    value = string,
  }))
  default = []
}

variable "max_scale" {
  description = "max scale of instances"
  type        = number
  default     = 20
}

variable "min_scale" {
  description = "min scale of instances"
  type        = number
  default     = 0
}

variable "initial_delay" {
  description = "initial delay for ready check of startup probe"
  type        = number
  default     = 15
}

variable "cpu_limit" {
  description = "cpu limit of the container"
  type        = string
  default     = "1000m"
}

variable "mem_limit" {
  description = "memory limit of the container"
  type        = string
  default     = "256M"
}

variable "gcr_creator" {
  description = "creator of the Cloud Run service"
  type        = string
}

variable "gcr_modifier" {
  description = "modifier of the Cloud Run service"
  type        = string
}

