{{
    config(
        materialized = 'table'
    )
}}

with min_max as (
    select
        session_guid,
        min(created_at_utc) as first_event,
        max(created_at_utc) as last_event
    from {{ ref('stg_greenery__events') }}
    group by 1
)

select
    e.session_guid,
    mm.first_event,
    mm.last_event,
    (date_part('day', mm.last_event::timestamp - mm.first_event::timestamp) * 24 +
        date_part('hour', mm.last_event::timestamp - mm.first_event::timestamp)) * 60 +
        date_part('minute', mm.last_event::timestamp - mm.first_event::timestamp)
    as session_length_minutes
from {{ ref('stg_greenery__events') }} as e
left join min_max as mm
    on e.session_guid = mm.session_guid