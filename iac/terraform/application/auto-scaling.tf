resource "aws_launch_template" "this" {
  name_prefix   = "myapp-template"
  image_id      = "ami-0671d1aa74a7a5599"
  instance_type = "t3.medium"            

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 50
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix = "myapp-"
  desired_capacity   = 2
  max_size           = 10
  min_size           = 2
  vpc_zone_identifier  = [data.aws_subnets.private.ids[0], data.aws_subnets.private.ids[1]]

  target_group_arns = [aws_lb_target_group.this.arn]
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = [ /*"launch_template",*/ "desired_capacity" ] 
  }   
}

resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_xx" {
  name                   = "avg-cpu-policy-greater-than-xx"
  policy_type = "TargetTrackingScaling" 
  autoscaling_group_name = aws_autoscaling_group.this.id 
  estimated_instance_warmup = 180 
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }  

}


