from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_required_project_files_exist():
    required = [
        "dbt_project.yml",
        "profiles.yml",
        "DATA_SOURCES.md",
        "scripts/download_cms_data.py",
        "scripts/load_raw_duckdb.py",
        "models/marts/core/dim_hospital.sql",
        "models/marts/core/fct_readmissions.sql",
        "models/marts/core/fct_timely_care.sql",
        "models/marts/analytics/mart_hospital_quality_snapshot.sql",
    ]
    for item in required:
        assert (ROOT / item).exists(), item


def test_raw_public_files_are_gitignored():
    gitignore = (ROOT / ".gitignore").read_text()
    assert "data/raw/*.csv" in gitignore
    assert "warehouse/*.duckdb" in gitignore
