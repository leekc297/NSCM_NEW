"""DMF0043_GET_CONTRIBUTION_SALES_LIST P_END_CUST_REPORT 'ALL' fix — standalone SQL 생성기.

직접 DDL 시 corp Oracle 의 orphan session library cache lock 으로 hang.
대안: 패치된 SQL 파일 생성 → 사용자가 DBeaver/SQL Developer/SQLPlus 로 직접 적용.

Output: _artifacts/_apply_corporate/14_dmf0043_01_end_cust_all_fix.sql
"""
import os, sys, pathlib, datetime
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()

# 현재 corp SP body
cur.execute("""
  SELECT TEXT FROM USER_SOURCE
  WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE='PROCEDURE'
  ORDER BY LINE
""")
lines = [row[0] for row in cur.fetchall()]
body = "".join(lines)
print(f"[ pulled corp body ] {len(lines)} lines, {len(body)} chars")
conn.close()

OLD_LINE = "    v_sql_text := REPLACE(v_sql_text,'[@v_end_cust_report]'  , ' AND A.END_CUST_REPORT LIKE ''%' || p_end_cust_report || '%'' ');"
NEW_LINE = """    v_sql_text := REPLACE(v_sql_text,'[@v_end_cust_report]'  ,
        CASE WHEN NVL(p_end_cust_report,'') IN ('', 'ALL') THEN ''
             ELSE ' AND A.END_CUST_REPORT LIKE ''%' || p_end_cust_report || '%'' '
        END);"""

assert OLD_LINE in body, "OLD_LINE pattern not found"
patched_body = body.replace(OLD_LINE, NEW_LINE)
print(f"[ patched ] body diff {len(patched_body) - len(body)} chars")

# Standalone SQL 파일 작성
out = pathlib.Path(__file__).resolve().parent / "14_dmf0043_01_end_cust_all_fix.sql"
ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
header = f"""-- ===========================================================================
-- DMF0043_GET_CONTRIBUTION_SALES_LIST — P_END_CUST_REPORT 'ALL' 처리 fix
--
-- Root cause: line 524 `LIKE '%' || p_end_cust_report || '%'` → 'ALL' 입력 시 `LIKE '%ALL%'` → row 0
-- Fix      : CASE WHEN NVL(p_end_cust_report,'') IN ('', 'ALL') THEN '' ELSE 기존 LIKE END
--
-- Generated: {ts}
-- Backup   : _artifacts/_apply_corporate/_backup/DMF0043_GET_CONTRIBUTION_SALES_LIST_<ts>.sql
--
-- 적용 방법 (DBeaver/SQL Developer/SQLPlus 모두 동일):
--   1. 본 파일 통째 실행 (Execute SQL Script)
--   2. STATUS=VALID 확인:
--        SELECT STATUS, LAST_DDL_TIME FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST';
--   3. 화면에서 DMF0043_01 진입 → VER_SEQ=12 / R_S_20251126_V002_C / 'ALL' 선택 → 조회
--
-- ⚠️ BE Spring Boot 가 기동 중이면 library cache lock 으로 hang 가능. 적용 전 BE 중단 권장.
-- ===========================================================================

ALTER SESSION SET DDL_LOCK_TIMEOUT=60;

CREATE OR REPLACE """
out.write_text(header + patched_body, encoding="utf-8")
print(f"[ wrote SQL ] {out}")
print(f"[ size ] {len(header + patched_body)} chars")
