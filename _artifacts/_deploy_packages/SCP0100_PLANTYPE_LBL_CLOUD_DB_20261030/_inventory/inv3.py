import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info()
con = oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'")
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("SWEEP START", cur.fetchone()[0])
# mechanical axis sweep: SCM_ADM_% / SCM_MST_% tables (not GTT), string cols len>=7
cur.execute("""SELECT T.TABLE_NAME FROM ALL_TABLES T WHERE T.OWNER='SCM_MGR' AND T.TEMPORARY='N' AND (T.TABLE_NAME LIKE 'SCM_ADM_%' OR T.TABLE_NAME LIKE 'SCM_MST_%') AND T.TABLE_NAME NOT LIKE '%BAK%' AND T.TABLE_NAME NOT LIKE '%BK' AND T.TABLE_NAME NOT LIKE '%_H' ORDER BY 1""")
tabs=[r[0] for r in cur.fetchall()]
print("TABLES", len(tabs))
hits=[]
for t in tabs:
    cur.execute("SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY COLUMN_ID", t=t)
    cols=cur.fetchall()
    scols=[c for c,dt in cols if dt in ('VARCHAR2','CHAR','NVARCHAR2','NCHAR')]
    names=[c for c,_ in cols]
    if not scols: continue
    where=" OR ".join('"' + c + '" LIKE ' + "'%SCP0100%'" for c in scols)
    sel="COUNT(*)"
    has_upd='LAST_UPDATE_DATE' in names; has_by='LAST_UPDATED_BY' in names
    extra=(", MAX(LAST_UPDATE_DATE)" if has_upd else ", NULL") + (", SUM(CASE WHEN LAST_UPDATE_DATE>=DATE'2026-10-01' THEN 1 ELSE 0 END)" if has_upd else ", NULL") + (", LISTAGG(DISTINCT LAST_UPDATED_BY,',')" if has_by else ", NULL")
    try:
        cur.execute(f'SELECT {sel}{extra} FROM "{t}" WHERE {where}')
        r=cur.fetchone()
    except Exception as e:
        print("QUERY FAIL (STOP)", t, e); sys.exit(2)
    if r[0]: hits.append((t,)+tuple(r)); print("HIT", t, r)
print("\n## HITS", len(hits))
for h in hits: print(" | ".join("" if v is None else str(v) for v in h))
# SHEET_COLUMNS full rows
cur.execute("SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0100' ORDER BY SHEET_NAME, SORT_ORDER, COLUMN_NAME")
cols=[c[0] for c in cur.description]; rows=cur.fetchall()
print("\n## SHEET_COLUMNS rows", len(rows)); print(" | ".join(cols))
for r in rows: print(" | ".join("" if v is None else str(v) for v in r))
import csv
with open("sheet_columns_corp.csv","w",encoding="utf-8",newline="") as f:
    w=csv.writer(f); w.writerow(cols); [w.writerow(["" if v is None else v for v in r]) for r in rows]
cur.execute("SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1 LIKE '%SCP0100%' OR SEGMENT2 LIKE '%SCP0100%' OR SEGMENT3 LIKE '%SCP0100%' OR SEGMENT4 LIKE '%SCP0100%' OR SEGMENT5 LIKE '%SCP0100%'")
print("\n## LOOKUP_MASTER_DETAIL", [c[0] for c in cur.description]); 
for r in cur.fetchall(): print(r)
