# -*- coding: utf-8 -*-
"""MKT GET rc1 전행 캡처 (값 동등성 대조용 — 읽기 전용). 사용: capture_mkt.py <out.json>"""
import io
import json
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

ARGS = ["40", "ALL", "ALL", "ALL", "", "", "ALL", "20260801", "20270228", "minyonglee1",
        "ALL", "ALL", "", "CURRENT", "MONTHLY", "", "", "N", "ALL", "minyonglee1", "DMF0035"]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
o = [con.cursor() for _ in range(4)]
t0 = time.time()
cur.callproc("SCM_MGR.PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL", ARGS + o)
el = time.time() - t0
cols = [c[0] for c in o[0].description]
rows = [dict(zip(cols, [str(v) for v in r])) for r in o[0].fetchall()]
rows.sort(key=lambda r: json.dumps(r, sort_keys=True, ensure_ascii=False))
out = sys.argv[1]
json.dump({"elapsed_s": round(el, 1), "rows": rows}, open(out, "w", encoding="utf-8"),
          ensure_ascii=False, sort_keys=True)
print(f"[capture] {el:.1f}s — {len(rows)}행 → {out}")
con.close()
