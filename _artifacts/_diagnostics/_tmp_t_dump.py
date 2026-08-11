#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_dump.py — PKG_DMF0044 라이브 BODY dump + 선행 마커 실측 (읽기 전용)"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "_artifacts" / "_apply_corporate" / "BACKUP_PKG_DMF0044_BODY_pre_tunet_20260810.sql"

MARKS = [
    "AUTHUNION 2026-08-09",
    "20260805 MERGE-ON 파리티 복원",
    "PIVOTSEL 2026-08-10",
    "PRODUCTDETAIL 2026-08-10",
    "M.CALC_YN = '-'",
    "RPTGRP-STUB 2026-08-10",
    "NVL(d_Result_Date, '-')",
    "SEQGRP 2026-08-10",
    "ETCDEL 2026-08-10",
    "DYNSAMP 2026-08-10",
    "DYNSAMP2 2026-08-10",
    "DYNSAMP3 2026-08-10",
    "NODATAGUARD 2026-08-10",
    "DESCNULL 2026-08-10",
    "TUNE-T 2026-08-10",
]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                        AND TYPE='PACKAGE BODY' ORDER BY LINE""")
        rows = cur.fetchall()
    if not rows:
        sys.exit("[error] PACKAGE BODY 없음")
    body = "CREATE OR REPLACE " + "".join(r[0] for r in rows).lstrip()
    OUT.write_text(body, encoding="utf-8")
    print("[dump] %s (%d 행)" % (OUT, len(body.splitlines())))
    for m in MARKS:
        print("  마커 '%s' = %d" % (m, body.count(m)))


if __name__ == "__main__":
    main()
