# view is not necessary with the ticket_facts table. Phase 2 project to make this more user friendly

view: audits {
  sql_table_name: zendesk_stitch.audits ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: author_id {
    type: number
    sql: ${TABLE}.author_id ;;
  }

  dimension_group: created_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at::timestamp ;;
  }

  dimension: ticket_id {
    type: number
    # hidden: true
    sql: ${TABLE}.ticket_id ;;
  }

  ### Measures

  measure: count {
    description: "Count Zendesk ticket changes"
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      tickets.via__source__from__name,
      tickets.id,
      tickets.via__source__to__name,
      audits__events.count
    ]
  }
}
