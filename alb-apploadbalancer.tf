module "alb_example_complete-alb" {
  source  = "terraform-aws-modules/alb/aws//examples/complete-alb"
  version = "10.5.0"

  name               = "${local.name}-alb"
  vpc_id             = module.vpc.vpc.id
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets

  security_group_ingress_rules = {

    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }


  target_groups = {
    mytg1 = {
      create_attachment                 = false
      name_prefix                       = "mytg1-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }
}


resource "aws_lb_target_group_attachment" "mytg1" {
  for_each         = { for k, v in module.ec2_private : k => v }
  target_group_arn = module.alb_example_complete-alb.target_groups["mytg1"].arn
  target_id        = each.value.id
  port             = 80
}
# k = ec2 instance
# v = ec2 details

output "zz_ec2_private" {
  #value = {for k, v in module.ec2_private: k => v}
  value = { for ec2_instance, ec2_instance_details in module.ec2_private : ec2_instance => ec2_instance_details }
}