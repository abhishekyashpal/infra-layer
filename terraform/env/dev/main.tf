module "sg" {
  source = "../../modules/security-group"

  name        = "dev-sg"
  description = "Dev security group"
  vpc_id      = var.vpc_id

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

  associate_public_ip_address = false
  security_group_ids          = [module.sg.id]

  name = "devops-server"
}

module "eip" {
  source = "../../modules/eip"

  instance_id = module.ec2.instance_id
  tags = {
    Name = "devops-server-eip"
    Env  = "dev"
  }
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

resource "null_resource" "ansible_provisioner" {
  count = var.run_ansible_provisioner ? 1 : 0

  depends_on = [module.ec2, module.eip, module.ebs]

  triggers = {
    instance_id = module.ec2.instance_id
    public_ip   = module.eip.public_ip
  }

  provisioner "local-exec" {
    command     = "bash \"${path.module}/../../scripts/wait-and-ansible.sh\" \"${module.eip.public_ip}\" \"${var.ssh_private_key_path}\""
    interpreter = ["bash", "-c"]
  }
}

