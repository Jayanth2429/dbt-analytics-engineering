with hospital_general as (

    select *
    from {{ ref('stg_hospitals') }}

),

readmission_hospitals as (

    select
        facility_id,
        max(facility_name) as facility_name,
        max(state) as state
    from {{ ref('stg_readmissions') }}
    group by 1

),

timely_care_hospitals as (

    select
        facility_id,
        max(facility_name) as facility_name,
        max(state) as state
    from {{ ref('stg_timely_care') }}
    group by 1

),

hospital_spine as (

    select facility_id from hospital_general
    union
    select facility_id from readmission_hospitals
    union
    select facility_id from timely_care_hospitals

)

select
    s.facility_id,

    coalesce(
        h.facility_name,
        r.facility_name,
        t.facility_name
    ) as facility_name,

    h.address,
    h.city,

    coalesce(
        h.state,
        r.state,
        t.state
    ) as state,

    h.zip_code,
    h.county,
    h.hospital_type,
    h.hospital_ownership,
    h.has_emergency_services,
    h.hospital_overall_rating,

    h.mortality_measure_count,
    h.mortality_measures_better,
    h.mortality_measures_no_different,
    h.mortality_measures_worse,

    h.safety_measure_count,
    h.safety_measures_better,
    h.safety_measures_no_different,
    h.safety_measures_worse,

    h.readmission_measure_count,
    h.readmission_measures_better,
    h.readmission_measures_no_different,
    h.readmission_measures_worse,

    h.facility_id is not null as present_in_hospital_general,
    r.facility_id is not null as present_in_readmissions,
    t.facility_id is not null as present_in_timely_care

from hospital_spine s

left join hospital_general h
    on s.facility_id = h.facility_id

left join readmission_hospitals r
    on s.facility_id = r.facility_id

left join timely_care_hospitals t
    on s.facility_id = t.facility_id
