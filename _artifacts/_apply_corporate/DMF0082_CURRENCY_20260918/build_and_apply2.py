# -*- coding: utf-8 -*-
"""
DMF0082 CURRENCY 결손 보완 2차 — 3단계 폴백 추가

1차 보완(8키 · CELL_PROD_SITE_ID 제외) 적용 후에도 결손이 남는 케이스를 실측했다.

  40 / Varta RO_RO_OTP / MCCM131012A1
     수요 행 : PROJECT=Varta         INCOTERMS=CIF  CELL_PROD=NJ01-A
     단가 행 : PROJECT=Varta         INCOTERMS=CIP  CELL_PROD=NJ01-A   (USD)
               PROJECT=VARTA(Vacuum) INCOTERMS=CIF  CELL_PROD=HQ06-A   (USD)
               PROJECT=Varta         INCOTERMS=CIF  CELL_PROD='-'      (USD)

  → 어긋나는 컬럼이 CELL_PROD_SITE_ID 하나가 아니다. INCOTERMS·PROJECT_CODE·PLANT_SITE_ID
    도 수요/단가 원장 간에 갈린다. 그런데 **같은 ITEM+SITE 의 단가는 전부 같은 통화(USD)** 다.

실측 — 통화가 유일하게 결정되는 축 (DIV 40 · DM_PLN_CFM_SELLING_PRICE · LOC · 2026~)
  | 축 | 키 수 | 통화 2종 이상 |
  |---|---:|---:|
  | 9키 (1차)                          | -     | -        |
  | 8키 (2차 · CELL_PROD 제외)          | 2,638 | 9 (0.3%) |
  | DIV+SITE+ITEM+DOM_EXP+FCST_TYPE   | 2,313 | 34 (1.5%) |
  | DIV+SITE+ITEM                      | 2,006 | 40 (2.0%) |
  | DIV+SITE                           |   438 | 44 (10.0%) |

보완
  3차 폴백 = DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
  (PROJECT_CODE / PLANT_SITE_ID / INCOTERMS / CELL_PROD_SITE_ID 를 모두 뺀 축)

  · 1·2차 후에도 CURRENCY 가 NULL 인 행만 대상 (비파괴)
  · HAVING COUNT(DISTINCT CURRENCY) = 1 — 축 안에서 통화가 갈리면 건드리지 않는다(34키 제외)
  · 기간·VMI 게이트는 1·2차와 동일

  통화는 판매가의 속성이고 같은 사업부·거래처·제품·내수수출·FCST 유형이면 단일하다는
  실측(98.5%)에 근거한다. 갈리는 1.5% 는 채우지 않고 그대로 둔다.
"""
import re
import sys
import pathlib
import datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent

# 2차 MERGE 의 꼬리 — 1차는 ON 절이 CELL_PROD_SITE_ID 로 끝나므로 이 문자열은 유일하다
ANCHOR = """        AND A.FCST_TYPE         = B.FCST_TYPE )
    WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
    WHERE  A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%'
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;
"""

PATCH = ANCHOR + """
    -- ====================================================================================================
    -- [E20260918-CURRSITEITEM] CURRENCY 3차 보완 — DIV+SITE+ITEM+DOM_EXP+FCST_TYPE 폴백
    --
    --   2차(8키)로도 못 메우는 케이스가 있다. 수요 원장과 단가 원장 사이에서 어긋나는 컬럼이
    --   CELL_PROD_SITE_ID 하나가 아니라 INCOTERMS·PROJECT_CODE·PLANT_SITE_ID 로도 갈리기 때문이다.
    --   실증(ZIOUI1 2026-09-18) 40 / Varta RO_RO_OTP / MCCM131012A1 —
    --     수요 INCOTERMS=CIF·PROJECT=Varta 인데 단가는 CIP(Varta) / CIF(VARTA(Vacuum)) 뿐.
    --     그럼에도 이 ITEM+SITE 의 단가는 전부 USD 단일이다.
    --
    --   실측(DIV 40 LOC): 통화가 2종 이상인 축 비율 = 8키 0.3% / 본 축 1.5% / DIV+SITE 10.0%.
    --   본 축까지만 완화하고, 갈리는 키는 HAVING 으로 제외해 오배정을 차단한다.
    --   1·2차 후에도 비어 있는 행만 채운다(비파괴).
    -- ====================================================================================================
    MERGE /*+ LEADING(B) USE_HASH(A) */ INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    USING (
               SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
                    , MIN(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    CURRENCY IS NOT NULL
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
               HAVING COUNT(DISTINCT CURRENCY) = 1
           ) B
    ON (    A.DIVISION_ID = B.DIVISION_ID
        AND A.SCM_SITE_ID = B.SCM_SITE_ID
        AND A.ITEM_ID     = B.ITEM_ID
        AND A.DOM_EXP     = B.DOM_EXP
        AND A.FCST_TYPE   = B.FCST_TYPE )
    WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
    WHERE  A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%'
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;
"""


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


with conn() as db:
    cur = db.cursor()
    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                      AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'""")
    st, ddl = cur.fetchone()
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                    AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    body = "".join(r[0] for r in cur)
    print("SOURCE-FRESH {}  LAST_DDL={}  STATUS={}  {} lines".format(
        datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), ddl, st, body.count(chr(10)) + 1))

    if "[E20260918-CURRSITEITEM]" in body:
        print("이미 적용되어 있음 — 중단"); raise SystemExit(0)
    if "[E20260918-CURRCELLPROD]" not in body:
        raise SystemExit("1차 보완(E20260918-CURRCELLPROD)이 없다. 먼저 build_and_apply.py 적용 필요")

    n = body.count(ANCHOR)
    if n != 1:
        raise SystemExit("앵커 {}회 — 1회여야 한다. 중단".format(n))

    new = body.replace(ANCHOR, PATCH)
    (D / "01_PKG_DMF0082_BODY.sql").write_text(new, encoding="utf-8")
    print("패치본 저장 — {} lines (+{})".format(
        new.count(chr(10)) + 1, new.count(chr(10)) - body.count(chr(10))))

    cur.execute("CREATE OR REPLACE " + new.lstrip())
    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                      AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'""")
    print("적용 후 STATUS={}  LAST_DDL={}".format(*cur.fetchone()))
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' ORDER BY SEQUENCE""")
    errs = cur.fetchall()
    if errs:
        for e in errs[:10]:
            print("   L{} P{} {}".format(*e))
        raise SystemExit(1)
    print("컴파일 오류 0건")
