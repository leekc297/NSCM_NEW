#!/usr/bin/env python3
"""사내 적용 후 라이브 PKG_DMF0044/PKG_DMF0049 BODY 재추출 → 클라우드 이관본 (hook #136)."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

OUT = pathlib.Path(__file__).resolve().parent
MARKERS = ("E20260828-SARGSWEEP", "E20260828-LOCDELSARG", "E20260820-CFMERGE",
           "E20260820-CFSETBASED", "E20260820-CFNOSTATS", "E20260820-EXAUTH",
           "E20260820-DIVIDSCALAR", "E20260812-DS2")


def main() -> None:
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for pkg, fname in (("PKG_DMF0044", "11_PKG_DMF0044_BODY.sql"),
                           ("PKG_DMF0049", "12_PKG_DMF0049_BODY.sql")):
            cur.execute(
                """SELECT text FROM all_source
                    WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE BODY' ORDER BY line""",
                n=pkg,
            )
            body = "".join(r[0] for r in cur.fetchall())
            sql = "CREATE OR REPLACE " + body.rstrip("\n") + "\n/\n"
            (OUT / fname).write_text(sql, encoding="utf-8", newline="\n")
            counts = {m: sum(1 for line in sql.splitlines() if m in line) for m in MARKERS}
            print(fname, len(sql), "bytes |", ", ".join(f"{k.split('-')[1]}={v}" for k, v in counts.items() if v))


if __name__ == "__main__":
    main()
