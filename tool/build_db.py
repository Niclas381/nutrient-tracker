#!/usr/bin/env python3
"""Builds the bundled nutrient database (SQLite).

Inputs (tool/raw/, see tool/README.md for download links):
  bls/BLS_4_0_2025_DE/BLS_4_0_Daten_2025_DE.xlsx   BLS 4.0 (CC BY 4.0, Max Rubner-Institut)
  sr/FoodData_Central_sr_legacy_food_csv_2018-04/   USDA SR Legacy (public domain)
  fnd/FoodData_Central_foundation_food_csv_*/       USDA Foundation Foods (public domain)

Outputs (identical files, so food ids resolve in both places):
  assets/db/nutrients.sqlite
  routine_repo/db/nutrients.sqlite
  assets/db/db_version.txt   (lets the app check the bundled version without reading the DB)

Food ids are stable:
  BLS:  10_000_001 … assigned per BLS code and persisted in tool/bls_ids.json (new codes are appended)
  USDA: fdc_id (< 10_000_000). A food in both SR Legacy and Foundation (same NDB number) is merged:
        Foundation values win per nutrient, SR Legacy fills the gaps; the Foundation fdc_id is used.
User-created foods in the app start at 100_000_000.
"""

import csv
import glob
import os
import re
import sqlite3
import sys

from catalog import BY_CODE, CATALOG, nutrient_id
from common_foods import COMMON_FOODS
import nutriscore_heuristics as nsh
import reference_values

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
RAW = os.path.join(HERE, "raw")
DB_VERSION = "2026.10.10-1"
OUTPUTS = [os.path.join(ROOT, "assets", "db", "nutrients.sqlite"),
           os.path.join(ROOT, "routine_repo", "db", "nutrients.sqlite")]


# ---------------------------------------------------------------------------
# BLS
# ---------------------------------------------------------------------------

def bls_tsv_path():
    tsv = os.path.join(RAW, "bls", "bls.tsv")
    if not os.path.exists(tsv):
        import openpyxl  # only needed once
        xlsx = os.path.join(RAW, "bls", "BLS_4_0_2025_DE", "BLS_4_0_Daten_2025_DE.xlsx")
        ws = openpyxl.load_workbook(xlsx, read_only=True).worksheets[0]
        with open(tsv, "w", newline="") as f:
            w = csv.writer(f, delimiter="\t")
            for r in ws.iter_rows(values_only=True):
                w.writerow(["" if v is None else v for v in r])
    return tsv


BLS_IDS_FILE = os.path.join(HERE, "bls_ids.json")


def bls_id_map(codes):
    """BLS code -> food id, persisted in bls_ids.json so ids stay stable across rebuilds and BLS versions."""
    import json
    ids = json.load(open(BLS_IDS_FILE)) if os.path.exists(BLS_IDS_FILE) else {}
    next_id = max(ids.values(), default=10_000_000) + 1
    for code in sorted(codes):
        if code not in ids:
            ids[code] = next_id
            next_id += 1
    json.dump(ids, open(BLS_IDS_FILE, "w"), indent=0, sort_keys=True)
    return ids


def load_bls():
    rows = list(csv.reader(open(bls_tsv_path(), encoding="utf-8"), delimiter="\t"))
    header, data = rows[0], rows[1:]
    col = {}
    for i, h in enumerate(header):
        m = re.match(r"^(\S+) .*\[[^\]]+/100g\]$", h)
        if m:
            col[m.group(1)] = i
    ids = bls_id_map(r[0] for r in data)
    foods = []
    for r in data:
        code, name_de, name_en = r[0], r[1], r[2]
        values = {}
        for n in CATALOG:
            if not (n.bls and n.bls in col):
                continue
            raw = r[col[n.bls]]
            if raw in ("", "-"):  # BLS: '-' = missing value, not zero
                continue
            if raw in ("TR", "<LOD", "<LOQ", "<LOD or <LOQ"):  # trace / below detection limit
                values[n.code] = 0.0
            else:
                values[n.code] = float(raw) * n.bls_factor
        foods.append(dict(id=ids[code], name=name_en.strip(), name_de=name_de.strip(), source="bls",
                          source_ref=code, group=code[:2], values=values, serving_g=None, serving_label=None))
    return foods


