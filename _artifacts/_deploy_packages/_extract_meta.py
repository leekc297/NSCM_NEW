#!/usr/bin/env python3
"""
_extract_meta.py — dev/local DB 에서 3 화면 (DMF0043/0043_01/0072) 의 모든 메타 추출 후
                   클라우드 적용용 INSERT SQL 파일 생성 (멱등 = DELETE 선행 + INSERT).
"""
import os, sys, datetime
from pathlib import Path
import oracledb

con = oracledb.connect(user=os.environ['NSCM_ORA_USER'], password=os.environ['NSCM_ORA_PASS'], dsn=os.environ['NSCM_ORA_DSN'])
cur = con.cursor()

ROOT = Path(__file__).resolve().parent  # _artifacts/_deploy_packages
PROGS = ['DMF0043', 'DMF0043_01', 'DMF0072']

def quote(v):
    if v is None: return 'NULL'
    if isinstance(v, (int, float)): return str(v)
    if isinstance(v, datetime.datetime): return f"TO_DATE('{v.strftime('%Y-%m-%d %H:%M:%S')}','YYYY-MM-DD HH24:MI:SS')"
    if isinstance(v, datetime.date): return f"TO_DATE('{v.strftime('%Y-%m-%d')}','YYYY-MM-DD')"
    s = str(v).replace("'", "''")
    return f"'{s}'"

def fetch_dict(sql, binds):
    cur.execute(sql, binds)
    cols = [c[0] for c in cur.description]
    return cols, cur.fetchall()

def write_insert(file: Path, table: str, where_col: str, where_val: str, sql: str, binds: dict, header: str):
    cols, rows = fetch_dict(sql, binds)
    body = [f"-- ============================================================", f"-- {header}", f"-- 실행 계정: SCM_MGR · 멱등: DELETE 선행 + INSERT", f"-- 행 수: {len(rows)}", f"-- ============================================================", ""]
    body.append(f"DELETE FROM SCM_MGR.{table} WHERE {where_col} = '{where_val}';")
    body.append('')
    if rows:
        col_list = ', '.join(cols)
        for r in rows:
            vals = ', '.join(quote(v) for v in r)
            body.append(f"INSERT INTO SCM_MGR.{table} ({col_list}) VALUES ({vals});")
    body.append('')
    body.append('COMMIT;')
    body.append('')
    file.write_text('\n'.join(body), encoding='utf-8')
    return len(rows)

