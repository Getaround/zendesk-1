connection: "getdata"

# include all the views
include: "*.view"

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
    view_label: "Ticket Fact"
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
    view_label: "Ticket Fact"
    type: left_outer
    sql_on: ${tickets.id} = ${ticket_first_and_last_touch.ticket_id} ;;
    relationship: one_to_one
  }

  join: ticket_group_details {
    view_label: "Ticket Fact"
    type: left_outer
    sql_on: ${tickets.id} = ${ticket_group_details.ticket_id} ;;
    relationship: one_to_one
  }

  join: ticket_call_details {
    view_label: "Ticket Call Information"
    type: left_outer
    sql_on: ${tickets.id} = ${ticket_call_details.ticket_id} ;;
    relationship: one_to_many
  }
#
#   join: satisfaction_ratings {
#     view_label: "CSAT Ratings"
#     type: left_outer
#     sql_on: ${tickets.id} = ${satisfaction_ratings.ticket_id} ;;
#     relationship: one_to_many
#   }
}
