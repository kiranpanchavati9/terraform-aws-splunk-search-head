output "autoscaling_group_id" {
  description = "The ID of the autoscaling group"
  value       = aws_autoscaling_group.search_head.id
}

output "autoscaling_group_name" {
  description = "The name of the autoscaling group"
  value       = aws_autoscaling_group.search_head.name
}

output "autoscaling_group_arn" {
  description = "The ARN of the autoscaling group"
  value       = aws_autoscaling_group.search_head.arn
}