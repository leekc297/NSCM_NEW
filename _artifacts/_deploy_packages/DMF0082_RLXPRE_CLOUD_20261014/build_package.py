"""DMF0082_RLXPRE 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 블록 1개만 삽입)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY(LAST_DDL 2026-10-14 13:46:31, G01 실측)와 사내 BODY 는 적용 시점이 달라
전체본 교체 금지. 삽입 블록 문구는 사내 적용 스크립트(_apply_corporate/DMF0082_RLXPRE_20261014/build_apply.py)의
BLOCK 을 그대로 가져온다.
앵커: 한글 주석 줄은 클라이언트 문자셋 변환 위험이 있어 쓰지 않는다 → ASCII 한 줄
  `    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;` 의
  **P_DMF0082_GET_MAIN_DATA 구간 안 1건**(BODY 전체로는 2건 — 다른 하나는 구간 밖) 바로 뒤에 삽입한다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에서 "앵커 줄 + 블록"이 GET_MAIN_DATA 구간에 정확히 1건이고
  마커가 1곳인지 확인 — 사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_RLXPRE_20261014\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
ANCHOR = "    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;\n"
KOR_LINE = "    -- #TempSiteItem 만들기 종료\n"
# 사내 적용본은 한글 주석 줄 뒤에 블록이 붙어 있다. 클라우드도 같은 위치(주석 줄 뒤)에 넣기 위해
# 삽입 블록 = 한글 주석 줄 + BLOCK 이 아니라, 앵커(ASCII) 뒤 "한글 주석 줄" 은 원문 그대로 두고 그 다음에 붙인다.
# → PL/SQL 에서는 앵커 위치 + 앵커 다음 줄 끝을 찾아 그 뒤에 BLOCK 을 넣는다 (한글 줄 내용 비교 없음, 줄 수만 사용).
BLOCK = corp.BLOCK
FILTERS = ["WHERE  NVL(PROJECT_CODE, ' ') NOT IN (", "WHERE  NVL(OWNER, ' ') NOT IN (", "WHERE  NVL(DEPT_ID, ' ') NOT IN ("]


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE) = 앵커 + 한글 주석 줄 + BLOCK 이 GET_MAIN_DATA 구간에 1건, 마커 1곳
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        fetched, host = cur.fetchone()
    m = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n")
    c = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
    seg = body[m:c]
    full = ANCHOR + KOR_LINE + BLOCK
    if seg.count(full) != 1 or body.count(corp.MARK) != 1:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에서 앵커+블록 {seg.count(full)}건(기대 1) · 마커 {body.count(corp.MARK)}곳(기대 1)")
    if seg.count(ANCHOR) != 1 or "\t" in BLOCK or "\t" in ANCHOR:
        sys.exit("FRESH-GATE FAIL: 앵커가 GET_MAIN_DATA 구간에 1건이 아니거나 탭 문자 포함")
    for f in FILTERS:
        if seg.count(f) != 1:
            sys.exit(f"FRESH-GATE FAIL: 기존 필터 DELETE 앵커 불일치: {f}")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl, "HOST", host, "FETCHED", fetched)
    return last_ddl, fetched, host


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_ins   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_anchor CONSTANT VARCHAR2(200) :=   -- ASCII 앵커 (GET_MAIN_DATA 구간 안 1건 · BODY 전체 2건)
        {plsql_lit(ANCHOR)};
    c_block CONSTANT VARCHAR2(32767) :=   -- 삽입 블록 (사내 적용본과 동일 문구)
        {plsql_lit(BLOCK)};
{''.join(f"    c_flt{i} CONSTANT VARCHAR2(100) := '{f.replace(chr(39), chr(39)*2)}';{chr(10)}" for i, f in enumerate(FILTERS, 1))}    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos > p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src  := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_main := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_cur  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    IF NOT (v_main > 0 AND v_main < v_cur) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 위치 확인 불가 (GET_MAIN_DATA / _CURRENT). 원문 무변경');
    END IF;
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
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 에서 조회조건 Project / Owner / Team 지정 시, 판가·수요를 적재하기 전에
--       품목 마스터 GTT(GT_DMF0082_TEMP_SITE_ITEM)를 선택 조건과 같은 (사업부, Sales Site, 품목) 묶음으로 미리 줄인다.
--       기존 필터 DELETE(Project/Owner/Team)는 그대로 남아 최종 결과는 동일하고, 적재·삭제량만 줄어든다.
-- 배경: 클라우드 QA 실측(G01/G02 2026-10-14) — 81 Project 지정 시 판가 18만 행 적재(2.1s) 뒤 91% 삭제(1.4s).
--       45일 조회 중 81 Project 단독 중앙값 10s vs Project+SalesSite 2s.
-- 범위: 조회 SP 1곳에 블록 1개(36줄) 삽입. 원장 · 저장 · 메타 · FE · 권한 무변경. 조건 미지정 조회는 블록이 실행되지 않음.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 GET_MAIN_DATA 구간의 ASCII 앵커 줄
--         `    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;`
--       다음 줄(#TempSiteItem 만들기 종료 주석) 뒤에 블록을 넣고 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 구간 안 1건이 아니거나 기존 필터 DELETE 3종이 각 1건이 아니면 중단(원문 무변경)
--       · 조립 길이 불일치 시 중단 · 컴파일 오류 시 원문 자동 복원
-- ⚠ 99_ROLLBACK 은 이 파일과 같은 도구(같은 클라이언트)로 실행할 것 — 블록 안 한글 주석을 같은 방식으로 비교한다.
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (전후 비교 30케이스 29 PASS · 1건 = 측정 사이 원장 변경, 코드 미실행 경로).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anchor, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커가 GET_MAIN_DATA 구간에 ' || cnt(v_src, c_anchor, v_main, v_cur) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    IF cnt(v_src, c_flt1, v_main, v_cur) <> 1 OR cnt(v_src, c_flt2, v_main, v_cur) <> 1 OR cnt(v_src, c_flt3, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — 기존 Project/Owner/Team 필터 DELETE 가 GET_MAIN_DATA 구간에 각 1건이 아님. 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, c_anchor, v_main);
    v_ins := DBMS_LOB.INSTR(v_src, CHR(10), v_pos + LENGTH(c_anchor));   -- 앵커 다음 줄(#TempSiteItem 만들기 종료) 끝
    IF v_ins = 0 OR v_ins > v_cur THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 삽입 위치 확인 불가. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_ins) || c_block || SUBSTR(v_src, v_ins + 1);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 1
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + LENGTH(c_block) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 삽입 블록 제거 (이 DB 의 USER_SOURCE 를 읽어 블록만 빼고 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 블록이 정확히 1건일 때만 실행. 10_APPLY 와 같은 도구로 실행할 것.
-- ⚠ 되돌리면 Project/Owner/Team 지정 조회가 다시 전량 적재 후 삭제 방식(이전 속도)으로 돌아간다. 결과 값은 같다.
{HEAD}    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_block, v_main, v_cur) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 삽입 블록이 GET_MAIN_DATA 구간에 ' || cnt(v_src, c_block, v_main, v_cur) || '건 (1 기대 — 블록이 수정됐거나 다른 도구로 적용됨). 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, c_block, v_main);
    v_new := SUBSTR(v_src, 1, v_pos - 1) || SUBSTR(v_src, v_pos + LENGTH(c_block));
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 제거 뒤 마커 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


# 줄 단위 판정 — GET_MAIN_DATA 구간(첫 PROCEDURE P_DMF0082_GET_MAIN_DATA 줄 ~ _CURRENT 줄)
SCOPE = """S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = 'PROCEDURE P_DMF0082_GET_MAIN_DATA')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT%')"""

