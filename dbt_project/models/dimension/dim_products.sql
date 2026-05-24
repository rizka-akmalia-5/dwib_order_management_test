{{ config(
    materialized='table'
) }}

with products as (
    select 
        product_id::VARCHAR as product_id,
        sku,
        product_name,
        category_id::VARCHAR as category_id, -- Pastikan di-cast ke VARCHAR di sini
        standard_price,
        estimated_unit_cost,
        is_active,
        created_at
    from {{ ref('stg_products') }}
),

categories as (
    select 
        category_id::VARCHAR as category_id, -- Pastikan di-cast ke VARCHAR di sini
        category_name,
        subcategory_name
    from {{ ref('stg_categories') }}
)

select
    p.product_id,
    p.sku,
    p.product_name,
    p.category_id,
    c.category_name,
    c.subcategory_name,
    p.standard_price as retail_price,
    p.estimated_unit_cost as unit_cost,
    p.is_active,
    p.created_at
from products p
left join categories c
    -- Cast di kedua sisi saat JOIN untuk memastikan tipe data cocok
    on c.category_id::VARCHAR = p.category_id::VARCHAR