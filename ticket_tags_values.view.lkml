view: ticket__tags {
  sql_table_name: zendesk.tickets__tags ;;

  dimension: pkid {
    primary_key: yes
    type: string
    hidden: yes
    sql: (${TABLE}._sdc_level_0_id::text) || '_' || (${TABLE}._sdc_source_key_id::text) ;;
  }

  dimension: ticket_id {
    type: number
    sql: ${TABLE}._sdc_source_key_id ;;
  }

  dimension: value {
    label: "Ticket Tag"
    group_label: "Custom Fields"
    description: "Custom tag associated with a ticket"
    type: string
    sql: ${TABLE}.value ;;
  }

  dimension_group: created_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${tickets.created_at_time}::timestamp ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
