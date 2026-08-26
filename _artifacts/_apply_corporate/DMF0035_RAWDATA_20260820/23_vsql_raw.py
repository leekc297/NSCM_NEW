# -*- coding: utf-8 -*-
"""V$SQL 원시 목록 (PROGRAM_ID=PKG_DMF0035 BODY) — 집계 없이 커서 단위 그대로 (읽기 전용)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0035' AND OBJECT_TYPE='PACKAGE BODY'""")
pid = cur.fetchone()[0]

print(f"{'SQL_ID':<14} {'CH':>2} {'PLINE':>6} {'EXEC':>6} {'EL_s':>9} {'s/exec':>8} {'BUFGETS':>13} {'DISK':>9} {'ROWS':>9}  TEXT")
cur.execute("""SELECT SQL_ID, CHILD_NUMBER, PROGRAM_LINE#, EXECUTIONS, ELAPSED_TIME, BUFFER_GETS,
                      DISK_READS, ROWS_PROCESSED, REPLACE(SUBSTR(SQL_TEXT,1,95),CHR(10),' ')
                 FROM V$SQL WHERE PROGRAM_ID=:p ORDER BY ELAPSED_TIME DESC""", {"p": pid})
tot = 0
for (sid, ch, pl, ex, el, bg, dr, rp, txt) in cur.fetchall():
    s = el / 1e6
    tot += s
    if s < 0.01:
        continue
    print(f"{sid:<14} {ch:>2} {pl:>6} {ex:>6} {s:>9.2f} {s/max(ex,1):>8.3f} {bg:>13} {dr:>9} {rp:>9}  {txt}")
print(f"\n[누적] {tot:.1f}s")

# 동적 SQL(EXECUTE IMMEDIATE/OPEN FOR) 은 PROGRAM_ID 가 안 붙을 수 있으므로 별도 스윕
print("\n=== PROGRAM_ID 무관 — GT_DM35 참조 상위 커서 (동적 SQL 포함) ===")
cur.execute("""SELECT SQL_ID, PROGRAM_ID, PROGRAM_LINE#, EXECUTIONS, ELAPSED_TIME, BUFFER_GETS,
                      DISK_READS, ROWS_PROCESSED, REPLACE(SUBSTR(SQL_TEXT,1,95),CHR(10),' ')
                 FROM V$SQL WHERE UPPER(SQL_TEXT) LIKE '%GT_DM35%'
                 ORDER BY ELAPSED_TIME DESC FETCH FIRST 25 ROWS ONLY""")
for (sid, pi, pl, ex, el, bg, dr, rp, txt) in cur.fetchall():
    print(f"{sid:<14} pid={pi} pl={pl} exec={ex} {el/1e6:>9.2f}s buf={bg} disk={dr} rows={rp}\n    {txt}")
con.close()
