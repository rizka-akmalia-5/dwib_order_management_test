with source as (
    select * from {{ source('raw', 'cities') }}
)

select
    -- ID dijadikan String
    city_id::VARCHAR AS city_id,
    
    -- Field lainnya
    city_name,
    province,
    region,
    country,
    loaded_at
from source