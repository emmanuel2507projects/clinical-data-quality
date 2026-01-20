# clinical-data-quality

A small portfolio repository demonstrating **clinical-style data validation** using:

- **SQL** (data integrity checks)
- **Python** (pandas-based validation script)
- **R** (visualisation for quality review)

This repo is intentionally lightweight but structured like real-world clinical / registry data work.

## Repository structure
- `sql/`    : SQL checks (missingness, duplicates, referential integrity)
- `python/` : Python scripts for validation and reporting
- `r/`      : R scripts for exploratory checks and visualisation
- `data/`   : small de-identified sample datasets for demonstration

## What this demonstrates
- Data quality rules and validation logic
- Audit-ready structure and readable scripts
- Basic reproducible workflow across SQL + Python + R

## How to run (Python)
```bash
pip install pandas
python python/data_quality_checks.py
