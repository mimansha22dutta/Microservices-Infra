output "id" {
  description = "The Kubernetes Managed Cluster ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "The name of the Kubernetes Managed Cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools."
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kubelet_identity" {
  description = "The Kubelet Identity block."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "identity" {
  description = "The Identity block."
  value       = azurerm_kubernetes_cluster.this.identity
}
