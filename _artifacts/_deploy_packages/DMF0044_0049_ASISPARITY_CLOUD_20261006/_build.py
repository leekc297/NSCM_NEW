# -*- coding: utf-8 -*-
"""DMF0044_0049_ASISPARITY_CLOUD_20261006 — 클라우드 이관 패키지 빌더 [E20261006-ASISPARITY].

원천 = 사내 ZIOUI1 PKG_DMF0044 / PKG_DMF0049 BODY 를 지금 새로 읽은 원문 (hook #152). FRESH-GATE: 추출 전후 동일 + 마커 assert.
BEFORE 지문 = 사내 적용 직전 조회본(_apply_corporate/DMF0044_0049_ASISPARITY_20261006/_base_*.txt)에서 동일 산식으로 계산.
사용: python _build.py
"""
import datetime, difflib, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

TAG = "E20261006-ASISPARITY"
SRC = HERE.parents[1] / "_apply_corporate" / "DMF0044_0049_ASISPARITY_20261006"
PKGS = {"PKG_DMF0044": 11, "PKG_DMF0049": 12}          # 패키지 → 마커 줄 수
BAK = {"PKG_DMF0044": "BAK_SRC_DMF0044_ASISPARITY", "PKG_DMF0049": "BAK_SRC_DMF0049_ASISPARITY"}
MSG_NEW = "TEAM정보가 존재하지 않아 저장할 수 없습니다."
MSG_OLD = "DEPT_NAME 정보가 존재하지 않아 저장할 수 없습니다."


def fp_sql(pkg):
    return (f"SELECT COUNT(*) LN, SUM(LENGTH(RTRIM(TEXT, CHR(10)||CHR(13)))) CH FROM USER_SOURCE "
            f"WHERE NAME='{pkg}' AND TYPE='PACKAGE BODY' AND LINE > 1")


def fp_of(src):
    body = src.split("\n")[1:]
    if body and body[-1] == "":
        body.pop()
    return len(body), sum(len(l.rstrip("\r")) for l in body)


def mark_sql(pkg):
    return f"(SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='{pkg}' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%[{TAG}]%')"


u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def state(pkg):
    cur.execute(f"SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='{pkg}' AND OBJECT_TYPE='PACKAGE BODY'")
    ddl, st = cur.fetchone()
    cur.execute(fp_sql(pkg))
    return ddl, st, tuple(cur.fetchone())


