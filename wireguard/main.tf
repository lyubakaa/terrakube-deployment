resource "aws_instance" "bastion" {
  ami                    = var.vpn_ami_type
  instance_type          = var.vpn_instance_type
  subnet_id              = element(var.public_subnets, 0)
  vpc_security_group_ids = [aws_security_group.wireguard.id]
  key_name               = var.private_key_name
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}

resource "null_resource" "provision_bastion" {
  depends_on = [aws_instance.bastion]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "/bin/bash -c \"$(curl -fsSL https://git.io/JDGfm)\"",
      "mkdir -p /home/ubuntu/wireguard",
      "echo '${data.template_file.wireguard-docker-yml.rendered}' > /home/ubuntu/wireguard/docker-compose.yml",
      "cd /home/ubuntu/wireguard && sudo docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = aws_instance.bastion.public_ip
    }
  }
}

resource "aws_security_group" "wireguard" {
  vpc_id      = var.vpc_id
  name        = "wireguard"
  description = "Allow SSH and WireGuard"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "wireguard-docker-yml" {
  template = file("${path.module}/wireguard-docker-yml.tftpl")
  vars = {
    wireguard_public_ip = aws_instance.bastion.public_ip
    wireguard_pass      = var.wireguard_pass
  }
}

output "wireguard_public_ip" {
  value = aws_instance.bastion.public_ip
}

