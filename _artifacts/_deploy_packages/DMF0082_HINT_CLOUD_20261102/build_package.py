"""DMF0082_HINT 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 P_DMF0082_GET_MAIN_DATA 범위 안 7곳만 치환)

앵커 = ASCII · GET_MAIN_DATA 범위(PROCEDURE P_DMF0082_GET_MAIN_DATA ~ PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO)에서 각 1건.
FRESH-GATE: 생성 직전 사내 DB BODY 에 변경 후 문구 각 1건 · 앵커 0건인지 확인 — 다르면 중단.

  python build_package.py [--alias CAL|CALL]
"""
import sys, os
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn

HERE = os.path.dirname(os.path.abspath(__file__))
MARK = "E20261102-DMF0082HINT"
M = f"/*[{MARK}]*/"
ALIAS = sys.argv[sys.argv.index('--alias') + 1] if '--alias' in sys.argv else 'CAL'
PK_LINE = "PROCEDURE P_DMF0082_GET_MAIN_DATA"
BOUND = "PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO"
INS_FCST = "    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST\n        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)\n"

# (설명, 앵커, 변경 후) — 앵커·변경 후 모두 ASCII
REPS = [
    ("H1 TEMP_SITE_ITEM_ALL FULL(F)",
     "    )\n    SELECT F.DIVISION_ID\n         , F.PROJECT_CODE\n         , F.SCM_SITE_ID\n         , F.ITEM_ID\n         , F.ATTRIBUTE5 ",
     f"    )\n    SELECT /*+ FULL(F) */ {M} F.DIVISION_ID\n         , F.PROJECT_CODE\n         , F.SCM_SITE_ID\n         , F.ITEM_ID\n         , F.ATTRIBUTE5 "),
    ("H2 T_LAST_DATA_SETUP_FCST FULL(A) USE_HASH(A)",
     INS_FCST + "    SELECT A.DIVISION_ID,",
     INS_FCST + f"    SELECT /*+ FULL(A) USE_HASH(A) */ {M} A.DIVISION_ID,"),
    ("H3 FUTURE_PRICE 1 read",
     "        FROM (\n        SELECT A.DIVISION_ID AS C01\n             , A.PROJECT_CODE AS C02\n             , A.PROJECT_CODE AS C03  --[DIV81]",
     f"        FROM (\n        SELECT /*+ LEADING(B A C) USE_HASH(A C D) FULL(A) FULL(B) FULL(C) FULL(D) NO_SWAP_JOIN_INPUTS(A) PARALLEL(4) */ {M} A.DIVISION_ID AS C01\n             , A.PROJECT_CODE AS C02\n             , A.PROJECT_CODE AS C03  --[DIV81]"),
    ("H4 CFM_SELLING_PRICE hint replace",
     "        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ ",
     f"        SELECT /*+ LEADING(B A) USE_HASH(A C) FULL(A) SWAP_JOIN_INPUTS(B) NO_SWAP_JOIN_INPUTS(A) SWAP_JOIN_INPUTS(C) */ /*[{MARK}] old hint: LEADING(A) USE_HASH(B) USE_HASH(C)*/ "),
    ("H5 MF_SP load",
     "    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID\n         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID\n         , F.CELL_PROD_SITE_ID\n         , CAL.BUCKET_TYPE\n",
     f"    SELECT /*+ LEADING({ALIAS} F VD) USE_HASH(F VD PVT) SWAP_JOIN_INPUTS({ALIAS}) NO_SWAP_JOIN_INPUTS(F) PARALLEL(F 4) */ {M} F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID\n         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID\n         , F.CELL_PROD_SITE_ID\n         , CAL.BUCKET_TYPE\n"),
    ("H6a final dynamic SQL placeholder",
     "    V_SQL := '\n    SELECT [@V_COLUMN]\n    , ([@V_QTY_SUM]) AS QTY\n",
     "    V_SQL := '\n    SELECT [@V_HINT82] [@V_COLUMN]\n    , ([@V_QTY_SUM]) AS QTY\n"),
    ("H6b PARALLEL(8) only for 82",
     "    V_SQL := REPLACE(V_SQL, '[@V_QTY_SUM]',     V_QTY_SUM);\n",
     f"    V_SQL := REPLACE(V_SQL, '[@V_HINT82]', CASE WHEN p_division_id = '82' THEN '/*+ PARALLEL(8) */' END);  --[{MARK}] 82 only\n    V_SQL := REPLACE(V_SQL, '[@V_QTY_SUM]',     V_QTY_SUM);\n"),
]
for _, a, b in REPS:
    assert all(ord(c) < 128 for c in a + b), a[:40]


