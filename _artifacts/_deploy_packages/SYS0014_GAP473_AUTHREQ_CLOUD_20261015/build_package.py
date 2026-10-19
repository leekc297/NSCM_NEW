"""SYS0014_GAP473_AUTHREQ_CLOUD_20261015 패키지 생성기.

GAP 473 — SYS0014 Group User: 사용자를 그룹에서 빼거나 사업부 권한을 지워도 권한 요청 기록(SCM_MST_AUTH_REQUEST)이 남음.
  AS-IS UP_FX_DeleteUserGroupInfo / UP_FX_DeleteUserGroupAuthExtention (LGCE_SCMDEV) 는 같은 키의 요청 기록도 지운다.
  보완: PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M 의 userInfo D · unit_auth D 블록 머리에 AUTH_REQUEST 삭제 1문장씩 삽입.

FRESH-GATE: 생성 직전 사내 ALL_SOURCE 재조회 == 사내 적용본(_apply_corporate/SYS0014_GAP473_AUTHREQ_20261015/PKG_SYS0014_BODY.TOBE.sql)
            (사내는 21:13:24 적용 완료 상태 — 수정 전 원문 = 같은 폴더 .ASIS.sql, 착수 시 조회본)
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
CORP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\SYS0014_GAP473_AUTHREQ_20261015"
sys.path.insert(0, CORP)
from apply_gap473 import OLD1, NEW1, OLD2, NEW2, P_A, P_B, MARK, PKG  # 사내 적용기와 동일 문구 (단일 소스)

SP = "P_SYS0014_SAVE_GROUP_USER_M"
TAG = "GAP473"

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
PRE = open(os.path.join(CORP, "PKG_SYS0014_BODY.ASIS.sql"), encoding="utf-8", newline="").read().replace("\r\n", "\n")
TOBE_FILE = open(os.path.join(CORP, "PKG_SYS0014_BODY.TOBE.sql"), encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert NOW == TOBE_FILE, "FRESH-GATE 실패: 사내 원문 != 사내 적용본 — 재조회·재병합"
assert PRE.count(MARK) == 0 and NEW1.count(MARK) == 1 and NEW2.count(MARK) == 1
assert all(x.isascii() for x in (OLD1, NEW1, OLD2, NEW2, P_A, P_B, MARK))
PAIRS = [(OLD1, NEW1), (OLD2, NEW2)]


def seg(src):
    a = src.index(P_A); b = src.index(P_B, a)
    return a, b


def sim_apply(src):
    a, b = seg(src); s = src[a:b]
    for old, new in PAIRS:
        assert s.count(old) == 1
        s = s.replace(old, new)
    return src[:a] + s + src[b:]


def sim_rollback(src):
    a, b = seg(src); s = src[a:b]
    for old, new in PAIRS:
        assert s.count(new) == 1
        s = s.replace(new, old)
    return src[:a] + s + src[b:]


TOBE = sim_apply(PRE)
assert TOBE == NOW, "시뮬레이터: 수정 전 → 적용 ≠ 사내 적용본"
assert sim_rollback(TOBE) == PRE, "시뮬레이터: 적용본 → 원복 ≠ 수정 전"
print("simulator OK")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = (f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 "
         f"(사내 적용본 기준 문구 · 클라우드는 자기 USER_SOURCE 를 패치)")
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
    c_old1   CONSTANT VARCHAR2(4000) := '{q(OLD1)}';
    c_new1   CONSTANT VARCHAR2(4000) := '{q(NEW1)}';
    c_old2   CONSTANT VARCHAR2(4000) := '{q(OLD2)}';
    c_new2   CONSTANT VARCHAR2(4000) := '{q(NEW2)}';
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
    expect('저장 SP userInfo DELETE 주석 줄', cnt(v_seg, c_old1), 1);
    expect('저장 SP unit_auth DELETE 주석 줄', cnt(v_seg, c_old2), 1);
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
    expect('적용 블록 1 (userInfo)', cnt(v_seg, c_new1), 1);
    expect('적용 블록 2 (unit_auth)', cnt(v_seg, c_new2), 1);
    v_seg := REPLACE(v_seg, c_new1, c_old1);
    v_seg := REPLACE(v_seg, c_new2, c_old2);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 0);
"""

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 473 PKG_SYS0014 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: Group User 저장 {SP} — 사용자를 그룹에서 삭제(UserInfo D)하거나 사업부 권한을 삭제(Division D)할 때
--   같은 키의 권한 요청 기록(SCM_MST_AUTH_REQUEST)도 함께 삭제 (AS-IS UP_FX_DeleteUserGroupInfo / UP_FX_DeleteUserGroupAuthExtention 동일).
--   그룹(GroupInfo) 삭제 · 추가 · 수정 · 다른 프로시저 무변경. 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 저장 SP 구간 안 ASCII 주석 2줄 뒤에 DELETE 1문장씩 삽입 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 줄 각 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
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
-- 99_ROLLBACK — [{MARK}] GAP 473 원복 (전체 F5, 값 입력 없음, 멱등) — 삽입한 DELETE 2문장 제거(역치환)
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

