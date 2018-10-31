view: organizations {
  sql_table_name: zendesk_stitch.organizations ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: time_created_at {
    description: "The time the organization was created, in the timezone specified by the Looker user"
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
    description: "The name of the organization, which corresponds to external partners (e.g. insurance entities, specific owner groups) and internal categories (e.g. Vendors)."
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: is_owner_group {
    description: "\"Yes\" if this is a vehicle owner group"
    type: yesno
    sql: ${name} IN ('Owner', 'VIP Owners', 'DriveWhip') ;;
  }

  dimension: notes {
    description: "Notes about the organization, if created by admin"
    type: string
    sql: ${TABLE}.notes ;;
  }

  ### Measures

  measure: count {
    description: "Count Zendesk organizations"
    type: count
    drill_fields: [default*]
  }

  set: default {
    fields: [
      id,
      time_created_at_time,
      details,
      name,
      is_owner_group,
      notes
    ]
  }
}
