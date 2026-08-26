# -*- coding: utf-8 -*-
"""반복 계측 — 단독 1회 성적 채택 금지(메모리 룰). 케이스별 N회 s/exec + 행수.

사용: python bench.py [N] [tag]
"""
import io
import json
import re
import statistics
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

N = int(sys.argv[1]) if len(sys.argv) > 1 else 3
TAG = sys.argv[2] if len(sys.argv) > 2 else "BASE"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
raw = cur.fetchone()[0].read()
jk = lambda k: (re.search(r'"%s":"([^"]*)"' % k, raw).group(1)
                if re.search(r'"%s":"([^"]*)"' % k, raw) else None)
P = {k: jk(k) for k in ["deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
                        "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId", "plantSiteId",
                        "bizType", "owner", "bucket", "userDeptId", "groupId", "cellYn",
                        "userId", "mnuId"]}

# 케이스 = 실측으로 데이터 존재 확인된 조합 (probe_cases.py 결과)
CASES = [
    ("C1 div40 CURRENT", "40", "CURRENT"),
    ("C2 div81 CURRENT", "81", "CURRENT"),
    ("C3 div82 CURRENT", "82", "CURRENT"),
    ("C4 div40 CUR+SP_W", "40", "CURRENT,SP_W_20260817_V001"),
    ("C5 div40 SP_W only", "40", "SP_W_20260817_V001"),
    ("C6 div81 CUR+SP_W", "81", "CURRENT,SP_W_20260817_V001"),
]

res = {}
for label, div, ver in CASES:
    ts, rows = [], None
    for i in range(N):
        o = [con.cursor() for _ in range(3)]
        t0 = time.time()
        cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", [
            div, P["deptId"] or "ALL", P["endCustomer"], P["scmSiteId"], P["projectCode"] or "",
            P["itemId"] or "", P["itemType"], P["fromYyyymmdd"], "20260817", P["toYyyymmdd"],
            P["sesUserId"], P["plantSiteId"], P["bizType"], P["owner"] or "", "N", P["cellYn"],
            ver, P["bucket"] or "MONTHLY", P["userDeptId"] or "", P["groupId"] or "",
            P["userId"], P["mnuId"]] + o)
        ts.append(time.time() - t0)
        rows = [len(c.fetchall()) if c.description else None for c in o]
    res[label] = {"times": [round(x, 2) for x in ts], "min": round(min(ts), 2),
                  "med": round(statistics.median(ts), 2), "rows": rows}
    print(f"[{TAG}] {label:22s} min {min(ts):6.2f}s  med {statistics.median(ts):6.2f}s  "
          f"{[round(x,2) for x in ts]}  rows={rows}")
open(f"bench_{TAG}.json", "w", encoding="utf-8").write(json.dumps(res, ensure_ascii=False, indent=1))
con.close()
