module "example_module" {
  source  = "lyqwaterway/cloudguard-network-security-cn/azure//modules/management"
  version = "1.1.0"

  # Authentication Variables
  client_secret                   = var.client_secret
  client_id                       = var.client_id
  tenant_id                       = var.tenant_id
  subscription_id                 = var.subscription_id

  # Basic Configurations Variables
  resource_group_name = "checkpoint-mgmt-terraform"
  mgmt_name           = "checkpoint-mgmt-terraform"
  location            = "chinanorth3"
  tags                = {}

  # Virtual Machine Instances Variables
  source_image_vhd_uri           = "noCustomUri"
  authentication_type            = "Password"
  admin_password                 = "xxxxxxxxxxx"
  serial_console_password_hash   = "xxxxxxxxxxx"
  maintenance_mode_password_hash = "xxxxxxxxxxx"
  vm_size                        = "Standard_D4ds_v4"
  disk_size                      = "110"
  os_version                     = "R82"
  vm_os_sku                      = "mgmt-byol"
  vm_os_offer                    = "check-point-cg-r82"
  allow_upload_download          = true
  admin_shell                    = "/etc/cli.sh"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  zone                           = ""

  # Networking Variables
  vnet_name                       = "checkpoint-mgmt-vnet"
  subnet_name                     = "checkpoint-mgmt-vnet-subnet"
  address_space                   = "10.0.0.0/16"
  subnet_prefix                   = "10.0.0.0/24"
  management_GUI_client_network   = "0.0.0.0/0"
  mgmt_enable_api                 = "disable"
  nsg_id                          = ""
  storage_account_deployment_mode = "New"
  add_storage_account_ip_rules    = false
  storage_account_additional_ips  = []
}
