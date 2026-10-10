"""Reference values for adults, transcribed from the official sources (retrieved 2026-10-10).

Row fields:
  code        nutrient code (catalog.py)
  sex         'm', 'f' or 'any'
  age_min/max inclusive years
  value_type  RI   recommended intake (DGE "empfohlene Zufuhr")
              EV   estimated value (DGE "Schätzwert")
              GV   guide value (DGE "Richtwert")
              AR   average requirement (EFSA)
              PRI  population reference intake (EFSA; used only when AR >= DGE RI)
              UL   tolerable upper intake level (EFSA)
              LIMIT  WHO upper limit
              RANGE_LOW / RANGE_HIGH  EFSA reference intake range (% energy)
              ENERGY  DGE energy guide value
  amount      number in the nutrient's unit (or per basis)
  basis       'abs' | 'per_kg_bw' | 'pct_energy' | 'per_mj'
  condition   '' or 'key=value' (pal=1.4, iron_status=..., phytate=...)
  ul_basis    for UL rows: 'total' | 'supplement' | 'nutrient:<CODE>'
  source      citation

Values that EFSA calls a "safe level of intake" are deliberately not included (never turn a bar red).
Nutrients without any official value get no rows and therefore no bar.
"""

DGE = "DGE/ÖGE Referenzwerte für die Nährstoffzufuhr, 3. Aufl. 2025 – dge.de/wissenschaft/referenzwerte/{}"
EFSA_DRV = "EFSA DRV Finder (multimedia.efsa.europa.eu/drvs), {}"
EFSA_UL = "EFSA Overview on Tolerable Upper Intake Levels, Version 11 (Aug 2025)"
WHO = "WHO Healthy diet fact sheet No. 394"

# DGE adult age bands (inclusive)
A19, A25, A51, A65 = (19, 24), (25, 50), (51, 64), (65, 130)
ADULT = (19, 130)

rows: list[dict] = []


def add(code, sex, ages, vtype, amount, *, basis="abs", cond="", ul_basis="", source):
    rows.append(dict(code=code, sex=sex, age_min=ages[0], age_max=ages[1], value_type=vtype,
                     amount=amount, basis=basis, condition=cond, ul_basis=ul_basis, source=source))


def per_band(code, vtype, slug, m: list, f: list, **kw):
    """m/f: values for the four DGE adult bands."""
    for ages, vm, vf in zip((A19, A25, A51, A65), m, f):
        if vm is not None:
            add(code, "m", ages, vtype, vm, source=DGE.format(slug), **kw)
        if vf is not None:
            add(code, "f", ages, vtype, vf, source=DGE.format(slug), **kw)


# --- Energy (DGE Richtwerte, kcal/day, by PAL) ---
for pal, m, f in (
    ("1.4", [2400, 2300, 2200, 2100], [1900, 1800, 1700, 1700]),
    ("1.6", [2800, 2700, 2500, 2500], [2200, 2100, 2000, 1900]),
    ("1.8", [3100, 3000, 2800, 2800], [2500, 2400, 2200, 2100]),
):
    per_band("ENERC_KCAL", "ENERGY", "energie", m, f, cond=f"pal={pal}")

# --- Protein: DGE RI 0.8 g/kg (19–64), EV 1.0 g/kg (65+); EFSA AR 0.66 / PRI 0.83 g/kg ---
for sex in ("m", "f"):
    for ages in (A19, A25, A51):
        add("PROT", sex, ages, "RI", 0.8, basis="per_kg_bw", source=DGE.format("protein"))
    add("PROT", sex, A65, "EV", 1.0, basis="per_kg_bw", source=DGE.format("protein"))
    add("PROT", sex, ADULT, "AR", 0.66, basis="per_kg_bw", source=EFSA_DRV.format("Protein, adults"))
    add("PROT", sex, ADULT, "PRI", 0.83, basis="per_kg_bw", source=EFSA_DRV.format("Protein, adults"))

