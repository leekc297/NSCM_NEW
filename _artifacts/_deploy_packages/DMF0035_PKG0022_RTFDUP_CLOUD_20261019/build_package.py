"""DMF0035_PKG0022_RTFDUP_CLOUD_20261019 패키지 생성기.

[E20261019-000071] PKG_DMF0022 (DMF0035 Plan Type = SALES PLAN) 40사업부 [PJ2024-50611] RTF 재적재 블록 주석 처리.
치환 정의는 사내 적용 폴더 ops.py 를 import 한다(단일 원천).
- 클라우드는 자기 USER_SOURCE 를 읽어 HEAD~TAIL 앵커 위치 기준으로 감싼다(사내 전체본 복사 아님).
- 한글 문구는 UNISTR 로 만든다(클라이언트 문자셋 무관). SQL 파일 자체는 주석 외 ASCII.
- FRESH-GATE: 사내 BODY(ALL_SOURCE) 재조회 → 마커 수 · 시뮬레이터(수정 전→적용==적용본 · 적용본→원복==수정 전).
"""
import os, sys, datetime, hashlib
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_RTFDUP_20261019"
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, CORP)
from ora import conn_info
from ops import MARK, MARK_N, HEAD, TAIL, OPEN, CLOSE, apply_ops, rollback_ops
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
PRE_FILE = os.path.join(CORP, "PKG_DMF0022_BODY.ASIS.sql")
OBJ = "PKG_DMF0022"

# 진단 대상 (사용자 신고 조건)
DIAG = dict(div="40", ver="SP_W_20261001_V001", item="MCCM348014A3", site="SCUD_CN_FOC", inco="DAP")
if len(sys.argv) > 1:          # 사내 문법 리허설용 버전 치환 (예: SP_W_20260827_V001)
    DIAG["ver"] = sys.argv[1]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
last_ddl = cur.fetchone()[0]
# FRESH-GATE: 사내 DB 원문 재조회 (ALL_SOURCE)
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
APPLIED = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
PRE = open(PRE_FILE, encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert APPLIED.count(MARK) == MARK_N and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"
assert apply_ops(PRE) == APPLIED, "시뮬레이터: 수정 전 → 적용 ≠ 적용본"
assert rollback_ops(APPLIED) == PRE, "시뮬레이터: 적용본 → 원복 ≠ 수정 전"
print("simulator OK")


def plx(t):
    """문자열 → PL/SQL 식. ASCII 는 리터럴, 비ASCII 는 UNISTR, 개행은 CHR(10)."""
    parts, buf, asc = [], "", None
    def flush():
        if not buf:
            return
        if asc:
            parts.append("'" + buf.replace("'", "''") + "'")
        else:
            parts.append("TO_CHAR(UNISTR('" + "".join("\\%04X" % ord(ch) for ch in buf) + "'))")
    for ch in t:
        if ch == "\n":
            flush(); buf = ""; asc = None
            parts.append("CHR(10)")
            continue
        a = ord(ch) < 128
        if asc is None or a == asc:
            buf += ch; asc = a
        else:
            flush(); buf = ch; asc = a
    flush()
    return " || ".join(parts)


for nm, t in (("HEAD", HEAD), ("TAIL", TAIL), ("OPEN", OPEN), ("CLOSE", CLOSE)):
    assert "\t" not in t, nm
    assert "\\" not in t, nm   # UNISTR 이스케이프 충돌 방지

STAMP = f"-- SOURCE-FRESH: SCM_MGR.{OBJ} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_blk    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_s      PLS_INTEGER;
    v_e      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_head   CONSTANT VARCHAR2(4000) := {plx(HEAD)};
    c_tail   CONSTANT VARCHAR2(4000) := {plx(TAIL)};
    c_open   CONSTANT VARCHAR2(4000) := {plx(OPEN)};
    c_close  CONSTANT VARCHAR2(4000) := {plx(CLOSE)};
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        IF p_src IS NULL THEN RETURN 0; END IF;
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, 'STOP - ' || p_name || ' ' || p_got || ' (expected ' || p_exp || '). 00_PRECHECK result please. source unchanged');
        END IF;
    END;
