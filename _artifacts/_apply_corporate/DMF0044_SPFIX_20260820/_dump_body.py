#!/usr/bin/env python3
"""라이브 PKG_DMF0044 SPEC/BODY 를 ALL_SOURCE 에서 전문 덤프 (적용 전 백업)."""
import sys, pathlib, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1].parent / "_diagnostics"))
from ora import conn_info  # noqa
import oracledb

HERE = pathlib.Path(__file__).resolve().parent
u, p, d = conn_info()
print(f"connect: {u}@{d}")
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    for typ, suffix in (("PACKAGE", "SPEC"), ("PACKAGE BODY", "BODY")):
        cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE=:t
                        ORDER BY LINE""", {"t": typ})
        rows = cur.fetchall()
        if not rows:
            print(f"!! {typ}: 0 lines"); continue
        out = HERE / f"00_BACKUP_PKG_DMF0044_{suffix}_LIVE.sql"
        with out.open("w", encoding="utf-8", newline="\n") as f:
            f.write("CREATE OR REPLACE ")
            for _, t in rows:
                f.write(t.replace("\r", "").rstrip("\n") + "\n")
            f.write("/\n")
        print(f"{typ}: {len(rows)} lines -> {out.name}")
    # 상태 스냅샷
    cur.execute("""SELECT OBJECT_TYPE, STATUS, LAST_DDL_TIME FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044'""")
    for r in cur.fetchall():
        print("STATUS:", r)
print("dumped at", datetime.datetime.now())
