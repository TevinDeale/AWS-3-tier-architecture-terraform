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