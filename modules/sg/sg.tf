#Security Group
resource "aws_security_group" "main_sg" {
  for_each = { for sg in var.security_groups : subnet.name => {
    name = sg.name
    description = sg.description
    vpc_id = sg.vpc_id
  }}

  name = each.value.name
  description = each.value.description
  vpc_id = each.value.vpc_id
  revoke_rules_on_delete = true

  tags = {
    Name = sg.name
  }
}