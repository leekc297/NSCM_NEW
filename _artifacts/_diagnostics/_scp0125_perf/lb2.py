import sys, time, datetime; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
RS = """SELECT MIN(MAX_DT) FROM (SELECT SITE_ID, MAX(CUTOFF_DATE) AS MAX_DT FROM SCM_DNM_STOCK_AGING_V_SN
         WHERE DIVISION_ID = :B2 AND SITE_ID IS NOT NULL AND CUTOFF_DATE > :B1 - 6 AND CUTOFF_DATE <= :B1 + 1 GROUP BY SITE_ID)"""
RSL = """SELECT SITE_ID FROM SCM_DNM_STOCK_AGING_V_SN WHERE DIVISION_ID = :B2 AND SITE_ID IS NOT NULL AND CUTOFF_DATE > :B1 - 6 AND CUTOFF_DATE <= :B1 + 1 GROUP BY SITE_ID"""
VL = """SELECT A.SITE_ID, MAX(A.ORG_CUTOFF_DATE) FROM SCM_DNM_STOCK_AGING_V A
   WHERE A.SITE_ID = :S AND A.DIVISION_ID = :B2 AND A.ORG_CUTOFF_DATE > :B1 - 6 AND A.ORG_CUTOFF_DATE <= :B1 + 1 GROUP BY A.SITE_ID"""
with connect('tobe') as cx:
    c=cx.cursor(); B1=datetime.datetime.strptime(sys.argv[1],'%Y%m%d')
    for d in sys.argv[2:]:
        t=time.time(); c.execute(RS,B1=B1,B2=d); print(d,'RS',f"{time.time()-t:.2f}s",c.fetchall())
        t=time.time(); c.execute(RSL,B1=B1,B2=d); print(d,'RSL',f"{time.time()-t:.2f}s",c.fetchall())
        for s in ('A009','A003'):
            t=time.time(); c.execute(VL,S=s,B1=B1,B2=d); print(d,'VL',s,f"{time.time()-t:.2f}s",c.fetchall())
