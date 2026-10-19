# -*- coding: utf-8 -*-
"""DMF0082_ONEREAD_CLOUD_20260930 — 클라우드 이관 패키지 빌더 [E20260930-DMF0082ONEREAD].

원천 = 사내 ZIOUI1 PKG_DMF0082 BODY 를 지금 새로 읽은 원문 (hook #152). FRESH-GATE: 추출 전후 동일 + 마커·힌트 assert.
전제 = 클라우드 BODY 가 DMF0082_81SALESPLAN_CLOUD_20260930 적용본(16276/836956) + 공용 SP 81SP 적용본(886/59771).
사용: python _build.py
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

TAG = "E20260930-DMF0082ONEREAD"
BEFORE = (16276, 836956)            # 81SALESPLAN 적용본 (사내 12:07:37)
BEFORE_AJS = (16293, 837608)        # + 타 작업자(AJS) 15:46 TB_FX_USER→SCM_ADM_USER_M 수정본 (사내 기준본)
SP_NAME, SP_FP = "PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE", (886, 59771)
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()
FP = ("SELECT COUNT(*) LN, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CH FROM USER_SOURCE "
      "WHERE NAME='{n}' AND TYPE='{t}' AND LINE > 1")


def state():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    ddl, st = cur.fetchone()
    cur.execute(FP.format(n="PKG_DMF0082", t="PACKAGE BODY"))
    return ddl, st, tuple(cur.fetchone())


s0 = state()
cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
body = "".join(t or "" for (t,) in cur)
assert state() == s0, "FRESH-GATE: 추출 도중 변경"
active_idx02 = [ln for ln in body.splitlines() if "IDX02_SCM_MST_FUTURE_PRICE" in ln and not ln.lstrip().startswith("--")]
assert s0[1] == "VALID" and body.count(TAG) >= 3 and not active_idx02, (s0, body.count(TAG), active_idx02)
AFTER = s0[2]
cur.execute(FP.format(n=SP_NAME, t="PROCEDURE"))
assert tuple(cur.fetchone()) == SP_FP, "사내 공용 SP 지문 변동"
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
A = HERE / "A_DB"
A.mkdir(exist_ok=True)

(A / "00_PRECHECK_CLOUD.sql").write_text(f"""-- 00_PRECHECK_CLOUD.sql — READ-ONLY 선판정 [{TAG}] · 빌드 {now} · 원천 사내 ZIOUI1
--  ⚠ QA · DEV 두 DB 모두 · 두 JUDGE 가 '적용'(또는 'SKIP') 이 아니면 중단하고 결과 회신
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A80
PROMPT [E0] 접속 DB
SELECT USER USR, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST FROM DUAL;
PROMPT [H] 지문 — PKG BODY 전 {BEFORE[0]}/{BEFORE[1]} (= DMF0082_81SALESPLAN_CLOUD_20260930 적용본) · 후 {AFTER[0]}/{AFTER[1]} / 공용 SP {SP_FP[0]}/{SP_FP[1]} (81SP 적용본)
SELECT 'PKG_DMF0082 BODY' OBJ, LN || '/' || CH FP,
       CASE WHEN LN = {AFTER[0]} AND CH = {AFTER[1]} THEN 'SKIP — 이미 적용됨'
            WHEN LN = {BEFORE_AJS[0]} AND CH = {BEFORE_AJS[1]} THEN '적용 — 05 → 11 → 90 (AJS 09-30 사용자테이블 수정 적용된 상태)'
            WHEN LN = {BEFORE[0]} AND CH = {BEFORE[1]} THEN '적용 — 05 → 11 → 90 (AJS 09-30 수정도 함께 반영됨 — [U] 3행 확인)'
            WHEN LN = 16177 AND CH = 830657 THEN '⚠ 중단 — 81SALESPLAN 미적용(CLOUDPERF 상태): DMF0082_81SALESPLAN_CLOUD_20260930 먼저'
            WHEN LN = 16176 AND CH = 830176 THEN '⚠ 중단 — CLOUDPERF·81SALESPLAN 미적용(QRYPERF 상태): 두 패키지 먼저'
            ELSE '⚠ 중단 — UNKNOWN 지문 (클라우드 고유 변경 가능 — 결과 회신)' END JUDGE
  FROM ({FP.format(n="PKG_DMF0082", t="PACKAGE BODY")})
UNION ALL
SELECT '{SP_NAME}' OBJ, LN || '/' || CH FP,
       CASE WHEN LN = {SP_FP[0]} AND CH = {SP_FP[1]} THEN 'PASS (81SP 적용본)'
            ELSE '⚠ 중단 — 공용 SP 가 81SP 적용본 아님: DMF0082_81SALESPLAN_CLOUD_20260930 먼저' END JUDGE
  FROM ({FP.format(n=SP_NAME, t="PROCEDURE")});
