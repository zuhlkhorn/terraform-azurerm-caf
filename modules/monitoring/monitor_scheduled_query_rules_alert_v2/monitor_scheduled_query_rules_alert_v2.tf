resource "azurerm_monitor_scheduled_query_rules_alert_v2" "alert_v2" {
  name                = var.settings.name
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = try(var.settings.evaluation_frequency, null)
  window_duration      = var.settings.window_duration
  scopes               = var.settings.scopes
  severity             = var.settings.severity

  criteria {
    query                   = var.settings.criteria.query
    time_aggregation_method = var.settings.criteria.time_aggregation_method
    threshold               = var.settings.criteria.threshold
    operator                = var.settings.criteria.operator

    resource_id_column    = try(var.settings.criteria.resource_id_column, null)
    metric_measure_column = try(var.settings.criteria.metric_measure_column, null)

    dynamic "dimension" {
      for_each = try(var.settings.criteria.dimension, [])

      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = dimension.value.values
      }
    }

    dynamic "failing_periods" {
      for_each = try(var.settings.criteria.failing_periods, [])

      content {
        minimum_failing_periods_to_trigger_alert = failing_periods.value.minimum_failing_periods_to_trigger_alert
        number_of_evaluation_periods             = failing_periods.value.number_of_evaluation_periods
      }
    }
  }

  auto_mitigation_enabled          = try(var.settings.auto_mitigation_enabled, false)
  workspace_alerts_storage_enabled = try(var.settings.workspace_alerts_storage_enabled, false)
  description                      = try(var.settings.description, null)
  display_name                     = try(var.settings.display_name, null)
  enabled                          = try(var.settings.enabled, true)
  mute_actions_after_alert_duration= try(var.settings.mute_actions_after_alert_duration, null)
  query_time_range_override        = try(var.settings.query_time_range_override, null)
  skip_query_validation            = try(var.settings.skip_query_validation, false)

  dynamic "action" {
    for_each = try(var.settings.action, [])

    content {
      action_groups     = try(action.value.action_groups, [])
      custom_properties = try(action.value.custom_properties, {})
    }
  }

  tags = local.tags
  target_resource_types = try(var.settings.target_resource_types, null)
}