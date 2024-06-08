output "instances" {
  description = "EC2 INSTANCE DETAILS"
  value       = aws_instance.ec2
}

output "fmt_instances" {
  description = "EC2 FORMATTED INSTANCE DETAILS"
  value = [
    for instance in aws_instance.ec2 : {
      name         = instance.tags["Name"],
      arn          = instance.arn
      id           = instance.id
      ipv6_address = instance.ipv6_addresses
      ipv4_private = instance.private_ip
      ipv4_public  = instance.public_ip
      az           = instance.availability_zone
      sg           = instance.security_groups
    }
  ]
}