with source as (
    select * from {{ source('raw', 'shipments') }}
)

select
    -- ID dijadikan String
    shipment_id::VARCHAR AS shipment_id,
    order_id::VARCHAR AS order_id,
    shipping_service_id::VARCHAR AS shipping_service_id,
    
    -- Waktu dijadikan Date
    checkout_ts::DATE AS checkout_date,
    shipped_ts::DATE AS shipped_date,
    delivered_ts::DATE AS delivered_date,
    
    -- Field lainnya
    shipping_fee,
    shipping_subsidy,
    is_delayed,
    shipping_status,
    tracking_number,
    loaded_at
from source