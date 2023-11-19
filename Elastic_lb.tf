#Load Balancer
resource "aws_lb" "prod_loadBalancer" {
  name                              = "Production-elb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = [aws_security_group.allow_web.id]
  subnets                           = [aws_subnet.subnet-1.id, aws_subnet.subnet-1a.id]
  enable_deletion_protection        = false
    tags = {
        Environment                 = "production"
  }
}
#Target Group
resource "aws_lb_target_group" "prod-target-group" {
  name                              = "CPUtest-tg"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = aws_vpc.pro_vpc.id
}
#Listener
resource "aws_lb_listener" "prod-listener" {
  load_balancer_arn                 = aws_lb.prod_loadBalancer.arn
  port                              = 80
  protocol                          = "HTTP"
  default_action {
    type                            = "forward"
    target_group_arn                = aws_lb_target_group.prod-target-group.arn
  }
}