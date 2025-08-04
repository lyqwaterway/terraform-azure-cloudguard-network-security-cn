![GitHub Wachers](https://img.shields.io/github/watchers/lyqwaterway/terraform-azure-cloudguard-network-security-cn)
![GitHub Release](https://img.shields.io/github/v/release/lyqwaterway/terraform-azure-cloudguard-network-security-cn)
![GitHub Commits Since Last Commit](https://img.shields.io/github/commits-since/lyqwaterway/terraform-azure-cloudguard-network-security-cn/latest/master)
![GitHub Last Commit](https://img.shields.io/github/last-commit/lyqwaterway/terraform-azure-cloudguard-network-security-cn/master)
![GitHub Repo Size](https://img.shields.io/github/repo-size/lyqwaterway/terraform-azure-cloudguard-network-security-cn)
![GitHub Downloads](https://img.shields.io/github/downloads/lyqwaterway/terraform-azure-cloudguard-network-security-cn/total)

# Terraform Modules for CloudGuard Network Security (CGNS) - Azure China


## Introduction
This repository provides a structured set of Terraform modules for deploying Check Point CloudGuard Network Security in Microsoft Azure China. These modules automate the creation of Virtual Networks, Security Gateways, High-Availability architectures, and more, enabling secure and scalable cloud deployments.

## Repository Structure
`Submodules:` Contains modular, reusable, production-grade Terraform components, each with its own documentation.

`Examples:` Demonstrates how to use the modules.

 
**Submodules:**
* [`high_availability_existing_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/high_availability_existing_vnet) - Deploys CloudGuard High Availability solution into an existing VNet in azure.
* [`high_availability_new_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/high_availability_new_vnet) Deploys CloudGuard High Availability solution into a new VNet.
* [`management_existing_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/management_existing_vnet) - Deploys CloudGuard Management solution into an existing VNet.
* [`management_new_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/management_new_vnet) - Deploys CloudGuard Management solution into a new VNet
* [`mds_existing_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/mds_existing_vnet) - Deploys CloudGuard Management solution into a new VNet.
* [`mds_new_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/mds_new_vnet) - Deploys CloudGuard Management solution into a new VNet.
* [`single_gateway_existing_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/single_gateway_existing_vnet) - Deploys CloudGuard Single Gateway solution into an existing VNet.
* [`single_gateway_new_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/single_gateway_new_vnet) - Deploys CloudGuard Single Gateway solution into a new VNet.                   
* [`vmss_existing_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/vmss_existing_vnet) - Deploys CloudGuard VMSS solution into an existing VNet.
* [`vmss_new_vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/vmss_new_vnet) - Deploys CloudGuard VMSS solution into a new VNet.

Internal Submodules - 

* [`common`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/common) - Contains shared configurations and reusable components for all modules.

* [`network_security_group`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/network_security_group) - Manages Network Security Groups (NSGs) with CloudGuard-specific rules.

- [`vnet`](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest/submodules/vnet) - Simplifies Virtual Network and subnet configurations.


## Security Rules Default Configuration
Some modules in this repository include default security rules configured for "allow all inbound traffic." These rules are provided for ease of deployment but are not intended for production use without further customization. Add security rule to override the default "allow all traffic" configuration.

**Example:** To restrict inbound traffic, update the security_rules attribute in the submodule configuration:
```hcl
security_rules = [
  {
    name                       = "AllowSSH"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_ranges         = "*"
    destination_port_ranges    = "22"
    description                = "Allow SSH inbound connections"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "*"
  }
]
```

**Check Point Recommendation:** Always follow the principle of least privilege when configuring security rules to reduce exposure to threats.

***

# Best Practices for Using CloudGuard Modules

## Step 1: Use the Required Module
Add the required module in your Terraform configuration file (`main.tf`) to deploy resources. For example:

```hcl
provider "azurerm" {
  environment = "china”
  skip_provider_registration = true
  features {}
}

module "example_module" {
  source  = "yqwaterway/cloudguard-network-security-cn/azure//modules/{module_name}"
  version = "{chosen_version}"
  # Add the required inputs
}
```
---

## Step 2: Open the Terminal
Ensure you have [Azure CLI installed](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) and navigate to the directory where your `main.tf` file is located, using the appropriate terminal: 

- **Linux/macOS**: **Terminal**.
- **Windows**: **PowerShell** or **Command Prompt**.

---

## Step 3: Set Environment Variables and Log in with Azure CLI
Set the required environment variables and authenticate with Azure using your Service Principal. Then, select the correct subscription.

### Linux/macOS
```hcl
export TF_VAR_client_id="{your-client-id}"
export TF_VAR_client_secret="{your-client-secret}"
export TF_VAR_subscription_id="{your-subscription-id}"
export TF_VAR_tenant_id="{your-tenant-id}"

az cloud set --name AzureChinaCloud
az login --service-principal -u $TF_VAR_client_id -p $TF_VAR_client_secret --tenant $TF_VAR_tenant_id
az account set --subscription $TF_VAR_subscription_id

az provider register --namespace Microsoft.Network --consent-to-permissions --verbose
az provider register --namespace Microsoft.Storage --consent-to-permissions --verbose
az provider register --namespace Microsoft.Compute --consent-to-permissions --verbose
az provider register --namespace Microsoft.insights --consent-to-permissions --verbose
```
### PowerShell (Windows)
```hcl
$env:TF_VAR_client_id="{your-client-id}"
$env:TF_VAR_client_secret="{your-client-secret}"
$env:TF_VAR_subscription_id="{your-subscription-id}"
$env:TF_VAR_tenant_id="{your-tenant-id}"

az cloud set --name AzureChinaCloud
az login --service-principal -u $env:TF_VAR_client_id -p $env:TF_VAR_client_secret --tenant $env:TF_VAR_tenant_id
az account set --subscription $env:TF_VAR_subscription_id

az provider register --namespace Microsoft.Network --consent-to-permissions --verbose
az provider register --namespace Microsoft.Storage --consent-to-permissions --verbose
az provider register --namespace Microsoft.Compute --consent-to-permissions --verbose
az provider register --namespace Microsoft.insights --consent-to-permissions --verbose
```
### Command Prompt (Windows)
```hcl
set TF_VAR_client_id="{your-client-id}"
set TF_VAR_client_secret="{your-client-secret}"
set TF_VAR_subscription_id="{your-subscription-id}"
set TF_VAR_tenant_id="{your-tenant-id}"

az cloud set --name AzureChinaCloud
az login --service-principal -u %TF_VAR_client_id% -p %TF_VAR_client_secret% --tenant %TF_VAR_tenant_id%
az account set --subscription %TF_VAR_subscription_id%

az provider register --namespace Microsoft.Network --consent-to-permissions --verbose
az provider register --namespace Microsoft.Storage --consent-to-permissions --verbose
az provider register --namespace Microsoft.Compute --consent-to-permissions --verbose
az provider register --namespace Microsoft.insights --consent-to-permissions --verbose
```
---


## Step 4: Deploy with Terraform
Use Terraform commands to deploy resources securely.

### Initialize Terraform
Prepare the working directory and download required provider plugins:
```hcl
terraform init
```

### Plan Deployment
Preview the changes Terraform will make:
```hcl
terraform plan
```
### Apply Deployment
Apply the planned changes and deploy the resources:
```hcl
terraform apply
```
