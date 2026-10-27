"""[E20261027-CELLPRODDASH] DMF0082 조회 전후 비교 (조회 프로시저만 호출 · ROLLBACK)
  python test_snapshot.py before|after
  기대: 임시 테이블에 '/'·공백 Cell Prod 가 없던 케이스 = 완전 동일 / 있던 케이스 = '/'→'-' 외 동일하고 보이는 키 중복 감소
"""
import sys, os, pickle, hashlib, collections
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPD_20261027"); import test_before_after as T
HERE = os.path.dirname(os.path.abspath(__file__)); SNAP = os.path.join(HERE, "_snap_before.pkl")
CASES = [("81", "20260701", "20261231", "ALL", "HKMC_KR_ASA"), ("81", "20260101", "20261231", "ALL", "BMW_US_SPA"),
         ("82", "20261001", "20261231", "ALL", "NextEra_US_PHX"), ("82", "20261001", "20261231", "ALL", "FPL_US_PHX"),
         ("40", "20260701", "20270331", "acer", "acer_CN_CKG")]
USERS = ["minyonglee1", "k0101"]
mode = sys.argv[1]
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE '%E20261027-CELLPRODDASH%'")
mk = cur.fetchone()[0]
if (mode == "before") != (mk == 0): sys.exit(f"ABORT mode={mode} marker={mk}")
def norm(v): return "-" if v == "/" or (v is not None and str(v).strip() == "") else v
res = {}
for proc in T.PROCS:
    for div, f, t, cust, site in CASES:
        for usr in USERS:
            cols, rows, rc = T.call(cur, proc, div, f, t, usr, cust, site)
            gtt = "GT_DMF0082_MF_SP" if proc == T.PROCS[0] else "GTT_MF_SP"
            cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{gtt} WHERE CELL_PROD_SITE_ID = '/' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL)")
            slash = cur.fetchone()[0]
            con.rollback()
            ci = cols.index("CELL_PROD_SITE_ID") if "CELL_PROD_SITE_ID" in cols else None
            rows_n = [tuple(norm(v) if i == ci else v for i, v in enumerate(r)) for r in rows]
            vis = [i for i, c in enumerate(cols) if not T.is_measure(c)]
            g = collections.Counter(tuple(r[i] for i in vis) for r in rows_n)
            res[(proc, div, site, usr)] = {"n": len(rows), "full": T.digest(cols, rows), "slash_gtt": slash,
                                           "keydup": sum(v - 1 for v in g.values() if v > 1), "cp_vals": sorted({str(r[ci]) for r in rows})[:6] if ci is not None else None,
                                           "rows_n": rows_n, "cols": cols}
            print(f"  {proc[11:]:22s} {div} {site:16s} {usr:12s} rows {len(rows):5d} GTT '/'행 {slash:5d} CP값 {res[(proc,div,site,usr)]['cp_vals']}", flush=True)
if mode == "before":
    pickle.dump(res, open(SNAP, "wb")); print("SAVED", len(res)); sys.exit(0)
bef = pickle.load(open(SNAP, "rb")); fail = 0
for k, a in res.items():
    b = bef[k]
    if b["slash_gtt"] == 0:
        ok = a["full"] == b["full"]; note = "GTT '/' 없음 → 적용 전과 완전 동일"
    else:
        # '/' 를 '-' 로 읽은 적용 전 결과에서 중복 키를 합친 것과 같은지는 피벗 재집계라 직접 비교 불가 → 줄 수 감소량 = 적용 전 정규화 중복 수, CP 값에 '/' 없음
        ok = a["n"] == b["n"] - b["keydup"] and "/" not in (a["cp_vals"] or []) and a["slash_gtt"] == 0
        note = f"GTT '/' {b['slash_gtt']}행 → 0 · 줄 {b['n']}→{a['n']} (정규화 중복 {b['keydup']}) · CP {a['cp_vals']}"
    fail += not ok
    print("PASS" if ok else "FAIL", "|", k[0][11:], k[1], k[2], k[3], "|", note)
print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
