"""DMF0082_GAP452_SAVETXN_CLOUD_20261015 패키지 생성기.

GAP 452 — DMF0082(40) 저장 도중 오류 시 앞부분만 반영된 채 남음(반쪽 저장). 사용자 결정 2026-10-15 "패키지 안만":
  S1 P_DMF0082_SAVE_MAIN_DATA 40 경로 전파 호출 직전 COMMIT 제거
  P1 P_PR_DM_PLN_CFM_TO_MKT_FCST GTT TRUNCATE(DDL=자동 확정) 9개 → DELETE
  P2 같은 프로시저 DBMS_STATS(자동 확정) 4개 제거
  P3 같은 프로시저 내부 COMMIT 제거
  한계: 전파 안의 공용 배치 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(통계 수집 25곳) 무변경 → 그 시점 이후 오류는 종전처럼 앞부분 확정.

모든 표지는 ASCII 다(한글 비교 없음). FRESH-GATE + 시뮬레이터(수정 전→적용==적용본 · 적용본→원복==수정 전).
"""
import os, sys, re, datetime, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "A_DB")
PRE_FILE = r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\b863378f-208f-46a1-9563-63278599cad9\scratchpad\gap452\body_fresh.sql"
M = "[GAP452 2026-10-15]"
MARK = "GAP452 2026-10-15"
P_A = "\nPROCEDURE P_PR_DM_PLN_CFM_TO_MKT_FCST"
P_B = "\nEND P_PR_DM_PLN_CFM_TO_MKT_FCST;"
S1_OLD = "        COMMIT;\n        P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);\n"
S1_NEW = f"        NULL;  --{M} commit removed: propagation error rolls back the whole save (single COMMIT at SP end)\n        P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);\n"
P3_OLD = "\n    COMMIT;\n"
P3_NEW = f"\n    NULL;  --{M} internal commit removed (caller P_DMF0082_SAVE_MAIN_DATA commits once; exception ROLLBACK+RAISE kept)\n"
# 정규식 — Python 시뮬레이터와 Oracle REGEXP 양쪽에서 같은 의미로 쓰는 형태(\w · 리터럴 escape · 줄 단위)
P1_PAT = r"EXECUTE IMMEDIATE 'TRUNCATE TABLE (SCM_MGR\.\w+)';"
P1_REP_PY = lambda m: f"DELETE FROM {m.group(1)};  --{M} TRUNCATE->DELETE (no implicit commit)"
P1_RB_PAT = r"DELETE FROM (SCM_MGR\.\w+);  --\[GAP452 2026-10-15\] TRUNCATE->DELETE \(no implicit commit\)"
P2_PAT = r"(    )(DBMS_STATS\.GATHER_TABLE_STATS\(OWNNAME => 'SCM_MGR', TABNAME => '\w+', NO_INVALIDATE => FALSE\);)"
P2_RB_PAT = r"(    )NULL;  --\[GAP452 2026-10-15\] stats removed \(implicit commit\): (DBMS_STATS\.GATHER_TABLE_STATS\(OWNNAME => 'SCM_MGR', TABNAME => '\w+', NO_INVALIDATE => FALSE\);)"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
# FRESH-GATE: 생성 직전 DB 원문 재조회 (ALL_SOURCE + LAST_DDL_TIME)
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
last_ddl = cur.fetchone()[0]
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
APPLIED = "".join(r[0] for r in cur).replace("\r\n", "\n")
fetched = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
PRE = open(PRE_FILE, encoding="utf-8", newline="").read().replace("\r\n", "\n")
assert APPLIED.count(MARK) == 15 and PRE.count(MARK) == 0, "FRESH-GATE 실패: 마커 수"


def seg_ops(src, fn):
    a = src.index(P_A); b = src.index(P_B, a)
    return src[:a] + fn(src[a:b]) + src[b:]


