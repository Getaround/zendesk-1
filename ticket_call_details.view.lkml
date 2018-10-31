view: ticket_call_details {
  derived_table: {
    sql: SELECT
        audits.id,
        ticket_id,
        events.data__call_duration AS call_duration,
        events.data__answered_by_name AS agent_on_call,
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
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.call_duration::NUMERIC ;;
  }

  dimension: call_duration_minutes {
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.call_duration::NUMERIC / 60 ;;
  }

  dimension: agent_on_call {
    description: "Name of the agent who is on the call"
    type: string
    sql: ${TABLE}.agent_on_call ;;
  }

  dimension: call_location {
    description: "Location of the agent who is on the call"
    type: string
    sql: ${TABLE}.call_location ;;
  }

  dimension: call_number {
    description: "Sequential number of call, associated with each ticket"
    type: number
    sql: ${TABLE}.call_number ;;
  }

  dimension_group: time_started_at {
    type: time
    group_label: "Time Started At"
    description: "Time Call Started At, in the timezone specified by the Looker user"
    label: "Started At"
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
    type: time
    group_label: "Time Started At UTC"
    label: "Started At UTC"
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

  measure: number_of_calls {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [default*]
  }

  measure: sum_call_duration_seconds {
    description: "Sum of call duration, in seconds"
    type: sum
    value_format_name: decimal_0
    sql: ${call_duration_seconds} ;;
    drill_fields: [default*]
  }

  measure: average_call_duration_seconds {
    description: "Average of call duration, in seconds"
    type: average
    value_format_name: decimal_0
    sql: ${call_duration_seconds} ;;
    drill_fields: [default*]
  }

  measure: median_call_duration_seconds {
    description: "Median of call duration, in seconds"
    type: median
    value_format_name: decimal_0
    sql: ${call_duration_seconds} ;;
    drill_fields: [default*]
  }

  measure: sum_call_duration_minutes {
    description: "Sum of call duration, in minutes"
    type: sum
    value_format_name: decimal_2
    sql: ${call_duration_minutes} ;;
    drill_fields: [default*]
  }

  set: default {
    fields: [
      ticket_id,
      call_duration_minutes,
      call_duration_seconds,
      agent_on_call,
      call_location,
      time_started_at_time,
      time_started_at_utc_time
    ]
  }
}
