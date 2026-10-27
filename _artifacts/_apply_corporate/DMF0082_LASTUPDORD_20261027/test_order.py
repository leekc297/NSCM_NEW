"""[E20261027-DMF0082LASTUPDORD] 줄 순서 비교 (조회 프로시저만 · Column Set 행은 같은 세션 INSERT 후 ROLLBACK)
  before/after — 기대: BASE 줄 순서 완전 동일 · BY/DATE/BOTH 의 키 순서(두 컬럼 제외) = BASE 키 순서"""
import sys, os, pickle
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPD_20261027"); import test_before_after as T
HERE = os.path.dirname(os.path.abspath(__file__)); SNAP = os.path.join(HERE, "_order_before.pkl")
mode = sys.argv[1]
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
cur.execute("SELECT COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type='PACKAGE BODY' AND text LIKE '%E20261027-DMF0082LASTUPDORD%'")
mk = cur.fetchone()[0]
if (mode == "before") != (mk == 0): sys.exit(f"ABORT mode={mode} marker={mk}")
res = {}
for proc in T.PROCS:
    for div, f, t, cust, site, users in T.CASES:
        for usr in users:
            for vn, add in T.VARIANTS.items():
                for c in add:
                    cur.execute("INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (:u,'DMF0082','FcstNPrice','C',:c,:s,'N','admin',SYSDATE,'admin',SYSDATE)", u=usr, c=c, s=T.SORTNO[c])
                cols, rows, rc = T.call(cur, proc, div, f, t, usr, cust, site); con.rollback()
                kn = [c for c in cols if c not in T.LU and not T.is_measure(c)]
                ki = [cols.index(c) for c in sorted(kn)]
                res[(proc, div, usr, vn)] = {"seq": [tuple(r[i] for i in ki) for r in rows], "full": [tuple(r) for r in rows]}
                print(f"  {proc[11:]:22s} {div} {usr:12s} {vn:4s} rows {len(rows)}", flush=True)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_INQUIRY_COLUMN_TYPE_CODE='C' AND COLUMN_NAME IN ('LAST_UPDATED_BY','LAST_UPDATE_DATE')")
print("잔존 테스트 Column Set 행:", cur.fetchone()[0])
if mode == "before":
    pickle.dump(res, open(SNAP, "wb"))
    for k, v in res.items():
        if k[3] != "BASE": print(f"  [적용 전] {k[0][11:]:22s} {k[1]} {k[2]:12s} {k[3]:4s} 키 순서 = BASE {v['seq'] == res[k[:3] + ('BASE',)]['seq']}")
    sys.exit(0)
bef = pickle.load(open(SNAP, "rb")); fail = 0
for k, a in res.items():
    if k[3] == "BASE":
        ok = a["full"] == bef[k]["full"]; note = "적용 전과 줄 순서·값 완전 동일"
    else:
        ok = a["seq"] == res[k[:3] + ("BASE",)]["seq"]; note = f"키 순서 = BASE (적용 전 {bef[k]['seq'] == bef[k[:3] + ('BASE',)]['seq']})"
    fail += not ok
    print("PASS" if ok else "FAIL", "|", k[0][11:], k[1], k[2], k[3], "|", note)
print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
