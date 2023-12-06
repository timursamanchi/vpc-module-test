provider "aws" {
  region = "eu-west-1"
}
data "aws_availability_zones" "azs" {}

module "my-test-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.2.0"
  name            = "downham-module-vpc"
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
    Name = "module-VPC-ts"
  }

  public_subnet_tags = {
    Name = "PUB-module-VPC-ts"
  }

  private_subnet_tags = {
    Name = "PRIV-module-VPC-ts"
  }
}