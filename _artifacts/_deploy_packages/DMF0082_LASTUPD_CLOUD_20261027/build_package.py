"""DMF0082_LASTUPD 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 2곳에 블록을 끼워 넣는다)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 와 사내 BODY 는 타 작업자 수정분 · 센티널 세대가 달라 전체본 교체 금지.
삽입 블록은 사내 적용 스크립트(_apply_corporate/DMF0082_LASTUPD_20261027/build_apply.py)에서 그대로 가져온다.
앵커는 ASCII 만 (클라우드 문자셋 차이 회피):
  - GET_MAIN_DATA        : [E20260918-KEYCOLGRAIN2] MERGE 끝 3줄 **뒤**에 삽입 (사내 적용 위치와 동일)
  - GET_MAIN_DATA_CURRENT: 피벗 IN 리스트 빈값 방어 IF 4줄 **앞**에 삽입 (사내 위치 = CURRNORM UPDATE 뒤. 그 줄은 센티널 세대마다 달라 앵커로 쓰지 않음.
                           두 위치 사이에는 주석뿐이라 동작 동일)
원복 = 삽입 블록 문구를 위치와 무관하게 걷어낸다 (사내 · 클라우드 모두 동작).
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE) 현재 BODY 에 두 블록이 각각 정확히 1회 있는지 확인 — 사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPD_20261027\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
BLK_GET = corp.HEAD + corp.BODY_GET + corp.TAIL
BLK_CUR = corp.HEAD + corp.BODY_CUR + corp.TAIL
A_GET = corp.ANCHOR_GET
A_CUR = ("    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN\n"
         "        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;\n"
         "        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;\n"
         "        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;\n")
assert all(ord(ch) < 128 for ch in A_GET + A_CUR), "앵커는 ASCII 여야 함"


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 패키지가 넣을 블록이 각각 1회 존재 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    for nm, b in (("GET", BLK_GET), ("CURRENT", BLK_CUR)):
        if body.count(b) != 1:
            sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 {nm} 블록이 {body.count(b)}회 (1 이어야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_pg    PLS_INTEGER;
    v_pc    PLS_INTEGER;
    v_get_e PLS_INTEGER;
    v_cur_s PLS_INTEGER;
    v_cur_e PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_ag    CONSTANT VARCHAR2(32767) :=   -- 앵커 1: GET_MAIN_DATA 의 숨긴 PLANT_SITE_ID 대표값 MERGE 끝 3줄 (이 뒤에 삽입)
        {plsql_lit(A_GET)};
    c_ac    CONSTANT VARCHAR2(32767) :=   -- 앵커 2: GET_MAIN_DATA_CURRENT 의 피벗 IN 리스트 빈값 방어 IF 4줄 (이 앞에 삽입)
        {plsql_lit(A_CUR)};
    c_bg    CONSTANT VARCHAR2(32767) :=   -- 삽입 1: P_DMF0082_GET_MAIN_DATA (피벗 원천 GT_DMF0082_MF_SP)
        {plsql_lit(BLK_GET)};
    c_bc    CONSTANT VARCHAR2(32767) :=   -- 삽입 2: P_DMF0082_GET_MAIN_DATA_CURRENT (피벗 원천 GTT_MF_SP)
        {plsql_lit(BLK_CUR)};
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
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)에서
--       Column Set 에 LAST UPDATED BY / LAST UPDATE DATE 를 넣어도 줄이 갈리지 않게 한다.
--       두 컬럼은 행 키가 아닌 참고값 — 선택한 컬럼의 키마다 수정일이 가장 큰 행의 수정자 · 수정일 한 쌍만 표시,
--       줄 수 · 메저 값은 두 컬럼을 선택하지 않았을 때와 같다. 두 컬럼을 선택하지 않으면 추가 로직은 실행되지 않는다.
-- 배경: 최종 피벗이 결과 컬럼 전체로 묶어, 두 컬럼을 고르면 같은 키가 수정일 · 수정자 조합 수만큼 여러 줄로 나뉘었다 (사용자 요청 2026-10-27).
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 ASCII 앵커 2곳에 블록을 끼워 넣은 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 각 1건이 아니거나 해당 프로시저 범위 밖이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 블록 · 전후 비교 40케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_ag) <> 1 OR cnt(v_src, c_ac) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 매칭 GET ' || cnt(v_src, c_ag) || ' · CURRENT ' || cnt(v_src, c_ac) || '건 (각 1 기대). 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_pg    := DBMS_LOB.INSTR(v_src, c_ag);
    v_pc    := DBMS_LOB.INSTR(v_src, c_ac);
    v_get_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO');
    v_cur_s := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_cur_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_get_e > 0 AND v_cur_s > 0 AND v_cur_e > 0 AND v_pg < v_get_e AND v_cur_s < v_pc AND v_pc < v_cur_e) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 범위와 다름. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_pg + LENGTH(c_ag) - 1) || c_bg
          || SUBSTR(v_src, v_pg + LENGTH(c_ag), v_pc - v_pg - LENGTH(c_ag))
          || c_bc || CHR(10)
          || SUBSTR(v_src, v_pc);
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_ag || c_bg) <> 1 OR cnt(v_new, c_bc || CHR(10) || c_ac) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 삽입 블록 2개를 걷어낸 뒤 CREATE OR REPLACE (이 DB 의 USER_SOURCE 기준, 위치 무관). 전체 F5, 멱등
-- 마커 없으면 무동작. ⚠ 되돌리면 LAST UPDATED BY / LAST UPDATE DATE 를 선택한 사용자에게 다시 줄이 갈려 나온다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_bg) <> 1 OR cnt(v_src, c_bc) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 블록 매칭 ' || cnt(v_src, c_bg) || ' · ' || cnt(v_src, c_bc) || '건 (각 1 기대). 원문 무변경');
    END IF;
    IF cnt(v_src, c_bc || CHR(10) || c_ac) = 1 THEN
        v_new := REPLACE(v_src, c_bc || CHR(10) || c_ac, c_ac);   -- 10 으로 넣은 위치 (빈 줄까지 걷어냄)
    ELSE
        v_new := REPLACE(v_src, c_bc, NULL);
    END IF;
    v_new := REPLACE(v_new, c_bg, NULL);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 걷어낸 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


USERS_SQL = """SELECT '{tag}' CHK, U.COLUMN_NAME, COUNT(DISTINCT U.USER_ID) USERS
  FROM SCM_MST_TITLESET_USER U
 WHERE U.PROGRAM_ID = 'DMF0082' AND U.SHEET_NAME = 'FcstNPrice' AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
   AND U.COLUMN_NAME IN ('LAST_UPDATED_BY', 'LAST_UPDATE_DATE')
 GROUP BY U.COLUMN_NAME ORDER BY 2;
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 패치 앵커 — GET(숨긴 PLANT_SITE_ID 대표값 MERGE 끝 줄) · CURRENT(피벗 IN 빈값 방어 IF 다음 줄) 각 1건이어야 10 적용 가능
-- * [L2] 마커 — 적용 전 0 (적용 뒤 2)
-- * [L3] Column Set 에 두 컬럼을 넣은 사용자 수 (= 지금 줄이 갈려 보이는 사용자)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A12
COLUMN JUDGE FORMAT A60
COLUMN COLUMN_NAME FORMAT A22
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커GET' CHK, COUNT(*) N, MIN(S.LINE) LINE_1,
       CASE WHEN COUNT(*) = 1 THEN 'PASS (최종 판정은 10 이 3줄 전체로 한다)' ELSE 'FAIL — 1건이 아님 → 중단·회신' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.TEXT LIKE '%WHEN MATCHED THEN UPDATE SET T.PLANT_SITE_ID = S.REP_PLANT_SITE%';
SELECT 'L1 앵커CUR' CHK, COUNT(*) N, MIN(S.LINE) LINE_1, MAX(S.LINE) LINE_2,
       '2건 기대 (GET · CURRENT 각 1 — 10 은 CURRENT 범위의 4줄 묶음 1건으로 판정)' JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND S.TEXT LIKE '%IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN%';
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
{USERS_SQL.format(tag='L3 선택자')}SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(2) · V2 VALID/오류 0 · V3 마커 2줄(두 조회 프로시저에 1줄씩)
-- * 화면 확인: Column Set 에 LAST UPDATED BY · LAST UPDATE DATE 를 넣고 조회 → 넣기 전과 줄 수 · 메저 값이 같고,
--   두 컬럼에는 그 줄의 가장 최근 수정일과 그 수정자 하나만 보이는지 본다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A12
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A60
COLUMN COLUMN_NAME FORMAT A22
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 줄' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND ( S.TEXT LIKE '%{MARK}%' OR S.TEXT LIKE '%MERGE INTO SCM_MGR.G%MF_SP T%' AND S.TEXT LIKE '%''MERGE%' )
 ORDER BY S.LINE;
{USERS_SQL.format(tag='V4 선택자')}"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_LASTUPD_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_LASTUPD_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
