# aws_autoscaling_lifecycle_hook

resource "aws_sqs_queue" "worker" {
  name = var.name

  message_retention_seconds = 300

  # policy = data.aws_iam_policy_document.sqs.json
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "events.amazonaws.com",
          "sqs.amazonaws.com"
        ]
      },
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:${var.region}:${local.account_id}:${var.name}"
    }
  ]
}
POLICY

  tags = local.tags
}

resource "aws_autoscaling_lifecycle_hook" "worker_launching" {
  name                   = format("%s-launching", var.name)
  autoscaling_group_name = aws_autoscaling_group.worker.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = <<EOF
{
  "foo": "launching"
}
EOF

  # notification_target_arn = aws_sqs_queue.worker.arn
  # role_arn                = "arn:aws:iam::123456789012:role/S3Access"
}

resource "aws_autoscaling_lifecycle_hook" "worker_terminating" {
  name                   = format("%s-terminating", var.name)
  autoscaling_group_name = aws_autoscaling_group.worker.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_metadata = <<EOF
{
  "foo": "terminating"
}
EOF

  # notification_target_arn = aws_sqs_queue.worker.arn
  # role_arn                = ""
}
