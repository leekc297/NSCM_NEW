import sys, time, datetime; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
Q={
'grp': "SELECT SITE_ID, MAX(CUTOFF_DATE) FROM SCM_DNM_STOCK_AGING_V_SN WHERE DIVISION_ID=:B2 AND SITE_ID IS NOT NULL AND CUTOFF_DATE > :B1-6 AND CUTOFF_DATE <= :B1+1 GROUP BY SITE_ID",
'pk': "SELECT /*+ INDEX(A PK_SCM_AGING_STOCK_H) */ SITE_ID, MAX(CUTOFF_DATE) FROM FP_MGR.SCM_AGING_STOCK_H A WHERE DIVISION_ID=:B2 AND SITE_ID IS NOT NULL AND CUTOFF_DATE > :B1-6 AND CUTOFF_DATE <= :B1+1 GROUP BY SITE_ID",
'tbl': "SELECT SITE_ID, MAX(CUTOFF_DATE) FROM FP_MGR.SCM_AGING_STOCK_H A WHERE DIVISION_ID=:B2 AND SITE_ID IS NOT NULL AND CUTOFF_DATE > :B1-6 AND CUTOFF_DATE <= :B1+1 GROUP BY SITE_ID",
}
with connect('tobe') as cx:
    c=cx.cursor(); B1=datetime.datetime(2026,8,30)
    for k,s in Q.items():
        for _ in range(2):
            t=time.time(); c.execute(s,B1=B1,B2=sys.argv[1]); r=c.fetchall(); print(k,f"{time.time()-t:.2f}s",r)
    c.execute("EXPLAIN PLAN FOR "+Q['grp'])
    c.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY(NULL,NULL,'BASIC +ROWS +PREDICATE'))"); print('\n'.join(r[0] for r in c))
