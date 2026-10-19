"""DMF0082_MANDCOL 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 2곳에 보정 블록 삽입)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY(10-12 13:27 변경)와 사내 BODY 는 타 작업자 수정분이 달라 전체본 교체 금지
  (DMF0082_LATFIX_CLOUD_20261012 와 같은 방식). 10_APPLY 가 대상 DB 의 USER_SOURCE 를 그대로 읽어 앵커 2곳 뒤에 블록만 넣고
  CREATE OR REPLACE 한다.

삽입 블록 문구는 사내 적용 스크립트(_apply_corporate/DMF0082_MANDCOL_20261012/build_apply.py fix_block)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(ALL_SOURCE/USER_SOURCE)의 현재 BODY 에 그 블록 2개가 각각 정확히 1회 있는지 확인 — 사내 적용본과
  패키지 문구가 다르면 중단한다.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_MANDCOL_20261012\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")

ANCHORS = [
    ("CELL_PROD_SITE_ID",
     "       AND U.COLUMN_NAME = 'CELL_PROD_SITE_ID';\n\n",
     "    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만 (표시 중이면 AS-IS 파리티 유지)\n", True),
    ("PLANT_SITE_ID",
     "       AND U.COLUMN_NAME = 'PLANT_SITE_ID';\n\n",
     "    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만\n", False),
]


def plsql_lit(text, indent="        "):
    """여러 줄 문자열 → PL/SQL 리터럴 ('줄' || CHR(10) || …)."""
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
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM user_objects "
                    "WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl, now = cur.fetchone()
    for col, pre, post, first in ANCHORS:
        full = pre + corp.fix_block(col, first) + post
        if body.count(full) != 1:
            sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 {col} 적용 블록 {body.count(full)}회 (1회여야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl, now


def decl(rollback):
    out = []
    for i, (col, pre, post, first) in enumerate(ANCHORS, 1):
        old = pre + post
        new = pre + corp.fix_block(col, first) + post
        out.append(f"    c_old{i}  CONSTANT VARCHAR2(32767) :=   -- {col} 판정 (원문)\n        {plsql_lit(old)};\n")
        out.append(f"    c_new{i}  CONSTANT VARCHAR2(32767) :=   -- {col} 판정 + 필수 컬럼 보정 블록\n        {plsql_lit(new)};\n")
    return "".join(out)


COMMON_FN = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
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
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어(클라우드 현재 원문 기준 — 사내 전체본 복사 아님) 숨김 판정 2곳 뒤에 보정 블록만 삽입 후 CREATE OR REPLACE.
-- 내용: P_DMF0082_GET_MAIN_DATA 의 '숨긴 컬럼 대표값 통일'([E20260918-KEYCOLGRAIN] CELL_PROD_SITE_ID / [KEYCOLGRAIN2] PLANT_SITE_ID) 판정에서
--       사용자 컬럼 저장 내역(SCM_MST_TITLESET_USER 'C')에 없더라도 **메타상 필수 컬럼**(SCM_MST_SHEET_COLUMNS USER_SELECTABLE_FLAG='N' · VISIBLE_FLAG='Y' ·
--       해당 division)이면 '표시 중' 으로 본다. 화면은 필수 컬럼을 항상 표시하므로 판정을 화면과 일치시킨다. 기존 문장은 한 글자도 바꾸지 않는다.
-- 증상: 저장 내역에 CELL_PROD_SITE_ID 가 없는 사용자(k0101)는 화면에 Cell Prod Site 가 보이는데도 LOC/KRW/USD 가 한 사이트로 합쳐져
--       HQ06-A 에 LOC 가 안 나옴 (클라우드 QA 10-12 실측 — 판가 HQ06-A 888 / NJ01-A 777 → NJ01-A 한 줄 832.5)
-- 가드: 마커 존재 시 무동작 · 앵커 각 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 블록 · 전후 비교 4케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
{decl(False)}{COMMON_FN}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_old1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — CELL_PROD_SITE_ID 판정 앵커 매칭 ' || cnt(v_src, c_old1) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    IF cnt(v_src, c_old2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — PLANT_SITE_ID 판정 앵커 매칭 ' || cnt(v_src, c_old2) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_old1, c_new1), c_old2, c_new2);
    IF cnt(v_new, c_mark) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (2 기대)');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 보정 블록 2개 제거 후 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 제거 뒤 마커 0 이어야 실행.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
{decl(True)}{COMMON_FN}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new1) <> 1 OR cnt(v_src, c_new2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 블록 매칭 ' || cnt(v_src, c_new1) || '/' || cnt(v_src, c_new2) || '건 (각 1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_new1, c_old1), c_new2, c_old2);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


PRECHECK = f"""-- 00_PRECHECK — 조회 전용. [{MARK}] 적용 전 상태 판정 (전체 F5, 값 입력 없음)
-- * [L0] 접속 DB · PKG_DMF0082 BODY 상태·LAST_DDL
-- * [L1] 패치 앵커 2곳 — 숨김 판정 SELECT 끝줄 바로 뒤(빈 줄 1개)에 IF 줄이 오는 형태가 각 1건이어야 10 적용 가능
-- * [L2] 마커 — 적용 전 0 (적용 뒤 2)
-- * [L3] 필수 컬럼 메타 — CELL_PROD_SITE_ID(40) · PLANT_SITE_ID(81 계열)가 USER_SELECTABLE_FLAG='N' · VISIBLE_FLAG='Y' · VALID_YN='Y' 여야 보정이 동작
-- * [L4] 영향 사용자 — 컬럼 저장 내역(C)에 CELL_PROD_SITE_ID / PLANT_SITE_ID 가 없는 사용자 (적용 뒤 이 사용자들의 조회 결과가 달라진다)
-- * [L5] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — CREATE OR REPLACE 가 library cache pin 대기)
SET LINESIZE 300 PAGESIZE 200
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','INSTANCE_NAME') INST, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커' CHK, A.COL, COUNT(B.LINE) N,
       CASE WHEN COUNT(B.LINE) = 1 THEN 'PASS → 10 적용 가능' WHEN COUNT(B.LINE) = 0 THEN 'FAIL — 앵커 없음 (이미 적용이면 L2=2) → 중단' ELSE 'FAIL — 앵커 2건↑ → 중단' END JUDGE
  FROM (SELECT 'CELL_PROD_SITE_ID' COL FROM DUAL UNION ALL SELECT 'PLANT_SITE_ID' FROM DUAL) A
  LEFT JOIN (SELECT S1.LINE, CASE WHEN S1.TEXT LIKE '%''CELL_PROD_SITE_ID''%' THEN 'CELL_PROD_SITE_ID' ELSE 'PLANT_SITE_ID' END COL
               FROM USER_SOURCE S1
               JOIN USER_SOURCE S2 ON S2.NAME = S1.NAME AND S2.TYPE = S1.TYPE AND S2.LINE = S1.LINE + 1
               JOIN USER_SOURCE S3 ON S3.NAME = S1.NAME AND S3.TYPE = S1.TYPE AND S3.LINE = S1.LINE + 2
              WHERE S1.NAME = 'PKG_DMF0082' AND S1.TYPE = 'PACKAGE BODY'
                AND (RTRIM(S1.TEXT, CHR(10)||CHR(13)) = '       AND U.COLUMN_NAME = ''CELL_PROD_SITE_ID'';'
                  OR RTRIM(S1.TEXT, CHR(10)||CHR(13)) = '       AND U.COLUMN_NAME = ''PLANT_SITE_ID'';')
                AND RTRIM(S2.TEXT, CHR(10)||CHR(13)) IS NULL
                AND S3.TEXT LIKE '    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만%') B ON B.COL = A.COL
 GROUP BY A.COL ORDER BY A.COL;
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' WHEN COUNT(*) = 2 THEN '적용됨 — 10 재실행은 가드로 무동작' ELSE '부분 적용 — 99 원복 후 재적용' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 메타' CHK, C.COLUMN_NAME, C.DIVISION_ID, C.USER_SELECTABLE_FLAG, C.VISIBLE_FLAG, C.VALID_YN,
       CASE WHEN C.USER_SELECTABLE_FLAG = 'N' AND C.VISIBLE_FLAG = 'Y' AND C.VALID_YN = 'Y' THEN '필수 컬럼 (이 division 은 합치지 않음)' ELSE '필수 아님 (종전대로 숨김 시 합침)' END JUDGE
  FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice' AND C.COLUMN_NAME IN ('CELL_PROD_SITE_ID','PLANT_SITE_ID')
 ORDER BY C.COLUMN_NAME;
