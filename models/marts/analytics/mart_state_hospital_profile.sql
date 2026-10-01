select
    state,
    count(*) as hospital_count,
    count(hospital_overall_rating) as hospitals_with_overall_rating,
    avg(hospital_overall_rating) as avg_hospital_overall_rating,
    sum(case when has_emergency_services then 1 else 0 end) as hospitals_with_emergency_services,
    100.0 * sum(case when has_emergency_services then 1 else 0 end) / nullif(count(*), 0) as pct_with_emergency_services,
    sum(case when hospital_type = 'Acute Care Hospitals' then 1 else 0 end) as acute_care_hospitals,
    sum(case when hospital_type = 'Critical Access Hospitals' then 1 else 0 end) as critical_access_hospitals
from {{ ref('dim_hospital') }}
group by 1
