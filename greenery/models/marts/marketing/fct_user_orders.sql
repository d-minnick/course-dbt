{{
    config(
        materialized = 'table'
    )
}}

with item_counts as (
    select
        user_guid,
        sum(item_count) as total_items,
        round(avg(item_count)) as avg_items_per_order,
        round(avg(unique_items)) as avg_unique_items_per_order,
        round(avg(order_total_cost)::numeric, 2) as avg_spent_per_order
    from {{ ref('int_order_items') }}
    group by 1
)


select
    uo.user_guid,
    uo.first_name,
    uo.last_name,
    uo.total_orders,
    uo.total_spent,
    ic.avg_spent_per_order,
    ic.total_items,
    ic.avg_items_per_order,
    ic.avg_unique_items_per_order,
    du.first_order,
    du.latest_order


from {{ ref('int_user_orders') }} as uo
left join item_counts as ic
    on uo.user_guid = ic.user_guid
left join {{ ref('dim_users') }} as du
    on uo.user_guid = du.user_guid