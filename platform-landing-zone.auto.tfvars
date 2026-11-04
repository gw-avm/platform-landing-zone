/*
--- Built-in Replacements ---
This file contains built-in replacements to avoid repeating the same hard-coded values.
Replacements are denoted by the dollar-dollar curly braces token (e.g. $${starter_location_01}). The following details each built-in replacements that you can use:
`starter_location_01`: This is the primary Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_02` to `starter_location_##`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
`starter_location_01_short`: Short code for the primary Azure location. Defaults to the region geo_code, or short_name if no geo_code is available. Can be overridden via the starter_locations_short variable.
`starter_location_02_short` to `starter_location_##_short`: Short codes for the secondary Azure locations. Same behavior and override rules as starter_location_01_short.
`root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
`subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_ids`.
`subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_ids`.
`subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_ids`.
`subscription_id_security`: The subscription ID of the subscription to deploy the security resources to, sourced from the variable `subscription_ids`.
*/

/*
--- Starter Locations ---
You can define the Azure regions to use throughout the configuration.
The first location will be used as the primary location, the second as the secondary location, and so on.
*/
# East Asia: the only region where the app subscriptions get B-series VM quota.
# Hong Kong has no UK adequacy decision - test data only (ISO 27001 A.5.31, A.5.34).
starter_locations = ["eastasia"]

/*
--- Custom Replacements ---
You can define custom replacements to use throughout the configuration.
*/
custom_replacements = {
  /*
  --- Custom Name Replacements ---
  You can define custom names and other strings to use throughout the configuration.
  You can only use the built in replacements in this section.
  NOTE: You cannot refer to another custom name in this variable.
  */
  names = {
    # Defender email security contact
    defender_email_security_contact = "graemewales13@gmail.com"

    # Resource provisioning global connectivity
    #
    # SECURITY RISK: A DDoS Network Protection Plan is a recommended security
    # control for public-facing services. Disabling it without an alternative may
    # leave your applications and workloads vulnerable to DDoS attacks. You should
    # weigh up the pros and cons before deciding to disable the DDoS Network
    # Protection Plan and also consider how you will protect your applications and
    # services without it. You may decide the DDoS IP Protection offering
    # per-Public IP is a suitable option, or an alternative solution.
    # See: https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison
    #
    ddos_protection_plan_enabled = false

    # Resource provisioning primary connectivity
    # Firewall (~GBP 230/month) and VPN gateway (~GBP 280/month) are off to
    # keep a test landing zone affordable. Spokes route straight to the
    # internet - an accepted risk to record in the risk register.
    primary_firewall_enabled                              = false
    primary_firewall_sku_tier                             = "Basic"
    primary_virtual_network_gateway_express_route_enabled = false
    primary_virtual_network_gateway_vpn_enabled           = false
    primary_private_dns_zones_enabled                     = false
    primary_private_dns_auto_registration_zone_enabled    = false
    primary_private_dns_resolver_enabled                  = false
    primary_bastion_enabled                               = false

    # CAF naming: <type>-<workload>-<component>-<environment>-<region>-<###>
    # with CAF abbreviations (rg, log, id, dcr). Region in full.

    # Resource group names
    management_resource_group_name               = "rg-management-prod-$${starter_location_01}-001"
    connectivity_hub_primary_resource_group_name = "rg-connectivity-hub-prod-$${starter_location_01}-001"
    dns_resource_group_name                      = "rg-connectivity-dns-prod-$${starter_location_01}-001"
    ddos_resource_group_name                     = "rg-connectivity-ddos-prod-$${starter_location_01}-001"
    # Policy creates these two in every subscription under alz with the same
    # name, so they carry no workload or environment.
    asc_export_resource_group_name            = "rg-mdfcexport-$${starter_location_01}-001"
    service_health_alerts_resource_group_name = "rg-servicehealth-$${starter_location_01}-001"

    # Resource names management
    log_analytics_workspace_name            = "log-management-prod-$${starter_location_01}-001"
    ddos_protection_plan_name               = "ddos-connectivity-prod-$${starter_location_01}-001"
    ama_user_assigned_managed_identity_name = "id-ama-prod-$${starter_location_01}-001"
    dcr_change_tracking_name                = "dcr-changetracking-prod-$${starter_location_01}-001"
    dcr_defender_sql_name                   = "dcr-defendersql-prod-$${starter_location_01}-001"
    dcr_vm_insights_name                    = "dcr-vminsights-prod-$${starter_location_01}-001"

    # IP Ranges Primary
    # Regional Address Space: 10.0.0.0/16
    primary_hub_address_space = "10.0.0.0/16"
  }

  /*
  --- Custom Resource Group Identifier Replacements ---
  You can define custom resource group identifiers to use throughout the configuration.
  You can only use the templated variables and custom names in this section.
  NOTE: You cannot refer to another custom resource group identifier in this variable.
  */
  resource_group_identifiers = {
    management_resource_group_id           = "/subscriptions/$${subscription_id_management}/resourcegroups/$${management_resource_group_name}"
    ddos_protection_plan_resource_group_id = "/subscriptions/$${subscription_id_connectivity}/resourcegroups/$${ddos_resource_group_name}"
    primary_connectivity_resource_group_id = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/$${connectivity_hub_primary_resource_group_name}"
    dns_resource_group_id                  = "/subscriptions/$${subscription_id_connectivity}/resourceGroups/$${dns_resource_group_name}"
  }

  /*
  --- Custom Resource Identifier Replacements ---
  You can define custom resource identifiers to use throughout the configuration.
  You can only use the templated variables, custom names and customer resource group identifiers in this variable.
  NOTE: You cannot refer to another custom resource identifier in this variable.
  */
  resource_identifiers = {
    ama_change_tracking_data_collection_rule_id = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_change_tracking_name}"
    ama_mdfc_sql_data_collection_rule_id        = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_defender_sql_name}"
    ama_vm_insights_data_collection_rule_id     = "$${management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/$${dcr_vm_insights_name}"
    ama_user_assigned_managed_identity_id       = "$${management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/$${log_analytics_workspace_name}"
    ddos_protection_plan_id                     = "$${ddos_protection_plan_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/$${ddos_protection_plan_name}"
  }
}

