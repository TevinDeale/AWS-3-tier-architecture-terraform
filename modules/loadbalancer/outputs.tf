output "elb" {
  description = "ELB DETAILS"
  value = [
    for lb in aws_lb.elb : {
      name = lb.name
      arn = lb.arn
      dns = lb.dns_name
    }
  ]
}

output "tgs" {
  description = "TG DETAILS"
  value = [
    for tg in aws_lb_target_group.tg : {
      name = tg.name
      arn = tg.arn
    }
  ]
}