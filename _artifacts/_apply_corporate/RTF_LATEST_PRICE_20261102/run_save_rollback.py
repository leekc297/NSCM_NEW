# -*- coding: utf-8 -*-
"""저장 경로 실객체 시험: MKT_FCST_SAVE(40) · PKG_DMF0020 SINGLE(82). 키 1건만, 실행 후 ROLLBACK. 두 객체 모두 내부 COMMIT 없음."""
import sys, time
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
sys.stdout.reconfigure(encoding='utf-8')
import dbconn

cx = dbconn.connect('tobe', dbconn.load_cfg()); cx.autocommit = False; c = cx.cursor()
c.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); print('at', c.fetchone()[0])
SP = """select measure, yyyymmdd, cell_prod_site_id, currency, to_char(qty,'TM9') from dm_pln_sales_plan
  where division_id=:d and project_code=:p and item_id=:i and yyyymmdd between :a and :b and measure in ('RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD') order by 2,1"""


def snap(d, p, i, a, b):
    c.execute(SP, d=d, p=p, i=i, a=a, b=b); return c.fetchall()


# 1) MKT_FCST_SAVE — 40 IM APCCA3122A, RTF 20280401 (이전 단가 20280327)
k40 = dict(d='40', p='IM', i='APCCA3122A', a='20280401', b='20280407')
before = snap(**k40); print('40 before', before)
c.execute("delete from gt_prdm_results")
c.execute("""insert into gt_prdm_results (v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_measure,v_plant_site_id,v_yyyymmdd,v_created_by)
  select distinct division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,'MKT_FCST',plant_site_id,yyyymmdd,'SYSTEM'
  from dm_pln_cfm_mkt_demand_plan where division_id='40' and project_code='IM' and item_id='APCCA3122A' and yyyymmdd='20280401' and measure='RTF_SYS_RP'""")
print('results rows', c.rowcount)
t = time.time(); c.callproc('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE'); print('sec', round(time.time() - t, 2))
print('40 after ', snap(**k40))
cx.rollback(); assert snap(**k40) == before; print('40 rollback same True')

# 2) SINGLE — 82 C-24-038 EBA02351AA, RTF 20280303 (이전 단가 20271227)
k82 = dict(d='82', p='C-24-038', i='EBA02351AA', a='20280303', b='20280303')
before = snap(**k82); print('82 before', before)
c.execute("select column_name, nullable from all_tab_columns where owner='SCM_MGR' and table_name='GT_DMF0020_RESULTS' order by column_id"); print([r[0] for r in c.fetchall()][:14])
c.execute("delete from gt_dmf0020_results")
c.execute("""insert into gt_dmf0020_results (v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id,v_yyyymmdd,v_currency,v_measure,v_price,v_created_by)
  select distinct division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,plant_site_id,'20271227','USD','LOC',67,'SYSTEM'
  from dm_pln_cfm_mkt_demand_plan where division_id='82' and project_code='C-24-038' and item_id='EBA02351AA' and yyyymmdd='20280303' and measure='RTF_SYS_RP'""")
print('results rows', c.rowcount)
t = time.time(); c.callproc('PKG_DMF0020.P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE'); print('sec', round(time.time() - t, 2))
print('82 after ', snap(**k82))
cx.rollback(); assert snap(**k82) == before; print('82 rollback same True')
