variable "vpc_id" {}

variable "ami_id" {}

variable "instance_type" {
  default = "t3.large"
}

variable "key_name" {}

variable "subnet_id" {}

variable "availability_zone" {}
variable "ebs_size" {
  type    = number
  default = 20
}