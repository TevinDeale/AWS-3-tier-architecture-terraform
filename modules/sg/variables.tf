variable "security_groups" {
  description = "List of security groups"
  
  type = list(object({
    name = string
    description = string
    vpc_id = string
  }))
}