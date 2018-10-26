view: organizations {
  sql_table_name: zendesk_stitch.organizations ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: time_created_at {
    description: "The time the organization was created"
    type: time
    hidden: yes
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: details {
    description: "Details about the organization, such as its address"
    type: string
    sql: ${TABLE}.details ;;
  }

  dimension: name {
    description: "The name of the organization"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: is_owner_group {
    description: "\"Yes\" if this is an vehicle owner group"
    type: string
    sql: ${name} IN ("Owner", "VIP Owners", "DriveWhip")  ;;
  }

  dimension: notes {
    description: "Notes about the organization"
    type: string
    sql: ${TABLE}.notes ;;
  }

  measure: count {
    description: "Count Zendesk organizations"
    type: count
    drill_fields: [id, name]
  }
}
