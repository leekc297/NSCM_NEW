#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_fnsrc.py — 대상 함수 원본 열람 + 원천표 카디널리티/인덱스 실측 (읽기 전용)"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

FNS = sys.argv[1:] or ["FN_GET_COUNTRY_KR_NAME", "FN_GET_DM_MKT_OWNER_NAME", "FN_SCM_SPLIT"]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for nm in FNS:
            cur.execute("""SELECT RTRIM(TEXT) FROM ALL_SOURCE
                            WHERE OWNER='SCM_MGR' AND NAME=:n ORDER BY LINE""", {"n": nm})
            src = [r[0] for r in cur.fetchall()]
            print("\n========== %s (%d 행) ==========" % (nm, len(src)))
            print("\n".join(src))


if __name__ == "__main__":
    main()
