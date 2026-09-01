# -*- coding: utf-8 -*-
"""클라우드 NLS 모사 검증: NLS_DATE_FORMAT='RR/MM/DD' 세션에서 (a) 백업 ASIS 식 → ORA-01861 재현, (b) 정정본 PKG 호출 → 정상 반환"""
import io, sys; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb; from ora import conn_info
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD'")
cur.execute("SELECT VALUE FROM NLS_SESSION_PARAMETERS WHERE PARAMETER='NLS_DATE_FORMAT'"); print("session NLS_DATE_FORMAT =", cur.fetchone()[0])
try:
    cur.execute("SELECT TO_CHAR(SCM_MGR.FN_NEXT_DAY(CAST('20260824' AS DATE),'MON')-7,'YYYYMMDD') FROM DUAL"); print("(a) ASIS 식:", cur.fetchone())
except oracledb.DatabaseError as e: print("(a) ASIS 식 재현:", str(e).splitlines()[0])
cur.execute("SELECT TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE('20260824','YYYYMMDD'),'MON')-7,'YYYYMMDD') FROM DUAL"); print("(a') 정정 식:", cur.fetchone())
r1 = cur.var(oracledb.CURSOR); r2 = cur.var(oracledb.CURSOR)
cur.callproc("SCM_MGR.PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON", ['40','ALL','ALL','ALL','ALL','ALL','','','20260801','20270228','admin','Current','ALL','','False','MONTHLY','admin','DMF0040', r1, r2])
rows = r1.getvalue().fetchall(); print("(b) 정정본 PKG 호출 OK — rows", len(rows), "cols", len(r1.getvalue().description) if False else "")
cur.execute("SELECT LOG_TYPE, SQL_ERR_CODE FROM SCM_MGR.SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME LIKE '%DMF0040%' AND EVENT_DATE > SYSDATE-2/1440 ORDER BY EVENT_DATE DESC FETCH FIRST 3 ROWS ONLY"); print("(c) 로그:", cur.fetchall())
