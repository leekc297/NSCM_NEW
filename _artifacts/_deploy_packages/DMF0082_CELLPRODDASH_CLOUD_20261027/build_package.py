"""DMF0082_CELLPRODDASH 패키지 생성기 — CELL_PROD_SITE_ID 빈값 = '-' (AS-IS 파리티) · 사내/클라우드 공용 · 전체 F5

구성 (CELL_PROD_SITE_ID 한 컬럼만):
  10_APPLY_LOGIC_PATCH   PKG_DMF0082 BODY 정규화 2곳 삽입 · PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING ELSE '/' 3곳 → '-' (이 DB 의 USER_SOURCE 위 패치형)
  20_ALTER_DEFAULT       CELL_PROD_SITE_ID DEFAULT '/' 인 테이블 → '-' (ON NULL 여부 유지 · 이전 값 기록)
  30_DATA_SLASH_TO_DASH  CELL_PROD_SITE_ID '/' · 공백 → '-' (전 사업부 · 바꾼 행 ROWID·이전 값 기록 · PK 충돌 테이블 건너뜀)
  90_VERIFY / 99_ROLLBACK (30 → 20 → 10 역순 원복)
삽입·치환 문구 = 사내 적용 스크립트(_apply_corporate/CELLPROD_SLASH_20261027/build_apply.py) 그대로.
FRESH-GATE: 생성 직전 사내 DB 현재 원문에 적용 문구가 기대 횟수만큼 있는지 확인 — 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\CELLPROD_SLASH_20261027\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP); corp = importlib.util.module_from_spec(spec); spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
ANC = corp.PKG_ANCHOR + "\n"[:0]           # ASCII 앵커 (줄 앞부분)
B1 = corp.pkg_block("GT_DMF0082_MF_SP")
B2 = corp.pkg_block("GTT_MF_SP")
REPL = corp.MAP_REPL
assert all(ord(c) < 128 for c in ANC), "앵커는 ASCII"
EXCL = "(BAK|_SNAPSHOT|_TMP|_TEST|^CMP[0-9][$]|^ZZ_)"


def lit(text, indent="        "):
    parts = text.split("\n"); assert parts[-1] == ""
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        out = {}
        for n, t in (("PKG_DMF0082", "PACKAGE BODY"), ("PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING", "PROCEDURE")):
            cur.execute("SELECT text FROM user_source WHERE name=:n AND type=:t ORDER BY line", n=n, t=t)
            out[n] = "".join(r[0] for r in cur)
            cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n AND object_type=:t", n=n, t=t)
            out[n + "_ddl"] = cur.fetchone()[0]
    if out["PKG_DMF0082"].count(B1 + corp.PKG_ANCHOR) != 1 or out["PKG_DMF0082"].count(B2 + corp.PKG_ANCHOR) != 1:
        sys.exit("FRESH-GATE FAIL: 사내 PKG_DMF0082 에 삽입 문구가 1회씩이 아님")
    for old, rep, n in REPL:
        if out["PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING"].count(rep) != n:
            sys.exit("FRESH-GATE FAIL: 사내 MAPPING 치환 줄 수 불일치")
    print("FRESH-GATE PASS — PKG", out["PKG_DMF0082_ddl"], "· MAPPING", out["PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING_ddl"])
    return out["PKG_DMF0082_ddl"], out["PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING_ddl"]


COMMON = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    FUNCTION src(p_name VARCHAR2, p_type VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_name AND TYPE = p_type ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN REPLACE(v, CHR(13) || CHR(10), CHR(10));
    END;
    PROCEDURE recompile(p_name VARCHAR2, p_type VARCHAR2, p_new CLOB, p_old CLOB, p_msg VARCHAR2) IS
        v_st VARCHAR2(30); v_err PLS_INTEGER;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_new;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = p_name AND OBJECT_TYPE = p_type;
        SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = p_name AND TYPE = p_type;
        IF v_st <> 'VALID' OR v_err > 0 THEN
            FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = p_name AND TYPE = p_type ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
                DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
            END LOOP;
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_old;
            RAISE_APPLICATION_ERROR(-20005, p_name || ' 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원');
        END IF;
        DBMS_OUTPUT.PUT_LINE(p_msg || ' — ' || p_name || ' ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    END;
"""


