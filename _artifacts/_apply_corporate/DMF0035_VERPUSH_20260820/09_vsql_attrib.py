# -*- coding: utf-8 -*-
"""대상 INSERT 문 자체에 귀속된 실측 (V$SQL) — 벽시계 총소요 대신 문장 단위 대조.

패치로 SQL 텍스트가 바뀌었으므로 BEFORE/AFTER 는 **서로 다른 SQL_ID** 로 공유풀에 공존한다.
⚠ PL/SQL 정적 SQL 은 V$SQL 저장 시 **주석이 제거**되므로 마커(주석)로는 신/구를 가를 수 없다.
  → 실제 추가된 **술어 원문** 으로 판별한다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""
SELECT S.SQL_ID, S.PLAN_HASH_VALUE, S.EXECUTIONS,
       ROUND(S.ELAPSED_TIME/1e6/GREATEST(S.EXECUTIONS,1), 2) SEC_PER_EXEC,
       ROUND(S.BUFFER_GETS/GREATEST(S.EXECUTIONS,1))          BGETS_PER_EXEC,
       ROUND(S.ROWS_PROCESSED/GREATEST(S.EXECUTIONS,1))       ROWS_PER_EXEC,
       CASE WHEN DBMS_LOB.INSTR(S.SQL_FULLTEXT,'VERSION_NO IN (SELECT VERSION_NO FROM SCM_MGR.GT_DM35_VERSION')>0
            THEN 'AFTER(VERPUSH)' ELSE 'BEFORE' END           GEN,
       TO_CHAR(S.LAST_ACTIVE_TIME,'HH24:MI:SS')               LAST_ACT
  FROM V$SQL S
 WHERE S.SQL_TEXT LIKE 'INSERT INTO SCM_MGR.GT_DM35_T_LAST_SETUP_C%'
 ORDER BY GEN, S.LAST_ACTIVE_TIME
""")
cols = [c[0] for c in cur.description]
print(" | ".join(f"{c:<16}" for c in cols))
for r in cur.fetchall():
    print(" | ".join(f"{str(v):<16}" for v in r))

print("\n=== 프로시저 전체 상위 비용 문장 (회귀 감시) ===")
cur.execute("""
SELECT * FROM (
  SELECT S.SQL_ID, S.PLAN_HASH_VALUE, S.EXECUTIONS,
         ROUND(S.ELAPSED_TIME/1e6/GREATEST(S.EXECUTIONS,1),2) SEC_PER_EXEC,
         ROUND(S.ELAPSED_TIME/1e6,1) TOT_SEC,
         SUBSTR(S.SQL_TEXT,1,88) TXT
    FROM V$SQL S
   WHERE S.LAST_ACTIVE_TIME > SYSDATE - 1/24
     AND (S.SQL_TEXT LIKE '%GT_DM35%' OR S.SQL_TEXT LIKE '%DM_PLN_MKT%')
   ORDER BY S.ELAPSED_TIME DESC)
 WHERE ROWNUM <= 12
""")
for r in cur.fetchall():
    print(f"  {r[0]} ph={r[1]:<11} ex={r[2]:<4} {r[3]:>7}s/ex tot={r[4]:>8}s  {r[5]}")
con.close()
