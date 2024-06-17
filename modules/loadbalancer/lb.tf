resource "aws_lb" "elb" {
  for_each = { for lb in var.elb : lb.name => {
    name                  = lb.name
    internal              = lb.internal
    type                  = lb.type
    security_groups       = lb.security_groups
    subnets               = lb.subnets
    phh                   = lb.phh
    xff_client_port       = lb.xff_client_port
    xff_header_processing = lb.xff_header_processing
    cross_zone            = lb.cross_zone
  } }

  name                             = each.value.name
  internal                         = each.value.internal
  load_balancer_type               = each.value.type
  security_groups                  = each.value.security_groups
  subnets                          = each.value.subnets
  preserve_host_header             = each.value.phh
  xff_header_processing_mode       = each.value.xff_header_processing
  enable_xff_client_port           = each.value.xff_client_port
  enable_cross_zone_load_balancing = each.value.cross_zone
}

resource "aws_lb_target_group" "tg" {
  for_each = { for tg in var.tg : tg.name => {
    name                  = tg.name
    port                  = tg.port
    protocol              = tg.protocol
    vpc_id                = tg.vpc_id
    enable_health_check   = tg.enable_health_check
    health_check_interval = tg.health_check_interval
    health_check_path     = tg.health_check_path
    enable_sticky         = tg.enable_sticky
    cookie_name           = tg.cookie_name
    cookie_duration       = tg.cookie_duration
    sticky_type           = tg.sticky_type
  } }

  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = each.value.vpc_id

  health_check {
    enabled  = each.value.enable_health_check
    interval = each.value.health_check_interval
    path     = each.value.health_check_path
  }

  stickiness {
    enabled         = each.value.enable_sticky
    type            = each.value.sticky_type
    cookie_name     = each.value.cookie_name
    cookie_duration = each.value.cookie_duration
  }
}

resource "aws_lb_target_group_attachment" "targets" {
  depends_on = [ aws_lb_target_group.tg ]
  for_each = { for idx, target in var.targets : "${target.target_id}-${idx}" => {
    tg_arn    = target.tg_arn
    target_id = target.target_id
    port      = target.target_port
  } }
  target_group_arn = each.value.tg_arn
  target_id        = each.value.target_id
  port             = each.value.port
}

resource "aws_lb_listener" "lb_listener" {
  depends_on = [aws_lb.elb, aws_lb_target_group.tg]
  for_each = { for listener in var.lb_listeners : listener.port => {
    lb_arn      = listener.lb_arn
    port        = listener.port
    protocol    = listener.protocol
    ssl_policy  = listener.ssl_policy
    cert_arn    = listener.cert_arn
    action_type = listener.action_type
    tg_arn      = listener.tg_arn
  } }

  load_balancer_arn = each.value.lb_arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.ssl_policy
  certificate_arn   = each.value.cert_arn

  default_action {
    type             = each.value.action_type
    target_group_arn = each.value.tg_arn
  }
}