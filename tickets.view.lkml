view: tickets {
  sql_table_name: zendesk_stitch.tickets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: assignee_email {
    description: "the requester is the customer who initiated the ticket. the email is retrieved from the `users` table."
    type: string
    sql: ${assignees.email} ;;
  }

  ## include only if your Zendesk application utilizes the assignee_id field
  dimension: assignee_id {
    description: "The ID of the agent currently assigned to the ticket"
    type: number
    value_format_name: id
    sql: ${TABLE}.assignee_id ;;
  }

  dimension_group: time_created_at {
    alias: [created_at]
    type: time
    group_label: "Time Created At"
    description: "Time Created At, in the timezone specified by the Looker user"
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

  parameter: time_created_at_filter {
    description: "Filter-only field that can be used with the Time Created At Filtered dimension"
    type: string
    allowed_value: {
      label: "Date"
      value: "date"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
  }

  dimension: time_created_at_filtered {
    label_from_parameter: time_created_at_filter
    description: "Use this field with the Time Created At Filter.  Using this field allows you to adjust the time frame dynamically"
    type: string
    sql: CASE WHEN {% parameter time_created_at_filter %} = 'date' THEN ${time_created_at_date}::text
          WHEN {% parameter time_created_at_filter %} = 'week' THEN ${time_created_at_week}
          WHEN {% parameter time_created_at_filter %} = 'month' THEN ${time_created_at_month}
          WHEN {% parameter time_created_at_filter %} = 'quarter' THEN ${time_created_at_quarter}
         END ;;
  }


  dimension_group: time_created_at_utc {
    alias: [created_at_utc]
    type: time
    group_label: "Time Created At UTC"
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
    hidden: yes
    sql: ${TABLE}.group_id ;;
  }

  dimension: group_name {
    description: "The current group that the ticket is assigned to"
    type: string
    sql: ${groups.name} ;;
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
    description: "The requester is the customer who initiated the ticket"
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

  dimension: submitter_id {
    description: "the submitter is always the first to comment on a ticket"
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

  dimension: via__source__rel {
    hidden: yes
    type: string
    sql: ${TABLE}.via__source__rel ;;
  }

  dimension: hyperlink {
    description: "Hyperlink to the Zendesk ticket"
    group_label: "Zendesk"
    type: string
    sql: ${TABLE}.id ;;
    html: <a href="https://getaround.zendesk.com/agent/tickets/{{ value }}">{{ value }}</a> ;;
  }

  measure: count {
    description: "Count Zendesk tickets"
    type: count
    drill_fields: [default*]
  }

  # ----- ADDITIONAL FIELDS -----

  dimension: is_pending {
    alias: [is_backlogged]
    type: yesno
    sql: ${status} = 'pending' ;;
  }

  dimension: is_onhold {
    type: yesno
    sql: ${status} = 'hold' ;;
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

  dimension: ticket_source {
    description: "How the ticket was created"
    group_label: "Ticket Details"
    type: string
    sql: CASE WHEN ${via__channel} = 'voice' AND ${via__source__rel} = 'inbound' THEN 'Inbound Call'
           WHEN ${via__channel} = 'voice' AND ${via__source__rel} = 'outbound' THEN 'Outbound Call'
           WHEN ${via__channel} = 'voice' AND ${via__source__rel} = 'voicemail' THEN 'Inbound Voicemail'
           WHEN ${via__channel} = 'email' AND ${via__source__rel} IS NULL AND (${submitter_id} = 387083233
                                    OR ${submitter_id} IN (14347589207, 20732481127, 360354963368)) THEN 'Managed Tickets' ---shadow & no-reply
           WHEN ${via__channel} = 'email' AND ${via__source__rel} IS NULL THEN 'Inbound Email'
           WHEN ${via__channel} = 'api' AND ${via__source__rel} IS NULL AND ${TABLE}.description LIKE 'Forked%' THEN 'Forked Ticket'
           WHEN ${via__channel} = 'api' AND ${via__source__rel} IS NULL THEN 'Programmatic'
           WHEN ${via__channel} = 'sms' AND ${via__source__rel} IS NULL THEN 'Managed Tickets' --- sms
           WHEN ${via__channel} = 'mobile_sdk' AND ${via__source__rel} = 'mobile_sdk' THEN 'Inbound Email'
           WHEN ${via__channel} = 'facebook' AND ${via__source__rel} IN ('message', 'post') THEN 'Facebook'
           WHEN ${via__channel} = 'twitter' AND ${via__source__rel} IN ('direct_message', 'mention') THEN 'Twitter'
           WHEN ${via__channel} = 'web' AND ${via__source__rel} = 'follow_up' THEN 'Inbound Email' --- follow-up ticket
           WHEN ${via__channel} = 'web' AND ${via__source__rel} IS NULL AND ${ticket_fact.number_outbound_emails} > 0 THEN 'Outbound Email'
           ELSE NULL END;;
  }

  ### Measures

  measure: count_pending_tickets {
    type: count
    filters: {
      field: is_pending
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_onhold_tickets {
    type: count

    filters: {
      field: is_onhold
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_new_tickets {
    type: count

    filters: {
      field: is_new
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_open_tickets {
    type: count

    filters: {
      field: is_open
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_solved_tickets {
    type: count

    filters: {
      field: is_solved
      value: "Yes"
    }
    drill_fields: [default*]
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
    drill_fields: [default*]
  }

  measure: count_dissatisfied {
    description: "Count tickets marked as \"bad\" by the requester"
    type: count
    filters: {
      field: csat_rating
      value: "bad"
    }
    drill_fields: [default*]
  }

  measure: count_offered {
    description: "Count tickets marked as \"offered\" by the requester"
    type: count
    filters: {
      field: csat_rating
      value: "offered"
    }
    drill_fields: [default*]
  }

  measure: count_unoffered {
    description: "Count tickets marked as \"unoffered\" by the requester"
    type: count
    filters: {
      field: csat_rating
      value: "unoffered"
    }
    drill_fields: [default*]
  }

  set: default {
    fields: [
      hyperlink,
      time_created_at_time,
      organization_name,
      status,
      csat_rating,
      type,
      via__channel,
      subject
    ]
  }
}
