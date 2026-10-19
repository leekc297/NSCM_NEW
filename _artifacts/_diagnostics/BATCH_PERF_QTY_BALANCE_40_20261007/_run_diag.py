"""[조회 전용] 01_qty_balance_40_log_diag.sql 의 각 쿼리를 사내 ZIOUI1 에서 실행해 문법·결과를 확인한다 (클라우드 실행 전 검증)
  python _run_diag.py                                   → 전주 월~목, 40 / NULL (SQL 그대로)
  python _run_diag.py 2026-09-28 2026-10-02             → 기간 지정 (W 윈도 치환)
  python _run_diag.py 2026-09-28 2026-10-02 82 CALL     → 사업부/plan_id 치환 (사내 검증용 — 사내에는 40/NULL 배치 실행 로그가 없어 82/CALL 로 구조 검증)
Q7 은 V$/AWR 권한이 필요해 사내 SCM_MGR 에서는 ORA-00942/01031 로 끝나는 것이 정상(클라우드 권한 계정에서만 유효).
"""
import sys, re, pathlib, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = pathlib.Path(__file__).resolve().parent
sql = (HERE / "01_qty_balance_40_log_diag.sql").read_text(encoding="utf-8")
if len(sys.argv) >= 3:
    sql = sql.replace("TRUNC(SYSDATE, 'IW') - 7", f"TO_DATE('{sys.argv[1]}','YYYY-MM-DD')").replace("TRUNC(SYSDATE, 'IW') - 3", f"TO_DATE('{sys.argv[2]}','YYYY-MM-DD')")
if len(sys.argv) >= 4:
    div = sys.argv[3]; plan = sys.argv[4] if len(sys.argv) >= 5 else "NULL"
    sql = sql.replace('{"p_division_id":"40","p_plan_id":"NULL"}', f'{{"p_division_id":"{div}","p_plan_id":"{plan}"}}')
    sql = sql.replace(r"'^@p_division_id\s*:\s*40(\s|/|$)'", rf"'^@p_division_id\s*:\s*{div}(\s|/|$)'")
# 블록 분할: "/* ---------- Qn" 헤더 또는 "-- Qn-x." 서브 헤더 단위
blocks = [b for b in re.split(r"\n(?=/\* -{5,} Q\d|-- Q\d-[a-z]\.)", sql) if re.match(r"/\* -{5,} Q\d|-- Q\d-[a-z]\.", b)]
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
print(f"conn={u}@{d}  blocks={len(blocks)}")
for b in blocks:
    title = re.search(r"Q\d[^\n]*", b).group(0)
    body = re.sub(r"/\*.*?\*/", "", b, flags=re.S)
    body = "\n".join(l for l in body.splitlines() if not l.strip().startswith("--"))
    body = re.sub(r"--[^\n]*", "", body)
    stmts = [s.strip() for s in body.split(";") if s.strip()]
    for i, stmt in enumerate(stmts):
        t0 = time.time()
        try:
            cur.execute(stmt); rows = cur.fetchmany(80); cols = [c[0] for c in cur.description]
            print(f"\n### {title} [{i+1}/{len(stmts)}]  ({len(rows)}행, {time.time()-t0:.1f}s)"); print("   ", cols)
            for r in rows[:60]: print("   ", [str(v)[:60] if v is not None else "" for v in r])
        except Exception as e:
            print(f"\n### {title} [{i+1}/{len(stmts)}]  ERROR {str(e)[:220]}")
