# -*- coding: utf-8 -*-
"""00_PRECHECK / 90_VERIFY 를 사내에서 읽기 전용 실행 (SQL*Plus 명령 PROMPT/SET/COLUMN 은 출력·무시).
SELECT/WITH 문만 실행 — DML/DDL 은 거부(assert). 사용: python _run_readonly.py A_DB/00_PRECHECK_CLOUD.sql"""
import io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
from ora import conn_info
import oracledb

u, p, d = conn_info()
cur = oracledb.connect(user=u, password=p, dsn=d).cursor()
buf = []
for ln in pathlib.Path(sys.argv[1]).read_text(encoding="utf-8").split("\n"):
    if re.match(r"(?i)^\s*(SET|COLUMN)\b", ln) or ln.strip().startswith("--") or not ln.strip():
        continue
    if re.match(r"(?i)^\s*PROMPT\b", ln):
        print("\n" + ln.strip()[7:])
        continue
    buf.append(ln)
    if ln.rstrip().endswith(";"):
        sql = "\n".join(buf).rstrip().rstrip(";")
        buf = []
        assert re.match(r"(?is)^\s*(SELECT|WITH)\b", sql), "읽기 전용 아님: " + sql[:60]
        cur.execute(sql)
        cols = [c[0] for c in cur.description]
        rows = cur.fetchall()
        print("  " + " | ".join(cols))
        for r in rows:
            print("  " + " | ".join("" if v is None else str(v) for v in r))
        if not rows:
            print("  (0행)")
