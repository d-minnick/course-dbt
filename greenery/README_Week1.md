# Week 1 Project

Q: How many users do we have?
A: 130 users

``` sql
select
  count(distinct user_guid ) as user_count
from dbt.dbt_deanna_m.stg_greenery__users
```

Q: On average, how many orders do we receive per hour?
A: 7.5 orders per hour

``` sql
with orders_by_hour as (
  select
    count(distinct date_trunc('hour', created_at_utc)) as hour_count,
    count(distinct order_guid) as order_count
  from dbt_deanna_m.stg_greenery__orders
  )
  select
    hour_count,
    order_count,
    round(round(order_count,2)/round(hour_count,2),2) as orders_per_hour
  from orders_by_hour
```

Q: On average, how long does an order take from being placed to being delivered?
A: 3 days, 21 hours, 24 minutes

``` sql
with deliver_avg as (
  select
    order_guid,
    created_at_utc,
    delivered_at_utc,
    delivered_at_utc - created_at_utc as time_to_deliver
  from dbt_deanna_m.stg_greenery__orders
)

select
  avg(time_to_deliver),
  sum(time_to_deliver),
  count(distinct order_guid)
from deliver_avg
where delivered_at_utc is not null
```

Q: How many users have only made one purchase? Two purchases? Three+ purchases?
A:  1 purchase  - 25 users
    2 purchases - 28 users
    3+ purchases - 71 users

``` sql
with user_order_count as (
  select
    user_guid,
    count(distinct order_guid) as order_count
  from dbt_deanna_m.stg_greenery__orders
  group by user_guid
  order by order_count
)

select
  order_count,
  count(distinct user_guid)
from user_order_count
group by order_count
```

Q: On average, how many unique sessions do we have per hour?
A: 10 unique sessions per hour
--This is giving the total number of unique sessions divided by the total number of hours. Ideally I would find the average number of unique sessions in each given hour and average those.

``` sql
with unique_sessions as (
  select
    count(distinct session_guid) as total_sessions,
    extract(epoch FROM max(created_at_utc) - min(created_at_utc))/3600 as hours_elapsed
  from dbt_deanna_m.stg_greenery__events
)     

select
  total_sessions/hours_elapsed as unique_sessions_per_hour,
  total_sessions,
  hours_elapsed
from unique_sessions
```