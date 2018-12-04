view: ticket_group_touches {
  derived_table: {
    sql: SELECT
        DISTINCT audits.ticket_id AS ticket_id,
        groups.name AS first_group,
        events.value AS first_group_id
      FROM
        zendesk_stitch.ticket_audits__events AS events
      LEFT JOIN
        zendesk_stitch.ticket_audits AS audits
      ON
        audits.id = events._sdc_source_key_id
      LEFT JOIN
        zendesk_stitch.groups AS groups
      ON
        groups.id::text = events.value
      WHERE
        events.field_name = 'group_id'
        AND events.type = 'Create'
       ;;
    indexes: ["ticket_id"]
    sql_trigger_value: SELECT COUNT(*) FROM zendesk_stitch.ticket_audits__events ;;
  }

  dimension: ticket_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: first_group {
    description: "The name of the first group the ticket was assigned to"
    view_label: "Ticket First Touch"
    type: string
    sql: ${TABLE}.first_group ;;
  }

  dimension: last_group {
    description: "The name of the last group the ticket was assigned to"
    view_label: "Ticket Last Touch"
    type: string
    sql: ${tickets.group_name} ;;
  }

  dimension: first_group_id {
    description: "The id of the first group the ticket was assigned to"
    type: string
    hidden: yes
    sql: ${TABLE}.first_group_id ;;
  }

  set: default {
    fields: [
      ticket_id,
      first_group,
      first_group_id
    ]
  }
}
