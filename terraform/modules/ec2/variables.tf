variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "security_group_ids" {
  type = list(string)
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "volume_type" {
  type    = string
  default = "gp3"
}

variable "name" {}

variable "tags" {
  type    = map(string)
  default = {}
}