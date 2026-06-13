variable "availability_zone" {}
variable "size" {
  type = number
}
variable "type" {
  default = "gp3"
}
variable "device_name" {
  default = "/dev/sdh"
}
variable "instance_id" {}
variable "tags" {
  type = map(string)
  default = {}
}