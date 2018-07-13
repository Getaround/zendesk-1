view: tag_types {
  sql_table_name: zendesk.zendesk_tags ;;

  dimension: count {
    description: "Count Zendesk tags"
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
}
