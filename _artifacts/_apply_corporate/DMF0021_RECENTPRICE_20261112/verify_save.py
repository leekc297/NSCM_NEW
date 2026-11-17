# -*- coding: utf-8 -*-
"""검증 — 사용자가 11:22:50 에 화면에서 보낸 저장 인자(BE 로그)를 그대로 다시 호출하고 금액을 확인한다(같은 행 · 같은 값).
저장 SP 는 내부에서 COMMIT 한다."""
import sys, oracledb
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
A = ['M^M^M', '40^40^40', 'SpaceX^SpaceX^SpaceX', 'SpaceX_US_XLC^SpaceX_US_XLC^SpaceX_US_XLC', '/^/^/',
     'MCCM348015A1-000^MCCM348015A1-000^MCCM348015A1-000', 'E^E^E', 'MPS^MPS^MPS', 'FCA^FCA^FCA',
     'RTF_SYS_RP^RTF_SYS_RP^RTF_SYS_RP', 'M_202612^M_202701^M_202702', '111^222^333', 'USD^USD^USD',
     'minyonglee1^minyonglee1^minyonglee1', 'minyonglee1^minyonglee1^minyonglee1', '/^/^/',
     '70090866^70090866^70090866', 'HQ06-A^HQ06-A^HQ06-A']
Q = ("SELECT YYYYMMDD, MEASURE, QTY, TO_CHAR(LAST_UPDATE_DATE,'HH24:MI:SS') FROM SCM_MGR.DM_PLN_SALES_PLAN WHERE DIVISION_ID='40' AND SCM_SITE_ID='SpaceX_US_XLC' "
     "AND ITEM_ID='MCCM348015A1-000' AND YYYYMMDD>='20261201' AND MEASURE IN ('RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD') ORDER BY 1,2")
u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor(); cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
    cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("DB 시각", cur.fetchone()[0])
    cur.execute(Q); print("저장 전"); [print("  ", r) for r in cur.fetchall()]
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL", A + [rc])
    r = rc.getvalue(); print("저장 응답", [x[0] for x in r.description], r.fetchall())
    con.commit()
    cur.execute(Q); print("저장 후"); [print("  ", r) for r in cur.fetchall()]
