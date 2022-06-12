{{
    config(
        materialized = 'view'
    )
}}

with products_source as (
    select * from {{ source('src_greenery','products')}}
)

, renamed_recast as (
    select
        product_id as product_guid
        , name as product_name
        , price as price_usd
        , inventory as inventory_qty
    from products_source
)

select * from renamed_recast