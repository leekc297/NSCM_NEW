# 2-14 WH_STOCK(aj7nw6qjt4tjv) 사내 재현 : 세션 GTT 에 계획 40/20261121/SP/1 HQ00 측정값 적재 후 SELECT 부분 실행(SP 변수 = 바인드)
import sys, io, re, time
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
src = io.open('PR_SSP_ANL_SHIP_PLAN_40.TOBE.sql', encoding='utf-8').read()
i = src.index('/* 2-14. [I]WH_STOC'); j = src.index('WITH BOH AS', i); k = src.index('\n        ;', j)
sel = src[j:k]
sel = re.sub(r'\bV_(DIVISION_ID|PLAN_START_YYYYMMDD|PLAN_TYPE|SEQ|COMPANY_ID|DATA_START_YYYYMMDD|DATA_END_YYYYMMDD)\b', r':V_\1', sel)
io.open('w_sel_old.sql', 'w', encoding='utf-8').write(sel)
B = dict(V_DIVISION_ID='40', V_PLAN_START_YYYYMMDD='20261121', V_PLAN_TYPE='SP', V_SEQ=1, V_COMPANY_ID='HQ00', V_DATA_START_YYYYMMDD='20261120', V_DATA_END_YYYYMMDD='20270213')
def binds(q): return {k: v for k, v in B.items() if ':' + k in q}
cx = dbconn.connect('tobe'); c = cx.cursor(); c.callTimeout = 300000
c.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR"); c.execute("ALTER SESSION SET optimizer_dynamic_sampling = 2")
c.execute("ALTER SESSION SET statistics_level = ALL")
c.execute("""SELECT LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_ID) FROM ALL_TAB_COLUMNS T WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_SSP_ANL_SHIP_PLAN_40'
  AND EXISTS (SELECT 1 FROM ALL_TAB_COLUMNS S WHERE S.OWNER='SCM_MGR' AND S.TABLE_NAME='SSP_ANL_SHIP_PLAN_40' AND S.COLUMN_NAME=T.COLUMN_NAME)""")
cols = c.fetchone()[0]
t = time.time()
c.execute("INSERT INTO GT_SSP_ANL_SHIP_PLAN_40 (" + cols + ") SELECT " + cols + """ FROM SSP_ANL_SHIP_PLAN_40 P
 WHERE P.DIVISION_ID='40' AND P.PLAN_START_YYYYMMDD='20261121' AND P.PLAN_TYPE='SP' AND P.SEQ=1
   AND P.MEASURE IN ('SHIP_CONFIRM','WH_IN','POSTP_PLAN','MES_FCS_HOLD','MES_FCS_RELEASE')
   AND EXISTS (SELECT 1 FROM SCM_MST_SITE E WHERE E.DIVISION_ID='40' AND NVL(E.COMPANY_ID,'-')='HQ00' AND E.SCM_SITE_ID=P.FROM_SITE)""")
print('GT 적재', c.rowcount, '%.1fs' % (time.time() - t), flush=True)
tag = time.strftime('%H%M%S')
t = time.time(); c.execute('SELECT /* W14_OLD_%s */ X.* FROM (%s\n) X' % (tag, sel), binds(sel)); rows = c.fetchall()
print('OLD %.2fs rows %d qty %.3f' % (time.time() - t, len(rows), sum(r[10] or 0 for r in rows)), flush=True)
c.execute("select sql_id, child_number from v$sql where sql_text like '%%W14_OLD_%s%%' and sql_text not like '%%v$sql%%'" % tag); s, ch = c.fetchone()
c.execute("select plan_table_output from table(dbms_xplan.display_cursor(:s, :c, 'ALLSTATS LAST'))", s=s, c=ch)
io.open('w_plan_old.txt', 'w', encoding='utf-8').write('\n'.join(r[0] for r in c.fetchall()))
cx.rollback()
