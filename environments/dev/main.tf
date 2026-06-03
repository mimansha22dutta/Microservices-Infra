locals {
  tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

module "resource_groups" {
  source = "../../modules/resource_group"

  resource_groups = {
    aks = {
      name     = "rg-aks-${var.environment}-${var.location}"
      location = var.location
      tags     = local.tags
    }
    acr = {
      name     = "rg-acr-${var.environment}-${var.location}"
      location = var.location
      tags     = local.tags
    }
  }

  tags = local.tags
}

module "acr" {
  source     = "../../modules/acr"
  depends_on = [module.resource_groups]

  name                = "acrproj${var.environment}${var.location}"
  resource_group_name = module.resource_groups.resource_groups["acr"].name
  location            = module.resource_groups.resource_groups["acr"].location
  sku                 = "Standard"
  admin_enabled       = false

  tags = local.tags
}

module "aks" {
  source     = "../../modules/aks"
  depends_on = [module.resource_groups]

  name                = "aks-${var.environment}-${var.location}"
  location            = module.resource_groups.resource_groups["aks"].location
  resource_group_name = module.resource_groups.resource_groups["aks"].name
  dns_prefix          = "aks-${var.environment}"
  kubernetes_version  = "1.28" # Replace with valid version for your region
  sku_tier            = "Free"

  default_node_pool = {
    name                = "default"
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    node_count          = 1
    zones               = ["1", "2", "3"]
  }

  identity_type = "SystemAssigned"

  network_profile = {
    network_plugin = "azure"
    network_policy = "azure"
  }

  azure_rbac_enabled = true

  tags = local.tags
}
