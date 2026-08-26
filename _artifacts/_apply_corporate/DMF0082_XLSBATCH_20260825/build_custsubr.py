# -*- coding: utf-8 -*-
"""[E20260826-CUSTSUBR] CUST 종속 메저 실적 축 배선 — DM_PLN_MKT_FCST_RESULT (AS-IS 동일 원장).
   결손 실증: BMW 5키/Volvo WA 2키 — 종속 값이 실적 구간(과거)에만 존재, Current 실적 arm
   원천(SALES_PLAN_RESULT)에는 종속 메저 부재 → 14행 누락 (파일 대사 2026-08-26)."""
import io, json, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
src = "".join(t for (t,) in cur if t is not None)
con.close()

# 앵커: GET Current 81 실적 arm 의 꼬리 (DM_PLN_SALES_PLAN_RESULT arm) — GET 은 첫 출현
i0 = src.find("PROCEDURE P_DMF0082_GET_MAIN_DATA")
i1 = src.find("PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
tail = """        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- Current 버전"""
k = src.find(tail, i0)
assert i0 < k < i1, "anchor not in GET"
assert src.count(tail) >= 1
# GET 내 유일성 확인 (전체에 복수면 위치 지정 치환 불가 -> sp_patch 는 전역 유일 요구)
assert src.count(tail) == 1, "tail count=%d" % src.count(tail)

new_arm = """        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

        /* [E20260826-CUSTSUBR] CUST 종속 메저(EDI/Commercial_Agreement 등) 실적 축 배선 (사용자 지시 2026-08-26).
           결손 실증(파일 대사 14행): 종속 값이 실적 구간(과거)에만 있는 키(BMW 5키/Volvo WA 2키)는
           Current 실적 arm 원천(DM_PLN_SALES_PLAN_RESULT)에 종속 메저가 없어 행이 통째로 빠졌다.
           AS-IS 실적 원장 = DM_PLN_MKT_FCST_RESULT (BMW 키 CUST_FCST_EDI 9행 실측 — 정확히 결손 값).
           본 arm = 종속 메저 전용 (모 CUST_FCST 는 기존 arm 이 담당 — MEASURE<>MEASURE_GROUP 게이트로 중복 0).
           기간/게이트 = 위 실적 arm 동일 (from~V_TO_RESULT, QTY<>0, SITE_ITEM VALID, WS FCST_TYPE).
           CURRENCY = '' (계획 arm 파리티 — 수량 축), CELL_PROD '-' [DIV81]. */
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재 규약
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , NVL(A.ATTRIBUTE10, ' ') AS AS_FROM_SITE
             , NULL AS CREATE_DATE
             , NULL AS LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , 'INTEGER' AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
            AND B.MEASURE_GROUP = 'CUST_FCST'
            AND B.MEASURE <> 'CUST_FCST'   -- 모행은 기존 실적 arm(SALES_PLAN_RESULT) 담당 — 중복 0
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- Current 버전"""

out = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_XLSBATCH_20260825\edits_custsubr.json")
out.write_text(json.dumps([{"old": tail, "new": new_arm}], ensure_ascii=False, indent=1), encoding="utf-8")
print("edit 생성 (old %d자 -> new %d자)" % (len(tail), len(new_arm)))
