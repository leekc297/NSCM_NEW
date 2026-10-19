import sys, re, pathlib, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
sql = pathlib.Path("02_compact_output.sql").read_text(encoding="utf-8")
blocks = [b for b in re.split(r"\n(?=/\* -{5,} C\d+)", sql) if re.match(r"/\* -{5,} C(9|10)\.", b)]
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
for b in blocks:
    title = re.search(r"C\d+[^\n]*", b).group(0)[:60]
    body = re.sub(r"/\*.*?\*/", "", b, flags=re.S); body = "\n".join(l for l in body.splitlines() if not l.strip().startswith("--")); body = re.sub(r"--[^\n]*", "", body)
    for i, stmt in enumerate([s.strip() for s in body.split(";") if s.strip()]):
        t0=time.time()
        try:
            cur.execute(stmt); rows = cur.fetchmany(40); print(f"### {title} [{i+1}] {len(rows)}행 {time.time()-t0:.1f}s"); [print("  ", (r[0] or "")[:200]) for r in rows[:25]]
        except Exception as e: print(f"### {title} [{i+1}] ERROR {str(e)[:200]}")
