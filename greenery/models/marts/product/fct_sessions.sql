{{
    config(
        materialized = 'table'
    )
}}

select
    se.session_guid,
    se.user_guid,
    du.first_name,
    du.last_name,
    du.user_email,
    se.page_view,
    se.add_to_cart,
    se.checkout,
    se.package_shipped,
    sl.first_event,
    sl.last_event,
    sl.session_length_minutes

from {{ ref('int_session_events_agg') }} as se
left join {{ ref('dim_users') }} as du
    on se.user_guid = du.user_guid
left join {{ ref('int_session_length') }} as sl
    on se.session_guid = sl.session_guid