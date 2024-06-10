#### this is root/eks/variables.tf

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "value"
  type        = string
}

variable "public_subnets" {
  description = "value"
  type = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
}


variable "cluster_security_group_additional_rules" {
  description = "Additional security group rules for the cluster security group"
  type        = map(any)
  default     = {}
}

variable "node_security_group_additional_rules" {
  description = "Additional security group rules for the node security group"
  type        = map(any)
  default     = {}
}

variable "instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}


variable "region" {
  type = string
}




# variable "cluster_admin_role_arn" {
#   description = "ARN of the IAM role with admin access to the EKS cluster"
#   type        = string
# }
