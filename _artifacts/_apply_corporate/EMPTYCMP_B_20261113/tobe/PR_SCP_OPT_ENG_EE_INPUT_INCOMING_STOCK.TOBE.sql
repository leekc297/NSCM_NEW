-- SOURCE-FRESH: SCM_MGR.PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK PROCEDURE LAST_DDL=2026-10-13 15:26:20 FETCHED=2026-11-13 19:09:04 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK
(
     P_PLAN_ID              VARCHAR2
    ,P_DIVISION_ID          VARCHAR2
    ,P_GROUP_ID             VARCHAR2
    ,P_PLAN_START_YYYYMMDD  VARCHAR2
    ,P_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK
 * Description  : EE(전극) Optimization Engine 입력용 Incoming Stock(창고/해상/Workbench/자재 입고예정) 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.05    Y.S.H          Initial Release
 * 2025.05.30    Philsu Park    OPT ENG LOOKUP 반영.
 * 2025.08.08    Philsu Park    소형 전극 재고 반영 시 PRODUCT_TYPE 제약조건 추가.
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    /* Set Prameter */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK';
    V_PLAN_ID             VARCHAR2(50 CHAR)   := P_PLAN_ID;
    V_DIVISION_ID         VARCHAR2(20 CHAR)   := P_DIVISION_ID;
    V_GROUP_ID            VARCHAR2(20 CHAR)   := P_GROUP_ID;
    V_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR)    := P_PLAN_START_YYYYMMDD;
    V_PLAN_END_YYYYMMDD   VARCHAR2(8 CHAR)    := P_PLAN_END_YYYYMMDD;
    V_MESSAGE_TEXT        VARCHAR2(1000 CHAR);
    V_DETAIL_DATE         DATE;
    /* Set Param for Biz */
    V_P_PLAN_NAME         VARCHAR2(8 CHAR);
    V_P_PLAN_TYPE         VARCHAR2(4000 CHAR);
    V_P_SEQ               VARCHAR2(4000 CHAR);
    V_P_MODELING_ID       VARCHAR2(4000 CHAR);
    V_CUTOFF_DAY          VARCHAR2(8 CHAR);
    V_D_CUTOFF_DAY        DATE;
    V_DEMAND_CUTOFF_DAY   VARCHAR2(8 CHAR);
    V_D_PLAN_NAME         DATE;                  /* added 2025-11-24 jongykim2 */
    V_SINGLE_PLAN_TYPE    VARCHAR2(1 CHAR);      /* added 2025-11-24 jongykim2 */
    V_PLAN_GROUP_ORG      VARCHAR2(20 CHAR);     /* added 2025-11-24 jongykim2 */
    V_MAX_TUESDAY         VARCHAR2(8 CHAR);
