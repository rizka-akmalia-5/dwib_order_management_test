with customers as (
    select 
        customer_id::VARCHAR as customer_id,
        customer_profile_event_id::VARCHAR as customer_profile_event_id,
        city_id::VARCHAR as city_id,
        full_name,
        email,
        gender,
        birth_date,
        loyalty_tier,
        marketing_opt_in,
        effective_at
    from {{ ref('stg_customers') }}
),

cities as (
    select 
        city_id::VARCHAR as city_id,
        city_name,
        province,
        region,
        country
    from {{ ref('stg_cities') }}
),

ranked_customers as (
    select
        *,
        row_number() over (
            partition by customer_id
            order by effective_at desc, customer_profile_event_id desc
        ) as rn
    from customers
)

select
    c.customer_id,
    c.full_name,
    c.email,
    c.gender,
    c.birth_date,
    c.loyalty_tier,
    c.marketing_opt_in,
    c.city_id,
    ci.city_name,
    ci.province,
    ci.region,
    ci.country
from ranked_customers c
left join cities ci
    on ci.city_id = c.city_id
where c.rn = 1