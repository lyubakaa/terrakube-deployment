# wireguard/variables.tf

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "private_key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Map of private subnet IDs"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "vpn_instance_type" {
  description = "Instance type for the VPN server"
  type        = string
}

variable "vpn_ami_type" {
  description = "AMI type for the VPN server"
  type        = string
}

variable "wireguard_pass" {
  description = "Password for WireGuard"
  type        = string
}
