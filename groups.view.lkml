view: groups {
  sql_table_name: zendesk_stitch.groups ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: time_created_at {
    alias: [created_at]
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

  dimension: is_happiness_group {
    description: "\"Yes\" if this group should be included in reporting for the Happiness team.  Groups include Renter Happiness, Owner Happiness, Owner Success, Happiness Team Lead, Happiness Escalation and the managed queues."
    type: yesno
    sql: ${id} IN (20357762, 20707481, 32925228, 360000020007, 360000033968, 360000056487, 360000237428, 360000230527) ;;
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
