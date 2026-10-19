# -*- coding: utf-8 -*-
"""조인키 컬럼의 NULL/센티널 실태 — MERGE ON 은 NULL 이면 어떤 값과도 매칭되지 않는다"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

COLS = ["PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID",
        "INCOTERMS", "DOM_EXP", "FCST_TYPE", "CELL_PROD_SITE_ID"]
T = [("DM_PLN_CFM_MKT_DEMAND_PLAN", "40", "계획 수요(40)"),
     ("DM_PLN_SALES_PLAN_RESULT",   "40", "실적"),
     ("DM_PLN_CFM_SELLING_PRICE",   "40", "단가(40)"),
     ("DM_PLN_MKT_FCST",            "81", "계획 수요(81)"),
     ("SCM_MST_FUTURE_PRICE",       "81", "단가(81)")]

for tbl, div, note in T:
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t""", t=tbl)
    have = {r[0] for r in cur}
    sel, names = [], []
    for c in COLS:
        if c not in have:
            continue
        names.append(c)
        sel.append("SUM(CASE WHEN {0} IS NULL THEN 1 ELSE 0 END)".format(c))
        sel.append("SUM(CASE WHEN {0} = '-' THEN 1 ELSE 0 END)".format(c))
    cur.execute("SELECT COUNT(*), {} FROM SCM_MGR.{} WHERE DIVISION_ID=:d AND YYYYMMDD>='20260101'".format(
        ", ".join(sel), tbl), d=div)
    r = cur.fetchone()
    print("\n{}  [{}]  DIV {}  총 {:,}행".format(tbl, note, div, r[0]))
    for i, c in enumerate(names):
        nul, dash = r[1 + i * 2], r[2 + i * 2]
        mark = "   <== NULL 존재 (MERGE ON 매칭 불가)" if nul else ""
        print("   {:20s} NULL {:>10,d}   '-' {:>10,d}{}".format(c, nul, dash, mark))
    missing = [c for c in COLS if c not in have]
    if missing:
        print("   (컬럼 없음: {})".format(", ".join(missing)))
