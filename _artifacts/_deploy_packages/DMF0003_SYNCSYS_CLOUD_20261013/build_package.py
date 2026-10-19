"""DMF0003_SYNCSYS 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 동기화 프로시저의 최종 기록 2줄만 교체)

왜 패치형인가: PKG_DMF0003 BODY 는 타 작업자 수정분이 수시로 들어가 클라우드와 사내 원문이 다를 수 있다 → 전체본 교체 금지.
치환 문구(OLD/NEW)는 사내 적용 스크립트(_apply_corporate/DMF0003_SYNCSYS_20261013/build_apply.py)에서 그대로 가져온다.
FRESH-GATE: 생성 직전 사내 DB(USER_SOURCE)의 현재 BODY 에 NEW 문구가 정확히 1회 · OLD 문구(주석 아닌 실행 줄)가 0회인지 확인.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0003_SYNCSYS_20261013\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP)
corp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
OLD, NEW = corp.OLD, corp.NEW


def plsql_lit(text, indent="        "):
    parts = text.split("\n")
    assert parts[-1] == "", "줄바꿈으로 끝나야 함"
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    # FRESH-GATE: 사내 DB 의 현재 BODY(USER_SOURCE)에 패키지가 넣을 NEW 문구가 1회 존재 = 사내 적용본과 문구 동일
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0003' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0003' AND object_type='PACKAGE BODY'")
        last_ddl = cur.fetchone()[0]
    if body.count(NEW) != 1 or body.count("\n" + OLD) != 0:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 적용 문구 {body.count(NEW)}회 · 원문 {body.count(chr(10) + OLD)}회 (1 · 0 이어야 함)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", last_ddl)
    return last_ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_proc  PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := '{MARK}';
    c_old   CONSTANT VARCHAR2(32767) :=   -- 최종 기록 2줄 (원문 — 줄 맨 앞 줄바꿈 포함: 주석 처리된 같은 문구와 구분)
        CHR(10) || {plsql_lit(OLD)};
    c_new   CONSTANT VARCHAR2(32767) :=   -- 설명 5줄 + 종전 2줄 주석 + 새 2줄
        CHR(10) || {plsql_lit(NEW)};
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0003' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
"""

TAIL = """    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0003' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0003' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0003' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
"""
POST = "SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0003' ORDER BY OBJECT_TYPE;\n"


def gen_apply(corp_ddl):
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0003 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0003_MKT_FCST_SALES_PLAN_SYNC (DMF0003 저장 뒤 82 Sales Plan 동기화)가 DM_PLN_SALES_PLAN 에 기록하는
--       생성자·수정자를 저장한 사용자 대신 'SYSTEM' 으로 바꾼다.
--         수량 메저(MKT_FCST·CUST_FCST·TMM_FCST·RTF·RTF_SYS_RP) : 생성자·생성 시각 = 원장 값 그대로 / 수정자 = 'SYSTEM'
--         금액 메저(SalesAmt_KRW/LOC/USD·MKT_AMT_KRW/LOC)       : 생성자 = 'SYSTEM'·생성 시각 = 저장 시각 / 수정자 = 'SYSTEM'
--         수정 시각 = 전 메저 저장 시각 (종전과 같음)
-- 배경: 82 는 한 품목만 저장해도 사업부 전체 Sales Plan(당주 이후)이 다시 기록되어, 손대지 않은 품목까지
--       그 사용자가 수정한 것으로 남았다 (클라우드 QA 10-13 13:42 k0101 — 12,249행).
-- 범위: 이 프로시저의 최종 INSERT SELECT 목록 2줄만. 수량·금액 값, 삭제 범위, 메저 목록 무변경.
--       ★ 기존 데이터는 고치지 않는다 — 적용 뒤 82 를 DMF0003 에서 저장할 때부터 새 규칙으로 기록된다.
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 그 2줄만 바꾼 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 다른 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커 1건 아니거나 동기화 프로시저 밖이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 {corp_ddl} (같은 치환 · 바뀐 식 20케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_old) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 최종 기록 2줄 앵커 매칭 ' || cnt(v_src, c_old) || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_pos  := DBMS_LOB.INSTR(v_src, c_old);
    v_proc := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0003_MKT_FCST_SALES_PLAN_SYNC');
    IF v_proc = 0 OR v_pos < v_proc OR DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE ', v_proc + 20) BETWEEN 1 AND v_pos THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커가 P_DMF0003_MKT_FCST_SALES_PLAN_SYNC 밖에 있음. 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_old, c_new);
    IF cnt(v_new, c_mark) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (1 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0003 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 역치환 (이 DB 의 USER_SOURCE 를 읽어 바꾼 2줄을 종전 문장으로 되돌린 뒤 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 되돌린 뒤 마커 0 이어야 실행. ⚠ 되돌리면 다시 저장한 사용자 이름으로 기록된다. 이미 기록된 데이터는 바뀌지 않는다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_new) || '건 (1 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_new, c_old);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 역치환 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0003 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def q(s):
    return s.rstrip("\n").replace("'", "''")


OLD1, OLD2 = corp.OLD_LINES

PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0003 상태·LAST_DDL
-- * [L1] 패치 앵커 — 최종 기록 2줄(주석 아닌 실행 줄)이 각각 1건이어야 10 적용 가능 + 그 줄 번호
-- * [L2] 마커 — 적용 전 0 (적용 뒤 1)
-- * [L3] 지금 82 Sales Plan(당주 이후)의 메저별 생성자·수정자 분포 — 참고용 (이 패치는 기존 데이터를 고치지 않는다)
-- * [L4] 지금 PKG_DMF0003 실행 중 세션 (있으면 끝난 뒤 10 실행)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN JUDGE FORMAT A70
COLUMN TXT FORMAT A150
COLUMN MEASURE FORMAT A16
COLUMN CREATED_BY FORMAT A20
COLUMN UPD_BY FORMAT A20
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0003' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 앵커1' CHK, COUNT(*) N, MIN(S.LINE) LINE_NO,
       CASE WHEN COUNT(*) = 1 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL — 없음 (이미 적용이면 L2 = 1) → 중단·회신' ELSE 'FAIL — 2건↑ → 중단·회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0003' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{q(OLD1)}'
UNION ALL
SELECT 'L1 앵커2' CHK, COUNT(*) N, MIN(S.LINE) LINE_NO,
       CASE WHEN COUNT(*) = 1 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL — 없음 (이미 적용이면 L2 = 1) → 중단·회신' ELSE 'FAIL — 2건↑ → 중단·회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME = 'PKG_DMF0003' AND S.TYPE = 'PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{q(OLD2)}';
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0003' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 현황' CHK, S.MEASURE, SUBSTR(S.CREATED_BY, 1, 20) CREATED_BY, SUBSTR(S.LAST_UPDATED_BY, 1, 20) UPD_BY, COUNT(*) CNT,
       TO_CHAR(MAX(S.LAST_UPDATE_DATE), 'MM-DD HH24:MI:SS') LAST_AT
  FROM DM_PLN_SALES_PLAN S
 WHERE S.DIVISION_ID = '82' AND S.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
   AND S.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST','RTF','RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','MKT_AMT_KRW','MKT_AMT_LOC')
 GROUP BY S.MEASURE, S.CREATED_BY, S.LAST_UPDATED_BY
 ORDER BY S.MEASURE, COUNT(*) DESC FETCH FIRST 80 ROWS ONLY;
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0003' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 PASS · V2 VALID/오류 0 · V3 바뀐 구간(설명 5줄 + 종전 2줄 주석 + 새 2줄) · V4 새 식 10 메저 전부 PASS
-- * 동기화 프로시저는 실행하지 않는다 — 실행하면 82 Sales Plan 전 행이 다시 기록된다 (기존 데이터 일괄 수정 불필요).
--   실제 기록은 적용 뒤 DMF0003 에서 82 를 저장한 다음 00_PRECHECK 의 L3 로 확인한다 (수정자 SYSTEM · 금액 메저 생성자 SYSTEM).
-- * V4 는 패치가 넣는 식과 같은 식을 시험 행(메저 10종)에 적용한 결과다. 테이블을 읽거나 쓰지 않는다.
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A8
COLUMN TXT FORMAT A160
COLUMN MEASURE FORMAT A14
COLUMN OUT_CREATED_BY FORMAT A14
COLUMN OUT_UPD_BY FORMAT A10
COLUMN JUDGE FORMAT A30
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0003' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0003')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0003' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 구간' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))),1,160) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0003' AND S.TYPE='PACKAGE BODY'
   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0003' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0003' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%') + 8
 ORDER BY S.LINE;
