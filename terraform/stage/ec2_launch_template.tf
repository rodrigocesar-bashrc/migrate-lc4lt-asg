# By Rodrigo César Assis

resource "aws_launch_template" "lt_app_fake" {
  lifecycle {
    create_before_destroy = true
  }
    name                                 = "lt_app"
    image_id                             = "${data.aws_ami.ami.id}"
    instance_initiated_shutdown_behavior = "terminate"
    instance_type                        = "${var.app_instance_type}"
    key_name                             = "${var.key_name}"
    vpc_security_group_ids               = ["${aws_security_group.web.id}", "${aws_security_group.database.id}"]
    user_data                            = "${base64encode(data.template_file.instanciaweb.rendered)}"
    update_default_version               = true
    
      monitoring {
    enabled = true
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web"
    }
  }
}