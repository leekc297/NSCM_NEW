import sys,oracledb
sys.path.insert(0,'_artifacts/_diagnostics'); import ora
u,p,d=ora.conn_info(); cn=oracledb.connect(user=u,password=p,dsn=d); cur=cn.cursor()
V=sys.argv[1] if len(sys.argv)>1 else "R_S_20260823_V004"
K=['DIVISION_ID','DEPARTMENT_ID','DEPT_ID','ITEM_ID','MEASURE','YYYYMMDD','CURRENCY','COMPANY_ID','END_CUST_REPORT','CUST_REPORT','PRODUCT_GROUP','COUNTRY_CODE']
raw=" AND ".join(f"A.{k}=B.{k}" for k in K); nvl=" AND ".join(f"NVL(A.{k},'/')=NVL(B.{k},'/')" for k in K)
for nm,on in (("현행(=)",raw),("보완(NVL '/')",nvl)):
    cur.execute(f"SELECT COUNT(DISTINCT A.ROWID) FROM DM_PLN_SALES_ETC_REPORT_C A JOIN DM_PLN_SALES_ETC_REPORT_C B ON A.VERSION_NO=B.VERSION_NO AND {on} WHERE A.VERSION_NO=:v AND A.DIVISION_ID='40'",v=V)
    print(V,nm,"자기연결 성립 행:",cur.fetchone()[0])
cur.execute("SELECT COUNT(*) FROM DM_PLN_SALES_ETC_REPORT_C WHERE VERSION_NO=:v",v=V); print("전체:",cur.fetchone()[0])
