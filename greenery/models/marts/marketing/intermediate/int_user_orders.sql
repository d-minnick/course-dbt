{{
    config(
        materialized = 'table'
    )
}}

with order_totals as (
    select
        user_guid,
        count(distinct order_guid) as total_orders,
        round(sum(order_total_cost)::numeric, 2) as total_spent
    from {{ ref('stg_greenery__orders') }}
    group by 1
)

select
    u.user_guid,
    u.first_name,
    u.last_name,
    (case when ot.total_orders is null then 0 else ot.total_orders end) as total_orders,
    (case when ot.total_spent is null then 0 else ot.total_spent end) as total_spent
from {{ ref('stg_greenery__users') }} as u
left join order_totals as ot
    on u.user_guid = ot.user_guid
