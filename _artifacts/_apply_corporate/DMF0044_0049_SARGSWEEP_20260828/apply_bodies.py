#!/usr/bin/env python3
"""SARGSWEEP 정정 BODY 2본 사내 적용 + 검증 (VALID·마커·USER_ERRORS)."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
FILES = {"PKG_DMF0044": "PKG_DMF0044_BODY_LIVE.sql", "PKG_DMF0049": "PKG_DMF0049_BODY_LIVE.sql"}


def main() -> None:
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")
        for pkg, fname in FILES.items():
            sql = (HERE / fname).read_text(encoding="utf-8").rstrip()
            if sql.endswith("/"):
                sql = sql[:-1].rstrip()
            cur.execute(sql)
            print(f"{pkg}: CREATE OR REPLACE BODY 실행 완료")
            cur.execute(
                """SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS')
                     FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n ORDER BY object_type""",
                n=pkg,
            )
            for r in cur.fetchall():
                print("  OBJ:", r)
            cur.execute(
                """SELECT COUNT(*) FROM all_source
                    WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE BODY'
                      AND text LIKE '%E20260828-SARGSWEEP%'""",
                n=pkg,
            )
            print("  MARKER SARGSWEEP lines:", cur.fetchone()[0])
            cur.execute(
                """SELECT line, position, SUBSTR(text,1,120) FROM all_errors
                    WHERE owner='SCM_MGR' AND name=:n ORDER BY sequence""",
                n=pkg,
            )
            errs = cur.fetchall()
            print("  ERRORS:", len(errs))
            for e in errs:
                print("   ", e)


if __name__ == "__main__":
    main()
