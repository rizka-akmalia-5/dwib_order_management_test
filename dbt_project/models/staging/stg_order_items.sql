with source as (
    select * from {{ source('raw', 'order_items') }}
)

select
    -- ID dijadikan String
    order_item_id::VARCHAR AS order_item_id,
    order_id::VARCHAR AS order_id,
    product_id::VARCHAR AS product_id,
    
    -- Field lainnya
    item_number,
    quantity,
    unit_price,
    subtotal,
    discount_amount,
    shipping_subsidy,
    voucher_amount,
    total_payment,
    estimated_cost,
    profit,
    is_returned,
    is_cancelled,
    loaded_at
from source