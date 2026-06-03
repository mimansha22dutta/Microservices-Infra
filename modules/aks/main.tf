terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.dns_prefix
  kubernetes_version      = var.kubernetes_version
  sku_tier                = var.sku_tier
  private_cluster_enabled = var.private_cluster_enabled

  default_node_pool {
    name                 = var.default_node_pool.name
    vm_size              = var.default_node_pool.vm_size
    vnet_subnet_id       = var.default_node_pool.vnet_subnet_id
    enable_auto_scaling  = var.default_node_pool.enable_auto_scaling
    min_count            = var.default_node_pool.min_count
    max_count            = var.default_node_pool.max_count
    node_count           = var.default_node_pool.node_count
    orchestrator_version = var.kubernetes_version
    zones                = var.default_node_pool.zones
    tags                 = var.tags
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" ? var.user_assigned_identity_ids : null
  }

  network_profile {
    network_plugin = var.network_profile.network_plugin
    network_policy = var.network_profile.network_policy
    dns_service_ip = var.network_profile.dns_service_ip
    service_cidr   = var.network_profile.service_cidr
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = var.azure_rbac_enabled
    tenant_id              = var.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = each.key
  vm_size               = each.value.vm_size
  vnet_subnet_id        = each.value.vnet_subnet_id
  enable_auto_scaling   = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  node_count            = each.value.node_count
  orchestrator_version  = each.value.orchestrator_version != null ? each.value.orchestrator_version : var.kubernetes_version
  zones                 = each.value.zones
  tags                  = merge(var.tags, coalesce(each.value.tags, {}))

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
