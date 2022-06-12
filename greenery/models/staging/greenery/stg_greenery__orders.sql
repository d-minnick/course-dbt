{{
    config(
        materialized = 'view'
    )
}}

with orders_source as (
    select * from {{ source('src_greenery','orders')}}
)

, renamed_recast as (
    select
        order_id as order_guid
        , user_id as user_guid
        , promo_id as promo_type
        , address_id as address_guid
        , created_at as created_at_utc
        , order_cost
        , shipping_cost
        , order_total as order_total_cost
        , tracking_id as tracking_guid
        , shipping_service
        , estimated_delivery_at as estimated_delivery_at_utc
        , delivered_at as delivered_at_utc
        , status as order_status
        from orders_source
)

select * from renamed_recast