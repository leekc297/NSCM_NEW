#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0021_ut_probe.py — DMF0021 단위테스트 3항목 실측 probe (2026-08-18)

단일 연결 안에서 필요한 실측을 모두 수행한다 (로컬 소켓 버퍼 고갈로 접속당 1쿼리 방식이
간헐 실패하는 환경 대응 — 재시도 포함).

축:
  P1 SAVE 메시지 원장 등재 여부 (SP 가 반환하는 MSG00457~462 등)
  P2 Cutoff 원장 DM_MST_VERSION — VERSION_TYPE 별 생성 요일 패턴 (RTFGATE 시간창 근사와 대조)
  P3 titleSet 개인화 (SCM_MST_TITLESET_USER) division 스코프 유무 + 실데이터
"""
import os
import sys
import time

import oracledb

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

QUERIES = [
    (
        "P1 SAVE 메시지 원장 등재",
        """SELECT MSG_ID, SUBSTR(MSG_NM, 1, 70) AS MSG_NM
             FROM SCM_ADM_MSG_M
            WHERE MSG_ID IN ('MSG00328','MSG00428','MSG00457','MSG00458','MSG00459',
                             'MSG00460','MSG00461','MSG00462','MSG00467','MSG00704')
            ORDER BY MSG_ID""",
    ),
    (
        "P2-a Cutoff 생성 요일 패턴 (2026-06-01~, 40/81)",
        """SELECT VERSION_TYPE, DIVISION_ID,
                  TO_CHAR(TO_DATE(YYYYMMDD,'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=ENGLISH') AS DY,
                  COUNT(*) AS CNT
             FROM DM_MST_VERSION
            WHERE DIVISION_ID IN ('40','81')
              AND VERSION_TYPE IN ('SP_W','SF_W','MF_W','CF_W')
              AND YYYYMMDD >= '20260601'
            GROUP BY VERSION_TYPE, DIVISION_ID,
                     TO_CHAR(TO_DATE(YYYYMMDD,'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=ENGLISH')
            ORDER BY 1, 2, 4 DESC""",
    ),
    (
        "P2-b 최근 4주 Cutoff 이력 (SP_W/SF_W)",
        """SELECT DIVISION_ID, VERSION_TYPE, YYYYMMDD, VERSION_NO,
                  TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI') AS CRE_DT,
                  TO_CHAR(TO_DATE(YYYYMMDD,'YYYYMMDD'),'DY','NLS_DATE_LANGUAGE=ENGLISH') AS DY
             FROM DM_MST_VERSION
            WHERE DIVISION_ID IN ('40','81')
              AND VERSION_TYPE IN ('SP_W','SF_W')
              AND YYYYMMDD >= '20260720'
            ORDER BY DIVISION_ID, VERSION_TYPE, YYYYMMDD DESC""",
    ),
    (
        "P3-a TITLESET_USER 컬럼 (division 스코프 유무)",
        """SELECT COLUMN_NAME, DATA_TYPE
             FROM ALL_TAB_COLUMNS
            WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = 'SCM_MST_TITLESET_USER'
            ORDER BY COLUMN_ID""",
    ),
    (
        "P3-b DMF0021 개인화 저장 현황 (사용자별 컬럼 수)",
        """SELECT USER_ID, COLUMN_TYPE, COUNT(*) AS CNT
             FROM SCM_MST_TITLESET_USER
            WHERE PROGRAM_ID = 'DMF0021'
            GROUP BY USER_ID, COLUMN_TYPE
            ORDER BY 1, 2""",
    ),
]


def connect(retries=20, wait=15):
    import ora  # 접속정보 규약 단일 출처 (룰 32)

    u, p, d = ora.conn_info()
    last = None
    for i in range(retries):
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
        print(f"\n{'=' * 100}\n[{title}]\n{'=' * 100}")
        try:
            cur.execute(sql)
            cols = [c[0] for c in cur.description]
            rows = cur.fetchall()
            print(" | ".join(cols))
            print("-" * 100)
            for r in rows:
                print(" | ".join("" if v is None else str(v) for v in r))
            print(f"({len(rows)} rows)")
        except Exception as e:  # noqa: BLE001
            print(f"ERROR: {e}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
