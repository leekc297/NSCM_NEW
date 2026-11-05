# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] 2-A Current 경로 — 새 문장 블록 (S0 · S1 · S2 · S3) 텍스트 생성.
   원문 줄 번호 주석 = main.sql(BODY 8행부터) 기준. build.py 가 원문 조각과 이어 붙인다.
"""

MARK = "[E20261104-DMF0082ONEQUERY]"

# TEMP_FCST_N_PRICE 60 열 (원문 L1451~1461 INSERT 열 순서)
FNP_COLS = ("DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS"
            ", MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP"
            ", CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO"
            ", FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE"
            ", SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN"
            ", CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY"
            ", FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC"
            ", FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE"
            ", MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE"
            ", CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT"
            ", CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION")
FNP_LIST = [c.strip() for c in FNP_COLS.replace("\n", "").split(",")]
assert len(FNP_LIST) == 60, len(FNP_LIST)

# TEMP_SITE_ITEM(C) 투영 33 열 (MEASURE_GROUP 뒤 ~ SORT_ORDER_NO 앞, 원문 arm 공통)
C_ATTR = ["CELL_MODEL", "NICK_NAME", "DMS_SALES", "DMS_CUSTOMER", "OWNER", "DEPT_ID", "DEPT_NAME_KO",
          "FORECAST_INFO_CELL_PACK_COUNT", "ITEM_TYPE", "PROJECT_NAME", "PROJECT_OWNER", "BIZ_TYPE",
          "SOLDTO_CUSTOMER", "COUNTRY_NAME", "CITY_NAME", "PROJECT_STATUS", "ITEM_NAME", "VMI_YN",
          "CUST_GROUP", "CUST_GROUP_DTL", "APPLICATION", "ROUTE", "MDM_PROJECT_NAME", "MIN_CAPACITY",
          "FORECAST_INFO_BIZ_TYPE", "CELL_TYPE", "FORECAST_INFO_ALL", "FORECAST_INFO_SPEC",
          "FORECAST_INFOR_VERSION", "CELL_MODEL_NICK_NAME", "CELL_PER_CAR", "CELL_PER_MODULE", "MODULE_PER_CAR"]
C_SEL = "\n             , ".join(f"C.{c}" for c in C_ATTR)
C_MAX = "\n             , ".join(f"MAX(A.{c}) AS {c}" for c in C_ATTR)   # 파생 arm 용 (원문 L3869~3880 순서 동일 · UNION 열 이름용 별칭)

KEY8 = "DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE"
D81 = "(p_division_id LIKE '81%' OR p_division_id = '82')"
D40 = "(p_division_id IS NULL OR (p_division_id NOT LIKE '81%' AND p_division_id <> '82'))"   # 원문 IF 의 ELSE (NULL 도 ELSE)
G_CUR = "(NVL(p_version_type,'~') LIKE '%Current%' OR NVL(p_version_type,'~') LIKE '%current%')"   # 원문 L1453 Current 게이트 (2-B ALL 변형에서만 사용)
NOTATION_A = "CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END"
CUST_MEAS = "CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END ELSE A.MEASURE END"
# [E20261104-DMF0082PPMERGE] 수요 arm(#1/#2) + MKT_FCST_PP arm(#3/#4) 병합용 측정값 매핑 — 구 #3/#4 의 키 없는 MEA 교차조인(옵티마이저 1행 추정 → 원장 PK 행별 NL) 제거.
#   M(AM→BM, PP): MEA 의 DISTINCT MEASURE 자기매핑(PP='N') ∪ ('MKT_FCST'→'MKT_FCST_PP', PP='Y') 1행(MEA 에 MKT_FCST_PP 가 있을 때만).
#   B 는 M.BM 으로 등가조인 → 행 다중도 = 구 형태와 동일(#1: B.MEASURE=A.MEASURE 의 B 행수 / #3: MKT_FCST_PP 의 B 행수).
B_MAP = """        INNER JOIN (SELECT DISTINCT MEASURE AS AM, MEASURE AS BM, 'N' AS PP FROM MEA
                    UNION ALL
                    SELECT 'MKT_FCST', 'MKT_FCST_PP', 'Y' FROM DUAL
                    WHERE  EXISTS (SELECT 1 FROM MEA WHERE MEASURE = 'MKT_FCST_PP')) M
            ON  M.AM = A.MEASURE
        INNER JOIN MEA B
            ON  B.MEASURE = M.BM"""
MEAS_MAP = "CASE WHEN M.PP = 'Y' THEN 'MKT_FCST_PP' ELSE " + CUST_MEAS + " END"
LD_JOIN = """        LEFT JOIN LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE"""
C_JOIN_VALID = """        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'"""


def s0_param_token():
    """원문 L257~297: DELETE + 분해 INSERT 10 → DELETE + INSERT 1 (UNION ALL)."""
    parts = [("p_plant_site_id", "p_plant_site_id"), ("p_project_code", "p_project_code"), ("p_owner", "p_owner"),
             ("p_sender_code", "p_sender_code"), ("p_team_id", "p_team_id"), ("p_scm_site_id", "p_scm_site_id"),
             ("p_customer", "p_customer"), ("p_biz_type", "p_biz_type"), ("p_item_id", "p_item_id")]
    sel = "\n    UNION ALL\n".join(f"    SELECT '{n}', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN({p}, ','))" for n, p in parts)
    return f"""    /* {MARK} S0 — 원문 L257~297 PARAM_TOKEN 분해 INSERT 10 문장 → 1 문장 (토큰 내용 동일 · 함수 호출 횟수 동일). */
    DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
{sel}
    UNION ALL
    /* [GAP439 2026-10-15] 버전 토큰은 첫 '(' 이후 절단 (원문 L289~297 그대로) */
    SELECT 'p_version_type'
         , CASE WHEN UPPER(COLUMN_VALUE) LIKE '%CURRENT%' THEN COLUMN_VALUE
                ELSE TRIM(REGEXP_REPLACE(COLUMN_VALUE, '\\(.*$', ''))
           END
    FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));
"""