def consts():
    s = f"""    c_mark CONSTANT VARCHAR2(40) := '{MARK}';
    c_anc  CONSTANT VARCHAR2(200) := '{corp.PKG_ANCHOR}';
    c_b1   CONSTANT VARCHAR2(32767) :=   -- PKG 삽입 1: P_DMF0082_GET_MAIN_DATA
        {lit(B1)};
    c_b2   CONSTANT VARCHAR2(32767) :=   -- PKG 삽입 2: P_DMF0082_GET_MAIN_DATA_CURRENT
        {lit(B2)};
"""
    for i, (old, rep, n) in enumerate(REPL, 1):
        s += f"    c_o{i} CONSTANT VARCHAR2(400) := {lit(old)};   -- MAPPING 원문 줄 ({n}곳)\n"
        s += f"    c_r{i} CONSTANT VARCHAR2(400) := {lit(rep)};\n"
    return s


def gen_logic(rollback, ddl_pkg, ddl_map):
    head = ("-- 99_ROLLBACK_3_LOGIC — [" + MARK + "] 로직 원복 (PKG 삽입 2곳 제거 · MAPPING '-' → '/' 3곳 되돌림). 전체 F5, 멱등\n") if rollback else (
        "-- 10_APPLY_LOGIC_PATCH — [" + MARK + "] CELL_PROD_SITE_ID 빈값 = '-' 로직 (전체 F5 · 값 입력 없음 · 멱등)\n"
        "-- ① PKG_DMF0082 BODY: GET_MAIN_DATA · GET_MAIN_DATA_CURRENT 의 [E20261013-DMF0082AFSSHARE] 직전에 조회용 임시 테이블 정규화 1문장씩\n"
        "--    (CELL_PROD_SITE_ID '/' · 공백 → '-'). 실적 '/' 와 계획 '-' 로 같은 키가 2줄 나오던 현상(클라우드 81 BMW_US_SPA) 해소.\n"
        "-- ② PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING: CELL_PROD_SITE_ID CASE 의 ELSE '/' 3곳 → '-' (AS-IS L934 · L1158 원형 복원 · 실적 생성 시 '/' 금지)\n"
        "-- 방식: 이 DB 의 USER_SOURCE 위 외과 치환(사내 전체본 복사 아님). 객체별 독립 블록 — 하나가 중단돼도 다른 하나는 진행.\n"
        f"-- 사내 ZIOUI1 적용 완료 PKG {ddl_pkg} · MAPPING {ddl_map}. 컴파일 실패 시 원문 자동 복원.\n")
    out = head + "SET SERVEROUTPUT ON SIZE UNLIMITED\nSET DEFINE OFF\n"
    # PKG 블록
    out += "DECLARE\n    v_src CLOB; v_new CLOB; v_p1 PLS_INTEGER; v_p2 PLS_INTEGER; v_cs PLS_INTEGER; v_ce PLS_INTEGER;\n" + consts() + COMMON + "BEGIN\n"
    out += "    v_src := src('PKG_DMF0082', 'PACKAGE BODY');\n"
    if not rollback:
        out += """    IF cnt(v_src, c_mark) > 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — PKG_DMF0082 이미 적용 (마커 ' || cnt(v_src, c_mark) || ')'); RETURN; END IF;
    IF cnt(v_src, c_anc) <> 2 THEN RAISE_APPLICATION_ERROR(-20001, 'PKG_DMF0082 중단 — 앵커 ' || cnt(v_src, c_anc) || '건 (2 기대 · AFSSHARE 미적용 DB?) · 원문 무변경'); END IF;
    v_p1 := DBMS_LOB.INSTR(v_src, c_anc, 1, 1); v_p2 := DBMS_LOB.INSTR(v_src, c_anc, 1, 2);
    v_cs := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT'); v_ce := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_cs > 0 AND v_ce > 0 AND v_p1 < v_cs AND v_cs < v_p2 AND v_p2 < v_ce) THEN RAISE_APPLICATION_ERROR(-20002, 'PKG_DMF0082 중단 — 앵커 위치 불일치 · 원문 무변경'); END IF;
    v_new := SUBSTR(v_src, 1, v_p1 - 1) || c_b1 || SUBSTR(v_src, v_p1, v_p2 - v_p1) || c_b2 || SUBSTR(v_src, v_p2);
    IF cnt(v_new, c_b1 || c_anc) <> 1 OR cnt(v_new, c_b2 || c_anc) <> 1 THEN RAISE_APPLICATION_ERROR(-20004, 'PKG_DMF0082 중단 — 조립 불일치 · 원문 무변경'); END IF;
    recompile('PKG_DMF0082', 'PACKAGE BODY', v_new, v_src, 'APPLIED');
"""
    else:
        out += """    IF cnt(v_src, c_mark) = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — PKG_DMF0082 마커 없음'); RETURN; END IF;
    IF cnt(v_src, c_b1) <> 1 OR cnt(v_src, c_b2) <> 1 THEN RAISE_APPLICATION_ERROR(-20001, 'PKG_DMF0082 중단 — 삽입 문구 매칭 불일치 · 원문 무변경'); END IF;
    v_new := REPLACE(REPLACE(v_src, c_b1, NULL), c_b2, NULL);
    IF cnt(v_new, c_mark) <> 0 THEN RAISE_APPLICATION_ERROR(-20004, 'PKG_DMF0082 중단 — 마커 잔존 · 원문 무변경'); END IF;
    recompile('PKG_DMF0082', 'PACKAGE BODY', v_new, v_src, 'ROLLED BACK');
"""
    out += "END;\n/\n"
    # MAPPING 블록
    out += "DECLARE\n    v_src CLOB; v_new CLOB;\n" + consts() + COMMON + "BEGIN\n"
    out += "    v_src := src('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PROCEDURE');\n"
    if not rollback:
        out += "    IF cnt(v_src, c_mark) > 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — MAPPING 이미 적용 (마커 ' || cnt(v_src, c_mark) || ')'); RETURN; END IF;\n"
        conds = " OR ".join(f"cnt(v_src, c_o{i}) <> {n}" for i, (_, _, n) in enumerate(REPL, 1))
        out += f"    IF {conds} THEN RAISE_APPLICATION_ERROR(-20001, 'MAPPING 중단 — ELSE ''/'' 대상 줄 ' || " + " || ' · ' || ".join(f"cnt(v_src, c_o{i})" for i in range(1, len(REPL) + 1)) + " || '건 (2 · 1 기대) · 원문 무변경 → 00 M1 회신'); END IF;\n"
        out += "    v_new := v_src;\n" + "".join(f"    v_new := REPLACE(v_new, c_o{i}, c_r{i});\n" for i in range(1, len(REPL) + 1))
        out += "    recompile('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PROCEDURE', v_new, v_src, 'APPLIED');\n"
    else:
        out += "    IF cnt(v_src, c_mark) = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — MAPPING 마커 없음'); RETURN; END IF;\n"
        out += "    v_new := v_src;\n" + "".join(f"    v_new := REPLACE(v_new, c_r{i}, c_o{i});\n" for i in range(1, len(REPL) + 1))
        out += "    IF cnt(v_new, c_mark) <> 0 THEN RAISE_APPLICATION_ERROR(-20004, 'MAPPING 중단 — 마커 잔존 · 원문 무변경'); END IF;\n"
        out += "    recompile('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PROCEDURE', v_new, v_src, 'ROLLED BACK');\n"
    out += "END;\n/\n"
    out += "SELECT 'POST' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME IN ('PKG_DMF0082','PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING') ORDER BY 2, 3;\n"
    return out


