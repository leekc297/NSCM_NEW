"""dmf0040_multiselect_sweep3.py — Biz Type 멀티선택 (후보 = 원천: 81 SCM_MST_PROJECT.BIZ_TYPE / 40 SCM_MST_ITEM_SN.FORECAST_INFO_BIZ_TYPE). 2026-09-14"""
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
Q = {"81": """SELECT P.BIZ_TYPE FROM DM_PLN_MKT_FCST F JOIN SCM_MST_PROJECT P ON P.DIVISION_ID=F.DIVISION_ID AND P.PROJECT_CODE=F.PROJECT_CODE
              WHERE F.DIVISION_ID='81' AND F.YYYYMMDD BETWEEN :f AND :t AND F.QTY<>0 AND P.BIZ_TYPE IS NOT NULL GROUP BY P.BIZ_TYPE ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY""",
     "40": """SELECT I.FORECAST_INFO_BIZ_TYPE FROM DM_PLN_MKT_FCST F JOIN SCM_MST_ITEM_SN I ON I.DIVISION_ID=F.DIVISION_ID AND I.ITEM_ID=F.ITEM_ID
              WHERE F.DIVISION_ID='40' AND F.YYYYMMDD BETWEEN :f AND :t AND F.QTY<>0 AND I.FORECAST_INFO_BIZ_TYPE IS NOT NULL GROUP BY I.FORECAST_INFO_BIZ_TYPE ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY"""}
for div in ("81", "40"):
    vals = [r[0] for r in cur.execute(Q[div], f=FROM, t=TO).fetchall()]
    if len(vals) < 2: print(div, "biz 후보 부족", vals, flush=True); continue
    a, b, ab = call(div, biz=vals[0]), call(div, biz=vals[1]), call(div, biz=",".join(vals))
    v = "ERROR" if any(isinstance(x, str) for x in (a, b, ab)) else ("OK" if ab == a + b else "NG")
    print(f"[{tag}] div{div} biz      IN A={vals[0]}:{a}  B={vals[1]}:{b}  A,B:{ab}  -> {v}", flush=True)
    out.append(dict(div=div, key="biz", kind="IN", vals=vals, a=a, b=b, ab=ab, verdict=v))
json.dump(out, open(rf"C:\Projects\NSCM\_artifacts\_diagnostics\dmf0040_multiselect_sweep3_{tag}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)