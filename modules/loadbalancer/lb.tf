resource "aws_lb" "elb" {
  for_each = { for lb in var.elb : lb.name => {
    name = lb.name
    internal = lb.internal
    type = lb.type
    security_groups = lb.security_groups
    subnets = lb.subnets
    phh = lb.phh
    xff_client_port = lb.xff_client_port
    xff_header_processing = lb.xff_header_processing
    cross_zone = lb.cross_zone
  }}

  name = each.value.name
  internal = each.value.internal
  load_balancer_type = each.value.type
  security_groups = each.value.security_groups
  subnets = each.value.subnets
  preserve_host_header = each.value.phh
  xff_header_processing_mode = each.value.xff_header_processing
  enable_xff_client_port = each.value.xff_client_port
  enable_cross_zone_load_balancing = each.value.cross_zone
}