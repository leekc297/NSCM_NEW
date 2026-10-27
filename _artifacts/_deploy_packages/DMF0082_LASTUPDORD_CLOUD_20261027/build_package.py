"""DMF0082_LASTUPDORD 클라우드 패키지 생성기 — 패치형 (클라우드 USER_SOURCE 를 읽어 C_TITLE 루프 직후 2곳에 1문장씩 삽입)

삽입 문구 = 사내 적용 스크립트(_apply_corporate/DMF0082_LASTUPDORD_20261027/build_apply.py) 그대로.
앵커 = '    END LOOP;\\n    CLOSE C_TITLE;\\n' (ASCII · 두 조회 프로시저에 1회씩).
FRESH-GATE: 생성 직전 사내 DB 현재 BODY 에 '앵커+블록' 이 정확히 2회 있는지 확인 — 다르면 중단.

  python build_package.py
"""
import sys, os, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPDORD_20261027\build_apply.py"
spec = importlib.util.spec_from_file_location("corp_build", CORP); corp = importlib.util.module_from_spec(spec); spec.loader.exec_module(corp)
MARK = corp.MARK.strip("[]")
ANC, BLK = corp.ANCHOR, corp.BLOCK
assert all(ord(c) < 128 for c in ANC)


def lit(text, indent="        "):
    parts = text.split("\n"); assert parts[-1] == ""
    return (" ||\n" + indent).join("'" + p.replace("'", "''") + "' || CHR(10)" for p in parts[:-1])


def fresh_gate():
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line")
        body = "".join(r[0] for r in cur)
        cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
        ddl = cur.fetchone()[0]
    if body.count(ANC + BLK) != 2:
        sys.exit(f"FRESH-GATE FAIL: 사내 BODY 에 삽입 문구 {body.count(ANC + BLK)}회 (2 기대)")
    print("FRESH-GATE PASS — 사내 BODY LAST_DDL", ddl)
    return ddl


HEAD = f"""SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src  CLOB;
    v_new  CLOB;
    v_st   VARCHAR2(30);
    v_err  PLS_INTEGER;
    v_p1   PLS_INTEGER;
    v_p2   PLS_INTEGER;
    v_cs   PLS_INTEGER;
    v_ce   PLS_INTEGER;
    c_mark CONSTANT VARCHAR2(40) := '{MARK}';
    c_anc  CONSTANT VARCHAR2(200) :=   -- 앵커: C_TITLE 루프 끝 2줄 (두 조회 프로시저에 1회씩)
        {lit(ANC)};
    c_blk  CONSTANT VARCHAR2(32767) :=   -- 삽입: 정렬 키에서 두 참고값 컬럼 제거 1문장
        {lit(BLK)};
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


def gen_apply(ddl):
    return f"""-- 10_APPLY — [{MARK}] PKG_DMF0082 BODY 패치 (전체 F5 · 값 입력 없음 · 멱등)
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)의 정렬 키(V_ORDERBY)에서
--       LAST_UPDATED_BY · LAST_UPDATE_DATE 를 뺀다. [E20261027-DMF0082LASTUPD](줄 묶음 제외)와 짝 — 두 컬럼은 참고값이라
--       Column Set 에 넣어도 줄 순서는 키 컬럼으로만 정한다. 두 컬럼을 고르지 않으면 정렬 키는 원래 값 그대로.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 C_TITLE 루프 끝(END LOOP; CLOSE C_TITLE;) 2곳 뒤에 1문장씩 끼워 넣고 CREATE OR REPLACE (사내 전체본 복사 아님 · 기존 문장 무변경)
-- 가드: 마커 있으면 무동작 · 앵커 2건 아니거나 위치가 두 조회 프로시저와 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 선행: DMF0082_LASTUPD_CLOUD_20261027 (클라우드 적용 확인됨 — 없어도 이 패치는 독립 동작)
-- 사내 ZIOUI1 적용 완료 {ddl} (40케이스 전후 비교 PASS). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
{HEAD}    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 매칭 ' || cnt(v_src, c_anc) || '건 (2 기대) → 00_PRECHECK L1 회신. 원문 무변경');
    END IF;
    v_p1 := DBMS_LOB.INSTR(v_src, c_anc, 1, 1);
    v_p2 := DBMS_LOB.INSTR(v_src, c_anc, 1, 2);
    v_cs := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_ce := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_cs > 0 AND v_ce > 0 AND v_p1 < v_cs AND v_cs < v_p2 AND v_p2 < v_ce) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_p1 + LENGTH(c_anc) - 1) || c_blk
          || SUBSTR(v_src, v_p1 + LENGTH(c_anc), v_p2 - v_p1)
          || c_blk
          || SUBSTR(v_src, v_p2 + LENGTH(c_anc));
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_anc || c_blk) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


