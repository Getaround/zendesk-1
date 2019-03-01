view: tickets {
  sql_table_name: zendesk_stitch.tickets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: assignee_email {
    description: "The email of the assignee (agent currently assigned to the ticket)"
    type: string
    sql: ${assignees.email} ;;
  }

  dimension: assignee_id {
    description: "The ID of the assignee (agent currently assigned to the ticket)"
    type: number
    value_format_name: id
    sql: ${TABLE}.assignee_id ;;
  }

  dimension_group: time_created_at {
    alias: [created_at]
    description: "Timestamp when the ticket was created, in the timezone specified by the Looker user"
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
    description: "Use this field with the Time Created At Filter.  Using this field allows you to adjust the time frame dynamically. In the timezone specified by the Looker user"
    type: string
    sql: CASE WHEN {% parameter time_created_at_filter %} = 'date' THEN ${time_created_at_date}::text
          WHEN {% parameter time_created_at_filter %} = 'week' THEN ${time_created_at_week}
          WHEN {% parameter time_created_at_filter %} = 'month' THEN ${time_created_at_month}
          WHEN {% parameter time_created_at_filter %} = 'quarter' THEN ${time_created_at_quarter}
         END ;;
  }


  dimension_group: time_created_at_utc {
    alias: [created_at_utc]
    description: "Timestamp when the ticket was created, in UTC"
    group_label: "Time Created At"
    label: "Created At UTC"
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
    convert_tz: no
  }

  dimension: group_id {
    type: number
    hidden: yes
    sql: ${TABLE}.group_id ;;
  }

  dimension: group_name {
    description: "The current group that the ticket is assigned to"
    type: string
    hidden: yes
    sql: ${groups.name} ;;
  }

  dimension: organization_id {
    type: number
    hidden: yes
    sql: ${TABLE}.organization_id ;;
  }

  dimension: recipient_email {
    description: "The original recipient email address of the ticket (in most cases, help@getaround.com)"
    type: string
    sql: ${TABLE}.recipient ;;
  }

  dimension: requester_email {
    description: "The email address of the requester (customer who initiated the ticket)"
    sql: ${requesters.email} ;;
  }

  dimension: requester_id {
    description: "The ID of the requester (customer who initiated the ticket)"
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

  dimension: csat_reason {
    description: "Customers who select 'Bad, I'm unsatisfied' are presented with a drop-down menu of possible reasons for their negative response"
    label: "CSAT Reason"
    group_label: "CSAT"
    type: string
    sql: ${TABLE}.satisfaction_rating__reason ;;
  }

  dimension: status {
    description: "The current status of the ticket. Possible values: new, open, pending, hold, solved, and closed"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: subject {
    description: "The most recent value of the subject field for the ticket"
    type: string
    sql: ${TABLE}.subject ;;
  }

  dimension: submitter_id {
    description: "The ID of the person who initiated the first public comment for the ticket."
    type: number
    hidden: yes
    sql: ${TABLE}.submitter_id ;;
  }

  dimension: type {
    description: "The ticket type. Possible values: problem, incident, question, and task."
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: via__channel {
    description: "The channel used to create the ticket (e.g. API, SMS, Email, Facebook, etc)"
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
    type: string
    sql: ${TABLE}.id ;;
    html: <a href="https://getaround.zendesk.com/agent/tickets/{{ value }}">{{ value }}</a> ;;
  }

  # ----- ADDITIONAL FIELDS -----

  dimension: is_pending {
    alias: [is_backlogged]
    description: "\"Yes\" if the ticket status is pending."
    type: yesno
    sql: ${status} = 'pending' ;;
  }

  dimension: is_on_hold {
    description: "\"Yes\" if the ticket status is hold."
    type: yesno
    sql: ${status} = 'hold' ;;
  }

  dimension: is_new {
    description: "\"Yes\" if the ticket status is new."
    type: yesno
    sql: ${status} = 'new' ;;
  }

  dimension: is_open {
    description: "\"Yes\" if the ticket status is open."
    type: yesno
    sql: ${status} = 'open' ;;
  }

  dimension: is_solved {
    description: "\"Yes\" if the ticket status is solved or closed."
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
    description: "How the ticket was created (e.g. Inbound Call, Inbound Email, Forked Ticket, Outbound Call, etc)"
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
           WHEN ${via__channel} = 'web' AND ${via__source__rel} IS NULL AND ${ticket_facts.number_outbound_emails} > 0 THEN 'Outbound Email'
           ELSE NULL END;;
  }

  dimension: is_created_during_trip {
    description: "'Yes' if ticket was created between 30 minutes prior to trip start time and 30 minutes post the final trip end time."
    group_label: "Trip"
    type: yesno
    sql: ${time_created_at_raw} >= (${getaround_trip.time_start_at_raw} - INTERVAL '30 minutes')
      AND ${time_created_at_raw} <= (${getaround_trip.time_end_at_raw} + INTERVAL '30 minutes') ;;
  }

  dimension: is_created_during_trip_extension_period {
    description: "'Yes' if ticket was created between the trip's original end time and the trip final extension's end time."
    group_label: "Trip"
    type: yesno
    sql: ${time_created_at_raw} >= (${getaround_trip.time_original_end_at_raw})
      AND ${time_created_at_raw} <= (${getaround_trip.time_end_at_raw}) ;;
  }

  dimension: is_created_at_trip_start {
    description: "'Yes' if ticket was created 30 minutes before or after the trip's start time"
    group_label: "Trip"
    type: yesno
    sql: ${time_created_at_raw} >= (${getaround_trip.time_start_at_raw} - INTERVAL '30 minutes')
      AND ${time_created_at_raw} <= (${getaround_trip.time_start_at_raw} + INTERVAL '30 minutes') ;;
  }

  dimension: is_created_at_original_end_time {
    description: "'Yes' if ticket was created 30 minutes before or after the trip's original end time"
    group_label: "Trip"
    type: yesno
    sql: ${time_created_at_raw} >= (${getaround_trip.time_original_end_at_raw} - INTERVAL '30 minutes')
      AND ${time_created_at_raw} <= (${getaround_trip.time_original_end_at_raw} + INTERVAL '30 minutes') ;;
  }

  dimension: is_created_at_trip_creation_time {
    description: "'Yes' if ticket was created 30 minutes before or after the trip's created at time"
    group_label: "Trip"
    type: yesno
    sql: ${time_created_at_raw} >= (${getaround_trip.time_created_at_raw} - INTERVAL '30 minutes')
      AND ${time_created_at_raw} <= (${getaround_trip.time_created_at_raw} + INTERVAL '30 minutes') ;;
  }

  ### Measures

  measure: count {
    description: "Count Zendesk tickets"
    type: count
    drill_fields: [default*]
  }

  measure: count_pending_tickets {
    description: "Count of tickets in pending status"
    type: count
    filters: {
      field: is_pending
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_on_hold_tickets {
    description: "Count of tickets in hold status"
    type: count
    filters: {
      field: is_on_hold
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_new_tickets {
    description: "Count of tickets in new status"
    type: count
    filters: {
      field: is_new
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_open_tickets {
    description: "Count of tickets in open status"
    type: count
    filters: {
      field: is_open
      value: "Yes"
    }
    drill_fields: [default*]
  }

  measure: count_solved_tickets {
    description: "Count of tickets in solved or closed status"
    type: count
    filters: {
      field: is_solved
      value: "Yes"
    }
    drill_fields: [default*]
  }
  measure: count_satisfied {
    description: "Count tickets marked as \"good\" by the requester"
    group_label: "CSAT"
    type: count
    filters: {
      field: csat_rating
      value: "good"
    }
    drill_fields: [default*]
  }

  measure: count_dissatisfied {
    description: "Count tickets marked as \"bad\" by the requester"
    group_label: "CSAT"
    type: count
    filters: {
      field: csat_rating
      value: "bad"
    }
    drill_fields: [default*]
  }

  measure: count_offered {
    description: "Count tickets marked as \"offered\" by the requester"
    group_label: "CSAT"
    type: count
    filters: {
      field: csat_rating
      value: "offered"
    }
    drill_fields: [default*]
  }

  measure: count_unoffered {
    description: "Count tickets marked as \"unoffered\" by the requester"
    group_label: "CSAT"
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
      status,
      type,
      via__channel,
      subject
    ]
  }

  set: getaround_trip_dependent_fields {
    fields: [
      is_created_during_trip,
      is_created_during_trip_extension_period,
      is_created_at_trip_start,
      is_created_at_original_end_time,
      is_created_at_trip_creation_time,
    ]
  }
}