# --- Fat and carbohydrates: EFSA reference intake ranges (% energy) ---
add("FAT", "any", ADULT, "RANGE_LOW", 20, basis="pct_energy", source=EFSA_DRV.format("Total fat, RI 20–35 E%"))
add("FAT", "any", ADULT, "RANGE_HIGH", 35, basis="pct_energy", source=EFSA_DRV.format("Total fat, RI 20–35 E%"))
add("CHO", "any", ADULT, "RANGE_LOW", 45, basis="pct_energy", source=EFSA_DRV.format("Total carbohydrates, RI 45–60 E%"))
add("CHO", "any", ADULT, "RANGE_HIGH", 60, basis="pct_energy", source=EFSA_DRV.format("Total carbohydrates, RI 45–60 E%"))

# --- Fiber: DGE guide value >= 30 g/day ---
add("FIBT", "any", ADULT, "GV", 30, source=DGE.format("ballaststoffe"))

# --- Essential fatty acids: DGE recommended intake in % energy ---
add("F18:2CN6", "any", ADULT, "RI", 2.5, basis="pct_energy", source=DGE.format("fett-essenzielle-fettsaeuren"))
add("F18:3CN3", "any", ADULT, "RI", 0.5, basis="pct_energy", source=DGE.format("fett-essenzielle-fettsaeuren"))

# --- WHO limits ---
add("FASAT", "any", ADULT, "LIMIT", 10, basis="pct_energy", source=WHO + " – saturated fat < 10 % of energy")
add("FATRN", "any", ADULT, "LIMIT", 1, basis="pct_energy", source=WHO + " – trans fat < 1 % of energy")
add("FSUGAR", "any", ADULT, "LIMIT", 10, basis="pct_energy", source=WHO + " – free sugars < 10 % of energy")
add("NACL", "any", ADULT, "LIMIT", 5, source=WHO + " – salt < 5 g/day")

# --- Vitamins ---
per_band("VITA", "RI", "vitamin-a", [850, 850, 850, 800], [700, 700, 700, 700])
add("VITA", "m", ADULT, "AR", 570, source=EFSA_DRV.format("Vitamin A, AR 570 µg RE/day"))
add("VITA", "f", ADULT, "AR", 490, source=EFSA_DRV.format("Vitamin A, AR 490 µg RE/day"))
add("VITA", "m", ADULT, "PRI", 750, source=EFSA_DRV.format("Vitamin A, PRI 750 µg RE/day"))
add("VITA", "f", ADULT, "PRI", 650, source=EFSA_DRV.format("Vitamin A, PRI 650 µg RE/day"))
add("VITA", "any", ADULT, "UL", 3000, ul_basis="nutrient:RETOL", source=EFSA_UL + " – preformed vitamin A (retinol)")

per_band("VITD", "EV", "vitamin-d", [20] * 4, [20] * 4)
add("VITD", "any", ADULT, "UL", 100, ul_basis="total", source=EFSA_UL)

per_band("VITE", "EV", "vitamin-e", [8] * 4, [8] * 4)
add("VITE", "any", ADULT, "UL", 300, ul_basis="total", source=EFSA_UL)

per_band("VITK", "EV", "vitamin-k", [70, 70, 80, 80], [60, 60, 65, 65])

per_band("THIA", "RI", "thiamin", [1.3, 1.2, 1.2, 1.1], [1.0] * 4)
add("THIA", "any", ADULT, "AR", 0.072, basis="per_mj", source=EFSA_DRV.format("Thiamin, AR 0.072 mg/MJ"))
add("THIA", "any", ADULT, "PRI", 0.1, basis="per_mj", source=EFSA_DRV.format("Thiamin, PRI 0.1 mg/MJ"))

per_band("RIBF", "RI", "riboflavin", [1.4, 1.4, 1.3, 1.3], [1.1, 1.1, 1.0, 1.0])
add("RIBF", "any", ADULT, "AR", 1.3, source=EFSA_DRV.format("Riboflavin, AR 1.3 mg/day"))
add("RIBF", "any", ADULT, "PRI", 1.6, source=EFSA_DRV.format("Riboflavin, PRI 1.6 mg/day"))

