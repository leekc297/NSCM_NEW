"""DMF0049_SOLDTONULL_CLOUD_20261022 패키지 생성기.

DMF0049 저장 시 빈 Sold-To 가 '/'(이전 세대 '-') 로 저장되어 기존 NULL 행과 정렬 위치가 달라지는 문제.
  P_DMF0049_SAVE_SALES_ETC_REPORT_C 의 INSERT 2곳 NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''), '/'|'-')
  → NULLIF(RTRIM(A.SOLDTO_CODE),'') (AS-IS 동일 — 빈값 그대로 = Oracle NULL). 원래 줄은 '--' 주석 보존.
  데이터: DM_PLN_SALES_ETC_REPORT_C SOLDTO_CODE IN ('-','/') → NULL (백업 테이블 선적재). _H 이력은 무변경.

방식: 클라우드는 자기 USER_SOURCE 를 줄 단위로 패치(전체본 교체 금지). 위치는 ASCII 토큰만으로 찾는다.
FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 재조회본(적용본, 마커 2)과 착수 기준본(00_BACKUP, 마커 0)으로
  '수정 전 → 적용 == 적용본' · '적용본 → 원복 == 수정 전' 이 문자 단위로 일치할 때만 SQL 을 쓴다.
"""
import os, sys, glob, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
OBJ = "PKG_DMF0049"
MARK = "[E20261022-SOLDTONULL]"
TOKS = ["NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''), '/')", "NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''), '-')"]
NEW = "NULLIF(RTRIM(A.SOLDTO_CODE),'')"
TAIL = "    -- 2026.10.22 " + MARK + " AS-IS 동일 빈 Sold-To = NULL 저장('/' 치환 제거 — 기존 NULL 행과 정렬 일치)\n"
T = "DM_PLN_SALES_ETC_REPORT_C"
BAK = "DM_PLN_SALES_ETC_REPORT_C_BAK20261022_SOLDTO"
PK = "B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DATA_SEQ = A.DATA_SEQ AND B.MEASURE = A.MEASURE AND B.YYYYMMDD = A.YYYYMMDD"
assert all(ord(ch) < 128 for ch in "".join(TOKS) + NEW + MARK), "앵커는 ASCII 만"

