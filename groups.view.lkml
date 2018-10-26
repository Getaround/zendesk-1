view: groups {
  sql_table_name: zendesk_stitch.groups ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: time_created_at {
    hidden: yes
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: name {
    description: "The name of the group"
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    description: "Count Zendesk groups"
    type: count
    drill_fields: [id, name]
  }
}
