"""[조회 전용] 02_compact_q2_q3.sql 의 3 문장을 사내 ZIOUI1 에서 실행해 문법을 확인한다 (SET 지시어는 건너뜀)."""
import sys, re, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = pathlib.Path(__file__).resolve().parent
sql = (HERE / "02_compact_q2_q3.sql").read_text(encoding="utf-8")
sql = re.sub(r"/\*.*?\*/", "", sql, flags=re.S)
sql = "\n".join(l for l in sql.splitlines() if not l.strip().upper().startswith("SET ") and not l.strip().startswith("--"))
stmts = [s.strip() for s in sql.split(";") if s.strip()]
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
print(f"conn={u}@{d}  stmts={len(stmts)}")
for i, st in enumerate(stmts, 1):
    try:
        cur.execute(st); rows = cur.fetchall()
        print(f"[{i}] OK {len(rows)} rows")
        for r in rows[:4]: print("   ", r[0][:170])
    except Exception as e:
        print(f"[{i}] ERROR {str(e)[:200]}")
