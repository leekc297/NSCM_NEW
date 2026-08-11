#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""V_GROUP_ID 대입 조건 AS-IS ↔ TO-BE 1:1 대조 — 편집불가의 진짜 원인 지점"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

print("=" * 116); print("### AS-IS  (AsIs_LGCE_SCMDEV_SP1_DDL.sql  L145975 ~ L146005)"); print("=" * 116)
f = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL\AsIs_LGCE_SCMDEV_SP1_DDL.sql")
with io.open(f, encoding="utf-8", errors="ignore") as fh:
    for i, ln in enumerate(fh, 1):
        if 145975 <= i <= 146005:
            print(f"  {i:7d} | {ln.rstrip()[:170]}")
        elif i > 146005:
            break

print("\n" + "=" * 116); print("### TO-BE  (라이브 PKG_DMF0044 BODY  L1160 ~ L1200)"); print("=" * 116)
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND LINE BETWEEN 1160 AND 1200 ORDER BY LINE""")
for ln, tx in cur.fetchall():
    print(f"  {ln:7d} | {tx.rstrip()[:170]}")

print("\n" + "=" * 116); print("### 실측 — 이 사용자가 AS-IS 조건을 만족하는가"); print("=" * 116)
cur2 = con.cursor()
for label, sql in (
    ("V_ADMIN_GROUP 에 minyonglee1 의 그룹이 있는가",
     """SELECT * FROM SCM_MGR.V_ADMIN_GROUP WHERE ROWNUM <= 20"""),
):
    print(f"\n[{label}]")
    try:
        cur2.execute(sql)
        cols = [c[0] for c in cur2.description]
        print("   ", " | ".join(cols))
        for r in cur2.fetchall():
            print("   ", " | ".join(str(x) for x in r))
    except Exception as e:
        print("   ", str(e)[:200])

con.close()
