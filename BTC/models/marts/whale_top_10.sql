with base as (select * from {{ ref("whale_alter") }} order by total_sent desc limit 10)
select *
from base
