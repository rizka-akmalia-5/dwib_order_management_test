with source as (
    select * from {{ source('raw', 'vouchers') }}
)

select
    -- ID dijadikan String
    voucher_id::VARCHAR AS voucher_id,
    
    -- Field lainnya
    voucher_code,
    voucher_name,
    voucher_type,
    rule_description,
    min_order_amount,
    discount_amount,
    cashback_rate,
    loaded_at
from source