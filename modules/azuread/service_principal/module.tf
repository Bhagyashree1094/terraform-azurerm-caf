
resource "azuread_service_principal" "app" {
  application_id               = var.application_id
  app_role_assignment_required = try(var.settings.app_role_assignment_required, false)
  tags                         = try(var.settings.tags, null)
  
  owners = concat(
    try(var.settings.owners, []),
    [
      var.client_config.object_id
    ]
  )

  # lifecycle {
  #   ignore_changes = [application_id]
  # }
}

resource "time_sleep" "propagate_to_azuread" {
  depends_on = [azuread_service_principal.app]

  create_duration = "30s"
}