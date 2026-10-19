"""DMF0072_GAP412_INSDUP_CLOUD_20261015 패키지 생성기.

GAP 412 — DMF0072 신규(I) 행 키가 기존 행과 같으면 오류 없이 기존 행을 덮어씀 → AS-IS 처럼 저장 실패.
  AS-IS DMF0072_SAVE_NNMASTER_MAPPING (LGCE_SCMDEV 2025-01-21): MERGE ON (... AND B.ACT_TYPE='M') → I 행은 항상 INSERT
    → PK(DM_CUST_MODEL_MAPPING_M_PK 15컬럼, END_CUSTOMER 미포함) 위반 → CATCH 'F' + 오류, 같이 보낸 행 전부 미반영.
  TO-BE P_DMF0072_SAVE_NNMASTER_MAPPING: 커서 ACT_TYPE IN ('M','I') (2026.08.13 AJS) + 존재 시 UPDATE → I 행이 기존 행 덮어씀.
  보완: 루프의 'IF V_EXISTS_CNT > 0 THEN' 바로 앞에 I 행 PK 중복 확인(센티널 '-'/'--'/'/'/공백 동치) → RAISE → 기존 EXCEPTION ROLLBACK.

FRESH-GATE: 생성 직전 사내 ALL_SOURCE 재조회 == 착수 조회본(_apply_corporate/DMF0072_GAP412_20261015/PKG_DMF0072_BODY.ASIS.sql).
시뮬레이터: 수정 전 → 적용 == 적용본 · 적용본 → 원복 == 수정 전.
DRY-RUN(사내, DB 무변경): 10/99 PL/SQL 블록을 소스 입력=바인드, 컴파일 대신 결과 CLOB 반환으로 바꿔 실행 → 기대값과 전문 대조.
모든 표지는 ASCII (한글 비교 없음).
"""
import os, sys, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0072_GAP412_20261015"
sys.path.insert(0, CORP)
from apply_gap412 import OLD, NEW, P_A, P_B, MARK, PKG  # 사내 적용기와 동일 문구 (단일 소스)

SP = "P_DMF0072_SAVE_NNMASTER_MAPPING"
TAG = "GAP412"

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
ASIS = open(os.path.join(CORP, "PKG_DMF0072_BODY.ASIS.sql"), encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert NOW == ASIS, "FRESH-GATE 실패: 착수 조회본 이후 사내 원문 변경 — 재조회·재병합"
assert NOW.count(MARK) == 0 and NEW.count(MARK) == 1 and NEW.isascii() and OLD.isascii()


def seg(src):
    a = src.index(P_A); b = src.index(P_B, a)
    return a, b


def sim_apply(src):
    a, b = seg(src); s = src[a:b]
    assert s.count(OLD) == 1
    return src[:a] + s.replace(OLD, NEW) + src[b:]


def sim_rollback(src):
    a, b = seg(src); s = src[a:b]
    assert s.count(NEW) == 1
    return src[:a] + s.replace(NEW, OLD) + src[b:]


TOBE = sim_apply(NOW)
assert sim_rollback(TOBE) == NOW, "시뮬레이터: 적용본 → 원복 ≠ 수정 전"
assert TOBE == open(os.path.join(CORP, "PKG_DMF0072_BODY.TOBE.sql"), encoding="utf-8", newline="").read().replace("\r\n", "\n")
print("simulator OK")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = (f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 "
         f"(사내 수정 전 원문 기준 문구 · 클라우드는 자기 USER_SOURCE 를 패치)")
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_seg    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_a      PLS_INTEGER;
    v_b      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_pa     CONSTANT VARCHAR2(200)  := '{q(P_A)}';
    c_pb     CONSTANT VARCHAR2(200)  := '{q(P_B)}';
    c_old    CONSTANT VARCHAR2(4000) := '{q(OLD)}';
    c_new    CONSTANT VARCHAR2(4000) := '{q(NEW)}';
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
    split_seg;
    expect('저장 SP 루프 IF V_EXISTS_CNT 줄', cnt(v_seg, c_old), 1);
    v_seg := REPLACE(v_seg, c_old, c_new);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 1);
