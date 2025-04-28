# Auto Scaling Group

resource "aws_autoscaling_group" "webapp_asg" {
  launch_template {
    id      = aws_launch_template.web_app_launch_template.id
    version = "$Latest"
  }

  name                      = "csye6225_asg"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 3
  vpc_zone_identifier       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = [aws_lb_target_group.webapp_target_group.arn]

  tag {
    key                 = "Name"
    value               = "webapp-instance"
    propagate_at_launch = true
  }

}

# Scale-up Policy
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale_up_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name

}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale_down_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name

}

# Cloudwatch Metric Alarm for Scale-up Policy
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "cpu_above_5_percent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

# Cloudwatch Metric Alarm for Scale-down Policy
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "cpu_below_4_percent"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 4

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]

}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.webapp_asg.name

}

