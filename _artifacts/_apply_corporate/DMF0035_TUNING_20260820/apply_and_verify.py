# -*- coding: utf-8 -*-
"""E20260820-WFITEMPERF 적용 + 검증 — BODY 교체 → 컴파일 확인 → 재계측 → 값 동등성 diff."""
import io
import json
import subprocess
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_TUNING_20260820"
body = open(BASE + r"\PKG_DMF0035_BODY_PATCHED.sql", encoding="utf-8").read()
assert body.lstrip().upper().startswith("PACKAGE BODY"), body[:60]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")
cur.execute("CREATE OR REPLACE " + body)
print("[apply] CREATE OR REPLACE PACKAGE BODY 실행")

# 룰 #136 — 대상 객체 실측
cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0035'")
for r in cur.fetchall():
    print("[status]", r)
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'")
errs = cur.fetchone()[0]
print(f"[errors] {errs}건")
if errs:
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY")
    for r in cur.fetchall():
        print("  ⛔", r)
    sys.exit(1)
cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0035' AND OBJECT_TYPE='PACKAGE BODY'")
assert cur.fetchone()[0] == "VALID", "BODY INVALID — 중단"
con.close()

# 재계측 + 캡처 (새 세션)
r = subprocess.run([sys.executable, BASE + r"\capture_mkt.py", BASE + r"\after_rc1.json"],
                   capture_output=True)
print(r.stdout.decode("utf-8", errors="replace").strip())
if r.returncode:
    print(r.stderr.decode("utf-8", errors="replace")[-1500:])
    sys.exit(1)

# 값 동등성 diff
b = json.load(open(BASE + r"\baseline_rc1.json", encoding="utf-8"))
a = json.load(open(BASE + r"\after_rc1.json", encoding="utf-8"))
rb, ra = b["rows"], a["rows"]
print(f"[diff] 행수 {len(rb)} → {len(ra)} / 시간 {b['elapsed_s']}s → {a['elapsed_s']}s")
sb = [json.dumps(x, sort_keys=True, ensure_ascii=False) for x in rb]
sa = [json.dumps(x, sort_keys=True, ensure_ascii=False) for x in ra]
if sb == sa:
    print("[diff] 전행 완전 일치 — 값 동등성 PASS")
else:
    only_b = [x for x in sb if x not in set(sa)]
    only_a = [x for x in sa if x not in set(sb)]
    print(f"[diff] 불일치 — baseline 전용 {len(only_b)} / after 전용 {len(only_a)}")
    for x in only_b[:3]:
        print("  B>", x[:200])
    for x in only_a[:3]:
        print("  A>", x[:200])
    sys.exit(2)
