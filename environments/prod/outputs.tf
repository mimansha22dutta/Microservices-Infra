output "resource_groups" {
  value       = module.resource_groups.resource_groups
  description = "Created resource groups"
}

output "acr_login_server" {
  value       = module.acr.login_server
  description = "ACR login server URL"
}

output "aks_cluster_name" {
  value       = module.aks.name
  description = "AKS cluster name"
}

output "aks_kube_config" {
  value       = module.aks.kube_config_raw
  sensitive   = true
  description = "AKS kubeconfig"
}
