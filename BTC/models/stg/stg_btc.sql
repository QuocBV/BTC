{{
    config(
        materialized="incremental",
        unique_key="HASH_KEY",
        incremental_strategy="merge",
    )
}}

select '{{ invocation_id }}' as invocation_id, *
from {{ source("btc", "btc") }}
{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    -- (uses >= to include records whose timestamp occurred since the last run of this
    -- model)
    -- (If event_time is NULL or the table is truncated, the condition will always be
    -- true and load all records)
    where block_timestamp > (select max(block_timestamp) from {{ this }})

{% endif %}
