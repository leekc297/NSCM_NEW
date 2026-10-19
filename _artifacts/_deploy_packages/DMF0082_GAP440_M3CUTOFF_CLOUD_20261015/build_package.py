"""DMF0082_GAP440_M3CUTOFF_CLOUD_20261015 패키지 생성기.

GAP 440 — DMF0082 월 칸 잠금 경계가 조회 시작월에 따라 움직임 (AS-IS = 오늘 월 기준 고정).
  O_RC2 M3_CUTOFF_DATE = 조회 월별 첫날+3개월 이고 FE 가 첫 행을 경계로 사용 →
  PKG_DMF0082.P_DMF0082_GET_MAIN_DATA O_RC2 의 M3_CUTOFF_DATE 1식을 오늘 월 + 3개월로 변경.

FRESH-GATE: 사내 ZIOUI1 ALL_SOURCE 를 지금 재조회해 적용본(마커 1곳 · 구 문장 0곳)인지 확인한 뒤에만 생성.
블록 문구는 재조회한 사내 적용본에서 그대로 추출한다 (손으로 다시 쓰지 않음).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
MARK = "GAP440 2026-10-15"
OLD = "             , TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(MIN(A.BASIS_YYYYMMDD), 'YYYYMMDD'), 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE"
END = "             , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE"
CASE_LINE = END
INDENT = "             "

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
b0 = src.index("\n" + INDENT + "/* [" + MARK) + 1
b1 = src.index(END + "\n", b0) + len(END) + 1
assert main < b0 < b1 < curp, "블록이 GET_MAIN_DATA 구간 밖"
BLOCK = src[b0:b1]
assert BLOCK.count("\n") == 3 and BLOCK.endswith(END + "\n"), "블록 형태 이상"


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

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 440 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 구 문장(O_RC2 M3_CUTOFF_DATE 식) — GET_MAIN_DATA 구간에 1줄이어야 10 적용 가능 (PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 참고 — 적용 후 화면 월 칸 잠금 경계월(오늘 월 + 3개월): 이 달까지 잠기고 다음 달부터 편집
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
SELECT 'L3 참고' CHK, TO_CHAR(SYSDATE,'YYYY-MM-DD') TODAY, TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),3),'YYYYMM') LOCK_UNTIL_YYYYMM FROM DUAL;
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 440 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 P_DMF0082_GET_MAIN_DATA 의 O_RC2(월 칸 잠금 경계) M3_CUTOFF_DATE 식 1줄을 바꾼다.
--       구: 조회 월별 첫날 + 3개월 → FE 가 첫 행을 경계로 써서 조회 시작월을 바꾸면 경계가 움직였다
--           (과거 시작 = 공급 확정월 편집 가능 / 늦은 시작 = 입력할 달 잠김).
--       신: 오늘 월 + 3개월 (AS-IS 와 같게 조회 시작월 무관). 저장 행 선별도 같은 경계를 쓴다.
-- 범위: 조회 SP 1줄(1줄 → 3줄, 주석 2줄 포함). 원장 · 저장 SP · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 GET_MAIN_DATA 구간의 ASCII 구 줄 1줄을 블록으로 치환하고 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 구 문장이 구간 안 1건이 아니면 중단(원문 무변경) · 조립 길이 불일치 시 중단
--       · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}) — 81 조회 시작 2026-07/09/11 경계 202610/202612/202702 → 전부 202701 (2026-10-15 기준).
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
-- 99_ROLLBACK — [{MARK}] GAP 440 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 가 넣은 블록(마커 주석 시작 ~ ASCII 끝 줄 `{END.strip()}`)을 구 문장 1줄로 되돌린다.
--       블록 시작은 ASCII 마커 '{INDENT}/* [{MARK}]', 끝은 ASCII 줄로 찾으므로 한글 주석 비교에 의존하지 않는다.
-- 가드: 마커 없음 → 무동작 · 마커/끝 줄 위치 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{COMMON_DECL}
    c_start CONSTANT VARCHAR2(100) := CHR(10) || '{INDENT}/* [{MARK}]';
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
    IF v_e = 0 OR v_e > v_cur OR v_e - v_pos > 1000 THEN
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

VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 440 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(1줄) · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 구 줄 0 + 신 줄 1 PASS
--         · V4 참고: 화면 월 칸 잠금 경계월(오늘 월 + 3개월) — 조회 시작월을 바꿔도 이 값으로 고정
--         · 화면 확인: 조회 시작월을 과거/미래로 바꿔 조회해도 V4 의 달까지 잠기고 다음 달부터 편집
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
       SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{CASE_SQL}' THEN 1 ELSE 0 END) NEW_N,
       CASE WHEN SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{OLD_SQL}' THEN 1 ELSE 0 END) = 0
             AND SUM(CASE WHEN RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{CASE_SQL}' THEN 1 ELSE 0 END) = 1
            THEN 'PASS' ELSE 'FAIL — 구 줄 잔존 또는 신 줄 수 이상' END JUDGE
  FROM USER_SOURCE S
 WHERE S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
{RANGE};
SELECT 'V4 참고' CHK, TO_CHAR(SYSDATE,'YYYY-MM-DD') TODAY, TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),3),'YYYYMM') LOCK_UNTIL_YYYYMM,
       TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),4),'YYYYMM') EDIT_FROM_YYYYMM FROM DUAL;
"""

