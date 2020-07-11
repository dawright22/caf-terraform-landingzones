variable launchpad_mode {
  default = "launchpad_light"

  validation {
    condition     = contains(["launchpad_light", "launchpad"], var.launchpad_mode)
    error_message = "Allowed values are launchpad_light or launchpad."
  }
}

variable level {
  default = "level0"

  validation {
    condition     = contains(["level0", "level1", "level2", "level3", "level4"], var.level)
    error_message = "Allowed values are level0, level1, level2, level3 or level4."
  }
}

variable global_settings {
  default = {
    default_location  = "southeastasia"
    convention        = "cafrandom"
  }

  validation {
    condition     = contains(["cafrandom", "random", "passthrough", "cafclassic"], var.global_settings.convention)
    error_message = "Convention allowed values are cafrandom, random, passthrough or cafclassic."
  }
}

# Do not change the default value to be able to upgrade to the standard launchpad
variable "tf_name" {
  description = "Name of the terraform state in the blob storage (Does not include the extension .tfstate)"
  default     = "launchpad"
}

variable resource_groups {
  default = {
      tfstate     = {
        name      = "launchpad-tfstates"
        location  = "southeastasia"
      }
      security    = {
        name      = "launchpad-security"
      }
      gitops      = {
        name      = "launchpad-devops-agents"
      }
      networking  = {
        name      = "launchpad-networking"
      }
  }
}

variable storage_account_name {
  type    = string
  default = "level0"
}

# variable "prefix" {
#   description = "(Optional) (Default = null) Generate a prefix that will be used to prepend all resources names"
#   default     = null
# }


variable keyvaults {
  default = {
    # Do not rename the key "launchpad" to be able to upgrade to the standard launchpad
    launchpad = {
      name                = "launchpad"
      resource_group_key  = "security"
      region              = "southeastasia"
      convention          = "cafrandom"
      sku_name            = "standard"
    }
  }
}

variable subscriptions {
  default = {
    logged_in_subscription = {
      role_definition_name = "Owner"
      aad_app_key          = "caf_launchpad_level0"
    }
  }
}

variable aad_apps {
  default = {
    # Do not rename the key "launchpad" to be able to upgrade to the standard launchpad
    caf_launchpad_level0 = {
      convention              = "cafrandom"
      useprefix               = true
      application_name        = "caf_launchpad_level0"
      password_expire_in_days = 180
      keyvault = {
        keyvault_key  = "launchpad"
        secret_prefix = "caf-launchpad-level0"
        access_policies = {
          key_permissions    = []
          secret_permissions = ["Get", "List", "Set", "Delete"]
        }
      }
    }
  }
}

variable launchpad_key_names {
  default = {
    keyvault    = "launchpad"
    aad_app     = "caf_launchpad_level0"
    networking  = "networking_gitops"
  }
}

variable custom_role_definitions {
  default = {}
}

variable tags {
  type    = map
  default = {}
}

variable rover_version {}

variable user_type {}

variable logged_user_objectId {}

variable aad_users {
  default = {}
}

variable aad_roles {
  default = {}
}

variable aad_api_permissions {
  default = {}
}

variable github_projects {
  default = {}
}

variable azure_devops {
  default = {}
}

variable environment {
  type        = string
  description = "This variable is set by the rover during the deployment based on the -env or -environment flags. Default to sandpit"
  default     = "Sandpit"
}

variable blueprint_networking {
  default = {}
}

variable diagnostics_settings {
  default = {
    resource_diagnostics_name         = "diag"
    azure_diagnostics_logs_event_hub  = false
    resource_group_key                = "gitops"
  }
}

variable log_analytics {
  default = {
    resource_log_analytics_name       = "logs"
    resource_group_key                = "gitops"
    solutions_maps = {
      KeyVaultAnalytics = {
        "publisher" = "Microsoft"
        "product"   = "OMSGallery/KeyVaultAnalytics"
      }
    }
  }
}

variable networking {
  default = {
    networking_gitops = {
      resource_group_key  = "networking"

      vnet = {
        name                = "gitops-vnet"
        address_space       = ["192.168.100.0/24"] 
        dns                 = []
      }

      specialsubnets     = {}

      subnets = {
        level0        = {
          name                = "level0"
          cidr                = "192.168.100.16/29"
          service_endpoints   = []
          nsg_inbound         = [
            # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
            ["ssh_internet", "150", "Inbound", "Allow", "*", "*", "22", "*", "*"],       # Temp until bastion + vwan in place.
            ["ssh", "200", "Inbound", "Allow", "*", "*", "22", "192.168.200.8/29", "*"],
          ]
          nsg_outbound        = []
        }
      }

      diags = {
        log = [
          # ["Category name", "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
          ["VMProtectionAlerts", true, true, 5],
        ]
        metric = [
          #["Category name", "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
          ["AllMetrics", true, true, 2],
        ]
      }
    }
  }
}