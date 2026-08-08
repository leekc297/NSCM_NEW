#!/usr/bin/env python3
"""PKG_DMF0082 live SPEC/BODY 백업 덤프 — uicategory 작업 전 (2026-08-07)
USER_SOURCE 원문 그대로 CREATE OR REPLACE + '/' 종결로 저장 (1바이트 무수정 원칙)."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate"
TARGETS = [
    ("PACKAGE", OUT / "BACKUP_PKG_DMF0082_SPEC_pre_uicategory_20260807.sql"),
    ("PACKAGE BODY", OUT / "BACKUP_PKG_DMF0082_BODY_pre_uicategory_20260807.sql"),
]

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    for typ, path in TARGETS:
        cur.execute(
            "SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE=:t ORDER BY LINE",
            {"t": typ},
        )
        lines = [r[0] if r[0] is not None else "" for r in cur.fetchall()]
        if not lines:
            sys.exit(f"ERROR: USER_SOURCE 0 rows for {typ}")
        body = "".join(lines)
        if not body.endswith("\n"):
            body += "\n"
        path.write_text("CREATE OR REPLACE " + body + "/\n", encoding="utf-8", newline="\n")
        print(f"{typ}: {len(lines)} lines -> {path.name}")
    cur.execute(
        "SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')"
        " FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082'"
    )
    for r in cur.fetchall():
        print(r)
