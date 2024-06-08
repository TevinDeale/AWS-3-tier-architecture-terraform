variable "elb" {
  description = "ELB Details"
  type = list(object({
    name                  = string
    internal              = bool
    type                  = string
    security_groups       = list(string)
    subnets               = list(string)
    phh                   = bool
    xff_client_port       = bool
    xff_header_processing = string
    cross_zone            = bool
  }))
}

variable "tg" {
  description = "TARGET GROUPS"
  type = list(object({
    name                  = string
    port                  = number
    protocol              = string
    vpc_id                = string
    enable_health_check   = bool
    health_check_interval = number
    health_check_path     = string
    enable_sticky         = bool
    cookie_name           = string
    cookie_duration       = number
    sticky_type           = string
  }))
}

variable "targets" {
  description = "TARGET"
  type = list(object({
    tg_arn      = string
    target_id   = string
    target_port = number
  }))
}

variable "lb_listeners" {
  description = "LB LISTENERS"
  type = list(object({
    lb_arn      = string
    port        = number
    protocol    = string
    ssl_policy  = string
    cert_arn    = string
    action_type = string
    tg_arn      = string
  }))
}