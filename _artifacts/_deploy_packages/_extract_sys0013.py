#!/usr/bin/env python3
"""
_extract_sys0013.py — dev/local 의 SYS0013 모든 객체 DDL 추출 후 이관 파일 생성.
산출물:
  SYS0013/04_PKG_SP/100_PKG_SYS0013_FULL.sql       (spec + body)
  SYS0013/04_PKG_SP/200_SYS0013_ALL_SP.sql         (11 standalone procedures)
  SYS0013/04_PKG_SP/300_PR_DM_ADM_DQ_ALL.sql       (6 hist/create procedures)
  SYS0013/04_PKG_SP/400_FN_DQ_FUNCTIONS.sql        (4 functions)
  SYS0013/04_PKG_SP/500_DQ_TYPES.sql               (4 types)
  SYS0013/04_GRANT_SYNONYM/100_GRANT_SCMD_APP.sql  (전 객체 GRANT + SYNONYM)
"""
import os, oracledb
from pathlib import Path

con = oracledb.connect(user=os.environ['NSCM_ORA_USER'], password=os.environ['NSCM_ORA_PASS'], dsn=os.environ['NSCM_ORA_DSN'])
cur = con.cursor()
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE); END;")
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE); END;")
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', FALSE); END;")

ROOT = Path(__file__).resolve().parent
BASE = ROOT / 'SYS0013'
PKG_SP = BASE / '04_PKG_SP'
PKG_SP.mkdir(parents=True, exist_ok=True)
GRANT = BASE / '04_GRANT_SYNONYM'
GRANT.mkdir(parents=True, exist_ok=True)

def get_ddl(otype: str, name: str) -> str:
    cur.execute("SELECT DBMS_METADATA.GET_DDL(:t, :n, USER) FROM dual", {'t': otype, 'n': name})
    row = cur.fetchone()
    return row[0].read() if hasattr(row[0], 'read') else str(row[0])

def write_block(file: Path, header: str, items: list, otype: str):
    body = [f"-- ============================================================",
            f"-- {header}",
            f"-- 실행 계정: SCM_MGR · dev/local DDL extract 2026-06-22",
            f"-- ============================================================", ""]
    for name in items:
        try:
            ddl = get_ddl(otype, name)
            body.append(f"-- ===== {name} =====")
            body.append(ddl.strip())
            body.append('/')
            body.append('')
            print(f"  {name}: OK ({len(ddl)} chars)")
        except Exception as e:
            print(f"  {name}: FAIL {e}")
    file.write_text('\n'.join(body), encoding='utf-8')

# 1) PKG_SYS0013 (spec + body)
pkg_body = [f"-- ============================================================",
            f"-- PKG_SYS0013 (spec + body) — SYS0013 화면 main entry API",
            f"-- 실행 계정: SCM_MGR · 8 API_URL 중 7개 통과",
            f"-- ============================================================", "",
            "-- ===== SPEC =====",
            get_ddl('PACKAGE', 'PKG_SYS0013').strip(), '/', '',
            "-- ===== BODY =====",
            get_ddl('PACKAGE_BODY', 'PKG_SYS0013').strip(), '/', '']
(PKG_SP / '100_PKG_SYS0013_FULL.sql').write_text('\n'.join(pkg_body), encoding='utf-8')
print(f"PKG_SYS0013 spec+body: {sum(len(s) for s in pkg_body):>8d} chars")

# 2) 11 standalone SYS0013_* procedures
sys_sps = ['SYS0013_DELETE_USER_GROUP', 'SYS0013_EXECUTE_HIST', 'SYS0013_EXECUTE_QUERY',
           'SYS0013_GET_COLUMNS', 'SYS0013_GET_DYNAMIC_QUERYS', 'SYS0013_GET_HISTORY',
           'SYS0013_GET_PARAMETERS', 'SYS0013_GET_QUERY_LIST', 'SYS0013_GET_QUERY_LIST_COMMON',
           'SYS0013_GET_ROLE_DATA', 'SYS0013_SAVE_COLUMNS', 'SYS0013_SAVE_PARAMETERS',
           'SYS0013_SAVE_QUERY', 'SYS0013_SAVE_USER_GROUP']
write_block(PKG_SP / '200_SYS0013_ALL_SP.sql',
            'SYS0013_* standalone procedures (14)', sys_sps, 'PROCEDURE')

# 3) PR_DM_ADM_DQ_* procedures — INVALID 4개 제외 (CREATE / CREATE_COLUMN / CREATE_PARAMETER / CREATE_USER_GROUP)
#    INVALID = SQL Server 변환 미완성 잔존. dev/local 에서도 컴파일 fail. PKG_SYS0013 종속 없음 (미사용).
pr_dq = ['PR_DM_ADM_DQ_CREATE_COLUMN_HIST',
         'PR_DM_ADM_DQ_CREATE_HIST', 'PR_DM_ADM_DQ_CREATE_PARAMETER_HIST',
         'PR_DM_ADM_DQ_CREATE_USER_GROUP_DELETE',
         'PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST', 'PR_DM_ADM_DQ_EXECUTE_HIST']
