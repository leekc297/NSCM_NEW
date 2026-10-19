# -*- coding: utf-8 -*-
"""GT_DMF0082_TEMP_FCST_N_PRICE 로 들어가는 INSERT 블록 전수 — MEASURE / CURRENCY 표현식 매핑"""
import re, pathlib
src = pathlib.Path("PKG_DMF0082_BODY.sql").read_text(encoding="utf-8").split("\n")

# GET_MAIN_DATA 본문 범위 (다음 PROCEDURE 전까지)
start = next(i for i, l in enumerate(src) if l.strip().startswith("PROCEDURE P_DMF0082_GET_MAIN_DATA") and "CURRENT" not in l)
end = next(i for i, l in enumerate(src[start + 1:], start + 1)
           if re.match(r"\s*PROCEDURE P_DMF0082", l))
print("GET_MAIN_DATA 본문 L{}~L{}".format(start + 1, end))

ins = [i for i in range(start, end)
       if "INSERT INTO" in src[i] and "GT_DMF0082_TEMP_FCST_N_PRICE" in src[i]]
print("GTT INSERT 블록 {}개\n".format(len(ins)))

print("{:>7s} {:>7s}  {:28s} {:34s} {:30s}".format("L", "끝", "MEASURE", "CURRENCY 표현식", "기간조건"))
print("-" * 118)
for k, i in enumerate(ins):
    j = ins[k + 1] if k + 1 < len(ins) else end
    body = "\n".join(src[i:j])
    # MEASURE 리터럴 (SELECT 절의 'XXX' AS MEASURE 또는 , 'XXX' 형태)
    meas = re.findall(r"'([A-Za-z_][A-Za-z0-9_]*)'\s+AS\s+MEASURE", body, re.I)
    meas += re.findall(r"D\.MEASURE|A\.MEASURE|B\.MEASURE", body)
    meas = sorted(set(meas))
    curx = re.findall(r"(?:^|\n)\s*,?\s*([^\n,]{0,40}?)\s+AS\s+CURRENCY", body, re.I)
    curx += re.findall(r"(?:^|\n)\s*,\s*(A\.CURRENCY|B\.CURRENCY|MAX\(A\.CURRENCY\))\s*,", body)
    curx = sorted(set(x.strip() for x in curx))
    per = "계획(V_TO_RESULT~V_TO)" if "BETWEEN V_TO_RESULT" in body else (
          "실적(from~<V_TO_RESULT)" if "< V_TO_RESULT" in body else "")
    print("{:>7d} {:>7d}  {:28s} {:34s} {:30s}".format(
        i + 1, j, ",".join(meas)[:28] or "(동적)", ",".join(curx)[:34] or "(미지정)", per))
