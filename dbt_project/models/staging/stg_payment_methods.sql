with source as (
    select * from {{ source('raw', 'payment_methods') }}
)

select
    -- ID dijadikan String
    payment_method_id::VARCHAR AS payment_method_id,
    
    -- Field lainnya
    payment_method_name,
    payment_group,
    loaded_at
from source