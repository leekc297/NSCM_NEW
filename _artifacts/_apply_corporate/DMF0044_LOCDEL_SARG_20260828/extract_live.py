#!/usr/bin/env python3
"""사내 라이브 PKG_DMF0044 SPEC/BODY 추출 — LOCDELSARG 패치 기반 원문 (2026-08-28)."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

OUT = pathlib.Path(__file__).resolve().parent


def dump(cur, obj_type: str, fname: str) -> None:
    cur.execute(
        """SELECT text FROM all_source
            WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type=:t ORDER BY line""",
        t=obj_type,
    )
    lines = [r[0] for r in cur.fetchall()]
    body = "".join(lines)
    # CREATE OR REPLACE 원형으로 감싼다 (ALL_SOURCE 는 'PACKAGE ...' 부터 시작)
    sql = "CREATE OR REPLACE " + body
    if not sql.rstrip().endswith("/"):
        sql = sql.rstrip("\n") + "\n/\n"
    (OUT / fname).write_text(sql, encoding="utf-8", newline="\n")
    print(f"{fname}: {len(lines)} lines, {len(sql)} bytes")


def main() -> None:
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        dump(cur, "PACKAGE", "10_PKG_DMF0044_SPEC_LIVE.sql")
        dump(cur, "PACKAGE BODY", "11_PKG_DMF0044_BODY_LIVE.sql")


if __name__ == "__main__":
    main()