# ---------------------------------------------------------------------------
# USDA
# ---------------------------------------------------------------------------

def read_csv(path):
    with open(path, encoding="utf-8") as f:
        yield from csv.DictReader(f)


def usda_raw(dirpath, only_ids=None):
    """Returns {fdc_id: {nutrient_id: amount}}, descriptions, categories, first portions."""
    vals = {}
    for r in read_csv(os.path.join(dirpath, "food_nutrient.csv")):
        if only_ids is not None and r["fdc_id"] not in only_ids:
            continue
        if r["amount"] == "":
            continue
        vals.setdefault(r["fdc_id"], {})[int(r["nutrient_id"])] = float(r["amount"])
    desc, cat = {}, {}
    for r in read_csv(os.path.join(dirpath, "food.csv")):
        if only_ids is None or r["fdc_id"] in only_ids:
            desc[r["fdc_id"]] = r["description"]
            cat[r["fdc_id"]] = r["food_category_id"]
    portions = {}
    for r in read_csv(os.path.join(dirpath, "food_portion.csv")):
        fid = r["fdc_id"]
        if (only_ids is not None and fid not in only_ids) or not r["gram_weight"]:
            continue
        seq = int(r["seq_num"] or 999)
        if fid not in portions or seq < portions[fid][0]:
            label = " ".join(x for x in (r["amount"], r["portion_description"] or r["modifier"]) if x).strip()
            portions[fid] = (seq, float(r["gram_weight"]), label)
    return vals, desc, cat, portions


def usda_value(n, raw: dict):
    """Canonical value for catalogue entry n from a USDA nutrient dict, or None."""
    if n.derive:
        return DERIVE[n.derive](raw)
    for nid, factor in n.usda:
        if nid in raw:
            return raw[nid] * factor
    return None


def _sum_if_any(raw, ids):
    present = [raw[i] for i in ids if i in raw]
    return sum(present) if present else None


DERIVE = {
    # EU convention: available carbohydrate = carbohydrate by difference - total fiber
    "usda_available_cho": lambda r: (max(0.0, r[1005] - r.get(1079, 0.0)) if 1005 in r
                                     else r.get(1050)),
    "usda_salt": lambda r: r[1093] * 2.5 / 1000 if 1093 in r else None,
    # DFE when given; Foundation foods have no folic acid fortification data -> total folate
    "usda_folate_dfe": lambda r: r.get(1190, r.get(1177)),
    "usda_vitk": lambda r: _sum_if_any(r, [1185, 1183]),
    # niacin equivalents = niacin + tryptophan[g] * 1000 / 60 (same formula as BLS NIAEQ)
    "usda_niacin_eq": lambda r: (r[1167] + r.get(1210, 0.0) * 1000 / 60) if 1167 in r else None,
    "usda_n3": lambda r: _sum_if_any(r, [1404 if 1404 in r else 1270, 1276, 1278, 1280, 1272]),
    "usda_n6": lambda r: _sum_if_any(r, [1316 if 1316 in r else 1269, 1321, 1313, 1406,
                                         1408 if 1408 in r else 1271]),
    "usda_aae9": lambda r: _sum_if_any(r, [1221, 1212, 1213, 1214, 1215, 1217, 1211, 1210, 1219]),
    "c18_1_total": lambda r: r.get(1268),
}


