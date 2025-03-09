# Variables
variable "subscription_id" {
  type = string
}

variable "public_rsa" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "vm_username" {
  type = string
  default = "administrateur"
}

variable "vm_ip" {
  type = string
  default = "192.168.0.10"
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
resource "azurerm_resource_group" rg_bastion {
  name     = "rg-inf1430-bastion"
  location = "Canada Central"
}

resource "azurerm_public_ip" "vnet_pip_bastion" {
  name                = "pip-bastion"
  resource_group_name = azurerm_resource_group.rg_bastion.name
  location            = azurerm_resource_group.rg_bastion.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_bastion_nic_1" {
  name                = "vm-bastion-nic-1"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.vnet_sub1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_ip
    public_ip_address_id          = azurerm_public_ip.vnet_pip_bastion.id
  }
}

resource "azurerm_network_security_group" "nsg_bastion" {
  name                = "nsg-vm-bastion"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_nic_association" {
  network_interface_id      = azurerm_network_interface.vm_bastion_nic_1.id
  network_security_group_id = azurerm_network_security_group.nsg_bastion.id
}

resource "azurerm_linux_virtual_machine" "vm_bastion_01" {
  name                = "vm-bastion"
  resource_group_name = azurerm_resource_group.rg_bastion.name
  location            = azurerm_resource_group.rg_bastion.location
  size                = var.vm_size
  admin_username      = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.vm_bastion_nic_1.id,
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

output "public_ip" {
  value = azurerm_public_ip.vnet_pip_bastion.ip_address
}