SELECT 'L4 영향 사용자' CHK, U.USER_ID,
       MAX(CASE WHEN U.COLUMN_NAME = 'CELL_PROD_SITE_ID' THEN 'Y' ELSE 'N' END) HAS_CELL_PROD,
       MAX(CASE WHEN U.COLUMN_NAME = 'PLANT_SITE_ID' THEN 'Y' ELSE 'N' END) HAS_PLANT,
       TO_CHAR(MAX(U.LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI') LAST_SAVED
  FROM SCM_MST_TITLESET_USER U
 WHERE U.PROGRAM_ID = 'DMF0082' AND U.SHEET_NAME = 'FcstNPrice' AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
 GROUP BY U.USER_ID
HAVING MAX(CASE WHEN U.COLUMN_NAME = 'CELL_PROD_SITE_ID' THEN 1 ELSE 0 END) = 0
    OR MAX(CASE WHEN U.COLUMN_NAME = 'PLANT_SITE_ID' THEN 1 ELSE 0 END) = 0
 ORDER BY U.USER_ID;
SELECT 'L5 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.MACHINE, S.LAST_CALL_ET CALL_SEC, S.SQL_ID
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE')
 ORDER BY S.LAST_CALL_ET DESC;
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] V1~V3 조회 전용 · V4 = 40·81·82 조회 SP 1회씩 호출(세션 작업 테이블만, ROLLBACK) · V5 = 영향 사용자 기능 확인
-- * 기대: V1 마커 2 · V2 VALID/오류 0 · V3 보정 블록 2개 · V4 'OK' 3줄 · V5 'PASS'
-- * 10 실행 전에 돌리면 V1=0 · V5 = '합쳐짐(적용 전 상태)' — 그 자체가 적용 전 증거
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 300 PAGESIZE 500
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL (' || COUNT(*) || ')' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 블록' CHK, S.LINE, RTRIM(S.TEXT, CHR(10)||CHR(13)) TXT
  FROM USER_SOURCE S
 WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND EXISTS (SELECT 1 FROM USER_SOURCE M WHERE M.NAME=S.NAME AND M.TYPE=S.TYPE AND M.TEXT LIKE '%{MARK}%' AND S.LINE BETWEEN M.LINE AND M.LINE + 18)
   AND (S.TEXT LIKE '%{MARK}%' OR S.TEXT LIKE '%SCM_MST_SHEET_COLUMNS C%' OR S.TEXT LIKE '%C.COLUMN_NAME = %' OR S.TEXT LIKE '%USER_SELECTABLE_FLAG%')
 ORDER BY S.LINE;
-- V4 — 40 · 81 · 82 조회 호출 (ADMIN / minyonglee1, 당월~+6개월, 전체 필터). 결과 커서는 행수만 세고 ROLLBACK
DECLARE
  rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rr SYS_REFCURSOR;
  v_from VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6)-1,'YYYYMMDD');
  t0 NUMBER; n PLS_INTEGER;
  FUNCTION cnt(rc IN OUT SYS_REFCURSOR) RETURN PLS_INTEGER IS k PLS_INTEGER := 0; cc INTEGER; BEGIN cc := DBMS_SQL.TO_CURSOR_NUMBER(rc); WHILE DBMS_SQL.FETCH_ROWS(cc) > 0 LOOP k := k + 1; END LOOP; DBMS_SQL.CLOSE_CURSOR(cc); RETURN k; END;
