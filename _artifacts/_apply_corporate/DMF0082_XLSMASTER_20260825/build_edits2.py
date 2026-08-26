# -*- coding: utf-8 -*-
"""[E20260825-XLSMASTER perf2] WT_KEY 2단 재구성 — 174K 원장을 키로 선접기 후 마스터 보강"""
import io
import json
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()

k0 = src.find("    WITH WT_KEY AS (")
assert k0 > 0, "k0"
k1 = src.find("    -- 입력 가능 measure (화면 개인화 무관", k0)
assert k1 > 0, "k1"
old = src[k0:k1]
assert src.count(old) == 1, "old count"

new = """    WITH WT_RAW AS (
        /* [E20260825-XLSMASTER perf2] 1단 — 174K 원장을 키(2.4K)로 먼저 접는다.
           구 1단 구성(원장 174K x ITEM_V 뷰 LEFT JOIN 후 GROUP BY)은 550s+ 실측 —
           무거운 뷰 조인을 접기 전에 태운 것이 병목. 보강 조인은 2단(키 행수)에서만. */
        SELECT /*+ MATERIALIZE */
               F.DIVISION_ID
             , F.PROJECT_CODE
             , F.SCM_SITE_ID
             , F.ITEM_ID
             , F.INCOTERMS
             , F.FCST_TYPE
             , F.DOM_EXP
             , F.CURRENCY
             , MAX(F.LAST_UPDATED_BY)                AS LAST_UPDATED_BY
          FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
         WHERE F.DIVISION_ID = p_division_id
           AND F.MEASURE     = 'LOC'
           AND (NVL(p_sales_site,   'ALL') = 'ALL' OR INSTR(',' || p_sales_site   || ',', ',' || F.SCM_SITE_ID  || ',') > 0)
           AND (NVL(p_item_id,      'ALL') = 'ALL' OR INSTR(',' || p_item_id      || ',', ',' || F.ITEM_ID      || ',') > 0)
           AND (NVL(p_end_customer, 'ALL') = 'ALL' OR INSTR(',' || p_end_customer || ',', ',' || F.PROJECT_CODE || ',') > 0)
           AND (NVL(p_project_code, 'ALL') = 'ALL' OR INSTR(',' || p_project_code || ',', ',' || F.PROJECT_CODE || ',') > 0)
         GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
                , F.INCOTERMS, F.FCST_TYPE, F.DOM_EXP, F.CURRENCY
    )
    , WT_KEY AS (
        /* [E20260825-XLSMASTER] 2단 — 키 행수에서만 마스터 보강 (SITE·SITE_ITEM = 유효성 게이트 겸용,
           일괄입력 팝업 SP 동일 술어. SITE_ITEM PK = div+project+site+item 1:1 / ITEM_V = div+item 1:1).
           END_CUSTOMER = PROJECT_CODE ([DIV81] 규약) / CELL_PROD_SITE_ID = '-' (마스터에 축 없음).
           dept·biztype·owner·sender 축은 마스터 매핑 부재 — 미적용 (MAIN 종속 폐지의 의도적 결과). */
        SELECT /*+ MATERIALIZE */
               R.DIVISION_ID
             , R.PROJECT_CODE                        AS END_CUSTOMER
             , R.SCM_SITE_ID
             , R.ITEM_ID
             , R.INCOTERMS
             , R.FCST_TYPE
             , R.DOM_EXP
             , '-'                                   AS CELL_PROD_SITE_ID
             , R.CURRENCY
             , SI.DEPT_ID                            AS TEAM_ID
             , SD.DEPT_NAME_KO                       AS TEAM_NAME_KO
             , CAST(NULL AS VARCHAR2(400))           AS SOLDTO_CUSTOMER
             , CAST(NULL AS VARCHAR2(400))           AS COUNTRY_NAME
             , CAST(NULL AS VARCHAR2(400))           AS CITY_NAME
             , IV.ITEM_NAME
             , IV.NICK_NAME
             , IV.ITEM_TYPE
             , SI.CUST_GROUP
             , SI.CUST_GROUP_DTL
             , SI.OWNER
             , SI.APPLICATION
             , SI.ROUTE
             , IV.MDM_PROJECT_NAME
             , IV.MIN_CAPACITY
             , IV.FORECAST_INFO_BIZ_TYPE
             , IV.CELL_TYPE
             , IV.FORECAST_INFO_CELL_MODEL           AS FORECAST_INFO_CELL_MODEL
             , IV.FORECAST_INFO_CELL_PACK_COUNT
             , CAST(NULL AS VARCHAR2(400))           AS FORECAST_INFO_ALL
             , IV.FORECAST_INFO_SPEC
             , IV.FORECAST_INFOR_VERSION
             , CAST(NULL AS VARCHAR2(400))           AS CELL_MODEL_NICK_NAME
             , MS0.VMI_YN
             , CAST(NULL AS VARCHAR2(400))           AS DMS_SALES
             , CAST(NULL AS VARCHAR2(400))           AS DMS_CUSTOMER
             , ' '                                   AS AS_FROM_SITE
             , R.LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(400))           AS SENDER_NAME
          FROM WT_RAW R
         INNER JOIN SCM_MGR.SCM_MST_SITE MS0
            ON  MS0.DIVISION_ID = R.DIVISION_ID
            AND MS0.SCM_SITE_ID = R.SCM_SITE_ID
            AND MS0.VALID_YN    = 'Y'
         INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
            ON  SI.DIVISION_ID  = R.DIVISION_ID
            AND SI.PROJECT_CODE = R.PROJECT_CODE
            AND SI.SCM_SITE_ID  = R.SCM_SITE_ID
            AND SI.ITEM_ID      = R.ITEM_ID
            AND SI.VALID_YN     = 'Y'
          LEFT JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V IV
            ON  IV.DIVISION_ID = R.DIVISION_ID
            AND IV.ITEM_ID     = R.ITEM_ID
          LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO SD
            ON  SD.DEPT_ID = SI.DEPT_ID
    )
"""

out = pathlib.Path(__file__).resolve().parent / "edits_perf2.json"
out.write_text(json.dumps([{"old": old, "new": new}], ensure_ascii=False, indent=1), encoding="utf-8")
print("perf2 edit: old=%d자 new=%d자" % (len(old), len(new)))
