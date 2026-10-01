select
    facility_id,
    count(*) as timely_care_measure_rows,
    count(distinct measure_id) as distinct_timely_care_measures,
    count(score_numeric) as numeric_score_rows,
    count(*) - count(score_numeric) as non_numeric_or_unavailable_score_rows,
    count(distinct condition) as timely_care_conditions
from {{ ref('stg_timely_care') }}
group by 1
