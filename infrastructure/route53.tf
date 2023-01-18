resource "aws_route53_record" "alb-record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "suffer.guard-lite.com"
  type    = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}
