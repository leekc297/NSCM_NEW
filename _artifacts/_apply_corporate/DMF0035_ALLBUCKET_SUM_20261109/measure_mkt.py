# MKT 메인 SP 실측 — 기간·버킷별 컬럼 수/행 수/소요/오류 (조회 전용)
import sys, time, datetime, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics'); import ora
u,p,d = ora.conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
def run(div, frm, to, bucket):
    rc = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(4)]
    args = [div,'ALL','ALL','ALL','', '', 'ALL', frm, to, 'minyonglee1','ALL','ALL','', 'CURRENT', bucket, '', '', 'N','ALL','minyonglee1','DMF0035'] + rc
    t=time.time()
    try:
        cur.callproc('PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL', args)
        c1 = rc[0].getvalue(); cols=[x[0] for x in c1.description]; rows=c1.fetchall()
        res = rc[3].getvalue().fetchall()
        per = [c for c in cols if c[:2] in ('D_','W_','M_')]
        out = f"cols={len(cols)} D={sum(c.startswith('D_') for c in per)} W={sum(c.startswith('W_') for c in per)} M={sum(c.startswith('M_') for c in per)} rows={len(rows)} res={res[:1]}"
    except Exception as e:
        out = "ERR " + str(e).splitlines()[0][:200]
    con.rollback()
    print(f"{datetime.datetime.now():%H:%M:%S} div={div} {frm}~{to} {bucket:8} {time.time()-t:7.2f}s {out}", flush=True)
for spec in sys.argv[1:]:
    div, frm, to, bucket = spec.split(':'); run(div, frm, to, bucket)
