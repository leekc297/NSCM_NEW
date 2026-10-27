"""DMF0042_EDITFLAG_TITLESET_CLOUD_20261022 패키지 생성기.

DMF0042 편집 불가(노란 셀 0) — 개인 컬럼 설정이 저장된 사용자는 조회 결과에 EDIT_FLAG 컬럼이 없다.
  P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 의 컬럼 목록 2분기 중 '개인 설정 있음' 분기(TITLESET_USER UNION ALL 숨은 고정 칸)가
  RTRIM(C.DEFAULT_FLAG, ' -') IS NULL 그대로라, 10-19 F-19 로 DEFAULT_FLAG 가 'N' 이 된 EDIT_FLAG 를 뺀다.
  → NVL(RTRIM(C.DEFAULT_FLAG, ' -'), 'N') = 'N' (기본 분기 L2709 와 같은 판정). 원래 줄은 '--' 주석으로 남긴다.

방식: 클라우드는 자기 USER_SOURCE 를 패치한다(전체본 교체 금지). 위치는 ASCII 토큰만으로 찾는다(대상 줄 주석의 한글은 비교하지 않음).
  구간 = GET 프로시저 안 'SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE' ~ ') WHERE ROWNUM <= 100'.
FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 재조회본(적용본, 마커 1)과 착수 기준본(00_BACKUP, 마커 0)으로
  '수정 전 → 적용 == 적용본' · '적용본 → 원복 == 수정 전' 이 문자 단위로 일치할 때만 SQL 을 쓴다.
"""
import os, sys, glob, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
OBJ = "PKG_DMF0042"
MARK = "[E20261022-EDITFLAG]"
IND = " " * 32
P_FROM = "  PROCEDURE P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA"
A_START = "                        SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE\n"
A_END = "                        ) WHERE ROWNUM <= 100\n"
OLD_HEAD = IND + "AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL"          # 수정 전 활성 줄 (줄 끝까지가 대상)
CMT_HEAD = IND + "--AND RTRIM(C.DEFAULT_FLAG, ' -') IS NULL"        # 적용 후 주석으로 남은 원래 줄
NEW_HEAD = IND + "AND NVL(RTRIM(C.DEFAULT_FLAG, ' -'), 'N') = 'N'   -- 2026.10.22 " + MARK

