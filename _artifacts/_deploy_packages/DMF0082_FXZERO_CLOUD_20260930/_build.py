# -*- coding: utf-8 -*-
"""DMF0082_FXZERO_CLOUD_20260930 — 클라우드 이관 패키지 빌더 [E20260930-DMF0082FXZERO].

원천 = 사내 ZIOUI1 PKG_DMF0082 BODY 를 지금 새로 읽은 원문 (hook #152). FRESH-GATE: 추출 전후 동일 + 마커 assert.
BEFORE 지문 = 사내 적용 직전 백업(00_BACKUP_PKG_DMF0082_BODY.sql = CUSTEXCEL 누적본과 동일 원문)에서 동일 산식으로 계산.
사용: python _build.py
"""
import datetime, io, pathlib, shutil, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

TAG = "E20260930-DMF0082FXZERO"
PKG = "PKG_DMF0082"
SRC = HERE.parents[1] / "_apply_corporate" / "DMF0082_FXZERO_20260930"
FP = f"SELECT COUNT(*) LN, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CH FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND LINE > 1"
OLD_JOIN = "JOIN GT_F020_EXCH B"
OLD_PH2 = "WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)"


def body_lines(path):
    lines = pathlib.Path(path).read_text(encoding="utf-8").split("\n")
    h = next(i for i, l in enumerate(lines) if l.startswith("CREATE OR REPLACE PACKAGE BODY"))
    body = lines[h + 1:]
    while body and body[-1].strip() in ("", "/", f"SHOW ERRORS PACKAGE BODY SCM_MGR.{PKG}"):
        body.pop()
    return body


def fp_of(body):
    return len(body), sum(len(l.rstrip("\r")) for l in body)


def active(lines, stripped):
    return sum(1 for l in lines if l.strip() == stripped)


BEFORE = fp_of(body_lines(SRC / "00_BACKUP_PKG_DMF0082_BODY.sql"))
LOCAL = body_lines(SRC / "01_PKG_DMF0082_BODY_FXZERO.sql")
LOCAL_AFTER = fp_of(LOCAL)
assert active(LOCAL, OLD_JOIN) == 0 and active(LOCAL, OLD_PH2) == 0
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def state():
    cur.execute(f"SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' AND OBJECT_TYPE='PACKAGE BODY'")
    ddl, st = cur.fetchone()
    cur.execute(FP)
    return ddl, st, tuple(cur.fetchone())


s0 = state()
cur.execute(f"SELECT TEXT FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' ORDER BY LINE")
body = "".join(t or "" for (t,) in cur)
cur.execute(f"SELECT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{PKG}' AND REFERENCED_TYPE='PACKAGE' AND NOT (NAME='{PKG}' AND TYPE='PACKAGE BODY') ORDER BY 2,1")
dependents = cur.fetchall()
assert state() == s0, "FRESH-GATE: 추출 도중 변경"
assert s0[1] == "VALID" and body.count(f"--[{TAG}] 원문:") == 10, (s0, body.count(f"--[{TAG}] 원문:"))
AFTER = s0[2]
assert LOCAL_AFTER == AFTER, f"지문 산식 불일치 local={LOCAL_AFTER} db={AFTER}"
assert BEFORE != AFTER
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
A = HERE / "A_DB"
A.mkdir(exist_ok=True)
M1 = f"(SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%--[{TAG}] 원문:%')"
ACT_JOIN = (f"(SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TRIM(BOTH ' ' FROM TRIM(BOTH CHR(9) FROM RTRIM(TEXT, CHR(10)||CHR(13)))) = '{OLD_JOIN}')")
ACT_PH2 = (f"(SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE='PACKAGE BODY' AND TRIM(BOTH ' ' FROM TRIM(BOTH CHR(9) FROM RTRIM(TEXT, CHR(10)||CHR(13)))) = q'[{OLD_PH2}]')")

