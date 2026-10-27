"""사내 재현: 81 BMW_US_SPA 조회 → 측정값 컬럼 제외 키가 같은 줄 그룹에서 값이 다른 컬럼 찾기 (조회 전용, ROLLBACK)"""
import sys, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPD_20261027"); import test_before_after as T
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
item = sys.argv[1] if len(sys.argv) > 1 else "APBMW48CL-B1-360"
for proc in T.PROCS:
  for usr in ("minyonglee1", "k0101"):
    cols, rows, rc = T.call(cur, proc, "81", "20260101", "20261231", usr, "ALL", "BMW_US_SPA"); con.rollback()
    meas = [i for i,c in enumerate(cols) if T.is_measure(c)]
    ii = cols.index("ITEM_ID") if "ITEM_ID" in cols else None
    sel = [r for r in rows if ii is None or r[ii] == item]
    print(f"== {proc[11:]} {usr} rows {len(rows)} item rows {len(sel)} rc {rc}")
    for r in sel:
        vis = {c: r[i] for i,c in enumerate(cols) if i not in meas}
        print("   ", {k: v for k, v in vis.items() if k in ("MEASURE","PLANT_SITE_ID","CELL_PROD_SITE_ID","END_CUSTOMER","CURRENCY","AS_FROM_SITE","VERSION_NO","NOTATION","SORT_KEY","EDIT_FLAG","GROUP_ID","NEW_FLAG","DOM_EXP","FCST_TYPE","INCOTERMS")},
              "nonnull buckets", [cols[i] for i in meas if r[i] not in (None, 0)][:3], "...", [cols[i] for i in meas if r[i] not in (None, 0)][-2:])
