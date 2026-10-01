select
    md5(facility_id || '|' || measure_id || '|' || coalesce(cast(start_date as varchar), '') || '|' || coalesce(cast(end_date as varchar), '')) as readmission_fact_key,
    facility_id,
    md5('READMISSION|' || measure_id) as measure_key,
    measure_id,
    start_date,
    end_date,
    number_of_discharges,
    excess_readmission_ratio,
    predicted_readmission_rate,
    expected_readmission_rate,
    number_of_readmissions,
    footnote,
    case
        when excess_readmission_ratio > 1 then 'ABOVE_EXPECTED'
        when excess_readmission_ratio < 1 then 'BELOW_EXPECTED'
        when excess_readmission_ratio = 1 then 'AT_EXPECTED'
        else 'NOT_REPORTED'
    end as readmission_ratio_status
from {{ ref('stg_readmissions') }}
