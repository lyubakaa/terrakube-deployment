resource "aws_route53_zone" "private" {
  name = "{your_name}"
  vpc {
    vpc_id = var.vpc_id
  }
  comment = "kubing.test (development)"
  tags = {
    env = "dev"
  }
}

