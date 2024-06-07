output "elb" {
  description = "ELB DETAILS"
  value = [
    for lb in aws_lb.elb : {
      name = lb.name
      id = lb.id
      dns = lb.dns_name
    }
  ]
}