with readmission as (
    select distinct
        'READMISSION' as measure_domain,
        measure_id,
        measure_id as measure_name,
        cast(null as varchar) as condition
    from {{ ref('stg_readmissions') }}
),

timely as (
    select distinct
        'TIMELY_CARE' as measure_domain,
        measure_id,
        measure_name,
        condition
    from {{ ref('stg_timely_care') }}
)

select
    md5(measure_domain || '|' || measure_id) as measure_key,
    measure_domain,
    measure_id,
    measure_name,
    condition
from (
    select * from readmission
    union all
    select * from timely
)