(A / "00_PRECHECK_CLOUD.sql").write_text(f"""-- 00_PRECHECK_CLOUD.sql — READ-ONLY 선판정 [{TAG}] · 빌드 {now} · 원천 사내 ZIOUI1
--  ⚠ QA · DEV 두 DB 모두 · JUDGE 가 '적용'/'SKIP' 이 아니면 11 을 적용하지 말고 12 수동 반영(README §4)
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A95
PROMPT [E0] 접속 DB
SELECT USER USR, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST FROM DUAL;
PROMPT [H0] {PKG} SPEC/BODY 상태 (SPEC 은 변경 없음 — 둘 다 VALID 여야 정상)
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}' ORDER BY 1;
PROMPT [H] {PKG} BODY 지문 — 전 {BEFORE[0]}/{BEFORE[1]} (= DMF0082_CUSTEXCEL_CLOUD_20260930 적용본) · 후 {AFTER[0]}/{AFTER[1]}
SELECT LN || '/' || CH BODY_FP, {M1} MARK_LINES, {ACT_JOIN} ACTIVE_INNER_JOIN, {ACT_PH2} ACTIVE_OLD_PH2,
       CASE WHEN LN = {AFTER[0]} AND CH = {AFTER[1]} THEN 'SKIP — 이미 적용됨'
            WHEN LN = {BEFORE[0]} AND CH = {BEFORE[1]} THEN '적용 — 05 → 11 → 13 → 90'
            WHEN {M1} = 10 THEN 'SKIP? — 마커 10 전부 존재하나 지문 상이(타 변경 병존). 90 으로 확인'
            ELSE '⚠ 11 적용 금지 — 지문 상이(CUSTEXCEL 누적본 미적용 또는 타 작업자 변경). 12 를 수동 반영 (README §4)' END JUDGE
  FROM ({FP});
PROMPT [H2] 관련 GTT 존재 (저장: GT_PRDM1_T_MAIN · GT_PRDM1_TEMP_EXCH / Excel: GT_F020_UPLOAD_MASTER_FINAL · GT_F020_EXCH)
SELECT TABLE_NAME, TEMPORARY, DURATION FROM USER_TABLES WHERE TABLE_NAME IN ('GT_PRDM1_T_MAIN','GT_PRDM1_TEMP_EXCH','GT_F020_UPLOAD_MASTER_FINAL','GT_F020_EXCH') ORDER BY 1;
""", encoding="utf-8")

(A / "05_BACKUP_CLOUD_SOURCE.sql").write_text(f"""-- 05_BACKUP_CLOUD_SOURCE.sql — 적용 직전 클라우드 SPEC+BODY 원문 보관 (비파괴 · 멱등) [{TAG}]
SET SERVEROUTPUT ON
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='BAK_SRC_DMF0082_FXZERO';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE TABLE BAK_SRC_DMF0082_FXZERO AS
      SELECT NAME, TYPE, LINE, TEXT, SYSDATE AS BAK_DATE FROM USER_SOURCE WHERE NAME='{PKG}' AND TYPE IN ('PACKAGE','PACKAGE BODY')]';
    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP CREATED');
  ELSE
    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP EXISTS - SKIP');
  END IF;
END;
/
SELECT TYPE, COUNT(*) LINES FROM BAK_SRC_DMF0082_FXZERO GROUP BY TYPE;
""", encoding="utf-8")

(A / f"11_{PKG}_BODY.sql").write_text(
    f"-- SOURCE-FRESH: SCM_MGR.{PKG} PACKAGE BODY LAST_DDL={s0[0]} FETCHED={now} DB=ZIOUI1 STATUS=VALID\n"
    f"-- [{TAG}] {PKG} BODY 전체본 (누적: CUSTEXCEL 까지의 09-30 회차 + 본 건) — 환율 없는 기간도 KRW·USD 를 0 으로 함께 생성 (LOC 저장·Batch Price Input·Excel Upload)\n"
    "SET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + body.rstrip() + f"\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.{PKG}\n",
    encoding="utf-8")
shutil.copy(SRC / "_change_preview.sql", A / "12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql")
dep_list = ", ".join(f"('{n}','{t}')" for n, t in dependents)
(A / "13_RECOMPILE_DEPENDENTS.sql").write_text(f"""-- 13_RECOMPILE_DEPENDENTS.sql — {PKG} 의존 INVALID 객체 재컴파일 (멱등 · BODY 만 교체해도 안전망으로 실행) [{TAG}]
--  사내 의존 목록: {dep_list or '(없음)'}
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  v_sql VARCHAR2(400);
BEGIN
  FOR r IN (SELECT D.NAME, D.TYPE FROM USER_DEPENDENCIES D JOIN USER_OBJECTS O ON O.OBJECT_NAME = D.NAME AND O.OBJECT_TYPE = D.TYPE
             WHERE D.REFERENCED_NAME = '{PKG}' AND D.REFERENCED_TYPE = 'PACKAGE' AND O.STATUS <> 'VALID'
             ORDER BY CASE D.TYPE WHEN 'PACKAGE BODY' THEN 1 ELSE 2 END, D.NAME) LOOP
    v_sql := CASE r.TYPE WHEN 'PACKAGE BODY' THEN 'ALTER PACKAGE ' || r.NAME || ' COMPILE BODY'
                         WHEN 'PACKAGE'      THEN 'ALTER PACKAGE ' || r.NAME || ' COMPILE'
                         ELSE 'ALTER ' || r.TYPE || ' ' || r.NAME || ' COMPILE' END;
    BEGIN
      EXECUTE IMMEDIATE v_sql;
      DBMS_OUTPUT.PUT_LINE('OK   ' || v_sql);
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL ' || v_sql || ' : ' || SQLERRM);
    END;
  END LOOP;
END;
/
PROMPT [13-V] {PKG} 의존 객체 상태 (전부 VALID 이어야 함)
SELECT D.NAME, D.TYPE, O.STATUS FROM USER_DEPENDENCIES D JOIN USER_OBJECTS O ON O.OBJECT_NAME = D.NAME AND O.OBJECT_TYPE = D.TYPE
 WHERE D.REFERENCED_NAME = '{PKG}' AND D.REFERENCED_TYPE = 'PACKAGE' ORDER BY 2, 1;
""", encoding="utf-8")

