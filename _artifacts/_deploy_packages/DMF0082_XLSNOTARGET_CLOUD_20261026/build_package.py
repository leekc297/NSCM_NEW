"""DMF0082_XLSNOTARGET 클라우드 패키지 생성기 — 패치형 (그 DB 의 USER_SOURCE 를 읽어 P_DMF0082_EXCEL_UPLOAD 구간에 검증 1블록 삽입)

[E20261026-DMF0082XLSNOTARGET] 사용자 지시 2026-10-26:
  "81 Excel Upload 에서 Model 을 빼고 올리면 PKG 에 포함된 Model 단가를 올린다. LOC·MKT FCST 등 실제 대상이 없어 올릴 수 없거나
   Division·Team·End Customer·Project·Currency 가 없으면 Validation 에서 SUCCESS 가 아니라 ERROR 로."
  · 저장 분기는 Model 빈칸 행을 사이트(Div+End Customer) × SITE_ITEM(Project) × 품목 부서명(Team)
    × (SCM_MST_FUTURE_PRICE 'LOC' ∪ DM_PLN_SALES_PLAN 'RTF_SYS_RP') INNER JOIN 으로 펼친다 (GT_F020_UPLOAD_MASTER_STEP1).
  · 기존 검증은 Team·End Customer·Project·Currency 를 각각 따로 존재만 보므로 조합이 어긋나면 SUCCESS → 저장 0행이었다.
  · 'Invalid MODEL.' 검사 바로 뒤에 같은 조인으로 대상 Model 0 인 Model 빈칸 행을 ERROR 로 바꾸는 UPDATE 1개를 삽입한다.
  · 개별 값 존재 검사(NULL/Invalid Division·TEAM·END CUSTOMER·PROJECT CODE·CURRENCY)는 원문 그대로 (E2E 로 동작 재확인).

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 는 사내와 타 작업자 반영분이 달라 전체본 교체 금지 → ASCII 앵커 뒤 삽입 / 원복 = 삽입 블록 제거.
FRESH-GATE: 생성 시 사내 DB(USER_SOURCE)를 새로 읽어 기준본으로 삼는다. 리허설(run_rehearsal.py)은 적용 직전 재조회해 기준본과 같을 때만 실행.

  python build_package.py           # 사내 원문 조회 → 백업 + A_DB/*.sql 생성 (DB 무변경)
"""
import os
import sys
from datetime import datetime

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
CORP_DIR = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSNOTARGET_20261026"
MARK = "E20261026-DMF0082XLSNOTARGET"
TAG = "XLSNOTARGET"
PROC_START = "\nPROCEDURE P_DMF0082_EXCEL_UPLOAD\n"
PROC_END = "\nPROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA"
# ASCII 앵커 = 'Invalid MODEL.' 검사 로그 4줄. 블록은 이 뒤에 삽입한다.
ANCHOR = (
    "        V_LOG_MESSAGE := '########## Invalid MODEL. ##########';\n"
    "        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);\n"
    "        D_EVENT_DATE  := SYSDATE;\n"
    "        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;\n"
)
BLOCK = """
        /* #################################################### */
        /* Model 빈칸 행 저장 대상 Model 체크						*/
        /* #################################################### */
        --[E20261026-DMF0082XLSNOTARGET] 사용자 지시 2026-10-26 — Model 빈칸 행은 저장 시 아래 조인으로 Model 을 펼친다
        --  (GT_F020_UPLOAD_MASTER_STEP1): 사이트(Div+End Customer) x SITE_ITEM(Project) x 품목 부서명(Team)
        --  x (SCM_MST_FUTURE_PRICE 'LOC' 또는 DM_PLN_SALES_PLAN 'RTF_SYS_RP').
        --  위 개별 검사는 값마다 따로 존재만 보므로 조합이 어긋나면 SUCCESS 후 저장 0행이었다 -> 같은 조인으로 대상 0 이면 ERROR.
        --  메시지 = 처음 끊긴 단계 (1) End Customer-Project (2) Team (3) LOC/RTF 대상.
        UPDATE SCM_ADM_EXCEL_UPLOAD EU
           SET EU.UPLOAD_STATUS_CODE = 'ERROR'
             , EU.MESSAGE_TEXT       = CASE
                    WHEN NOT EXISTS (
                         SELECT 1
                           FROM SCM_MST_SITE MS
                          INNER JOIN SCM_MST_SITE_ITEM ITM
                             ON ITM.DIVISION_ID  = EU.ATTRIBUTE1
                            AND ITM.PROJECT_CODE = EU.ATTRIBUTE4
                            AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                            AND ITM.VALID_YN     = 'Y'
                          WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1
                            AND MS.END_CUSTOMER = EU.ATTRIBUTE3
                            AND MS.VALID_YN     = 'Y'
                         ) THEN 'No MODEL for END CUSTOMER / PROJECT CODE.'
                    WHEN NOT EXISTS (
                         SELECT 1
                           FROM SCM_MST_SITE MS
                          INNER JOIN SCM_MST_SITE_ITEM ITM
                             ON ITM.DIVISION_ID  = EU.ATTRIBUTE1
                            AND ITM.PROJECT_CODE = EU.ATTRIBUTE4
                            AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                            AND ITM.VALID_YN     = 'Y'
                          INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                             ON DI.DEPT_ID       = ITM.DEPT_ID
                            AND DI.DEPT_NAME_KO  = EU.ATTRIBUTE2
                            AND DI.VALID_YN      = 'Y'
                          WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1
                            AND MS.END_CUSTOMER = EU.ATTRIBUTE3
                            AND MS.VALID_YN     = 'Y'
                         ) THEN 'No MODEL for TEAM / PROJECT CODE.'
                    ELSE 'No Upload Target MODEL (LOC / RTF_SYS_RP).'
                END
         WHERE EU.PROGRAM_ID         = V_PROGRAM_ID
           AND EU.SHEET_NAME         = V_SHEET_NAME
           AND EU.CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(EU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND EU.UPLOAD_STATUS_CODE = 'UPLOAD'
           AND EU.ATTRIBUTE6 IS NULL --item_id 입력 안된건
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SITE MS
                 INNER JOIN SCM_MST_SITE_ITEM ITM
                    ON ITM.DIVISION_ID  = EU.ATTRIBUTE1
                   AND ITM.PROJECT_CODE = EU.ATTRIBUTE4
                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                   AND ITM.VALID_YN     = 'Y'
                 INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                    ON DI.DEPT_ID       = ITM.DEPT_ID
                   AND DI.DEPT_NAME_KO  = EU.ATTRIBUTE2
                   AND DI.VALID_YN      = 'Y'
                 WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1
                   AND MS.END_CUSTOMER = EU.ATTRIBUTE3
                   AND MS.VALID_YN     = 'Y'
                   AND (   EXISTS (SELECT 1
                                     FROM SCM_MST_FUTURE_PRICE FP
                                    WHERE FP.DIVISION_ID  = EU.ATTRIBUTE1
                                      AND FP.PROJECT_CODE = EU.ATTRIBUTE4
                                      AND FP.SCM_SITE_ID  = MS.SCM_SITE_ID
                                      AND FP.ITEM_ID      = ITM.ITEM_ID
                                      AND FP.MEASURE      = 'LOC')
                        OR EXISTS (SELECT 1
                                     FROM DM_PLN_SALES_PLAN PN
                                    WHERE PN.DIVISION_ID  = EU.ATTRIBUTE1
                                      AND PN.PROJECT_CODE = EU.ATTRIBUTE4
                                      AND PN.SCM_SITE_ID  = MS.SCM_SITE_ID
                                      AND PN.ITEM_ID      = ITM.ITEM_ID
                                      AND PN.MEASURE      = 'RTF_SYS_RP')
                       )
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## No Upload Target MODEL. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
"""


