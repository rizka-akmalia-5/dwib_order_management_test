with source as (
    select * from {{ source('raw', 'categories') }}
)

select
    category_id,
    category_name,
    subcategory_name,
    department,
    loaded_at
from source