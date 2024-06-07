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

resource "aws_lb_target_group" "tg" {
  for_each = { for tg in var.tg : tg.name => {
    name = tg.name
    port = tg.port
    protocol = tg.protocol
    vpc_id = tg.vpc_id
    enable_health_check = tg.enable_health_check
    health_check_interval = tg.health_check_interval
    health_check_path = tg.health_check_path
    enable_sticky = tg.enable_sticky
    cookie_name = tg.cookie_name
    cookie_duration = tg.cookie_duration
    sticky_type = tg.sticky_type
  }}

  name = each.value.name
  port = each.value.port
  protocol = each.value.protocol
  vpc_id = each.value.vpc_id

  health_check {
    enabled = each.value.enable_health_check
    interval = each.value.health_check_interval
    path = each.value.path
  }

  stickiness {
    enabled = ea
    type = each.value.sticky_type
    cookie_name = each.value.cookie_name
    cookie_duration = each.value.cookie_duration
  }
}