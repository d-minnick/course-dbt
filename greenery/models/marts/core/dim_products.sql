{{
    config(
        materialized = 'table'
    )
}}

with item_total as (
    select
        product_guid,
        count(*) as total_ordered
    from {{ ref('stg_greenery__order_items')}}
    group by 1
)

select
    p.product_guid,
    p.product_name,
    p.price_usd,
    p.inventory_qty,
    it.total_ordered

from {{ ref('stg_greenery__products') }} as p
left join {{ ref('stg_greenery__order_items') }} as oi
    on p.product_guid = oi.product_guid
left join item_total as it
    on p.product_guid = it.product_guid
