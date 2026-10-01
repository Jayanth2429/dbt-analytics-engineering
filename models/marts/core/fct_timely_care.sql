select
    md5(facility_id || '|' || measure_id || '|' || coalesce(cast(start_date as varchar), '') || '|' || coalesce(cast(end_date as varchar), '')) as timely_care_fact_key,
    facility_id,
    md5('TIMELY_CARE|' || measure_id) as measure_key,
    measure_id,
    condition,
    start_date,
    end_date,
    score_raw,
    score_numeric,
    sample_size,
    footnote
from {{ ref('stg_timely_care') }}
