"""Canonical nutrient catalogue.

Every nutrient the app knows is defined here once, with
- a stable integer id and code (codes are what the routine and the app exchange),
- display name and unit,
- importance tier (spec: home-screen order) and target type,
- how to read it from BLS 4.0 (column code + factor) and USDA FDC (nutrient ids + factor),
  or a derivation from other nutrients.

Target types:
  energy   energy bar (DGE energy guide value by PAL)
  minimum  green >= recommended/estimated value, red below AR (or 2/3 rule)
  range    like minimum, additionally red above the EFSA UL
  pct_range  green inside an EFSA reference-intake range in % of energy, red outside
  limit    green <= WHO limit, red above
  none     number only, no bar
"""

from dataclasses import dataclass, field


@dataclass
class N:
    code: str
    name: str
    unit: str
    tier: int
    target: str = "none"
    bls: str | None = None
    bls_factor: float = 1.0
    usda: list = field(default_factory=list)  # [(nutrient_id, factor)], first present wins
    derive: str | None = None  # name of a derivation in build_db.py (USDA side)
    estimate: bool = False  # filled by Claude when missing (enrich_food)


# Order inside a tier is the display order.
CATALOG: list[N] = [
    # Tier 1: energy and macros
    N("ENERC_KCAL", "Energy", "kcal", 1, "energy", "ENERCC", usda=[(1008, 1), (2048, 1), (2047, 1)], estimate=True),
    N("PROT", "Protein", "g", 1, "minimum", "PROT625", usda=[(1003, 1)], estimate=True),
    N("FAT", "Fat", "g", 1, "pct_range", "FAT", usda=[(1004, 1), (1085, 1)], estimate=True),
    N("CHO", "Carbohydrates", "g", 1, "pct_range", "CHO", derive="usda_available_cho", estimate=True),
    # Tier 2
    N("FIBT", "Fiber", "g", 2, "minimum", "FIBT", usda=[(1079, 1), (2033, 1)], estimate=True),
    N("SUGAR", "Sugar (total)", "g", 2, "none", "SUGAR", usda=[(2000, 1), (1063, 1)], estimate=True),
    N("FSUGAR", "Free sugars", "g", 2, "limit", estimate=True),
    N("FASAT", "Saturated fat", "g", 2, "limit", "FASAT", usda=[(1258, 1)], estimate=True),
    N("FATRN", "Trans fat", "g", 2, "limit", usda=[(1257, 1)], estimate=True),
    N("NACL", "Salt", "g", 2, "limit", "NACL", derive="usda_salt", estimate=True),
    # Tier 3: commonly low micronutrients
    N("VITD", "Vitamin D", "µg", 3, "range", "VITD", usda=[(1114, 1), (1110, 0.025)], estimate=True),
    N("ID", "Iodine", "µg", 3, "range", "ID", usda=[(1100, 1)], estimate=True),
    N("FOL", "Folate", "µg", 3, "range", "FOL", derive="usda_folate_dfe", estimate=True),
    N("VITB12", "Vitamin B12", "µg", 3, "minimum", "VITB12", usda=[(1178, 1)], estimate=True),
    N("FE", "Iron", "mg", 3, "minimum", "FE", usda=[(1089, 1)], estimate=True),
    N("CA", "Calcium", "mg", 3, "range", "CA", usda=[(1087, 1)], estimate=True),
    N("K", "Potassium", "mg", 3, "minimum", "K", usda=[(1092, 1)], estimate=True),
    N("MG", "Magnesium", "mg", 3, "range", "MG", usda=[(1090, 1)], estimate=True),
    N("ZN", "Zinc", "mg", 3, "range", "ZN", usda=[(1095, 1)], estimate=True),
    N("SE", "Selenium", "µg", 3, "range", usda=[(1103, 1)], estimate=True),
    N("NA", "Sodium", "mg", 3, "minimum", "NA", usda=[(1093, 1)], estimate=True),
    # Tier 4: remaining vitamins and minerals
    N("VITA", "Vitamin A", "µg", 4, "range", "VITAA", usda=[(1106, 1)], estimate=True),
    N("VITE", "Vitamin E", "mg", 4, "range", "VITE", usda=[(1109, 1)], estimate=True),
    N("VITK", "Vitamin K", "µg", 4, "minimum", "VITK", derive="usda_vitk", estimate=True),
    N("THIA", "Vitamin B1 (thiamin)", "mg", 4, "minimum", "THIA", usda=[(1165, 1)], estimate=True),
    N("RIBF", "Vitamin B2 (riboflavin)", "mg", 4, "minimum", "RIBF", usda=[(1166, 1)], estimate=True),
    N("NIAEQ", "Niacin", "mg", 4, "range", "NIAEQ", derive="usda_niacin_eq", estimate=True),
    N("VITB6", "Vitamin B6", "mg", 4, "range", "VITB6", 0.001, usda=[(1175, 1)], estimate=True),
    N("PANTAC", "Pantothenic acid", "mg", 4, "minimum", "PANTAC", usda=[(1170, 1)], estimate=True),
    N("BIOT", "Biotin", "µg", 4, "minimum", "BIOT", usda=[(1176, 1)], estimate=True),
    N("VITC", "Vitamin C", "mg", 4, "minimum", "VITC", usda=[(1162, 1)], estimate=True),
    N("P", "Phosphorus", "mg", 4, "minimum", "P", usda=[(1091, 1)], estimate=True),
    N("CLD", "Chloride", "mg", 4, "minimum", "CLD", estimate=True),
    N("CU", "Copper", "mg", 4, "none", "CU", 0.001, usda=[(1098, 1)]),
    N("MN", "Manganese", "mg", 4, "none", "MN", 0.001, usda=[(1101, 1)]),
    N("CR", "Chromium", "µg", 4, "none", "CR"),
    N("MO", "Molybdenum", "µg", 4, "none", "MO", usda=[(1102, 1)]),
    N("FD", "Fluoride", "mg", 4, "none", "FD", 0.001, usda=[(1099, 0.001)]),
    N("S", "Sulphur", "mg", 4, "none", "S", usda=[(1094, 1)]),
    N("CHOLN", "Choline", "mg", 4, "none", usda=[(1180, 1)]),
    # Forms that carry their own EFSA UL (UL basis), plus related vitamin forms
    N("RETOL", "Retinol (preformed vitamin A)", "µg", 4, "none", "RETOL", usda=[(1105, 1)], estimate=True),
    N("FOLAC", "Folic acid (synthetic)", "µg", 4, "none", "FOLAC", usda=[(1186, 1)], estimate=True),
    N("NIA", "Niacin (preformed)", "mg", 4, "none", "NIA", usda=[(1167, 1)], estimate=True),
    N("FOLFD", "Folate (food)", "µg", 4, "none", "FOLFD", usda=[(1187, 1)]),
    N("CARTB", "Beta-carotene", "µg", 4, "none", "CARTB", usda=[(1107, 1)]),
    N("VITK1", "Vitamin K1 (phylloquinone)", "µg", 4, "none", "VITK1", usda=[(1185, 1)]),
    N("VITK2", "Vitamin K2 (menaquinones)", "µg", 4, "none", "VITK2", usda=[(1183, 1)]),
    N("CHOCAL", "Vitamin D3 (cholecalciferol)", "µg", 4, "none", "CHOCAL", usda=[(1112, 1)]),
    N("ERGCAL", "Vitamin D2 (ergocalciferol)", "µg", 4, "none", "ERGCAL", usda=[(1111, 1)]),
    # Tier 5: fatty acids
    N("FAMS", "Monounsaturated fat", "g", 5, "none", "FAMS", usda=[(1292, 1)]),
    N("FAPU", "Polyunsaturated fat", "g", 5, "none", "FAPU", usda=[(1293, 1)]),
    N("FAPUN3", "Omega-3 fatty acids", "g", 5, "none", "FAPUN3", derive="usda_n3"),
    N("FAPUN6", "Omega-6 fatty acids", "g", 5, "none", "FAPUN6", derive="usda_n6"),
    N("F18:2CN6", "Linoleic acid (LA)", "g", 5, "minimum", "F18:2CN6", usda=[(1316, 1), (1269, 1)], estimate=True),
    N("F18:3CN3", "Alpha-linolenic acid (ALA)", "g", 5, "minimum", "F18:3CN3", usda=[(1404, 1), (1270, 1)], estimate=True),
    N("F20:5CN3", "EPA (C20:5 n-3)", "g", 5, "none", "F20:5CN3", usda=[(1278, 1)]),
    N("F22:5CN3", "DPA (C22:5 n-3)", "g", 5, "none", "F22:5CN3", usda=[(1280, 1)]),
    N("F22:6CN3", "DHA (C22:6 n-3)", "g", 5, "none", "F22:6CN3", usda=[(1272, 1)]),
    N("F18:4CN3", "Stearidonic acid (C18:4 n-3)", "g", 5, "none", "F18:4CN3", usda=[(1276, 1)]),
    N("F18:3CN6", "Gamma-linolenic acid (C18:3 n-6)", "g", 5, "none", "F18:3CN6", usda=[(1321, 1)]),
    N("F20:2CN6", "Eicosadienoic acid (C20:2 n-6)", "g", 5, "none", "F20:2CN6", usda=[(1313, 1)]),
    N("F20:3CN6", "Dihomo-gamma-linolenic acid (C20:3 n-6)", "g", 5, "none", "F20:3CN6", usda=[(1406, 1)]),
    N("F20:4CN6", "Arachidonic acid (C20:4 n-6)", "g", 5, "none", "F20:4CN6", usda=[(1408, 1), (1271, 1)]),
    N("F18:2C9T11", "Conjugated linoleic acid (CLA)", "g", 5, "none", "F18:2C9T11", usda=[(1311, 1)]),
    N("F4:0", "Butyric acid (C4:0)", "g", 5, "none", "F4:0", usda=[(1259, 1)]),
    N("F6:0", "Caproic acid (C6:0)", "g", 5, "none", "F6:0", usda=[(1260, 1)]),
    N("F8:0", "Caprylic acid (C8:0)", "g", 5, "none", "F8:0", usda=[(1261, 1)]),
    N("F10:0", "Capric acid (C10:0)", "g", 5, "none", "F10:0", usda=[(1262, 1)]),
    N("F12:0", "Lauric acid (C12:0)", "g", 5, "none", "F12:0", usda=[(1263, 1)]),
    N("F14:0", "Myristic acid (C14:0)", "g", 5, "none", "F14:0", usda=[(1264, 1)]),
    N("F15:0", "Pentadecylic acid (C15:0)", "g", 5, "none", "F15:0", usda=[(1299, 1)]),
    N("F16:0", "Palmitic acid (C16:0)", "g", 5, "none", "F16:0", usda=[(1265, 1)]),
    N("F17:0", "Margaric acid (C17:0)", "g", 5, "none", "F17:0", usda=[(1300, 1)]),
    N("F18:0", "Stearic acid (C18:0)", "g", 5, "none", "F18:0", usda=[(1266, 1)]),
    N("F20:0", "Arachidic acid (C20:0)", "g", 5, "none", "F20:0", usda=[(1267, 1)]),
    N("F22:0", "Behenic acid (C22:0)", "g", 5, "none", "F22:0", usda=[(1273, 1)]),
    N("F24:0", "Lignoceric acid (C24:0)", "g", 5, "none", "F24:0", usda=[(1301, 1)]),
    N("F14:1CN5", "Myristoleic acid (C14:1)", "g", 5, "none", "F14:1CN5", usda=[(2009, 1), (1274, 1)]),
    N("F16:1CN7", "Palmitoleic acid (C16:1)", "g", 5, "none", "F16:1CN7", usda=[(1314, 1), (1275, 1)]),
    N("F18:1CN9", "Oleic acid (C18:1 n-9)", "g", 5, "none", "F18:1CN9"),
    N("F18:1CN7", "Vaccenic acid (C18:1 n-7)", "g", 5, "none", "F18:1CN7", usda=[(1413, 1)]),
    N("F18:1", "C18:1 fatty acids (total)", "g", 5, "none", derive="c18_1_total"),
    N("F20:1CN9", "Gondoic acid (C20:1)", "g", 5, "none", "F20:1CN9", usda=[(2012, 1), (1277, 1)]),
    N("F22:1CN9", "Erucic acid (C22:1)", "g", 5, "none", "F22:1CN9", usda=[(2014, 1), (1279, 1)]),
    N("CHORL", "Cholesterol", "mg", 5, "none", "CHORL", usda=[(1253, 1)]),
    # Tier 5: amino acids
    N("AAE9", "Essential amino acids (total)", "g", 5, "none", "AAE9", derive="usda_aae9"),
    N("AA_HIS", "Histidine", "g", 5, "none", "HIS", usda=[(1221, 1)]),
    N("AA_ILE", "Isoleucine", "g", 5, "none", "ILE", usda=[(1212, 1)]),
    N("AA_LEU", "Leucine", "g", 5, "none", "LEU", usda=[(1213, 1)]),
    N("AA_LYS", "Lysine", "g", 5, "none", "LYS", usda=[(1214, 1)]),
    N("AA_MET", "Methionine", "g", 5, "none", "MET", usda=[(1215, 1)]),
    N("AA_PHE", "Phenylalanine", "g", 5, "none", "PHE", usda=[(1217, 1)]),
    N("AA_THR", "Threonine", "g", 5, "none", "THR", usda=[(1211, 1)]),
    N("AA_TRP", "Tryptophan", "g", 5, "none", "TRP", usda=[(1210, 1)]),
    N("AA_VAL", "Valine", "g", 5, "none", "VAL", usda=[(1219, 1)]),
    N("AA_ALA", "Alanine", "g", 5, "none", "ALA", usda=[(1222, 1)]),
    N("AA_ARG", "Arginine", "g", 5, "none", "ARG", usda=[(1220, 1)]),
    N("AA_ASP", "Aspartic acid", "g", 5, "none", "ASP", usda=[(1223, 1)]),
    N("AA_CYS", "Cysteine", "g", 5, "none", "CYSTE", usda=[(1232, 1), (1216, 1)]),
    N("AA_GLU", "Glutamic acid", "g", 5, "none", "GLU", usda=[(1224, 1)]),
    N("AA_GLY", "Glycine", "g", 5, "none", "GLY", usda=[(1225, 1)]),
    N("AA_PRO", "Proline", "g", 5, "none", "PRO", usda=[(1226, 1)]),
    N("AA_SER", "Serine", "g", 5, "none", "SER", usda=[(1227, 1)]),
    N("AA_TYR", "Tyrosine", "g", 5, "none", "TYR", usda=[(1218, 1)]),
    # Tier 5: other compounds
    N("ALC", "Alcohol", "g", 5, "none", "ALC", usda=[(1018, 1)], estimate=True),
    N("CAFFN", "Caffeine", "mg", 5, "none", usda=[(1057, 1)]),
    N("THEBRN", "Theobromine", "mg", 5, "none", usda=[(1058, 1)]),
    N("STARCH", "Starch", "g", 5, "none", "STARCH", usda=[(1009, 1)]),
    N("GLUS", "Glucose", "g", 5, "none", "GLUS", usda=[(1011, 1)]),
    N("FRUS", "Fructose", "g", 5, "none", "FRUS", usda=[(1012, 1)]),
    N("GALS", "Galactose", "g", 5, "none", "GALS", usda=[(1075, 1)]),
    N("SUCS", "Sucrose", "g", 5, "none", "SUCS", usda=[(1010, 1)]),
    N("MALS", "Maltose", "g", 5, "none", "MALS", usda=[(1014, 1)]),
    N("LACS", "Lactose", "g", 5, "none", "LACS", usda=[(1013, 1)]),
    N("OLSAC", "Oligosaccharides (available)", "g", 5, "none", "OLSAC"),
    N("FIBSOL", "Fiber, water-soluble", "g", 5, "none", "FIBSOL", usda=[(1082, 1)]),
    N("FIBINS", "Fiber, water-insoluble", "g", 5, "none", "FIBINS", usda=[(1084, 1)]),
    N("FIBHMW", "Fiber, high molecular weight", "g", 5, "none", "FIBHMW", usda=[(2038, 1)]),
    N("FIBLMW", "Fiber, low molecular weight", "g", 5, "none", "FIBLMW", usda=[(2065, 1)]),
    N("POLYL", "Polyols (total)", "g", 5, "none", "POLYL"),
    N("SORTL", "Sorbitol", "g", 5, "none", "SORTL"),
    N("MANTL", "Mannitol", "g", 5, "none", "MANTL"),
    N("XYLTL", "Xylitol", "g", 5, "none", "XYLTL"),
    N("OA", "Organic acids (total)", "g", 5, "none", "OA"),
    N("CITAC", "Citric acid", "g", 5, "none", "CITAC", usda=[(1032, 0.001)]),
    N("MALAC", "Malic acid", "g", 5, "none", "MALAC", usda=[(1039, 0.001)]),
    N("LACAC", "Lactic acid", "g", 5, "none", "LACAC"),
    N("ACEAC", "Acetic acid", "g", 5, "none", "ACEAC"),
    N("TARAC", "Tartaric acid", "g", 5, "none", "TARAC"),
    N("CARTA", "Alpha-carotene", "µg", 5, "none", usda=[(1108, 1)]),
    N("CRYPXB", "Beta-cryptoxanthin", "µg", 5, "none", usda=[(1120, 1)]),
    N("LYCPN", "Lycopene", "µg", 5, "none", usda=[(1122, 1)]),
    N("LUTN_ZEA", "Lutein + zeaxanthin", "µg", 5, "none", usda=[(1123, 1)]),
    N("CAROTPAXB", "Carotenoids except beta-carotene", "µg", 5, "none", "CAROTPAXB"),
    N("TOCPHB", "Beta-tocopherol", "mg", 5, "none", "TOCPHB", usda=[(1125, 1)]),
    N("TOCPHG", "Gamma-tocopherol", "mg", 5, "none", "TOCPHG", usda=[(1126, 1)]),
    N("TOCPHD", "Delta-tocopherol", "mg", 5, "none", "TOCPHD", usda=[(1127, 1)]),
    N("TOCTRA", "Alpha-tocotrienol", "mg", 5, "none", "TOCTRA", usda=[(1128, 1)]),
    N("PHYSTR", "Phytosterols", "mg", 5, "none", usda=[(1283, 1)]),
    N("BETN", "Betaine", "mg", 5, "none", usda=[(1198, 1)]),
]

CODES = [n.code for n in CATALOG]
assert len(CODES) == len(set(CODES)), "duplicate nutrient code"
BY_CODE = {n.code: n for n in CATALOG}


def nutrient_id(code: str) -> int:
    """Stable integer id: position in the catalogue, starting at 1. New nutrients are appended."""
    return CODES.index(code) + 1
