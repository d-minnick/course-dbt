{{
    config(
        materialized = 'view'
    )
}}

with promos_source as (
    select * from {{ source('src_greenery','promos')}}
)

, renamed_recast as (
    select
        promo_id as promo_type
        , discount
        , status as promo_status
    from promos_source
)

select * from renamed_recast