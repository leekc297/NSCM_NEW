#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0082_no45_case.py — 통합테스트 No.45 신고 케이스 주차 단위 실측 (2026-08-18)

키(사용자 제공): 40 / LX INTL SINGAPORE / LX INTL SINGAPORE_SG_SIN / MPCKRMVLTA16 / CIF / Mass(=MPS) / E / USD

목적: 52주 구간에서 "수량은 있는데 판가가 없는 주차"를 센티널 처리 방식별로 센다.
  · AS-IS  = PLANT_SITE_ID / CELL_PROD_SITE_ID 원문 비교 (raw)
  · TO-BE  = [SENTINEL3] 변형 3형(' '/'-'/'--') = '-' 통일 비교 (normalized)
둘의 차이가 곧 "AS-IS는 막고 TO-BE는 통과" 의 크기다.
"""
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

K = {
    "div": "40",
    "ec": "LX INTL SINGAPORE",
    "site": "LX INTL SINGAPORE_SG_SIN",
    "item": "MPCKRMVLTA16",
    "inco": "CIF",
}

NORM = ("CASE WHEN TRIM({c}) IS NULL OR {c} IN ('-','--') THEN '-' ELSE {c} END")

QUERIES = [
    (
        "A 수량 원장 키 조합 (DM_PLN_MKT_FCST — 52주 구간, QTY<>0)",
        """SELECT MEASURE, FCST_TYPE, DOM_EXP,
                  NVL(REPLACE(PLANT_SITE_ID, ' ', '<sp>'), '(null)') AS PLANT_RAW,
                  NVL(CELL_PROD_SITE_ID,'(null)') AS CELL_RAW,
                  COUNT(*) CNT, MIN(YYYYMMDD) MIN_D, MAX(YYYYMMDD) MAX_D
             FROM DM_PLN_MKT_FCST
            WHERE DIVISION_ID=:div AND END_CUSTOMER=:ec AND SCM_SITE_ID=:site
              AND ITEM_ID=:item AND INCOTERMS=:inco
              AND NVL(QTY,0) <> 0
              AND YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
              AND YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
            GROUP BY MEASURE, FCST_TYPE, DOM_EXP, PLANT_SITE_ID, CELL_PROD_SITE_ID
            ORDER BY MEASURE, FCST_TYPE""",
    ),
    (
        "B 판가 원장 주차 커버리지 (LOC, PRICE<>0 — 52주 구간, PLANT 변형별)",
        """SELECT NVL(REPLACE(PLANT_SITE_ID,' ','<sp>'),'(null)') AS PLANT_RAW,
                  NVL(CELL_PROD_SITE_ID,'(null)') AS CELL_RAW, FCST_TYPE,
                  COUNT(DISTINCT YYYYMMDD) WEEKS, MIN(YYYYMMDD) MIN_D, MAX(YYYYMMDD) MAX_D
             FROM DM_PLN_CFM_SELLING_PRICE
            WHERE DIVISION_ID=:div AND END_CUSTOMER=:ec AND SCM_SITE_ID=:site
              AND ITEM_ID=:item AND INCOTERMS=:inco
              AND MEASURE='LOC' AND NVL(PRICE,0) <> 0
              AND YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
              AND YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
            GROUP BY PLANT_SITE_ID, CELL_PROD_SITE_ID, FCST_TYPE
            ORDER BY 1""",
    ),
    (
        "C 52주 달력 주차 수 (판정 분모)",
        """SELECT COUNT(DISTINCT BASIS_START_DATE) WEEKS
             FROM SCM_SYS_CALENDAR_M
            WHERE BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
              AND BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')""",
    ),
    (
        "D ⭐ 판가 미입력 주차 수 — AS-IS(raw) vs TO-BE(normalized)",
        f"""WITH WK AS (
              SELECT DISTINCT BASIS_START_DATE AS D FROM SCM_SYS_CALENDAR_M
               WHERE BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
                 AND BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')),
            Q AS (  -- 수량 행 (검증 대상 measure)
              SELECT DISTINCT PLANT_SITE_ID, CELL_PROD_SITE_ID, DOM_EXP, FCST_TYPE, MEASURE
                FROM DM_PLN_MKT_FCST
               WHERE DIVISION_ID=:div AND END_CUSTOMER=:ec AND SCM_SITE_ID=:site
                 AND ITEM_ID=:item AND INCOTERMS=:inco AND NVL(QTY,0)<>0
                 AND MEASURE IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                  WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE'
                                    AND SEGMENT1='MEASURE' AND VALID_YN='Y')),
            P AS (  -- 판가 행
              SELECT PLANT_SITE_ID, CELL_PROD_SITE_ID, DOM_EXP, FCST_TYPE, YYYYMMDD
                FROM DM_PLN_CFM_SELLING_PRICE
               WHERE DIVISION_ID=:div AND END_CUSTOMER=:ec AND SCM_SITE_ID=:site
                 AND ITEM_ID=:item AND INCOTERMS=:inco AND MEASURE='LOC' AND NVL(PRICE,0)<>0)
            SELECT Q.MEASURE, Q.FCST_TYPE,
                   NVL(REPLACE(Q.PLANT_SITE_ID,' ','<sp>'),'(null)') AS Q_PLANT,
                   COUNT(*) AS WEEKS_TOTAL,
                   SUM(CASE WHEN NOT EXISTS (
                         SELECT 1 FROM P WHERE P.YYYYMMDD = WK.D
                           AND P.PLANT_SITE_ID = Q.PLANT_SITE_ID
                           AND P.CELL_PROD_SITE_ID = Q.CELL_PROD_SITE_ID
                           AND P.DOM_EXP = Q.DOM_EXP AND P.FCST_TYPE = Q.FCST_TYPE)
                        THEN 1 ELSE 0 END) AS MISSING_ASIS_RAW,
                   SUM(CASE WHEN NOT EXISTS (
                         SELECT 1 FROM P WHERE P.YYYYMMDD = WK.D
                           AND {NORM.format(c='P.PLANT_SITE_ID')} = {NORM.format(c='Q.PLANT_SITE_ID')}
                           AND {NORM.format(c='P.CELL_PROD_SITE_ID')} = {NORM.format(c='Q.CELL_PROD_SITE_ID')}
                           AND P.DOM_EXP = Q.DOM_EXP AND P.FCST_TYPE = Q.FCST_TYPE)
                        THEN 1 ELSE 0 END) AS MISSING_TOBE_NORM
              FROM Q CROSS JOIN WK
             GROUP BY Q.MEASURE, Q.FCST_TYPE, Q.PLANT_SITE_ID
             ORDER BY 1,2,3""",
    ),
]


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
    for title, sql in QUERIES:
        print(f"\n{'=' * 125}\n[{title}]\n{'=' * 125}")
        try:
            cur.execute(sql, K)
            cols = [c[0] for c in cur.description]
            rows = cur.fetchall()
            print(" | ".join(cols))
            print("-" * 125)
            for r in rows:
                print(" | ".join("" if v is None else str(v) for v in r))
            print(f"({len(rows)} rows)")
        except Exception as e:  # noqa: BLE001
            print(f"ERROR: {str(e)[:160]}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