SP_RANGE = f"""   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE {SP} (%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'END {SP};%')"""
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 473 적용 전 상태
-- * [L0] 접속 DB · {PKG} 상태·LAST_DDL
-- * [L1] 대상 — 저장 SP 안 '    -- userInfo DELETE' 줄 1 · '    -- unit_auth DELETE' 줄 1 (둘 다 PASS 기대)
-- * [L2] 권한 요청 테이블 SCM_MGR.SCM_MST_AUTH_REQUEST 키 컬럼 4개(DIVISION_ID·GROUP_ID·PLANT_ID·USER_ID) 존재 (4행 기대)
-- * [L3] 마커 — 적용 전 0
-- * [L4] 참고 — 매핑 없는 권한 요청 기록 수(이번 패치는 이미 남아 있는 기록을 지우지 않는다. 숫자만 회신)
-- * [L5] 지금 {PKG} 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A50
COLUMN JUDGE FORMAT A70
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상' CHK, '-- userInfo DELETE 줄' KIND, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '    -- userInfo DELETE'
{SP_RANGE}
UNION ALL
SELECT 'L1 대상', '-- unit_auth DELETE 줄', COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '    -- unit_auth DELETE'
{SP_RANGE};
SELECT 'L2 테이블' CHK, COLUMN_NAME KIND, DATA_TYPE, NULLABLE
  FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_AUTH_REQUEST'
   AND COLUMN_NAME IN ('USER_ID','GROUP_ID','DIVISION_ID','PLANT_ID') ORDER BY COLUMN_NAME;
SELECT 'L3 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L4 참고' CHK, COUNT(*) TOTAL_REQ,
       SUM(CASE WHEN NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M M WHERE M.USER_GR_ID = R.GROUP_ID AND M.USER_ID = R.USER_ID) THEN 1 ELSE 0 END) NO_MAPPING_REQ
  FROM SCM_MGR.SCM_MST_AUTH_REQUEST R;
SELECT 'L5 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' AND OBJECT_TYPE='PACKAGE');
"""
VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 473 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 2 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 저장 SP 안 AUTH_REQUEST DELETE 2 PASS
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
SELECT 'V3 활성' CHK, '저장 SP 안 AUTH_REQUEST DELETE' KIND, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='{PKG}' AND S.TYPE='PACKAGE BODY'
   AND TRIM(S.TEXT) LIKE 'DELETE FROM SCM_MGR.SCM_MST_AUTH_REQUEST R%'
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


assert dryrun(APPLY, PRE) == TOBE, "DRY-RUN 10: 수정 전 → 적용 ≠ 적용본"
assert dryrun(APPLY, TOBE) == "SKIP", "DRY-RUN 10 재실행 SKIP 아님"
assert dryrun(ROLLBACK, TOBE) == PRE, "DRY-RUN 99: 적용본 → 원복 ≠ 수정 전"
assert dryrun(ROLLBACK, PRE) == "SKIP", "DRY-RUN 99 재실행 SKIP 아님"
print("dry-run OK (10 적용==적용본 · 10 재실행 SKIP · 99 원복==수정 전 · 99 재실행 SKIP)")

open(os.path.join(HERE, "_md5_corporate.txt"), "w", encoding="utf-8").write(
    f"{PKG} BODY (LF) pre md5={hashlib.md5(PRE.encode('utf-8')).hexdigest()} tobe md5={hashlib.md5(TOBE.encode('utf-8')).hexdigest()} "
    f"LAST_DDL={last_ddl} FETCHED={fetched} (사내 적용 완료 상태에서 생성)\n")
print("LAST_DDL", last_ddl)
