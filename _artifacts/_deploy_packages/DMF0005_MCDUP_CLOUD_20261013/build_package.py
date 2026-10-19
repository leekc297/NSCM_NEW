"""DMF0005_MCDUP 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 키 중복 사전 검증 3곳을 끼워 넣는다)

왜 패치형인가: 클라우드 PKG_DMF0005 BODY 는 사내 BODY 와 줄 수는 같아도 내용이 다르다(10-13 지문 불일치) → 전체본 교체 금지.
치환 문구(앵커/신규)는 사내 적용 스크립트(_apply_corporate/DMF0005_MCDUP_20261013/build_apply.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 신규 문구 3종이 각각 정확히 1회 있는지 확인 — 사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0005_MCDUP_20261013\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
PAIRS = [("변경 이력 줄", corp.A_HIST, corp.N_HIST),
         ("CHANGE_TABLE 설명 주석", corp.A_PROC, corp.N_PROC),
         ("CHANGE_TABLE 대상 0건 반환", corp.A_CALL, corp.N_CALL)]
N_MARK = sum(n.count(corp.MARK) for _, _, n in PAIRS)   # 적용 뒤 마커 수


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 패키지가 넣을 신규 문구가 각각 1회 존재 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0005' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0005' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    for name, old, new in PAIRS:
        if body.count(new) != 1:
            sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 '{name}' 적용 문구 {body.count(new)}회 (1 이어야 함)")
    if body.count(corp.MARK) != N_MARK:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 마커 {body.count(corp.MARK)}곳 ({N_MARK} 이어야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl, "마커", N_MARK)
    return last_ddl


CONSTS = "".join(
    f"    c_old{i}  CONSTANT VARCHAR2(32767) :=   -- 앵커 {i}: {name}\n        {plsql_lit(old)};\n"
    f"    c_new{i}  CONSTANT VARCHAR2(32767) :=\n        {plsql_lit(new)};\n"
    for i, (name, old, new) in enumerate(PAIRS, 1))

HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
{CONSTS}    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
"""

