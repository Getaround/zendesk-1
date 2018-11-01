view: satisfaction_ratings {
  derived_table: {
    sql: SELECT
        ratings.*,
        agent.name AS assignee_name,
        requester.name as requester_name,
        groups.name as group_name
      FROM
        zendesk_stitch.satisfaction_ratings AS ratings
      LEFT JOIN
        zendesk_stitch.users AS agent
      ON
        agent.id = ratings.assignee_id
      LEFT JOIN
        zendesk_stitch.users AS requester
      ON
        requester.id = ratings.requester_id
      LEFT JOIN
        zendesk_stitch.groups AS groups
      ON
        groups.id = ratings.group_id
       ;;
    indexes: ["ticket_id"]
    sql_trigger_value: SELECT COUNT(*) FROM zendesk_stitch.satisfaction_ratings ;;
  }

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

  dimension: assignee_name {
    description: "The name of the agent assigned at the time of the rating."
    type: string
    sql: ${TABLE}.assignee_name ;;
  }

  dimension: requester_name {
    description: "The name address of the requester (customer who initiated the ticket and who submitted the rating)"
    type: string
    sql: ${TABLE}.requester_name ;;
  }

  dimension: group_name {
    description: "The name of the group assigned at the time of the rating"
    type: string
    sql: ${TABLE}.group_name ;;
  }

  ### MEASURES

  measure: count_satisfied {
    description: "Count ratings marked as \"good\" by the requester"
    type: count_distinct
    filters: {
      field: rating
      value: "good"
    }
    sql: ${id} ;;
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
      comment,
      id,
      rating,
      reason,
      ticket_id,
      assignee_name,
      requester_name,
      group_name
    ]
  }
}
