"""Fetch full VIEW text (LONG) for the 7 payload views and check our 10-08 edits are present."""
import sys, json, re, pathlib
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
p = json.load(open(HERE / "../../patches.json", encoding="utf-8"))["patches"]
u, pw, d = ora.conn_info()
norm = lambda s: re.sub(r"\s+", " ", s.strip())
with oracledb.connect(user=u, password=pw, dsn=d) as c:
    cur = c.cursor()
    for k, v in p.items():
        if not k.startswith("VIEW|"):
            continue
        nm = k.split("|", 1)[1]
        cur.execute("SELECT text FROM all_views WHERE owner='SCM_MGR' AND view_name=:1", [nm])
        r = cur.fetchone()
        if not r:
            print(nm, "NOT FOUND"); continue
        txt = r[0] if isinstance(r[0], str) else r[0].read()
        (HERE / "fresh_all" / f"{nm}.VIEW.sql").write_text(txt, encoding="utf-8")
        fn = norm(txt)
        present = sum(1 for e in v["edits"] if e.get("new") and norm(e["new"]) in fn)
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type='VIEW'", [nm])
        st = cur.fetchone()
        print(f"{nm}: full_text_len={len(txt)} edits present {present}/{len(v['edits'])} status={st[0]} ddl={st[1]}")
