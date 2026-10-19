"""dmf0040_multiselect_sweep2.py — Biz Type / Owner 멀티선택 (후보 = ALL 조회 결과 실값). 2026-09-14"""
import oracledb, sys, json, collections, time
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
FROM, TO = "20260914", "20261130"
def call(div, rows=False, **kw):
    p = dict(site="ALL", plant="ALL", team="ALL", customer="ALL", biz="ALL", project="", item="", itype="ALL", owner=""); p.update(kw)
    rc, rs = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    args = [div, p["site"], p["plant"], p["team"], p["customer"], p["biz"], p["project"], p["item"], FROM, TO, "minyonglee1", "Current", p["itype"], p["owner"], "False", "MONTHLY", "minyonglee1", "DMF0040", rc, rs]
    try:
        cur.callproc("PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON", args)
        c = rc.getvalue(); cols = [d[0] for d in c.description]; data = [dict(zip(cols, r)) for r in c.fetchall()]
        res = data if rows else len(data)
    except Exception as e:
        res = "ERR " + str(e).split("SQLERRM=")[-1].split(" /")[0][:40]
    con.rollback(); return res
tag = sys.argv[1] if len(sys.argv) > 1 else "before"
out = []
for div in ("81", "40"):
    allrows = call(div, rows=True)
    if isinstance(allrows, str): print(div, "ALL", allrows); continue
    bizcol = "BIZ_TYPE" if div != "40" else "FORECAST_INFO_BIZ_TYPE"
    biz = [k for k, _ in collections.Counter(r.get(bizcol) for r in allrows if r.get(bizcol)).most_common(2)]
    own = [k for k, _ in collections.Counter((r.get("OWNER") or "").split(",")[0] for r in allrows if r.get("OWNER")).most_common(2)]
    print(f"[{tag}] div{div} ALL rows={len(allrows)} biz({bizcol})={biz} owner={own} cols={[c for c in allrows[0].keys() if 'BIZ' in c or 'OWNER' in c] if allrows else None}", flush=True)
    for key, kind, vals in (("biz", "IN", biz), ("owner", "LK", own)):
        if len(vals) < 2: print(div, key, "후보 부족", vals); continue
        a, b, ab = call(div, **{key: vals[0]}), call(div, **{key: vals[1]}), call(div, **{key: ",".join(vals)})
        if any(isinstance(x, str) for x in (a, b, ab)): v = "ERROR"
        elif kind == "IN": v = "OK" if ab == a + b else "NG"
        else: v = "OK" if ab > 0 and ab >= max(a, b) else "NG"
        print(f"[{tag}] div{div} {key:8} {kind} A={vals[0]}:{a}  B={vals[1]}:{b}  A,B:{ab}  -> {v}", flush=True)
        out.append(dict(div=div, key=key, kind=kind, vals=vals, a=a, b=b, ab=ab, verdict=v))
json.dump(out, open(rf"C:\Projects\NSCM\_artifacts\_diagnostics\dmf0040_multiselect_sweep2_{tag}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
