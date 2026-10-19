"""DMF0072_GAP418_ENDCUSTKEY_CLOUD_20261015 패키지 생성기.

GAP 418 — DMF0072 저장 방식: TO-BE 행별 존재 확인·UPDATE 조건에 END_CUSTOMER 포함 → AS-IS MERGE ON(END_CUSTOMER 주석 제외)과 같게.
  End Customer 만 바꾼 수정(M) 행: AS-IS = 같은 원장 행 UPDATE / TO-BE = 미매칭 → INSERT → ORA-00001 저장 실패.
  보완: 존재 확인 SELECT · UPDATE WHERE 의 END_CUSTOMER 조건 2줄 주석 처리. 행별 루프(ORA-38104 사유)는 유지.
  ⚠ 선행 = GAP412 (마커 'GAP412 2026-10-15'). 412 없이 적용하면 End Customer 만 다른 같은 PK 신규 행이 덮어쓰기가 됨 → 가드로 중단.

FRESH-GATE: 생성 직전 사내 ALL_SOURCE 재조회 == 착수 조회본(_apply_corporate/DMF0072_GAP418_20261015/PKG_DMF0072_BODY.FETCHED.sql).
  패치 문구 기준본 = GAP412 적용본(사내 412 미적용 상태라 412 적용기의 적용본 파일).
시뮬레이터: 412 적용본 → 적용 == 418 적용본 · 418 적용본 → 원복 == 412 적용본.
DRY-RUN(사내, DB 무변경): 10/99 PL/SQL 블록을 소스 입력=바인드, 컴파일 대신 결과 CLOB 반환으로 바꿔 실행 → 기대값과 전문 대조.
모든 표지는 ASCII (한글 비교 없음).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0072_GAP418_20261015"
sys.path.insert(0, CORP)
from apply_gap418 import REPL, P_A, P_B, MARK, MARK412, PKG  # 사내 적용기와 동일 문구 (단일 소스)

SP = "P_DMF0072_SAVE_NNMASTER_MAPPING"
TAG = "GAP418"
(OLD1, NEW1), (OLD2, NEW2) = REPL

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")
print("DB", d, cur.fetchone())
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=PKG)
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=PKG)
NOW = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
rd = lambda f: open(os.path.join(CORP, f), encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert NOW == rd("PKG_DMF0072_BODY.FETCHED.sql"), "FRESH-GATE 실패: 착수 조회본 이후 사내 원문 변경 — 재조회·재병합"
BASE = rd("PKG_DMF0072_BODY.ASIS.sql")   # = GAP412 적용본
assert NOW.count(MARK) == 0 and BASE.count(MARK412) == 1 and BASE.count(MARK) == 0
assert all(o.isascii() and n.isascii() and n.count(MARK) == 1 for o, n in REPL)


def seg(src):
    a = src.index(P_A); b = src.index(P_B, a)
    return a, b


def sim(src, pairs):
    a, b = seg(src); s = src[a:b]
    for o, n in pairs:
        assert s.count(o) == 1
        s = s.replace(o, n)
    return src[:a] + s + src[b:]


TOBE = sim(BASE, REPL)
assert sim(TOBE, [(n, o) for o, n in REPL]) == BASE, "시뮬레이터: 적용본 → 원복 ≠ GAP412 적용본"
assert TOBE == rd("PKG_DMF0072_BODY.TOBE.sql")
print("simulator OK")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


ql = lambda t: t.replace("'", "''")


STAMP = (f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 "
         f"(사내는 GAP412 미적용 — 문구 기준 = GAP412 적용본 · 클라우드는 자기 USER_SOURCE 를 패치)")
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_seg    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_a      PLS_INTEGER;
    v_b      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_m412   CONSTANT VARCHAR2(40)   := '{MARK412}';
    c_pa     CONSTANT VARCHAR2(200)  := '{q(P_A)}';
    c_pb     CONSTANT VARCHAR2(200)  := '{q(P_B)}';
    c_old1   CONSTANT VARCHAR2(400)  := '{q(OLD1)}';
    c_new1   CONSTANT VARCHAR2(400)  := '{q(NEW1)}';
    c_old2   CONSTANT VARCHAR2(400)  := '{q(OLD2)}';
    c_new2   CONSTANT VARCHAR2(400)  := '{q(NEW2)}';
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
    PROCEDURE split_seg IS
    BEGIN
        v_a := DBMS_LOB.INSTR(v_new, c_pa);
        v_b := CASE WHEN v_a > 0 THEN DBMS_LOB.INSTR(v_new, c_pb, v_a) ELSE 0 END;
        IF NOT (v_a > 0 AND v_b > v_a) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — {SP} 위치 확인 불가. 원문 무변경');
        END IF;
        v_seg := SUBSTR(v_new, v_a, v_b - v_a);
    END;
    PROCEDURE join_seg IS
    BEGIN
        v_new := SUBSTR(v_new, 1, v_a - 1) || v_seg || SUBSTR(v_new, v_b);
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' ' || p_got || '건 (' || p_exp || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
    END;
"""
LOAD = f"""    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = '{PKG}' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;"""
COMPILE = f"""    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = '{PKG}' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = '{PKG}' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = '{PKG}' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;"""
POST = f"SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' ORDER BY OBJECT_TYPE;"

