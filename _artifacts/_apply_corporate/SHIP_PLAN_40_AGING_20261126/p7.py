import sys, io
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
sel = io.open('p_sel_old.sql', encoding='utf-8').read()
c = dbconn.connect('tobe').cursor(); c.callTimeout = 120000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2"); c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
base = sel.replace(':V_DIVISION_ID', "'40'").replace(':V_COMPANY_ID', "'HQ00'")
H = {
 'H1': 'INDEX_SS(P.DPP IX01_FP_DAILY_PRODUCTIOIN_PLAN_H)',
 'H2': 'INDEX_SS(P.SCM_FORMATION_POST_CELL_V_SN.DPP IX01_FP_DAILY_PRODUCTIOIN_PLAN_H)',
 'H3': 'INDEX_SS(@SEL$3 DPP IX01_FP_DAILY_PRODUCTIOIN_PLAN_H)',
}
for k, h in H.items():
    q = base.replace('SELECT  P.DIVISION_ID', 'SELECT /*+ %s */ P.DIVISION_ID' % h, 1)
    c.execute("DELETE FROM PLAN_TABLE WHERE STATEMENT_ID = :s", s=k)
    c.execute("EXPLAIN PLAN SET STATEMENT_ID = '%s' FOR " % k + q)
    c.execute("SELECT OPERATION || ' ' || OPTIONS, OBJECT_NAME, CARDINALITY, COST FROM PLAN_TABLE WHERE STATEMENT_ID=:s AND OBJECT_NAME LIKE 'IX0%%FP_DAILY%%' AND PLAN_ID=(SELECT MAX(PLAN_ID) FROM PLAN_TABLE WHERE STATEMENT_ID=:s)", s=k)
    print(k, c.fetchall())
c.execute("SELECT DISTINCT OBJECT_ALIAS, QBLOCK_NAME FROM PLAN_TABLE WHERE STATEMENT_ID='H1' AND OBJECT_NAME='FP_DAILY_PRODUCTIOIN_PLAN_H'"); print(c.fetchall())
c.connection.rollback()
