provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = "subnet-12345678"
  tags = {
    Name = "Web Server"
  }
}

resource "aws_lb" "lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]
  security_groups    = ["sg-0123456789abcdef0"]
}

resource "aws_lb_target_group" "tg" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-87654321"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }
}
