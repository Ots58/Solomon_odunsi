data "aws_ami" "amzLinux" {
        most_recent                 = true
        owners                      = ["amazon"]
    
    filter {
        name                        = "name"
        values                      = ["al2023-ami-2023*x86_64"]
        }
}

 locals {
        DB                          = "aurora_solo_db"
        User                        = "test"
        PW                          = "extrajos85"
        host                        = "host"
}
#Launch Template
resource "aws_launch_template" "prod-launch-template" {
  name                              = "WebserverLaunchTemplate"
  image_id                          = data.aws_ami.amzLinux.id
  instance_type                     = "t2.micro"
  vpc_security_group_ids            = [aws_security_group.allow_web.id] 
   #user_data                         = file("newuser_data.sh")
  #user_data                          = "${base64encode(data.template_file.userdatatemplate.rendered)}"
  user_data                         = base64encode(templatefile("newuser_data.sh",{
       DB   = local.DB
        User = local.User
        PW   = local.PW
       host = local.host
  } )) 
#IAM profile
iam_instance_profile {
        name                        = "instance_role_prod"
   }     
  tag_specifications {
        resource_type               = "instance"
        tags                        = {
            Name                    = "launch_temp"
  }
 }
 }


#Autoscaling Group
resource "aws_autoscaling_group" "prod-AutoScalingGroup" {
  name                              = "prod-autoscaling-group"
  max_size                          = 2
  min_size                          = 2
  desired_capacity                  = 2
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