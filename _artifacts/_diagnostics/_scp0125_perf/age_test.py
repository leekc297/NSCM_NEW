import sys, time, datetime; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
div, cut, uc = sys.argv[1], sys.argv[2], sys.argv[3]   # cut = V_CUTOFF_DAY (plan start -1)
B1 = datetime.datetime.strptime(cut,'%Y%m%d')
COLS = """IA.DIVISION_ID, IA.SCM_SITE_ID, IA.PLANT_ID, IA.ITEM_ID, IA.AVAILABLE_DATE, IA.WIPHOLD_YN, IA.CUTOFF_DATE, IA.SITE_ID, IA.K_LINE_ID, IA.K_BEFORE_DEGAS, SUM(IA.QTY) QTY"""
INNER = """SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PLANT_ID, A.ITEM_ID, A.AVAILABLE_DATE, A.WIPHOLD_YN, A.CUTOFF_DATE, A.SITE_ID
     , CASE WHEN :B3 = 'Y' THEN A.LINE_ID END AS K_LINE_ID, CASE WHEN :B3 = 'Y' THEN A.BEFORE_DEGAS END AS K_BEFORE_DEGAS, A.QTY
     , MAX(CASE WHEN A.CUTOFF_DATE > :B1 - 7 AND A.CUTOFF_DATE <= :B1 THEN A.CUTOFF_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.SITE_ID) AS MAX_CUTOFF_DATE
  FROM SCM_DNM_STOCK_AGING_V A
 WHERE A.SITE_ID IS NOT NULL AND A.DIVISION_ID = :B2 AND A.ORG_CUTOFF_DATE > :B1 - 6 AND A.ORG_CUTOFF_DATE <= :B1 + 1"""
EXTRA = """
   AND (A.SITE_ID, A.ORG_CUTOFF_DATE) IN (SELECT XA.SITE_ID, MAX(XA.ORG_CUTOFF_DATE)
                                            FROM SCM_DNM_STOCK_AGING_V XA
                                           WHERE XA.SITE_ID IS NOT NULL AND XA.DIVISION_ID = :B2
                                             AND XA.ORG_CUTOFF_DATE > :B1 - 6 AND XA.ORG_CUTOFF_DATE <= :B1 + 1
                                           GROUP BY XA.SITE_ID)"""
GB = " ) IA WHERE IA.CUTOFF_DATE = IA.MAX_CUTOFF_DATE GROUP BY IA.DIVISION_ID, IA.SCM_SITE_ID, IA.PLANT_ID, IA.ITEM_ID, IA.AVAILABLE_DATE, IA.WIPHOLD_YN, IA.CUTOFF_DATE, IA.SITE_ID, IA.K_LINE_ID, IA.K_BEFORE_DEGAS"
OLD = f"SELECT {COLS} FROM ({INNER}{GB}"
NEW = f"SELECT {COLS} FROM ({INNER}{EXTRA}{GB}"
b = dict(B1=B1, B2=div, B3=uc)
with connect('tobe') as cx:
    c = cx.cursor()
    res = {}
    for nm, sql in (('OLD',OLD),('NEW',NEW),('OLD',OLD),('NEW',NEW)):
        t=time.time(); c.execute(sql, b); rows=c.fetchall(); res[nm]=rows; print(nm, f"{time.time()-t:.2f}s rows={len(rows)}")
    from collections import Counter
    o, n = Counter(res['OLD']), Counter(res['NEW'])
    print('OLD-NEW', sum((o-n).values()), 'NEW-OLD', sum((n-o).values()), 'qty', sum(r[-1] or 0 for r in res['OLD']), sum(r[-1] or 0 for r in res['NEW']))
