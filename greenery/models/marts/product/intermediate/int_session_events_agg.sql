{{
    config(
        materialized = 'table'
    )
}}

/*select
    session_guid,
    user_guid,
    product_guid,
    created_at_utc,
     sum (case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart,
    sum (case when event_type = 'checkout' then 1 else 0 end) as checkout,
    sum (case when event_type = 'page_view' then 1 else 0 end) as page_view,
    sum (case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped
from {{ ref('stg_greenery__events') }}
group by 1,2,3,4 
*/

{%- set event_types = get_event_types() -%}
select
    session_guid,
    user_guid,
    product_guid,
    created_at_utc,
    {%- for event_type in event_types %}
        sum(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}
        {%- if not loop.last %},{% endif -%}
    {% endfor %}
from {{ ref('stg_greenery__events') }}
group by 1, 2, 3, 4

