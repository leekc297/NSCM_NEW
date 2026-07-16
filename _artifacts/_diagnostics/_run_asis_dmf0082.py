# -*- coding: utf-8 -*-
import os, time
import pyodbc

def _conn():
    env = {}
    p = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".env.asis"))
    for ln in open(p, encoding="utf-8-sig"):
        ln = ln.strip()
        if ln and not ln.startswith("#") and "=" in ln:
            k, v = ln.split("=", 1); env[k.strip()] = v.strip()
    cs = (f"DRIVER={{{env.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')}}};"
          f"SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};DATABASE={env['ASIS_DB_NAME']};"
          f"UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes;Encrypt=no")
    return pyodbc.connect(cs, timeout=30, autocommit=True)

# 골든 EXEC: div40, ALL, Current, dsiol/ADMIN, 6개월(2025-02~07)
SQL = "EXEC DMF0082_GET_MAIN_DATA '40','ALL','ALL','ALL','20250201','20250731','ALL','','Current','Y','dsiol','ADMIN'"

cn = _conn(); cur = cn.cursor()
cur.execute("SET NOCOUNT ON")
t0 = time.time()
cur.execute(SQL)
setno = 0
while True:
    setno += 1
    try:
        cols = [d[0] for d in cur.description] if cur.description else []
    except Exception:
        cols = []
    rows = cur.fetchall() if cols else []
    # measure 컬럼 탐지
    mcol = None
    for c in cols:
        if c.upper() in ("MEASURE","RESULT_MEASURE"):
            mcol = c; break
    dist = ""
    if mcol:
        idx = cols.index(mcol)
        from collections import Counter
        cc = Counter(str(r[idx]) for r in rows)
        dist = " | measures=" + str(dict(sorted(cc.items(), key=lambda x:-x[1])))
    print(f"[set {setno}] rows={len(rows)} cols={len(cols)}{(' :: '+','.join(cols[:8])) if cols else ''}{dist}")
    if not cur.nextset():
        break
print(f"TOTAL_ELAPSED_SEC={time.time()-t0:.1f}")
cn.close()