def s1_site_item():
    """원문 L611~1114: ORI_V/A_V/B_V/_V/SITE_ITEM_ALL 5 GTT + 필터 DELETE 5 → TEMP_SITE_ITEM INSERT 1 (CTE 체인).
       L1126~1151 선행 축소 DELETE 는 build.py 가 원문 그대로 뒤에 붙인다 (NOT IN NULL 의미 보존)."""
    return f"""    /* {MARK} S1 — 원문 L611~1114 (ORI_V → A_V/B_V → _V → SITE_ITEM_ALL → TEMP_SITE_ITEM) 를 CTE 체인 1 INSERT 로.
       · 원문 L842 p_item_id 필터는 _V 단계(CTE V)에 두어 T2·T4(CELL_MODEL 닉네임 조회) 둘 다 필터본을 본다 (원문 동일).
       · 원문 L1002~1048 site/customer/biz/item 필터(NOT EXISTS DELETE) = 생존 조건 EXISTS 로 CTE ALLF 에 흡수 (의미 동일).
       · GTT 적재 시 묵시 변환 재현: _V.ENERGE NUMBER(20,4) · ALL.MIN_CAPACITY/CELL_QUANTITY/MODULE_PER_CAR NUMBER(20,10). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
      , CELL_MODEL, DMS_SALES, DMS_CUSTOMER, OWNER
      , DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
      , ITEM_TYPE, PROJECT_OWNER, BIZ_TYPE
      , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
      , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
      , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
      , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
      , SORT_ORDER_NO, ENERGE, CELL_QUANTITY, PLANT_SITE_ID
      , ITEM_VALID_YN, END_CUSTOMER, PROJECT_S_OP_REPORT
    )
    WITH ORI AS (  /* L614~659 */
        SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME
             , T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
             , T1.ACTIVE_FLAG, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
             , T1.FORECAST_INFO_BIZ_TYPE, T1.FORECAST_INFO_PRODUCT_GROUP
             , T1.FORECAST_INFO_CELL_MODEL, T1.FORECAST_INFO_CELL_PACK_COUNT
             , T1.FORECAST_INFO_SPEC, T1.FORECAST_INFOR_VERSION, T1.CELL_TYPE
        FROM   SCM_MGR.SCM_ITEM_M_SN T1
        WHERE  T1.DIVISION_ID = p_division_id
          AND  T1.ACTIVE_FLAG = 'Y'
          AND  SUBSTR(T1.ITEM_ID,1,12) IN (
                 SELECT SUBSTR(S.ITEM_ID,1,12)
                   FROM SCM_MGR.SCM_MST_SITE_ITEM S
                  WHERE S.DIVISION_ID = p_division_id )
    ), AV AS (  /* L671~703 */
        SELECT T1.DIVISION_ID
             , T1.ITEM_ID
             , MAX(T1.ITEM_NAME)                                AS ITEM_NAME
             , MAX(T1.ITEM_CLASS)                               AS ITEM_CLASS
             , MAX(T1.ITEM_CLASS_NAME)                          AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME)                                AS NICK_NAME
             , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                             WHEN T1.ITEM_TYPE = 'H' THEN 2
                             WHEN T1.ITEM_TYPE = 'Q' THEN 3
                             ELSE 4 END)
                    WHEN 1 THEN 'P'
                    WHEN 2 THEN 'H'
                    WHEN 3 THEN 'Q'
                    ELSE 'R'
               END                                              AS ITEM_TYPE
             , MAX(T1.MATERIAL_CLASS_NAME)                      AS MATERIAL_CLASS_NAME
             , MAX(T1.ITEM_UOM)                                 AS ITEM_UOM
             , MAX(T1.SPEC)                                     AS SPEC
             , MAX(T1.MDM_PROJECT_NAME)                         AS MDM_PROJECT_NAME
             , MAX(T1.MIN_CAPACITY)                             AS MIN_CAPACITY
             , MAX(T1.ACTIVE_FLAG)                              AS ACTIVE_FLAG
             , MAX(T1.ENERGE)                                   AS ENERGE
             , MAX(T1.CELL_QUANTITY)                            AS CELL_QUANTITY
             , MAX(T1.SCP_EXTRA_SPEC)                           AS SCP_EXTRA_SPEC
        FROM   ORI T1
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ), BV AS (  /* L715~732 */
        SELECT DIVISION_ID
             , SUBSTR(ITEM_ID, 1, 12)                           AS ITEM_ID
             , MAX(FORECAST_INFO_BIZ_TYPE)                      AS FORECAST_INFO_BIZ_TYPE
             , MAX(FORECAST_INFO_PRODUCT_GROUP)                 AS FORECAST_INFO_PRODUCT_GROUP
             , MAX(FORECAST_INFO_CELL_MODEL)                    AS FORECAST_INFO_CELL_MODEL
             , MAX(FORECAST_INFO_CELL_PACK_COUNT)               AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(FORECAST_INFO_SPEC)                          AS FORECAST_INFO_SPEC
             , MAX(FORECAST_INFOR_VERSION)                      AS FORECAST_INFOR_VERSION
             , MAX(CELL_TYPE)                                   AS CELL_TYPE
        FROM   ORI
        GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
    ), V0 AS (  /* L744~838 */
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
             , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
             , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
             , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
             , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
             , ACTIVE_FLAG, CELL_TYPE
             , CAST(CASE WHEN TO_NUMBER(ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL
                         THEN ROUND(TO_NUMBER(ENERGE) / 1000, 4)
                         ELSE NULL
                    END AS NUMBER(20,4))                        AS ENERGE  -- WH → KWH 환산 (GTT NUMBER(20,4) 재현)
             , CELL_QUANTITY, SCP_EXTRA_SPEC
        FROM (
            SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME
                 , T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
                 , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
                 , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT
                 , T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
                 , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
            FROM   AV T1
            INNER JOIN BV T2
                ON  T1.DIVISION_ID = T2.DIVISION_ID
                AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
            WHERE  T1.DIVISION_ID = p_division_id
        )
        GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
               , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
               , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
               , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    ), V AS (  /* L842~850 Item 필터 — NOT EXISTS DELETE 의 생존 조건 */
        SELECT F.*
        FROM   V0 F
        WHERE  p_item_id IS NULL
           OR  EXISTS (SELECT 1
                       FROM   SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                       WHERE  T.PARAM_NM = 'p_item_id'
                       AND    (F.ITEM_ID   LIKE '%' || T.TOKEN || '%'
                            OR F.NICK_NAME LIKE '%' || T.TOKEN || '%'))
    ), ALLX AS (  /* L864~998 */
        SELECT F.DIVISION_ID
             , F.PROJECT_CODE
             , F.SCM_SITE_ID
             , F.ITEM_ID
             , F.ATTRIBUTE5                                     AS CELL_MODEL
             , T2.NICK_NAME
             , F.ATTRIBUTE1                                     AS DMS_SALES
             , F.ATTRIBUTE2                                     AS DMS_CUSTOMER
             , (SELECT LISTAGG(X.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY X.USER_NAME_EN)
                FROM   (SELECT DISTINCT ZA.USER_NAME_EN
                        FROM   (SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL) AS TOK
                                FROM   DUAL
                                CONNECT BY LEVEL <= REGEXP_COUNT(F.OWNER, ',') + 1) TK
                        JOIN   SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = TK.TOK) X
               )                                                AS OWNER
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL
                    THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT DEFAULT NULL ON CONVERSION ERROR)
                    ELSE T2.FORECAST_INFO_CELL_PACK_COUNT
               END                                              AS FORECAST_INFO_CELL_PACK_COUNT
             , T2.ITEM_TYPE
             , NVL(MP.PROJECT_NAME, F.PROJECT_CODE)             AS PROJECT_NAME
             , J.USER_NAME_EN                                   AS PROJECT_OWNER
             , ''                                               AS BIZ_TYPE
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY_NAME
             , H.CITY_NAME
             , ''                                               AS PROJECT_STATUS
             , T2.ITEM_NAME
             , S.VMI_YN
             , F.CUST_GROUP
             , F.CUST_GROUP_DTL
             , F.APPLICATION
             , F.ROUTE
             , T2.MDM_PROJECT_NAME
             , CAST(TO_NUMBER(T2.MIN_CAPACITY DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(20,10)) AS MIN_CAPACITY
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                    ELSE T2.FORECAST_INFO_BIZ_TYPE
               END                                              AS FORECAST_INFO_BIZ_TYPE
             , LOOK.NAME                                        AS CELL_TYPE
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , T4.NICK_NAME                                     AS CELL_MODEL_NICK_NAME
             , TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_CAR
             , TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_MODULE
             , CAST(TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR)
               / CASE WHEN NVL(TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR), 0) = 0 THEN 1
                      ELSE TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR)
                 END AS NUMBER(20,10))                          AS MODULE_PER_CAR
             , CAST(NULL AS NUMBER(20,10))                      AS SORT_ORDER_NO
             , TO_CHAR(T2.ENERGE)                               AS ENERGE
             , CAST(TO_NUMBER(T2.CELL_QUANTITY DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(20,10)) AS CELL_QUANTITY
             , '/'                                              AS PLANT_SITE_ID
             , F.VALID_YN                                       AS ITEM_VALID_YN
             , S.END_CUSTOMER
             , CAST(NULL AS VARCHAR2(200))                      AS PROJECT_S_OP_REPORT
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        INNER JOIN V T2
            ON  F.DIVISION_ID = T2.DIVISION_ID
            AND F.ITEM_ID     = T2.ITEM_ID
        INNER JOIN SCM_MGR.SCM_MST_SITE S
            ON  F.DIVISION_ID = S.DIVISION_ID
            AND F.SCM_SITE_ID = S.SCM_SITE_ID
            AND S.SITE_TYPE   = 'SALES'
        INNER JOIN SCM_MGR.SCM_MST_CITY H
            ON  S.CITY        = H.CITY
        INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
            ON  S.COUNTRY     = I.COUNTRY
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
            ON  F.DIVISION_ID  = MP.DIVISION_ID
            AND F.PROJECT_CODE = MP.PROJECT_CODE
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
            ON TEAM.DEPT_ID = F.DEPT_ID
        LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
            ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                                 THEN F.OWNER
                                 ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                            END
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
            ON K.DEPT_ID = F.DEPT_ID
        LEFT JOIN (
            SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'CELL_TYPE'
        ) LOOK
            ON LOOK.CODE = T2.CELL_TYPE
        LEFT JOIN V T4
            ON  T2.DIVISION_ID = T4.DIVISION_ID
            AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
        LEFT JOIN (
            SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
            FROM (
                SELECT SEGMENT2 AS MODEL
                     , SEGMENT3 AS BIZ_TYPE
                     , SEGMENT4 AS CELL_PACK_COUNT
                     , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
                  AND  SEGMENT1    = '40'
            ) A
            WHERE MODEL_RANK = 1
        ) LOOKA
            ON LOOKA.MODEL = F.ITEM_ID
        WHERE  F.DIVISION_ID = p_division_id
    ), ALLF AS (  /* L1002~1048 조회조건 필터 4 (NOT EXISTS DELETE → 생존 EXISTS) */
        SELECT F.*
        FROM   ALLX F
        WHERE  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_customer IS NOT NULL AND p_customer <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_customer'
                           AND    T.TOKEN    = CASE WHEN p_division_id = '40' THEN F.PROJECT_CODE ELSE F.END_CUSTOMER END))
          AND  (   NOT (p_biz_type IS NOT NULL AND p_biz_type <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_biz_type' AND T.TOKEN = F.FORECAST_INFO_BIZ_TYPE))
          AND  (   p_item_id IS NULL
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T
                           WHERE  T.PARAM_NM = 'p_item_id'
                           AND    (F.ITEM_ID LIKE '%' || T.TOKEN || '%' OR F.NICK_NAME LIKE '%' || T.TOKEN || '%')))
    )
    /* L1060~1114 6키 GROUP BY MAX */
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL), MAX(DMS_SALES), MAX(DMS_CUSTOMER), MAX(OWNER)
         , MAX(DEPT_ID), MAX(DEPT_NAME_KO), MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(ITEM_TYPE), MAX(PROJECT_OWNER), MAX(BIZ_TYPE)
         , MAX(SOLDTO_CUSTOMER), MAX(COUNTRY_NAME), MAX(CITY_NAME), MAX(PROJECT_STATUS)
         , MAX(ITEM_NAME), MAX(VMI_YN), MAX(CUST_GROUP), MAX(CUST_GROUP_DTL), MAX(APPLICATION), MAX(ROUTE)
         , MAX(MDM_PROJECT_NAME), MAX(MIN_CAPACITY), MAX(FORECAST_INFO_BIZ_TYPE), MAX(CELL_TYPE)
         , MAX(FORECAST_INFO_ALL), MAX(FORECAST_INFO_SPEC), MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_MODEL_NICK_NAME), MAX(CELL_PER_CAR), MAX(CELL_PER_MODULE), MAX(MODULE_PER_CAR)
         , MAX(SORT_ORDER_NO), MAX(ENERGE), MAX(CELL_QUANTITY), MAX(PLANT_SITE_ID)
         , MAX(ITEM_VALID_YN), MAX(END_CUSTOMER), MAX(PROJECT_S_OP_REPORT)
    FROM   ALLF
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
"""


