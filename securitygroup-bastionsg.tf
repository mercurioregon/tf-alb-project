module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "public-bastion-sg"
  description = "Security group with SSH port open.  Egress ports are open"
  vpc_id      = module.vpc.vpc_id

  #Ingress riles and CIDR blocks
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  #Egress rules 
  egress_rules = ["all-all"]
}