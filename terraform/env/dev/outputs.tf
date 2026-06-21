output "public_ip" {
  value = module.eip.public_ip
}

output "elastic_ip_allocation_id" {
  value = module.eip.allocation_id
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "ansible_command" {
  description = "Run this after apply to configure the server with Ansible"
  value       = "bash terraform/scripts/wait-and-ansible.sh ${module.eip.public_ip} ${var.ssh_private_key_path}"
}

output "argocd_sslip_host" {
  value = "argocd.${module.eip.public_ip}.sslip.io"
}

output "grafana_sslip_host" {
  value = "grafana.${module.eip.public_ip}.sslip.io"
}

output "api_sslip_host" {
  value = "api.${module.eip.public_ip}.sslip.io"
}