def fetch_body(cur):
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    body = "".join(r[0] or "" for r in cur)
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS "
                "WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    last_ddl, status = cur.fetchone()
    return body, last_ddl, status


def span_of(body):
    assert body.count(PROC_START) == 1, f"PROC_START 매칭 {body.count(PROC_START)}"
    assert body.count(PROC_END) == 1, f"PROC_END 매칭 {body.count(PROC_END)}"
    s, e = body.index(PROC_START), body.index(PROC_END)
    assert s < e
    return s, e


def patch(body):
    s, e = span_of(body)
    span = body[s:e]
    assert TAG not in span, "이미 적용됨"
    assert span.count(ANCHOR) == 1, f"ANCHOR 매칭 {span.count(ANCHOR)}"
    span = span.replace(ANCHOR, ANCHOR + BLOCK)
    return body[:s] + span + body[e:]


def unpatch(body):
    s, e = span_of(body)
    span = body[s:e]
    assert span.count(ANCHOR + BLOCK) == 1, "삽입 블록 매칭 != 1"
    span = span.replace(ANCHOR + BLOCK, ANCHOR)
    assert TAG not in span
    return body[:s] + span + body[e:]


def lit(text):
    return "'" + text.replace("'", "''") + "'"


def plsql_lines(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == ""
    return (" ||\n" + indent).join(lit(p) + " || CHR(10)" for p in parts[:-1])


def head():
    return f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET SQLBLANKLINES ON
DECLARE
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_tag   CONSTANT VARCHAR2(20) := '{TAG}';
    c_anc   CONSTANT VARCHAR2(4000) :=
        {plsql_lines(ANCHOR)};
    c_blk   CONSTANT VARCHAR2(32767) :=
        {plsql_lines(BLOCK)};
    v_src   CLOB;
    v_span  CLOB;
    v_new   CLOB;
    v_s     PLS_INTEGER;
    v_e     PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_code  PLS_INTEGER := 0;
    v_msg   VARCHAR2(400);
    v_chk   PLS_INTEGER;
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
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (토큰은 LF 기준)
    IF cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10)) <> 1
       OR cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA') <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'STOP - P_DMF0082_EXCEL_UPLOAD span not found. source unchanged');
    END IF;
    v_s := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10));
    v_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA');
    v_span := SUBSTR(v_src, v_s, v_e - v_s);
