import sys, json, re, difflib, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
from parse_check import parse_all
MARK = "[E20261009-GRPBYFIX]"
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name='PKG_DMF0044' AND object_type='PACKAGE BODY'")
    print("status/ddl:", cur.fetchone())
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type='PACKAGE BODY' ORDER BY line")
    now = "".join(r[0] for r in cur.fetchall())
    (HERE / "PKG_DMF0044.BODY.db_150045.sql").write_text(now, encoding="utf-8")
    ours = (HERE / "applied_corp/PKG_DMF0044.PACKAGE_BODY.sql").read_text(encoding="utf-8")
    print("lines now/ours:", now.count("\n"), ours.count("\n"), "| markers now:", now.count(MARK), "| '/' lines now/ours:", sum("'/'" in l for l in now.splitlines()), sum("'/'" in l for l in ours.splitlines()))
    pt = json.load(open(HERE / "../../patches.json", encoding="utf-8"))["patches"]["PACKAGE BODY|PKG_DMF0044"]["edits"]
    norm = lambda s: re.sub(r"\s+", " ", s.strip())
    nn = norm(now); present = sum(1 for e in pt if e.get("new") and norm(e["new"]) in nn)
    print(f"our 10-08 edits present in DB now: {present}/{len(pt)}")
    d_ = [l for l in difflib.unified_diff(ours.splitlines(), now.splitlines(), "ours_1442", "db_150045", n=0, lineterm="") if l.startswith(("+", "-")) and not l.startswith(("+++", "---"))]
    print("diff lines (ours→now):", len(d_))
    for l in d_[:40]: print("  ", l[:170])
    res = parse_all(cur, now); n979 = [x for x in res if "00979" in x[1]]
    print("parse: stmts", len(res), "ORA-00979:", len(n979), [x[0] for x in n979])
    # who: look for a marker/comment with today's date added by the other worker
    for l in now.splitlines():
        if re.search(r"2026[.\-]?10[.\-]?09", l) and MARK not in l: print("  today-comment:", l.strip()[:150])
