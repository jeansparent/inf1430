# Variables
variable "subscription_id" {
  type = string
}

variable "public_rsa" {
  type = string
}

variable "vm_size" {
  type = string
  default = "Standard_B1s"
}

variable "vm_username" {
  type = string
  default = "administrateur"
}

variable "vm_ip" {
  type = string
  default = "192.168.0.106"
}

variable "region" {
  type = string
  default = "Canada Central"
}

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_subnet" "vnet_sub1" {
  name                 = "vnet-sub1"
  virtual_network_name = "vnet-inf1430"
  resource_group_name  = "rg-inf1430-vnet"
}

# Create a resource group
resource "azurerm_resource_group" rg_applicatif_vm {
  name     = "rg-inf1430-applicatif-vm"
  location = var.region
}

resource "azurerm_public_ip" "vnet_pip_applicatif_vm" {
  name                = "pip-applicatif-vm"
  resource_group_name = azurerm_resource_group.rg_applicatif_vm.name
  location            = azurerm_resource_group.rg_applicatif_vm.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_applicatif_vm_nic_1" {
  name                = "vm-applicatif-vm-nic-1"
  location            = azurerm_resource_group.rg_applicatif_vm.location
  resource_group_name = azurerm_resource_group.rg_applicatif_vm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vnet_sub1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_ip
    public_ip_address_id          = azurerm_public_ip.vnet_pip_applicatif_vm.id
  }
}

resource "azurerm_network_security_group" "nsg_applicatif_vm" {
  name                = "nsg-vm-applicatif-vm"
  location            = azurerm_resource_group.rg_applicatif_vm.location
  resource_group_name = azurerm_resource_group.rg_applicatif_vm.name
}

resource "azurerm_network_security_rule" "nsg_applicatif_vm_ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_applicatif_vm.name
  network_security_group_name = azurerm_network_security_group.nsg_applicatif_vm.name
}

resource "azurerm_network_security_rule" "nsg_applicatif_vm_all" {
  name                        = "all"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_applicatif_vm.name
  network_security_group_name = azurerm_network_security_group.nsg_applicatif_vm.name
}

resource "azurerm_network_interface_security_group_association" "nsg_applicatif_vm_association" {
  network_interface_id      = azurerm_network_interface.vm_applicatif_vm_nic_1.id
  network_security_group_id = azurerm_network_security_group.nsg_applicatif_vm.id
}

resource "azurerm_linux_virtual_machine" "vm_applicatif-vm" {
  name                = "vm-applicatif-vm"
  resource_group_name = azurerm_resource_group.rg_applicatif_vm.name
  location            = azurerm_resource_group.rg_applicatif_vm.location
  size                = var.vm_size
  admin_username      = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.vm_applicatif_vm_nic_1.id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = var.public_rsa
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

}

output "private_ip" {
  value = var.vm_ip
}