"""DMF0043_GET_CONTRIBUTION_SALES_LIST P_END_CUST_REPORT 'ALL' 처리 fix.

Root cause:
  line 524 의 `REPLACE(v_sql_text,'[@v_end_cust_report]', ' AND A.END_CUST_REPORT LIKE ''%'' || p_end_cust_report || ''%'' ')`
  가 P_END_CUST_REPORT='ALL' 시 `LIKE '%ALL%'` 으로 변환 → 매칭 0건 → 화면 데이터 없음.

Fix:
  CASE WHEN NVL(p_end_cust_report,'') IN ('', 'ALL') THEN ''
       ELSE ' AND A.END_CUST_REPORT LIKE ''%' || p_end_cust_report || '%'' '
  END

방식: USER_SOURCE 로부터 풀 SP body 추출 → 1-line patch → CREATE OR REPLACE → 검증 SP call.
백업: USER_SOURCE 스냅샷을 _artifacts/_apply_corporate/_backup/ 에 저장.
멱등: 이미 fix 적용된 body 면 skip.
"""
import os, sys, pathlib, datetime, time
import oracledb

# 즉시 flush — 백그라운드 실행 시 진행 상황 가시화
sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()

# DDL_LOCK_TIMEOUT = 30s — BE 가 SP cursor pin 시 무한 대기 방지
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")
print("[ session ] DDL_LOCK_TIMEOUT=30")

# 1. 현재 corp SP body 풀 추출
cur.execute("""
  SELECT TEXT FROM USER_SOURCE
  WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE='PROCEDURE'
  ORDER BY LINE
""")
lines = [row[0] for row in cur.fetchall()]
body = "".join(lines)
print(f"[ pulled corp body ] {len(lines)} lines, {len(body)} chars")

# 2. 백업 저장
backup_dir = pathlib.Path(__file__).resolve().parent / "_backup"
backup_dir.mkdir(exist_ok=True)
ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
backup_path = backup_dir / f"DMF0043_GET_CONTRIBUTION_SALES_LIST_{ts}.sql"
backup_path.write_text(body, encoding="utf-8")
print(f"[ backup saved ] {backup_path}")

# 3. 멱등 check: 이미 fix 됐는지
SENTINEL_FIXED = "NVL(p_end_cust_report,'') IN ('', 'ALL')"
if SENTINEL_FIXED in body:
    print("[ skip ] body already contains fix sentinel — no change")
    cur.close(); conn.close()
    sys.exit(0)

# 4. 정확한 1-line patch
OLD_LINE = "    v_sql_text := REPLACE(v_sql_text,'[@v_end_cust_report]'  , ' AND A.END_CUST_REPORT LIKE ''%' || p_end_cust_report || '%'' ');"
NEW_LINE = """    v_sql_text := REPLACE(v_sql_text,'[@v_end_cust_report]'  ,
        CASE WHEN NVL(p_end_cust_report,'') IN ('', 'ALL') THEN ''
             ELSE ' AND A.END_CUST_REPORT LIKE ''%' || p_end_cust_report || '%'' '
        END);"""

if OLD_LINE not in body:
    print("[ FAIL ] expected OLD_LINE pattern not found in corp body. Aborting.")
    print("Looking for:", repr(OLD_LINE[:80]))
    cur.close(); conn.close()
    sys.exit(1)

patched_body = body.replace(OLD_LINE, NEW_LINE)
assert patched_body != body, "patch did not change body"
print(f"[ patched ] body diff {len(patched_body) - len(body)} chars")

# 5. CREATE OR REPLACE — USER_SOURCE body 는 "PROCEDURE name (...)" 으로 시작.
#    문장 시작에 "CREATE OR REPLACE " 를 prepend 해서 실행 가능.
ddl = "CREATE OR REPLACE " + patched_body
print(f"[ executing CREATE OR REPLACE ] {len(ddl)} chars (DDL_LOCK_TIMEOUT=30s)")
t_ddl = time.time()
try:
    cur.execute(ddl)
    conn.commit()
    print(f"[ deployed ] {time.time() - t_ddl:.2f} sec")
except oracledb.DatabaseError as e:
    err = str(e)
    print(f"[ DDL FAILED ] {time.time() - t_ddl:.2f} sec — {err}")
    if "ORA-04021" in err or "ORA-00054" in err:
        print("  → BE (Spring Boot, PID 27208) 가 SP cursor pin 보유 추정. BE 중단 후 재시도 필요.")
    cur.close(); conn.close()
    sys.exit(3)

# 6. status check
cur.execute("SELECT STATUS, LAST_DDL_TIME FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST'")
status, last_ddl = cur.fetchone()
print(f"[ object status ] STATUS={status}, LAST_DDL={last_ddl}")
if status != 'VALID':
    print("[ compile errors ]")
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' ORDER BY SEQUENCE")
    for row in cur.fetchall():
        print(f"  L{row[0]}:{row[1]}  {row[2]}")
    cur.close(); conn.close()
    sys.exit(2)

# 7. 검증 SP call
print("\n[ verify SP call ] DMF0043_GET_CONTRIBUTION_SALES_LIST(40, 12, R_S_20251126_V002_C, ALL, ALL, ALL, N, N, minyonglee1)")
o_rc1 = cur.var(oracledb.CURSOR); o_rc2 = cur.var(oracledb.CURSOR); o_rc3 = cur.var(oracledb.CURSOR)
t0 = time.time()
cur.callproc("DMF0043_GET_CONTRIBUTION_SALES_LIST", [
    "40", "12", "R_S_20251126_V002_C", "ALL", "ALL", "ALL", "N", "N", "minyonglee1",
    o_rc1, o_rc2, o_rc3,
])
elapsed = time.time() - t0
rc1 = o_rc1.getvalue().fetchall()
print(f"[ SP elapsed ] {elapsed:.2f} sec")
print(f"[ o_rc1 ] {len(rc1)} rows")
if rc1:
    print(f"  first data row: {rc1[0][:10]}{'...' if len(rc1[0])>10 else ''}")
    print(f"  last row (Total): {rc1[-1][:5]}...")

conn.close()
print("\n[ done ]")
