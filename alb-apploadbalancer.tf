module "alb_example_complete-alb" {
  source  = "terraform-aws-modules/alb/aws//examples/complete-alb"
  version = "10.5.0"

  name    = "${local.name}-alb"
  vpc_id  = module.vpc.vpc.id
  subnets = module.vpc.public_subnets

}


