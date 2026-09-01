#!/usr/bin/env python3
"""사내 라이브 PKG_DMF0044/PKG_DMF0049 BODY 추출 — SARGSWEEP 패치 기반 원문."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

OUT = pathlib.Path(__file__).resolve().parent


def main() -> None:
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for pkg in ("PKG_DMF0044", "PKG_DMF0049"):
            cur.execute(
                """SELECT text FROM all_source
                    WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE BODY' ORDER BY line""",
                n=pkg,
            )
            body = "".join(r[0] for r in cur.fetchall())
            sql = "CREATE OR REPLACE " + body.rstrip("\n") + "\n/\n"
            f = OUT / f"{pkg}_BODY_LIVE.sql"
            f.write_text(sql, encoding="utf-8", newline="\n")
            print(f.name, len(sql), "bytes")


if __name__ == "__main__":
    main()
