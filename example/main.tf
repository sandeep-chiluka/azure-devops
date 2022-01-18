module "RG" {
 source = "../modules/resource_group"

 resource_group_name = var.resource_group_name
}


resource "azurerm_network_security_group" "ssh" {
  name                = "ssh"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

module "vnet" {
  source              = "../modules/AZ_Virtual_network"
  Name                = "interview_assesment_vpn"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  nsg_ids = {
    subnet1 = azurerm_network_security_group.ssh.id
    subnet2 = azurerm_network_security_group.ssh.id
    subnet3 = azurerm_network_security_group.ssh.id
  }


  tags = {
    environment = "dev"
    costcenter  = "it"
    purpose     = "interview_assesment"
  }
}

output "subnet_ID" {
  value = module.vnet.vnet_subnets
}

module "linuxservers" {
  source              = "../modules/AZ_linux_vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  Name                = "Test"
  security_group_id   = [ azurerm_network_security_group.ssh.id ]
  file_path           = "/Users/pradeep/.ssh/azure.pub"
  vnet_subnet_id      = module.vnet.vnet_subnets[0]
}
