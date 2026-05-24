with source as (
    select * from {{ source('raw', 'shipping_services') }}
)

select
    -- ID dijadikan String
    shipping_service_id::VARCHAR AS shipping_service_id,
    
    -- Field lainnya
    shipping_provider,
    shipping_service,
    service_level,
    min_delivery_days,
    max_delivery_days,
    loaded_at
from source