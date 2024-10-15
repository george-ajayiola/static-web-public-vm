resource "azurerm_linux_virtual_machine" "main" {
  name                = "static-web-vm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.vmnic.id]

  custom_data = filebase64("postdeploy.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/devazurekey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
