"""DMF0082_GAP439_VERPAREN_CLOUD_20261015 패키지 생성기.

GAP 439 — DMF0082 조회 시 Current 외 버전 선택하면 0건.
  버전 팝업 반환값 = VERSION_NO||'(주차)'[||' (NO PLAN)'] 이 그대로 p_version_type 으로 유입 →
  PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 의 버전 토큰 적재 1문장에서 '(' 이후 절단 (Current 제외).

FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본(마커 1곳 · 구 문장 0곳)인지 확인한 뒤에만 생성.
블록 문구는 재조회한 사내 적용본에서 그대로 추출한다 (손으로 다시 쓰지 않음).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
MARK = "GAP439 2026-10-15"
OLD = "    SELECT 'p_version_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));"
END = "    FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));"
CASE_LINE = "         , CASE WHEN UPPER(COLUMN_VALUE) LIKE '%CURRENT%' THEN COLUMN_VALUE"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

assert src.count(MARK) == 1, f"FRESH-GATE 실패: 사내 마커 {src.count(MARK)}곳 (1 기대)"
assert src.count(OLD + "\n") == 0, "FRESH-GATE 실패: 사내에 구 문장 잔존"
main = src.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n")
curp = src.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
b0 = src.index("\n    /* [" + MARK) + 1
b1 = src.index(END + "\n", b0) + len(END) + 1
assert main < b0 < b1 < curp, "블록이 GET_MAIN_DATA 구간 밖"
BLOCK = src[b0:b1]
assert BLOCK.count("\n") == 8 and CASE_LINE in BLOCK, "블록 형태 이상"


def plsql_lit(text):
    """여러 줄 텍스트 → PL/SQL 문자열 식 ('…' || CHR(10) || …)."""
    parts = []
    for line in text[:-1].split("\n"):
        parts.append("        '" + line.replace("'", "''") + "' || CHR(10)")
    return " ||\n".join(parts)


STAMP = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
RANGE = """   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = 'PROCEDURE P_DMF0082_GET_MAIN_DATA')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT%')"""
OLD_SQL = OLD.replace("'", "''")
CASE_SQL = CASE_LINE.replace("'", "''")

COMMON_DECL = f"""    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_old   CONSTANT VARCHAR2(400) :=   -- 구 문장 (ASCII 한 줄 · GET_MAIN_DATA 구간 안 1건)
        '{OLD_SQL}' || CHR(10);"""

