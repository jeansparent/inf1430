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

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Create a resource group
resource "azurerm_resource_group" rg_dev-env {
  name     = "rg-inf1430-dev-env"
  location = "Canada Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-inf1430-dev-env"
  address_space       = ["192.168.160.0/20"]
  location            = azurerm_resource_group.rg_dev-env.location
  resource_group_name = azurerm_resource_group.rg_dev-env.name
}

resource "azurerm_subnet" "vnet_sub1" {
  name                 = "vnet-sub1"
  resource_group_name  = azurerm_resource_group.rg_dev-env.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.160.0/24"]
}


resource "azurerm_public_ip" "vnet_pip_dev-vm" {
  name                = "pip-dev-vm"
  resource_group_name = azurerm_resource_group.rg_dev-env.name
  location            = azurerm_resource_group.rg_dev-env.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_dev-vm_nic_1" {
  name                = "vm-dev-vm-nic-1"
  location            = azurerm_resource_group.rg_dev-env.location
  resource_group_name = azurerm_resource_group.rg_dev-env.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet_sub1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vnet_pip_dev-vm.id
  }
}

resource "azurerm_network_security_group" "nsg_dev-vm" {
  name                = "nsg-vm-dev-vm"
  location            = azurerm_resource_group.rg_dev-env.location
  resource_group_name = azurerm_resource_group.rg_dev-env.name

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
  network_interface_id      = azurerm_network_interface.vm_dev-vm_nic_1.id
  network_security_group_id = azurerm_network_security_group.nsg_dev-vm.id
}

resource "azurerm_linux_virtual_machine" "vm_dev-vm_01" {
  name                = "vm-dev-vm-01"
  resource_group_name = azurerm_resource_group.rg_dev-env.name
  location            = azurerm_resource_group.rg_dev-env.location
  size                = var.vm_size
  admin_username      = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.vm_dev-vm_nic_1.id,
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
  value = azurerm_public_ip.vnet_pip_dev-vm.ip_address
}