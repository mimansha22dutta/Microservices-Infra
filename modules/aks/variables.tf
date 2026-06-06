variable "name" {
  description = "The name of the Managed Kubernetes Cluster."
  type        = string
}

variable "location" {
  description = "The location of the resource group."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Standard."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_tier must be Free or Standard."
  }
}

variable "private_cluster_enabled" {
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
  type        = bool
  default     = false
}

variable "default_node_pool" {
  description = "Default node pool configuration."
  type = object({
    name                = string
    vm_size             = string
    vnet_subnet_id      = optional(string)
    enable_auto_scaling = optional(bool, true)
    min_count           = optional(number, 1)
    max_count           = optional(number, 3)
    node_count          = optional(number, 1)
    zones               = optional(list(string), [])
  })
}

variable "identity_type" {
  description = "The type of identity used for the managed cluster."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs."
  type        = list(string)
  default     = null
}

variable "network_profile" {
  description = "Network profile configuration."
  type = object({
    network_plugin = optional(string, "azure")
    network_policy = optional(string, "azure")
    dns_service_ip = optional(string, "10.0.0.10")
    service_cidr   = optional(string, "10.0.0.0/16")
  })
  default = {}
}

variable "azure_rbac_enabled" {
  description = "Is Role Based Access Control based on Azure AD enabled?"
  type        = bool
  default     = true
}

variable "tenant_id" {
  description = "The Tenant ID used for Azure Active Directory Application."
  type        = string
  default     = null
}

variable "admin_group_object_ids" {
  description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
  type        = list(string)
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace which the OMS Agent should send data to."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "node_pools" {
  description = "A map of additional node pools."
  type = map(object({
    vm_size              = string
    vnet_subnet_id       = optional(string)
    enable_auto_scaling  = optional(bool, true)
    min_count            = optional(number, 1)
    max_count            = optional(number, 3)
    node_count           = optional(number, 1)
    orchestrator_version = optional(string)
    zones                = optional(list(string), [])
    tags                 = optional(map(string), {})
  }))
  default = {}
}
