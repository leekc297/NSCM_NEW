import sys, json, re, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from parse_check import declared_names, statements_with_group_by, bindify
from groupby_scan import strip_comments

sweep = json.load(open(HERE / "fresh_sweep.json", encoding="utf-8"))
log = (HERE / "fix_run2.log").read_text(encoding="utf-8", errors="ignore")
# fixes per object from the fixer log
cur = None; fixes = {}
for line in log.splitlines():
    m = re.match(r"=== (\S+(?: \S+)?) (\S+)$", line.strip())
    if line.startswith("==="):
        cur = line.split()[-1]; fixes[cur] = []; continue
    m = re.search(r"FIX\[[^\]]*\] L(\d+) \(select L(\d+)\)", line)
    if m and cur: fixes[cur].append((int(m.group(1)), int(m.group(2))))
for obj, fx in fixes.items():
    if not fx: continue
    key = next((k for k in sweep if k.startswith(obj + ".")), None)
    if not key: print(obj, "not in sweep"); continue
    st = sweep[key]["all"]  # [line, code, text]
    lines = sorted(x[0] for x in st)
    print(f"== {obj}: parser stmts={len(st)} at {lines}")
    # locate statement containing each fix: statement start <= select_line, next start > select_line
    for gl, sl in fx:
        start = max([l for l in lines if l <= sl], default=None)
        code = next((x[1] for x in st if x[0] == start), None) if start else None
        # does that statement really extend to gl? check via re-parse on the file
        print(f"   fix GROUP BY L{gl} (select L{sl}) -> parser stmt L{start} code={code}")
# ORA-00928 detail
for k, v in sweep.items():
    for x in v.get("all", []):
        if x[1] not in ("OK", "ORA-00979"):
            print(f"OTHER {k} L{x[0]} {x[1]} | {x[2][:100]}")