"""
LOAD = f"""    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;"""
COMPILE = f"""    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{OBJ}' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, 'COMPILE FAIL(' || v_st || ', errors ' || v_err || ') -> source restored. run 90_VERIFY');
    END IF;"""
POST = f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' ORDER BY OBJECT_TYPE;"

LOCATE = """    v_s := DBMS_LOB.INSTR(v_src, c_head);
    v_e := DBMS_LOB.INSTR(v_src, c_tail);"""

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] DMF0035(SALES PLAN) {OBJ} BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL 의 40사업부 [PJ2024-50611] 계획구간 RTF 재적재 블록 전체를 주석 처리
--   (Sales Plan Waterfall 데이터 RTF 중복 현상 — 재적재 조인에 CURRENCY 가 없어 같은 키의 다른 통화 행(USD)으로 수량이 복제됨)
-- 범위: 위 블록 1곳(IF p_division_id = '40' ~ END IF). 블록 안의 힌트 '/*+ NO_PARALLEL */' 는 블록주석 중첩 불가로 '\\*+ NO_PARALLEL *\\' 표기
--       원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 시작/끝 앵커 위치로 감싼다 → CREATE OR REPLACE (사내 전체본 복사 아님). 한글 문구 = UNISTR
-- 가드: 마커 존재 시 무동작 · 앵커 시작 1 / 끝 1 아니면 중단(원문 무변경) · 마커 {MARK_N}줄 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied (marker found). source unchanged');
        RETURN;
    END IF;
    expect('HEAD anchor', cnt(v_src, c_head), 1);
    expect('TAIL anchor', cnt(v_src, c_tail), 1);
{LOCATE}
    IF v_s >= v_e THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - HEAD after TAIL. source unchanged');
    END IF;
    v_blk := SUBSTR(v_src, v_s, v_e + LENGTH(c_tail) - v_s);
    expect('backslash-star in block', cnt(v_blk, '\\*'), 0);
    expect('star-backslash in block', cnt(v_blk, '*\\'), 0);
    v_blk := REPLACE(REPLACE(v_blk, '/*', '\\*'), '*/', '*\\');
    v_new := SUBSTR(v_src, 1, v_s - 1) || c_open || v_blk || c_close || SUBSTR(v_src, v_e + LENGTH(c_tail));
    expect('marker after build', cnt(v_new, c_mark), {MARK_N});
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED - {OBJ} BODY ' || v_st || ' / marker {MARK_N} / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] DMF0035(SALES PLAN) {OBJ} 원복 (전체 F5, 값 입력 없음, 멱등) — START~END 사이 역치환 후 마커 2줄·주석 경계 제거
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - no marker (not applied). source unchanged');
        RETURN;
    END IF;
    expect('OPEN text', cnt(v_src, c_open), 1);
    expect('CLOSE text', cnt(v_src, c_close), 1);
    v_s := DBMS_LOB.INSTR(v_src, c_open);
    v_e := DBMS_LOB.INSTR(v_src, c_close);
    IF v_s >= v_e THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - OPEN after CLOSE. source unchanged');
    END IF;
    v_blk := SUBSTR(v_src, v_s + LENGTH(c_open), v_e - v_s - LENGTH(c_open));
    v_blk := REPLACE(REPLACE(v_blk, '\\*', '/*'), '*\\', '*/');
    v_new := SUBSTR(v_src, 1, v_s - 1) || v_blk || SUBSTR(v_src, v_e + LENGTH(c_close));
    expect('marker after build', cnt(v_new, c_mark), 0);
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK - {OBJ} BODY ' || v_st || ' / marker 0 / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] DMF0035(SALES PLAN) {OBJ} 적용 전 상태
-- * [L0] 접속 DB · 문자셋 · {OBJ} 상태·LAST_DDL
-- * [L1] 앵커 시작 1 / 끝 1 · 블록 안 역슬래시 표기 0 (PASS 기대, DBMS_OUTPUT)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 지금 {OBJ} 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW,
       (SELECT VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER='NLS_CHARACTERSET') DB_CHARSET FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('L1 N/A - already applied (marker found). 10 rerun is no-op; see 90_VERIFY');
        RETURN;
    END IF;
{LOCATE}
    DBMS_OUTPUT.PUT_LINE('L1 HEAD anchor ' || cnt(v_src, c_head) || ' / TAIL anchor ' || cnt(v_src, c_tail) || ' -> '
        || CASE WHEN cnt(v_src, c_head) = 1 AND cnt(v_src, c_tail) = 1 AND v_s < v_e THEN 'PASS' ELSE 'FAIL (1/1 expected) -> do not run 10, send this result' END);
    IF cnt(v_src, c_head) = 1 AND cnt(v_src, c_tail) = 1 AND v_s < v_e THEN
        v_blk := SUBSTR(v_src, v_s, v_e + LENGTH(c_tail) - v_s);
        DBMS_OUTPUT.PUT_LINE('L1 block chars ' || LENGTH(v_blk) || ' (corp 23879) / comment-open ' || cnt(v_blk, '/*') || ' / comment-close ' || cnt(v_blk, '*/')
            || ' / backslash tokens ' || (cnt(v_blk, '\\*') + cnt(v_blk, '*\\')) || ' -> '
            || CASE WHEN cnt(v_blk, '\\*') + cnt(v_blk, '*\\') = 0 AND cnt(v_blk, '/*') = cnt(v_blk, '*/') THEN 'PASS' ELSE 'FAIL -> send this result' END);
    END IF;
END;
/
SELECT 'L2 marker' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN 'not applied (expected)' ELSE 'applied - 10 rerun is no-op by guard' END JUDGE
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 running' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] DMF0035(SALES PLAN) 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 {MARK_N}줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 시작/끝 문구 각 1 · 원래 앵커(감싸기 전 시작) 0
-- * 화면 확인: DMF0035 · PLAN TYPE=SALES PLAN · 40 · SP_W_20261001_V001 · MCCM348014A3 · SCUD_CN_FOC
--   → DAP 는 CNY 행만(원천에 CURRENCY 공란 행이 있으면 그 행 수량만 별도 통화로 나옴 — 05_DIAG D1 참고)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'V1 marker' CHK, COUNT(*) N, CASE WHEN COUNT(*) = {MARK_N} THEN 'PASS' ELSE 'FAIL (not applied or marker count mismatch)' END JUDGE
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 status' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{OBJ}')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
DECLARE
{DECL}BEGIN
{LOAD}
    DBMS_OUTPUT.PUT_LINE('V3 OPEN ' || cnt(v_src, c_open) || ' / CLOSE ' || cnt(v_src, c_close) || ' / live HEAD+IF ' || cnt(v_src, c_head) || ' -> '
        || CASE WHEN cnt(v_src, c_open) = 1 AND cnt(v_src, c_close) = 1 AND cnt(v_src, c_head) = 1 THEN 'PASS (HEAD now inside comment)' ELSE 'FAIL (1/1/1 expected)' END);
    v_s := DBMS_LOB.INSTR(v_src, c_open);
    v_e := DBMS_LOB.INSTR(v_src, c_close);
    IF v_s > 0 AND v_e > v_s THEN
        v_blk := SUBSTR(v_src, v_s + LENGTH(c_open), v_e - v_s - LENGTH(c_open));
        DBMS_OUTPUT.PUT_LINE('V3 inner comment-close tokens ' || cnt(v_blk, '*/') || ' -> ' || CASE WHEN cnt(v_blk, '*/') = 0 THEN 'PASS' ELSE 'FAIL' END);
    END IF;
END;
/
"""

