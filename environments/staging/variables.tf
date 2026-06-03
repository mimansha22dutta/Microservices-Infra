variable "environment" {
  type        = string
  description = "The environment name (e.g., dev, qa, staging, prod)"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources in"
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "Common tags for resources"
  default     = {}
}
