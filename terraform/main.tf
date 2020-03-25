provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
}
data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rgid" {
  name     = "rg${local.alias}"
  location = local.region
}
resource "azurerm_container_registry" "acr" {
  name                     = "acr${local.alias}01"
  location                 = azurerm_resource_group.rgid.location
  resource_group_name      = azurerm_resource_group.rgid.name
  sku                      = "Basic"
  admin_enabled            = true
}
resource "azurerm_virtual_network" "vnetid" {
  name                = "vnet${local.alias}"
  location            = azurerm_resource_group.rgid.location
  resource_group_name = azurerm_resource_group.rgid.name
  address_space       = ["11.0.0.0/16"]

  subnet {
    name           = "default"
    address_prefix = "11.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "11.0.2.0/24"
  }
}

resource "azurerm_kubernetes_cluster" "aksid" {
  name                = "aks${local.alias}pe"
  location            = azurerm_resource_group.rgid.location
  resource_group_name = azurerm_resource_group.rgid.name
  dns_prefix          = "aks${local.alias}pe"

  default_node_pool {
    name            = "default"
    node_count      = local.workers
    vm_size         = local.instancia
    min_count       = local.workers
    max_count       = 5
    os_disk_size_gb = 30
    type            = "VirtualMachineScaleSets"
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = true
    vnet_subnet_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.rgid.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.vnetid.name}/subnets/default"
  }

  service_principal {
    client_id     = local.clientid
    client_secret = local.clientsecret
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "Production"
  }
}
