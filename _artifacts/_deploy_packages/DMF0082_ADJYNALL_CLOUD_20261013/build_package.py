"""DMF0082_ADJYNALL 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 단가 검증 제외조건 8줄을 주석 처리)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 와 사내 BODY 는 타 작업자 수정분이 달라 전체본 교체 금지.
치환 문구(OLD/NEW)는 사내 적용 스크립트(_apply_corporate/DMF0082_ADJYNALL_20261013/build_apply.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 NEW 문구가 정확히 1회 있는지 확인 — 사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_ADJYNALL_20261013\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
OLD, NEW = corp.OLD, corp.NEW


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 패키지가 넣을 NEW 문구가 1회 존재 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    if body.count(NEW) != 1 or body.count(OLD) != 0:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 적용 문구 {body.count(NEW)}회 · 원문 {body.count(OLD)}회 (1 · 0 이어야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_old   CONSTANT VARCHAR2(32767) :=   -- 단가 검증 제외조건 8줄 (원문)
        {plsql_lit(OLD)};
    c_new   CONSTANT VARCHAR2(32767) :=   -- 같은 8줄을 줄 주석 처리 + 설명 2줄
        {plsql_lit(NEW)};
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
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
"""

TAIL = """    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;\n"


def gen_apply(corp_ddl):
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0082_SAVE_MAIN_DATA 단가 검증(#10 Sales Price 해당 주차 확인)에서
--       'Site-Item 마스터에 SALES_PLAN_ADJUST_YN = N 인 품목은 검사 제외' 조건 8줄을 주석 처리한다.
--       → 판매계획 조정 제외 품목도 그 주에 판가가 없으면 'Unit Price Not Found !' 로 저장 차단.
-- 배경: 클라우드 QA 10-12 — 40 · AJ상사_AB_TES · MCCM356015A2 · Aima 가 오창A 판가 없이 MKT_FCST 저장됨(품목 플래그 N).
--       사용자 요청(2026-10-13): 플래그가 N 이어도 단가 검증 적용. AS-IS 도 같은 예외를 두고 있어 AS-IS 대비 의도적 강화.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 그 8줄만 주석으로 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 치환 · 문장 전후 비교 5케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 제외조건 앵커 매칭 ' || cnt(v_src, c_old) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (1 기대)');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 주석 처리한 8줄을 되살린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 조정 제외(N) 품목은 다시 판가 없이 저장된다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_new) || '건 (1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_new, c_old);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 BODY 상태·LAST_DDL
-- * [L1] 패치 앵커 — 단가 검증 제외조건의 마지막 줄(주석 아닌 실행 줄)이 1건이어야 10 적용 가능 + 그 앞 문맥
-- * [L2] 마커 — 적용 전 0 (적용 뒤 1)
-- * [L3] 영향 품목 — Site-Item 마스터에서 SALES_PLAN_ADJUST_YN = N 인 유효 품목 (적용 뒤 이 품목들이 단가 검증 대상이 된다)
-- * [L4] 영향 미리보기 — 위 품목의 오늘 이후 수요(검증 대상 메저) 중 '그 주 · 같은 키' 판가가 없는 주 수
--        (이미 저장된 데이터는 그대로다. 그 품목·그 주에 수량을 새로 넣거나 고칠 때 판가가 없으면 막힌다)
-- * [L5] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A70
COLUMN PROJECT_CODE FORMAT A24
COLUMN SCM_SITE_ID FORMAT A30
COLUMN ITEM_ID FORMAT A24
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커' CHK, COUNT(*) N,
       CASE WHEN COUNT(*) = 1 THEN 'PASS → 10 적용 가능' WHEN COUNT(*) = 0 THEN 'FAIL — 앵커 없음 (이미 적용이면 L2=1) → 중단·회신' ELSE 'FAIL — 앵커 2건↑ → 중단·회신' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '                             AND Z.SALES_PLAN_ADJUST_YN = ''N'')';
SELECT 'L1 문맥' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MAX(LINE) - 9 FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%AND Z.SALES_PLAN_ADJUST_YN = ''N'')%')
                  AND (SELECT MAX(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%AND Z.SALES_PLAN_ADJUST_YN = ''N'')%')
 ORDER BY S.LINE;
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 품목' CHK, S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.VALID_YN, S.SALES_PLAN_ADJUST_YN ADJ_YN,
       TO_CHAR(S.LAST_UPDATE_DATE,'YYYY-MM-DD') UPD
  FROM SCM_MST_SITE_ITEM S
 WHERE S.SALES_PLAN_ADJUST_YN = 'N' AND S.VALID_YN = 'Y' AND (S.DIVISION_ID = '40' OR S.DIVISION_ID LIKE '81%')
 ORDER BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID FETCH FIRST 100 ROWS ONLY;
SELECT 'L4 영향' CHK, COUNT(DISTINCT D.PROJECT_CODE || '|' || D.SCM_SITE_ID || '|' || D.ITEM_ID) ITEMS, COUNT(*) WEEKS_WITH_QTY,
       SUM(CASE WHEN NOT EXISTS (SELECT 1 FROM DM_PLN_CFM_SELLING_PRICE P
                                  WHERE P.DIVISION_ID = D.DIVISION_ID AND P.PROJECT_CODE = D.PROJECT_CODE AND P.END_CUSTOMER = D.END_CUSTOMER
                                    AND P.SCM_SITE_ID = D.SCM_SITE_ID AND P.PLANT_SITE_ID = D.PLANT_SITE_ID AND P.CELL_PROD_SITE_ID = D.CELL_PROD_SITE_ID
                                    AND P.ITEM_ID = D.ITEM_ID AND P.DOM_EXP = D.DOM_EXP AND P.FCST_TYPE = D.FCST_TYPE AND P.INCOTERMS = D.INCOTERMS
                                    AND P.MEASURE = 'LOC' AND P.PRICE > 0 AND P.YYYYMMDD = D.WEEK_START)
                THEN 1 ELSE 0 END) WEEKS_NO_PRICE
  FROM (SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID,
                        A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, C.BASIS_START_DATE WEEK_START
          FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
          JOIN SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = A.YYYYMMDD
          JOIN SCM_MST_SITE_ITEM S ON S.DIVISION_ID = A.DIVISION_ID AND S.PROJECT_CODE = A.PROJECT_CODE AND S.SCM_SITE_ID = A.SCM_SITE_ID AND S.ITEM_ID = A.ITEM_ID
                                  AND S.VALID_YN = 'Y' AND S.SALES_PLAN_ADJUST_YN = 'N'
         WHERE A.DIVISION_ID = '40' AND A.YYYYMMDD >= TO_CHAR(SYSDATE,'YYYYMMDD') AND A.QTY <> 0
           AND A.MEASURE IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE' AND SEGMENT1 = 'MEASURE' AND VALID_YN = 'Y')) D;
SELECT 'L5 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] V1~V3 조회 전용 · V4 = 조정 제외(N) 품목의 '판가 없는 주' 신규 수량 1건으로 저장 SP 호출 → 단가 검증 차단 확인
-- * 기대: V1 마커 PASS · V2 VALID/오류 0 · V3 주석 처리된 8줄 · V4 'PASS — 단가 검증으로 차단 · 원장 0 → 0'
-- * V4 는 **마커가 있을 때만** 호출한다 (미적용 상태에서 호출하면 시험 행이 저장된다).
--   시험 키 = 마스터의 조정 제외(N) 유효 품목(40) 중에서 고르고, 일자 = 8주 뒤 월요일. 그 (키, 일자)의 수요와 그 주 판가가 0건일 때만 호출.
--   앞 단계 검증(Biz Type 등)에 먼저 걸리는 품목은 다음 품목으로 넘어간다 (최대 20 품목). 호출마다 ROLLBACK, 호출 뒤 건수 재확인.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A150
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL (미적용)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 블록' CHK, S.LINE, SUBSTR(RTRIM(S.TEXT, CHR(10)||CHR(13)),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') + 9
 ORDER BY S.LINE;
DECLARE
    n_mark PLS_INTEGER;
    v_ymd  VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'IW') + 56, 'YYYYMMDD');
    v_wk   VARCHAR2(8);
    n_b    PLS_INTEGER; n_a PLS_INTEGER;
    n_try  PLS_INTEGER := 0;
    v_done BOOLEAN := FALSE;
    rc     SYS_REFCURSOR;
    v_code VARCHAR2(100); v_msg VARCHAR2(4000); v_evt VARCHAR2(400);
    FUNCTION ledger_cnt(p_div VARCHAR2, p_prj VARCHAR2, p_site VARCHAR2, p_item VARCHAR2) RETURN PLS_INTEGER IS
        n1 PLS_INTEGER; n2 PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO n1 FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = p_div AND PROJECT_CODE = p_prj AND SCM_SITE_ID = p_site AND ITEM_ID = p_item AND YYYYMMDD = v_ymd;
        SELECT COUNT(*) INTO n2 FROM DM_PLN_CFM_SELLING_PRICE   WHERE DIVISION_ID = p_div AND PROJECT_CODE = p_prj AND SCM_SITE_ID = p_site AND ITEM_ID = p_item AND YYYYMMDD IN (v_ymd, v_wk);
        RETURN n1 + n2;
    END;
BEGIN
    SELECT COUNT(*) INTO n_mark FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
    IF n_mark = 0 THEN
        DBMS_OUTPUT.PUT_LINE('V4 SKIP — 미적용 상태 (10 적용 뒤 다시 실행)');
        RETURN;
    END IF;
    SELECT NVL(MAX(BASIS_START_DATE), v_ymd) INTO v_wk FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = v_ymd;
    FOR k IN (SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID
                FROM SCM_MST_SITE_ITEM S
               WHERE S.DIVISION_ID = '40' AND S.VALID_YN = 'Y' AND S.SALES_PLAN_ADJUST_YN = 'N'
                 AND EXISTS (SELECT 1 FROM SCM_MST_ITEM_SN N WHERE N.DIVISION_ID = S.DIVISION_ID AND N.ITEM_ID = S.ITEM_ID AND N.ACTIVE_FLAG = 'Y')
               ORDER BY S.LAST_UPDATE_DATE DESC, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID FETCH FIRST 20 ROWS ONLY) LOOP
        EXIT WHEN v_done;
        n_b := ledger_cnt(k.DIVISION_ID, k.PROJECT_CODE, k.SCM_SITE_ID, k.ITEM_ID);
        IF n_b = 0 THEN
            n_try := n_try + 1;
            SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA('I', k.DIVISION_ID, k.PROJECT_CODE, k.PROJECT_CODE, k.SCM_SITE_ID, k.ITEM_ID, 'E', 'MPS', 'CPT', 'MKT_FCST', '-', 'HQ06-A', v_ymd, '', '1', 'minyonglee1', '', rc);
            FETCH rc INTO v_code, v_msg, v_evt;
            CLOSE rc;
            ROLLBACK;
            n_a := ledger_cnt(k.DIVISION_ID, k.PROJECT_CODE, k.SCM_SITE_ID, k.ITEM_ID);
            DBMS_OUTPUT.PUT_LINE('V4 시도 ' || n_try || ' = ' || k.DIVISION_ID || ' / ' || k.PROJECT_CODE || ' / ' || k.SCM_SITE_ID || ' / ' || k.ITEM_ID || ' / ' || v_ymd
                                 || ' → ' || v_code || ' | ' || REPLACE(SUBSTR(v_msg,1,160), CHR(10), ' / '));
            IF n_a <> 0 THEN
                DBMS_OUTPUT.PUT_LINE('V4 FAIL — 막히지 않고 저장됨(' || n_a || '건). 위 시도 키·일자의 행을 정리해야 함');
                v_done := TRUE;
            ELSIF INSTR(v_msg, 'Unit Price Not Found') > 0 THEN
                DBMS_OUTPUT.PUT_LINE('V4 PASS — 단가 검증으로 차단 · 원장 0 → 0');
                v_done := TRUE;
            END IF;
        END IF;
    END LOOP;
    IF NOT v_done THEN
        DBMS_OUTPUT.PUT_LINE('V4 N/A — 단가 검증까지 도달한 시험 품목 없음 (시도 ' || n_try || '건 모두 앞 단계 검증에서 차단 또는 대상 품목 없음). V1~V3 으로 판정');
    END IF;
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('V4 FAIL — ' || REPLACE(SUBSTR(SQLERRM,1,300), CHR(10), ' / '));
END;
/
"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_ADJYNALL_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_ADJYNALL_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
