view: ticket_custom_fields {
  derived_table: {
    sql:
      WITH ticket_custom_fields AS (
        SELECT DISTINCT
          tickets__fields._sdc_source_key_id AS ticket_id,

          -- Field IDs defined in Zendesk
          -- Navigate to:
          --   https://getaround.zendesk.com/agent/admin/ticket_fields
          -- Then edit a field to see its numeric ID
          MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 21140580)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_category,
          MAX(value_options.name) FILTER (WHERE tickets__fields.id = 21140580)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_category_name,
          MAX(value_options.raw_name) FILTER (WHERE tickets__fields.id = 21140580)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_category_raw_name,

          MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 21061264)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_freedom_metadata,
          CASE WHEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22157130)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id) ~ '^\d+(.\d+)?$'
                    AND length(MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22157130)
                                 OVER (PARTITION BY tickets__fields._sdc_source_key_id)) < 20
               THEN (MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22157130)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id))::text
               ELSE NULL END AS value_car_id,
          CASE WHEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 21146160)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id) ~ '^\d+(.\d+)?$'
                    AND length(MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 21146160)
                                 OVER (PARTITION BY tickets__fields._sdc_source_key_id)) < 20
               THEN (MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 21146160)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id))::bigint
               ELSE NULL END AS value_trip_id,

          MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22850570)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_zone_group,
          MAX(value_options.name) FILTER (WHERE tickets__fields.id = 22850570)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_zone_group_name,
          MAX(value_options.raw_name) FILTER (WHERE tickets__fields.id = 22850570)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_zone_group_raw_name,

          MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22939810)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_exit_reason,
          MAX(value_options.name) FILTER (WHERE tickets__fields.id = 22939810)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_exit_reason_name,
          MAX(value_options.raw_name) FILTER (WHERE tickets__fields.id = 22939810)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_exit_reason_raw_name,

          MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 30166248)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_claim_status,
          MAX(value_options.name) FILTER (WHERE tickets__fields.id = 30166248)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_claim_status_name,
          MAX(value_options.raw_name) FILTER (WHERE tickets__fields.id = 30166248)
            OVER (PARTITION BY tickets__fields._sdc_source_key_id) AS value_claim_status_raw_name,

          (CASE WHEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 31479707)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id) ~ '^\d+(.\d+)?$'
               THEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 31479707)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id)
               ELSE NULL END)::bigint AS value_total_time_spent,
          (CASE WHEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 31479717)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id) ~ '^\d+(.\d+)?$'
               THEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 31479717)
                      OVER (PARTITION BY tickets__fields._sdc_source_key_id)
               ELSE NULL END)::bigint AS value_time_spent_last_update
       FROM zendesk_stitch.tickets__custom_fields as tickets__fields
          LEFT JOIN zendesk_stitch.ticket_fields__custom_field_options AS value_options
            ON (tickets__fields.id = value_options._sdc_source_key_id AND
                tickets__fields.value = value_options.value))

      SELECT
        ticket_custom_fields.*,
        COALESCE(getaround_trip_a.coalesced_id, getaround_trip_b.coalesced_id) AS corrected_trip_id
      FROM
        ticket_custom_fields
      LEFT JOIN public.trip AS getaround_trip_a
        ON (getaround_trip_a.coalesced_id = ticket_custom_fields.value_trip_id::text)
      LEFT JOIN public.trip AS getaround_trip_b
        ON (getaround_trip_b.id = ticket_custom_fields.value_trip_id::text) ;;
    indexes: ["ticket_id",
              "value_trip_id",
              "value_car_id"]
    sql_trigger_value: SELECT MAX(_sdc_sequence) FROM zendesk_stitch.tickets__custom_fields ;;
  }

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
