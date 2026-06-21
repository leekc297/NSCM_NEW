#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST — 성능 + cell 값 0 fix (5 Phase)

Phase A: cell 값 0 root cause fix
  - RATIO_DTL.CONTRIBUTION_TYPE='COMMISSION' (대문자) vs LOOKUP.SEGMENT1='Commission' (Pascal) 대소문자 mismatch
  - SQL CASE 매칭에 UPPER() 적용
  - 변경: B.CONTRIBUTION_TYPE = ''' || v_small_code → UPPER(B.CONTRIBUTION_TYPE) = UPPER(''' || v_small_code

Phase B: column 안 sub-select → 변수 사전 추출 (사용자 명시 #2)
  - (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq))
  - SP 시작 시 SELECT YYYY INTO v_yyyy 변수에 1회 추출
  - 3 곳 (BP_FCST L289, SALES_PLAN L315, INSERT GT_SALES_LIST_C L366) 모두 v_yyyy 사용

Phase C: SCM_MST_COMPANY_SN sub-select → GTT 사전 적재 (사용자 명시 #1, #3)
  - SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN 2 곳
  - GT_DMF0043_COMPANY_SN 신규 GTT 신설 + SP 시작 시 INSERT
  - NOT IN (SELECT ... GT) 변경

Phase D: TEAM subquery → GTT 사전 적재 (사용자 명시 #1, #3)
  - LEFT JOIN ( SELECT B.USER_ID ... FROM SCM_MST_SSO_USER_INFO B INNER JOIN ... INNER JOIN ... ) TEAM
  - GT_DMF0043_TEAM 신규 GTT 신설 + SP 시작 시 INSERT (1번)
  - LEFT JOIN GT_DMF0043_TEAM TEAM 변경

Phase E: RATIO_DTL filter → 사전 GTT 적재 (사용자 명시 #1)
  - dynamic SQL 안 INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B ... WHERE B.VER_SEQ = p_ver_seq
  - GT_DMF0043_RATIO_DTL 신규 GTT 신설 + SP 시작 시 INSERT WHERE VER_SEQ = p_ver_seq
  - INNER JOIN GT_DMF0043_RATIO_DTL B 변경 (WHERE B.VER_SEQ 제거 — 이미 적재 시 필터)

검증:
  vs=7 + R_S_20251126_V002_C → main rows > 0 + non_zero > 0 + 실행 시간 측정
"""
import datetime, time
from pathlib import Path
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/OCGSCMD_P01")
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
BACKUP_DIR = Path(__file__).parent.parent / "_diagnostics"
LOG_DIR = Path(__file__).parent / "_logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    log = [f"=== DMF0043 perf+cell fix ({ts}) ==="]
    conn = oracledb.connect(**CONN)
    cur = conn.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    try:
        # === Step 0: 신규 GTT 3종 CREATE (멱등) ===========================
        for tbl, ddl in [
            (
                "GT_DMF0043_COMPANY_SN",
                """CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0043_COMPANY_SN (
                    COMPANY_ID VARCHAR2(60)
                ) ON COMMIT PRESERVE ROWS""",
            ),
            (
                "GT_DMF0043_TEAM",
                """CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0043_TEAM (
                    USER_ID         VARCHAR2(60),
                    USER_NAME       VARCHAR2(150),
                    USER_NAME_EN    VARCHAR2(150),
                    DEPT_ID         VARCHAR2(60),
                    DEPT_NAME_KO    VARCHAR2(150),
                    DEPARTMENT_ID   VARCHAR2(60),
                    DEPARTMENT_NAME VARCHAR2(150)
                ) ON COMMIT PRESERVE ROWS""",
            ),
            (
                "GT_DMF0043_RATIO_DTL",
                """CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0043_RATIO_DTL (
                    DEPARTMENT_ID       VARCHAR2(60),
                    DEPT_ID             VARCHAR2(60),
                    END_CUST_REPORT     VARCHAR2(60),
                    SOLDTO_CUST_REPORT  VARCHAR2(60),
                    PRODUCT_GROUP       VARCHAR2(60),
                    DM_BIZ_TYPE         VARCHAR2(60),
                    YYYYMM              VARCHAR2(6),
                    OS_CORP_CD          VARCHAR2(60),
                    CONTRIBUTION_TYPE   VARCHAR2(60),
                    CONTRIBUTION_RATIO  NUMBER
                ) ON COMMIT PRESERVE ROWS""",
            ),
        ]:
            cur.execute(
                f"SELECT COUNT(*) FROM USER_TABLES WHERE TABLE_NAME='{tbl}'"
            )
            if cur.fetchone()[0] == 0:
                cur.execute(ddl)
                log.append(f"  [CREATE GTT] {tbl} OK")
            else:
                log.append(f"  [GTT exists] {tbl}")
        conn.commit()

        # === Step 1: SP body 백업 + read =================================
        cur.execute(
            "SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE",
            n=SP,
        )
        src = "".join((r[0] or "") for r in cur.fetchall())
        (BACKUP_DIR / f"{SP}_perf_before_{ts}.sql").write_text(
            "CREATE OR REPLACE " + src, encoding="utf-8"
        )
        log.append(f"  [BACKUP] {len(src)} chars")

        # === Phase A: cell 값 0 fix — UPPER() 매칭 =======================
        # 짧은 substring 단위 replace (긴 string 가독성 + escape 회피)
        old_a = "B.CONTRIBUTION_TYPE = ''' || v_small_code || '''"
        new_a = "UPPER(B.CONTRIBUTION_TYPE) = UPPER(''' || v_small_code || ''')"
        if old_a in src:
            src = src.replace(old_a, new_a)
            log.append("  [Phase A] UPPER(CONTRIBUTION_TYPE) 적용 OK")
        else:
            log.append("  [Phase A WARN] 패턴 미매칭 — 수동 확인")

        # === Phase B: v_yyyy 변수 사전 추출 ==============================
        # 변수 선언 추가
        old_b_decl = "    v_seq\t\tPLS_INTEGER;"
        new_b_decl = "    v_seq\t\tPLS_INTEGER;\n    v_yyyy\t\tVARCHAR2(4 CHAR);"
        if old_b_decl in src and "v_yyyy" not in src:
            src = src.replace(old_b_decl, new_b_decl)
            log.append("  [Phase B] v_yyyy 변수 선언 추가 OK")

        # BEGIN 직후 SELECT YYYY INTO v_yyyy
        old_b_init = "BEGIN\n\n    va_program_id := 'DMF0043';"
        new_b_init = """BEGIN

    -- [Phase B] column 안 sub-select → 변수 사전 추출 (사용자 명시 #2)
    SELECT YYYY INTO v_yyyy FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq);

    va_program_id := 'DMF0043';"""
        if old_b_init in src and "[Phase B]" not in src:
            src = src.replace(old_b_init, new_b_init)
            log.append("  [Phase B] SELECT YYYY INTO v_yyyy 추가 OK")

        # 3 곳의 sub-select → v_yyyy
        subq_yyyy_a = "(SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq))||'%'"
        cnt_yyyy = src.count(subq_yyyy_a)
        src = src.replace(subq_yyyy_a, "v_yyyy||'%'")
        log.append(f"  [Phase B] sub-select YYYY 3 곳 → v_yyyy: {cnt_yyyy} 곳 변경")

        # === Phase C: SCM_MST_COMPANY_SN → GTT =============================
        # BEGIN 직후 GT_DMF0043_COMPANY_SN 적재
        old_c_init = "    -- [Phase B] column 안 sub-select → 변수 사전 추출 (사용자 명시 #2)\n    SELECT YYYY INTO v_yyyy FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = TO_NUMBER(p_ver_seq);"
        new_c_init = """    -- [Phase B] column 안 sub-select → 변수 사전 추출 (사용자 명시 #2)
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
     WHERE VER_SEQ = TO_NUMBER(p_ver_seq);"""
        if old_c_init in src and "[Phase C]" not in src:
            src = src.replace(old_c_init, new_c_init)
            log.append("  [Phase C/D/E] 신규 GTT 3종 사전 적재 추가 OK")

        # NOT IN (SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN) → NOT IN (SELECT FROM GT)
        old_c_in = "SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)"
        new_c_in = "SELECT COMPANY_ID FROM GT_DMF0043_COMPANY_SN  -- [Phase C] GTT 사전 적재"
        cnt_c = src.count(old_c_in)
        src = src.replace(old_c_in, new_c_in)
        log.append(f"  [Phase C] COMPANY_SN sub-select → GTT: {cnt_c} 곳")

        # === Phase D: TEAM subquery → GTT (INSERT GT_SALES_LIST_C 부분만) ====
        old_d_team = """\t\tLEFT JOIN (
\t\t\tSELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
\t\t\tFROM SCM_MST_SSO_USER_INFO B
\t\t\tINNER JOIN SCM_MST_SSO_DEPT_INFO C
\t\t\tON B.DEPT_ID = C.DEPT_ID
\t\t\tINNER JOIN SCM_MST_SSO_DEPT_INFO D
\t\t\tON C.UPPER_DEPT_ID = D.DEPT_ID
\t\t    )  TEAM"""
        new_d_team = "\t\tLEFT JOIN GT_DMF0043_TEAM TEAM  -- [Phase D] subquery → GTT 사전 적재"
        cnt_d = src.count(old_d_team)
        src = src.replace(old_d_team, new_d_team)
        log.append(f"  [Phase D] TEAM subquery → GTT: {cnt_d} 곳")

        # === Phase E: INNER JOIN RATIO_DTL → GT (짧은 substring 매칭) =====
        # INNER JOIN 절 — RATIO_DTL → GT
        e1_old = "INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B"
        e1_new = "INNER JOIN GT_DMF0043_RATIO_DTL B  -- [Phase E] VER_SEQ 사전 필터링된 GTT"
        cnt_e1 = src.count(e1_old)
        src = src.replace(e1_old, e1_new)
        log.append(f"  [Phase E.1] INNER JOIN RATIO_DTL → GT: {cnt_e1} 곳")

        # dynamic SQL 안 WHERE B.VER_SEQ = p_ver_seq → 1=1 (GTT 적재 시 이미 필터링)
        e2_old = "WHERE B.VER_SEQ = ' || p_ver_seq || '"
        e2_new = "WHERE 1=1 -- [Phase E] B.VER_SEQ 이미 GTT 적재 시 필터링"
        cnt_e2 = src.count(e2_old)
        src = src.replace(e2_old, e2_new)
        log.append(f"  [Phase E.2] WHERE B.VER_SEQ → 1=1: {cnt_e2} 곳")

        # === CREATE OR REPLACE ============================================
        try:
            cur.execute("CREATE OR REPLACE " + src)
            conn.commit()
            log.append("  [CREATE OR REPLACE] OK")
        except oracledb.DatabaseError as e:
            log.append(f"  [ERR] {str(e)[:200]}")
            cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY", n=SP)
            for ln, pos, text in cur.fetchall():
                log.append(f"    L{ln}:{pos} {text}")
            return 5

        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=SP)
        status = cur.fetchone()[0]
        log.append(f"  [STATUS] {status}")
        if status != "VALID":
            cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY", n=SP)
            for ln, pos, text in cur.fetchall():
                log.append(f"    L{ln}:{pos} {text}")
            return 6

        # === Sanity ========================================================
        for vs, vno in [("7", "R_S_20251126_V002_C"), ("7", "R_S_20251202_V001_C")]:
            cur.execute("DELETE FROM GT_DMF0043_PLAN_REPORT_C")
            cur.execute("DELETE FROM GT_DMF0043_SALES_LIST_C")
            conn.commit()
            rc_m = cur.var(oracledb.CURSOR)
            rc_s = cur.var(oracledb.CURSOR)
            rc_c = cur.var(oracledb.CURSOR)
            t0 = time.time()
            try:
                cur.callproc(SP, ["40", vs, vno, "", "ALL", "ALL", "N", "N", "minyonglee1", rc_m, rc_s, rc_c])
                mrows = rc_m.getvalue().fetchall()
                dt = time.time() - t0
                if mrows:
                    cs = [d[0] for d in rc_m.getvalue().description]
                    r0 = dict(zip(cs, mrows[0]))
                    nz = sum(1 for v in r0.values() if isinstance(v, (int, float)) and v != 0)
                    samples = {k: v for k, v in r0.items() if isinstance(v, (int, float)) and v != 0}
                    log.append(f"  [SANITY] vs={vs} {vno:<27} rows={len(mrows):<5} non_zero={nz} time={dt:.1f}s sample={dict(list(samples.items())[:3])}")
                else:
                    log.append(f"  [SANITY] vs={vs} {vno:<27} rows=0 time={dt:.1f}s")
            except Exception as e:
                log.append(f"  [SANITY ERR] vs={vs}: {str(e)[:120]}")

        log.append("  [DONE]")
        print("[OK] apply 완료")
    finally:
        (LOG_DIR / f"{ts}_DMF0043_PERF.log").write_text("\n".join(log), encoding="utf-8")
        conn.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
