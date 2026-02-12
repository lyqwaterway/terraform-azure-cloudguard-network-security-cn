provider "azurerm" {
  environment = "china"
  skip_provider_registration = true
  features {}
}

module "example_module" {
  source  = "CheckPointSW/china-cloudguard-network-security-cn/azure//modules/high-availability"
  version = "~> 1.1"

  # Authentication Variables
  client_secret                   = var.client_secret
  client_id                       = var.client_id
  tenant_id                       = var.tenant_id
  subscription_id                 = var.subscription_id

  # Basic Configurations Variables
  resource_group_name = "checkpoint-ha-terraform"
  cluster_name        = "checkpoint-ha-terraform"
  location            = "chinanorth3"
  tags                = {}

  # Virtual Machine Instances Variables
  source_image_vhd_uri           = "noCustomUri"
  authentication_type            = "Password"
  sic_key                        = "xxxxxxxxxxx"
  admin_password                 = "xxxxxxxxxxx"
  serial_console_password_hash   = "xxxxxxxxxxx"
  maintenance_mode_password_hash = "xxxxxxxxxxx"
  vm_size                        = "Standard_D4ds_v4"
  disk_size                      = "110"
  os_version                     = "R82"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r82"
  allow_upload_download          = true
  admin_shell                    = "/etc/cli.sh"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  enable_custom_metrics          = true
  availability_type              = "Availability Zone"
  availability_zones             = ["1", "2"]

  # Smart-1 Cloud Variables
  smart_1_cloud_token_a = ""
  smart_1_cloud_token_b = ""

  # Networking Variables
  vnet_name                       = "checkpoint-ha-vnet"
  frontend_subnet_name            = "Frontend"
  backend_subnet_name             = "Backend"
  address_space                   = "10.0.0.0/16"
  subnet_prefixes                 = ["10.0.1.0/24", "10.0.2.0/24"]
  nsg_id                          = ""
  storage_account_deployment_mode = "New"
  add_storage_account_ip_rules    = false
  storage_account_additional_ips  = []
  vips_names                      = []

  # Load Balancers Variables
  enable_floating_ip           = true
  use_public_ip_prefix         = false
  create_public_ip_prefix      = false
  existing_public_ip_prefix_id = ""
}
