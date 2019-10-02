view: ticket_custom_fields {
  sql_table_name: analytics_common.zendesk_ticket_custom_fields ;;
  # this model now resides at https://github.com/Getaround/getaround-analytics/blob/master/dbt/models/common/zendesk_ticket_custom_fields.sql
  # This table updates with the Zendesk tag in dbt: https://cloud.getdbt.com/#/accounts/959/jobs/2763/


  dimension: ticket_id {
    description: "Zendesk ticket number"
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: getaround_car_id {
    alias: [car_id]
    description: "Getaround ID of the car this ticket relates to"
    label: "Getaround Car ID"
    type: string
    sql: ${TABLE}.value_car_id ;;
  }

  dimension: getaround_trip_id {
    alias: [trip_id]
    description: "Getaround ID of the trip this ticket relates to"
    label: "Getaround Trip ID"
    type: number
    sql: ${TABLE}.corrected_trip_id ;;
  }

  dimension: category_name {
    description: "Category dropdown full menu item name"
    type: string
    sql: ${TABLE}.value_category_name ;;
  }

  dimension: category_tag {
    description: "Category tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_category ;;
  }

  dimension: zone_group_name {
    description: "Zone Group dropdown full menu item name"
    type: string
    sql: ${TABLE}.value_zone_group_name ;;
  }

  dimension: zone_group_tag {
    description: "Zone Group tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_zone_group ;;
  }

  dimension: exit_reason_name {
    description: "Exit Reason dropdown full menu item name"
    type: number
    sql: ${TABLE}.value_exit_reason_name ;;
  }

  dimension: exit_reason_tag {
    description: "Exit Reason tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_exit_reason ;;
  }

  dimension: claim_status_name {
    description: "Claim Status dropdown full menu item name"
    type: string
    sql: ${TABLE}.value_claim_status_name ;;
  }

  dimension: claim_status_tag {
    description: "Claim Status tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_claim_status ;;
  }

  dimension: total_time_spent {
    description: "Agent total time spent working this ticket, in seconds"
    type: number
    sql: ${TABLE}.value_total_time_spent ;;
  }

  dimension: time_spent_last_update {
    description: "Agent time spent on the last ticket update, in seconds"
    type: number
    sql: ${TABLE}.value_time_spent_last_update ;;
  }

  dimension: is_trip_related {
    description: "\"Yes\" if this ticket has a Trip ID set"
    type: yesno
    sql:  ${getaround_trip_id} IS NOT NULL ;;
  }

  dimension: is_car_related {
    description: "\"Yes\" if this ticket has a Car ID set"
    type: yesno
    sql:  ${getaround_car_id} IS NOT NULL ;;
  }

  ### Measures

  measure: count {
    description: "Count tickets custom field records"
    type: count
    drill_fields: [default*]
  }

  measure: count_trip_related {
    description: "Count tickets that have an associated Getaround Trip ID"
    type: count
    filters: {
      field: is_trip_related
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_car_related {
    description: "Count tickets that have an associated Getaround Car ID"
    type: count
    filters: {
      field: is_car_related
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_unique_trips {
    description: "Unique count of Trip IDs referenced by Zendesk tickets"
    type:  count_distinct
    sql:  ${getaround_trip_id} ;;
  }

  measure: count_unique_cars {
    description: "Unique count of Car IDs referenced by Zendesk tickets"
    type:  count_distinct
    sql:  ${getaround_car_id} ;;
    drill_fields: [default*]
  }

  measure: sum_total_time_spent {
    description: "Sum total time spent working this ticket, in seconds"
    type: sum
    sql: ${total_time_spent} ;;
    drill_fields: [default*]
  }

  measure: sum_time_spent_last_update {
    description: "Sum time spent on the last ticket update, in seconds"
    type: sum
    sql: ${time_spent_last_update} ;;
    drill_fields: [default*]
  }

  set: default {
    fields: [
      ticket_id,
      getaround_car_id,
      getaround_trip_id,
      category_name,
      category_tag,
      zone_group_name,
      zone_group_tag,
      exit_reason_name,
      exit_reason_tag,
      claim_status_name,
      claim_status_tag,
      total_time_spent,
      time_spent_last_update,
      is_trip_related,
      is_car_related
    ]
  }
}