def lit(text, indent="        "):
    parts = text.split("\n")
    out = []
    for i, p in enumerate(parts):
        q = "'" + p.replace("'", "''") + "'"
        if i < len(parts) - 1:
            out.append(q + " || CHR(10)")
        elif p:
            out.append(q)
    return (" ||\n" + indent).join(out)


def get_body():
    cx = dbconn.connect('tobe', dbconn.load_cfg())
    c = cx.cursor()
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    body = ''.join(r[0] or '' for r in c.fetchall())
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    ddl, st = c.fetchone()
    c.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    return body, ddl, st, c.fetchone()[0]


def fresh_gate(body, base_path):
    """사내 적용 전 백업(00_BACKUP)을 기준으로 앵커가 범위 안 각 1건인지 + 사내 현재 본문의 변경 후 문구 확인"""
    base = open(base_path, encoding='utf-8', newline='\n').read()
    i, e = base.index(PK_LINE + "\n"), base.index(BOUND)
    rng = base[i:e]
    for name, a, b in REPS:
        n = rng.count(a)
        assert n == 1, f'FRESH-GATE FAIL: 적용 전 원문 앵커 {name} {n}건'
    for name, a, b in REPS:
        print(f'  앵커 OK {name}')
    print('사내 현재 본문 마커 수', body.count(MARK))


COMMON_DECL = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src  CLOB;
    v_new  CLOB;
    v_rng  CLOB;
    v_st   VARCHAR2(30);
    v_err  PLS_INTEGER;
    v_s    PLS_INTEGER;
    v_e    PLS_INTEGER;
    c_mark CONSTANT VARCHAR2(40) := '{MARK}';
    TYPE t_vc IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    c_name t_vc; c_anc t_vc; c_new t_vc;
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE compile_body(p_sql CLOB) IS   -- 컴파일 오류(ORA-24344)는 아래 STATUS 확인으로 처리, 그 외 오류(ORA-04021 등)는 그대로 올림
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_sql;
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE <> -24344 THEN RAISE; END IF;
    END;
BEGIN
"""
SET_ARR = ""
for i, (name, a, b) in enumerate(REPS, 1):
    SET_ARR += f"    c_name({i}) := '{name}';\n    c_anc({i}) := {lit(a)};\n    c_new({i}) := {lit(b)};\n"

LOAD = f"""    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF v_src IS NULL OR DBMS_LOB.GETLENGTH(v_src) = 0 THEN
        RAISE_APPLICATION_ERROR(-20000, '중단 — USER_SOURCE 에 PKG_DMF0082 BODY 없음. SCM_MGR 로 접속했는지 확인');
    END IF;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    v_s := DBMS_LOB.INSTR(v_src, CHR(10) || '{PK_LINE}' || CHR(10));
    v_e := DBMS_LOB.INSTR(v_src, CHR(10) || '{BOUND}');
    IF v_s = 0 OR v_e = 0 OR v_e < v_s THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — P_DMF0082_GET_MAIN_DATA 범위를 찾지 못함. 원문 무변경');
    END IF;
    v_rng := SUBSTR(v_src, v_s, v_e - v_s);
"""

TAIL = """    compile_body(v_new);
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        compile_body(v_src);   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;\n"


