#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_fncost.py — hook #129 1·2 순위 판정용 실측 (읽기 전용 SELECT 만)

1순위: 함수 호출 비용 / 서로 다른 입력값 개수(= 메모이제이션 이득)
2순위: 함수가 감싼 컬럼의 인덱스 존재 여부 (SARGable 판정)
"""
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


def t(cur, label, sql):
    t0 = time.time()
    cur.execute(sql)
    r = cur.fetchall()
    el = time.time() - t0
    val = r[0] if len(r) == 1 else ("%d rows" % len(r))
    print("  %-58s %-28s %7.2f초" % (label, str(val)[:28], el))
    return r, el


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        print("=== [1순위] FN_GET_DM_MKT_OWNER_NAME — 입력 카디널리티 ===")
        t(cur, "SCM_MST_SITE_ITEM div40 행수",
          "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID='40'")
        t(cur, "  ↳ DISTINCT OWNER (서로 다른 입력값)",
          "SELECT COUNT(DISTINCT OWNER) FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID='40'")
        t(cur, "SCM_MST_SITE_ITEM 전체 행수",
          "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_ITEM")
        t(cur, "  ↳ DISTINCT OWNER 전체",
          "SELECT COUNT(DISTINCT OWNER) FROM SCM_MGR.SCM_MST_SITE_ITEM")

        print("\n  -- 함수 실호출 비용 (DISTINCT 입력 전량 1회씩) --")
        t(cur, "FN 호출 = DISTINCT OWNER 건수만큼",
          """SELECT COUNT(SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(OWNER, ',', 'KO'))
               FROM (SELECT DISTINCT OWNER FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID='40')""")
        t(cur, "FN 호출 = 행마다 (div40 전체 행)",
          """SELECT COUNT(SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(OWNER, ',', 'KO'))
               FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE DIVISION_ID='40'""")

        print("\n=== [1순위] FN_GET_COUNTRY_KR_NAME — 입력 카디널리티 ===")
        t(cur, "SCM_MST_COUNTRY 행수", "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_COUNTRY")
        t(cur, "  ↳ COUNTRY 중복 (0 이어야 JOIN 치환 안전)",
          "SELECT COUNT(*) FROM (SELECT COUNTRY FROM SCM_MGR.SCM_MST_COUNTRY GROUP BY COUNTRY HAVING COUNT(*)>1)")
        t(cur, "ETC_REPORT_C 대상버전 DISTINCT COUNTRY_CODE",
          """SELECT COUNT(DISTINCT COUNTRY_CODE) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
              WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C'""")

        print("\n=== [2순위] 함수가 감싼 컬럼의 인덱스 (SARGable 판정) ===")
        for tab in ("SCM_MST_SSO_USER_INFO", "SCM_MST_COUNTRY", "SCM_MST_SITE_ITEM"):
            cur.execute("""SELECT i.INDEX_NAME, i.UNIQUENESS, c.COLUMN_POSITION, c.COLUMN_NAME
                             FROM ALL_INDEXES i JOIN ALL_IND_COLUMNS c
                               ON c.INDEX_OWNER=i.OWNER AND c.INDEX_NAME=i.INDEX_NAME
                            WHERE i.TABLE_OWNER='SCM_MGR' AND i.TABLE_NAME=:t
                              AND c.COLUMN_POSITION <= 3
                            ORDER BY i.INDEX_NAME, c.COLUMN_POSITION""", {"t": tab})
            print("  -- %s --" % tab)
            for r in cur.fetchall():
                print("     %-38s %-9s %s. %s" % r)
            cur.execute("""SELECT COLUMN_NAME, DATA_DEFAULT FROM ALL_IND_EXPRESSIONS e
                             JOIN ALL_IND_COLUMNS c ON c.INDEX_NAME=e.INDEX_NAME
                                AND c.COLUMN_POSITION=e.COLUMN_POSITION
                            WHERE e.TABLE_OWNER='SCM_MGR' AND e.TABLE_NAME=:t""", {"t": tab})
            fbi = cur.fetchall()
            print("     FBI(함수기반인덱스) = %s" % (fbi if fbi else "없음"))

        print("\n=== [2순위] UPPER(USER_ID) 가 인덱스를 타는가 (실측) ===")
        t(cur, "USER_ID = 'minyonglee1' (SARGable)",
          "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SSO_USER_INFO WHERE USER_ID='minyonglee1'")
        t(cur, "UPPER(USER_ID) = UPPER('minyonglee1') (함수 감쌈)",
          "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SSO_USER_INFO WHERE UPPER(USER_ID)=UPPER('minyonglee1')")
        t(cur, "SCM_MST_SSO_USER_INFO 행수", "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SSO_USER_INFO")
        t(cur, "  ↳ USER_ID 가 이미 대문자만인가(대소문자 차이 건수)",
          "SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SSO_USER_INFO WHERE USER_ID <> UPPER(USER_ID)")


if __name__ == "__main__":
    main()