for prog in PROGS:
    base = ROOT / prog / '03_META'
    base.mkdir(parents=True, exist_ok=True)

    # 100_MNU_M
    n1 = write_insert(base / '100_MNU_M.sql', 'SCM_ADM_MNU_M', 'MNU_ID', prog,
                     "SELECT * FROM SCM_ADM_MNU_M WHERE MNU_ID = :p", {'p': prog},
                     f"{prog} — SCM_ADM_MNU_M (메뉴 등록)")
    # 101_SHEET_COLUMNS
    n2 = write_insert(base / '101_SHEET_COLUMNS.sql', 'SCM_MST_SHEET_COLUMNS', 'PROGRAM_ID', prog,
                     "SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = :p", {'p': prog},
                     f"{prog} — SCM_MST_SHEET_COLUMNS (정적 컬럼 메타)")
    # 102_MNU_BTN_MPG_M
    n3 = write_insert(base / '102_MNU_BTN_MPG_M.sql', 'SCM_ADM_MNU_BTN_MPG_M', 'MNU_ID', prog,
                     "SELECT * FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = :p", {'p': prog},
                     f"{prog} — SCM_ADM_MNU_BTN_MPG_M (버튼-API 매핑)")
    # 103_USER_GR_MNU_BTN_MPG_M
    n4 = write_insert(base / '103_USER_GR_MNU_BTN_MPG_M.sql', 'SCM_ADM_USER_GR_MNU_BTN_MPG_M', 'MNU_ID', prog,
                     "SELECT * FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = :p", {'p': prog},
                     f"{prog} — SCM_ADM_USER_GR_MNU_BTN_MPG_M (사용자 그룹 버튼 권한)")

    # 104_API_M  — BTN_MPG 의 API_ID 로 매칭
    cur.execute("SELECT DISTINCT API_ID FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = :p AND API_ID IS NOT NULL", {'p': prog})
    api_ids = [r[0] for r in cur.fetchall()]
    if api_ids:
        in_clause = ','.join(f":a{i}" for i in range(len(api_ids)))
        binds_api = {f'a{i}': v for i, v in enumerate(api_ids)}
        # API_M 의 PK 확인 — API_ID 가 보통 PK
        sql_api = f"SELECT * FROM SCM_ADM_API_M WHERE API_ID IN ({in_clause})"
        cur.execute(sql_api, binds_api)
        cols_a = [c[0] for c in cur.description]
        rows_a = cur.fetchall()
        body = [f"-- ============================================================",
                f"-- {prog} — SCM_ADM_API_M ({len(rows_a)} APIs — BTN_MPG.API_ID 매칭)",
                f"-- 실행 계정: SCM_MGR · 멱등: DELETE 선행 + INSERT",
                f"-- ============================================================", ""]
        for aid in api_ids:
            body.append(f"DELETE FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID = '{aid}';")
        body.append('')
        col_list_a = ', '.join(cols_a)
        for r in rows_a:
            vals = ', '.join(quote(v) for v in r)
            body.append(f"INSERT INTO SCM_MGR.SCM_ADM_API_M ({col_list_a}) VALUES ({vals});")
        body.extend(['', 'COMMIT;', ''])
        (base / '104_API_M.sql').write_text('\n'.join(body), encoding='utf-8')
        n5 = len(rows_a)
    else:
        (base / '104_API_M.sql').write_text(f"-- {prog} — API_M: BTN_MPG.API_ID 없음. DMF0043 공유.\n", encoding='utf-8')
        n5 = 0

    # 105_PROC_M  — API_M 의 API_URL (= PROC_NM) 로 매칭
    if api_ids:
        cur.execute(f"SELECT DISTINCT API_URL FROM SCM_ADM_API_M WHERE API_ID IN ({in_clause})", binds_api)
        proc_nms = [r[0] for r in cur.fetchall() if r[0]]
        if proc_nms:
            in_p = ','.join(f":p{i}" for i in range(len(proc_nms)))
            binds_p = {f'p{i}': v for i, v in enumerate(proc_nms)}
            cur.execute(f"SELECT * FROM SCM_ADM_PROC_M WHERE PROC_NM IN ({in_p})", binds_p)
            cols_p = [c[0] for c in cur.description]
            rows_p = cur.fetchall()
            body = [f"-- ============================================================",
                    f"-- {prog} — SCM_ADM_PROC_M ({len(rows_p)} 컬럼 메타 — API_URL=PROC_NM 매칭)",
                    f"-- 실행 계정: SCM_MGR · 멱등: DELETE 선행 + INSERT",
                    f"-- ============================================================", ""]
            for nm in proc_nms:
                body.append(f"DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = '{nm}';")
            body.append('')
            col_list_p = ', '.join(cols_p)
            for r in rows_p:
                vals = ', '.join(quote(v) for v in r)
                body.append(f"INSERT INTO SCM_MGR.SCM_ADM_PROC_M ({col_list_p}) VALUES ({vals});")
            body.extend(['', 'COMMIT;', ''])
            (base / '105_PROC_M.sql').write_text('\n'.join(body), encoding='utf-8')
            n6 = len(rows_p)
        else:
            (base / '105_PROC_M.sql').write_text(f"-- {prog} — PROC_M: API_URL 없음.\n", encoding='utf-8')
            n6 = 0
    else:
        (base / '105_PROC_M.sql').write_text(f"-- {prog} — PROC_M: DMF0043 공유.\n", encoding='utf-8')
        n6 = 0

    # GRANT_SCMD_APP — 화면의 SP 객체 GRANT EXECUTE + SYNONYM
    grant_base = ROOT / prog / '04_GRANT_SYNONYM'
    grant_base.mkdir(parents=True, exist_ok=True)
    # API_URL (= SP name) 기반 GRANT
    sp_names = proc_nms if api_ids else []
    body = [f"-- ============================================================",
            f"-- {prog} — GRANT EXECUTE + PUBLIC SYNONYM 일괄 (SCMD_APP 사용계정)",
            f"-- 실행 계정: SCM_MGR · 룰 `feedback_scmd_app_grant_mandatory`",
            f"-- ============================================================", ""]
    for sp in sp_names:
        body.append(f"GRANT EXECUTE ON SCM_MGR.{sp} TO SCMD_APP;")
        body.append(f"CREATE OR REPLACE PUBLIC SYNONYM {sp} FOR SCM_MGR.{sp};")
    body.append('')
    (grant_base / '100_GRANT_SCMD_APP.sql').write_text('\n'.join(body), encoding='utf-8')

    print(f"{prog}: MNU_M={n1} SHEET_COLUMNS={n2} BTN_MPG={n3} USER_GR_BTN={n4} API_M={n5} PROC_M={n6} GRANT={len(sp_names)} SPs")

con.close()
print('\n✅ All 6+1 meta files generated per program')
