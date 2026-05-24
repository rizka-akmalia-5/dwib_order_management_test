with source as (
    select * from {{ source('raw', 'order_status_events') }}
)

select
    -- ID dijadikan String
    status_event_id::VARCHAR AS status_event_id,
    order_id::VARCHAR AS order_id,
    
    -- Field lainnya
    status,
    
    -- Waktu dijadikan Date
    status_ts::DATE AS status_date,
    loaded_at
from source