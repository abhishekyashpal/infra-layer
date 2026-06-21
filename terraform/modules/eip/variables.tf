variable "instance_id" {
  description = "EC2 instance ID to associate with the Elastic IP"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Elastic IP"
  type        = map(string)
  default     = {}
}
