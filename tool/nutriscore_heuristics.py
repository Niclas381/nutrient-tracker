"""Nutri-Score input heuristics from the food group.

Returns (category, fvl_percent, is_liquid):
  category     'general' | 'beverage' | 'water' | 'fat_oil_nuts_seeds' | 'cheese' | 'red_meat'
               | 'not_applicable' (alcoholic drinks) | None (ambiguous -> Claude decides in enrich_food)
  fvl_percent  % fruit, vegetables, legumes; None when ambiguous (-> Claude)
  is_liquid    amounts are in ml

Only unambiguous groups get a value; everything else is left to the Claude fallback.
"""

import re

BEVERAGE_WORDS = re.compile(r"\b(juice|nectar|drink|beverage|spritzer|lemonade|soft drink|cola|smoothie|"
                            r"infusion|tea|coffee|espresso|cappuccino|water|milk shake|iced tea)\b", re.I)
ALCOHOL_FREE = re.compile(r"alcohol-free|0\.0 ?%|non-?alcoholic", re.I)
PROCESSED_FRUIT_VEG = re.compile(r"sugared|sweetened|candied|syrup|pie filling|chips|crisps|with |sauce|"
                                 r"pickled|in brine|soup|instant|puree|jam|jelly|compote", re.I)
POULTRY = re.compile(r"chicken|turkey|poultry|duck|goose|guineafowl|quail|pheasant|ostrich", re.I)
RED_SPECIES = re.compile(r"\b(beef|pork|veal|lamb|mutton|sheep|goat|horse|venison|deer|boar|bison|elk|game)\b", re.I)


def classify(food: dict):
    name = food["name"] or ""
    if food["source"] == "bls":
        return _bls(food["group"], name)
    return _usda(food["group"], name)


def _milk_like_beverage(name):
    return bool(re.match(r"^(milk|buttermilk|kefir)\b", name, re.I)) and not re.search(
        r"powder|condensed|evaporated|dried|dry\b|chocolate bar", name, re.I)


def _bls(group: str, name: str):
    letter, digit = group[0], group[1]
    if letter == "N":
        if digit == "1":
            return "water", 0.0, True
        return "beverage", None, True
    if letter == "P":
        if ALCOHOL_FREE.search(name):
            return "beverage", None, True
        return "not_applicable", None, True
    if letter == "F":
        if BEVERAGE_WORDS.search(name):
            return "beverage", None, True
        if digit == "9" or PROCESSED_FRUIT_VEG.search(name):
            return None, None, False
        return "general", 100.0, False
    if letter == "G":
        if digit == "8" or PROCESSED_FRUIT_VEG.search(name) or BEVERAGE_WORDS.search(name):
            return None, None, False
        return "general", 100.0, False
    if letter == "H":
        if digit in "1234":
            return "fat_oil_nuts_seeds", 0.0, False
        if digit == "7" and not PROCESSED_FRUIT_VEG.search(name):
            return "general", 100.0, False
        if digit == "8" and re.search(r"\bdrink\b", name, re.I):
            return "beverage", None, True
        return None, None, False
    if letter == "K":
        if digit == "1" and not PROCESSED_FRUIT_VEG.search(name):
            return "general", 0.0, False  # potatoes do not count as vegetables in Nutri-Score
        return None, None, False
    if letter == "M":
        if "cheese" in name.lower() or digit in "03456":
            return "cheese", 0.0, False
        if _milk_like_beverage(name) or re.search(r"\bdrink\b", name, re.I):
            return "beverage", 0.0, True
        if digit in "12":
            return "general", 0.0, False
        return None, None, False
    if letter == "Q":
        if digit in "12345678":
            return "fat_oil_nuts_seeds", 0.0, False
        if re.search(r"tahini|oil|fat\b", name, re.I):
            return "fat_oil_nuts_seeds", 0.0, False
        return None, None, False
    if letter == "U":
        return "red_meat", 0.0, False
    if letter == "W":
        if POULTRY.search(name) or digit == "9":
            return None, None, False
        return "red_meat", 0.0, False
    if letter == "V":
        if digit in "346":
            return "general", 0.0, False
        if digit in "12":
            return ("general", 0.0, False) if re.search(r"rabbit|hare", name, re.I) else ("red_meat", 0.0, False)
        if digit == "5":
            return ("red_meat", 0.0, False) if RED_SPECIES.search(name) else ("general", 0.0, False)
        if digit == "0":
            return "general", 0.0, False
        return None, None, False
    if letter == "T":
        return "general", 0.0, False
    if letter == "E":
        if digit == "9" or re.search(r"sauce|filling", name, re.I):
            return None, None, False
        return "general", 0.0, False
    if letter == "B" or (letter == "C" and digit in "1234"):
        return "general", 0.0, False
    if letter == "C" and digit == "6":
        return "beverage", 0.0, True
    return None, None, False  # pastries, sweets, dishes, spices, … -> Claude


