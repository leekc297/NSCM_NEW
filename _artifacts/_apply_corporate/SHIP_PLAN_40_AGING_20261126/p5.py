import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor(); c.callTimeout = 200000
c.execute("""select company_id, plan_type, count(*), min(plan_date), max(plan_date), sum(case when plan_date >= date'2026-11-20' then 1 else 0 end)
 from fp_mgr.fp_daily_productioin_plan_h where division_id='40' group by company_id, plan_type order by 3 desc"""); 
for r in c.fetchall(): print(r)
