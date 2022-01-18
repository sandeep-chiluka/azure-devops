#Azure Generic vNet Module
data azurerm_resource_group "vm" {
  name = var.resource_group_name
}

resource "azurerm_linux_virtual_machine" "vm-linux" {
  count = var.count_value ? var.count_value : 1
  name                = "${var.Name}-vmlinux-${count.index}"
  resource_group_name =  data.azurerm_resource_group.vm.name
  location            = coalesce(var.location, data.azurerm_resource_group.vm.location)
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [element(azurerm_network_interface.vm.*.id, count.index)]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.file_path)
  }

  os_disk {
  caching              = var.os_disk_caching
  storage_account_type = var.os_disk_storage_account_type
}

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "vm" {
  count               = var.count_value
  name                = "${var.Name}-pip-${count.index}"
  resource_group_name = data.azurerm_resource_group.vm.name
  location            = coalesce(var.location, data.azurerm_resource_group.vm.location)
  allocation_method   = var.allocation_method
  sku                 = var.public_ip_sku
  domain_name_label   = element(var.public_ip_dns, count.index)
  tags                = var.tags
}

// Dynamic public ip address will be got after it's assigned to a vm
data "azurerm_public_ip" "vm" {
  count               = var.count_value
  name                = azurerm_public_ip.vm[count.index].name
  resource_group_name = data.azurerm_resource_group.vm.name
  depends_on          = [azurerm_linux_virtual_machine.vm-linux]
}

resource "azurerm_network_interface" "vm" {
  count                         = var.count_value
  name                          = "${var.Name}-nic-${count.index}"
  resource_group_name           = data.azurerm_resource_group.vm.name
  location                      = coalesce(var.location, data.azurerm_resource_group.vm.location)
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "${var.Name}-ip-${count.index}"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = length(azurerm_public_ip.vm.*.id) > 0 ? element(concat(azurerm_public_ip.vm.*.id, tolist([""])), count.index) : ""
  }

  tags = var.tags
}

# resource "azurerm_network_interface_security_group_association" "test" {
#   count                     = var.count_value
#   network_interface_id      = azurerm_network_interface.vm[count.index].id
#   network_security_group_id = var.security_group_id
# }
