resource "aws_ecs_cluster" "this" {
  name = "${var.project}-ecs-${var.env}"
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.project}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.user_data.rendered)
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "${var.project}-asg-${var.env}"
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  desired_capacity          = var.asg_desired
  vpc_zone_identifier       = var.subnet_ids
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.project}-ecs-instance"
    propagate_at_launch = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh.tpl")
  vars = {
    ecs_cluster_name = aws_ecs_cluster.this.name
  }
}

output "this_cluster_id" {
  value = aws_ecs_cluster.this.id
}
