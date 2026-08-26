#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_verify_corp_20260818.py — 2026-08-18 사내 적용분 전수 재확인

이관 SQL 작성 전 게이트. 각 항목은 "적용했다"가 아니라 **대상 객체 실측**으로 판정한다(룰 #136).
"""
import sys
import time

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

CHECKS = [
    (
        "V1 DMF0021 RTFGATE2 (Cutoff 원장 판정) + MSG01001",
        """SELECT 'BODY 상태' AS AXIS, STATUS AS VAL, TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI') AS DTL
             FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0021' AND OBJECT_TYPE='PACKAGE BODY'
           UNION ALL
           SELECT 'RTFGATE2 마커', TO_CHAR(COUNT(*)), '기대 2' FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021' AND TYPE='PACKAGE BODY'
              AND TEXT LIKE '%[RTFGATE2 2026-08-18]%'
           UNION ALL
           SELECT 'MSG01001 발화', TO_CHAR(COUNT(*)), '기대 1' FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021' AND TYPE='PACKAGE BODY'
              AND TEXT LIKE '%V_S_CODE := ''MSG01001''%'
           UNION ALL
           SELECT 'MSG01001 원장', TO_CHAR(COUNT(*)), '기대 3(KO/EN/CN)' FROM SCM_ADM_MSG_M
            WHERE MSG_ID='MSG01001'""",
    ),
    (
        "V2 DMF0074 MRFPARITY (Excel Form 템플릿 MRF 필터 주석)",
        """SELECT 'BODY 상태' AS AXIS, STATUS AS VAL, TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI') AS DTL
             FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074' AND OBJECT_TYPE='PACKAGE BODY'
           UNION ALL
           SELECT 'MRFPARITY 마커', TO_CHAR(COUNT(*)), '기대 1' FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
              AND TEXT LIKE '%MRFPARITY 2026-08-18%'
           UNION ALL
           SELECT 'TEMPLATE MRF 활성(0이어야)', TO_CHAR(COUNT(*)), '기대 0' FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
              AND TEXT LIKE '              AND    NVL(ATTRIBUTE7, ''N'') = ''Y''%'
           UNION ALL
           SELECT 'UPLOAD MRF 활성(유지)', TO_CHAR(COUNT(*)), '기대 1' FROM ALL_SOURCE
            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
              AND TEXT LIKE '            AND    NVL(ATTRIBUTE7, ''N'') = ''Y''%'""",
    ),
    (
        "V3 환율 BPS I/F 권한 (PR_SCM_MST_EXCHANGE_RATE_UI)",
        """SELECT 'GRANT' AS AXIS, GRANTEE AS VAL, PRIVILEGE AS DTL
             FROM ALL_TAB_PRIVS
            WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME='PR_SCM_MST_EXCHANGE_RATE_UI'
           UNION ALL
           SELECT '시노님', OWNER, TABLE_NAME FROM ALL_SYNONYMS
            WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME='PR_SCM_MST_EXCHANGE_RATE_UI'""",
    ),
    (
        "V4 공유 콤보 EndCustomer 정렬 (이름 우선)",
        """SELECT 'ORDER BY NAME' AS AXIS,
                  CASE WHEN SQL_DTL_CTN LIKE '%ORDER BY DIVISION_ID, NAME, CODE%' THEN 'OK' ELSE 'NG' END AS VAL,
                  TO_CHAR(LENGTH(SQL_DTL_CTN)) AS DTL
             FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='EndCustomer'
           UNION ALL
           SELECT 'DEPT_ID SELECT 유지',
                  CASE WHEN SQL_DTL_CTN LIKE '%DEPT_ID,%' THEN 'OK' ELSE 'NG' END, '-'
             FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='EndCustomer'""",
    ),
    (
        "V5 DMF0082 그리드 END_CUSTOMER 셀 콤보 = EndCustomer",
        """SELECT PROGRAM_ID AS AXIS, CELL_COMBO_DATA_TYPE AS VAL,
                  CELL_CONTROL_OBJECT_TYPE_CODE AS DTL
             FROM SCM_MST_SHEET_COLUMNS
            WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND COLUMN_NAME='END_CUSTOMER'""",
    ),
    (
        "V6 DMF0082 W/S 메저 3분기 (서버 SQL — site 미입력 시 3종)",
        """SELECT '미입력 후보수' AS AXIS, TO_CHAR(COUNT(*)) AS VAL, '기대 3' AS DTL
             FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
            WHERE L.LOOKUP_TYPE='DM_UI_EDITABLE_MEASURE' AND L.SEGMENT1='DMF0082'
              AND L.SEGMENT2='81' AND L.VALID_YN='Y' AND L.ATTRIBUTE1='Y'
              AND L.SEGMENT3 NOT IN (CASE WHEN 'W'='D' THEN 'LOC' ELSE CHR(0) END)""",
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
    for title, sql in CHECKS:
        print(f"\n{'=' * 100}\n[{title}]\n{'=' * 100}")
        try:
            cur.execute(sql)
            for r in cur.fetchall():
                print("   " + " | ".join("" if v is None else str(v) for v in r))
        except Exception as e:  # noqa: BLE001
            print(f"   ERROR: {str(e)[:140]}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
