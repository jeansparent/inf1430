# Variables
variable "subscription_id" {
  type = string
}

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Create a resource group
resource "azurerm_resource_group" rg_vnet {
  name     = "rg-inf1430-vnet"
  location = "Canada Central"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-inf1430"
  address_space       = ["192.168.0.0/20"]
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_subnet" "vnet_sub1" {
  name                 = "vnet-sub1"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/24"]
}

# Adresse publique pour le NAT gateway
resource "azurerm_public_ip" "nat_public_ip" {
  name                = "nat-public-ip"
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "vnet_nat" {
  name                    = "nat-gateway"
  location                = azurerm_resource_group.rg_vnet.location
  resource_group_name     = azurerm_resource_group.rg_vnet.name
}

# Associer l'IP publique avec le NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "ip_nat" {
  nat_gateway_id       = azurerm_nat_gateway.vnet_nat.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

# Associer le NAT gateway avec un subnet
resource "azurerm_subnet_nat_gateway_association" "nat_subnet" {
  subnet_id      = azurerm_subnet.vnet_sub1.id
  nat_gateway_id = azurerm_nat_gateway.vnet_nat.id
}