def _arm(name, src, where_div, b_join, c_join, d_join, ec, meas, plant, cp, qty, afs, cd, lu, cur, ver, cutoff, notation, extra_from="", ld_join=LD_JOIN, hint=""):
    return f"""        /* ── {name} ── */
        SELECT {hint}A.DIVISION_ID, A.PROJECT_CODE, {ec} AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , {meas} AS MEASURE
             , {plant} AS PLANT_SITE_ID, {cp} AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST({qty} AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , {C_SEL}
             , B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , {afs} AS AS_FROM_SITE
             , {cd} AS CREATE_DATE
             , {lu} AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , {cur} AS CURRENCY
             , {ver} AS VERSION_NO
             , {cutoff} AS CUTOFF_YYYYMMDD
             , {notation} AS NOTATION
        FROM   {src} A
{b_join}
{ld_join}
{c_join}
{d_join}{extra_from}
        WHERE  {where_div}
{_WHERE_PLACEHOLDER}"""


_WHERE_PLACEHOLDER = "        /*WHERE_TAIL*/"


def arm(name, src, where_div, where_tail, b_join, c_join=C_JOIN_VALID, d_join="        INNER JOIN WS D\n            ON  D.FCST_TYPE = A.FCST_TYPE",
        ec="A.PROJECT_CODE", meas="A.MEASURE", plant="A.PLANT_SITE_ID", cp="'-'", qty="A.QTY", afs="NVL(A.ATTRIBUTE10, ' ')",
        cd="LD.CREATE_DATE", lu="LD.LAST_UPDATED_BY", cur="CAST(NULL AS VARCHAR2(10))", ver="'Current'", cutoff="CAST(NULL AS VARCHAR2(8))",
        notation=NOTATION_A, extra_from="", ld_join=LD_JOIN, hint=""):
    t = _arm(name, src, where_div, b_join, c_join, d_join, ec, meas, plant, cp, qty, afs, cd, lu, cur, ver, cutoff, notation, extra_from, ld_join, hint)
    return t.replace(_WHERE_PLACEHOLDER, where_tail)


