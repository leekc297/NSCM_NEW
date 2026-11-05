# -*- coding: utf-8 -*-
"""패치 블록 4종을 익명 블록으로 세션 GTT 에만 실행 후 ROLLBACK. 객체·원장 무변경(원장은 읽기만)."""
import sys
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
sys.stdout.reconfigure(encoding='utf-8')
import dbconn
import patch_def as P

cx = dbconn.connect('tobe', dbconn.load_cfg()); cx.autocommit = False; c = cx.cursor()
c.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS'), to_char(fn_next_day(sysdate,'MON')-7,'YYYYMMDD') from dual"); now, mon = c.fetchone(); print('at', now, 'mon', mon)


def one(sql, **k):
    c.execute(sql, **k); return c.fetchone()[0]


# ---- 1. 배치 블록
def batch(div):
    c.execute("delete from gt_prdm_t2_mkt_fcst"); c.execute("delete from gt_prdm_t2_price")
    cell = 'A.CELL_PROD_SITE_ID'
    proj = 'A.END_CUSTOMER' if div == '40' else 'A.PROJECT_CODE'
    c.execute(f"""insert into gt_prdm_t2_mkt_fcst (division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,yyyymmdd,plant_site_id,cell_prod_site_id,from_site_id,qty)
      select a.division_id,{proj},a.scm_site_id,a.item_id,a.dom_exp,a.fcst_type,a.incoterms,a.measure,a.yyyymmdd,a.plant_site_id,{cell},'-',a.qty
      from dm_pln_cfm_mkt_demand_plan a where a.division_id=:d and a.yyyymmdd>=:m and a.measure='RTF_SYS_RP'""", d=div, m=mon)
    src = ("select a.division_id,a.end_customer,a.scm_site_id,a.plant_site_id,a.cell_prod_site_id,a.item_id,a.yyyymmdd,a.currency,a.measure,a.dom_exp,a.fcst_type,a.incoterms,a.price from dm_pln_cfm_selling_price a"
           if div == '40' else
           "select a.division_id,a.project_code,a.scm_site_id,a.plant_site_id,'-',a.item_id,a.yyyymmdd,a.currency,a.measure,a.dom_exp,a.fcst_type,a.incoterms,a.price from scm_mst_future_price a")
    c.execute(f"insert into gt_prdm_t2_price (division_id,project_code,scm_site_id,plant_site_id,cell_prod_site_id,item_id,yyyymmdd,currency,measure,dom_exp,fcst_type,incoterms,price) {src} where a.division_id=:d and a.yyyymmdd>=:m and a.measure in ('KRW','LOC','USD')", d=div, m=mon)
    n0 = one("select count(*) from gt_prdm_t2_price")
    c.execute("declare V_DIVISION_ID varchar2(30) := :d; begin " + P.BATCH_BLOCK + " end;", d=div)
    n1 = one("select count(*) from gt_prdm_t2_price")
    print(f'batch {div}: T2_PRICE {n0} -> {n1} (added {n1 - n0})')
    # 금액 재현: 기존 조인 형태로 SalesAmt 행 수
    join_cell = "AND fp.cell_prod_site_id=w.cell_prod_site_id" if div == '40' else ''
    n = one(f"""select count(*) from gt_prdm_t2_mkt_fcst w join gt_prdm_t2_price fp on fp.division_id=w.division_id and fp.project_code=w.project_code and fp.scm_site_id=w.scm_site_id
        and fp.item_id=w.item_id and fp.dom_exp=w.dom_exp and fp.fcst_type=w.fcst_type and fp.incoterms=w.incoterms and fp.plant_site_id=w.plant_site_id {join_cell}
        and fp.yyyymmdd=(select basis_start_date from scm_sys_calendar_m where basis_yyyymmdd=w.yyyymmdd) where w.measure='RTF_SYS_RP' and w.qty<>0""")
    print(f'   SalesAmt join rows {n}')
    c.execute("""select project_code,item_id,yyyymmdd,measure,currency,price from gt_prdm_t2_price p where measure='LOC' and exists
        (select 1 from gt_prdm_t2_mkt_fcst w where w.item_id=p.item_id and w.project_code=p.project_code and w.measure='RTF_SYS_RP')
        and item_id in ('APCCA3122A','ETD1555AHB31') and yyyymmdd in ('20280401','20280403') order by 2""")
    for r in c.fetchall(): print('   sample', r)
    cx.rollback()


for d in ('82', '40', '81'):
    batch(d)

# ---- 2. MKT_FCST_SAVE 블록 (40 — 키 IM/APCCA3122A)
c.execute("delete from gt_prmf_t2_mkt_fcst"); c.execute("delete from gt_prmf_t2_price"); c.execute("delete from gt_prmf_sales_plan_temp")
c.execute("""insert into gt_prmf_t2_mkt_fcst (division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,cell_prod_site_id,yyyymmdd,qty,basis_start_date)
  select a.division_id,a.project_code,a.scm_site_id,a.item_id,a.dom_exp,a.fcst_type,a.incoterms,a.measure,a.plant_site_id,a.cell_prod_site_id,a.yyyymmdd,a.qty,m.basis_start_date
  from dm_pln_cfm_mkt_demand_plan a join scm_sys_calendar_m m on m.basis_yyyymmdd=a.yyyymmdd where a.division_id='40' and a.yyyymmdd>=:m and a.measure='RTF_SYS_RP' and a.qty<>0""", m=mon)
