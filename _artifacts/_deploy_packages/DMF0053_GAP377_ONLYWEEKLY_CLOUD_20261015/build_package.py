"""DMF0053_GAP377_ONLYWEEKLY_CLOUD_20261015 패키지 생성기.

GAP 377 — DMF0053 Bucket Only Weekly 주 합계 누락·월 걸친 주 칸 중복·기간 표기 없음.
치환 정의(T1~T3 머리글 각 2건 · G1~G2 조회 각 1건)는 사내 적용 스크립트 apply_corp.py 의 OPS 를 그대로 import 한다(단일 원천).
모든 문구는 ASCII(한글 비교 없음). FRESH-GATE(사내 BODY 재조회 + 마커 10) + 시뮬레이터(수정 전→적용==적용본 · 적용본→원복==수정 전).
"""
import os, sys, datetime, hashlib
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\GAP377_DMF0053_ONLYWEEKLY_20261015"
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, CORP)
from ora import conn_info
from apply_corp import OPS, MARK, MARK_N, apply_ops, rollback_ops
import oracledb

for nm, o, n, c in OPS:
    assert all(ord(ch) < 128 for ch in o + n), f"{nm} 비ASCII 문구"

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
PRE_FILE = os.path.join(CORP, "PKG_DMF0053_BODY.ASIS_20261015_191127.sql")
OBJ = "PKG_DMF0053"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
APPLIED = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
PRE = open(PRE_FILE, encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert APPLIED.count(MARK) == MARK_N and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"
assert apply_ops(PRE) == APPLIED, "시뮬레이터: 수정 전 → 적용 ≠ 적용본"
assert rollback_ops(APPLIED) == PRE, "시뮬레이터: 적용본 → 원복 ≠ 수정 전"
print("simulator OK")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.{OBJ} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
CONSTS = "".join(f"    c_{nm.lower()}_old CONSTANT VARCHAR2(4000) := '{q(o)}';\n    c_{nm.lower()}_new CONSTANT VARCHAR2(4000) := '{q(n)}';\n" for nm, o, n, c in OPS)
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40) := '{MARK}';
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
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' ' || p_got || '건 (' || p_exp || ' 기대). 00_PRECHECK 회신. 원문 무변경');
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
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;"""
POST = f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' ORDER BY OBJECT_TYPE;"

CHK_APPLY = "".join(f"    expect('{nm}', cnt(v_new, c_{nm.lower()}_old), {c});\n" for nm, o, n, c in OPS)
DO_APPLY = "".join(f"    v_new := REPLACE(v_new, c_{nm.lower()}_old, c_{nm.lower()}_new);\n" for nm, o, n, c in OPS)
CHK_RB = "".join(f"    expect('{nm}', cnt(v_new, c_{nm.lower()}_new), {c});\n" for nm, o, n, c in OPS)
DO_RB = "".join(f"    v_new := REPLACE(v_new, c_{nm.lower()}_new, c_{nm.lower()}_old);\n" for nm, o, n, c in reversed(OPS))
PRE_LINES = "".join(f"    DBMS_OUTPUT.PUT_LINE('L1 {nm} ' || cnt(v_src, c_{nm.lower()}_old) || '건 → ' || CASE WHEN cnt(v_src, c_{nm.lower()}_old) = {c} THEN 'PASS' ELSE 'FAIL ({c} 기대) → 10 실행 금지·결과 회신' END);\n" for nm, o, n, c in OPS)

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 377 {OBJ} BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: Customer FCST Waterfall 조회조건 Bucket = Only Weekly 를 AS-IS 와 같게 한다.
--   머리글 P_DMF0053_GET_SPREAD_TITLE (사용자설정·기본 두 분기 모두)
--     T1 기간 칸 폭 Only Weekly 100 (그 외 50)
--     T2·T3 월별 주 칸(W_월+주차)·월 칸(M_) 은 Only Weekly 에서 제외
--     T3 Only Weekly 주 칸 = 'W_' + 그 주의 기간 내 마지막 날 월 + 주차, 대분류 'MM.DD ~ MM.DD' (AS-IS [C20220620-000567])
--   조회 P_DMF0053_GET_CUST_FCST_WATERFALL 동적 SQL
--     G1·G2 Only Weekly 주 키를 날짜별 월이 아니라 '그 주의 기간 내 마지막 날 월 + 주차' 로 (AS-IS #CALENDAR) — 월에 걸친 주의 앞달 수량 누락 해소
-- 범위: 위 두 프로시저. Monthly·Weekly·Daily 결과 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 문구로 치환(한글 비교 없음) → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 각 대상 건수(T1~T3 2 / G1~G2 1)가 다르면 중단(원문 무변경) · 마커 {MARK_N}곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
{CHK_APPLY}{DO_APPLY}    expect('조립 결과 마커', cnt(v_new, c_mark), {MARK_N});
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — {OBJ} BODY ' || v_st || ' · 마커 {MARK_N}곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 377 원복 (전체 F5, 값 입력 없음, 멱등) — ASCII 문구로 역치환
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
{CHK_RB}{DO_RB}    expect('조립 결과 마커', cnt(v_new, c_mark), 0);
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {OBJ} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 377 적용 전 상태
-- * [L0] 접속 DB · {OBJ} 상태·LAST_DDL
-- * [L1] 대상 문구 건수 — T1~T3 각 2 · G1~G2 각 1 (전부 PASS 기대, DBMS_OUTPUT)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 지금 {OBJ} 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
DECLARE
{DECL}BEGIN
{LOAD}
{PRE_LINES}END;
/
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 377 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 {MARK_N}줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0
-- * V3 (참고) 2026-09-01~2027-02-28 Only Weekly 머리글 주 칸 = 26 · W40 대분류 '09.28 ~ 10.04' (머리글 SP 와 같은 달력 식)
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = {MARK_N} THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{OBJ}')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 참고' CHK, COUNT(*) WEEK_COLS,
       MAX(CASE WHEN COLUMN_NAME = 'W_20261040' THEN LARGE_LABEL END) W40_LABEL,
       CASE WHEN COUNT(*) = 26 AND MAX(CASE WHEN COLUMN_NAME = 'W_20261040' THEN LARGE_LABEL END) = '09.28 ~ 10.04' THEN 'PASS' ELSE '회신' END JUDGE
  FROM ( SELECT 'W_' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK AS COLUMN_NAME
              , SUBSTR(MIN(A.BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(A.BASIS_YYYYMMDD), 7, 2)
                || ' ~ ' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 7, 2) AS LARGE_LABEL
           FROM SCM_SYS_CALENDAR_M A
          WHERE A.BASIS_YYYYMMDD BETWEEN '20260901' AND '20270228'
          GROUP BY A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME );
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_GAP377_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, "99_ROLLBACK_GAP377_PATCH.sql": ROLLBACK}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"{OBJ} BODY (LF) applied md5={hashlib.md5(APPLIED.encode('utf-8')).hexdigest()} pre md5={hashlib.md5(PRE.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl)
