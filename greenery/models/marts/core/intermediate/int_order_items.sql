{{
    config(
        materialized = 'table'
    )
}}

with item_agg as (
    select
        order_guid,
        sum(quantity) as item_count
    from {{ ref('stg_greenery__order_items') }}
    group by 1
)

, is_unique as (
    select
        order_guid,
        count(distinct product_guid) as unique_items
    from {{ ref('stg_greenery__order_items') }}
    group by 1
)

select
    o.order_guid,
    o.user_guid,
    o.order_total_cost,
    ia.item_count,
    iu.unique_items

from {{ ref('stg_greenery__orders') }} as o
--inner join {{ ref('stg_greenery__order_items') }} as oi
    --on o.order_guid = oi.order_guid
left join item_agg as ia
    on o.order_guid = ia.order_guid
left join is_unique as iu
    on o.order_guid = iu.order_guid