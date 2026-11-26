# awr2c30u4h31c SELECT 사내 재현 : 소요, 행 수, 실행계획(ALLSTATS LAST)
import sys, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
OLD = """SELECT /*+ GATHER_PLAN_STATISTICS */ /* AGING_OLD_%s */ A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.LOT_ID, A.QTY, A.WIPHOLD_YN, A.SPECIAL_YN, A.UNHOLD_EXP_DATE
  FROM SCM_DNM_STOCK_AGING_V A
       JOIN ( SELECT C.DIVISION_ID, C.SITE_ID , MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
                FROM SCM_DNM_STOCK_AGING_V C
               WHERE C.CUTOFF_DATE >  SYSDATE - 5
                 AND C.DIVISION_ID = :d
               GROUP BY C.DIVISION_ID, C.SITE_ID ) B
    ON A.DIVISION_ID = B.DIVISION_ID
   AND A.SITE_ID     = B.SITE_ID
   AND A.CUTOFF_DATE = B.CUTOFF_DATE"""
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
c.execute("ALTER SESSION SET statistics_level = ALL")
c.execute("select max(cutoff_date), count(*) from SCM_DNM_STOCK_AGING_V_SN"); print('SN max cutoff, rows', c.fetchone(), flush=True)
tag = time.strftime('%H%M%S')
t = time.time(); c.execute(OLD % tag, d='40'); rows = c.fetchall(); print('OLD %.2fs rows %d' % (time.time() - t, len(rows)), flush=True)
c.execute("select sql_id, child_number from v$sql where sql_text like '%%AGING_OLD_%s%%' and sql_text not like '%%v$sql%%'" % tag); sid, ch = c.fetchone()
c.execute("select plan_table_output from table(dbms_xplan.display_cursor(:s, :c, 'ALLSTATS LAST'))", s=sid, c=ch)
open('plan_old.txt', 'w', encoding='utf-8').write('\n'.join(r[0] for r in c.fetchall()))
