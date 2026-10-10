# Nutrient Tracker

Personal Android app (Flutter) that logs everything eaten and drunk, compares daily averages with official reference
values, and suggests single foods to fix gaps. Built from `Nutrition Tracker App — Spec for Claude Code.md`
(phases 1–4; the visual design comes later and only touches `lib/ui/theme.dart`).

## Layout

| Path | Contents |
| --- | --- |
| `lib/data/` | Drift schema (`tables.dart`), DAOs and bundled-DB import (`database.dart`) |
| `lib/nutrition/` | Pure Dart: targets, bar classification, window averages, suggestions, status answers, Nutri-Score |
| `lib/claude/` | `ClaudeBackend` interface, `RoutineBackend` (GitHub exchange + fire + polling), schema validation |
| `lib/input/` | Voice, photo, Open Food Facts lookup, package-size parsing |
| `lib/services/` | Wiring: request creation, result import, enrichment, supplements, reports |
| `lib/ui/` | Pages and widgets (placeholder styling); all style values in `ui/theme.dart` |
| `routine_repo/` | Contents of the private routine repo: `ROUTINE.md`, `SETUP.md`, schemas, DB, tools |
| `tool/` | Python build of the bundled nutrient DB (see `tool/README.md`) |

## Build and run

```sh
flutter pub get
dart run build_runner build      # after changing lib/data/tables.dart
flutter test                     # nutrition logic, routine backend, import pipeline, widgets
flutter build apk --release      # needs the Android SDK
```

Then follow `routine_repo/SETUP.md` once and enter the connection in the app's onboarding.

## Decisions on open items (2026-10-10)

- **Bars:** yellow between average requirement and recommended intake. Estimated values (Schätzwerte) and other
  targets without an average requirement: red below 2/3. Energy: green within ±5 %, red beyond ±15 %.
- **Average requirement:** DGE's is only in the paid binder → EFSA ARs (DRV Finder). Where the EFSA AR is at or
  above the DGE value (riboflavin; niacin at high PAL) the EFSA PRI is used as the target.
- **Macros:** fat 20–35 %E and carbohydrates 45–60 %E (EFSA ranges); protein 0.8 g/kg (1.0 at 65+) with weight
  capped at BMI 25, red below EFSA AR 0.66 g/kg. Total sugar: number only; WHO limit on free sugars.
- **Sodium:** DGE minimum bar plus the WHO salt limit bar. Copper, manganese, chromium, molybdenum, fluoride:
  number only. Water: not tracked.
- **ULs with form-specific scope** apply to that form: magnesium and niacin to supplements only, vitamin A to
  retinol, folate to folic acid. EFSA "safe levels" (iron, manganese) never turn a bar red.
- **Profile:** DGE energy by PAL 1.4/1.6/1.8 (table values); women's iron by menstruation status (3 options);
  zinc by phytate level (default medium). Adults 19+ only.
- **Nutrient DB:** BLS 4.0 (CC BY 4.0) + USDA SR Legacy + Foundation; BLS preferred. Missing values (e.g. BLS has
  no selenium, USDA no iodine) are filled by Claude on the first use of each food, stored with provenance;
  label > database > estimate.
- **Healthiness:** NOVA group (Open Food Facts or Claude), Claude's absolute health rating 1–5 with a reason
  (cached once per food), Nutri-Score 2023 computed locally. Warning shown for ratings 1–2; "by healthiness" sorts
  by the rating. This replaces the spec's separate `food_warning` request: it is part of `enrich_food`.
- **Supplement days:** days that only contain automatic supplement entries don't count as logged days.
- **Time windows** are rolling: 3, 7, 30 and 365 days ending today.

## Open items still open

- Measure real routine turnaround and tune polling (`RoutineBackend` constants).
- When to replace routines with an own server (`ServerBackend` behind `ClaudeBackend`).
