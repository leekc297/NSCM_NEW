"""DMF0082_GAP443_LOCPAST_CLOUD_20261015 패키지 생성기.

GAP 443 — DMF0082 월 칸 판가(LOC) 수정 시 이미 지난 주의 판가·KRW/USD 환산까지 바뀜.
  AS-IS 는 FE(DMF0082_FcstNPrice_Mgmt.cs L7183~7199)가 이번 주 월요일 이전 일자를 건너뛴다.
  사용자 지시(DB 객체 우선)로 같은 규칙을 P_DMF0082_SAVE_MAIN_DATA 파싱 직후 블록 1개로 둔다 (FE 무변경).

FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본(마커 1곳 · 블록이 앵커 바로 앞)인지 확인한 뒤에만 생성.
블록 문구는 재조회한 사내 적용본에서 그대로 추출한다 (손으로 다시 쓰지 않음).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
MARK = "GAP443 2026-10-15"
P_FROM = "PROCEDURE P_DMF0082_SAVE_MAIN_DATA"
P_TO = "PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA"
ANCHOR = "    BEGIN\n        SELECT COUNT(1) INTO V_EDIT_CNT FROM SCM_MGR.GT_PRDM1_T_MAIN;\n"   # ASCII 2줄
START = "    /* [" + MARK + "]"                                                                  # ASCII
DEL_LINE = "        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN"
DATE_LINE_PREFIX = "           AND YYYYMMDD < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');"

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
assert src.count(ANCHOR) == 1, f"앵커 {src.count(ANCHOR)}곳 (1 기대)"
s0 = src.index("\n" + P_FROM + "\n")
s1 = src.index("\n" + P_TO)
b0 = src.index("\n" + START) + 1
b1 = src.index(ANCHOR)
assert s0 < b0 < b1 < s1 and b1 - b0 < 2000, "블록 위치 이상"
BLOCK = src[b0:b1]
assert DEL_LINE in BLOCK and DATE_LINE_PREFIX in BLOCK and BLOCK.endswith("    END IF;\n\n"), "블록 형태 이상"


def lit(text):
    """여러 줄 텍스트(끝 LF 포함) → PL/SQL 문자열 식. 빈 줄도 보존."""
    return " ||\n".join("        '" + ln.replace("'", "''") + "' || CHR(10)" for ln in text[:-1].split("\n"))


def q(text):
    return text.replace("'", "''").replace(chr(10), "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
RANGE = f"""   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) = '{P_FROM}')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '{P_TO}%')"""
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_s0     PLS_INTEGER;
    v_s1     PLS_INTEGER;
    v_pos    PLS_INTEGER;
    v_end    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)  := '{MARK}';
    c_anchor CONSTANT VARCHAR2(200) := '{q(ANCHOR)}';   -- ASCII 앵커 2줄 (SAVE_MAIN_DATA 구간 안 1건)
"""
FUNC = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos > p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;"""
LOAD = f"""    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_s0  := DBMS_LOB.INSTR(v_src, CHR(10) || '{P_FROM}' || CHR(10));
    v_s1  := DBMS_LOB.INSTR(v_src, CHR(10) || '{P_TO}');
    IF NOT (v_s0 > 0 AND v_s0 < v_s1) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 저장 프로시저 위치 확인 불가 (SAVE_MAIN_DATA / GET_EXCEL_FORM_DATA). 원문 무변경');
    END IF;"""
COMPILE = """    BEGIN
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

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 443 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 저장 P_DMF0082_SAVE_MAIN_DATA 파싱 직후에 블록 1개를 넣는다 — 화면·팝업 저장의 LOC 판가 중
--       이번 주 월요일 이전 일자를 버린다(KRW/USD·MKT_AMT 는 LOC 에서 확장되므로 함께 빠짐).
--       구: 월 칸 LOC 수정 시 당월 지난 주 일자(1일·지난 주 대표일)까지 저장 → 지난 주 판가·KRW·USD 환산이 바뀜.
--       AS-IS 근거: DMF0082_FcstNPrice_Mgmt.cs L7183~7199 (월 칸 LOC 분배가 이번 주 월요일 이전 일자 continue). FE 무변경.
-- 범위: 저장 SP 블록 1개 삽입. 행 삭제(ACTION='D') · Excel Upload 경로(SKIP_PARSE='Y') · 조회 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 SAVE_MAIN_DATA 구간의 ASCII 앵커(V_EDIT_CNT 집계 BEGIN 2줄) 바로 앞에 블록을 넣고
--       CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 구간 안 1건이 아니면 중단 · v_skip_parse 변수 부재 시 중단(원문 무변경)
--       · 조립 길이 불일치 시 중단 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}) — 40 LOC 1.234 × 10/01·10/05·10/12·10/19·10/26 저장: 수정 전 5일 전부 → 수정 후 10/12 이후 3일만 (이번 주 월요일 10/12).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}    c_block  CONSTANT VARCHAR2(4000) :=   -- 삽입 블록 (사내 적용본과 동일 문구)
{lit(BLOCK)};
{FUNC}
BEGIN
{LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anchor, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커가 SAVE_MAIN_DATA 구간에 ' || cnt(v_src, c_anchor, v_s0, v_s1) || '건 (1 기대). 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    IF cnt(v_src, 'v_skip_parse', v_s0, v_s1) = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — SAVE_MAIN_DATA 에 v_skip_parse 변수 없음 (구세대 BODY). 00_PRECHECK L3 회신. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, c_anchor, v_s0);   -- 앵커 첫 글자 = 삽입 위치
    v_new := SUBSTR(v_src, 1, v_pos - 1) || c_block || SUBSTR(v_src, v_pos);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 1
       OR DBMS_LOB.GETLENGTH(v_new) <> DBMS_LOB.GETLENGTH(v_src) + LENGTH(c_block) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 443 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 블록(ASCII 마커 줄 '{START}' 부터 ASCII 앵커 직전까지)을 지운다 — 한글 주석 비교에 의존하지 않는다.
