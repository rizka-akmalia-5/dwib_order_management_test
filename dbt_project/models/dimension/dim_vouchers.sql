{{ config(
    materialized='table'
) }}

select
    voucher_id,
    voucher_code,
    voucher_name,
    voucher_type,
    rule_description,
    min_order_amount,
    discount_amount,
    cashback_rate
from {{ ref('stg_vouchers') }}