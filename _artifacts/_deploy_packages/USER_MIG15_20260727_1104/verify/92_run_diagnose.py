# -*- coding: utf-8 -*-
"""30_auth_gap_diagnose.sql 실행기 — SELECT 결과를 fetch 하여 출력 (읽기 전용).
접속: _artifacts/_diagnostics/ora.py conn_info() 재사용 (.env.asis TOBE_DB_*)"""
import os
import sys

sys.stdout.reconfigure(encoding="utf-8")
BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.normpath(os.path.join(BASE, "..", "..", "_diagnostics")))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

SQL_FILE = os.path.join(BASE, "sql", "30_auth_gap_diagnose.sql")
text = open(SQL_FILE, encoding="utf-8").read().replace("\r", "")
stmts = [s.strip() for s in text.split(";") if s.strip() and not all(
    ln.strip().startswith("--") or not ln.strip() for ln in s.splitlines())]

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    for i, s in enumerate(stmts, 1):
        label = next((ln.strip() for ln in s.splitlines() if ln.strip().startswith("-- [진단")), f"[stmt {i}]")
        cur.execute(s)
        rows = cur.fetchall()
        cols = [c[0] for c in cur.description]
        print(f"\n===== {label} — {len(rows)} rows =====")
        print(" | ".join(cols))
        for r in rows[:400]:
            print(" | ".join("" if v is None else str(v) for v in r))
        if len(rows) > 400:
            print(f"... ({len(rows) - 400} rows 생략)")
print("\n[DONE] 진단 완료 (데이터 변경 없음)")
