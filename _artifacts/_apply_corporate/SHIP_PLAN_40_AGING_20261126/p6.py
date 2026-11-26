import sys, io
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
sel = io.open('p_sel_old.sql', encoding='utf-8').read()
c = dbconn.connect('tobe').cursor(); c.callTimeout = 120000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2"); c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
q = sel.replace(':V_DIVISION_ID', "'40'").replace(':V_COMPANY_ID', "'HQ00'")
c.execute("DELETE FROM PLAN_TABLE WHERE STATEMENT_ID = 'P23OLD'")
c.execute("EXPLAIN PLAN SET STATEMENT_ID = 'P23OLD' FOR " + q)
c.execute("""SELECT ID, LPAD(' ', 2*DEPTH) || OPERATION || ' ' || OPTIONS, OBJECT_NAME, CARDINALITY, COST, SUBSTR(ACCESS_PREDICATES,1,120), SUBSTR(FILTER_PREDICATES,1,100)
 FROM PLAN_TABLE WHERE STATEMENT_ID='P23OLD' AND PLAN_ID=(SELECT MAX(PLAN_ID) FROM PLAN_TABLE WHERE STATEMENT_ID='P23OLD') ORDER BY ID""")
for r in c.fetchall(): print(r)
c.connection.rollback()
