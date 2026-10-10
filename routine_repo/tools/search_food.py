#!/usr/bin/env python3
"""Search the bundled nutrient database. Standard library only.

Usage:
  python3 tools/search_food.py "banana"                 # fuzzy search by name (English or German)
  python3 tools/search_food.py "Vollkornbrot" --limit 20
  python3 tools/search_food.py --show 10001166          # all values of one food (per 100 g/ml)
  python3 tools/search_food.py --nutrients              # list nutrient codes, names and units
  python3 tools/search_food.py --version                # db_version

Search output: id | name | German name | source | typical serving
Prefer BLS foods (source bls) over USDA (source usda) when both fit equally well.
Only use ids printed by this tool. Never invent ids.
"""

import argparse
import difflib
import os
import re
import sqlite3
import sys

DB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "db", "nutrients.sqlite")


def connect():
    if not os.path.exists(DB):
        sys.exit(f"database not found: {DB}")
    return sqlite3.connect(DB)


def fts_query(text: str) -> str:
    words = [w for w in re.findall(r"\w+", text.lower()) if len(w) > 1]
    return " OR ".join(f'"{w}"*' for w in words)


def search(db, text: str, limit: int):
    q = fts_query(text)
    if not q:
        return []
    rows = db.execute(
        "SELECT f.id, f.name, f.name_de, f.source, f.default_serving_g, f.serving_label "
        "FROM food_search s JOIN food f ON f.id = s.rowid WHERE food_search MATCH ? "
        "ORDER BY bm25(food_search) LIMIT 400", (q,)).fetchall()
    needle = text.lower()

    def score(r):
        names = [r[1].lower()] + ([r[2].lower()] if r[2] else [])
        sim = max(difflib.SequenceMatcher(None, needle, n).ratio() for n in names)
        words = set(re.findall(r"\w+", needle))
        covered = max(len(words & set(re.findall(r"\w+", n))) for n in names) / max(1, len(words))
        raw_bonus = 0.05 if re.search(r"\braw\b|\broh\b", " ".join(names)) else 0
        source_bonus = 0.08 if r[3] == "bls" else 0
        return covered + sim + raw_bonus + source_bonus

    rows.sort(key=score, reverse=True)
    return rows[:limit]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("query", nargs="?")
    ap.add_argument("--limit", type=int, default=12)
    ap.add_argument("--show", type=int, metavar="FOOD_ID")
    ap.add_argument("--nutrients", action="store_true")
    ap.add_argument("--version", action="store_true")
    a = ap.parse_args()
    db = connect()

    if a.version:
        print(db.execute("SELECT value FROM meta WHERE key = 'db_version'").fetchone()[0])
        return
    if a.nutrients:
        for code, name, unit, fills in db.execute(
                "SELECT code, name, unit, claude_fills FROM nutrient ORDER BY importance_rank"):
            print(f"{code}\t{name}\t{unit}" + ("\t(estimate when missing)" if fills else ""))
        return
    if a.show is not None:
        f = db.execute("SELECT id, name, name_de, source, source_ref, default_serving_g, serving_label "
                       "FROM food WHERE id = ?", (a.show,)).fetchone()
        if not f:
            sys.exit(f"no food with id {a.show}")
        print(f"{f[0]} | {f[1]} | {f[2] or ''} | {f[3]} {f[4] or ''} | serving: {f[5] or '-'} g {f[6] or ''}")
        for code, name, unit, amount in db.execute(
                "SELECT n.code, n.name, n.unit, v.amount_per_100 FROM food_nutrient v JOIN nutrient n "
                "ON n.id = v.nutrient_id WHERE v.food_id = ? ORDER BY n.importance_rank", (a.show,)):
            print(f"  {code}\t{amount:g} {unit}\t{name}")
        return
    if not a.query:
        ap.print_help()
        return
    for r in search(db, a.query, a.limit):
        serving = f"{r[4]:g} g ({r[5]})" if r[4] else "-"
        print(f"{r[0]} | {r[1]} | {r[2] or ''} | {r[3]} | serving: {serving}")


if __name__ == "__main__":
    main()
