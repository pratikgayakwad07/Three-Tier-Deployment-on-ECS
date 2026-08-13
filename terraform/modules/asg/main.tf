data "aws_ami" "linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}
resource "aws_launch_template" "ecs_launch_template" {

  name_prefix = "ecs-launch-template-"

  image_id = data.aws_ami.linux.id

  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.backend_sg_id]

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ecs-instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {

  name = "ecs-asg"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  protect_from_scale_in     = true
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
}

# capacity provider

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {

  name = "blogapp-capacity-provider"

  auto_scaling_group_provider {

    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {

      status                    = "ENABLED"
      target_capacity           = 80
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 3
    }

    managed_termination_protection = "ENABLED"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {

  cluster_name = var.ecs_cluster_name

  capacity_providers = [
    aws_ecs_capacity_provider.ecs_capacity_provider.name
  ]

  default_capacity_provider_strategy {

    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name

    weight = 1
    base   = 1
  }
}