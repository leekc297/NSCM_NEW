import sys, time; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u,p,d=ora.conn_info()
import sys as _s
vt=_s.argv[1] if len(_s.argv)>1 else "Current"
params=["40","ALL","ALL","ALL","ALL","ALL","ALL","ALL","ALL","20261001","20270331","ALL","minyonglee1","minyonglee1","ALL","N","N",vt]
with oracledb.connect(user=u,password=p,dsn=d) as c:
    cur=c.cursor(); rc1=c.cursor(); rc2=c.cursor()
    t=time.time()
    try:
        cur.callproc("SCM_MGR.PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE", params+[rc1,rc2])
        r1=rc1.fetchall(); r2=rc2.fetchall()
        print(f"OK {time.time()-t:.1f}s rc1 rows={len(r1)} cols={[x[0] for x in rc1.description][:8]}... rc2 rows={len(r2)}")
        for r in r2[:3]: print("   rc2:", r)
    except Exception as e:
        print(f"ERR {time.time()-t:.1f}s", str(e)[:400])
    c.rollback()
