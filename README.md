# Enterprise Azure Kubernetes Service (AKS) & Azure Container Registry (ACR) Terraform

This repository provides a production-grade, modular, and DRY Terraform architecture to deploy AKS, ACR, and Resource Groups on Microsoft Azure.

## Architecture

```
.
├── environments
│   ├── dev       # Development environment (consolidated providers.tf)
│   ├── qa        # QA environment (consolidated providers.tf)
│   ├── staging   # Staging environment (consolidated providers.tf)
│   └── prod      # Production environment (consolidated providers.tf)
├── modules
│   ├── acr             # Azure Container Registry module
│   ├── aks             # Azure Kubernetes Service module
│   └── resource_group  # Azure Resource Group module (utilizes for_each)
└── README.md
```

## Features
- **Terraform >= 1.5** capabilities used (optional object attributes, dynamic blocks).
- **Environment Agnostic Modules:** Designed to be reusable across any environment simply by passing different variables.
- **Clean Configuration:** Consolidated `providers.tf` containing provider, version, and backend configurations.
- **Remote State:** Integrated Azure RM backend per environment.
- **Resource Groups:** Support for creating multiple Resource Groups simultaneously through nested maps and `for_each`.
- **Azure Kubernetes Service (AKS):** Supports RBAC, Managed Identity, dynamic default & additional node pools (auto-scaling, multi-zone).
- **Azure Container Registry (ACR):** Supports optional geo-replication, SKU selection, network rules, and private endpoints.

## Prerequisites
- Terraform CLI (v1.5.0 or newer)
- Azure CLI (authenticated with `az login`)
- Azure Subscription with adequate quotas for AKS & ACR.
- A pre-existing Azure Storage Account & Resource Group for Terraform remote state backend.

## Deployment Instructions

1. Navigate to your desired environment folder (e.g., `dev`):
   ```bash
   cd environments/dev
   ```

2. Update `terraform.tfvars` if necessary, and ensure `providers.tf` points to an existing storage account in the `backend` block.

3. Initialize Terraform (this will download providers and setup remote state):
   ```bash
   terraform init
   ```

4. Review the execution plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Best Practices Followed
- **Naming Conventions:** Consistent prefixes and environment suffixes.
- **Tagging:** Default tags merged with specific tags at the resource level.
- **Security:** Private endpoints options, RBAC enabled by default, SystemAssigned identities.
- **High Availability:** Availability zones configured on AKS node pools.
