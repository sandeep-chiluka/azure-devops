variable "Name" {
  description = "Name of the vnet to create"
  type = string
}

variable "count_value" {
  type = number
  default = "1"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
  default     = ""
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Specifies the admin username of the virtual machine."
  type        = string
  default     = "adminuser"
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "(Optional) Enable accelerated networking on Network interface."
  default     = false
}

variable "vnet_subnet_id" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type        = string
}

variable "allocation_method" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  type        = string
  default     = "Dynamic"
}

variable "public_ip_sku" {
  description = "Defines the SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  type        = string
  default     = "Basic"
}

variable "public_ip_dns" {
  description = "Optional globally unique per datacenter region domain name label to apply to each public ip address. e.g. thisvar.varlocation.cloudapp.azure.com where you specify only thisvar here. This is an array of names which will pair up sequentially to the number of public ips defined in var.nb_public_ip. One name or empty string is required for every public ip. If no public ip is desired, then set this to an array with a single empty string."
  type        = list(string)
  default     = [null]
}

variable "security_group_id" {
  description = "A list of public SG inside the vNet."
  type        = list(string)ss
}

variable "file_path" {
  type        = string
}
