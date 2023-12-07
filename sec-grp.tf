module "aws_module_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "tf-jenkins-sg"
  description = "Security group with HTTP, HTTPS, SSH & Jenkins reverse proxy ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.my-test-vpc.vpc_id

  ingress_rules       = ["ssh-tcp", "https-443-tcp", "http-8080-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = {
    Name = "tf-jenkins-sg"
  }
}
output "security_group_id" {
  value = module.aws_module_sg.security_group_id
}