# 원문 L2292 의 힌트 그대로 (2026-09-30 [E20260930-DMF0082CLOUDPERF] — 종속 메저 0행 파싱 계획 CARTESIAN→PK 행별 고정 방지 · k0101 28.4s→0.03s).
# 2-A 초기 빌드에서 제거했다가 11-04 21:06 k0101/40 실측(S2-40 30.05s · 카티션 2,107,840행 · PK 탐침 LIO 7.85M)으로 같은 병리가 재현되어 복원.
A9_HINT = "/*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ "


def s2_fcst_n_price_current(div='ALL', cur_gate=False):
    """div = '81' | '82' | '40' | 'ALL'(검사용) — 원문 IF 분기처럼 해당 사업부 arm 만 포함.
       바인드 술어 FILTER 가 단락되지 않아 82 조회에서 40 arm(PK_DM_PLN_CFM_MKT_DEMAND_PLAN NL) 이 실행된 11-04 ASH 실측(172샘플) 대응."""
    """원문 L1168~1246 (SELECT_MEASURE 3 INSERT) · L1254~1273 (LD) · L1441~2361 (Current 8 arm) · L3707~3829 (CURRENCY MERGE 3)
       · L3841~3927 (파생 LOC/KRW/FCST_GAP) · L4129~4307 (DM_ADMIN 삭제 · 필터 6 · 중복제거 · qty_yn · 고아) → 1 INSERT."""
    b_eq = "        INNER JOIN MEA B\n            ON  B.MEASURE = A.MEASURE"
    b_pp = "        INNER JOIN MEA B\n            ON  A.MEASURE = 'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP'"   # (구 #3/#4 형태 — 보존용, 미사용)
    b_map = B_MAP
    meas_map = MEAS_MAP
    b_res = "        INNER JOIN MEA B\n            ON  B.RESULT_MEASURE = A.MEASURE"
    b_cust = ("        INNER JOIN MEA B\n            ON  B.MEASURE = A.MEASURE\n            AND B.MEASURE_GROUP = 'CUST_FCST'\n"
              "            AND B.MEASURE <> 'CUST_FCST'")
    b_amt = "        INNER JOIN MEA B\n            ON  B.MEASURE = A.MEASURE\n            AND NVL(B.USER_ID, '/') <> 'DM_ADMIN'"
    w_plan = "        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD\n        AND    A.QTY <> 0"
    w_res = "        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT\n        AND    A.QTY <> 0"
    cust_lu_ld = "CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA' ELSE A.LAST_UPDATED_BY || '_EXCEL' END ELSE LD.LAST_UPDATED_BY END"

    arms = [
        # #1 L1450~1551 Current × 81/82 수요 + #3 L1693~1748 MKT_FCST_PP 81/82 — 같은 원장(DM_PLN_MKT_FCST)·같은 WHERE 를 1회 읽기로 병합
        #   [E20261104-DMF0082PPMERGE] 구 #3/#4 는 MEA 와 키 없는 교차조인(A.MEASURE='MKT_FCST' AND B.MEASURE='MKT_FCST_PP') 이라 옵티마이저가
        #   GTT 카티션(MEA 1행 × WS × SITE_ITEM) 추정 1행 → 원장 PK 행별 NL 로 굳음 (원본 L1750 sqlid 1kr5k368wpvrj 자식 0~2 = 109회 1,709s
        #   LIO 310M · 1104 7bkjc2n8cwq8z minyonglee1/40 S2 59.5s LIO 10.4M, 11-04 23:11 실측). 측정값 매핑 M(AM→BM) 등가조인으로 치환:
        #   M = MEA 의 DISTINCT MEASURE(자기 자신, PP='N') ∪ ('MKT_FCST'→'MKT_FCST_PP', PP='Y' · MEA 에 MKT_FCST_PP 가 있을 때 1행).
        #   행 수 등가: 구 #1 = A×B(B.MEASURE=A.MEASURE) = A×M(N,DISTINCT)×B(B.MEASURE=M.BM) · 구 #3 = A(MKT_FCST)×B(PP) = A×M(Y,1행)×B(PP).
        #   #1 과 #3 의 WHERE(w_plan)·LD 조인(LD.MEASURE=A.MEASURE)·NOTATION(A.MEASURE 기준)·LU 는 동일 — #3 의 LU 기본값 LD.LAST_UPDATED_BY 는
        #   A.MEASURE='MKT_FCST' 이므로 cust_lu_ld 와 같은 값. MEASURE 출력만 M.PP 로 분기.
        arm("A1 L1450+L1693 수요·MKT_FCST_PP 81/82 (DM_PLN_MKT_FCST 1회)", "SCM_MGR.DM_PLN_MKT_FCST", D81 + " AND A.DIVISION_ID = p_division_id", w_plan, b_map,
            meas=meas_map, lu=cust_lu_ld),
        # #2 L1559~1687 Current × 40 수요 + #4 L1750~1805 MKT_FCST_PP 40 (INSERT ALL 의 출력 분기 — LD 는 CTE LD(40) 와 동일값) — 위와 같은 병합
        arm("A2 L1559+L1750 수요·MKT_FCST_PP 40 (DM_PLN_CFM_MKT_DEMAND_PLAN 1회)", "SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN", D40 + " AND A.DIVISION_ID = p_division_id", w_plan, b_map,
            ec="A.END_CUSTOMER", cp="A.CELL_PROD_SITE_ID", meas=meas_map, lu=cust_lu_ld),
        # #5 L1816~1866 81 only 금액 (사전집계 원장)
        arm("A5 L1816 MKT_AMT 81 (DM_PLN_SALES_PLAN 집계)",
            """( SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                     , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY, MAX(S.CREATION_DATE) AS CREATE_DATE, MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.DM_PLN_SALES_PLAN S
                WHERE  S.DIVISION_ID = p_division_id
                AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
                AND    S.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                GROUP BY S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                       , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD )""",
            "p_division_id LIKE '81%'", "        AND    A.QTY <> 0", b_amt, afs="' '", cd="A.CREATE_DATE", lu="A.LAST_UPDATED_BY", notation="'POINT3'", ld_join=""),
        # #8 L2160~2264 실적 (전 사업부)
        arm("A8 L2160 실적 (DM_PLN_SALES_PLAN_RESULT)", "SCM_MGR.DM_PLN_SALES_PLAN_RESULT", "A.DIVISION_ID = p_division_id", w_res, b_res,
            meas="B.MEASURE", cp="A.CELL_PROD_SITE_ID", cur="A.CURRENCY"),
        # #9 L2273~2361 CUST 종속 실적
        arm("A9 L2273 CUST 종속 실적 (DM_PLN_MKT_FCST_RESULT)", "SCM_MGR.DM_PLN_MKT_FCST_RESULT", "A.DIVISION_ID = p_division_id", w_res, b_cust,
            meas=CUST_MEAS, cd="CAST(NULL AS DATE)",
            lu="CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN A.CREATED_BY LIKE '%robot' THEN A.CREATED_BY || '_RPA' ELSE A.CREATED_BY || '_EXCEL' END ELSE NULL END",
            notation="'INTEGER'", ld_join="", hint=A9_HINT),
    ]
    # #6 L1871~2052 판가 81/82 · #7 L2054~2156 판가 40 — 원문 윈도 형태 그대로 (C01..C60 → 열 이름)
    price = []
    for name, src, dv, ec, cp, d_part, outer_cols in (
        ("A6 L1871 판가 81/82 (SCM_MST_FUTURE_PRICE 1회 읽기)", "SCM_MGR.SCM_MST_FUTURE_PRICE", D81, "A.PROJECT_CODE", "'-'",
         "        INNER JOIN WS D\n            ON  D.FCST_TYPE = A.FCST_TYPE\n", None),
        ("A7 L2054 판가 40 (DM_PLN_CFM_SELLING_PRICE 1회 읽기)", "SCM_MGR.DM_PLN_CFM_SELLING_PRICE", D40, "A.END_CUSTOMER", "A.CELL_PROD_SITE_ID",
         "", "EXISTS"),
    ):
        d_where = "" if outer_cols is None else "        AND    EXISTS (SELECT 1 FROM WS D WHERE D.FCST_TYPE = A.FCST_TYPE)\n"
        price.append(f"""        /* ── {name} ── */
        SELECT {FNP_COLS}
        FROM (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, {ec} AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID, {cp} AS CELL_PROD_SITE_ID, A.YYYYMMDD
             , CAST(NVL(A.PRICE, 0) AS NUMBER(30,10)) AS QTY
             , B.MEASURE_GROUP
             , {C_SEL}
             , B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY
             , ' ' AS AS_FROM_SITE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS CREATE_DATE
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS LAST_UPDATED_BY
             , CAST(NULL AS VARCHAR2(50)) AS SENDER_CODE, CAST(NULL AS VARCHAR2(200)) AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , CAST(NULL AS VARCHAR2(8)) AS CUTOFF_YYYYMMDD
             , {NOTATION_A} AS NOTATION
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   {src} A
        INNER JOIN MEA B
            ON  B.MEASURE = A.MEASURE
{C_JOIN_VALID}
{d_part}        WHERE  {dv}
{d_where}        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD""")
    tag = {'81': ('A1', 'A5', 'A6', 'A8', 'A9'), '82': ('A1', 'A6', 'A8', 'A9'), '40': ('A2', 'A7', 'A8', 'A9')}.get(div)   # A3/A4 는 A1/A2 에 병합
    allarms = arms[:5] + price + arms[5:]
    if tag:
        allarms = [a for a in allarms if a.lstrip().split()[2] in tag]
        assert len(allarms) == len(tag), (div, [a.lstrip().split()[2] for a in allarms])
    if cur_gate:
        # 2-B ALL 변형: Current arm 은 원문 L1453 IF 게이트(버전 문자열에 Current 포함)를 arm WHERE 에 싣는다 (8칸 들여쓴 WHERE 가 arm 당 정확히 1개)
        for i, a in enumerate(allarms):
            assert a.count("\n        WHERE  ") == 1, a.lstrip().split()[2]
            allarms[i] = a.replace("\n        WHERE  ", f"\n        WHERE  {G_CUR} AND ", 1)
    base_union = "\n        UNION ALL\n".join(allarms)

    key9 = "DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID"
    key8n = ", ".join(f"NVL({k}, '/') AS {k}" for k in ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID", "INCOTERMS", "DOM_EXP", "FCST_TYPE"])
    key8g = ", ".join(f"NVL({k}, '/')" for k in ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID", "INCOTERMS", "DOM_EXP", "FCST_TYPE"])
    key5n = ", ".join(f"NVL({k}, '/') AS {k}" for k in ["DIVISION_ID", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE"])
    key5g = ", ".join(f"NVL({k}, '/')" for k in ["DIVISION_ID", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE"])
    on9 = " AND ".join(f"B.{k} = L9.{k}" for k in key9.split(", "))
    on8 = " AND ".join(f"NVL(B.{k}, '/') = L8.{k}" for k in ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID", "INCOTERMS", "DOM_EXP", "FCST_TYPE"])
    on5 = " AND ".join(f"NVL(B.{k}, '/') = L5.{k}" for k in ["DIVISION_ID", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE"])
    cols59 = ", ".join(f"B.{c}" for c in FNP_LIST if c != "CURRENCY")
    all59 = ", ".join(c for c in FNP_LIST if c != "QTY")      # 중복 제거 키 (원문 L4228 = QTY 제외 59열)
    drv_group = "A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID\n           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID\n           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE\n           , A.VERSION_NO, A.CUTOFF_YYYYMMDD"
    drv_cols = f"""A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD"""
    drv_tail = f"""             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
             , {C_MAX}
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO, MAX(A.ENERGE) AS ENERGE, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
             , NVL(MAX(A.AS_FROM_SITE), ' ') AS AS_FROM_SITE, MAX(A.CREATE_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.SENDER_CODE) AS SENDER_CODE, MAX(A.SENDER_NAME) AS SENDER_NAME, MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
             , MAX(A.CURRENCY) AS CURRENCY, A.VERSION_NO, A.CUTOFF_YYYYMMDD"""
    sel60 = ", ".join(FNP_LIST)
    qf9 = "DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, END_CUSTOMER, CELL_PROD_SITE_ID"
    qf9_nn = " AND ".join(f"{k} IS NOT NULL" for k in qf9.split(", "))
    orph_part = ("NVL(DIVISION_ID, ' '), NVL(PROJECT_CODE, ' '), NVL(END_CUSTOMER, ' '), NVL(SCM_SITE_ID, ' '), NVL(ITEM_ID, ' '), "
                 "NVL(DOM_EXP, ' '), NVL(FCST_TYPE, ' '), NVL(INCOTERMS, ' '), NVL(PLANT_SITE_ID, '/'), NVL(AS_FROM_SITE, ' ')")

    return f"""    /* {MARK} S2 — TEMP_FCST_N_PRICE 적재 1 INSERT (Current 경로).
       원문 대응: MEA=L1168~1246(SELECT_MEASURE 3 INSERT) · WS=L549~554 · LD=L1254~1273(81/82) + L1559 INSERT ALL 의 LD 분기(40)
         · BASE=L1441~2361 Current 8 arm · LOC9/LOC8/LOC5+CUR=L3707~3829 CURRENCY MERGE 3 · DRV1=L3841~3927
         · FLT=L4129~4204(DM_ADMIN 제외 · 조회조건 필터 6) · DEDUP=L4220~4232 · QTYF=L4246~4282 · ORPHF=L4291~4307.
       순서 의존 보존: CUR → DRV1 → FLT → DEDUP → QTY → ORPH. DELETE 의 생존 조건은 '삭제 조건이 TRUE 가 아님' 으로 썼다(NULL 의미 동일). */
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
    ( {FNP_COLS} )
    WITH WS AS (  /* L551~554 */
        SELECT DISTINCT A.SEGMENT1 AS FCST_TYPE
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
        WHERE  A.LOOKUP_TYPE = 'SALES_TYPE_CODE'
    ), MEA1 AS (  /* L1170~1187 사용자 선택 메저 */
        SELECT U.COLUMN_NAME                          AS MEASURE
             , NVL(M.ATTRIBUTE5, U.COLUMN_NAME)       AS RESULT_MEASURE
             , U.COLUMN_NAME                          AS MEASURE_GROUP
             , CAST(U.SORT_ORDER_NO AS NUMBER(10,2))  AS SORT_ORDER_NO
             , U.USER_ID
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
        INNER JOIN SCM_MGR.SCM_MST_SHEET_MEASURE M
            ON  M.PROGRAM_ID  = U.PROGRAM_ID
            AND M.SHEET_NAME  = U.SHEET_NAME
            AND M.COLUMN_NAME = U.COLUMN_NAME
            AND M.VALID_YN    = 'Y'
        WHERE  U.PROGRAM_ID = VA_PROGRAM_ID
        AND    U.SHEET_NAME = VA_SHEET_NAME
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND    U.USER_ID    = p_created_by
    ), MEA2 AS (  /* L1196~1223 CUST_FCST 종속 메저 (MEA1 에 없는 것) */
        SELECT S.MEASURE, S.MEASURE AS RESULT_MEASURE, 'CUST_FCST' AS MEASURE_GROUP
             , CAST(A.SORT_ORDER_NO + S.SORT_NO AS NUMBER(10,2)) AS SORT_ORDER_NO, A.USER_ID
        FROM  (SELECT U.USER_ID, U.SORT_ORDER_NO
               FROM   SCM_MGR.SCM_MST_TITLESET_USER U
               WHERE  U.PROGRAM_ID = VA_PROGRAM_ID
                 AND  U.SHEET_NAME = VA_SHEET_NAME
                 AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND  U.USER_ID    = p_created_by
                 AND  U.COLUMN_NAME = 'CUST_FCST') A,
              (SELECT MEASURE, MIN(SORT_NO) AS SORT_NO
               FROM  (SELECT 'CUST_FCST_EDI'               AS MEASURE, 0.11 AS SORT_NO FROM DUAL UNION ALL
                      SELECT 'Backorder'                             , 0.12 FROM DUAL UNION ALL
                      SELECT 'Commercial_Agreement'                  , 0.13 FROM DUAL UNION ALL
                      SELECT 'Firm_Temp'                             , 0.14 FROM DUAL UNION ALL
                      SELECT 'Immidiate'                             , 0.15 FROM DUAL UNION ALL
                      SELECT 'Manumacturing_Material_Temp'           , 0.16 FROM DUAL UNION ALL
                      SELECT 'Material_Temp'                         , 0.17 FROM DUAL UNION ALL
                      SELECT 'Planning_Forecast'                     , 0.18 FROM DUAL
                      UNION ALL
                      SELECT C.MEASURE, 0.10
                      FROM   SCM_MGR.DM_MST_CUSTOMER_FCST C
                      WHERE  C.MEASURE_GROUP = 'CUST_FCST'
                        AND  NVL(C.MEASURE, '/') <> '/'
                        AND  C.VALID_YN = 'Y')
               GROUP BY MEASURE) S
        WHERE NOT EXISTS (SELECT 1 FROM MEA1 X WHERE X.MEASURE = S.MEASURE)
    ), MEA3 AS (  /* L1236~1246 강제 포함 8 (MEA1∪MEA2 에 없는 것) */
        SELECT M.COLUMN_NAME AS MEASURE, M.COLUMN_NAME AS RESULT_MEASURE, M.COLUMN_NAME AS MEASURE_GROUP
             , CAST(M.SORT_ORDER_NO AS NUMBER(10,2)) AS SORT_ORDER_NO, 'DM_ADMIN' AS USER_ID
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE M
        WHERE  M.PROGRAM_ID  = VA_PROGRAM_ID
        AND    M.SHEET_NAME  = VA_SHEET_NAME
        AND    M.COLUMN_NAME IN ('LOC', 'KRW', 'FCST_GAP', 'RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW', 'SCM_FCST', 'MKT_FCST')
        AND    NOT EXISTS (SELECT 1 FROM MEA1 X WHERE X.MEASURE = M.COLUMN_NAME)
        AND    NOT EXISTS (SELECT 1 FROM MEA2 X WHERE X.MEASURE = M.COLUMN_NAME)
    ), MEA AS (
        SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID FROM MEA1
        UNION ALL SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID FROM MEA2
        UNION ALL SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID FROM MEA3
    ), LD AS (  /* L1258~1273 (81/82 DM_PLN_MKT_FCST) · L1559 INSERT ALL 의 LD 분기 (40 DM_PLN_CFM_MKT_DEMAND_PLAN) — 8키 1행 */
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  {D81}
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        UNION ALL
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
             , MAX(A.CREATION_DATE) AS CREATE_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID = A.DIVISION_ID AND C.PROJECT_CODE = A.PROJECT_CODE AND C.SCM_SITE_ID = A.SCM_SITE_ID AND C.ITEM_ID = A.ITEM_ID
        WHERE  {D40}
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
    ), BASE AS (  /* L1446~2361 Current 8 arm */
{base_union}
    ), LOC9 AS (  /* L3707~3730 1차 (9키 · MAX) */
        SELECT {key9}, MAX(CURRENCY) AS CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        GROUP BY {key9}
    ), LOC8 AS (  /* L3747~3786 2차 (8키 NVL · 단일 통화) */
        SELECT {key8n}, MIN(CURRENCY) AS CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    CURRENCY IS NOT NULL
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        GROUP BY {key8g}
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), LOC5 AS (  /* L3801~3829 3차 (5키 NVL · 단일 통화) */
        SELECT {key5n}, MIN(CURRENCY) AS CURRENCY
        FROM   BASE
        WHERE  MEASURE = 'LOC'
        AND    CURRENCY IS NOT NULL
        AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        GROUP BY {key5g}
        HAVING COUNT(DISTINCT CURRENCY) = 1
    ), CUR AS (  /* MERGE 3 = NULL 통화 행만 1차→2차→3차 순 채움 (p_from~V_TO 행) */
        SELECT {cols59}
             , CASE WHEN B.CURRENCY IS NULL AND B.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
                    THEN COALESCE(L9.CURRENCY, L8.CURRENCY, L5.CURRENCY)
                    ELSE B.CURRENCY END AS CURRENCY
        FROM   BASE B
        LEFT JOIN LOC9 L9 ON ({on9})
        LEFT JOIN LOC8 L8 ON ({on8})
        LEFT JOIN LOC5 L5 ON ({on5})
    ), DRV1 AS (  /* L3841~3927 LOC/KRW Unit Price + FCST_GAP (Current) */
        SELECT {drv_cols}
             , CASE D.MEASURE
                   WHEN 'LOC' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                        THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                                           / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                        ELSE 0 END
                   WHEN 'KRW' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                        THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                                           / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                        ELSE 0 END
               END AS QTY
{drv_tail}
             , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   CUR A
        JOIN   MEA D ON D.MEASURE IN ('LOC','KRW')
        WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD < V_TO_RESULT
        GROUP BY {drv_group}
        UNION ALL
        SELECT {drv_cols}
             , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
{drv_tail}
             , 'INTEGER' AS NOTATION
        FROM   CUR A
        JOIN   MEA D ON D.MEASURE = 'FCST_GAP'
        WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
        AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
        GROUP BY {drv_group}
    ), UNI AS (
        SELECT {sel60} FROM CUR
        UNION ALL
        SELECT {", ".join(c if c != "QTY" else "CAST(QTY AS NUMBER(30,10)) AS QTY" for c in FNP_LIST)} FROM DRV1
    ), FLT AS (  /* L4129 DM_ADMIN 제외 · L4149~4204 조회조건 필터 6 (생존 = 삭제조건 ≠ TRUE) */
        SELECT F.*
        FROM   UNI F
        WHERE  NOT EXISTS (SELECT 1 FROM MEA B WHERE B.USER_ID = 'DM_ADMIN' AND B.MEASURE = F.MEASURE)
          AND  (   NOT (p_scm_site_id IS NOT NULL AND p_scm_site_id <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_scm_site_id' AND T.TOKEN = F.SCM_SITE_ID))
          AND  (   NOT (p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id')
                    AND (   F.PLANT_SITE_ID IS NULL
                         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_plant_site_id' AND (T.TOKEN IS NULL OR T.TOKEN = F.PLANT_SITE_ID)))))
          AND  (   NOT (p_project_code IS NOT NULL AND p_project_code <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.PROJECT_CODE, ' ')))))
          AND  (   NOT (p_owner IS NOT NULL AND p_owner <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_owner' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.OWNER, ' ')))))
          AND  (   NOT (p_sender_code IS NOT NULL AND p_sender_code <> 'ALL')
                OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_sender_code' AND T.TOKEN = F.SENDER_CODE))
          AND  (   NOT (p_team_id IS NOT NULL AND p_team_id <> 'ALL')
                OR (    EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id')
                    AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_team_id' AND (T.TOKEN IS NULL OR T.TOKEN = NVL(F.DEPT_ID, ' ')))))
    )
    /* 중복제거(L4220~4232) · qty_yn(L4246~4282) · 고아(L4291~4307) 는 INSERT 뒤 원문 DELETE 그대로 — 윈도 정렬 3회가 넓은 행 전부를 TEMP 에 재기록(82 실측 46s)해 환원 */
    SELECT {sel60}
    FROM   FLT;
"""