TAIL = """    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0005' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0005' ORDER BY OBJECT_TYPE;\n"


def gen_apply(corp_ddl):
    chk = "".join(
        f"    IF cnt(v_src, c_old{i}) <> 1 THEN\n"
        f"        RAISE_APPLICATION_ERROR(-2000{i}, '중단 — 앵커 {i}({name}) 매칭 ' || cnt(v_src, c_old{i}) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 확인. 원문 무변경');\n"
        f"    END IF;\n" for i, (name, _, _) in enumerate(PAIRS, 1))
    rep = "    v_new := v_src;\n" + "".join(f"    v_new := REPLACE(v_new, c_old{i}, c_new{i});\n" for i in range(1, len(PAIRS) + 1))
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0005 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0005_SAVE_MODEL_CHANGE_POPUP (Model Code Change 팝업 저장)에 키 중복 사전 검증을 더한다.
--       변경 전 Model 과 같은 키에 변경 후 Model 이 이미 등록돼 있으면 갱신 전에 검증 메시지로 차단한다.
--       "변경 후 Model 코드가 같은 키로 이미 등록되어 있어 변경할 수 없습니다. / MODEL / TABLE / KEY"
-- 배경: 클라우드 QA 10-13 13:17 · 13:21 저장이 ORA-00001 (PK_SCM_MST_SITE_ITEM) 로 실패 — 화면에는 SQL ERROR 만 표시.
--       AS-IS 도 같은 데이터에서는 저장 실패(전체 ROLLBACK)라 저장 불가 결과는 같다. 안내 문구만 더한다.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 3곳에 끼워 넣은 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
--       ① 변경 이력 1줄 ② 내부 프로시저 CHECK_DUP 신설 ③ CHANGE_TABLE 에서 갱신 직전 호출 1줄
-- 가드: 마커 존재 시 무동작 · 앵커 3종 각 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 치환 · 판정 대조 7 시나리오 × 38 테이블 · 실호출 2건 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
{chk}{rep}    IF cnt(v_new, c_mark) <> {N_MARK} THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 ({N_MARK} 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0005 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    chk = "".join(
        f"    IF cnt(v_src, c_new{i}) <> 1 THEN\n"
        f"        RAISE_APPLICATION_ERROR(-2000{i}, '중단 — 적용 문구 {i}({name}) 매칭 ' || cnt(v_src, c_new{i}) || '건 (1 기대). 원문 무변경');\n"
        f"    END IF;\n" for i, (name, _, _) in enumerate(PAIRS, 1))
    # 역치환은 적용의 역순 (신규 문구가 앵커를 포함하므로 긴 것부터 되돌린다)
    rep = "    v_new := v_src;\n" + "".join(f"    v_new := REPLACE(v_new, c_new{i}, c_old{i});\n" for i in range(len(PAIRS), 0, -1))
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 끼워 넣은 3곳을 걷어낸 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 키가 겹치는 변경은 다시 ORA-00001 (화면 SQL ERROR) 로 실패한다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
{chk}{rep}    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0005 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def q(s):
    return s.rstrip("\n").replace("'", "''")


ANCH_SQL = "\nUNION ALL\n".join(
    f"SELECT 'L1 앵커{i}' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL — 없음 (이미 적용이면 L2 = {N_MARK}) → 중단·회신' ELSE 'FAIL — 2건↑ → 중단·회신' END JUDGE\n"
    f"  FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0005' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{q(line)}'"
    for i, line in enumerate([corp.A_HIST, corp.A_PROC, "        IF V_RIDS.COUNT = 0 THEN\n"], 1))

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0005 상태·LAST_DDL
-- * [L1] 패치 앵커 3종 — 각 1건이어야 10 적용 가능 (앵커3 은 3줄 묶음의 첫 줄만 센다 — 최종 판정은 10 이 3줄 전체로 한다)
-- * [L2] 마커 — 적용 전 0 (적용 뒤 {N_MARK})
-- * [L3] 검증 대상이 되는 유일 인덱스 — 갱신 대상 38개 테이블 중 ITEM_ID 를 포함한 것 (사내는 17개)
-- * [L4] 최근 저장 실패 기록 — ORA-00001 로 실패한 건 (적용 뒤에는 INVALID 로 기록된다)
-- * [L5] 지금 PKG_DMF0005 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A70
COLUMN TABLE_NAME FORMAT A34
COLUMN INDEX_NAME FORMAT A36
COLUMN COLS FORMAT A120
COLUMN MSG FORMAT A100
COLUMN DESCR FORMAT A100
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0005' ORDER BY O.OBJECT_TYPE;
{ANCH_SQL};
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0005' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 키' CHK, I.TABLE_NAME, I.INDEX_NAME,
       (SELECT LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) FROM USER_IND_COLUMNS C WHERE C.INDEX_NAME = I.INDEX_NAME) COLS
  FROM USER_INDEXES I
 WHERE I.UNIQUENESS = 'UNIQUE'
   AND EXISTS (SELECT 1 FROM USER_IND_COLUMNS C WHERE C.INDEX_NAME = I.INDEX_NAME AND C.COLUMN_NAME = 'ITEM_ID')
   AND I.TABLE_NAME IN ( 'DM_ANL_KPI_RTF_DEMAND', 'DM_ANL_KPI_RTF_SALES', 'DM_ANL_KPI_SALES_ACCURACY', 'DM_ANL_KPI_SUMMARY'
       , 'DM_DNM_EDI_CALLOFF_ITEM', 'DM_DNM_SALES_RESULT_IF', 'DM_HI_CUST_FCST_INPUT', 'DM_HI_MKT_FCST_CHANGE'
       , 'DM_HI_SALES_INPUT', 'DM_HI_SITE_ITEM_MAPPING', 'DM_HI_SITE_ITEM_MAPPING_ROWDATA'
       , 'DM_MST_BUCKET_CONVERSION', 'DM_MST_BUCKET_CONVERSION_H', 'DM_MST_CAPACITY_ALLOCATION', 'DM_MST_CAPACITY_ALLOCATION_H'
       , 'DM_MST_CUSTOMER_MODEL', 'DM_MST_CUSTOMER_MODEL_H', 'DM_MST_EDI_CUST_MATERIAL_INFO'
       , 'DM_PLN_BP_FCST', 'DM_PLN_BP_FCST_H', 'DM_PLN_CUSTOMER_PSI', 'DM_PLN_CUSTOMER_PSI_H'
       , 'DM_PLN_MKT_FCST', 'DM_PLN_MKT_FCST_CONFIRM', 'DM_PLN_MKT_FCST_H', 'DM_PLN_MKT_FCST_PK_DATA_UPDATE_H'
       , 'DM_PLN_MKT_FCST_RESULT', 'DM_PLN_PR_DETAIL', 'DM_PLN_SALES_PLAN', 'DM_PLN_SALES_PLAN_H'
       , 'DM_PLN_SALES_PLAN_REPORT_H', 'DM_PLN_SALES_PLAN_RESULT', 'SCM_MST_FUTURE_PRICE', 'SCM_MST_FUTURE_PRICE_H'
       , 'SCM_MST_SITE_ITEM', 'SCM_MST_SITE_ITEM_H', 'SCM_MST_SITE_ITEM_PRIORITY', 'SCM_MST_SITE_ITEM_PRIORITY_H' )
 ORDER BY I.TABLE_NAME, I.INDEX_NAME;
SELECT 'L4 실패' CHK, L.T, L.LOG_TYPE, L.MSG, L.DESCR
  FROM (SELECT TO_CHAR(B.EVENT_DATE,'MM-DD HH24:MI:SS') T, B.LOG_TYPE
             , SUBSTR(REPLACE(B.LOG_MESSAGE, CHR(10), ' '), 1, 100) MSG, SUBSTR(REPLACE(B.DESCRIPTION, CHR(10), ' '), 1, 100) DESCR
          FROM SCM_SYS_LOG_BATCH B
         WHERE B.PROGRAM_NAME = 'PKG_DMF0005' AND B.LOG_TYPE IN ('ERROR', 'INVALID')
         ORDER BY B.EVENT_DATE DESC) L
 WHERE ROWNUM <= 10;
SELECT 'L5 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0005' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] V1~V3 조회 전용 · V4 = 키가 겹치는 변경쌍 1건으로 저장 SP 호출 → 검증 메시지로 차단되는지 확인
-- * 기대: V1 마커 PASS({N_MARK}) · V2 VALID/오류 0 · V3 CHECK_DUP 호출 줄 · V4 'PASS — 검증 메시지로 차단'
-- * V4 는 **마커가 있을 때만** 호출한다.
--   시험 변경쌍 = SCM_MST_SITE_ITEM(40)에서 같은 Division·Project·Site 에 앞 11자리가 같은 Model 두 개가 함께 등록된 것.
--   이 쌍은 키가 겹치므로 저장이 성공할 수 없다(검증으로 막히거나, 막히지 않아도 ORA-00001 로 전체 ROLLBACK) → 데이터가 바뀌지 않는다.
--   품목 마스터에 없는 코드면 앞 단계 검증('존재하지 않는 코드')에서 먼저 막히므로 다음 쌍으로 넘어간다 (최대 20 쌍).
--   호출 중에는 앞선 대상 테이블 갱신이 잠깐 수행됐다가 되돌려진다 (사내 4~14초).
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = {N_MARK} THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0005' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0005')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0005' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 줄' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0005' AND S.TYPE='PACKAGE BODY' AND S.TEXT LIKE '%{MARK}%'
 ORDER BY S.LINE;
DECLARE
    n_mark PLS_INTEGER;
    n_try  PLS_INTEGER := 0;
    v_done BOOLEAN := FALSE;
    rc     SYS_REFCURSOR;
    v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(400);
    n_b    PLS_INTEGER; n_a PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n_mark FROM USER_SOURCE WHERE NAME='PKG_DMF0005' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
    IF n_mark = 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 미적용 상태 (10 적용 뒤 다시 실행)');
        RETURN;
    END IF;
    FOR k IN (SELECT B.ITEM_ID AS BEF, A.ITEM_ID AS AFT, COUNT(*) AS KEYS
                FROM SCM_MST_SITE_ITEM B
                JOIN SCM_MST_SITE_ITEM A ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                        AND A.ITEM_ID <> B.ITEM_ID AND SUBSTR(A.ITEM_ID, 1, 11) = SUBSTR(B.ITEM_ID, 1, 11)
               WHERE B.DIVISION_ID = '40' AND B.ITEM_ID LIKE 'MP%' AND LENGTH(B.ITEM_ID) = 12 AND LENGTH(A.ITEM_ID) = 12
                 AND B.ITEM_ID = UPPER(B.ITEM_ID) AND A.ITEM_ID = UPPER(A.ITEM_ID)
               GROUP BY B.ITEM_ID, A.ITEM_ID
               ORDER BY COUNT(*), B.ITEM_ID, A.ITEM_ID FETCH FIRST 20 ROWS ONLY) LOOP
        EXIT WHEN v_done;
        n_try := n_try + 1;
        SELECT COUNT(*) INTO n_b FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID = '40' AND ITEM_ID = k.BEF;
        SCM_MGR.PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP(
            '[{{"ITEM_ID_BEFORE":"' || k.BEF || '","ITEM_ID_AFTER":"' || k.AFT || '"}}]', 'minyonglee1', rc);
        FETCH rc INTO v_code, v_msg, v_evt;
        CLOSE rc;
        ROLLBACK;
        SELECT COUNT(*) INTO n_a FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID = '40' AND ITEM_ID = k.BEF;
        DBMS_OUTPUT.PUT_LINE('V4 시도 ' || n_try || ' = ' || k.BEF || ' -> ' || k.AFT || ' (겹치는 키 ' || k.KEYS || ') → ' || v_code || ' | ' || REPLACE(SUBSTR(v_msg, 1, 200), CHR(10), ' / '));
        IF n_a <> n_b THEN
            DBMS_OUTPUT.PUT_LINE('V4 FAIL — 변경 전 Model 행 수가 달라짐 (' || n_b || ' → ' || n_a || ')');
            v_done := TRUE;
        ELSIF v_code = '-1' AND INSTR(v_msg, '이미 등록되어') > 0 THEN
            DBMS_OUTPUT.PUT_LINE('V4 PASS — 검증 메시지로 차단 · 변경 전 Model 행 수 ' || n_b || ' → ' || n_a);
            v_done := TRUE;
        END IF;
    END LOOP;
    IF NOT v_done THEN
        DBMS_OUTPUT.PUT_LINE('V4 N/A — 키 중복 검증까지 도달한 시험 쌍 없음 (시도 ' || n_try || '건 — 겹치는 쌍이 없거나 모두 앞 단계 검증에서 차단). V1~V3 으로 판정');
    END IF;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('V4 FAIL — ' || REPLACE(SUBSTR(SQLERRM, 1, 300), CHR(10), ' / '));
END;
/
"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_MCDUP_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_MCDUP_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
