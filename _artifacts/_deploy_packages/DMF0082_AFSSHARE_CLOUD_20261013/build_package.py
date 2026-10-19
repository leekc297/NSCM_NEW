"""DMF0082_AFSSHARE 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 AS From Site 빈값 정규화 문장 뒤 2곳에 MERGE 를 끼워 넣는다)

왜 패치형인가: 클라우드 PKG_DMF0082 BODY 와 사내 BODY 는 타 작업자 수정분이 달라 전체본 교체 금지.
삽입 문구는 사내 적용 스크립트(_apply_corporate/DMF0082_AFSSHARE_20261013/build_apply.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 삽입 문구 2종이 각각 정확히 1회 있는지 확인 — 사내 적용본과 문구가 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_AFSSHARE_20261013\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
ANC = [corp.anchor(g) for g in corp.GTT]  # 1 = GET_MAIN_DATA / 2 = GET_MAIN_DATA_CURRENT
BLK = [corp.block(g) for g in corp.GTT]


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 패키지가 넣을 문구가 각각 1회 존재 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    for i, (a, b) in enumerate(zip(ANC, BLK), 1):
        if body.count(a + b) != 1:
            sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 삽입 문구 {i} 가 {body.count(a + b)}회 (1 이어야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_p1    PLS_INTEGER;
    v_p2    PLS_INTEGER;
    v_cur   PLS_INTEGER;
    v_nxt   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_anc1  CONSTANT VARCHAR2(32767) :=   -- 앵커 1: P_DMF0082_GET_MAIN_DATA 의 AS From Site 빈값 정규화 문장 (GT_DMF0082_MF_SP)
        {plsql_lit(ANC[0])};
    c_anc2  CONSTANT VARCHAR2(32767) :=   -- 앵커 2: P_DMF0082_GET_MAIN_DATA_CURRENT 의 같은 문장 (GTT_MF_SP)
        {plsql_lit(ANC[1])};
    c_blk1  CONSTANT VARCHAR2(32767) :=   -- 삽입 1
        {plsql_lit(BLK[0])};
    c_blk2  CONSTANT VARCHAR2(32767) :=   -- 삽입 2
        {plsql_lit(BLK[1])};
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
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
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)이
--       MKT_FCST 행의 AS From Site 값을 같은 키의 다른 메저 행(LOC · KRW · 실적 · 계산 메저 등)에도 내려주도록 한다.
--       키 = Division · Project · End Customer · Sales Site · Model · Customs Handbook · Fcst Type · Incoterms · Plant Site · Cell Prod Site
--       대상 = AS From Site 가 비어 있는(빈칸 · '-' · '/') MKT_FCST 가 아닌 행. 자기 값이 있는 행 · MKT_FCST 행은 그대로.
--       한 키의 MKT_FCST 에 서로 다른 값이 둘 이상이면 채우지 않는다. 결과 컬럼에 AS From Site 가 없는 조회는 건너뛴다.
-- 배경: AS From Site 는 수요 원장에만 저장돼 LOC 등 다른 메저 행은 빈칸 → 같은 품목인데 화면의 셀 병합이 끊겼다 (사용자 요청 2026-10-13).
-- 범위: 조회용 임시 테이블의 표시값만 바꾼다. 원장 · 저장 · 단가 검증 무변경.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 AS From Site 빈값 정규화 문장 뒤 2곳에 MERGE 를 끼워 넣은 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 각 1건이 아니거나 위치가 두 조회 프로시저와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 삽입 · 모의 행 14케이스 + 전후 비교 16케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc1) <> 1 OR cnt(v_src, c_anc2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 빈값 정규화 앵커 매칭 ' || cnt(v_src, c_anc1) || ' · ' || cnt(v_src, c_anc2) || '건 (각 1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_p1  := DBMS_LOB.INSTR(v_src, c_anc1);
    v_p2  := DBMS_LOB.INSTR(v_src, c_anc2);
    v_cur := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_nxt := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_cur > 0 AND v_nxt > 0 AND v_p1 < v_cur AND v_cur < v_p2 AND v_p2 < v_nxt) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_p1 + LENGTH(c_anc1) - 1) || c_blk1
          || SUBSTR(v_src, v_p1 + LENGTH(c_anc1), v_p2 + LENGTH(c_anc2) - v_p1 - LENGTH(c_anc1))
          || c_blk2
          || SUBSTR(v_src, v_p2 + LENGTH(c_anc2));
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_anc1 || c_blk1) <> 1 OR cnt(v_new, c_anc2 || c_blk2) <> 1
       OR LENGTH(v_new) <> LENGTH(v_src) + LENGTH(c_blk1) + LENGTH(c_blk2) THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 끼워 넣은 2곳을 걷어낸 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 걷어낸 뒤 마커 0 이어야 실행. ⚠ 되돌리면 LOC 등 다른 메저 행의 AS From Site 가 다시 빈칸으로 나온다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc1 || c_blk1) <> 1 OR cnt(v_src, c_anc2 || c_blk2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_anc1 || c_blk1) || ' · ' || cnt(v_src, c_anc2 || c_blk2) || '건 (각 1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_anc1 || c_blk1, c_anc1);
    v_new := REPLACE(v_new, c_anc2 || c_blk2, c_anc2);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


# 당주 이후 MKT_FCST 에 AS From Site 값이 있는 키 수 (적용 뒤 화면에서 확인할 대상 찾기) — 81 · 82 원장 = DM_PLN_MKT_FCST
DATA_SQL = """SELECT '{tag}' CHK, F.DIVISION_ID, COUNT(DISTINCT F.SCM_SITE_ID || '|' || F.ITEM_ID) KEYS, COUNT(*) ROWS_N
     , MIN(F.SCM_SITE_ID) SAMPLE_SITE, MIN(F.ATTRIBUTE10) SAMPLE_VALUE
  FROM DM_PLN_MKT_FCST F
 WHERE F.DIVISION_ID IN ('81', '82') AND F.MEASURE = 'MKT_FCST'
   AND F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
   AND RTRIM(F.ATTRIBUTE10, ' -/') IS NOT NULL
 GROUP BY F.DIVISION_ID
 ORDER BY F.DIVISION_ID;
