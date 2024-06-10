# this is routes/main.tf
resource "aws_route53_zone" "private" {
  name = "kubing.nl"
  vpc {
    vpc_id = var.vpc_id
  }
  comment = "kubing.test (development)"
  tags = {
    env = "dev"
  }
}