LINE_SQL = """SELECT '{tag}' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = K.EXPECT THEN 'PASS' ELSE '{ng}' END JUDGE
  FROM ( SELECT '앵커 GROUP BY 줄' KIND, '    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;' TXT, 1 EXPECT FROM DUAL UNION ALL
         SELECT 'Project 필터 DELETE', '        WHERE  NVL(PROJECT_CODE, '' '') NOT IN (', 1 FROM DUAL UNION ALL
         SELECT 'Owner 필터 DELETE',   '        WHERE  NVL(OWNER, '' '') NOT IN (', 1 FROM DUAL UNION ALL
         SELECT 'Team 필터 DELETE',    '        WHERE  NVL(DEPT_ID, '' '') NOT IN (', 1 FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
   AND {scope}
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
"""

MARK_SQL = """SELECT '{tag}' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = {exp} THEN '{ok}' ELSE '{ng}' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{mark}%';
"""

COLS_SQL = """SELECT 'L3 컬럼' CHK, K.TBL, K.COL, CASE WHEN C.COLUMN_NAME IS NULL THEN 'FAIL — 컬럼 없음 → 10 실행 금지' ELSE 'PASS' END JUDGE
  FROM ( SELECT 'GT_DMF0082_TEMP_SITE_ITEM' TBL, 'DIVISION_ID' COL FROM DUAL UNION ALL SELECT 'GT_DMF0082_TEMP_SITE_ITEM', 'SCM_SITE_ID' FROM DUAL UNION ALL
         SELECT 'GT_DMF0082_TEMP_SITE_ITEM', 'ITEM_ID' FROM DUAL UNION ALL SELECT 'GT_DMF0082_TEMP_SITE_ITEM', 'PROJECT_CODE' FROM DUAL UNION ALL
         SELECT 'GT_DMF0082_TEMP_SITE_ITEM', 'OWNER' FROM DUAL UNION ALL SELECT 'GT_DMF0082_TEMP_SITE_ITEM', 'DEPT_ID' FROM DUAL UNION ALL
         SELECT 'GT_DMF0082_PARAM_TOKEN', 'PARAM_NM' FROM DUAL UNION ALL SELECT 'GT_DMF0082_PARAM_TOKEN', 'TOKEN' FROM DUAL ) K
  LEFT JOIN USER_TAB_COLUMNS C ON C.TABLE_NAME = K.TBL AND C.COLUMN_NAME = K.COL
 ORDER BY K.TBL, K.COL;
"""


