view: groups {
  sql_table_name: zendesk_stitch.groups ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: time_created_at {
    description: "Timestamp when the group was created at, in the timezone specified by the Looker user"
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

  dimension: name {
    description: "The name of the group, which generally corresponds to various teams at Getaround (e.g. Happiness, Claims, City, Safety Specialist, etc.)"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: is_customer_happiness_group {
    description: "\"Yes\" if this group should be included in Customer Happiness team reporting.  Groups include Happiness, Lead, Supervisor and the managed queues."
    type: yesno
    sql: ${TABLE}.name IN ('Happiness', 'Lead', 'Supervisor',' Jessica R / City CarShare Managed Queue',
                           'Bryce / Toyota Connected Managed Queue' , 'Annie S / Drive with Uber Managed Queue') ;;
  }

  ### Measures

  measure: count {
    description: "Count Zendesk groups"
    type: count
    drill_fields: [default*]
  }

  set: default {
    fields: [
      id,
      time_created_at_date,
      name
    ]
  }
}
