# -*- coding: utf-8 -*-
# VMO 진단(읽기 전용) - sqllog_calls.py 5000행 1구간 시간 분해: 조회 / PARAMS CLOB 읽기
import os, sys, time, json
ROOT = r'C:\Projects\NSCM'
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
import dbconn
d = json.load(open(os.path.join(ROOT, 'Doc', 'verify', 'SCP0005', 'sqllog_calls.json'), encoding='utf-8'))
lo, hi = d['windows'][0][0], d['windows'][0][1]
a, b = hi - 4999, hi
cx = dbconn.connect('tobe'); cx.call_timeout = 120000
cur = cx.cursor()
q = """SELECT log_seq, sql_id, DBMS_LOB.SUBSTR(sql_text, 400, 1), params, result_count, TO_CHAR(execute_time, 'YYYY-MM-DD HH24:MI:SS'), created_by
 FROM scm_mgr.scm_com_sql_log WHERE log_seq BETWEEN :a AND :b AND sql_id = 'com.lgcns.nscm.callProc' AND (DBMS_LOB.INSTR(sql_text, 'PKG_SCP0005.') > 0)"""
cur.execute("EXPLAIN PLAN SET STATEMENT_ID='VMO_SQLLOG' FOR " + q.replace(':a', '1').replace(':b', '2'))
cur.execute("SELECT plan_table_output FROM TABLE(DBMS_XPLAN.DISPLAY(NULL,'VMO_SQLLOG','BASIC +ROWS'))")
for r in cur.fetchall(): print(r[0])
t0 = time.time(); cur.execute(q, a=a, b=b); rows = cur.fetchall(); t1 = time.time()
print(f'range {a}~{b} rows {len(rows)} execute+fetch {t1 - t0:.1f}s')
n = 0; t2 = time.time()
for r in rows:
    p = r[3].read() if hasattr(r[3], 'read') else r[3]; n += len(p or '')
t3 = time.time()
print(f'PARAMS read {len(rows)} rows {n} chars {t3 - t2:.1f}s  per row {(t3 - t2) / max(1, len(rows)):.3f}s')
cur.execute("SELECT DBMS_LOB.GETLENGTH(sql_text) FROM scm_mgr.scm_com_sql_log WHERE log_seq BETWEEN :a AND :b", a=a, b=b)
L = [x[0] or 0 for x in cur.fetchall()]
print(f'sql_text len rows {len(L)} max {max(L) if L else 0} avg {sum(L) / max(1, len(L)):.0f}')
cx.close()
