output "ALB_TG" {
  value       = module.prod_alb.ALB_TG
  description = "Load Balancer Target Group ARN"
}

output "ALB_DNS" {
  value       = module.prod_alb.ALB_DNS
  description = "Load Balancer Domain Name"
}