def load_usda():
    sr_dir = glob.glob(os.path.join(RAW, "sr", "FoodData_Central_sr_legacy_food_csv_*"))[0]
    fnd_dir = sorted(glob.glob(os.path.join(RAW, "fnd", "FoodData_Central_foundation_food_csv_*")))[-1]

    sr_ndb = {r["fdc_id"]: r["NDB_number"] for r in read_csv(os.path.join(sr_dir, "sr_legacy_food.csv"))}
    sr_vals, sr_desc, sr_cat, sr_por = usda_raw(sr_dir)

    fnd_ndb = {r["fdc_id"]: r["NDB_number"] for r in read_csv(os.path.join(fnd_dir, "foundation_food.csv"))}
    fnd_vals, fnd_desc, fnd_cat, fnd_por = usda_raw(fnd_dir, only_ids=set(fnd_ndb))

    ndb_to_sr = {ndb: fid for fid, ndb in sr_ndb.items()}
    merged_sr = set()
    foods = []
    for fid, ndb in fnd_ndb.items():
        raw = dict(fnd_vals.get(fid, {}))
        por = fnd_por.get(fid)
        sr_id = ndb_to_sr.get(ndb)
        if sr_id:
            merged_sr.add(sr_id)
            # per canonical nutrient: Foundation first, SR Legacy fills gaps (done below)
        foods.append(dict(id=int(fid), name=fnd_desc[fid], name_de=None, source="usda",
                          source_ref=f"fdc:{fid}" + (f" (+SR fdc:{sr_id})" if sr_id else ""),
                          group=fnd_cat[fid], raw=raw, raw_fallback=sr_vals.get(sr_id, {}) if sr_id else {},
                          serving_g=(por or (None, None, None))[1] or (sr_por.get(sr_id) or (None, None, None))[1],
                          serving_label=(por or (None, None, None))[2] or (sr_por.get(sr_id) or (None, None, None))[2]))
    for fid in sr_ndb:
        if fid in merged_sr:
            continue
        por = sr_por.get(fid)
        foods.append(dict(id=int(fid), name=sr_desc[fid], name_de=None, source="usda", source_ref=f"fdc:{fid}",
                          group=sr_cat[fid], raw=sr_vals.get(fid, {}), raw_fallback={},
                          serving_g=por[1] if por else None, serving_label=por[2] if por else None))
    for f in foods:
        values = {}
        for n in CATALOG:
            if not (n.usda or n.derive):
                continue
            v = usda_value(n, f["raw"])
            if v is None and f["raw_fallback"]:
                v = usda_value(n, f["raw_fallback"])
            if v is not None:
                values[n.code] = v
        f["values"] = values
        del f["raw"], f["raw_fallback"]
    return foods


# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------

SCHEMA = """
CREATE TABLE meta(key TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE nutrient(
  id INTEGER PRIMARY KEY, code TEXT NOT NULL UNIQUE, name TEXT NOT NULL, unit TEXT NOT NULL,
  importance_rank INTEGER NOT NULL, target_type TEXT NOT NULL, has_bar INTEGER NOT NULL,
  claude_fills INTEGER NOT NULL);
CREATE TABLE food(
  id INTEGER PRIMARY KEY, name TEXT NOT NULL, name_de TEXT, source TEXT NOT NULL, source_ref TEXT,
  food_group TEXT, nutriscore_category TEXT, fvl_percent REAL,
  default_serving_g REAL, serving_label TEXT, is_common INTEGER NOT NULL DEFAULT 0,
  is_liquid INTEGER NOT NULL DEFAULT 0);
CREATE TABLE food_nutrient(
  food_id INTEGER NOT NULL, nutrient_id INTEGER NOT NULL, amount_per_100 REAL NOT NULL,
  PRIMARY KEY(food_id, nutrient_id)) WITHOUT ROWID;
CREATE TABLE reference_value(
  id INTEGER PRIMARY KEY, nutrient_id INTEGER NOT NULL, sex TEXT NOT NULL, age_min INTEGER NOT NULL,
  age_max INTEGER NOT NULL, value_type TEXT NOT NULL, amount REAL NOT NULL, basis TEXT NOT NULL,
  condition TEXT NOT NULL, ul_basis TEXT NOT NULL, source TEXT NOT NULL);
CREATE VIRTUAL TABLE food_search USING fts5(name, name_de, content='food', content_rowid='id',
  tokenize='unicode61 remove_diacritics 2');
"""


