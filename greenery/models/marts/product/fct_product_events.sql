{{
    config (
        materalized = 'table'
    )
}}

select
    product_guid,
    product_name,
    unique_sessions,
    unique_orders,
    total_add_to_cart_events,
    total_checkout_events,
    total_page_view_events,
    total_package_shipped_events,
    round((unique_orders::numeric / unique_sessions::numeric) * 100, 2) as product_conversion_rate
from {{ ref('dim_products') }}
order by product_conversion_rate desc

