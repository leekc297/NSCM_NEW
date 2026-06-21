#!/usr/bin/env python3
"""
_extract_sp_body.py — dev/local 의 DMF0043 SP/PKG body 모두 GET_DDL 추출.
산출물: DMF0043/01_SP_BODY/200_DMF0043_ALL_SP_DDL.sql + PKG body 별도
"""
import os, oracledb
from pathlib import Path

con = oracledb.connect(user=os.environ['NSCM_ORA_USER'], password=os.environ['NSCM_ORA_PASS'], dsn=os.environ['NSCM_ORA_DSN'])
cur = con.cursor()

# DBMS_METADATA 옵션 — quote/segment 끈다
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE); END;")
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE); END;")
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE); END;")

ROOT = Path(__file__).resolve().parent

PROGS = {
    'DMF0043': ['DMF0043_GET_CONTRIBUTE_MAIN_DATA', 'DMF0043_GET_CONTRIBUTE_RATE_POPUP',
                'DMF0043_GET_CONTRIBUTE_YEAR_POPUP', 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',
                'DMF0043_GET_MAIN_SPREAD_TITLE', 'DMF0043_GET_MAIN_VARSION_DATA',
                'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO', 'DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'],
    'DMF0043_01': ['DMF0043_GET_CONTRIBUTION_SALES_LIST', 'DMF0043_GET_SALES_LIST_SPREAD_TITLE'],
    'DMF0072': [],  # 별도 list — 추출 동적
}

# DMF0072 SP list 동적 추출
cur.execute("SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'DMF0072%' AND OBJECT_TYPE='PROCEDURE'")
PROGS['DMF0072'] = [r[0] for r in cur.fetchall()]

for prog, sp_list in PROGS.items():
    base = ROOT / prog / '01_SP_BODY'
    base.mkdir(parents=True, exist_ok=True)
    body_all = [f"-- ============================================================",
                f"-- {prog} — 전 SP body (dev/local DDL extract, 2026-06-22)",
                f"-- 실행 계정: SCM_MGR",
                f"-- 적용: ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL=2; 추천",
                f"-- ============================================================", ""]
    for sp in sp_list:
        try:
            cur.execute("SELECT DBMS_METADATA.GET_DDL('PROCEDURE', :n, USER) FROM dual", {'n': sp})
            row = cur.fetchone()
            ddl = row[0].read() if hasattr(row[0], 'read') else str(row[0])
            body_all.append(f"-- ===== {sp} =====")
            body_all.append(ddl.strip())
            body_all.append('/')
            body_all.append('')
            print(f"  {prog} / {sp}: OK ({len(ddl)} chars)")
        except Exception as e:
            print(f"  {prog} / {sp}: FAIL {e}")
    (base / f'200_{prog}_ALL_SP_DDL.sql').write_text('\n'.join(body_all), encoding='utf-8')

# PKG_DMF0043 spec + body
try:
    cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE', 'PKG_DMF0043', USER) FROM dual")
    spec = cur.fetchone()[0].read()
    cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE_BODY', 'PKG_DMF0043', USER) FROM dual")
    body = cur.fetchone()[0].read()
    pkg_sql = [f"-- ============================================================",
               f"-- PKG_DMF0043 (spec + body) — dev/local DDL extract",
               f"-- 실행 계정: SCM_MGR",
               f"-- ============================================================", "",
               "-- ===== SPEC =====",
               spec.strip(), '/', '',
               "-- ===== BODY =====",
               body.strip(), '/', '']
    (ROOT / 'DMF0043' / '01_SP_BODY' / '210_PKG_DMF0043_FULL.sql').write_text('\n'.join(pkg_sql), encoding='utf-8')
    print(f"  PKG_DMF0043: spec {len(spec)} + body {len(body)} chars")
except Exception as e:
    print(f"  PKG_DMF0043: FAIL {e}")

con.close()
print("\n✅ All SP/PKG body extracted")
