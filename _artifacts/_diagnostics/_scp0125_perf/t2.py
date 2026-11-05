import sys, time, datetime; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
B1=datetime.datetime(2026,8,30)
Q = {
'site_dates': "SELECT SITE_ID, ORG_CUTOFF_DATE, COUNT(*) FROM SCM_DNM_STOCK_AGING_V WHERE SITE_ID IS NOT NULL AND DIVISION_ID=:B2 AND ORG_CUTOFF_DATE > :B1-6 AND ORG_CUTOFF_DATE <= :B1+1 GROUP BY SITE_ID, ORG_CUTOFF_DATE ORDER BY 1,2",
'cnt_raw': "SELECT COUNT(*) FROM SCM_DNM_STOCK_AGING_V_SN WHERE DIVISION_ID=:B2 AND CUTOFF_DATE > :B1-6 AND CUTOFF_DATE <= :B1+1",
'view_nofn': "SELECT SUM(QTY), COUNT(ITEM_ID), COUNT(AVAILABLE_DATE) FROM SCM_DNM_STOCK_AGING_V WHERE SITE_ID IS NOT NULL AND DIVISION_ID=:B2 AND ORG_CUTOFF_DATE > :B1-6 AND ORG_CUTOFF_DATE <= :B1+1",
'view_fn': "SELECT SUM(QTY), COUNT(SCM_SITE_ID), COUNT(ITEM_ID) FROM SCM_DNM_STOCK_AGING_V WHERE SITE_ID IS NOT NULL AND DIVISION_ID=:B2 AND ORG_CUTOFF_DATE > :B1-6 AND ORG_CUTOFF_DATE <= :B1+1",
}
with connect('tobe') as cx:
    c=cx.cursor()
    for k,s in Q.items():
        bb={'B1':B1,'B2':'81'}
        if ':B1' not in s: bb.pop('B1')
        t=time.time(); c.execute(s,bb); r=c.fetchall(); print(k, f"{time.time()-t:.2f}s", r[:40])
