#!/usr/bin/env python3
"""Load downloaded CMS CSV files into a local DuckDB raw schema."""
from __future__ import annotations

import argparse
from pathlib import Path

import duckdb

TABLES = {
    "hospital_general": "hospital_general_information.csv",
    "readmissions": "hospital_readmissions_reduction_program.csv",
    "timely_care": "timely_effective_care_hospital.csv",
}


def sql_path(path: Path) -> str:
    return str(path.resolve()).replace("'", "''")


def load_table(connection: duckdb.DuckDBPyConnection, table: str, csv_path: Path) -> int:
    if not csv_path.exists():
        raise FileNotFoundError(f"Missing {csv_path}. Run scripts/download_cms_data.py first.")

    connection.execute(
        f"""
        create or replace table raw.{table} as
        select
            *,
            current_timestamp as _loaded_at
        from read_csv_auto(
            '{sql_path(csv_path)}',
            header = true,
            all_varchar = true,
            normalize_names = true,
            sample_size = -1
        )
        """
    )
    return connection.execute(f"select count(*) from raw.{table}").fetchone()[0]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw-dir", type=Path, default=Path("data/raw"))
    parser.add_argument("--db", type=Path, default=Path("warehouse/cms_hospital_analytics.duckdb"))
    args = parser.parse_args()

    args.db.parent.mkdir(parents=True, exist_ok=True)
    with duckdb.connect(str(args.db)) as con:
        con.execute("create schema if not exists raw")
        for table, filename in TABLES.items():
            count = load_table(con, table, args.raw_dir / filename)
            print(f"[loaded] raw.{table}: {count:,} rows")


if __name__ == "__main__":
    main()