BEGIN
    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);

    /* Transaction (START) */
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    BEGIN
        /* Get Param Info */
        BEGIN
            SELECT
                   ATTRIBUTE1
                 , ATTRIBUTE2
              INTO V_DIVISION_ID
                 , V_GROUP_ID
              FROM SCP_OPT_ENG_PLAN_MASTER_SN
             WHERE PLAN_ID = V_PLAN_ID;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        SELECT
               MAX(BASIS_YYYYMMDD)
          INTO V_MAX_TUESDAY
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND DAYOFWEEK       = 'TUE';

        BEGIN
            SELECT
                   MODELING_ID
              INTO V_P_MODELING_ID
              FROM SCM_MST_MODELING
             WHERE PLAN_CYCLE  = 'WEEKLY'
               AND DIVISION_ID = V_DIVISION_ID;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        V_P_PLAN_NAME       := V_PLAN_START_YYYYMMDD;                                                  /* 당주 월요일 YYYYMMDD */
        V_D_PLAN_NAME       := TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD');                                     /* added 2025-11-24 jongykim2 */
        V_CUTOFF_DAY        := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');    /* 지난주 일요일 YYYYMMDD */
        V_D_CUTOFF_DAY      := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');
        V_DEMAND_CUTOFF_DAY := V_MAX_TUESDAY;                                                          /* 당주 화요일 YYYYMMDD */

        /* START 2025-11-24 jongykim2 */
        V_SINGLE_PLAN_TYPE := CASE WHEN SUBSTR(V_GROUP_ID, -2) = '_C' THEN 'C' WHEN SUBSTR(V_GROUP_ID, -2) = '_A' THEN 'A' ELSE '-' END;
        V_PLAN_GROUP_ORG   := CASE WHEN SUBSTR(V_GROUP_ID, -2) IN ('_C', '_A') THEN SUBSTR(V_GROUP_ID, 1, LENGTH(V_GROUP_ID) - 2) ELSE V_GROUP_ID END;
        /* END 2025-11-24 jongykim2 */

        /* 자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용 */
        /* SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
           FROM   SCP_OPT_ENG_PLAN_MASTER_SN
           WHERE  PLAN_ID = @V_PLAN_ID */

        DELETE
          FROM GT_OPTENG_EEIS_MAT;

        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
        INSERT
          INTO GT_OPTENG_EEIS_MAT
             ( MAT_ID
             , EFF_END_DATE )
        SELECT ITEM_ID_CHILD AS MAT_ID
             , TO_CHAR(MAX(TO_DATE(TO_YYYYMMDD, 'YYYYMMDD')) + 1, 'YYYYMMDD') AS EFF_END_DATE
          FROM SCP_OPMZ_VIRTUAL_BOM A
             , SCP_OPMZ_PLAN_GR_M   B
         WHERE A.OPMZ_PLAN_GR_ID   = B.OPMZ_PLAN_GR_ID
           AND A.DIVISION_ID       = V_DIVISION_ID
           AND B.OPMZ_PLAN_GR_NAME = V_GROUP_ID
           AND A.VALID_YN          = 'Y'
           AND B.VALID_YN          = 'Y'
         GROUP BY ITEM_ID_CHILD;
        /* END 2025.11.19 jongykim2: Schelduled Reciept Information */
        /* START 2025.11.19 jongykim2
           SELECT   ATTRIBUTE1 AS MAT_ID
                   ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
           FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
           WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
           AND      LU.VALID_YN    = 'Y'
           AND      LU.SEGMENT2    = @V_DIVISION_ID
           AND      LU.SEGMENT3    = @V_GROUP_ID
           GROUP BY ATTRIBUTE1 */

        DELETE
          FROM GT_OPTENG_EE_DIV;

        INSERT
          INTO GT_OPTENG_EE_DIV
             ( DIVISION_ID )
        SELECT DIVISION_ID
          FROM SCM_MST_DIVISION
         WHERE VALID_YN   = 'Y'
           AND ATTRIBUTE3 <> 'EE'
           AND ATTRIBUTE4 = (SELECT ATTRIBUTE4
                               FROM SCM_MST_DIVISION
                              WHERE DIVISION_ID = V_DIVISION_ID);   /* 전극 Division 변수 */

        /* Data Insert Start */
        DELETE
          FROM GT_OPTENG_EEIS_INV;

        DELETE
          FROM GT_OPTENG_EEIS_INT;

        /* 1. 창고 재고 : WH */
        /* 1.1 SALES 재고 */
        INSERT
          INTO GT_OPTENG_EEIS_INV
             ( DIVISION_ID
             , SCM_SITE_ID
             , INCOTERMS
             , STOCK_TYPE
             , ITEM_ID
             , AVAILABLE_DATE
             , QTY
             , WIPHOLD_YN
             , SITE_TYPE
             , LOCATION_CODE
             , PROJECT_CODE
             , FLAG )
        SELECT /* DISTINCT */
               A.DIVISION_ID AS DIVISION_ID
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS   /* 뒤에서 별도 UPDATE */
             , A.STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , CASE WHEN A.WIPHOLD_YN IS NULL                                   THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                     THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                             TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY   /* SCP 사용 QTY */
             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
             , C.SITE_TYPE
             , '-'     AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , '-'     AS PROJECT_CODE    /* 뒤에서 별도 UPDATE */
             , 'SALES' AS FLAG
          FROM SCM_DNM_STOCK    A
             , GT_OPTENG_EE_DIV B
             /* SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음 */
             , (
                SELECT DISTINCT D.DIVISION_ID
                     , D.SCM_SITE_ID
                     , D.SITE_TYPE
                  FROM SCM_MST_SITE     D
                     , GT_OPTENG_EE_DIV E
                 WHERE 1 = 1
                   AND D.DIVISION_ID = E.DIVISION_ID
                   AND D.SITE_TYPE   = 'SALES'
               ) C
         WHERE 1 = 1
           AND A.DIVISION_ID = B.DIVISION_ID
           AND A.DIVISION_ID = C.DIVISION_ID
           AND A.SCM_SITE_ID = C.SCM_SITE_ID
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           /* 전극 Item */
           AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E'
           AND (A.DIVISION_ID  = '40' AND A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
             OR A.DIVISION_ID != '40')
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           AND A.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                               WHERE PLAN_ID = V_PLAN_ID);

        /* Oracle : ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN (INCOTERMS/LOCATION_CODE/PROJECT_CODE VARCHAR(100)) -> GTT 정의 폭에 선반영(불필요) */

        /* 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리 */
        INSERT
          INTO GT_OPTENG_EEIS_INV
             ( DIVISION_ID
             , SCM_SITE_ID
             , INCOTERMS
             , STOCK_TYPE
             , ITEM_ID
             , AVAILABLE_DATE
             , QTY
             , WIPHOLD_YN
             , SITE_TYPE
             , LOCATION_CODE
             , PROJECT_CODE
             , FLAG )
        SELECT /* DISTINCT */
               A.DIVISION_ID    AS DIVISION_ID
             , A.TO_SCM_SITE_ID AS SCM_SITE_ID
             , '-'              AS INCOTERMS   /* 뒤에서 별도 UPDATE */
             , 'SO'             AS STOCK_TYPE
             , A.ITEM_ID        AS ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전 */
             /* 엔진 오류로 Plan 구간 안으로 처리 */
             , TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') AS AVAILABLE_DATE
             , A.DELIVERY_QTY AS QTY
             , 'N'            AS WIPHOLD_YN
             , C.SITE_TYPE
             , '-'            AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , 'SALES'        AS FLAG
          FROM SCM_DNM_INTRANSIT_C A
             , GT_OPTENG_EE_DIV    B
             /* SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음 */
             , (
                SELECT DISTINCT D.DIVISION_ID
                     , D.SCM_SITE_ID
                     , D.SITE_TYPE
                  FROM SCM_MST_SITE     D
                     , GT_OPTENG_EE_DIV E
                 WHERE 1 = 1
                   AND D.DIVISION_ID = E.DIVISION_ID
                   AND D.SITE_TYPE   = 'SALES'
               ) C
         WHERE 1 = 1
           AND A.DIVISION_ID    = B.DIVISION_ID
           AND A.DIVISION_ID    = C.DIVISION_ID
           AND A.TO_SCM_SITE_ID = C.SCM_SITE_ID
           AND A.RESULT_DATE    = V_CUTOFF_DAY
           /* SO Reserve Stock : result_type = 'B' 는 재고로 처리 */
           AND A.RESULT_TYPE    = 'B'
           AND A.VALID_YN       = 'Y'   /* 해상재고 */
           /* 전극 Item */
           AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E'
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           AND A.TO_SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                   FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                  WHERE PLAN_ID = V_PLAN_ID);

        /* 1.3 SALES 재고 : INCOTERMS UPDATE  (UPDATE..FROM 2 LEFT JOIN -> 상관 스칼라 서브쿼리) */
        UPDATE
               GT_OPTENG_EEIS_INV A
           SET A.INCOTERMS = NVL(NVL(
                             (SELECT MAX(CASE WHEN F.VMI_YN = 'Y' THEN 'DAP' ELSE B.INCOTERMS END)
                                FROM DM_PLN_NET_DEMAND B
                                   , (
                                      SELECT D.DIVISION_ID
                                           , D.SCM_SITE_ID
                                           , MAX(D.VERSION_NO) MAX_VERSION_NO
                                        FROM DM_PLN_NET_DEMAND D
                                           , GT_OPTENG_EE_DIV  E
                                       WHERE 1 = 1
                                         AND D.DIVISION_ID     = E.DIVISION_ID
                                         AND D.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* 화요일 일자(YYYYMMDD) */
                                       GROUP BY D.DIVISION_ID, D.SCM_SITE_ID
                                     ) C
                                   , (
                                      SELECT G.DIVISION_ID
                                           , G.SCM_SITE_ID
                                           , G.VMI_YN
                                        FROM SCM_MST_SITE     G
                                           , GT_OPTENG_EE_DIV H
                                       WHERE 1 = 1
                                         AND G.DIVISION_ID = H.DIVISION_ID
                                         AND G.VMI_YN      = 'Y'
                                     ) F
                               WHERE B.DIVISION_ID     = C.DIVISION_ID
                                 AND B.SCM_SITE_ID     = C.SCM_SITE_ID
                                 AND B.VERSION_NO      = C.MAX_VERSION_NO
                                 AND B.DIVISION_ID     = F.DIVISION_ID(+)
                                 AND B.SCM_SITE_ID     = F.SCM_SITE_ID(+)
                                 AND B.SCM_SITE_ID     = A.SCM_SITE_ID
                                 AND B.ITEM_ID         = A.ITEM_ID
                                 AND B.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY)
                           , (SELECT MAX(CASE WHEN M.VMI_YN = 'Y' THEN 'DAP' ELSE I.INCOTERMS END)
                                FROM DM_PLN_NET_DEMAND I
                                   , (
                                      SELECT K.DIVISION_ID
                                           , K.SCM_SITE_ID
                                           , MAX(K.VERSION_NO) MAX_VERSION_NO
                                        FROM DM_PLN_NET_DEMAND K
                                           , GT_OPTENG_EE_DIV  L
                                       WHERE 1 = 1
                                         AND K.DIVISION_ID     = L.DIVISION_ID
                                         AND K.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* 화요일 일자(YYYYMMDD) */
                                       GROUP BY K.DIVISION_ID, K.SCM_SITE_ID
                                     ) J
                                   , (
                                      SELECT N.DIVISION_ID
                                           , N.SCM_SITE_ID
                                           , N.VMI_YN
                                        FROM SCM_MST_SITE     N
                                           , GT_OPTENG_EE_DIV O
                                       WHERE 1 = 1
                                         AND N.DIVISION_ID = O.DIVISION_ID
                                         AND N.VMI_YN      = 'Y'
                                     ) M
                               WHERE I.DIVISION_ID     = J.DIVISION_ID
                                 AND I.SCM_SITE_ID     = J.SCM_SITE_ID
                                 AND I.VERSION_NO      = J.MAX_VERSION_NO
                                 AND I.DIVISION_ID     = M.DIVISION_ID(+)
                                 AND I.SCM_SITE_ID     = M.SCM_SITE_ID(+)
                                 AND I.SCM_SITE_ID     = A.SCM_SITE_ID
                                 AND I.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY)),
                             'DAP')   /* DEMAND 없는 경우 DAP 처리 */
         WHERE 1 = 1
           AND A.SITE_TYPE = 'SALES';

        /* 1.4 PLANT 재고 */
        INSERT
          INTO GT_OPTENG_EEIS_INV
             ( DIVISION_ID
             , SCM_SITE_ID
             , INCOTERMS
             , STOCK_TYPE
             , ITEM_ID
             , AVAILABLE_DATE
             , QTY
             , WIPHOLD_YN
             , SITE_TYPE
             , LOCATION_CODE
             , PROJECT_CODE
             , FLAG )
        SELECT A.DIVISION_ID AS DIVISION_ID
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , CASE WHEN B.OPERATION_GROUP = 'E' THEN '-'
                    ELSE 'DAP'
               END AS INCOTERMS
             , A.STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , CASE WHEN A.WIPHOLD_YN IS NULL                                   THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                     THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                             TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY
             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
             , B.SITE_TYPE
             /* , CASE WHEN ISNULL(OP.LOCATION_CODE, '') <> '' THEN OP.LOCATION_CODE
                       WHEN ISNULL(ST.LOCATION_CODE, '') <> '' THEN ST.LOCATION_CODE
                       ELSE '-'
                  END AS LOCATION_CODE -- PLANT 재고 구분용 정보 */
             , A.LOCATION_CODE AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , CASE WHEN B.OPERATION_GROUP = 'E' THEN ''
                    ELSE '-'
               END AS PROJECT_CODE
             , 'PLANT' AS FLAG
          FROM SCM_DNM_STOCK A
             , (
                SELECT DISTINCT C.DIVISION_ID
                     , C.SCM_SITE_ID
                     , C.SITE_TYPE
                     , C.OPERATION_GROUP
                  FROM SCM_MST_SITE     C
                     , GT_OPTENG_EE_DIV D
                 WHERE 1 = 1
                   AND C.DIVISION_ID      = D.DIVISION_ID
                   AND C.SITE_TYPE        = 'PLANT'
                   AND C.OPERATION_GROUP IN ('E', 'A')
               ) B
             /* LEFT JOIN (  SELECT DISTINCT
                                       A.OPERATION_ID
                                    ,  A.LOCATION_CODE
                            FROM   scm_mst_location a WITH (NOLOCK)
                                    INNER JOIN (SELECT S.DIVISION_ID, S.scm_site_id
                                                FROM   scm_mst_site S WITH (NOLOCK)
                                                INNER JOIN #DIVISION D WITH(NOLOCK)
                                                ON S.DIVISION_ID = D.DIVISION_ID
                                                WHERE  1=1
                                                AND    S.valid_yn        = 'Y'
                                                AND    S.operation_group IN ( 'A' )
                                                ) b
                                    ON  a.DIVISION_ID = b.DIVISION_ID
                                    AND a.scm_site_id = b.scm_site_id
                            WHERE  1=1
                            AND    a.valid_yn    = 'Y'
                            AND    location_code IN ('COATING', 'SLITTING'      전극 공정
                                                    ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING'  셀공정 : PACKAGING 이전
                                                    )
                            AND    (operation_id IS NOT NULL AND operation_id <> '')
                        )  op  셀의 operation_id 별 사용대상 조회
                ON   A.operation_id = op.operation_id
                LEFT JOIN (  SELECT DISTINCT
                                       a.storage_id
                                    ,  a.location_code
                            FROM   DBO.scm_mst_location a WITH (NOLOCK)
                                    INNER JOIN (SELECT S.DIVISION_ID, S.scm_site_id
                                                FROM   scm_mst_site S WITH (NOLOCK)
                                                INNER JOIN #DIVISION D WITH(NOLOCK)
                                                ON S.DIVISION_ID = D.DIVISION_ID
                                                WHERE  1=1
                                                AND    S.valid_yn        = 'Y'
                                                AND    S.operation_group IN ( 'A' )
                                                ) b
                                    ON  a.DIVISION_ID = b.DIVISION_ID
                                    AND a.scm_site_id = b.scm_site_id
                            WHERE  1=1
                            AND    a.valid_yn    = 'Y'
                            AND    location_code IN ( 'COATING', 'SLITTING'      전극 공정
                                                    ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING'  셀공정 : PACKAGING 이전
                                                    )
                            AND    (storage_id IS NOT NULL AND storage_id <> '')
                            UNION  전극 출하 SLOC는 별도 Lookup으로 설정
                            SELECT a.segment3       AS storage_id
                                 , 'ELECTRODE_SHIP' AS location_code
                            FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
                            WHERE  a.lookup_type = 'ELECTRODE_SHIP_SITE'
                            AND    a.valid_yn    = 'Y'
                        )  st  셀의 storage_id 별 사용대상 조회
                ON   A.storage_id   = st.storage_id */
         WHERE 1 = 1
           AND A.DIVISION_ID   = B.DIVISION_ID
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND A.CUTOFF_DATE   = V_CUTOFF_DAY
           AND A.LOCATION_CODE IN ( 'COATING', 'SLITTING'   /* 전극 공정 */
                                   ,'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING'   /* 셀공정 : PACKAGING 이전 */
                                  )
           AND (A.DIVISION_ID  = '40' AND A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
             OR A.DIVISION_ID != '40')
           /*************************
           대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 확인 필요
           *************************/
           AND ((B.OPERATION_GROUP = 'E' AND A.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                             FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                            WHERE PLAN_ID = V_PLAN_ID)
                )
             OR (B.OPERATION_GROUP = 'A' AND A.ITEM_ID IN (SELECT DISTINCT PARENT_ITEM_ID
                                                             FROM SCP_OPT_ENG_BOM_ELEC_SN
                                                            WHERE PLAN_ID = V_PLAN_ID
                                                              AND SCP_YN  = 'Y'
                                                            UNION
                                                           SELECT DISTINCT CHILD_ITEM_ID
                                                             FROM SCP_OPT_ENG_BOM_ELEC_SN
                                                            WHERE PLAN_ID = V_PLAN_ID
                                                              AND SCP_YN  = 'Y')
                )
               );

        /* 3. 해상 재고 : INT */
        /* 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
        INSERT
          INTO GT_OPTENG_EEIS_INT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SCM_SITE_ID
             , INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
             , FLAG )
        /*           ※되돌리지 말 것 - 되돌리면 이 INSERT 가 결과 0행이어도 36~48분 걸리는 상태로 회귀한다. */
        WITH INTRANSIT_MAT AS
           ( SELECT  *
               FROM SCM_DNM_INTRANSIT_V
              WHERE RESULT_DATE = V_CUTOFF_DAY
                AND RESULT_TYPE IN ('I', 'C')
           )
        SELECT A.DIVISION_ID    AS DIVISION_ID
             , A.ITEM_ID
             , A.TO_SCM_SITE_ID AS TO_SCM_SITE_ID
             , CASE WHEN E.SITE_TYPE != 'SALES' THEN 'DAP' ELSE A.FINAL_INCOTERMS END AS INCOTERMS   /* TS.SITE_TYPE가 SALES가 아니면 TARGETBIZ, TARGETBIZ의 INCOTERMS는 모두 DAP */
             /* , A.FINAL_INCOTERMS  AS INCOTERMS */
             /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , CASE WHEN A.ETA_DATE < V_P_PLAN_NAME THEN V_P_PLAN_NAME
                    ELSE A.ETA_DATE
               END AS ETA_DATE
             , A.DELIVERY_QTY
             /* ,IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN E.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-'   /* 법인간 이동 재고에는 Project Code 정보가 없음 */
                    WHEN E.SITE_TYPE = 'SALES' THEN CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END
                    WHEN E.SITE_TYPE = 'PLANT' THEN '-'   /* Cell Plant 가 Demand 로 동작하므로 '-' 처리 */
                    ELSE CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END
               END AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN E.SITE_TYPE = 'SALES' THEN 'SALES'
                    ELSE 'INT'
               END AS FLAG
          FROM INTRANSIT_MAT A
             , GT_OPTENG_EE_DIV    B
             , (
                SELECT DISTINCT DIVISION_ID
                     , ITEM_ID
                     , OPERATION_GROUP_ID
                  FROM SCM_MST_FINAL_ITEM_V
               ) C
             , (
                SELECT DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_GROUP
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID IN (SELECT DIVISION_ID
                                         FROM GT_OPTENG_EE_DIV)
                   AND SITE_TYPE        = 'PLANT'
                   AND OPERATION_GROUP IN ('E')   /* FROM_SITE 가 전극인 정보 */
                   AND VALID_YN         = 'Y'
               ) D
             , SCM_MST_SITE E
         WHERE 1 = 1
           AND A.DIVISION_ID      = B.DIVISION_ID
           AND A.DIVISION_ID      = C.DIVISION_ID
           AND A.ITEM_ID          = C.ITEM_ID
           AND C.OPERATION_GROUP_ID = 'E'   /* 전극 모델 */
           AND A.DIVISION_ID      = D.DIVISION_ID
           AND A.FROM_SCM_SITE_ID = D.SCM_SITE_ID
           AND A.DIVISION_ID      = E.DIVISION_ID
           AND A.TO_SCM_SITE_ID   = E.SCM_SITE_ID
           AND E.VALID_YN         = 'Y'
           AND (E.SITE_TYPE = 'SALES' OR E.OPERATION_GROUP = 'A')
           AND A.RESULT_DATE      = V_CUTOFF_DAY
           AND A.RESULT_TYPE     IN ('I', 'C')   /* ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
           /*************************
           대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 필요
           *************************/
           /* AND CONCAT(A.TO_SCM_SITE_ID, A.ITEM_ID)
                IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID )
                    FROM   SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                    WHERE  PLAN_ID = @V_PLAN_ID
                    ) */
           /*************************
           대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 확인 필요
           *************************/
           AND (A.ITEM_ID IN (SELECT DISTINCT PARENT_ITEM_ID
                                FROM SCP_OPT_ENG_BOM_ELEC_SN
                               WHERE PLAN_ID = V_PLAN_ID
                                 AND SCP_YN  = 'Y'
                               UNION
                              SELECT DISTINCT CHILD_ITEM_ID
                                FROM SCP_OPT_ENG_BOM_ELEC_SN
                               WHERE PLAN_ID = V_PLAN_ID
                                 AND SCP_YN  = 'Y')
               );

        /* Oracle : ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN PROJECT_CODE VARCHAR(100) -> GTT 정의 폭에 선반영(불필요) */

        /* 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함 */
        INSERT
          INTO GT_OPTENG_EEIS_INT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SCM_SITE_ID
             , INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
             , FLAG )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , C.SCM_SITE_ID AS TO_SCM_SITE_ID
             , 'DAP'         AS INCOTERMS   /* VMI 임 */
             /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD') AS ETA_DATE   /* PLAN 시작일자로 처리 */
             , NVL(A.SCM_QTY, 0) AS DELIVERY_QTY
             , '-'               AS PROJECT_CODE
             , 'SALES'           AS FLAG
          FROM SCM_DNM_STOCK          A
             , GT_OPTENG_EE_DIV       B
             , SCM_MST_VMI_INT_SLOC   C
         WHERE 1 = 1
           AND A.DIVISION_ID = B.DIVISION_ID
           AND A.DIVISION_ID = C.DIVISION_ID
           AND A.PLANT_ID    = C.PLANT_ID
           AND A.STORAGE_ID  = C.STORAGE_ID
           AND C.VALID_YN    = 'Y'
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           /* 전극 Item */
           AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) = 'E'
           AND (A.DIVISION_ID  = '40' AND A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')
             OR A.DIVISION_ID != '40')
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           AND C.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                               WHERE PLAN_ID = V_PLAN_ID);

        /* UPDATE PROJECT */
        /* INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준 */
        DELETE
          FROM GT_OPTENG_EEIS_DM;

        INSERT
          INTO GT_OPTENG_EEIS_DM
             ( SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE )
        SELECT SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE
          FROM (
                SELECT SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , PROJECT_CODE
                     , ROW_NUMBER() OVER (PARTITION BY SITE_ID, ITEM_ID, INCOTERMS, PROJECT_CODE ORDER BY MIN_DUE) AS ROW_NUM
                  FROM (
                        SELECT ATTRIBUTE1    AS SITE_ID
                             , ATTRIBUTE2    AS ITEM_ID
                             , ATTRIBUTE4    AS INCOTERMS
                             , ATTRIBUTE5    AS PROJECT_CODE
                             , MIN(DUE_DATE) AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID       = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL   /* PROJECT_CODE */
                           AND ATTRIBUTE4 IS NOT NULL   /* INCOTERMS */
                         GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE4, ATTRIBUTE5
                       ) A
               ) B
         WHERE ROW_NUM = 1
        UNION ALL
        SELECT SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE
          FROM (
                SELECT SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , PROJECT_CODE
                     , ROW_NUMBER() OVER (PARTITION BY SITE_ID, ITEM_ID, PROJECT_CODE ORDER BY MIN_DUE) AS ROW_NUM
                  FROM (
                        SELECT ATTRIBUTE1    AS SITE_ID
                             , ATTRIBUTE2    AS ITEM_ID
                             , NULL          AS INCOTERMS
                             , ATTRIBUTE5    AS PROJECT_CODE
                             , MIN(DUE_DATE) AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID       = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL
                           AND ATTRIBUTE4 IS NULL
                         GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
                       ) C
               ) D
         WHERE ROW_NUM = 1;

        /* #SCP_INVENTORY_I 프로젝트 UPDATE  (UPDATE..FROM INNER JOIN -> MERGE, 파생 MAX 결정화) */
        MERGE
         INTO GT_OPTENG_EEIS_INV A
        USING (
               SELECT DIVISION_ID
                    , SCM_SITE_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , MAX(PROJECT_CODE) AS PROJECT_CODE
                 FROM (
                       SELECT C.DIVISION_ID
                            , C.SCM_SITE_ID
                            , C.INCOTERMS
                            , C.STOCK_TYPE
                            , C.ITEM_ID
                            , C.AVAILABLE_DATE
                            , C.QTY
                            , C.WIPHOLD_YN
                            , C.SITE_TYPE
                            , C.LOCATION_CODE
                            , D.PROJECT_CODE
                         FROM (
                               SELECT E.DIVISION_ID
                                    , E.SCM_SITE_ID
                                    , E.INCOTERMS
                                    , E.STOCK_TYPE
                                    , E.ITEM_ID
                                    , CASE WHEN F.SEGMENT3 IS NULL THEN E.ITEM_ID ELSE F.SEGMENT4 END AS MDF_ITEM_ID
                                    , E.AVAILABLE_DATE
                                    , E.QTY
                                    , E.WIPHOLD_YN
                                    , E.SITE_TYPE
                                    , E.LOCATION_CODE
                                 FROM GT_OPTENG_EEIS_INV         E
                                    , SCP_OPMZ_LOOKUP_MASTER_DETAIL F
                                WHERE E.ITEM_ID        = F.SEGMENT3(+)
                                  AND F.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                  AND F.SEGMENT2(+)    = V_DIVISION_ID
                                  AND F.VALID_YN(+)    = 'Y'
                                  AND E.FLAG           = 'SALES'
                                  AND E.PROJECT_CODE   = '-'
                                  AND E.QTY            > 0
                              ) C
                            , GT_OPTENG_EEIS_DM D
                        WHERE C.SCM_SITE_ID = D.SITE_ID
                          AND C.MDF_ITEM_ID = D.ITEM_ID
                          AND (   (C.INCOTERMS IS NULL AND D.INCOTERMS IS NULL)
                               OR (C.INCOTERMS = D.INCOTERMS)
                               OR (C.INCOTERMS IS NOT NULL AND D.INCOTERMS IS NULL)
                              )
                      )
                GROUP BY DIVISION_ID, SCM_SITE_ID, INCOTERMS, STOCK_TYPE, ITEM_ID, AVAILABLE_DATE, QTY, WIPHOLD_YN, SITE_TYPE, LOCATION_CODE
              ) B
           ON (    A.DIVISION_ID    = B.DIVISION_ID
               AND A.SCM_SITE_ID    = B.SCM_SITE_ID
               AND A.INCOTERMS      = B.INCOTERMS
               AND A.STOCK_TYPE     = B.STOCK_TYPE
               AND A.ITEM_ID        = B.ITEM_ID
               AND A.AVAILABLE_DATE = B.AVAILABLE_DATE
               AND A.QTY            = B.QTY
               AND A.WIPHOLD_YN     = B.WIPHOLD_YN
               AND A.SITE_TYPE      = B.SITE_TYPE
               AND A.LOCATION_CODE  = B.LOCATION_CODE )
         WHEN MATCHED THEN UPDATE
          SET A.PROJECT_CODE = B.PROJECT_CODE;

        /* #SCP_INTRANSIT_I 프로젝트 UPDATE  (UPDATE..FROM INNER JOIN -> MERGE, 파생 MAX 결정화) */
        MERGE
         INTO GT_OPTENG_EEIS_INT A
        USING (
               SELECT DIVISION_ID
                    , ITEM_ID
                    , TO_SCM_SITE_ID
                    , INCOTERMS
                    , ETA_DATE
                    , DELIVERY_QTY
                    , FLAG
                    , MAX(PROJECT_CODE) AS PROJECT_CODE
                 FROM (
                       SELECT C.DIVISION_ID
                            , C.ITEM_ID
                            , C.TO_SCM_SITE_ID
                            , C.INCOTERMS
                            , C.ETA_DATE
                            , C.DELIVERY_QTY
                            , C.FLAG
                            , D.PROJECT_CODE
                         FROM (
                               SELECT E.DIVISION_ID
                                    , E.ITEM_ID
                                    , CASE WHEN F.SEGMENT3 IS NULL THEN E.ITEM_ID ELSE F.SEGMENT4 END AS MDF_ITEM_ID
                                    , E.TO_SCM_SITE_ID
                                    , E.INCOTERMS
                                    , E.ETA_DATE
                                    , E.DELIVERY_QTY
                                    , E.PROJECT_CODE
                                    , E.FLAG
                                 FROM GT_OPTENG_EEIS_INT         E   /* WHERE PROJECT_CODE = '-' AND FLAG ='SALES' */
                                    , SCP_OPMZ_LOOKUP_MASTER_DETAIL F
                                WHERE E.ITEM_ID        = F.SEGMENT3(+)
                                  AND F.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                  AND F.SEGMENT2(+)    = V_DIVISION_ID
                                  AND F.VALID_YN(+)    = 'Y'
                                  AND E.FLAG           = 'SALES'
                                  AND E.PROJECT_CODE   = '-'
                                  AND E.DELIVERY_QTY   > 0
                              ) C
                            , GT_OPTENG_EEIS_DM D
                        WHERE C.TO_SCM_SITE_ID = D.SITE_ID
                          AND C.MDF_ITEM_ID    = D.ITEM_ID
                          AND (   (C.INCOTERMS IS NULL AND D.INCOTERMS IS NULL)
                               OR (C.INCOTERMS = D.INCOTERMS)
                               OR (C.INCOTERMS IS NOT NULL AND D.INCOTERMS IS NULL)
                              )
                      )
                GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, INCOTERMS, ETA_DATE, DELIVERY_QTY, FLAG
              ) B
           ON (    A.DIVISION_ID    = B.DIVISION_ID
               AND A.ITEM_ID        = B.ITEM_ID
               AND A.TO_SCM_SITE_ID = B.TO_SCM_SITE_ID
               AND A.INCOTERMS      = B.INCOTERMS
               AND A.ETA_DATE       = B.ETA_DATE
               AND A.DELIVERY_QTY   = B.DELIVERY_QTY
               AND A.FLAG           = B.FLAG )
         WHEN MATCHED THEN UPDATE
          SET A.PROJECT_CODE = B.PROJECT_CODE;

        /* 2025.10.01 Philsu Park: Workbench 재고 반영. */
        DELETE
          FROM GT_OPTENG_EEIS_ADJ;

        INSERT
          INTO GT_OPTENG_EEIS_ADJ
             ( DIVISION_ID
             , ITEM_ID
             , SCM_SITE_ID
             , INCOTERMS
             , INV_DATE
             , QTY
             , PROJECT_CODE
             , STOCK_TYPE
             , LOCATION_CODE
             , STAGE )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID
             , A.INCOTERMS
             , A.INV_DATE
             , A.CHG_QTY AS QTY
             , A.PROJECT_CODE
             , A.STOCK_TYPE
             , A.LOCATION_CODE
             , CASE WHEN A.LOCATION_CODE NOT IN ('COATING', 'SLITTING') THEN 'TARGETBIZ'   /* Cell Plant 재고 Sales SIte 로 취급 */
                    WHEN A.LOCATION_CODE = 'SLITTING' THEN 'ELEC_POST'
                    WHEN A.LOCATION_CODE = 'COATING'  THEN 'COATING'
                    ELSE '-'
               END AS STAGE
          FROM SCP_OPMZ_INV_ADJ  A
             , GT_OPTENG_EE_DIV  B
             /* INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                    ON  ML.PLAN_ID = @V_PLAN_ID
                    AND ADJ.SCM_SITE_ID = ML.SCM_SITE_ID
                    AND ADJ.ITEM_ID     = ML.ITEM_ID */
         WHERE 1 = 1
           AND A.DIVISION_ID     = B.DIVISION_ID
           AND A.CUTOFF_YYYYMMDD = V_PLAN_START_YYYYMMDD   /* PLAN 주차 기준. */
           AND A.LOCATION_CODE  != '-'
           AND A.INV_DATE       >= V_PLAN_START_YYYYMMDD
           AND A.INV_DATE        < V_PLAN_END_YYYYMMDD;

        /* INCOMING STOCK INSERT
           2025.06.18 Philsu Park: DEMAND_EXCEPTION 룩업 등록된 대상 중 STOCK_EXCEPTION = 'Y'인 ITEM의 전극 환산 ITEM을 제외한다.(Site 조건 없이 ITEM 기준으로만 체크) */
        INSERT
          INTO SCP_OPT_ENG_INCOMING_STOCK_SN
             ( PLAN_ID
             , STOCK_ID
             , BUFFER_ID
             , EFFECTIVE_DATE
             , TYPE
             , QUANTITY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5 )
        SELECT PLAN_ID
             , STOCK_ID
             , BUFFER_ID
             , EFECTIVE_DATE
             , TYPE
             , SUM(QUANTITY) AS QUANTITY
             , SITE_ID
             , ITEM_ID
             , STAGE
             , INCOTERMS
             , PROJECT_CODE
          FROM (
                SELECT V_PLAN_ID AS PLAN_ID
                     , TYPE||'::'||SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END||'::'||EFECTIVE_DATE AS STOCK_ID
                     , SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END AS BUFFER_ID
                     , EFECTIVE_DATE AS EFECTIVE_DATE
                     , TYPE          AS TYPE
                     , QTY           AS QUANTITY
                     , SITE_ID       AS SITE_ID
                     , ITEM_ID       AS ITEM_ID
                     , STAGE         AS STAGE
                     , INCOTERMS     AS INCOTERMS
                     , PROJECT_CODE  AS PROJECT_CODE
                  FROM (
                        SELECT A.SCM_SITE_ID AS SITE_ID
                             /* , A.ITEM_ID AS ITEM_ID -- CELL 재고를 전극으로 전환 */
                             , CASE WHEN B.CHILD_ITEM_ID IS NULL THEN A.ITEM_ID
                                    ELSE B.CHILD_ITEM_ID
                               END ITEM_ID
                             /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성 */
                             , CASE
                                    WHEN A.FLAG = 'SALES'                               THEN 'ELECBIZ'
                                    WHEN A.FLAG = 'INT'                                 THEN 'TARGETBIZ'   /* 전극은 Cell PKG 를 Demand로 처리하므로 Cell 도착은 Sales SIte 로 취급 */
                                    WHEN A.LOCATION_CODE NOT IN ('COATING', 'SLITTING') THEN 'TARGETBIZ'   /* Cell Plant 재고 Sales SIte 로 취급 */
                                    WHEN A.LOCATION_CODE = 'SLITTING'                   THEN 'ELEC_POST'
                                    WHEN A.LOCATION_CODE = 'COATING'                    THEN 'COATING'
                                    ELSE '-'
                               END STAGE
                             , TO_CHAR(NVL(A.EFFSTARTDATE, TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD') AS EFECTIVE_DATE
                             , A.DESCR AS TYPE
                             /* , A.QTY AS QTY -- CELL 재고를 전극으로 전환 */
                             , CASE WHEN B.CHILD_ITEM_ID IS NULL THEN A.QTY
                                    ELSE A.QTY * NVL(B.USAGE, 1)
                               END QTY
                             , INCOTERMS
                             , PROJECT_CODE
                          FROM (
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     , TRUNC(AVAILABLE_DATE) AS EFFSTARTDATE
                                     , SUM(QTY) AS QTY
                                     , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
                                            ELSE 'WH_HOLD'
                                       END AS DESCR
                                     , LOCATION_CODE
                                     , PROJECT_CODE
                                     , FLAG
                                  FROM GT_OPTENG_EEIS_INV T
                                 WHERE 1 = 1
                                 GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, TRUNC(AVAILABLE_DATE), NVL(T.WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG
                                HAVING SUM(T.QTY) > 0
                                UNION ALL
                                /* INTRANSIT SHIPMENT 재고 */
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , TO_SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     , TO_DATE(ETA_DATE, 'YYYYMMDD') AS EFFSTARTDATE
                                     , SUM(DELIVERY_QTY) AS QTY
                                     , 'INT' AS DESCR
                                     , '-'   AS LOCATION_CODE
                                     , PROJECT_CODE
                                     , FLAG
                                  FROM GT_OPTENG_EEIS_INT T
                                 WHERE 1 = 1
                                   AND T.DELIVERY_QTY > 0
                                   AND (T.ETA_DATE IS NOT NULL)   -- [E20261113-EMPTYCMP-B] 결과에 영향 없는 빈 문자열 비교 항 삭제
                                 GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, ETA_DATE, INCOTERMS, PROJECT_CODE, FLAG
                               ) A
                               /* CELL 재고를 전극으로 전환하기 위한 정보 */
                             , (
                                SELECT PARENT_ITEM_ID
                                     , CHILD_ITEM_ID
                                     , MAX(USAGE) AS USAGE
                                  FROM SCP_OPT_ENG_BOM_ELEC_SN LU
                                 WHERE PLAN_ID = V_PLAN_ID
                                   AND SCP_YN  = 'Y'
                                 GROUP BY PARENT_ITEM_ID, CHILD_ITEM_ID
                               ) B
                             , SCM_MST_SITE TS
                         WHERE 1 = 1
                           AND A.ITEM_ID      = B.PARENT_ITEM_ID(+)
                           AND A.DIVISION_ID  = TS.DIVISION_ID(+)
                           AND A.SCM_SITE_ID  = TS.SCM_SITE_ID(+)
                           AND TS.VALID_YN(+) = 'Y'
                           AND NOT EXISTS (SELECT 1
                                             FROM GT_OPTENG_EEIS_ADJ ADJ
                                            WHERE ADJ.DIVISION_ID   = A.DIVISION_ID
                                              AND ADJ.SCM_SITE_ID   = A.SCM_SITE_ID
                                              AND ADJ.ITEM_ID       = NVL(B.CHILD_ITEM_ID, A.ITEM_ID)
                                              AND ADJ.LOCATION_CODE = A.LOCATION_CODE
                                              AND ADJ.INV_DATE      = TO_CHAR(NVL(A.EFFSTARTDATE, TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD')
                                              AND ADJ.INCOTERMS     = A.INCOTERMS
                                              AND ADJ.PROJECT_CODE  = A.PROJECT_CODE
                                              AND ADJ.STOCK_TYPE    = A.DESCR)
                           /*************************
                           대상 프로젝트 ITEM 필터링 : N/L/F 모델 추가 적용 확인 필요
                           *************************/
                           AND ((A.FLAG = 'SALES' AND A.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                      FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                     WHERE PLAN_ID = V_PLAN_ID)
                                )
                             OR (TS.OPERATION_GROUP = 'E' AND A.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                              WHERE PLAN_ID = V_PLAN_ID)
                                )
                             OR (TS.OPERATION_GROUP = 'A' AND A.ITEM_ID IN (SELECT DISTINCT PARENT_ITEM_ID
                                                                              FROM SCP_OPT_ENG_BOM_ELEC_SN
                                                                             WHERE PLAN_ID = V_PLAN_ID
                                                                               AND SCP_YN  = 'Y'
                                                                             UNION
                                                                            SELECT DISTINCT CHILD_ITEM_ID
                                                                              FROM SCP_OPT_ENG_BOM_ELEC_SN
                                                                             WHERE PLAN_ID = V_PLAN_ID
                                                                               AND SCP_YN  = 'Y')
                                )
                               )
                       ) A
                 WHERE 1 = 1
                   /*---------------------------------------------------------------------------------------
                     2025.06.18 Philsu Park
                     Demand Exception 대상 중 STOCK_EXCEPTION Flag = 'Y' 인 경우 재고 반영 제외.
                     ---------------------------------------------------------------------------------------*/
                   AND NOT EXISTS (SELECT 1
                                     FROM (
                                           /* SELECT  DISTINCT
                                                      ISNULL(B.CHILD_ITEM_ID, LV.SEGMENT4)   AS ELEC_ITEM_ID
                                              FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                              LEFT OUTER JOIN SCP_MST_BOM_ELEC B WITH (NOLOCK)
                                                  ON  LV.SEGMENT4 = B.PARENT_ITEM_ID  ASSY Item
                                                  AND B.SCP_YN    = 'Y'
                                              WHERE   LV.LOOKUP_TYPE  = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                              AND     LV.VALID_YN     = 'Y'
                                              AND     LV.SEGMENT2     = @V_DIVISION_ID
                                              AND     LV.SEGMENT5     = @V_GROUP_ID
                                              AND     LV.ATTRIBUTE1   = 'ASSY'  CELL PLAN 제외
                                              AND     LV.ATTRIBUTE4   = 'Y'     STOCK_EXCEPTION
                                              전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM
                                              AND     B.CHILD_ITEM_ID NOT IN (
                                                                              SELECT  DISTINCT ATTRIBUTE2
                                                                              FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                                                                              WHERE   DM.PLAN_ID = @V_PLAN_ID
                                                                             ) */
                                           /* 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                                           SELECT DISTINCT NVL(B.CHILD_ITEM_ID, D.ITEM_ID) AS ELEC_ITEM_ID
                                             FROM SCP_OPMZ_DEMAND_EXCEPTION D
                                                , SCP_MST_BOM_ELEC          B
                                                , SCP_OPMZ_PLAN_GR_M        PG
                                                , (
                                                   SELECT DISTINCT ITEM_ID
                                                     FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                    WHERE PLAN_ID = V_PLAN_ID
                                                  ) MDL
                                            WHERE 1 = 1
                                              AND D.ITEM_ID          = B.PARENT_ITEM_ID(+)   /* ASSY Item */
                                              AND B.SCP_YN(+)        = 'Y'
                                              AND D.OPMZ_PLAN_GR_ID  = PG.OPMZ_PLAN_GR_ID(+)
                                              AND PG.VALID_YN(+)     = 'Y'
                                              AND D.ITEM_ID          = MDL.ITEM_ID
                                              AND D.VALID_YN         = 'Y'
                                              AND D.DIVISION_ID      = V_DIVISION_ID
                                              AND PG.OPMZ_PLAN_GR_NAME = V_PLAN_GROUP_ORG
                                              /* AND     D.STAGE         = 'TARGETBIZ'   CELL PLAN 제외 */
                                              AND D.ATTRIBUTE1       = 'Y'   /* STOCK_EXCEPTION */
                                              /* 전극의 경우 공용 전극 ITEM이 있으므로 DEMAND가 있는 경우에는 제외하지 않음/20251013/THKIM */
                                              AND B.CHILD_ITEM_ID NOT IN (SELECT DISTINCT ATTRIBUTE2
                                                                            FROM SCP_OPT_ENG_DEMAND_SN DM
                                                                           WHERE DM.PLAN_ID = V_PLAN_ID)
                                          ) INV_EXCEPTION
                                    WHERE 1 = 1
                                      AND INV_EXCEPTION.ELEC_ITEM_ID = A.ITEM_ID)
                   AND EFECTIVE_DATE < V_PLAN_END_YYYYMMDD
                /* 2025.10.01 Philsu Park: Workbench 재고 추가 */
                UNION ALL
                SELECT V_PLAN_ID AS PLAN_ID
                     , STOCK_TYPE||'::'||SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END||'::'||INV_DATE AS STOCK_ID
                     , SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END AS BUFFER_ID
                     , INV_DATE    AS EFFECTIVE_DATE
                     , STOCK_TYPE  AS TYPE
                     , QTY         AS QUANTITY
                     , SCM_SITE_ID AS SITE_ID
                     , ITEM_ID     AS ITEM_ID
                     , STAGE       AS STAGE
                     , INCOTERMS   AS INCOTERMS
                     , PROJECT_CODE AS PROJECT_CODE
                  FROM GT_OPTENG_EEIS_ADJ INV
                 WHERE QTY > 0
                /*  자재/포장재의 입고 예정정보
                    2025.05.19 Philsu Park: GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용. */
                UNION ALL
                SELECT V_PLAN_ID AS PLAN_ID
                     , TYPE||'::'||SCM_SITE_ID||'::'||MAT_ID||'::'||STAGE||'::'||ARR_DATE AS STOCK_ID
                     , SCM_SITE_ID||'::'||MAT_ID||'::'||STAGE AS BUFFER_ID
                     , ARR_DATE    AS EFFECTIVE_DATE
                     , TYPE        AS TYPE
                     , QTY         AS QUANTITY
                     , SCM_SITE_ID AS ATTRIBUTE1
                     , MAT_ID      AS ATTRIBUTE2
                     , STAGE       AS ATTRIBUTE3
                     , '-'         AS INCOTERMS
                     , '-'         AS PROJECT_CODE
                  FROM (
                        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
                        SELECT LU.PLANT_SITE_ID  AS SCM_SITE_ID
                             , LU.ITEM_ID_CHILD  AS MAT_ID
                             , 'MATERIAL_CONST'  AS STAGE
                             , LU.TO_YYYYMMDD    AS ARR_DATE
                             , TO_NUMBER(LU.TO_EXPC_QTY) AS QTY
                             , 'MC'              AS TYPE
                          FROM SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION LU
                             , SCP_OPMZ_PLAN_GR_M                     PG
                             , GT_OPTENG_EEIS_MAT                     MAT
                         WHERE 1 = 1
                           AND LU.OPMZ_PLAN_GR_ID   = PG.OPMZ_PLAN_GR_ID
                           AND LU.ITEM_ID_CHILD     = MAT.MAT_ID
                           AND LU.DIVISION_ID       = V_DIVISION_ID
                           AND PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                           AND LU.VALID_YN          = 'Y'
                           AND PG.VALID_YN          = 'Y'
                           AND LU.TO_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE
                        /* END 2025.11.19 jongykim2: Schelduled Reciept Information */
                        /* BLOCKED END 2025.11.19 jongykim2
                           SELECT  LU.SEGMENT4      AS SCM_SITE_ID
                                  ,LU.SEGMENT5      AS MAT_ID
                                  ,'MATERIAL_CONST' AS STAGE
                                  ,ATTRIBUTE1       AS ARR_DATE
                                  ,ATTRIBUTE2       AS QTY
                                  ,'MC'             AS TYPE
                           FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                           INNER JOIN @MAT_CONST_TEMP MAT
                               ON  LU.SEGMENT5         = MAT.MAT_ID
                           WHERE   LU.LOOKUP_TYPE      = 'SCP_OPT_ENG_CONST_INCOMMING_MATERIAL'
                           AND     LU.VALID_YN         = 'Y'
                           AND     LU.SEGMENT2         = @V_DIVISION_ID
                           AND     LU.SEGMENT3         = @V_GROUP_ID
                           AND     LU.ATTRIBUTE1 BETWEEN @V_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE */
                       ) MC
                 WHERE ARR_DATE < V_PLAN_END_YYYYMMDD
               ) AA
         GROUP BY PLAN_ID, STOCK_ID, BUFFER_ID, EFECTIVE_DATE, TYPE, SITE_ID, ITEM_ID, STAGE, INCOTERMS, PROJECT_CODE;

        /* NERP로 넘어가지 않는 대상에 대해서 재고 위치 조정
           나중에 LOOK UP으로 변경해야 할수도 있음 */
        /* 1-1 G452-E에 이미 존재하는데, G451-A에도 있는 데이터 UPDATE */
        MERGE
         INTO SCP_OPT_ENG_INCOMING_STOCK_SN A
        USING (
               SELECT ITEM_ID        AS ITEM_ID
                    , STAGE          AS STAGE
                    , EFFECTIVE_DATE AS EFFECTIVE_DATE
                    , TYPE           AS TYPE
                    , SUM(QTY)       AS SUM_QTY
                 FROM (
                       SELECT ATTRIBUTE2 AS ITEM_ID
                            , CASE WHEN ATTRIBUTE1 = 'G451-A' THEN 'ELEC_POST' ELSE ATTRIBUTE3 END AS STAGE
                            , EFFECTIVE_DATE AS EFFECTIVE_DATE
                            , TYPE           AS TYPE
                            , QUANTITY       AS QTY
                         FROM SCP_OPT_ENG_INCOMING_STOCK_SN
                        WHERE PLAN_ID     = V_PLAN_ID
                          AND ATTRIBUTE1 IN ('G452-E', 'G451-A')
                          AND TYPE       IN ('WH', 'WH_HOLD')
                          AND ATTRIBUTE2  = 'APCAN2049A'
                      ) C
                GROUP BY ITEM_ID, STAGE, EFFECTIVE_DATE, TYPE
               HAVING COUNT(ITEM_ID) > 1
              ) B
           ON (    A.PLAN_ID        = V_PLAN_ID
               AND A.ATTRIBUTE1     = 'G452-E'
               AND A.ATTRIBUTE2     = B.ITEM_ID
               AND A.EFFECTIVE_DATE = B.EFFECTIVE_DATE
               AND A.ATTRIBUTE3     = B.STAGE
               AND A.TYPE           = B.TYPE )
         WHEN MATCHED THEN UPDATE
          SET A.QUANTITY   = B.SUM_QTY
            , A.ATTRIBUTE6 = 'AFTER_UPDATE';

        /* 1-1 G452-E에 이미 존재하는데, G451-A에도 있는 데이터는 G451-A는 0으로 UPDATE */
        DELETE
          FROM SCP_OPT_ENG_INCOMING_STOCK_SN A
         WHERE A.PLAN_ID    = V_PLAN_ID
           AND A.ATTRIBUTE1 = 'G451-A'
           AND EXISTS (SELECT 1
                         FROM (
                               SELECT ITEM_ID        AS ITEM_ID
                                    , STAGE          AS STAGE
                                    , EFFECTIVE_DATE AS EFFECTIVE_DATE
                                    , TYPE           AS TYPE
                                    , SUM(QTY)       AS SUM_QTY
                                 FROM (
                                       SELECT ATTRIBUTE2 AS ITEM_ID
                                            , CASE WHEN ATTRIBUTE1 = 'G451-A' THEN 'ELEC_POST' ELSE ATTRIBUTE3 END AS STAGE
                                            , EFFECTIVE_DATE AS EFFECTIVE_DATE
                                            , TYPE           AS TYPE
                                            , QUANTITY       AS QTY
                                         FROM SCP_OPT_ENG_INCOMING_STOCK_SN
                                        WHERE PLAN_ID     = V_PLAN_ID
                                          AND ATTRIBUTE1 IN ('G452-E', 'G451-A')
                                          AND TYPE       IN ('WH', 'WH_HOLD')
                                          AND ATTRIBUTE2  = 'APCAN2049A'
                                      ) C
                                GROUP BY ITEM_ID, STAGE, EFFECTIVE_DATE, TYPE
                               HAVING COUNT(ITEM_ID) > 1
                              ) B
                        WHERE B.ITEM_ID        = A.ATTRIBUTE2
                          AND B.EFFECTIVE_DATE = A.EFFECTIVE_DATE
                          /* AND     INS.STAGE          = T.ATTRIBUTE3 -- STAGE는 강제로 ELEC_POST로 변환했기 때문에 조건에서 제외 */
                          AND B.TYPE           = A.TYPE);

        /* 2 G452-E에 없고, G451-A에만 있는 데이터는 G452-E로 UPDATE */
        UPDATE
               SCP_OPT_ENG_INCOMING_STOCK_SN
           SET STOCK_ID   = TYPE||'::'||'G452-E'||'::'||ATTRIBUTE2||'::'||'ELEC_POST'||'::'||EFFECTIVE_DATE
             , BUFFER_ID  = 'G452-E'||'::'||ATTRIBUTE2||'::'||'ELEC_POST'
             , ATTRIBUTE1 = 'G452-E'
             , ATTRIBUTE3 = 'ELEC_POST'
             , ATTRIBUTE4 = '-'
             , ATTRIBUTE5 = ''
             , ATTRIBUTE6 = 'AFTER_UPDATE'
         WHERE PLAN_ID    = V_PLAN_ID
           AND TYPE      IN ('WH', 'WH_HOLD')
           AND ATTRIBUTE1 = 'G451-A'
           AND ATTRIBUTE2 = 'APCAN2049A';
        /* AND     QUANTITY  != 0 */

        /* 3 WA00-E, APCAN2049A는 TARGETBIZ로 변경 */
        UPDATE
               SCP_OPT_ENG_INCOMING_STOCK_SN
           SET STOCK_ID   = TYPE||'::'||ATTRIBUTE1||'::'||ATTRIBUTE2||'::'||'TARGETBIZ@DAP@-'||'::'||EFFECTIVE_DATE
             , BUFFER_ID  = ATTRIBUTE1||'::'||ATTRIBUTE2||'::'||'TARGETBIZ@DAP@-'
             , ATTRIBUTE1 = ATTRIBUTE1
             , ATTRIBUTE3 = 'TARGETBIZ'
             , ATTRIBUTE4 = 'DAP'
             , ATTRIBUTE5 = '-'
             , ATTRIBUTE6 = 'AFTER_UPDATE'
         WHERE PLAN_ID    = V_PLAN_ID
           AND TYPE      IN ('WH', 'WH_HOLD')
           AND ATTRIBUTE1 = 'WA00-E'
           AND ATTRIBUTE2 = 'APCAN2049A';

        /* 4 2025.09.01 Philsu Park
           APCAN2049A: WA에 위치한 재고 삭제처리(재고 감안한 수요(출하)계획 반영.) */
        DELETE
          FROM SCP_OPT_ENG_INCOMING_STOCK_SN
         WHERE PLAN_ID      = V_PLAN_ID
           AND ATTRIBUTE1 LIKE 'WA00%'
           AND ATTRIBUTE2    = 'APCAN2049A';
        /* AND     TYPE       IN('WH','WH_HOLD') */

        /* 2025-11-24 jongykim2: Hold 재고의 Release를 룩업 기반으로 반영. (PSD + n)
           hold 재고의 유효일자를 PSD로 변경키 위해 기존 Lookup(SCP_OPT_ENG_GM_RELEASE_HOLD)을 사용하였음! */
        MERGE
         INTO SCP_OPT_ENG_INCOMING_STOCK_SN A
        USING (
               SELECT SEGMENT3 AS SITE_ID
                    , SEGMENT4 AS STAGE
                    , MAX(TO_NUMBER(ATTRIBUTE1)) AS ADD_DAYS
                 FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_GM_RELEASE_HOLD'
                  AND VALID_YN    = 'Y'
                  AND SEGMENT1    = V_DIVISION_ID
                  /* AND     SEGMENT2     = @V_GROUP_ID */
                  AND SEGMENT2    = V_PLAN_GROUP_ORG
                GROUP BY SEGMENT3, SEGMENT4
              ) B
           ON (    B.SITE_ID = A.ATTRIBUTE1
               AND B.STAGE   = A.ATTRIBUTE3
               AND A.PLAN_ID = V_PLAN_ID
               AND INSTR(A.TYPE, 'HOLD') > 0 )
         WHEN MATCHED THEN UPDATE
          SET A.EFFECTIVE_DATE = TO_CHAR(V_D_PLAN_NAME + B.ADD_DAYS, 'YYYYMMDD')
            , A.UPDATE_ID      = 'HOLD_UPDATE'
            , A.UPDATE_TIME    = SYSDATE;

        /* 2026.04.08 Minyong Lee : 법인간 이동 재고 BUFFER_ID, STOCK_ID 생성 규칙 수정, INCOTERMS / PROJECT_CODE 제거 */
        DELETE
          FROM GT_OPTENG_EEIS_CINT;

        INSERT
          INTO GT_OPTENG_EEIS_CINT
             ( PLAN_ID
             , STOCK_ID
             , BUFFER_ID
             , EFFECTIVE_DATE
             , TYPE
             , QUANTITY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE15 )
        SELECT A.PLAN_ID
             , TYPE||'::'||A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||A.ATTRIBUTE3||'::'||A.EFFECTIVE_DATE AS STOCK_ID
             , A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||A.ATTRIBUTE3 AS BUFFER_ID
             , A.EFFECTIVE_DATE
             , A.TYPE
             , SUM(A.QUANTITY) AS QUANTITY
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , '-' AS ATTRIBUTE4
             , ''  AS ATTRIBUTE5
             , A.ATTRIBUTE15
          FROM (
                SELECT PLAN_ID
                     , EFFECTIVE_DATE
                     , TYPE
                     , QUANTITY
                     , ATTRIBUTE1
                     , ATTRIBUTE2
                     , ATTRIBUTE3
                     , ATTRIBUTE15
                  FROM SCP_OPT_ENG_INCOMING_STOCK_SN
                 WHERE PLAN_ID     = V_PLAN_ID
                   AND STOCK_ID   LIKE 'INT%'
                   AND ATTRIBUTE3 NOT LIKE '%BIZ'
               ) A
         GROUP BY PLAN_ID, EFFECTIVE_DATE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE15;

        DELETE
          FROM SCP_OPT_ENG_INCOMING_STOCK_SN
         WHERE PLAN_ID     = V_PLAN_ID
           AND STOCK_ID   LIKE 'INT%'
           AND ATTRIBUTE3 NOT LIKE '%BIZ';

        INSERT
          INTO SCP_OPT_ENG_INCOMING_STOCK_SN
             ( PLAN_ID
             , STOCK_ID
             , BUFFER_ID
             , EFFECTIVE_DATE
             , TYPE
             , QUANTITY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE15 )
        SELECT PLAN_ID
             , STOCK_ID
             , BUFFER_ID
             , EFFECTIVE_DATE
             , TYPE
             , QUANTITY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE15
          FROM GT_OPTENG_EEIS_CINT;

        /* Data Insert End */
        DELETE
          FROM GT_OPTENG_EEIS_INV;

        DELETE
          FROM GT_OPTENG_EEIS_INT;

        DELETE
          FROM GT_OPTENG_EE_DIV;

        DELETE
          FROM GT_OPTENG_EEIS_CINT;

    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SQLERRM;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'ERROR', NULL, V_MESSAGE_TEXT, NULL, V_PLAN_ID);
            V_DETAIL_DATE := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, V_DETAIL_DATE, NULL, V_MESSAGE_TEXT, 'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* 종료 LOG */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
    END IF;

END PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK;
/
