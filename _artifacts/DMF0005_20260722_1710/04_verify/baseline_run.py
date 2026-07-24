"""Run DMF0005 GET PRODUCTION scenarios against current deployed SP; dump sorted rows + sha256.
Usage: python baseline_run.py <outdir>"""
import os, sys, time, hashlib, json
import oracledb

OUT = sys.argv[1]
os.makedirs(OUT, exist_ok=True)

conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
conn.call_timeout = 900000
cur = conn.cursor()

# sample real filter tokens (deterministic)
def one(sql):
    cur.execute(sql)
    r = cur.fetchone()
    return r[0] if r else None

dept2 = []
cur.execute("SELECT DEPT_ID FROM (SELECT DISTINCT DEPT_ID FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID='81' AND DEPT_ID IS NOT NULL ORDER BY DEPT_ID) WHERE ROWNUM <= 2")
dept2 = [r[0] for r in cur.fetchall()]
site2 = []
cur.execute("SELECT SCM_SITE_ID FROM (SELECT DISTINCT SCM_SITE_ID FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID='81' ORDER BY SCM_SITE_ID) WHERE ROWNUM <= 2")
site2 = [r[0] for r in cur.fetchall()]
item_tok = one("SELECT SUBSTR(ITEM_ID,1,6) FROM (SELECT ITEM_ID FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID='81' AND ITEM_ID IS NOT NULL ORDER BY ITEM_ID) WHERE ROWNUM=1")
proj_tok = one("SELECT SUBSTR(PROJECT_CODE,1,5) FROM (SELECT PROJECT_CODE FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID='81' AND PROJECT_CODE IS NOT NULL ORDER BY PROJECT_CODE) WHERE ROWNUM=1")
owner_tok = one("SELECT SUBSTR(OWNER,1,5) FROM (SELECT OWNER FROM SCM_MST_SITE_ITEM WHERE DIVISION_ID='81' AND OWNER IS NOT NULL ORDER BY OWNER) WHERE ROWNUM=1")
endcust = one("SELECT EC FROM (SELECT DISTINCT ST.END_CUSTOMER EC FROM SCM_MST_SITE_ITEM SI JOIN SCM_MST_SITE ST ON ST.DIVISION_ID=SI.DIVISION_ID AND ST.SCM_SITE_ID=SI.SCM_SITE_ID AND ST.SITE_TYPE='SALES' WHERE SI.DIVISION_ID='81' AND ST.END_CUSTOMER IS NOT NULL ORDER BY EC) WHERE ROWNUM=1")

print("tokens:", json.dumps({"dept2": dept2, "site2": site2, "item": item_tok, "proj": proj_tok, "owner": owner_tok, "endcust": endcust}, ensure_ascii=False))

SCEN = {
    "S1_81_default_Y":   ["81", "ALL", "ALL", "ALL", "", "", "Y",   "", "minyonglee1"],
    "S2_81_valid_ALL":   ["81", "ALL", "ALL", "ALL", "", "", "ALL", "", "minyonglee1"],
    "S3_40_default_Y":   ["40", "ALL", "ALL", "ALL", "", "", "Y",   "", "minyonglee1"],
    "S4_82_default_Y":   ["82", "ALL", "ALL", "ALL", "", "", "Y",   "", "minyonglee1"],
    "S5_81_item":        ["81", "ALL", "ALL", "ALL", "", item_tok, "Y", "", "minyonglee1"],
    "S6_81_owner":       ["81", "ALL", "ALL", "ALL", "", "", "Y", owner_tok, "minyonglee1"],
    "S7_81_dept":        ["81", ",".join(dept2), "ALL", "ALL", "", "", "Y", "", "minyonglee1"],
    "S8_81_site":        ["81", "ALL", "ALL", ",".join(site2), "", "", "Y", "", "minyonglee1"],
    "S9_81_project":     ["81", "ALL", "ALL", "ALL", proj_tok, "", "Y", "", "minyonglee1"],
    "S10_81_endcust":    ["81", "ALL", endcust, "ALL", "", "", "Y", "", "minyonglee1"],
}

summary = {}
for name, params in SCEN.items():
    o_rc1 = conn.cursor(); o_res = conn.cursor()
    t0 = time.perf_counter()
    cur.callproc("PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION", params + [o_rc1, o_res])
    rows = o_rc1.fetchall()
    dt = time.perf_counter() - t0
    norm = sorted(repr(r) for r in rows)
    h = hashlib.sha256("\n".join(norm).encode("utf-8")).hexdigest()
    with open(os.path.join(OUT, name + ".txt"), "w", encoding="utf-8") as f:
        f.write("\n".join(norm))
    summary[name] = {"rows": len(rows), "sha256": h, "sec": round(dt, 2)}
    print(f"{name}: rows={len(rows)} sec={dt:.2f} sha={h[:16]}")

with open(os.path.join(OUT, "_summary.json"), "w", encoding="utf-8") as f:
    json.dump({"tokens": {"dept2": dept2, "site2": site2, "item": item_tok, "proj": proj_tok, "owner": owner_tok, "endcust": endcust}, "scenarios": summary}, f, ensure_ascii=False, indent=2)
print("done ->", OUT)
