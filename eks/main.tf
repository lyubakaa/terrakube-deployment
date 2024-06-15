module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.13.1"

  cluster_name                   = var.name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets

  cluster_addons = {
    aws-ebs-csi-driver = { most_recent = true }
    coredns = { most_recent = true }
    vpc-cni = { most_recent = true }
    kube-proxy = { most_recent = true }
  }

  eks_managed_node_group_defaults = {
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      Route53ListHostedZonesPolicy = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
    }
  }

  eks_managed_node_groups = {
    initial = {
      instance_types = var.instance_types
      min_size       = 2
      max_size       = 4
      desired_size   = 3
      subnet_ids     = var.private_subnets
    }
  }

  enable_cluster_creator_admin_permissions = true

  cluster_security_group_additional_rules = {
    allow_wireguard_traffic = {
      type        = "ingress"
      description = "Allow all traffic from WireGuard instance"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.private_subnet_cidr_blocks
    }
    allow_vpc_traffic = {
      type        = "ingress"
      description = "Allow all traffic from within the VPC"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.vpc_cidr]
    }
  }

  node_security_group_additional_rules = {
    allow_wireguard_traffic = {
      type        = "ingress"
      description = "Allow all traffic from WireGuard instance"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.private_subnet_cidr_blocks
    }
    allow_vpc_traffic = {
      type        = "ingress"
      description = "Allow all traffic from within the VPC"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.vpc_cidr]
    }
  }

  tags = var.tags
}

resource "null_resource" "kubeconfig" {
  depends_on = [module.eks]
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.name}"
    environment = {
      AWS_CLUSTER_NAME = var.name
    }
  }
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.3"

  cluster_name      = var.name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_karpenter              = true
  enable_kube_prometheus_stack  = true
  enable_metrics_server         = true
  enable_external_dns           = true
  enable_cert_manager           = true
  enable_aws_cloudwatch_metrics = true

  tags = var.tags
}




