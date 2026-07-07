#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS MSSQL — UP_FX_GetUserGroupAuthExtentionList @AuthType='J' 로직으로 DIVISION + JV_PLANT 추출.
.env.asis 의 ASIS_DB_* 사용."""
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
    print('### 1) TB_FX_UserGroupAuthExtention AuthType 분포 + JV_PLANT_ID 보유')
    run(cur, """SELECT AuthType, COUNT(*) CNT, COUNT(JV_PLANT_ID) JV_NONNULL
                FROM TB_FX_UserGroupAuthExtention GROUP BY AuthType ORDER BY AuthType""")
    print()
    print('### 2) AuthType=J 원천 row 샘플 (GroupID/UserID/Code(DIVISION)/JV_PLANT_ID)')
    run(cur, """SELECT TOP 50 GroupID, UserID, Code, PrntCode, JV_PLANT_ID
                FROM TB_FX_UserGroupAuthExtention WHERE AuthType='J' ORDER BY GroupID, UserID, Code""")
    print()
    print('### 3) AS-IS J 분기 추출 결과 (DIVISION + JV_PLANT) — UP_FX 로직 그대로')
    run(cur, """SELECT DISTINCT B.GroupID, B.UserID,
                       A.DIVISION_ID AS CODE,
                       A.DIVISION_ID + ' ' + MIN(A.DIVISION_NAME) AS NAME,
                       B.JV_PLANT_ID
                FROM SCM_MST_DIVISION A
                  INNER JOIN TB_FX_UserGroupAuthExtention B ON A.DIVISION_ID = B.Code AND B.AuthType='J'
                GROUP BY B.GroupID, B.UserID, A.DIVISION_ID, B.JV_PLANT_ID
                ORDER BY B.GroupID, B.UserID, A.DIVISION_ID""")
except Exception as e:
    print('ERROR:', type(e).__name__, str(e)[:300])
    sys.exit(1)
