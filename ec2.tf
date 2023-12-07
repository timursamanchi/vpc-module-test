
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