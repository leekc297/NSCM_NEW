"""[조회 전용] 01_longrun_identify_0929_1001.sql 의 각 블록을 사내 ZIOUI1 에서 실행해 문법·구조를 확인한다 (클라우드 실행 전 검증)
  python _run_check.py                 → SQL 그대로(2026-09-29 ~ 10-01)
  python _run_check.py 2026-09-28 2026-10-05   → from_dt / to_dt(미포함) 치환 (scan_from = from-1일, scan_to = to+1일 자동)
Q4 는 DBA_HIST 권한이 필요해 권한 없는 계정에서는 ORA-00942/01031 로 끝나는 것이 정상.
"""
import sys, re, pathlib, time, datetime as dt
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = pathlib.Path(__file__).resolve().parent
sql = (HERE / "01_longrun_identify_0929_1001.sql").read_text(encoding="utf-8")
if len(sys.argv) >= 3:
    f = dt.date.fromisoformat(sys.argv[1]); t = dt.date.fromisoformat(sys.argv[2])
    rep = {"2026-09-29": f.isoformat(), "2026-10-02": t.isoformat(),
           "2026-09-28": (f - dt.timedelta(days=1)).isoformat(), "2026-10-03": (t + dt.timedelta(days=1)).isoformat()}
    sql = re.sub(r"2026-(09-29|10-02|09-28|10-03)", lambda m: rep["2026-" + m.group(1)], sql)
blocks = [b for b in re.split(r"\n(?=/\* -{5,} Q\d|-- Q\d-[a-z]\.)", sql) if re.match(r"/\* -{5,} Q\d|-- Q\d-[a-z]\.", b)]
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
print(f"conn={u}@{d}  blocks={len(blocks)}")
for b in blocks:
    title = re.search(r"Q\d[^\n]*", b).group(0)[:70]
    body = re.sub(r"/\*.*?\*/", "", b, flags=re.S)
    body = "\n".join(l for l in body.splitlines() if not l.strip().startswith("--"))
    body = re.sub(r"--[^\n]*", "", body)
    stmts = [s.strip() for s in body.split(";") if s.strip()]
    for i, stmt in enumerate(stmts):
        t0 = time.time()
        try:
            cur.execute(stmt); rows = cur.fetchmany(80); cols = [c[0] for c in cur.description]
            print(f"\n### {title} [{i+1}/{len(stmts)}]  ({len(rows)}행, {time.time()-t0:.1f}s)"); print("   ", cols)
            for r in rows[:40]: print("   ", [str(v)[:50] if v is not None else "" for v in r])
        except Exception as e:
            print(f"\n### {title} [{i+1}/{len(stmts)}]  ERROR {str(e)[:220]}")
