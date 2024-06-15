data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    token                  = data.aws_eks_cluster_auth.cluster.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.ingressClass"
    value = "nginx"
  }

  set {
    name  = "controller.allowSnippetAnnotations"
    value = "true"
  }
  
  depends_on = [var.cluster_name]
}

resource "helm_release" "terrakube" {
  name             = "terrakube"
  repository       = "https://AzBuilder.github.io/terrakube-helm-chart"
  chart            = "terrakube"
  namespace        = "terrakube"
  create_namespace = true
  values           = [file("${path.module}/values.yml")]
  
  depends_on = [helm_release.nginx_ingress]
}


