"""[조회 전용] 01_weekly_rolling_log_diag.sql 의 각 쿼리를 사내 ZIOUI1 에서 실행해 문법·결과를 확인한다 (클라우드 실행 전 검증)
  python _run_diag.py            → 전주 월~목 (SQL 그대로)
  python _run_diag.py 2026-09-28 2026-10-02  → 기간 지정 (W 윈도 치환)
"""
import sys, re, pathlib, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = pathlib.Path(__file__).resolve().parent
files = [a for a in sys.argv[1:] if a.endswith(".sql")]
sys.argv = [a for a in sys.argv if not a.endswith(".sql")]
sql = (HERE / (files[0] if files else "01_weekly_rolling_log_diag.sql")).read_text(encoding="utf-8")
sql = sql.replace("'&sql_id'", "'00000000000000'").replace("'&block_start'", "'2026-09-30 19:40:48'").replace("'&block_end'", "'2026-09-30 19:41:42'")   # 사내 문법 검증용 치환
if len(sys.argv) >= 3:
    sql = sql.replace("TRUNC(SYSDATE, 'IW') - 7", f"TO_DATE('{sys.argv[1]}','YYYY-MM-DD')").replace("TRUNC(SYSDATE, 'IW') - 3", f"TO_DATE('{sys.argv[2]}','YYYY-MM-DD')")
if len(sys.argv) >= 4:   # 사업부 치환 (사내 검증용 — 클라우드 SQL 은 40 고정)
    sql = sql.replace("'Div: 40%'", f"'Div: {sys.argv[3]}%'")
blocks = [b for b in re.split(r"\n(?=/\* -{5,} Q\d)", sql) if re.match(r"/\* -{5,} Q\d", b)]
only = [a[7:].split(",") for a in sys.argv if a.startswith("--only=")]   # --only=Q10b,Q12b
if only: blocks = [b for b in blocks if re.search(r"Q\w+", b).group(0) in only[0]]
sys.argv = [a for a in sys.argv if not a.startswith("--only=")]
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
for b in blocks:
    title = re.search(r"Q\d[^\n]*", b).group(0)
    stmt = re.sub(r"/\*.*?\*/", "", b, flags=re.S).strip().rstrip(";")
    stmt = "\n".join(l for l in stmt.splitlines() if not l.strip().startswith("--"))
    stmt = re.sub(r"--[^\n]*", "", stmt)
    t0 = time.time()
    try:
        cur.execute(stmt); rows = cur.fetchmany(60); cols = [c[0] for c in cur.description]
        print(f"\n### {title}  ({len(rows)}행, {time.time()-t0:.1f}s)"); print("   ", cols)
        for r in rows[:40]: print("   ", [str(v)[:38] if v is not None else "" for v in r])
    except Exception as e:
        print(f"\n### {title}  ERROR {str(e)[:200]}")
