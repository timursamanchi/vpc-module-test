provider "aws" {
  region = "eu-west-1"
}
data "aws_availability_zones" "azs" {}

module "my-test-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.2.0"
  name            = "tf-jenkins-vpc"
  cidr            = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-jenkins-vpc"
  }

  public_subnet_tags = {
    Name = "tf-jenkins-PUB"
  }

  private_subnet_tags = {
    Name = "tf-jenkins-PRIV"
  }
}
module "aws_module_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "tf-jenkins-sg"
  description = "Security group with HTTP, HTTPS, SSH & Jenkins reverse proxy ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.my-test-vpc.vpc_id

  ingress_rules       = ["ssh-tcp","https-443-tcp","http-8080-tcp","http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = {
    Name = "tf-jenkins-sg"
  }
}
output "security_group_id" {
  value = module.aws_module_sg.security_group_id
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "t6f-jenkins-master"
  ami = "ami-0694d931cee176e7d"

  instance_type          = "t2.micro"
  key_name               = "jenkins-test-sunday"
  monitoring             = true

  vpc_security_group_ids = [module.aws_module_sg.security_group_id]
  subnet_id = module.my-test-vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Name = "tf-jenkins-master"
    Terraform   = "true"
    Environment = "dev"
  }
}