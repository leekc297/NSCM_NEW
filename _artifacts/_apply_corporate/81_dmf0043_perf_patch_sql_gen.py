#!/usr/bin/env python3
"""
DMF0043 perf fix — patch SQL 파일 생성 (DBA 권한 직접 실행용)

Apply 80 의 Phase A~E 변경 logic 동일. 다만 DB 적용 대신 SQL 파일 write.

배경:
  Apply 80 (5 회 시도) 모두 ORA-04021 — 37 dead JDBC sessions (12.9시간 idle)
  가 SP library cache pin 잡고 있음. SCM_MGR 권한으로 KILL 불가 → DBA 권한 필요.

생성 파일:
  _artifacts/_deploy_packages/DMF0043_PERF/
    ├ 00_README.md            — DBA 실행 가이드
    ├ 01_KILL_SESSIONS.sql    — dead session 37개 KILL (DBA 권한)
    └ 02_SP_PERF.sql          — DMF0043 SP body Phase A~E 변경 (CREATE OR REPLACE)
"""
import datetime
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
OUT_DIR = Path(__file__).parent.parent / "_deploy_packages" / "DMF0043_PERF"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def gen_patched_sp_body() -> str:
    """Apply 80 의 Phase A~E 변경 logic 동일 — SP body src 반환"""
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    try:
        cur.execute(
            "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
            n=SP,
        )
        src = "".join((r[0] or "") for r in cur.fetchall())

        # Phase A
        old_a = "B.CONTRIBUTION_TYPE = ''' || v_small_code || '''"
        new_a = "UPPER(B.CONTRIBUTION_TYPE) = UPPER(''' || v_small_code || ''')"
        src = src.replace(old_a, new_a)

        # Phase B — v_yyyy 변수 선언
        old_b_decl = "    v_seq\t\tPLS_INTEGER;"
        new_b_decl = "    v_seq\t\tPLS_INTEGER;\n    v_yyyy\t\tVARCHAR2(4 CHAR);"
        if "v_yyyy" not in src:
            src = src.replace(old_b_decl, new_b_decl)

        # Phase B+C+D+E — BEGIN 직후 변수 추출 + GTT 적재
        old_init = "BEGIN\n\n    va_program_id := 'DMF0043';"
        new_init = """BEGIN

    -- [Phase B] column 안 sub-select → 변수 사전 추출 (사용자 명시 #2)
    SELECT YYYY INTO v_yyyy FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq);

    -- [Phase C] COMPANY_SN → GTT 사전 적재 (사용자 명시 #1)
    DELETE FROM GT_DMF0043_COMPANY_SN;
    INSERT INTO GT_DMF0043_COMPANY_SN (COMPANY_ID)
    SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN;

    -- [Phase D] TEAM subquery → GTT 사전 적재 (사용자 명시 #1, #3)
    DELETE FROM GT_DMF0043_TEAM;
    INSERT INTO GT_DMF0043_TEAM (USER_ID, USER_NAME, USER_NAME_EN, DEPT_ID, DEPT_NAME_KO, DEPARTMENT_ID, DEPARTMENT_NAME)
    SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO,
           D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
      FROM SCM_MST_SSO_USER_INFO B
      INNER JOIN SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
      INNER JOIN SCM_MST_SSO_DEPT_INFO D ON C.UPPER_DEPT_ID = D.DEPT_ID;

    -- [Phase E] RATIO_DTL → 사전 필터링 GTT 적재 (사용자 명시 #1)
    DELETE FROM GT_DMF0043_RATIO_DTL;
    INSERT INTO GT_DMF0043_RATIO_DTL (DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
                                       PRODUCT_GROUP, DM_BIZ_TYPE, YYYYMM, OS_CORP_CD, CONTRIBUTION_TYPE, CONTRIBUTION_RATIO)
    SELECT DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE,
           YYYYMM, OS_CORP_CD, CONTRIBUTION_TYPE, CONTRIBUTION_RATIO
      FROM DM_MST_CONTRIBUTE_RATIO_DTL
     WHERE VER_SEQ = TO_NUMBER(p_ver_seq);

    va_program_id := 'DMF0043';"""
        if "[Phase B]" not in src:
            src = src.replace(old_init, new_init)

        # Phase B — sub-select YYYY 3 곳 → v_yyyy
        subq_yyyy = "(SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq))||'%'"
        src = src.replace(subq_yyyy, "v_yyyy||'%'")

        # Phase C — COMPANY_SN sub-select → GTT
        old_c = "SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)"
        new_c = "SELECT COMPANY_ID FROM GT_DMF0043_COMPANY_SN  -- [Phase C] GTT 사전 적재"
        src = src.replace(old_c, new_c)

        # Phase D — TEAM subquery → GTT
        old_d = """\t\tLEFT JOIN (
\t\t\tSELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
\t\t\tFROM SCM_MST_SSO_USER_INFO B
\t\t\tINNER JOIN SCM_MST_SSO_DEPT_INFO C
\t\t\tON B.DEPT_ID = C.DEPT_ID
\t\t\tINNER JOIN SCM_MST_SSO_DEPT_INFO D
\t\t\tON C.UPPER_DEPT_ID = D.DEPT_ID
\t\t    )  TEAM"""
        new_d = "\t\tLEFT JOIN GT_DMF0043_TEAM TEAM  -- [Phase D] subquery → GTT 사전 적재"
        src = src.replace(old_d, new_d)

        # Phase E.1 — INNER JOIN RATIO_DTL → GT
        src = src.replace(
            "INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B",
            "INNER JOIN GT_DMF0043_RATIO_DTL B  -- [Phase E] VER_SEQ 사전 필터링된 GTT",
        )

        # Phase E.2 — WHERE B.VER_SEQ → 1=1
        src = src.replace(
            "WHERE B.VER_SEQ = ' || p_ver_seq || '",
            "WHERE 1=1 -- [Phase E] B.VER_SEQ 이미 GTT 적재 시 필터링",
        )

        return src
    finally:
        conn.close()


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")

    # 1. SP body patch SQL
    patched_src = gen_patched_sp_body()
    sp_sql = f"""-- DMF0043_GET_CONTRIBUTION_SALES_LIST — Performance + Cell 값 0 Fix
-- 생성일: {ts}
-- 변경: Phase A (UPPER 매칭) + Phase B (v_yyyy 변수) + Phase C/D/E (3 GTT 적재 → JOIN)
--
-- 사전 조건:
--   1. GT_DMF0043_COMPANY_SN / GT_DMF0043_TEAM / GT_DMF0043_RATIO_DTL 3 GTT 생성 (apply 80 시점 이미 생성)
--   2. DMF0043_GET_CONTRIBUTION_SALES_LIST SP 사용 중 session 없음 (01_KILL_SESSIONS.sql 먼저 실행)
--
-- 실행 방법:
--   SQL Developer / SQLcl: F5 (Run Script)
--   SQL*Plus: @02_SP_PERF.sql

CREATE OR REPLACE {patched_src}
/

-- 컴파일 상태 확인
SELECT STATUS, LAST_DDL_TIME FROM USER_OBJECTS
 WHERE OBJECT_NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
   AND OBJECT_TYPE = 'PROCEDURE';

-- 에러 시 진단
SELECT LINE, POSITION, TEXT FROM USER_ERRORS
 WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
 ORDER BY SEQUENCE
 FETCH FIRST 10 ROWS ONLY;
"""
    (OUT_DIR / "02_SP_PERF.sql").write_text(sp_sql, encoding="utf-8")

    # 2. KILL sessions PL/SQL
    kill_sql = """-- DMF0043 SP library cache pin 잡고 있는 37 dead JDBC sessions KILL
-- 실행 권한: DBA (SYS / SYSTEM / SYSDBA)
-- 실행 시점: 02_SP_PERF.sql 직전
--
-- 배경:
--   apply 80 시도 5+ 회 모두 ORA-04021 (lock 시간 초과). V$DB_OBJECT_CACHE + V$ACCESS
--   진단 결과 37 dead JDBC sessions (LAST_CALL_ET 12.9~13.2 시간 idle, ScpApplication + JDBC Thin Client)
--   가 SP library cache pin 잡고 있음. SCM_MGR 권한 부족 → DBA KILL 필요.

BEGIN
  FOR r IN (
    SELECT DISTINCT s.SID, s.SERIAL#
      FROM V$SESSION s
     WHERE s.SID IN (
           SELECT SID FROM V$DB_OBJECT_CACHE oc, V$ACCESS a
            WHERE oc.NAMESPACE = 'TABLE/PROCEDURE'
              AND oc.NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
              AND a.OBJECT = oc.NAME)
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || r.SID || ',' || r.SERIAL# || ''' IMMEDIATE';
      DBMS_OUTPUT.PUT_LINE('KILLED SID=' || r.SID || ' SERIAL=' || r.SERIAL#);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAILED SID=' || r.SID || ' / ' || SQLERRM);
    END;
  END LOOP;
END;
/

-- 확인 — pin holder 0 여야 함
SELECT COUNT(*) AS REMAINING_PIN_HOLDERS
  FROM V$SESSION s
 WHERE s.SID IN (
       SELECT SID FROM V$DB_OBJECT_CACHE oc, V$ACCESS a
        WHERE oc.NAMESPACE = 'TABLE/PROCEDURE'
          AND oc.NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST'
          AND a.OBJECT = oc.NAME);
"""
    (OUT_DIR / "01_KILL_SESSIONS.sql").write_text(kill_sql, encoding="utf-8")

    # 3. README
    readme = f"""# DMF0043 Performance + Cell 값 0 Fix — DBA 실행 가이드

생성일: {ts}

## 배경

- DMF0043_GET_CONTRIBUTION_SALES_LIST SP 의 cell 값 0 사고 + 성능 사고
- AI apply 80 시도 5+ 회 모두 ORA-04021 (37 dead JDBC sessions 가 SP library cache pin 잡고 있음)
- SCM_MGR 권한 부족 → DBA 권한 필요

## 변경 내역 (5 Phase)

| Phase | 내용 |
|---|---|
| A | RATIO_DTL.CONTRIBUTION_TYPE='COMMISSION' (대문자) vs LOOKUP.SEGMENT1='Commission' (Pascal) 대소문자 mismatch → `UPPER(B.CONTRIBUTION_TYPE) = UPPER(...)` 적용 (cell 값 0 fix) |
| B | `(SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = ...)` sub-select 3 곳 → SP 시작 시 `v_yyyy` 변수 1회 추출 (사용자 명시 #2) |
| C | `SCM_MST_COMPANY_SN` sub-select 2 곳 → `GT_DMF0043_COMPANY_SN` GTT 사전 적재 + IN GTT (사용자 명시 #1) |
| D | TEAM subquery (LEFT JOIN ( SELECT ... FROM SSO_USER_INFO INNER JOIN SSO_DEPT_INFO ... )) → `GT_DMF0043_TEAM` GTT 사전 적재 + LEFT JOIN GTT (사용자 명시 #1, #3) |
| E | dynamic SQL 안 `INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B ... WHERE B.VER_SEQ = p_ver_seq` → `GT_DMF0043_RATIO_DTL` GTT 사전 적재 + INNER JOIN GTT (사용자 명시 #1) |

## 실행 순서

1. **01_KILL_SESSIONS.sql** — DBA 권한 (SYS/SYSTEM/SYSDBA) 으로 실행
   - 37 dead JDBC sessions KILL
   - REMAINING_PIN_HOLDERS = 0 확인

2. **02_SP_PERF.sql** — SCM_MGR 또는 DBA 권한 실행
   - SP body CREATE OR REPLACE
   - STATUS = 'VALID' 확인

3. **검증** — sanity SP 호출:
   ```sql
   DECLARE
     rc_m SYS_REFCURSOR; rc_s SYS_REFCURSOR; rc_c SYS_REFCURSOR;
   BEGIN
     DMF0043_GET_CONTRIBUTION_SALES_LIST('40', '7', 'R_S_20251126_V002_C', '', 'ALL', 'ALL', 'N', 'N', 'minyonglee1', rc_m, rc_s, rc_c);
     -- main rows > 0 + 수치 cell > 0 확인
   END;
   /
   ```

## 기대 결과

- main rows 998 (이전 1) ✓
- non_zero cells > 0 (이전 0) ✓ — Phase A UPPER 매칭 효과
- 실행 시간 < 5초 (이전 10초+) — Phase B/C/D/E GTT 활용 효과

## Rollback

apply 80 의 backup 파일 사용:
- `_artifacts/_diagnostics/DMF0043_GET_CONTRIBUTION_SALES_LIST_perf_before_*.sql`

가장 최근 backup 의 CREATE OR REPLACE 실행 → 원복.
"""
    (OUT_DIR / "00_README.md").write_text(readme, encoding="utf-8")

    print(f"[OK] patch 파일 3개 생성: {OUT_DIR}")
    for f in sorted(OUT_DIR.glob("*")):
        print(f"  {f.name} ({f.stat().st_size} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
