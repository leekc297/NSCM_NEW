# -*- coding: utf-8 -*-
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT i.TABLE_OWNER, i.INDEX_NAME, i.UNIQUENESS,
                      LISTAGG(c.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY c.COLUMN_POSITION)
                 FROM ALL_INDEXES i JOIN ALL_IND_COLUMNS c
                   ON c.INDEX_OWNER = i.OWNER AND c.INDEX_NAME = i.INDEX_NAME
                WHERE i.TABLE_NAME = 'SCM_ITEM_M'
                GROUP BY i.TABLE_OWNER, i.INDEX_NAME, i.UNIQUENESS""")
print("SCM_ITEM_M indexes:")
for r in cur.fetchall():
    print("  ", " | ".join(str(x) for x in r))
cur.execute("SELECT OWNER, NUM_ROWS, BLOCKS FROM ALL_TABLES WHERE TABLE_NAME='SCM_ITEM_M'")
print("SCM_ITEM_M table:", cur.fetchall())
con.close()
