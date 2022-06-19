{{
    config(
        materialized = 'table'
    )
}}

with min_order as (
    select
        user_guid,
        min(created_at_utc)::timestamp as first_order
    from {{ ref('stg_greenery__orders') }}
    group by 1
)

, max_order as (
    select
        user_guid,
        max(created_at_utc)::timestamp as latest_order
    from {{ ref('stg_greenery__orders') }}
    group by 1
)

select
    u.user_guid,
    u.first_name,
    u.last_name,
    a.address,
    a.state,
    a.zipcode,
    a.country,
    u.phone_number,
    u.user_email,
    u.created_at_utc,
    min.first_order,
    max.latest_order

from {{ ref('stg_greenery__users') }} as u
left join {{ ref('stg_greenery__addresses') }} as a
    on u.address_guid = a.address_guid
left join min_order as min
    on u.user_guid = min.user_guid
left join max_order as max
    on u.user_guid = max.user_guid

    