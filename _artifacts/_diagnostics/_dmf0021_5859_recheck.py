#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0021_5859_recheck.py — 통합테스트 1st No.58/59 보완 실재 재확인 (2026-08-18)

문서(대조표) 판정을 신뢰하지 않고 사내 DB 실측으로 확인한다.
  A PKG_DMF0021 상태(VALID) + RTFGATE 마커 라인 실재 (GET/SAVE 2곳) + MSG00704 발화
  B lookup GET_ADMIN_GROUP_MEASURE (DMF0021 · RTF_SYS_RP) 요일/시각 행
  C MSG00704 원장 등재 (3언어)
  D 현재 시각 기준 게이트 개폐 상태 (division 별 — 지금 RTF 수정 가능한가)
"""
import os
import sys
import time

import oracledb

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

QUERIES = [
    (
        "A-1 PKG_DMF0021 오브젝트 상태",
        """SELECT OBJECT_NAME, OBJECT_TYPE, STATUS,
                  TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') AS LAST_DDL
             FROM ALL_OBJECTS
            WHERE OBJECT_NAME = 'PKG_DMF0021' AND OWNER = 'SCM_MGR'
            ORDER BY OBJECT_TYPE""",
    ),
    (
        "A-2 RTFGATE / MSG00704 마커 소스 라인 (사내 배포본 실측)",
        """SELECT LINE, RTRIM(SUBSTR(TEXT, 1, 110)) AS SRC
             FROM ALL_SOURCE
            WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0021' AND TYPE = 'PACKAGE BODY'
              AND (UPPER(TEXT) LIKE '%RTFGATE%' OR TEXT LIKE '%MSG00704%')
            ORDER BY LINE""",
    ),
    (
        "B lookup GET_ADMIN_GROUP_MEASURE — DMF0021 RTF_SYS_RP (요일 A1 / 시각 A2)",
        """SELECT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4,
                  ATTRIBUTE1 AS DAY_OF_WEEK, ATTRIBUTE2 AS HHMM, VALID_YN
             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
              AND SEGMENT2 = 'DMF0021'
            ORDER BY SEGMENT3, SEGMENT4, SEGMENT1""",
    ),
    (
        "C MSG00704 원장 등재 (언어별)",
        """SELECT MSG_ID, LANG_CODE, SUBSTR(MSG_NM, 1, 80) AS MSG_NM
             FROM SCM_ADM_MSG_M
            WHERE MSG_ID = 'MSG00704'
            ORDER BY LANG_CODE""",
    ),
    (
        "D 현재 시각 기준 게이트 개폐 (division 별 — OPEN = 지금 RTF 수정 허용)",
        """SELECT SEGMENT3 AS DIVISION_ID, SEGMENT1 AS GRP_OR_USER,
                  ATTRIBUTE1 AS DY, ATTRIBUTE2 AS HHMM,
                  TO_CHAR(TRUNC(SYSDATE,'IW')
                          + DECODE(ATTRIBUTE1,'MON',0,'TUE',1,'WED',2,'THU',3,'FRI',4,'SAT',5,'SUN',6)
                          + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2,1,2)),0)/24
                          + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2,3,2)),0)/1440,
                          'YYYY-MM-DD HH24:MI') AS GATE_OPEN_AT,
                  CASE WHEN ATTRIBUTE1 IS NULL
                         OR SYSDATE >= TRUNC(SYSDATE,'IW')
                            + DECODE(ATTRIBUTE1,'MON',0,'TUE',1,'WED',2,'THU',3,'FRI',4,'SAT',5,'SUN',6)
                            + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2,1,2)),0)/24
                            + NVL(TO_NUMBER(SUBSTR(ATTRIBUTE2,3,2)),0)/1440
                       THEN 'OPEN' ELSE 'BLOCKED' END AS GATE_NOW
             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
              AND SEGMENT2 = 'DMF0021' AND SEGMENT4 = 'RTF_SYS_RP' AND VALID_YN = 'Y'
            ORDER BY SEGMENT3, SEGMENT1""",
    ),
    (
        "D-2 SYSDATE / 주 시작(IW)",
        """SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI DY') AS NOW_DT,
                  TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYY-MM-DD DY') AS WEEK_START
             FROM DUAL""",
    ),
]


def connect(retries=10, wait=10):
    import ora  # 접속정보 규약 단일 출처 (룰 32)

    u, p, d = ora.conn_info()
    last = None
    for _ in range(retries):
        try:
            return oracledb.connect(user=u, password=p, dsn=d)
        except Exception as e:  # noqa: BLE001
            last = e
            time.sleep(wait)
    raise SystemExit(f"접속 실패({retries}회): {last}")


def main():
    con = connect()
    cur = con.cursor()
    for title, sql in QUERIES:
        print(f"\n{'=' * 110}\n[{title}]\n{'=' * 110}")
        try:
            cur.execute(sql)
            cols = [c[0] for c in cur.description]
            rows = cur.fetchall()
            print(" | ".join(cols))
            print("-" * 110)
            for r in rows:
                print(" | ".join("" if v is None else str(v) for v in r))
            print(f"({len(rows)} rows)")
        except Exception as e:  # noqa: BLE001
            print(f"ERROR: {e}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
