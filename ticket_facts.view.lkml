view: ticket_facts {
  derived_table: {
    sql: SELECT
          audits.ticket_id,
          tickets.status,
          tickets.via__channel,
          tickets.via__source__rel,
          tickets.via__source__to__name,
          groups.name,
          metrics.group_stations AS number_of_groups_involved,
          COUNT(DISTINCT audits.id) FILTER(WHERE audits.via__channel = 'voice' AND audits.via__source__from__name = 'Getaround'
                                  AND audits.via__source__rel = 'outbound')  AS number_outbound_calls,
          COUNT(DISTINCT audits.id) FILTER(WHERE (audits.via__channel = 'voice' AND audits.via__source__to__name = 'Getaround'
                                  AND audits.via__source__rel = 'inbound')
                                  OR (audits.via__channel = 'voice' AND audits.via__source__rel = 'voicemail'))  AS number_inbound_calls,
          COUNT(DISTINCT audits.id) FILTER(WHERE (events.type = 'Comment' AND events.public = true AND audits.via__source__to__name = 'Getaround')
                                  OR (events.type = 'Comment' AND events.public = true AND audits.via__channel = 'mobile_sdk')
                                  OR (events.type = 'Comment' AND events.public = true AND audits.via__source__rel = 'follow_up'))  AS number_inbound_emails,
          COUNT(DISTINCT audits.id) FILTER(WHERE events.type = 'Comment' AND events.public = true AND audits.via__channel <> 'mobile_sdk' AND
                                 (audits.via__source__to__name IS NULL OR audits.via__source__to__name <> 'Getaround'))  AS number_outbound_emails,
          COUNT(DISTINCT audits.id) FILTER(WHERE events.type = 'Comment' AND events.public = false)  AS number_internal_comments,
          COUNT(DISTINCT audits.id) FILTER(WHERE audits.via__source__rel = 'merge' and audits.via__source__from__ticket_id IS NULL) AS number_merged_tickets,
          COUNT(DISTINCT audits.id) FILTER(WHERE audits.via__source__rel = 'merge' and audits.via__source__from__ticket_id IS NOT NULL)  AS is_ticket_merged,
          COUNT(DISTINCT tickets.id) FILTER(WHERE tickets.via__channel = 'api') AS is_auto_created

        FROM
        zendesk.audits AS audits

        LEFT JOIN zendesk.audits__events AS events
        ON events.audit_id = audits.id

        LEFT JOIN zendesk.tickets AS tickets
        ON audits.ticket_id = tickets.id

        LEFT JOIN zendesk.zendesk_ticket_metrics AS metrics
        ON audits.ticket_id = metrics.ticket_id

        LEFT JOIN zendesk.zendesk_groups AS groups
        ON tickets.group_id = groups.id
        GROUP BY 1,2,3,4,5,6,7 ;;

    indexes: ["ticket_id"]
    sql_trigger_value: SELECT COUNT(*) FROM zendesk.tickets ;;
   }

    dimension: ticket_id {
      primary_key: yes
      type: number
      hidden: yes
      sql: ${TABLE}.ticket_id ;;
    }

    dimension: status {
      hidden: yes
      type: string
      sql: ${TABLE}.status ;;
    }

    dimension: via__channel {
      hidden: yes
      type: string
      sql: ${TABLE}.via__channel ;;
    }

    dimension: via__source__rel {
      hidden: yes
      type: string
      sql: ${TABLE}.via__source__rel ;;
    }

    dimension: ticket_source {
      description: "How the ticket was created"
      group_label: "Ticket Details"
      type: string
      sql: CASE WHEN ${via__channel} = 'voice' AND ${via__source__rel} = 'inbound' THEN 'Inbound Call'
           WHEN ${via__channel} = 'voice' AND ${via__source__rel} = 'outbound' THEN 'Outbound Call'
           WHEN ${via__channel} = 'voice' AND ${via__source__rel} = 'voicemail' THEN 'Inbound Voicemail'
           WHEN ${via__channel} = 'email' AND ${via__source__rel} IS NULL AND (${requesters.email} = 'no-reply@getaround.com'
                                    OR ${requesters.email} LIKE '%@shadowfam.com') THEN 'Managed Tickets - Email'
           WHEN ${via__channel} = 'email' AND ${via__source__rel} IS NULL THEN 'Inbound Email'
           WHEN ${via__channel} = 'api' AND ${via__source__rel} IS NULL AND ${requesters.email} = 'zendesk@getaround.com' THEN 'Sentinel'
           WHEN ${via__channel} = 'api' AND ${via__source__rel} IS NULL THEN 'Internally Generated'
           WHEN ${via__channel} = 'sms' AND ${via__source__rel} IS NULL THEN 'Managed Tickets - SMS'
           WHEN ${via__channel} = 'mobile_sdk' AND ${via__source__rel} = 'mobile_sdk' THEN 'Inbound Email (from GA App)'
           WHEN ${via__channel} = 'facebook' AND ${via__source__rel} IN ('message', 'post') THEN 'Facebook Message'
           WHEN ${via__channel} = 'twitter' AND ${via__source__rel} IN ('direct_message', 'mention') THEN 'Twitter Message'
           WHEN ${via__channel} = 'web' AND ${via__source__rel} = 'follow_up' THEN 'Follow-up Ticket'
           WHEN ${via__channel} = 'web' AND ${via__source__rel} IS NULL AND ${number_outbound_emails} > 0 THEN 'Outbound Email'
           ELSE NULL END;;
    }

    dimension: group_name {
      description: "Ticket's group name. (If ticket was in more than one group, the group name defaults to the last assigned group)"
      type: string
      sql: ${TABLE}.name ;;
    }

    dimension: via__source__to__name {
      hidden: yes
      type: string
      sql: ${TABLE}.via__source__to__name ;;
    }

    dimension: multiple_groups_involved {
      description: "Yes, if the ticket has changed assigned group at any point."
      group_label: "Activity Details"
      type: yesno
      sql: ${TABLE}.number_of_groups_involved > 0 ;;
    }

    dimension: number_outbound_calls {
      description: "Number of outbound calls associated with ticket"
      group_label: "Activity Counts"
      type: number
      sql: ${TABLE}.number_outbound_calls ;;
    }

    dimension: has_outbound_calls {
      description: "Yes, if ticket has associated outbound calls"
      group_label: "Activity Details"
      type: yesno
      sql: ${number_outbound_calls} > 0 ;;
    }

    dimension: number_inbound_calls {
      description: "Number of inbound calls associated with ticket"
      group_label: "Activity Counts"
      type: number
      sql: ${TABLE}.number_inbound_calls ;;
    }

    dimension: has_inbound_calls {
      description: "Yes, if ticket has associated inbound calls"
      group_label: "Activity Details"
      type: yesno
      sql: ${number_inbound_calls} > 0 ;;
    }

    dimension: number_inbound_emails {
      description: "Number of inbound emails associated with ticket"
      group_label: "Activity Counts"
      type: number
      sql: ${TABLE}.number_inbound_emails ;;
    }

    dimension: has_inbound_emails {
      description: "Yes, if ticket has associated inbound emails"
      group_label: "Activity Details"
      type: yesno
      sql: ${number_inbound_emails} > 0 ;;
    }

    dimension: involves_customer {
      description: "Yes, if ticket has inbound or outbound activity"
      group_label: "Ticket Details"
      type: yesno
      sql: ${number_inbound_calls} > 0 OR ${number_inbound_emails} > 0 OR ${number_outbound_calls} > 0 OR ${number_outbound_emails} > 0 ;;
    }

    dimension: is_first_touch_resolution_email {
      description: "Yes, if inbound email was solved at first agent touch"
      group_label: "Activity Details"
      type: yesno
      sql: ${ticket_source} LIKE 'Inbound Email%'
         AND ${status} IN ('solved', 'closed')
         AND (${number_outbound_emails} + ${number_outbound_calls}) = 1 ;;
    }

    dimension: is_eligible_for_first_touch_resolution_email {
      description: "Yes, if inbound email was solved and has outbound activity"
      group_label: "Activity Details"
      type: yesno
      sql: ${ticket_source} LIKE 'Inbound Email%'
          AND ${status} IN ('solved', 'closed')
          AND (${number_outbound_emails} + ${number_outbound_calls}) >= 1 ;;
    }

    dimension: is_first_touch_resolution_phone_call {
      description: "Yes, if inbound phone call was solved at first agent touch"
      group_label: "Activity Details"
      type: yesno
      sql: ${ticket_source} IN ('Inbound Call','Inbound Voicemail')
           AND ${status} IN ('solved', 'closed')
           AND ${number_inbound_calls} = 1
           AND (${number_outbound_emails} + ${number_outbound_calls}) = 0 ;;
    }

    dimension: is_eligible_for_first_touch_resolution_phone_call {
      description: "Yes, if inbound phone call was solved"
      group_label: "Activity Details"
      type: yesno
      sql: ${ticket_source} IN ('Inbound Call','Inbound Voicemail')
           AND ${status} IN ('solved', 'closed')
           AND ${number_inbound_calls} >= 1 ;;
    }

    dimension: number_outbound_emails {
      description: "Number of outbound emails associated with ticket"
      group_label: "Activity Counts"
      type: number
      sql: ${TABLE}.number_outbound_emails ;;
    }

    dimension: has_outbound_emails {
      description: "Yes, if ticket has associated outbound emails"
      group_label: "Activity Details"
      type: yesno
      sql: ${number_outbound_emails} > 0 ;;
    }

    dimension: number_internal_comments {
      description: "Number of internal comments associated with ticket"
      group_label: "Activity Counts"
      type: number
      sql: ${TABLE}.number_internal_comments ;;
    }

    dimension: has_internal_comments {
      description: "Yes, if ticket has internal comments created"
      group_label: "Activity Details"
      type: yesno
      sql: ${number_internal_comments} > 0 ;;
    }

    dimension: is_parent_to_merged_tickets {
      description: "Yes, if the ticket is the parent to other merged tickets"
      group_label: "Ticket Details"
      type: yesno
      sql: ${TABLE}.number_merged_tickets > 0 ;;
    }

    dimension: is_ticket_merged {
      description: "Yes, if the ticket has been merged into another ticket"
      group_label: "Ticket Details"
      type: yesno
      sql: ${TABLE}.is_ticket_merged > 0 ;;
    }

    dimension: is_automatically_generated {
      description: "Yes, if ticket has been created automatically.  Generally via Sentinel"
      group_label: "Ticket Details"
      type: yesno
      sql: ${TABLE}.is_auto_created > 0 ;;
    }

    measure: count {
      description: "Count Tickets"
      type: count_distinct
      sql: ${ticket_id} ;;
      drill_fields: [detail*]
    }

    set: detail {
      fields: [
        ticket_id,
        status,
        via__channel,
        via__source__rel,
        via__source__to__name,
        multiple_groups_involved,
        number_outbound_calls,
        number_inbound_calls,
        number_inbound_emails,
        number_outbound_emails,
        number_internal_comments,
        is_parent_to_merged_tickets,
        is_ticket_merged,
        is_automatically_generated
      ]
    }
  }
