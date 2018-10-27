view: ticket__tags {
  derived_table: {
    sql: SELECT
        tags._sdc_source_key_id,
        tags.value,
        value_aggregate.all_values
      FROM
        zendesk_stitch.tickets__tags AS tags
      LEFT JOIN (
        SELECT
          _sdc_source_key_id,
          STRING_AGG(value,
            ', ') AS all_values
        FROM
          zendesk_stitch.tickets__tags
        GROUP BY
          _sdc_source_key_id) AS value_aggregate
      ON
        tags._sdc_source_key_id = value_aggregate._sdc_source_key_id ;;
    indexes: ["_sdc_source_key_id"]
    persist_for: "24 hours"
  }

  dimension: ticket_id {
    type: number
    hidden: yes
    sql: ${TABLE}._sdc_source_key_id ;;
  }

  dimension: value {
    description: "Zendesk ticket tag"
    type: string
    sql: ${TABLE}.value ;;
  }

  dimension: all_values {
    description: "Concatenated view of all Zendesk ticket tags"
    type: string
    sql: ${TABLE}.all_values ;;
  }

  dimension: is_ticket_closed_by_merge {
    description: "\"YES\" if the ticket is tagged 'closed_by_merge'"
    type: yesno
    sql: ${TABLE}.all_values ILIKE '%closed_by_merge%' ;;
  }

  dimension_group: time_ticket_created_at {
    alias: [created_at]
    description: "Time the tag was added to the ticket"
    label: "Created At"
    hidden: yes
    type: time
    timeframes: [
      time,
      date,
      week,
      month
      ]
    sql: ${tickets.time_created_at_time}::timestamp ;;
  }

  ### Measures

  measure: count {
    description: "Count Zendesk ticket tag values"
    type: count
    drill_fields: []
  }
}