def gen_apply(ddl, fetched):
    return f"""-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={ddl} FETCHED={fetched} DB=ZIOUI1
-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5 · 값 입력 없음 · 멱등)
-- 내용: P_DMF0082_GET_MAIN_DATA 힌트 6건(사용자 지정 튜닝 2026-11-02). 로직·결과 컬럼 변경 없음.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 GET_MAIN_DATA 범위 안 앵커 7곳만 치환 후 CREATE OR REPLACE (사내 전체본 복사 아님)
-- 가드: 마커 있으면 무동작 · 앵커가 범위 안 각 1건이 아니면 중단(원문 무변경, 어느 앵커인지 출력) · 컴파일 오류 시 원문 자동 복원
-- 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{COMMON_DECL}{SET_ARR}{LOAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    FOR i IN 1 .. c_anc.COUNT LOOP
        IF cnt(v_rng, c_anc(i)) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 ' || c_name(i) || ' 매칭 ' || cnt(v_rng, c_anc(i)) || '건 (1 기대) → 결과 회신. 원문 무변경');
        END IF;
    END LOOP;
    FOR i IN 1 .. c_anc.COUNT LOOP
        v_rng := REPLACE(v_rng, c_anc(i), c_new(i));
    END LOOP;
    v_new := SUBSTR(v_src, 1, v_s - 1) || v_rng || SUBSTR(v_src, v_e);
    IF cnt(v_new, c_mark) <> 7 - 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 ' || cnt(v_new, c_mark) || '곳 (6 기대). 원문 무변경');
    END IF;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 힌트 7곳을 원래 문구로 되돌림 (이 DB 의 USER_SOURCE 기준). 전체 F5 · 멱등
-- 마커 없으면 무동작.
{COMMON_DECL}{SET_ARR}{LOAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    FOR i IN 1 .. c_new.COUNT LOOP
        IF cnt(v_rng, c_new(i)) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 ' || c_name(i) || ' 매칭 ' || cnt(v_rng, c_new(i)) || '건 (1 기대). 원문 무변경');
        END IF;
    END LOOP;
    FOR i IN 1 .. c_new.COUNT LOOP
        v_rng := REPLACE(v_rng, c_new(i), c_anc(i));
    END LOOP;
    v_new := SUBSTR(v_src, 1, v_s - 1) || v_rng || SUBSTR(v_src, v_e);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 제거 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def like_line(tok):
    return tok.replace("'", "''")


PRE_TOK = [
    ("H1", "    SELECT F.DIVISION_ID"),
    ("H2", "    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST"),
    ("H3", "        SELECT A.DIVISION_ID AS C01"),
    ("H4", "        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */ %"),
    ("H5", "    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID"),
    ("H6a", "    SELECT [@V_COLUMN]"),
    ("H6b", "    V_SQL := REPLACE(V_SQL, '[@V_QTY_SUM]',     V_QTY_SUM);"),
]


def gen_precheck():
    rows = "\nUNION ALL ".join(
        f"SELECT '{n}' ANCHOR, COUNT(*) N_RANGE FROM USER_SOURCE S, B WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND S.LINE BETWEEN B.L1 AND B.L2 AND RTRIM(S.TEXT, CHR(10)||CHR(13)) LIKE '{like_line(t)}'"
        for n, t in PRE_TOK)
    return f"""-- 00_PRECHECK — 조회 전용 (전체 F5 · 값 입력 없음). [{MARK}] 적용 전 상태
-- L0 접속 DB · PKG 상태 · L1 앵커 첫 줄 (GET_MAIN_DATA 범위 줄 기준 — H1 2 이하, 나머지 1 이상이면 진행. 최종 판정은 10 이 앵커 전체로 한다) · L2 마커 0 · L3 실행 중 세션
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, USER CUR_USER, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
WITH B AS (SELECT (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = '{PK_LINE}') L1,
                  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{BOUND}%') L2 FROM DUAL)
{rows};
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""


VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5)
-- 기대: V1 마커 PASS(6) · V2 VALID/오류 0 · V3 힌트 줄 6 + 치환자 줄 1
SET DEFINE OFF
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 6 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 줄' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))), 1, 170) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND (S.TEXT LIKE '%{MARK}%' OR S.TEXT LIKE '%[@V_HINT82] [@V_COLUMN]%') ORDER BY S.LINE;
"""


LOG = "ZB_DMF0082_HINT_SPEED"


def gen_measure(label, want_applied):
    state = "적용 후" if want_applied else "적용 전"
    guard = ("v_mark = 0" if want_applied else "v_mark > 0")
    guard_msg = ("패치 미적용 상태 — 20_APPLY 먼저" if want_applied else "이미 패치 적용 상태 — 적용 전 측정 불가. 40_COMPARE 는 비교 불가")
    return f"""-- 속도 측정 [{label}] — {state} P_DMF0082_GET_MAIN_DATA (전체 F5 · 값 입력 없음 · 원장 변경 없음)
