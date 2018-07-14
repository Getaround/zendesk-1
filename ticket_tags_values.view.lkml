view: ticket__tags {
  sql_table_name: zendesk.tickets__tags ;;

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

  dimension_group: time_ticket_created_at {
    alias: [created_at]
    description: "Time the tag was added to the ticket"
    label: "Created At"
    hidden: yes
    type: time
    timeframes: [time, date, week, month]
    sql: ${tickets.created_at_time}::timestamp ;;
  }

  measure: count {
    description: "Count Zendesk ticket tag values"
    type: count
    drill_fields: []
  }
}
