resource "aws_route53_record" "app_dns_record" {
  zone_id = var.hosted_zone_id
  name    = "${var.subdomain_env}.${var.domain_name}"
  type    = "A"
  //  ttl     = 60 //Confirm later

  //  records = [aws_instance.app_instance.public_ip]

  alias {
    name                   = aws_lb.webapp_lb.dns_name
    zone_id                = aws_lb.webapp_lb.zone_id
    evaluate_target_health = true
  }

}

output "name" {
  value       = "http://${var.subdomain_env}.${var.domain_name}:${var.application_port}"
  description = "Application URL"
}