# -*- coding: utf-8 -*-
"""STEP B 5지점 중 **실제로 실행되어 검증된 지점**과 미실행(구조적 등가만 확보) 지점 구분 — 한계 명시용."""
import io
import re
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

cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = [(ln, t.rstrip("\n")) for ln, t in cur.fetchall()]
TXT = dict(src)
sites = [ln for ln, t in src if "E20260820-VERPUSH2" in t]
print(f"[STEP B 마커 라인] {len(sites)}곳: {sites}")

stmts = sorted({max(ln for ln, t in src if ln <= s and re.search(r"^\s*INSERT\s+INTO\s+SCM_MGR\.", t))
                for s in sites})
for st in stmts:
    end = next((k for k in range(st, max(TXT) + 1) if ";" in re.sub(r"--[^\n]*", "", TXT[k])), st)
    seg = "\n".join(TXT[k] for k in range(st, end + 1))
    led = sorted(set(re.findall(r"FROM SCM_MGR\.(DM_PLN_\w+_C)\b", seg)))
    n_push = seg.count("E20260820-VERPUSH2")
    cur.execute("""SELECT SQL_ID, EXECUTIONS, ROUND(ELAPSED_TIME/1e6,3), BUFFER_GETS, DISK_READS, ROWS_PROCESSED
                     FROM V$SQL WHERE PROGRAM_ID=:p AND PROGRAM_LINE# BETWEEN :a AND :b
                    ORDER BY LAST_ACTIVE_TIME DESC FETCH FIRST 4 ROWS ONLY""",
                {"p": pid, "a": st - 12, "b": end})
    rows = cur.fetchall()
    live = [r for r in rows if r[1] > 0]
    print(f"\n  문장 L{st}-{end}  지점 {n_push}곳  원장={','.join(led)}")
    print(f"    → {'실행 검증됨' if live else '⚠ 미실행 — 구조적 등가만 확보 (이번 케이스가 안 타는 분기)'}")
    for r in rows:
        print(f"       {r[0]} exec={r[1]} {r[2]}s buf={r[3]} disk={r[4]} rows={r[5]}")
con.close()
