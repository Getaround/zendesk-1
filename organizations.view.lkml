view: organizations {
  sql_table_name: zendesk_stitch.organizations ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: time_created_at {
    alias: [created]
    description: "The time the organization was created, in the timezone specified by the Looker user"
    group_label: "Time Created At"
    label: "Created At"
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
    description: "The name of the organization, which corresponds to external partners (e.g. insurance entities, specific owner organizations) and internal categories (e.g. Vendors)."
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: is_owner_organization {
    description: "\"Yes\" if this is a vehicle owner organization"
    type: yesno
    sql: ${id} IN (27717697608, 360026979927, 360072961408) ;;
  }

  dimension: notes {
    description: "Notes about the organization, if created by admin"
    type: string
    sql: ${TABLE}.notes ;;
  }

  ### Measures

  measure: count {
    description: "Count distinct Zendesk organizations"
    type: count_distinct
    sql: ${name} ;;
    drill_fields: [default*]
  }

  set: default {
    fields: [
      id,
      time_created_at_time,
      details,
      name,
      is_owner_organization,
      notes
    ]
  }
}
