module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name             = var.name
  cidr             = var.cidr
  azs              = var.azs
  public_subnets   = [for k, v in var.azs : cidrsubnet(var.cidr, 8, k)]
  private_subnets  = [for k, v in var.azs : cidrsubnet(var.cidr, 8, k + 10)]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  tags = var.tags

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}


