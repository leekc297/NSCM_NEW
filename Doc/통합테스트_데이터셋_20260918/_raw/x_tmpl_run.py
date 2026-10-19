# -*- coding: utf-8 -*-
"""템플릿 SP 실제 산출 확인 (읽기 전용) — 사내 ZIOUI1"""
import re
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
db = oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))
cur = db.cursor()

for div in ("81", "40"):
    rc1 = cur.var(oracledb.CURSOR)
    rr = cur.var(oracledb.CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE",
                 [div, "minyonglee1", "DMF0074", rc1, rr])
    c = rc1.getvalue()
    cols = [d[0] for d in c.description]
    rows = c.fetchmany(4)
    print("=" * 76)
    print("DIV {} — 템플릿 SP o_rc1  {}컬럼".format(div, len(cols)))
    want = [x for x in ("PLAN_YYYYMM", "METAL_LINK_YN", "METAL_EXCEPTION_YN",
                        "APPLY_PRICE_TYPE_CODE1", "APPLY_PRICE_TYPE_CODE2",
                        "FROM_PERIOD1", "ITEM_ID", "SCM_SITE_ID", "PROJECT_CODE")
            if x in cols]
    print("  ", want)
    for r in rows:
        d = dict(zip(cols, r))
        print("   ", [(k, d.get(k)) for k in want])
    print("   총 {}행(앞 4행만 표시)".format(len(rows)))
