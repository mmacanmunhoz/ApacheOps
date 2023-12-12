resource "aws_sns_topic" "myasg_sns_topic" {
  name = "myapp-sns-topic"
}

resource "aws_sns_topic_subscription" "myasg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
  protocol  = "email"
  endpoint  = "mmacanmunhoz@gmail.com"
}

resource "aws_autoscaling_notification" "myasg_notifications" {
  group_names = [aws_autoscaling_group.this.id]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.myasg_sns_topic.arn 
}