terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}
provider "azurerm" {
features {}
tenant_id="f5bb1277-3a7d-4263-92b3-b7d72fc834df"
client_id="3c26d8e3-fd60-473d-8024-a0ad9bf4fa5a"
client_secret="Aoh7Q~AXuiZfAsD7V4-fJyftd2aGQb-wU4qt~"
subscription_id="80826d76-468a-46e5-9960-66b8a8ae2d55"
}

terraform {
  backend "azurerm" {
    storage_account_name = "__terraformstorageaccount__"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "__storagekey__"
    features {}
  }
}

resource "azurerm_resource_group" "example1" {
  name     = "example1-rg"
  location = "EAST US 2"
}


resource "azurerm_virtual_network" "example1" {
  name                = "example1-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.example1.location
  resource_group_name = azurerm_resource_group.example1.name
}

resource "azurerm_subnet" "example1" {
  name                 = "example1-subnet"
  resource_group_name  = azurerm_resource_group.example1.name
  virtual_network_name = azurerm_virtual_network.example1.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_public_ip" "example1" {
  name                = "PubIP1"
  resource_group_name = azurerm_resource_group.example1.name
  location            = azurerm_resource_group.example1.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "example1" {
  name                = "example1-nic"
  location            = azurerm_resource_group.example1.location
  resource_group_name = azurerm_resource_group.example1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example1.id
          }


}


resource "azurerm_windows_virtual_machine" "example1" {
  name                = "example1-vm"
  resource_group_name = azurerm_resource_group.example1.name
  location            = azurerm_resource_group.example1.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "Siddiqm@64"
  network_interface_ids = [
    azurerm_network_interface.example1.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}

#######################################
# resource "azurerm_resource_group" "example2" {
#   name     = "example2-rg"
#   location = "WEST US 3"
# }


# resource "azurerm_virtual_network" "example2" {
#   name                = "example2-vnet"
#   address_space       = ["192.168.0.0/16"]
#   location            = azurerm_resource_group.example2.location
#   resource_group_name = azurerm_resource_group.example2.name
# }

# resource "azurerm_subnet" "example2" {
#   name                 = "example2-subnet"
#   resource_group_name  = azurerm_resource_group.example2.name
#   virtual_network_name = azurerm_virtual_network.example2.name
#   address_prefixes     = ["192.168.2.0/24"]
# }

# resource "azurerm_public_ip" "example2" {
#   name                = "PubIP1"
#   resource_group_name = azurerm_resource_group.example2.name
#   location            = azurerm_resource_group.example2.location
#   allocation_method   = "Dynamic"
# }

# resource "azurerm_network_interface" "example2" {
#   name                = "example2-nic"
#   location            = azurerm_resource_group.example2.location
#   resource_group_name = azurerm_resource_group.example2.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.example2.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.example2.id
#           }


# }


# resource "azurerm_windows_virtual_machine" "example2" {
#   name                = "example2-vm"
#   resource_group_name = azurerm_resource_group.example2.name
#   location            = azurerm_resource_group.example2.location
#   size                = "Standard_DS1_v2"
#   admin_username      = "adminuser"
#   admin_password      = "Siddiqm@64"
#   network_interface_ids = [
#     azurerm_network_interface.example2.id,
#   ]


#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#  source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2016-Datacenter"
#     version   = "latest"
#   }

# }