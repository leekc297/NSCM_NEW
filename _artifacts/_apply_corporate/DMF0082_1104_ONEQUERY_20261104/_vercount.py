import sys; sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, datetime
cn = dbconn.connect("tobe", dbconn.load_cfg())
cur = cn.cursor()
print(datetime.datetime.now())
for t in ["DM_PLN_MKT_FCST_C","DM_PLN_CFM_MKT_DEMAND_PLAN_C","SCM_MST_FUTURE_PRICE_C","DM_PLN_CFM_SELLING_PRICE_C","DM_PLN_SALES_PLAN_RESULT_C","DM_PLN_SALES_PLAN_C"]:
    cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME IN ('YYYYMMDD','QTY','VERSION_NO','DIVISION_ID','CUTOFF_YYYYMMDD')", t=t)
    cols = {r[0] for r in cur}
    if 'VERSION_NO' not in cols: print(t, "cols", cols); continue
    dc = "YYYYMMDD" if 'YYYYMMDD' in cols else "CUTOFF_YYYYMMDD"
    q = f"SELECT DIVISION_ID, VERSION_NO, COUNT(*), SUM(CASE WHEN {dc} BETWEEN '20261101' AND '20270430' THEN 1 ELSE 0 END) FROM SCM_MGR.{t} WHERE DIVISION_ID IN ('40','81','82') GROUP BY DIVISION_ID, VERSION_NO ORDER BY 1,2 DESC FETCH FIRST 40 ROWS ONLY"
    cur.execute(q)
    print("==", t, "date col", dc)
    for r in cur: print("  ", r)
cur.execute("SELECT DIVISION_ID, VERSION_TYPE, VERSION_NO, YYYYMMDD FROM SCM_MGR.DM_MST_VERSION WHERE DIVISION_ID IN ('40','81','82') AND VERSION_NO >= 'MF_W_202609' ORDER BY 1,3 DESC")
print("== DM_MST_VERSION")
for r in cur: print("  ", r)
