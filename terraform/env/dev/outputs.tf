output "public_ip" {
  value = module.ec2.public_ip
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "ansible_command" {
  description = "Run this after apply to configure the server with Ansible"
  value       = "bash terraform/scripts/wait-and-ansible.sh ${module.ec2.public_ip} ${var.ssh_private_key_path}"
}