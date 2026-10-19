"""[조회 전용] 03_sales_plan_weekly_rolling_40_diag.sql 사내 검증. python _run_sp40.py [division]  (사내엔 40 실행이 없어 81 로 치환 검증)"""
import sys, re, pathlib, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
sql = pathlib.Path("03_sales_plan_weekly_rolling_40_diag.sql").read_text(encoding="utf-8")
if len(sys.argv) >= 2:
    dv = sys.argv[1]; sql = sql.replace(r"'^@p_division_id\s*:\s*40(\s|/|$)'", rf"'^@p_division_id\s*:\s*{dv}(\s|/|$)'").replace('"p_division_id":"40"', f'"p_division_id":"{dv}"').replace("'40 Final Plan NULL%'", f"'{dv} Final Plan NULL%'")
body = re.sub(r"/\*.*?\*/", "", sql, flags=re.S)
body = "\n".join(l for l in body.splitlines() if not l.strip().startswith("--") and not l.strip().upper().startswith("SET ") and not l.strip().upper().startswith("SPOOL"))
body = re.sub(r"--[^\n]*", "", body)
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
for i, stmt in enumerate([s.strip() for s in body.split(";") if s.strip()]):
    t0=time.time()
    try:
        cur.execute(stmt); rows = cur.fetchmany(60); print(f"\n### [{i+1}] {len(rows)}행 {time.time()-t0:.1f}s"); [print("  ", (r[0] or "")[:230]) for r in rows[:40]]
    except Exception as e: print(f"\n### [{i+1}] ERROR {str(e)[:220]}\n   {stmt[:100]}")
