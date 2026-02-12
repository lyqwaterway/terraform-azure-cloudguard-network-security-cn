provider "azurerm" {
  environment = "china"
  skip_provider_registration = true
  features {}
}

module "example_module" {
  source  = "CheckPointSW/china-cloudguard-network-security/azure//modules/single-gateway"
  version = "~> 1.1"

  # Authentication Variables
  client_secret                   = var.client_secret
  client_id                       = var.client_id
  tenant_id                       = var.tenant_id
  subscription_id                 = var.subscription_id

  # Basic Configurations Variables
  resource_group_name = "checkpoint-single-rg-terraform"
  single_gateway_name = "checkpoint-single-terraform"
  location            = "chinanorth3"
  tags                = {}

  # Virtual Machine Instances Variables
  source_image_vhd_uri           = "noCustomUri"
  authentication_type            = "Password"
  sic_key                        = "xxxxxxxxxxx"
  admin_password                 = "xxxxxxxxxxx"
  serial_console_password_hash   = "xxxxxxxxxxx"
  maintenance_mode_password_hash = "xxxxxxxxxxx"
  installation_type              = "gateway"
  vm_size                        = "Standard_D4ds_v4"
  disk_size                      = "110"
  os_version                     = "R82"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r82"
  allow_upload_download          = true
  admin_shell                    = "/etc/cli.sh"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  enable_custom_metrics          = true
  zone                           = ""

  # Smart-1 Cloud Variables
  smart_1_cloud_token = ""

  # Management Variables
  management_GUI_client_network = "0.0.0.0/0"

  # Networking Variables
  vnet_name                       = "checkpoint-single-gw-vnet"
  frontend_subnet_name            = "Frontend"
  backend_subnet_name             = "Backend"
  address_space                   = "10.0.0.0/16"
  subnet_prefixes                 = ["10.0.1.0/24", "10.0.2.0/24"]
  nsg_id                          = ""
  storage_account_deployment_mode = "New"
  add_storage_account_ip_rules    = false
  storage_account_additional_ips  = []
}
