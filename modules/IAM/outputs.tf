output "instance_profile_name" {
  description = "Instance profile name for the launch template"
  value       = aws_iam_instance_profile.search_head.name
}