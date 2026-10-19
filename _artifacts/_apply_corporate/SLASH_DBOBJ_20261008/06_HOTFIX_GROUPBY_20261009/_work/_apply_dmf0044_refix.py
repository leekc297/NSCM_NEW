"""Apply pending_PKG_DMF0044_refix.sql to corporate. FRESH-GATE: DB LAST_DDL must equal the base snapshot's (15:16:09)."""
import sys, json, pathlib, time
HERE = pathlib.Path(__file__).parent
sys.path.insert(0, str(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
from parse_check import parse_all
MARK = "[E20261009-GRPBYFIX]"
info = json.load(open(HERE / "pending_PKG_DMF0044_refix.json"))
body = (HERE / "pending_PKG_DMF0044_refix.sql").read_text(encoding="utf-8").rstrip()
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 15")
    cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name='PKG_DMF0044' AND object_type='PACKAGE BODY'")
    st, ddl = cur.fetchone(); print("FRESH-GATE db:", st, ddl, "| base:", info["base_status"], info["base_ddl"])
    assert ddl == info["base_ddl"], "원문이 또 바뀜 — _refix_dmf0044.py 재실행 필요"
    t = time.time(); cur.execute("CREATE OR REPLACE " + body); print(f"applied ({time.time()-t:.1f}s)")
    cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name='PKG_DMF0044' AND object_type='PACKAGE BODY'")
    st2, ddl2 = cur.fetchone()
    cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type='PACKAGE BODY' AND attribute='ERROR'"); nerr = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type='PACKAGE BODY' ORDER BY line"); src = "".join(r[0] for r in cur.fetchall())
    (HERE / "applied_corp/PKG_DMF0044.PACKAGE_BODY.sql").write_text(src, encoding="utf-8")
    res = parse_all(cur, src); n979 = sum(1 for x in res if "00979" in x[1])
    cur.execute("SELECT object_type, object_name FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' AND object_name NOT IN ('PKG_SCP0134','PKG_SDM2010','PKG_SDM2020','PKG_SDM2030','PKG_SPMS_SEND_MAIL')"); inv = cur.fetchall()
    print(f"after: {st2}@{ddl2} errors={nerr} parse979={n979} markers={src.count(MARK)} new INVALID={inv}")
    log = json.load(open(HERE / "APPLY_LOG_corp_hotfix.json", encoding="utf-8"))
    for x in log["log"]:
        if x["obj"] == "PACKAGE BODY|PKG_DMF0044":
            x.update({"result": "REAPPLIED_ON_OTHER_WORKER_VERSION", "status": st2, "last_ddl": ddl2, "errors": nerr, "ora979_before": 4, "ora979_after": n979, "markers": src.count(MARK), "note": "타 작업자 15:00:45~15:16:09 덮어쓰기(ENERGE_KWH 포맷·NO_DATA_FOUND) 위에 GROUP BY 재교정"})
    log["new_invalid"] = [f"{a} {b}" for a, b in inv]
    json.dump(log, open(HERE / "APPLY_LOG_corp_hotfix.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
