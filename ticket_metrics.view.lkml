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
    description: "The number of minutes the agent spent waiting, inside of business hours"
    group_label: "Wait Time"
    type: number
    sql: ${TABLE}.agent_wait_time_in_minutes__business ;;
  }

  dimension: agent_wait_time_in_minutes__calendar {
    description: "The number of minutes the agent spent waiting"
    group_label: "Wait Time"
    type: number
    sql: ${TABLE}.agent_wait_time_in_minutes__calendar ;;
  }

  dimension_group: time_last_assigned_at {
    description: "The time the ticket was last assigned"
    group_label: "Time Last Assigned At"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.assigned_at ;;
  }

  dimension: last_assignee_id {
    description: "The id of the user last assigned to the ticket"
    type: number
    sql: ${tickets.assignee_id} ;;
  }

  dimension: last_assignee_email {
    description: "The email address of the user last assigned to the ticket"
    type: string
    sql: ${assignees.email} ;;
  }

  dimension: last_group_name {
    description: "The name of the group last assigned to the ticket"
    type: string
    sql: ${groups.name} ;;
  }

  dimension_group: time_last_updated_at {
    description: "The time the assignee last updated the ticket"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    hidden: yes
    sql: ${TABLE}.assignee_updated_at ;;
  }

  dimension_group: time_created_at {
    description: "The time the ticket metric was created"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    hidden: yes
    sql: ${TABLE}.created_at ;;
  }

  dimension: organization_name {
    description: "The name of the organization associated with this ticket"
    type: string
    sql: ${tickets.organization_name} ;;
  }

  # MINUTES

  dimension: first_resolution_time_in_minutes__business {
    description: "The number of minutes to the first resolution time, inside of business hours"
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.first_resolution_time_in_minutes__business ;;
  }

  measure: avg_first_resolution_time_in_minutes__business {
    description: "The average number of minutes to the first resolution time, inside of business hours"
    group_label: "First Resolution Time"
    type: average
    sql: ${first_resolution_time_in_minutes__business} ;;
  }

  dimension: first_resolution_time_in_minutes__calendar {
    description: "The number of minutes to the first resolution time"
    group_label: "First Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.first_resolution_time_in_minutes__calendar ;;
  }

  measure: avg_first_resolution_time_in_minutes__calendar {
    description: "The average number of minutes to the first resolution time"
    group_label: "First Resolution Time"
    type: average
    sql: ${first_resolution_time_in_minutes__calendar} ;;
  }

  dimension: full_resolution_time_in_minutes__business {
    description: "The number of minutes to the full resolution inside of business hours"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__business ;;
  }

  measure: avg_full_resolution_time_in_minutes__business {
    description: "The average number of minutes to the full resolution inside of business hours"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__business} ;;
  }

  dimension: full_resolution_time_in_minutes__calendar {
    description: "The number of minutes to the full resolution"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar ;;
  }

  measure: avg_full_resolution_time_in_minutes__calendar {
    description: "The average number of minutes to the full resolution"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__calendar} ;;
  }

  dimension: full_resolution_time_in_minutes__calendar_less_than_8_hours {
    description: "\"Yes\" if the ticket was solved within the first 8 calendar hours"
    label: "Full Resolution Time Meets 8 hour SLA"
    group_label: "SLA"
    type: yesno
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar <= 480 ;;
  }

  # HOURS

  dimension: first_resolution_time_in_hours__business {
    description: "The number of hours to the first resolution time, inside of business hours"
    group_label: "First Resolution Time"
    type: number
    sql: (${TABLE}.first_resolution_time_in_minutes__business / 60) ;;
  }

  measure: average_first_resolution_time_in_hours__business {
    description: "The average number of hours to the first resolution time, inside of business hours"
    group_label: "First Resolution Time"
    type: average
    sql: ${first_resolution_time_in_hours__business} ;;
  }

  dimension: first_resolution_time_in_hours__calendar {
    description: "The number of hours to the first resolution time"
    group_label: "First Resolution Time"
    type: number
    sql: (${TABLE}.first_resolution_time_in_minutes__calendar / 60) ;;
  }

  measure: average_first_resolution_time_in_hours__calendar {
    description: "The average number of hours to the first resolution time"
    group_label: "First Resolution Time"
    type: average
    sql: ${first_resolution_time_in_hours__calendar} ;;
  }

  dimension: full_resolution_time_in_hours__business {
    description: "The number of hours to the full resolution inside of business hours"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__business / 60 ;;
  }

  measure: avg_full_resolution_time_in_hours__business {
    description: "The average number of hours to the full resolution inside of business hours"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_hours__business} ;;
  }

  dimension: full_resolution_time_in_hours__calendar {
    description: "The number of hours to the full resolution"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar / 60 ;;
  }

  measure: avg_full_resolution_time_in_hours__calendar {
    description: "The average number of hours to the full resolution"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__calendar} ;;
  }

  # DAYS

  dimension: first_resolution_time_in_days__business {
    description: "The number of days to the first resolution time, inside of business hours"
    group_label: "First Resolution Time"
    type: number
    sql: (${TABLE}.first_resolution_time_in_minutes__business / 480) ;;
  }

  measure: average_first_resolution_time_in_days__business {
    description: "The average number of days to the first resolution time, inside of business hours"
    group_label: "First Resolution Time"
    type: average
    sql: ${first_resolution_time_in_days__business} ;;
  }

  dimension: first_resolution_time_in_days__calendar {
    description: "The number of days to the first resolution time"
    group_label: "First Resolution Time"
    type: number
    sql: (${TABLE}.first_resolution_time_in_minutes__calendar / 1440) ;;
  }

  measure: average_first_resolution_time_in_days__calendar {
    description: "The average number of days to the first resolution time"
    group_label: "First Resolution Time"
    type: average
    sql: ${first_resolution_time_in_days__calendar} ;;
  }

  dimension: full_resolution_time_in_days__business {
    description: "The number of days to the full resolution, inside of business hours"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__business / 480 ;;
  }

  measure: avg_full_resolution_time_in_days__business {
    description: "The average number of days to the full resolution, inside of business hours"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_days__business} ;;
  }

  dimension: full_resolution_time_in_days__calendar {
    description: "The number of days to the full resolution"
    group_label: "Full Resolution Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.full_resolution_time_in_minutes__calendar / 1440 ;;
  }

  measure: avg_full_resolution_time_in_days__calendar {
    description: "The average number of days to the full resolution"
    group_label: "Full Resolution Time"
    type: average
    value_format_name: decimal_2
    sql: ${full_resolution_time_in_minutes__calendar} ;;
  }

  dimension_group: time_initially_assigned_at {
    description: "The time the ticket was initially assigned"
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
    description: "The time the last comment was added to the ticket"
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

  # FIRST REPLY MINUTES

  dimension: reply_time_in_minutes__business {
    description: "The number of minutes to the first reply, inside of business hours"
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__business ;;
  }

  measure: avg_reply_time_in_minutes__business {
    description: "The average number of minutes to the first reply, inside of business hours"
    group_label: "First Reply Time"
    type: average
    sql: ${reply_time_in_minutes__business} ;;
  }

  dimension: reply_time_in_minutes__calendar {
    description: "The number of minutes to the first reply"
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__calendar ;;
  }

  measure: avg_reply_time_in_minutes__calendar {
    description: "The average number of minutes to the first reply"
    group_label: "First Reply Time"
    type: average
    value_format_name: decimal_2
    sql: ${reply_time_in_minutes__calendar} ;;
  }

  measure: median_reply_time_in_minutes__calendar {
    description: "The median number of minutes to the first reply"
    group_label: "First Reply Time"
    type: median
    value_format_name: decimal_2
    sql: ${reply_time_in_minutes__calendar} ;;
  }

  dimension: reply_time_in_hours__calendar_meet_SLA {
    description: "\"Yes\" if the ticket was first replied to within the first 4 calendar hours"
    label: "First Reply Time Meets 4 hour SLA"
    group_label: "SLA"
    type: yesno
    sql: ${TABLE}.reply_time_in_minutes__calendar <= 240 ;;
  }

  # FIRST REPLY HOURS

  dimension: reply_time_in_hours__business {
    description: "The number of hours to the first reply, inside of business hours"
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__business / 60 ;;
  }

  measure: avg_reply_time_in_hours__business {
    description: "The average number of hours to the first reply, inside of business hours"
    group_label: "First Reply Time"
    type: average
    sql: ${reply_time_in_hours__business} ;;
  }

  dimension: reply_time_in_hours__calendar {
    description: "The number of hours to the first reply"
    group_label: "First Reply Time"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.reply_time_in_minutes__calendar / 60 ;;
  }

  measure: avg_reply_time_in_hours__calendar {
    description: "The average number of hours to the first reply"
    group_label: "First Reply Time"
    type: average
    value_format_name: decimal_2
    sql: ${reply_time_in_hours__calendar} ;;
  }

  dimension_group: time_requester_updated_at {
    description: "The time the requester last updated the ticket"
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
    description: "The number of minutes the requester spent waiting inside of business hours"
    group_label: "Wait Time"
    type: number
    sql: ${TABLE}.requester_wait_time_in_minutes__business ;;
  }

  dimension: requester_wait_time_in_minutes__calendar {
    description: "The number of minutes the requester spent waiting"
    group_label: "Wait Time"
    type: number
    sql: ${TABLE}.requester_wait_time_in_minutes__calendar ;;
  }

  dimension_group: time_solved_at {
    alias: [solved]
    type: time
    group_label: "Time Solved At"
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
    description: "Use this field with the Time Created At Filter.  Using this field allows you to adjust the time frame dynamically"
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

  ### Measures

  measure: count {
    description: "Count Zendesk ticket metrics"
    type: count
    drill_fields: [id, tickets.via__source__from__name, tickets.id, tickets.via__source__to__name]
  }
}
