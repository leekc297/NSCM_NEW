# -*- coding: utf-8 -*-
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TO_CHAR(CREATION_DATE,'HH24:MI:SS'), EXCT_MSG_CTN
  FROM SCM_MGR.SCM_COM_SYS_LOG
 WHERE MNU_ID='DMF0044' AND EXCT_MSG_CTN IS NOT NULL AND CREATION_DATE > SYSDATE - 40/1440
 ORDER BY CREATION_DATE DESC FETCH FIRST 3 ROWS ONLY""")
for t, m in cur.fetchall():
    body = m.read() if hasattr(m, "read") else m
    print("=" * 24, t)
    print(body[:700])
con.close()
