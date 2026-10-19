# -*- coding: utf-8 -*-
"""DMF0082_81SALESPLAN_CLOUD_20260930 — 클라우드 이관 패키지 빌더 [E20260930-DMF0082-81SP].

원천 = 사내 ZIOUI1 에서 **지금 새로 읽은** 원문 2객체 (hook #152). FRESH-GATE: 추출 전후 LAST_DDL·지문 동일 + 기대 지문 assert.
  PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE (PROCEDURE) · PKG_DMF0082 (PACKAGE BODY, 누적본 — CLOUDPERF 포함)
사용: python _build.py
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MARK = "E20260930-DMF0082-81SP"
SP = "PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE"
FP = {  # (적용 전, 적용 후) — 줄수(LINE>1)/문자합
    SP: ((769, 53501), (886, 59771)),
    "PKG_DMF0082": ((16177, 830657), (16276, 836956)),   # 전 = 09-30 CLOUDPERF 적용본
}
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def state(name, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [name, typ])
    ddl, st = cur.fetchone()
    cur.execute("SELECT COUNT(*), SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 AND LINE > 1", [name, typ])
    return ddl, st, tuple(cur.fetchone())


def body(name, typ):
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [name, typ])
    return "".join(t or "" for (t,) in cur)


objs = [(SP, "PROCEDURE", "11_SALES_PLAN_SYNC_SP.sql"), ("PKG_DMF0082", "PACKAGE BODY", "12_PKG_DMF0082_BODY.sql")]
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
A = HERE / "A_DB"
A.mkdir(exist_ok=True)
for name, typ, fn in objs:
    s0 = state(name, typ)
    src = body(name, typ)
    assert state(name, typ) == s0, f"FRESH-GATE: {name} 추출 도중 변경"
    assert s0[1] == "VALID" and s0[2] == FP[name][1], (name, s0)
    assert MARK in src
    (A / fn).write_text(
        f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={s0[0]} FETCHED={now} DB=ZIOUI1 STATUS=VALID\n"
        f"-- [{MARK}] {name} 전체본\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src.rstrip()
        + f"\n/\nSHOW ERRORS {typ} SCM_MGR.{name}\n", encoding="utf-8")
    print(f"{fn}: {name} LAST_DDL={s0[0]} 지문 {s0[2]}")


def fp_case(name, typ):
    (b0, b1), (a0, a1) = FP[name]
    return f"""SELECT '{name}' OBJ, LN || '/' || CH FP,
       CASE WHEN LN = {a0} AND CH = {a1} THEN 'SKIP — 이미 적용됨'
            WHEN LN = {b0} AND CH = {b1} THEN '적용'
            ELSE '⚠ 중단 — UNKNOWN 지문 (클라우드 고유 변경 가능)' END JUDGE
  FROM (SELECT COUNT(*) LN, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CH FROM USER_SOURCE
         WHERE NAME = '{name}' AND TYPE = '{typ}' AND LINE > 1)"""


(A / "00_PRECHECK_CLOUD.sql").write_text(f"""-- 00_PRECHECK_CLOUD.sql — READ-ONLY 선판정 [{MARK}] · 빌드 {now} · 원천 사내 ZIOUI1
--  ⚠ QA · DEV 두 DB 모두 · 두 JUDGE 가 모두 '적용'(또는 'SKIP') 이어야 진행
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A60
PROMPT [E0] 접속 DB
SELECT USER USR, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST FROM DUAL;
PROMPT [H] 지문 — 공용 SP 전 {FP[SP][0][0]}/{FP[SP][0][1]} · PKG BODY 전 {FP['PKG_DMF0082'][0][0]}/{FP['PKG_DMF0082'][0][1]} (= DMF0082_CLOUDPERF_CLOUD_20260930 적용본)
{fp_case(SP, 'PROCEDURE')}
UNION ALL
{fp_case('PKG_DMF0082', 'PACKAGE BODY')};
PROMPT --  PKG BODY 가 UNKNOWN 이면 DMF0082_CLOUDPERF_CLOUD_20260930 선적용 여부부터 확인
PROMPT [D] 의존 객체 존재 (6행 VALID 기대)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE','GT_PRDM_SEND_TARGET_DATA','GT_PRDM_RESULTS',
                       'GT_PRMF_T2_MKT_FCST','GT_PRMF_T2_PRICE','DM_MST_ITEM_SINGLE_V')
 ORDER BY 1;
""", encoding="utf-8")

(A / "05_BACKUP_CLOUD_SOURCE.sql").write_text(f"""-- 05_BACKUP_CLOUD_SOURCE.sql — 적용 직전 클라우드 원문 2객체 보관 (비파괴 · 멱등) [{MARK}]
SET SERVEROUTPUT ON
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='BAK_SRC_DMF0082_81SP';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE TABLE BAK_SRC_DMF0082_81SP AS
      SELECT NAME, TYPE, LINE, TEXT, SYSDATE AS BAK_DATE FROM USER_SOURCE
       WHERE (NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY') OR (NAME='{SP}' AND TYPE='PROCEDURE')]';
    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP CREATED');
  ELSE
    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP EXISTS - SKIP');
  END IF;
END;
/
SELECT NAME, TYPE, COUNT(*) LINES FROM BAK_SRC_DMF0082_81SP GROUP BY NAME, TYPE;
""", encoding="utf-8")

(A / "90_VERIFY.sql").write_text(f"""-- 90_VERIFY.sql — 적용 후 단언 (조회 전용) [{MARK}]
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A40
PROMPT [V1] VALID · 오류 0 (2행 PASS)
SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       CASE WHEN O.STATUS='VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)=0
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_OBJECTS O
 WHERE (O.OBJECT_NAME='PKG_DMF0082' AND O.OBJECT_TYPE='PACKAGE BODY') OR (O.OBJECT_NAME='{SP}' AND O.OBJECT_TYPE='PROCEDURE');
PROMPT [V2] 지문 = 사내 적용본 (2행 SKIP — 이미 적용됨 = PASS)
{fp_case(SP, 'PROCEDURE')}
UNION ALL
{fp_case('PKG_DMF0082', 'PACKAGE BODY')};
PROMPT [V3] 참조 객체 INVALID 0 (0행 = PASS)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
 WHERE STATUS <> 'VALID' AND OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME IN ('{SP}','PKG_DMF0082'));
""", encoding="utf-8")

(A / "98_ROLLBACK_FROM_CLOUD_BACKUP.sql").write_text(f"""-- 98_ROLLBACK_FROM_CLOUD_BACKUP.sql — 05 보관본으로 2객체 복원 (롤백 전용) [{MARK}]
SET SERVEROUTPUT ON
DECLARE
  PROCEDURE rebuild(p_name VARCHAR2, p_type VARCHAR2) IS
    v CLOB;
  BEGIN
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    FOR r IN (SELECT TEXT FROM BAK_SRC_DMF0082_81SP WHERE NAME = p_name AND TYPE = p_type ORDER BY LINE) LOOP
      DBMS_LOB.APPEND(v, r.TEXT);
    END LOOP;
    IF DBMS_LOB.GETLENGTH(v) > 0 THEN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
      DBMS_OUTPUT.PUT_LINE('REBUILT ' || p_name);
    ELSE
      DBMS_OUTPUT.PUT_LINE('SKIP (no backup) ' || p_name);
    END IF;
  END;
BEGIN
  rebuild('{SP}', 'PROCEDURE');
  rebuild('PKG_DMF0082', 'PACKAGE BODY');
END;
/
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ('PKG_DMF0082','{SP}');
""", encoding="utf-8")
print("빌드 완료")
cn.close()
