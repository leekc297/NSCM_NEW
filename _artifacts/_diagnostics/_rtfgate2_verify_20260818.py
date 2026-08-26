#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_rtfgate2_verify_20260818.py — RTFGATE2 판정 3분기 실증 (통합테스트 1st No.58)

배포본 산식을 그대로 재현해 division 별 판정을 뽑고, 앵커를 인위 이동시켜
0건(Cutoff 미완료) / 1일자(1차 완료) / 2일자 이상(2차 완료) 세 분기를 모두 증명한다.
(리터럴 출현이 아니라 판정 결과로 확인 — 게이트 오탐 계보 회피)
"""
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

ANCHOR = """(CASE WHEN TRUNC(SYSDATE,'IW')
                       + DECODE(B.ATTRIBUTE1,'MON',0,'TUE',1,'WED',2,'THU',3,'FRI',4,'SAT',5,'SUN',6)
                       + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2,1,2)),0)/24
                       + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2,3,2)),0)/1440 > SYSDATE
                  THEN TRUNC(SYSDATE,'IW')-7 ELSE TRUNC(SYSDATE,'IW') END)
            + DECODE(B.ATTRIBUTE1,'MON',0,'TUE',1,'WED',2,'THU',3,'FRI',4,'SAT',5,'SUN',6)
            + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2,1,2)),0)/24
            + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2,3,2)),0)/1440"""

QUERIES = [
    (
        "V1 현행 판정 — division 별 (배포 산식 1:1)",
        f"""SELECT DISTINCT B.SEGMENT3 DIVISION_ID, B.ATTRIBUTE1 A1, B.ATTRIBUTE2 A2,
                  TO_CHAR({ANCHOR},'YYYY-MM-DD HH24:MI DY') ANCHOR_AT,
                  (SELECT COUNT(DISTINCT V.YYYYMMDD) FROM DM_MST_VERSION V
                    WHERE V.VERSION_TYPE='SP_W' AND V.DIVISION_ID=B.SEGMENT3
                      AND V.CREATION_DATE > {ANCHOR}) CUTOFF_DAYS,
                  CASE WHEN (SELECT COUNT(DISTINCT V.YYYYMMDD) FROM DM_MST_VERSION V
                              WHERE V.VERSION_TYPE='SP_W' AND V.DIVISION_ID=B.SEGMENT3
                                AND V.CREATION_DATE > {ANCHOR}) = 1
                       THEN 'ALLOW' ELSE 'BLOCK' END VERDICT
             FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND B.SEGMENT2='DMF0021'
              AND B.SEGMENT4='RTF_SYS_RP' AND B.VALID_YN='Y'
            ORDER BY 1""",
    ),
    (
        "V2 반증 A — 앵커를 '지금'으로 이동 (Cutoff 미완료 상황): 전 division BLOCK 이어야 함",
        """SELECT DISTINCT B.SEGMENT3 DIVISION_ID,
                  (SELECT COUNT(DISTINCT V.YYYYMMDD) FROM DM_MST_VERSION V
                    WHERE V.VERSION_TYPE='SP_W' AND V.DIVISION_ID=B.SEGMENT3
                      AND V.CREATION_DATE > SYSDATE) CUTOFF_DAYS,
                  CASE WHEN (SELECT COUNT(DISTINCT V.YYYYMMDD) FROM DM_MST_VERSION V
                              WHERE V.VERSION_TYPE='SP_W' AND V.DIVISION_ID=B.SEGMENT3
                                AND V.CREATION_DATE > SYSDATE) = 1
                       THEN 'ALLOW' ELSE 'BLOCK' END VERDICT
             FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND B.SEGMENT2='DMF0021'
              AND B.SEGMENT4='RTF_SYS_RP' AND B.VALID_YN='Y'
            ORDER BY 1""",
    ),
    (
        "V3 반증 B — 앵커를 4주 전으로 이동 (2차 이상 Cutoff 도래): 전 division BLOCK 이어야 함",
        """SELECT DISTINCT B.SEGMENT3 DIVISION_ID,
                  (SELECT COUNT(DISTINCT V.YYYYMMDD) FROM DM_MST_VERSION V
                    WHERE V.VERSION_TYPE='SP_W' AND V.DIVISION_ID=B.SEGMENT3
                      AND V.CREATION_DATE > TRUNC(SYSDATE,'IW')-28) CUTOFF_DAYS,
                  CASE WHEN (SELECT COUNT(DISTINCT V.YYYYMMDD) FROM DM_MST_VERSION V
                              WHERE V.VERSION_TYPE='SP_W' AND V.DIVISION_ID=B.SEGMENT3
                                AND V.CREATION_DATE > TRUNC(SYSDATE,'IW')-28) = 1
                       THEN 'ALLOW' ELSE 'BLOCK' END VERDICT
             FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND B.SEGMENT2='DMF0021'
              AND B.SEGMENT4='RTF_SYS_RP' AND B.VALID_YN='Y'
            ORDER BY 1""",
    ),
    (
        "V4 SalesAmt_LOC 무영향 확인 (A1 NULL = 상시 허용 — RTF 축만 게이트)",
        """SELECT SEGMENT3 DIVISION_ID, SEGMENT4 MEASURE, COUNT(*) LOOKUP_ROWS,
                  MAX(NVL(ATTRIBUTE1,'(null)')) A1
             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0021'
              AND SEGMENT4='SalesAmt_LOC' AND VALID_YN='Y'
            GROUP BY SEGMENT3, SEGMENT4 ORDER BY 1""",
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
        print(f"\n{'=' * 105}\n[{title}]\n{'=' * 105}")
        try:
            cur.execute(sql)
            cols = [c[0] for c in cur.description]
            rows = cur.fetchall()
            print(" | ".join(cols))
            print("-" * 105)
            for r in rows:
                print(" | ".join("" if v is None else str(v) for v in r))
            print(f"({len(rows)} rows)")
        except Exception as e:  # noqa: BLE001
            print(f"ERROR: {e}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
