output "server-public-ip" {
    value = module.ec2_instance.public_ip
}
output "server-public-dns" {
    value = module.ec2_instance.public_dns
}
output "security_group_id" {
  value = module.aws_module_sg.security_group_id
}