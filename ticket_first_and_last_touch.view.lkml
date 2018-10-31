view: ticket_first_and_last_touch {
  derived_table: {
    sql: SELECT
        distinct ticket_id,
        FIRST_VALUE(CASE
                      WHEN audits.metadata__system__location LIKE '%Philippines%' THEN 'Philippines'
                      WHEN audits.metadata__system__location LIKE '%San Francisco%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Mountain View%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Englewood, CO%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%Mexico%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%United States%' THEN 'United States'
                      WHEN audits.metadata__system__location LIKE '%Canada%' THEN 'Canada'
                      WHEN audits.metadata__system__location LIKE '%United Kingdom%' THEN 'UK'
                      WHEN audits.metadata__system__location LIKE '%United Arab Emirates%' THEN 'UAE'
                      ELSE 'Other' END) OVER (PARTITION BY ticket_id ORDER BY audits.created_at ASC) AS first_touch_agent_location,
        FIRST_VALUE(users.name) OVER (PARTITION BY ticket_id ORDER BY audits.created_at ASC) AS first_touch_agent_name,
        FIRST_VALUE(audits.created_at) OVER (PARTITION BY ticket_id ORDER BY audits.created_at ASC) AS first_touch_created_at,
        FIRST_VALUE(CASE
                      WHEN audits.metadata__system__location LIKE '%Philippines%' THEN 'Philippines'
                      WHEN audits.metadata__system__location LIKE '%San Francisco%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Mountain View%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Englewood, CO%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%Mexico%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%United States%' THEN 'United States'
                      WHEN audits.metadata__system__location LIKE '%Canada%' THEN 'Canada'
                      WHEN audits.metadata__system__location LIKE '%United Kingdom%' THEN 'UK'
                      WHEN audits.metadata__system__location LIKE '%United Arab Emirates%' THEN 'UAE'
                      ELSE 'Other' END) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_touch_agent_location,
        FIRST_VALUE(users.name) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_touch_agent_name,
        FIRST_VALUE(audits.author_id) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_agent_id,
        FIRST_VALUE(audits.created_at) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_touch_created_at
      FROM
        zendesk_stitch.ticket_audits AS audits
      LEFT JOIN
        zendesk_stitch.users AS users
      ON
        users.id = audits.author_id
      LEFT JOIN
        zendesk_stitch.ticket_audits__events as events
      ON
        events._sdc_source_key_id = audits.id
      WHERE
          (users.role = 'agent' OR users.role = 'admin')
        AND
          users.email != 'zendesk@getaround.com'
        AND
          ((events.public = true
           AND
          events.type = 'Comment')
        OR
          audits.via__channel = 'voice')
       ;;
    indexes: ["ticket_id"]
    sql_trigger_value: SELECT COUNT(*) FROM zendesk_stitch.ticket_audits ;;
  }

 dimension: ticket_id {
    primary_key: yes
    type: number
    hidden: no
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: first_touch_agent_location {
    description: "Location of agent who was the first agent to make a change to the ticket"
    group_label: "First Touch"
    type: string
    sql: ${TABLE}.first_touch_agent_location ;;
  }

  dimension: first_touch_agent_name {
    description: "ID of agent who was the first agent to make a change to the ticket"
    group_label: "First Touch"
    type: string
    sql: ${TABLE}.first_touch_agent_name ;;
  }

  dimension_group: first_touch_created_at {
    type: time
    group_label: "Time First Touch Created At"
    description: "First Touch Created At, in the timezone specified by the Looker user"
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
    sql: ${TABLE}.first_touch_created_at ;;
  }


  dimension_group: first_touch_created_at_utc {
    type: time
    group_label: "Time First Touch Created At UTC"
    label: "Last First Created At UTC"
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
    sql: ${TABLE}.first_touch_created_at ;;
    convert_tz: no
  }

  dimension: last_touch_agent_location {
    description: "Location of agent who was the last agent to make a change to the ticket"
    group_label: "Last Touch"
    type: string
    sql: ${TABLE}.last_touch_agent_location ;;
  }

  dimension: last_touch_agent_name {
    description: "ID of agent who was the last agent to make a change to the ticket"
    group_label: "Last Touch"
    type: string
    sql: ${TABLE}.last_touch_agent_name ;;
  }

  dimension_group: last_touch_created_at {
    type: time
    group_label: "Time Last Touch Created At"
    description: "Last Touch Created At, in the timezone specified by the Looker user"
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
    sql: ${TABLE}.last_touch_created_at ;;
  }

  dimension_group: last_touch_created_at_utc {
    type: time
    group_label: "Time Last Touch Created At UTC"
    label: "Last Touch Created At UTC"
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
    sql: ${TABLE}.last_touch_created_at ;;
    convert_tz: no
  }

  set: default {
    fields: [
      ticket_id,
      first_touch_agent_location,
      first_touch_agent_name,
      first_touch_created_at_time,
      last_touch_agent_location,
      last_touch_agent_name,
      last_touch_created_at_time
    ]
  }
}
