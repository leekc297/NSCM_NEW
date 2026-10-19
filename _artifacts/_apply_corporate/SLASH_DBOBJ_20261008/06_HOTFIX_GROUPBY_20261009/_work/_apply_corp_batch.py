"""Apply the 9 fixed objects to corporate ZIOUI1 with FRESH-GATE, then verify (VALID / errors / new INVALID / re-parse)."""
import sys, json, re, pathlib, time
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
from parse_check import parse_all

meta = json.load(open(HERE / "fresh_all/_meta.json", encoding="utf-8"))
sweep = json.load(open(HERE / "fresh_sweep4.json", encoding="utf-8"))
targets = []
for fn, v in sweep.items():
    if v.get("ora979"):
        k = next(k for k, m in meta.items() if m["file"] == fn)
        targets.append((k.split("|")[0], k.split("|")[1], fn, len(v["ora979"])))
print("targets:", [(nm, n) for ot, nm, fn, n in targets])
assert len(targets) == 9
BASELINE_INVALID = {"PKG_SCP0134", "PKG_SDM2010", "PKG_SDM2020", "PKG_SDM2030", "PKG_SPMS_SEND_MAIL"}
log = []
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for ot, nm, fn, n979 in targets:
        body = (HERE / "fixed_all" / fn).read_text(encoding="utf-8").rstrip()
        assert body.upper().startswith(ot.split()[0]), body[:40]
        assert "[E20261009-GRPBYFIX]" in body
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [nm, ot])
        st, ddl = cur.fetchone()
        gate = meta[f"{ot}|{nm}"]["last_ddl"]
        if ddl != gate:
            print(f"!! FRESH-GATE FAIL {ot} {nm}: db last_ddl={ddl} != fetched {gate} — SKIP (원문이 바뀜, 재추출 필요)")
            log.append({"obj": f"{ot}|{nm}", "result": "SKIP_FRESH_GATE", "db_ddl": ddl, "fetched_ddl": gate}); continue
        t = time.time()
        cur.execute("CREATE OR REPLACE " + body)
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [nm, ot])
        st2, ddl2 = cur.fetchone()
        cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:1 AND type=:2 AND attribute='ERROR'", [nm, ot])
        nerr = cur.fetchone()[0]
        # re-fetch source and parse-check
        if ot == "VIEW":
            res = []
        else:
            cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:1 AND type=:2 ORDER BY line", [nm, ot])
            src = "".join(r[0] for r in cur.fetchall())
            (HERE / "applied_corp" ).mkdir(exist_ok=True)
            (HERE / "applied_corp" / fn).write_text(src, encoding="utf-8")
            res = parse_all(cur, src)
        n979_after = sum(1 for x in res if "00979" in x[1])
        marks = src.count("[E20261009-GRPBYFIX]") if ot != "VIEW" else 0
        print(f"OK {ot} {nm}: {st}@{ddl} -> {st2}@{ddl2} errors={nerr} parse979 before={n979_after and 'n/a' or 0} after={n979_after} markers={marks} ({time.time()-t:.1f}s)")
        log.append({"obj": f"{ot}|{nm}", "result": "APPLIED", "status": st2, "last_ddl": ddl2, "errors": nerr, "ora979_before": n979, "ora979_after": n979_after, "markers": marks})
    cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
    inv = [f"{a} {b}" for a, b in cur.fetchall() if b not in BASELINE_INVALID]
    print("new INVALID (excluding 5 baseline):", inv)
json.dump({"applied_at": time.strftime("%Y-%m-%d %H:%M:%S"), "log": log, "new_invalid": inv}, open(HERE / "APPLY_LOG_corp_hotfix.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