TABS_SQL = f"""SELECT C.TABLE_NAME, C.DEFAULT_ON_NULL FROM USER_TAB_COLUMNS C JOIN USER_TABLES T ON T.TABLE_NAME = C.TABLE_NAME AND T.TEMPORARY = 'N'
                   WHERE C.COLUMN_NAME = 'CELL_PROD_SITE_ID' AND NOT REGEXP_LIKE(C.TABLE_NAME, '{EXCL}') ORDER BY 1"""

DEFAULT_APPLY = f"""-- 20_ALTER_DEFAULT — [{MARK}] CELL_PROD_SITE_ID DEFAULT '/' → '-' (전체 F5 · 멱등)
-- 대상: CELL_PROD_SITE_ID 가 있는 일반 테이블(백업·스냅샷·임시 제외) 중 현재 DEFAULT 가 '/' 인 것. ON NULL 여부는 그대로 유지.
-- AS-IS: DM_PLN_SALES_PLAN · DM_PLN_SALES_PLAN_RESULT · DM_PLN_MKT_FCST_RESULT 의 DEFAULT 가 '-' (나머지는 기본값 없음 · NOT NULL).
-- 이전 값은 SCM_MGR.ZZ_CELLPROD_DASH_DFLT_20261027 에 기록 (99 가 복원). 딕셔너리만 바뀌는 DDL (행 갱신 없음) · 잠금 대기 30초.
-- ⚠ 테이블 DDL 은 그 테이블을 쓰는 PKG/PROC 를 INVALID 로 만든다(사내 17개) → 끝에서 실행 전 VALID 이던 객체만 재컴파일 · 실패 목록 출력.
--   실행 중인 세션이 있으면 ORA-04068 이 날 수 있으니 배치·화면 사용이 적을 때 실행.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_log CONSTANT VARCHAR2(60) := 'ZZ_CELLPROD_DASH_DFLT_20261027';
    v_n NUMBER; v_d VARCHAR2(4000); v_cnt NUMBER := 0;
    TYPE t_set IS TABLE OF VARCHAR2(1) INDEX BY VARCHAR2(300);
    v_valid t_set; v_k VARCHAR2(300); v_bad NUMBER;
    PROCEDURE recomp_invalidated IS   -- 이 DDL 로 무효화된 객체(실행 전 VALID)만 재컴파일 · 원래 INVALID 이던 객체는 건드리지 않음
        v_st VARCHAR2(30); v_fix NUMBER := 0;
    BEGIN
        FOR pass IN 1 .. 3 LOOP
            FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'INVALID' ORDER BY OBJECT_TYPE, OBJECT_NAME) LOOP
                IF v_valid.EXISTS(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) THEN
                    BEGIN
                        EXECUTE IMMEDIATE CASE o.OBJECT_TYPE WHEN 'PACKAGE BODY' THEN 'ALTER PACKAGE ' || o.OBJECT_NAME || ' COMPILE BODY'
                                                              WHEN 'TYPE BODY' THEN 'ALTER TYPE ' || o.OBJECT_NAME || ' COMPILE BODY'
                                                              ELSE 'ALTER ' || o.OBJECT_TYPE || ' ' || o.OBJECT_NAME || ' COMPILE' END;
                    EXCEPTION WHEN OTHERS THEN NULL;   -- 컴파일 경고/오류는 아래 상태 확인으로 보고 (ORA-24344)
                    END;
                END IF;
            END LOOP;
        END LOOP;
        FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS ORDER BY 1, 2) LOOP
            IF v_valid.EXISTS(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) AND o.STATUS <> 'VALID' THEN
                DBMS_OUTPUT.PUT_LINE('   ★ 재컴파일 실패 ' || o.OBJECT_NAME || ' ' || o.OBJECT_TYPE || ' — 회신'); v_fix := v_fix + 1;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('== 의존 객체 재컴파일 완료 · 실패 ' || v_fix);
    END;
BEGIN
    FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'VALID') LOOP v_valid(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) := 'Y'; END LOOP;
    SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_log;
    IF v_n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.' || c_log || ' (TABLE_NAME VARCHAR2(128) NOT NULL, OLD_DEFAULT VARCHAR2(400), OLD_ON_NULL VARCHAR2(3), LOGGED_AT DATE DEFAULT SYSDATE NOT NULL)';
    END IF;
    EXECUTE IMMEDIATE 'ALTER SESSION SET DDL_LOCK_TIMEOUT = 30';
    FOR t IN ({TABS_SQL}) LOOP
        SELECT DATA_DEFAULT INTO v_d FROM USER_TAB_COLUMNS WHERE TABLE_NAME = t.TABLE_NAME AND COLUMN_NAME = 'CELL_PROD_SITE_ID';
        IF TRIM(v_d) = '''/''' THEN
            EXECUTE IMMEDIATE 'INSERT INTO SCM_MGR.' || c_log || ' (TABLE_NAME, OLD_DEFAULT, OLD_ON_NULL) VALUES (:1, :2, :3)' USING t.TABLE_NAME, TRIM(v_d), t.DEFAULT_ON_NULL;
            COMMIT;
            EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.' || t.TABLE_NAME || ' MODIFY (CELL_PROD_SITE_ID DEFAULT ' || CASE WHEN t.DEFAULT_ON_NULL = 'YES' THEN 'ON NULL ' END || '''-'')';
            v_cnt := v_cnt + 1;
            DBMS_OUTPUT.PUT_LINE('   ALTERED ' || RPAD(t.TABLE_NAME, 36) || ' DEFAULT ' || CASE WHEN t.DEFAULT_ON_NULL = 'YES' THEN 'ON NULL ' END || '''/'' → ''-''');
        ELSE
            DBMS_OUTPUT.PUT_LINE('   SKIP    ' || RPAD(t.TABLE_NAME, 36) || ' 현재 DEFAULT ' || NVL(TRIM(v_d), '(없음)'));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('== DEFAULT 변경 ' || v_cnt || '개 테이블 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    recomp_invalidated;   -- 테이블 DDL 은 의존 PKG/PROC 를 무효화한다 (사내 리허설 실측 17개)
END;
/
"""