V, IT, ST, DV, IC = DIAG["ver"], DIAG["item"], DIAG["site"], DIAG["div"], DIAG["inco"]
MEAS = "'RTF_SYS_RP','RTF_SCP','VMI_In_Plan','AS_In_Plan','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','SCM_FCST'"
NOW = "TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD')"
DIAGSQL = f"""-- 05_DIAG — 조회 전용 (전체 F5, 값 입력 없음). DMF0035 SALES PLAN · {DV} · {V} · {IT} · {ST} · {IC} 에 USD 가 나오는 사유 확인
-- 판정 순서
--  D0  {OBJ} 에 [{MARK}] 반영 여부 (0 = 미반영 → 아래 D4 복제가 화면에 나타나는 상태)
--  D1  원천(SALES_PLAN_C / ETC_PLAN_C / RESULT_C) 의 통화 분포 — CURRENCY 공란 행 존재 여부
--  D2  SITE_ITEM 통화 — 조회 SP 가 CURRENCY 공란 행을 이 값으로 채운다 (PKG_DMF0022 'CURRENCY 를 사용해야 하므로 여기서 UPDATE')
--  D3  계획구간(now 이후) 재적재 키 = 원천 키 + 채워진 통화 → 같은 INCOTERMS 에 통화 2종이면 원인 조건 성립
--  D4  [PJ2024-50611] 재적재 조인(통화 미포함) 이 만드는 행 — KEY_CURRENCY(USD) 에 SRC_CURRENCY(CNY) 수량이 붙으면 '복제' 확정
--  * now = 이번 주 월요일(화면 nowYyyymmdd 와 같다고 가정). 다르면 {NOW} 을 화면 값 'YYYYMMDD' 로 바꿔 실행
SET LINESIZE 260 PAGESIZE 500
SET DEFINE OFF
SELECT 'D0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, {NOW} NOW_YYYYMMDD,
       (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') MARKER_LINES,
       (SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' AND OBJECT_TYPE='PACKAGE BODY') LAST_DDL
  FROM DUAL;

SELECT 'D1' CHK, SRC, INCOTERMS, NVL(CURRENCY,'(NULL)') CURRENCY, MEASURE, MIN(YYYYMMDD) MIN_YMD, MAX(YYYYMMDD) MAX_YMD, COUNT(*) CNT, SUM(QTY) SUM_QTY
  FROM (SELECT 'SALES_PLAN_C' SRC, INCOTERMS, CURRENCY, MEASURE, YYYYMMDD, QTY FROM SCM_MGR.DM_PLN_SALES_PLAN_C
         WHERE VERSION_NO='{V}' AND DIVISION_ID='{DV}' AND ITEM_ID='{IT}' AND SCM_SITE_ID='{ST}'
        UNION ALL
        SELECT 'ETC_PLAN_C', INCOTERMS, CURRENCY, MEASURE, YYYYMMDD, QTY FROM SCM_MGR.DM_PLN_SALES_ETC_PLAN_C
         WHERE VERSION_NO='{V}' AND DIVISION_ID='{DV}' AND ITEM_ID='{IT}' AND SCM_SITE_ID='{ST}'
        UNION ALL
        SELECT 'RESULT_C', INCOTERMS, CURRENCY, MEASURE, YYYYMMDD, QTY FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C
         WHERE VERSION_NO='{V}' AND DIVISION_ID='{DV}' AND ITEM_ID='{IT}' AND SCM_SITE_ID='{ST}')
 GROUP BY SRC, INCOTERMS, CURRENCY, MEASURE
 ORDER BY SRC, INCOTERMS, MEASURE, CURRENCY;

SELECT 'D2' CHK, PROJECT_CODE, CURRENCY, VALID_YN
  FROM SCM_MGR.SCM_MST_SITE_ITEM
 WHERE DIVISION_ID='{DV}' AND ITEM_ID='{IT}' AND SCM_SITE_ID='{ST}'
 ORDER BY PROJECT_CODE;

WITH SRC AS (
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.YYYYMMDD,
           A.CELL_PROD_SITE_ID, A.CURRENCY RAW_CURRENCY,
           NVL(A.CURRENCY, (SELECT MIN(B.CURRENCY) KEEP (DENSE_RANK FIRST ORDER BY ROWID) FROM SCM_MGR.SCM_MST_SITE_ITEM B
                             WHERE B.DIVISION_ID=A.DIVISION_ID AND B.PROJECT_CODE=A.PROJECT_CODE AND B.SCM_SITE_ID=A.SCM_SITE_ID AND B.ITEM_ID=A.ITEM_ID)) KEY_CURRENCY
      FROM SCM_MGR.DM_PLN_SALES_PLAN_C A
     WHERE A.VERSION_NO='{V}' AND A.DIVISION_ID='{DV}' AND A.ITEM_ID='{IT}' AND A.SCM_SITE_ID='{ST}' AND A.QTY <> 0
)
SELECT 'D3' CHK, INCOTERMS, MEASURE, KEY_CURRENCY, NVL(RAW_CURRENCY,'(NULL)') RAW_CURRENCY, MIN(YYYYMMDD) MIN_YMD, MAX(YYYYMMDD) MAX_YMD, COUNT(*) CNT
  FROM SRC
 WHERE YYYYMMDD >= {NOW} AND MEASURE IN ({MEAS})
 GROUP BY INCOTERMS, MEASURE, KEY_CURRENCY, RAW_CURRENCY
 ORDER BY INCOTERMS, MEASURE, KEY_CURRENCY;

WITH SRC AS (
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE,
           A.MEASURE, A.YYYYMMDD, A.CELL_PROD_SITE_ID,
           NVL(A.CURRENCY, (SELECT MIN(B.CURRENCY) KEEP (DENSE_RANK FIRST ORDER BY ROWID) FROM SCM_MGR.SCM_MST_SITE_ITEM B
                             WHERE B.DIVISION_ID=A.DIVISION_ID AND B.PROJECT_CODE=A.PROJECT_CODE AND B.SCM_SITE_ID=A.SCM_SITE_ID AND B.ITEM_ID=A.ITEM_ID)) KEY_CURRENCY
      FROM SCM_MGR.DM_PLN_SALES_PLAN_C A
     WHERE A.VERSION_NO='{V}' AND A.DIVISION_ID='{DV}' AND A.ITEM_ID='{IT}' AND A.SCM_SITE_ID='{ST}' AND A.QTY <> 0
       AND A.YYYYMMDD >= {NOW} AND A.MEASURE IN ({MEAS})
), K AS (   -- GT_DM22_RAW_DATA_TEMP40_KEY 상당 (CURRENCY 포함 키)
    SELECT DISTINCT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, CELL_PROD_SITE_ID, KEY_CURRENCY
      FROM SRC
)
SELECT 'D4' CHK, K.INCOTERMS, K.MEASURE, K.KEY_CURRENCY, NVL(B.CURRENCY,'(NULL)') SRC_CURRENCY, COUNT(*) REINSERT_ROWS, SUM(B.QTY) REINSERT_QTY,
       CASE WHEN NVL(B.CURRENCY, K.KEY_CURRENCY) <> K.KEY_CURRENCY THEN 'DUPLICATED (other-currency qty attached)' ELSE 'own' END JUDGE
  FROM K
  JOIN SCM_MGR.DM_PLN_SALES_PLAN_C B          -- 2-2) SP 분기 재적재 조인과 같은 키 (CURRENCY 없음)
    ON  K.DIVISION_ID       = B.DIVISION_ID
   AND  K.VERSION_NO        = B.VERSION_NO
   AND  K.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
   AND  K.PROJECT_CODE      = B.PROJECT_CODE
   AND  K.SCM_SITE_ID       = B.SCM_SITE_ID
   AND  K.ITEM_ID           = B.ITEM_ID
   AND  K.INCOTERMS         = B.INCOTERMS
   AND  K.DOM_EXP           = B.DOM_EXP
   AND  K.FCST_TYPE         = B.FCST_TYPE
   AND  K.MEASURE           = B.MEASURE
   AND  B.YYYYMMDD         >= {NOW}
   AND  K.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
 GROUP BY K.INCOTERMS, K.MEASURE, K.KEY_CURRENCY, B.CURRENCY
 ORDER BY K.INCOTERMS, K.MEASURE, K.KEY_CURRENCY, B.CURRENCY;
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "05_DIAG_CURRENCY_CLOUD.sql": DIAGSQL, "10_APPLY_RTFDUP_PATCH.sql": APPLY,
         "90_VERIFY.sql": VERIFY, "99_ROLLBACK_RTFDUP_PATCH.sql": ROLLBACK}
if len(sys.argv) > 1:   # 리허설 버전 치환 시 DIAG 만 별도 사본으로
    open(os.path.join(HERE, f"_rehearsal_05_DIAG_{DIAG['ver']}.sql"), "w", encoding="utf-8", newline="\n").write(DIAGSQL)
    print("wrote rehearsal diag only"); sys.exit(0)
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
skip = ROLLBACK.replace("    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN", "    IF 1 = 1 THEN  -- SKIP-COPY", 1)
assert skip != ROLLBACK
open(os.path.join(HERE, "_rehearsal_99_SKIPCOPY.sql"), "w", encoding="utf-8", newline="\n").write(skip)
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"{OBJ} BODY (LF) applied md5={hashlib.md5(APPLIED.encode('utf-8')).hexdigest()} pre md5={hashlib.md5(PRE.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl)
