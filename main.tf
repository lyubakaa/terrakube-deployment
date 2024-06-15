## this is root/main.tf


## Data source to get the list of available AWS Availability Zones in the current region
data "aws_availability_zones" "available" {}

## Local values for reuse throughout the configuration
locals {
  name            = var.name  
  region          = var.region  
  cluster_version = var.cluster_version  
  instance_types  = ["t2.large"]  
  vpc_cidr        = var.vpc_cidr  
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)  
  tags = {
    Blueprint  = local.name  
    GitHubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"  
  }
}

## VPC Module to create the network infrastructure 
module "vpc" {
  source = "./vpc"
  name   = local.name
  cidr   = local.vpc_cidr
  azs    = local.azs
  tags   = local.tags
}

## Route53 module for DNS management
module "route53" {
  source = "./zones"
  vpc_id = module.vpc.vpc_id
  region = local.region
}

## EKS module to create the Kubernetes cluster
module "eks" {
  source              = "./eks"
  name                = local.name
  cluster_version     = local.cluster_version
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = local.vpc_cidr
  public_subnets      = module.vpc.public_subnets
  private_subnets     = module.vpc.private_subnets
  private_subnet_cidr_blocks = module.vpc.private_subnet_cidr_blocks
  instance_types      = local.instance_types
  tags                = local.tags
  region              = local.region
}

## Helm module to manage Helm charts deployment in the EKS cluster
module "helm" {
  source              = "./helm"
  cluster_name        = module.eks.cluster_name
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_ca_cert     = module.eks.cluster_certificate_authority_data
  region              = local.region
}

## WireGuard module for setting up a VPN
module "wireguard" {
  source              = "./wireguard"
  vpc_id              = module.vpc.vpc_id
  name                = local.name
  vpn_instance_type   = var.vpn_instance_type
  vpn_ami_type        = var.vpn_ami_type 
  public_subnets      = module.vpc.public_subnets
  private_subnet_cidr_blocks = module.vpc.private_subnet_cidr_blocks
  private_key_name    = var.private_key_name 
  private_key_path    = var.private_key_path
  private_subnets     = module.vpc.private_subnets 
  wireguard_pass      = var.wireguard_pass
}