DEFAULT_RB = f"""-- 99_ROLLBACK_2_DEFAULT — 20 원복 (기록 테이블의 이전 DEFAULT 로 · 무효화된 의존 객체 재컴파일). 전체 F5 · 멱등
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_n NUMBER;
    TYPE t_set IS TABLE OF VARCHAR2(1) INDEX BY VARCHAR2(300);
    v_valid t_set; v_k VARCHAR2(300); v_bad NUMBER;
    PROCEDURE recomp_invalidated IS   -- 이 DDL 로 무효화된 객체(실행 전 VALID)만 재컴파일 · 원래 INVALID 이던 객체는 건드리지 않음
        v_st VARCHAR2(30); v_fix NUMBER := 0;
    BEGIN
        FOR pass IN 1 .. 3 LOOP
            FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'INVALID' ORDER BY OBJECT_TYPE, OBJECT_NAME) LOOP
                IF v_valid.EXISTS(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) THEN
                    BEGIN
                        EXECUTE IMMEDIATE CASE o.OBJECT_TYPE WHEN 'PACKAGE BODY' THEN 'ALTER PACKAGE ' || o.OBJECT_NAME || ' COMPILE BODY'
                                                              WHEN 'TYPE BODY' THEN 'ALTER TYPE ' || o.OBJECT_NAME || ' COMPILE BODY'
                                                              ELSE 'ALTER ' || o.OBJECT_TYPE || ' ' || o.OBJECT_NAME || ' COMPILE' END;
                    EXCEPTION WHEN OTHERS THEN NULL;   -- 컴파일 경고/오류는 아래 상태 확인으로 보고 (ORA-24344)
                    END;
                END IF;
            END LOOP;
        END LOOP;
        FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS ORDER BY 1, 2) LOOP
            IF v_valid.EXISTS(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) AND o.STATUS <> 'VALID' THEN
                DBMS_OUTPUT.PUT_LINE('   ★ 재컴파일 실패 ' || o.OBJECT_NAME || ' ' || o.OBJECT_TYPE || ' — 회신'); v_fix := v_fix + 1;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('== 의존 객체 재컴파일 완료 · 실패 ' || v_fix);
    END;
BEGIN
    FOR o IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE STATUS = 'VALID') LOOP v_valid(o.OBJECT_NAME || '|' || o.OBJECT_TYPE) := 'Y'; END LOOP;
    SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = 'ZZ_CELLPROD_DASH_DFLT_20261027';
    IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — 기록 테이블 없음 (20 미실행)'); RETURN; END IF;
    EXECUTE IMMEDIATE 'ALTER SESSION SET DDL_LOCK_TIMEOUT = 30';
    FOR r IN (SELECT TABLE_NAME, OLD_DEFAULT, OLD_ON_NULL FROM SCM_MGR.ZZ_CELLPROD_DASH_DFLT_20261027 ORDER BY 1) LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE SCM_MGR.' || r.TABLE_NAME || ' MODIFY (CELL_PROD_SITE_ID DEFAULT ' || CASE WHEN r.OLD_ON_NULL = 'YES' THEN 'ON NULL ' END || r.OLD_DEFAULT || ')';
        DBMS_OUTPUT.PUT_LINE('   RESTORED ' || RPAD(r.TABLE_NAME, 36) || ' DEFAULT ' || CASE WHEN r.OLD_ON_NULL = 'YES' THEN 'ON NULL ' END || r.OLD_DEFAULT);
    END LOOP;
    EXECUTE IMMEDIATE 'DROP TABLE SCM_MGR.ZZ_CELLPROD_DASH_DFLT_20261027 PURGE';
    recomp_invalidated;
END;
/
"""

