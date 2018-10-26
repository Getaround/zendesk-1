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
        FIRST_VALUE(author_id) OVER (PARTITION BY ticket_id ORDER BY audits.created_at ASC) AS first_touch_agent_id,
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
        FIRST_VALUE(author_id) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_touch_agent_id
      FROM
        zendesk_stitch.ticket_audits AS audits
      LEFT JOIN
        zendesk_stitch.users AS users
      ON
        users.id = audits.author_id
      WHERE
        users.role IN ('agent', 'admin')
       ;;
  }

  dimension: ticket_id {
    type: number
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: first_touch_agent_location {
    type: string
    sql: ${TABLE}.first_touch_agent_location ;;
  }

  dimension: first_touch_agent_id {
    type: number
    sql: ${TABLE}.first_touch_agent_id ;;
  }

  dimension: last_touch_agent_location {
    type: string
    sql: ${TABLE}.last_touch_agent_location ;;
  }

  dimension: last_touch_agent_id {
    type: number
    sql: ${TABLE}.last_touch_agent_id ;;
  }

  set: detail {
    fields: [ticket_id, first_touch_agent_location, first_touch_agent_id, last_touch_agent_location, last_touch_agent_id]
  }
}
