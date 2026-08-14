#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form 0건 진단 — division 축 대조.
   같은 filters 로 ①메인 SEARCH ②FORM_DATA 를 나란히 호출해 **어느 쪽이 0인지** 가른다.
   0행이면 ①경로부재 ②데이터부재 ③조건밖 3분 (feedback_literal_occurrence_is_not_structure_evidence)
"""
import io, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import requests
from ora import conn_info
import oracledb

BASE = "http://localhost:8080"
USER = "minyonglee1"
MENU, SHEET = "DMF0014", "FCST Upload"

# ── 원장 실측: division × bucket 별 CUST_FCST 데이터 분포 ─────────────────
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
print("## 원장 분포 — DM_PLN_CUSTOMER_PSI (MEASURE_GROUP='CUST_FCST')")
cur.execute("""SELECT DIVISION_ID, COUNT(*) CNT, MIN(YYYYMMDD) MN, MAX(YYYYMMDD) MX
               FROM SCM_MGR.DM_PLN_CUSTOMER_PSI WHERE MEASURE_GROUP='CUST_FCST'
               GROUP BY DIVISION_ID ORDER BY 1""")
for r in cur.fetchall():
    print(f"   div={r[0]:<8} {r[1]:>9}행  {r[2]} ~ {r[3]}")

print("\n## measure 마스터 — DM_MST_CUSTOMER_FCST (UPLOAD_BUCKET_TYPE 별)")
cur.execute("""SELECT DIVISION_ID, UPLOAD_BUCKET_TYPE, COUNT(*) CNT
               FROM SCM_MGR.DM_MST_CUSTOMER_FCST WHERE VALID_YN='Y'
               GROUP BY DIVISION_ID, UPLOAD_BUCKET_TYPE ORDER BY 1,2""")
for r in cur.fetchall():
    print(f"   div={r[0]:<8} bucket={str(r[1]):<10} {r[2]:>5}종")
con.close()

# ── HTTP 대조 ────────────────────────────────────────────────────────────
sess = requests.Session()
sess.post(f"{BASE}/user/login", json={"userId": USER}, timeout=30)


def probe(div, bucket, fr, to):
    f = {"divisionId": div, "deptId": "ALL", "endCustomer": "ALL", "scmSiteId": "ALL",
         "plantSiteId": "ALL", "projectCode": "", "itemId": "",
         "startYyyymmdd": fr, "endYyyymmdd": to, "bucketType": bucket, "domExp": "ALL",
         "createdBy": USER, "userinfo": "ADMIN", "sesUserId": USER, "mnuId": MENU}
    out = []
    for btn in ("SEARCH", "FORM_DATA"):
        r = sess.post(f"{BASE}/{MENU}/{SHEET}/{btn}/call-proc", json=f, timeout=300)
        try:
            res = (r.json() or {}).get("result") or {}
            n = len(res.get("o_rc1") or [])
        except Exception:
            n = -1
        out.append(n)
    mark = "" if out[0] == 0 or out[1] > 0 else "   ⛔ SEARCH 는 나오는데 FORM 은 0 = SP 결함"
    print(f"   div={div:<6} bucket={bucket:<8} {fr}~{to}  SEARCH={out[0]:>4} / FORM_DATA={out[1]:>4}{mark}")


print("\n## HTTP 대조 (동일 filters — SEARCH vs FORM_DATA)")
for div in ("40", "81", "82"):
    for bucket in ("WEEKLY", "MONTHLY", "DAILY"):
        probe(div, bucket, "20260601", "20261231")
