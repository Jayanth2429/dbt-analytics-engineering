with source as (
    select * from {{ source('cms', 'hospital_general') }}
)

select
    trim(cast(facility_id as varchar)) as facility_id,
    {{ cms_null('facility_name') }} as facility_name,
    {{ cms_null('address') }} as address,
    {{ cms_null('citytown') }} as city,
    {{ cms_null('state') }} as state,
    {{ cms_null('zip_code') }} as zip_code,
    {{ cms_null('countyparish') }} as county,
    {{ cms_null('hospital_type') }} as hospital_type,
    {{ cms_null('hospital_ownership') }} as hospital_ownership,
    case lower({{ cms_null('emergency_services') }})
        when 'yes' then true
        when 'no' then false
        else null
    end as has_emergency_services,
    {{ cms_integer('hospital_overall_rating') }} as hospital_overall_rating,
    {{ cms_integer('count_of_facility_mort_measures') }} as mortality_measure_count,
    {{ cms_integer('count_of_mort_measures_better') }} as mortality_measures_better,
    {{ cms_integer('count_of_mort_measures_no_different') }} as mortality_measures_no_different,
    {{ cms_integer('count_of_mort_measures_worse') }} as mortality_measures_worse,
    {{ cms_integer('count_of_facility_safety_measures') }} as safety_measure_count,
    {{ cms_integer('count_of_safety_measures_better') }} as safety_measures_better,
    {{ cms_integer('count_of_safety_measures_no_different') }} as safety_measures_no_different,
    {{ cms_integer('count_of_safety_measures_worse') }} as safety_measures_worse,
    {{ cms_integer('count_of_facility_readm_measures') }} as readmission_measure_count,
    {{ cms_integer('count_of_readm_measures_better') }} as readmission_measures_better,
    {{ cms_integer('count_of_readm_measures_no_different') }} as readmission_measures_no_different,
    {{ cms_integer('count_of_readm_measures_worse') }} as readmission_measures_worse,
    _loaded_at
from source
where {{ cms_null('facility_id') }} is not null
