variable "rsa_publique" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjwqaeL/mSX9JCexscnTyLIh94xYZA2YhZjMQ+9hPXLdZzbPl+BOL7Piwf0W+P96SPQXIO001DCc9uetdx74NuyAJocrcJ1E5dw6eC7mtsTaQw4g6a5ut1cVykxvjIYevfKasHK29+7jK5XGG9om+CphadcV3PZ2fWWI77RgCjuRLGSpRrEm+NCEpIaDpg7g1XXx+1vvorZM3n35Bq+XsaCFsAWStQPwQkIP88yKM+b6RRTcVawzpB0e91leUAWuqdYqUhtJOGUdaXkjqkUc/M7eukJph6SCOEVXxE5lnP2n5Ats+mt1XrG8eqOTenXQ7Z/UcX2VWf6JpNBlh8XOpW0jqR+AMbA+iwZKZ0Jic4ltRcN1AjqQ6uu+8pxfLuXhC7iWGlN1sYPAj8PCVKGPCUNleyygYPU0i5BD/qQjReyQKUO0EHzWCxHSUZjrst4wkFHe1xByfcy0fcWwvQxWwO+8P/WHbpzhAFyfHAELdw07mAtzOtRpYUTcmKtrLJAIs="
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
  subscription_id = "5384af96-54c6-4e2b-8169-a887ddbac33b"
}

# Create a resource group
resource "azurerm_resource_group" "rg_inf1430_exemple" {
  name     = "rg_inf1430_exemple"
  location = "Canada Central"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet_inf1430_exemple" {
  name                = "vnet_inf1430_exemple"
  address_space       = ["192.168.0.0/20"]
  location            = azurerm_resource_group.rg_inf1430_exemple.location
  resource_group_name = azurerm_resource_group.rg_inf1430_exemple.name
}

resource "azurerm_subnet" "vnet_sub1_exemple" {
  name                 = "vnet_sub1_exemple"
  resource_group_name  = azurerm_resource_group.rg_inf1430_exemple.name
  virtual_network_name = azurerm_virtual_network.vnet_inf1430_exemple.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource "azurerm_public_ip" "vm_exemple_public_ip" {
  name                = "vm_exemple_public_ip"
  resource_group_name = azurerm_resource_group.rg_inf1430_exemple.name
  location            = azurerm_resource_group.rg_inf1430_exemple.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_exemple_nic_1" {
  name                = "vm_exemple_nic_1"
  location            = azurerm_resource_group.rg_inf1430_exemple.location
  resource_group_name = azurerm_resource_group.rg_inf1430_exemple.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet_sub1_exemple.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_exemple_public_ip.id
  }
}

resource "azurerm_network_security_group" "nsg_exemple" {
  name                = "nsg_exemple"
  location            = azurerm_resource_group.rg_inf1430_exemple.location
  resource_group_name = azurerm_resource_group.rg_inf1430_exemple.name

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
  network_interface_id      = azurerm_network_interface.vm_exemple_nic_1.id
  network_security_group_id = azurerm_network_security_group.nsg_exemple.id
}

resource "azurerm_linux_virtual_machine" "vm_exemple_01" {
  name                = "vm-exemple-01"
  resource_group_name = azurerm_resource_group.rg_inf1430_exemple.name
  location            = azurerm_resource_group.rg_inf1430_exemple.location
  size                = var.vm_size
  admin_username      = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.vm_exemple_nic_1.id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = var.rsa_publique
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
  value = azurerm_public_ip.vm_exemple_public_ip.ip_address
}