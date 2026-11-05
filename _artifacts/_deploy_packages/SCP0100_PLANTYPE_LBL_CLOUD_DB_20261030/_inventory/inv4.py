import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info()
con = oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'")
def show(title, sql, **b):
    try:
        cur.execute(sql, b); cols=[c[0] for c in cur.description]; rows=cur.fetchall()
    except Exception as e:
        print(f"\n## {title} ERROR {e}"); return
    print(f"\n## {title} ({len(rows)} rows)"); print(" | ".join(cols))
    for r in rows: print(" | ".join("" if v is None else str(v).replace("\n","\n")[:300] for v in r))
show("CMBO cols", "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_CMBO_SQL_M' ORDER BY COLUMN_ID")
show("CMBO rows", "SELECT SQL_ID, MDU_DIVS_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('PLAN_END_DATE_REPORT','PlanType1_SCP_ALL','Division_SCP','SCPPlanPeriod_SCP') ORDER BY 1")
show("LOOKUP types", "SELECT SEGMENT1 TYP, COUNT(*) CNT, MAX(LAST_UPDATE_DATE) MAX_UPD, LISTAGG(DISTINCT LAST_UPDATED_BY,',') UB FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1 IN ('STOCK_TREND_DISPLAY','PRODUCT_LEVEL','BUCKET_TYPE_CODE','SCP_UNIT_QTY','PLAN_TYPE') GROUP BY SEGMENT1")
show("LOOKUP cols", "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_LOOKUP_MASTER_DETAIL' ORDER BY COLUMN_ID")
codes=['MSG00097','LBL01167','LBL01163','LBL00112','MSG00704','MSG00703','MSG00618','LBL01129','LBL01073','LBL00767','LBL00710','LBL00690','LBL00684','LBL00683','LBL00605','LBL00310','LBL00050','LBL00049','LBL00040','LBL00039','LBL00023','LBL00022','LBL00021','LBL00012','LBL00001']
show("MSG_M FE codes", "SELECT MSG_ID, LISTAGG(LANG_CD||'='||MSG_NM, ' / ') WITHIN GROUP (ORDER BY LANG_CD) NMS, MIN(CREATION_DATE) CRE, MAX(LAST_UPDATE_DATE) UPD, LISTAGG(DISTINCT CREATED_BY,',') CB, LISTAGG(DISTINCT LAST_UPDATED_BY,',') UB FROM SCM_ADM_MSG_M WHERE MSG_ID IN (%s) GROUP BY MSG_ID ORDER BY 1" % ",".join("'%s'"%c for c in codes))
show("MSG_M missing", "SELECT COLUMN_VALUE MSG_ID FROM TABLE(SYS.ODCIVARCHAR2LIST(%s)) WHERE COLUMN_VALUE NOT IN (SELECT MSG_ID FROM SCM_ADM_MSG_M)" % ",".join("'%s'"%c for c in codes))
show("MSG_M recent by user", "SELECT MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE FROM SCM_ADM_MSG_M WHERE (CREATED_BY IN ('admin','minyonglee1') OR LAST_UPDATED_BY IN ('admin','minyonglee1')) AND LAST_UPDATE_DATE >= DATE'2026-10-13' ORDER BY LAST_UPDATE_DATE")
show("LBL01167 full", "SELECT * FROM SCM_ADM_MSG_M WHERE MSG_ID='LBL01167'")
show("users", "SELECT USER_ID, USER_NM FROM SCM_ADM_USER_M WHERE USER_ID IN ('iamarock','minyonglee1','admin','AJS','ZIONEX')")
