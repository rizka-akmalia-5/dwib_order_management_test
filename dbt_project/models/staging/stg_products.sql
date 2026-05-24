with source as (
    select * from {{ source('raw', 'products') }}
)

select
    -- ID dijadikan String
    product_id::VARCHAR AS product_id,
    category_id::VARCHAR AS category_id,
    
    -- Field lainnya
    sku,
    product_name,
    standard_price,
    estimated_unit_cost,
    is_active,
    
    -- Waktu dijadikan Date
    created_at::DATE AS created_at,
    loaded_at
from source