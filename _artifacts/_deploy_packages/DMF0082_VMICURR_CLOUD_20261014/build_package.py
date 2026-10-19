"""DMF0082_VMICURR 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 VMI 통화 제외 조건 6곳만 치환)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 와 사내 BODY 는 타 작업자 수정분이 달라 전체본 교체 금지.
치환 문구(원문 → 적용문, 기대 횟수)는 사내 적용 스크립트(_apply_corporate/DMF0082_VMICURR_20261014/build_apply.py)의
EDITS 를 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 적용문이 기대 횟수만큼 있고 원문은 0회인지 확인 —
사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_VMICURR_20261014\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
EDITS = [(o, n, a + b) for o, n, a, b in corp.EDITS]   # (원문, 적용문, 전체 기대 횟수)
TOTAL_MARK = sum(n.count(corp.MARK) * k for _, n, k in EDITS)
NAMES = ["백필 MERGE 3곳 (GET_MAIN_DATA 1차·2차·3차)", "백필 MERGE 1곳 (GET_MAIN_DATA_CURRENT)", "CURRNORM 2곳 (두 조회 프로시저)"]


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 적용문이 기대 횟수만큼, 원문이 0회 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    for i, (o, n, k) in enumerate(EDITS, 1):
        if body.count(n) != k or body.count(o) != 0:
            sys.exit(f"FRESH-GATE FAIL: 사내 BODY 치환 {i} 적용문 {body.count(n)}회(기대 {k}) · 원문 {body.count(o)}회(기대 0)")
    if body.count(corp.MARK) != TOTAL_MARK:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 마커 {body.count(corp.MARK)}곳 (기대 {TOTAL_MARK})")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl, "마커", TOTAL_MARK)
    return last_ddl


def consts():
    out = []
    for i, ((o, n, k), nm) in enumerate(zip(EDITS, NAMES), 1):
        out.append(f"    c_old{i}  CONSTANT VARCHAR2(32767) :=   -- 원문 {i}: {nm} — 기대 {k}건\n        {plsql_lit(o)};")
        out.append(f"    c_new{i}  CONSTANT VARCHAR2(32767) :=   -- 적용문 {i}\n        {plsql_lit(n)};")
    return "\n".join(out)


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_main  PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_nxt   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
{consts()}
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
    -- 토큰이 전부 GET_MAIN_DATA ~ GET_SPREAD_TITLE 구간(두 조회 프로시저) 안에 있는가
    FUNCTION in_scope(p_src CLOB, p_tok VARCHAR2) RETURN BOOLEAN IS
        pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            IF pos < v_main OR pos > v_nxt THEN RETURN FALSE; END IF;
            pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN TRUE;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src  := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_main := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA' || CHR(10));
    v_cur  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_nxt  := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_main > 0 AND v_main < v_cur AND v_cur < v_nxt) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 조회 프로시저 위치 확인 불가 (GET_MAIN_DATA / _CURRENT / GET_SPREAD_TITLE). 원문 무변경');
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
    n = len(EDITS)
    checks = "\n".join(
        f"    IF cnt(v_src, c_old{i}) <> {k} OR NOT in_scope(v_src, c_old{i}) THEN\n"
        f"        RAISE_APPLICATION_ERROR(-20001, '중단 — 원문 {i} 매칭 ' || cnt(v_src, c_old{i}) || '건 ({k} 기대) 또는 조회 프로시저 밖. 00_PRECHECK L1 회신. 원문 무변경');\n"
        f"    END IF;" for i, (_, _, k) in enumerate(EDITS, 1))
    reps = "\n".join(f"    v_new := REPLACE(v_new, c_old{i}, c_new{i});" for i in range(1, n + 1))
    posts = " OR ".join(f"cnt(v_new, c_new{i}) <> {k} OR cnt(v_new, c_old{i}) <> 0" for i, (_, _, k) in enumerate(EDITS, 1))
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)에서
--       VMI 계열 메저(VMI_In_Req · VMI_Inv · VMI_DIO 등)도 MKT_FCST 처럼 같은 키 LOC 행의 CURRENCY 를 받아 표시하도록 한다.
--       ① LOC 통화 백필 MERGE 의 `AND A.MEASURE NOT LIKE 'VMI%'` 4곳 주석 처리
--       ② CURRNORM 의 `MEASURE LIKE 'VMI%' OR` (VMI 통화 공백 강제) 2곳 제거
-- 배경: VMI 행만 통화가 빈칸이라 같은 품목의 LOC · MKT_FCST 행과 값이 달라 화면 셀 병합이 끊겼다 (사용자 요청 2026-10-14).
--       AS-IS 는 VMI 통화를 항상 빈칸으로 내려준다 — 의도적 변경.
-- 범위: 조회용 임시 테이블의 표시값만 바꾼다. 원장 · 저장 · 단가 검증 · 메타 · FE 무변경.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 위 6곳만 치환한 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 원문이 기대 건수와 다르거나 조회 프로시저 밖이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 치환 · 전후 비교 12케이스 + MKT_FCST 병행 비교 3케이스). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
{checks}
    v_new := v_src;
{reps}
    IF cnt(v_new, c_mark) <> {TOTAL_MARK} OR {posts} THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, {TOTAL_MARK} 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    checks = "\n".join(
        f"    IF cnt(v_src, c_new{i}) <> {k} THEN\n"
        f"        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용문 {i} 매칭 ' || cnt(v_src, c_new{i}) || '건 ({k} 기대). 원문 무변경');\n"
        f"    END IF;" for i, (_, _, k) in enumerate(EDITS, 1))
    reps = "\n".join(f"    v_new := REPLACE(v_new, c_new{i}, c_old{i});" for i in range(1, len(EDITS) + 1))
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 치환한 6곳을 원문으로 되돌린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 VMI 메저 행의 CURRENCY 가 다시 빈칸으로 나온다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
{checks}
    v_new := v_src;
{reps}
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


# 당주 이후 VMI 메저 원장 실재 사이트 (적용 뒤 화면에서 확인할 대상 찾기) — 40 · 81 · 82 원장 = DM_PLN_MKT_FCST
DATA_SQL = """SELECT '{tag}' CHK, F.DIVISION_ID, F.MEASURE, COUNT(DISTINCT F.SCM_SITE_ID || '|' || F.ITEM_ID) KEYS, COUNT(*) ROWS_N
     , MIN(F.SCM_SITE_ID) SAMPLE_SITE
  FROM DM_PLN_MKT_FCST F
 WHERE F.MEASURE LIKE 'VMI%' AND F.QTY <> 0
   AND F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
 GROUP BY F.DIVISION_ID, F.MEASURE
 ORDER BY F.DIVISION_ID, F.MEASURE;
