# Week 3 Project

## PART 1: Create new models to answer the first two questions (answer questions in README file)

### What is our overall conversion rate?

62.46%

``` sql
select
  round(sum(checkout) / count(distinct session_guid) * 100, 2) as conversion_rate
from dbt_deanna_m.int_session_events_agg
```

### What is our conversion rate by product?

I tried to use checkout events by product, but they were all null. Alternatively, I verified that no session_guid had more than one unique order_guid associated with it. For my product conversion rate, I calculated unique orders per product and divided that by unique sessions per product. This is housed in my dim_products model (marts/core):

``` sql
with order_totals as (
    select
        product_guid,
        count(*) as total_ordered,
        count (distinct order_guid) as unique_orders
    from {{ ref('stg_greenery__order_items')}}
    group by 1
)

, event_totals as (
    select
        product_guid,
        count (distinct session_guid)::integer as unique_sessions,
        sum(add_to_cart) as total_add_to_cart_events,
        sum(checkout) as total_checkout_events,
        sum(page_view) as total_page_view_events,
        sum(package_shipped) as total_package_shipped_events
    from {{ ref('int_session_events_agg') }}
    group by 1
)
```
This is how I verified there is only one unique order_guid maximum per session_guid:

``` sql
select
  session_guid,
  count(distinct order_guid) as order_count
from dbt_deanna_m.stg_greenery__events
group by 1
order by 2 desc
```

### A question to think about: Why might certain products be converting at higher/lower rates than others? Note: we don't actually have data to properly dig into this, but we can make some hypotheses. 
  * The photos may be more interesting or better quality somehow. 
  * Perhaps the pricing is more compelling on some items.
  * It would be interesting to note which products are featured in marketing (emails, social, media, etc.) and how that related to conversion rates for those items.
  * There could be promo codes available for certain items or price thresholds that work well with certain items (ie a discount for purchases of $25+ may encourage people to buy more expensive items)

## PART 2: We’re getting really excited about dbt macros after learning more about them and want to apply them to improve our dbt project. 

Created the get_event_types macro and utilized it in the int_session_events_agg model.

## PART 3: We’re starting to think about granting permissions to our dbt models in our postgres database so that other roles can have access to them.

Add a post hook to your project to apply grants to the role “reporting”. Create reporting role first by running CREATE ROLE reporting in your database instance.

After you create the role you still need to grant it usage access on your schema dbt_<firstname>_<lastinitial> (what you set in your profiles.yml in week 1) which can be done using an on-run-end hook

You can use the grant macro example from this week and make any necessary changes for postgres syntax

To check if your grants worked as expected, you can query the information schema like this (inputing the table name you want to check): 

SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name='mytable'

### Worked as expected.

## PART 4:  After learning about dbt packages, we want to try one out and apply some macros or tests.

Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project

### Installed dbt-utils and tried out the accepted_range test on the quantity column in stg_greenery__order_items.

## PART 5: After improving our project with all the things that we have learned about dbt, we want to show off our work!

Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.