per_band("NIAEQ", "RI", "niacin", [16, 15, 15, 14], [13, 12, 11, 11])
add("NIAEQ", "any", ADULT, "AR", 1.3, basis="per_mj", source=EFSA_DRV.format("Niacin, AR 1.3 mg NE/MJ"))
add("NIAEQ", "any", ADULT, "PRI", 1.6, basis="per_mj", source=EFSA_DRV.format("Niacin, PRI 1.6 mg NE/MJ"))
add("NIAEQ", "any", ADULT, "UL", 10, ul_basis="supplement", source=EFSA_UL + " – nicotinic acid (applied to supplements)")

per_band("VITB6", "RI", "vitamin-b6", [1.6] * 4, [1.4] * 4)
add("VITB6", "m", ADULT, "AR", 1.5, source=EFSA_DRV.format("Vitamin B6, AR 1.5 mg/day"))
add("VITB6", "f", ADULT, "AR", 1.3, source=EFSA_DRV.format("Vitamin B6, AR 1.3 mg/day"))
add("VITB6", "m", ADULT, "PRI", 1.7, source=EFSA_DRV.format("Vitamin B6, PRI 1.7 mg/day"))
add("VITB6", "f", ADULT, "PRI", 1.6, source=EFSA_DRV.format("Vitamin B6, PRI 1.6 mg/day"))
add("VITB6", "any", ADULT, "UL", 12, ul_basis="total", source=EFSA_UL)

per_band("FOL", "RI", "folat", [300] * 4, [300] * 4)
add("FOL", "any", ADULT, "AR", 250, source=EFSA_DRV.format("Folate, AR 250 µg DFE/day"))
add("FOL", "any", ADULT, "PRI", 330, source=EFSA_DRV.format("Folate, PRI 330 µg DFE/day"))
add("FOL", "any", ADULT, "UL", 1000, ul_basis="nutrient:FOLAC", source=EFSA_UL + " – folic acid and added folate forms")

per_band("PANTAC", "EV", "pantothensaeure", [5] * 4, [5] * 4)
per_band("BIOT", "EV", "biotin", [40] * 4, [40] * 4)
per_band("VITB12", "EV", "vitamin-b12", [4.0] * 4, [4.0] * 4)

per_band("VITC", "RI", "vitamin-c", [110] * 4, [95] * 4)
add("VITC", "m", ADULT, "AR", 90, source=EFSA_DRV.format("Vitamin C, AR 90 mg/day"))
add("VITC", "f", ADULT, "AR", 80, source=EFSA_DRV.format("Vitamin C, AR 80 mg/day"))
add("VITC", "m", ADULT, "PRI", 110, source=EFSA_DRV.format("Vitamin C, PRI 110 mg/day"))
add("VITC", "f", ADULT, "PRI", 95, source=EFSA_DRV.format("Vitamin C, PRI 95 mg/day"))

# --- Minerals ---
per_band("NA", "EV", "natrium", [1500] * 4, [1500] * 4)
per_band("CLD", "EV", "chlorid", [2300] * 4, [2300] * 4)
per_band("K", "EV", "kalium", [4000] * 4, [4000] * 4)

per_band("CA", "RI", "calcium", [1000] * 4, [1000] * 4)
add("CA", "any", A19, "AR", 860, source=EFSA_DRV.format("Calcium 18–24 y, AR 860 mg/day"))
add("CA", "any", (25, 130), "AR", 750, source=EFSA_DRV.format("Calcium ≥ 25 y, AR 750 mg/day"))
add("CA", "any", A19, "PRI", 1000, source=EFSA_DRV.format("Calcium 18–24 y, PRI 1000 mg/day"))
add("CA", "any", (25, 130), "PRI", 950, source=EFSA_DRV.format("Calcium ≥ 25 y, PRI 950 mg/day"))
add("CA", "any", ADULT, "UL", 2500, ul_basis="total", source=EFSA_UL)

per_band("P", "EV", "phosphor", [550] * 4, [550] * 4)

per_band("MG", "EV", "magnesium", [350] * 4, [300] * 4)
add("MG", "any", ADULT, "UL", 250, ul_basis="supplement", source=EFSA_UL + " – readily dissociable Mg salts in supplements")