/*
--- Tags ---
This variable can be used to apply tags to all resources that support it. Some resources allow overriding these tags.
*/
# CAF tagging (learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging):
# lowercase keys, consistent lowercase values, no personal or sensitive data.
tags = {
  app             = "platform-landing-zone"
  env             = "prod"
  region          = "$${starter_location_01}"
  criticality     = "mission-critical"
  confidentiality = "private"
  businessunit    = "shared"
  opsteam         = "platform"
  repo            = "https://github.com/gw-avm/platform-landing-zone"
  deployed_by     = "terraform"
}

/*
--- Management Resources ---
You can use this section to customize the management resources that will be deployed.
*/
management_resources_enabled = true

management_resource_settings = {
  location                     = "$${starter_location_01}"
  log_analytics_workspace_name = "$${log_analytics_workspace_name}"
  # Cost guardrail: ingestion stops for the rest of the day at 0.5 GB
  # (normal use is a few MB/day). Hitting it drops logs, so raise it before
  # onboarding real workloads (ISO 27001 A.8.15).
  log_analytics_workspace_daily_quota_gb = 0.5
  resource_group_name                    = "$${management_resource_group_name}"
  user_assigned_managed_identities = {
    ama = {
      name = "$${ama_user_assigned_managed_identity_name}"
    }
  }
  data_collection_rules = {
    change_tracking = {
      name = "$${dcr_change_tracking_name}"
    }
    defender_sql = {
      name = "$${dcr_defender_sql_name}"
    }
    vm_insights = {
      name = "$${dcr_vm_insights_name}"
    }
  }
}

/*
--- Management Groups and Policy ---
You can use this section to customize the management groups and policies that will be deployed.
You can further configure management groups and policy by supplying a `lib` folder. This is detailed in the Accelerator documentation.
*/
management_groups_enabled = true

