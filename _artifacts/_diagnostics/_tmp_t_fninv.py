#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_fninv.py — hook #129 §2.2 1단계: SELECT 목록 함수 전수 인벤토리 (읽기 전용)

+ 현재 live 마커 실측 (내 배포가 타인 배포를 덮었는지 확인)
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MARKS = ["AUTHUNION 2026-08-09", "PIVOTSEL 2026-08-10", "PRODUCTDETAIL 2026-08-10",
         "SEQGRP 2026-08-10", "ETCDEL 2026-08-10", "DYNSAMP 2026-08-10",
         "DYNSAMP2 2026-08-10", "DYNSAMP3 2026-08-10", "NODATAGUARD 2026-08-10",
         "DESCNULL 2026-08-10", "DESCDEF 2026-08-10", "TUNE-T 2026-08-10"]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        print("=== live BODY 마커 실측 ===")
        for m in MARKS:
            cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""",
                        {"m": m.replace("-", "\\-")})
            print("  %-28s = %s" % (m, cur.fetchone()[0]))
        cur.execute("""SELECT TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' AND OBJECT_TYPE='PACKAGE BODY'""")
        print("  BODY LAST_DDL/STATUS =", cur.fetchone())

        print("\n=== PKG_DMF0044 BODY 내 함수 호출 전수 (FN_/UF_) ===")
        cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                          AND REGEXP_LIKE(TEXT, '(FN_|UF_)[A-Z0-9_]+\\s*\\(', 'i')
                          AND LTRIM(TEXT) NOT LIKE '--%'
                        ORDER BY LINE""")
        rows = cur.fetchall()
        import re
        names = {}
        for ln, txt in rows:
            print("  L%-5s %s" % (ln, txt.strip()[:150]))
            for nm in re.findall(r"\b((?:FN_|UF_)[A-Z0-9_]+)\s*\(", txt, re.I):
                names.setdefault(nm.upper(), []).append(ln)
        print("(%d 행)" % len(rows))

        print("\n=== 함수별 호출 라인 요약 ===")
        for nm, lns in sorted(names.items()):
            print("  %-34s %2d회  L%s" % (nm, len(lns), ",".join(map(str, lns))))

        print("\n=== 각 함수 원본 (ALL_SOURCE) ===")
        for nm in sorted(names):
            cur.execute("""SELECT OWNER, TYPE, LINE, RTRIM(TEXT) FROM ALL_SOURCE
                            WHERE NAME=:n AND OWNER IN ('SCM_MGR','SCMD_APP') ORDER BY OWNER, LINE""",
                        {"n": nm})
            src = cur.fetchall()
            print("\n----- %s (%d 행) -----" % (nm, len(src)))
            if not src:
                cur.execute("""SELECT OWNER, OBJECT_TYPE FROM ALL_OBJECTS WHERE OBJECT_NAME=:n""", {"n": nm})
                print("  (ALL_SOURCE 없음) ALL_OBJECTS:", cur.fetchall())
            for _, _, ln, txt in src:
                print("  %4s %s" % (ln, txt))


if __name__ == "__main__":
    main()
