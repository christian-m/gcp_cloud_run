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

variable "service_revision" {
  description = "revision of the container image"
  type        = string
  default     = "v1"
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

variable "container_ready_port" {
  description = "ready port of the container image"
  type        = number
  default     = 8080
}

variable "env_vars" {
  description = "environment variables to pass to the container"
  type = map(string)
  default = {}
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

variable "compute_network" {
  description = "name of the compute network"
  type = object({
    network_name    = string,
    subnetwork_name = string,
  })
  nullable = true
  default  = null
}

variable "deletion_protection" {
  description = "should the instance can be deleted"
  type        = bool
  default     = false
}

locals {
  service_name     = "${var.environment}-${var.service_name}"
  service_revision = "${local.service_name}-${var.service_revision}"
}