# Static Website Deployment on Azure Virtual Machine using Terraform

This repository contains documentation for deploying a static website on an Azure Virtual Machine (VM). The infrastructure is created using Infrastructure as Code (IaC) with Terraform, the website is served using the Nginx web server installed via a custom bash script on the VM and a CDN solution (Front Door) is used to front the public IP of the virtual machine..

## Architecture Overview

The infrastructure consists of:

- A Virtual Network (VNet) with a Subnet
- A Network Interface connected to the subnet
- A Virtual Machine provisioned with a Public IP
- A bash script to automatically install and configure Nginx on the VM
- A Network Security Group (NSG) allowing HTTP (port 80) traffic
- Azure Front Door service to provide a frontend to the VM Public IP


  ![Archi](INF_Screenshots/Archi.drawio.png)

   *Figure 1: Architecture .*

## Prerequisites

- An Azure account
- Terraform installed on your machine
- Bash script for Nginx installation 

## Step-by-Step Process

### 1. Terraform Configuration

The Terraform code is split into the following files for better modularity and readability:

- **provider.tf**: Specifies the Azure provider for Terraform.
- **resource_group.tf**: To use the resource group where all resources will reside.
- **network.tf**: Defines the Virtual Network and Subnet.
- **nic.tf**: Defines the network interface that connects the VM to the virtual network.
- **virtual_machine.tf**: Provisions the virtual machine and uses the bash script stored in Azure Blob Storage to install Nginx.
- **output.tf**: Outputs the public IP of the VM, allowing easy access to the static website.
- **front_door.tf**: Provisions Azure Front Door to front the public IP of the VM.

1.1. Running Terraform Commands
After configuring the Terraform files, run the following commands:
- ``terraform init``
- ``terraform validate``
- ``terraform apply``
  
  ![apply_tf1](INF_Screenshots/apply.png)
  *Figure 2: Terraform apply complete.*

  ![apply_tf](INF_Screenshots/resultofterraform_apply.png)
  *Figure 3: Terraform config result.*
  
## 2. Access the Static Website

Once Terraform completes the process, the public IP of the VM will be available in the output. Open the browser and navigate to the public IP to access the static website served by Nginx.


![apply_tf3](INF_Screenshots/vm.png)
*Figure 4: VM IP.*
  


![apply_tf4](INF_Screenshots/vm_ip.png)
*Figure 5: Website access from VM IP.*


## 3. Azure Front Door Configuration

Azure Front Door will be set up to front the public IP of the VM, allowing traffic management and enhanced security for the static website.

![afd1](INF_Screenshots/frontend_afd.png)

*Figure 6: Azure Front Door frontend endpoint.*

![afd](INF_Screenshots/AFD.png)

*Figure 7: Website access from Azure Front Door .*




