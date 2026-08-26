# -*- coding: utf-8 -*-
"""다음 병목 `INSERT INTO GT_DM35_RAW_DATA` 구조 실측 (읽기 전용).

클라우드 실측: SQL_ID g0w0gvnn7rkb2 / 307.1초·회 / buffer 4.55M / 16,776행 /
  대기 `cell single block physical read` — VERPUSH 직전 문장과 동일 계열 신호.
확인 목표: 이 문장도 버전 술어가 테이블 접근 뒤에만 걸리는 구조인지(= 같은 처방 적용 가능한지).
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
rows = cur.fetchall()
open(BASE + r"\PKG_DMF0035_BODY_LIVE_POSTVERPUSH.sql", "w", encoding="utf-8").write(
    "".join(t if t.endswith("\n") else t + "\n" for _, t in rows))
print(f"[dump] {len(rows)} lines (VERPUSH 적용본)")

starts = [ln for ln, t in rows if re.search(r"INSERT INTO\s+SCM_MGR\.GT_DM35_RAW_DATA\b", t, re.I)]
print("INSERT INTO GT_DM35_RAW_DATA 위치:", starts)

for s in starts:
    print(f"\n=== L{s} 이후 원천표/조인/술어 (120줄 스캔) ===")
    for ln, t in rows[s - 1: s + 120]:
        st = t.strip()
        if re.search(r"\b(FROM|JOIN|WHERE|AND|VERSION_NO|DIVISION_ID)\b", st, re.I) and not st.startswith("--"):
            if re.search(r"(FROM|JOIN)\s+SCM_MGR\.\w+|VERSION_NO|DIVISION_ID\s*=", st, re.I):
                print(f"  L{ln}: {st[:135]}")
con.close()