-- 가드: 마커 없음 → 무동작 · 블록/앵커 위치 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}    c_start  CONSTANT VARCHAR2(100) := CHR(10) || '{q(START)}';
{FUNC}
BEGIN
{LOAD}
    IF cnt(v_src, c_mark, 1, DBMS_LOB.GETLENGTH(v_src)) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_start, v_s0, v_s1) <> 1 OR cnt(v_src, c_anchor, v_s0, v_s1) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 블록 시작 또는 앵커가 SAVE_MAIN_DATA 구간에 1건이 아님. 원문 무변경');
    END IF;
    v_pos := DBMS_LOB.INSTR(v_src, c_start, v_s0) + 1;   -- 블록 첫 글자
    v_end := DBMS_LOB.INSTR(v_src, c_anchor, v_pos);      -- 앵커 첫 글자 (블록 끝 다음)
    IF v_end = 0 OR v_end - v_pos > 2000 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 블록 끝 위치 이상. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_pos - 1) || SUBSTR(v_src, v_end);
    IF cnt(v_new, c_mark, 1, DBMS_LOB.GETLENGTH(v_new)) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ANCHOR2 = ANCHOR.split("\n")[1]
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 443 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 앵커(V_EDIT_CNT 집계 줄) — SAVE_MAIN_DATA 구간에 1줄이어야 10 적용 가능 (PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 블록이 쓰는 것 실존 — SAVE_MAIN_DATA 의 v_skip_parse 변수 · FN_NEXT_DAY 함수 · GT_PRDM1_T_MAIN 컬럼 3개 (전부 PASS 기대)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A30
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커' CHK, COUNT(S.LINE) N, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = 1 THEN 'PASS' ELSE 'FAIL — 건수 다름(1 기대) → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{q(ANCHOR2)}'
{RANGE};
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 실존' CHK, 'v_skip_parse 변수(SAVE_MAIN_DATA)' KIND,
       CASE WHEN COUNT(*) > 0 THEN 'PASS' ELSE 'FAIL — 구세대 BODY → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND UPPER(S.TEXT) LIKE '%V_SKIP_PARSE%'
{RANGE}
UNION ALL
SELECT 'L3 실존', 'FN_NEXT_DAY 함수', CASE WHEN COUNT(*) > 0 THEN 'PASS' ELSE 'FAIL — 함수 없음 → 10 실행 금지' END
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'FN_NEXT_DAY' AND OBJECT_TYPE = 'FUNCTION' AND STATUS = 'VALID'
UNION ALL
SELECT 'L3 실존', 'GT_PRDM1_T_MAIN.' || K.COL, CASE WHEN C.COLUMN_NAME IS NULL THEN 'FAIL — 컬럼 없음 → 10 실행 금지' ELSE 'PASS' END
  FROM ( SELECT 'MEASURE' COL FROM DUAL UNION ALL SELECT 'ACTION' FROM DUAL UNION ALL SELECT 'YYYYMMDD' FROM DUAL ) K
  LEFT JOIN USER_TAB_COLUMNS C ON C.TABLE_NAME = 'GT_PRDM1_T_MAIN' AND C.COLUMN_NAME = K.COL;
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 443 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(1줄) · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 PASS(DELETE·일자 조건 줄이 앵커 바로 앞)
--         · V4 참고: 지금 기준 이번 주 월요일 — 이 일자 이전 LOC 판가는 화면·팝업 저장에서 무시된다
-- * 화면 확인(README 4단계): Monthly 에서 당월 LOC 월 칸 수정 → 저장 → 재조회 시 V4 이전 주 판가는 그대로.
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
SELECT 'V3 위치' CHK, M.LINE MARK_LINE, D.LINE DATE_COND_LINE, A.LINE ANCHOR_LINE,
       CASE WHEN M.LINE < D.LINE AND D.LINE < A.LINE AND A.LINE - M.LINE <= 15 THEN 'PASS' ELSE 'FAIL — 블록 위치 이상' END JUDGE
  FROM (SELECT MIN(LINE) LINE FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') M,
       (SELECT MIN(S.LINE) LINE FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
           AND S.TEXT LIKE '{q(DATE_LINE_PREFIX)}%'
{RANGE}) D,
       (SELECT MIN(S.LINE) LINE FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
           AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{q(ANCHOR2)}'
{RANGE}) A;
SELECT 'V4 참고' CHK, TO_CHAR(SYSDATE,'YYYY-MM-DD DY') TODAY, TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') THIS_MONDAY FROM DUAL;
"""

os.makedirs(OUT, exist_ok=True)
files = {
    "00_PRECHECK_CLOUD.sql": PRECHECK,
    "10_APPLY_GAP443_PATCH.sql": APPLY,
    "90_VERIFY.sql": VERIFY,
    "99_ROLLBACK_GAP443_PATCH.sql": ROLLBACK,
}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) md5={hashlib.md5(src.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl, "block lines", BLOCK.count("\n"))
