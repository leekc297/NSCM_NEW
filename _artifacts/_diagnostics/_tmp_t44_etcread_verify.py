#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ETCREAD 배포 후 검증 — 저장값이 ETC 조회에 나오는가 + 표시 컬럼이 비지 않았는가 (조회 전용)
   사용자가 저장한 값: 202603=1, 202604=2, 202605=3, 202606=4 (SalesAmt_KRW, ITEM_ID=ETC, CUST=IM)
"""
import sys, pathlib
from collections import Counter
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV, VER = '40', 'R_S_20260810_V010_C'
u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[0] 라이브 마커 확인")
cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'ETCREAD 2026\\-08\\-11')),0) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""")
print(f"  ETCREAD 마커 = {cur.fetchone()[0]}")

for dt, nm in (('2', 'ETC'), ('1', 'Cutoff'), ('ALL', 'ALL')):
    sec(f"[{nm}] DATA_TYPE={dt} 조회")
    try:
        c1 = con.cursor(); c2 = con.cursor()
        cur.callproc("PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA",
                     [DIV, 'REPORT_SP_W', '2026', VER, dt,
                      'minyonglee1', 'minyonglee1', 'minyonglee1', 'DMF0044', c1, c2])
        cols = [x[0] for x in c1.description]
        rows = c1.fetchall()
        idx = {c: i for i, c in enumerate(cols)}
        ef = Counter(r[idx['EDIT_FLAG']] for r in rows) if 'EDIT_FLAG' in idx else {}
        print(f"  행 {len(rows):,} / EDIT_FLAG {dict(ef)}")

        hit = [r for r in rows
               if str(r[idx.get('ITEM_ID', 0)]) == 'ETC'
               and str(r[idx.get('CUST_REPORT', 0)]) == 'IM'
               and str(r[idx.get('MEASURE', 0)]) == 'SalesAmt_KRW']
        print(f"  저장 대상행 매칭 {len(hit)}건  (기대: 저장값 202603=1 · 202604=2 · 202605=3 · 202606=4)")
        for r in hit[:4]:
            v = {k: r[idx[k]] for k in ('M_202603', 'M_202604', 'M_202605', 'M_202606') if k in idx}
            print(f"     → {v}")

        if dt == '2' and rows:
            sec2 = "  [표시 컬럼 공백 점검] 재매핑한 컬럼이 전부 NULL 이 되지 않았는가"
            print(sec2)
            for c in ('END_CUSTOMER', 'CELL_MODEL_INFO', 'CELL_MODEL', 'BIZ_TYPE_NAME40',
                      'COUNTRY_CODE', 'SOLDTO_CODE', 'SOLDTO_COUNTRY', 'SHIPTO_COUNTRY',
                      'ITEM_USE', 'PROJECT_NAME', 'CELL_PROD_SITE', 'PRODUCT_DETAILS'):
                if c not in idx:
                    print(f"     {c:<18} (커서에 없음)")
                    continue
                nn = sum(1 for r in rows if r[idx[c]] not in (None, ''))
                print(f"     {c:<18} 비어있지 않은 행 {nn:>5} / {len(rows):>5}")
    except Exception as e:
        print(f"  ⛔ {str(e)[:220]}")

sec("[비교] 원장 실제값 (기준)")
show(*fetch(cur, """
SELECT DATA_TYPE, MEASURE, YYYYMMDD, QTY
  FROM DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID=:d AND VERSION_NO=:v AND ITEM_ID='ETC' AND CUST_REPORT='IM'
   AND MEASURE='SalesAmt_KRW' AND SUBSTR(YYYYMMDD,1,6) IN ('202603','202604','202605','202606')
 ORDER BY YYYYMMDD""", {"d": DIV, "v": VER}))

con.close()
