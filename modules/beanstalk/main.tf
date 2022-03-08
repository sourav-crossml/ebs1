resource "aws_iam_instance_profile" "ec2_eb_profile" {
  name = "event-driven-ec2-profile"
  role = aws_iam_role.ec2_role.name
  tags = {
    name= "Infoj-prod"
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "event-driven-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  ]

  inline_policy {
    name   = "eb-application-permissions"
    policy = data.aws_iam_policy_document.permissions.json
  }
  tags = {
    "permission":"Infoj-prod IAM assume role"
  }
}



resource "aws_elastic_beanstalk_application" "infog-prod" {
  name        = "infog-prod"
  description = "infog-prod"
}

resource "aws_elastic_beanstalk_application_version" "infog-prod_app_ver" {
  bucket      = var.s3_bucket
  key         = var.s3_bucket_object
  application = aws_elastic_beanstalk_application.infog-prod.name
  name        = "infog-prod-app-version-lable"

}

resource "aws_elastic_beanstalk_environment" "prod_env" {
  name                = "prod-env"
  application         = aws_elastic_beanstalk_application.infog-prod.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.11 running Python 3.7"
  description         = "eb env"
  version_label       = aws_elastic_beanstalk_application_version.infog-prod_app_ver.name
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "aws-elasticbeanstalk-service-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "event-driven-ec2-profile"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.medium"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"

  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "Subnets"
  #   value     = "var.private_subnet-1,var.private_subnet-2"
  # }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "subnet-0e9fa142613946fbd,subnet-03a26e1e32867bcfb"
  }
  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "Subnets"
  #   value     = var.private_subnet-2
  # }

  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "ELBSubnets"
  #   value     = "var.public_subnet-1,var.public_subnet-2"
  # }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "subnet-00c80b9b603f4a841,subnet-047e8ea3205b7ef4c"
  }
  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "ELBSubnets"
  #   value     = var.public_subnet-2
  # }
  ###=========================== Logging ========================== ###

  setting {
    namespace = "aws:elasticbeanstalk:hostmanager"
    name      = "LogPublicationControl"
    value     = false

  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = true

  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = true

  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = 7

  }

  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "EC2KeyName"
  #   value     = var.keypair

  # }



  ###=========================== Load Balancer ========================== ###
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "ListenerEnabled"
    value     = true
  }
  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "Protocol"
    value     = "HTTP"
  }

  # setting {
  #     namespace = "aws:elbv2:listener:443"
  #     name      = "SSLPolicy"
  #     value     = "ELBSecurityPolicy-2016-08"

  # }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = 80
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Protocol"
    value     = "HTTP"
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"

  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"

  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"

  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = 20

  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = -1

  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = 60

  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = 1

  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = true

  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"

  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = 1

  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "RollingWithAdditionalBatch"

  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = 1

  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"

  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = 30

  }
}

# resource "aws_lb_target_group" "alb_target_group" {
#   port     = 80
#   target_type = "alb"
#   protocol = "TCP"
#   vpc_id   = var.vpc_id
# }

# resource "aws_lb_listener" "alb_listener_group_rule1" {
#   load_balancer_arn = aws_elastic_beanstalk_environment.prod_env.load_balancers[0]
#   port              = "80"
#   protocol          = "HTTP"
#   tags = {
#      name = "infoj_alb_listner1"
#   }
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
# }
# data "aws_lb" "eb_lb" {
#   arn = aws_elastic_beanstalk_environment.prod_env.load_balancers[0]
#   name = "Infoj_alb"
# }



resource "aws_security_group" "infoj_alb_sg" {
  name        = "infoj_alb_sg"
  description = "Allow all inbound traffic"
  vpc_id     = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"]
  }
  tags = {
    Name = "infoj_alb_sg"
  }
  depends_on = [
    var.vpc_id
  ]
}