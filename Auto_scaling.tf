data "aws_ami" "amzLinux" {
        most_recent                 = true
        owners                      = ["amazon"]
    
    filter {
        name                        = "name"
        values                      = ["al2023-ami-2023*x86_64"]
        }
}
 locals {
        DB                          = "aurora_db"
        User                        = "test"
        PW                          = "Extrajos58"
        #host                        = aws_rds_cluster.auroracluster.id
}
#Launch Template
resource "aws_launch_template" "prod-launch-template" {
  name                              = "WebserverLaunchTemplate"
  image_id                          = data.aws_ami.amzLinux.id
  #image_id                         = "ami-08541bb85074a743a"
  instance_type                     = "t2.micro"
  vpc_security_group_ids            = [aws_security_group.allow_web.id]
   user_data                         = base64encode(templatefile("user_data.sh",{
        DB   = local.DB
        User = local.User
        PW   = local.PW
        #host = local.host
    } )) 

#IAM profile
# iam_instance_profile {
#         name                        = "instance_role_prod"
#    }     
#   tag_specifications {
#         resource_type               = "instance"
#         tags                        = {
#             Name                    = "aurora_db"
#   }
#   }
# resource "aws_iam_instance_profile" "prod_test_profile" {
#   name = "prod_test_profile"
#   role = aws_iam_role.role.name
# }

#  resource "aws_instance" "instance" {
#   iam_instance_profile = aws_iam_instance_profile.prod_test_profile.name
# }

# tag_specifications {
#         resource_type               = "instance"
#         tags                        = {
#             Name                    = "aurora_db"
# }
}

#Autoscaling Group
resource "aws_autoscaling_group" "prod-AutoScalingGroup" {
  name                              = "prod-autoscaling-group"
  max_size                          = 4
  min_size                          = 2
  desired_capacity                  = 2
  #changed to public subnets while NATGateway is turned off 
  vpc_zone_identifier               = [aws_subnet.subnet-1.id, aws_subnet.subnet-1a.id]
  target_group_arns                 = [aws_lb_target_group.prod-target-group.arn]
  health_check_type                 = "ELB"
  health_check_grace_period         = 300
  launch_template {
    id                              = aws_launch_template.prod-launch-template.id
    version                         = "$Latest"
  }
}
#Autoscaling policy
resource "aws_autoscaling_policy" "prod_policy" {
  name                              = "CPUpolicy"
  policy_type                       = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type        = "ASGAverageCPUUtilization"
    }
      target_value                  = 75.0
  }
  autoscaling_group_name            = aws_autoscaling_group.prod-AutoScalingGroup.name
}