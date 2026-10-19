"""[조회 전용] 03_rerun_plan1461_cloud.sql 의 조회 문장(P1~P7, A1~A5, B2~B3)을 사내 ZIOUI1 에서 실행해 문법을 확인한다.
B1 실행 블록은 주석 처리되어 있어 실행되지 않는다(사내에서도 절대 실행하지 않음)."""
import sys, re, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
import oracledb
HERE = pathlib.Path(__file__).resolve().parent
target = sys.argv[1] if len(sys.argv) > 1 else "03_rerun_plan1461_cloud.sql"   # python _run_check_03.py 04_awr_0930_run_cloud.sql
sql = (HERE / target).read_text(encoding="utf-8")
sql = re.sub(r"/\*.*?\*/", "", sql, flags=re.S)
lines = []
for l in sql.splitlines():
    s = l.strip()
    if s.upper().startswith("SET ") or s.startswith("--"): continue
    lines.append(re.sub(r"--[^\n]*", "", l))
body = "\n".join(lines)
# 실행 블록(DECLARE ... END; /) 은 절대 실행하지 않고 통째로 제거한다 (조회 문장만 검증)
body, n_exec = re.subn(r"DECLARE\b.*?\bEND;\s*\n/\s*\n", "", body, flags=re.S | re.I)
if n_exec: print(f"[skip] 실행 블록 {n_exec}개 제거(검증 대상 아님)")
stmts = [s.strip() for s in body.split(";") if s.strip()]
assert not any("PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(" in s and "BEGIN" in s.upper() for s in stmts), "실행 블록이 살아 있음 — 중단"
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
print(f"conn={u}@{d}  stmts={len(stmts)}")
for i, st in enumerate(stmts, 1):
    head = re.sub(r"\s+", " ", st)[:70]
    try:
        cur.execute(st); rows = cur.fetchall(); cols = [c[0] for c in cur.description]
        print(f"[{i}] OK {len(rows)} rows  :: {head}")
        for r in rows[:3]: print("    ", [str(v)[:40] if v is not None else "" for v in r])
    except Exception as e:
        print(f"[{i}] ERROR {str(e)[:160]}  :: {head}")
