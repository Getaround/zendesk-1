view: agent_touch {
  sql_table_name: dbt_arthur_common.zendesk_ticket_touch ;;


  dimension: id {
    description: "ID for the touch of a ticket"
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: time_touched_at_utc {
    description: "Timestamp when the ticket was touched by an agent, in UTC"
    group_label: "Time Touched At"
    label: "Touched At UTC"
    type: time
    timeframes: [
      raw,
      time,
      date,
      time_of_day,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      year,
      week_of_year,
      month_num,
      quarter_of_year
    ]
    sql: ${TABLE}.created_at ;;
    convert_tz: no
  }

  dimension_group: time_touched_at {
    description: "Timestamp when the ticket was touched by an agent, in the timezone specified by the Looker user"
    group_label: "Time Touched At"
    label: "Touched At"
    type: time
    timeframes: [
      raw,
      time,
      date,
      time_of_day,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      year,
      week_of_year,
      month_num,
      quarter_of_year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: agent_email {
    description: "Email address of Agent who touched the ticket"
    group_label: "Agent"
    type: string
    sql: ${TABLE}."agent_email" ;;
  }

  dimension: agent_name {
    description: "Full name of Agent who touched the ticket"
    group_label: "Agent"
    type: string
    sql: ${TABLE}."agent_name" ;;
  }

  dimension: ticket_id {
    type: number
    sql: ${TABLE}."ticket_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [
      id,
      time_touched_at_utc_raw,
      agent_email,
      ticket_id
      ]
  }
}