# Iron: men 11 mg; women by status (DGE footnote d: non-menstruating women 11 mg)
per_band("FE", "RI", "eisen", [11] * 4, [None] * 4)
for ages in (A19, A25, A51):
    add("FE", "f", ages, "RI", 16, cond="iron_status=menstruating", source=DGE.format("eisen"))
    add("FE", "f", ages, "RI", 11, cond="iron_status=not_menstruating", source=DGE.format("eisen") + " (footnote d)")
    add("FE", "f", ages, "RI", 14, cond="iron_status=postmenopausal", source=DGE.format("eisen"))
add("FE", "f", A65, "RI", 14, source=DGE.format("eisen"))
add("FE", "m", ADULT, "AR", 6, source=EFSA_DRV.format("Iron men, AR 6 mg/day"))
add("FE", "f", ADULT, "AR", 7, cond="iron_status=menstruating", source=EFSA_DRV.format("Iron women ≥ 18 y, AR 7 mg/day"))
add("FE", "f", ADULT, "AR", 6, cond="iron_status=not_menstruating", source=EFSA_DRV.format("Iron, AR 6 mg/day (as men)"))
add("FE", "f", ADULT, "AR", 6, cond="iron_status=postmenopausal", source=EFSA_DRV.format("Iron postmenopausal women, AR 6 mg/day"))
add("FE", "m", ADULT, "PRI", 11, source=EFSA_DRV.format("Iron men, PRI 11 mg/day"))
add("FE", "f", ADULT, "PRI", 16, cond="iron_status=menstruating", source=EFSA_DRV.format("Iron women, PRI 16 mg/day"))
add("FE", "f", ADULT, "PRI", 11, cond="iron_status=not_menstruating", source=EFSA_DRV.format("Iron, PRI 11 mg/day"))
add("FE", "f", ADULT, "PRI", 11, cond="iron_status=postmenopausal", source=EFSA_DRV.format("Iron postmenopausal women, PRI 11 mg/day"))
# Iron has only an EFSA safe level of intake (40 mg) -> never red from high intake.

# Iodine: DGE RI 150 µg (2025), EFSA UL 600 µg
per_band("ID", "RI", "jod", [150] * 4, [150] * 4)
add("ID", "any", ADULT, "UL", 600, ul_basis="total", source=EFSA_UL)

# Zinc by phytate intake. DGE low/medium/high = 330/660/990 mg phytate;
# EFSA ARs/PRIs for LPI 300/600/900 mg are the nearest levels.
for phy, dm, df, arm, arf, prim, prif in (
    ("low", 11, 7, 7.5, 6.2, 9.4, 7.5),
    ("medium", 14, 8, 9.3, 7.6, 11.7, 9.3),
    ("high", 16, 10, 11.0, 8.9, 14.0, 11.0),
):
    per_band("ZN", "RI", "zink", [dm] * 4, [df] * 4, cond=f"phytate={phy}")
    lpi = {"low": 300, "medium": 600, "high": 900}[phy]
    add("ZN", "m", ADULT, "AR", arm, cond=f"phytate={phy}", source=EFSA_DRV.format(f"Zinc men LPI {lpi} mg/day"))
    add("ZN", "f", ADULT, "AR", arf, cond=f"phytate={phy}", source=EFSA_DRV.format(f"Zinc women LPI {lpi} mg/day"))
    add("ZN", "m", ADULT, "PRI", prim, cond=f"phytate={phy}", source=EFSA_DRV.format(f"Zinc men LPI {lpi} mg/day"))
    add("ZN", "f", ADULT, "PRI", prif, cond=f"phytate={phy}", source=EFSA_DRV.format(f"Zinc women LPI {lpi} mg/day"))
add("ZN", "any", ADULT, "UL", 25, ul_basis="total", source=EFSA_UL)

per_band("SE", "EV", "selen", [70] * 4, [60] * 4)
add("SE", "any", ADULT, "UL", 255, ul_basis="total", source=EFSA_UL)