-- 사업부 40 · 81 · 82 를 각 3회 호출해 프로시저 실행 시간 · 커서 fetch 시간 · 행 수 · 결과 해시를 {LOG} 에 기록한다(같은 세션 반복).
-- 조건 = 화면 기본값: 기간 당월 1일 ~ +6개월-1일 · 필터 전부 빈값 · Current · qtyYn N · 사용자 = 아래 규칙.
-- 사용자: c_user 가 NULL 이면 BEFORE 때 DMF0082 FcstNPrice 개인 컬럼 설정 행이 가장 많은 사용자를 고르고, AFTER 는 같은 사용자 · 같은 기간을 그대로 쓴다.
--         특정 사용자로 재려면 c_user 값을 바꾼다 (10 · 30 같은 값).
-- 같은 라벨을 다시 돌리면 그 라벨 기록을 지우고 새로 기록한다. 0행이면 ZERO_ROWS 로 표시 — 그 사업부 비교는 무의미.
-- 이 측정은 DB 안 시간이다. BE 왕복 · JSON 변환은 포함되지 않으므로 화면 체감은 따로 확인한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{LOG}';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE {LOG} (LABEL VARCHAR2(20), DIV VARCHAR2(10), RUN_NO NUMBER, USER_ID VARCHAR2(100), FROM_YMD VARCHAR2(8), TO_YMD VARCHAR2(8), PROC_SEC NUMBER, FETCH_SEC NUMBER, TOTAL_SEC NUMBER, ROW_CNT NUMBER, COL_CNT NUMBER, RES_HASH NUMBER, ERR VARCHAR2(1000), BODY_DDL VARCHAR2(20), RUN_AT DATE)';
        DBMS_OUTPUT.PUT_LINE('기록표 생성 {LOG}');
    END IF;
