{{
    config(
        materialized = 'table'
    )
}}

with order_totals as (
    select
        product_guid,
        count(*) as total_ordered,
        count (distinct order_guid) as unique_orders
    from {{ ref('stg_greenery__order_items')}}
    group by 1
)

, event_totals as (
    select
        product_guid,
        count (distinct session_guid)::integer as unique_sessions,
        sum(add_to_cart) as total_add_to_cart_events,
        sum(checkout) as total_checkout_events,
        sum(page_view) as total_page_view_events,
        sum(package_shipped) as total_package_shipped_events
    from {{ ref('int_session_events_agg') }}
    group by 1
)

select
    p.product_guid,
    p.product_name,
    p.price_usd,
    p.inventory_qty,
    ot.total_ordered,
    ot.unique_orders,
    et.unique_sessions,
    et.total_add_to_cart_events,
    et.total_checkout_events,
    et.total_page_view_events,
    et.total_package_shipped_events

from {{ ref('stg_greenery__products') }} as p
left join order_totals as ot
    on p.product_guid = ot.product_guid
left join event_totals as et
    on p.product_guid = et.product_guid
