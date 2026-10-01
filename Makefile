.PHONY: setup data load build docs test clean

setup:
	python3 -m venv .venv
	. .venv/bin/activate && python -m pip install --upgrade pip && python -m pip install -r requirements.txt

data:
	. .venv/bin/activate && python scripts/download_cms_data.py

load:
	. .venv/bin/activate && python scripts/load_raw_duckdb.py

build:
	. .venv/bin/activate && dbt build --profiles-dir .

docs:
	. .venv/bin/activate && dbt docs generate --profiles-dir . && dbt docs serve --profiles-dir .

test:
	. .venv/bin/activate && python -m pytest -q

clean:
	rm -rf target logs warehouse/*.duckdb warehouse/*.wal
