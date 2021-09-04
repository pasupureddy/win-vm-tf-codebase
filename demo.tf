locals {
  created_by = "terraform"
  developer = "koti"
}

resource "azurerm_resource_group" "demo" {
  location = var.location
  name = "${var.prefix}-rg"

  tags = {
    created_by = local.created_by
    developer= local.developer
    env = var.env
  }
}

resource "azurerm_virtual_network" "main" {
  address_space = var.address_space
  location = azurerm_resource_group.demo.location
  name = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.demo.name

  tags = {
    created_by = local.created_by
    developer = local.developer
    env = var.env
  }
}

resource "azurerm_subnet" "public" {
  name = "${var.prefix}-public-subnet"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = var.address_prefix_public
}

resource "azurerm_subnet" "private" {
  name = "${var.prefix}-private-subnet"
  resource_group_name = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = var.address_prefix_private
}

resource "azurerm_network_interface" "main" {
  location = azurerm_resource_group.demo.location
  name = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.demo.name
  ip_configuration {
    name = "${var.prefix}-pip"
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.public.id
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_security_group" "main" {
  location = azurerm_resource_group.demo.location
  name = "${var.prefix}-nsg"
  resource_group_name = azurerm_resource_group.demo.name

  tags = {
    created_by = local.created_by
    developer = local.developer
    env = var.env
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_public_ip" "main" {
  allocation_method = "Dynamic"
  location = azurerm_resource_group.demo.location
  name = "${var.prefix}-pubip"
  resource_group_name = azurerm_resource_group.demo.name

}

resource "azurerm_virtual_machine" "main" {
  location = azurerm_resource_group.demo.location
  name = "${var.prefix}-vm"
  network_interface_ids = [azurerm_network_interface.main.id]
  resource_group_name = azurerm_resource_group.demo.name

  vm_size = "Standard_B2s"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true

  storage_os_disk {
    create_option = "FromImage"
    name = "${var.prefix}-disk"
    managed_disk_type = "Standard_LRS"

  }
  storage_image_reference {
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "8_2"
    version = "latest"
  }
  os_profile {
    computer_name = "hostname"
    admin_username = "azureuser"
    admin_password = "Password@1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    created_by = local.created_by
    developer = local.developer
    env = var.env
  }
}

