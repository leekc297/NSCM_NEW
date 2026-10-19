# -*- coding: utf-8 -*-
"""
DMF0082 CURRENCY 결손 보완 3차 — 조인키 NULL 정규화 (클라우드 실증 반영)

클라우드 진단 결과 (91_DIAG_CLOUD.sql, 40 / MCSS22561-C1 / Current)

  구분      MEASURE      PROJECT  SCM_SITE                 PLANT_SITE  ITEM          INCO  DOM  FCST  CELL_PROD  행수  통화
  결손      RTF_SYS_RP   NT       BYD Electronics_CN_SZX   (빈값)      MCSS22561-C1  DAP   E    MPS   NJ01-A      44   —
  단가LOC   LOC          NT       BYD Electronics_CN_SZX   -           MCSS22561-C1  DAP   E    MPS   NJ01-A      80   USD

  → 9키 중 **PLANT_SITE_ID 만** 다르다. 수요/실적 행은 NULL, 단가 행은 '-'.
  → 게다가 Oracle 의 MERGE ON 은 `A.col = B.col` 에서 한쪽이 NULL 이면 UNKNOWN 이라
    **NULL 인 행은 어떤 값과도 매칭되지 않는다.** 양쪽이 모두 NULL 이어도 마찬가지다.
    즉 조인키 중 하나라도 NULL 이면 1차(9키)·2차(8키)가 통째로 무력화된다.

  사내 ZIOUI1 은 DIV 40 의 PLANT_SITE_ID 가 **전 행 '-'** (NULL 0건)라 이 결함이 드러나지 않았다.
    DM_PLN_CFM_MKT_DEMAND_PLAN  244,124행 전부 '-'
    DM_PLN_SALES_PLAN_RESULT     38,008행 전부 '-'
    DM_PLN_CFM_SELLING_PRICE    567,972행 전부 '-'
  클라우드는 수요/실적 쪽이 NULL 이라 재현된다. 사내에서 재현되지 않은 이유가 이것이다.

보완
  2차(8키)·3차(DIV+SITE+ITEM+DOM_EXP+FCST_TYPE) MERGE 의 조인키를 **NVL(...,'-') 로 정규화**한다.
    · USING 의 SELECT/GROUP BY 와 ON 절을 **동시에** 정규화한다.
      (ON 만 정규화하면 B 쪽에 NULL 그룹과 '-' 그룹이 따로 생겨 한 A 행에 두 B 행이 붙어
       ORA-30926 "unable to get a stable set of rows" 가 날 수 있다.)
    · HAVING COUNT(DISTINCT CURRENCY) = 1 유지 — 정규화 후 통화가 갈리면 건드리지 않는다.
    · 1차(9키)는 AS-IS 원문 그대로 둔다.

  이로써 NULL/'-' 센티널이 섞인 어떤 조합이든 2차에서 정확히 잡힌다
  (PROJECT_CODE·INCOTERMS 변별을 유지하므로 3차까지 내려가지 않는다).
"""
import re
import sys
import pathlib
import datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
K8 = ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID",
      "ITEM_ID", "INCOTERMS", "DOM_EXP", "FCST_TYPE"]
K5 = ["DIVISION_ID", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE"]

# ── 2차 ────────────────────────────────────────────────────────────────────
OLD2 = """               SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
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
        AND A.FCST_TYPE         = B.FCST_TYPE )"""

NEW2 = ("""               -- [E20260918-CURRNULLKEY] 조인키 NULL 정규화 — 원장별로 센티널이 NULL / '-' 로 갈린다
               --   (클라우드 실증: 수요·실적 PLANT_SITE_ID = NULL, 단가 = '-')
               --   MERGE ON 은 NULL 이면 UNKNOWN 이라 매칭 자체가 불가하므로 USING 과 ON 을 함께 정규화한다.
               SELECT """
        + "\n                    , ".join("NVL({0}, '-') AS {0}".format(c) for c in K8)
        + """
                    , MIN(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    CURRENCY IS NOT NULL
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY """
        + "\n                    , ".join("NVL({0}, '-')".format(c) for c in K8)
        + """
               HAVING COUNT(DISTINCT CURRENCY) = 1
           ) B
    ON (    """
        + "\n        AND ".join("NVL(A.{0}, '-') = B.{0}".format(c) for c in K8)
        + " )")

# ── 3차 ────────────────────────────────────────────────────────────────────
OLD3 = """               SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
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
        AND A.FCST_TYPE   = B.FCST_TYPE )"""

NEW3 = ("""               -- [E20260918-CURRNULLKEY] 조인키 NULL 정규화 (2차와 동일 사유)
               SELECT """
        + "\n                    , ".join("NVL({0}, '-') AS {0}".format(c) for c in K5)
        + """
                    , MIN(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    CURRENCY IS NOT NULL
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY """
        + "\n                    , ".join("NVL({0}, '-')".format(c) for c in K5)
        + """
               HAVING COUNT(DISTINCT CURRENCY) = 1
           ) B
    ON (    """
        + "\n        AND ".join("NVL(A.{0}, '-') = B.{0}".format(c) for c in K5)
        + " )")


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

    if "[E20260918-CURRNULLKEY]" in body:
        print("이미 적용되어 있음 — 중단"); raise SystemExit(0)
    for mk in ("[E20260918-CURRCELLPROD]", "[E20260918-CURRSITEITEM]"):
        if mk not in body:
            raise SystemExit("선행 보완 {} 없음 — 중단".format(mk))
    for name, old in (("2차", OLD2), ("3차", OLD3)):
        n = body.count(old)
        if n != 1:
            raise SystemExit("{} 앵커 {}회 — 1회여야 한다. 중단".format(name, n))

    new = body.replace(OLD2, NEW2).replace(OLD3, NEW3)
    (D / "01_PKG_DMF0082_BODY.sql").write_text(new, encoding="utf-8")
    print("패치본 저장 — {} lines".format(new.count(chr(10)) + 1))

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
