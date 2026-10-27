import re, pyodbc, pathlib, sys
kv = {}
for l in pathlib.Path(r"C:\Projects\NSCM\.env.asis").read_text(encoding="utf-8", errors="ignore").splitlines():
    if "=" in l and not l.strip().startswith("#"): k, v = l.split("=", 1); kv[k.strip()] = v.strip()
con = pyodbc.connect(f"DRIVER={{{kv['ASIS_DB_DRIVER']}}};SERVER={kv['ASIS_DB_HOST']},{kv['ASIS_DB_PORT']};DATABASE={kv['ASIS_DB_NAME']};UID={kv['ASIS_DB_USER']};PWD={kv['ASIS_DB_PASS']};TrustServerCertificate=yes", timeout=20)
cur = con.cursor()
for sp in sys.argv[1:]:
    cur.execute("SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID(?)", sp)
    d = cur.fetchone()[0].split("\n")
    pathlib.Path(f"{sp}.asis.sql").write_text("\n".join(d), encoding="utf-8")
    print("=====", sp, len(d), "lines")
    for i, l in enumerate(d):
        if "CELL_PROD" in l.upper() and re.search(r"'-'|ISNULL|NULLIF|@V_DIVISION|DIVISION_ID\s*=", l, re.I):
            print(f"  L{i+1}: {l.strip()[:200]}")
cur.execute("""SELECT t.name, c.name, c.is_nullable, dc.definition FROM sys.columns c JOIN sys.tables t ON t.object_id=c.object_id
 LEFT JOIN sys.default_constraints dc ON dc.parent_object_id=c.object_id AND dc.parent_column_id=c.column_id
 WHERE c.name='CELL_PROD_SITE_ID' AND t.name IN ('DM_PLN_SALES_PLAN_RESULT','DM_PLN_SALES_PLAN','DM_PLN_CFM_MKT_DEMAND_PLAN','DM_PLN_CFM_SELLING_PRICE','DM_PLN_MKT_FCST_RESULT','DM_PLN_DEMAND_CHANGE_STATUS','DM_PLN_NET_DEMAND')""")
print("== AS-IS 테이블 정의"); [print("  ", r) for r in cur.fetchall()]
cur.execute("""SELECT LEFT(DIVISION_ID,2) D, CELL_PROD_SITE_ID, COUNT(*) FROM DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)
 WHERE CELL_PROD_SITE_ID IN ('-','/','') OR CELL_PROD_SITE_ID IS NULL GROUP BY LEFT(DIVISION_ID,2), CELL_PROD_SITE_ID ORDER BY 1,2""")
print("== AS-IS DM_PLN_SALES_PLAN_RESULT 빈값 표기 분포"); [print("  ", r) for r in cur.fetchall()]
cur.execute("""SELECT LEFT(DIVISION_ID,2) D, CELL_PROD_SITE_ID, COUNT(*) FROM DM_PLN_CFM_MKT_DEMAND_PLAN WITH(NOLOCK)
 WHERE CELL_PROD_SITE_ID IN ('-','/','') OR CELL_PROD_SITE_ID IS NULL GROUP BY LEFT(DIVISION_ID,2), CELL_PROD_SITE_ID ORDER BY 1,2""")
print("== AS-IS DM_PLN_CFM_MKT_DEMAND_PLAN 빈값 표기 분포"); [print("  ", r) for r in cur.fetchall()]