DATA_APPLY = f"""-- 30_DATA_SLASH_TO_DASH — [{MARK}] CELL_PROD_SITE_ID '/' · 공백 → '-' (전 사업부 · 전체 F5 · 멱등)
-- 대상: CELL_PROD_SITE_ID 한 컬럼만 (감사 컬럼 등 다른 컬럼 무변경) · CELL_PROD_SITE_ID 가 있는 일반 테이블(백업·스냅샷·임시 제외)
-- 원복 대비: 바꾸는 행의 ROWID 와 이전 값을 SCM_MGR.ZZ_CELLPROD_DASH_DATA_20261027 에 먼저 기록 → 기록분만 5만 건씩 UPDATE · COMMIT
-- 가드: PK 에 CELL_PROD_SITE_ID 가 있고 같은 키 '-' 행이 이미 있으면(PK 충돌) 그 테이블 전체 건너뜀 (회신)
-- ★ c_dry_run = 'Y' 이면 건수만 (변경·기록 없음)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_dry_run CONSTANT VARCHAR2(1) := 'N';
    c_log     CONSTANT VARCHAR2(60) := 'ZZ_CELLPROD_DASH_DATA_20261027';
    c_cond    CONSTANT VARCHAR2(200) := ' (CELL_PROD_SITE_ID = ''/'' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL)) ';
    v_n NUMBER; v_on VARCHAR2(4000); v_pk VARCHAR2(4000); v_lo NUMBER; v_hi NUMBER; v_done NUMBER; v_all NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('== CELL_PROD_SITE_ID ''/'' → ''-'' ' || CASE c_dry_run WHEN 'Y' THEN '[DRY RUN]' ELSE '[실행]' END || ' · ' || SYS_CONTEXT('USERENV','DB_NAME') || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    IF c_dry_run = 'N' THEN
        SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_log;
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.' || c_log || ' (SEQ NUMBER NOT NULL, TABLE_NAME VARCHAR2(128) NOT NULL, RID ROWID NOT NULL, OLD_VAL VARCHAR2(120), LOGGED_AT DATE DEFAULT SYSDATE NOT NULL)';
        END IF;
    END IF;
    FOR t IN ({TABS_SQL}) LOOP
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME || ' WHERE' || c_cond INTO v_n;
        IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 36) || ' 대상 0 (''/'' 행 없음)'); CONTINUE; END IF;
        v_pk := NULL; v_on := NULL;
        FOR k IN (SELECT CC.COLUMN_NAME FROM USER_CONSTRAINTS C JOIN USER_CONS_COLUMNS CC ON CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
                   WHERE C.TABLE_NAME = t.TABLE_NAME AND C.CONSTRAINT_TYPE = 'P' ORDER BY CC.POSITION) LOOP
            v_pk := v_pk || k.COLUMN_NAME || ',';
            IF k.COLUMN_NAME <> 'CELL_PROD_SITE_ID' THEN v_on := v_on || ' AND B.' || k.COLUMN_NAME || ' = A.' || k.COLUMN_NAME; END IF;
        END LOOP;
        IF INSTR(',' || v_pk, ',CELL_PROD_SITE_ID,') > 0 THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME || ' A WHERE' || REPLACE(c_cond, 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID')
                           || ' AND EXISTS (SELECT 1 FROM SCM_MGR.' || t.TABLE_NAME || ' B WHERE B.CELL_PROD_SITE_ID = ''-''' || v_on || ')' INTO v_done;
            IF v_done > 0 THEN DBMS_OUTPUT.PUT_LINE('   ★ ' || RPAD(t.TABLE_NAME, 34) || ' PK 충돌 ' || v_done || '건 — 건너뜀 (회신)'); CONTINUE; END IF;
        END IF;
        IF c_dry_run = 'Y' THEN DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 36) || ' 대상 ' || TO_CHAR(v_n, 'FM999,999,999')); CONTINUE; END IF;
        EXECUTE IMMEDIATE 'SELECT NVL(MAX(SEQ), 0) FROM SCM_MGR.' || c_log INTO v_lo;
        EXECUTE IMMEDIATE 'INSERT INTO SCM_MGR.' || c_log || ' (SEQ, TABLE_NAME, RID, OLD_VAL) SELECT :b + ROWNUM, :t, ROWID, CELL_PROD_SITE_ID FROM SCM_MGR.' || t.TABLE_NAME || ' WHERE' || c_cond
            USING v_lo, t.TABLE_NAME;
        v_hi := v_lo + SQL%ROWCOUNT;
        COMMIT;
        v_done := 0;
        WHILE v_lo < v_hi LOOP
            EXECUTE IMMEDIATE 'UPDATE SCM_MGR.' || t.TABLE_NAME || ' SET CELL_PROD_SITE_ID = ''-'' WHERE ROWID IN (SELECT RID FROM SCM_MGR.' || c_log || ' WHERE SEQ > :a AND SEQ <= :z) AND' || c_cond
                USING v_lo, LEAST(v_lo + 50000, v_hi);
            v_done := v_done + SQL%ROWCOUNT;
            COMMIT;
            v_lo := v_lo + 50000;
        END LOOP;
        v_all := v_all + v_done;
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 36) || ' 전환 ' || LPAD(TO_CHAR(v_done, 'FM999,999,999'), 12) || ' / 대상 ' || TO_CHAR(v_n, 'FM999,999,999'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('== 완료 ' || CASE c_dry_run WHEN 'Y' THEN '(DRY RUN)' ELSE '전환 합계 ' || TO_CHAR(v_all, 'FM999,999,999') END || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
"""

