"""DMF0022 Waterfall 40 smoke — SCUD_CN_FOC / MCCM348014A3 · 결과 커서의 INCOTERMS×CURRENCY×MEASURE 분포"""
import sys, json, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb

u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("""SELECT PARAMS FROM (SELECT PARAMS FROM SCM_MGR.SCM_COM_SQL_LOG
                    WHERE DBMS_LOB.INSTR(SQL_TEXT,'P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL')>0
                      AND DBMS_LOB.INSTR(PARAMS,'"divisionId":"40"')>0 ORDER BY CREATE_DATE DESC) WHERE ROWNUM=1""")
    raw = cur.fetchone()[0].read()
    prm = json.loads(raw)
    keys = ["divisionId","deptId","endCustomer","scmSiteId","projectCode","itemId","itemType","fromYyyymmdd",
            "nowYyyymmdd","toYyyymmdd","sesUserId","plantSiteId","bizType","owner","internalYn","cellYn",
            "versionType","bucket","userDeptId","groupId","userId","mnuId"]
    print({k: prm.get(k) for k in keys})
    prm["scmSiteId"] = "SCUD_CN_FOC"; prm["itemId"] = "MCCM348014A3"
    if len(sys.argv) > 1: prm["versionType"], prm["fromYyyymmdd"], prm["nowYyyymmdd"], prm["toYyyymmdd"] = sys.argv[1:5]
    args = [prm.get(k) if prm.get(k) not in (None, "") else None for k in keys]
    rc1, rc2, rc3 = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    cur.callproc("SCM_MGR.PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL", args + [rc1, rc2, rc3])
    for nm, v in (("RESULT", rc3),):
        r = v.getvalue(); print(nm, [x[0] for x in r.description]); print(r.fetchall())
    r = rc1.getvalue(); cols = [x[0] for x in r.description]; rows = r.fetchall()
    print("O_RC1 rows", len(rows)); print(cols[:30])
    ci = {n.upper(): i for i, n in enumerate(cols)}
    agg = {}
    for row in rows:
        k = tuple(str(row[ci[n]]) if n in ci else "?" for n in ("VERSION_NO","INCOTERMS","CURRENCY","MEASURE"))
        agg[k] = agg.get(k, 0) + 1
    for k in sorted(agg): print(k, agg[k])


    for row in rows:
        if str(row[ci["INCOTERMS"]]) == "DAP" and str(row[ci["MEASURE"]]) in ("RTF_SYS_RP", "RTF_PR"):
            nz = {cols[i]: v for i, v in enumerate(row) if cols[i][:2] == "M_" and v not in (None, 0)}
            print("BUCKET", row[ci["CURRENCY"]], row[ci["MEASURE"]], "months", len(nz), "sum", sum(nz.values()), nz)