SELECT 'V4 식' CHK, T.MEASURE, T.CREATED_BY IN_CREATED_BY
     , CASE WHEN T.MEASURE IN ('MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'RTF', 'RTF_SYS_RP') THEN T.CREATED_BY ELSE 'SYSTEM' END OUT_CREATED_BY
     , 'SYSTEM' OUT_UPD_BY
     , CASE WHEN T.KIND = 'QTY' AND CASE WHEN T.MEASURE IN ('MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'RTF', 'RTF_SYS_RP') THEN T.CREATED_BY ELSE 'SYSTEM' END = T.CREATED_BY THEN 'PASS — 원장 생성자 유지'
            WHEN T.KIND = 'AMT' AND CASE WHEN T.MEASURE IN ('MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'RTF', 'RTF_SYS_RP') THEN T.CREATED_BY ELSE 'SYSTEM' END = 'SYSTEM' THEN 'PASS — 생성자 SYSTEM'
            ELSE 'FAIL' END JUDGE
  FROM ( SELECT 'QTY' KIND, 'MKT_FCST' MEASURE, 'ledger_user' CREATED_BY FROM DUAL UNION ALL
         SELECT 'QTY', 'CUST_FCST', 'ledger_user' FROM DUAL UNION ALL
         SELECT 'QTY', 'TMM_FCST', 'ledger_user' FROM DUAL UNION ALL
         SELECT 'QTY', 'RTF', 'ledger_user' FROM DUAL UNION ALL
         SELECT 'QTY', 'RTF_SYS_RP', 'ledger_user' FROM DUAL UNION ALL
         SELECT 'AMT', 'SalesAmt_KRW', NULL FROM DUAL UNION ALL
         SELECT 'AMT', 'SalesAmt_LOC', NULL FROM DUAL UNION ALL
         SELECT 'AMT', 'SalesAmt_USD', NULL FROM DUAL UNION ALL
         SELECT 'AMT', 'MKT_AMT_KRW', NULL FROM DUAL UNION ALL
         SELECT 'AMT', 'MKT_AMT_LOC', NULL FROM DUAL ) T;
"""


def main():
    corp_ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_SYNCSYS_PATCH.sql": gen_apply(corp_ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_SYNCSYS_PATCH.sql": gen_rollback()}
    for name, txt in files.items():
        open(os.path.join(HERE, "A_DB", name), "w", encoding="utf-8", newline="\n").write(txt)
        print("WROTE", name, txt.count("\n"), "lines")


if __name__ == "__main__":
    main()
