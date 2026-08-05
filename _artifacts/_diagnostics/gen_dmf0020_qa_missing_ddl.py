#!/usr/bin/env python3
"""
gen_dmf0020_qa_missing_ddl.py — DMF0020 SP 의존 생성물 DDL 자급 스크립트 생성기 (읽기 전용)

클라우드 QA 컴파일 실패(ORA-00942) 원인 = 세션 생성물 미존재.
사내 DB(DBMS_METADATA)에서 GTT/TYPE/VIEW/FUNCTION DDL 을 추출해
QA(및 DEV 재검증)용 단일 sqlplus 스크립트를 생성한다. DB 는 변경하지 않는다.
"""
import sys, pathlib

sys.stdout.reconfigure(encoding="utf-8")
ROOT = pathlib.Path(__file__).resolve().parents[2]
env = {}
for line in (ROOT / ".env.asis").read_text().splitlines():
    if "=" in line and not line.strip().startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip()

import oracledb
oc = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                      dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
c = oc.cursor()
c.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',FALSE); "
          "DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',FALSE); END;")

GTT = ["GT_DMF0020_DATA","GT_DMF0020_ITEM","GT_DMF0020_OUTPUT","GT_DMF0020_OVER_RANGE",
       "GT_DMF0020_OVER_RANGE_LIST","GT_DMF0020_PLAN_DATA","GT_DMF0020_SALES_SITE_MODEL",
       "GT_DMF0020_SALES_SITE_MODEL_ALL",
       "GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V","GT_FTPR_DM_PLN_SALES_PLAN","GT_FTPR_SCM_MST_FUTURE_PRICE",
       "GT_FTPR_SCM_MST_FUTURE_PRICE_OVER","GT_FTPR_TMPDATA","GT_FTPR_TMPITEM","GT_FTPR_TMPOUTPUT",
       "GT_FTPR_TMPOUTPUTALL","GT_FTPR_TMPOUTPUTOMISSION","GT_FTPR_TMPOVERRANGE",
       "GT_FTPR_TMPOVERRANGELIST","GT_FTPR_TMPPLANDATA","GT_FTPR_TMPSALESSITEMODEL",
       "GT_FTPR_TMPSALESSITEMODELALL"]
REPLACEABLE = [("TYPE","T_STR_TAB"), ("VIEW","DM_MST_ITEM_SINGLE_V"),
               ("FUNCTION","FN_STRING_SPLIT"), ("FUNCTION","FN_GET_DEPT_LIST"),
               ("FUNCTION","FN_GET_MULTI_OWNER_NAME")]

def ddl(otype, name):
    c.execute("SELECT DBMS_METADATA.GET_DDL(:1,:2,'SCM_MGR') FROM DUAL", [otype, name])
    r = c.fetchone()[0]
    return (r.read() if hasattr(r, "read") else str(r)).strip()

def idx_ddls(tab):
    c.execute("SELECT INDEX_NAME FROM ALL_INDEXES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:1 AND INDEX_NAME NOT LIKE 'SYS%'", [tab])
    out = []
    for (ix,) in c.fetchall():
        out.append(ddl("INDEX", ix))
    return out

