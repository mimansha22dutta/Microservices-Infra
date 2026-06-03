variable "resource_groups" {
  description = "A map of resource groups to create."
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string))
  }))
}

variable "tags" {
  description = "Common tags to apply to all resource groups."
  type        = map(string)
  default     = {}
}
