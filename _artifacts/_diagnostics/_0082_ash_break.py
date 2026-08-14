#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 GET — SP 내부 시간을 **SQL_ID 단위로 실측 분해** (hook #129 ⓪-b).

방법: 전용 세션에 MODULE 마커를 찍고 SP 를 실행 → 그 세션의 ASH 샘플을 SQL_ID×이벤트로 집계.
      ASH 1샘플 ≈ 1초이므로 샘플수가 곧 초.
귀속은 **SQL_ID 실측만** 인정한다(명명 추정·단독재현 금지).
"""
import io, sys, time, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

A = 'ALL'
PARAMS = ['40', A, A, A, '20260801', '20270131', A, None,
          'Current', 'N', 'minyonglee1', 'ADMIN', A, A, A, A]
MOD = 'DMF0082BREAK'

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SID'), SYS_CONTEXT('USERENV','SESSIONID') FROM DUAL")
sid, _ = cur.fetchone()
cur.execute(f"BEGIN DBMS_APPLICATION_INFO.SET_MODULE('{MOD}','GET'); END;")
# ⭐ 이번 실행 구간만 ASH 를 자르기 위한 기준 시각 (20분 창이면 직전 실행이 섞인다)
cur.execute("SELECT TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS.FF3') FROM DUAL")
T_START = cur.fetchone()[0]
print(f"[window] start={T_START}")

rcs = [con.cursor() for _ in range(5)]
rr = con.cursor()
t0 = time.time()
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", PARAMS + rcs + [rr])
t_sp = time.time() - t0
rcs[0].arraysize = 1000
rcs[0].prefetchrows = 1000
t1 = time.time()
n = len(rcs[0].fetchall())
t_fetch = time.time() - t1
print(f"[SID {sid}]  SP {t_sp:7.2f}s | fetch {t_fetch:6.2f}s | 결과 {n:,}행")
con.close()

# ── ASH 귀속 (별도 접속) ────────────────────────────────────────────────────
con2 = oracledb.connect(user=u, password=p, dsn=d)
c2 = con2.cursor()
c2.execute("""
    WITH A AS (
        SELECT SQL_ID, NVL(EVENT,'ON CPU') EV, COUNT(*) S
        FROM   V$ACTIVE_SESSION_HISTORY
        WHERE  MODULE = :m
        AND    SAMPLE_TIME >= TO_TIMESTAMP(:t,'YYYY-MM-DD HH24:MI:SS.FF3')
        GROUP  BY SQL_ID, NVL(EVENT,'ON CPU')
    ), T AS (
        SELECT SQL_ID, MIN(SUBSTR(SQL_TEXT,1,90)) TXT FROM V$SQL GROUP BY SQL_ID
    )
    SELECT A.SQL_ID, A.EV, A.S, T.TXT
    FROM   A LEFT JOIN T ON T.SQL_ID = A.SQL_ID
    ORDER  BY A.S DESC FETCH FIRST 20 ROWS ONLY""", m=MOD, t=T_START)
rows = c2.fetchall()
tot = sum(r[2] for r in rows) or 1
print(f"\n=== SQL_ID 귀속 (ASH 총 {tot}s) — ★ = 2초 이상 (튜닝 대상) ===")
print(f"   {'SQL_ID':<15}{'EVENT':<26}{'초':>5}{'%':>7}  SQL")
for r in rows:
    mark = '★' if r[2] >= 2 else ' '
    print(f" {mark} {str(r[0]):<15}{r[1][:25]:<26}{r[2]:>5}{100*r[2]/tot:>6.1f}%  {(r[3] or '')[:52]}")

# 상위 SQL 의 플랜 라인 귀속
if rows:
    top = rows[0][0]
    c2.execute("""SELECT SQL_PLAN_LINE_ID, COUNT(*) S FROM V$ACTIVE_SESSION_HISTORY
                  WHERE MODULE=:m AND SQL_ID=:s
                    AND SAMPLE_TIME >= TO_TIMESTAMP(:t,'YYYY-MM-DD HH24:MI:SS.FF3')
                  GROUP BY SQL_PLAN_LINE_ID ORDER BY 2 DESC FETCH FIRST 6 ROWS ONLY""",
               m=MOD, s=top, t=T_START)
    print(f"\n=== 최상위 SQL {top} 의 플랜 라인 ===")
    for r in c2.fetchall():
        print(f"   LINE {str(r[0]):>5}  {r[1]:>4}s")
con2.close()
