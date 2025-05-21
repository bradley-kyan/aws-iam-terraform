variable "users" {
  description = "List of IAM users to create"
  type = map(object({
    fname      = string
    lname      = string
    group_name = string
  }))
}

variable "groups" {
    description = "List of IAM groups to create"
    type = list(string)
}
