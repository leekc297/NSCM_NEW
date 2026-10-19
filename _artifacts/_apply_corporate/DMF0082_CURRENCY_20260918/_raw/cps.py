# -*- coding: utf-8 -*-
"""arm 별 CELL_PROD_SITE_ID / PLANT_SITE_ID / CURRENCY 표현식 + 원천 테이블"""
import re, pathlib
src = pathlib.Path("PKG_DMF0082_BODY.sql").read_text(encoding="utf-8").split("\n")
start = 7
end = next(i for i, l in enumerate(src[8:], 8) if re.match(r"\s*PROCEDURE P_DMF0082", l))
ins = [i for i in range(start, end)
       if "INSERT INTO" in src[i] and "GT_DMF0082_TEMP_FCST_N_PRICE" in src[i]]

def pick(body, col):
    m = re.findall(r"(?:^|\n)\s*,?\s*([^\n,]{1,60}?)\s+AS\s+" + col + r"\b", body, re.I)
    if m:
        return m[0].strip()
    m = re.findall(r"(?:^|\n)\s*,\s*((?:A|B|C|D|E|F)\." + col + r")\s*(?:,|$)", body)
    return m[0].strip() if m else "?"

print("{:>6s} {:34s} {:26s} {:20s} {:16s}".format("L", "FROM(원천)", "CELL_PROD_SITE_ID", "PLANT_SITE_ID", "CURRENCY"))
print("-" * 112)
for k, i in enumerate(ins):
    j = ins[k + 1] if k + 1 < len(ins) else end
    body = "\n".join(src[i:j])
    frm = re.findall(r"FROM\s+SCM_MGR\.([A-Z0-9_]+)", body)
    print("{:>6d} {:34s} {:26s} {:20s} {:16s}".format(
        i + 1, (frm[0] if frm else "?")[:34],
        pick(body, "CELL_PROD_SITE_ID")[:26],
        pick(body, "PLANT_SITE_ID")[:20],
        pick(body, "CURRENCY")[:16]))
