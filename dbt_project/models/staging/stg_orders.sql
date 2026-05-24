with source as (
    select * from {{ source('raw', 'orders') }}
)

select
    -- ID dijadikan String
    order_id::VARCHAR AS order_id,
    order_number::VARCHAR AS order_number,
    customer_id::VARCHAR AS customer_id,
    payment_method_id::VARCHAR AS payment_method_id,
    shipping_service_id::VARCHAR AS shipping_service_id,
    voucher_id::VARCHAR AS voucher_id,

    -- Waktu dijadikan Date
    order_ts::DATE AS order_date,
    
    -- Field lainnya
    order_status,
    cancellation_stage,
    sales_channel,
    currency,
    loaded_at
from source