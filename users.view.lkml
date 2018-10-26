view: users {
  sql_table_name: zendesk_stitch.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: alias {
    description: "The user’s alias, displayed to end users"
    type: string
    sql: ${TABLE}.alias ;;
  }

  dimension_group: time_created_at {
    description: "Timestamp when the user was created at"
    group_label: "Time Created At"
    label: "Created At"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    description: "The user’s primary email address"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    description: "The user’s name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: organization_id {
    type: number
    hidden: yes
    value_format_name: id
    sql: ${TABLE}.organization_id ;;
  }

  dimension: role {
    description: "The role of the user. Possible values are agent, admin, end-user."
    type: string
    sql: ${TABLE}.role ;;
  }

  dimension: time_zone {
    description: "The user’s timezone"
    type: string
    sql: ${TABLE}.time_zone ;;
  }

  measure: count {
    description: "Count Zendesk users"
    type: count
    drill_fields: [id, name]
  }
}
