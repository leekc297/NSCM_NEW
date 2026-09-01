#!/usr/bin/env python3
"""사내 적용 후 라이브 PKG_DMF0044 BODY 재추출 → 클라우드 이관본 (hook #136 실측 규약)."""
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
        cur.execute(
            """SELECT text FROM all_source
                WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type='PACKAGE BODY'
                ORDER BY line"""
        )
        body = "".join(r[0] for r in cur.fetchall())
        sql = "CREATE OR REPLACE " + body.rstrip("\n") + "\n/\n"
        out = OUT / "11_PKG_DMF0044_BODY.sql"
        out.write_text(sql, encoding="utf-8", newline="\n")
        # 마커 자가검증 — 이관본 파일 자체에서 카운트
        for m in ("E20260828-LOCDELSARG", "E20260820-CFMERGE", "E20260820-CFSETBASED",
                  "E20260820-CFNOSTATS", "E20260820-EXAUTH", "E20260812-DS2"):
            print(m, "=", sum(1 for line in sql.splitlines() if m in line), "lines")
        print("written:", out.name, len(sql), "bytes")


if __name__ == "__main__":
    main()
