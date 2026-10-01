# Modeling decisions

## Preserve Facility ID as text
CMS Certification Numbers may contain leading zeroes. The pipeline never casts `facility_id` to a numeric type.

## Treat score semantics carefully
Timely and Effective Care scores are heterogeneous: some are durations, percentages, categories, or unavailable values. The model keeps both `score_raw` and a best-effort `score_numeric`. It does not average unlike measures together.

## Do not recreate CMS risk adjustment
The HRRP model consumes CMS-published predicted rates, expected rates, and excess readmission ratios. The project does not claim to reproduce or independently validate CMS's risk-adjustment methodology.

## Deterministic measure keys
The measure dimension combines measure domain and measure ID before hashing. This prevents a code collision between unrelated CMS programs.

## Public data is downloaded, not committed
The repository stays small and reproducible by resolving the current CMS CSV URLs at runtime. CI therefore exercises the same ingestion path a user runs locally.
