# By Rodrigo César Assis

resource "aws_autoscaling_group" "asg_web" {

  lifecycle {
    create_before_destroy = true
  }
  
  name                 = "asg-report-${aws_launch_template.lt_app_fake.latest_version}"
  max_size             = "${var.asg_web_max}"   					# max de instâncias ec2
  min_size             = "${var.asg_web_min}"   					# min de instâncias ec2
  desired_capacity     = "${var.asg_web_des}"   					# desejável de instâncias ec2
  health_check_type    = "ELB"
  wait_for_elb_capacity = "${var.asg_web_min}"  					# Aguarda ficar na capacidade mínima e depois destrói as instâncias
  target_group_arns    = ["${aws_lb_target_group.tg_app.id}"]           # Target group que irá conter as instâncias
  vpc_zone_identifier  = "${var.public_subnets}"					

  launch_template {												
    id      = "${aws_launch_template.lt_app_fake.id}"
    version = "$Latest"
#   version = aws_launch_template.lt_app_fake.latest_version
#   version = "$$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}