import sys,oracledb
sys.path.insert(0,'_artifacts/_diagnostics'); import ora
u,p,d=ora.conn_info(); cn=oracledb.connect(user=u,password=p,dsn=d); cur=cn.cursor()
V="R_S_20260823_V004"
cur.execute("SELECT DIVISION_ID,COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v GROUP BY DIVISION_ID",v=V); print(cur.fetchall())
cols=['DIVISION_ID','DEPARTMENT_ID','DEPT_ID','ITEM_ID','MEASURE','YYYYMMDD','CURRENCY','COMPANY_ID','END_CUST_REPORT','CUST_REPORT','PRODUCT_GROUP','COUNTRY_CODE']
for c in cols:
    cur.execute(f"SELECT SUM(CASE WHEN {c} IS NULL THEN 1 ELSE 0 END),SUM(CASE WHEN {c}='/' THEN 1 ELSE 0 END),SUM(CASE WHEN {c}='-' THEN 1 ELSE 0 END),SUM(CASE WHEN {c} IS NOT NULL AND TRIM({c}) IS NULL THEN 1 ELSE 0 END),SUM(CASE WHEN {c}<>RTRIM({c}) AND TRIM({c}) IS NOT NULL THEN 1 ELSE 0 END) FROM DM_PLN_SALES_ETC_REPORT_C")
    print(c,"ALL NULL,/,-,space,trailsp=",cur.fetchone())