PROMPT [U] 본문에 포함된 AJS 09-30 수정(TB_FX_USER → SCM_ADM_USER_M)의 참조 컬럼 — 3행 기대 (USER_ID · TMZ_CD · DEPT_ID)
SELECT COLUMN_NAME, CASE WHEN COUNT(*) OVER () = 3 THEN 'PASS' ELSE '⚠ 중단 — 컬럼 부재: 결과 회신' END JUDGE
  FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'SCM_ADM_USER_M' AND COLUMN_NAME IN ('USER_ID','TMZ_CD','DEPT_ID');
""", encoding="utf-8")

(A / "05_BACKUP_CLOUD_SOURCE.sql").write_text(f"""-- 05_BACKUP_CLOUD_SOURCE.sql — 적용 직전 클라우드 BODY 원문 보관 (비파괴 · 멱등) [{TAG}]
SET SERVEROUTPUT ON
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='BAK_SRC_DMF0082_ONEREAD';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE TABLE BAK_SRC_DMF0082_ONEREAD AS
      SELECT NAME, TYPE, LINE, TEXT, SYSDATE AS BAK_DATE FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY']';
    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP CREATED');
  ELSE
    DBMS_OUTPUT.PUT_LINE('SOURCE BACKUP EXISTS - SKIP');
  END IF;
END;
/
SELECT TYPE, COUNT(*) LINES FROM BAK_SRC_DMF0082_ONEREAD GROUP BY TYPE;
""", encoding="utf-8")

(A / "11_PKG_DMF0082_BODY.sql").write_text(
    f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={s0[0]} FETCHED={now} DB=ZIOUI1 STATUS=VALID\n"
    f"-- [{TAG}] PKG_DMF0082 BODY 전체본 — 81SALESPLAN 적용본 + AJS 09-30 사용자테이블 수정 + 81/82 판가 원장 1회 읽기 통합 · IDX02 힌트 2곳 철회\n"
    "SET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + body.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0082\n",
    encoding="utf-8")

(A / "90_VERIFY.sql").write_text(f"""-- 90_VERIFY.sql — 적용 후 단언 (조회 전용) [{TAG}]
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A40
PROMPT [V1] VALID · 오류 0
SELECT O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       CASE WHEN O.STATUS='VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)=0
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0082' ORDER BY O.OBJECT_TYPE;
PROMPT [V2] 지문 {AFTER[0]}/{AFTER[1]} · 마커 ONEREAD {body.count(TAG)} · 활성 IDX02 힌트 0
SELECT LN || '/' || CH BODY_FP,
       (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%{TAG}%') MARK,
       (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
         AND TEXT LIKE '%IDX02_SCM_MST_FUTURE_PRICE%' AND LTRIM(TEXT) NOT LIKE '--%') ACTIVE_IDX02,
       CASE WHEN LN = {AFTER[0]} AND CH = {AFTER[1]} THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM ({FP.format(n="PKG_DMF0082", t="PACKAGE BODY")});
PROMPT [V3] 앱 계정 실행 권한 유지
SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME='PKG_DMF0082' ORDER BY GRANTEE;
PROMPT [V4] 타임아웃 문장(3d2xnx839ksnt) 커서 — 적용 후 새 조회에서 실행 증가 없음이 정상 (문장 제거)
SELECT SQL_ID, CHILD_NUMBER, EXECUTIONS, TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') LAST_ACT FROM V$SQL WHERE SQL_ID='3d2xnx839ksnt';
""", encoding="utf-8")

(A / "98_ROLLBACK_FROM_CLOUD_BACKUP.sql").write_text(f"""-- 98_ROLLBACK_FROM_CLOUD_BACKUP.sql — 05 보관본으로 BODY 복원 (롤백 전용 · 평소 실행 안 함) [{TAG}]
SET SERVEROUTPUT ON
DECLARE
  v CLOB;
BEGIN
  DBMS_LOB.CREATETEMPORARY(v, TRUE);
  FOR r IN (SELECT TEXT FROM BAK_SRC_DMF0082_ONEREAD WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE) LOOP
    DBMS_LOB.APPEND(v, r.TEXT);
  END LOOP;
  IF DBMS_LOB.GETLENGTH(v) > 0 THEN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
    DBMS_OUTPUT.PUT_LINE('REBUILT PACKAGE BODY');
  ELSE
    DBMS_OUTPUT.PUT_LINE('SKIP (no backup)');
  END IF;
END;
/
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082';
""", encoding="utf-8")
print(f"빌드 완료  원천 LAST_DDL={s0[0]}  지문 {AFTER}  마커 {body.count(TAG)}")
cn.close()
