
output "vm_name" {
  value = azurerm_virtual_machine.main.name
}

output "vm_ip" {
  value = azurerm_public_ip.main.ip_address
}