VERIFY_FUNC = f"""-- 91 VERIFY_FUNC — [{MARK}] GAP 440 기능 확인 (선택, 전체 F5, 값 입력 없음, 조회만 — 원장 무변경)
-- * 조회 SP 를 Div 81 · Current · 조회 시작월 3가지(오늘 기준 -3/0/+1개월)로 호출해 O_RC2 첫 행(FE 잠금 경계)을 출력한다.
-- * 기대: 3줄 모두 BOUNDARY = 오늘 월 + 3개월 · JUDGE PASS. (조회 1회당 사내 약 6초 — 데이터량에 따라 더 걸릴 수 있음)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR;
    v_rc4 SYS_REFCURSOR; v_rc5 SYS_REFCURSOR; v_res SYS_REFCURSOR;
    v_ym   VARCHAR2(6); v_end VARCHAR2(8); v_m3 VARCHAR2(8);
    v_from VARCHAR2(8);
    v_exp  VARCHAR2(6) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMM');
BEGIN
    FOR k IN (SELECT -3 OFS FROM DUAL UNION ALL SELECT 0 FROM DUAL UNION ALL SELECT 1 FROM DUAL) LOOP
        v_from := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), k.OFS), 'YYYYMMDD');
        PKG_DMF0082.P_DMF0082_GET_MAIN_DATA('81', 'ALL', 'ALL', 'ALL', v_from, TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 6), 'YYYYMMDD'),
            'ALL', '', 'Current', 'N', USER, 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL',
            v_rc1, v_rc2, v_rc3, v_rc4, v_rc5, v_res);
        FETCH v_rc2 INTO v_ym, v_end, v_m3;
        DBMS_OUTPUT.PUT_LINE('F1 시작 ' || v_from || ' → BOUNDARY ' || SUBSTR(v_m3, 1, 6) || ' (기대 ' || v_exp || ') '
            || CASE WHEN SUBSTR(v_m3, 1, 6) = v_exp THEN 'PASS' ELSE 'FAIL — 회신' END);
        CLOSE v_rc1; CLOSE v_rc2; CLOSE v_rc3; CLOSE v_rc4; CLOSE v_rc5; CLOSE v_res;
    END LOOP;
END;
/
"""

os.makedirs(OUT, exist_ok=True)
files = {
    "00_PRECHECK_CLOUD.sql": PRECHECK,
    "10_APPLY_GAP440_PATCH.sql": APPLY,
    "90_VERIFY.sql": VERIFY,
    "91_VERIFY_FUNC.sql": VERIFY_FUNC,
    "99_ROLLBACK_GAP440_PATCH.sql": ROLLBACK,
}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) md5={hashlib.md5(src.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl, "block lines", BLOCK.count("\n"))
