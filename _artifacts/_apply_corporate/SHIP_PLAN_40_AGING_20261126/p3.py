# 2-3 SELECT(6fv7933qvycp9) 사내 재현 : 소요, 행 수, ALLSTATS
import sys, io, re, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
src = io.open('PR_SSP_ANL_SHIP_PLAN_40.W.TOBE.sql', encoding='utf-8').read()
i = src.index('INSERT INTO GT_SSP_FORMATION_POST_CELL'); j = src.index('SELECT  P.DIVISION_ID', i); k = src.index('\n        ;', j)
sel = re.sub(r'\bV_(DIVISION_ID|COMPANY_ID)\b', r':V_\1', src[j:k])
io.open('p_sel_old.sql', 'w', encoding='utf-8').write(sel)
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2"); c.execute("ALTER SESSION SET optimizer_adaptive_plans = FALSE")
c.execute("ALTER SESSION SET statistics_level = ALL")
tag = time.strftime('%H%M%S')
for co in ('HQ00', 'NJ00', 'AZ00'):
    q = '/* P23_%s_%s */ SELECT COUNT(*), SUM(QTY), MIN(YYYYMMDD), MAX(YYYYMMDD), COUNT(DISTINCT YYYYMMDD) FROM (%s\n)' % (co, tag, sel)
    t = time.time(); c.execute(q, V_DIVISION_ID='40', V_COMPANY_ID=co); r = c.fetchone(); print(co, '%.2fs' % (time.time() - t), r, flush=True)
c.execute("select sql_id, child_number from v$sql where sql_text like '%%P23_HQ00_%s%%' and sql_text not like '%%v$sql%%'" % tag); s, ch = c.fetchone()
c.execute("select plan_table_output from table(dbms_xplan.display_cursor(:s, :c, 'ALLSTATS LAST'))", s=s, c=ch)
io.open('p_plan_old.txt', 'w', encoding='utf-8').write('\n'.join(r[0] for r in c.fetchall()))
