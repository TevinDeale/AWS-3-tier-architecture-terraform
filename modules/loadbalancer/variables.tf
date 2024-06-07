variable "elb" {
  description = "ELB Details"
  type = list(object({
    name = string
    internal = bool
    type = string
    security_groups = list(string)
    subnets = list(string)
    phh = bool
    xff_client_port = bool
    xff_header_processing = string
    cross_zone = bool
  }))
}

variable "tg" {
  description = "TARGET GROUPS"
  type = list(object({
    name = string
    port = number
    protocol = string
    vpc_id = string
    enable_health_check = bool
    health_check_interval = number
    health_check_path = string
    enable_sticky = bool
    cookie_name = string
    cookie_duration = number
    sticky_type = string
  }))
}