"""

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 패치 앵커 — AS From Site 빈값 정규화 문장의 첫 줄이 임시 테이블별로 조건에 맞게 있어야 10 적용 가능
--        (GT_DMF0082_MF_SP · GTT_MF_SP 각각 UPDATE 줄 바로 다음 줄이 SET AS_FROM_SITE = ' ' 인 곳이 1건)
-- * [L2] 마커 — 적용 전 0 (적용 뒤 2)
-- * [L3] 당주 이후 MKT_FCST 에 AS From Site 값이 있는 품목 수 (0행이면 적용해도 화면에 달라지는 것이 없다)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A70
COLUMN SAMPLE_SITE FORMAT A30
COLUMN SAMPLE_VALUE FORMAT A20
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커' CHK, COUNT(*) N, MIN(A.LINE) LINE_1, MAX(A.LINE) LINE_2,
       CASE WHEN COUNT(*) = 2 THEN 'PASS → 10 적용 가능 (최종 판정은 10 이 3줄 전체로 한다)' ELSE 'FAIL — 2건이 아님 → 중단·회신' END JUDGE
  FROM USER_SOURCE A
  JOIN USER_SOURCE B ON B.NAME = A.NAME AND B.TYPE = A.TYPE AND B.LINE = A.LINE + 1
 WHERE A.NAME = 'PKG_DMF0082' AND A.TYPE = 'PACKAGE BODY'
   AND RTRIM(A.TEXT, CHR(10)||CHR(13)) IN ('    UPDATE SCM_MGR.GT_DMF0082_MF_SP', '    UPDATE SCM_MGR.GTT_MF_SP')
   AND RTRIM(B.TEXT, CHR(10)||CHR(13)) = '    SET    AS_FROM_SITE = '' ''';
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
{DATA_SQL.format(tag='L3 대상')}SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS(2) · V2 VALID/오류 0 · V3 마커 2줄 + MERGE 2줄(두 조회 프로시저에 1줄씩) · V4 화면에서 확인할 대상
-- * 화면 확인: V4 의 SAMPLE_SITE 로 81(또는 82)을 조회해, MKT_FCST 행과 같은 품목의 LOC 행에 같은 AS From Site 가 보이고 셀이 병합되는지 본다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN TXT FORMAT A150
COLUMN JUDGE FORMAT A60
COLUMN SAMPLE_SITE FORMAT A30
COLUMN SAMPLE_VALUE FORMAT A20
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 줄' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))),1,150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND ( S.TEXT LIKE '%{MARK}%' OR S.TEXT LIKE '%MERGE INTO SCM_MGR.G%MF_SP T%' AND S.LINE IN (
           SELECT M.LINE + 8 FROM USER_SOURCE M WHERE M.NAME='PKG_DMF0082' AND M.TYPE='PACKAGE BODY' AND M.TEXT LIKE '%{MARK}%' ) )
 ORDER BY S.LINE;
{DATA_SQL.format(tag='V4 대상')}"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_AFSSHARE_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_AFSSHARE_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
