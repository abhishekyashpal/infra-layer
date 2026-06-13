variable "vpc_id" {}

variable "ami_id" {}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key used for Ansible provisioning"
  type        = string
  default     = "~/.ssh/dev-key.pem"
}

variable "run_ansible_provisioner" {
  description = "Run Ansible automatically after EC2 is created (requires bash and ansible on the machine running Terraform)"
  type        = bool
  default     = false
}

variable "instance_type" {
  default = "t3.large"
}

variable "key_name" {}

variable "subnet_id" {}

variable "availability_zone" {}
variable "ebs_size" {
  type    = number
  default = 30
}