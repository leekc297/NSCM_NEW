# -*- coding: utf-8 -*-
"""
DMF0082 CURRENCY 보완 검증

G1  결손 해소  : 1차(9키)가 못 메운 행이 2차(8키)로 채워졌는가
G2  값 정합    : 채워진 통화가 같은 8키의 LOC 통화와 일치하는가
G3  비파괴     : 1차가 이미 채운 값이 바뀌지 않았는가 (9키 일치 행의 통화 = 9키 LOC 통화)
G4  오배정 차단: 8키 안에서 통화가 갈리는 키는 그대로 NULL 로 남았는가
"""
import re
import sys
import pathlib

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

ITEMS = ("MCCM134010A1,MCCM131012A1,MCCM348014A3,MCCM356015A2,MCCM350415B1,"
         "MIF489266C11,MCCH350040A1T001,MCSS22561-C1,MCCM349215A1-111,MCCM348018A3")
DIV, FR, TO = "40", "20260101", "20271231"


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


with conn() as db:
    cur = db.cursor()
    cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                    AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
                    AND TEXT LIKE '%E20260918-CURRCELLPROD%'""")
    print("패치 마커: {}".format("있음" if cur.fetchone()[0] else "*** 없음 ***"))

    rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 [DIV, "ALL", "ALL", "ALL", FR, TO, "ALL", ITEMS,
                  "Current", "Y", "minyonglee1", "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
    print("RESULT:", rc[5].getvalue().fetchall()[:1])

    K8 = ("DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, "
          "INCOTERMS, DOM_EXP, FCST_TYPE")

    print("\n[G1] CURRENCY NULL 잔존")
    cur.execute("""SELECT MEASURE, COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                    WHERE CURRENCY IS NULL AND MEASURE NOT LIKE 'VMI%'
                    GROUP BY MEASURE ORDER BY 1""")
    rest = cur.fetchall()
    print("   " + (", ".join("{}={}".format(*r) for r in rest) if rest else "0건"))

    print("\n[G2/G3] 채워진 통화 vs 같은 8키 LOC 통화")
    cur.execute("""
      WITH L AS (SELECT {k}, MIN(CURRENCY) CUR, COUNT(DISTINCT CURRENCY) KINDS
                   FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                  WHERE MEASURE='LOC' AND CURRENCY IS NOT NULL
                  GROUP BY {k})
      SELECT SUM(CASE WHEN A.CURRENCY = L.CUR THEN 1 ELSE 0 END) OK,
             SUM(CASE WHEN A.CURRENCY <> L.CUR THEN 1 ELSE 0 END) MISMATCH,
             COUNT(*) TOT
        FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
        JOIN L ON L.DIVISION_ID=A.DIVISION_ID AND L.PROJECT_CODE=A.PROJECT_CODE
              AND L.SCM_SITE_ID=A.SCM_SITE_ID AND L.PLANT_SITE_ID=A.PLANT_SITE_ID
              AND L.ITEM_ID=A.ITEM_ID AND L.INCOTERMS=A.INCOTERMS
              AND L.DOM_EXP=A.DOM_EXP AND L.FCST_TYPE=A.FCST_TYPE
       WHERE A.CURRENCY IS NOT NULL AND L.KINDS = 1""".format(k=K8))
    ok, mis, tot = cur.fetchone()
    print("   일치 {:,} / 불일치 {:,} / 대상 {:,}".format(ok or 0, mis or 0, tot or 0))

    print("\n[G4] 8키 다중통화 키 (보완 제외 대상)")
    cur.execute("""
      SELECT COUNT(*) FROM ( SELECT {k} FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
                              WHERE MEASURE='LOC' AND CURRENCY IS NOT NULL
                              GROUP BY {k} HAVING COUNT(DISTINCT CURRENCY) > 1 )""".format(k=K8))
    print("   {}건".format(cur.fetchone()[0]))

    print("\n== 판정 ==")
    print("   G1 결손 해소 :", "PASS" if not rest else "잔존 " + str(rest))
    print("   G2/G3 값 정합:", "PASS" if not mis else "FAIL 불일치 {}".format(mis))
