variable "location" {
  default = "eastasia"
}

variable "prefix" {
  description = "a prefix for your tf resource"
}

variable "address_space" {
  default = ["192.168.0.0/16"]
}

variable "address_prefix_private" {
  default = ["192.168.1.0/24"]
}

variable "address_prefix_public" {
  default = ["192.168.2.0/24"]
}

variable "env" {
  default =  "Dev"
}