"""


# 컴파일 실패 시 원문 자동 복원 — EXECUTE IMMEDIATE 를 BEGIN…EXCEPTION 으로 감싸야 ORA-24344 로 복원 코드가 건너뛰어지지 않는다.
# ⚠ ORA-24344 외 오류(ORA-04021 잠금 대기 시간 초과 등 = 생성 자체 미실행)는 삼키면 원문 VALID 그대로라 '적용됨'으로 오판한다
#   (2026-10-26 리허설 실사고 — 타 세션 PKG 실행 중 pin 대기 15분 후 미적용인데 APPLIED 출력) → 코드 보존 후 중단.
TAIL = """    v_new := SUBSTR(v_src, 1, v_s - 1) || v_span || SUBSTR(v_src, v_e);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        v_code := SQLCODE; v_msg := SUBSTR(SQLERRM, 1, 400);   -- ORA-24344(컴파일 오류 동반 생성)만 아래 STATUS 판정으로 진행
    END;
    IF v_code NOT IN (0, -24344) THEN
        RAISE_APPLICATION_ERROR(-20006, 'STOP - CREATE not executed: ' || v_msg || ' (PKG_DMF0082 in use? retry later). source unchanged');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
        RAISE_APPLICATION_ERROR(-20005, 'COMPILE FAILED -> original restored (now ' || v_st || '). run 90_VERIFY');
    END IF;
    SELECT COUNT(*) INTO v_chk FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, c_tag) > 0;
