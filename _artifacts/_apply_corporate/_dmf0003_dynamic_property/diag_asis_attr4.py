"""AS-IS DM_PLN_MKT_FCST ATTR4 distribution + sample extraction."""
import os, pathlib, sys
import pyodbc

env = {}
for line in pathlib.Path("C:/Projects/NSCM/.env.asis").read_text(encoding="utf-8").splitlines():
    if "=" in line and not line.strip().startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip()

conn_str = (
    f"DRIVER={{{env['ASIS_DB_DRIVER']}}};"
    f"SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};"
    f"DATABASE={env['ASIS_DB_NAME']};"
    f"UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};"
    f"TrustServerCertificate=yes;"
)

queries = [
    ("AS-IS table existence",
     "SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'DM_PLN_MKT_FCST%' ORDER BY 1,2"),
    ("AS-IS DM_PLN_MKT_FCST.ATTR4 distribution by DIV+MEASURE",
     """SELECT TOP 10 DIVISION_ID, MEASURE, COUNT(*) AS CNT
        FROM dbo.DM_PLN_MKT_FCST WITH (NOLOCK)
        WHERE ATTRIBUTE4 IS NOT NULL
        GROUP BY DIVISION_ID, MEASURE
        ORDER BY 3 DESC"""),
    ("AS-IS sample 3 rows (DIV=81 MKT_FCST + ATTR4 NOT NULL)",
     """SELECT TOP 3 DIVISION_ID, MEASURE, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, YYYYMMDD, ATTRIBUTE4, ATTRIBUTE5, QTY
        FROM dbo.DM_PLN_MKT_FCST WITH (NOLOCK)
        WHERE DIVISION_ID = '81' AND MEASURE = 'MKT_FCST' AND ATTRIBUTE4 IS NOT NULL"""),
]

with pyodbc.connect(conn_str, timeout=30) as con:
    cur = con.cursor()
    for label, sql in queries:
        print(f"\n=== {label} ===")
        try:
            cur.execute(sql)
            cols = [c[0] for c in cur.description] if cur.description else []
            rows = cur.fetchall()
            print(" | ".join(cols))
            print("-" * 80)
            for r in rows:
                print(" | ".join(str(x) for x in r))
            print(f"({len(rows)} rows)")
        except Exception as e:
            print(f"FAIL: {e}")
