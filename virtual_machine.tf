resource "azurerm_virtual_machine" "main" {
  name                  = "nginx-static-web-vm"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vmnic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  
}

resource "azurerm_virtual_machine_extension" "custom_script" {
  name                 = "custom-script-extension"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "fileUris": [
        "https://postdeploymentvm.blob.core.windows.net/nginx-vm-customscript/postdeploy.sh?sp=r&st=2024-09-18T22:54:41Z&se=2024-09-19T06:54:41Z&spr=https&sv=2022-11-02&sr=b&sig=EXUj2yPA71niHTSc8ccPbVuM11sq8mPwBfYfPJfoOyk%3D"
      ],
      "commandToExecute": "bash postdeploy.sh"
    }
SETTINGS

  depends_on = [azurerm_virtual_machine.main]
}
