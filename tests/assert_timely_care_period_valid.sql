select *
from {{ ref('fct_timely_care') }}
where start_date is not null
  and end_date is not null
  and start_date > end_date
