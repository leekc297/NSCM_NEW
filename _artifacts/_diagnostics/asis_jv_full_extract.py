#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS JV Planner 전체 이관 데이터 추출 (user / mapping / J auth) → JSON.
.env.asis ASIS_DB_* 사용."""
import os, sys, pathlib, json, pyodbc

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
    cs=(f"DRIVER={{{kv.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')}}};"
        f"SERVER={kv.get('ASIS_DB_HOST')},{kv.get('ASIS_DB_PORT','1433')};"
        f"DATABASE={kv.get('ASIS_DB_NAME')};UID={kv.get('ASIS_DB_USER')};PWD={kv.get('ASIS_DB_PASS')};"
        f"TrustServerCertificate=yes;Encrypt=no;")
    return pyodbc.connect(cs, timeout=20)

def rows(cur, sql):
    cur.execute(sql); cols=[c[0] for c in cur.description]
    return [dict(zip(cols, ['' if v is None else str(v) for v in r])) for r in cur.fetchall()]

cn=connect(); cur=cn.cursor()
out={}
# 1) JV Planner 그룹 매핑 사용자 (authoritative user list)
out['mapping']=rows(cur, "SELECT GroupID, UserID, UseYN, RegtUserID FROM TB_FX_UserGroupInfo WHERE GroupID='JV Planner' ORDER BY UserID")
# 2) 그 사용자들의 user master 상세
out['users']=rows(cur, """SELECT U.UserID, U.UserName, U.UserName_E, U.Email, U.Dept_ID, U.Language
                          FROM TB_FX_User U
                          WHERE U.UserID IN (SELECT UserID FROM TB_FX_UserGroupInfo WHERE GroupID='JV Planner')
                          ORDER BY U.UserID""")
# 3) J auth 17행 (DIVISION + JV_PLANT)
out['auth']=rows(cur, """SELECT GroupID, UserID, Code, PrntCode, JV_PLANT_ID
                         FROM TB_FX_UserGroupAuthExtention WHERE AuthType='J' ORDER BY UserID, Code""")
# 4) JV_PLANT_ID 컬럼 길이
out['jv_len']=rows(cur, "SELECT MAX(LEN(JV_PLANT_ID)) AS MAXLEN FROM TB_FX_UserGroupAuthExtention WHERE AuthType='J'")
outpath=pathlib.Path(__file__).resolve().parent/'asis_jv_data.json'
outpath.write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding='utf-8')
print('mapping:', len(out['mapping']), '| users:', len(out['users']), '| auth:', len(out['auth']), '| jv_maxlen:', out['jv_len'])
print('users sample:', json.dumps(out['users'][:3], ensure_ascii=False))
print('mapping userIds:', [m['UserID'] for m in out['mapping']])
print('-> saved', outpath)
