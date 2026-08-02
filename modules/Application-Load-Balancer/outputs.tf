output "dns_name" {
  description = "ALB DNS name, use this to reach Splunk Web"
  value       = aws_lb.search_head.dns_name
}

output "zone_id" {
  description = "Hosted zone ID for a Route 53 alias record"
  value       = aws_lb.search_head.zone_id
}

output "arn" {
  description = "ALB ARN"
  value       = aws_lb.search_head.arn
}

output "target_group_arn" {
  description = "Target group ARN for the ASG"
  value       = aws_lb_target_group.search_head.arn
}