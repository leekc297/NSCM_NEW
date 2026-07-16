# -*- coding: utf-8 -*-
import os, time
import pyodbc
def _conn():
    env={}; p=os.path.abspath(os.path.join(os.path.dirname(__file__),"..","..",".env.asis"))
    for ln in open(p,encoding="utf-8-sig"):
        ln=ln.strip()
        if ln and not ln.startswith("#") and "=" in ln:
            k,v=ln.split("=",1); env[k.strip()]=v.strip()
    cs=(f"DRIVER={{{env.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')}}};"
        f"SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};DATABASE={env['ASIS_DB_NAME']};"
        f"UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes;Encrypt=no")
    return pyodbc.connect(cs,timeout=60,autocommit=True)
cn=_conn(); cur=cn.cursor(); cur.execute("SET NOCOUNT ON")
cur.execute("SELECT CONVERT(VARCHAR(8),GETDATE(),112)"); print("ASIS_TODAY=",cur.fetchone()[0])
for rng in [("20260101","20260731"),("20260701","20270131")]:
    t0=time.time()
    cur.execute(f"EXEC DMF0082_GET_MAIN_DATA '40','ALL','ALL','ALL','{rng[0]}','{rng[1]}','ALL','','Current','N','dsiol','ADMIN'")
    from collections import Counter
    cols=[d[0] for d in cur.description]; rows=cur.fetchall()
    midx=None
    for i,c in enumerate(cols):
        if c.upper() in ('MEASURE','RESULT_MEASURE'): midx=i;break
    cc=Counter(str(r[midx]) for r in rows) if midx is not None else {}
    print(f"[{rng[0]}-{rng[1]}] set1_rows={len(rows)} cols={len(cols)} {dict(cc)} ({time.time()-t0:.1f}s)")
cn.close()