BEGIN
  FOR d IN (SELECT '40' dv FROM DUAL UNION ALL SELECT '81' FROM DUAL UNION ALL SELECT '82' FROM DUAL) LOOP
    t0 := DBMS_UTILITY.GET_TIME;
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(d.dv, 'ALL', 'ALL', 'ALL', v_from, v_to, 'ALL', NULL, 'Current', 'N', 'minyonglee1', 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL', rc1, rc2, rc3, rc4, rc5, rr);
    n := cnt(rc1); CLOSE rc2; CLOSE rc3; CLOSE rc4; CLOSE rc5; CLOSE rr;
    DBMS_OUTPUT.PUT_LINE('V4 div ' || d.dv || ' OK  SP ' || TO_CHAR((DBMS_UTILITY.GET_TIME - t0)/100, 'FM99990.00') || 's  RC1 rows=' || n);
    ROLLBACK;
  END LOOP;
END;
/
-- V5 — 기능 확인: 컬럼 저장 내역에 CELL_PROD_SITE_ID 가 없는 사용자 1명으로 40 조회 → 출력 직전 자료에서 '같은 키·같은 메저에 Cell Prod Site 2개 이상' 인 묶음 수
--   적용 전 = 0 (전부 한 값으로 합쳐짐) / 적용 뒤 = 원자료에 그런 키가 있으면 1 이상 (합치지 않음)
DECLARE
  rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rr SYS_REFCURSOR;
  v_from VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6)-1,'YYYYMMDD');
  v_user VARCHAR2(100); v_out PLS_INTEGER; v_raw PLS_INTEGER;
