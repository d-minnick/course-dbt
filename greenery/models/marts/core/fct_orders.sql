{{
    config(
        materialized = 'table'
    )
}}

select
    o.order_guid,
    du.first_name,
    du.last_name,
    du.user_email,
    ioi.order_total_cost,
    ioi.item_count,
    o.created_at_utc,
    o.estimated_delivery_at_utc,
    o.delivered_at_utc,
    (date_part('day', o.delivered_at_utc::timestamp - o.created_at_utc::timestamp) * 24 +
        date_part('hour', o.delivered_at_utc::timestamp - o.created_at_utc::timestamp))
        as hours_to_deliver,
    o.order_status,
    o.promo_type,
    du.country

from {{ ref('stg_greenery__orders') }} as o
left join {{ ref('int_order_items') }} as ioi
    on o.order_guid = ioi.order_guid
left join {{ ref('dim_users') }} as du
    on o.user_guid = du.user_guid


