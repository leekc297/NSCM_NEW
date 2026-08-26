# -*- coding: utf-8 -*-
"""PKG_DMF0022 실행 후 V$SQL 문장 귀속 리포트.

귀속 = SQL_FULLTEXT ↔ BODY 세그먼트 매칭(권위) + PROGRAM_LINE#(보조).
사용: python attrib.py [분_window]
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

win = int(sys.argv[1]) if len(sys.argv) > 1 else 10
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 0
cur = con.cursor()
cur.execute("""
  SELECT s.SQL_ID, s.CHILD_NUMBER, s.EXECUTIONS, s.ELAPSED_TIME/1e6 ELA,
         s.BUFFER_GETS, s.DISK_READS, s.ROWS_PROCESSED, s.PROGRAM_LINE#,
         o.OBJECT_NAME, s.SQL_FULLTEXT
    FROM V$SQL s LEFT JOIN DBA_OBJECTS o ON o.OBJECT_ID = s.PROGRAM_ID
   WHERE s.LAST_ACTIVE_TIME > SYSDATE - :w/1440
     AND (o.OBJECT_NAME = 'PKG_DMF0022' OR s.PARSING_SCHEMA_NAME='SCM_MGR')
   ORDER BY s.ELAPSED_TIME DESC""", {"w": win})
rows = cur.fetchall()
tot = 0.0
out = []
for sid, ch, ex, ela, bg, dr, rp, pl, obj, ft in rows:
    if ela < 0.05:
        continue
    txt = ft.read() if hasattr(ft, "read") else (ft or "")
    txt1 = " ".join(txt.split())
    out.append((ela, sid, ch, ex, bg, dr, rp, pl, obj or "-", txt1))
    tot += ela
print(f"{'ELA_S':>8} {'S/EXEC':>7} {'EXEC':>5} {'BUFFER':>12} {'DISK':>9} {'ROWS':>8} {'LINE#':>6}  OBJ / SQL")
for ela, sid, ch, ex, bg, dr, rp, pl, obj, txt in out:
    print(f"{ela:8.2f} {ela/max(ex,1):7.3f} {ex:5d} {bg:12d} {dr:9d} {rp:8d} {str(pl):>6}  {obj} [{sid}]")
    print(f"          {txt[:260]}")
print(f"\n합계 ELAPSED = {tot:.2f}s / {len(out)} statements")
con.close()
