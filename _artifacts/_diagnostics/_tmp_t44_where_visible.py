#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""저장된 DATA_TYPE='2' 행이 어느 조회 분기에서 보이는가 — WHERE 절 실측 + 실호출 대조"""
import sys, pathlib
from collections import Counter
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 600000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] Cutoff 분기(P_DATA_TYPE <> '2') 의 WHERE — DATA_TYPE 필터가 걸리는가")
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 1403 AND 1470 ORDER BY LINE""")
for ln, tx in cur.fetchall():
    s = tx.rstrip()
    if s.strip().upper().startswith(('WHERE', 'AND', 'FROM', 'GROUP', 'LEFT', 'INNER', 'JOIN')):
        print(f"    L{ln:5d} | {s[:150]}")

sec("[2] 실호출 대조 — 같은 버전을 DATA_TYPE 1 / 2 / ALL 로 조회했을 때 저장행이 보이나")
VER = 'R_S_20260810_V010_C'
for dt, nm in (('1', 'Cutoff'), ('2', 'ETC'), ('ALL', 'ALL')):
    try:
        c1 = con.cursor(); c2 = con.cursor()
        cur.callproc("PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA",
                     ['40', 'REPORT_SP_W', '2026', VER, dt,
                      'minyonglee1', 'minyonglee1', 'minyonglee1', 'DMF0044', c1, c2])
        cols = [x[0] for x in c1.description]
        rows = c1.fetchall()
        idx = {c: i for i, c in enumerate(cols)}
        ef = Counter(r[idx['EDIT_FLAG']] for r in rows) if 'EDIT_FLAG' in idx else {}
        # 저장한 셀: ITEM_ID='ETC', CUST_REPORT='IM', MEASURE SalesAmt_KRW, M_202603=1
        hit = [r for r in rows
               if str(r[idx.get('ITEM_ID', 0)]) == 'ETC'
               and str(r[idx.get('CUST_REPORT', 0)]) == 'IM'
               and str(r[idx.get('MEASURE', 0)]) == 'SalesAmt_KRW']
        vals = []
        for r in hit[:3]:
            vals.append({k: r[idx[k]] for k in ('M_202603', 'M_202604', 'M_202605', 'M_202606') if k in idx})
        print(f"\n  DATA_TYPE={dt:<3} ({nm:<6}) : {len(rows):,}행 / EDIT_FLAG {dict(ef)}")
        print(f"      저장 대상행(ITEM_ID=ETC, CUST=IM, SalesAmt_KRW) 매칭 {len(hit)}건")
        for v in vals:
            print(f"      → {v}   (저장값 기대: 202603=1, 202604=2, 202605=3, 202606=4)")
    except Exception as e:
        print(f"  DATA_TYPE={dt} ({nm}) : ⛔ {str(e)[:180]}")

con.close()
