view: tickets {
  sql_table_name: zendesk.tickets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: assignee_email {
    description: "the requester is the customer who initiated the ticket. the email is retrieved from the `users` table."
    sql: ${assignees.email} ;;
  }

  ## include only if your Zendesk application utilizes the assignee_id field
  dimension: assignee_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.assignee_id ;;
  }

  #   - dimension: brand_id      ## include only if your Zendesk application utilizes the brand field
  #     value_format_name: id                ## only associated with Zendesk Enterprise Accounts
  #     type: number
  #     sql: ${TABLE}.brand_id

  dimension_group: created_at {
    type: time
    group_label: "Time Created At"
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

  dimension_group: created_at_utc {
    type: time
    group_label: "Time Created At"
    label: "Created At UTC"
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
    convert_tz: no
  }

  dimension: group_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.group_id ;;
  }

  dimension: organization_id {
    type: number
    value_format_name: id
    sql: ${TABLE}.organization_id ;;
  }

  dimension: organization_name {
    type: string
    sql: ${organizations.name} ;;
  }

  dimension: recipient {
    type: string
    sql: ${TABLE}.recipient ;;
  }

  dimension: requester_email {
    description: "the requester is the customer who initiated the ticket. the email is retrieved from the `users` table."
    sql: ${requesters.email} ;;
  }

  dimension: requester_id {
    description: "the requester is the customer who initiated the ticket"
    type: number
    value_format_name: id
    sql: ${TABLE}.requester_id ;;
  }

  dimension: csat_comment {
    description: "CSAT comment submitted by the ticket requester"
    label: "CSAT Comment"
    group_label: "CSAT"
    type: string
    sql: ${TABLE}.satisfaction_rating__comment ;;
  }

  dimension: csat_id {
    description: "CSAT ID for the rating submitted by the ticket requester"
    label: "CSAT ID"
    group_label: "CSAT"
    type: number
    sql: ${TABLE}.satisfaction_rating__id ;;
  }

  dimension: csat_rating {
    description: "CSAT rating submitted by the ticket requester"
    label: "CSAT Rating"
    group_label: "CSAT"
    type: string
    sql: ${TABLE}.satisfaction_rating__score ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  ## depending on use, either this field or "via_channel" will represent the channel the ticket came through
  dimension: subject {
    type: string
    sql: ${TABLE}.subject ;;
  }

  ## The submitter is always the first to comment on a ticket
  dimension: submitter_id {
    description: "a submitter is either a customer or an agent submitting on behalf of a customer"
    type: number
    value_format_name: id
    sql: ${TABLE}.submitter_id ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: via__channel {
    type: string
    sql: ${TABLE}.via__channel ;;
  }

  measure: count {
    type: count
    drill_fields: [id, requester_email]
  }

  # ----- ADDITIONAL FIELDS -----

  dimension: is_backlogged {
    type: yesno
    sql: ${status} = 'pending' ;;
  }

  dimension: is_new {
    type: yesno
    sql: ${status} = 'new' ;;
  }

  dimension: is_open {
    type: yesno
    sql: ${status} = 'open' ;;
  }

  dimension: is_solved {
    description: "solved tickets have either a solved or closed status"
    type: yesno
    sql: ${status} = 'solved' OR ${status} = 'closed' ;;
  }

  dimension: subject_category {
    sql: CASE
      WHEN ${subject} LIKE 'Chat%' THEN 'Chat'
      WHEN ${subject} LIKE 'Offline message%' THEN 'Offline Message'
      WHEN ${subject} LIKE 'Phone%' THEN 'Phone Call'
      ELSE 'Other'
      END
       ;;
  }

  measure: count_pending_tickets {
    type: count

    filters: {
      field: is_backlogged
      value: "Yes"
    }
  }

  measure: count_new_tickets {
    type: count

    filters: {
      field: is_new
      value: "Yes"
    }
  }

  measure: count_open_tickets {
    type: count

    filters: {
      field: is_open
      value: "Yes"
    }
  }

  measure: count_solved_tickets {
    type: count

    filters: {
      field: is_solved
      value: "Yes"
    }
  }

  measure: count_distinct_organizations {
    type: count_distinct
    sql: ${organization_id} ;;
  }

  measure: count_orgs_submitting {
    type: count_distinct
    sql: ${organizations.name} ;;

    filters: {
      field: organization_name
      value: "-NULL"
    }
  }

  measure: count_satisfied {
    description: "Count tickets marked as \"good\" by the requester"
    type: count
    filters: {
      field: csat_rating
      value: "good"
    }
  }

  measure: count_dissatisfied {
    description: "Count tickets marked as \"bad\" by the requester"
    type: count
    filters: {
      field: csat_rating
      value: "bad"
    }
  }

  measure: count_offered {
    description: "Count tickets marked as \"offered\" by the requester"
    type: count
    filters: {
      field: csat_rating
      value: "offered"
    }
  }

  measure: count_unoffered {
    description: "Count tickets marked as \"unoffered\" by the requester"
    type: count
    filters: {
      field: csat_rating
      value: "unoffered"
    }
  }

  ############ TIME FIELDS ###########

#  dimension_group: time {
#    type: time
    ###   use day_of_week
#    timeframes: [day_of_week, hour_of_day]
#    sql: ${TABLE}.created_at::timestamp ;;
#  }
}

#   - dimension: created_day_of_week
#     sql_case:
#       Sunday:    ${hidden_created_day_of_week_index} = 6
#       Monday:    ${hidden_created_day_of_week_index} = 0
#       Tuesday:   ${hidden_created_day_of_week_index} = 1
#       Wednesday: ${hidden_created_day_of_week_index} = 2
#       Thursday:  ${hidden_created_day_of_week_index} = 3
#       Friday:    ${hidden_created_day_of_week_index} = 4
#       Saturday:  ${hidden_created_day_of_week_index} = 5

### REVIEW
#   - dimension: satisfaction_rating_percent_tier
#     type: tier
#     tiers: [10,20,30,40,50,60,70,80,90]
#     sql: ${satisfaction_rating}
#
#   - measure: average_satisfaction_rating
#     type: avg
#     sql: ${satisfaction_rating}
#     value_format: '#,#00.00%'


### REVIEW BELOW
# ----- Sets of fields for drilling ------
#   sets:
#     detail:
#     - via__source__from__ticket_id
#     - via__source__from__name
#     - via__source__to__name
#     - organizations.id
#     - organizations.name
#     - audits.count
#     - zendesk_ticket_metrics.count
