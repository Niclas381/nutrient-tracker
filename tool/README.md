# Nutrient database build

`build_db.py` builds `assets/db/nutrients.sqlite` and the identical `routine_repo/db/nutrients.sqlite`.

## Inputs (not committed, put them into `tool/raw/`)

| Source | Download | Unpack to |
| --- | --- | --- |
| BLS 4.0 (CC BY 4.0) | blsdb.de → BLS-Daten → Download → `BLS_4_0_2025_DE.zip` | `raw/bls/BLS_4_0_2025_DE/` |
| USDA SR Legacy (public domain) | fdc.nal.usda.gov/download-datasets → SR Legacy CSV (`FoodData_Central_sr_legacy_food_csv_2018-04.zip`) | `raw/sr/` |
| USDA Foundation Foods (public domain) | same page → Foundation Foods CSV (latest) | `raw/fnd/` |

## Build

```sh
cd tool
python3 -m venv .venv && .venv/bin/pip install openpyxl   # openpyxl is only needed to read the BLS xlsx once
.venv/bin/python build_db.py
```

Bump `DB_VERSION` in `build_db.py` for every rebuild that ships. Then commit the new DB to the routine repo and ship
an app build with the same file (the app re-imports when `assets/db/db_version.txt` changes).

## Files

- `catalog.py`: canonical nutrients (codes, units, importance order, bar type, BLS/USDA mapping). Append new
  nutrients at the end of a tier; ids are list positions.
- `reference_values.py`: DGE/EFSA/WHO values, transcribed with source per row.
- `common_foods.py`: curated common grocery foods with typical servings (food suggestions). Edit freely.
- `nutriscore_heuristics.py`: Nutri-Score category and fruit/vegetable/legume % from the food group, where
  unambiguous (Claude fills the rest on first use).
- `bls_ids.json`: persisted BLS code → food id map (keeps ids stable across rebuilds). Commit it.

## Data conventions

- BLS `-` = missing (no row); `TR`, `<LOD`, `<LOQ` = 0.
- USDA carbohydrates are converted to available carbohydrate (by difference − fiber), like BLS and EU labels.
- USDA niacin is converted to niacin equivalents (niacin + tryptophan/60), like BLS.
- A food in SR Legacy and Foundation (same NDB number) is merged; Foundation values win per nutrient.
