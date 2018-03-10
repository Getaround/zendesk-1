connection: "getdata"

# include all the views
include: "*.view"
include: "/getaround/getaround_trip.view"
include: "/getaround/getaround_car.view"
include: "/getaround/getaround_car_style.view"
include: "/getaround/getaround_user.view"
include: "/getaround/getaround_market.view"
include: "/getaround/getaround_market_timezone.view"
include: "/getaround/edmunds_*.view"

# include all the dashboards
include: "*.dashboard"

explore: audits {
  label: "Ticket Changes"

  join: tickets {
    type: left_outer
    sql_on: ${audits.ticket_id} = ${tickets.id} ;;
    relationship: many_to_one
  }

  join: ticket_custom_fields {
    view_label: "Tickets"
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
    #       type: left_outer
    view_label: "Ticket Changes"
    sql_on: ${audits.id} = ${audits__events.audit_id} ;;
    relationship: one_to_many
  }
}

# - explore: audits__events
#   joins:
#     - join: audits
#       type: left_outer
#       sql_on: ${audits__events._rjm_source_key_id} = ${audits.id}
#       relationship: many_to_one
#
#     - join: tickets
#       type: left_outer
#       sql_on: ${audits.ticket_id} = ${tickets.id}
#       relationship: many_to_one
#
#     - join: organizations
#       type: left_outer
#       sql_on: ${tickets.organization_id} = ${organizations.id}
#       relationship: many_to_one
#
#     - join: requesters
#       from: users
#       type: left_outer
#       sql_on: ${tickets.requester_id} = ${requesters.id}
#       relationship: many_to_one
#
#     - join: assignees
#       from: users
#       type: left_outer
#       sql_on: ${tickets.assignee_id} = ${assignees.id}
#       relationship: many_to_one

explore: organizations {}

explore: ticket_fields {
  label: "Ticket Fields"

  join: tickets__fields {
    view_label: "Ticket Fields"
    sql_on: ${ticket_fields.id_field_name} = ${tickets__fields.ticket_id} ;;
    relationship: one_to_many
  }
}

explore: tickets {

  fields: [
    ALL_FIELDS*,
    -getaround_car.car_fact_dependent*,
    -getaround_user.renter_fact_dependent_fields*,
    -getaround_user.owner_fact_dependent_fields*,
    -getaround_trip.market_fact_dependent*,
    -getaround_trip.renter_fact_dependent*,
    -getaround_trip.car_fact_dependent*,
    -getaround_trip.insurance_dependent*,
    -getaround_trip.user_market_dependent*,
    -getaround_car.closeio_lead_dependent*,
#    -getaround_car.car_style_dependent*,
    -getaround_user.stripe_dependent_fields*,
    -getaround_owner.market_dependent_fields*,
    -getaround_owner.renter_fact_dependent_fields*,
    -getaround_owner.owner_fact_dependent_fields*,
    -getaround_owner.stripe_dependent_fields*
  ]

  join: ticket_custom_fields {
    view_label: "Tickets"
    type: left_outer
    foreign_key: tickets.id
    relationship: one_to_one
  }

  join: getaround_trip {
    foreign_key: ticket_custom_fields.trip_id
    relationship: many_to_one
  }

  join: getaround_user {
    foreign_key: getaround_trip.renter_id
    relationship:  many_to_one
  }

  join: getaround_market {
    foreign_key: getaround_trip.car_parking_address_postcode
    relationship: many_to_one
  }

  join: getaround_market_timezone {
    sql_on: ${getaround_market.market_id} = ${getaround_market_timezone.market_id} AND coalesce(${getaround_market.zone_id},0) = coalesce(${getaround_market_timezone.zone_id},0) ;;
    relationship: one_to_one
  }

  join: getaround_car {
    foreign_key: ticket_custom_fields.car_id
    relationship: many_to_one
  }

  join: getaround_car_style {
    foreign_key: getaround_car.id
    relationship: one_to_one
  }

  join: getaround_owner
  {
    from: getaround_user
    foreign_key: getaround_trip.renter_id
    relationship:  many_to_one
  }

  # Edmunds begins #
  join: edmunds_style {
    view_label: "Edmunds"
    sql_on: ${getaround_car.model_style_id} = ${edmunds_style.id} ;;
    relationship: many_to_one
  }

  join: edmunds_engine {
    view_label: "Edmunds"
    sql_on: ${edmunds_style.engine_id} = ${edmunds_engine.id} ;;
    relationship: many_to_one
  }

  join: edmunds_fuel_economy {
    view_label: "Edmunds"
    sql_on: ${edmunds_style.fuel_economy_id} = ${edmunds_fuel_economy.id} ;;
    relationship: many_to_one
  }

  join: edmunds_price {
    view_label: "Edmunds"
    sql_on: ${edmunds_style.price_id} = ${edmunds_price.id} ;;
    relationship: many_to_one
  }

  join: edmunds_category {
    view_label: "Edmunds"
    sql_on: ${edmunds_style.category_id} = ${edmunds_category.id} ;;
    relationship: many_to_one
  }
  # Edmunds ends #

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

  join: groups {
    type: left_outer
    sql_on: ${tickets.group_id} = ${groups.id} ;;
    relationship: many_to_one
  }
}

# - explore: tickets__fields
#   view_label: 'Ticket fields'

explore: ticket__tags {
  join: tickets {
    type: left_outer
    sql_on: ${ticket__tags.ticket_id} = ${tickets.id} ;;
    relationship: many_to_one
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
}

explore: users {
  join: organizations {
    type: left_outer
    sql_on: ${users.organization_id} = ${organizations.id} ;;
    relationship: many_to_one
  }
}

explore: groups {}

explore: tag_types {}

explore: ticket_metrics {
  join: tickets {
    type: left_outer
    sql_on: ${ticket_metrics.ticket_id} = ${tickets.id} ;;
    relationship: many_to_one
  }

  join: organizations {
    type: left_outer
    sql_on: ${tickets.organization_id} = ${organizations.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${tickets.assignee_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: groups {
    type: left_outer
    sql_on: ${tickets.group_id} = ${groups.id} ;;
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
}