"""
POST = ("SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL "
        "FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;\n")


def gen_apply(corp_ddl):
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 Excel Upload 검증(P_DMF0082_EXCEL_UPLOAD, p_mode=0)에 'Model 빈칸 행 저장 대상 Model 체크' 1블록 삽입.
--       Model 빈칸 행이 저장 시 펼쳐질 Model 이 0 이면(End Customer·Project·Team 조합 불일치 또는 LOC/RTF_SYS_RP 대상 없음)
--       SUCCESS 대신 ERROR — 'No MODEL for END CUSTOMER / PROJECT CODE.' / 'No MODEL for TEAM / PROJECT CODE.'
--       / 'No Upload Target MODEL (LOC / RTF_SYS_RP).'  (이전: SUCCESS 후 저장 0행)
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 'Invalid MODEL.' 검사 로그 4줄(ASCII 앵커) 뒤에 블록 삽입 후 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 프로시저·다른 줄 무변경).
-- 가드: 표식({TAG}) 존재 시 무동작 · 앵커가 정확히 1곳이 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 기준 원문 LAST_DDL {corp_ddl}. 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{head()}    IF cnt(v_span, c_tag) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied (tag ' || cnt(v_span, c_tag) || '). source unchanged');
        RETURN;
    END IF;
    IF cnt(v_span, c_anc) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - anchor match ' || cnt(v_span, c_anc) || ' (expected 1). run 00_PRECHECK and send result. source unchanged');
    END IF;
    v_span := REPLACE(v_span, c_anc, c_anc || c_blk);
    IF cnt(v_span, c_tag) <> 1 OR cnt(v_span, c_anc || c_blk) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, 'STOP - assembled tag ' || cnt(v_span, c_tag) || ' (expected 1). source unchanged');
    END IF;
{TAIL}    IF v_chk <> 1 THEN
        RAISE_APPLICATION_ERROR(-20007, 'STOP - after CREATE, tag in USER_SOURCE = ' || v_chk || ' (expected 1). run 90_VERIFY');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED - PKG_DMF0082 BODY ' || v_st || ' / {TAG} block 1 / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 삽입 블록 제거 (이 DB 의 USER_SOURCE 를 읽어 블록만 빼고 CREATE OR REPLACE). 전체 F5, 멱등
-- 표식 없으면 무동작. ⚠ 되돌리면 Model 빈칸 행의 대상 Model 이 0 이어도 다시 SUCCESS(저장 0행)가 된다.
{head()}    IF cnt(v_span, c_tag) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - tag not found (not applied). source unchanged');
        RETURN;
    END IF;
    IF cnt(v_span, c_anc || c_blk) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20003, 'STOP - inserted block match ' || cnt(v_span, c_anc || c_blk) || ' (expected 1, block edited?). source unchanged');
    END IF;
    v_span := REPLACE(v_span, c_anc || c_blk, c_anc);
    IF cnt(v_span, c_tag) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'STOP - tag remains after removal ' || cnt(v_span, c_tag) || '. source unchanged');
    END IF;
{TAIL}    IF v_chk <> 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'STOP - after CREATE, tag in USER_SOURCE = ' || v_chk || ' (expected 0). run 90_VERIFY');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK - PKG_DMF0082 BODY ' || v_st || ' / tag 0 / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


SPAN_SQL = """  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.LINE >  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)||' ') = 'PROCEDURE P_DMF0082_EXCEL_UPLOAD')
   AND S.LINE <  (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)||' ') LIKE 'PROCEDURE P!_DMF0082!_GET!_EXCEL!_UPLOAD!_DATA%' ESCAPE '!')"""


def gen_precheck():
    return f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 표식({TAG}) — 적용 전 0 (적용 뒤 1)
-- * [L2] 앵커 'Invalid MODEL.' 검사 로그 줄 — P_DMF0082_EXCEL_UPLOAD 구간에 정확히 1 이어야 10 적용 가능
-- * [L3] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A40
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 TAG' CHK, COUNT(*) N,
       CASE WHEN COUNT(*) = 0 THEN 'NOT APPLIED (expected)' ELSE 'APPLIED - 10 rerun = SKIP' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{TAG}%';
SELECT 'L2 ANCHOR' CHK, COUNT(*) N,
       CASE WHEN COUNT(*) = 1 THEN 'PASS -> 10 can be applied' ELSE 'FAIL - send result' END JUDGE
{SPAN_SQL}
   AND S.TEXT LIKE '%V!_LOG!_MESSAGE := ''########## Invalid MODEL. ##########'';%' ESCAPE '!';
SELECT 'L3 ACTIVE' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""


def gen_verify():
    return f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 표식 1 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 삽입 블록 메시지 3종 = 구간 안 3줄 PASS
-- * 화면 확인: 81 · Model 빈칸 · 대상 없는 조합(예: Team 을 그 Project 품목 부서가 아닌 팀으로) Excel Upload
--   → 결과 ERROR 'No MODEL for TEAM / PROJECT CODE.' · 저장(OK) 불가. 정상 조합은 종전대로 SUCCESS → 저장.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A30
SELECT 'V1 TAG' CHK, COUNT(*) N,
       CASE WHEN COUNT(*) = 1 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (not applied)' ELSE 'FAIL (count)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{TAG}%';
SELECT 'V2 STATUS' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 MSG' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 3 THEN 'PASS' ELSE 'FAIL' END JUDGE
{SPAN_SQL}
   AND (   S.TEXT LIKE '%''No MODEL for END CUSTOMER / PROJECT CODE.''%'
        OR S.TEXT LIKE '%''No MODEL for TEAM / PROJECT CODE.''%'
        OR S.TEXT LIKE '%''No Upload Target MODEL (LOC / RTF!_SYS!_RP).''%' ESCAPE '!');
"""


