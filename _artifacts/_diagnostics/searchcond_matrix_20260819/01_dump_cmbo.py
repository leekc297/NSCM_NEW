#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""01_dump_cmbo.py — SCM_ADM_CMBO_SQL_M 전건 덤프 → cmbo_meta.json

DMF 13UI 조회조건 MATRIX 데이터 원천 ① (플랜 §1).
- 전건 (165본 기대) SQL_ID / MDU_DIVS_CD (복합키 — ProjectModelMapping 2건) / SQL_NM / SQL_DTL_CTN / USE_YN
- @토큰 파싱: BE makeComboQuery 와 동일 정규식 @(\\w+) — 대소문자 원표기 유지
"""
import json
import os
import re
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "cmbo_meta.json")


def main():
    u, p, d = ora.conn_info()
    con = None
    for _ in range(10):
        try:
            con = oracledb.connect(user=u, password=p, dsn=d)
            break
        except Exception:  # noqa: BLE001
            time.sleep(10)
    if con is None:
        raise SystemExit("접속 실패")
    cur = con.cursor()
    cur.execute(
        """SELECT SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN
             FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
            ORDER BY SQL_ID, MDU_DIVS_CD"""
    )
    rows = []
    for sql_id, mdu, nm, ctn, use_yn in cur.fetchall():
        body = ctn or ""
        # BE 치환 엔진과 동일 패턴 (BaseService.makeComboQuery @(\w+)) — 원표기 그대로 수집
        tokens = sorted(set(re.findall(r"@\w+", body)))
        rows.append(
            {
                "SQL_ID": sql_id,
                "MDU_DIVS_CD": mdu,
                "SQL_NM": nm,
                "USE_YN": use_yn,
                "TOKENS": tokens,
                "SQL_DTL_CTN": body,
            }
        )
    cur.close()
    con.close()
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(rows, f, ensure_ascii=False, indent=1)
    print(f"덤프 {len(rows)}건 → {OUT}")
    dup = {}
    for r in rows:
        dup.setdefault(r["SQL_ID"], []).append(r["MDU_DIVS_CD"])
    multi = {k: v for k, v in dup.items() if len(v) > 1}
    print(f"복합키(동일 SQL_ID 다건): {multi}")
    tok_all = sorted({t for r in rows for t in r["TOKENS"]})
    print(f"@토큰 종류 {len(tok_all)}: {tok_all}")


if __name__ == "__main__":
    main()