BEGIN
  SELECT MIN(USER_ID) INTO v_user FROM (
    SELECT U.USER_ID FROM SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = 'DMF0082' AND U.SHEET_NAME = 'FcstNPrice' AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
     GROUP BY U.USER_ID HAVING MAX(CASE WHEN U.COLUMN_NAME = 'CELL_PROD_SITE_ID' THEN 1 ELSE 0 END) = 0);
  IF v_user IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('V5 SKIP — 컬럼 저장 내역에 CELL_PROD_SITE_ID 가 없는 사용자가 없음 (전원 저장 내역 보유 = 증상 대상 없음)');
    RETURN;
  END IF;
  SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA('40', 'ALL', 'ALL', 'ALL', v_from, v_to, 'ALL', NULL, 'Current', 'N', v_user, 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL', rc1, rc2, rc3, rc4, rc5, rr);
  CLOSE rc1; CLOSE rc2; CLOSE rc3; CLOSE rc4; CLOSE rc5; CLOSE rr;
  SELECT COUNT(*) INTO v_out FROM (
    SELECT 1 FROM SCM_MGR.GT_DMF0082_MF_SP
     GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
    HAVING COUNT(DISTINCT CELL_PROD_SITE_ID) > 1);
  SELECT COUNT(*) INTO v_raw FROM (
    SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
     GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
    HAVING COUNT(DISTINCT CELL_PROD_SITE_ID) > 1);
  DBMS_OUTPUT.PUT_LINE('V5 user ' || v_user || ' div 40 — 원자료에서 Cell Prod Site 가 갈리는 묶음 ' || v_raw || ' · 출력 직전 자료 ' || v_out || ' → ' ||
    CASE WHEN v_raw = 0 THEN 'N/A (이 기간 원자료에 갈리는 키 없음 — 판정 불가)'
         WHEN v_out > 0 THEN 'PASS — 합치지 않음 (적용 상태)'
         ELSE '합쳐짐 (적용 전 상태)' END);
  ROLLBACK;
END;
/
"""


def main():
    corp_ddl, now = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_MANDCOL_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_MANDCOL_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")
    print("BUILD OK", now)


if __name__ == "__main__":
    main()
