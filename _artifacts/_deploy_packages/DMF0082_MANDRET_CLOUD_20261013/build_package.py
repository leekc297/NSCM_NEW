"""DMF0082_MANDRET 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 저장 키 루프 뒤 2곳에 필수 컬럼 루프를 끼워 넣는다)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 와 사내 BODY 는 타 작업자 수정분이 달라 전체본 교체 금지.
삽입 문구는 사내 적용 스크립트(_apply_corporate/DMF0082_MANDRET_20261013/build_apply.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 삽입 문구 2종이 각각 정확히 1회 있는지 확인 — 사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_MANDRET_20261013\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
ANCHOR = corp.ANCHOR
BLK = [corp.block(g) for g in corp.GTT]   # 1 = GET_MAIN_DATA / 2 = GET_MAIN_DATA_CURRENT


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 패키지가 넣을 문구가 각각 1회 존재 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    for i, b in enumerate(BLK, 1):
        if body.count(ANCHOR + b) != 1:
            sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 삽입 문구 {i} 가 {body.count(ANCHOR + b)}회 (1 이어야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_p1    PLS_INTEGER;
    v_p2    PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_nxt   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_anc   CONSTANT VARCHAR2(32767) :=   -- 앵커: 저장 키 강제 추가 루프의 끝 5줄 (두 조회 프로시저에 1회씩)
        {plsql_lit(ANCHOR)};
    c_blk1  CONSTANT VARCHAR2(32767) :=   -- 삽입 1: P_DMF0082_GET_MAIN_DATA (피벗 원천 GT_DMF0082_MF_SP)
        {plsql_lit(BLK[0])};
    c_blk2  CONSTANT VARCHAR2(32767) :=   -- 삽입 2: P_DMF0082_GET_MAIN_DATA_CURRENT (피벗 원천 GTT_MF_SP)
        {plsql_lit(BLK[1])};
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
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)이
--       화면 필수 표시 컬럼을 사용자 Column Set 저장 내역과 무관하게 항상 결과에 넣도록 한다.
--       필수 컬럼 = 컬럼 메타(SCM_MST_SHEET_COLUMNS)에서 USER_SELECTABLE_FLAG = 'N' · VISIBLE_FLAG = 'Y' · VALID_YN = 'Y' 이고
--                   DIVISION_ID 목록에 조회 사업부가 들어 있는 컬럼 (화면이 항상 표시하는 것과 같은 규칙)
-- 배경: AS From Site 를 필수 표시로 바꾼 뒤 컬럼은 보이는데 값이 빈칸 (클라우드 QA 10-13 minyonglee1 — Column Set 저장 내역에 이 컬럼 없음).
--       조회 SP 는 Column Set 저장 내역에 있는 컬럼과 저장 키 12컬럼만 내려주고 있었다.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 저장 키 루프 뒤 2곳에 루프를 끼워 넣은 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 2건 아니거나 위치가 두 조회 프로시저와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 삽입 · 전후 비교 12케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 저장 키 루프 끝 앵커 매칭 ' || cnt(v_src, c_anc) || '건 (2 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_p1  := DBMS_LOB.INSTR(v_src, c_anc, 1, 1);
    v_p2  := DBMS_LOB.INSTR(v_src, c_anc, 1, 2);
    v_cur := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_nxt := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_cur > 0 AND v_nxt > 0 AND v_p1 < v_cur AND v_cur < v_p2 AND v_p2 < v_nxt) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름. 원문 무변경');
    END IF;
    -- 뒤쪽(2번째)부터 끼워 넣는다 — 앞쪽 위치가 밀리지 않게
    v_new := DBMS_LOB.SUBSTR(v_src, 1, 1);   -- CLOB 초기화용 (아래에서 다시 조립)
    v_new := SUBSTR(v_src, 1, v_p1 + LENGTH(c_anc) - 1) || c_blk1
          || SUBSTR(v_src, v_p1 + LENGTH(c_anc), v_p2 - v_p1)
          || c_blk2
          || SUBSTR(v_src, v_p2 + LENGTH(c_anc));
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_anc || c_blk1) <> 1 OR cnt(v_new, c_anc || c_blk2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 끼워 넣은 2곳을 걷어낸 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 걷어낸 뒤 마커 0 이어야 실행. ⚠ 되돌리면 필수 표시 컬럼이 Column Set 저장 내역에 없는 사용자에게 다시 빈칸으로 나온다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc || c_blk1) <> 1 OR cnt(v_src, c_anc || c_blk2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_anc || c_blk1) || ' · ' || cnt(v_src, c_anc || c_blk2) || '건 (각 1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_anc || c_blk1, c_anc);
    v_new := REPLACE(v_new, c_anc || c_blk2, c_anc);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


MAND_SQL = """SELECT '{tag}' CHK, C.COLUMN_NAME, SUBSTR(C.DIVISION_ID, 1, 44) DIVISIONS
     , CASE WHEN C.COLUMN_NAME IN ('DIVISION_ID','PROJECT_CODE','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','DOM_EXP','FCST_TYPE','INCOTERMS','MEASURE','PLANT_SITE_ID','CELL_PROD_SITE_ID','CURRENCY')
            THEN '저장 키 (종전부터 항상 반환)'
            WHEN EXISTS (SELECT 1 FROM USER_TAB_COLUMNS T WHERE T.TABLE_NAME = 'GT_DMF0082_MF_SP' AND T.COLUMN_NAME = C.COLUMN_NAME)
            THEN '항상 반환 대상 (이미 결과에 있으면 그대로)'
            ELSE '조회 원천에 없는 컬럼 — 패치 대상 아님' END JUDGE
     , (SELECT COUNT(DISTINCT U.USER_ID) FROM SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = C.PROGRAM_ID AND U.SHEET_NAME = C.SHEET_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C') USERS_WITH_SET
     , (SELECT COUNT(DISTINCT U.USER_ID) FROM SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = C.PROGRAM_ID AND U.SHEET_NAME = C.SHEET_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' AND U.COLUMN_NAME = C.COLUMN_NAME) USERS_HAVING_COL
  FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice'
   AND C.VALID_YN = 'Y' AND C.USER_SELECTABLE_FLAG = 'N' AND C.VISIBLE_FLAG = 'Y'
 ORDER BY 4, C.COLUMN_NAME;
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 패치 앵커 — 저장 키 목록 줄이 2건(두 조회 프로시저에 1건씩)이어야 10 적용 가능 + 줄 번호
-- * [L2] 마커 — 적용 전 0 (적용 뒤 2)
-- * [L3] 필수 표시 컬럼 목록 — 어떤 컬럼이 항상 반환 대상인지, Column Set 을 저장한 사용자 중 그 컬럼을 가진 사용자 수
--        (USERS_WITH_SET - USERS_HAVING_COL = 지금 그 컬럼이 빈칸으로 나오는 사용자 수. Column Set 을 저장한 적 없는 사용자도 해당)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A60
COLUMN COLUMN_NAME FORMAT A22
COLUMN DIVISIONS FORMAT A44
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커' CHK, COUNT(*) N, MIN(S.LINE) LINE_1, MAX(S.LINE) LINE_2,
       CASE WHEN COUNT(*) = 2 THEN 'PASS → 10 적용 가능 (최종 판정은 10 이 5줄 전체로 한다)' ELSE 'FAIL — 2건이 아님 → 중단·회신' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.TEXT LIKE '%FOR K IN (SELECT REGEXP_SUBSTR(''DIVISION_ID,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,CURRENCY''%';
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
{MAND_SQL.format(tag='L3 필수')}SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(2) · V2 VALID/오류 0 · V3 마커 2줄(두 조회 프로시저에 1줄씩) · V4 필수 컬럼 목록에 '항상 반환 대상' 표시
-- * 화면 확인: Column Set 에 AS From Site 를 넣지 않은 계정으로 81 또는 82 를 조회해 AS From Site 값이 보이는지 본다.
--   (값이 없는 품목은 빈칸이 정상이다. 원장에 값이 있는 품목으로 확인한다.)
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A60
COLUMN COLUMN_NAME FORMAT A22
COLUMN DIVISIONS FORMAT A44
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 줄' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND ( S.TEXT LIKE '%{MARK}%' OR S.TEXT LIKE '%FROM USER_TAB_COLUMNS T WHERE T.TABLE_NAME = ''G%MF_SP''%' )
 ORDER BY S.LINE;
{MAND_SQL.format(tag='V4 필수')}"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_MANDRET_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_MANDRET_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
