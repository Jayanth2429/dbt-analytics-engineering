select
    h.state,
    f.measure_id,
    count(*) filter (where f.excess_readmission_ratio is not null) as hospitals_with_ratio,
    avg(f.excess_readmission_ratio) as avg_excess_readmission_ratio,
    sum(case when f.excess_readmission_ratio > 1 then 1 else 0 end) as hospitals_above_expected,
    sum(case when f.excess_readmission_ratio < 1 then 1 else 0 end) as hospitals_below_expected,
    sum(f.number_of_discharges) as total_reported_discharges,
    sum(f.number_of_readmissions) as total_reported_readmissions
from {{ ref('fct_readmissions') }} f
join {{ ref('dim_hospital') }} h using (facility_id)
group by 1, 2
