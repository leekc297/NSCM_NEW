#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0082_endcust_parity_map.py — DMF0082 그리드 END_CUSTOMER 파리티 대조 기초자료 (2026-08-18)

hook #138 절차: 주석 제거 전처리본에서만 라이브를 센다.
  A. TO-BE 배포본 PKG_DMF0082 BODY 덤프 → strip → 라이브 `AS END_CUSTOMER` 전수 + 원천 테이블
  B. AS-IS 전처리본(live.sql)의 라이브 26개소 + 원천 테이블
  C. 원장 실데이터 — DM_PLN_CFM_MKT_DEMAND_PLAN(81) END_CUSTOMER 분포 (GET 원천/SAVE 대상)
"""
import re
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from strip_code_comments import strip_sql  # noqa: E402

ASIS_LIVE = r"C:\Projects\NSCM\_artifacts\_diagnostics\_asis_DMF0082_GET_MAIN_DATA.live.sql"
TOBE_DUMP = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_BODY_deployed_20260818.sql"
TOBE_LIVE = TOBE_DUMP.replace(".sql", ".live.sql")


def find_source_table(lines, hit_idx, max_scan=60):
    """히트 라인에서 아래로 스캔해 첫 FROM <table> 을 찾는다 (블록의 원천 테이블)."""
    for j in range(hit_idx, min(hit_idx + max_scan, len(lines))):
        m = re.search(r"\bFROM\s+(?:SCM_MGR\.)?([A-Z0-9_#\.]+)", lines[j], re.I)
        if m:
            return m.group(1), j + 1
    return "(미확인)", -1


def scan(path, patterns, label):
    text = open(path, encoding="utf-8", errors="replace").read()
    lines = text.splitlines()
    print(f"\n{'=' * 110}\n[{label}] — 라이브 전수 (전처리본 기준)\n{'=' * 110}")
    out = []
    for pat, tag in patterns:
        for i, ln in enumerate(lines):
            if re.search(pat, ln):
                tbl, at = find_source_table(lines, i)
                out.append((i + 1, tag, tbl))
    out.sort()
    for line_no, tag, tbl in out:
        print(f"   L{line_no:>6} | {tag:<28} | FROM {tbl}")
    print(f"   (계 {len(out)}개소)")
    return out


def main():
    import ora

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

    # A. 배포본 덤프 → 전처리
    cur.execute(
        """SELECT TEXT FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
            ORDER BY LINE"""
    )
    body = "".join(r[0] for r in cur.fetchall())
    open(TOBE_DUMP, "w", encoding="utf-8", newline="").write(
        "CREATE OR REPLACE " + body.rstrip() + "\n/\n"
    )
    open(TOBE_LIVE, "w", encoding="utf-8", newline="").write(
        strip_sql(open(TOBE_DUMP, encoding="utf-8").read())
    )
    print(f"[A0] 배포본 덤프 {len(body.splitlines())}줄 → 전처리본 {TOBE_LIVE}")

    pats = [
        (r"PROJECT_CODE\s+AS\s+END_CUSTOMER", "PROJECT_CODE AS END_CUSTOMER"),
        (r",\s*A\.END_CUSTOMER\b(?!_)", "A.END_CUSTOMER (실값)"),
    ]
    scan(TOBE_LIVE, pats, "A. TO-BE 배포본 PKG_DMF0082")
    scan(ASIS_LIVE, pats, "B. AS-IS DMF0082_GET_MAIN_DATA")

    # C. 원장 실데이터
    print(f"\n{'=' * 110}\n[C] DM_PLN_CFM_MKT_DEMAND_PLAN — div 81 END_CUSTOMER 실값 분포\n{'=' * 110}")
    cur.execute(
        """SELECT NVL(END_CUSTOMER,'(null)') EC, COUNT(*) CNT
             FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID='81'
            GROUP BY END_CUSTOMER ORDER BY 2 DESC FETCH FIRST 12 ROWS ONLY"""
    )
    for r in cur.fetchall():
        print(f"   {str(r[0]):<40} | {r[1]}")
    cur.execute(
        """SELECT COUNT(DISTINCT END_CUSTOMER) FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID='81'"""
    )
    print(f"   고유 {cur.fetchone()[0]}종")
    # 그 값이 사이트 END_CUSTOMER 인지 PROJECT_CODE 인지
    cur.execute(
        """WITH V AS (SELECT DISTINCT END_CUSTOMER EC FROM DM_PLN_CFM_MKT_DEMAND_PLAN
                       WHERE DIVISION_ID='81' AND END_CUSTOMER IS NOT NULL)
           SELECT COUNT(*) TOTAL,
                  SUM(CASE WHEN EXISTS (SELECT 1 FROM SCM_MST_SITE S
                        WHERE S.DIVISION_ID='81' AND S.END_CUSTOMER=V.EC) THEN 1 ELSE 0 END) AS_SITE_EC,
                  SUM(CASE WHEN EXISTS (SELECT 1 FROM SCM_MST_PROJECT P
                        WHERE P.DIVISION_ID='81' AND P.PROJECT_CODE=V.EC) THEN 1 ELSE 0 END) AS_PROJECT
             FROM V"""
    )
    r = cur.fetchone()
    print(f"   판정: 고유 {r[0]}종 중 사이트 END_CUSTOMER 매칭 {r[1]} / PROJECT_CODE 매칭 {r[2]}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
