# this is root/variables.tf

variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "VPC IP CIDR block"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "private_key_name" {
  description = "Name of the private key for SSH access"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key for SSH access"
  type        = string
}

variable "vpn_instance_type" {
  description = "Instance type for VPN instance"
  type        = string
}

variable "vpn_ami_type" {
  description = "AMI type for VPN instance"
  type        = string
}

variable "wireguard_pass" {
  description = "Password for WireGuard"
  type        = string
}

variable "instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
}

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}