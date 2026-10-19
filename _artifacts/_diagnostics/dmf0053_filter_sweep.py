"""dmf0053_filter_sweep.py — Project/Model/Owner 조회조건 실측 (1건 A / 1건 B / 2건 A,B vs ALL). 2026-09-14"""
import oracledb, sys, json, time, collections
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
FROM_Y, TO_Y, FROM_C, TO_C = "20260701", "20270228", "20260901", "20260914"
def call(**kw):
    p = dict(project="", item="", owner=""); p.update(kw)
    rc1, rc2, rc3, rs = (cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(4))
    args = ["81","ALL","ALL","ALL",p["project"],p["item"],"ALL",FROM_Y,TO_Y,"minyonglee1","ALL","ALL",p["owner"],"MONTHLY","","","",FROM_C,TO_C,"minyonglee1","DMF0053", rc1, rc2, rc3, rs]
    t = time.time()
    try:
        cur.callproc("PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL", args)
        c = rc1.getvalue(); cols = [d[0] for d in c.description]; rows = [dict(zip(cols, r)) for r in c.fetchall()]
    except Exception as e:
        rows = "ERR " + str(e)[:80]
    con.rollback(); return rows, time.time() - t
tag = sys.argv[1] if len(sys.argv) > 1 else "before"
allrows, sec = call(); print(f"[{tag}] ALL rows={len(allrows)} {sec:.0f}s", flush=True)
cnt = lambda key: [k for k, _ in collections.Counter(str(r.get(key)) for r in allrows if r.get(key) not in (None, "", " ")).most_common(2)]
proj, item = cnt("PROJECT_CODE"), cnt("ITEM_ID")
own = [k for k, _ in collections.Counter(str(r.get("OWNER") or "").split(",")[0] for r in allrows if r.get("OWNER")).most_common(2)] if allrows and "OWNER" in allrows[0] else []
if not own:   # 결과 컬럼에 OWNER 가 없으면 원천 마스터에서 후보
    own = [r[0] for r in cur.execute("""SELECT OWNER FROM SCM_MST_SITE_ITEM I WHERE DIVISION_ID='81' AND OWNER IS NOT NULL
             AND (SCM_SITE_ID, PROJECT_CODE, ITEM_ID) IN (SELECT SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM DM_PLN_CUST_FCST_H WHERE DIVISION_ID='81' AND CREATE_DATE BETWEEN :f AND :t)
             GROUP BY OWNER ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY""", f=FROM_C, t=TO_C).fetchall()]
print(f"[{tag}] 후보 project={proj} item={item} owner={own}", flush=True)
out = {"ALL": len(allrows)}
for key, vals in (("project", proj), ("item", item), ("owner", own)):
    if len(vals) < 2: print(key, "후보 부족", vals); continue
    a, _ = call(**{key: vals[0]}); b, _ = call(**{key: vals[1]}); ab, _ = call(**{key: ",".join(vals)})
    na, nb, nab = (len(x) if not isinstance(x, str) else x for x in (a, b, ab))
    ok = all(isinstance(x, int) for x in (na, nb, nab)) and 0 < na < len(allrows) and 0 < nb < len(allrows) and max(na, nb) <= nab < len(allrows) + 1
    print(f"[{tag}] {key:8} A={vals[0]}:{na}  B={vals[1]}:{nb}  A,B:{nab}  (ALL={len(allrows)})  -> {'필터 동작' if ok else '필터 미동작/이상'}", flush=True)
    out[key] = dict(vals=vals, a=na, b=nb, ab=nab, ok=ok)
json.dump(out, open(rf"C:\Projects\NSCM\_artifacts\_diagnostics\dmf0053_filter_sweep_{tag}.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
