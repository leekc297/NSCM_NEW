#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0021_etcmerge_fix_20260819.py — PKG_DMF0021 GET ORA-30926 정정

원인(실측): DM_PLN_SALES_ETC_PLAN 은 MEASURE(SalesAmt_KRW/LOC/USD) 3행이 정상인데
L886 MERGE USING 이 MEASURE 축 없이 키 9종만 투영 → 동일 타깃 3회 갱신 → ORA-30926.
정정: USING 을 ROW_NUMBER dedup(RN=1, LAST_UPDATE_DATE 최신 우선)으로 감쌈 —
ATTRIBUTE1/REMARK_TEXT 만 소비하므로 의미 불변. 마커 [E20260819-ETCMERGE].
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora  # noqa: E402
import oracledb  # noqa: E402

OLD = """    USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
                 , ATTRIBUTE1, REMARK_TEXT --[PJ2024-50611] \uae30\ud0c0\ub9e4\ucd9c, Catch Up \ud14c\uc774\ube14 \ubd84\ub9ac : \ud544\ub4dc\ucd94\uac00
                 , '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID \ucd94\uac00
              FROM DM_PLN_SALES_ETC_PLAN --[PJ2024-50611] \uae30\ud0c0\ub9e4\ucd9c, Catch Up \ud14c\uc774\ube14 \ubd84\ub9ac : \ud14c\uc774\ube14 \ubcc0\uacbd
             WHERE DIVISION_ID = '40'
               AND FCST_TYPE   = 'ETC'
               AND YYYYMMDD >= p_now_yyyymmdd AND YYYYMMDD <= p_to_yyyymmdd
               AND QTY <> 0 ) B"""

NEW = """    USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
                 , ATTRIBUTE1, REMARK_TEXT --[PJ2024-50611] \uae30\ud0c0\ub9e4\ucd9c, Catch Up \ud14c\uc774\ube14 \ubd84\ub9ac : \ud544\ub4dc\ucd94\uac00
                 , '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID \ucd94\uac00
              --[E20260819-ETCMERGE] \uc6d0\ucc9c\uc740 MEASURE(SalesAmt_KRW/LOC/USD) \ud589\ubcc4 \uc801\uc7ac\uac00 \uc815\uc0c1\uc778\ub370
              --  \ubcf8 MERGE \ud0a4\uc5d0 MEASURE \uac00 \uc5c6\uc5b4 \ub3d9\uc77c \ud0c0\uae43 3\ud68c \uac31\uc2e0 \u2192 ORA-30926.
              --  \uc18c\ube44 \ucef4\ub7fc\uc740 ATTRIBUTE1/REMARK_TEXT \ubfd0\uc774\ubbc0\ub85c RN=1 dedup (\uc758\ubbf8 \ubd88\ubcc0).
              FROM ( SELECT E.DIVISION_ID, E.PROJECT_CODE, E.SCM_SITE_ID, E.ITEM_ID, E.DOM_EXP, E.FCST_TYPE
                          , E.INCOTERMS, E.PLANT_SITE_ID, E.YYYYMMDD, E.ATTRIBUTE1, E.REMARK_TEXT
                          , ROW_NUMBER() OVER ( PARTITION BY E.DIVISION_ID, E.PROJECT_CODE, E.SCM_SITE_ID, E.ITEM_ID
                                                    , E.DOM_EXP, E.FCST_TYPE, E.INCOTERMS, E.PLANT_SITE_ID, E.YYYYMMDD
                                                ORDER BY E.LAST_UPDATE_DATE DESC, E.MEASURE ) AS RN
                       FROM DM_PLN_SALES_ETC_PLAN E --[PJ2024-50611]
                      WHERE E.DIVISION_ID = '40'
                        AND E.FCST_TYPE   = 'ETC'
                        AND E.YYYYMMDD >= p_now_yyyymmdd AND E.YYYYMMDD <= p_to_yyyymmdd
                        AND E.QTY <> 0 )
             WHERE RN = 1 ) B"""


def main():
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute(
        """SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021'
           AND TYPE='PACKAGE BODY' ORDER BY LINE"""
    )
    body = "CREATE OR REPLACE " + "".join(r[0] for r in cur.fetchall()).rstrip() + "\n/\n"
    with open(r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0021_BODY_PRE_ETCMERGE_20260819.sql",
              "w", encoding="utf-8", newline="") as f:
        f.write(body)
    cnt = body.count(OLD)
    assert cnt == 1, f"앵커 {cnt}건"
    body = body.replace(OLD, NEW)
    out = r"C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0021_BODY_ETCMERGE_20260819.sql"
    with open(out, "w", encoding="utf-8", newline="") as f:
        f.write(body)
    cur.execute(body.rstrip().rstrip("/").rstrip())
    cur.execute(
        "SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0021'"
    )
    print("적용 후:", cur.fetchall())
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021'")
    print("ALL_ERRORS:", cur.fetchone()[0])
    cur.execute(
        """SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021'
           AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260819-ETCMERGE%'"""
    )
    print("마커:", cur.fetchone()[0])
    cur.close()
    con.close()
    print("클라우드 적용 파일:", out)


if __name__ == "__main__":
    main()