def sim_apply(src):
    assert src.count(S1_OLD) == 1
    src = src.replace(S1_OLD, S1_NEW)
    def f(seg):
        seg, n1 = re.subn(P1_PAT, P1_REP_PY, seg); assert n1 == 9
        seg, n2 = re.subn(P2_PAT, lambda m: f"{m.group(1)}NULL;  --{M} stats removed (implicit commit): {m.group(2)}", seg); assert n2 == 4
        assert seg.count(P3_OLD) == 1
        return seg.replace(P3_OLD, P3_NEW)
    return seg_ops(src, f)


def sim_rollback(src):
    assert src.count(S1_NEW) == 1
    src = src.replace(S1_NEW, S1_OLD)
    def f(seg):
        seg, n1 = re.subn(P1_RB_PAT, lambda m: f"EXECUTE IMMEDIATE 'TRUNCATE TABLE {m.group(1)}';", seg); assert n1 == 9
        seg, n2 = re.subn(P2_RB_PAT, lambda m: m.group(1) + m.group(2), seg); assert n2 == 4
        assert seg.count(P3_NEW) == 1
        return seg.replace(P3_NEW, P3_OLD)
    return seg_ops(src, f)


assert sim_apply(PRE) == APPLIED, "시뮬레이터: 수정 전 → 적용 ≠ 적용본"
assert sim_rollback(APPLIED) == PRE, "시뮬레이터: 적용본 → 원복 ≠ 수정 전"
print("simulator OK")


def q(t):
    return t.replace("'", "''").replace("\n", "' || CHR(10) || '")


STAMP = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={last_ddl} FETCHED={fetched} DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)"
DECL = f"""    v_src    CLOB;
    v_new    CLOB;
    v_seg    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_a      PLS_INTEGER;
    v_b      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '{MARK}';
    c_pa     CONSTANT VARCHAR2(100)  := '{q(P_A)}';
    c_pb     CONSTANT VARCHAR2(100)  := '{q(P_B)}';
    c_s1_old CONSTANT VARCHAR2(400)  := '{q(S1_OLD)}';
    c_s1_new CONSTANT VARCHAR2(600)  := '{q(S1_NEW)}';
    c_p3_old CONSTANT VARCHAR2(100)  := '{q(P3_OLD)}';
    c_p3_new CONSTANT VARCHAR2(400)  := '{q(P3_NEW)}';
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
            RAISE_APPLICATION_ERROR(-20002, '중단 — P_PR_DM_PLN_CFM_TO_MKT_FCST 위치 확인 불가. 원문 무변경');
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
LOAD = """    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;"""
COMPILE = """    BEGIN
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
ql = lambda t: t.replace("'", "''")

