import oracledb, time
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
# 81 사업부에서 MKT_FCST 데이터가 있는 End Customer 상위 3개
ecs = cur.execute("""SELECT P.END_CUSTOMER, COUNT(*) FROM DM_PLN_MKT_FCST F JOIN SCM_MST_SITE P ON P.DIVISION_ID=F.DIVISION_ID AND P.SCM_SITE_ID=F.SCM_SITE_ID
                     WHERE F.DIVISION_ID='81' AND F.YYYYMMDD BETWEEN '20260914' AND '20261130' AND F.QTY<>0 GROUP BY P.END_CUSTOMER ORDER BY 2 DESC FETCH FIRST 3 ROWS ONLY""").fetchall()
print("END_CUSTOMER 후보", ecs)
def run(customer):
    rc, rs = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    args = ["81","ALL","ALL","ALL",customer,"ALL","","","20260914","20261130","minyonglee1","Current","ALL","","False","MONTHLY","minyonglee1","DMF0040", rc, rs]
    t = time.time()
    try:
        cur.callproc("PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON", args)
        res = rs.getvalue().fetchall() if rs.getvalue() else None
        rows = rc.getvalue().fetchall() if rc.getvalue() else []
        print(f"P_CUSTOMER={customer!r:40} rows={len(rows)} result={res} sec={time.time()-t:.1f}")
    except Exception as e:
        print(f"P_CUSTOMER={customer!r:40} ERROR {e} sec={time.time()-t:.1f}")
    con.rollback()
print(cur.execute("SELECT position, argument_name FROM user_arguments WHERE package_name='PKG_DMF0040' AND object_name='P_DMF0040_GET_MKT_FCST_COMPARISON' ORDER BY position").fetchall())
run("ALL"); run(ecs[0][0]); run(ecs[1][0]); run(ecs[0][0] + "," + ecs[1][0])

