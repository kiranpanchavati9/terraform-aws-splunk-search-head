output "autoscaling_group_id" {
  description = "The ID of the autoscaling group"
  value       = aws_autoscaling_group.search-head-autoscaling-group.id
}

output "autoscaling_group_name" {
  description = "The name of the autoscaling group"
  value       = aws_autoscaling_group.search-head-autoscaling-group.name
}