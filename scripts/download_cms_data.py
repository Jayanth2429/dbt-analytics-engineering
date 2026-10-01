#!/usr/bin/env python3
"""Download current CMS Provider Data CSVs using stable dataset identifiers.

The Provider Data Catalog rotates underlying resource URLs over time. This script
resolves each current CSV download URL from CMS metadata instead of hard-coding
transient file URLs.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import requests

API_ROOT = "https://data.cms.gov/provider-data/api/1"

DATASETS = {
    "hospital_general_information": {
        "dataset_id": "xubh-q36u",
        "filename": "hospital_general_information.csv",
    },
    "hospital_readmissions_reduction_program": {
        "dataset_id": "9n3s-kdb3",
        "filename": "hospital_readmissions_reduction_program.csv",
    },
    "timely_effective_care_hospital": {
        "dataset_id": "yv7e-xc69",
        "filename": "timely_effective_care_hospital.csv",
    },
}


def get_metadata(dataset_id: str, session: requests.Session | None = None) -> dict[str, Any]:
    http = session or requests.Session()
    url = f"{API_ROOT}/metastore/schemas/dataset/items/{dataset_id}"
    response = http.get(url, timeout=60)
    response.raise_for_status()
    return response.json()


def select_csv_distribution(metadata: dict[str, Any]) -> dict[str, Any]:
    distributions = metadata.get("distribution") or []
    if isinstance(distributions, dict):
        distributions = [distributions]

    def is_csv(item: dict[str, Any]) -> bool:
        media = str(item.get("mediaType", "")).lower()
        fmt = str(item.get("format", "")).lower()
        url = str(item.get("downloadURL", "")).lower()
        title = str(item.get("title", "")).lower()
        return (
            media in {"text/csv", "application/csv"}
            or fmt == "csv"
            or url.endswith(".csv")
            or "csv" in title
        ) and bool(item.get("downloadURL"))

    candidates = [d for d in distributions if is_csv(d)]
    if not candidates:
        raise RuntimeError("CMS metadata did not contain a CSV download distribution")
    return candidates[0]


def download_file(url: str, destination: Path, session: requests.Session | None = None) -> None:
    http = session or requests.Session()
    destination.parent.mkdir(parents=True, exist_ok=True)
    with http.get(url, stream=True, timeout=180) as response:
        response.raise_for_status()
        with destination.open("wb") as fh:
            for chunk in response.iter_content(chunk_size=1024 * 1024):
                if chunk:
                    fh.write(chunk)


def download_dataset(
    name: str,
    config: dict[str, str],
    raw_dir: Path,
    metadata_dir: Path,
    force: bool,
) -> Path:
    dataset_id = config["dataset_id"]
    target = raw_dir / config["filename"]
    meta_target = metadata_dir / f"{name}.json"

    metadata = get_metadata(dataset_id)
    distribution = select_csv_distribution(metadata)
    download_url = distribution["downloadURL"]

    metadata_dir.mkdir(parents=True, exist_ok=True)
    meta_target.write_text(json.dumps(metadata, indent=2), encoding="utf-8")

    if target.exists() and not force:
        print(f"[skip] {name}: {target} already exists (use --force to refresh)")
        return target

    print(f"[download] {name} ({dataset_id})")
    print(f"           {download_url}")
    download_file(download_url, target)
    print(f"[saved]    {target} ({target.stat().st_size:,} bytes)")
    return target


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw-dir", type=Path, default=Path("data/raw"))
    parser.add_argument("--metadata-dir", type=Path, default=Path("data/metadata"))
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()

    for name, config in DATASETS.items():
        download_dataset(name, config, args.raw_dir, args.metadata_dir, args.force)


if __name__ == "__main__":
    main()
