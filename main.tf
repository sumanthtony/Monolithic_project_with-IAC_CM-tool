resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-09ed39e30153c3bf9"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t3.small"
    key_name = "Mumbai-kp"
    tags = {
        Name = "DevOps-servers"
    }
    
}
   


  resource "aws_lb" "web_server_lb"{
     name = "web-server-lb"
     load_balancer_type = "application"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-00f0e4183f3b8fe00", "subnet-0d9338ba2a44a581a"]
    tags = {
      Name = "terraform-alb"
    }
  }
resource "aws_lb_target_group" "web_server_tg" {
  name     = "web-server-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0258a4f3bfcab844b"
}

resource "aws_lb_listener" "web_server_listener" {
  load_balancer_arn = aws_lb.web_server_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }
}

resource "aws_autoscaling_group" "web_server_asg" {
    name                 = "web-server-asg"
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type    = "EC2"
    vpc_zone_identifier    = ["subnet-00f0e4183f3b8fe00", "subnet-0d9338ba2a44a581a"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
target_group_arns = [aws_lb_target_group.web_server_tg.arn]
    
  }

