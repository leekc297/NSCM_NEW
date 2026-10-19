"""DMF0044_GRPUPPER 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 CUTOFF DATA 구간 GROUP BY 3줄만 고친다)

왜 패치형인가: 클라우드 PKG_DMF0044 BODY 와 사내 BODY 는 타 작업자 수정분이 다를 수 있어 전체본 교체 금지.
치환 문구는 사내 적용 스크립트(_apply_corporate/DMF0044_GRPUPPER_20261014/build_apply.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 치환 뒤 문구가 정확히 1회 있는지 확인.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0044_GRPUPPER_20261014\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")


def q(s):   # PL/SQL 문자열 리터럴 (끝의 줄바꿈은 CHR(10))
    assert "\n" not in s.rstrip("\n")
    lit = "'" + s.rstrip("\n").replace("'", "''") + "'"
    return lit + " || CHR(10)" if s.endswith("\n") else lit


def fresh_gate():
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0044' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0044' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    if body.count(corp.G_NEW) != 1 or body.count(corp.MARK) != 1:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 치환 뒤 문구 {body.count(corp.G_NEW)}회 · 마커 {body.count(corp.MARK)}회 (각 1 이어야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_reg   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_a     PLS_INTEGER;
    v_b     PLS_INTEGER;
    v_g     PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40)   := '{MARK}';
    c_ps    CONSTANT VARCHAR2(200)  := CHR(10) || {q(corp.P_START.lstrip(chr(10)))};   -- 범위 시작: 조회 프로시저
    c_pe    CONSTANT VARCHAR2(200)  := {q(corp.P_END)};   -- 범위 끝: ETC 구간 시작
    c_up    CONSTANT VARCHAR2(200)  := {q(corp.T_UP)};   -- SELECT 쪽 식 (그대로 둔다)
    c_raw   CONSTANT VARCHAR2(200)  := {q(corp.T_RAW)};   -- GROUP BY 쪽 식 (UPPER 로 맞춘다)
    c_gold  CONSTANT VARCHAR2(400)  := {q(corp.G_OLD)};
    c_gnew  CONSTANT VARCHAR2(400)  := {q(corp.G_NEW)};
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_a := DBMS_LOB.INSTR(v_src, c_ps);
    IF v_a > 0 THEN v_b := DBMS_LOB.INSTR(v_src, c_pe, v_a); END IF;
    IF NVL(v_a, 0) = 0 OR NVL(v_b, 0) = 0 OR cnt(v_src, c_ps) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 또는 ETC 구간 시작 줄을 찾지 못함. 원문 무변경');
    END IF;
    v_reg := SUBSTR(v_src, v_a, v_b - v_a);   -- 프로시저 시작 ~ ETC 구간 직전 (CUTOFF DATA 구간 포함)
"""