DATA_RB = f"""-- 99_ROLLBACK_1_DATA — 30 원복 (기록 테이블의 ROWID · 이전 값으로, 지금도 '-' 인 행만). 전체 F5 · 멱등
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_n NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = 'ZZ_CELLPROD_DASH_DATA_20261027';
    IF v_n = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — 기록 테이블 없음 (30 미실행)'); RETURN; END IF;
    FOR t IN (SELECT TABLE_NAME, COUNT(*) N FROM SCM_MGR.ZZ_CELLPROD_DASH_DATA_20261027 GROUP BY TABLE_NAME ORDER BY 1) LOOP
        EXECUTE IMMEDIATE 'MERGE INTO SCM_MGR.' || t.TABLE_NAME || ' A USING (SELECT RID, OLD_VAL FROM SCM_MGR.ZZ_CELLPROD_DASH_DATA_20261027 WHERE TABLE_NAME = :t) L
                           ON (A.ROWID = L.RID) WHEN MATCHED THEN UPDATE SET A.CELL_PROD_SITE_ID = L.OLD_VAL WHERE A.CELL_PROD_SITE_ID = ''-''' USING t.TABLE_NAME;
        DBMS_OUTPUT.PUT_LINE('   RESTORED ' || RPAD(t.TABLE_NAME, 36) || ' ' || SQL%ROWCOUNT || ' / 기록 ' || t.N);
        COMMIT;
    END LOOP;
    EXECUTE IMMEDIATE 'DROP TABLE SCM_MGR.ZZ_CELLPROD_DASH_DATA_20261027 PURGE';
END;
/
"""

