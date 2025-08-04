# Check Point CloudGuard High Availability Module - Existing VNet
This Terraform module deploys Check Point CloudGuard Network Security High Availability solution into an existing VNet in azure.
As part of the deployment the following resources are created:
- Resource group
- System assigned identity
- Availability Set - conditional creation

For additional information,
please see the [CloudGuard Network for Azure High Availability Cluster Deployment Guide](https://sc1.checkpoint.com/documents/IaaS/WebAdminGuides/EN/CP_CloudGuard_Network_for_Azure_HA_Cluster/Default.htm)

This solution uses the following modules:
- common - used for creating a resource group and defining common variables.

## Usage
Follow best practices for using CGNS modules on [the root page](https://registry.terraform.io/modules/lyqwaterway/cloudguard-network-security-cn/azure/latest).

**Example:**
```
provider "azurerm" {
  environment = "china"
  features {}
}

module "example_module" {

        source  = "lyqwaterway/cloudguard-network-security-cn/azure//modules/high_availability_existing_vnet"
        version = "1.0.4"

        tenant_id                       = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        source_image_vhd_uri            = "noCustomUri"
        resource_group_name             = "checkpoint-ha-terraform"
        cluster_name                    = "checkpoint-ha-terraform"
        location                        = "chinanorth3"
        vnet_name                       = "checkpoint-ha-vnet"
        vnet_resource_group             = "existing-vnet"
        frontend_subnet_name            = "frontend"
        backend_subnet_name             = "backend"
        frontend_IP_addresses           = [5, 6, 7]
        backend_IP_addresses            = [5, 6, 7]
        admin_password                  = "xxxxxxxxxxxx"
        smart_1_cloud_token_a           = "xxxxxxxxxxxx"
        smart_1_cloud_token_b           = "xxxxxxxxxxxx"
        sic_key                         = "xxxxxxxxxxxx"
        vm_size                         = "Standard_D3_v2"
        disk_size                       = "110"
        vm_os_sku                       = "sg-byol"
        vm_os_offer                     = "check-point-cg-r8110"
        os_version                      = "R8110"
        bootstrap_script                = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
        allow_upload_download           = true
        authentication_type             = "Password"
        availability_type               = "Availability Zone"
        enable_custom_metrics           = true
        enable_floating_ip              = false
        use_public_ip_prefix            = false
        create_public_ip_prefix         = false
        existing_public_ip_prefix_id    = ""
        admin_shell                     = "/etc/cli.sh"
        serial_console_password_hash    = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        maintenance_mode_password_hash  = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        add_storage_account_ip_rules    = false
        storage_account_additional_ips  = []
}
```

## Conditional creation
- To deploy the solution based on Azure Availability Set and create a new Availability Set for the virtual machines:
  ```
  availability_type = "Availability Set"
  ```
  Otherwise, to deploy the solution based on Azure Availability Zone:
  ```
  availability_type = "Availability Zone"
  ```

- To enable CloudGuard metrics in order to send statuses and statistics collected from HA instances to the Azure Monitor service:
  ```
  enable_custom_metrics = true
  ```

- To create new public IP prefix for the public IP:
  ```
  use_public_ip_prefix            = true
  create_public_ip_prefix         = true
  ```
- To use an existing public IP prefix for the public IP:
  ```
  use_public_ip_prefix            = true
  create_public_ip_prefix         = false
  existing_public_ip_prefix_id    = "public IP prefix resource id"
  ```

### Module's variables:
| Name                                  | Description                                                                                                                                                      | Type           | Allowed values                                                                                                                                                                                                                                    |
|---------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **tenant_id**                         | The tenant ID of the Service Principal used to deploy the solution                                                                                               | string         |                                                                                                                                                                                                                                       |
| **source_image_vhd_uri**              | The URI of the blob containing the development image. Please use noCustomUri if you want to use marketplace images                                               | string         | **Default:**  "noCustomUri"                                                                                                                                                                                                                            |
| **resource_group_name**               | The name of the resource group that will contain the contents of the deployment                                                                                  | string         | Resource group names only allow alphanumeric characters, periods, underscores, hyphens and parenthesis and cannot end in a period<br />                                                                                              |
| **location**                          | The region where the resources will be deployed at                                                                                                               | string         | The full list of Azure regions can be found at https://azure.microsoft.com/regions<br />                                                                                                       |
| **cluster_name**                      | The name of the Check Point Cluster Object                                                                                                                       | string         | Only alphanumeric characters are allowed, and the name must be 1-30 characters long<br />                                                                                                      |
| **vnet_name**                         | Virtual Network name                                                                                                                                             | string         | The name must begin with a letter or number, end with a letter, number or underscore, and may contain only letters, numbers, underscores, periods, or hyphens<br />                              |
| **vnet_resource_group**               | Resource Group of the existing virtual network                                                                                                                   | string         | The exact name of the existing vnet's resource group<br />                                                                                                                                                                            |
| **frontend_subnet_name**              | Specifies the name of the external subnet                                                                                                                        | string         | The exact name of the existing external subnet<br />                                                                                                                                                                                  |
| **backend_subnet_name**               | Specifies the name of the internal subnet                                                                                                                        | string         | The exact name of the existing internal subnet<br />                                                                                                                                                                                  |
| **frontend_IP_addresses**             | A list of three whole numbers representing the private IP addresses of the members' eth0 NICs and the cluster VIP IP addresses                                   | list(number)   |                                                                                                                                                                                                                                       |
| **backend_IP_addresses**              | A list of three whole numbers representing the private IP addresses of the members' eth1 NICs and the backend LB IP addresses                                    | list(number)   |                                                                                                                                                                                                                                       |
| **admin_password**                    | The password associated with the local administrator account on each cluster member                                                                               | string         | Password must have 3 of the following: 1 lower case character, 1 upper case character, 1 number, and 1 special character<br />                                                                |
| **smart_1_cloud_token_a**             | Smart-1 Cloud token to connect automatically ***Member A*** to Check Point's Security Management as a Service. Follow these instructions to connect this member.  | string         | A valid token copied from the Connect Gateway screen in Smart-1 Cloud portal<br />                                                                                                           |
| **smart_1_cloud_token_b**             | Smart-1 Cloud token to connect automatically ***Member B*** to Check Point's Security Management as a Service. Follow these instructions to connect this member.  | string         | A valid token copied from the Connect Gateway screen in Smart-1 Cloud portal<br />                                                                                                           |
| **sic_key**                           | The Secure Internal Communication one-time secret used to set up trust between the cluster object and the management server                                       | string         | Only alphanumeric characters are allowed, and the value must be 12-30 characters long<br />                                                                                                   |
| **vm_size**                           | Specifies the size of Virtual Machine                                                                                                                            | string         | Various valid sizes (e.g., "Standard_DS2_v2", "Standard_D4s_v3", etc.)<br />                                                                                                                  |
| **disk_size**                         | Storage data disk size (GB)                                                                                                                                      | string         | A number in the range 100 - 3995 (GB)<br />                                                                                                                                                                                          |
| **vm_os_sku**                         | A SKU of the image to be deployed                                                                                                                                | string         | "sg-byol" - BYOL license<br />                                                                                        |
| **vm_os_offer**                       | The name of the image offer to be deployed                                                                                                                       | string         | "check-point-cg-r81.10";<br />"check-point-cg-r81.20";<br />"check-point-cg-r82";<br />                                                                            |
| **os_version**                        | GAIA OS version                                                                                                                                                  | string         | "R8110";<br />"R8120";<br />"R82";<br />                                                                                                                                           |
| **bootstrap_script**                  | An optional script to run on the initial boot                                                                                                                    | string         | Bootstrap script example:<br />"touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"<br />                                                                         |
| **allow_upload_download**             | Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point                                       | boolean        | true;<br />false;<br />                                                                                                                                                                        |
| **authentication_type**               | Specifies whether a password authentication or SSH Public Key authentication should be used                                                                       | string         | "Password";<br />"SSH Public Key";<br />                                                                                                                                                      |
| **availability_type**                 | Specifies whether to deploy the solution based on Azure Availability Set or based on Azure Availability Zone                                                     | string         | "Availability Zone";<br />"Availability Set";<br />**Default:**  "Availability Zone"                                                                                                                           |
| **enable_custom_metrics**             | Indicates whether CloudGuard Metrics will be used for Cluster members monitoring                                                                                 | boolean        | true;<br />false;<br />**Default:**  true                                                                                                                                                                      |
| **enable_floating_ip**                | Indicates whether the load balancers will be deployed with floating IP                                                                                           | boolean        | true;<br />false;<br />**Default:**  false                                                                                                                                                                     |
| **use_public_ip_prefix**              | Indicates whether the public IP resources will be deployed with public IP prefix                                                                                 | boolean        | true;<br />false;<br />**Default:**  false                                                                                                                                                                     |
| **create_public_ip_prefix**           | Indicates whether the public IP prefix will be created or an existing one will be used                                                                           | boolean        | true;<br />false;<br />**Default:**  false                                                                                                                                                                     |
| **existing_public_ip_prefix_id**      | The existing public IP prefix resource ID                                                                                                                       | string         | Existing public IP prefix resource ID<br />                                                                                                                                                  |
| **admin_shell**                       | Enables selecting different admin shells                                                                                                                         | string         | /etc/cli.sh;<br />/bin/bash;<br />/bin/csh;<br />/bin/tcsh;<br />                                                                                                                             |
| **serial_console_password_hash**      | Optional parameter, used to enable serial console connection in case of SSH key as authentication type                                                           | string         |                                                                                                                                                                                                                                       |
| **maintenance_mode_password_hash**    | Maintenance mode password hash, relevant only for R81.20 and higher versions                                                                                     | string         |                                                                                                                                                                                                                                       |
| **add_storage_account_ip_rules**      | Add Storage Account IP rules that allow access to the Serial Console only for IPs based on their geographic location                                             | boolean        | true;<br />false;<br />**Default:**  false                                                                                                                                                                     |
| **storage_account_additional_ips**    | IPs/CIDRs that are allowed access to the Storage Account                                                                                                          | list(string)   | A list of valid IPs and CIDRs<br />**Default:**  []                                                                                                                                                            |
| **security_rules**                    | Security rules for the Network Security Group                                                                                                                   | list(any)      | A security rule composed of: {name, priority, direction, access, protocol, source_port_ranges, destination_port_ranges, source_address_prefix, destination_address_prefix, description}<br />**Default:**  []  |
| **admin_SSH_key**                     | The SSH public key for SSH connections to the instance. Used when the authentication_type is 'SSH Public Key'                                                    | string         | **Default:**  ""                                                                                                                                                                                                                                      |