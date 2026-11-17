# -*- coding: utf-8 -*-
"""사내(ZIOUI1) 40 사업부 Sales Plan 주간 버전(SP_W) 생성 — PR_DM_PLN_SALES_PLAN_CUTOFF 1회 실행 (사용자 요청 2026-11-12).
배치는 내부에서 COMMIT 한다(되돌릴 수 없음). 새 버전 1건 + 그 버전의 스냅샷(_C) 행만 추가한다."""
import sys, os, datetime
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '_diagnostics'))
import importlib.util
spec = importlib.util.spec_from_file_location('ora', os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '_diagnostics', 'ora.py'))
ora = importlib.util.module_from_spec(spec); spec.loader.exec_module(ora)
import oracledb
u, p, d = ora.conn_info(); conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
def one(sql, **b): cur.execute(sql, b); return cur.fetchone()
print('DB', one("SELECT SYS_CONTEXT('USERENV','SERVER_HOST')||'/'||SYS_CONTEXT('USERENV','SERVICE_NAME')||' '||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")[0])
Q = "SELECT COUNT(*), MAX(YYYYMMDD) FROM SCM_MGR.DM_MST_VERSION WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W'"
before = one(Q); print('실행 전 SP_W(40) 건수·최신', before)
t0 = datetime.datetime.now()
cur.execute("BEGIN SCM_MGR.PR_DM_PLN_SALES_PLAN_CUTOFF(:d, TO_CLOB('SALES_PLAN WEEKLY CUTOFF'), :t, :u); END;", d='40', t='SP_W', u='system')
print('실행 시간(초)', round((datetime.datetime.now() - t0).total_seconds(), 1))
after = one(Q); print('실행 후 SP_W(40) 건수·최신', after)
cur.execute("SELECT VERSION_NO, YYYYMMDD, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS'), CREATED_BY FROM SCM_MGR.DM_MST_VERSION WHERE DIVISION_ID='40' AND VERSION_TYPE='SP_W' AND CREATION_DATE >= SYSDATE - 10/1440 ORDER BY CREATION_DATE")
for r in cur.fetchall(): print('신규 버전', r)
cur.execute("SELECT TO_CHAR(EVENT_DATE,'HH24:MI:SS'), PROGRAM_NAME, LOG_TYPE, SUBSTR(LOG_MESSAGE,1,120), SQL_ERR_CODE FROM SCM_MGR.SCM_SYS_LOG_BATCH WHERE EVENT_DATE >= SYSDATE - 10/1440 AND (LOG_TYPE='ERROR' OR PROGRAM_NAME='PR_DM_PLN_SALES_PLAN_CUTOFF') ORDER BY EVENT_DATE, CREATION_DATE")
for r in cur.fetchall(): print('로그', r)
