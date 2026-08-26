# -*- coding: utf-8 -*-
"""[E20260825-XLSMASTER] Excel Form 행 원천 전환 — edits.json 생성"""
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

# ---- edit1: MAIN GET 내부호출 블록 → 마스터 카운트 ----
a1 = src.find("    -- 1) MAIN 조회 파이프라인 재사용")
assert a1 > 0, "a1"
s1 = src.rfind("    ------------------------------------------------------------------------\n", 0, a1)
e1_anchor = "    SELECT COUNT(*) INTO n_key_cnt FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;\n"
e1 = src.find(e1_anchor, a1)
assert e1 > 0, "e1"
old1 = src[s1:e1 + len(e1_anchor)]
assert src.count(old1) == 1, "old1 count"

new1 = """    /* [E20260825-XLSMASTER] Excel Form 행 원천 전환 (사용자 지시 2026-08-25).
       구: MAIN GRID 조회 파이프라인(GET 내부호출 -> GT_TEMP 재사용) — 수량 원장·버전·기간 종속.
       신: 판가 마스터 SCM_MST_FUTURE_PRICE(MEASURE='LOC') = LOC 대상 정본
           (일괄입력 팝업 SP 동일 원천) — 조회조건 division 기준 직생성. MAIN GET 미호출. */
    SELECT COUNT(*)
      INTO n_key_cnt
      FROM (SELECT DISTINCT F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, F.INCOTERMS
                          , F.FCST_TYPE, F.DOM_EXP, F.CURRENCY
              FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
             WHERE F.DIVISION_ID = p_division_id AND F.MEASURE = 'LOC');
"""

# ---- edit2: WT_KEY CTE 교체 ----
k0 = src.find("    WITH WT_KEY AS (")
assert k0 > 0, "k0"
k1 = src.find("    -- 입력 가능 measure (화면 개인화 무관", k0)
assert k1 > 0, "k1"
old2 = src[k0:k1]
assert src.count(old2) == 1, "old2 count"

new2 = """    WITH WT_KEY AS (
        /* [E20260825-XLSMASTER] 행 원천 = 판가 마스터(SCM_MST_FUTURE_PRICE, MEASURE='LOC') division 기준.
           - END_CUSTOMER = PROJECT_CODE ([DIV81] 규약) / CELL_PROD_SITE_ID = '-' (마스터에 축 없음)
           - 유효성: SITE·SITE_ITEM VALID 조합만 (일괄입력 팝업 SP 동일 술어)
           - 선택 필터: Sales Site / Item / End Customer(=Project) 콤마 다중 ('ALL'/빈값 = 전체).
             dept·biztype·owner·sender 축은 마스터에 매핑 부재 — 미적용 (MAIN 종속 폐지의 의도적 결과)
           - 부가 정보컬럼은 SITE_ITEM·ITEM_V 마스터 보강, 원천 없는 것은 NULL (업로드 검증 미사용 축) */
        SELECT F.DIVISION_ID
             , F.PROJECT_CODE                        AS END_CUSTOMER
             , F.SCM_SITE_ID
             , F.ITEM_ID
             , F.INCOTERMS
             , F.FCST_TYPE
             , F.DOM_EXP
             , '-'                                   AS CELL_PROD_SITE_ID
             , F.CURRENCY
             , MAX(SI.DEPT_ID)                       AS TEAM_ID
             , MAX(SD.DEPT_NAME_KO)                  AS TEAM_NAME_KO
             , CAST(NULL AS VARCHAR2(400))           AS SOLDTO_CUSTOMER
             , CAST(NULL AS VARCHAR2(400))           AS COUNTRY_NAME
             , CAST(NULL AS VARCHAR2(400))           AS CITY_NAME
             , MAX(IV.ITEM_NAME)                     AS ITEM_NAME
             , MAX(IV.NICK_NAME)                     AS NICK_NAME
             , MAX(IV.ITEM_TYPE)                     AS ITEM_TYPE
             , MAX(SI.CUST_GROUP)                    AS CUST_GROUP
             , MAX(SI.CUST_GROUP_DTL)                AS CUST_GROUP_DTL
             , MAX(SI.OWNER)                         AS OWNER
             , MAX(SI.APPLICATION)                   AS APPLICATION
             , MAX(SI.ROUTE)                         AS ROUTE
             , MAX(IV.MDM_PROJECT_NAME)              AS MDM_PROJECT_NAME
             , MAX(IV.MIN_CAPACITY)                  AS MIN_CAPACITY
             , MAX(IV.FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
             , MAX(IV.CELL_TYPE)                     AS CELL_TYPE
             , MAX(IV.FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
             , MAX(IV.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
             , CAST(NULL AS VARCHAR2(400))           AS FORECAST_INFO_ALL
             , MAX(IV.FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
             , MAX(IV.FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
             , CAST(NULL AS VARCHAR2(400))           AS CELL_MODEL_NICK_NAME
             , MAX(MS0.VMI_YN)                       AS VMI_YN
             , CAST(NULL AS VARCHAR2(400))           AS DMS_SALES
             , CAST(NULL AS VARCHAR2(400))           AS DMS_CUSTOMER
             , ' '                                   AS AS_FROM_SITE
             , MAX(F.LAST_UPDATED_BY)                AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(400))           AS SENDER_NAME
          FROM SCM_MGR.SCM_MST_FUTURE_PRICE F
         INNER JOIN SCM_MGR.SCM_MST_SITE MS0
            ON  MS0.DIVISION_ID = F.DIVISION_ID
            AND MS0.SCM_SITE_ID = F.SCM_SITE_ID
            AND MS0.VALID_YN    = 'Y'
         INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
            ON  SI.DIVISION_ID  = F.DIVISION_ID
            AND SI.PROJECT_CODE = F.PROJECT_CODE
            AND SI.SCM_SITE_ID  = F.SCM_SITE_ID
            AND SI.ITEM_ID      = F.ITEM_ID
            AND SI.VALID_YN     = 'Y'
          LEFT JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V IV
            ON  IV.DIVISION_ID = F.DIVISION_ID
            AND IV.ITEM_ID     = F.ITEM_ID
          LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO SD
            ON  SD.DEPT_ID = SI.DEPT_ID
         WHERE F.DIVISION_ID = p_division_id
           AND F.MEASURE     = 'LOC'
           AND (NVL(p_sales_site,   'ALL') = 'ALL' OR INSTR(',' || p_sales_site   || ',', ',' || F.SCM_SITE_ID  || ',') > 0)
           AND (NVL(p_item_id,      'ALL') = 'ALL' OR INSTR(',' || p_item_id      || ',', ',' || F.ITEM_ID      || ',') > 0)
           AND (NVL(p_end_customer, 'ALL') = 'ALL' OR INSTR(',' || p_end_customer || ',', ',' || F.PROJECT_CODE || ',') > 0)
           AND (NVL(p_project_code, 'ALL') = 'ALL' OR INSTR(',' || p_project_code || ',', ',' || F.PROJECT_CODE || ',') > 0)
         GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
                , F.INCOTERMS, F.FCST_TYPE, F.DOM_EXP, F.CURRENCY
    )
"""

out = pathlib.Path(__file__).resolve().parent / "edits.json"
out.write_text(json.dumps([{"old": old1, "new": new1}, {"old": old2, "new": new2}],
                          ensure_ascii=False, indent=1), encoding="utf-8")
print("edits 2건: old1=%d자 old2=%d자" % (len(old1), len(old2)))