TAIL = """    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0044' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;\n"


def gen_apply(corp_ddl):
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0044 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 증상: DMF0044 조회 — Data Type 이 ALL · CUTOFF DATA 이면 SQL ERROR, ETC 는 정상.
-- 원인: P_DMF0044_GET_SALES_REPORTS_DATA 의 CUTOFF DATA INSERT 문에서 Model Type 식이
--         SELECT   : CASE WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE '%CELL%' …   (UPPER 있음)
--         GROUP BY : CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' …          (UPPER 없음)
--       로 서로 달라 ORA-00979 (SINGLE.ITEM_CLASS_NAME: must appear in the GROUP BY clause).
-- 보완: GROUP BY 의 3줄을 SELECT 와 같은 식(UPPER)으로 맞춘다. SELECT · ETC 구간 · 그 밖의 문장 무변경.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 3줄만 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · CUTOFF 구간의 식이 "UPPER 3줄 + UPPER 없음 3줄" 구조가 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (적용 전 ALL · CUTOFF DATA 오류 재현 → 적용 후 3종 모두 정상). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_reg, c_up) <> 3 OR cnt(v_reg, c_raw) <> 3 OR cnt(v_reg, c_gold) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — CUTOFF 구간 Model Type 식 개수: UPPER ' || cnt(v_reg, c_up) || ' · UPPER 없음 ' || cnt(v_reg, c_raw)
            || ' (3 · 3 기대). 이 DB 의 원문이 사내와 다름 → 00_PRECHECK L1 · L2 결과 회신. 원문 무변경');
    END IF;
    v_g := DBMS_LOB.INSTR(v_reg, c_raw);
    IF NOT (DBMS_LOB.INSTR(v_reg, c_up, 1, 3) < v_g AND DBMS_LOB.INSTR(v_reg, 'GROUP BY', DBMS_LOB.INSTR(v_reg, c_up, 1, 3)) < v_g) THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — UPPER 식이 SELECT, UPPER 없는 식이 GROUP BY 에 있는 구조가 아님. 원문 무변경');
    END IF;
    v_reg := REPLACE(REPLACE(v_reg, c_gold, c_gnew), c_raw, c_up);
    v_new := SUBSTR(v_src, 1, v_a - 1) || v_reg || SUBSTR(v_src, v_b);
    IF cnt(v_new, c_mark) <> 1 OR cnt(v_reg, c_up) <> 6 OR cnt(v_reg, c_raw) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 1 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0044 BODY ' || v_st || ' · GROUP BY 3줄 보완 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (GROUP BY 3줄을 UPPER 없는 식으로 되돌린다). 전체 F5, 멱등
-- 마커 없으면 무동작. ⚠ 되돌리면 ALL · CUTOFF DATA 조회가 다시 ORA-00979 로 실패한다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    v_g := DBMS_LOB.INSTR(v_reg, c_gnew);
    IF cnt(v_reg, c_gnew) <> 1 OR cnt(SUBSTR(v_reg, v_g), c_up) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_reg, c_gnew) || '건 (1 기대). 원문 무변경');
    END IF;
    v_reg := SUBSTR(v_reg, 1, v_g - 1) || REPLACE(REPLACE(SUBSTR(v_reg, v_g), c_gnew, c_gold), c_up, c_raw);
    v_new := SUBSTR(v_src, 1, v_a - 1) || v_reg || SUBSTR(v_src, v_b);
    IF cnt(v_new, c_mark) <> 0 OR cnt(v_reg, c_up) <> 3 OR cnt(v_reg, c_raw) <> 3 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 결과 불일치. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0044 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


ERR_SQL = """SELECT '{tag}' CHK, TO_CHAR(L.EVENT_DATE,'MM-DD HH24:MI:SS') EVT, SUBSTR(L.SQL_ERR_MSG, 1, 100) ERR_MSG
     , SUBSTR(REPLACE(L.SQL_BACKTRACE, CHR(10), ' '), 1, 60) BACKTRACE
     , SUBSTR(L.IN_PARA_DATA, 1, 130) PARAMS
  FROM SCM_SYS_LOG_BATCH L
 WHERE L.PROGRAM_NAME = 'PKG_DMF0044' AND L.LOG_TYPE = 'ERROR' AND L.EVENT_DATE >= SYSDATE - {days}
 ORDER BY L.EVENT_DATE DESC
 FETCH FIRST 10 ROWS ONLY;
"""
SRC_SQL = """SELECT '{tag}' CHK, S.LINE, CASE WHEN S.TEXT LIKE '%UPPER(SINGLE.ITEM_CLASS_NAME)%' THEN 'UPPER 있음' ELSE 'UPPER 없음' END KIND
     , SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))), 1, 120) TXT
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0044' AND S.TYPE = 'PACKAGE BODY'
   AND S.TEXT LIKE '%SINGLE.ITEM_CLASS_NAME%LIKE%CELL%'
 ORDER BY S.LINE;
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). DMF0044 조회 SQL ERROR 원인 확인 + [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0044 상태·LAST_DDL
-- * [L1] 최근 3일 조회 오류 기록 — ERR_MSG 가 ORA-00979 … "SINGLE"."ITEM_CLASS_NAME" 이면 이 패치의 대상이 맞다.
--        다른 오류면 10 을 실행하지 말고 L1 결과를 회신.
-- * [L2] Model Type 식 4줄 — 사내 적용 전과 같으면 1번째 줄만 'UPPER 있음', 나머지 3줄 'UPPER 없음'
--        (1번째 = CUTOFF SELECT · 2번째 = CUTOFF GROUP BY ← 여기가 달라서 오류 · 3·4번째 = ETC SELECT · GROUP BY)
-- * [L3] 마커 — 적용 전 0 (적용 뒤 1)
-- * [L4] 지금 PKG_DMF0044 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 260 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN ERR_MSG FORMAT A100
COLUMN BACKTRACE FORMAT A60
COLUMN PARAMS FORMAT A130
COLUMN TXT FORMAT A120
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0044' ORDER BY O.OBJECT_TYPE;
{ERR_SQL.format(tag='L1 오류', days=3)}{SRC_SQL.format(tag='L2 식')}SELECT 'L3 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(1) · V2 VALID/오류 0 · V3 1·2번째 줄 'UPPER 있음', 3·4번째 줄 'UPPER 없음'
--         V4 = 화면에서 ALL · CUTOFF DATA 로 다시 조회한 뒤 실행하면, 적용 시각 이후의 오류 기록이 없어야 한다.
SET LINESIZE 260 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN ERR_MSG FORMAT A100
COLUMN BACKTRACE FORMAT A60
COLUMN PARAMS FORMAT A130
COLUMN TXT FORMAT A120
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0044')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0044' ORDER BY O.OBJECT_TYPE;
{SRC_SQL.format(tag='V3 식')}{ERR_SQL.format(tag='V4 오류', days=1)}"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_GRPUPPER_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_GRPUPPER_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
