module "config" {
  source = "./modules/config-templating"

  starter_locations               = var.starter_locations
  starter_locations_short         = var.starter_locations_short
  subscription_id_connectivity    = var.subscription_ids["connectivity"]
  subscription_id_identity        = try(var.subscription_ids["identity"], "")
  subscription_id_management      = var.subscription_ids["management"]
  subscription_id_security        = try(var.subscription_ids["security"], "")
  root_parent_management_group_id = var.root_parent_management_group_id

  custom_replacements = local.custom_replacements

  inputs = {
    connectivity_resource_groups    = var.connectivity_resource_groups
    hub_and_spoke_networks_settings = var.hub_and_spoke_networks_settings
    hub_virtual_networks            = var.hub_virtual_networks
    virtual_wan_settings            = var.virtual_wan_settings
    virtual_hubs                    = var.virtual_hubs
    management_resource_settings    = var.management_resource_settings
    management_group_settings       = var.management_group_settings
    tags                            = var.tags
    connectivity_tags               = var.connectivity_tags
  }

  enable_telemetry = var.enable_telemetry
}

# Values kept out of this public repo. The pipeline sets them from secrets
# (TF_VAR_*), and they're merged into the custom names used in the tfvars.
locals {
  custom_replacements = merge(var.custom_replacements, {
    names = merge(var.custom_replacements.names, {
      defender_email_security_contact = var.security_contact_email
      apps_nonprod_virtual_network_id = "/subscriptions/${var.app_subscription_ids["nonprod"]}/resourceGroups/rg-apps-network-nonprod-$${starter_location_01}-001/providers/Microsoft.Network/virtualNetworks/vnet-apps-nonprod-$${starter_location_01}-001"
      apps_prod_virtual_network_id    = "/subscriptions/${var.app_subscription_ids["prod"]}/resourceGroups/rg-apps-network-prod-$${starter_location_01}-001/providers/Microsoft.Network/virtualNetworks/vnet-apps-prod-$${starter_location_01}-001"
    })
  })
}
