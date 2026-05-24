with source as (
    select * from {{ source('raw', 'customer_profile_events') }}
)

select
    -- ID dijadikan String
    customer_profile_event_id::VARCHAR AS customer_profile_event_id,
    customer_id::VARCHAR AS customer_id,
    city_id::VARCHAR AS city_id,
    
    -- Field lainnya
    full_name,
    email,
    gender,
    
    -- Waktu dijadikan Date
    birth_date::DATE AS birth_date,
    effective_at::DATE AS effective_at,
    
    loyalty_tier,
    marketing_opt_in,
    operation,
    loaded_at
from source