APPLY_BODY = """    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF DBMS_LOB.INSTR(v_src, c_m412) = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — 선행 GAP412 미적용 (마커 GAP412 2026-10-15 없음). DMF0072_GAP412_INSDUP 패키지 먼저 적용. 원문 무변경');
    END IF;
    split_seg;
    expect('존재 확인 END_CUSTOMER 조건 줄', cnt(v_seg, c_old1), 1);
    expect('UPDATE WHERE END_CUSTOMER 조건 줄', cnt(v_seg, c_old2), 1);
    v_seg := REPLACE(v_seg, c_old1, c_new1);
    v_seg := REPLACE(v_seg, c_old2, c_new2);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 2);
"""
ROLLBACK_BODY = """    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    split_seg;
    expect('적용 줄 1', cnt(v_seg, c_new1), 1);
    expect('적용 줄 2', cnt(v_seg, c_new2), 1);
    v_seg := REPLACE(v_seg, c_new1, c_old1);
    v_seg := REPLACE(v_seg, c_new2, c_old2);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 0);
"""

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 418 PKG_DMF0072 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: N N Master Mapping 저장 {SP} — 행별 존재 확인 · UPDATE 조건에서 END_CUSTOMER 제외 (AS-IS MERGE ON 과 같은 키).
--   종전: End Customer 만 바꾼 수정 행이 기존 행과 못 맞춰져 INSERT → ORA-00001 저장 실패. AS-IS: 같은 행 UPDATE(End Customer 는 미갱신).
--   행별 루프 구조(ORA-38104 사유) · 신규(I) 행 처리 · 다른 프로시저 무변경. 원장 · 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- ⚠ 선행: DMF0072_GAP412_INSDUP_CLOUD_20261015 (마커 GAP412 2026-10-15). 없으면 중단.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 저장 SP 구간 안 ASCII 문구 2줄을 주석 처리 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · GAP412 마커 없으면 중단 · 대상 줄 각 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
{APPLY_BODY}{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — {PKG} BODY ' || v_st || ' · 마커 2곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""
ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 418 원복 (전체 F5, 값 입력 없음, 멱등) — END_CUSTOMER 조건 2줄 복원(역치환). GAP412 는 그대로 둔다
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
{ROLLBACK_BODY}{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — {PKG} BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

SP_RANGE = f"""   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE {SP}%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'END {SP};%')"""
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 418 적용 전 상태
-- * [L0] 접속 DB · {PKG} 상태·LAST_DDL
-- * [L1] 대상 — 저장 SP 안 END_CUSTOMER 조건 2줄 각 1 (PASS 기대)
-- * [L2] 선행 GAP412 마커 1 (PASS 기대 — FAIL 이면 GAP412 패키지 먼저)
-- * [L3] 마커 — 적용 전 0
-- * [L4] 지금 {PKG} 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A50
COLUMN JUDGE FORMAT A70
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상' CHK, '존재 확인 END_CUSTOMER 줄' KIND, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{ql(OLD1.rstrip(chr(10)))}'
{SP_RANGE}
UNION ALL
SELECT 'L1 대상', 'UPDATE WHERE END_CUSTOMER 줄', COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '{ql(OLD2.rstrip(chr(10)))}'
{SP_RANGE};
SELECT 'L2 선행' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → GAP412 패키지 먼저 적용' END JUDGE
  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK412}%';
SELECT 'L3 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' AND OBJECT_TYPE='PACKAGE');
"""
VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 418 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 2 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 저장 SP 안 활성 END_CUSTOMER 조건 0 PASS
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A50
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{PKG}')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 잔존' CHK, '활성 END_CUSTOMER = REC.END_CUSTOMER 조건' KIND, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND REGEXP_LIKE(S.TEXT, '^ *AND +A\\.END_CUSTOMER += REC\\.END_CUSTOMER')
{SP_RANGE};
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, f"10_APPLY_{TAG}_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, f"99_ROLLBACK_{TAG}_PATCH.sql": ROLLBACK}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")


# ── DRY-RUN (사내, DB 무변경): 소스 = 바인드 입력, 컴파일 대신 결과 반환 ──
def dryrun(block_sql, src):
    blk = "DECLARE\n" + block_sql.split("DECLARE\n", 1)[1].rsplit("\n/\n", 1)[0]
    blk = blk.replace(LOAD, "    v_src := :src;\n    v_new := v_src;")
    blk = blk.replace(COMPILE, "    :res := v_new;")
    blk = blk.replace("        RETURN;\n", "        :res := 'SKIP';\n        RETURN;\n")
    assert ":res := v_new;" in blk and "EXECUTE IMMEDIATE" not in blk, "dry-run 변환 실패 — 실행 금지"
    o = cur.var(oracledb.DB_TYPE_CLOB)
    cur.execute(blk, src=src, res=o)
    v = o.getvalue()
    return v.read() if hasattr(v, "read") else v


assert dryrun(APPLY, BASE) == TOBE, "DRY-RUN 10: GAP412 적용본 → 적용 ≠ 418 적용본"
assert dryrun(APPLY, TOBE) == "SKIP", "DRY-RUN 10 재실행 SKIP 아님"
try:
    dryrun(APPLY, NOW)
    raise AssertionError("DRY-RUN 10: GAP412 미적용 원문인데 중단되지 않음")
except oracledb.DatabaseError as e:
    assert "ORA-20003" in str(e), e
assert dryrun(ROLLBACK, TOBE) == BASE, "DRY-RUN 99: 적용본 → 원복 ≠ GAP412 적용본"
assert dryrun(ROLLBACK, BASE) == "SKIP", "DRY-RUN 99 재실행 SKIP 아님"
print("dry-run OK (10 적용==적용본 · 10 재실행 SKIP · 412 미적용 시 중단 · 99 원복==412 적용본 · 99 재실행 SKIP)")

open(os.path.join(HERE, "_md5_corporate.txt"), "w", encoding="utf-8").write(
    f"{PKG} BODY (LF) corp-now md5={hashlib.md5(NOW.encode('utf-8')).hexdigest()} base(GAP412 applied) md5={hashlib.md5(BASE.encode('utf-8')).hexdigest()} "
    f"tobe md5={hashlib.md5(TOBE.encode('utf-8')).hexdigest()} "
    f"LAST_DDL={last_ddl} FETCHED={fetched} (사내 미적용 상태에서 생성)\n")
print("LAST_DDL", last_ddl)
