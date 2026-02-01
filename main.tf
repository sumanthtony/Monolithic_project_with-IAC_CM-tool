resource "aws_launch_template" "web_server_as" {
    name = "myproject"
    image_id           = "ami-0ff5003538b60d5ec"
    vpc_security_group_ids = [aws_security_group.web_server.id]
    instance_type = "t3.micro"
    key_name = "Mumbai-kp"
    tags = {
        Name = "DevOps"
    }
    
}
   


  resource "aws_lb" "web_server_lb"{
     name = "web-server-lb"
     load_balancer_type = "application"
     security_groups = [aws_security_group.web_server.id]
     subnets = ["subnet-092d83e1f27567bac", "subnet-056d0a81628ddd6da"]
    tags = {
      Name = "terraform-alb"
    }
  }
resource "aws_lb_target_group" "web_server_tg" {
  name     = "web-server-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = "vpc-0f47eccfd6b1ea46c"
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
    availability_zones    = ["ap-south-1a", "ap-south-1b"] 
    launch_template {
        id      = aws_launch_template.web_server_as.id
        version = "$Latest"
      }
target_group_arns = [aws_lb_target_group.web_server_tg.arn]
    
  }

