"""같은 실행 안 BASE → BY/DATE/BOTH → BASE 재호출: BASE 안정 + 변형의 줄 수·키·메저 = BASE + 키당 두 컬럼 1쌍 (적용 후 상태, 적용 전 스냅샷 불필요)"""
import sys, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import test_before_after as T
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
def run(proc, div, f, t, cust, site, usr, add):
    for c in add:
        cur.execute("INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (:u,'DMF0082','FcstNPrice','C',:c,:s,'N','admin',SYSDATE,'admin',SYSDATE)", u=usr, c=c, s=T.SORTNO[c])
    cols, rows, _ = T.call(cur, proc, div, f, t, usr, cust, site); con.rollback()
    return cols, rows
fail = 0
for proc in T.PROCS:
    for div, f, t, cust, site, users in T.CASES:
        for usr in users:
            c0, r0 = run(proc, div, f, t, cust, site, usr, ())
            res = {vn: run(proc, div, f, t, cust, site, usr, add) for vn, add in T.VARIANTS.items() if vn != "BASE"}
            c1, r1 = run(proc, div, f, t, cust, site, usr, ())
            stable = T.digest(c0, r0) == T.digest(c1, r1)
            for vn, (c, r) in res.items():
                one = all(len(v) == 1 for v in T.keyed(c, r).values())
                ok = stable and len(r) == len(r0) and T.digest(c, r, T.LU) == T.digest(c0, r0) and one
                fail += not ok
                print("PASS" if ok else "FAIL", f"| {proc[11:]:22s} | {div} | {usr:12s} | {vn:4s} | BASE {len(r0)}→{len(r1)} 안정 {stable} | 변형 {len(r)} 줄 | 키·메저=BASE {T.digest(c, r, T.LU) == T.digest(c0, r0)} | 키당 1쌍 {one}", flush=True)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_INQUIRY_COLUMN_TYPE_CODE='C' AND COLUMN_NAME IN ('LAST_UPDATED_BY','LAST_UPDATE_DATE')")
print("잔존 테스트 Column Set 행:", cur.fetchone()[0]); print("RESULT", "PASS" if fail == 0 else f"FAIL {fail}")
