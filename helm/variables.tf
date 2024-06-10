#### this is root helm/variables.tf
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_cert" {
  description = "Certificate Authority data for the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

