view: ticket_metrics {
  sql_table_name: zendesk_stitch.ticket_metrics ;;
  #   definition resource: https://developer.zendesk.com/rest_api/docs/core/ticket_metrics

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: agent_wait_time_in_minutes__business {
    description: "The cumulative number of minutes a ticket has been in a pending state (awaiting customer response), inside of business hours.  Business hours are from M-F, 9am - 5pm PST."
    group_label: "Wait Time"
    type: number
    sql: ${TABLE}.agent_wait_time_in_minutes__business ;;
  }

  dimension: agent_wait_time_in_minutes__calendar {
    description: "The cumulative number of minutes a ticket has been in a pending state (awaiting customer response)"
    group_label: "Wait Time"
    type: number
    sql: ${TABLE}.agent_wait_time_in_minutes__calendar ;;
  }

  dimension_group: time_last_assigned_at {
    alias: [assigned]
    description: "The time the ticket was last assigned, in the timezone specified by the Looker user"
    group_label: "Time Last Assigned At"
    label: "Last Assigned At"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.assigned_at ;;
  }

  dimension_group: time_last_assigned_at_utc {
    description: "The time the ticket was last assigned, in UTC"
    group_label: "Time Last Assigned At"
    label: "Last Assigned At UTC"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    convert_tz: no
    sql: ${TABLE}.assigned_at ;;
  }

  dimension: last_assignee_id {
    alias: [assignee_id]
    description: "The ID of the user last assigned to the ticket"
    type: number
    sql: ${tickets.assignee_id} ;;
  }

  dimension: last_assignee_email {
    alias: [assignee_email]
    description: "The email address of the user last assigned to the ticket"
    type: string
    sql: ${assignees.email} ;;
  }

  dimension: last_group_name {
    alias: [group_name]
    description: "The name of the group last assigned to the ticket"
    type: string
    hidden: yes
    sql: ${groups.name} ;;
  }

  dimension_group: time_last_updated_at {
    alias: [assignee_updated_at]
    description: "The time the assignee last updated the ticket, in the timezone specified by the Looker user"
    group_label: "Time Last Updated At"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.assignee_updated_at ;;
  }

  # MINUTES

  dimension: first_resolution_time_in_minutes__business {
    description: "The number of minutes from when a ticket is created to when it is first solved, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.first_resolution_time_in_minutes__business ;;
  }

  dimension: first_resolution_time_in_minutes__calendar {
    description: "The number of minutes from when a ticket is created to when it is first solved"
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.first_resolution_time_in_minutes__calendar ;;
  }

  dimension: full_resolution_time_in_minutes__business {
    description: "The number of minutes from when a ticket is created to when it is solved for the last time, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__business ;;
  }

  dimension: full_resolution_time_in_minutes__calendar {
    description: "The number of minutes from when a ticket is created to when it is solved for the last time"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar ;;
  }

  dimension: full_resolution_time_in_minutes__calendar_less_than_8_hours {
    description: "\"Yes\" if the ticket was solved within the first 8 calendar hours"
    label: "Full Resolution Time Meets 8 hour SLA"
    group_label: "SLA"
    type: yesno
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar <= 480 ;;
  }

  dimension: full_resolution_time_in_minutes__calendar_less_than_48_hours {
    description: "\"Yes\" if the ticket was solved within the first 48 calendar hours"
    label: "Full Resolution Time Meets 48 hour SLA"
    group_label: "SLA"
    type: yesno
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar <= 2880 ;;
  }

  dimension: first_resolution_time_in_hours__business {
    description: "The number of hours from when a ticket is created to when it is first solved, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: (${TABLE}.first_resolution_time_in_minutes__business / 60) ;;
  }

  dimension: first_resolution_time_in_hours__calendar {
    description: "The number of hours from when a ticket is created to when it is first solved"
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: (${TABLE}.first_resolution_time_in_minutes__calendar / 60) ;;
  }

  dimension: full_resolution_time_in_hours__business {
    description: "The number of hours from when a ticket is created to when it is solved for the last time, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__business / 60 ;;
  }

  dimension: full_resolution_time_in_hours__calendar {
    description: "The number of hours from when a ticket is created to when it is solved for the last time"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar / 60 ;;
  }

  dimension: first_resolution_time_in_days__business {
    description: "The number of days from when a ticket is created to when it is first solved, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: (${TABLE}.first_resolution_time_in_minutes__business / 480) ;;
  }

  dimension: first_resolution_time_in_days__calendar {
    description: "The number of days from when a ticket is created to when it is first solved"
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: (${TABLE}.first_resolution_time_in_minutes__calendar / 1440) ;;
  }

  dimension: full_resolution_time_in_days__business {
    description: "The number of days from when a ticket is created to when it is solved for the last time, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__business / 480 ;;
  }

  dimension: full_resolution_time_in_days__calendar {
    description: "The number of days from when a ticket is created to when it is solved for the last time"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar / 1440 ;;
  }

  dimension_group: time_initially_assigned_at {
    description: "The time the ticket was initially assigned, in the timezone specified by the Looker user"
    group_label: "Time Initially Assigned At"
    label: "Initially Assigned At"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    hidden: yes
    sql: ${TABLE}.initially_assigned_at ;;
  }

  dimension_group: time_latest_comment_added_at {
    description: "The time the last comment was added to the ticket, in the timezone specified by the Looker user"
    group_label: "Time Lastest Comment Added At"
    label: "Lastest Comment Added At"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    hidden: yes
    sql: ${TABLE}.latest_comment_added_at ;;
  }

  dimension: number_reopens {
    description: "The total number of times the ticket was reopened"
    type: number
    sql: ${TABLE}.reopens ;;
  }

  dimension: number_replies {
    description: "The total number of times the ticket was replied to"
    type: number
    sql: ${TABLE}.replies ;;
  }

  dimension: reply_time_in_minutes__business {
    description: "The number of minutes between ticket creation and the first public comment from an agent, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__business ;;
  }

  dimension: reply_time_in_minutes__calendar {
    description: "The number of minutes between ticket creation and the first public comment from an agent"
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__calendar ;;
  }

  dimension: reply_time_in_hours__calendar_meet_4_hour_SLA {
    description: "\"Yes\" if the ticket was first replied to within the first 4 calendar hours"
    label: "First Reply Time Meets 4 hour SLA"
    group_label: "SLA"
    type: yesno
    sql: ${reply_time_in_minutes__calendar} <= 240 ;;
  }

  dimension: reply_time_in_hours__calendar_meet_2_hour_SLA {
    description: "\"Yes\" if the ticket was first replied to within the first 2 calendar hours.  This SLA applies to account verification related tickets"
    label: "First Reply Time Meets 2 hour SLA"
    group_label: "SLA"
    type: yesno
    sql: ${reply_time_in_minutes__calendar} <= 120
         AND (${ticket__tags.all_values} LIKE '%question-account-verification%'
              OR ${ticket__tags.all_values} LIKE '%account_verification%'
              OR ${ticket__tags.all_values} LIKE '%driving_record%'
             ) ;;
  }

  dimension: is_account_verification_ticket {
    description: "\"Yes\" if the ticket was for account verification"
    group_label: "SLA"
    type: yesno
    sql: ${ticket__tags.all_values} LIKE '%question-account-verification%'
         OR ${ticket__tags.all_values} LIKE '%account_verification%'
         OR ${ticket__tags.all_values} LIKE '%driving_record%' ;;
  }

  dimension: reply_time_in_hours__business {
    description: "The number of hours between ticket creation and the first public comment from an agent, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__business / 60 ;;
  }

  dimension: reply_time_in_hours__calendar {
    description: "The number of hours between ticket creation and the first public comment from an agent"
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__calendar / 60 ;;
  }

  dimension: coalesce_reply_time_and_first_resolution_time_in_minutes__calendar {
    description: "The number of minutes between ticket creation and the first reply from an agent, if it exists.  If not, the number of minutes between ticket creation and first resolved at time.  This is primarily used for the Safety Team, where responding to a customer is not always necessary."
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: coalesce(${TABLE}.reply_time_in_minutes__calendar,${first_resolution_time_in_minutes__calendar}) ;;
  }

  dimension_group: time_requester_updated_at {
    description: "The time the requester last updated the ticket, in the timezone specified by the Looker user"
    group_label: "Time Requester Updated At"
    label: "Requester Updated At"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    hidden: yes
    sql: ${TABLE}.requester_updated_at ;;
  }

  dimension: requester_wait_time_in_minutes__business {
    description: "The cumulative number of minutes that a ticket is in a New, Open or On-hold state, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "Wait Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.requester_wait_time_in_minutes__business ;;
  }

  dimension: requester_wait_time_in_minutes__calendar {
    description: "The cumulative number of minutes that a ticket is in a New, Open or On-hold state"
    group_label: "Wait Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.requester_wait_time_in_minutes__calendar ;;
  }

  dimension_group: time_solved_at {
    alias: [solved]
    description: "Time the ticket was last solved at, in the timezone specified by the Looker user"
    group_label: "Time Solved At"
    label: "Solved At"
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
    sql: ${TABLE}.solved_at ;;
  }

  dimension_group: time_solved_at_utc {
    description: "Time the ticket was last solved at, in UTC"
    group_label: "Time Solved At"
    label: "Solved At UTC"
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
    convert_tz: no
    sql: ${TABLE}.solved_at ;;
  }

  parameter: time_solved_at_filter {
    description: "Filter-only field that can be used with the Time Solved At Filtered dimension"
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

  dimension: time_solved_at_filtered {
    label_from_parameter: time_solved_at_filter
    description: "Use this field with the Time Created At Filter.  Using this field allows you to adjust the time frame dynamically. In the timezone specified by the Looker user"
    type: string
    sql: CASE WHEN {% parameter time_solved_at_filter %} = 'date' THEN ${time_solved_at_date}::text
          WHEN {% parameter time_solved_at_filter %} = 'week' THEN ${time_solved_at_week}
          WHEN {% parameter time_solved_at_filter %} = 'month' THEN ${time_solved_at_month}
          WHEN {% parameter time_solved_at_filter %} = 'quarter' THEN ${time_solved_at_quarter}
         END ;;
  }

  dimension: ticket_id {
    description: "The ID of the associated ticket"
    type: number
    hidden: yes
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: age_bpo_cohort_weeks {
    label: "Age BPO Cohort Weeks"
    description: "Age when the BPO agent solved ticket, measured in weeks since cohort start date"
    type: number
    sql:  EXTRACT(day from (DATE_TRUNC('week', ${ticket_metrics.time_solved_at_raw})
      - DATE_TRUNC('week', ${ticket_last_assignee.time_bpo_cohort_start_at_raw})))/7 ;;
  }

  ### Measures

  measure: count {
    description: "Count Zendesk ticket metrics"
    type: count
    drill_fields: [default*]
  }

  measure: count_coalesce_reply_time_and_first_resolution_time_calendar_meet_2_hour_SLA {
    label: "Count Coalesce Reply Time and First Resolution Time Calendar Meet 2 hour SLA"
    description: "Count of tickets that are responded to or first resolved within the 2 hour SLA. This is primarily used for the Safety Team"
    type: sum
    sql: CASE WHEN ${av_reply_time_in_minutes__calendar} <= 120 THEN 1 ELSE NULL END ;;
    drill_fields: [default*]
  }

  measure: average_first_resolution_time_in_minutes__business {
    description: "The average number of minutes to the first resolution time, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${first_resolution_time_in_minutes__business} ;;
    drill_fields: [default*]
  }

  measure: average_first_resolution_time_in_minutes__calendar {
    description: "The average number of minutes to the first resolution time"
    group_label: "First Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${first_resolution_time_in_minutes__calendar} ;;
    drill_fields: [default*]
  }

  measure: average_full_resolution_time_in_minutes__business {
    description: "The average number of minutes to the full resolution inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__business} ;;
    drill_fields: [default*]
  }

  measure: average_full_resolution_time_in_minutes__calendar {
    description: "The average number of minutes to the full resolution"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__calendar} ;;
    drill_fields: [default*]
  }

  measure: average_first_resolution_time_in_hours__business {
    description: "The average number of hours to the first resolution time, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${first_resolution_time_in_hours__business} ;;
    drill_fields: [default*]
  }

  measure: average_first_resolution_time_in_hours__calendar {
    description: "The average number of hours to the first resolution time"
    group_label: "First Resolution Time"
    type: average
    sql: ${first_resolution_time_in_hours__calendar} ;;
    drill_fields: [default*]
  }

  measure: average_full_resolution_time_in_hours__business {
    description: "The average number of hours to the full resolution inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_hours__business} ;;
    drill_fields: [default*]
  }

  measure: average_full_resolution_time_in_hours__calendar {
    description: "The average number of hours to the full resolution"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__calendar} ;;
    drill_fields: [default*]
  }

  measure: average_first_resolution_time_in_days__business {
    description: "The average number of days to the first resolution time, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${first_resolution_time_in_days__business} ;;
    drill_fields: [default*]
  }

  measure: average_first_resolution_time_in_days__calendar {
    description: "The average number of days to the first resolution time"
    group_label: "First Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${first_resolution_time_in_days__calendar} ;;
    drill_fields: [default*]
  }

  measure: average_full_resolution_time_in_days__business {
    description: "The average number of days to the full resolution, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_days__business} ;;
    drill_fields: [default*]
  }

  measure: average_full_resolution_time_in_days__calendar {
    description: "The average number of days to the full resolution"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__calendar} ;;
    drill_fields: [default*]
  }

  measure: average_reply_time_in_minutes__business {
    description: "The average number of minutes to the first reply, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Reply Time"
    type: average
    value_format_name: decimal_2
    sql: ${reply_time_in_minutes__business} ;;
    drill_fields: [default*]
  }

  measure: average_reply_time_in_minutes__calendar {
    description: "The average number of minutes to the first reply"
    group_label: "First Reply Time"
    type: average
    value_format_name: decimal_2
    sql: ${reply_time_in_minutes__calendar} ;;
    drill_fields: [default*]
  }

  measure: median_reply_time_in_minutes__calendar {
    description: "The median number of minutes to the first reply"
    group_label: "First Reply Time"
    type: median
    value_format_name: decimal_2
    sql: ${reply_time_in_minutes__calendar} ;;
    drill_fields: [default*]
  }

  measure: average_reply_time_in_hours__business {
    description: "The average number of hours to the first reply, inside of business hours. Business hours are from M-F, 9am - 5pm PST."
    group_label: "First Reply Time"
    type: average
    value_format_name: decimal_2
    sql: ${reply_time_in_hours__business} ;;
    drill_fields: [default*]
  }

  measure: average_reply_time_in_hours__calendar {
    description: "The average number of hours to the first reply"
    group_label: "First Reply Time"
    type: average
    value_format_name: decimal_2
    sql: ${reply_time_in_hours__calendar} ;;
    drill_fields: [default*]
  }

  measure: sum_number_reopens {
    description: "Sum of the total number of reopens"
    type: sum
    sql: ${TABLE}.reopens ;;
  }

  measure: sum_number_replies {
    description: "Sum of the total number of replies"
    type: sum
    sql: ${TABLE}.replies ;;
  }

  measure: p95_first_reply_time_hours {
    description: "95th percentile of the number of hours it takes for a ticket's first reply"
    type: percentile
    percentile: 95
    value_format: "0.#"
    sql: ${reply_time_in_minutes__calendar}/60 ;;
  }

  measure: p95_full_resolution_time_hours {
    description: "95th percentile of the number of hours it takes for a ticket to be fully resolved"
    type: percentile
    percentile: 95
    value_format: "0.#"
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar/60 ;;
  }

  measure: p95_av_reply_time_hours {
    description: "95th percentile of the number of hours it takes for an Account Verification ticket to be first replied to"
    type: percentile
    percentile: 95
    value_format: "0.#"
    sql: ${av_reply_time_in_minutes__calendar}/60 ;;
  }

  set: default {
    fields: [
      id,
      agent_wait_time_in_minutes__business,
      agent_wait_time_in_minutes__calendar,
      last_assignee_id,
      last_assignee_email,
      first_resolution_time_in_minutes__business,
      first_resolution_time_in_minutes__calendar,
      full_resolution_time_in_minutes__business,
      full_resolution_time_in_minutes__calendar,
      full_resolution_time_in_minutes__calendar_less_than_8_hours,
      full_resolution_time_in_minutes__calendar_less_than_48_hours,
      first_resolution_time_in_hours__business,
      first_resolution_time_in_hours__calendar,
      full_resolution_time_in_hours__business,
      full_resolution_time_in_hours__calendar,
      first_resolution_time_in_days__business,
      first_resolution_time_in_days__calendar,
      full_resolution_time_in_days__business,
      full_resolution_time_in_days__calendar,
      number_reopens,
      number_replies,
      reply_time_in_minutes__business,
      reply_time_in_minutes__calendar,
      reply_time_in_hours__calendar_meet_4_hour_SLA,
      reply_time_in_hours__calendar_meet_2_hour_SLA,
      reply_time_in_hours__business,
      reply_time_in_hours__calendar,
      requester_wait_time_in_minutes__business,
      requester_wait_time_in_minutes__calendar,
      time_solved_at_filtered,
      ticket_id
    ]
  }
}
