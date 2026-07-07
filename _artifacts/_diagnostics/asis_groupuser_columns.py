#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS MSSQL SCM_MST_SHEET_COLUMNS — Group User 화면(SHEET_NAME=GroupInfo/UserInfo/Division) 컬럼 추출.
.env.asis 의 ASIS_DB_* 사용 (비번 CLI 노출 없음)."""
import os, sys, pathlib, pyodbc

def load_env():
    root = pathlib.Path(__file__).resolve().parents[2]
    env = root / '.env.asis'; kv = {}
    if env.exists():
        for line in env.read_text(encoding='utf-8', errors='ignore').splitlines():
            if '=' in line and not line.strip().startswith('#'):
                k, v = line.split('=', 1); kv[k.strip()] = v.strip()
    return kv

def connect():
    kv = load_env()
    host=kv.get('ASIS_DB_HOST'); port=kv.get('ASIS_DB_PORT','1433'); db=kv.get('ASIS_DB_NAME')
    user=kv.get('ASIS_DB_USER'); pwd=kv.get('ASIS_DB_PASS'); drv=kv.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')
    cs=(f'DRIVER={{{drv}}};SERVER={host},{port};DATABASE={db};UID={user};PWD={pwd};'
        f'TrustServerCertificate=yes;Encrypt=no;')
    return pyodbc.connect(cs, timeout=20)

def run(cur, sql):
    cur.execute(sql); cols=[c[0] for c in cur.description]; rows=cur.fetchall()
    w=[max(len(str(c)), *(len(str(r[i])) for r in rows)) if rows else len(str(c)) for i,c in enumerate(cols)]
    print(' | '.join(str(c).ljust(w[i]) for i,c in enumerate(cols)))
    print('-+-'.join('-'*x for x in w))
    for r in rows: print(' | '.join(str('' if v is None else v).ljust(w[i]) for i,v in enumerate(r)))
    print(f'({len(rows)} rows)')
    return rows

try:
    cn=connect(); cur=cn.cursor()
    print('### 1) SHEET_NAME GroupInfo/UserInfo/Division 를 쓰는 PROGRAM_ID')
    run(cur, """SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) CNT
                FROM SCM_MST_SHEET_COLUMNS
                WHERE SHEET_NAME IN ('GroupInfo','UserInfo','Division')
                GROUP BY PROGRAM_ID, SHEET_NAME ORDER BY PROGRAM_ID, SHEET_NAME""")
    print()
    print('### 2) Group User 후보 PROGRAM_ID 전체 컬럼 (PROGRAM_ID LIKE Group 또는 SHEET_NAME 일치)')
    run(cur, """SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH,
                       CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, INPUT_TP_CD,
                       HORIZONTAL_ALIGN_CODE, SORT_ORDER_NO, VISIBLE_FLAG, VALID_YN, DIVISION_ID
                FROM SCM_MST_SHEET_COLUMNS
                WHERE SHEET_NAME IN ('GroupInfo','UserInfo','Division')
                   OR UPPER(PROGRAM_ID) LIKE '%GROUPUSER%' OR UPPER(PROGRAM_ID) LIKE '%USERGROUP%'
                ORDER BY PROGRAM_ID, SHEET_NAME, SORT_ORDER_NO""")
except Exception as e:
    print('ERROR:', type(e).__name__, str(e)[:300])
    sys.exit(1)
