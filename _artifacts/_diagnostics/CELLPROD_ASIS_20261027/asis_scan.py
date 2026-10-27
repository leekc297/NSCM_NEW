"""AS-IS MSSQL(LGCE_SCMDEV) 원문: CELL_PROD_SITE_ID 빈값 → '-' 처리 로직 전수 (조회 전용)"""
import os, re, pyodbc, pathlib, datetime
kv = {}
for l in pathlib.Path(r"C:\Projects\NSCM\.env.asis").read_text(encoding="utf-8", errors="ignore").splitlines():
    if "=" in l and not l.strip().startswith("#"): k, v = l.split("=", 1); kv[k.strip()] = v.strip()
cs = f"DRIVER={{{kv['ASIS_DB_DRIVER']}}};SERVER={kv['ASIS_DB_HOST']},{kv['ASIS_DB_PORT']};DATABASE={kv['ASIS_DB_NAME']};UID={kv['ASIS_DB_USER']};PWD={kv['ASIS_DB_PASS']};TrustServerCertificate=yes"
con = pyodbc.connect(cs, timeout=20); cur = con.cursor()
cur.execute("SELECT @@SERVERNAME, DB_NAME(), SUSER_NAME(), CONVERT(varchar(19), GETDATE(), 120)"); print("AS-IS", cur.fetchone())
cur.execute("""SELECT o.name, o.type_desc, m.definition FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id
               WHERE m.definition LIKE '%CELL_PROD_SITE_ID%' ORDER BY o.name""")
out = pathlib.Path(__file__).with_name("asis_hits.txt"); rep = []
pat = re.compile(r"ISNULL\s*\(\s*[\w\.@\[\]]*CELL_PROD_SITE_ID\]?\s*,\s*N?'-'\s*\)|CELL_PROD_SITE_ID\]?\s*=\s*N?'-'|N?'-'\s*(AS\s+)?\[?CELL_PROD_SITE_ID|NULLIF\s*\([^)]*CELL_PROD_SITE_ID[^)]*\)", re.I)
summary = []
for name, typ, d in cur.fetchall():
    lines = d.split("\n"); hits = []
    for i, l in enumerate(lines):
        code = l.split("--")[0]
        if pat.search(code) or ("CELL_PROD" in code.upper() and re.search(r"N?'-'", code)):
            hits.append(i + 1)
            rep.append(f"{name} L{i+1}: {l.strip()[:220]}")
    if hits: summary.append((name, typ, len(hits)))
out.write_text("\n".join(rep), encoding="utf-8")
print("CELL_PROD 사용 객체 + '-' 줄 보유:", len(summary))
for s in summary: print(f"  {s[0]:55s} {s[1]:22s} {s[2]}줄")
