locals {
  sg_name_to_id = { for sg in var.security_groups : sg.name => sg.id }
}

resource "aws_instance" "ec2" {
  for_each = { for instance in var.instances : instance.name => {
    ami = instance.ami,
    type = instance.type,
    name = instance.name
    subnet_id = instance.subnet_id
    public_ipv4 = instance.public_ipv4
    ipv6_count = instance.ipv6_count
    security_group = instance.security_group
    key = instance.key
    volume_size = instance.volume_size
    user_data = instance.user_data
  }}

  ami = each.value.ami
  instance_type = each.value.type
  subnet_id = each.value.subnet_id
  associate_public_ip_address = each.value.public_ipv4
  ipv6_address_count = each.value.ipv6_count
  vpc_security_group_ids = each.value.security_group
  key_name = each.value.key
  user_data = each.value.user_data != null ? each.value.user_data : null 

  tags = {
    Name = each.value.name
  }
}