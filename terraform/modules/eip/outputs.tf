output "allocation_id" {
  value = aws_eip.this.id
}

output "association_id" {
  value = aws_eip_association.this.id
}

output "public_ip" {
  value = aws_eip.this.public_ip
}
