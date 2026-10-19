"""dmf0040_multiselect_sweep.py — 멀티선택 조회조건 전수: 1건 A / 1건 B / 2건 A,B 행수 실측 (PKG_DMF0040 직접 호출). 2026-09-14
판정: IN 계열 = rows(A,B) == rows(A)+rows(B) (키 비중복) / LIKE 계열 = rows(A,B) >= max(A,B) 이고 > 0"""
import oracledb, time, sys, json
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
FROM, TO = "20260914", "20261130"
def call(div, **kw):
    p = dict(site="ALL", plant="ALL", team="ALL", customer="ALL", biz="ALL", project="", item="", itype="ALL", owner="")
    p.update(kw)
    rc, rs = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    args = [div, p["site"], p["plant"], p["team"], p["customer"], p["biz"], p["project"], p["item"], FROM, TO, "minyonglee1", "Current", p["itype"], p["owner"], "False", "MONTHLY", "minyonglee1", "DMF0040", rc, rs]
    try:
        cur.callproc("PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON", args)
        n = len(rc.getvalue().fetchall()) if rc.getvalue() else 0
    except Exception as e:
        n = "ERR " + str(e).split("SQLERRM=")[-1].split(" /")[0][:40]
    con.rollback(); return n
def pick(sql):
    return [r[0] for r in cur.execute(sql).fetchall()]
cases = []
for div in ("81", "40"):
    base = f"FROM DM_PLN_MKT_FCST F WHERE F.DIVISION_ID='{div}' AND F.YYYYMMDD BETWEEN '{FROM}' AND '{TO}' AND F.QTY<>0"
    cases += [
        (div, "site", "IN", pick(f"SELECT F.SCM_SITE_ID {base} GROUP BY F.SCM_SITE_ID ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY")),
        (div, "plant", "IN", pick(f"SELECT F.PLANT_SITE_ID {base} GROUP BY F.PLANT_SITE_ID ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY")),
        (div, "team", "IN", pick(f"SELECT I.DEPT_ID {base.replace('WHERE', 'JOIN SCM_MST_SITE_ITEM I ON I.DIVISION_ID=F.DIVISION_ID AND I.PROJECT_CODE=F.PROJECT_CODE AND I.SCM_SITE_ID=F.SCM_SITE_ID AND I.ITEM_ID=F.ITEM_ID WHERE I.DEPT_ID IS NOT NULL AND')} GROUP BY I.DEPT_ID ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY")),
        (div, "customer", "IN" if div != "40" else "LK",
            pick(f"SELECT S.END_CUSTOMER {base.replace('WHERE', 'JOIN SCM_MST_SITE S ON S.DIVISION_ID=F.DIVISION_ID AND S.SCM_SITE_ID=F.SCM_SITE_ID WHERE')} GROUP BY S.END_CUSTOMER ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY") if div != "40"
            else pick(f"SELECT F.PROJECT_CODE {base} GROUP BY F.PROJECT_CODE ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY")),
        (div, "itype", "IN", ["P", "H"]),
        (div, "project", "LK", pick(f"SELECT F.PROJECT_CODE {base} GROUP BY F.PROJECT_CODE ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY")),
        (div, "item", "LK", pick(f"SELECT F.ITEM_ID {base} GROUP BY F.ITEM_ID ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY")),
    ]
tag = sys.argv[1] if len(sys.argv) > 1 else "before"
out = []
for div, key, kind, vals in cases:
    if len(vals) < 2: print(div, key, "후보 부족", vals); continue
    t = time.time()
    a, b, ab = call(div, **{key: vals[0]}), call(div, **{key: vals[1]}), call(div, **{key: ",".join(vals)})
    if isinstance(ab, str) or isinstance(a, str) or isinstance(b, str): verdict = "ERROR"
    elif kind == "IN": verdict = "OK" if ab == a + b else "NG"
    else: verdict = "OK" if ab > 0 and ab >= max(a, b) else "NG"
    print(f"[{tag}] div{div} {key:8} {kind} A={vals[0]}:{a}  B={vals[1]}:{b}  A,B:{ab}  -> {verdict}  ({time.time()-t:.0f}s)", flush=True)
    out.append(dict(div=div, key=key, kind=kind, vals=vals, a=a, b=b, ab=ab, verdict=verdict))
json.dump(out, open(rf"C:\Projects\NSCM\_artifacts\_diagnostics\dmf0040_multiselect_sweep_{tag}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
