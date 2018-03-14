view: ticket_custom_fields {
  derived_table: {
    sql:
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
        (CASE WHEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22157130)
                    OVER (PARTITION BY tickets__fields._sdc_source_key_id) ~ '^\d+(.\d+)?$'
                  AND length(MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22157130)
                               OVER (PARTITION BY tickets__fields._sdc_source_key_id)) < 20
             THEN (MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 22157130)
                    OVER (PARTITION BY tickets__fields._sdc_source_key_id))::bigint
             ELSE NULL END)::text AS value_car_id,
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
             ELSE NULL END)::int AS value_total_time_spent,
        (CASE WHEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 31479717)
                    OVER (PARTITION BY tickets__fields._sdc_source_key_id) ~ '^\d+(.\d+)?$'
             THEN MAX(tickets__fields.value) FILTER (WHERE tickets__fields.id = 31479717)
                    OVER (PARTITION BY tickets__fields._sdc_source_key_id)
             ELSE NULL END)::int AS value_time_spent_last_update

      FROM zendesk.tickets__fields
        LEFT JOIN zendesk.ticket_fields__custom_field_options AS value_options
          ON (tickets__fields.id = value_options._sdc_source_key_id AND
              tickets__fields.value = value_options.value) ;;
    indexes: ["ticket_id"]
    sql_trigger_value: SELECT MAX(_sdc_sequence) FROM zendesk.tickets__fields ;;
  }

  dimension: ticket_id {
    description: "Zendesk ticket number"
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: car_id {
    group_label: "Custom Fields"
    hidden: yes
    type: string
    sql: ${TABLE}.value_car_id ;;
  }

  dimension: trip_id {
    group_label: "Custom Fields"
    hidden: yes
    type: number
    sql: ${TABLE}.value_trip_id ;;
  }

  dimension: category_name {
    group_label: "Custom Fields"
    description: "Category dropdown full menu item name"
    type: string
    sql: ${TABLE}.value_category_name ;;
  }

  dimension: category_tag {
    group_label: "Custom Fields"
    description: "Category tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_category ;;
  }

  dimension: zone_group_name {
    group_label: "Custom Fields"
    description: "Zone Group dropdown full menu item name"
    type: string
    sql: ${TABLE}.value_zone_group_name ;;
  }

  dimension: zone_group_tag {
    group_label: "Custom Fields"
    description: "Zone Group tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_zone_group ;;
  }

  dimension: exit_reason_name {
    group_label: "Custom Fields"
    description: "Exit Reason dropdown full menu item name"
    type: number
    sql: ${TABLE}.value_exit_reason_name ;;
  }

  dimension: exit_reason_tag {
    group_label: "Custom Fields"
    description: "Exit Reason tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_exit_reason ;;
  }

  dimension: claim_status_name {
    group_label: "Custom Fields"
    description: "Claim Status dropdown full menu item name"
    type: string
    sql: ${TABLE}.value_claim_status_name ;;
  }

  dimension: claim_status_tag {
    group_label: "Custom Fields"
    description: "Claim Status tag associated with a menu item"
    type: string
    sql: ${TABLE}.value_claim_status ;;
  }

  dimension: total_time_spent {
    group_label: "Custom Fields"
    description: "Agent total time spent working this ticket, in seconds"
    type: number
    sql: ${TABLE}.value_total_time_spent ;;
  }

  dimension: time_spent_last_update {
    group_label: "Custom Fields"
    description: "Agent time spent on the last ticket update, in seconds"
    type: number
    sql: ${TABLE}.value_time_spent_last_update ;;
  }

  # Measures

  measure: sum_total_time_spent {
    description: "Sum total time spent working this ticket, in seconds"
    type: sum
    sql: ${total_time_spent} ;;
  }

  measure: sum_time_spent_last_update {
    description: "Sum time spent on the last ticket update, in seconds"
    type: sum
    sql: ${time_spent_last_update} ;;
  }
}
