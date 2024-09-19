locals {
  front_door_name                         = "nginxportfolioweb"
  front_door_frontend_endpoint_name       = "frontEndEndpoint"
  front_door_load_balancing_settings_name = "loadBalancingSettings"
  front_door_health_probe_settings_name   = "healthProbeSettings"
  front_door_routing_rule_name            = "routingRule"
  front_door_backend_pool_name            = "backendPool"
}

resource "azurerm_frontdoor" "main" {
  name                = local.front_door_name
  resource_group_name = data.azurerm_resource_group.rg.name

  routing_rule {
    name               = local.front_door_routing_rule_name
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = [local.front_door_frontend_endpoint_name]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = local.front_door_backend_pool_name
    }
  }

  backend_pool_load_balancing {
    name = local.front_door_load_balancing_settings_name
  }

  backend_pool_health_probe {
    name = local.front_door_health_probe_settings_name
    protocol = "Http"
    path     = "/"
    interval_in_seconds = 30
  }

  backend_pool {
    name = local.front_door_backend_pool_name
    backend {
      host_header = azurerm_public_ip.publicip.ip_address
      address     = azurerm_public_ip.publicip.ip_address
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = local.front_door_load_balancing_settings_name
    health_probe_name   = local.front_door_health_probe_settings_name
  }

  frontend_endpoint {
    name      = local.front_door_frontend_endpoint_name
    host_name = "${local.front_door_name}.azurefd.net"  
  }

   depends_on = [
    azurerm_virtual_machine.main,  # VM dependency
    azurerm_public_ip.publicip          # Public IP dependency
  ]
}