def gen_rollback():
    return f"""-- 99 ROLLBACK — [{MARK}] 삽입 2곳 제거 (이 DB 의 USER_SOURCE 기준). 전체 F5 · 멱등
-- 마커 없으면 무동작. 되돌리면 두 컬럼을 Column Set 에 넣은 사용자의 정렬 키에 다시 두 컬럼이 붙는다.
{HEAD}    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_anc || c_blk) <> 2 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 적용 문구 매칭 ' || cnt(v_src, c_anc || c_blk) || '건 (2 기대). 원문 무변경');
    END IF;
    v_new := REPLACE(v_src, c_anc || c_blk, c_anc);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 제거 뒤 마커 ' || cnt(v_new, c_mark) || '곳 잔존. 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
{TAIL}    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}"""


PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5 · 값 입력 없음). [{MARK}] 적용 전 상태
-- * L0 접속 DB · PKG_DMF0082 상태 · L1 앵커(CLOSE C_TITLE 줄) 2건 · L2 마커 0 · L3 선행 LASTUPD 마커 · L4 두 컬럼을 Column Set 에 넣은 사용자 수 · L5 실행 중 세션
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
SELECT 'L1 앵커' CHK, COUNT(*) N, MIN(LINE) LINE_1, MAX(LINE) LINE_2,
       CASE WHEN COUNT(*) = 2 THEN 'PASS (최종 판정은 10 이 2줄 전체로 한다)' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '    CLOSE C_TITLE;%';
SELECT 'L2 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 선행' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'LASTUPD 적용됨' ELSE 'LASTUPD 미적용 — 이 패치는 독립 동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%[E20261027-DMF0082LASTUPD]%';
SELECT 'L4 선택자' CHK, COLUMN_NAME, COUNT(DISTINCT USER_ID) USERS FROM SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND USER_INQUIRY_COLUMN_TYPE_CODE='C' AND COLUMN_NAME IN ('LAST_UPDATED_BY','LAST_UPDATE_DATE')
 GROUP BY COLUMN_NAME ORDER BY 2;
SELECT 'L5 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] 조회 전용 (전체 F5)
-- 기대: V1 마커 PASS(2) · V2 VALID/오류 0 · V3 삽입 줄 2 (두 조회 프로시저에 1줄씩)
-- 화면 확인: Column Set 에 LAST UPDATED BY · LAST UPDATE DATE 를 넣고 조회 → 넣기 전과 줄 순서가 같은지
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' WHEN COUNT(*) = 0 THEN 'FAIL (미적용)' ELSE 'FAIL (마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 줄' CHK, S.LINE, SUBSTR(LTRIM(RTRIM(S.TEXT, CHR(10)||CHR(13))), 1, 150) TXT
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND S.TEXT LIKE '%V_ORDERBY := RTRIM(REPLACE(REPLACE(V_ORDERBY%' ORDER BY S.LINE;
"""


def main():
    ddl = fresh_gate()
    os.makedirs(os.path.join(HERE, "A_DB"), exist_ok=True)
    files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_LASTUPDORD_PATCH.sql": gen_apply(ddl),
             "90_VERIFY.sql": VERIFY, "99_ROLLBACK_LASTUPDORD_PATCH.sql": gen_rollback()}
    for n, t in files.items():
        open(os.path.join(HERE, "A_DB", n), "w", encoding="utf-8", newline="\n").write(t)
        print("WROTE", n, t.count("\n"))


if __name__ == "__main__":
    main()
