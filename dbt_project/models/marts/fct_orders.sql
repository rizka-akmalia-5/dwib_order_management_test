{{ config(
    materialized='table'
) }}

with orders as (
    select * from {{ ref('stg_orders') }}
),
shipments as (
    select * from {{ ref('stg_shipments') }}
),
shipping_services as (
    select * from {{ ref('stg_shipping_services') }}
),
customer_orders_rank as (
    select
        order_id::VARCHAR as order_id,
        customer_id::VARCHAR as customer_id,
        row_number() over (
            partition by customer_id
            order by order_date -- Menggunakan order_date
        ) as order_sequence
    from orders
),
dim_customers as (
    select * from {{ ref('dim_customers') }}
),
dim_date as (
    select * from {{ ref('dim_date') }}
),
dim_payments as (
    select * from {{ ref('dim_payments') }}
),
dim_vouchers as (
    select * from {{ ref('dim_vouchers') }}
)

select
    o.order_id,
    o.customer_id,
    c.full_name as customer_name,
    c.city_name,
    pay.payment_method_name,
    coalesce(v.voucher_code, 'NO_DISCOUNT') as voucher_code,
    d.date_id,
    d.date_month,
    d.year,
    -- Karena order_date sekarang tipe DATE, untuk peak_hour 
    -- kita perlu mengambil dari kolom timestamp asli (jika masih ada) 
    -- atau sesuaikan kebutuhan analisis jam.
    0 as peak_hour, 
    o.order_status,
    o.sales_channel,
    case
        when cor.order_sequence = 1 then 'New Customer'
        else 'Returning Customer'
    end as customer_cohort_type,
    case
        when o.order_status = 'cancelled' then coalesce(o.cancellation_stage, 'unknown')
        else 'Not Cancelled'
    end as cancellation_stage,
    -- Perhitungan selisih waktu menggunakan kolom _date yang sudah kita buat
    null as checkout_to_delivered_minutes, 
    s.is_delayed as is_shipping_delayed,
    s.shipping_fee,
    s.shipping_subsidy,
    s.shipping_status,
    ss.shipping_provider,
    ss.shipping_service,
    s.tracking_number,
    o.shipping_service_id
from orders o
left join shipments s
    on s.order_id::VARCHAR = o.order_id::VARCHAR
left join shipping_services ss
    on ss.shipping_service_id::VARCHAR = o.shipping_service_id::VARCHAR
left join customer_orders_rank cor
    on cor.order_id::VARCHAR = o.order_id::VARCHAR
left join dim_customers c
    on c.customer_id::VARCHAR = o.customer_id::VARCHAR
left join dim_payments pay
    on pay.payment_method_id::VARCHAR = o.payment_method_id::VARCHAR
left join dim_vouchers v
    on v.voucher_id::VARCHAR = o.voucher_id::VARCHAR
left join dim_date d
    on d.full_date = o.order_date