STATE_SQL = f"""SELECT '{{tag}} 마커' CHK, O.NAME, COUNT(*) N FROM (SELECT 'PKG_DMF0082' NAME, 'PACKAGE BODY' TYPE, 2 EXP FROM DUAL UNION ALL SELECT 'PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PROCEDURE', 3 FROM DUAL) O
  LEFT JOIN USER_SOURCE S ON S.NAME = O.NAME AND S.TYPE = O.TYPE AND S.TEXT LIKE '%{MARK}%' GROUP BY O.NAME ORDER BY 2;
SELECT '{{tag}} 상태' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) ERR
  FROM USER_OBJECTS O WHERE OBJECT_NAME IN ('PKG_DMF0082','PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING') ORDER BY 2, 3;
"""


def state_block(tag):
    return f"""DECLARE
    v_d VARCHAR2(4000); v_n NUMBER; v_slash NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('== {tag} 테이블별 CELL_PROD_SITE_ID DEFAULT · ''/''/공백 행 수');
    FOR t IN ({TABS_SQL}) LOOP
        SELECT DATA_DEFAULT INTO v_d FROM USER_TAB_COLUMNS WHERE TABLE_NAME = t.TABLE_NAME AND COLUMN_NAME = 'CELL_PROD_SITE_ID';
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME || ' WHERE CELL_PROD_SITE_ID = ''/'' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL)' INTO v_n;
        v_slash := v_slash + v_n;
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(t.TABLE_NAME, 36) || ' DEFAULT ' || RPAD(NVL(TRIM(v_d), '(없음)'), 6) || ' ON NULL ' || RPAD(t.DEFAULT_ON_NULL, 3) || ' · ''/''행 ' || TO_CHAR(v_n, 'FM999,999,999'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('   합계 ''/''행 ' || TO_CHAR(v_slash, 'FM999,999,999'));
END;
/
"""