(A / "90_VERIFY.sql").write_text(f"""-- 90_VERIFY.sql — 적용 후 단언 (조회 전용) [{TAG}]
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A40
PROMPT [V1] VALID · 오류 0
SELECT O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       CASE WHEN O.STATUS='VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)=0
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='{PKG}' ORDER BY O.OBJECT_TYPE;
PROMPT [V2] 원문 보존 주석 10 · Excel 환율 INNER JOIN 활성 0 · 구 Phase2 조건 활성 0 (11 적용 시 지문 {AFTER[0]}/{AFTER[1]})
SELECT LN || '/' || CH BODY_FP, {M1} MARK_LINES, {ACT_JOIN} ACTIVE_INNER_JOIN, {ACT_PH2} ACTIVE_OLD_PH2,
       CASE WHEN {M1} = 10 AND {ACT_JOIN} = 0 AND {ACT_PH2} = 0 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM ({FP});
PROMPT [V3] 앱 계정 실행 권한 유지
SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME='{PKG}' ORDER BY GRANTEE;
PROMPT [V4] 의존 객체 INVALID 0
SELECT (SELECT COUNT(*) FROM USER_DEPENDENCIES D JOIN USER_OBJECTS O ON O.OBJECT_NAME=D.NAME AND O.OBJECT_TYPE=D.TYPE
         WHERE D.REFERENCED_NAME='{PKG}' AND D.REFERENCED_TYPE='PACKAGE' AND O.STATUS<>'VALID') INVALID_DEPENDENTS,
       CASE WHEN (SELECT COUNT(*) FROM USER_DEPENDENCIES D JOIN USER_OBJECTS O ON O.OBJECT_NAME=D.NAME AND O.OBJECT_TYPE=D.TYPE
                   WHERE D.REFERENCED_NAME='{PKG}' AND D.REFERENCED_TYPE='PACKAGE' AND O.STATUS<>'VALID') = 0
            THEN 'PASS' ELSE '❌ FAIL — 13 실행' END JUDGE
  FROM DUAL;
""", encoding="utf-8")

(A / "98_ROLLBACK_FROM_CLOUD_BACKUP.sql").write_text(f"""-- 98_ROLLBACK_FROM_CLOUD_BACKUP.sql — 05 보관본으로 SPEC→BODY 복원 (롤백 전용) [{TAG}]
SET SERVEROUTPUT ON
DECLARE
  v CLOB;
BEGIN
  FOR t IN (SELECT 'PACKAGE' TYP FROM DUAL UNION ALL SELECT 'PACKAGE BODY' FROM DUAL) LOOP
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    FOR r IN (SELECT TEXT FROM BAK_SRC_DMF0082_FXZERO WHERE NAME='{PKG}' AND TYPE=t.TYP ORDER BY LINE) LOOP
      DBMS_LOB.APPEND(v, r.TEXT);
    END LOOP;
    IF DBMS_LOB.GETLENGTH(v) > 0 THEN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
      DBMS_OUTPUT.PUT_LINE('REBUILT ' || t.TYP);
    ELSE
      DBMS_OUTPUT.PUT_LINE('SKIP ' || t.TYP || ' (no backup)');
    END IF;
    DBMS_LOB.FREETEMPORARY(v);
  END LOOP;
END;
/
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='{PKG}';
""", encoding="utf-8")
print(f"빌드 완료  원천 LAST_DDL={s0[0]}  지문 BEFORE={BEFORE} AFTER={AFTER}  의존={dependents}")
cn.close()
