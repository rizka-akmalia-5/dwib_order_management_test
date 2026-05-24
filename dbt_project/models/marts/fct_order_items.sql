{{ config(
    materialized='table'
) }}

with order_items as (
    select * from {{ ref('stg_order_items') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
dim_customers as (
    select * from {{ ref('dim_customers') }}
),
dim_date as (
    select * from {{ ref('dim_date') }}
),
dim_products as (
    select * from {{ ref('dim_products') }}
),
dim_payments as (
    select * from {{ ref('dim_payments') }}
),
dim_vouchers as (
    select * from {{ ref('dim_vouchers') }}
)

select
    i.order_item_id,
    o.order_id,
    o.customer_id,
    c.full_name as customer_name,
    c.city_name,
    p.product_id,
    p.product_name,
    p.category_name,
    pay.payment_method_name,
    coalesce(v.voucher_code, 'NO_DISCOUNT') as voucher_code,
    d.date_id,
    d.full_date,
    d.date_month,
    d.year,
    o.order_status,
    i.is_returned,
    i.is_cancelled,
    i.quantity,
    i.unit_price,
    i.subtotal as gross_revenue,
    i.discount_amount as item_discount_amount,
    i.shipping_subsidy,
    i.voucher_amount as voucher_discount_amount,
    i.total_payment as net_revenue,
    i.estimated_cost as cogs,
    i.profit
from order_items i
inner join orders o
    on CAST(o.order_id AS VARCHAR) = CAST(i.order_id AS VARCHAR)
left join dim_customers c
    on CAST(c.customer_id AS VARCHAR) = CAST(o.customer_id AS VARCHAR)
left join dim_products p
    on CAST(p.product_id AS VARCHAR) = CAST(i.product_id AS VARCHAR)
left join dim_payments pay
    on CAST(pay.payment_method_id AS VARCHAR) = CAST(o.payment_method_id AS VARCHAR)
left join dim_vouchers v
    on CAST(v.voucher_id AS VARCHAR) = CAST(o.voucher_id AS VARCHAR)
left join dim_date d
    on d.full_date = o.order_date