# aws_eip

data "aws_instances" "worker" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.worker.name
  }

  # instance_state_names = ["running", "stopped"]

  depends_on = [aws_autoscaling_group.worker]
}

resource "aws_eip" "worker" {
  instance = data.aws_instances.worker.ids.0

  vpc = true

  tags = local.tags
}

output "public_ip" {
  value = aws_eip.worker.public_ip
}
