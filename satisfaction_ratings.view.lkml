view: satisfaction_ratings {
  sql_table_name: zendesk_stitch.satisfaction_ratings ;;

  dimension: comment {
    description: "CSAT comment submitted by the ticket requester (customer who initiated the ticket)"
    label: "Comment"
    type: string
    sql: ${TABLE}.comment ;;
  }

  dimension: id {
    primary_key: yes
    description: "CSAT ID for the rating submitted by the ticket requester (customer who initiated the ticket)"
    label: "ID"
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: rating {
    description: "CSAT rating submitted by the ticket requester (customer who initiated the ticket)"
    label: "Rating"
    type: string
    sql: ${TABLE}.score ;;
  }

  dimension: reason {
    description: "Customers who select 'Bad, I'm unsatisfied' are presented with a drop-down menu of possible reasons for their negative response"
    label: "Reason"
    type: string
    sql: ${TABLE}.reason ;;
  }

  dimension_group: time_created_at {
    description: "Timestamp when the rating was created, in the timezone specified by the Looker user"
    group_label: "Time Created At"
    label: "Created At"
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

  dimension: ticket_id {
    type: number
    hidden: yes
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: assignee_id {
    description: "The id of the agent assigned at the time of the rating."
    type: string
    hidden: yes
    sql: ${TABLE}.assignee_id ;;
  }

  dimension: requester_id {
    description: "The id of the requester (customer who initiated the ticket and who submitted the rating)"
    type: string
    hidden: yes
    sql: ${TABLE}.requester_id ;;
  }

  dimension: group_id {
    description: "The id of the group assigned at the time of the rating"
    type: string
    hidden: yes
    sql: ${TABLE}.group_id ;;
  }

  ### MEASURES

  measure: count {
    description: "Count satisfaction ratings"
    type: count
    drill_fields: [default*]
  }

  measure: count_satisfied {
    description: "Count ratings marked as \"good\" by the requester"
    type: count
    filters: {
      field: rating
      value: "good"
    }
    drill_fields: [default*]
  }

  measure: count_dissatisfied {
    description: "Count ratings marked as \"bad\" by the requester"
    type: count
    filters: {
      field: rating
      value: "bad"
    }
    drill_fields: [default*]
  }

  measure: count_offered {
    description: "Count ratings marked as \"offered\" by the requester"
    type: count
    filters: {
      field: rating
      value: "offered"
    }
    drill_fields: [default*]
  }

  measure: count_unoffered {
    description: "Count ratings marked as \"unoffered\" by the requester"
    type: count
    filters: {
      field: rating
      value: "unoffered"
    }
    drill_fields: [default*]
  }

  set: default {
    fields: [
      id,
      time_created_at_time,
      ticket_id,
      rating,
      reason,
      comment
    ]
  }
}