u, p, d = conn_info()
cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); host = cur.fetchone()[0]
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=OBJ)
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=OBJ)
APPLIED = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
bk = open(glob.glob(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0042_EDITFLAG_20261022\00_BACKUP_*.sql")[0], encoding="utf-8").read()
PRE = bk.split("\n", 1)[1][len("CREATE OR REPLACE "):].rstrip("\n").removesuffix("\n/").replace("\r\n", "\n")
if not PRE.endswith("\n") and APPLIED.endswith("\n"):
    PRE += "\n"
assert APPLIED.count(MARK) == 1 and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"
NEW_LINE = APPLIED[APPLIED.index(NEW_HEAD):APPLIED.index("\n", APPLIED.index(NEW_HEAD)) + 1]
assert all(ord(ch) < 128 for ch in P_FROM + A_START + A_END + OLD_HEAD + CMT_HEAD + NEW_HEAD), "앵커는 ASCII 만"


def rng(src):
    assert src.count(P_FROM) == 1
    p0 = src.index(P_FROM)
    s = src.index(A_START, p0)
    e = src.index(A_END, s)
    assert e - s < 3000, "구간 길이"
    return s, e


def apply_ops(src):
    lo, hi = rng(src)
    assert src.count(OLD_HEAD, lo, hi) == 1
    pos = src.index(OLD_HEAD, lo)
    return src[:pos] + IND + "--" + src[pos + len(IND):src.index("\n", pos) + 1] + NEW_LINE + src[src.index("\n", pos) + 1:]


def rollback_ops(src):
    lo, hi = rng(src)
    assert src.count(NEW_HEAD, lo, hi) == 1 and src.count(CMT_HEAD, lo, hi) == 1
    s = src.index(NEW_HEAD, lo); e = src.index("\n", s) + 1
    src = src[:s] + src[e:]
    c = src.index(CMT_HEAD, lo)
    return src[:c + len(IND)] + src[c + len(IND) + 2:]


assert apply_ops(PRE) == APPLIED, "시뮬레이터: 수정 전 → 적용 연산 ≠ 적용본"
assert rollback_ops(APPLIED) == PRE, "시뮬레이터: 적용본 → 원복 연산 ≠ 수정 전"
print("simulator OK (apply == applied · rollback == pre)")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.{OBJ} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    lo       PLS_INTEGER;
    hi       PLS_INTEGER;
    s        PLS_INTEGER;
    e        PLS_INTEGER;
    n        PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_ind    CONSTANT VARCHAR2(40)   := '{IND}';
    c_pfrom  CONSTANT VARCHAR2(200)  := '{q(P_FROM)}';
    c_astart CONSTANT VARCHAR2(200)  := '{q(A_START)}';
    c_aend   CONSTANT VARCHAR2(200)  := '{q(A_END)}';
    c_oldhd  CONSTANT VARCHAR2(200)  := '{q(OLD_HEAD)}';
    c_cmthd  CONSTANT VARCHAR2(200)  := '{q(CMT_HEAD)}';
    c_newhd  CONSTANT VARCHAR2(200)  := '{q(NEW_HEAD)}';
    c_new    CONSTANT VARCHAR2(2000) := '{q(NEW_LINE)}';
"""
HELPERS = """    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        k PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            k := k + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN k;
    END;
    -- 구간: GET 프로시저 시작(BODY 1건) 뒤 개인 컬럼 설정 분기의 숨은 고정 칸 서브쿼리
    --       'SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE' ~ ') WHERE ROWNUM <= 100'
    PROCEDURE rng IS
        p0 PLS_INTEGER;
    BEGIN
        IF cnt(v_new, c_pfrom, 1, DBMS_LOB.GETLENGTH(v_new) + 1) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — GET 프로시저 위치 1건 아님. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        p0 := DBMS_LOB.INSTR(v_new, c_pfrom);
        lo := DBMS_LOB.INSTR(v_new, c_astart, p0);
        hi := CASE WHEN lo > 0 THEN DBMS_LOB.INSTR(v_new, c_aend, lo) ELSE 0 END;
        IF NOT (lo > p0 AND hi > lo AND hi - lo < 3000) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — 개인 설정 분기 구간 확인 불가. 00_PRECHECK 회신. 원문 무변경');
        END IF;
    END;"""
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
-- 10_APPLY — {MARK} DMF0042 개인 컬럼 설정 사용자 EDIT_FLAG 누락 보정 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 컬럼 목록의 '개인 설정 있음' 분기에서 숨은 고정 칸 판정
--       RTRIM(C.DEFAULT_FLAG, ' -') IS NULL → NVL(RTRIM(C.DEFAULT_FLAG, ' -'), 'N') = 'N'  (기본 분기와 같은 판정)
--       DEFAULT_FLAG 'N' 인 EDIT_FLAG 가 빠져 화면 편집 셀(노란색)이 하나도 열리지 않던 증상 해소. 원래 줄은 '--' 주석 보존.
-- 범위: GET 프로시저 1줄(+주석 1줄). 데이터 · 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 토큰으로 위치를 찾아 치환 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 건수 ≠ 1 이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
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
    rng;
    n := cnt(v_new, c_oldhd, lo, hi);
    IF n <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — DEFAULT_FLAG 판정 줄 ' || n || '건 (1 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    s := DBMS_LOB.INSTR(v_new, c_oldhd, lo);
    e := DBMS_LOB.INSTR(v_new, CHR(10), s) + 1;
    v_new := SUBSTR(v_new, 1, s - 1) || c_ind || '--' || SUBSTR(v_new, s + LENGTH(c_ind), e - s - LENGTH(c_ind))
             || c_new || SUBSTR(v_new, e);
    IF DBMS_LOB.INSTR(v_new, c_mark) = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 없음. 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — {OBJ} BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — {MARK} 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 줄을 지우고 주석으로 남긴 원래 줄의 '--' 를 뗀다 — 위치는 ASCII 토큰으로만 찾는다(한글 비교 없음).
-- 가드: 마커 없음 → 무동작 · 대상 건수 ≠ 1 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
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
    rng;
    IF cnt(v_new, c_newhd, lo, hi) <> 1 OR cnt(v_new, c_cmthd, lo, hi) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 줄/주석 줄 1건 아님. 원문 무변경');
    END IF;
    s := DBMS_LOB.INSTR(v_new, c_newhd, lo);
    e := DBMS_LOB.INSTR(v_new, CHR(10), s) + 1;
    v_new := SUBSTR(v_new, 1, s - 1) || SUBSTR(v_new, e);
    s := DBMS_LOB.INSTR(v_new, c_cmthd, lo);
    v_new := SUBSTR(v_new, 1, s - 1 + LENGTH(c_ind)) || SUBSTR(v_new, s + LENGTH(c_ind) + 2);
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {OBJ} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). {MARK} 적용 전 상태 + 원인 판정
-- * [L0] 접속 DB · {OBJ} 상태·LAST_DDL
-- * [L1] 패치 앵커 — 전부 PASS 기대 (FAIL 이면 10 실행 금지, 결과 회신)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 원인 판정 — 숨은 고정 칸(VISIBLE_FLAG 'N') 의 DEFAULT_FLAG 값 · 개인 컬럼 설정 보유 사용자 수
--        EDIT_FLAG 의 DEFAULT_FLAG = 'N' 이면 개인 설정 보유 사용자는 EDIT_FLAG 미반환(본 패치 대상)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A40
COLUMN JUDGE FORMAT A50
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{OBJ}' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = K.EXPECT THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM ( SELECT 'GET 프로시저 시작' KIND, '{P_FROM}' TXT, 1 EXPECT FROM DUAL UNION ALL
         SELECT '개인 설정 분기 숨은 칸 SELECT', '{A_START.rstrip(chr(10))}', 1 FROM DUAL UNION ALL
         SELECT '개인 설정 분기 ROWNUM 100', '{A_END.rstrip(chr(10))}', 1 FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = '{OBJ}' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
SELECT 'L1 판정줄' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND SUBSTR(TEXT, 1, {len(OLD_HEAD)}) = '{q(OLD_HEAD)}';
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS (미적용)' ELSE '이미 적용됨 — 10 은 SKIP 됨' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND INSTR(TEXT, '{MARK}') > 0;
SELECT 'L3 메타' CHK, COLUMN_NAME, VISIBLE_FLAG, '[' || DEFAULT_FLAG || ']' DEFAULT_FLAG, VALID_YN, DIVISION_ID
  FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan' AND VISIBLE_FLAG = 'N' ORDER BY SORT_ORDER_NO;
SELECT 'L3 개인설정' CHK, COUNT(DISTINCT USER_ID) USERS
  FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan' AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C';
"""

VERIFY = f"""-- 90_VERIFY — 조회 전용 (전체 F5, 값 입력 없음). {MARK} 적용 뒤 확인
-- * [V1] 마커 줄 1 · 원래 줄 주석 1 · [V2] BODY VALID · 오류 0
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A40
SELECT 'V1 마커' CHK, COUNT(*) N, LISTAGG(LINE, ',') WITHIN GROUP (ORDER BY LINE) LINES,
       CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND SUBSTR(TEXT, 1, {len(NEW_HEAD)}) = '{q(NEW_HEAD)}';
SELECT 'V1 판정줄' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS (활성 IS NULL 판정 없음)' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME = '{OBJ}' AND TYPE = 'PACKAGE BODY' AND SUBSTR(TEXT, 1, {len(OLD_HEAD)}) = '{q(OLD_HEAD)}';
SELECT 'V2 상태' CHK, O.STATUS, (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) ERRS,
       TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       CASE WHEN O.STATUS = 'VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME = O.OBJECT_NAME AND E.TYPE = O.OBJECT_TYPE) = 0 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME = '{OBJ}' AND O.OBJECT_TYPE = 'PACKAGE BODY';
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_EDITFLAG_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY,
         "99_ROLLBACK_EDITFLAG_PATCH.sql": ROLLBACK}
for nme, t in files.items():
    open(os.path.join(OUT, nme), "w", encoding="utf-8", newline="\n").write(t)
md5 = lambda x: hashlib.md5(x.encode("utf-8")).hexdigest()
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"HOST={host} LAST_DDL={last_ddl} FETCHED={fetched}\napplied md5={md5(APPLIED)}\npre     md5={md5(PRE)}\n")
print("written", list(files), "HOST", host, "LAST_DDL", last_ddl)
