# -*- coding: utf-8 -*-
"""
DMF0082 CURRENCY 결손 보완 — 빌드 & 사내 적용

결함
  P_DMF0082_GET_MAIN_DATA 의 "CURRENCY 업데이트 (계획구간 통화코드 보완)" MERGE 가
  조인키에 CELL_PROD_SITE_ID 를 포함한다. 그런데 GTT 로 적재되는 arm 별로 이 컬럼의
  채움 규약이 다르다.

    · 수요/실적 arm  DM_PLN_CFM_MKT_DEMAND_PLAN(_C) / DM_PLN_SALES_PLAN_RESULT(_C)
                     → A.CELL_PROD_SITE_ID (실제값, 예: NJ01-A)
    · 단가 arm       SCM_MST_FUTURE_PRICE(_C)  → 원장에 컬럼 자체가 없어 '-' 고정삽입
                     DM_PLN_CFM_SELLING_PRICE(_C) → A.CELL_PROD_SITE_ID ('-' 61% / 실제값 39%)

  따라서 같은 사업 키인데도 이 한 컬럼이 엇갈리면 MERGE 가 매칭되지 않아
  단가(Unit Price)는 통화가 보이는데 RTF/MKT FCST/SCM FCST 등은 CURRENCY 가 빈다.

  AS-IS(_asis_DMF0082_GET_MAIN_DATA.live.sql L4571~4610)도 조인키가 동일 → AS-IS 승계 결함.

실증 (ZIOUI1 2026-09-18)
  DIV 40 Current, 8키 일치 + CELL_PROD_SITE_ID 만 불일치 = 3키
    MIF489266C11 / NT_CN_SZX  수요 NJ01-A vs 단가 '-'
      → MKT_FCST 4행/RTF_SYS_RP 2행/SCM_FCST 4행 **전부 CURRENCY NULL** (단가는 정상)
    MCCM131012A1 / Varta RO_RO_OTP  수요 NJ01-A vs 단가 '-'  → 부분 결손
    MCCH350040A1T001 / Greenway_CN_DGG  수요 NJ01-A vs 단가 HQ06-A

보완
  1차(9키) MERGE 는 **원문 그대로 유지** (AS-IS 파리티 · 기존 결과 불변).
  그 뒤에 2차 보완 MERGE 를 추가한다.
    · 조인키에서 CELL_PROD_SITE_ID 만 제외한 8키
    · 1차 후에도 CURRENCY 가 NULL 인 행만 대상 (비파괴 · 덮어쓰기 없음)
    · HAVING COUNT(DISTINCT CURRENCY) = 1 — 8키 안에서 통화가 갈리는 키는 **건드리지 않는다**
      (실측: 40 9키 / 81 78키 / 82 8키가 8키 단위 다중통화 → 오배정 위험 차단)
    · 기간·VMI 게이트는 1차와 동일

  통화는 판매가의 속성이라 생산 셀 사이트(CELL_PROD_SITE_ID)와 무관하다.
  그럼에도 1차를 남기는 이유는 AS-IS 동작을 그대로 두고 결손만 메우기 위해서다.
"""
import re
import sys
import pathlib
import datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
RAW = D / "_raw"

ANCHOR = """    WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
    WHERE  A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%'
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;
"""

PATCH = ANCHOR + """
    -- ====================================================================================================
    -- [E20260918-CURRCELLPROD] CURRENCY 2차 보완 — CELL_PROD_SITE_ID 제외 8키 폴백
    --
    --   위 1차 MERGE 는 CELL_PROD_SITE_ID 를 조인키에 포함한다(AS-IS 동일). 그런데 GTT 적재 arm 별로
    --   이 컬럼의 채움 규약이 다르다 — 단가 원천 SCM_MST_FUTURE_PRICE 에는 컬럼 자체가 없어 '-' 를
    --   고정 삽입하고, 수요/실적 원천은 실제값(NJ01-A 등)을 그대로 쓴다. DM_PLN_CFM_SELLING_PRICE 도
    --   '-' 와 실제값이 섞여 있다(40 실측 '-' 950,621 / 실제값 600,783).
    --   그 결과 같은 사업 키인데 이 한 컬럼만 엇갈려 1차가 매칭되지 않고,
    --   단가(Unit Price)에는 통화가 보이는데 RTF/MKT FCST/SCM FCST 는 CURRENCY 가 빈다.
    --   (ZIOUI1 실증 2026-09-18 — 40 Current: MIF489266C11/NT_CN_SZX 등 3키, 수요 NJ01-A vs 단가 '-')
    --
    --   통화는 판매가의 속성이라 생산 셀 사이트와 무관하다. 다만 1차는 원문 그대로 두고,
    --   **1차 후에도 비어 있는 행만** 8키로 메운다(비파괴 — 이미 채워진 값은 건드리지 않음).
    --   HAVING COUNT(DISTINCT CURRENCY) = 1 : 8키 안에서 통화가 갈리는 키는 제외해 오배정을 차단한다.
    -- ====================================================================================================
    MERGE /*+ LEADING(B) USE_HASH(A) */ INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    USING (
               SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , INCOTERMS, DOM_EXP, FCST_TYPE, MIN(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    CURRENCY IS NOT NULL
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , INCOTERMS, DOM_EXP, FCST_TYPE
               HAVING COUNT(DISTINCT CURRENCY) = 1
           ) B
    ON (    A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.INCOTERMS         = B.INCOTERMS
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE )
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


def fetch_live(cur):
    """hook #152 FRESH-GATE — 적용 직전 DB 원문 재조회"""
    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                      AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'""")
    st, ddl = cur.fetchone()
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                    AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    return "".join(r[0] for r in cur), st, ddl


with conn() as db:
    cur = db.cursor()
    body, status, ddl = fetch_live(cur)
    print("SOURCE-FRESH {}  LAST_DDL={}  STATUS={}  {} lines".format(
        datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), ddl, status,
        body.count(chr(10)) + 1))

    if "[E20260918-CURRCELLPROD]" in body:
        print("이미 적용되어 있음 — 중단"); raise SystemExit(0)

    n = body.count(ANCHOR)
    if n != 1:
        raise SystemExit("앵커 {}회 — 1회여야 한다. 중단".format(n))

    (D / "00_BEFORE_PKG_DMF0082_BODY.sql").write_text(body, encoding="utf-8")
    new = body.replace(ANCHOR, PATCH)
    (D / "01_PKG_DMF0082_BODY.sql").write_text(new, encoding="utf-8")
    print("패치본 저장 — {} lines (+{})".format(
        new.count(chr(10)) + 1, new.count(chr(10)) - body.count(chr(10))))

    ddl_sql = "CREATE OR REPLACE " + new if not new.upper().lstrip().startswith("CREATE") else new
    cur.execute(ddl_sql)
    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                      AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'""")
    st2, ddl2 = cur.fetchone()
    print("적용 후 STATUS={}  LAST_DDL={}".format(st2, ddl2))

    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' ORDER BY SEQUENCE""")
    errs = cur.fetchall()
    if errs:
        print("컴파일 오류 {}건".format(len(errs)))
        for e in errs[:10]:
            print("   L{} P{} {}".format(*e))
        raise SystemExit(1)
    print("컴파일 오류 0건")
