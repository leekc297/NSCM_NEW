"""[조회 전용] 02_compact_output.sql 을 사내 ZIOUI1 에서 실행해 한 줄 출력 검증. 인자 = _run_diag.py 와 동일 ([from] [to] [division] [plan_id])"""
import sys, re, pathlib, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = pathlib.Path(__file__).resolve().parent
sql = (HERE / "02_compact_output.sql").read_text(encoding="utf-8")
if len(sys.argv) >= 3:
    sql = sql.replace("TRUNC(SYSDATE, 'IW') - 7", f"TO_DATE('{sys.argv[1]}','YYYY-MM-DD')").replace("TRUNC(SYSDATE, 'IW') - 3", f"TO_DATE('{sys.argv[2]}','YYYY-MM-DD')")
if len(sys.argv) >= 4:
    div = sys.argv[3]; plan = sys.argv[4] if len(sys.argv) >= 5 else "NULL"
    sql = sql.replace('{"p_division_id":"40","p_plan_id":"NULL"}', f'{{"p_division_id":"{div}","p_plan_id":"{plan}"}}')
    sql = sql.replace(r"'^@p_division_id\s*:\s*40(\s|/|$)'", rf"'^@p_division_id\s*:\s*{div}(\s|/|$)'")
body = re.sub(r"/\*.*?\*/", "", sql, flags=re.S)
body = "\n".join(l for l in body.splitlines() if not l.strip().startswith("--") and not l.strip().upper().startswith("SET ") and not l.strip().upper().startswith("SPOOL"))
body = re.sub(r"--[^\n]*", "", body)
stmts = [s.strip() for s in body.split(";") if s.strip()]
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
print(f"conn={u}@{d}  statements={len(stmts)}")
for i, stmt in enumerate(stmts):
    t0 = time.time()
    try:
        cur.execute(stmt); rows = cur.fetchmany(60)
        print(f"\n### [{i+1}/{len(stmts)}] {len(rows)}행 {time.time()-t0:.1f}s")
        for r in rows: print("  ", (r[0] or "")[:260])
    except Exception as e:
        print(f"\n### [{i+1}/{len(stmts)}] ERROR {str(e)[:260]}\n   {stmt[:120]}")
