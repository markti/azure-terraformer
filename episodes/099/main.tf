variable "thing" {
  type = object({
    X = string
    Y = optional(string, null)
    Z = string
  })
}
variable "thing2" {
  type    = string
  default = null
}