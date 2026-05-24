{{ config(
    materialized='table'
) }}

with staging_payments as (
    select * from {{ ref('stg_payment_methods') }}
)

select
    payment_method_id,
    payment_method_name,
    payment_group,
    case
        when lower(payment_method_name) = 'cod' then 'Offline'
        else 'Digital/Online'
    end as payment_type
from staging_payments