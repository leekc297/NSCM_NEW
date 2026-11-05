import sys, io, csv
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info()
con = oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'")
def show(title, sql, save=None, **b):
    try:
        cur.execute(sql, b); cols=[c[0] for c in cur.description]; rows=cur.fetchall()
    except Exception as e:
        print(f"\n## {title} ERROR {e}"); return
    print(f"\n## {title} ({len(rows)} rows)"); print(" | ".join(cols))
    for r in rows: print(" | ".join("" if v is None else str(v).replace("\n","\n")[:120] for v in r))
    if save:
        with open(save,"w",encoding="utf-8",newline="") as f:
            w=csv.writer(f); w.writerow(cols); [w.writerow(["" if v is None else v for v in r]) for r in rows]
show("SHEET_COLUMNS desc", "SELECT COLUMN_NAME,DATA_TYPE,DATA_LENGTH,NULLABLE,DATA_DEFAULT FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SHEET_COLUMNS' ORDER BY COLUMN_ID")
show("SHEET_COLUMNS SCP0100 any col", "SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID LIKE '%SCP0100%' OR SHEET_NAME LIKE '%SCP0100%' OR COLUMN_NAME LIKE '%SCP0100%' ORDER BY PROGRAM_ID, SHEET_NAME, COLUMN_NAME", save="sheet_columns_corp.csv")
show("LOOKUP SCP0100", "SELECT LOOKUP_TYPE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,DISPLAY_SEQ,VALID_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE LIKE '%SCP0100%' OR SEGMENT1 LIKE '%SCP0100%' OR SEGMENT2 LIKE '%SCP0100%' OR SEGMENT3 LIKE '%SCP0100%' OR DESCRIPTION LIKE '%SCP0100%'")
show("LOOKUP types used", "SELECT LOOKUP_TYPE, COUNT(*) CNT, MIN(CREATION_DATE) MIN_CRE, MAX(LAST_UPDATE_DATE) MAX_UPD, LISTAGG(DISTINCT LAST_UPDATED_BY,',') UB FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE IN ('STOCK_TREND_DISPLAY','PRODUCT_LEVEL','BUCKET_TYPE_CODE','SCP_UNIT_QTY','PLAN_TYPE') GROUP BY LOOKUP_TYPE")
show("SRCH_COND", "SELECT * FROM SCM_ADM_USER_MNU_SRCH_COND_M WHERE MNU_ID='SCP0100' FETCH FIRST 3 ROWS ONLY")
show("PROGRAM", "SELECT * FROM SCM_ADM_PROGRAM WHERE PROGRAM_ID='SCP0100'")
show("PROGRAM cols", "SELECT COLUMN_NAME,DATA_TYPE,NULLABLE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_PROGRAM' ORDER BY COLUMN_ID")
show("MNU_M cols", "SELECT COLUMN_NAME,DATA_TYPE,DATA_LENGTH,NULLABLE,DATA_DEFAULT FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_MNU_M' ORDER BY COLUMN_ID")
show("MNU parent", "SELECT MNU_ID,UPPR_MNU_ID,MNU_MSG_ID,MNU_DESC,MNU_TP_CD,USE_YN FROM SCM_ADM_MNU_M WHERE MNU_ID='Supply_Plan'")
