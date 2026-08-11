#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_hintreport.py — DBMS_XPLAN HINT_REPORT (읽기 전용)

19c 의 HINT_REPORT 는 '어떤 힌트가 왜 무시됐는지'를 옵티마이저가 직접 보고한다.
추측 대신 이걸로 확정한다.
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

SQLID = sys.argv[1] if len(sys.argv) > 1 else "fndp8c35xn8y5"
FMT = sys.argv[2] if len(sys.argv) > 2 else "TYPICAL +HINT_REPORT +ALIAS"


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(
            """SELECT PLAN_TABLE_OUTPUT FROM TABLE(
                   DBMS_XPLAN.DISPLAY_CURSOR(:s, NULL, :f))""",
            {"s": SQLID, "f": FMT},
        )
        for (line,) in cur.fetchall():
            print(line if line is not None else "")


if __name__ == "__main__":
    main()
