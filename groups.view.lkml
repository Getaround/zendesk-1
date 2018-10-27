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
    description: "The name of the group, which generally corresponds to various teams at Getaround"
    type: string
    sql: ${TABLE}.name ;;
  }

  ### Measures

  measure: count {
    description: "Count Zendesk groups"
    type: count
    drill_fields: [id, name]
  }
}
