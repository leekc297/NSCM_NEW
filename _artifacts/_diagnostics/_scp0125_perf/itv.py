import sys, time; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
base="SELECT DIVISION_ID, RESULT_TYPE, ITEM_ID, TO_SCM_SITE_ID, FROM_SCM_SITE_ID, FINAL_INCOTERMS, ETA_DATE, DELIVERY_QTY, PROJECT_CODE FROM SCM_DNM_INTRANSIT_V WHERE TO_SCM_SITE_ID IS NOT NULL AND DIVISION_ID = :d AND RESULT_DATE = :r AND "
Q={'IN':base+"RESULT_TYPE IN ('I','C')", 'I':base+"RESULT_TYPE = 'I'", 'C':base+"RESULT_TYPE = 'C'"}
with connect('tobe') as cx:
    c=cx.cursor()
    for k,s in Q.items():
        for _ in range(2):
            t=time.time(); c.execute(s,d='81',r='20260816'); r=c.fetchall(); print(k,f"{time.time()-t:.2f}s",len(r))