now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
A = HERE / "A_DB"
A.mkdir(exist_ok=True)
info = {}
for pkg, marks in PKGS.items():
    s0 = state(pkg)
    cur.execute(f"SELECT TEXT FROM USER_SOURCE WHERE NAME='{pkg}' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    body = "".join(t or "" for (t,) in cur)
    cur.execute(f"SELECT NAME, TYPE FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='{pkg}' AND REFERENCED_TYPE='PACKAGE' AND NOT (NAME='{pkg}' AND TYPE='PACKAGE BODY') ORDER BY 2,1")
    deps = cur.fetchall()
    cur.execute(f"SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME='{pkg}' ORDER BY 1")
    grants = cur.fetchall()
    assert state(pkg) == s0, "FRESH-GATE: 추출 도중 변경 " + pkg
    assert s0[1] == "VALID" and body.count("[" + TAG + "]") == marks, (pkg, s0, body.count("[" + TAG + "]"))
    base = (SRC / f"_base_{pkg}.txt").read_text(encoding="utf-8")
    before, after = fp_of(base), s0[2]
    assert fp_of(body) == after, f"지문 산식 불일치 {pkg} local={fp_of(body)} db={after}"
    assert before != after
    info[pkg] = dict(ddl=s0[0], before=before, after=after, body=body, base=base, deps=deps, grants=grants, marks=marks)
assert info["PKG_DMF0044"]["body"].count(MSG_NEW) == 2 and info["PKG_DMF0044"]["body"].count(MSG_OLD) == 0


def judge(pkg):
    i, m = info[pkg], mark_sql(pkg)
    return f"""PROMPT [H-{pkg[-4:]}] {pkg} BODY 지문 — 전 {i['before'][0]}/{i['before'][1]} · 후 {i['after'][0]}/{i['after'][1]}
SELECT '{pkg}' PKG, LN || '/' || CH BODY_FP, {m} MARK_LINES,
       CASE WHEN LN = {i['after'][0]} AND CH = {i['after'][1]} THEN 'SKIP — 이미 적용됨'
            WHEN LN = {i['before'][0]} AND CH = {i['before'][1]} THEN '적용 — 05 → 1x BODY → 13 → 90'
            WHEN {m} = {i['marks']} THEN 'SKIP? — 변경분은 전부 있으나 지문 상이(타 변경 병존). 90 으로 확인'
            ELSE '⚠ BODY 전체본 적용 금지 — 지문 상이(사내 누적본 미적용 또는 클라우드 전용 변경). 12 를 수동 반영 (README §4)' END JUDGE
  FROM ({fp_sql(pkg)});
"""


(A / "00_PRECHECK_CLOUD.sql").write_text(f"""-- 00_PRECHECK_CLOUD.sql — READ-ONLY 선판정 [{TAG}] · 빌드 {now} · 원천 사내 ZIOUI1
--  ⚠ QA · DEV 두 DB 모두 · 패키지별 JUDGE 가 '적용'/'SKIP' 이 아니면 그 패키지의 BODY 전체본을 적용하지 말고 12 수동 반영(README §4)
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A110
PROMPT [E0] 접속 DB
SELECT USER USR, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST FROM DUAL;
PROMPT [H0] SPEC/BODY 상태 (SPEC 은 변경 없음)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('PKG_DMF0044','PKG_DMF0049') ORDER BY 1, 2;
{judge('PKG_DMF0044')}{judge('PKG_DMF0049')}PROMPT [D1] (참고) 부서명 NULL 행 보유 버전 — 적용 후 이 버전들도 Transfer 가 된다 (리포트에는 부서명 '-')
SELECT DIVISION_ID, VERSION_NO, COUNT(*) DEPARTMENT_NAME_NULL FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DEPARTMENT_NAME IS NULL GROUP BY DIVISION_ID, VERSION_NO ORDER BY 1, 2;
PROMPT [D2] (참고) 팀명 NULL 행 — 있으면 적용 후에도 Transfer 가 'TEAM정보가 …' 로 막힌다 (기존과 동일, 문구만 변경)
SELECT DIVISION_ID, VERSION_NO, COUNT(*) DEPT_NAME_NULL FROM DM_PLN_SALES_ETC_REPORT_C
 WHERE DEPT_NAME IS NULL GROUP BY DIVISION_ID, VERSION_NO ORDER BY 1, 2;
""", encoding="utf-8")

blk = "\n".join(f"""  SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME='{BAK[pkg]}';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[CREATE TABLE {BAK[pkg]} AS
      SELECT NAME, TYPE, LINE, TEXT, SYSDATE AS BAK_DATE FROM USER_SOURCE WHERE NAME='{pkg}' AND TYPE IN ('PACKAGE','PACKAGE BODY')]';
    DBMS_OUTPUT.PUT_LINE('{pkg} SOURCE BACKUP CREATED');
  ELSE
    DBMS_OUTPUT.PUT_LINE('{pkg} SOURCE BACKUP EXISTS - SKIP');
  END IF;""" for pkg in PKGS)
(A / "05_BACKUP_CLOUD_SOURCE.sql").write_text(f"""-- 05_BACKUP_CLOUD_SOURCE.sql — 적용 직전 클라우드 SPEC+BODY 원문 보관 (비파괴 · 멱등) [{TAG}]
SET SERVEROUTPUT ON
DECLARE
  n NUMBER;
BEGIN
{blk}
END;
/
SELECT 'PKG_DMF0044' PKG, TYPE, COUNT(*) LINES FROM {BAK['PKG_DMF0044']} GROUP BY TYPE
UNION ALL SELECT 'PKG_DMF0049', TYPE, COUNT(*) FROM {BAK['PKG_DMF0049']} GROUP BY TYPE;
""", encoding="utf-8")

DESC = {"PKG_DMF0044": "P_DMF0044_MOBILE_REPORT_CREATE — DEPT_NAME 검증 문구 2곳 운영 문구 + DEPARTMENT_NAME 검증 9줄 비활성",
        "PKG_DMF0049": "P_DMF0049_SAVE_SALES_ETC_REPORT_C — 구코드 COMPANY_ID 검증 11줄 비활성"}
for no, pkg in ((11, "PKG_DMF0044"), (12, "PKG_DMF0049")):
    i = info[pkg]
    (A / f"{no if no == 11 else 14}_{pkg}_BODY.sql").write_text(
        f"-- SOURCE-FRESH: SCM_MGR.{pkg} PACKAGE BODY LAST_DDL={i['ddl']} FETCHED={now} DB=ZIOUI1 STATUS=VALID\n"
        f"-- [{TAG}] {pkg} BODY 전체본 (사내 누적본) — {DESC[pkg]}\n"
        "SET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + i["body"].rstrip() + f"\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.{pkg}\n",
        encoding="utf-8")

diff = []
for pkg in PKGS:
    i = info[pkg]
    diff.append(f"-- ===== {pkg} BODY — {DESC[pkg]}")
    diff.append("--   '-' 줄 = 현재(변경 전) 원문 / '+' 줄 = 바꿀 내용 / 공백 시작 줄 = 위치 확인용 앞뒤 원문. @@ 의 줄 번호는 사내 기준.")
    diff += [l.rstrip("\n") for l in difflib.unified_diff(i["base"].split("\n"), i["body"].split("\n"), "변경 전", "변경 후", n=3, lineterm="")]
    diff.append("")
(A / "12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt").write_text(
    f"-- 12_CHANGE_BLOCK_FOR_MANUAL_MERGE — 지문이 다를 때 클라우드 BODY 에 손으로 옮길 변경분 전문 [{TAG}] (실행 파일 아님)\n" + "\n".join(diff) + "\n", encoding="utf-8")

names = ", ".join(f"'{p}'" for p in PKGS)
(A / "13_RECOMPILE_DEPENDENTS.sql").write_text(f"""-- 13_RECOMPILE_DEPENDENTS.sql — 두 패키지 본체·의존 INVALID 객체 재컴파일 (멱등 · 안전망) [{TAG}]
--  사내 의존 목록: PKG_DMF0044 {info['PKG_DMF0044']['deps'] or '(없음)'} / PKG_DMF0049 {info['PKG_DMF0049']['deps'] or '(없음)'}
--  PKG_DMF0049 BODY 는 PKG_DMF0044 를 호출한다 (SPEC 무변경이라 무효화되지 않지만 안전망으로 확인)
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  v_sql VARCHAR2(400);
BEGIN
  FOR r IN (SELECT O.OBJECT_NAME NAME, O.OBJECT_TYPE TYPE FROM USER_OBJECTS O
             WHERE O.STATUS <> 'VALID'
               AND (O.OBJECT_NAME IN ({names})
                    OR EXISTS (SELECT 1 FROM USER_DEPENDENCIES D WHERE D.NAME = O.OBJECT_NAME AND D.TYPE = O.OBJECT_TYPE
                                AND D.REFERENCED_NAME IN ({names}) AND D.REFERENCED_TYPE = 'PACKAGE'))
             ORDER BY CASE O.OBJECT_TYPE WHEN 'PACKAGE' THEN 1 WHEN 'PACKAGE BODY' THEN 2 ELSE 3 END, O.OBJECT_NAME) LOOP
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
PROMPT [13-V] 두 패키지 상태 (전부 VALID 이어야 함)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ({names}) ORDER BY 1, 2;
""", encoding="utf-8")

i44, i49 = info["PKG_DMF0044"], info["PKG_DMF0049"]
(A / "90_VERIFY.sql").write_text(f"""-- 90_VERIFY.sql — 적용 후 단언 (조회 전용) [{TAG}]
SET PAGESIZE 200 LINESIZE 250
COLUMN JUDGE FORMAT A40
PROMPT [V1] VALID · 오류 0
SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       CASE WHEN O.STATUS='VALID' AND (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)=0
            THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME IN ({names}) ORDER BY 1, 2;
PROMPT [V2] PKG_DMF0044 — 마커 11줄 · 운영 문구 2줄 · 실행 코드에 옛 문구 0 · 실행 코드에 DEPARTMENT_NAME INVALID 0 (전체본 적용 시 지문 {i44['after'][0]}/{i44['after'][1]})
SELECT LN || '/' || CH BODY_FP, M MARK_LINES, T TEAM_MSG, O OLD_MSG_LIVE, X DEPARTMENT_CHECK_LIVE,
       CASE WHEN M = 11 AND T = 2 AND O = 0 AND X = 0 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM ({fp_sql('PKG_DMF0044')}),
       (SELECT SUM(CASE WHEN TEXT LIKE '%[{TAG}]%' THEN 1 ELSE 0 END) M,
               SUM(CASE WHEN TEXT LIKE '%''{MSG_NEW}''%' THEN 1 ELSE 0 END) T,
               SUM(CASE WHEN TEXT LIKE '%''{MSG_OLD}''%' AND LTRIM(TEXT) NOT LIKE '--%' THEN 1 ELSE 0 END) O,
               SUM(CASE WHEN TEXT LIKE '%''DEPARTMENT_NAME INVALID''%' AND LTRIM(TEXT) NOT LIKE '--%' THEN 1 ELSE 0 END) X
          FROM USER_SOURCE WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY');
PROMPT [V3] PKG_DMF0049 — 마커 12줄 · 실행 코드에 NERP_CONV_MASTER 0 (전체본 적용 시 지문 {i49['after'][0]}/{i49['after'][1]})
SELECT LN || '/' || CH BODY_FP, M MARK_LINES, X COMPANY_CHECK_LIVE,
       CASE WHEN M = 12 AND X = 0 THEN 'PASS' ELSE '❌ FAIL' END JUDGE
  FROM ({fp_sql('PKG_DMF0049')}),
       (SELECT SUM(CASE WHEN TEXT LIKE '%[{TAG}]%' THEN 1 ELSE 0 END) M,
               SUM(CASE WHEN TEXT LIKE '%NERP_CONV_MASTER%' AND LTRIM(TEXT) NOT LIKE '--%' THEN 1 ELSE 0 END) X
          FROM USER_SOURCE WHERE NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY');
PROMPT [V4] 앱 계정 실행 권한 유지 (사내: PKG_DMF0044 {i44['grants']} / PKG_DMF0049 {i49['grants']})
SELECT TABLE_NAME, GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS WHERE TABLE_NAME IN ({names}) ORDER BY 1, 2;
PROMPT [V5] 의존 객체 INVALID 0
SELECT COUNT(*) INVALID_DEPENDENTS, CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE '❌ FAIL — 13 실행' END JUDGE
  FROM USER_DEPENDENCIES D JOIN USER_OBJECTS O ON O.OBJECT_NAME=D.NAME AND O.OBJECT_TYPE=D.TYPE
 WHERE D.REFERENCED_NAME IN ({names}) AND D.REFERENCED_TYPE='PACKAGE' AND O.STATUS<>'VALID';
""", encoding="utf-8")

rb = "\n".join(f"""  FOR t IN (SELECT 'PACKAGE' TYP FROM DUAL UNION ALL SELECT 'PACKAGE BODY' FROM DUAL) LOOP
    DBMS_LOB.CREATETEMPORARY(v, TRUE);
    FOR r IN (SELECT TEXT FROM {BAK[pkg]} WHERE NAME='{pkg}' AND TYPE=t.TYP ORDER BY LINE) LOOP
      DBMS_LOB.APPEND(v, r.TEXT);
    END LOOP;
    IF DBMS_LOB.GETLENGTH(v) > 0 THEN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
      DBMS_OUTPUT.PUT_LINE('REBUILT {pkg} ' || t.TYP);
    ELSE
      DBMS_OUTPUT.PUT_LINE('SKIP {pkg} ' || t.TYP || ' (no backup)');
    END IF;
    DBMS_LOB.FREETEMPORARY(v);
  END LOOP;""" for pkg in PKGS)
(A / "98_ROLLBACK_FROM_CLOUD_BACKUP.sql").write_text(f"""-- 98_ROLLBACK_FROM_CLOUD_BACKUP.sql — 05 보관본으로 SPEC→BODY 복원 (롤백 전용) [{TAG}]
SET SERVEROUTPUT ON
DECLARE
  v CLOB;
BEGIN
{rb}
END;
/
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ({names}) ORDER BY 1, 2;
""", encoding="utf-8")

for pkg in PKGS:
    i = info[pkg]
    print(f"{pkg} 원천 LAST_DDL={i['ddl']} 지문 BEFORE={i['before']} AFTER={i['after']} 의존={i['deps']} 권한={i['grants']}")
cn.close()
