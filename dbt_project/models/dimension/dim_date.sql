{{ config(
    materialized='table'
) }}

with date_spine as (
    select generate_series::date as date_day
    from generate_series(
        -- Menggunakan order_date yang sudah kita perbarui di stg_orders
        (select min(order_date) from {{ ref('stg_orders') }}),
        (select max(order_date) from {{ ref('stg_orders') }}),
        interval '1 day'
    )
)

select
    to_char(date_day, 'YYYYMMDD')::int as date_id,
    date_day as full_date,
    date_trunc('month', date_day)::date as date_month,
    extract('year' from date_day)::int as year,
    extract('quarter' from date_day)::int as quarter,
    extract('month' from date_day)::int as month,
    to_char(date_day, 'Month') as month_name,
    extract('week' from date_day)::int as week_of_year,
    extract('day' from date_day)::int as day_of_month,
    extract('dow' from date_day)::int as day_of_week,
    to_char(date_day, 'Day') as day_name,
    (extract('dow' from date_day) in (0, 6)) as is_weekend
from date_spine