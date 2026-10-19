# -*- coding: utf-8 -*-
"""보완안 안전성 — 8키(CELL_PROD 제외) 단위로 LOC 통화가 2종 이상인 키가 있는가"""
import re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)); cur = db.cursor()

for tbl, div in (("DM_PLN_CFM_SELLING_PRICE", "40"),
                 ("SCM_MST_FUTURE_PRICE", "81"),
                 ("SCM_MST_FUTURE_PRICE", "82")):
    cur.execute("""
      SELECT COUNT(*) KEYS8, SUM(CASE WHEN CUR_KINDS > 1 THEN 1 ELSE 0 END) MULTI_CUR
        FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                      INCOTERMS, DOM_EXP, FCST_TYPE, COUNT(DISTINCT CURRENCY) CUR_KINDS
                 FROM SCM_MGR.{}
                WHERE DIVISION_ID = :d AND MEASURE = 'LOC' AND YYYYMMDD >= '20260101'
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
                         INCOTERMS, DOM_EXP, FCST_TYPE )""".format(tbl), d=div)
    k, mc = cur.fetchone()
    print("{:28s} DIV {:3s}  8키 {:>8,d} 개  통화 2종이상 {:>6,d} 개  {}".format(
        tbl, div, k or 0, mc or 0, "OK(안전)" if not mc else "⚠ 확인필요"))
