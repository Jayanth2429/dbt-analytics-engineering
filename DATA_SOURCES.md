# Data sources

This project uses public hospital datasets from the **Centers for Medicare & Medicaid Services (CMS) Provider Data Catalog**. No employer data, patient-level PHI, or proprietary schemas are used.

The downloader resolves the current CSV resource URL through the CMS metadata API each time it runs. Raw CSV files are stored under `data/raw/` and are ignored by Git.

## 1. Hospital General Information

- Publisher: Centers for Medicare & Medicaid Services (CMS)
- Dataset ID: `xubh-q36u`
- Dataset page: https://data.cms.gov/provider-data/dataset/xubh-q36u
- Grain: one row per Medicare-registered hospital
- Example attributes: facility ID, location, hospital type, ownership, emergency-services indicator, overall hospital rating
- Public access level: public

## 2. Hospital Readmissions Reduction Program

- Publisher: CMS
- Dataset ID: `9n3s-kdb3`
- Dataset page: https://data.cms.gov/provider-data/dataset/9n3s-kdb3
- Grain: hospital + HRRP measure + reporting period
- Example measures: excess readmission ratio, predicted/expected readmission rates, discharges, readmissions
- Public access level: public

CMS describes HRRP excess readmissions as a ratio of a hospital's predicted readmission rate to the expected rate for a hospital with similar patients. The portfolio uses that published field as reported and does not attempt to recreate CMS risk adjustment.

## 3. Timely and Effective Care - Hospital

- Publisher: CMS
- Dataset ID: `yv7e-xc69`
- Dataset page: https://data.cms.gov/provider-data/dataset/yv7e-xc69
- Grain: hospital + quality measure + reporting period
- Example fields: condition, measure ID/name, score, sample, reporting dates
- Public access level: public

## Reproducibility

Run:

```bash
python scripts/download_cms_data.py
```

The script requests metadata from:

`https://data.cms.gov/provider-data/api/1/metastore/schemas/dataset/items/<dataset-id>`

and selects the current CSV `downloadURL` from the dataset's distribution metadata. This avoids hard-coding resource URLs that CMS may rotate between releases.

This is an independent portfolio project and is not affiliated with or endorsed by CMS.