APPLY = f"""{STAMP}
-- 10_APPLY — [{MARK}] GAP 452 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082(40) 저장 도중 오류 시 앞부분만 확정되던 '반쪽 저장'을 줄인다 (사용자 결정 2026-10-15 "패키지 안만").
--   S1 P_DMF0082_SAVE_MAIN_DATA 40 경로 전파 호출 직전 COMMIT 제거
--   P1 P_PR_DM_PLN_CFM_TO_MKT_FCST GTT TRUNCATE(DDL=자동 확정) 9개 → DELETE
--   P2 같은 프로시저 DBMS_STATS(자동 확정) 4개 제거 (저장 SP 세션 optimizer_dynamic_sampling=2 가 대체)
--   P3 같은 프로시저 내부 COMMIT 제거 (호출자 저장 SP 끝 COMMIT 1곳에서 확정, 예외 ROLLBACK+RAISE 유지)
--   한계: 전파 안의 공용 배치 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(통계 수집 25곳)는 무변경 → 그 호출 이후 오류는 종전처럼 앞부분 확정.
-- 범위: 저장 SP 1줄 + 전파 프로시저. 조회 · 원장 · 메타 · FE · 권한 · GTT 정의 무변경. 81 경로 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 표지/패턴으로 치환(한글 비교 없음) → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 각 대상 건수(1/9/4/1)가 다르면 중단(원문 무변경) · 마커 15곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL {last_ddl}) — 정상 저장 경로 실측: 100 저장·0 저장·전파(DM_PLN_MKT_FCST) 정상.
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    -- S1
    expect('S1 저장 SP 전파 직전 COMMIT', cnt(v_new, c_s1_old), 1);
    v_new := REPLACE(v_new, c_s1_old, c_s1_new);
    -- P1~P3 (전파 프로시저 구간)
    split_seg;
    expect('P1 TRUNCATE', REGEXP_COUNT(v_seg, '{ql(P1_PAT)}'), 9);
    expect('P2 DBMS_STATS', REGEXP_COUNT(v_seg, '{ql(P2_PAT)}'), 4);
    expect('P3 COMMIT', cnt(v_seg, c_p3_old), 1);
    v_seg := REGEXP_REPLACE(v_seg, '{ql(P1_PAT)}', 'DELETE FROM \\1;  --{M} TRUNCATE->DELETE (no implicit commit)');
    v_seg := REGEXP_REPLACE(v_seg, '{ql(P2_PAT)}', '\\1NULL;  --{M} stats removed (implicit commit): \\2');
    v_seg := REPLACE(v_seg, c_p3_old, c_p3_new);
    join_seg;
    IF (DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark) <> 15 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 수 불일치(15 기대). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 15곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

ROLLBACK = f"""{STAMP}
-- 99_ROLLBACK — [{MARK}] GAP 452 원복 (전체 F5, 값 입력 없음, 멱등) — ASCII 표지·패턴으로 역치환
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
{DECL}BEGIN
{LOAD}
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    expect('S1', cnt(v_new, c_s1_new), 1);
    v_new := REPLACE(v_new, c_s1_new, c_s1_old);
    split_seg;
    expect('P1', REGEXP_COUNT(v_seg, '{ql(P1_RB_PAT)}'), 9);
    expect('P2', REGEXP_COUNT(v_seg, '{ql(P2_RB_PAT)}'), 4);
    expect('P3', cnt(v_seg, c_p3_new), 1);
    v_seg := REGEXP_REPLACE(v_seg, '{ql(P1_RB_PAT)}', 'EXECUTE IMMEDIATE ''TRUNCATE TABLE \\1'';');
    v_seg := REGEXP_REPLACE(v_seg, '{ql(P2_RB_PAT)}', '\\1\\2');
    v_seg := REPLACE(v_seg, c_p3_new, c_p3_old);
    join_seg;
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
{COMPILE}
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
{POST}
"""

PROC_RANGE = """   AND S.LINE BETWEEN (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'PROCEDURE P_PR_DM_PLN_CFM_TO_MKT_FCST%')
                  AND (SELECT MIN(LINE) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE 'END P_PR_DM_PLN_CFM_TO_MKT_FCST;%')"""
PRECHECK = f"""-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [{MARK}] GAP 452 적용 전 상태
-- * [L0] 접속 DB · PKG_DMF0082 상태·LAST_DDL
-- * [L1] 대상 건수 — 저장 SP 전파 호출 1 · 전파 프로시저 TRUNCATE 9 · DBMS_STATS 4 · COMMIT 1 (전부 PASS 기대)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 패키지 밖 P_PR_DM_PLN_CFM_TO_MKT_FCST 호출처 0 (내부 COMMIT 제거의 영향 범위 확인 — PASS 기대)
-- * [L4] 지금 PKG_DMF0082 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A40
COLUMN JUDGE FORMAT A60
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'L1 대상' CHK, 'S1 저장 SP 전파 호출 줄' KIND, COUNT(*) N, CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END JUDGE
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY'
   AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '        P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);'
   AND RTRIM((SELECT P.TEXT FROM USER_SOURCE P WHERE P.NAME=S.NAME AND P.TYPE=S.TYPE AND P.LINE=S.LINE-1), CHR(10)||CHR(13)) = '        COMMIT;'