u, p, d = conn_info()
cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); host = cur.fetchone()[0]
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
LINES_APPLIED = [r[0] for r in cur]
APPLIED = "".join(LINES_APPLIED).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
bk = open(sorted(glob.glob(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0049_SOLDTONULL_20261022\00_BACKUP_*.sql"))[0], encoding="utf-8").read()
PRE = bk.split("\n", 1)[1][len("CREATE OR REPLACE "):].rstrip("\n").removesuffix("\n/").replace("\r\n", "\n")
assert APPLIED.count(MARK) == 2 and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"


def find_tok(line):
    for t in TOKS:
        if t in line:
            return line.index(t)
    return -1


# PL/SQL 과 같은 줄 단위 연산 (시뮬레이터)
def apply_ops(src):
    out = []
    for ln in src.splitlines(keepends=True):
        i = find_tok(ln)
        if i >= 0 and not ln.lstrip().startswith("--"):
            out += ["--" + ln, ln[:i] + NEW + TAIL]
        else:
            out.append(ln)
    return "".join(out)


def rollback_ops(src):
    ls, out = src.splitlines(keepends=True), []
    for k, ln in enumerate(ls):
        if MARK in ln:
            continue
        if k + 1 < len(ls) and MARK in ls[k + 1]:
            assert ln.startswith("--") and find_tok(ln) >= 0
            ln = ln[2:]
        out.append(ln)
    return "".join(out)


assert apply_ops(PRE).rstrip() == APPLIED.rstrip(), "시뮬레이터: 수정 전 → 적용 연산 ≠ 적용본"
assert rollback_ops(APPLIED).rstrip() == PRE.rstrip(), "시뮬레이터: 적용본 → 원복 연산 ≠ 수정 전"
print("simulator OK (apply == applied · rollback == pre)")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.{OBJ} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
DECL = f"""    TYPE t_lines IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    l        t_lines;
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    n        PLS_INTEGER := 0;
    i        PLS_INTEGER;
    v_ln     VARCHAR2(32767);
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_tok1   CONSTANT VARCHAR2(100)  := '{q(TOKS[0])}';
    c_tok2   CONSTANT VARCHAR2(100)  := '{q(TOKS[1])}';
    c_new    CONSTANT VARCHAR2(100)  := '{q(NEW)}';
    c_tail   CONSTANT VARCHAR2(400)  := '{q(TAIL)}';
"""
HELPERS = """    FUNCTION tok_pos(p VARCHAR2) RETURN PLS_INTEGER IS
    BEGIN
        RETURN CASE WHEN INSTR(p, c_tok1) > 0 THEN INSTR(p, c_tok1) ELSE INSTR(p, c_tok2) END;
    END;
    FUNCTION is_cmt(p VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN SUBSTR(LTRIM(p), 1, 2) = '--';
    END;
    PROCEDURE put(p VARCHAR2) IS
    BEGIN
        IF p IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v_new, LENGTH(p), p); END IF;
    END;"""
LOAD = f"""    SELECT TEXT BULK COLLECT INTO l FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' ORDER BY LINE;
    IF l.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — {OBJ} BODY 없음');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    FOR k IN 1 .. l.COUNT LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(l(k)), l(k));
    END LOOP;"""
COMPILE = f"""    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{OBJ}' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR x IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || x.LINE || ':' || x.POSITION || ' ' || x.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;"""
POST = f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{OBJ}' ORDER BY OBJECT_TYPE;"

APPLY = f"""{STAMP}
-- 10_APPLY — {MARK} DMF0049 저장 빈 Sold-To = NULL (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0049_SAVE_SALES_ETC_REPORT_C INSERT 2곳의 SOLDTO_CODE
--       NVL(NULLIF(RTRIM(A.SOLDTO_CODE),''), '/') (또는 '-') → NULLIF(RTRIM(A.SOLDTO_CODE),'')   (AS-IS 동일)
--       빈 Sold-To 가 '/' 로 저장되어 기존 NULL 행과 정렬(ORDER BY UPPER(SOLDTO_CODE))이 달라지던 증상 해소. 원래 줄은 '--' 주석 보존.
-- 범위: 저장 프로시저 2줄(+주석 2줄). 데이터는 20_DATA 에서 별도. 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 줄 단위로 읽어 ASCII 토큰으로 위치를 찾아 치환 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상(주석 아닌 줄) ≠ 2 이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}). 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}{HELPERS}
BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF tok_pos(l(k)) > 0 AND NOT is_cmt(l(k)) THEN n := n + 1; END IF;
    END LOOP;
    IF n <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — SOLDTO_CODE 빈값 치환 줄 ' || n || '건 (2 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        i := tok_pos(l(k));
        IF i > 0 AND NOT is_cmt(l(k)) THEN
            put('--' || l(k));
            put(SUBSTR(l(k), 1, i - 1) || c_new || c_tail);
        ELSE
            put(l(k));
        END IF;
    END LOOP;
    IF DBMS_LOB.INSTR(v_new, c_mark) = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 없음. 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — {OBJ} BODY ' || v_st || ' · 마커 2곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — {MARK} PKG 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 마커 줄 2개를 지우고, 바로 위 주석으로 남긴 원래 줄의 '--' 를 뗀다 (ASCII 토큰으로만 판정).
-- 가드: 마커 없음 → 무동작 · 마커 줄 ≠ 2 또는 윗줄이 원래 줄 주석이 아니면 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
-- 데이터 원복은 99_ROLLBACK_DATA (별도)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}{HELPERS}
BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF INSTR(l(k), c_mark) > 0 THEN
            IF k = 1 OR SUBSTR(l(k - 1), 1, 2) <> '--' OR tok_pos(l(k - 1)) = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 줄 위가 원래 줄 주석이 아님(L' || k || '). 원문 무변경');
            END IF;
            n := n + 1;
        END IF;
    END LOOP;
    IF n <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 마커 줄 ' || n || '건 (2 기대). 원문 무변경');
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF INSTR(l(k), c_mark) > 0 THEN
            NULL;
        ELSIF k < l.COUNT AND INSTR(l(k + 1), c_mark) > 0 THEN
            put(SUBSTR(l(k), 3));
        ELSE
            put(l(k));
        END IF;
    END LOOP;
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {OBJ} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

DATA = f"""-- 20_DATA — {MARK} {T}.SOLDTO_CODE '-'/'/' → NULL (전체 F5, 값 입력 없음, 멱등)
-- 대상: 저장 SP 빈값 치환('-' 2026-08-11~ · '/' 10월~)으로 생긴 행. AS-IS 이관분(빈 Sold-To)은 NULL 이라 무변경.
-- 백업: {BAK} (대상 행 전 컬럼) — 없으면 CTAS, 있으면 빠진 행만 추가. 백업이 대상 전부를 덮는지 확인한 뒤 UPDATE.
-- 이력(_H)은 저장 당시 기록이라 변경하지 않는다. 원복 = 99_ROLLBACK_DATA
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n  NUMBER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{BAK}';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE {BAK} AS SELECT * FROM {T} WHERE SOLDTO_CODE IN (''-'', ''/'')';
    ELSE
        EXECUTE IMMEDIATE 'INSERT INTO {BAK} SELECT * FROM {T} A WHERE A.SOLDTO_CODE IN (''-'', ''/'') AND NOT EXISTS (SELECT 1 FROM {BAK} B WHERE {PK})';
    END IF;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM {T} A WHERE A.SOLDTO_CODE IN (''-'', ''/'') AND NOT EXISTS (SELECT 1 FROM {BAK} B WHERE {PK})' INTO n;
    IF n > 0 THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, '중단 — 백업에 없는 대상 ' || n || '행. 데이터 무변경');
    END IF;
    UPDATE {T} SET SOLDTO_CODE = NULL WHERE SOLDTO_CODE IN ('-', '/');
    n := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DATA — SOLDTO_CODE NULL 정리 ' || n || '행 COMMIT · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, NVL(SOLDTO_CODE, '(NULL)') SOLDTO_CODE, COUNT(*) N FROM {T} WHERE SOLDTO_CODE IS NULL OR SOLDTO_CODE IN ('-', '/') GROUP BY NVL(SOLDTO_CODE, '(NULL)');
"""

ROLLBACK_DATA = f"""-- 99_ROLLBACK_DATA — {MARK} 20_DATA 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 백업 {BAK} 의 SOLDTO_CODE 로 되돌린다(현재 NULL 인 행만). 백업 테이블은 남긴다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n  NUMBER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = '{BAK}';
    IF n = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 백업 테이블 없음 (20_DATA 미실행). 데이터 무변경');
        RETURN;
    END IF;
    EXECUTE IMMEDIATE 'MERGE INTO {T} A USING {BAK} B ON (A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID AND A.DATA_SEQ = B.DATA_SEQ AND A.MEASURE = B.MEASURE AND A.YYYYMMDD = B.YYYYMMDD)'
                   || ' WHEN MATCHED THEN UPDATE SET A.SOLDTO_CODE = B.SOLDTO_CODE WHERE A.SOLDTO_CODE IS NULL';
    n := SQL%ROWCOUNT;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DATA ROLLED BACK — ' || n || '행 COMMIT');
END;
/
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). {MARK} 적용 전 상태 + 원인 판정
-- * [L0] 접속 DB · {OBJ} 상태·LAST_DDL
-- * [L1] 패치 대상 — 주석 아닌 SOLDTO_CODE 빈값 치환 줄 2 기대 (아니면 10 실행 금지, 결과 회신)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 데이터 — {T}.SOLDTO_CODE NULL / '-' / '/' 건수 (20_DATA 가 '-'·'/' 를 NULL 로 정리)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A50
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY'
   AND (INSTR(TEXT, '{q(TOKS[0])}') > 0 OR INSTR(TEXT, '{q(TOKS[1])}') > 0) AND SUBSTR(LTRIM(TEXT), 1, 2) <> '--';
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS (미적용)' ELSE '이미 적용됨 — 10 은 SKIP 됨' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, '{MARK}') > 0;
SELECT 'L3 데이터' CHK, DIVISION_ID, NVL(SOLDTO_CODE, '(NULL)') SOLDTO_CODE, COUNT(*) N, COUNT(DISTINCT VERSION_NO) VERS
  FROM {T} WHERE SOLDTO_CODE IS NULL OR SOLDTO_CODE IN ('-', '/') GROUP BY DIVISION_ID, NVL(SOLDTO_CODE, '(NULL)') ORDER BY 2, 3;
SELECT 'L3 백업' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS (백업 테이블 없음 — 20 이 생성)' ELSE '있음 — 20 은 빠진 행만 추가' END JUDGE
  FROM USER_TABLES WHERE TABLE_NAME = '{BAK}';
"""

VERIFY = f"""-- 90_VERIFY — 조회 전용 (전체 F5, 값 입력 없음). {MARK} 적용 뒤 확인
-- * [V1] 마커 줄 2 · 활성 빈값 치환 줄 0 · [V2] BODY VALID · 오류 0 · [V3] '-'/'/' 0
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A40
SELECT 'V1 마커' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, '{MARK}') > 0 AND INSTR(TEXT, '{q(NEW)}') > 0;
SELECT 'V1 치환줄' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS (활성 치환 없음)' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY'
   AND (INSTR(TEXT, '{q(TOKS[0])}') > 0 OR INSTR(TEXT, '{q(TOKS[1])}') > 0) AND SUBSTR(LTRIM(TEXT), 1, 2) <> '--';
SELECT 'V2 상태' CHK, O.STATUS, (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) ERRS,
       TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       CASE WHEN O.STATUS = 'VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) = 0 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME = '{OBJ}' AND O.OBJECT_TYPE = 'PACKAGE BODY';
SELECT 'V3 데이터' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL — 20_DATA 재실행·회신' END JUDGE
  FROM {T} WHERE SOLDTO_CODE IN ('-', '/');
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_SOLDTONULL_PATCH.sql": APPLY, "20_DATA_SOLDTO_NULL.sql": DATA,
         "90_VERIFY.sql": VERIFY, "99_ROLLBACK_SOLDTONULL_PATCH.sql": ROLLBACK, "99_ROLLBACK_DATA.sql": ROLLBACK_DATA}
for nme, t in files.items():
    open(os.path.join(OUT, nme), "w", encoding="utf-8", newline="\n").write(t)
md5 = lambda x: hashlib.md5(x.rstrip().encode("utf-8")).hexdigest()
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"HOST={host} LAST_DDL={last_ddl} FETCHED={fetched}\napplied md5={md5(APPLIED)}\npre     md5={md5(PRE)}\n")
print("written", list(files), "HOST", host, "LAST_DDL", last_ddl)
