"""DMF0049_GAP358_GDWDUPNVL_CLOUD_20261015 패키지 생성기.

GAP 358 — DMF0049 저장 SP(P_DMF0049_SAVE_SALES_ETC_REPORT_C) GDW 중복 키 검사 연결 조건 12개
  `A.x = B.x` → `NVL(A.x,'/') = NVL(B.x,'/')` (AS-IS MSSQL ''='' 파리티, 센티널 '/' — 사용자 지시 2026-10-15).

모든 표지는 ASCII 다(한글 비교 없음). FRESH-GATE(사내 BODY 재조회 + 마커 1) + 시뮬레이터(수정 전→적용==적용본 · 적용본→원복==수정 전).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\GAP358_DMF0049_GDWDUP_20261015"
PRE_FILE = os.path.join(CORP, "PKG_DMF0049_BODY.ASIS_20261015_183625.sql")
OBJ = "PKG_DMF0049"
MARK = "GAP358 2026-10-15"
KEYS = ["DIVISION_ID", "DEPARTMENT_ID", "DEPT_ID", "ITEM_ID", "MEASURE", "YYYYMMDD", "CURRENCY",
        "COMPANY_ID", "END_CUST_REPORT", "CUST_REPORT", "PRODUCT_GROUP", "COUNTRY_CODE"]
HEAD_OLD = "          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B\n                  ON A.VERSION_NO = B.VERSION_NO\n"
HEAD_NEW = ("          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B\n"
            f"                  ON A.VERSION_NO = B.VERSION_NO  --[{MARK}] 12 keys: empty(NULL) equality NVL(x,'/') both sides (AS-IS MSSQL ''='' parity)\n")
OLD = HEAD_OLD + "".join(f"                 AND A.{k} = B.{k}\n" for k in KEYS)
NEW = HEAD_NEW + "".join(f"                 AND NVL(A.{k},'/') = NVL(B.{k},'/')\n" for k in KEYS)

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
APPLIED = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
PRE = open(PRE_FILE, encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert APPLIED.count(MARK) == 1 and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"
assert PRE.count(OLD) == 1 and APPLIED.count(NEW) == 1
assert PRE.replace(OLD, NEW) == APPLIED, "시뮬레이터: 수정 전 → 적용 ≠ 적용본"
assert APPLIED.replace(NEW, OLD) == PRE, "시뮬레이터: 적용본 → 원복 ≠ 수정 전"
print("simulator OK")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.{OBJ} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_old    CONSTANT VARCHAR2(2000) := '{q(OLD)}';
    c_new    CONSTANT VARCHAR2(2000) := '{q(NEW)}';
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

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 358 {OBJ} BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0049 저장(P_DMF0049_SAVE_SALES_ETC_REPORT_C) GDW 중복 키 검사 [E20250418-001567] 의 연결 조건 12개를
--   `A.x = B.x` → `NVL(A.x,'/') = NVL(B.x,'/')` 로 바꾼다. AS-IS(MSSQL)는 빈 값끼리('' = '') 같다고 보지만
--   Oracle 은 빈 값이 NULL 이라 비교가 성립하지 않아, 빈 칸(Country·Cust.(Report) 등)이 있는 행이 중복 검사에서 빠졌다.
-- 범위: 검증 SELECT 1문장(13줄). 저장 로직 · 원장 · 메타 · FE · 권한 · GTT 정의 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 문구로 치환(한글 비교 없음) → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 블록이 1건이 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
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
    IF cnt(v_new, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 중복 검사 연결 블록 ' || cnt(v_new, c_old) || '건 (1 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    v_new := REPLACE(v_new, c_old, c_new);
    IF cnt(v_new, c_new) <> 1 OR cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치. 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — {OBJ} BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 358 원복 (전체 F5, 값 입력 없음, 멱등) — ASCII 문구로 역치환
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_new, c_new) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 블록 ' || cnt(v_new, c_new) || '건 (1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_new, c_new, c_old);
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 OR cnt(v_new, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {OBJ} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 358 적용 전 상태
-- * [L0] 접속 DB · {OBJ} 상태·LAST_DDL
-- * [L1] 대상 블록(중복 검사 연결 조건 13줄) 건수 — 1 PASS 기대 (DBMS_OUTPUT)
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
    DBMS_OUTPUT.PUT_LINE('L1 대상 블록 ' || cnt(v_src, c_old) || '건 → ' || CASE WHEN cnt(v_src, c_old) = 1 THEN 'PASS' WHEN cnt(v_src, c_new) = 1 THEN '이미 적용됨(10 은 SKIP)' ELSE 'FAIL → 10 실행 금지·결과 회신' END);
END;
/
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' AND OBJECT_TYPE='PACKAGE');
"""

nvl_in = ",".join(f"'                 AND NVL(A.{k},''/'') = NVL(B.{k},''/'')'" for k in KEYS)
raw_in = ",".join(f"'                 AND A.{k} = B.{k}'" for k in KEYS)
VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 358 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 1줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 NVL 12줄 PASS / 구 '=' 12줄 0 PASS
-- * V4 (참고) Div 40 최신 ETC Report 버전 자기연결 성립 행 — 구 조건(=) vs 신 조건(NVL '/'): 신 조건 = 전체 행이면 정상
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{OBJ}')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 NVL' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 12 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) IN ({nvl_in})
UNION ALL
SELECT 'V3 구조건', COUNT(*), CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL — 회신' END
  FROM USER_SOURCE WHERE NAME='{OBJ}' AND TYPE='PACKAGE BODY' AND RTRIM(TEXT, CHR(10)||CHR(13)) IN ({raw_in});
WITH V AS (SELECT MAX(VERSION_NO) VER FROM DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID = '40')
SELECT 'V4 참고' CHK, V.VER,
       (SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO = V.VER AND DIVISION_ID = '40') TOTAL_ROWS,
       (SELECT COUNT(DISTINCT A.ROWID) FROM DM_PLN_SALES_ETC_REPORT_C A JOIN DM_PLN_SALES_ETC_REPORT_C B
           ON A.VERSION_NO = B.VERSION_NO {" ".join(f"AND A.{k} = B.{k}" for k in KEYS)}
         WHERE A.VERSION_NO = V.VER AND A.DIVISION_ID = '40') OLD_EQ_MATCH,
       (SELECT COUNT(DISTINCT A.ROWID) FROM DM_PLN_SALES_ETC_REPORT_C A JOIN DM_PLN_SALES_ETC_REPORT_C B
           ON A.VERSION_NO = B.VERSION_NO {" ".join(f"AND NVL(A.{k},'/') = NVL(B.{k},'/')" for k in KEYS)}
         WHERE A.VERSION_NO = V.VER AND A.DIVISION_ID = '40') NEW_NVL_MATCH
  FROM V;
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_GAP358_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, "99_ROLLBACK_GAP358_PATCH.sql": ROLLBACK}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"{OBJ} BODY (LF) applied md5={hashlib.md5(APPLIED.encode('utf-8')).hexdigest()} pre md5={hashlib.md5(PRE.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl)