USDA_GROUPS = {
    "1": "dairy_egg", "2": "spices", "3": "baby", "4": "fats", "5": "poultry", "6": "soups", "7": "sausages",
    "8": "cereals", "9": "fruits", "10": "pork", "11": "vegetables", "12": "nuts", "13": "beef",
    "14": "beverages", "15": "fish", "16": "legumes", "17": "lamb_veal_game", "18": "baked", "19": "sweets",
    "20": "grains", "21": "fast_food", "22": "meals", "23": "snacks", "24": "native", "25": "restaurant",
    "28": "alcoholic",
}


def _usda(group: str, name: str):
    g = USDA_GROUPS.get(group)
    low = name.lower()
    if g == "alcoholic" or (g == "beverages" and re.search(r"alcoholic|beer|wine|liqueur|whiskey|vodka|rum\b|gin\b|"
                                                           r"distilled", low) and not ALCOHOL_FREE.search(name)):
        return "not_applicable", None, True
    if g == "beverages":
        if re.match(r"^(beverages, )?water\b", low) and "flavored" not in low:
            return "water", 0.0, True
        if re.search(r"powder|dry|mix\b", low):
            return None, None, False
        return "beverage", None, True
    if g == "fruits":
        if re.search(r"juice|nectar|drink", low):
            return "beverage", None, True
        if PROCESSED_FRUIT_VEG.search(name):
            return None, None, False
        return "general", 100.0, False
    if g == "vegetables":
        if PROCESSED_FRUIT_VEG.search(name) or re.search(r"juice", low):
            return None, None, False
        if low.startswith("potato"):
            return "general", 0.0, False
        return "general", 100.0, False
    if g == "legumes":
        if re.match(r"^(beans|lentils|chickpeas|peas|cowpeas|lima beans|mung beans|broadbeans|pigeon peas)\b", low) \
                and not PROCESSED_FRUIT_VEG.search(name):
            return "general", 100.0, False
        if re.search(r"\bsoymilk|soy milk\b", low):
            return "beverage", None, True
        return None, None, False
    if g in ("fats",):
        if re.search(r"dressing|mayonnaise|sauce|spread\b", low):
            return None, None, False
        return "fat_oil_nuts_seeds", 0.0, False
    if g == "nuts":
        return "fat_oil_nuts_seeds", 0.0, False
    if g == "dairy_egg":
        if low.startswith("butter"):
            return "fat_oil_nuts_seeds", 0.0, False
        if "cheese" in low:
            return "cheese", 0.0, False
        if _milk_like_beverage(name):
            return "beverage", 0.0, True
        if re.search(r"fruit|flavor|chocolate|pudding|dessert|ice cream", low):
            return None, None, False
        return "general", 0.0, False
    if g in ("beef", "pork", "lamb_veal_game"):
        return "red_meat", 0.0, False
    if g == "sausages":
        if RED_SPECIES.search(name) and not POULTRY.search(name):
            return "red_meat", 0.0, False
        return None, None, False
    if g in ("poultry", "fish"):
        return "general", 0.0, False
    if g == "grains":
        return "general", 0.0, False
    return None, None, False
