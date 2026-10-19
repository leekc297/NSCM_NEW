# -*- coding: utf-8 -*-
"""METAL_KEY_VALUE 룩업 vs 템플릿 Key 값 대조 (읽기 전용)"""
import re
import pathlib
import sys

import openpyxl

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

print("== SCM_ADM_LOOKUP_MASTER_DETAIL / METAL_KEY_VALUE ==")
cur.execute("""SELECT SEGMENT1 DIV, SEGMENT2 KEYNM, COUNT(*) CNT
                 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE='METAL_KEY_VALUE' AND VALID_YN='Y'
                GROUP BY SEGMENT1, SEGMENT2 ORDER BY 1,2""")
for r in cur:
    print("   DIV={:4s} KEY={:10s} {:3d}건".format(str(r[0]), str(r[1]), r[2]))

print("\n== DIV 81 · KEY 'Ni' 유효 CODE 목록 ==")
cur.execute("""SELECT SEGMENT3, SEGMENT4, SEGMENT5, ATTRIBUTE1
                 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE='METAL_KEY_VALUE' AND VALID_YN='Y'
                  AND SEGMENT1='81' AND SEGMENT2='Ni' ORDER BY SEGMENT3""")
ni81 = cur.fetchall()
for r in ni81:
    print("   CODE={!r:24s} SEG4={!r:20s} SEG5={!r:16s} ATTR1={!r}".format(*[str(x) for x in r]))
print("   → 총 {}건".format(len(ni81)))

print("\n== DIV 40 · KEY 'Ni' 유효 CODE (비교용) ==")
cur.execute("""SELECT SEGMENT3, SEGMENT4 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE='METAL_KEY_VALUE' AND VALID_YN='Y'
                  AND SEGMENT1='40' AND SEGMENT2='Ni' ORDER BY SEGMENT3""")
for r in cur.fetchall()[:12]:
    print("   CODE={!r:24s} SEG4={!r}".format(str(r[0]), str(r[1])))

print("\n== 템플릿 파일의 Key_Ni 실값 ==")
for f, kcol in (("DMF0074_Template_20260915_111214.xlsx", 14),
                ("DMF0074_40_Upload_Sample10_20260915.xlsx", 12)):
    ws = openpyxl.load_workbook(pathlib.Path(r"C:\TRANFILE\RECEIVE") / f,
                                data_only=True).worksheets[0]
    vals = []
    for r in ws.iter_rows(min_row=3, values_only=True):
        if r[0] is None:
            continue
        vals.append((r[0], r[1], r[7] if "Template" in f else r[5], r[kcol - 1]))
    print("  {}".format(f))
    print("    (Div, PlanDate, MetalLink, Key_Ni)")
    for v in vals[:8]:
        print("     ", v)