def gen_precheck():
    return f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL (G01 실측 2026-10-14 14:45: BODY 13:46:31 · 17,256줄)
-- * [L1] 앵커·기존 필터 DELETE 줄 — GET_MAIN_DATA 구간에 각 1줄이어야 10 적용 가능 (전부 PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 블록이 쓰는 GTT 컬럼 8개 실존 (전부 PASS 기대)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A24
COLUMN LINES FORMAT A20
COLUMN JUDGE FORMAT A60
COLUMN TBL FORMAT A28
COLUMN COL FORMAT A14
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
{LINE_SQL.format(tag='L1 대상줄', ng='FAIL — 건수 다름 → 10 실행 금지·결과 회신', scope=SCOPE)}{MARK_SQL.format(tag='L2 마커', exp=0, ok='미적용 (기대)', ng='적용됨 — 10 재실행은 가드로 무동작', mark=MARK)}{COLS_SQL}SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""


def gen_verify():
    return f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(1줄) · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 블록 위치 PASS · V4 기존 필터 DELETE 줄 유지 PASS
-- * V5 (선택) 화면에서 Project 를 지정해 DMF0082 를 조회한 뒤 이 파일을 다시 실행하면 실행 기록이 보인다.
--      - 새 DELETE(TEMP_SITE_ITEM C …) = 적용 뒤 처음 생기는 커서. 조회 전이면 이 행이 없는 것이 정상.
--      - 기존 Project 필터 DELETE 는 문장 텍스트가 같아 적용 전 커서를 그대로 이어 쓴다(라인 번호·로드 시각도 적용 전 값).
--        누적값이므로 적용 전 G01 실측(EX 19 · 1회 216,449행)과 비교해, EX 가 늘어난 만큼 TOTAL_ROWS 가 거의 늘지 않으면 정상.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A24
COLUMN LINES FORMAT A20
COLUMN JUDGE FORMAT A60
COLUMN TXT FORMAT A80
{MARK_SQL.format(tag='V1 마커', exp=1, ok='PASS', ng='FAIL (미적용 또는 마커 수 불일치)', mark=MARK)}SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 위치' CHK, A.LINE ANCHOR_LINE, M.LINE MARK_LINE, T.LINE FIRST_CONSUMER_LINE,
       CASE WHEN A.LINE < M.LINE AND M.LINE < T.LINE AND M.LINE - A.LINE <= 3 THEN 'PASS' ELSE 'FAIL — 블록 위치 이상' END JUDGE
  FROM (SELECT MIN(S.LINE) LINE FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
          AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;'
          AND {SCOPE}) A,
       (SELECT MIN(LINE) LINE FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') M,
       (SELECT MIN(S.LINE) LINE FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
          AND TEXT LIKE '%INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST%' AND {SCOPE}) T;
{LINE_SQL.format(tag='V4 유지', ng='FAIL — 기존 줄 변경됨', scope=SCOPE)}SELECT 'V5 실행' CHK, S.PROGRAM_LINE# LINE, S.EXECUTIONS EX, ROUND(S.ELAPSED_TIME/1e6/GREATEST(S.EXECUTIONS,1),3) SEC_PER_EX,
       ROUND(S.ROWS_PROCESSED/GREATEST(S.EXECUTIONS,1)) ROWS_PER_EX, S.ROWS_PROCESSED TOTAL_ROWS,
       S.LAST_LOAD_TIME LOADED, TO_CHAR(S.LAST_ACTIVE_TIME,'MM-DD HH24:MI') LAST_ACT,
       CASE WHEN UPPER(S.SQL_TEXT) LIKE 'DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C%' THEN '신규 선행축소' ELSE '기존 Project 필터(누적)' END KIND,
       SUBSTR(REGEXP_REPLACE(S.SQL_TEXT,'\\s+',' '),1,80) TXT
  FROM GV$SQL S
 WHERE S.PROGRAM_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY')
   AND S.COMMAND_TYPE = 7
   AND (UPPER(S.SQL_TEXT) LIKE 'DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C WHERE (C.DIVISION_ID%'
        OR UPPER(S.SQL_TEXT) LIKE '%NVL(PROJECT_CODE, '' '') NOT IN%')
 ORDER BY KIND DESC, S.LAST_LOAD_TIME;
"""


def main():
    corp_ddl, fetched, host = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={corp_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)\n"
    files = {"00_PRECHECK_CLOUD.sql": gen_precheck(), "10_APPLY_RLXPRE_PATCH.sql": stamp + gen_apply(corp_ddl),
             "90_VERIFY.sql": gen_verify(), "99_ROLLBACK_RLXPRE_PATCH.sql": stamp + gen_rollback()}
    for name, txt in files.items():
        assert "&" not in txt, f"{name}: 치환변수 문자 & 포함 금지 (클라우드 ORA-01008 계보)"
        assert "\t" not in txt, f"{name}: 탭 문자 포함 금지"
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