"""
ROLLBACK_BODY = """    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    split_seg;
    expect('적용 블록', cnt(v_seg, c_new), 1);
    v_seg := REPLACE(v_seg, c_new, c_old);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 0);
"""

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 412 PKG_DMF0072 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: N N Master Mapping 저장 {SP} — 신규(I) 행의 키(PK 15컬럼)가 기존 행과 같으면 오류 → 저장 전체 ROLLBACK.
--   종전: 오류 없이 기존 행의 Valid From/To · Active · Mapping Item 을 덮어씀. AS-IS: PK 위반으로 저장 실패.
--   수정(M) 행 처리 · 저장 대상 커서(ACT_TYPE IN ('M','I')) · 다른 프로시저 무변경. 원장 · 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 저장 SP 구간 안 ASCII 문구 1곳 앞에 확인 블록 삽입 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 줄 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
{APPLY_BODY}{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — {PKG} BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""
ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 412 원복 (전체 F5, 값 입력 없음, 멱등) — 삽입한 확인 블록 제거(역치환)
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
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 412 적용 전 상태
-- * [L0] 접속 DB · {PKG} 상태·LAST_DDL
-- * [L1] 대상 — 저장 SP 안 '        IF V_EXISTS_CNT > 0 THEN' 줄 1 (PASS 기대)
-- * [L2] 저장 커서가 I 행을 포함하는가 — 'WHERE B.ACT_TYPE IN (''M'', ''I'')' 줄 1 (PASS 기대.
--        FAIL 이면 클라우드는 신규 행이 아예 저장되지 않는 구판 — 10 은 무해하나 효과 없음 → 결과 회신)
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
SELECT 'L1 대상' CHK, 'IF V_EXISTS_CNT > 0 THEN 줄' KIND, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '        IF V_EXISTS_CNT > 0 THEN'
{SP_RANGE}
UNION ALL
SELECT 'L2 커서', 'ACT_TYPE IN (''M'', ''I'') 줄', COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL — 신규 행 미처리 구판 가능 → 결과 회신' END
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND TRIM(S.TEXT) LIKE 'WHERE B.ACT_TYPE IN (''M'', ''I'');%'
{SP_RANGE};
SELECT 'L3 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' AND OBJECT_TYPE='PACKAGE');
"""
VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 412 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 1 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 저장 SP 안 RAISE -20072 1 PASS
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A50
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{PKG}')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 활성' CHK, '저장 SP 안 I 행 중복 RAISE' KIND, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND TRIM(S.TEXT) LIKE 'RAISE_APPLICATION_ERROR(-20072,%'
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


assert dryrun(APPLY, NOW) == TOBE, "DRY-RUN 10: 수정 전 → 적용 ≠ 적용본"
assert dryrun(APPLY, TOBE) == "SKIP", "DRY-RUN 10 재실행 SKIP 아님"
assert dryrun(ROLLBACK, TOBE) == NOW, "DRY-RUN 99: 적용본 → 원복 ≠ 수정 전"
assert dryrun(ROLLBACK, NOW) == "SKIP", "DRY-RUN 99 재실행 SKIP 아님"
print("dry-run OK (10 적용==적용본 · 10 재실행 SKIP · 99 원복==수정 전 · 99 재실행 SKIP)")

open(os.path.join(HERE, "_md5_corporate.txt"), "w", encoding="utf-8").write(
    f"{PKG} BODY (LF) pre md5={hashlib.md5(NOW.encode('utf-8')).hexdigest()} tobe md5={hashlib.md5(TOBE.encode('utf-8')).hexdigest()} "
    f"LAST_DDL={last_ddl} FETCHED={fetched} (사내 미적용 상태에서 생성)\n")
print("LAST_DDL", last_ddl)
