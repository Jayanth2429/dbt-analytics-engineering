select *
from {{ ref('fct_readmissions') }}
where excess_readmission_ratio is not null
  and excess_readmission_ratio <= 0
