locals {
  ec2_ami               = data.aws_ami.ubuntu.id
  ec2_instance_type     = "t2.small"
  alb_security_group_id = data.terraform_remote_state.alb.outputs.alb_security_group_id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

module "instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.prefix}-nginx-sg"
  description = "Security group for nginx web servers"
  vpc_id      = local.vpc_id

  egress_rules = ["all-all"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = local.alb_security_group_id
    }
  ]
}
/*
resource "aws_instance" "nginx" {
  count                       = length(local.private_subnets)
  ami                         = local.ec2_ami
  instance_type               = local.ec2_instance_type
  vpc_security_group_ids      = [module.instance_sg.security_group_id]
  subnet_id                   = local.private_subnets[count.index]
  associate_public_ip_address = true

  user_data = <<EOT
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
  EOT

  tags = merge(
    {
      Name = "${local.prefix}-nginx-${count.index + 1}"
    },
    local.common_tags
  )
}


resource "aws_key_pair" "ec2" {
  key_name   = "alb"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdsWbfUvr2EMAtF+HqEW+aSYAlnPST6AsX59SY2PAcDzM2ZP0ByNNmy0xL2Gpij+j/hqJbfwHZ6CDLQyXUV354BSJ1b+5G1Z6ZAeYE8J7hl+8QOSiyjrCJZ3vVXLMT4QZe441MKhR3wnuiM+21QelnV3L0UP9eHhLTra0r5oJ/kP5EYYDv5KlpQa0h9DYHIvyu+blDQe7/wkBBrXUjdtEsHAVu++0tjeiS4UlRFPP+eKd7LabVclhMLR/d7DOmzkFZE9ZL31nNUzAlssMtzq5R/OkEQGb1pYv5LOip/rY4bExJBQgqMjdaFZvsBjtrhjgP5v/wzA32GDN7I3sAe8YykRvS+VEIHNksKyFFbVBMJ5oXVj1o7yMIZmGSLEgmOpPdo91J9Xj7Q71A8xqllIk9OmZfWLlvcaAGeV4RuvOzsx53v+EQln8rs8VCcih/lYiZGfLTQAU9ejdpyh/okj6rX/8qu8/2Oz0D/EqkN1XUTzRkve92+NcDP5AGHk8sfWE= swezinlinn@Swes-MBP.lan"
}

resource "aws_instance" "web" {
  count                       = length(local.private_subnets)
  ami                         = local.ec2_ami
  instance_type               = local.ec2_instance_type
  vpc_security_group_ids      = [module.instance_sg.security_group_id]
  subnet_id                   = local.public_subnets[count.index]
  associate_public_ip_address = true

  tags = merge(
    {
      Name = "${local.prefix}-web-app-${count.index + 1}"
    },
    local.common_tags
  )

  connection { 
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/albdemo") 
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo docker run -d -p 80:80 yeasy/simple-web"
    ]
  }    

}*/
