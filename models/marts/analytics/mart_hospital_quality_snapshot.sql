with hospitals as (
    select * from {{ ref('dim_hospital') }}
),
readmissions as (
    select * from {{ ref('int_readmission_summary') }}
),
timely as (
    select * from {{ ref('int_timely_care_coverage') }}
)

select
    h.facility_id,
    h.facility_name,
    h.state,
    h.hospital_type,
    h.hospital_ownership,
    h.has_emergency_services,
    h.hospital_overall_rating,
    r.reported_readmission_measures,
    r.measures_with_ratio,
    r.avg_excess_readmission_ratio,
    r.measures_above_expected,
    r.measures_below_expected,
    r.total_reported_discharges,
    r.total_reported_readmissions,
    t.distinct_timely_care_measures,
    t.numeric_score_rows,
    t.non_numeric_or_unavailable_score_rows,
    t.timely_care_conditions
from hospitals h
left join readmissions r using (facility_id)
left join timely t using (facility_id)
