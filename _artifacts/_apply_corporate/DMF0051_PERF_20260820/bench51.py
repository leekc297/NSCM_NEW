# -*- coding: utf-8 -*-
"""성적 전용 벤치 (GTT 덤프 없음 — 순수 SP 왕복 시간 + 문장별 BUFFER_GETS).

사용: python bench51.py <label> [반복횟수]
before/after 를 같은 조건·같은 시간대에 재고 싶을 때 사용 (동시 부하 오염 회피).
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

LABEL = sys.argv[1]
REP = int(sys.argv[2]) if len(sys.argv) > 2 else 3
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=227122")
raw = cur.fetchone()[0].read()
J = lambda k: (re.search(r'"%s":"([^"]*)"' % k, raw) or [None, None])[1]
B = {k: J(k) for k in ["divisionId", "deptId", "endCustomer", "scmSiteId", "projectCode", "itemId",
                       "itemType", "fromYyyymmdd", "toYyyymmdd", "sesUserId", "plantSiteId", "bizType",
                       "owner", "cellYn", "userId", "mnuId"]}


def args(**ov):
    a = dict(div=B["divisionId"], dept=B["deptId"] or "ALL", endc=B["endCustomer"], site=B["scmSiteId"],
             proj=B["projectCode"] or "", item=B["itemId"] or "", itype=B["itemType"],
             frm=B["fromYyyymmdd"], now="20260817", to=B["toYyyymmdd"], user=B["sesUserId"],
             plant=B["plantSiteId"], biz=B["bizType"], owner=B["owner"] or "", ver="CURRENT",
             cell=B["cellYn"], qty="N", uid=B["userId"], mnu=B["mnuId"])
    a.update(ov)
    return [a["div"], a["dept"], a["endc"], a["site"], a["proj"], a["item"], a["itype"], a["frm"],
            a["now"], a["to"], a["user"], a["plant"], a["biz"], a["owner"], a["ver"], a["cell"],
            a["qty"], a["uid"], a["mnu"]]


CASES = {
    "C1_div40_CURRENT": args(),
    "C2_div40_BP20260810": args(ver="BP_M_20260810_V001"),
    "C4_div40_CURRENT+BP2": args(ver="CURRENT^BP_M_20260810_V001^BP_M_20260223_V001"),
    "C5_div40_CURRENT_cellY": args(cell="Y"),
    "C10_div40_CURRENT_narrow": args(frm="20260901", to="20261130"),
}

SNAP = """SELECT SQL_ID, SUM(EXECUTIONS), SUM(BUFFER_GETS), SUM(DISK_READS) FROM V$SQL
WHERE PARSING_SCHEMA_NAME='SCM_MGR'
  AND (PROGRAM_ID=(SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0051' AND OBJECT_TYPE='PACKAGE BODY')
       OR SQL_TEXT LIKE '%T_DM51_WF%')
GROUP BY SQL_ID"""


def snap():
    cur.execute(SNAP)
    return {r[0]: r[1:] for r in cur.fetchall()}


res = {}
for name, a in CASES.items():
    ts, bgs = [], []
    for i in range(REP):
        b0 = snap()
        out = [con.cursor() for _ in range(3)]
        t0 = time.time()
        cur.callproc("SCM_MGR.PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL", a + out)
        n = len(out[0].fetchall()) if out[0].description else 0
        ts.append(time.time() - t0)
        b1 = snap()
        tot = sum(v[1] - b0.get(k, (0, 0, 0))[1] for k, v in b1.items() if v[0] - b0.get(k, (0, 0, 0))[0] > 0)
        bgs.append(tot)
    res[name] = {"rows": n, "t_min": round(min(ts), 2), "t_med": round(statistics.median(ts), 2),
                 "bg_min": min(bgs), "bg_med": int(statistics.median(bgs))}
    print(f"  {name:26} rows={n:6d}  t_min={min(ts):6.2f}s t_med={statistics.median(ts):6.2f}s  "
          f"BG_min={min(bgs):9d} BG_med={int(statistics.median(bgs)):9d}")

open(f"bench_{LABEL}.json", "w", encoding="utf-8").write(json.dumps(res, ensure_ascii=False, indent=1))
print(f"[saved] bench_{LABEL}.json")
con.close()
