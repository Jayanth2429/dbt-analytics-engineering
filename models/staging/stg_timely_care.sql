with source as (
    select * from {{ source('cms', 'timely_care') }}
)

select
    trim(cast(facility_id as varchar)) as facility_id,
    {{ cms_null('facility_name') }} as facility_name,
    {{ cms_null('state') }} as state,
    {{ cms_null('condition') }} as condition,
    {{ cms_null('measure_id') }} as measure_id,
    {{ cms_null('measure_name') }} as measure_name,
    {{ cms_null('score') }} as score_raw,
    {{ cms_number('score') }} as score_numeric,
    {{ cms_number('_sample') }} as sample_size,
    {{ cms_null('footnote') }} as footnote,
    {{ cms_date('start_date') }} as start_date,
    {{ cms_date('end_date') }} as end_date,
    _loaded_at
from source
where {{ cms_null('facility_id') }} is not null
  and {{ cms_null('measure_id') }} is not null