write_block(PKG_SP / '300_PR_DM_ADM_DQ_ALL.sql',
            'PR_DM_ADM_DQ_* procedures (VALID only, 6) — INVALID 4개 제외 (SQL Server 잔존)', pr_dq, 'PROCEDURE')

# 4) FN_DQ_* functions — INVALID 1개 제외 (FN_DQ_FP_PLAN: RETURNS TABLE SQL Server syntax)
fn_dq = ['FN_DQ_MKT_FCST_81', 'FN_DQ_PROD_PLAN', 'FN_DQ_STOCK']
write_block(PKG_SP / '400_FN_DQ_FUNCTIONS.sql',
            'FN_DQ_* table functions (VALID only, 3) — FN_DQ_FP_PLAN 제외 (RETURNS TABLE 잔존)', fn_dq, 'FUNCTION')

# 5) 4 TYPE objects (TYPE → 'TYPE_SPEC' for spec only — table function row/tab)
types = ['FN_DQ_PROD_PLAN_ROW', 'FN_DQ_PROD_PLAN_TAB', 'FN_DQ_STOCK_ROW', 'FN_DQ_STOCK_TAB',
         'T_DQ_STOCK_ROW', 'T_DQ_STOCK_TAB', 'T_FN_DQ_MKT_FCST_81_ROW', 'T_FN_DQ_MKT_FCST_81_TAB']
type_body = [f"-- ============================================================",
             f"-- SYS0013 — TYPE objects (FN_DQ_* + T_DQ_* / table function row/tab)",
             f"-- 실행 계정: SCM_MGR",
             f"-- ============================================================", ""]
for name in types:
    try:
        ddl = get_ddl('TYPE', name)
        type_body.append(f"-- ===== {name} =====")
        type_body.append(ddl.strip())
        type_body.append('/')
        type_body.append('')
        print(f"  TYPE {name}: OK")
    except Exception as e:
        print(f"  TYPE {name}: FAIL {e}")
(PKG_SP / '500_DQ_TYPES.sql').write_text('\n'.join(type_body), encoding='utf-8')

# 6) GRANT + SYNONYM 일괄 (VALID only)
seqs = ['SEQ1_SCM_ADM_DQ_COLUMN_H', 'SEQ1_SCM_ADM_DQ_EXECUTE_H', 'SEQ1_SCM_ADM_DQ_LIST_H',
        'SEQ1_SCM_ADM_DQ_PARAMETER_H', 'SEQ1_SCM_ADM_DQ_USER_GROUP_H']
gr = [f"-- ============================================================",
      f"-- SYS0013 — GRANT EXECUTE/SELECT/INSERT/UPDATE/DELETE + PUBLIC SYNONYM",
      f"-- 실행 계정: SCM_MGR · SCMD_APP 사용계정 권한",
      f"-- ============================================================", ""]
# PKG / SP / FUNC / TYPE → EXECUTE
exec_objs = ['PKG_SYS0013'] + sys_sps + pr_dq + fn_dq + types
for o in exec_objs:
    gr.append(f"GRANT EXECUTE ON SCM_MGR.{o} TO SCMD_APP;")
    gr.append(f"CREATE OR REPLACE PUBLIC SYNONYM {o} FOR SCM_MGR.{o};")
gr.append('')
# Tables → SELECT/INSERT/UPDATE/DELETE
tables = ['SCM_ADM_DQ_COLUMN', 'SCM_ADM_DQ_COLUMN_H', 'SCM_ADM_DQ_EXECUTE_H', 'SCM_ADM_DQ_EXECUTE_PARAMETER_H',
          'SCM_ADM_DQ_LIST', 'SCM_ADM_DQ_LIST_H', 'SCM_ADM_DQ_PARAMETER', 'SCM_ADM_DQ_PARAMETER_H',
          'SCM_ADM_DQ_USER_GROUP', 'SCM_ADM_DQ_USER_GROUP_H']
for o in tables:
    gr.append(f"GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.{o} TO SCMD_APP;")
    gr.append(f"CREATE OR REPLACE PUBLIC SYNONYM {o} FOR SCM_MGR.{o};")
gr.append('')
# Sequences → SELECT
for o in seqs:
    gr.append(f"GRANT SELECT ON SCM_MGR.{o} TO SCMD_APP;")
    gr.append(f"CREATE OR REPLACE PUBLIC SYNONYM {o} FOR SCM_MGR.{o};")
gr.append('')
(GRANT / '100_GRANT_SCMD_APP.sql').write_text('\n'.join(gr), encoding='utf-8')

con.close()
print(f"\n✅ SYS0013 PKG/SP/FUNC/TYPE/GRANT all extracted")
print(f"   Files: 5 (PKG / 14 SP / 10 PR_DQ / 4 FN / 8 TYPE) + GRANT (37 EXECUTE + 10 TABLE + 5 SEQ)")
