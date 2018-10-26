connection: "getdata"

# include all the views
include: "*.view"

explore: audits {
  label: "Ticket Changes"

  join: tickets {
    type: left_outer
    sql_on: ${audits.ticket_id} = ${tickets.id} ;;
    relationship: many_to_one
  }

  join: ticket_facts {
    type: left_outer
    sql_on: ${audits.ticket_id} = ${ticket_facts.ticket_id} ;;
    relationship: many_to_one
  }

  join: ticket_custom_fields {
    type: left_outer
    foreign_key: tickets.id
    relationship: one_to_one
  }

  join: organizations {
    type: left_outer
    sql_on: ${tickets.organization_id} = ${organizations.id} ;;
    relationship: many_to_one
  }

  join: requesters {
    from: users
    type: left_outer
    sql_on: ${tickets.requester_id} = ${requesters.id} ;;
    relationship: many_to_one
  }

  join: assignees {
    from: users
    type: left_outer
    sql_on: ${tickets.assignee_id} = ${assignees.id} ;;
    relationship: many_to_one
  }

  join: audits__events {
    view_label: "Ticket Changes"
    sql_on: ${audits.id} = ${audits__events.audit_id} ;;
    relationship: one_to_many
  }
}

explore: users {
  join: organizations {
    type: left_outer
    sql_on: ${users.organization_id} = ${organizations.id} ;;
    relationship: many_to_one
  }
}

explore: tickets {

  join: ticket_custom_fields {
    type: left_outer
    foreign_key: tickets.id
    relationship: one_to_one
  }

  join: ticket_facts {
    type: left_outer
    foreign_key: tickets.id
    relationship: one_to_one
  }

  join: organizations {
    type: left_outer
    sql_on: ${tickets.organization_id} = ${organizations.id} ;;
    relationship: many_to_one
  }

  join: requesters {
    from: users
    type: left_outer
    sql_on: ${tickets.requester_id} = ${requesters.id} ;;
    relationship: many_to_one
  }

  join: assignees {
    from: users
    type: left_outer
    sql_on: ${tickets.assignee_id} = ${assignees.id} ;;
    relationship: many_to_one
  }

  join: ticket_metrics {
    type: left_outer
    sql_on: ${tickets.id} = ${ticket_metrics.ticket_id} ;;
    relationship: one_to_one
  }

  join: groups {
    type: left_outer
    sql_on: ${tickets.group_id} = ${groups.id} ;;
    relationship: many_to_one
  }

  join: ticket__tags {
    type: left_outer
    sql_on: ${tickets.id} = ${ticket__tags.ticket_id} ;;
    relationship: one_to_many
  }

  join: ticket_first_and_last_touch {
    type: left_outer
    sql_on: ${tickets.id} = ${ticket_first_and_last_touch.ticket_id} ;;
    relationship: one_to_one
  }
}
