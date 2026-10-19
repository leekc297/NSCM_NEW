"""Definitive sweep: DBMS_SQL.PARSE every GROUP BY statement of every non-VIEW object source in a folder.
Usage: python _parse_sweep.py <folder> <out.json>   → prints objects having ORA-00979 (and code histogram)
"""
import sys, json, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from parse_check import parse_all
import ora, oracledb
from collections import Counter

folder = pathlib.Path(sys.argv[1]); out = pathlib.Path(sys.argv[2])
u, p, d = ora.conn_info()
result = {}
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for f in sorted(folder.glob("*.sql")):
        if ".VIEW." in f.name or f.name.startswith("_"):
            continue
        src = f.read_text(encoding="utf-8", errors="ignore")
        try:
            res = parse_all(cur, src)
        except Exception as e:
            result[f.name] = {"error": str(e)[:200]}; print(f.name, "ERROR", str(e)[:120]); continue
        hist = dict(Counter(x[1] for x in res))
        bad = [x for x in res if "00979" in x[1]]
        result[f.name] = {"stmts": len(res), "codes": hist, "ora979": bad, "all": res}
        flag = "  <== ORA-00979 x%d" % len(bad) if bad else ""
        print(f"{f.name}: stmts={len(res)} codes={hist}{flag}")
        for x in bad:
            print(f"     L{x[0]} | {x[2][:100]}")
json.dump(result, open(out, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
tot = sum(len(v.get("ora979", [])) for v in result.values())
print(f"TOTAL objects={len(result)} ORA-00979 statements={tot} in objects={sum(1 for v in result.values() if v.get('ora979'))}")
