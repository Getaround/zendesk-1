view: ticket_call {
  derived_table: {
    sql: SELECT
        audits.id,
        ticket_id,
        events.data__call_duration AS call_duration,
        events.data__answered_by_id AS agent_id,
        CASE
          WHEN audits.metadata__system__location LIKE '%Philippines%' THEN 'Philippines'
          WHEN audits.metadata__system__location LIKE '%San Francisco%' THEN 'San Francisco'
          WHEN audits.metadata__system__location LIKE '%Mountain View%' THEN 'San Francisco'
          WHEN audits.metadata__system__location LIKE '%Englewood, CO%' THEN 'Mexico'
          WHEN audits.metadata__system__location LIKE '%Mexico%' THEN 'Mexico'
          WHEN audits.metadata__system__location LIKE '%United States%' THEN 'United States'
          WHEN audits.metadata__system__location LIKE '%Canada%' THEN 'Canada'
          WHEN audits.metadata__system__location LIKE '%United Kingdom%' THEN 'UK'
          WHEN audits.metadata__system__location LIKE '%United Arab Emirates%' THEN 'UAE'
          ELSE 'Other' END as call_location,
        events.data__started_at as time_call_started_at,
        audits.via__source__rel as call_type,
        ROW_NUMBER() OVER (PARTITION BY ticket_id ORDER BY events.data__started_at) AS call_number
      FROM
        zendesk_stitch.ticket_audits AS audits
      LEFT JOIN
        zendesk_stitch.ticket_audits__events AS events
      ON
        events._sdc_source_key_id = audits.id
      WHERE
        events.data__call_duration IS NOT NULL
       ;;
    indexes: ["ticket_id"]
    sql_trigger_value: SELECT COUNT(*) FROM zendesk_stitch.ticket_audits ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: ticket_id {
    type: number
    hidden: yes
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: call_duration_seconds {
    group_label: "Call Duration"
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.call_duration::NUMERIC ;;
  }

  dimension: call_duration_minutes {
    group_label: "Call Duration"
    type: number
    value_format_name: decimal_2
    sql: ${call_duration_seconds} / 60 ;;
  }

  dimension: agent_id {
    description: "ID of the agent who is on the call"
    type: string
    hidden: yes
    sql: ${TABLE}.agent_id ;;
  }

  dimension: call_location {
    description: "Location of the agent who is on the call"
    type: string
    sql: ${TABLE}.call_location ;;
  }

  dimension: call_number {
    description: "Sequential number of call, associated with each ticket (e.g. first call, second call, etc.)"
    type: number
    sql: ${TABLE}.call_number ;;
  }

  dimension_group: time_started_at {
    description: "Time call started at, in the timezone specified by the Looker user"
    group_label: "Time Started At"
    label: "Started At"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      year,
    ]
    sql: ${TABLE}.time_call_started_at ;;
  }

  dimension_group: time_started_at_utc {
    description: "Time call started at, in UTC"
    group_label: "Time Started At"
    label: "Started At UTC"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      year,
    ]
    sql: ${TABLE}.time_call_started_at ;;
    convert_tz: no
  }

  dimension: call_type {
    description: "Whether the call is an inbound call or an outbound call"
    type: string
    sql: ${TABLE}.call_type ;;
  }

  ### Measures

  measure: count {
    description: "Ticket Call Count"
    type: count
    drill_fields: [default*]
  }

  measure: sum_call_seconds {
    description: "Sum of call duration, in seconds"
    group_label: "Call Duration"
    type: sum
    value_format_name: decimal_0
    sql: ${call_duration_seconds} ;;
    drill_fields: [default*]
  }

  measure: average_call_seconds {
    description: "Average of call duration, in seconds"
    group_label: "Call Duration"
    type: average
    value_format_name: decimal_0
    sql: ${call_duration_seconds} ;;
    drill_fields: [default*]
  }

  measure: median_call_seconds {
    description: "Median of call duration, in seconds"
    group_label: "Call Duration"
    type: median
    value_format_name: decimal_0
    sql: ${call_duration_seconds} ;;
    drill_fields: [default*]
  }

  measure: sum_call_minutes {
    description: "Sum of call duration, in minutes"
    group_label: "Call Duration"
    type: sum
    value_format_name: decimal_2
    sql: ${call_duration_minutes} ;;
    drill_fields: [default*]
  }

  set: default {
    fields: [
      ticket_id,
      call_duration_minutes,
      call_location,
      time_started_at_time,
      time_started_at_utc_time
    ]
  }
}