UNION ALL
SELECT 'L1 대상', 'P1 전파 PR TRUNCATE', COUNT(*), CASE WHEN COUNT(*) = 9 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND REGEXP_LIKE(S.TEXT, '{ql(P1_PAT)}')
{PROC_RANGE}
UNION ALL
SELECT 'L1 대상', 'P2 전파 PR DBMS_STATS', COUNT(*), CASE WHEN COUNT(*) = 4 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND REGEXP_LIKE(S.TEXT, '^{ql(P2_PAT)}')
{PROC_RANGE}
UNION ALL
SELECT 'L1 대상', 'P3 전파 PR COMMIT', COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'PASS' ELSE 'FAIL → 10 실행 금지·결과 회신' END
  FROM USER_SOURCE S WHERE S.NAME='PKG_DMF0082' AND S.TYPE='PACKAGE BODY' AND RTRIM(S.TEXT, CHR(10)||CHR(13)) = '    COMMIT;'
{PROC_RANGE};
SELECT 'L2 마커' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN '미적용 (기대)' ELSE '적용됨 — 10 재실행은 가드로 무동작' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'L3 외부호출' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL — 패키지 밖 호출처 있음 → 결과 회신(그쪽 확정 처리 검토 필요)' END JUDGE
  FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%P_PR_DM_PLN_CFM_TO_MKT_FCST%' AND NOT (OWNER = USER AND NAME = 'PKG_DMF0082') AND TRIM(TEXT) NOT LIKE '--%';
SELECT 'L4 실행중' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE');
"""

VERIFY = f"""-- 90 VERIFY — [{MARK}] GAP 452 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 15줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 전파 PR 안 TRUNCATE·DBMS_STATS·COMMIT 활성 0 PASS
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
COLUMN CHK FORMAT A10
COLUMN KIND FORMAT A40
COLUMN JUDGE FORMAT A60
SELECT 'V1 마커' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 15 THEN 'PASS' ELSE 'FAIL (미적용 또는 마커 수 불일치)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{MARK}%';
SELECT 'V2 상태' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0082')) DEP_INVALID
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
SELECT 'V3 잔존' CHK, K.KIND, COUNT(S.LINE) N, CASE WHEN COUNT(S.LINE) = 0 THEN 'PASS' ELSE 'FAIL — 회신' END JUDGE
  FROM ( SELECT 'TRUNCATE (실행문)' KIND, '{ql(P1_PAT)}' PAT FROM DUAL UNION ALL
         SELECT 'DBMS_STATS (실행문)', '^    DBMS_STATS' FROM DUAL UNION ALL
         SELECT 'COMMIT (실행문)', '^    COMMIT;' FROM DUAL ) K
  LEFT JOIN USER_SOURCE S
    ON S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY' AND REGEXP_LIKE(S.TEXT, K.PAT)
{PROC_RANGE}
 GROUP BY K.KIND ORDER BY K.KIND;
"""

os.makedirs(OUT, exist_ok=True)
files = {"00_PRECHECK_CLOUD.sql": PRECHECK, "10_APPLY_GAP452_PATCH.sql": APPLY, "90_VERIFY.sql": VERIFY, "99_ROLLBACK_GAP452_PATCH.sql": ROLLBACK}
for name, body in files.items():
    open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n").write(body)
    print("wrote", name, len(body.splitlines()), "lines")
open(os.path.join(HERE, "_md5_corporate_applied.txt"), "w", encoding="utf-8").write(
    f"PKG_DMF0082 BODY (LF) applied md5={hashlib.md5(APPLIED.encode('utf-8')).hexdigest()} pre md5={hashlib.md5(PRE.encode('utf-8')).hexdigest()} LAST_DDL={last_ddl} FETCHED={fetched}\n")
print("LAST_DDL", last_ddl)
