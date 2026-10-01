with source as (
    select * from {{ source('cms', 'readmissions') }}
)

select
    trim(cast(facility_id as varchar)) as facility_id,
    {{ cms_null('facility_name') }} as facility_name,
    {{ cms_null('state') }} as state,
    {{ cms_null('measure_name') }} as measure_id,
    {{ cms_number('number_of_discharges') }} as number_of_discharges,
    {{ cms_number('excess_readmission_ratio') }} as excess_readmission_ratio,
    {{ cms_number('predicted_readmission_rate') }} as predicted_readmission_rate,
    {{ cms_number('expected_readmission_rate') }} as expected_readmission_rate,
    {{ cms_number('number_of_readmissions') }} as number_of_readmissions,
    {{ cms_null('footnote') }} as footnote,
    {{ cms_date('start_date') }} as start_date,
    {{ cms_date('end_date') }} as end_date,
    _loaded_at
from source
where {{ cms_null('facility_id') }} is not null
  and {{ cms_null('measure_name') }} is not null
