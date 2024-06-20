variable "instances" {
  description = "Map of ec2 instances"
  type = list(object({
    ami            = string
    type           = string
    name           = string
    subnet_id      = string
    private_ip     = string
    public_ipv4    = bool
    ipv6_count     = number
    security_group = list(string)
    key            = string
    volume_size    = number
    user_data      = string
  }))
}