parts = []
parts.append("""-- =============================================================================
-- DMF0020_CLOUD_QA_MISSING_OBJECTS_20260805.sql — QA 컴파일 실패(ORA-00942) 해소: 의존 생성물 자급
-- 원인: DMF0020 SP 2본이 참조하는 세션 생성물(GTT 21종·TYPE·VIEW·FUNCTION 3종)이 QA 미생성(DEV만 존재)
-- 정책: 이관패키지 GTT/TYPE DDL 자급 의무(기존재 가정 금지) — DDL 은 사내 DB 실물 추출본
--   GTT/INDEX = 기존재 시 ORA-00955 발생하나 무시하고 계속(신규 생성만 목적)
--   TYPE/VIEW/FUNCTION = CREATE OR REPLACE(멱등)
-- 실행: QA 에서 1회 (DEV 도 재실행 무해). 실행 후 하단 재컴파일+검증까지 자동 수행.
--   export NLS_LANG=KOREAN_KOREA.AL32UTF8
--   sqlplus SCM_MGR/<암호>@//<QA호스트>:1521/OCGSCMD_P01
--   SQL> @DMF0020_CLOUD_QA_MISSING_OBJECTS_20260805.sql
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET LINESIZE 200
SET PAGESIZE 200

PROMPT ===== [0] 접속 DB 확인 =====
SELECT USER, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') SERVER_HOST FROM DUAL;

PROMPT ===== [0-1] 사전 진단: 누락 오브젝트 목록 (실행 전 상태 기록용) =====
SELECT COLUMN_VALUE AS MISSING_OBJECT FROM TABLE(SYS.ODCIVARCHAR2LIST(
""" + ",".join(f"'{t}'" for t in GTT + [n for _, n in REPLACEABLE]) + """
)) L WHERE NOT EXISTS (SELECT 1 FROM USER_OBJECTS O WHERE O.OBJECT_NAME = L.COLUMN_VALUE);
""")

parts.append("PROMPT ===== [1] TYPE / FUNCTION / VIEW (CREATE OR REPLACE — 멱등) =====")
for otype, name in REPLACEABLE:
    d = ddl(otype, name)
    if not d.upper().startswith("CREATE OR REPLACE"):
        d = "CREATE OR REPLACE " + d.split(" ", 1)[1] if d.upper().startswith("CREATE ") else d
    parts.append(f"PROMPT -- {otype} {name}")
    parts.append(d + ("\n/" if otype in ("TYPE", "FUNCTION") else ";"))

parts.append("\nPROMPT ===== [2] GTT 21종 (기존재 시 ORA-00955 무시) =====")
for t in GTT:
    parts.append(f"PROMPT -- GTT {t}")
    parts.append(ddl("TABLE", t) + ";")
    for ix in idx_ddls(t):
        parts.append(ix + ";")

parts.append("""
PROMPT ===== [3] SP 2본 재컴파일 =====
ALTER PROCEDURE DMF0020_GET_SCM_MST_FUTURE_PRICE COMPILE;
ALTER PROCEDURE DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP COMPILE;

PROMPT ===== [4] 검증 1: 누락 잔존 0 이어야 함 =====
SELECT COLUMN_VALUE AS STILL_MISSING FROM TABLE(SYS.ODCIVARCHAR2LIST(
""" + ",".join(f"'{t}'" for t in GTT + [n for _, n in REPLACEABLE]) + """
)) L WHERE NOT EXISTS (SELECT 1 FROM USER_OBJECTS O WHERE O.OBJECT_NAME = L.COLUMN_VALUE);

PROMPT ===== [4] 검증 2: SP STATUS = VALID 2건 이어야 함 =====
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS
WHERE OBJECT_NAME IN ('DMF0020_GET_SCM_MST_FUTURE_PRICE','DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP')
  AND OBJECT_TYPE='PROCEDURE';

PROMPT ===== [4] 검증 3: 컴파일 오류 잔존 시 상세 =====
SELECT NAME, LINE, POSITION, TEXT FROM USER_ERRORS
WHERE NAME IN ('DMF0020_GET_SCM_MST_FUTURE_PRICE','DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP')
ORDER BY NAME, SEQUENCE;

PROMPT ===== 완료 — 검증1 무행 + 검증2 VALID 2건 + 검증3 무행이면 정상 =====
""")

out = ROOT / "_artifacts" / "_apply_corporate" / "DMF0020_CLOUD_QA_MISSING_OBJECTS_20260805.sql"
out.write_text("\n".join(parts), encoding="utf-8")
print(f"생성: {out.name} ({sum(len(p.splitlines()) for p in parts)}줄, GTT {len(GTT)} + REPLACE {len(REPLACEABLE)})")
oc.close()
