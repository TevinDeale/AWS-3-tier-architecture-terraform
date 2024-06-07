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