def main():
    os.makedirs(CORP_DIR, exist_ok=True)
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL")
        host, pdb = cur.fetchone()
        body, last_ddl, status = fetch_body(cur)   # FRESH-GATE 기준본 = 방금 조회한 USER_SOURCE
    body = body.replace("\r\n", "\n")
    fetched = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    assert status == "VALID", status
    s, e = span_of(body)
    assert TAG not in body[s:e], "사내에 이미 적용됨 — 생성기 기준본은 미적용 원문이어야 한다"
    assert BLOCK.count(TAG) == 1, "블록 안 표식은 정확히 1"
    assert ANCHOR.isascii(), "앵커는 ASCII"
    tobe = patch(body)
    assert unpatch(tobe) == body, "왕복 불일치"
    assert tobe.count(TAG) == 1
    stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB={pdb}({host})\n"
    open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.ASIS.sql"), "w", encoding="utf-8", newline="\n").write(
        stamp + "CREATE OR REPLACE " + body + "\n/\n")
    open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.ASIS.raw"), "w", encoding="utf-8", newline="\n").write(body)
    open(os.path.join(CORP_DIR, "PKG_DMF0082_BODY.TOBE.raw"), "w", encoding="utf-8", newline="\n").write(tobe)
    files = {
        "00_PRECHECK_CLOUD.sql": gen_precheck(),
        "10_APPLY_XLSNOTARGET_PATCH.sql": stamp + gen_apply(last_ddl),
        "90_VERIFY.sql": gen_verify(),
        "99_ROLLBACK_XLSNOTARGET_PATCH.sql": stamp + gen_rollback(),
    }
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")
    print(f"DB={pdb}({host}) LAST_DDL={last_ddl} FETCHED={fetched}")
    print(f"BLOCK lines={BLOCK.count(chr(10))}  insert after ANCHOR at span offset {body[s:e].index(ANCHOR)}")


if __name__ == "__main__":
    main()
