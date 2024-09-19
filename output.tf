# output.tf

output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.publicip.ip_address
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_virtual_machine.main.name
}

output "frontdoor_hostname" {
  description = "The hostname of the Azure Front Door"
  value       = azurerm_frontdoor.main.frontend_endpoint[0].host_name
}