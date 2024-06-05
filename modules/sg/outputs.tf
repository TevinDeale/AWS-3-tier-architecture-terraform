output "security_groups" {
  description = "Security Groups"
  value = [
    for sg in aws_security_group.main_sg : {
      name    = sg.name
      id      = sg.id
      ingress = sg.ingress
      egress  = sg.egress
    }
  ]
}

