# Week 4 Project

## Introduction
```
For the final week of our project, we are going to tackle a data modeling challenge inspired by the real world: understanding the product funnel. This is very representative of the type of data modeling work that happens within data organizations. I’ve spent a lot of time with our product data at Drizly, building reporting and metrics for our Product and Engineering teams!
```

## Project Details
### Part 1. dbt Snapshots
Let's put our snapshot skills to the test! At Greenery, we want to understand how our data is changing over time. For some data, like events, this is already possible. For other datasets, like products, we only know what that table looks like at a point in time. Some questions that the business might be asking could be:

  #### How often are items going out of stock? And how quickly are they back in stock?
    *monitored in product_snapshot.sql

  #### What does an order's lifecycle typically look like?
    *monitored in order_snapshot.sql

  #### How is our pricing changing over time?
    *monitored in product_snapshot.sql


### Part 2. Modeling challenge
Let’s say that the Director of Product at greenery comes to us (the head Analytics Engineer) and asks some questions:

    *How are our users moving through the product funnel?
    *Which steps in the funnel have largest drop off points?

Product funnel is defined with 3 levels for our dataset:
    *Sessions with any event of type page_view / add_to_cart / checkout
    *Sessions with any event of type add_to_cart / checkout
    *Sessions with any event of type checkout

#### I was able to use my existing fct_sessions model to answer these questions:
### total_sessions: 578
### from page_view to add_to_cart: 80.80%
### from add_to_cart to checkout: 77.30%

``` sql
with temp_t as (
  select
    count(distinct session_guid) as total_sessions,
    count(distinct case when add_to_cart = 1 then session_guid end) as add_to_cart_total,
    count(distinct case when checkout = 1 then session_guid end) as checkout_total
    
  from dbt_deanna_m.fct_sessions
)

select
  total_sessions,
  round(add_to_cart_total/total_sessions :: numeric * 100, 2) || '%' as add_to_cart_pct,
  round(checkout_total/add_to_cart_total :: numeric * 100, 2) || '%' as check_out_pct

from temp_t
```
#### Created an exposure for my Product Funnel Dashboard and verified it's displaying correctly in the DAG. 

### Part 3: Reflection question
#### Reflecting on your learning in this class...

#### ...if you are thinking about moving to analytics engineering, what skills have you picked that give you the most confidence in pursuing this next step?
  I have definitely gotten more practice in writing SQL queries, and I have a clearer concept of how to address a variety of real-life BI questions. This was my first introduction to dimension modeling, and it's starting to make sense! Overall, I have more clarity about the role of an analytics engineer and what factors we need to be aware of within the data stack to allow everything to work together smoothly.