END;
/
DECLARE
    c_label CONSTANT VARCHAR2(20) := '{label}';
    c_runs  CONSTANT PLS_INTEGER := 3;
    c_user  CONSTANT VARCHAR2(100) := NULL;
    TYPE t_div IS TABLE OF VARCHAR2(10);
    v_divs  t_div := t_div('40', '81', '82');
    v_mark  PLS_INTEGER;
    v_user  VARCHAR2(100);
    v_from  VARCHAR2(8);
    v_to    VARCHAR2(8);
    v_ddl   VARCHAR2(20);
    v_cnt   PLS_INTEGER;

    PROCEDURE one_run(p_div VARCHAR2, p_run PLS_INTEGER) IS
        rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rc6 SYS_REFCURSOR;
        t0 PLS_INTEGER; t1 PLS_INTEGER; t2 PLS_INTEGER;
        c  INTEGER; ncol INTEGER; dsc DBMS_SQL.DESC_TAB2;
        val VARCHAR2(4000); rw VARCHAR2(32767);
        h  NUMBER := 0; r_h NUMBER; rows_n PLS_INTEGER := 0; v_err VARCHAR2(1000);
    BEGIN
        t0 := DBMS_UTILITY.GET_TIME;
        PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(p_div, NULL, NULL, NULL, v_from, v_to, NULL, NULL, 'Current', 'N', v_user, v_user, NULL, NULL, NULL, NULL, rc1, rc2, rc3, rc4, rc5, rc6);
        t1 := DBMS_UTILITY.GET_TIME;
        c := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
        DBMS_SQL.DESCRIBE_COLUMNS2(c, ncol, dsc);
        FOR i IN 1 .. ncol LOOP DBMS_SQL.DEFINE_COLUMN(c, i, val, 4000); END LOOP;
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            rows_n := rows_n + 1; rw := NULL; r_h := 0;
            FOR i IN 1 .. ncol LOOP
                DBMS_SQL.COLUMN_VALUE(c, i, val);
                IF NVL(LENGTHB(rw), 0) + NVL(LENGTHB(val), 0) > 30000 THEN
                    r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(rw, 1, 1073741824), 1000000007); rw := NULL;
                END IF;
                rw := rw || '|' || val;
            END LOOP;
            r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(rw, 1, 1073741824), 1000000007);
            h := MOD(h + r_h, 281474976710656);   -- 행 순서 무관 합
        END LOOP;
        t2 := DBMS_UTILITY.GET_TIME;
        DBMS_SQL.CLOSE_CURSOR(c);
        IF rc2%ISOPEN THEN CLOSE rc2; END IF; IF rc3%ISOPEN THEN CLOSE rc3; END IF; IF rc4%ISOPEN THEN CLOSE rc4; END IF;
        IF rc5%ISOPEN THEN CLOSE rc5; END IF; IF rc6%ISOPEN THEN CLOSE rc6; END IF;
        INSERT INTO {LOG} (LABEL, DIV, RUN_NO, USER_ID, FROM_YMD, TO_YMD, PROC_SEC, FETCH_SEC, TOTAL_SEC, ROW_CNT, COL_CNT, RES_HASH, ERR, BODY_DDL, RUN_AT)
        VALUES (c_label, p_div, p_run, v_user, v_from, v_to, (t1 - t0) / 100, (t2 - t1) / 100, (t2 - t0) / 100, rows_n, ncol, h, CASE WHEN rows_n = 0 THEN 'ZERO_ROWS' END, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(c_label || ' div' || p_div || ' #' || p_run || ' proc ' || (t1 - t0) / 100 || 's fetch ' || (t2 - t1) / 100 || 's rows=' || rows_n || ' cols=' || ncol);
    EXCEPTION WHEN OTHERS THEN
        v_err := SUBSTR(SQLERRM, 1, 1000);
        ROLLBACK;
        INSERT INTO {LOG} (LABEL, DIV, RUN_NO, USER_ID, FROM_YMD, TO_YMD, ERR, BODY_DDL, RUN_AT) VALUES (c_label, p_div, p_run, v_user, v_from, v_to, v_err, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(c_label || ' div' || p_div || ' #' || p_run || ' ERROR ' || v_err);
    END;
BEGIN
    SELECT COUNT(*) INTO v_mark FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
    IF {guard} THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — {guard_msg} (마커 ' || v_mark || '곳)');
    END IF;
    SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') INTO v_ddl FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_cnt FROM {LOG} WHERE LABEL = 'BEFORE' AND USER_ID IS NOT NULL;
    IF c_label <> 'BEFORE' AND v_cnt > 0 THEN   -- 비교 조건 고정: BEFORE 와 같은 사용자 · 기간
        SELECT MAX(USER_ID), MAX(FROM_YMD), MAX(TO_YMD) INTO v_user, v_from, v_to FROM {LOG} WHERE LABEL = 'BEFORE';
    ELSE
        v_from := TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD');
        v_to   := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 6) - 1, 'YYYYMMDD');
        v_user := c_user;
        IF v_user IS NULL THEN
            SELECT MAX(USER_ID) KEEP (DENSE_RANK FIRST ORDER BY CNT DESC, USER_ID) INTO v_user
              FROM (SELECT USER_ID, COUNT(*) CNT FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' GROUP BY USER_ID);
        END IF;
        IF v_user IS NULL THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 — DMF0082 FcstNPrice 개인 컬럼 설정 사용자 없음. c_user 에 사용자 ID 를 넣고 다시 실행');
        END IF;
    END IF;
    DELETE FROM {LOG} WHERE LABEL = c_label;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(c_label || ' 시작 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' · user=' || v_user || ' · ' || v_from || '~' || v_to || ' · BODY LAST_DDL ' || v_ddl);
    FOR d IN 1 .. v_divs.COUNT LOOP
        FOR r IN 1 .. c_runs LOOP
            one_run(v_divs(d), r);
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(c_label || ' 끝 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT LABEL, DIV, RUN_NO, PROC_SEC, FETCH_SEC, TOTAL_SEC, ROW_CNT, COL_CNT, RES_HASH, ERR FROM {LOG} WHERE LABEL = '{label}' ORDER BY DIV, RUN_NO;
"""


COMPARE = f"""-- 40_SPEED_COMPARE — 적용 전 · 적용 후 비교 (조회 전용 · 전체 F5). 기록 = {LOG}
-- 시간 = 회별 중앙값(초). 1회차는 하드파싱이 섞일 수 있어 회별 값은 아래 C2 로 함께 본다.
-- C1 NOTE: 'OK' 이외(오류 · 0행 · 행수 다름 · 결과 해시 다름 · 조건 다름)가 있으면 시간 비교 전에 그 내용을 먼저 확인한다.
-- 판단: 유지 = 90_VERIFY_KEEP · 원복 = 99_ROLLBACK_HINT_PATCH. 어느 쪽이든 끝나면 98_CLEANUP_SPEED_LOG.
SET DEFINE OFF
WITH S AS (
    SELECT LABEL, DIV, COUNT(*) RUNS, COUNT(ERR) ERRS, MEDIAN(PROC_SEC) P, MEDIAN(FETCH_SEC) F, MEDIAN(TOTAL_SEC) T, MIN(TOTAL_SEC) T_MIN, MAX(TOTAL_SEC) T_MAX,
           MIN(ROW_CNT) R_MIN, MAX(ROW_CNT) R_MAX, COUNT(DISTINCT RES_HASH) HN, MIN(RES_HASH) H1, MAX(USER_ID) U, MAX(FROM_YMD) FM, MAX(TO_YMD) TM
      FROM {LOG} GROUP BY LABEL, DIV)
SELECT 'C1' CHK, B.DIV,
       B.T BEFORE_TOTAL, A.T AFTER_TOTAL, A.T - B.T DIFF_TOTAL,
       CASE WHEN B.T > 0 THEN ROUND((A.T - B.T) / B.T * 100, 1) END DIFF_PCT,
       B.P BEFORE_PROC, A.P AFTER_PROC, B.F BEFORE_FETCH, A.F AFTER_FETCH,
       B.T_MIN || '~' || B.T_MAX BEFORE_RANGE, A.T_MIN || '~' || A.T_MAX AFTER_RANGE, B.R_MAX BEFORE_ROWS, A.R_MAX AFTER_ROWS,
       CASE WHEN B.ERRS + A.ERRS > 0 THEN '오류 또는 0행 — C2 확인'
            WHEN B.U <> A.U OR B.FM <> A.FM OR B.TM <> A.TM THEN '조건 다름 — 비교 불가'
            WHEN B.R_MAX <> A.R_MAX OR B.R_MIN <> B.R_MAX OR A.R_MIN <> A.R_MAX THEN '행수 다름 — 원인 확인'
            WHEN B.HN <> 1 OR A.HN <> 1 OR B.H1 <> A.H1 THEN '결과 해시 다름 — 값 변경 또는 측정 중 데이터 변경 확인'
            ELSE 'OK' END NOTE
  FROM S B LEFT JOIN S A ON A.DIV = B.DIV AND A.LABEL = 'AFTER'
 WHERE B.LABEL = 'BEFORE'
 ORDER BY B.DIV;
SELECT 'C2' CHK, LABEL, DIV, RUN_NO, PROC_SEC, FETCH_SEC, TOTAL_SEC, ROW_CNT, COL_CNT, RES_HASH, USER_ID, FROM_YMD, TO_YMD, BODY_DDL, TO_CHAR(RUN_AT, 'HH24:MI:SS') AT_TIME, ERR
  FROM {LOG} ORDER BY DIV, LABEL DESC, RUN_NO;
"""

VERIFY_ROLLED = f"""-- 99_VERIFY_ROLLED_BACK — 원복 확인 (조회 전용 · 전체 F5). 기대: R1 마커 0 · R2 치환자 0 · R3 VALID / 오류 0
SET DEFINE OFF
SELECT 'R1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END JUDGE FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'R2 치환자' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END JUDGE FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%V_HINT82%';
SELECT 'R3 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
"""

CLEANUP = f"""-- 98_CLEANUP_SPEED_LOG — 측정 기록표 삭제 (유지 · 원복 판단이 끝난 뒤 · 전체 F5 · 멱등). 지우기 전 40_COMPARE 결과를 보관한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{LOG}';
    IF n > 0 THEN
        EXECUTE IMMEDIATE 'DROP TABLE {LOG} PURGE';
        DBMS_OUTPUT.PUT_LINE('삭제 {LOG}');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SKIP — {LOG} 없음');
    END IF;
END;
/
"""


def main():
    body, ddl, st, fetched = get_body()
    print('사내 BODY', ddl, st, 'FETCHED', fetched)
    base = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_HINT_20261102\00_BACKUP_PKG_DMF0082_BODY.sql"
    fresh_gate(body, base)
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    for old in os.listdir(os.path.join(HERE, "A_DB")):
        os.remove(os.path.join(HERE, "A_DB", old))
    files = {"00_PRECHECK_CLOUD.sql": gen_precheck(),
             "10_SPEED_BEFORE.sql": gen_measure('BEFORE', False),
             "20_APPLY_HINT_PATCH.sql": gen_apply(ddl, fetched).replace('실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK', '실행 뒤 30_SPEED_AFTER'),
             "30_SPEED_AFTER.sql": gen_measure('AFTER', True),
             "40_SPEED_COMPARE.sql": COMPARE,
             "90_VERIFY_KEEP.sql": VERIFY,
             "98_CLEANUP_SPEED_LOG.sql": CLEANUP,
             "99_ROLLBACK_HINT_PATCH.sql": gen_rollback(),
             "99_VERIFY_ROLLED_BACK.sql": VERIFY_ROLLED}
    for n, t in files.items():
        open(os.path.join(HERE, "A_DB", n), "w", encoding="utf-8", newline="\n").write(t)
        print("WROTE", n, t.count("\n"))


if __name__ == "__main__":
    main()
