"""Apply remaining fixed objects (those whose DB source lacks the marker) with DDL_LOCK_TIMEOUT, then rebuild the full
apply log for all 9 target objects from the DB (status / last_ddl / errors / markers / re-parse ORA-00979)."""
import sys, json, re, pathlib, time
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
from parse_check import parse_all

MARK = "[E20261009-GRPBYFIX]"
meta = json.load(open(HERE / "fresh_all/_meta.json", encoding="utf-8"))
sweep = json.load(open(HERE / "fresh_sweep4.json", encoding="utf-8"))
targets = []
for fn, v in sweep.items():
    if v.get("ora979"):
        k = next(k for k, m in meta.items() if m["file"] == fn)
        targets.append((k.split("|")[0], k.split("|")[1], fn, len(v["ora979"])))
BASELINE_INVALID = {"PKG_SCP0134", "PKG_SDM2010", "PKG_SDM2020", "PKG_SDM2030", "PKG_SPMS_SEND_MAIL"}
(HERE / "applied_corp").mkdir(exist_ok=True)
log = []
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 15")
    for ot, nm, fn, n979 in targets:
        cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name=:1 AND type=:2 AND text LIKE :3", [nm, ot, f"%{MARK}%"])
        has = cur.fetchone()[0] > 0
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [nm, ot])
        st, ddl = cur.fetchone()
        result = "ALREADY_APPLIED"
        if not has:
            gate = meta[f"{ot}|{nm}"]["last_ddl"]
            if ddl != gate:
                print(f"!! FRESH-GATE FAIL {ot} {nm}: db={ddl} fetched={gate} — SKIP"); log.append({"obj": f"{ot}|{nm}", "result": "SKIP_FRESH_GATE", "db_ddl": ddl, "fetched_ddl": gate}); continue
            body = (HERE / "fixed_all" / fn).read_text(encoding="utf-8").rstrip()
            assert MARK in body
            try:
                t = time.time(); cur.execute("CREATE OR REPLACE " + body); result = "APPLIED"
                print(f"applied {ot} {nm} ({time.time()-t:.1f}s)")
            except Exception as e:
                code = re.search(r"ORA-\d{5}", str(e)); code = code.group() if code else str(e)[:60]
                print(f"!! APPLY FAIL {ot} {nm}: {code} — {str(e)[:120]}")
                log.append({"obj": f"{ot}|{nm}", "result": "FAIL_" + code, "ora979_before": n979}); continue
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [nm, ot])
        st2, ddl2 = cur.fetchone()
        cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:1 AND type=:2 AND attribute='ERROR'", [nm, ot])
        nerr = cur.fetchone()[0]
        cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:1 AND type=:2 ORDER BY line", [nm, ot])
        src = "".join(r[0] for r in cur.fetchall())
        (HERE / "applied_corp" / fn).write_text(src, encoding="utf-8")
        res = parse_all(cur, src); n_after = sum(1 for x in res if "00979" in x[1]); marks = src.count(MARK)
        print(f"{result} {ot} {nm}: {st2}@{ddl2} errors={nerr} parse979 {n979}->{n_after} markers={marks}")
        log.append({"obj": f"{ot}|{nm}", "result": result, "status": st2, "last_ddl": ddl2, "errors": nerr, "ora979_before": n979, "ora979_after": n_after, "markers": marks})
    cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
    inv = [f"{a} {b}" for a, b in cur.fetchall() if b not in BASELINE_INVALID]
    print("new INVALID (excluding 5 baseline):", inv)
json.dump({"applied_at": time.strftime("%Y-%m-%d %H:%M:%S"), "log": log, "new_invalid": inv}, open(HERE / "APPLY_LOG_corp_hotfix.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("SUMMARY:", {x["result"]: sum(1 for y in log if y["result"] == x["result"]) for x in log})
