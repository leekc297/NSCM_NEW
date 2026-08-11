#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ETC 저장 실반영 검증 — payload 전문 확보 + 저장 시각에 실제로 바뀐 원장 행 확인 (조회 전용)"""
import sys, pathlib, json, re
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] 최근 SAVE payload 전문 → 저장 키 분해")
cur.execute("""
SELECT TO_CHAR(LOG_ST_DTM,'HH24:MI:SS'), SYS_LOG_MSG_CTN
  FROM SCM_MGR.SCM_COM_SYS_LOG
 WHERE MNU_ID='DMF0044' AND MNU_BTN_CD='SAVE' AND SHT_NM='MDF Reports'
 ORDER BY LOG_ST_DTM DESC FETCH FIRST 1 ROWS ONLY""")
t, payload = cur.fetchone()
pl = payload.read() if hasattr(payload, 'read') else payload
try:
    arr = json.loads(pl)
    obj = arr[1] if isinstance(arr, list) and len(arr) > 1 else {}
except Exception:
    obj = {}
    for k in ('versionNo', 'measure', 'yyyymmdd', 'qty', 'itemId', 'custReport',
              'productGroup', 'currency', 'companyId', 'activeFlag', 'endCustReport',
              'cellModelInfo', 'cellModel', 'departmentId', 'deptId'):
        m = re.search(r'"%s"\s*:\s*"([^"]*)"' % k, pl)
        if m:
            obj[k] = m.group(1)
print(f"  저장 시각 {t}")
KEYS = ('versionNo', 'divisionId', 'activeFlag', 'measure', 'yyyymmdd', 'qty', 'itemId',
        'custReport', 'endCustReport', 'productGroup', 'currency', 'companyId',
        'departmentId', 'deptId', 'cellModelInfo', 'cellModel', 'cutoffType')
split = {k: str(obj.get(k, '')).split('^') for k in KEYS if k in obj}
n = max((len(v) for v in split.values()), default=0)
print(f"  전달 엔트리 수 = {n}")
for i in range(min(n, 8)):
    row = {k: (v[i] if i < len(v) else '') for k, v in split.items()}
    print(f"    [{i}] measure={row.get('measure','')!r} yyyymmdd={row.get('yyyymmdd','')!r} "
          f"qty={row.get('qty','')!r} item={row.get('itemId','')!r} "
          f"cust={row.get('custReport','')!r} flag={row.get('activeFlag','')!r}")

VER = split.get('versionNo', [''])[0]

sec(f"[2] 저장 대상표 DM_PLN_SALES_PLAN_REPORT_C — {VER} 에서 방금 바뀐 행")
show(*fetch(cur, """
SELECT DATA_TYPE, MEASURE, YYYYMMDD, QTY, ITEM_ID, CUST_REPORT, CURRENCY,
       TO_CHAR(LAST_UPDATE_DATE,'HH24:MI:SS') upd, LAST_UPDATED_BY
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID='40' AND VERSION_NO=:v AND LAST_UPDATE_DATE > SYSDATE - 20/1440
 ORDER BY LAST_UPDATE_DATE DESC FETCH FIRST 15 ROWS ONLY""", {"v": VER}))

sec(f"[3] 조회 원천표 DM_PLN_SALES_ETC_REPORT_C — 같은 시각에 바뀐 행이 있는가")
show(*fetch(cur, """
SELECT MEASURE, YYYYMMDD, QTY, ITEM_ID, CUST_REPORT,
       TO_CHAR(LAST_UPDATE_DATE,'HH24:MI:SS') upd, LAST_UPDATED_BY
  FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DIVISION_ID='40' AND VERSION_NO=:v AND LAST_UPDATE_DATE > SYSDATE - 20/1440
 ORDER BY LAST_UPDATE_DATE DESC FETCH FIRST 15 ROWS ONLY""", {"v": VER}))

sec("[4] MAIN GRID 조회 SP 가 DATA_TYPE 별로 읽는 표 (라이브 원문에서 확인)")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 1230 AND 1560
                  AND (UPPER(TEXT) LIKE '%FROM DM_PLN_SALES%' OR UPPER(TEXT) LIKE '%P_DATA_TYPE%')
                ORDER BY LINE""")
for ln, tx in cur.fetchall():
    print(f"    L{ln:5d} | {tx.rstrip()[:150]}")

con.close()
