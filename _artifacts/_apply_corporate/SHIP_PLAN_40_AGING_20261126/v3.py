import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("select text from all_views where owner='FP_MGR' and view_name='AGING_STOCK_V'"); print(c.fetchone()[0])
c.execute("select trunc(cutoff_date), division_id, count(*) from fp_mgr.scm_aging_stock_h where cutoff_date > date'2026-11-10' group by trunc(cutoff_date), division_id order by 1,2"); 
for r in c.fetchall(): print(r)
