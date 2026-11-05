import sys, time, datetime; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
LB = """
WITH RS AS (SELECT SITE_ID, MAX(CUTOFF_DATE) AS MAX_DT
              FROM SCM_DNM_STOCK_AGING_V_SN
             WHERE DIVISION_ID = :B2 AND SITE_ID IS NOT NULL
               AND CUTOFF_DATE > :B1 - 6 AND CUTOFF_DATE <= :B1 + 1
             GROUP BY SITE_ID)
SELECT MIN(MAX_DT) FROM (
  SELECT MAX_DT FROM RS
  UNION ALL
  SELECT MAX(A.ORG_CUTOFF_DATE)
    FROM SCM_DNM_STOCK_AGING_V A
   WHERE A.SITE_ID IS NOT NULL AND A.DIVISION_ID = :B2
     AND A.ORG_CUTOFF_DATE > :B1 - 6 AND A.ORG_CUTOFF_DATE <= :B1 + 1
     AND NOT EXISTS (SELECT 1 FROM RS WHERE RS.SITE_ID = A.SITE_ID)
   GROUP BY A.SITE_ID)"""
with connect('tobe') as cx:
    c=cx.cursor()
    for d in sys.argv[2:]:
        for _ in range(2):
            t=time.time(); c.execute(LB, B1=datetime.datetime.strptime(sys.argv[1],'%Y%m%d'), B2=d); r=c.fetchall(); print(d, f"{time.time()-t:.2f}s", r)
