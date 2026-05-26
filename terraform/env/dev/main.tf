module "sg" {
  source = "../../modules/security-group"

  name        = "dev-sg"
  description = "Dev security group"
  vpc_id      = "vpc-xxxx"

  tags = {
    Env = "dev"
  }
}

module "sg_rules" {
  source = "../../modules/security-group-rules"

  security_group_id = module.sg.id

  ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    https = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    argocd = {
      from_port   = 32080
      to_port     = 32080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress_rules = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


module "ec2" {
  source = "../../modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  security_group_ids = [module.sg.id]

  name = "devops-server"
}

module "ebs" {
  source = "../../modules/ebs"

  availability_zone = var.availability_zone
  size              = var.ebs_size
  instance_id       = module.ec2.instance_id

  tags = {
    Env = "dev"
  }
}