"""

# 원문 줄 단위 판정 — 치환 대상 줄이 조회 프로시저 구간에 몇 줄 있는가 (최종 판정은 10 이 여러 줄 전체 문구로 한다)
LINE_SQL = """SELECT '{tag}' CHK, K.KIND, COUNT(S.LINE) N, K.EXPECT, LISTAGG(S.LINE, ',') WITHIN GROUP (ORDER BY S.LINE) LINES,
       CASE WHEN COUNT(S.LINE) = K.EXPECT THEN '{ok}' ELSE '{ng}' END JUDGE
  FROM ( SELECT '백필 VMI 제외(MAIN 형)' KIND, '    AND    A.MEASURE NOT LIKE ''VMI%''' TXT, {e1} EXPECT FROM DUAL UNION ALL
         SELECT '백필 VMI 제외(CURRENT 형)', '            AND   A.MEASURE NOT LIKE ''VMI%'';', {e2} FROM DUAL UNION ALL
         SELECT 'CURRNORM VMI 공백 강제', '    AND    (   MEASURE LIKE ''VMI%''', {e3} FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = K.TXT
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_DMF0082_GET_MAIN_DATA%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE%')
 GROUP BY K.KIND, K.EXPECT
 ORDER BY K.KIND;
"""


def gen_precheck():
    k = [e[2] for e in EDITS]
    return f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 치환 대상 줄 — 조회 프로시저 구간에 기대 건수만큼 있어야 10 적용 가능
--        백필 VMI 제외 MAIN 형 3 · CURRENT 형 1 · CURRNORM VMI 공백 강제 2 (최종 판정은 10 이 여러 줄 전체 문구로 한다)
-- * [L2] 마커 — 적용 전 0 (적용 뒤 {TOTAL_MARK})
-- * [L3] 당주 이후 VMI 메저 원장이 있는 사이트 (적용 뒤 화면 확인 대상)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A28
COLUMN LINES FORMAT A30
COLUMN JUDGE FORMAT A60
COLUMN SAMPLE_SITE FORMAT A30
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
{LINE_SQL.format(tag='L1 대상줄', e1=k[0], e2=k[1], e3=k[2], ok='PASS', ng='FAIL — 건수 다름 → 10 실행 금지·결과 회신')}SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
{DATA_SQL.format(tag='L3 대상')}SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""


def gen_verify():
    return f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS({TOTAL_MARK}) · V2 VALID/오류 0/의존 INVALID 0 · V3 치환 대상 줄 잔존 0 · V4 화면 확인 대상
-- * 화면 확인: V4 의 SAMPLE_SITE 로 조회해, VMI 메저 행 Currency 가 같은 품목 LOC · MKT_FCST 행과 같고 셀이 병합되는지 본다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A28
COLUMN LINES FORMAT A30
COLUMN JUDGE FORMAT A60
COLUMN SAMPLE_SITE FORMAT A30
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = {TOTAL_MARK} THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
{LINE_SQL.format(tag='V3 잔존', e1=0, e2=0, e3=0, ok='PASS (잔존 0)', ng='FAIL — VMI 제외 조건 잔존')}{DATA_SQL.format(tag='V4 대상')}"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": gen_precheck(), "10_APPLY_VMICURR_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": gen_verify(), "99_ROLLBACK_VMICURR_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
