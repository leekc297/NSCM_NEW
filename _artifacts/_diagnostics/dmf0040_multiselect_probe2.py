import oracledb, time
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
def run(label, div, customer="ALL", plant="ALL", site="ALL", team="ALL", itype="ALL", biz="ALL"):
    rc, rs = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    args = [div, site, plant, team, customer, biz, "", "", "20260914", "20261130", "minyonglee1", "Current", itype, "", "False", "MONTHLY", "minyonglee1", "DMF0040", rc, rs]
    t = time.time()
    try:
        cur.callproc("PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON", args)
        rows = rc.getvalue().fetchall() if rc.getvalue() else []
        print(f"{label:48} rows={len(rows):4} result={rs.getvalue().fetchall() if rs.getvalue() else None} {time.time()-t:.1f}s")
    except Exception as e:
        print(f"{label:48} ERROR {str(e).splitlines()[0]} {time.time()-t:.1f}s")
    con.rollback()
# 81 Plant Site 후보
p81 = [r[0] for r in cur.execute("SELECT PLANT_SITE_ID FROM DM_PLN_MKT_FCST WHERE DIVISION_ID='81' AND YYYYMMDD BETWEEN '20260914' AND '20261130' AND QTY<>0 GROUP BY PLANT_SITE_ID ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY").fetchall()]
run(f"81 Plant 1건 {p81[0]}", "81", plant=p81[0])
if len(p81) > 1: run(f"81 Plant 2건 {p81[0]},{p81[1]}", "81", plant=",".join(p81))
# 40 End Customer(=PROJECT_CODE LIKE) 후보
c40 = [r[0] for r in cur.execute("SELECT PROJECT_CODE FROM DM_PLN_MKT_FCST WHERE DIVISION_ID='40' AND YYYYMMDD BETWEEN '20260914' AND '20261130' AND QTY<>0 GROUP BY PROJECT_CODE ORDER BY COUNT(*) DESC FETCH FIRST 2 ROWS ONLY").fetchall()]
print("40 PROJECT_CODE 후보", c40)
run("40 ALL", "40")
if c40:
    run(f"40 End Customer 1건 {c40[0]}", "40", customer=c40[0])
    if len(c40) > 1:
        run(f"40 End Customer 1건 {c40[1]}", "40", customer=c40[1])
        run(f"40 End Customer 2건", "40", customer=",".join(c40))
