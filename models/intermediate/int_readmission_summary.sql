select
    facility_id,
    count(*) as reported_readmission_measures,
    count(excess_readmission_ratio) as measures_with_ratio,
    avg(excess_readmission_ratio) as avg_excess_readmission_ratio,
    sum(case when excess_readmission_ratio > 1 then 1 else 0 end) as measures_above_expected,
    sum(case when excess_readmission_ratio < 1 then 1 else 0 end) as measures_below_expected,
    sum(number_of_discharges) as total_reported_discharges,
    sum(number_of_readmissions) as total_reported_readmissions
from {{ ref('stg_readmissions') }}
group by 1