c.execute("""insert into gt_prmf_t2_price (division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,plant_site_id,cell_prod_site_id,currency,measure,yyyymmdd,price)
  select a.division_id,a.project_code,a.scm_site_id,a.item_id,a.dom_exp,a.fcst_type,a.incoterms,a.plant_site_id,a.cell_prod_site_id,a.currency,a.measure,a.yyyymmdd,a.price
  from dm_pln_cfm_selling_price a where a.division_id='40' and a.yyyymmdd>=:m and a.measure in ('KRW','LOC','USD') and a.price>0""", m=mon)
c.execute("""insert into gt_prmf_sales_plan_temp (division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,cell_prod_site_id,yyyymmdd,qty)
  select division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,cell_prod_site_id,yyyymmdd,qty from gt_prmf_t2_mkt_fcst""")
n0 = one("select count(*) from gt_prmf_t2_price")
c.execute("declare V_DIVISION_ID varchar2(30) := '40'; begin " + P.SAVE_BLOCK + " end;")
n1 = one("select count(*) from gt_prmf_t2_price")
print(f'save 40: T2_PRICE {n0} -> {n1} (added {n1 - n0}) RTF currency filled', one("select count(*) from gt_prmf_sales_plan_temp where currency is not null"))
c.execute("begin " + P.SAVE_DELETE + " end;")
print('   after delete', one("select count(*) from gt_prmf_t2_price"), 'equals before', n0)
cx.rollback()
# 81 분기 문법
c.execute("declare V_DIVISION_ID varchar2(30) := '81'; begin " + P.SAVE_BLOCK + " end;"); cx.rollback(); print('save 81: block parsed/executed (빈 임시표)')

# ---- 3. SINGLE 블록 (82 — EBA02351AA)
c.execute("delete from gt_prdm_sales_plan_temp_single")
base = """select a.division_id,a.project_code,a.scm_site_id,a.item_id,a.dom_exp,a.fcst_type,a.incoterms,{m},a.plant_site_id,a.cell_prod_site_id,a.yyyymmdd,null,{q}
  from dm_pln_cfm_mkt_demand_plan a where a.division_id='82' and a.item_id='EBA02351AA' and a.yyyymmdd='20280303' and a.measure='RTF_SYS_RP'"""
for m, q in (("'RTF_SYS_RP'", 'a.qty'), ("'SalesAmt_KRW'", '0'), ("'SalesAmt_LOC'", '0'), ("'SalesAmt_USD'", '0')):
    c.execute("insert into gt_prdm_sales_plan_temp_single (division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,cell_prod_site_id,yyyymmdd,currency,qty) " + base.format(m=m, q=q))
c.execute("begin " + P.SINGLE_BLOCK + " end;")
c.execute("select measure,currency,to_char(qty) from gt_prdm_sales_plan_temp_single order by 1"); print('single 82 EBA02351AA 20280303', c.fetchall())
c.execute("select measure,currency,to_char(price),yyyymmdd from scm_mst_future_price where division_id='82' and item_id='EBA02351AA' and yyyymmdd='20271227' and project_code='C-24-038' order by 1"); print('   ledger 20271227', c.fetchall())
cx.rollback()

# ---- 4. SYNC 블록 (82)
c.execute("delete from gt_fsps_t_mkt_fcst"); c.execute("delete from gt_fsps_t_price"); c.execute("delete from gt_fsps_sales_plan_temp_loc")
c.execute("""insert into gt_fsps_t_mkt_fcst (division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,yyyymmdd,plant_site_id,qty)
  select division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,yyyymmdd,plant_site_id,qty from dm_pln_mkt_fcst where division_id='82' and yyyymmdd>=:m and measure='RTF_SYS_RP'""", m=mon)
c.execute("""insert into gt_fsps_t_price (division_id,project_code,scm_site_id,plant_site_id,item_id,yyyymmdd,currency,measure,dom_exp,fcst_type,incoterms,price)
  select division_id,project_code,scm_site_id,plant_site_id,item_id,yyyymmdd,currency,measure,dom_exp,fcst_type,incoterms,price from scm_mst_future_price where division_id='82' and yyyymmdd>=:m and measure in ('KRW','LOC','USD')""", m=mon)
c.execute("""insert into gt_fsps_sales_plan_temp_loc (division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,yyyymmdd,qty)
  select division_id,project_code,scm_site_id,item_id,dom_exp,fcst_type,incoterms,measure,plant_site_id,yyyymmdd,qty from gt_fsps_t_mkt_fcst""")
c.execute("declare V_NEXT_MON_MINUS7 varchar2(8) := :m; begin " + P.SYNC_BLOCK + " end;", m=mon)
c.execute("select measure,count(*),count(currency) from gt_fsps_sales_plan_temp_loc group by measure order by 1"); print('sync 82', c.fetchall())
cx.rollback()
c.execute("select object_name,status,to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name in ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW','PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE') and object_type='PROCEDURE' union all select object_name,status,to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name in ('PKG_DMF0020','PKG_DMF0003') and object_type='PACKAGE BODY'")
for r in c.fetchall(): print(r)
c.execute("select name,type,count(*) from all_source where owner='SCM_MGR' and text like '%E20261102-RTFLATESTPRICE%' group by name,type"); print('marker in DB', c.fetchall())