management_group_settings = {
  # This is the name of the architecture that will be used to deploy the management resources.
  # It refers to the alz_custom.alz_architecture_definition.yaml file in the lib folder.
  # Do not change this value unless you have created another architecture definition
  # with the name value specified below.
  architecture_name  = "alz_custom"
  location           = "$${starter_location_01}"
  parent_resource_id = "$${root_parent_management_group_id}"
  policy_default_values = {
    ama_change_tracking_data_collection_rule_id = "$${ama_change_tracking_data_collection_rule_id}"
    ama_mdfc_sql_data_collection_rule_id        = "$${ama_mdfc_sql_data_collection_rule_id}"
    ama_vm_insights_data_collection_rule_id     = "$${ama_vm_insights_data_collection_rule_id}"
    ama_user_assigned_managed_identity_id       = "$${ama_user_assigned_managed_identity_id}"
    ama_user_assigned_managed_identity_name     = "$${ama_user_assigned_managed_identity_name}"
    log_analytics_workspace_id                  = "$${log_analytics_workspace_id}"
    #ddos_protection_plan_id                     = "$${ddos_protection_plan_id}"
    #private_dns_zone_subscription_id            = "$${subscription_id_connectivity}"
    #private_dns_zone_region                     = "$${starter_location_01}"
    #private_dns_zone_resource_group_name        = "$${dns_resource_group_name}"
    resource_group_name_service_health_alerts = "$${service_health_alerts_resource_group_name}"
    resource_group_name_mdfc                  = "$${asc_export_resource_group_name}"
    resource_group_location                   = "$${starter_location_01}"
    email_security_contact                    = "$${defender_email_security_contact}"
    /*
    # Example of allowed locations for Sovereign Landing Zones policies
    allowed_locations = [
      "$${starter_location_01}"
    ]
    */
  }
  subscription_placement = {
    # Uncomment the identity block below when you have a dedicated identity subscription
    # identity = {
    #   subscription_id       = "$${subscription_id_identity}"
    #   management_group_name = "identity"
    # }
    connectivity = {
      subscription_id       = "$${subscription_id_connectivity}"
      management_group_name = "connectivity"
    }
    management = {
      subscription_id       = "$${subscription_id_management}"
      management_group_name = "management"
    }
    # Uncomment the security block below when you have a dedicated security subscription
    # security = {
    #   subscription_id       = "$${subscription_id_security}"
    #   management_group_name = "security"
    # }
  }
  policy_assignments_to_modify = {
    alz = {
      policy_assignments = {
        # Paid Defender plans off (cost). The free foundational CSPM still
        # runs; switch a plan back to "DeployIfNotExists" to enable it.
        Deploy-MDFC-Config-H224 = {
          parameters = {
            enableAscForServers                         = "Disabled"
            enableAscForServersVulnerabilityAssessments = "Disabled"
            enableAscForSql                             = "Disabled"
            enableAscForAppServices                     = "Disabled"
            enableAscForStorage                         = "Disabled"
            enableAscForContainers                      = "Disabled"
            enableAscForKeyVault                        = "Disabled"
            enableAscForSqlOnVm                         = "Disabled"
            enableAscForArm                             = "Disabled"
            enableAscForOssDb                           = "Disabled"
            enableAscForCosmosDbs                       = "Disabled"
            enableAscForCspm                            = "Disabled"
            enableAscForAI                              = "Disabled"
          }
        }
        # These enable paid Defender for SQL / open-source DBs on each database
        # server. DoNotEnforce keeps the compliance report without deploying them.
        Deploy-MDFC-SqlAtp = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-MDFC-OssDb = {
          enforcement_mode = "DoNotEnforce"
        }
        # The default action group only notifies subscription Owners, which
        # here is terraform-admin with no mailbox. The whole object is replaced,
        # so the unused receivers stay as empty values.
        Deploy-SvcHealth-BuiltIn = {
          parameters = {
            actionGroupResources = {
              actionGroupEmail    = ["$${defender_email_security_contact}"]
              eventHubResourceId  = []
              functionResourceId  = ""
              functionTriggerUrl  = ""
              logicappCallbackUrl = ""
              logicappResourceId  = ""
              webhookServiceUri   = []
            }
          }
        }
      }
    }
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          creation_enabled = false
        }
      }
    }
    landingzones = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          creation_enabled = false
        }
      }
    }
    corp = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {
          creation_enabled = false
        }
      }
    }
  }
  /*
  # Example of how to add management group role assignments
  management_group_role_assignments = {
    root_owner_role_assignment = {
      management_group_name      = "root"
      role_definition_id_or_name = "Owner"
      principal_id               = "00000000-0000-0000-0000-000000000000"
    }
  }
  */
  # role_assignment_name_use_random_uuid = false  # Uncomment this for backwards compatibility with previous naming convention
}

/*
--- Connectivity - Hub and Spoke Virtual Network ---
You can use this section to customize the hub virtual networking that will be deployed.
*/
connectivity_type = "hub_and_spoke_vnet"

connectivity_resource_groups = {
  ddos = {
    name     = "$${ddos_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = "$${ddos_protection_plan_enabled}"
    }
  }
  vnet_primary = {
    name     = "$${connectivity_hub_primary_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = true
    }
  }
  dns = {
    name     = "$${dns_resource_group_name}"
    location = "$${starter_location_01}"
    settings = {
      enabled = "$${primary_private_dns_zones_enabled}"
    }
  }
}

hub_and_spoke_networks_settings = {
  enabled_resources = {
    ddos_protection_plan = "$${ddos_protection_plan_enabled}"
  }
  ddos_protection_plan = {
    name                = "$${ddos_protection_plan_name}"
    resource_group_name = "$${ddos_resource_group_name}"
    location            = "$${starter_location_01}"
  }
}

hub_virtual_networks = {
  primary = {
    location                  = "$${starter_location_01}"
    default_parent_id         = "$${primary_connectivity_resource_group_id}"
    default_hub_address_space = "$${primary_hub_address_space}"
    hub_virtual_network = {
      name = "vnet-connectivity-hub-prod-$${starter_location_01}-001"
    }
    enabled_resources = {
      firewall                              = "$${primary_firewall_enabled}"
      bastion                               = "$${primary_bastion_enabled}"
      virtual_network_gateway_express_route = "$${primary_virtual_network_gateway_express_route_enabled}"
      virtual_network_gateway_vpn           = "$${primary_virtual_network_gateway_vpn_enabled}"
      private_dns_zones                     = "$${primary_private_dns_zones_enabled}"
      private_dns_resolver                  = "$${primary_private_dns_resolver_enabled}"
    }
    firewall = {
      sku_tier = "$${primary_firewall_sku_tier}"
    }
    firewall_policy = {
      sku = "$${primary_firewall_sku_tier}"
    }
    private_dns_zones = {
      parent_id = "$${dns_resource_group_id}"
    }
  }
}

# private_link_private_dns_zone_virtual_network_link_moved_blocks_enabled = true

enable_telemetry = true
telemetry_additional_content = {
  deployed_by    = "alz-terraform-accelerator"
  correlation_id = "00000000-0000-0000-0000-000000000000"
}
