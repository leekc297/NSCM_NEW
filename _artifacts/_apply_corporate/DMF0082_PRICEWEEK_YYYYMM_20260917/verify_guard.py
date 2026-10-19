# -*- coding: utf-8 -*-
"""
#18 삭제 가드 기능 검증 — 적용된 판정식을 GTT 에 모의행을 넣어 3 케이스로 실증.

원장 실측(2026-09-17): DIV40 / NT / Luxshare Precision_VN_BGG / MCSS22531-B2 / MPS / DAP / E
  MKT_FCST @ 20261004 QTY=777  (ISO 202640 의 **202610** 조각. BASIS_START_DATE=20261001)
  ※ 같은 ISO 주차의 202609 조각 = 20260928~30 (BASIS_START_DATE=20260928)

케이스
  A 같은 저장에서 MKT_FCST 도 0 으로 삭제 + 같은 주차 LOC 삭제  → 통과(차단 아님)  [패치2]
  B LOC 만 삭제(메저는 그대로)                                  → 차단             [규칙 보존]
  C 다른 년월 조각(20260928)의 LOC 삭제, 메저는 202610 에 존재    → 통과(차단 아님)  [패치1]
"""
import sys, pathlib, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

KEY = dict(DIVISION_ID='40', PROJECT_CODE='NT', END_CUSTOMER='NT',
           SCM_SITE_ID='Luxshare Precision_VN_BGG', ITEM_ID='MCSS22531-B2',
           DOM_EXP='E', FCST_TYPE='MPS', INCOTERMS='DAP',
           PLANT_SITE_ID='-', CELL_PROD_SITE_ID='NJ01-A')

# 적용된 #18 40 분기 판정식과 동일 (SP 원문 L13396~13447 발췌)
GUARD = """
SELECT COUNT(*)
  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
  JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
 WHERE EXISTS (
     SELECT A.DIVISION_ID
       FROM SCM_MGR.GT_PRDM1_T_MAIN A
       JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
      WHERE A.ACTION = 'D'
        AND F.DIVISION_ID = A.DIVISION_ID AND F.PROJECT_CODE = A.PROJECT_CODE
        AND F.SCM_SITE_ID = A.SCM_SITE_ID AND F.PLANT_SITE_ID = A.PLANT_SITE_ID
        AND F.ITEM_ID = A.ITEM_ID AND F.DOM_EXP = A.DOM_EXP
        AND F.FCST_TYPE = A.FCST_TYPE AND F.INCOTERMS = A.INCOTERMS
        AND A.MEASURE = 'LOC'
        AND F.MEASURE IN ('MKT_FCST','RTF_SCP','AS_In_Req','SCM_FCST')
        AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
        AND B.BASIS_START_DATE = D.BASIS_START_DATE          -- 패치1
        AND F.QTY <> 0
        AND F.FCST_TYPE NOT IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                 WHERE MST.LOOKUP_TYPE='SALES_TYPE_CODE' AND MST.SEGMENT4='FREE'
                                 GROUP BY SEGMENT1))
   AND NOT EXISTS (                                          -- 패치2
       SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN Z
        WHERE Z.DIVISION_ID = F.DIVISION_ID AND Z.PROJECT_CODE = F.PROJECT_CODE
          AND Z.SCM_SITE_ID = F.SCM_SITE_ID AND Z.PLANT_SITE_ID = F.PLANT_SITE_ID
          AND Z.ITEM_ID = F.ITEM_ID AND Z.DOM_EXP = F.DOM_EXP
          AND Z.FCST_TYPE = F.FCST_TYPE AND Z.INCOTERMS = F.INCOTERMS
          AND Z.MEASURE = F.MEASURE AND Z.YYYYMMDD = F.YYYYMMDD
          AND Z.CELL_PROD_SITE_ID = F.CELL_PROD_SITE_ID
          AND NVL(Z.QTY_PRICE,0) = 0)
"""

COLS = list(KEY) + ['ACTION', 'MEASURE', 'YYYYMMDD', 'QTY_PRICE', 'CURRENCY', 'CREATED_BY']
INS = (f"INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN ({','.join(COLS)}) "
       f"VALUES ({','.join(':' + c for c in COLS)})")


def row(action, measure, ymd, qty):
    d = dict(KEY); d.update(ACTION=action, MEASURE=measure, YYYYMMDD=ymd,
                            QTY_PRICE=qty, CURRENCY='USD', CREATED_BY='verify')
    return d


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


CASES = [
    ("A 같은 저장에 메저+단가 동시 삭제",
     [row('D', 'LOC', '20261004', 0), row('D', 'MKT_FCST', '20261004', 0)], 0),
    ("B 단가만 삭제 (메저 값 잔존)",
     [row('D', 'LOC', '20261004', 0)], 1),
    ("C 다른 년월 조각의 단가 삭제 (메저는 202610)",
     [row('D', 'LOC', '20260928', 0)], 0),
]

with conn() as db:
    cur = db.cursor()
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE "
                "F.DIVISION_ID=:DIVISION_ID AND F.PROJECT_CODE=:PROJECT_CODE AND "
                "F.SCM_SITE_ID=:SCM_SITE_ID AND F.ITEM_ID=:ITEM_ID AND F.MEASURE='MKT_FCST' "
                "AND F.YYYYMMDD='20261004' AND F.QTY<>0",
                {k: KEY[k] for k in ('DIVISION_ID', 'PROJECT_CODE', 'SCM_SITE_ID', 'ITEM_ID')})
    print(f"[전제] 원장 MKT_FCST @20261004 (QTY<>0) = {cur.fetchone()[0]}건")

    ok = True
    for name, rows, expect in CASES:
        cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN")
        cur.executemany(INS, rows)
        cur.execute(GUARD)
        got = 1 if cur.fetchone()[0] > 0 else 0
        mark = "PASS" if got == expect else "FAIL"
        ok &= (got == expect)
        print(f"  [{mark}] {name:38s} 차단={got} (기대 {expect})")
    cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN")
    db.rollback()
    print("\n결과:", "전 케이스 통과" if ok else "❌ 실패 있음")
