#!/usr/bin/env python3
"""Checks result files before they are committed. Standard library only.

Usage: python3 tools/validate_result.py outbox/<request_id>.json [more files …]

Checks the structure of schemas/result.schema.json (the parts that matter), that every food_id exists in
db/nutrients.sqlite, and that every nutrient code exists. Exits non-zero and prints the problems on failure.
"""

import json
import os
import re
import sqlite3
import sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
UUID = re.compile(r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")


def main(paths):
    db = sqlite3.connect(os.path.join(ROOT, "db", "nutrients.sqlite"))
    codes = {r[0] for r in db.execute("SELECT code FROM nutrient")}
    version = db.execute("SELECT value FROM meta WHERE key='db_version'").fetchone()[0]
    ok = True
    for p in paths:
        problems = check(p, db, codes, version)
        for msg in problems:
            print(f"{p}: {msg}")
        ok &= not problems
    if ok:
        print("all results valid")
    sys.exit(0 if ok else 1)


def food_exists(db, fid):
    return isinstance(fid, int) and db.execute("SELECT 1 FROM food WHERE id = ?", (fid,)).fetchone() is not None


def check(path, db, codes, version):
    errs = []
    try:
        r = json.load(open(path, encoding="utf-8"))
    except Exception as e:  # noqa: BLE001
        return [f"not valid JSON: {e}"]
    rid = os.path.splitext(os.path.basename(path))[0]
    if r.get("request_id") != rid:
        errs.append("request_id must equal the file name")
    if not UUID.match(str(r.get("request_id", ""))):
        errs.append("request_id is not a UUID")
    t = r.get("type")
    if t not in ("log_text", "log_photo", "enrich_food", "ping"):
        errs.append(f"unknown type {t!r}")
    if r.get("db_version") != version:
        errs.append(f"db_version must be {version!r}")
    extra = set(r) - {"request_id", "type", "db_version", "status", "error_message", "result"}
    if extra:
        errs.append(f"unexpected keys {sorted(extra)}")
    status = r.get("status")
    if status == "error":
        if not r.get("error_message"):
            errs.append("error results need error_message")
        return errs
    if status != "ok":
        return errs + ["status must be ok or error"]
    res = r.get("result")
    if not isinstance(res, dict):
        return errs + ["ok results need a result object"]

    def amounts(lst, where, origin=False):
        if not isinstance(lst, list):
            errs.append(f"{where} must be a list")
            return
        for a in lst:
            if not isinstance(a, dict) or a.get("code") not in codes:
                errs.append(f"{where}: unknown nutrient code {a.get('code') if isinstance(a, dict) else a!r}")
            elif not isinstance(a.get("amount"), (int, float)) or a["amount"] < 0:
                errs.append(f"{where}: bad amount for {a['code']}")
            elif origin and a.get("origin") not in ("db", "estimate"):
                errs.append(f"{where}: origin must be db or estimate for {a['code']}")

    if t in ("log_text", "log_photo"):
        items = res.get("items")
        if not isinstance(items, list):
            return errs + ["result.items must be a list"]
        for i, it in enumerate(items):
            w = f"items[{i}]"
            if ("food_id" in it) == ("new_food" in it):
                errs.append(f"{w}: exactly one of food_id / new_food")
            if "food_id" in it and not food_exists(db, it["food_id"]):
                errs.append(f"{w}: food_id {it['food_id']} does not exist in db")
            if not isinstance(it.get("amount"), (int, float)) or it["amount"] <= 0:
                errs.append(f"{w}: amount must be > 0")
            if it.get("unit") not in ("g", "ml", "piece"):
                errs.append(f"{w}: unit must be g, ml or piece")
            c = it.get("confidence")
            if not isinstance(c, (int, float)) or not 0 <= c <= 1:
                errs.append(f"{w}: confidence must be 0..1")
            if not it.get("label"):
                errs.append(f"{w}: label missing")
            nf = it.get("new_food")
            if nf is not None:
                kind = nf.get("kind")
                if kind not in ("dish", "supplement", "food") or not nf.get("name"):
                    errs.append(f"{w}.new_food: needs name and kind dish|supplement|food")
                if kind == "dish":
                    ings = nf.get("ingredients") or []
                    if not ings:
                        errs.append(f"{w}.new_food: dish needs ingredients")
                    for g in ings:
                        if not food_exists(db, g.get("food_id")):
                            errs.append(f"{w}.new_food: ingredient food_id {g.get('food_id')} does not exist")
                        if not isinstance(g.get("grams"), (int, float)) or g["grams"] <= 0:
                            errs.append(f"{w}.new_food: ingredient grams must be > 0")
                if kind == "supplement":
                    amounts(nf.get("nutrients_per_unit"), f"{w}.new_food.nutrients_per_unit")
                    if it.get("unit") != "piece":
                        errs.append(f"{w}: supplements use unit 'piece'")
                if kind == "food":
                    key = "label_nutrients_per_100" if "label_nutrients_per_100" in nf else "estimated_nutrients_per_100"
                    amounts(nf.get(key), f"{w}.new_food.{key}")
    elif t == "enrich_food":
        amounts(res.get("nutrients_per_100"), "nutrients_per_100", origin=True)
        m = res.get("matched_food_id")
        if m is not None and not food_exists(db, m):
            errs.append(f"matched_food_id {m} does not exist")
        if "nova_group" in res and res["nova_group"] not in (1, 2, 3, 4):
            errs.append("nova_group must be 1..4")
        if "health_rating" in res and res["health_rating"] not in (1, 2, 3, 4, 5):
            errs.append("health_rating must be 1..5")
        ns = res.get("nutriscore_inputs")
        if ns is not None and ns.get("category") not in (
                "general", "beverage", "water", "fat_oil_nuts_seeds", "cheese", "red_meat", "not_applicable"):
            errs.append("nutriscore_inputs.category invalid")
    elif t == "ping" and res.get("ok") is not True:
        errs.append("ping result must be {\"ok\": true}")
    return errs


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1:])
