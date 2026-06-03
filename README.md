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

## CI/CD Pipeline

This project uses **GitHub Actions** for continuous integration and deployment.

### Authentication
Authentication to Azure is handled via **Workload Identity Federation (OIDC)**. This eliminates the need for long-lived secrets or certificates.

### Pipeline Stages
1. **Validate & Lint**:
   - **Terraform Format**: Checks for proper indentation and style.
   - **TFLint**: Performs static analysis to catch cloud-provider specific errors.
   - **TFSec**: Scans the code for security vulnerabilities.
2. **Plan**:
   - Generates a `terraform plan` for the target environment.
   - On Pull Requests, the plan is posted as a comment for review.
3. **Apply**:
   - Automatically deploys changes to the `staging` or `production` environment when changes are merged into the respective branches.

### Monitoring
You can monitor the status of the pipeline in the **Actions** tab of this repository.

<!-- Triggering CI/CD re-run: 2026-06-03 17:52 UTC -->

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