def main():
    print("loading BLS …", file=sys.stderr)
    foods = load_bls()
    print("loading USDA …", file=sys.stderr)
    foods += load_usda()

    ids = [f["id"] for f in foods]
    assert len(ids) == len(set(ids)), "food id collision"

    by_ref = {f["source_ref"].split(" ")[0]: f for f in foods}
    for ref, serving_g, label in COMMON_FOODS:
        f = by_ref.get(ref)
        if f is None:
            sys.exit(f"common food not found: {ref}")
        f["is_common"] = 1
        f["serving_g"], f["serving_label"] = serving_g, label

    for f in foods:
        cat, fvl, liquid = nsh.classify(f)
        f["ns_cat"], f["fvl"], f["liquid"] = cat, fvl, liquid

    targets_with_rows = {r["code"] for r in reference_values.rows}

    for out in OUTPUTS:
        os.makedirs(os.path.dirname(out), exist_ok=True)
        if os.path.exists(out):
            os.remove(out)
        db = sqlite3.connect(out)
        db.executescript(SCHEMA)
        db.executemany("INSERT INTO meta VALUES(?,?)", [
            ("db_version", DB_VERSION),
            ("attribution", "BLS 4.0: Max Rubner-Institut (2025), Bundeslebensmittelschlüssel (BLS), Version 4.0 – "
                            "Deutsche Nährstoffdatenbank, Karlsruhe, DOI 10.25826/Data20251217-134202-0, CC BY 4.0. "
                            "USDA FoodData Central SR Legacy and Foundation Foods, public domain."),
        ])
        for i, n in enumerate(CATALOG):
            has_bar = int(n.target != "none" and n.code in targets_with_rows)
            if n.target != "none" and not has_bar:
                sys.exit(f"{n.code} has target type {n.target} but no reference values")
            db.execute("INSERT INTO nutrient VALUES(?,?,?,?,?,?,?,?)",
                       (nutrient_id(n.code), n.code, n.name, n.unit, n.tier * 1000 + i, n.target, has_bar,
                        int(n.estimate)))
        db.executemany(
            "INSERT INTO food(id,name,name_de,source,source_ref,food_group,nutriscore_category,fvl_percent,"
            "default_serving_g,serving_label,is_common,is_liquid) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
            [(f["id"], f["name"], f["name_de"], f["source"], f["source_ref"], f["group"], f["ns_cat"], f["fvl"],
              f["serving_g"], f["serving_label"], f.get("is_common", 0), int(f["liquid"])) for f in foods])
        db.executemany(
            "INSERT INTO food_nutrient VALUES(?,?,?)",
            [(f["id"], nutrient_id(code), round(v, 6)) for f in foods for code, v in f["values"].items()])
        db.executemany(
            "INSERT INTO reference_value(nutrient_id,sex,age_min,age_max,value_type,amount,basis,condition,"
            "ul_basis,source) VALUES(?,?,?,?,?,?,?,?,?,?)",
            [(nutrient_id(r["code"]), r["sex"], r["age_min"], r["age_max"], r["value_type"], r["amount"],
              r["basis"], r["condition"], r["ul_basis"], r["source"]) for r in reference_values.rows])
        db.execute("INSERT INTO food_search(food_search) VALUES('rebuild')")
        db.commit()
        db.execute("VACUUM")
        db.close()
        print(f"wrote {out} ({os.path.getsize(out) / 1e6:.1f} MB)", file=sys.stderr)

    with open(os.path.join(ROOT, "assets", "db", "db_version.txt"), "w") as f:
        f.write(DB_VERSION)
    print(f"{len(foods)} foods, {sum(len(f['values']) for f in foods)} values, "
          f"{len(reference_values.rows)} reference values, {len(COMMON_FOODS)} common foods", file=sys.stderr)


if __name__ == "__main__":
    for code in reference_values.rows:
        assert code["code"] in BY_CODE, code
    main()