COMMON_FUNC = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos > p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;"""

COMMON_LOAD = """    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src  := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_main := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_cur  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    IF NOT (v_main > 0 AND v_main < v_cur) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 위치 확인 불가 (GET_MAIN_DATA / _CURRENT). 원문 무변경');
    END IF;"""

COMMON_COMPILE = """    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원 (2026-10-15 GAP452 리허설 사고 정정)
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;"""

POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;"

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 439 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 구 문장(버전 토큰 적재) — GET_MAIN_DATA 구간에 1줄이어야 10 적용 가능 (PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] DM_MST_VERSION.VERSION_NO 에 '(' 포함 행 — 0 이어야 '(' 이후 절단이 실버전을 훼손하지 않음 (PASS 기대)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상줄' CHK, COUNT(S.LINE) N, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = 1 THEN 'PASS' ELSE 'FAIL — 건수 다름(1 기대) → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{OLD_SQL}'
{RANGE};
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 버전' CHK, COUNT(*) N,
       CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL — VERSION_NO 에 ''('' 포함 → 10 실행 금지·결과 회신' END JUDGE
  FROM DM_MST_VERSION WHERE VERSION_NO LIKE '%(%';
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 439 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 버전 토큰 적재 1문장을 바꾼다.
--       버전 팝업(DMF0073_GET_VERSION_SALESPRICE)이 돌려주는 값 = VERSION_NO||'(주차)'[||' (NO PLAN)'] 이 그대로 넘어와
--       DM_MST_VERSION.VERSION_NO 정확 조인이 0건 → Current 외 버전 조회 불가.
--       Current 가 아닌 토큰은 첫 '(' 이후를 잘라 순수 VERSION_NO 로 적재한다. Current 는 그대로.
-- 범위: 조회 SP 1문장(1줄 → 8줄). 원장 · 저장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 GET_MAIN_DATA 구간의 ASCII 구 문장 1줄을 블록으로 치환하고 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 구 문장이 구간 안 1건이 아니면 중단(원문 무변경) · 조립 길이 불일치 시 중단
--       · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}) — 81 MF_W_20260930_V001(W40) 0→498건 · Current 7,148 불변.
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{COMMON_DECL}
    c_block CONSTANT VARCHAR2(32767) :=   -- 치환 블록 (사내 적용본과 동일 문구)
{plsql_lit(BLOCK)};
{COMMON_FUNC}
BEGIN
{COMMON_LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, CHR(10) || c_old, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 구 문장이 GET_MAIN_DATA 구간에 ' || cnt(v_src, CHR(10) || c_old, v_main, v_cur) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, CHR(10) || c_old, v_main) + 1;   -- 구 문장 첫 글자
    v_new := SUBSTR(v_src, 1, v_pos - 1) || c_block || SUBSTR(v_src, v_pos + LENGTH(c_old));
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 1
       OR cnt(v_new, CHR(10) || c_old, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) - LENGTH(c_old) + LENGTH(c_block) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
{COMMON_COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 439 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 블록(마커 주석 시작 ~ ASCII 끝 줄 `{END.strip()}`)을 구 문장 1줄로 되돌린다.
--       블록 시작은 ASCII 마커 '    /* [{MARK}]', 끝은 ASCII 줄로 찾으므로 한글 주석 비교에 의존하지 않는다.
-- 가드: 마커 없음 → 무동작 · 마커/끝 줄 위치 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{COMMON_DECL}
    c_start CONSTANT VARCHAR2(100) := CHR(10) || '    /* [{MARK}]';
    c_end   CONSTANT VARCHAR2(200) := CHR(10) || '{END.replace("'", "''")}' || CHR(10);
    v_e     PLS_INTEGER;
{COMMON_FUNC}
BEGIN
{COMMON_LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_start, v_main, v_cur) <> 1 OR cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 블록이 GET_MAIN_DATA 구간에 1건이 아님. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, c_start, v_main) + 1;          -- 블록 첫 글자
    v_e   := DBMS_LOB.INSTR(v_src, c_end, v_pos);                  -- 끝 줄 앞 LF
    IF v_e = 0 OR v_e > v_cur OR v_e - v_pos > 2000 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 블록 끝 줄 위치 이상. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_pos - 1) || c_old || SUBSTR(v_src, v_e + LENGTH(c_end));
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0
       OR cnt(v_new, CHR(10) || c_old, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
{COMMON_COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 439 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(1줄) · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 구 문장 0 + CASE 줄 1 PASS
--         · V4 정제식 PASS 4줄 (팝업 반환형 → 순수 VERSION_NO, Current 유지)
--         · V5 이 DB 의 최근 버전 팝업 반환형을 정제했을 때 DM_MST_VERSION 매칭 (UNMATCHED 0 기대)
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 문장' CHK,
       SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{OLD_SQL}' THEN 1 ELSE 0 END) OLD_N,
       SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{CASE_SQL}' THEN 1 ELSE 0 END) CASE_N,
       CASE WHEN SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{OLD_SQL}' THEN 1 ELSE 0 END) = 0
             AND SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{CASE_SQL}' THEN 1 ELSE 0 END) = 1
            THEN 'PASS' ELSE 'FAIL — 구 문장 잔존 또는 CASE 줄 수 이상' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
{RANGE};
SELECT 'V4 정제식' CHK, T.IN_VAL, T.EXPECT, X.OUT_VAL,
       CASE WHEN X.OUT_VAL = T.EXPECT THEN 'PASS' ELSE 'FAIL' END JUDGE
  FROM ( SELECT 1 SEQ, 'MF_W_20260930_V001(W40)' IN_VAL, 'MF_W_20260930_V001' EXPECT FROM DUAL UNION ALL
         SELECT 2, 'SP_W_20260923_V001(W39) (NO PLAN)', 'SP_W_20260923_V001' FROM DUAL UNION ALL
         SELECT 3, 'MF_W_20260930_V001', 'MF_W_20260930_V001' FROM DUAL UNION ALL
         SELECT 4, 'Current', 'Current' FROM DUAL ) T
 CROSS APPLY ( SELECT CASE WHEN UPPER(COLUMN_VALUE) LIKE '%CURRENT%' THEN COLUMN_VALUE
                           ELSE TRIM(REGEXP_REPLACE(COLUMN_VALUE, '\\(.*$', ''))
                      END OUT_VAL
                 FROM TABLE(UF_FX_String_SplitForIN(T.IN_VAL, ',')) ) X
 ORDER BY T.SEQ;
SELECT 'V5 매칭' CHK, COUNT(*) POPUP_VALUES,
       SUM(CASE WHEN M.VERSION_NO IS NULL THEN 1 ELSE 0 END) UNMATCHED,
       CASE WHEN COUNT(*) > 0 AND SUM(CASE WHEN M.VERSION_NO IS NULL THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM ( SELECT A.DIVISION_ID, A.VERSION_NO || '(' || B.WEEK_NAME || ')' POPUP_VAL     -- 팝업 반환형 (DMF0073_GET_VERSION_SALESPRICE 동일 식)
           FROM DM_MST_VERSION A
          INNER JOIN SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
          WHERE A.YYYYMMDD >= TO_CHAR(SYSDATE - 60, 'YYYYMMDD')
            AND SUBSTR(A.VERSION_TYPE, 1, 2) IN ('SP', 'MF', 'SF') ) P
  LEFT JOIN DM_MST_VERSION M
    ON M.DIVISION_ID = P.DIVISION_ID
   AND M.VERSION_NO  = TRIM(REGEXP_REPLACE(P.POPUP_VAL, '\\(.*$', ''));
"""

os.makedirs(OUT, exist_ok=True)
files = {
    "00_PRECHECK_CLOUD.sql": PRECHECK,
    "10_APPLY_GAP439_PATCH.sql": APPLY,
    "90_VERIFY.sql": VERIFY,
    "99_ROLLBACK_GAP439_PATCH.sql": ROLLBACK,
}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) md5={hashlib.md5(src.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl, "block lines", BLOCK.count("\n"))
