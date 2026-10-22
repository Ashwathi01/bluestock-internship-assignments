"""Day 1 - fetch live NAV history from mfapi.in and save each scheme as a raw CSV.

Run from the project root:  python scripts/live_nav_fetch.py
Output: data/raw/live_nav_<amfi_code>.csv
"""
import time
from pathlib import Path

import pandas as pd
import requests

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
BASE_URL = "https://api.mfapi.in/mf/{code}"

SCHEMES = {
    125497: "SBI Small Cap Direct",
    119551: "SBI Bluechip",
    120503: "ICICI Bluechip",
    118632: "Nippon Large Cap",
    119092: "Axis Bluechip",
    120841: "Kotak Bluechip",
}


def fetch_nav(code, retries=3):
    """Call the API and return a DataFrame with columns: date, nav, amfi_code, scheme_name."""
    for attempt in range(1, retries + 1):
        try:
            resp = requests.get(BASE_URL.format(code=code), timeout=30)
            resp.raise_for_status()
            payload = resp.json()
            break
        except (requests.RequestException, ValueError) as exc:
            print(f"  attempt {attempt} failed for {code}: {exc}")
            if attempt == retries:
                return None
            time.sleep(2 * attempt)

    df = pd.DataFrame(payload.get("data", []))
    if df.empty:
        print(f"  no data returned for {code}")
        return None
    df["date"] = pd.to_datetime(df["date"], format="%d-%m-%Y")
    df["nav"] = pd.to_numeric(df["nav"], errors="coerce")
    df["amfi_code"] = code
    df["scheme_name"] = payload.get("meta", {}).get("scheme_name", SCHEMES[code])
    return df.sort_values("date").reset_index(drop=True)


def main():
    RAW.mkdir(parents=True, exist_ok=True)
    for code, label in SCHEMES.items():
        print(f"Fetching {label} ({code}) ...")
        df = fetch_nav(code)
        if df is None:
            continue
        out = RAW / f"live_nav_{code}.csv"
        df.to_csv(out, index=False)
        print(f"  saved {len(df)} rows ({df.date.min().date()} to {df.date.max().date()}) -> {out.name}")
        time.sleep(1)  # be polite to the API


if __name__ == "__main__":
    main()
