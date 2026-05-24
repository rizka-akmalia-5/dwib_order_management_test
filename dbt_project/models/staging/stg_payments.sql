with source as (
    select * from {{ source('raw', 'payments') }}
)

select
    -- ID dijadikan String
    payment_id::VARCHAR AS payment_id,
    order_id::VARCHAR AS order_id,
    payment_method_id::VARCHAR AS payment_method_id,
    
    -- Waktu dijadikan Date
    payment_ts::DATE AS payment_date,
    
    -- Field lainnya
    payment_status,
    payment_amount,
    transaction_reference,
    loaded_at
from source