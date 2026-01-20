"""
Clinical Data Quality Checks (Python)

Purpose:
- Load a dataset
- Run basic data quality checks
- Output a simple quality report

Assumes an input CSV with columns like:
patient_id, date_of_birth, sex
"""

from __future__ import annotations

import pandas as pd


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)
    df.columns = [c.strip().lower() for c in df.columns]
    return df


def quality_report(df: pd.DataFrame) -> dict:
    report: dict[str, object] = {}

    # Missing critical fields
    required_cols = ["patient_id", "date_of_birth", "sex"]
    missing_cols = [c for c in required_cols if c not in df.columns]
    report["missing_required_columns"] = missing_cols

    if not missing_cols:
        report["missing_patient_id_rows"] = int(df["patient_id"].isna().sum())
        report["missing_dob_rows"] = int(df["date_of_birth"].isna().sum())
        report["missing_sex_rows"] = int(df["sex"].isna().sum())

        # Duplicate patient IDs
        report["duplicate_patient_id_rows"] = int(df.duplicated(subset=["patient_id"]).sum())

        # Date checks
        dob = pd.to_datetime(df["date_of_birth"], errors="coerce")
        report["invalid_dob_format_rows"] = int(dob.isna().sum())
        report["dob_in_future_rows"] = int((dob > pd.Timestamp.today()).sum())

    # Basic dataset summary
    report["row_count"] = int(len(df))
    report["column_count"] = int(df.shape[1])

    return report


def main() -> None:
    # Update this path when running locally
    input_path = "data/sample_patients.csv"

    df = load_data(input_path)
    report = quality_report(df)

    print("=== Clinical Data Quality Report ===")
    for k, v in report.items():
        print(f"{k}: {v}")


if __name__ == "__main__":
    main()