def gen_precheck():
    return (f"""-- 00_PRECHECK — [{MARK}] 조회 전용 (전체 F5 · 값 입력 없음)
-- * P0 접속 DB · P1 로직 앵커(PKG AFSSHARE 2건 · MAPPING ELSE '/' 대상 줄 2·1건) · P2 마커/상태 · P3 테이블별 DEFAULT · '/' 행 수
-- * P4 30 DRY RUN 은 30 파일 c_dry_run 을 'Y' 로 바꿔 실행 (PK 충돌 확인 포함)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'P0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST, USER, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'P1 PKG앵커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE FROM USER_SOURCE
 WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND TEXT LIKE '    /* [E20261013-DMF0082AFSSHARE]%';
SELECT 'P1 MAP줄' CHK, SUM(CASE WHEN TEXT LIKE '%ELSE ''/'' END AS CELL_PROD_SITE_ID%' THEN 1 ELSE 0 END) SELECT_2, SUM(CASE WHEN TEXT LIKE '%ELSE ''/'' END;%' THEN 1 ELSE 0 END) GROUPBY_1
  FROM USER_SOURCE WHERE NAME = 'PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING' AND TYPE = 'PROCEDURE' AND TEXT NOT LIKE '--%' AND LTRIM(TEXT) NOT LIKE '--%';
""" + STATE_SQL.format(tag="P2") + state_block("P3"))


def gen_verify():
    return (f"""-- 90_VERIFY — [{MARK}] 조회 전용 (전체 F5)
-- 기대: V1 마커 PKG 2 · MAPPING 3 · V2 VALID/오류 0 · V3 모든 테이블 DEFAULT '-' · '/'행 0
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
""" + STATE_SQL.format(tag="V1") + state_block("V3"))


def main():
    ddl_pkg, ddl_map = fresh_gate()
    d = os.path.join(HERE, "A_DB"); os.makedirs(d, exist_ok=True)
    files = {"00_PRECHECK.sql": gen_precheck(), "10_APPLY_LOGIC_PATCH.sql": gen_logic(False, ddl_pkg, ddl_map),
             "20_ALTER_DEFAULT.sql": DEFAULT_APPLY, "30_DATA_SLASH_TO_DASH.sql": DATA_APPLY, "90_VERIFY.sql": gen_verify(),
             "99_ROLLBACK_1_DATA.sql": DATA_RB, "99_ROLLBACK_2_DEFAULT.sql": DEFAULT_RB, "99_ROLLBACK_3_LOGIC.sql": gen_logic(True, ddl_pkg, ddl_map)}
    for n, t in files.items():
        open(os.path.join(d, n), "w", encoding="utf-8", newline="\n").write(t)
        print("WROTE", n, t.count("\n"))


if __name__ == "__main__":
    main()
