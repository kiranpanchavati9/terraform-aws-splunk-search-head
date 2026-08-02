output "id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.splunk_search_head.id
}

output "latest_version" {
  description = "The latest version of the launch template"
  value       = aws_launch_template.splunk_search_head.latest_version
}

output "name" {
  description = "The name of the launch template"
  value       = aws_launch_template.splunk_search_head.name
}

output "arn" {
  description = "The ARN of the launch template"
  value       = aws_launch_template.splunk_search_head.arn
}