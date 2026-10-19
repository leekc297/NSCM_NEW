PACKAGE BODY PKG_S39V6
IS

    /************************************************************************************************/
    /* [공통] GTT 통계 수집 - CNS 전환가이드 7항                                                     */
    /*        GTT 는 통계가 없으면 옵티마이저가 1행으로 보고 NESTED LOOP 를 골라 조회가 폭주한다.    */
    /*        세션 레벨 통계이므로 다른 세션에 영향을 주지 않는다.                                   */
    /************************************************************************************************/
    PROCEDURE P_GATHER
    (
        P_TAB_NAME  IN VARCHAR2
    )
    IS
    BEGIN
        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME       => USER
                                    , TABNAME       => P_TAB_NAME
                                    , NO_INVALIDATE => FALSE);
    EXCEPTION
        WHEN OTHERS THEN
            NULL;   /* 통계 수집 실패가 조회를 막지 않도록 한다 */
    END P_GATHER;

    /************************************************************************************************/
    /* [공통] 기준 일자 정보 - 당주 월요일(plan_start_yyyymmdd) 과 plan horizon_end_date            */
    /************************************************************************************************/
    PROCEDURE P_SET_BASE_DATE
    (
        P_DIVISION_ID     IN  VARCHAR2,
        O_FROM_YYYYMMDD   OUT VARCHAR2,
        O_TO_YYYYMMDD     OUT VARCHAR2
    )
    IS
    BEGIN

        /* 당주 월요일 (plan_start_yyyymmdd) */
        SELECT MAX(B.YYYYMMDD)
          INTO O_FROM_YYYYMMDD
          FROM SCM_MST_BUCKET A
             , SCM_MST_BUCKET B
         WHERE B.YYYYWW = A.YYYYWW
           AND B.DAYOFWEEK = 'MON'
           AND A.YYYYMMDD = '20260824';

        /* plan horizon_end_date */
        SELECT MAX(HORIZON_END_DATE)
          INTO O_TO_YYYYMMDD
          FROM SCM_MST_PLAN
         WHERE DIVISION_ID = P_DIVISION_ID
           AND PLAN_NAME   = O_FROM_YYYYMMDD
           AND PLAN_CYCLE  = 'WEEKLY';

    END P_SET_BASE_DATE;

    /************************************************************************************************/
    /* [공통] SCP Plan 공정 정보 (2025.08.14 추가)                                                  */
    /************************************************************************************************/
    PROCEDURE P_LOAD_SCP_PLAN_OPERATION
    IS
    BEGIN

        DELETE FROM GT_0039_SCP_PLAN_OPERATION;

        INSERT INTO GT_0039_SCP_PLAN_OPERATION
        (
            OPERATION_ID
        )
        SELECT DISTINCT SEGMENT1  AS OPERATION_ID
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
           AND VALID_YN    = 'Y';
        P_GATHER('GT_0039_SCP_PLAN_OPERATION');

    END P_LOAD_SCP_PLAN_OPERATION;

    /************************************************************************************************/
    /* [공통] Plan Group 정보 (Plan Group Line -> Item Line Assign -> Line Model -> Basic Nick)      */
    /************************************************************************************************/
    PROCEDURE P_LOAD_PLAN_GROUP_INFO
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_FROM_YYYYMMDD   IN VARCHAR2,
        P_TO_YYYYMMDD     IN VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0039_PLAN_GROUP_LINE;
        DELETE FROM GT_0039_ITEM_LINE_ASSIGN;
        DELETE FROM GT_0039_PLAN_GR_LINE_MODEL;
        DELETE FROM GT_0039_PG_LINE_MDL_BSC_NICK;
        DELETE FROM GT_0039_PLAN_GROUP_INFO;

        /* Plan Group Line 정보 */
        INSERT INTO GT_0039_PLAN_GROUP_LINE
        (
            OPMZ_PLAN_GR_ID
          , OPMZ_PLAN_GR_NAME
          , DIVISION_ID
          , LINE_ID
          , FACTORY_ID
          , PLANT_ID
          , OPERATION_ID
          , ITEM_ID
        )
        SELECT B.OPMZ_PLAN_GR_ID
             , B.OPMZ_PLAN_GR_NAME
             , B.DIVISION_ID
             , A.LINE_ID
             , A.FACTORY_ID
             , A.PLANT_ID
             , A.OPERATION_ID
             , A.ITEM_ID
          FROM SCP_OPMZ_PLAN_GR_LINE_M A
             , SCP_OPMZ_PLAN_GR_M      B
         WHERE B.OPMZ_PLAN_GR_ID = A.OPMZ_PLAN_GR_ID
           AND B.VALID_YN = 'Y'
           /* PJ20257329 2025.09.12 변경전  INNER JOIN SCM_MST_DIVISION DM ON DM.DIVISION_ID = GM.DIVISION_ID AND DM.ATTRIBUTE3 = '81' */
           AND B.DIVISION_ID = P_DIVISION_ID
           AND A.VALID_YN = 'Y'
         ORDER BY A.LINE_ID;
        P_GATHER('GT_0039_PLAN_GROUP_LINE');

        /* ITEM Line Assign 정보 */
        INSERT INTO GT_0039_ITEM_LINE_ASSIGN
        (
            DIVISION_ID
          , PLANT_ID
          , FACTORY_ID
          , OPERATION_ID
          , LINE_ID
          , ITEM_ID
        )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.ITEM_ID
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN  A
             , GT_0039_SCP_PLAN_OPERATION   B   /* 2025.08.14 SCP Plan Operation 으로 참조 범위 제한 */
         WHERE B.OPERATION_ID = A.OPERATION_ID
           AND A.ACTIVE_FLAG = 'Y'
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.MONTH BETWEEN SUBSTR(P_FROM_YYYYMMDD, 1, 6) AND SUBSTR(P_TO_YYYYMMDD, 1, 6)   /* 2025.08.14 당월부터 plan horizon end date 까지 참조 */
           AND A.PRIORITY NOT IN ('0', '9');
        P_GATHER('GT_0039_ITEM_LINE_ASSIGN');

        /* Plan Group Line Model 정보 */
        INSERT INTO GT_0039_PLAN_GR_LINE_MODEL
        (
            OPMZ_PLAN_GR_ID
          , OPMZ_PLAN_GR_NAME
          , DIVISION_ID
          , LINE_ID
          , FACTORY_ID
          , PLANT_ID
          , OPERATION_ID
          , ITEM_ID
          , OPERATION_GROUP
        )
        SELECT A.OPMZ_PLAN_GR_ID
             , A.OPMZ_PLAN_GR_NAME
             , A.DIVISION_ID
             , A.LINE_ID
             , A.FACTORY_ID
             , A.PLANT_ID
             , A.OPERATION_ID
             , B.ITEM_ID
             , SUBSTR(A.OPERATION_ID, 1, 1)  AS OPERATION_GROUP
          FROM GT_0039_PLAN_GROUP_LINE  A
             , GT_0039_ITEM_LINE_ASSIGN B
         WHERE B.LINE_ID      = A.LINE_ID
           AND B.FACTORY_ID   = A.FACTORY_ID
           AND B.PLANT_ID     = A.PLANT_ID
           AND B.OPERATION_ID = A.OPERATION_ID
           AND B.DIVISION_ID  = A.DIVISION_ID
           AND B.ITEM_ID      = CASE WHEN A.ITEM_ID = '-'
                                     THEN B.ITEM_ID
                                     ELSE A.ITEM_ID
                                END;
        P_GATHER('GT_0039_PLAN_GR_LINE_MODEL');

        /* Plan Group Line Model / Cell model Basic Nick name 정보 */
        INSERT INTO GT_0039_PG_LINE_MDL_BSC_NICK
        (
            OPMZ_PLAN_GR_ID
          , OPMZ_PLAN_GR_NAME
          , DIVISION_ID
          , LINE_ID
          , FACTORY_ID
          , PLANT_ID
          , OPERATION_ID
          , ITEM_ID
          , OPERATION_GROUP
          , BASIC_NICK_NAME
        )
        SELECT A.OPMZ_PLAN_GR_ID
             , SUBSTR(A.OPMZ_PLAN_GR_NAME, 1, 100)  AS OPMZ_PLAN_GR_NAME
             , A.DIVISION_ID
             , A.LINE_ID
             , A.FACTORY_ID
             , A.PLANT_ID
             , A.OPERATION_ID
             , SUBSTR(A.ITEM_ID, 1, 100)            AS ITEM_ID
             , A.OPERATION_GROUP
             , SUBSTR(E.BASIC_NICK_NAME, 1, 500)    AS BASIC_NICK_NAME
          FROM GT_0039_PLAN_GR_LINE_MODEL A
             , SCP_MST_FINAL_ITEM         B    /* Final Pack */
             , SCP_MST_ITEM_BSI_IFO       C    /* Doe model */
             , SCP_MST_FINAL_ITEM         D
             , SCP_MST_ITEM_BSI_IFO       E    /* Cell Model 기준 Basic nick name 참조 */
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.ITEM_ID(+)     = A.ITEM_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.ITEM_ID(+)     = C.APPLIED_DOE
           AND E.ITEM_ID(+)     = CASE WHEN A.OPERATION_GROUP = 'P'
                                       THEN NVL(B.ATTRIBUTE1, D.ATTRIBUTE1)
                                       ELSE A.ITEM_ID
                                  END;
        P_GATHER('GT_0039_PG_LINE_MDL_BSC_NICK');

        /* Plan Group Line Model / Cell model Basic Nick name 정보 - Cell Product 추가 */
        INSERT INTO GT_0039_PG_LINE_MDL_BSC_NICK
        (
            OPMZ_PLAN_GR_ID
          , OPMZ_PLAN_GR_NAME
          , DIVISION_ID
          , LINE_ID
          , FACTORY_ID
          , PLANT_ID
          , OPERATION_ID
          , ITEM_ID
          , OPERATION_GROUP
          , BASIC_NICK_NAME
        )
        SELECT A.OPMZ_PLAN_GR_ID
             , A.OPMZ_PLAN_GR_NAME
             , A.DIVISION_ID
             , A.LINE_ID
             , A.FACTORY_ID
             , A.PLANT_ID
             , A.OPERATION_ID
             , B.ITEM_ID_PROD   AS ITEM_ID_PROD
             , A.OPERATION_GROUP
             , A.BASIC_NICK_NAME
          FROM GT_0039_PG_LINE_MDL_BSC_NICK A
             , SCP_MST_CELL_PROD_ASSY_MAP   B
         WHERE B.DIVISION_ID  = A.DIVISION_ID
           AND B.PLANT_ID     = A.PLANT_ID
           AND B.ITEM_ID_ASSY = A.ITEM_ID
           AND B.VALID_YN = 'Y'                 /* 2025.07.24 추가(김혜라 C) */
           AND A.OPERATION_GROUP = 'A';
        P_GATHER('GT_0039_PG_LINE_MDL_BSC_NICK');

        /* PLAN_GROUP_INFO 임시테이블 */
        INSERT INTO GT_0039_PLAN_GROUP_INFO
        (
            ITEM_ID
          , DIVISION_ID
          , LINE_ID
          , OPMZ_PLAN_GR_ID
          , OPMZ_PLAN_GR_NAME
          , BASIC_NICK_NAME
          , RN
          , RN_NICK
        )
        SELECT ITEM_ID
             , DIVISION_ID
             , LINE_ID
             , OPMZ_PLAN_GR_ID
             , OPMZ_PLAN_GR_NAME
             , BASIC_NICK_NAME
             , ROW_NUMBER() OVER (PARTITION BY ITEM_ID
                                             , DIVISION_ID
                                      ORDER BY OPMZ_PLAN_GR_ID DESC
                                             , LINE_ID DESC)   AS RN
             , ROW_NUMBER() OVER (PARTITION BY BASIC_NICK_NAME
                                             , DIVISION_ID
                                      ORDER BY OPMZ_PLAN_GR_ID DESC
                                             , LINE_ID DESC)   AS RN_NICK
          FROM GT_0039_PG_LINE_MDL_BSC_NICK;
        P_GATHER('GT_0039_PLAN_GROUP_INFO');

    END P_LOAD_PLAN_GROUP_INFO;

    /************************************************************************************************/
    /* [공통] AS_SITE_PLANT - PJ20257329 2025.09.05 AS Sales Site 제외                               */
    /************************************************************************************************/
    PROCEDURE P_LOAD_AS_SITE_PLANT
    IS
    BEGIN

        DELETE FROM GT_0039_AS_SITE_PLANT;

        INSERT INTO GT_0039_AS_SITE_PLANT
        (
            SCM_SITE_ID
          , DIVISION_ID
        )
        SELECT DISTINCT
               SEGMENT1  AS SCM_SITE_ID
             , SEGMENT3  AS DIVISION_ID
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
           AND VALID_YN    = 'Y';
        P_GATHER('GT_0039_AS_SITE_PLANT');

    END P_LOAD_AS_SITE_PLANT;

    /************************************************************************************************/
    /* [공통] MKT FCST Cell Prod Site 정보 - PJ20257329 2025.09.12 소형 Cell Prod Site 적용          */
    /************************************************************************************************/
    PROCEDURE P_LOAD_CFM_MKT_DEMAND_PLAN
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_FROM_YYYYMMDD   IN VARCHAR2,
        P_TO_YYYYMMDD     IN VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0039_CFM_MKT_DMND_PLAN;

        INSERT INTO GT_0039_CFM_MKT_DMND_PLAN
        (
            DIVISION_ID
          , PROJECT_CODE
          , SCM_SITE_ID
          , ITEM_ID
          , DOM_EXP
          , FCST_TYPE
          , INCOTERMS
          , MEASURE
          , YYYYMMDD
          , PLANT_SITE_ID
          , CELL_PROD_SITE_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , RN
        )
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.YYYYMMDD
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , B.COMPANY_ID
             , B.SITE_ID
             , CASE WHEN B.OSP_YN = 'Y'
                    THEN B.LOGISTIC_PLANT_ID
                    ELSE B.PLANT_ID
               END                              AS PLANT_ID
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.PROJECT_CODE
                                             , A.SCM_SITE_ID
                                             , A.ITEM_ID
                                             , A.DOM_EXP
                                             , A.FCST_TYPE
                                             , A.INCOTERMS
                                             , A.MEASURE
                                             , A.YYYYMMDD
                                             , A.PLANT_SITE_ID
                                      ORDER BY A.CELL_PROD_SITE_ID)  AS RN
          FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.CELL_PROD_SITE_ID
           AND A.DIVISION_ID = CASE WHEN P_DIVISION_ID = '40'   /* 소형 전용 */
                                    THEN P_DIVISION_ID
                                    ELSE NULL
                               END
           AND A.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req')
           AND A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
           /* AS-IS : CELL_PROD_SITE_ID NOT IN ('-', '')
              이관 시 빈값은 '-' 또는 공백으로 들어오므로 NULL·공백·'-' 를 모두 제외한다 */
           AND TRIM(A.CELL_PROD_SITE_ID) IS NOT NULL
           AND A.CELL_PROD_SITE_ID != '-';
        P_GATHER('GT_0039_CFM_MKT_DMND_PLAN');

    END P_LOAD_CFM_MKT_DEMAND_PLAN;

    /************************************************************************************************/
    /* [공통] CELL_PROD_SITE_ID 공통코드 목록                                                       */
    /*        AS-IS : EXEC UP_FX_GetCommonDataList @Code='CELL_PROD_SITE_ID' (파라미터 전부 NULL)    */
    /*        -> 해당 갈래(@PARAM1 이 빈 값)의 조회문을 그대로 옮긴다.                                */
    /************************************************************************************************/
    PROCEDURE P_LOAD_CELL_PROD_SITE_ID
    IS
    BEGIN

        DELETE FROM GT_0039_CELL_PROD_SITE_ID;

        INSERT INTO GT_0039_CELL_PROD_SITE_ID
        (
            CODE
          , NAME
        )
        /* [PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정 */
        /* 기본적으로 사용되는 CODE '-' 를 강제로 추가 */
        SELECT SEGMENT1   AS CODE
             , ATTRIBUTE1 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
           AND SEGMENT1    = '-'
           AND VALID_YN    = 'Y'
         UNION ALL
        /* 현재 사용 중인 모든 셀생산지 리스트 가져오기 */
        SELECT DISTINCT
               A.SCM_SITE_ID  AS CODE
             , C.ATTRIBUTE1   AS NAME
          FROM SCM_MST_SITE                  A
             , ( SELECT DISTINCT IA.DIVISION_ID, IA.COMPANY_ID, IA.SCP_OPERATION_GROUP
                   /* [C20200608-000328] SALESCOMPANY 콤보는 ITEM MASTER 의 COMPANY ID, OPERATION GROUP 기준으로 조회 */
                   FROM SCM_MST_ITEM_SN IA
                  WHERE IA.ACTIVE_FLAG = 'Y'
                    AND IA.ITEM_TYPE IS NOT NULL
                    AND IA.FORECAST_INFO_BIZ_TYPE = 'CELL' ) B
             , SCM_ADM_LOOKUP_MASTER_DETAIL  C
         WHERE A.DIVISION_ID     = B.DIVISION_ID
           AND A.OPERATION_GROUP = B.SCP_OPERATION_GROUP
           AND A.COMPANY_ID      = B.COMPANY_ID
           AND C.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
           AND A.SCM_SITE_ID = C.SEGMENT1
           AND C.VALID_YN    = 'Y'
           AND A.SITE_TYPE       = 'PLANT'
           AND A.OPERATION_GROUP = 'A'
           AND A.OSP_YN          = 'N';
        P_GATHER('GT_0039_CELL_PROD_SITE_ID');

    END P_LOAD_CELL_PROD_SITE_ID;

    /************************************************************************************************/
    /* [공통] 전극 Applied Cell Model                                                               */
    /************************************************************************************************/
    PROCEDURE P_LOAD_ELEC_APPLIED_MODEL
    (
        P_DIVISION_ID  IN VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0039_ELEC_APPLIED_MODEL;

        INSERT INTO GT_0039_ELEC_APPLIED_MODEL
        (
            DIVISION_ID
          , ITEM_ID
          , APPLIED_MODEL
          , RN
        )
        SELECT IA.DIVISION_ID
             , IA.ITEM_ID
             , IA.APPLIED_MODEL
             , IA.RN
          FROM ( SELECT A.DIVISION_ID
                      , A.ITEM_ID
                      , B.APPLIED_MODEL
                      , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                      ,A.ITEM_ID
                                               ORDER BY CASE WHEN C.ATTRIBUTE3 = '81' AND A.ITEM_ID LIKE 'A%' THEN 1
                                                             WHEN C.ATTRIBUTE3 = '40' AND A.ITEM_ID LIKE 'M%' THEN 2
                                                             WHEN C.ATTRIBUTE3 = '82' AND A.ITEM_ID LIKE 'M%' THEN 3
                                                             ELSE 9
                                                        END)  AS RN
                   FROM SCP_MST_FINAL_ITEM A
                      , SCM_MST_ITEM_SN    B
                      , SCM_MST_DIVISION   C
                  WHERE B.DIVISION_ID = A.DIVISION_ID
                    AND B.ITEM_ID     = A.ITEM_ID
                    AND C.DIVISION_ID = A.DIVISION_ID
                    AND B.ACTIVE_FLAG = 'Y'
                    AND NVL(B.APPLIED_MODEL, 'Z') != 'Z'
                    AND A.DIVISION_ID     = P_DIVISION_ID
                    AND A.OPERATION_GROUP = 'E' ) IA
         WHERE IA.RN = 1;
        P_GATHER('GT_0039_ELEC_APPLIED_MODEL');

    END P_LOAD_ELEC_APPLIED_MODEL;

    /************************************************************************************************/
    /* [공통] 확인 대상 전체 데이터 - Plan Group 매핑                                               */
    /************************************************************************************************/
    PROCEDURE P_LOAD_TARGET_DATA_PLAN_GROUP
    IS
    BEGIN

        DELETE FROM GT_0039_TGT_DATA_PLAN_GROUP;

        INSERT INTO GT_0039_TGT_DATA_PLAN_GROUP
        (
            OPMZ_PLAN_GR_ID
          , OPMZ_PLAN_GR_NAME
          , LINE_ID
          , BASIC_NICK_NAME
          , DV
          , DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , MASTER_INVLD_MSG
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
          , YIELD
          , FROM_UI
        )
        SELECT NVL(B.OPMZ_PLAN_GR_ID  , C.OPMZ_PLAN_GR_ID  )  AS OPMZ_PLAN_GR_ID
             , NVL(B.OPMZ_PLAN_GR_NAME, C.OPMZ_PLAN_GR_NAME)  AS OPMZ_PLAN_GR_NAME
             , NVL(B.LINE_ID          , C.LINE_ID          )  AS LINE_ID
             , NVL(B.BASIC_NICK_NAME  , C.BASIC_NICK_NAME  )  AS BASIC_NICK_NAME
             , CASE WHEN B.LINE_ID IS NOT NULL THEN 'A'   /* item id mapping */
                    WHEN C.LINE_ID IS NOT NULL THEN 'B'   /* basic cell nick name mapping */
                    ELSE 'Z'
               END                                            AS DV
             , A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , A.BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.MASTER_INVLD_MSG
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
             , A.YIELD
             , A.FROM_UI
          FROM GT_0039_TARGET_DATA_BC_NICK A
             , GT_0039_PLAN_GROUP_INFO     B   /* item_id 로 매핑 */
             , GT_0039_PLAN_GROUP_INFO     C   /* basic cell nick name 으로 매핑 */
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.ITEM_ID(+)     = A.MODEL_ID
           AND B.RN(+)          = 1
           AND C.DIVISION_ID(+)     = A.DIVISION_ID
           AND C.BASIC_NICK_NAME(+) = A.BASIC_CELL_NICK_NAME
           AND C.RN_NICK(+)         = 1;
        P_GATHER('GT_0039_TGT_DATA_PLAN_GROUP');

    END P_LOAD_TARGET_DATA_PLAN_GROUP;

    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_STOCK_OSP                                               */
    /* Description : Stock OSP 조회                                                                 */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh   Initial Release PJ2024A332R                                                 */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_STOCK_OSP
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
    BEGIN

/*
--================================================================================================================================
### Stock OSP 요구사항

1) 협력사별 자료 업로드 여부 (DIVISION PLANT(패커사별)별)
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_TARGET_SUNDAY;
        DELETE FROM GT_0039_PACKER_SITE_INFO;
        DELETE FROM GT_0039_PACKER_UPLOAD_ITEM_CNT;

        /* ---------------------------------------------------------------------------------------- */
        /* UPLOAD 재고 기준 일자 - 일요일                                                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_SUNDAY';
        INSERT INTO GT_0039_TARGET_SUNDAY
        (
            YYYYMMDD
          , D_YYYYMMDD
          , YMD_SEQ
        )
        SELECT YYYYMMDD
             , 'D_' || YYYYMMDD  AS D_YYYYMMDD
             , ROW_NUMBER() OVER (PARTITION BY 'A' ORDER BY YYYYMMDD DESC)  AS YMD_SEQ
          FROM SCM_MST_BUCKET
         WHERE YYYYMMDD BETWEEN '20260710'
                            AND '20260824'
           AND DAYOFWEEK = 'SUN';
        P_GATHER('GT_0039_TARGET_SUNDAY');

        /* ---------------------------------------------------------------------------------------- */
        /* Packer Site                                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PACKER_SITE_INFO';
        INSERT INTO GT_0039_PACKER_SITE_INFO
        (
            DIVISION_ID
          , SCM_SITE_ID
          , SITE_DESCRIPTION
          , ATTRIBUTE1
          , ATTRIBUTE2
          , YYYYMMDD
          , D_YYYYMMDD
          , YMD_SEQ
        )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.SITE_DESCRIPTION
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , B.YYYYMMDD
             , B.D_YYYYMMDD
             , B.YMD_SEQ
          FROM SCM_MST_SITE          A
             , GT_0039_TARGET_SUNDAY B
         WHERE 1 = 1
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.OSP_YN      = 'Y'
           AND A.VALID_YN    = 'Y';
        P_GATHER('GT_0039_PACKER_SITE_INFO');

        /* ---------------------------------------------------------------------------------------- */
        /* Packer 별 Upload Item 건수                                                                */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PACKER_UPLOAD_ITEM_CNT';
        INSERT INTO GT_0039_PACKER_UPLOAD_ITEM_CNT
        (
            DIVISION_ID
          , SCM_SITE_ID
          , SITE_DESCRIPTION
          , W0
          , W0_LAST_UPDATE_DATE
          , W0_ITEM_COUNT
          , "W-1_ITEM_COUNT"
          , "W-2_ITEM_COUNT"
          , "W-3_ITEM_COUNT"
          , "W-4_ITEM_COUNT"
          , MASTER_INVLD_CD
        )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.SITE_DESCRIPTION
             , MAX(CASE WHEN A.YMD_SEQ = 1 THEN A.YYYYMMDD ELSE NULL END)                       AS W0
             , NVL(MAX(DISTINCT CASE WHEN A.YMD_SEQ = 1
                                     THEN TO_CHAR(B.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS')
                                     ELSE NULL
                                END), '미입력')                                                 AS W0_LAST_UPDATE_DATE
             , COUNT(DISTINCT CASE WHEN A.YMD_SEQ = 1 THEN B.ITEM_ID ELSE NULL END)             AS W0_ITEM_COUNT
             , COUNT(DISTINCT CASE WHEN A.YMD_SEQ = 2 THEN B.ITEM_ID ELSE NULL END)             AS "W-1_ITEM_COUNT"
             , COUNT(DISTINCT CASE WHEN A.YMD_SEQ = 3 THEN B.ITEM_ID ELSE NULL END)             AS "W-2_ITEM_COUNT"
             , COUNT(DISTINCT CASE WHEN A.YMD_SEQ = 4 THEN B.ITEM_ID ELSE NULL END)             AS "W-3_ITEM_COUNT"
             , COUNT(DISTINCT CASE WHEN A.YMD_SEQ = 5 THEN B.ITEM_ID ELSE NULL END)             AS "W-4_ITEM_COUNT"
             , CASE WHEN COUNT(DISTINCT CASE WHEN A.YMD_SEQ = 1 THEN B.ITEM_ID ELSE NULL END) = 0
                    THEN 'SP001'
                    ELSE NULL
               END                                                                              AS MASTER_INVLD_CD
          FROM GT_0039_PACKER_SITE_INFO A
             , SCM_DNM_STOCK_OSP        B   /* DIVISION_ID, SCM_SITE_ID, ITEM_ID, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2 */
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND B.YYYYMMDD(+)    = A.YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.SITE_DESCRIPTION
         ORDER BY A.SITE_DESCRIPTION;
        P_GATHER('GT_0039_PACKER_UPLOAD_ITEM_CNT');

        /* ---------------------------------------------------------------------------------------- */
        /* 최종 결과 조회                                                                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.SCM_SITE_ID
                 , A.SITE_DESCRIPTION
                 , A.W0
                 , A.W0_LAST_UPDATE_DATE
                 , A.W0_ITEM_COUNT
                 , A."W-1_ITEM_COUNT"
                 , A."W-2_ITEM_COUNT"
                 , A."W-3_ITEM_COUNT"
                 , A."W-4_ITEM_COUNT"
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                 AS MASTER_INVLD_MSG
              FROM GT_0039_PACKER_UPLOAD_ITEM_CNT  A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL    B
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_STOCK_OSP;


    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_PLAN_GROUP                                              */
    /* Description : Plan Group 조회                                                                */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2025/08/14  hrkim   PJ20257329 MKT FCST 최종 수정일시 추가, plan group 미매핑 데이터만 조회   */
    /* 2025/08/26  hrkim   PJ20257329 plan_group_info 임시테이블 추가 사용                           */
    /* 2025/09/05  hrkim   PJ20257329 MKT_FCST 참조시 AS Sales 사이트 제외                           */
    /* 2025/09/12  hrkim   PJ20257329 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용           */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_PLAN_GROUP
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);   /* 당주 월요일 (plan_start_yyyymmdd) */
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);   /* horizon_end_date */
    BEGIN

/*
--================================================================================================================================
### Plan Group  요구사항

1) CURRENT MKT FCST DP에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 Plan Group이 설정되어 있지 않은 경우

※1. Plan Group 입력 영향을 받지 않고 모두 조회함
※2. 81 like division은 기입력된 plan group 의 모델정보를 활용하여 수요의 모델을 엮을것.
    : 로직은 left 12 / distinct
※3. 2번로직으로 찾은 모델은 PLAN GROUP에 '(예상)' 추가하여 송출함

* 40 / 82 는 최적화 확장시에 논의하여 결정필요..
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_MKT_FCST_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            DIVISION_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , BASIC_CELL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
        )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID                      AS SALES_SITE_ID
             , A.PROJECT_CODE                     AS PROJECT_CODE
             , A.ITEM_ID                          AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)            AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP                  AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                        AS MODEL_NICK_NAME
             , F.BASIC_NICK_NAME                  AS BASIC_CELL_NICK_NAME
             , MIN(A.YYYYMMDD)                    AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                    AS SALES_TO_YYYYMMDD
             , SUM(A.QTY)                         AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE   /* 2025.08.14 추가 */
          FROM DM_PLN_MKT_FCST        A   /* DIVISION_ID, MEASURE, YYYYMMDD */
             , SCM_MST_SITE           B
             , SCP_MST_FINAL_ITEM     C
             , SCP_MST_ITEM_BSI_IFO   D   /* Doe model */
             , SCP_MST_FINAL_ITEM     E
             , SCP_MST_ITEM_BSI_IFO   F   /* Cell Model 기준 Basic nick name 참조 */
             , GT_0039_AS_SITE_PLANT  G   /* PJ20257329 2025.09.05 AS Sales Site 제외 */
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND D.ITEM_ID(+)     = A.ITEM_ID
           AND E.DIVISION_ID(+) = A.DIVISION_ID
           AND E.ITEM_ID(+)     = D.APPLIED_DOE
           AND F.ITEM_ID(+)     = CASE WHEN C.OPERATION_GROUP = 'P'
                                       THEN NVL(C.ATTRIBUTE1, E.ATTRIBUTE1)
                                       ELSE A.ITEM_ID   /* sales_item_id */
                                  END
           AND G.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND G.DIVISION_ID(+) = A.DIVISION_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND G.SCM_SITE_ID IS NULL   /* PJ20257329 2025.09.05 AS Sales Site 제외 */
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , F.BASIC_NICK_NAME;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST Plan group 매핑                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST_PLAN_GROUP';
        INSERT INTO GT_0039_MKT_FCST_PLAN_GROUP
        (
            OPMZ_PLAN_GR_ID
          , OPMZ_PLAN_GR_NAME
          , LINE_ID
          , BASIC_NICK_NAME
          , DV
          , BASIC_CELL_NICK_NAME
          , DIVISION_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
        )
        SELECT NVL(B.OPMZ_PLAN_GR_ID  , C.OPMZ_PLAN_GR_ID  )  AS OPMZ_PLAN_GR_ID
             , NVL(B.OPMZ_PLAN_GR_NAME, C.OPMZ_PLAN_GR_NAME)  AS OPMZ_PLAN_GR_NAME
             , NVL(B.LINE_ID          , C.LINE_ID          )  AS LINE_ID
             , NVL(B.BASIC_NICK_NAME  , C.BASIC_NICK_NAME  )  AS BASIC_NICK_NAME
             , CASE WHEN B.LINE_ID IS NOT NULL THEN 'A'   /* item id mapping */
                    WHEN C.LINE_ID IS NOT NULL THEN 'B'   /* basic cell nick name mapping */
                    ELSE 'Z'
               END                                            AS DV
             , A.BASIC_CELL_NICK_NAME
             , A.DIVISION_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.MF_LAST_UPDATE_DATE
          FROM GT_0039_MKT_FCST         A
             , GT_0039_PLAN_GROUP_INFO  B   /* item_id 로 매핑 */
             , GT_0039_PLAN_GROUP_INFO  C   /* basic cell nick name 으로 매핑 */
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.ITEM_ID(+)     = A.SALES_ITEM_ID
           AND B.RN(+)          = 1
           AND C.DIVISION_ID(+)     = A.DIVISION_ID
           AND C.BASIC_NICK_NAME(+) = A.BASIC_CELL_NICK_NAME
           AND C.RN_NICK(+)         = 1;
        P_GATHER('GT_0039_MKT_FCST_PLAN_GROUP');

        /* ---------------------------------------------------------------------------------------- */
        /* 최종 확인 필요 대상 조회 - Plan Group 미등록                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.SALES_ITEM_ID                  AS ITEM_ID
                 , A.MODEL_NICK_NAME                AS NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.DV                             AS PLAN_GROUP_MAPPING_DV
                 , B.SEGMENT1                       AS MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , C.SITE_DESCRIPTION               AS SALES_PLANT_SITE
                 , A.PROJECT_CODE                   AS PROJECT_OPERATION
                 , A.INCOTERMS                      AS INCOERMS_LINE
                 , A.QTY
                 , 'Sales기간:' || A.SALES_FROM_YYYYMMDD || '~' || A.SALES_TO_YYYYMMDD
                                || ', FCST Last Update :' || A.MF_LAST_UPDATE_DATE
                                || ', Sales Site:'        || A.SALES_SITE_ID
                                                    AS MASTER_INVLD_CTN   /* 2025.08.14 수요 최종 변경일 추가 */
              FROM GT_0039_MKT_FCST_PLAN_GROUP  A
                 , SCM_MST_SITE                 C
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE C.DIVISION_ID = V_DIVISION_ID
               AND C.SCM_SITE_ID = A.SALES_SITE_ID
               /* AS-IS 는 ON 절에 ISNULL(OPMZ_PLAN_GR_ID,'-')='-' 를 두었으나 아래 WHERE 조건과 동일하므로 생략 */
               AND B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = 'PG001'
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.SALES_ITEM_ID   LIKE IA.TST
                  OR A.MODEL_NICK_NAME LIKE IA.TST )
               AND NVL(A.OPMZ_PLAN_GR_ID, '-') = '-'   /* 2025.08.14 plan group 매핑이 안되는 데이터만 조회 */
             ORDER BY A.DIVISION_ID
                    , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                           WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                           ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                      END
                    , A.MODEL_OPERATION_GROUP
                    , A.MODEL_NICK_NAME
                    , A.SALES_ITEM_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_PLAN_GROUP;

    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_YIELD                                                   */
    /* Description : 수율 조회                                                                      */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2025/08/14  hrkim   PJ20257329 scp plan operation 으로 공정 참조 범위 제한                    */
    /* 2025/08/26  hrkim   PJ20257329 SCP 완성공정 조건 하드코딩 lookup 데이터 참조로 변경           */
    /* 2025/09/12  hrkim   PJ20257329 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용           */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_YIELD
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

/*
--================================================================================================================================
### 수율 요구사항
------------------------------------------------------------------------------
1) CURRENT CAPA 입력되어 있는 'LINE', '모델' 정보를 기반으로
 >> E2000, A9000, P5500, P9500 공정의 수율이 50% 미만인경우

2) CURRENT FORMATION 입력되어 있는 'LINE', '모델' 정보를 기반으로
  >> 활성화/특성 공정의 수율이 50% 미만인경우"

### 메시지
------------------------------------------------------------------------------
1) CAPA 수율이 50%미만으로 낮습니다. 확인필요합니다.
2) FORMATION 수율이 50%미만으로 낮습니다. 확인필요합니다."
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        /* [PJ20257329] 2025.08.26 SCP 완성 공정 하드 코딩 변경 (임시 테이블) */
        V_STEP := 'SCP_FINAL_OPERATION';
        DELETE FROM GT_0039_SCP_FINAL_OPERATION;

        INSERT INTO GT_0039_SCP_FINAL_OPERATION
        (
            OPERATION_ID
        )
        SELECT DISTINCT SEGMENT1  AS OPERATION_ID
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
           AND ATTRIBUTE1  = 'Y';   /* Final Operation */

        V_STEP := 'Plan Group 정보';
        P_GATHER('GT_0039_SCP_FINAL_OPERATION');
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := '전극 Applied Cell Model';
        P_LOAD_ELEC_APPLIED_MODEL(V_DIVISION_ID);

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터                                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , YIELD
          , FROM_UI
          , MASTER_INVLD_CTN
        )
        /*
         1) CURRENT CAPA 입력되어 있는 'LINE', '모델' 정보를 기반으로
         >> E2000, A9000, P5500, P9500 공정의 수율이 50% 미만인경우
        */
        SELECT A.DIVISION_ID
             , A.ITEM_ID                    AS MODEL_ID
             , C.NICK_NAME
             , 'YLD01'                      AS MASTER_INVLD_CD
             , B.SITE_DESCRIPTION           AS SALES_PLANT_SITE
             , A.OPERATION_ID               AS PROJECT_OPERATION
             , A.LINE_ID                    AS INCOTERMS_LINE
             , A.YIELD
             , 'CAPA'                       AS FROM_UI
             , 'Min/Max Month : ' || MIN(A.MONTH) || '/' || MAX(A.MONTH)  AS MASTER_INVLD_CTN
          FROM SCM_MST_YIELD_SN            A   /* COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MONTH */
             , SCM_MST_SITE                B
             , SCP_MST_FINAL_ITEM          C
             , GT_0039_SCP_FINAL_OPERATION D   /* PJ20257329 2025.08.26 완성 공정 하드 코딩 변경 */
         WHERE B.DIVISION_ID     = A.DIVISION_ID
           AND B.PLANT_ID        = A.PLANT_ID
           AND B.OPERATION_GROUP = SUBSTR(A.OPERATION_ID, 1, 1)
           AND B.COMPANY_ID      = A.COMPANY_ID
           AND C.DIVISION_ID     = A.DIVISION_ID
           AND C.ITEM_ID         = A.ITEM_ID
           AND D.OPERATION_ID    = A.OPERATION_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MONTH >= SUBSTR(V_FROM_YYYYMMDD, 1, 6)
           AND NVL(A.YIELD, 1) < 0.5
         GROUP BY A.DIVISION_ID
                , A.ITEM_ID
                , C.NICK_NAME
                , B.SITE_DESCRIPTION
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YIELD
                , B.SCM_SITE_ID
         UNION ALL
        /*
        2) CURRENT FORMATION 입력되어 있는 'LINE', '모델' 정보를 기반으로
          >> 활성화/특성 공정의 수율이 50% 미만인경우"
        */
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , C.NICK_NAME
             , 'YLD02'                      AS MASTER_INVLD_CD
             , B.SITE_DESCRIPTION           AS SALES_PLANT_SITE
             , NULL                         AS PROJECT_OPERATION
             , NULL                         AS INCOTERMS_LINE
             , NVL(A.SSP_MODIFY_YIELD
                  ,A.FORMATION_TOTAL_YIELD) AS YIELD
             , 'FORMATION'                  AS FROM_UI
               /* AS-IS CONVERT(NVARCHAR(50), numeric(20,10)) 은 소수 10자리를 고정 표기하므로
                  TO_CHAR 기본 서식(.03)이 아니라 자릿수 서식(0.0300000000)을 쓴다 */
             , 'FORMATION YIELD :' || TO_CHAR(A.FORMATION_YIELD, 'FM9999999990.0000000000')
            || 'CHAR_YIELD :'      || TO_CHAR(A.CHAR_YIELD     , 'FM9999999990.0000000000')  AS MASTER_INVLD_CTN
          FROM SCP_MST_FORMATION_V A   /* DIVISION_ID, PLANT_SITE_ID, ITEM_ID */
             , SCM_MST_SITE        B
             , SCP_MST_FINAL_ITEM  C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND NVL(A.SSP_MODIFY_YIELD, A.FORMATION_TOTAL_YIELD) < 0.5;
        P_GATHER('GT_0039_TARGET_DATA');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , YIELD
          , FROM_UI
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , D.BASIC_NICK_NAME       AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.YIELD
             , A.FROM_UI
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA        A
             , SCP_MST_FINAL_ITEM         B
             , GT_0039_ELEC_APPLIED_MODEL C
             , SCP_MST_ITEM_BSI_IFO       D
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.ITEM_ID(+)     = A.MODEL_ID
           AND D.ITEM_ID(+)     = CASE WHEN B.OPERATION_GROUP = 'E' THEN C.APPLIED_MODEL
                                       WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                       ELSE A.MODEL_ID
                                  END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.YIELD
                 , A.FROM_UI
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND A.YIELD != 0
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , A.MODEL_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_YIELD;


    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_BOM                                                     */
    /* Description : BOD                                                                            */
    /*----------------------------------------------------------------------------------------------*/
    /* Initial Release  PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축                */
    /* 2025/08/14  hrkim   PJ20257329 line assign 참조시 scp plan operation 으로 공정 참조 범위 제한 */
    /* 2025/08/26  hrkim   PJ20257329 Model BOM 참조시 parent/child FP item master active 'Y'만 참조 */
    /* 2025/09/05  hrkim   PJ20257329 MKT_FCST 참조시 AS Sales 사이트 제외                           */
    /* 2025/09/12  hrkim   PJ20257329 소형 Cell Prod Site 적용                                       */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_BOM
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

/*
--================================================================================================================================
### BOM 요구사항 ###############################################################

1) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 A9000(조립)/ E2000(전극) 공정에 대한 PLANT 확장 정보가 미존재하는 경우 (모든 PLANT 중)

2) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당모델의 A900(조립)/E2000(전극)공정 '모델' 기반으로
 >> ITEM TYPE = NULL 인경우
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'CFM_MKT_DEMAND_PLAN';
        P_LOAD_CFM_MKT_DEMAND_PLAN(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'CELL_PROD_SITE_ID';
        P_LOAD_CELL_PROD_SITE_ID;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_SCP_BOM;
        DELETE FROM GT_0039_BOM_CHILD_CNT;
        DELETE FROM GT_0039_BOM_CHILD_CNT_0;
        DELETE FROM GT_0039_BOM_NOT_EXISTS;
        DELETE FROM GT_0039_ITEM_TYPE_IS_NULL;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* PK : DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,      */
        /*      MEASURE, YYYYMMDD, PLANT_SITE_ID                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(CASE WHEN NVL(E.RN, 1) = 1 THEN A.QTY ELSE 0 END)  AS QTY   /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
             , E.CELL_PROD_SITE_ID
             , E.COMPANY_ID                   AS COMPANY_ID_CELL_PROD
             , E.SITE_ID                      AS SITE_ID_CELL_PROD
             , E.PLANT_ID                     AS PLANT_ID_CELL_PROD
          FROM DM_PLN_MKT_FCST           A   /* DIVISION_ID, MEASURE, YYYYMMDD */
             , SCM_MST_SITE              B
             , SCP_MST_FINAL_ITEM        C
             , GT_0039_AS_SITE_PLANT     D   /* PJ20257329 2025.09.05 AS Sales Site 제외 */
             , GT_0039_CFM_MKT_DMND_PLAN E   /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND C.OPERATION_GROUP != 'E'   /* 전극 제외 */
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PROJECT_CODE(+)  = A.PROJECT_CODE
           AND E.SCM_SITE_ID(+)   = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.DOM_EXP(+)       = A.DOM_EXP
           AND E.FCST_TYPE(+)     = A.FCST_TYPE
           AND E.INCOTERMS(+)     = A.INCOTERMS
           AND E.MEASURE(+)       = A.MEASURE
           AND E.YYYYMMDD(+)      = A.YYYYMMDD
           AND E.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL   /* PJ20257329 2025.09.05 AS Sales Site 제외 */
         GROUP BY A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , E.CELL_PROD_SITE_ID
                , E.COMPANY_ID
                , E.SITE_ID
                , E.PLANT_ID;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST 가 존재하는 모델 BOM                                                             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_BOM';
        INSERT INTO GT_0039_SCP_BOM
        (
            MODEL_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , MODEL_OPERATION_GROUP
          , CHILD_DIVISION_ID
          , CHILD_COMPANY_ID
          , CHILD_SITE_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , CHILD_ITEM_TYPE
          , CHILD_ITEM_NICK_NAME
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , B.OPERATION_GROUP        AS MODEL_OPERATION_GROUP   /* PJ20257329 2025.09.05 추가 */
             , A.CHILD_DIVISION_ID
             , A.CHILD_COMPANY_ID
             , A.CHILD_SITE_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN C.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE C.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , D.ITEM_TYPE              AS CHILD_ITEM_TYPE
             , D.NICK_NAME              AS CHILD_ITEM_NICK_NAME
          FROM SCM_MST_MODEL_BOM   A   /* COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM */
             , SCP_MST_FINAL_ITEM  B   /* PJ20257329 2025.09.05 추가 JOIN */
             , SCP_MST_FINAL_ITEM  C
             , SCM_MST_ITEM_SN     D
             , SCM_MST_ITEM_SN     E   /* PJ20257329 2025.08.26 parent item master active 'Y'만 참조 */
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'   /* Cell Assy 제외 */
           AND D.ITEM_ID     = A.CHILD_ITEM_ID
           AND D.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND D.DIVISION_ID = A.CHILD_DIVISION_ID
           AND D.SITE_ID     = A.CHILD_SITE_ID
           AND D.ACTIVE_FLAG = 'Y'           /* PJ20257329 2025.08.26 child item master active 'Y'만 참조 */
           AND E.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND E.COMPANY_ID(+)  = A.COMPANY_ID
           AND E.DIVISION_ID(+) = A.DIVISION_ID
           AND E.SITE_ID(+)     = A.SITE_ID
           AND E.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR E.ITEM_ID IS NOT NULL)   /* PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 */
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_SCP_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM - 모델별 셀 또는 전극(Anode/Cathod) 건수 정보                                         */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'BOM_CHILD_CNT';
        INSERT INTO GT_0039_BOM_CHILD_CNT
        (
            MODEL_ID
          , MODEL_OPERATION_GROUP
          , CELL_MODEL_ID
          , CELL_CNT
          , ANODE_CNT
          , CATHODE_CNT
        )
        SELECT MODEL_ID
             , MAX(MODEL_OPERATION_GROUP)                                                                         AS MODEL_OPERATION_GROUP   /* PJ20257329 2025.09.05 추가 */
             , MAX(CASE WHEN CHILD_OPERATION_GROUP = 'A' THEN CHILD_ITEM_ID ELSE NULL END)                        AS CELL_MODEL_ID           /* PJ20257329 2025.09.05 추가 */
             , COUNT(DISTINCT CASE WHEN CHILD_OPERATION_GROUP = 'A' THEN CHILD_ITEM_ID ELSE NULL END)             AS CELL_CNT
             , COUNT(DISTINCT CASE WHEN CHILD_OPERATION_GROUP = 'E' AND CHILD_ELECTRODE_TYPE = 'ANODE'
                                   THEN CHILD_ITEM_ID ELSE NULL END)                                              AS ANODE_CNT
             , COUNT(DISTINCT CASE WHEN CHILD_OPERATION_GROUP = 'E' AND CHILD_ELECTRODE_TYPE = 'CATHODE'
                                   THEN CHILD_ITEM_ID ELSE NULL END)                                              AS CATHODE_CNT
          FROM GT_0039_SCP_BOM
         GROUP BY MODEL_ID;
        P_GATHER('GT_0039_BOM_CHILD_CNT');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM - 모델별 셀 또는 전극(Anode/Cathod) 0 인 건                                           */
        /* PJ20257329 2025.09.05 추가                                                                */
        /* Pack Model기준 Cell모델 확장 / 동일 plant 전극 미확장 이더라도                            */
        /* 타 plant에 해당 cell 모델의 전극 BOM확장된 경우 -> BOM 확장 된 것으로 본다.                */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'BOM_CHILD_CNT_0';
        INSERT INTO GT_0039_BOM_CHILD_CNT_0
        (
            MODEL_ID
          , MODEL_OPERATION_GROUP
          , CELL_MODEL_ID
          , CELL_CNT
          , ANODE_CNT
          , CATHODE_CNT
        )
        SELECT MODEL_ID
             , MODEL_OPERATION_GROUP
             , CELL_MODEL_ID
             , CELL_CNT
             , ANODE_CNT
             , CATHODE_CNT
          FROM GT_0039_BOM_CHILD_CNT A
         WHERE (A.CELL_CNT = 0 OR A.ANODE_CNT = 0 OR A.CATHODE_CNT = 0)
           AND NOT EXISTS ( SELECT 1   /* Pack model 기준 Cell 확인되어 있고 */
                              FROM GT_0039_BOM_CHILD_CNT XA
                             WHERE XA.MODEL_ID = A.CELL_MODEL_ID
                               AND XA.MODEL_OPERATION_GROUP = 'A'
                               AND A.MODEL_OPERATION_GROUP  = 'P'
                               AND A.CELL_CNT     > 0   /* Pack model의 하위 cell 확장 */
                               AND XA.ANODE_CNT   > 0   /* Cell 모델의 하위 전극 확장 */
                               AND XA.CATHODE_CNT > 0 );
        P_GATHER('GT_0039_BOM_CHILD_CNT_0');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM에 Sales Model 또는 하위 Child item이 없는 경우                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'BOM_NOT_EXISTS';
        INSERT INTO GT_0039_BOM_NOT_EXISTS
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        /* ### 1. BOM에 Sales Model이 없는 경우 */
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , 'BOM01'                                                    AS MASTER_INVLD_CD
             , 'Model:0' || CASE WHEN A.CELL_PROD_SITE_ID IS NULL
                                 THEN ''
                                 ELSE ' ,Cell Prod Site : ' || B.NAME     /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
                            END                                           AS MASTER_INVLD_CTN   /* 상세내용 */
          FROM GT_0039_MKT_FCST           A
             , GT_0039_CELL_PROD_SITE_ID  B   /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
         WHERE B.CODE(+) = A.CELL_PROD_SITE_ID
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_SCP_BOM XA
                             WHERE XA.MODEL_ID = A.SALES_ITEM_ID )
         UNION ALL
        /* ### 2. BOM에 Sales Model 정보는 있으나, BOM 하위에 Cell 또는 전극(양극 또는 음극) 품목이 없는 경우 (Final item 기준) */
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , 'BOM02'                                                    AS MASTER_INVLD_CD
             , 'Cell:'      || TO_CHAR(C.CELL_CNT)
            || ',Anode:'    || TO_CHAR(C.ANODE_CNT)
            || ',Cathode:'  || TO_CHAR(C.CATHODE_CNT)
            || CASE WHEN A.CELL_PROD_SITE_ID IS NULL
                    THEN ''
                    ELSE ', Cell Prod Site ID : ' || B.NAME               /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
               END                                                        AS MASTER_INVLD_CTN   /* 상세내용 */
          FROM GT_0039_MKT_FCST           A
             , GT_0039_BOM_CHILD_CNT_0    C   /* PJ20257329 2025.09.05 변경 (#SCP_BOM_CHILD_CNT -> #SCP_BOM_CHILD_CNT_0) */
             , GT_0039_CELL_PROD_SITE_ID  B   /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
         WHERE C.MODEL_ID = A.SALES_ITEM_ID
           AND B.CODE(+)  = A.CELL_PROD_SITE_ID
           AND A.MODEL_OPERATION_GROUP != 'E';
        P_GATHER('GT_0039_BOM_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* Item Type is NULL                                                                         */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'ITEM_TYPE_IS_NULL';
        INSERT INTO GT_0039_ITEM_TYPE_IS_NULL
        (
            CHILD_ITEM_TYPE
          , CHILD_DIVISION_ID
          , CHILD_COMPANY_ID
          , CHILD_SITE_ID
          , CHILD_ITEM_ID
          , CHILD_ITEM_NICK_NAME
          , CHILD_OPERATION_GROUP
          , SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT B.CHILD_ITEM_TYPE
             , B.CHILD_DIVISION_ID
             , B.CHILD_COMPANY_ID
             , B.CHILD_SITE_ID
             , B.CHILD_ITEM_ID
             , B.CHILD_ITEM_NICK_NAME
             , B.CHILD_OPERATION_GROUP
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , B.CHILD_OPERATION_ID
             , B.CHILD_ELECTRODE_TYPE
             , 'BOM03'                                                    AS MASTER_INVLD_CD
             , 'Child Division:' || B.CHILD_DIVISION_ID
            || ', Sales Item : ' || A.SALES_ITEM_ID
            || ', Company:'      || C.COMPANY_NAME
            || CASE WHEN A.CELL_PROD_SITE_ID IS NULL
                    THEN ''
                    ELSE ', Cell Prod Site ID : ' || D.NAME               /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
               END                                                        AS MASTER_INVLD_CTN
          FROM GT_0039_MKT_FCST           A
             , GT_0039_SCP_BOM            B   /* BOM이 존재한다는 전제하에 project route 확인 대상 */
             , SCM_MST_COMPANY_SN         C
             , GT_0039_CELL_PROD_SITE_ID  D   /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
         WHERE B.MODEL_ID = A.SALES_ITEM_ID
           /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND C.COMPANY_ID(+) = B.CHILD_COMPANY_ID
           AND D.CODE(+)       = A.CELL_PROD_SITE_ID
           AND B.CHILD_ITEM_TYPE IS NULL;
        P_GATHER('GT_0039_ITEM_TYPE_IS_NULL');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM 확인 대상 전체 데이터                                                                 */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        /* BOM not exists */
        SELECT V_DIVISION_ID          AS DIVISION_ID
             , A.SALES_ITEM_ID        AS MODEL_ID
             , A.MODEL_NICK_NAME      AS NICK_NAME
             , A.SALES_SITE_ID        AS SALES_PLANT_SITE
             , A.PROJECT_CODE         AS PROJECT_OPERATION
             , A.INCOTERMS            AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CD
             , A.MASTER_INVLD_CTN
          FROM GT_0039_BOM_NOT_EXISTS A
         UNION ALL
        /* Item_type is null (SCM_MST_ITEM_SN) */
        SELECT V_DIVISION_ID          AS DIVISION_ID
             , A.CHILD_ITEM_ID        AS MODE_ID
             , A.CHILD_ITEM_NICK_NAME AS NICK_NAME
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.INCOTERMS
             , A.QTY
             , A.MASTER_INVLD_CD
             , A.MASTER_INVLD_CTN
          FROM GT_0039_ITEM_TYPE_IS_NULL A;
        P_GATHER('GT_0039_TARGET_DATA');

        V_STEP := '전극 Applied Cell Model';
        P_LOAD_ELEC_APPLIED_MODEL(V_DIVISION_ID);

        /* ---------------------------------------------------------------------------------------- */
        /* BOM 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                      */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , D.BASIC_NICK_NAME       AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA        A
             , SCP_MST_FINAL_ITEM         B
             , GT_0039_ELEC_APPLIED_MODEL C
             , SCP_MST_ITEM_BSI_IFO       D
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.ITEM_ID(+)     = A.MODEL_ID
           AND D.ITEM_ID(+)     = CASE WHEN B.OPERATION_GROUP = 'E' THEN C.APPLIED_MODEL
                                       WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                       ELSE A.MODEL_ID
                                  END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , A.MODEL_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_BOM;

    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_PROJECT_ROUTE                                           */
    /* Description : Project Route 조회                                                             */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2025/08/14  hrkim   PJ20257329 scp plan operation 으로 공정 참조 범위 제한                    */
    /* 2025/08/26  hrkim   PJ20257329 parent/child FP item master active 'Y'만 참조                  */
    /* 2025/09/05  hrkim   PJ20257329 MKT_FCST 참조시 AS Sales 사이트 제외                           */
    /* 2025/09/12  hrkim   PJ20257329 소형 Cell Prod Site 적용, 중복 제거                            */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_PROJECT_ROUTE
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

/*
--================================================================================================================================
### Project Route 요구사항

1) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와 해당 모델의 BOM 정보를 기반으로
 >> PJT ROUTE 미등록인 경우

2) CURRENT PROD AMEND 에 입력되어 있는 '모델'/'PLANT'/'생산계획날짜' 정보를 기반으로
 >> 생산계획 시기가 PJT ROUTE - PLANT ASSGIN의 FROM TO 날짜외 구간에 입력되어 있는 경우
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'CFM_MKT_DEMAND_PLAN';
        P_LOAD_CFM_MKT_DEMAND_PLAN(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'CELL_PROD_SITE_ID';
        P_LOAD_CELL_PROD_SITE_ID;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_SCP_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE;
        DELETE FROM GT_0039_PR_NOT_EXISTS;
        DELETE FROM GT_0039_SCP_PLAN_VERSION;
        DELETE FROM GT_0039_CELL_PROD_ASSY_MAP;
        DELETE FROM GT_0039_SCP_PROD_PLAN;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(CASE WHEN NVL(E.RN, 1) = 1 THEN A.QTY ELSE 0 END)  AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE   /* 2025.08.14 추가 */
             , E.CELL_PROD_SITE_ID
             , E.COMPANY_ID                   AS COMPANY_ID_CELL_PROD
             , E.SITE_ID                      AS SITE_ID_CELL_PROD
             , E.PLANT_ID                     AS PLANT_ID_CELL_PROD
          FROM DM_PLN_MKT_FCST           A
             , SCM_MST_SITE              B
             , SCP_MST_FINAL_ITEM        C
             , GT_0039_AS_SITE_PLANT     D
             , GT_0039_CFM_MKT_DMND_PLAN E
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PROJECT_CODE(+)  = A.PROJECT_CODE
           AND E.SCM_SITE_ID(+)   = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.DOM_EXP(+)       = A.DOM_EXP
           AND E.FCST_TYPE(+)     = A.FCST_TYPE
           AND E.INCOTERMS(+)     = A.INCOTERMS
           AND E.MEASURE(+)       = A.MEASURE
           AND E.YYYYMMDD(+)      = A.YYYYMMDD
           AND E.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL
         GROUP BY A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , E.CELL_PROD_SITE_ID
                , E.COMPANY_ID
                , E.SITE_ID
                , E.PLANT_ID;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM                                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_BOM';
        INSERT INTO GT_0039_SCP_BOM
        (
            MODEL_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN C.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE C.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
             , SCM_MST_ITEM_SN     D   /* PJ20257329 2025.08.26 parent item master active 'Y'만 참조 */
         WHERE B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'   /* Cell Assy 제외 */
           AND C.OPERATION_GROUP != 'E'      /* 전극 제외 */
           AND D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_SCP_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT ROUTE - 40/82 소형과 ESS는 Sales site 및 project Code 값이 없음 ('-')             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE';
        INSERT INTO GT_0039_PROJECT_ROUTE
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , PLANT_SITE_ID
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.PLANT_SITE_ID
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND B.OPERATION_GROUP != 'W'   /* AS plant site 제외 */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST 기준 Project Route 존재하지 않는 데이터                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PR_NOT_EXISTS';
        INSERT INTO GT_0039_PR_NOT_EXISTS
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.MF_LAST_UPDATE_DATE
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , B.CHILD_ITEM_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , 'PR001'                                       AS MASTER_INVLD_CD
             , 'Sales Period:' || A.SALES_FROM_YYYYMMDD || '~' || A.SALES_TO_YYYYMMDD
            || ', Child Item:' || B.CHILD_ITEM_ID
            || ', FCST Last Update :' || A.MF_LAST_UPDATE_DATE  AS MASTER_INVLD_CTN   /* 2025.08.14 수요 최종 변경일 추가 */
          FROM GT_0039_MKT_FCST A
             , GT_0039_SCP_BOM  B
         WHERE B.MODEL_ID = A.SALES_ITEM_ID
           /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XA
                             WHERE XA.ITEM_ID = B.CHILD_ITEM_ID
                               AND XA.PLANT_SITE_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                                           THEN A.CELL_PROD_SITE_ID
                                                           ELSE XA.PLANT_SITE_ID
                                                      END
                               AND XA.PROJECT_CODE  = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.PROJECT_CODE
                                                      END
                               AND XA.SALES_SITE_ID = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.SALES_SITE_ID
                                                      END );
        P_GATHER('GT_0039_PR_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* SCP Plan 버전 정보                                                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PLAN_VERSION';
        INSERT INTO GT_0039_SCP_PLAN_VERSION
        (
            DIVISION_ID
          , PLAN_TYPE
          , PLAN_SEQ
          , PLAN_START_YYYYMMDD
          , HORIZON_END_DATE
          , PLAN_STATUS
          , CONFIRM_FLAG
          , PLAN_PRIORITY
        )
        SELECT IA.DIVISION_ID
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IA.PLAN_START_YYYYMMDD
             , IA.HORIZON_END_DATE
             , IA.PLAN_STATUS
             , IA.CONFIRM_FLAG
             , IA.PLAN_PRIORITY
          FROM ( SELECT A.DIVISION_ID
                      , B.PLAN_TYPE
                      , B.PLAN_SEQ
                      , A.PLAN_NAME                            AS PLAN_START_YYYYMMDD
                      , SUBSTR(A.HORIZON_END_DATE, 1, 8)       AS HORIZON_END_DATE
                      , B.PLAN_STATUS
                      , B.CONFIRM_FLAG
                      , DENSE_RANK() OVER (PARTITION BY A.DIVISION_ID
                                               ORDER BY A.PLAN_NAME DESC
                                                      , B.INPUT_START_DATE DESC)  AS PLAN_PRIORITY
                   FROM SCM_MST_PLAN        A
                      , SCM_MST_PLAN_DETAIL B
                  WHERE B.DIVISION_ID = A.DIVISION_ID
                    AND B.PLAN_ID     = A.PLAN_ID
                    AND B.PLAN_STATUS = '1'   /* 정상 완료 */
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.PLAN_CYCLE  = 'WEEKLY'
                    AND A.PLAN_NAME   = V_FROM_YYYYMMDD ) IA
         WHERE IA.PLAN_PRIORITY = 1;
        P_GATHER('GT_0039_SCP_PLAN_VERSION');

        /* 계획 버전은 PLAN_PRIORITY = 1 로 한 건이다. GTT 와 조인하면 대용량 파티션 테이블에
           파티션 프루닝이 걸리지 않아 조회가 폭주하므로, 값을 변수로 받아 상수 조건으로 준다. */
        SELECT MAX(DIVISION_ID)
             , MAX(PLAN_TYPE)
             , MAX(PLAN_SEQ)
             , MAX(PLAN_START_YYYYMMDD)
             , MAX(HORIZON_END_DATE)
          INTO V_PLAN_DIVISION
             , V_PLAN_TYPE
             , V_PLAN_SEQ
             , V_PLAN_START
             , V_HORIZON_END
          FROM GT_0039_SCP_PLAN_VERSION;


        /* ---------------------------------------------------------------------------------------- */
        /* Cell Assy/Prod Mapping 정보                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'CELL_PROD_ASSY_MAP';
        INSERT INTO GT_0039_CELL_PROD_ASSY_MAP
        (
            ITEM_ID_ASSY
          , ITEM_ID_PROD
          , ITEM_ID_PROD_NICK_NAME
        )
        SELECT A.ITEM_ID_ASSY
             , MAX(A.ITEM_ID_PROD)  AS ITEM_ID_PROD
             , MAX(B.NICK_NAME)     AS ITEM_ID_PROD_NICK_NAME
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
             , SCP_MST_FINAL_ITEM         B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID_PROD
           AND B.FLOW_ID LIKE 'A%'
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
         GROUP BY A.ITEM_ID_ASSY;
        P_GATHER('GT_0039_CELL_PROD_ASSY_MAP');

        /* ---------------------------------------------------------------------------------------- */
        /* Project Route 기간 범위 밖의 생산계획                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PROD_PLAN';
        INSERT INTO GT_0039_SCP_PROD_PLAN
        (
            ITEM_ID
          , PLANT_SITE_ID
          , OPERATION_GROUP
          , OPERATION_ID
          , LINE_ID
          , PROD_FROM_YYYYMMDD
          , PROD_TO_YYYYMMDD
          , QTY
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT B.ITEM_ID
             , B.SCM_SITE_ID        AS PLANT_SITE_ID
             , B.OPERATION_GROUP
             , B.OPERATION_ID
             , B.LINE_ID
             , MIN(B.YYYYMMDD)      AS PROD_FROM_YYYYMMDD
             , MAX(B.YYYYMMDD)      AS PROD_TO_YYYYMMDD
             , SUM(B.QTY)           AS QTY
             , 'PR002'              AS MASTER_INVLD_CD
             , 'Min:'        || MIN(B.YYYYMMDD)
            || ', Max:'      || MAX(B.YYYYMMDD)
            || ', Cell Assy:'|| B.ITEM_ID                       AS MASTER_INVLD_CTN   /* 상세내용 */
          FROM SCP_ANL_PRODUCTION_PLAN B
         WHERE B.DIVISION_ID         = V_PLAN_DIVISION
           AND B.PLAN_START_YYYYMMDD = V_PLAN_START
           AND B.PLAN_TYPE           = V_PLAN_TYPE
           AND B.SEQ                 = V_PLAN_SEQ
           AND B.YYYYMMDD           <= V_HORIZON_END
           AND B.MEASURE = 'PROD_PLAN_AMEND'
           AND B.QTY > 0
           AND EXISTS ( SELECT 1
                          FROM GT_0039_PROJECT_ROUTE XA
                         WHERE XA.ITEM_ID       = B.ITEM_ID
                           AND XA.PLANT_SITE_ID = B.SCM_SITE_ID )   /* 생산 Plant 정보 존재 */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XB
                             WHERE XB.ITEM_ID       = B.ITEM_ID
                               AND XB.PLANT_SITE_ID = B.SCM_SITE_ID
                               AND B.YYYYMMDD BETWEEN XB.FROM_YYYYMMDD AND XB.TO_YYYYMMDD )  /* Project Route 범위 밖 기간의 생산계획 정보 */
         GROUP BY B.ITEM_ID
                , B.SCM_SITE_ID
                , B.OPERATION_GROUP
                , B.OPERATION_ID
                , B.LINE_ID;
        P_GATHER('GT_0039_SCP_PROD_PLAN');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT_ROUTE 확인 대상 전체 데이터                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        /* Project Route 미등록 */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , A.SALES_ITEM_ID      AS MODEL_ID
             , A.MODEL_NICK_NAME    AS NICK_NAME
             , A.MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.PROJECT_CODE       AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
               /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
            || CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND A.CHILD_OPERATION_GROUP = 'A'
                    THEN ' ,Cell Prod Site : ' || C.NAME
                    ELSE ''
               END                  AS MASTER_INVLD_CTN
          FROM GT_0039_PR_NOT_EXISTS       A
             , SCM_MST_SITE                B
             , GT_0039_CELL_PROD_SITE_ID   C
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.SCM_SITE_ID = A.SALES_SITE_ID
           AND C.CODE(+)     = A.CELL_PROD_SITE_ID
         UNION ALL
        /* 범위 밖 생산계획 */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , CASE WHEN A.OPERATION_GROUP = 'P'
                    THEN A.ITEM_ID
                    ELSE C.ITEM_ID_PROD
               END                  AS MODEL_ID
             , C.ITEM_ID_PROD_NICK_NAME  AS NICK_NAME
             , A.MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.OPERATION_ID       AS PROJECT_OPERATION
             , A.LINE_ID            AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_SCP_PROD_PLAN      A
             , SCM_MST_SITE               B
             , GT_0039_CELL_PROD_ASSY_MAP C
         WHERE B.DIVISION_ID   = V_DIVISION_ID
           AND B.SCM_SITE_ID   = A.PLANT_SITE_ID
           AND C.ITEM_ID_ASSY(+) = A.ITEM_ID;
        P_GATHER('GT_0039_TARGET_DATA');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT ROUTE 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , C.BASIC_NICK_NAME    AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA  A
             , SCP_MST_FINAL_ITEM   B
             , SCP_MST_ITEM_BSI_IFO C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.ITEM_ID(+)  = CASE WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                    ELSE A.MODEL_ID
                               END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT DISTINCT   /* PJ20257329 2025.09.12 중복 제거 */
                   A.DIVISION_ID
                 , A.MODEL_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , A.MODEL_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_PROJECT_ROUTE;


    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_OUTSOURCING_CAPACITY                                    */
    /* Description : 외주 Capacity 조회                                                             */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_OS_CAPACITY
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := '40';   /* AS-IS 원문 그대로 : @p_division_id 가 아니라 '40' 고정 - 40만 조회 김도형선임 (2025.07.15) */
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'CFM_MKT_DEMAND_PLAN';
        P_LOAD_CFM_MKT_DEMAND_PLAN(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'CELL_PROD_SITE_ID';
        P_LOAD_CELL_PROD_SITE_ID;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_SCP_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE;
        DELETE FROM GT_0039_PR_NOT_EXISTS;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(CASE WHEN NVL(E.RN, 1) = 1 THEN A.QTY ELSE 0 END)  AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE
             , E.CELL_PROD_SITE_ID
             , E.COMPANY_ID                   AS COMPANY_ID_CELL_PROD
             , E.SITE_ID                      AS SITE_ID_CELL_PROD
             , E.PLANT_ID                     AS PLANT_ID_CELL_PROD
          FROM DM_PLN_MKT_FCST           A
             , SCM_MST_SITE              B
             , SCP_MST_FINAL_ITEM        C
             , GT_0039_AS_SITE_PLANT     D
             , GT_0039_CFM_MKT_DMND_PLAN E
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PROJECT_CODE(+)  = A.PROJECT_CODE
           AND E.SCM_SITE_ID(+)   = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.DOM_EXP(+)       = A.DOM_EXP
           AND E.FCST_TYPE(+)     = A.FCST_TYPE
           AND E.INCOTERMS(+)     = A.INCOTERMS
           AND E.MEASURE(+)       = A.MEASURE
           AND E.YYYYMMDD(+)      = A.YYYYMMDD
           AND E.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL
         GROUP BY A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , E.CELL_PROD_SITE_ID
                , E.COMPANY_ID
                , E.SITE_ID
                , E.PLANT_ID;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM                                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_BOM';
        INSERT INTO GT_0039_SCP_BOM
        (
            MODEL_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , CELL_TYPE
          , CHILD_NICK_NAME
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.CHILD_ITEM_ID
             , C.OPERATION_GROUP        AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , C.ATTRIBUTE8             AS CELL_TYPE
             , C.NICK_NAME              AS CHILD_NICK_NAME
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
             , SCM_MST_ITEM_SN     D
         WHERE B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'
           AND C.OPERATION_GROUP != 'E'
           AND D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_SCP_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT ROUTE                                                                             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE';
        INSERT INTO GT_0039_PROJECT_ROUTE
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , PLANT_SITE_ID
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , COUNTRY
          , CITY
          , OSP_YN
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.PLANT_SITE_ID
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , B.COUNTRY
             , B.CITY
             , B.OSP_YN
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST 기준 Project Route 존재하지 않는 데이터                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PR_NOT_EXISTS';
        INSERT INTO GT_0039_PR_NOT_EXISTS
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.MF_LAST_UPDATE_DATE
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , B.CHILD_ITEM_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , 'COM01'                                        AS MASTER_INVLD_CD
             , 'Target Item :' || A.SALES_ITEM_ID
            || ', FCST Last Update :' || A.MF_LAST_UPDATE_DATE AS MASTER_INVLD_CTN   /* 2025.08.14 수요 최종 변경일 추가 */
          FROM GT_0039_MKT_FCST A
             , GT_0039_SCP_BOM  B
         WHERE B.MODEL_ID = A.SALES_ITEM_ID
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND B.CHILD_OPERATION_GROUP != 'E'
           AND NVL(B.CELL_TYPE, ' ') NOT LIKE 'CA%'
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XA
                             WHERE XA.ITEM_ID = B.CHILD_ITEM_ID
                               AND XA.SALES_SITE_ID = CASE WHEN V_DIVISION_ID IN ('40', '82')
                                                           THEN '-'
                                                           ELSE A.SALES_SITE_ID
                                                      END
                               AND XA.PROJECT_CODE  = CASE WHEN V_DIVISION_ID IN ('40', '82')
                                                           THEN '-'
                                                           ELSE A.PROJECT_CODE
                                                      END );
        P_GATHER('GT_0039_PR_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST / Project Route 기준 외주 Capa 존재하지 않는 경우                                */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , MASTER_INVLD_MSG
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        /* Project Route 미등록 */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , A.SALES_ITEM_ID      AS MODEL_ID
             , A.MODEL_NICK_NAME    AS NICK_NAME
             , A.MASTER_INVLD_CD
             , C.ATTRIBUTE2         AS MASTER_INVLD_MSG
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.PROJECT_CODE       AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_PR_NOT_EXISTS        A
             , SCM_MST_SITE                 B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.SCM_SITE_ID = A.SALES_SITE_ID
           AND C.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
           AND C.SEGMENT1(+)    = A.MASTER_INVLD_CD
           AND C.VALID_YN(+)    = 'Y'
         UNION ALL
        /*
        2) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
           해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
         >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우
        */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , IA.SALES_ITEM_ID     AS MODEL_ID
             , IA.MODEL_NICK_NAME   AS NICK_NAME
             , C.SEGMENT1           AS MASTER_INVLD_CD
             , C.ATTRIBUTE2         AS MASTER_INVLD_MSG
             , IA.PLANT_SITE        AS SALES_PLANT_SITE
             , NULL                 AS PROJECT_OPERATION
             , IA.INCOTERMS         AS INCOTERMS_LINE
             , IA.QTY
             , IA.MASTER_INVLD_CTN
          FROM ( SELECT DISTINCT
                        A.SALES_ITEM_ID
                      , A.SALES_SITE_ID
                      , A.INCOTERMS
                      , A.MODEL_NICK_NAME
                      , A.QTY
                      , A.SALES_FROM_YYYYMMDD
                      , A.SALES_TO_YYYYMMDD
                      , B.PLANT_SITE_ID
                      , C.SITE_DESCRIPTION  AS PLANT_SITE
                      , B.ITEM_ID
                      , B.COUNTRY
                      , B.CITY
                      , 'SalesSite:' || A.SALES_SITE_ID  AS MASTER_INVLD_CTN   /* 상세내용 */
                   FROM GT_0039_MKT_FCST      A
                      , GT_0039_PROJECT_ROUTE B
                      , SCM_MST_SITE          C
                  WHERE B.ITEM_ID = A.SALES_ITEM_ID
                    /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
                    AND B.PLANT_SITE_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND A.MODEL_OPERATION_GROUP = 'A'
                                               THEN A.CELL_PROD_SITE_ID
                                               ELSE B.PLANT_SITE_ID
                                          END
                    AND C.DIVISION_ID = V_DIVISION_ID
                    AND C.SCM_SITE_ID = B.PLANT_SITE_ID
                    AND C.OSP_YN      = 'Y'
                    AND C.VALID_YN    = 'Y'
                    AND NVL(C.ATTRIBUTE1, 'N') != 'Y'   /* ESS 외주 Pakcer Line 생산 Target 적용 */
                    AND NOT EXISTS ( SELECT 1
                                       FROM SCP_MST_OUTSOURCING_CAPA XA   /* DIVISION_ID, PLANT_SITE_ID, ITEM_ID */
                                      WHERE XA.DIVISION_ID   = C.DIVISION_ID
                                        AND XA.PLANT_SITE_ID = B.PLANT_SITE_ID
                                        AND XA.ITEM_ID       = B.ITEM_ID
                                        AND XA.DAILY_CAPA_QTY != 0 ) ) IA
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
         WHERE C.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
           AND C.SEGMENT1(+)    = 'OC002'
           AND C.VALID_YN(+)    = 'Y';
        P_GATHER('GT_0039_TARGET_DATA');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , C.BASIC_NICK_NAME    AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA  A
             , SCP_MST_FINAL_ITEM   B
             , SCP_MST_ITEM_BSI_IFO C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.ITEM_ID(+)  = CASE WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                    ELSE A.MODEL_ID
                               END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , A.MODEL_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_OS_CAPACITY;

    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_TACT_TIME_OSP                                           */
    /* Description : 외주 Tact Time 조회                                                            */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_TACT_TIME_OSP
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := '82';   /* AS-IS 원문 그대로 : @p_division_id 가 아니라 '82' 고정 - 김도형선임 (2025.07.15) */
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_SCP_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE;
        DELETE FROM GT_0039_PR_NOT_EXISTS;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(A.QTY)                     AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE   /* 2025.08.14 추가 */
          FROM DM_PLN_MKT_FCST        A
             , SCM_MST_SITE           B
             , SCP_MST_FINAL_ITEM     C
             , GT_0039_AS_SITE_PLANT  D   /* PJ20257329 2025.09.05 AS Sales Site 제외 */
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           /* ??AND FI.OPERATION_GROUP = 'P'  -- ESS Pack */
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL
         GROUP BY A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM                                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_BOM';
        INSERT INTO GT_0039_SCP_BOM
        (
            MODEL_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , CELL_TYPE
          , CHILD_NICK_NAME
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.CHILD_ITEM_ID
             , C.OPERATION_GROUP        AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , C.ATTRIBUTE8             AS CELL_TYPE
             , C.NICK_NAME              AS CHILD_NICK_NAME
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     D   /* PJ20257329 2025.08.26 parent item master active 'Y'만 참조 */
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
         WHERE D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'   /* Cell Assy 제외 */
           AND C.OPERATION_GROUP != 'E'      /* 전극 제외 */
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE XA.SALES_ITEM_ID = A.MODEL_ID );
        P_GATHER('GT_0039_SCP_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT ROUTE - 40/82 소형과 ESS는 Sales site 및 project Code 값이 없음 ('-')             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE';
        INSERT INTO GT_0039_PROJECT_ROUTE
        (
            ITEM_ID
          , PLANT_SITE_ID
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , COUNTRY
          , CITY
          , OSP_YN
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.PLANT_SITE_ID
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , B.COUNTRY
             , B.CITY
             , B.OSP_YN
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST 기준 Project Route 존재하지 않는 데이터                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PR_NOT_EXISTS';
        INSERT INTO GT_0039_PR_NOT_EXISTS
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.MF_LAST_UPDATE_DATE
             , B.CHILD_ITEM_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , 'COM01'                                        AS MASTER_INVLD_CD
             , 'Target Item :' || A.SALES_ITEM_ID
            || ', FCST Last Update :' || A.MF_LAST_UPDATE_DATE AS MASTER_INVLD_CTN   /* 2025.08.14 수요 최종 변경일 추가 */
          FROM GT_0039_MKT_FCST A
             , GT_0039_SCP_BOM  B
         WHERE A.SALES_ITEM_ID = B.MODEL_ID
           AND B.CHILD_OPERATION_GROUP != 'E'
           AND NVL(B.CELL_TYPE, ' ') NOT LIKE 'CA%'
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XA
                             WHERE XA.ITEM_ID = B.CHILD_ITEM_ID );
        P_GATHER('GT_0039_PR_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터                                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        /* Project Route 미등록 */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , A.SALES_ITEM_ID      AS MODEL_ID
             , A.MODEL_NICK_NAME    AS NICK_NAME
             , A.MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.PROJECT_CODE       AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_PR_NOT_EXISTS A
             , SCM_MST_SITE          B
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.SCM_SITE_ID = A.SALES_SITE_ID
         UNION ALL
        /*
        2) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
           해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
         >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우
        */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , IA.SALES_ITEM_ID     AS MODEL_ID
             , IA.MODEL_NICK_NAME   AS NICK_NAME
             , 'TTO02'              AS MASTER_INVLD_ID
             , IA.PLANT_SITE        AS SALES_PLANT_SITE
             , NULL                 AS PROJECT_OPERATION
             , IA.INCOTERMS         AS INCOTERMS_LINE
             , IA.QTY
             , IA.MASTER_INVLD_CTN
          FROM ( SELECT DISTINCT
                        A.SALES_ITEM_ID
                      , A.SALES_SITE_ID
                      , A.INCOTERMS
                      , A.MODEL_NICK_NAME
                      , A.QTY
                      , A.SALES_FROM_YYYYMMDD
                      , A.SALES_TO_YYYYMMDD
                      , B.PLANT_SITE_ID
                      , C.SITE_DESCRIPTION  AS PLANT_SITE
                      , B.ITEM_ID
                      , B.COUNTRY
                      , B.CITY
                      , 'SalesSite:' || A.SALES_SITE_ID  AS MASTER_INVLD_CTN   /* 상세내용 */
                   FROM GT_0039_MKT_FCST      A
                      , GT_0039_PROJECT_ROUTE B
                      , SCM_MST_SITE          C
                  WHERE B.ITEM_ID   = A.SALES_ITEM_ID
                    AND C.DIVISION_ID = V_DIVISION_ID
                    AND C.SCM_SITE_ID = B.PLANT_SITE_ID
                    AND C.OSP_YN      = 'Y'   /* OSP 외주 */
                    AND C.VALID_YN    = 'Y'
                    AND NOT EXISTS ( SELECT 1
                                       FROM SCP_MST_TACT_TIME_OSP XA
                                      WHERE XA.DIVISION_ID   = C.DIVISION_ID
                                        AND XA.PLANT_SITE_ID = B.PLANT_SITE_ID
                                        AND XA.ITEM_ID       = B.ITEM_ID
                                        AND XA.TACT_TIME != 0 ) ) IA;
        P_GATHER('GT_0039_TARGET_DATA');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , C.BASIC_NICK_NAME    AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA  A
             , SCP_MST_FINAL_ITEM   B
             , SCP_MST_ITEM_BSI_IFO C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.ITEM_ID(+)  = CASE WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                    ELSE A.MODEL_ID
                               END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , A.MODEL_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_TACT_TIME_OSP;


    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_PROJECT_ROUTE_ELEC                                      */
    /* Description : 전극 Project Route 조회                                                        */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2025/08/20  hrkim   PJ20257329 유효 라인/SCP Plan Operation 범위 제한                         */
    /* 2025/09/12  hrkim   PJ20257329 소형 Cell Prod Site 적용                                       */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_PR_ELEC
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

/*
--================================================================================================================================
2) CURRENT PROD AMEND 에 입력되어 있는 '모델'/'PLANT'/'생산계획날짜' 정보를 기반으로
 >> 생산계획 시기가 PJT ROUTE - PLANT ASSGIN의 FROM TO 날짜외 구간에 입력되어 있는 경우
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'CFM_MKT_DEMAND_PLAN';
        P_LOAD_CFM_MKT_DEMAND_PLAN(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_MKT_FCST_MDL_CELL_BOM;
        DELETE FROM GT_0039_CELL_PROD_ASSY_MAP;
        DELETE FROM GT_0039_LINE_ASSIGN_CELL;
        DELETE FROM GT_0039_LINE_ASSIGN_CELL_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE;
        DELETE FROM GT_0039_PRE_NOT_EXISTS;
        DELETE FROM GT_0039_SCP_PLAN_VERSION;
        DELETE FROM GT_0039_SCP_PROD_PLAN;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(CASE WHEN NVL(E.RN, 1) = 1 THEN A.QTY ELSE 0 END)  AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE
             , E.CELL_PROD_SITE_ID
             , E.COMPANY_ID                   AS COMPANY_ID_CELL_PROD
             , E.SITE_ID                      AS SITE_ID_CELL_PROD
             , E.PLANT_ID                     AS PLANT_ID_CELL_PROD
          FROM DM_PLN_MKT_FCST           A
             , SCM_MST_SITE              B
             , SCP_MST_FINAL_ITEM        C
             , GT_0039_AS_SITE_PLANT     D
             , GT_0039_CFM_MKT_DMND_PLAN E
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND C.OPERATION_GROUP != 'E'   /* 전극 제외 */
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PROJECT_CODE(+)  = A.PROJECT_CODE
           AND E.SCM_SITE_ID(+)   = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.DOM_EXP(+)       = A.DOM_EXP
           AND E.FCST_TYPE(+)     = A.FCST_TYPE
           AND E.INCOTERMS(+)     = A.INCOTERMS
           AND E.MEASURE(+)       = A.MEASURE
           AND E.YYYYMMDD(+)      = A.YYYYMMDD
           AND E.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL
         GROUP BY A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , E.CELL_PROD_SITE_ID
                , E.COMPANY_ID
                , E.SITE_ID
                , E.PLANT_ID;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT_FCST 기준 Model Cell BOM                                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST_MDL_CELL_BOM';
        INSERT INTO GT_0039_MKT_FCST_MDL_CELL_BOM
        (
            MODEL_ID
          , CHILD_COMPANY_ID
          , CHILD_SITE_ID
          , CHILD_PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.CHILD_COMPANY_ID
             , A.CHILD_SITE_ID
             , A.CHILD_PLANT_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN C.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE C.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     D   /* PJ20257329 2025.08.26 parent item master active 'Y'만 참조 */
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
         WHERE D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'   /* Cell Assy 제외 */
           AND C.OPERATION_GROUP = 'A'       /* Cell */
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_MKT_FCST_MDL_CELL_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* Cell Assy/Prod Mapping 정보                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'CELL_PROD_ASSY_MAP';
        INSERT INTO GT_0039_CELL_PROD_ASSY_MAP
        (
            ITEM_ID_ASSY
          , ITEM_ID_PROD
          , ITEM_ID_PROD_NICK_NAME
        )
        SELECT A.ITEM_ID_ASSY
             , MAX(A.ITEM_ID_PROD)  AS ITEM_ID_PROD
             , MAX(B.NICK_NAME)     AS ITEM_ID_PROD_NICK_NAME
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
             , SCP_MST_FINAL_ITEM         B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID_PROD
           AND B.FLOW_ID LIKE 'A%'
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST_MDL_CELL_BOM XA
                         WHERE XA.CHILD_ITEM_ID = A.ITEM_ID_PROD )   /* MKT FCST 기준 생산 대상 Cell Model */
         GROUP BY A.ITEM_ID_ASSY;
        P_GATHER('GT_0039_CELL_PROD_ASSY_MAP');

        /* ---------------------------------------------------------------------------------------- */
        /* Line Assign 된 Cell 모델 (Cell Product 기준)                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_ASSIGN_CELL';
        INSERT INTO GT_0039_LINE_ASSIGN_CELL
        (
            COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , CELL_MODEL_ID
          , CELL_NICK_NAME
          , FROM_ASSIGNED_MONTH
          , TO_ASSIGNED_MONTH
        )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , C.ITEM_ID_PROD       AS CELL_MODEL_ID
             , MAX(B.NICK_NAME)     AS CELL_NICK_NAME
             , MIN(A.MONTH)         AS FROM_ASSIGNED_MONTH   /* 2025.07.09 */
             , MIN(A.MONTH)         AS TO_ASSIGNED_MONTH     /* 2025.07.09 */
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN A
             , SCP_MST_FINAL_ITEM          B
             , GT_0039_CELL_PROD_ASSY_MAP  C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND B.OPERATION_GROUP = 'A'
           AND C.ITEM_ID_ASSY = A.ITEM_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
           AND A.ACTIVE_FLAG = 'Y'
           AND A.PRIORITY NOT IN ('0', '9')
           /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST_MDL_CELL_BOM XA
                         WHERE XA.CHILD_ITEM_ID    = C.ITEM_ID_PROD
                           AND XA.CHILD_COMPANY_ID = A.COMPANY_ID
                           AND XA.CHILD_SITE_ID    = A.SITE_ID
                           AND XA.CHILD_PLANT_ID   = A.PLANT_ID )
         GROUP BY A.COMPANY_ID
                , A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , C.ITEM_ID_PROD;
        P_GATHER('GT_0039_LINE_ASSIGN_CELL');

        /* ---------------------------------------------------------------------------------------- */
        /* 라인 Assign 된 Cell Model BOM (셀-전극)                                                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_ASSIGN_CELL_BOM';
        INSERT INTO GT_0039_LINE_ASSIGN_CELL_BOM
        (
            MODEL_ID
          , PLANT_ID
          , CHILD_COMPANY_ID
          , CHILD_DIVISION_ID
          , CHILD_SITE_ID
          , CHILD_PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , ELEC_NICK_NAME
          , FROM_ASSIGNED_MONTH
          , TO_ASSIGNED_MONTH
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.PLANT_ID
             , A.CHILD_COMPANY_ID
             , A.CHILD_DIVISION_ID
             , A.CHILD_SITE_ID
             , A.CHILD_PLANT_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN C.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE C.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , C.NICK_NAME              AS ELEC_NICK_NAME
             , B.FROM_ASSIGNED_MONTH    /* 7/9 추가 */
             , B.TO_ASSIGNED_MONTH      /* 7/9 추가 */
          FROM SCM_MST_MODEL_BOM        A
             , GT_0039_LINE_ASSIGN_CELL B
             , SCM_MST_ITEM_SN          D
             , SCP_MST_FINAL_ITEM       C
             , SCM_MST_ITEM_SN          E   /* PJ20257329 2025.08.26 parent item master active 'Y'만 참조 */
         WHERE B.COMPANY_ID    = A.COMPANY_ID
           AND B.DIVISION_ID   = A.DIVISION_ID
           AND B.SITE_ID       = A.SITE_ID
           AND B.PLANT_ID      = A.PLANT_ID
           AND B.CELL_MODEL_ID = A.MODEL_ID
           AND D.ITEM_ID     = A.CHILD_ITEM_ID
           AND D.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND D.DIVISION_ID = A.CHILD_DIVISION_ID
           AND D.SITE_ID     = A.CHILD_SITE_ID
           AND D.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'   /* Cell Assy 제외 */
           AND C.OPERATION_GROUP = 'E'       /* Child 전극 */
           AND E.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND E.COMPANY_ID(+)  = A.COMPANY_ID
           AND E.DIVISION_ID(+) = A.DIVISION_ID
           AND E.SITE_ID(+)     = A.SITE_ID
           AND E.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR E.ITEM_ID IS NOT NULL);
        P_GATHER('GT_0039_LINE_ASSIGN_CELL_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* 전극 PROJECT ROUTE                                                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE';
        INSERT INTO GT_0039_PROJECT_ROUTE
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , PLANT_SITE_ID
          , PLANT_ID
          , COMPANY_ID
          , SITE_ID
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , A.PLANT_SITE_ID
             , B.PLANT_ID
             , B.COMPANY_ID
             , B.SITE_ID
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND B.OPERATION_GROUP = 'E'   /* 전극 Plant Site */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE');

        /* ---------------------------------------------------------------------------------------- */
        /* Line Assign Cell 기준 전극 Project Route 가 없는 데이터                                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PRE_NOT_EXISTS';
        INSERT INTO GT_0039_PRE_NOT_EXISTS
        (
            MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
        )
        SELECT A.CHILD_ITEM_ID       AS MODEL_ID   /* 전극 */
             , A.ELEC_NICK_NAME      AS NICK_NAME
             , 'PRE01'               AS MASTER_INVLD_CD
             , 'Assigned Period: ' || A.FROM_ASSIGNED_MONTH || '~' || A.TO_ASSIGNED_MONTH
            || ', Cell Model:'      || A.MODEL_ID                       AS MASTER_INVLD_CTN   /* 상세내용 */
             , B.SITE_DESCRIPTION    AS SALES_PLANT_SITE   /* Cell Plant Site */
             , A.CHILD_OPERATION_ID  AS PROJECT_OPERATION
             , NULL                  AS INCOTERMS_LINE
             , NULL                  AS QTY
          FROM GT_0039_LINE_ASSIGN_CELL_BOM A
             , SCM_MST_SITE                 B
         WHERE B.DIVISION_ID = V_DIVISION_ID   /* Cell model 기준 Division */
           AND B.SCM_SITE_ID = A.PLANT_ID || '-' || 'A'   /* Cell 기준 Plant 사이트 */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XA
                             WHERE XA.ITEM_ID = A.CHILD_ITEM_ID );   /* 전극 */

        /* ---------------------------------------------------------------------------------------- */
        /* 전극 SCP Plan 버전 정보                                                                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PLAN_VERSION';
        P_GATHER('GT_0039_PRE_NOT_EXISTS');
        INSERT INTO GT_0039_SCP_PLAN_VERSION
        (
            ORIGIN_DIVISION_ID
          , DIVISION_ID
          , PLAN_TYPE
          , PLAN_SEQ
          , PLAN_START_YYYYMMDD
          , HORIZON_END_DATE
          , PLAN_STATUS
          , CONFIRM_FLAG
          , PLAN_PRIORITY
        )
        SELECT V_DIVISION_ID  AS ORIGIN_DIVISION_ID
             , IA.DIVISION_ID
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IA.PLAN_START_YYYYMMDD
             , IA.HORIZON_END_DATE
             , IA.PLAN_STATUS
             , IA.CONFIRM_FLAG
             , IA.PLAN_PRIORITY
          FROM ( SELECT C.DIVISION_ID
                      , D.PLAN_TYPE
                      , D.PLAN_SEQ
                      , C.PLAN_NAME                            AS PLAN_START_YYYYMMDD
                      , SUBSTR(C.HORIZON_END_DATE, 1, 8)       AS HORIZON_END_DATE
                      , D.PLAN_STATUS
                      , D.CONFIRM_FLAG
                      , DENSE_RANK() OVER (PARTITION BY C.DIVISION_ID
                                               ORDER BY C.PLAN_NAME DESC
                                                      , D.INPUT_START_DATE DESC)  AS PLAN_PRIORITY
                   FROM SCM_MST_DIVISION    A
                      , SCM_MST_DIVISION    B
                      , SCM_MST_PLAN        C
                      , SCM_MST_PLAN_DETAIL D
                  WHERE A.VALID_YN   = 'Y'
                    AND B.ATTRIBUTE3 = 'EE'
                    AND B.ATTRIBUTE4 = A.ATTRIBUTE4
                    AND C.DIVISION_ID = B.DIVISION_ID   /* 전극 Division */
                    AND D.DIVISION_ID = C.DIVISION_ID
                    AND D.PLAN_ID     = C.PLAN_ID
                    AND D.PLAN_STATUS = '1'   /* 정상 완료 */
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND C.PLAN_CYCLE  = 'WEEKLY'
                    AND C.PLAN_NAME   = V_FROM_YYYYMMDD ) IA
         WHERE IA.PLAN_PRIORITY = 1;
        P_GATHER('GT_0039_SCP_PLAN_VERSION');

        /* 계획 버전은 PLAN_PRIORITY = 1 로 한 건이다. GTT 와 조인하면 대용량 파티션 테이블에
           파티션 프루닝이 걸리지 않아 조회가 폭주하므로, 값을 변수로 받아 상수 조건으로 준다. */
        SELECT MAX(DIVISION_ID)
             , MAX(PLAN_TYPE)
             , MAX(PLAN_SEQ)
             , MAX(PLAN_START_YYYYMMDD)
             , MAX(HORIZON_END_DATE)
          INTO V_PLAN_DIVISION
             , V_PLAN_TYPE
             , V_PLAN_SEQ
             , V_PLAN_START
             , V_HORIZON_END
          FROM GT_0039_SCP_PLAN_VERSION;


        /* ---------------------------------------------------------------------------------------- */
        /* Project Route 기간 범위 밖의 전극 생산계획                                                */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PROD_PLAN_ELEC';
        INSERT INTO GT_0039_SCP_PROD_PLAN
        (
            DIVISION_ID
          , ORIGIN_DIVISION_ID
          , ITEM_ID
          , PLANT_SITE_ID
          , OPERATION_GROUP
          , OPERATION_ID
          , LINE_ID
          , PROD_FROM_YYYYMMDD
          , PROD_TO_YYYYMMDD
          , QTY
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT B.DIVISION_ID         AS EE_DIVISION_ID
             , B.ORIGIN_DIVISION_ID  AS ORIGIN_DIVISION_ID
             , B.ITEM_ID
             , B.SCM_SITE_ID         AS PLANT_SITE_ID
             , B.OPERATION_GROUP
             , B.OPERATION_ID
             , B.LINE_ID
             , MIN(B.YYYYMMDD)       AS PROD_FROM_YYYYMMDD
             , MAX(B.YYYYMMDD)       AS PROD_TO_YYYYMMDD
             , SUM(B.QTY)            AS QTY
             , 'PRE02'               AS MASTER_INVLD_CD
             , 'Min:'   || MIN(B.YYYYMMDD)
            || ', Max:' || MAX(B.YYYYMMDD)                      AS MASTER_INVLD_CTN   /* 상세내용 */
          FROM SCP_ANL_PRODUCTION_PLAN B
         WHERE B.DIVISION_ID         = V_PLAN_DIVISION
           AND B.PLAN_START_YYYYMMDD = V_PLAN_START
           AND B.PLAN_TYPE           = V_PLAN_TYPE
           AND B.SEQ                 = V_PLAN_SEQ
           AND B.OPERATION_GROUP     = 'E'   /* 전극 생산계획 */
           AND B.YYYYMMDD           <= V_HORIZON_END
           AND B.ORIGIN_DIVISION_ID  = V_DIVISION_ID
           AND B.MEASURE = 'PROD_PLAN_AMEND'
           AND B.QTY > 0
           AND EXISTS ( SELECT 1
                          FROM GT_0039_PROJECT_ROUTE XA
                         WHERE XA.ITEM_ID       = B.ITEM_ID
                           AND XA.PLANT_SITE_ID = B.SCM_SITE_ID )   /* 생산 Plant 정보 존재 */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XB
                             WHERE XB.ITEM_ID       = B.ITEM_ID
                               AND XB.PLANT_SITE_ID = B.SCM_SITE_ID
                               AND B.YYYYMMDD BETWEEN XB.FROM_YYYYMMDD AND XB.TO_YYYYMMDD )
         GROUP BY B.DIVISION_ID
                , B.ORIGIN_DIVISION_ID
                , B.ITEM_ID
                , B.SCM_SITE_ID
                , B.OPERATION_GROUP
                , B.OPERATION_ID
                , B.LINE_ID;
        P_GATHER('GT_0039_SCP_PROD_PLAN');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터                                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        /* 전극 Project Route 미등록 */
        SELECT V_DIVISION_ID              AS DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , SUBSTR(A.INCOTERMS_LINE, 1, 100)  AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_PRE_NOT_EXISTS A
         UNION ALL
        /* 범위 밖 생산계획 */
        SELECT A.ORIGIN_DIVISION_ID       AS DIVISION_ID
             , A.ITEM_ID                  AS MODEL_ID   /* 전극 */
             , B.NICK_NAME                AS NICK_NAME
             , A.MASTER_INVLD_CD
             , C.SITE_DESCRIPTION         AS SALES_PLANT_SITE
             , A.OPERATION_ID             AS PROJECT_OPERATION
             , SUBSTR(A.LINE_ID, 1, 100)  AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_SCP_PROD_PLAN A
             , SCP_MST_FINAL_ITEM    B
             , SCM_MST_SITE          C
         WHERE B.DIVISION_ID = A.ORIGIN_DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.DIVISION_ID = A.ORIGIN_DIVISION_ID
           AND C.SCM_SITE_ID = A.PLANT_SITE_ID;
        P_GATHER('GT_0039_TARGET_DATA');

        V_STEP := '전극 Applied Cell Model';
        P_LOAD_ELEC_APPLIED_MODEL(V_DIVISION_ID);

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , D.BASIC_NICK_NAME    AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA        A
             , SCP_MST_FINAL_ITEM         B
             , GT_0039_ELEC_APPLIED_MODEL C
             , SCP_MST_ITEM_BSI_IFO       D
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.ITEM_ID(+)     = A.MODEL_ID
           AND D.ITEM_ID(+)     = CASE WHEN B.OPERATION_GROUP = 'E' THEN C.APPLIED_MODEL
                                       WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                       ELSE A.MODEL_ID
                                  END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , A.MODEL_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_PR_ELEC;

    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_LINE_ASSIGN                                             */
    /* Description : Line Assign 조회                                                               */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2025/08/20  hrkim   PJ20257329 유효 라인/SCP Plan Operation 범위 제한                         */
    /* 2025/09/12  hrkim   PJ20257329 소형 Cell Prod Site 적용, 중복 제거                            */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_LINE_ASSIGN
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'CFM_MKT_DEMAND_PLAN';
        P_LOAD_CFM_MKT_DEMAND_PLAN(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'CELL_PROD_SITE_ID';
        P_LOAD_CELL_PROD_SITE_ID;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_SCP_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE;
        DELETE FROM GT_0039_PR_NOT_EXISTS;
        DELETE FROM GT_0039_MKT_FCST_MDL_CELL_BOM;
        DELETE FROM GT_0039_CELL_PROD_ASSY_MAP;
        DELETE FROM GT_0039_TARGET_CASE2;
        DELETE FROM GT_0039_LINE_ASSIGN_CELL;
        DELETE FROM GT_0039_LINE_ASSIGN_CELL_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE_ELEC;
        DELETE FROM GT_0039_TARGET_CASE3;
        DELETE FROM GT_0039_SCP_PLAN_VERSION;
        DELETE FROM GT_0039_SCP_PROD_PLAN;
        DELETE FROM GT_0039_TARGET_CASE4;
        DELETE FROM GT_0039_TARGET_CASE5;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(CASE WHEN NVL(E.RN, 1) = 1 THEN A.QTY ELSE 0 END)  AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE
             , E.CELL_PROD_SITE_ID
             , E.COMPANY_ID                   AS COMPANY_ID_CELL_PROD
             , E.SITE_ID                      AS SITE_ID_CELL_PROD
             , E.PLANT_ID                     AS PLANT_ID_CELL_PROD
          FROM DM_PLN_MKT_FCST           A
             , SCM_MST_SITE              B
             , SCP_MST_FINAL_ITEM        C
             , GT_0039_AS_SITE_PLANT     D
             , GT_0039_CFM_MKT_DMND_PLAN E
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PROJECT_CODE(+)  = A.PROJECT_CODE
           AND E.SCM_SITE_ID(+)   = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.DOM_EXP(+)       = A.DOM_EXP
           AND E.FCST_TYPE(+)     = A.FCST_TYPE
           AND E.INCOTERMS(+)     = A.INCOTERMS
           AND E.MEASURE(+)       = A.MEASURE
           AND E.YYYYMMDD(+)      = A.YYYYMMDD
           AND E.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL
         GROUP BY A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , E.CELL_PROD_SITE_ID
                , E.COMPANY_ID
                , E.SITE_ID
                , E.PLANT_ID;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM                                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_BOM';
        INSERT INTO GT_0039_SCP_BOM
        (
            MODEL_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , CELL_TYPE
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.CHILD_ITEM_ID
             , C.OPERATION_GROUP        AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , C.ATTRIBUTE8             AS CELL_TYPE
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
             , SCM_MST_ITEM_SN     D
         WHERE B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND C.OPERATION_GROUP != 'E'   /* 전극 제외 */
           AND D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_SCP_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT ROUTE                                                                             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE';
        INSERT INTO GT_0039_PROJECT_ROUTE
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , PLANT_SITE_ID
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , COUNTRY
          , CITY
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.PLANT_SITE_ID
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , B.COUNTRY
             , B.CITY
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST 기준 Project Route 존재하지 않는 데이터                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PR_NOT_EXISTS';
        INSERT INTO GT_0039_PR_NOT_EXISTS
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.MF_LAST_UPDATE_DATE
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , B.CHILD_ITEM_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , 'COM01'                                        AS MASTER_INVLD_CD
             , 'Target Item:' || B.CHILD_ITEM_ID
            || ', FCST Last Update :' || A.MF_LAST_UPDATE_DATE AS MASTER_INVLD_CTN   /* 2025.08.13 수요 최종 변경일 추가 */
          FROM GT_0039_MKT_FCST A
             , GT_0039_SCP_BOM  B
         WHERE A.SALES_ITEM_ID = B.MODEL_ID
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND B.CHILD_OPERATION_GROUP != 'E'
           AND NVL(B.CELL_TYPE, ' ') NOT LIKE 'CA%'   /* Cell Assy 제외 */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XA
                             WHERE XA.ITEM_ID = B.CHILD_ITEM_ID
                               AND XA.PLANT_SITE_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                                           THEN A.CELL_PROD_SITE_ID
                                                           ELSE XA.PLANT_SITE_ID
                                                      END
                               AND XA.PROJECT_CODE  = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.PROJECT_CODE
                                                      END
                               AND XA.SALES_SITE_ID = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.SALES_SITE_ID
                                                      END );
        P_GATHER('GT_0039_PR_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* case 2 : MKT_FCST 기준 Model Cell BOM                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST_MDL_CELL_BOM';
        INSERT INTO GT_0039_MKT_FCST_MDL_CELL_BOM
        (
            MODEL_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN C.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE C.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
             , SCM_MST_ITEM_SN     D
         WHERE B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'   /* Cell Assy 기준 */
           AND C.OPERATION_GROUP = 'A'       /* Cell */
           AND D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE XA.SALES_ITEM_ID = A.MODEL_ID );
        P_GATHER('GT_0039_MKT_FCST_MDL_CELL_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* Cell Assy/Prod Mapping 정보                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'CELL_PROD_ASSY_MAP';
        INSERT INTO GT_0039_CELL_PROD_ASSY_MAP
        (
            DIVISION_ID
          , PLANT_ID
          , ITEM_ID_ASSY
          , ITEM_ID_PROD
          , ITEM_ID_PROD_NICK_NAME
          , CHILD_ITEM_ID
          , ITEM_ID_PROD_PRIORITY
          , ITEM_ID_PROD_PRIORITY2
        )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.ITEM_ID_ASSY
             , A.ITEM_ID_PROD
             , B.NICK_NAME          AS ITEM_ID_PROD_NICK_NAME
             , C.CHILD_ITEM_ID
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.PLANT_ID
                                             , A.ITEM_ID_ASSY
                                      ORDER BY CASE WHEN C.CHILD_ITEM_ID IS NOT NULL
                                                    THEN 1
                                                    ELSE 0
                                               END DESC
                                             , A.ITEM_ID_PROD DESC)  AS ITEM_ID_PROD_PRIORITY
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.ITEM_ID_ASSY
                                      ORDER BY CASE WHEN C.CHILD_ITEM_ID IS NOT NULL
                                                    THEN 1
                                                    ELSE 0
                                               END DESC
                                             , A.ITEM_ID_PROD DESC)  AS ITEM_ID_PROD_PRIORITY2
          FROM SCP_MST_CELL_PROD_ASSY_MAP     A
             , SCP_MST_FINAL_ITEM             B
             , GT_0039_MKT_FCST_MDL_CELL_BOM  C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID_PROD
           AND C.CHILD_ITEM_ID(+) = A.ITEM_ID_PROD
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y';
        P_GATHER('GT_0039_CELL_PROD_ASSY_MAP');

        /* ---------------------------------------------------------------------------------------- */
        /* 조립/팩 Line Assign 누락 데이터                                                           */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_CASE2';
        INSERT INTO GT_0039_TARGET_CASE2
        (
            PLANT_SITE_ID
          , PLANT_SITE
          , MODEL_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , LINE_ID
        )
        SELECT DISTINCT
               C.PLANT_SITE_ID
             , D.SITE_DESCRIPTION   AS PLANT_SITE
             , CASE WHEN B.CHILD_OPERATION_GROUP = 'A'
                    THEN NVL(NVL(E.ITEM_ID_PROD, F.ITEM_ID_PROD), C.ITEM_ID)
                    ELSE C.ITEM_ID
               END                  AS MODEL_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , D.COMPANY_ID
             , D.DIVISION_ID
             , D.SITE_ID
             , D.PLANT_ID
             , G.LINE_ID
          FROM GT_0039_MKT_FCST             A
             , GT_0039_SCP_BOM              B
             , GT_0039_PROJECT_ROUTE        C
             , SCM_MST_SITE                 D   /* plant site */
             , GT_0039_CELL_PROD_ASSY_MAP   E
             , GT_0039_CELL_PROD_ASSY_MAP   F
               /* AS-IS 의 LEFT JOIN ON 절에 있던 SCP 계획 공정 제한 / ACTIVE_FLAG / PRIORITY 조건은
                  인라인 뷰로 옮긴다 (Oracle 은 (+) 조인 조건에 서브쿼리를 쓸 수 없다 - ORA-01799) */
             , ( SELECT XA.COMPANY_ID
                      , XA.DIVISION_ID
                      , XA.SITE_ID
                      , XA.PLANT_ID
                      , XA.ITEM_ID
                      , XA.OPERATION_ID
                      , XA.MONTH
                      , XA.LINE_ID
                   FROM SCM_MST_ITEM_LINE_ASSIGN_SN XA
                      , GT_0039_SCP_PLAN_OPERATION  XB   /* scp 계획 공정으로 범위 제한 */
                  WHERE XB.OPERATION_ID = XA.OPERATION_ID
                    AND XA.ACTIVE_FLAG = 'Y'
                    AND XA.PRIORITY NOT IN ('0', '9') ) G
         WHERE B.MODEL_ID = A.SALES_ITEM_ID
           AND NVL(B.CELL_TYPE, ' ') NOT LIKE 'CP%'   /* Cell Assy 기준 (CP 제외) */
           AND C.ITEM_ID      = B.CHILD_ITEM_ID
           AND C.PROJECT_CODE = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                     THEN '-'
                                     ELSE A.PROJECT_CODE
                                END
           AND C.SALES_SITE_ID = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                      THEN '-'
                                      ELSE A.SALES_SITE_ID
                                 END
           AND D.DIVISION_ID = V_DIVISION_ID
           AND D.SCM_SITE_ID = C.PLANT_SITE_ID
           AND D.VALID_YN    = 'Y'
           AND D.SITE_TYPE   = 'PLANT'
           AND NVL(D.OPERATION_GROUP, 'Z') != 'W'   /* 2025.08.06 Warranty Plant 제외 */
           AND NVL(D.OSP_YN, 'Z')          != 'Y'   /* 2025.08.06 OSP 제외 */
           AND E.DIVISION_ID(+)  = D.DIVISION_ID
           AND E.PLANT_ID(+)     = D.PLANT_ID
           AND E.ITEM_ID_ASSY(+) = C.ITEM_ID
           AND E.ITEM_ID_PROD_PRIORITY(+) = 1
           AND F.DIVISION_ID(+)  = D.DIVISION_ID
           AND F.ITEM_ID_ASSY(+) = C.ITEM_ID
           AND F.ITEM_ID_PROD_PRIORITY2(+) = 1
           AND G.COMPANY_ID(+)  = D.COMPANY_ID
           AND G.DIVISION_ID(+) = D.DIVISION_ID
           AND G.SITE_ID(+)     = D.SITE_ID
           AND G.PLANT_ID(+)    = D.PLANT_ID
           AND G.ITEM_ID(+)     = C.ITEM_ID
           AND G.MONTH(+) BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)   /* 2025.08.20 당월부터 plan horizon end date 까지 참조 */
           AND G.LINE_ID IS NULL;   /* line assign 안된 Cell/Pack Project Route 데이터 */

        /* ---------------------------------------------------------------------------------------- */
        /* case 3 : Line Assign 된 Cell 모델 (Cell Product 기준)                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_ASSIGN_CELL';
        P_GATHER('GT_0039_TARGET_CASE2');
        INSERT INTO GT_0039_LINE_ASSIGN_CELL
        (
            COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , CELL_MODEL_ID
          , CELL_NICK_NAME
        )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , E.ITEM_ID_PROD       AS CELL_MODEL_ID
             , MAX(D.NICK_NAME)     AS CELL_NICK_NAME
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN A
             , SCM_MST_LINE_SN             B   /* 2025.08.20 PJ20257329 유효한 라인만 참조 */
             , GT_0039_SCP_PLAN_OPERATION  C   /* 2025.08.20 SCP Plan Operation 으로 참조 범위 제한 */
             , SCP_MST_FINAL_ITEM          D
             , GT_0039_CELL_PROD_ASSY_MAP  E
         WHERE B.COMPANY_ID   = A.COMPANY_ID
           AND B.DIVISION_ID  = A.DIVISION_ID
           AND B.SITE_ID      = A.SITE_ID
           AND B.PLANT_ID     = A.PLANT_ID
           AND B.FACTORY_ID   = A.FACTORY_ID
           AND B.OPERATION_ID = A.OPERATION_ID
           AND B.LINE_ID      = A.LINE_ID
           AND B.ACTIVE_FLAG  = 'Y'
           AND C.OPERATION_ID = A.OPERATION_ID
           AND D.DIVISION_ID  = A.DIVISION_ID
           AND D.ITEM_ID      = A.ITEM_ID
           AND D.OPERATION_GROUP = 'A'
           AND E.DIVISION_ID  = A.DIVISION_ID
           AND E.PLANT_ID     = A.PLANT_ID
           AND E.ITEM_ID_ASSY = A.ITEM_ID
           AND E.ITEM_ID_PROD_PRIORITY = 1
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST_MDL_CELL_BOM XA
                         WHERE XA.CHILD_ITEM_ID = E.ITEM_ID_PROD )   /* MKT FCST 기준 생산 대상 Cell Model */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
           AND A.ACTIVE_FLAG = 'Y'
           AND A.PRIORITY NOT IN ('0', '9')   /* FP에서 0 / 9 는 생산 대상 아님 */
           AND EXISTS ( SELECT 1   /* 2025.08.20 Project route 가 존재하는 cell model */
                          FROM GT_0039_PROJECT_ROUTE XB
                         WHERE XB.ITEM_ID = A.ITEM_ID )
         GROUP BY A.COMPANY_ID
                , A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , E.ITEM_ID_PROD;
        P_GATHER('GT_0039_LINE_ASSIGN_CELL');

        /* ---------------------------------------------------------------------------------------- */
        /* 라인 Assign 된 Cell Model BOM (셀-전극)                                                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_ASSIGN_CELL_BOM';
        INSERT INTO GT_0039_LINE_ASSIGN_CELL_BOM
        (
            MODEL_ID
          , PLANT_ID
          , CHILD_COMPANY_ID
          , CHILD_DIVISION_ID
          , CHILD_SITE_ID
          , CHILD_PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , ELEC_NICK_NAME
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.PLANT_ID
             , A.CHILD_COMPANY_ID
             , A.CHILD_DIVISION_ID
             , A.CHILD_SITE_ID
             , A.CHILD_PLANT_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN D.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE D.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(D.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , D.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , D.NICK_NAME              AS ELEC_NICK_NAME
          FROM SCM_MST_MODEL_BOM        A
             , GT_0039_LINE_ASSIGN_CELL B
             , SCM_MST_ITEM_SN          C
             , SCP_MST_FINAL_ITEM       E   /* Cell Model */
             , SCP_MST_FINAL_ITEM       D   /* Child 전극 */
             , SCM_MST_ITEM_SN          F
         WHERE B.COMPANY_ID    = A.COMPANY_ID
           AND B.DIVISION_ID   = A.DIVISION_ID
           AND B.SITE_ID       = A.SITE_ID
           AND B.PLANT_ID      = A.PLANT_ID
           AND B.CELL_MODEL_ID = A.MODEL_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND C.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND C.DIVISION_ID = A.CHILD_DIVISION_ID
           AND C.SITE_ID     = A.CHILD_SITE_ID
           AND C.ACTIVE_FLAG = 'Y'
           AND E.DIVISION_ID = A.DIVISION_ID
           AND E.ITEM_ID     = A.MODEL_ID
           AND E.OPERATION_GROUP = 'A'   /* Cell Model */
           AND E.FLOW_ID LIKE 'A%'
           AND D.DIVISION_ID = A.DIVISION_ID
           AND D.ITEM_ID     = A.CHILD_ITEM_ID
           AND D.OPERATION_GROUP = 'E'   /* Child 전극 */
           AND F.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND F.COMPANY_ID(+)  = A.COMPANY_ID
           AND F.DIVISION_ID(+) = A.DIVISION_ID
           AND F.SITE_ID(+)     = A.SITE_ID
           AND F.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR F.ITEM_ID IS NOT NULL);
        P_GATHER('GT_0039_LINE_ASSIGN_CELL_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* 전극 PROJECT ROUTE                                                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE_ELEC';
        INSERT INTO GT_0039_PROJECT_ROUTE_ELEC
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , PLANT_SITE_ID
          , DIVISION_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , A.PLANT_SITE_ID
             , B.DIVISION_ID
             , B.COMPANY_ID
             , B.SITE_ID
             , B.PLANT_ID
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND B.OPERATION_GROUP = 'E'   /* 전극 Plant Site */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE_ELEC');

        /* ---------------------------------------------------------------------------------------- */
        /* 전극 Line Assign 안된 데이터                                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_CASE3';
        INSERT INTO GT_0039_TARGET_CASE3
        (
            DIVISION_ID
          , ELEC_ITEM_ID
          , ELEC_NICK_NAME
          , OPERATION_ID
          , PLANT_SITE_ID
          , MODEL_ID
          , MODEL_PLANT_ID
        )
        SELECT DISTINCT
               A.CHILD_DIVISION_ID    AS DIVISION_ID
             , A.CHILD_ITEM_ID        AS ELEC_ITEM_ID
             , A.ELEC_NICK_NAME
             , A.CHILD_OPERATION_ID   AS OPERATION_ID
             , B.PLANT_SITE_ID
             , A.MODEL_ID
             , A.PLANT_ID             AS MODEL_PLANT_ID
          FROM GT_0039_LINE_ASSIGN_CELL_BOM A
             , GT_0039_PROJECT_ROUTE_ELEC   B
               /* AS-IS 의 LEFT JOIN ON 절에 있던 SCP 계획 공정 제한 / ACTIVE_FLAG / PRIORITY 조건은
                  인라인 뷰로 옮긴다 (Oracle 은 (+) 조인 조건에 서브쿼리를 쓸 수 없다 - ORA-01799) */
             , ( SELECT XA.COMPANY_ID
                      , XA.DIVISION_ID
                      , XA.SITE_ID
                      , XA.PLANT_ID
                      , XA.ITEM_ID
                      , XA.OPERATION_ID
                      , XA.MONTH
                      , XA.LINE_ID
                   FROM SCM_MST_ITEM_LINE_ASSIGN_SN XA
                      , GT_0039_SCP_PLAN_OPERATION  XB   /* scp 계획 공정으로 범위 제한 */
                  WHERE XB.OPERATION_ID = XA.OPERATION_ID
                    AND XA.ACTIVE_FLAG = 'Y'
                    AND XA.PRIORITY NOT IN ('0', '9') ) C
         WHERE A.CHILD_ITEM_ID = B.ITEM_ID
           AND A.PLANT_ID      = B.PLANT_ID   /* 2025.08.20 PJ20257329 cell/전극 동일 plant 조건 추가 */
           AND C.COMPANY_ID(+)  = B.COMPANY_ID
           AND C.DIVISION_ID(+) = B.DIVISION_ID
           AND C.SITE_ID(+)     = B.SITE_ID
           AND C.PLANT_ID(+)    = B.PLANT_ID
           AND C.ITEM_ID(+)     = B.ITEM_ID
           AND C.MONTH(+) BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
           AND C.LINE_ID IS NULL;   /* 전극 line assign 누락 데이터 */

        /* ---------------------------------------------------------------------------------------- */
        /* case 4 : SCP Plan 버전 정보                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PLAN_VERSION';
        P_GATHER('GT_0039_TARGET_CASE3');
        INSERT INTO GT_0039_SCP_PLAN_VERSION
        (
            DIVISION_ID
          , PLAN_TYPE
          , PLAN_SEQ
          , PLAN_START_YYYYMMDD
          , HORIZON_END_DATE
          , PLAN_STATUS
          , CONFIRM_FLAG
          , PLAN_PRIORITY
        )
        SELECT IA.DIVISION_ID
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IA.PLAN_START_YYYYMMDD
             , IA.HORIZON_END_DATE
             , IA.PLAN_STATUS
             , IA.CONFIRM_FLAG
             , IA.PLAN_PRIORITY
          FROM ( SELECT A.DIVISION_ID
                      , B.PLAN_TYPE
                      , B.PLAN_SEQ
                      , A.PLAN_NAME                            AS PLAN_START_YYYYMMDD
                      , SUBSTR(A.HORIZON_END_DATE, 1, 8)       AS HORIZON_END_DATE
                      , B.PLAN_STATUS
                      , B.CONFIRM_FLAG
                      , DENSE_RANK() OVER (PARTITION BY A.DIVISION_ID
                                               ORDER BY A.PLAN_NAME DESC
                                                      , B.INPUT_START_DATE DESC)  AS PLAN_PRIORITY
                   FROM SCM_MST_PLAN        A
                      , SCM_MST_PLAN_DETAIL B
                  WHERE B.DIVISION_ID = A.DIVISION_ID
                    AND B.PLAN_ID     = A.PLAN_ID
                    AND B.PLAN_STATUS = '1'   /* 정상 완료 */
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.PLAN_CYCLE  = 'WEEKLY'
                    AND A.PLAN_NAME   = V_FROM_YYYYMMDD ) IA
         WHERE IA.PLAN_PRIORITY = 1;
        P_GATHER('GT_0039_SCP_PLAN_VERSION');

        /* 계획 버전은 PLAN_PRIORITY = 1 로 한 건이다. GTT 와 조인하면 대용량 파티션 테이블에
           파티션 프루닝이 걸리지 않아 조회가 폭주하므로, 값을 변수로 받아 상수 조건으로 준다. */
        SELECT MAX(DIVISION_ID)
             , MAX(PLAN_TYPE)
             , MAX(PLAN_SEQ)
             , MAX(PLAN_START_YYYYMMDD)
             , MAX(HORIZON_END_DATE)
          INTO V_PLAN_DIVISION
             , V_PLAN_TYPE
             , V_PLAN_SEQ
             , V_PLAN_START
             , V_HORIZON_END
          FROM GT_0039_SCP_PLAN_VERSION;


        /* ---------------------------------------------------------------------------------------- */
        /* SCP 생산계획 (2025.08.20 추가)                                                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PROD_PLAN';
        INSERT INTO GT_0039_SCP_PROD_PLAN
        (
            DIVISION_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , OPERATION_GROUP
          , SCM_SITE_ID
          , ITEM_ID
          , LINE_ID
          , OPERATION_ID
          , YYYYMM
          , QTY
        )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , SUBSTR(A.YYYYMMDD, 1, 6)  AS YYYYMM
             , SUM(A.QTY)                AS QTY
          FROM SCP_ANL_PRODUCTION_PLAN A
         WHERE A.DIVISION_ID         = V_PLAN_DIVISION
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_PLAN_SEQ
           AND A.YYYYMMDD           <= V_HORIZON_END
           AND A.MEASURE = 'PROD_PLAN_AMEND'
           AND A.QTY != 0
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , SUBSTR(A.YYYYMMDD, 1, 6);
        P_GATHER('GT_0039_SCP_PROD_PLAN');

        /* ---------------------------------------------------------------------------------------- */
        /* Current 생산계획 - line assign 범위 밖의 생산계획                                         */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_CASE4';
        INSERT INTO GT_0039_TARGET_CASE4
        (
            DIVISION_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , OPERATION_GROUP
          , SCM_SITE_ID
          , SITE_DESCRIPTION
          , ITEM_ID
          , LINE_ID
          , OPERATION_ID
          , MIN_PROD_MONTH
          , MAX_PROD_MONTH
          , QTY
        )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , B.SITE_DESCRIPTION
             , CASE WHEN A.OPERATION_GROUP = 'P'
                    THEN A.ITEM_ID
                    ELSE NVL(NVL(D.ITEM_ID_PROD, E.ITEM_ID_PROD), A.ITEM_ID)
               END                      AS ITEM_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , MIN(A.YYYYMM)            AS MIN_PROD_MONTH
             , MAX(A.YYYYMM)            AS MAX_PROD_MONTH
             , SUM(A.QTY)               AS QTY
          FROM GT_0039_SCP_PROD_PLAN       A
             , SCM_MST_SITE                B
               /* AS-IS 의 LEFT JOIN ON 절에 있던 SCP 계획 공정 제한 / ACTIVE_FLAG / PRIORITY 조건은
                  인라인 뷰로 옮긴다 (Oracle 은 (+) 조인 조건에 서브쿼리를 쓸 수 없다 - ORA-01799) */
             , ( SELECT XA.COMPANY_ID
                      , XA.DIVISION_ID
                      , XA.SITE_ID
                      , XA.PLANT_ID
                      , XA.ITEM_ID
                      , XA.OPERATION_ID
                      , XA.MONTH
                      , XA.LINE_ID
                   FROM SCM_MST_ITEM_LINE_ASSIGN_SN XA
                      , GT_0039_SCP_PLAN_OPERATION  XB   /* scp 계획 공정으로 범위 제한 */
                  WHERE XB.OPERATION_ID = XA.OPERATION_ID
                    AND XA.ACTIVE_FLAG = 'Y'
                    AND XA.PRIORITY NOT IN ('0', '9') ) C
             , GT_0039_CELL_PROD_ASSY_MAP  D
             , GT_0039_CELL_PROD_ASSY_MAP  E
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND C.COMPANY_ID(+)  = B.COMPANY_ID
           AND C.DIVISION_ID(+) = B.DIVISION_ID
           AND C.SITE_ID(+)     = B.SITE_ID
           AND C.PLANT_ID(+)    = B.PLANT_ID
           AND C.LINE_ID(+)     = A.LINE_ID
           AND C.ITEM_ID(+)     = A.ITEM_ID
           AND C.MONTH(+)       = A.YYYYMM   /* 해당 범위 내 */
           AND D.DIVISION_ID(+)  = B.DIVISION_ID
           AND D.PLANT_ID(+)     = B.PLANT_ID
           AND D.ITEM_ID_ASSY(+) = A.ITEM_ID
           AND D.ITEM_ID_PROD_PRIORITY(+) = 1
           AND E.DIVISION_ID(+)  = B.DIVISION_ID
           AND E.ITEM_ID_ASSY(+) = A.ITEM_ID
           AND E.ITEM_ID_PROD_PRIORITY2(+) = 1
           AND C.LINE_ID IS NULL   /* 범위 밖의 Line Assign */
           AND EXISTS ( SELECT 1   /* line Assign 이 존재 */
                          FROM SCM_MST_ITEM_LINE_ASSIGN_SN XA
                             , SCM_MST_LINE_SN             XB   /* 2025.08.20 PJ20257329 유효한 라인만 참조 */
                             , GT_0039_SCP_PLAN_OPERATION  XC   /* 2025.08.20 scp 계획 공정으로 범위 제한 */
                         WHERE XB.COMPANY_ID   = XA.COMPANY_ID
                           AND XB.DIVISION_ID  = XA.DIVISION_ID
                           AND XB.SITE_ID      = XA.SITE_ID
                           AND XB.PLANT_ID     = XA.PLANT_ID
                           AND XB.FACTORY_ID   = XA.FACTORY_ID
                           AND XB.OPERATION_ID = XA.OPERATION_ID
                           AND XB.LINE_ID      = XA.LINE_ID
                           AND XB.ACTIVE_FLAG  = 'Y'
                           AND XC.OPERATION_ID = XA.OPERATION_ID
                           AND XA.COMPANY_ID  = B.COMPANY_ID
                           AND XA.DIVISION_ID = B.DIVISION_ID
                           AND XA.SITE_ID     = B.SITE_ID
                           AND XA.PLANT_ID    = B.PLANT_ID
                           AND XA.LINE_ID     = A.LINE_ID
                           AND XA.ITEM_ID     = A.ITEM_ID
                           AND XA.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
                           AND XA.ACTIVE_FLAG = 'Y'
                           AND XA.PRIORITY NOT IN ('0', '9') )
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , B.SITE_DESCRIPTION
                , CASE WHEN A.OPERATION_GROUP = 'P'
                       THEN A.ITEM_ID
                       ELSE NVL(NVL(D.ITEM_ID_PROD, E.ITEM_ID_PROD), A.ITEM_ID)
                  END
                , A.LINE_ID
                , A.OPERATION_ID;
        P_GATHER('GT_0039_TARGET_CASE4');

        /* ---------------------------------------------------------------------------------------- */
        /* case 5 : 전극 Line Assign Lane 수량이 1보다 작은 데이터                                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_CASE5';
        INSERT INTO GT_0039_TARGET_CASE5
        (
            DIVISION_ID
          , ELEC_ITEM_ID
          , ELEC_NICK_NAME
          , OPERATION_ID
          , PLANT_SITE_ID
          , MODEL_ID
          , MODEL_PLANT_ID
          , LINE_ID
          , MONTH_MIN
          , MONTH_MAX
        )
        SELECT A.CHILD_DIVISION_ID    AS DIVISION_ID
             , A.CHILD_ITEM_ID        AS ELEC_ITEM_ID
             , A.ELEC_NICK_NAME
             , A.CHILD_OPERATION_ID   AS OPERATION_ID
             , B.PLANT_SITE_ID
             , A.MODEL_ID
             , A.PLANT_ID             AS MODEL_PLANT_ID
             , C.LINE_ID
             , MIN(C.MONTH)           AS MONTH_MIN
             , MAX(C.MONTH)           AS MONTH_MAX
          FROM GT_0039_LINE_ASSIGN_CELL_BOM A
             , GT_0039_PROJECT_ROUTE_ELEC   B
             , SCM_MST_ITEM_LINE_ASSIGN_SN  C
             , SCM_MST_LINE_SN              D   /* 2025.08.20 PJ20257329 유효한 라인만 참조 */
             , GT_0039_SCP_PLAN_OPERATION   E   /* 2025.08.20 SCP Plan Operation 으로 참조 범위 제한 */
         WHERE A.CHILD_ITEM_ID = B.ITEM_ID
           AND C.COMPANY_ID   = B.COMPANY_ID
           AND C.DIVISION_ID  = B.DIVISION_ID
           AND C.SITE_ID      = B.SITE_ID
           AND C.PLANT_ID     = B.PLANT_ID
           AND C.ITEM_ID      = B.ITEM_ID
           AND C.OPERATION_ID = 'E2000'   /* 6/20 추가 */
           AND C.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
           AND D.COMPANY_ID   = C.COMPANY_ID
           AND D.DIVISION_ID  = C.DIVISION_ID
           AND D.SITE_ID      = C.SITE_ID
           AND D.PLANT_ID     = C.PLANT_ID
           AND D.FACTORY_ID   = C.FACTORY_ID
           AND D.OPERATION_ID = C.OPERATION_ID
           AND D.LINE_ID      = C.LINE_ID
           AND D.ACTIVE_FLAG  = 'Y'
           AND E.OPERATION_ID = C.OPERATION_ID
           AND C.ACTIVE_FLAG = 'Y'
           AND C.PRIORITY NOT IN ('0', '9')
           AND C.LANE_QTY < 1   /* lane 수가 1 미만인 경우 */
         GROUP BY A.CHILD_DIVISION_ID
                , A.CHILD_ITEM_ID
                , A.ELEC_NICK_NAME
                , A.CHILD_OPERATION_ID
                , B.PLANT_SITE_ID
                , A.MODEL_ID
                , A.PLANT_ID
                , C.LINE_ID;
        P_GATHER('GT_0039_TARGET_CASE5');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터                                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        /* Project Route 미등록 */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , A.SALES_ITEM_ID      AS MODEL_ID
             , A.MODEL_NICK_NAME    AS NICK_NAME
             , A.MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.PROJECT_CODE       AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
               /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
            || CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND A.CHILD_OPERATION_GROUP = 'A'
                    THEN ' ,Cell Prod Site : ' || C.NAME
                    ELSE ''
               END                  AS MASTER_INVLD_CTN
          FROM GT_0039_PR_NOT_EXISTS      A
             , SCM_MST_SITE               B
             , GT_0039_CELL_PROD_SITE_ID  C
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.SCM_SITE_ID = A.SALES_SITE_ID
           AND C.CODE(+)     = A.CELL_PROD_SITE_ID
         UNION ALL
        /*
        2) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
           해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
         >> ASSIGN 된 PLANT 내 LINE ASSIGN 이 조회되지 않는경우
        */
        SELECT DISTINCT   /* PJ20257329 2025.09.12 distinct 추가 */
               A.DIVISION_ID
             , A.MODEL_ID
             , B.NICK_NAME
             , 'LNA02'                   AS MASTER_INVLD_CD
             , A.PLANT_SITE              AS SALES_PLANT_SITE
             , A.CHILD_OPERATION_ID      AS PROJECT_OPERATION
             , A.LINE_ID                 AS INCOERMS_LINE
             , NULL                      AS QTY
             , 'Sales Item :' || A.SALES_ITEM_ID  AS MASTER_INVLD_CTN   /* PJ20257329 2025.09.12 Sales Site 및 Project Code 정보 제외 */
          FROM GT_0039_TARGET_CASE2 A
             , SCP_MST_FINAL_ITEM   B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
         UNION ALL
        /*
        3) (전극)CURRENT 상위BOM '셀' LINE ASSIGN이 되어있는 '모델' 정보와
           해당 모델의 E2000(코팅) 공정의 BOM 정보를 기반으로
         >> 전극 PLANT ASSIGN 정보가 경우 (ROUTE 미등록)
        */
        SELECT DISTINCT   /* PJ20257329 2025.09.12 distinct 추가 */
               A.DIVISION_ID
             , A.ELEC_ITEM_ID       AS MODEL_ID
             , A.ELEC_NICK_NAME     AS NICK_NAME
             , 'LNA03'              AS MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.OPERATION_ID       AS PROJECT_OPERATION
             , NULL                 AS INCOERMS_LINE
             , NULL                 AS QTY
             , 'Cell Model :' || A.MODEL_ID  AS MASTER_INVLD_CTN   /* PJ20257329 2025.09.12 Model Plant 정보 제외 */
          FROM GT_0039_TARGET_CASE3 A
             , SCM_MST_SITE         B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
         UNION ALL
        /*
        4) CURRENT PROD AMEND 에 입력되어 있는 '모델'/'PLANT'/'LINE'/'생산계획날짜' 정보를 기반으로
         >> 생산계획 시기가 LINE ASSIGN의 FROM TO 날짜외 구간에 입력되어 있는 경우
        */
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.NICK_NAME
             , 'LNA04'              AS MASTER_INVLD_CD
             , A.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.OPERATION_ID       AS PROJECT_OPERATION
             , A.LINE_ID            AS INCOERMS_LINE
             , A.QTY                AS QTY
             , 'Min Month :' || A.MIN_PROD_MONTH || ', Max Month :' || A.MAX_PROD_MONTH  AS MASTER_INVLD_CTN
          FROM GT_0039_TARGET_CASE4 A
             , SCP_MST_FINAL_ITEM   B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
         UNION ALL
        /*
        5) (전극) CURRENT 상위BOM '셀' LINE ASSIGN이 되어있는 '모델' 정보와
           해당 모델의 E2000(코팅) 공정의 BOM 정보를 기반으로
         >> E2000 공정의 LANE 정보가 1이상의 정수가 아닌경우 (LANE정보 미등록)
        */
        SELECT A.DIVISION_ID
             , A.ELEC_ITEM_ID       AS MODEL_ID
             , A.ELEC_NICK_NAME     AS NICK_NAME
             , 'LNA05'              AS MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.OPERATION_ID       AS PROJECT_OPERATION
             , A.LINE_ID            AS INCOERMS_LINE
             , NULL                 AS QTY
             , 'Min Month:' || A.MONTH_MIN || ' Max Month:' || A.MONTH_MAX
            || '. Cell Model :' || A.MODEL_ID || ', Plant :' || A.MODEL_PLANT_ID  AS MASTER_INVLD_CTN
          FROM GT_0039_TARGET_CASE5 A
             , SCM_MST_SITE         B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID;
        P_GATHER('GT_0039_TARGET_DATA');

        V_STEP := '전극 Applied Cell Model';
        P_LOAD_ELEC_APPLIED_MODEL(V_DIVISION_ID);

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , D.BASIC_NICK_NAME    AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA        A
             , SCP_MST_FINAL_ITEM         B
             , GT_0039_ELEC_APPLIED_MODEL C
             , SCP_MST_ITEM_BSI_IFO       D
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.ITEM_ID(+)     = A.MODEL_ID
           AND D.ITEM_ID(+)     = CASE WHEN B.OPERATION_GROUP = 'E' THEN C.APPLIED_MODEL
                                       WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                       ELSE A.MODEL_ID
                                  END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT DISTINCT   /* PJ20257329 2025.09.12 중복 제거 */
                   A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , ITEM_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_LINE_ASSIGN;

    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_TACT_TIME                                               */
    /* Description : Tact Time 조회                                                                 */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2025/08/20  hrkim   PJ20257329 유효 라인/SCP Plan Operation 범위 제한                         */
    /* 2025/09/12  hrkim   PJ20257329 소형 Cell Prod Site 적용, 중복 제거                            */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_TACT_TIME
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'CFM_MKT_DEMAND_PLAN';
        P_LOAD_CFM_MKT_DEMAND_PLAN(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'CELL_PROD_SITE_ID';
        P_LOAD_CELL_PROD_SITE_ID;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_SCP_BOM;
        DELETE FROM GT_0039_CELL_PROD_ASSY_MAP;
        DELETE FROM GT_0039_PROJECT_ROUTE;
        DELETE FROM GT_0039_PR_NOT_EXISTS;
        DELETE FROM GT_0039_FP_TACT_TIME;
        DELETE FROM GT_0039_SCP_TACT_TIME;
        DELETE FROM GT_0039_SCP_TACT_TIME_EXCEPT;
        DELETE FROM GT_0039_TT_CASE_2;
        DELETE FROM GT_0039_LINE_ASSIGN_MODEL;
        DELETE FROM GT_0039_TT_CASE_3;
        DELETE FROM GT_0039_MKT_FCST_MDL_CELL_BOM;
        DELETE FROM GT_0039_LINE_ASSIGN_CELL;
        DELETE FROM GT_0039_LINE_ASSIGN_CELL_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE_ELEC;
        DELETE FROM GT_0039_TT_CASE_4;
        DELETE FROM GT_0039_TT_CASE_4_2;
        DELETE FROM GT_0039_SCP_PLAN_VERSION;
        DELETE FROM GT_0039_TT_CASE_5;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST                                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(CASE WHEN NVL(E.RN, 1) = 1 THEN A.QTY ELSE 0 END)  AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE
             , E.CELL_PROD_SITE_ID
             , E.COMPANY_ID                   AS COMPANY_ID_CELL_PROD
             , E.SITE_ID                      AS SITE_ID_CELL_PROD
             , E.PLANT_ID                     AS PLANT_ID_CELL_PROD
          FROM DM_PLN_MKT_FCST           A
             , SCM_MST_SITE              B
             , SCP_MST_FINAL_ITEM        C
             , GT_0039_AS_SITE_PLANT     D
             , GT_0039_CFM_MKT_DMND_PLAN E
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PROJECT_CODE(+)  = A.PROJECT_CODE
           AND E.SCM_SITE_ID(+)   = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.DOM_EXP(+)       = A.DOM_EXP
           AND E.FCST_TYPE(+)     = A.FCST_TYPE
           AND E.INCOTERMS(+)     = A.INCOTERMS
           AND E.MEASURE(+)       = A.MEASURE
           AND E.YYYYMMDD(+)      = A.YYYYMMDD
           AND E.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL
         GROUP BY A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , E.CELL_PROD_SITE_ID
                , E.COMPANY_ID
                , E.SITE_ID
                , E.PLANT_ID;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM                                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_BOM';
        INSERT INTO GT_0039_SCP_BOM
        (
            MODEL_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , CELL_TYPE
          , CHILD_NICK_NAME
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.CHILD_ITEM_ID
             , C.OPERATION_GROUP        AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , C.ATTRIBUTE8             AS CELL_TYPE
             , C.NICK_NAME              AS CHILD_NICK_NAME
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     D   /* PJ20257329 2025.08.26 parent item master active 'Y'만 참조 */
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
         WHERE D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_SCP_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* Cell Assy/Prod Mapping 정보                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'CELL_PROD_ASSY_MAP';
        INSERT INTO GT_0039_CELL_PROD_ASSY_MAP
        (
            DIVISION_ID
          , PLANT_ID
          , ITEM_ID_ASSY
          , ITEM_ID_PROD
          , ITEM_ID_PROD_NICK_NAME
          , CHILD_ITEM_ID
          , ITEM_ID_PROD_PRIORITY
          , ITEM_ID_PROD_PRIORITY2
        )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.ITEM_ID_ASSY
             , A.ITEM_ID_PROD
             , B.NICK_NAME          AS ITEM_ID_PROD_NICK_NAME
             , C.CHILD_ITEM_ID
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.PLANT_ID
                                             , A.ITEM_ID_ASSY
                                      ORDER BY CASE WHEN C.CHILD_ITEM_ID IS NOT NULL
                                                    THEN 1
                                                    ELSE 0
                                               END DESC
                                             , A.ITEM_ID_PROD DESC)  AS ITEM_ID_PROD_PRIORITY
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.ITEM_ID_ASSY
                                      ORDER BY CASE WHEN C.CHILD_ITEM_ID IS NOT NULL
                                                    THEN 1
                                                    ELSE 0
                                               END DESC
                                             , A.ITEM_ID_PROD DESC)  AS ITEM_ID_PROD_PRIORITY2
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
             , SCP_MST_FINAL_ITEM         B
             , GT_0039_SCP_BOM            C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID_PROD
           AND C.CHILD_ITEM_ID(+) = A.ITEM_ID_PROD
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y';
        P_GATHER('GT_0039_CELL_PROD_ASSY_MAP');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT ROUTE                                                                             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE';
        INSERT INTO GT_0039_PROJECT_ROUTE
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , PLANT_SITE_ID
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , COUNTRY
          , CITY
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.PLANT_SITE_ID
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , B.COUNTRY
             , B.CITY
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST 기준 Project Route 존재하지 않는 데이터                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PR_NOT_EXISTS';
        INSERT INTO GT_0039_PR_NOT_EXISTS
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.MF_LAST_UPDATE_DATE
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , B.CHILD_ITEM_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , 'COM01'                                        AS MASTER_INVLD_CD
             , 'Target Item:' || B.CHILD_ITEM_ID
            || ', FCST Last Update :' || A.MF_LAST_UPDATE_DATE AS MASTER_INVLD_CTN   /* 2025.08.14 수요 최종 변경일 추가 */
          FROM GT_0039_MKT_FCST A
             , GT_0039_SCP_BOM  B
         WHERE A.SALES_ITEM_ID = B.MODEL_ID
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND B.CHILD_OPERATION_GROUP != 'E'
           AND NVL(B.CELL_TYPE, ' ') NOT LIKE 'CA%'
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XA
                             WHERE XA.ITEM_ID = B.CHILD_ITEM_ID
                               AND XA.PLANT_SITE_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                                           THEN A.CELL_PROD_SITE_ID
                                                           ELSE XA.PLANT_SITE_ID
                                                      END
                               AND XA.PROJECT_CODE  = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.PROJECT_CODE
                                                      END
                               AND XA.SALES_SITE_ID = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.SALES_SITE_ID
                                                      END );
        P_GATHER('GT_0039_PR_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* case 2 : FP / SCP Tact Time                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'FP_TACT_TIME';
        INSERT INTO GT_0039_FP_TACT_TIME
        (
            PLANT_SITE_ID
          , ITEM_ID
          , OPERATION_ID
          , LINE_ID
          , MONTH
        )
        SELECT DISTINCT
               PLANT_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , MONTH
          FROM SCM_MST_TACT_TIME_VER_H_V
         WHERE DIVISION_ID = V_DIVISION_ID
           AND TACT_TIME > 0
           AND MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6);   /* 2025.08.20 PJ20257329 */

        V_STEP := 'SCP_TACT_TIME';
        P_GATHER('GT_0039_FP_TACT_TIME');
        INSERT INTO GT_0039_SCP_TACT_TIME
        (
            PLANT_SITE_ID
          , ITEM_ID
          , LINE_ID
          , OPERATION_ID
        )
        SELECT DISTINCT
               PLANT_SITE_ID
             , ITEM_ID
             , LINE_ID
             , OPERATION_ID
          FROM SCP_MST_TACT_TIME
         WHERE DIVISION_ID = V_DIVISION_ID
           AND TACT_TIME > 0
           AND VALID_YN  = 'Y';
        P_GATHER('GT_0039_SCP_TACT_TIME');

        V_STEP := 'SCP_TACT_TIME_EXCEPT';
        INSERT INTO GT_0039_SCP_TACT_TIME_EXCEPT
        (
            PLANT_SITE_ID
          , ITEM_ID
          , LINE_ID
          , OPERATION_ID
        )
        SELECT DISTINCT
               PLANT_SITE_ID
             , ITEM_ID
             , LINE_ID
             , OPERATION_ID
          FROM SCP_MST_TACT_TIME_EXCEPT
         WHERE DIVISION_ID         = V_DIVISION_ID
           AND TACT_TIME_END_DATE  > V_FROM_YYYYMMDD
           AND TACT_TIME > 0
           AND USE_YN    = 'Y';
        P_GATHER('GT_0039_SCP_TACT_TIME_EXCEPT');

        /* ---------------------------------------------------------------------------------------- */
        /* 조립/팩/전극 Tact Time 누락 데이터 (MKT_FCST & BOM & PROJECT_ROUTE)                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TT_CASE_2';
        INSERT INTO GT_0039_TT_CASE_2
        (
            PLANT_SITE_ID
          , PLANT_SITE
          , MODEL_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , DESCR
        )
        SELECT DISTINCT
               C.PLANT_SITE_ID
             , D.SITE_DESCRIPTION   AS PLANT_SITE
             , CASE WHEN B.CHILD_OPERATION_GROUP = 'A'
                    THEN NVL(NVL(E.ITEM_ID_PROD, F.ITEM_ID_PROD), C.ITEM_ID)
                    ELSE C.ITEM_ID
               END                  AS MODEL_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , D.COMPANY_ID
             , D.DIVISION_ID
             , D.SITE_ID
             , D.PLANT_ID
             , 'Sales Model:' || A.SALES_ITEM_ID  AS DESCR   /* PJ20257329 2025.09.12 Sales Site 및 Project Code 정보 제외 */
          FROM GT_0039_MKT_FCST            A
             , GT_0039_SCP_BOM             B
             , GT_0039_PROJECT_ROUTE       C
             , SCM_MST_SITE                D   /* plant site */
             , GT_0039_CELL_PROD_ASSY_MAP  E
             , GT_0039_CELL_PROD_ASSY_MAP  F
         WHERE B.MODEL_ID = A.SALES_ITEM_ID
           AND NVL(B.CELL_TYPE, '-') != 'CP'   /* Cell Tact Time 은 Cell Assy 기준으로 관리 */
           AND B.CHILD_OPERATION_GROUP != 'E'  /* 전극 제외 */
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND C.ITEM_ID      = B.CHILD_ITEM_ID
           AND C.PROJECT_CODE = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                     THEN '-'
                                     ELSE A.PROJECT_CODE
                                END
           AND C.SALES_SITE_ID = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                      THEN '-'
                                      ELSE A.SALES_SITE_ID
                                 END
           AND D.VALID_YN    = 'Y'
           AND D.SITE_TYPE   = 'PLANT'
           AND D.SCM_SITE_ID = C.PLANT_SITE_ID
           AND NVL(D.OPERATION_GROUP, 'Z') != 'W'   /* 2025.08.06 Warranty Plant 제외 */
           AND NVL(D.OSP_YN, 'Z')          != 'Y'   /* 2025.08.06 OSP 제외 */
           AND E.DIVISION_ID(+)  = D.DIVISION_ID
           AND E.PLANT_ID(+)     = D.PLANT_ID
           AND E.ITEM_ID_ASSY(+) = C.ITEM_ID
           AND E.ITEM_ID_PROD_PRIORITY(+) = 1
           AND F.DIVISION_ID(+)  = D.DIVISION_ID
           AND F.ITEM_ID_ASSY(+) = C.ITEM_ID
           AND F.ITEM_ID_PROD_PRIORITY2(+) = 1
           AND B.CHILD_OPERATION_ID NOT LIKE 'F%'
           AND NOT EXISTS ( SELECT 1   /* fp tact time */
                              FROM GT_0039_FP_TACT_TIME XA
                             WHERE XA.PLANT_SITE_ID = C.PLANT_SITE_ID
                               AND XA.ITEM_ID       = C.ITEM_ID )
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_SCP_TACT_TIME XB
                             WHERE XB.PLANT_SITE_ID = C.PLANT_SITE_ID
                               AND XB.ITEM_ID       = C.ITEM_ID )
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_SCP_TACT_TIME_EXCEPT XC
                             WHERE XC.PLANT_SITE_ID = C.PLANT_SITE_ID
                               AND XC.ITEM_ID       = C.ITEM_ID );
        P_GATHER('GT_0039_TT_CASE_2');

        /* ---------------------------------------------------------------------------------------- */
        /* case 3 : Line Assign 된 모델                                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_ASSIGN_MODEL';
        INSERT INTO GT_0039_LINE_ASSIGN_MODEL
        (
            COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , LINE_ID
          , ITEM_ID
          , NICK_NAME
        )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.LINE_ID
             , A.ITEM_ID
             , MAX(D.NICK_NAME)  AS NICK_NAME
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN A
             , SCM_MST_LINE_SN             B   /* 2025.08.20 PJ20257329 유효한 라인만 참조 */
             , GT_0039_SCP_PLAN_OPERATION  C   /* 2025.08.20 PJ20257329 SCP Plan Operation 으로 참조 범위 제한 */
             , SCP_MST_FINAL_ITEM          D
         WHERE B.COMPANY_ID   = A.COMPANY_ID
           AND B.DIVISION_ID  = A.DIVISION_ID
           AND B.SITE_ID      = A.SITE_ID
           AND B.PLANT_ID     = A.PLANT_ID
           AND B.FACTORY_ID   = A.FACTORY_ID
           AND B.OPERATION_ID = A.OPERATION_ID
           AND B.LINE_ID      = A.LINE_ID
           AND B.ACTIVE_FLAG  = 'Y'
           AND C.OPERATION_ID = A.OPERATION_ID
           AND D.DIVISION_ID  = A.DIVISION_ID
           AND D.ITEM_ID      = A.ITEM_ID
           AND D.OPERATION_GROUP != 'E'   /* 전극 제외 */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
           AND A.ACTIVE_FLAG = 'Y'
           AND A.PRIORITY NOT IN ('0', '9')
         GROUP BY A.COMPANY_ID
                , A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.LINE_ID
                , A.ITEM_ID;
        P_GATHER('GT_0039_LINE_ASSIGN_MODEL');

        /* ---------------------------------------------------------------------------------------- */
        /* 조립/팩 Tact Time 누락 데이터 (MKT_FCST & BOM & Line Assign)                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TT_CASE_3';
        INSERT INTO GT_0039_TT_CASE_3
        (
            PLANT_SITE_ID
          , PLANT_SITE
          , MODEL_ID
          , LINE_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , DESCR
        )
        SELECT DISTINCT
               D.SCM_SITE_ID        AS PLANT_SITE_ID
             , D.SITE_DESCRIPTION   AS PLANT_SITE
             , CASE WHEN B.CHILD_OPERATION_GROUP = 'A'
                    THEN NVL(NVL(E.ITEM_ID_PROD, F.ITEM_ID_PROD), C.ITEM_ID)
                    ELSE C.ITEM_ID
               END                  AS MODEL_ID
             , C.LINE_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , C.COMPANY_ID
             , C.DIVISION_ID
             , C.SITE_ID
             , C.PLANT_ID
             , 'Sales Model:' || A.SALES_ITEM_ID  AS DESCR   /* PJ20257329 2025.09.12 Sales Site 및 Project Code 정보 제외 */
          FROM GT_0039_MKT_FCST            A
             , GT_0039_SCP_BOM             B
             , GT_0039_LINE_ASSIGN_MODEL   C   /* 전극을 제외한 Line Assign 된 모델 */
             , SCM_MST_SITE                D
             , GT_0039_CELL_PROD_ASSY_MAP  E
             , GT_0039_CELL_PROD_ASSY_MAP  F
         WHERE B.MODEL_ID = A.SALES_ITEM_ID
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND NVL(B.CELL_TYPE, '-') != 'CP'
           AND B.CHILD_OPERATION_GROUP != 'E'
           AND C.ITEM_ID = B.CHILD_ITEM_ID
           AND D.DIVISION_ID     = C.DIVISION_ID
           AND D.PLANT_ID        = C.PLANT_ID
           AND D.SITE_TYPE       = 'PLANT'
           AND D.OPERATION_GROUP = B.CHILD_OPERATION_GROUP
           AND D.VALID_YN        = 'Y'
           AND NVL(D.OPERATION_GROUP, 'Z') != 'W'
           AND NVL(D.OSP_YN, 'Z')          != 'Y'
           AND E.DIVISION_ID(+)  = C.DIVISION_ID
           AND E.PLANT_ID(+)     = C.PLANT_ID
           AND E.ITEM_ID_ASSY(+) = C.ITEM_ID
           AND E.ITEM_ID_PROD_PRIORITY(+) = 1
           AND F.DIVISION_ID(+)  = C.DIVISION_ID
           AND F.ITEM_ID_ASSY(+) = C.ITEM_ID
           AND F.ITEM_ID_PROD_PRIORITY2(+) = 1
           AND B.CHILD_OPERATION_ID NOT LIKE 'F%'
           AND NOT EXISTS ( SELECT 1   /* fp tact time */
                              FROM GT_0039_FP_TACT_TIME XA
                             WHERE XA.PLANT_SITE_ID = D.SCM_SITE_ID
                               AND XA.ITEM_ID       = C.ITEM_ID
                               AND XA.LINE_ID       = C.LINE_ID )
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_SCP_TACT_TIME XB
                             WHERE XB.PLANT_SITE_ID = D.SCM_SITE_ID
                               AND XB.LINE_ID       = C.LINE_ID
                               AND XB.ITEM_ID       = C.ITEM_ID )
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_SCP_TACT_TIME_EXCEPT XC
                             WHERE XC.PLANT_SITE_ID = D.SCM_SITE_ID
                               AND XC.LINE_ID       = C.LINE_ID
                               AND XC.ITEM_ID       = C.ITEM_ID );
        P_GATHER('GT_0039_TT_CASE_3');

        /* ---------------------------------------------------------------------------------------- */
        /* case 4 : MKT_FCST 기준 Model Cell BOM                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST_MDL_CELL_BOM';
        INSERT INTO GT_0039_MKT_FCST_MDL_CELL_BOM
        (
            MODEL_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN C.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE C.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     D
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
         WHERE D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND C.OPERATION_GROUP = 'A'   /* Cell */
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_MKT_FCST_MDL_CELL_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* Line Assign 된 Cell 모델 (Cell Product 기준)                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_ASSIGN_CELL';
        INSERT INTO GT_0039_LINE_ASSIGN_CELL
        (
            COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , CELL_MODEL_ID
          , CELL_NICK_NAME
        )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , NVL(NVL(E.ITEM_ID_PROD, F.ITEM_ID_PROD), A.ITEM_ID)                                     AS CELL_MODEL_ID
             , MAX(NVL(NVL(E.ITEM_ID_PROD_NICK_NAME, F.ITEM_ID_PROD_NICK_NAME), D.NICK_NAME))          AS CELL_NICK_NAME
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN A
             , SCM_MST_LINE_SN             B   /* 2025.08.20 PJ20257329 유효한 라인만 참조 */
             , GT_0039_SCP_PLAN_OPERATION  C   /* 2025.08.20 PJ20257329 SCP Plan Operation 으로 참조 범위 제한 */
             , SCP_MST_FINAL_ITEM          D
             , GT_0039_CELL_PROD_ASSY_MAP  E
             , GT_0039_CELL_PROD_ASSY_MAP  F
         WHERE B.COMPANY_ID   = A.COMPANY_ID
           AND B.DIVISION_ID  = A.DIVISION_ID
           AND B.SITE_ID      = A.SITE_ID
           AND B.PLANT_ID     = A.PLANT_ID
           AND B.FACTORY_ID   = A.FACTORY_ID
           AND B.OPERATION_ID = A.OPERATION_ID
           AND B.LINE_ID      = A.LINE_ID
           AND B.ACTIVE_FLAG  = 'Y'
           AND C.OPERATION_ID = A.OPERATION_ID
           AND D.DIVISION_ID  = A.DIVISION_ID
           AND D.ITEM_ID      = A.ITEM_ID
           AND D.OPERATION_GROUP = 'A'
           AND E.DIVISION_ID(+)  = A.DIVISION_ID
           AND E.PLANT_ID(+)     = A.PLANT_ID
           AND E.ITEM_ID_ASSY(+) = A.ITEM_ID
           AND E.ITEM_ID_PROD_PRIORITY(+) = 1
           AND F.DIVISION_ID(+)  = A.DIVISION_ID
           AND F.ITEM_ID_ASSY(+) = A.ITEM_ID
           AND F.ITEM_ID_PROD_PRIORITY2(+) = 1
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
           AND A.ACTIVE_FLAG = 'Y'
           AND A.PRIORITY NOT IN ('0', '9')
           AND EXISTS ( SELECT 1   /* 상위 모델 MKT FCST 존재 6/24 */
                          FROM GT_0039_MKT_FCST_MDL_CELL_BOM XA
                         WHERE XA.CHILD_ITEM_ID = NVL(NVL(E.ITEM_ID_PROD, F.ITEM_ID_PROD), A.ITEM_ID) )
         GROUP BY A.COMPANY_ID
                , A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , NVL(NVL(E.ITEM_ID_PROD, F.ITEM_ID_PROD), A.ITEM_ID);
        P_GATHER('GT_0039_LINE_ASSIGN_CELL');

        /* ---------------------------------------------------------------------------------------- */
        /* 라인 Assign 된 Cell Model BOM (셀-전극)                                                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_ASSIGN_CELL_BOM';
        INSERT INTO GT_0039_LINE_ASSIGN_CELL_BOM
        (
            MODEL_ID
          , PLANT_ID
          , CHILD_COMPANY_ID
          , CHILD_DIVISION_ID
          , CHILD_SITE_ID
          , CHILD_PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
          , ELEC_NICK_NAME
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.PLANT_ID
             , A.CHILD_COMPANY_ID
             , A.CHILD_DIVISION_ID
             , A.CHILD_SITE_ID
             , A.CHILD_PLANT_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN D.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE D.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(D.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , D.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
             , D.NICK_NAME              AS ELEC_NICK_NAME
          FROM SCM_MST_MODEL_BOM        A
             , SCM_MST_ITEM_SN          E   /* PJ20257329 2025.08.26 parent item master active 'Y'만 참조 */
             , GT_0039_LINE_ASSIGN_CELL B
             , SCM_MST_ITEM_SN          C
             , SCP_MST_FINAL_ITEM       D
         WHERE E.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND E.COMPANY_ID(+)  = A.COMPANY_ID
           AND E.DIVISION_ID(+) = A.DIVISION_ID
           AND E.SITE_ID(+)     = A.SITE_ID
           AND E.ACTIVE_FLAG(+) = 'Y'
           AND B.COMPANY_ID    = A.COMPANY_ID
           AND B.DIVISION_ID   = A.DIVISION_ID
           AND B.SITE_ID       = A.SITE_ID
           AND B.PLANT_ID      = A.PLANT_ID
           AND B.CELL_MODEL_ID = A.MODEL_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND C.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND C.DIVISION_ID = A.CHILD_DIVISION_ID
           AND C.SITE_ID     = A.CHILD_SITE_ID
           AND C.ACTIVE_FLAG = 'Y'
           AND D.DIVISION_ID = A.DIVISION_ID
           AND D.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(D.ATTRIBUTE8, ' ') NOT LIKE 'CA%'   /* Cell Assy 제외 */
           AND D.OPERATION_GROUP = 'E'       /* Child 전극 */
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR E.ITEM_ID IS NOT NULL);
        P_GATHER('GT_0039_LINE_ASSIGN_CELL_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* 전극 PROJECT ROUTE                                                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE_ELEC';
        INSERT INTO GT_0039_PROJECT_ROUTE_ELEC
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , PLANT_SITE_ID
          , DIVISION_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , A.PLANT_SITE_ID
             , B.DIVISION_ID
             , B.COMPANY_ID
             , B.SITE_ID
             , B.PLANT_ID
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE               B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND B.SITE_TYPE   = 'PLANT'
           AND B.VALID_YN    = 'Y'
           AND B.OPERATION_GROUP = 'E'   /* 전극 Plant Site */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= '20260824';
        P_GATHER('GT_0039_PROJECT_ROUTE_ELEC');

        /* ---------------------------------------------------------------------------------------- */
        /* 전극 Line Assign 안된 데이터                                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TT_CASE_4';
        INSERT INTO GT_0039_TT_CASE_4
        (
            DIVISION_ID
          , ELEC_MODEL_ID
          , ELEC_NICK_NAME
          , PLANT_SITE_ID
          , OPERATION_ID
          , MASTER_INVLD_CTN
        )
        SELECT DISTINCT
               B.DIVISION_ID          AS DIVISION_ID
             , B.ITEM_ID              AS ELEC_MODEL_ID
             , A.ELEC_NICK_NAME
             , B.PLANT_SITE_ID
             , A.CHILD_OPERATION_ID   AS OPERATION_ID
             , CAST(NULL AS VARCHAR2(250 CHAR))  AS MASTER_INVLD_CTN
          FROM GT_0039_LINE_ASSIGN_CELL_BOM A
             , GT_0039_PROJECT_ROUTE_ELEC   B
               /* AS-IS 의 LEFT JOIN ON 절에 있던 SCP 계획 공정 제한 / ACTIVE_FLAG / PRIORITY 조건은
                  인라인 뷰로 옮긴다 (Oracle 은 (+) 조인 조건에 서브쿼리를 쓸 수 없다 - ORA-01799) */
             , ( SELECT XA.COMPANY_ID
                      , XA.DIVISION_ID
                      , XA.SITE_ID
                      , XA.PLANT_ID
                      , XA.ITEM_ID
                      , XA.OPERATION_ID
                      , XA.MONTH
                      , XA.LINE_ID
                   FROM SCM_MST_ITEM_LINE_ASSIGN_SN XA
                      , GT_0039_SCP_PLAN_OPERATION  XB   /* scp 계획 공정으로 범위 제한 */
                  WHERE XB.OPERATION_ID = XA.OPERATION_ID
                    AND XA.ACTIVE_FLAG = 'Y'
                    AND XA.PRIORITY NOT IN ('0', '9') ) C
         WHERE A.CHILD_ITEM_ID = B.ITEM_ID
           AND A.PLANT_ID      = B.PLANT_ID   /* 2025.08.20 PJ20257329 cell/전극 동일 plant 조건 추가 */
           AND C.COMPANY_ID(+)   = B.COMPANY_ID
           AND C.DIVISION_ID(+)  = B.DIVISION_ID
           AND C.SITE_ID(+)      = B.SITE_ID
           AND C.PLANT_ID(+)     = B.PLANT_ID
           AND C.ITEM_ID(+)      = B.ITEM_ID
           AND C.OPERATION_ID(+) = A.CHILD_OPERATION_ID
           AND C.MONTH(+) BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)   /* 6/30 */
           AND C.LINE_ID IS NULL   /* 전극 line assign 누락 데이터 */
           AND NOT EXISTS ( SELECT 1
                              FROM SCM_MST_ITEM_LINE_ASSIGN_SN XB
                                 , SCM_MST_LINE_SN             XC
                             WHERE XC.COMPANY_ID   = XB.COMPANY_ID
                               AND XC.DIVISION_ID  = XB.DIVISION_ID
                               AND XC.SITE_ID      = XB.SITE_ID
                               AND XC.PLANT_ID     = XB.PLANT_ID
                               AND XC.FACTORY_ID   = XB.FACTORY_ID
                               AND XC.OPERATION_ID = XB.OPERATION_ID
                               AND XC.LINE_ID      = XB.LINE_ID
                               AND XC.ACTIVE_FLAG  = 'Y'
                               AND XB.COMPANY_ID   = B.COMPANY_ID
                               AND XB.DIVISION_ID  = B.DIVISION_ID
                               AND XB.SITE_ID      = B.SITE_ID
                               AND XB.PLANT_ID     = B.PLANT_ID
                               AND XB.ITEM_ID      = B.ITEM_ID
                               AND XB.OPERATION_ID = A.CHILD_OPERATION_ID
                               AND XB.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
                               AND XB.PRIORITY NOT IN ('0', '9')
                               AND XB.ACTIVE_FLAG = 'Y'
                               AND XB.OPERATION_ID IN ( SELECT XD.OPERATION_ID FROM GT_0039_SCP_PLAN_OPERATION XD ) );
        P_GATHER('GT_0039_TT_CASE_4');

        /* ---------------------------------------------------------------------------------------- */
        /* 전극 Line Assign 되고 Tact Time 미등록 데이터                                             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TT_CASE_4_2';
        INSERT INTO GT_0039_TT_CASE_4_2
        (
            DIVISION_ID
          , ITEM_ID
          , PLANT_SITE_ID
          , OPERATION_ID
          , LINE_ID
        )
        SELECT DISTINCT
               C.DIVISION_ID
             , C.ITEM_ID
             , B.PLANT_SITE_ID
             , C.OPERATION_ID
             , C.LINE_ID
          FROM GT_0039_LINE_ASSIGN_CELL_BOM A
             , GT_0039_PROJECT_ROUTE_ELEC   B
             , SCM_MST_ITEM_LINE_ASSIGN_SN  C
             , SCM_MST_LINE_SN              D   /* 2025.08.20 PJ20257329 유효한 라인만 참조 */
             , GT_0039_SCP_PLAN_OPERATION   E   /* 2025.08.20 PJ20257329 SCP Plan Operation 으로 참조 범위 제한 */
         WHERE A.CHILD_ITEM_ID = B.ITEM_ID
           AND A.PLANT_ID      = B.PLANT_ID
           AND C.COMPANY_ID   = B.COMPANY_ID
           AND C.DIVISION_ID  = B.DIVISION_ID
           AND C.SITE_ID      = B.SITE_ID
           AND C.PLANT_ID     = B.PLANT_ID
           AND C.ITEM_ID      = B.ITEM_ID
           AND C.OPERATION_ID = A.CHILD_OPERATION_ID
           AND C.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)   /* 6/30 */
           AND C.PRIORITY NOT IN ('0', '9')
           AND C.ACTIVE_FLAG = 'Y'   /* 6/30 */
           AND D.COMPANY_ID   = C.COMPANY_ID
           AND D.DIVISION_ID  = C.DIVISION_ID
           AND D.SITE_ID      = C.SITE_ID
           AND D.PLANT_ID     = C.PLANT_ID
           AND D.FACTORY_ID   = C.FACTORY_ID
           AND D.OPERATION_ID = C.OPERATION_ID
           AND D.LINE_ID      = C.LINE_ID
           AND D.ACTIVE_FLAG  = 'Y'
           AND E.OPERATION_ID = C.OPERATION_ID
           AND NOT EXISTS ( SELECT 1   /* fp tact time */
                              FROM GT_0039_FP_TACT_TIME XA
                             WHERE XA.PLANT_SITE_ID = B.PLANT_SITE_ID
                               AND XA.ITEM_ID       = C.ITEM_ID
                               AND XA.LINE_ID       = C.LINE_ID
                               AND XA.OPERATION_ID  = C.OPERATION_ID )
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_SCP_TACT_TIME XB
                             WHERE XB.PLANT_SITE_ID = B.PLANT_SITE_ID
                               AND XB.LINE_ID       = C.LINE_ID
                               AND XB.ITEM_ID       = C.ITEM_ID
                               AND XB.OPERATION_ID  = C.OPERATION_ID )
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_SCP_TACT_TIME_EXCEPT XC
                             WHERE XC.PLANT_SITE_ID = B.PLANT_SITE_ID
                               AND XC.LINE_ID       = C.LINE_ID
                               AND XC.ITEM_ID       = C.ITEM_ID
                               AND XC.OPERATION_ID  = C.OPERATION_ID );
        P_GATHER('GT_0039_TT_CASE_4_2');

        /* ---------------------------------------------------------------------------------------- */
        /* case 5 : SCP Plan 버전 정보                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PLAN_VERSION';
        INSERT INTO GT_0039_SCP_PLAN_VERSION
        (
            DIVISION_ID
          , PLAN_TYPE
          , PLAN_SEQ
          , PLAN_START_YYYYMMDD
          , HORIZON_END_DATE
          , PLAN_STATUS
          , CONFIRM_FLAG
          , PLAN_PRIORITY
        )
        SELECT IA.DIVISION_ID
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IA.PLAN_START_YYYYMMDD
             , IA.HORIZON_END_DATE
             , IA.PLAN_STATUS
             , IA.CONFIRM_FLAG
             , IA.PLAN_PRIORITY
          FROM ( SELECT A.DIVISION_ID
                      , B.PLAN_TYPE
                      , B.PLAN_SEQ
                      , A.PLAN_NAME                            AS PLAN_START_YYYYMMDD
                      , SUBSTR(A.HORIZON_END_DATE, 1, 8)       AS HORIZON_END_DATE
                      , B.PLAN_STATUS
                      , B.CONFIRM_FLAG
                      , DENSE_RANK() OVER (PARTITION BY A.DIVISION_ID
                                               ORDER BY A.PLAN_NAME DESC
                                                      , B.INPUT_START_DATE DESC)  AS PLAN_PRIORITY
                   FROM SCM_MST_PLAN        A
                      , SCM_MST_PLAN_DETAIL B
                  WHERE B.DIVISION_ID = A.DIVISION_ID
                    AND B.PLAN_ID     = A.PLAN_ID
                    AND B.PLAN_STATUS = '1'   /* 정상 완료 */
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.PLAN_CYCLE  = 'WEEKLY'
                    AND A.PLAN_NAME   = V_FROM_YYYYMMDD ) IA
         WHERE IA.PLAN_PRIORITY = 1;
        P_GATHER('GT_0039_SCP_PLAN_VERSION');

        /* 계획 버전은 PLAN_PRIORITY = 1 로 한 건이다. GTT 와 조인하면 대용량 파티션 테이블에
           파티션 프루닝이 걸리지 않아 조회가 폭주하므로, 값을 변수로 받아 상수 조건으로 준다. */
        SELECT MAX(DIVISION_ID)
             , MAX(PLAN_TYPE)
             , MAX(PLAN_SEQ)
             , MAX(PLAN_START_YYYYMMDD)
             , MAX(HORIZON_END_DATE)
          INTO V_PLAN_DIVISION
             , V_PLAN_TYPE
             , V_PLAN_SEQ
             , V_PLAN_START
             , V_HORIZON_END
          FROM GT_0039_SCP_PLAN_VERSION;


        /* ---------------------------------------------------------------------------------------- */
        /* Current 생산계획 - Tact Time 범위 밖의 생산계획                                           */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TT_CASE_5';
        INSERT INTO GT_0039_TT_CASE_5
        (
            DIVISION_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , OPERATION_GROUP
          , SCM_SITE_ID
          , SITE_DESCRIPTION
          , ITEM_ID
          , LINE_ID
          , OPERATION_ID
          , PROD_MONTH
          , QTY
        )
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , C.SITE_DESCRIPTION
             , A.ITEM_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , SUBSTR(A.YYYYMMDD, 1, 6)  AS PROD_MONTH
             , SUM(A.QTY)                AS QTY
          FROM SCP_ANL_PRODUCTION_PLAN   A
             , SCM_MST_SITE              C
             , SCM_MST_TACT_TIME_SN      D
             , SCP_MST_TACT_TIME_EXCEPT  E
         WHERE A.DIVISION_ID         = V_PLAN_DIVISION
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_PLAN_SEQ
           AND A.YYYYMMDD           <= V_HORIZON_END
           AND C.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.SITE_TYPE   = 'PLANT'
           AND C.VALID_YN    = 'Y'
           AND D.COMPANY_ID(+)   = C.COMPANY_ID
           AND D.DIVISION_ID(+)  = C.DIVISION_ID
           AND D.SITE_ID(+)      = C.SITE_ID
           AND D.PLANT_ID(+)     = C.PLANT_ID
           AND D.OPERATION_ID(+) = A.OPERATION_ID
           AND D.LINE_ID(+)      = A.LINE_ID
           AND D.ITEM_ID(+)      = A.ITEM_ID
           AND D.MONTH(+)       >= '202608'
           AND D.MONTH(+)        = SUBSTR(A.YYYYMMDD, 1, 6)   /* 해당 범위 내 */
           AND D.TACT_TIME(+)   != 0
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PLANT_SITE_ID(+) = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.OPERATION_ID(+)  = A.OPERATION_ID
           AND E.LINE_ID(+)       = A.LINE_ID
           AND E.USE_YN(+)        = 'Y'
           AND E.TACT_TIME(+)     > 0
           AND A.MEASURE = 'PROD_PLAN_AMEND'
           AND A.QTY != 0
           AND D.ITEM_ID IS NULL   /* FP Tact Time 기간 범위내 생산계획이 아닌 경우 */
           AND E.ITEM_ID IS NULL   /* SCP Tact Time Except 기간 범위내 생산계획이 아닌 경우 */
           AND (
                 EXISTS ( SELECT 1   /* fp tact time 존재 */
                            FROM SCM_MST_TACT_TIME_SN XA
                           WHERE XA.COMPANY_ID  = C.COMPANY_ID
                             AND XA.DIVISION_ID = C.DIVISION_ID
                             AND XA.SITE_ID     = C.SITE_ID
                             AND XA.PLANT_ID    = C.PLANT_ID
                             AND XA.LINE_ID     = A.LINE_ID
                             AND XA.ITEM_ID     = A.ITEM_ID
                             AND XA.MONTH BETWEEN SUBSTR(V_FROM_YYYYMMDD, 1, 6) AND SUBSTR(V_TO_YYYYMMDD, 1, 6)
                             AND XA.TACT_TIME > 0 )
                 OR
                 EXISTS ( SELECT 1
                            FROM SCP_MST_TACT_TIME XB
                           WHERE XB.DIVISION_ID   = A.DIVISION_ID
                             AND XB.PLANT_SITE_ID = A.SCM_SITE_ID
                             AND XB.ITEM_ID       = A.ITEM_ID
                             AND XB.OPERATION_ID  = A.OPERATION_ID
                             AND XB.LINE_ID       = A.LINE_ID
                             AND XB.VALID_YN  = 'Y'
                             AND XB.TACT_TIME > 0 )
                 OR
                 EXISTS ( SELECT 1
                            FROM SCP_MST_TACT_TIME_EXCEPT XC
                           WHERE XC.DIVISION_ID   = A.DIVISION_ID
                             AND XC.PLANT_SITE_ID = A.SCM_SITE_ID
                             AND XC.ITEM_ID       = A.ITEM_ID
                             AND XC.OPERATION_ID  = A.OPERATION_ID
                             AND XC.LINE_ID       = A.LINE_ID
                             AND XC.USE_YN    = 'Y'
                             AND XC.TACT_TIME > 0 )
               )
         GROUP BY A.DIVISION_ID
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.SEQ
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , C.SITE_DESCRIPTION
                , A.ITEM_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , SUBSTR(A.YYYYMMDD, 1, 6);
        P_GATHER('GT_0039_TT_CASE_5');

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        /* Project Route 미등록 */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , A.SALES_ITEM_ID      AS MODEL_ID
             , A.MODEL_NICK_NAME    AS NICK_NAME
             , A.MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.PROJECT_CODE       AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
               /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
            || CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND A.CHILD_OPERATION_GROUP = 'A'
                    THEN ' ,Cell Prod Site : ' || C.NAME
                    ELSE ''
               END                  AS MASTER_INVLD_CTN
          FROM GT_0039_PR_NOT_EXISTS      A
             , SCM_MST_SITE               B
             , GT_0039_CELL_PROD_SITE_ID  C
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.SCM_SITE_ID = A.SALES_SITE_ID
           AND C.CODE(+)     = A.CELL_PROD_SITE_ID
         UNION ALL
        /*
        2) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
           해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
         >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우
        */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , A.MODEL_ID
             , B.NICK_NAME
             , 'TTT02'              AS MASTER_INVLD_CD
             , A.PLANT_SITE
             , A.CHILD_OPERATION_ID AS PROJECT_OPERATION
             , NULL                 AS INCOTERMS_LINE
             , NULL                 AS QTY
             , A.DESCR              AS MASTER_INVLD_CTN
          FROM GT_0039_TT_CASE_2  A
             , SCP_MST_FINAL_ITEM B
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
         UNION ALL
        /*
        3) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
           해당 모델의 'LINE' ASSIGN 정보를 기반으로
         >> ASSIGN 된 LINE 내 TACT TIME 이 조회되지 않는경우
        */
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , B.NICK_NAME
             , 'TTT03'              AS MASTER_INVLD_CD
             , A.PLANT_SITE
             , A.CHILD_OPERATION_ID AS PROJECT_OPERATION
             , A.LINE_ID            AS INCOTERMS_LINE
             , NULL                 AS QTY
             , A.DESCR              AS MASTER_INVLD_CTN
          FROM GT_0039_TT_CASE_3  A
             , SCP_MST_FINAL_ITEM B
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
         UNION ALL
        /*
        4) (전극) CURRENT 상위BOM '셀' LINE ASSIGN이 되어있는 '모델' 정보와
           해당 모델의 E2000(코팅) 공정의 BOM 정보를 기반으로
         >> 전극 LINE ASSIGN 정보가 모든 PLANT에서 없거나(LINE ASSIGN미등록)
         >> ASSIGN 된 LINE 내 TACT TIME 이 조회
        */
        SELECT A.DIVISION_ID
             , A.ELEC_MODEL_ID
             , A.ELEC_NICK_NAME
             , 'TTT04'              AS MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.OPERATION_ID       AS PROJECT_OPERATION
             , NULL                 AS INCOTERMS_LINE
             , NULL                 AS QTY
             , 'line assign 미등록'  AS MASTER_INVLD_CTN
          FROM GT_0039_TT_CASE_4 A   /* line assign 미등록 */
             , SCM_MST_SITE      B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.PLANT_SITE_ID
         UNION ALL
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.NICK_NAME
             , 'TTT04'              AS MASTER_INVLD_CD
             , C.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.OPERATION_ID       AS PROJECT_OPERATION
             , NULL                 AS INCOTERMS_LINE
             , NULL                 AS QTY
             , 'line assign 등록 / tact time 미등록 / Line ' || A.LINE_ID  AS MASTER_INVLD_CTN
          FROM GT_0039_TT_CASE_4_2 A   /* line assign 등록 / tact time 미등록 */
             , SCP_MST_FINAL_ITEM  B
             , SCM_MST_SITE        C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.SCM_SITE_ID = A.PLANT_SITE_ID
         UNION ALL
        /*
        5) CURRENT PROD AMEND 에 입력되어 있는 '모델'/'PLANT'/'LINE'/'생산계획날짜' 정보를 기반으로
         >> 생산계획 시기가 CAPA:TACT TIME 날짜외 구간에 입력되어 있는 경우
        */
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.NICK_NAME
             , 'TTT05'              AS MASTER_INVLD_CD
             , A.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.OPERATION_ID       AS PROJECT_OPERATION
             , A.LINE_ID            AS INCOTERMS_LINE
             , A.QTY
             , 'Prod Plan Month :' || A.PROD_MONTH  AS MASTER_INVLD_CTN
          FROM GT_0039_TT_CASE_5  A
             , SCP_MST_FINAL_ITEM B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID;
        P_GATHER('GT_0039_TARGET_DATA');

        V_STEP := '전극 Applied Cell Model';
        P_LOAD_ELEC_APPLIED_MODEL(V_DIVISION_ID);

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 - Basic Cell Nick Name 매핑                                           */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , D.BASIC_NICK_NAME    AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA        A
             , SCP_MST_FINAL_ITEM         B
             , GT_0039_ELEC_APPLIED_MODEL C
             , SCP_MST_ITEM_BSI_IFO       D
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.ITEM_ID(+)     = A.MODEL_ID
           AND D.ITEM_ID(+)     = CASE WHEN B.OPERATION_GROUP = 'E' THEN C.APPLIED_MODEL
                                       WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                       ELSE A.MODEL_ID
                                  END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT DISTINCT   /* PJ20257329 2025.09.12 중복 데이터 제거 */
                   A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , ITEM_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_TACT_TIME;

    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_BOD                                                     */
    /* Description : BOD 조회                                                                       */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release PJ2024A332R                                              */
    /* 2025/08/13  hrkim   PJ20257329 수요 최종 변경일 추가                                          */
    /* 2025/09/12  hrkim   PJ20257329 소형 Cell Prod Site 적용, 중복 데이터 제거                     */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_BOD
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT     VARCHAR2(4000);
        V_STEP           VARCHAR2(100);
        V_DIVISION_ID    VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID  VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD  VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD    VARCHAR2(8  CHAR);
        V_PLAN_DIVISION  VARCHAR2(30 CHAR);
        V_PLAN_TYPE      VARCHAR2(50 CHAR);
        V_PLAN_SEQ       NUMBER;
        V_PLAN_START     VARCHAR2(8  CHAR);
        V_HORIZON_END    VARCHAR2(8  CHAR);
    BEGIN

/*
--================================================================================================================================
2) CURRENT MKT FCST DP에 입력되어 있는 '모델' / TO SITE'/ 'INCOTERMS'와
   해당 모델의 PJT ROUTE의 FROM SITE 정보를 기반으로
 >> FROM SITE/TO SITE/INCOTERMS 로 MAPPING되는 BOD ID 정보가 없는 경우

3) CURRENT SHIP SEMI/FG SHIP PLAN 에 입력되어 있는 모델
 >> 해당 모델의 출하계획 시기가 BOD ID의 FROM-TO 날짜외 계획있는 경우, 사용한 BOD ID의 VALID N 인 경우
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'AS_SITE_PLANT';
        P_LOAD_AS_SITE_PLANT;

        V_STEP := 'CFM_MKT_DEMAND_PLAN';
        P_LOAD_CFM_MKT_DEMAND_PLAN(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'CELL_PROD_SITE_ID';
        P_LOAD_CELL_PROD_SITE_ID;

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_SCM_MST_SITE_FROM;
        DELETE FROM GT_0039_SCM_MST_SITE_TO;
        DELETE FROM GT_0039_MKT_FCST;
        DELETE FROM GT_0039_SCP_BOM;
        DELETE FROM GT_0039_PROJECT_ROUTE;
        DELETE FROM GT_0039_PR_NOT_EXISTS;
        DELETE FROM GT_0039_BOD;
        DELETE FROM GT_0039_TRANSPORT_MODE;
        DELETE FROM GT_0039_FROM_SITE_BY_PR;
        DELETE FROM GT_0039_BOD_NOT_EXISTS;
        DELETE FROM GT_0039_SCP_PLAN_VERSION;
        DELETE FROM GT_0039_SHIP_PLAN_FG;
        DELETE FROM GT_0039_SHIP_PLAN_SEMI;
        DELETE FROM GT_0039_INVALID_BOD_SHIP_PLAN;
        DELETE FROM GT_0039_TARGET_DATA;
        DELETE FROM GT_0039_TARGET_DATA_BC_NICK;

        /* ---------------------------------------------------------------------------------------- */
        /* From Site (SCM_MST_SITE) -- 6/27                                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCM_MST_SITE_FROM';
        INSERT INTO GT_0039_SCM_MST_SITE_FROM
        (
            SCM_SITE_ID
          , SITE_DESCRIPTION
          , OSP_YN
          , OPERATION_GROUP
          , COUNTRY
          , CITY
        )
        SELECT SCM_SITE_ID
             , SITE_DESCRIPTION
             , OSP_YN
             , OPERATION_GROUP
             , COUNTRY
             , CITY
          FROM SCM_MST_SITE
         WHERE DIVISION_ID = V_DIVISION_ID
           AND SITE_TYPE   = 'PLANT'
           AND VALID_YN    = 'Y';
        P_GATHER('GT_0039_SCM_MST_SITE_FROM');

        /* ---------------------------------------------------------------------------------------- */
        /* To Site (SCM_MST_SITE) -- 6/27                                                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCM_MST_SITE_TO';
        INSERT INTO GT_0039_SCM_MST_SITE_TO
        (
            SCM_SITE_ID
          , SITE_DESCRIPTION
          , SITE_TYPE
          , OPERATION_GROUP
          , VMI_YN
          , COUNTRY
          , CITY
          , END_CUSTOMER
        )
        SELECT IA.SCM_SITE_ID
             , MAX(IA.SITE_DESCRIPTION)                                                                                AS SITE_DESCRIPTION
             , MAX(IA.SITE_TYPE)                                                                                       AS SITE_TYPE
             , MAX(IA.OPERATION_GROUP)                                                                                 AS OPERATION_GROUP
             , MAX(CASE WHEN IA.SITE_TYPE = 'SALES' AND IA.DIVISION_ID = V_DIVISION_ID THEN IA.VMI_YN       ELSE NULL END)  AS VMI_YN
             , MAX(CASE WHEN IA.SITE_TYPE = 'SALES' AND IA.DIVISION_ID = V_DIVISION_ID THEN IA.COUNTRY      ELSE NULL END)  AS COUNTRY
             , MAX(CASE WHEN IA.SITE_TYPE = 'SALES' AND IA.DIVISION_ID = V_DIVISION_ID THEN IA.CITY         ELSE NULL END)  AS CITY
             , MAX(CASE WHEN IA.SITE_TYPE = 'SALES' AND IA.DIVISION_ID = V_DIVISION_ID THEN IA.END_CUSTOMER ELSE NULL END)  AS END_CUSTOMER
          FROM ( SELECT DIVISION_ID
                      , SCM_SITE_ID
                      , SITE_DESCRIPTION
                      , SITE_TYPE
                      , OPERATION_GROUP
                      , VMI_YN
                      , COUNTRY
                      , CITY
                      , END_CUSTOMER
                   FROM SCM_MST_SITE
                  WHERE VALID_YN    = 'Y'
                    AND DIVISION_ID = V_DIVISION_ID
                  UNION
                 SELECT DIVISION_ID
                      , SCM_SITE_ID
                      , SITE_DESCRIPTION
                      , SITE_TYPE
                      , OPERATION_GROUP
                      , VMI_YN
                      , COUNTRY
                      , CITY
                      , END_CUSTOMER
                   FROM SCM_MST_SITE
                  WHERE VALID_YN = 'Y'
                    AND SCM_SITE_ID LIKE '%' || '-A' ) IA
         GROUP BY IA.SCM_SITE_ID;
        P_GATHER('GT_0039_SCM_MST_SITE_TO');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST (To Site)                                                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'MKT_FCST';
        INSERT INTO GT_0039_MKT_FCST
        (
            SALES_SITE_ID
          , TO_COUNTRY
          , TO_CITY
          , CUSTOMER
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MEASURE
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
        )
        SELECT A.SCM_SITE_ID                  AS SALES_SITE_ID
             , B.COUNTRY                      AS TO_COUNTRY
             , B.CITY                         AS TO_CITY
             , B.END_CUSTOMER                 AS CUSTOMER
             , A.PROJECT_CODE                 AS PROJECT_CODE
             , A.ITEM_ID                      AS SALES_ITEM_ID
             , A.INCOTERMS
             , A.MEASURE
             , SUBSTR(C.FLOW_ID, 1, 5)        AS MODEL_OPERATION_ID
             , C.OPERATION_GROUP              AS MODEL_OPERATION_GROUP
             , C.NICK_NAME                    AS MODEL_NICK_NAME
             , MIN(A.YYYYMMDD)                AS SALES_FROM_YYYYMMDD
             , MAX(A.YYYYMMDD)                AS SALES_TO_YYYYMMDD
             , SUM(CASE WHEN NVL(E.RN, 1) = 1 THEN A.QTY ELSE 0 END)  AS QTY
             , TO_CHAR(MAX(A.LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS')  AS MF_LAST_UPDATE_DATE   /* 2025.08.13 추가 */
             , E.CELL_PROD_SITE_ID
             , E.COMPANY_ID                   AS COMPANY_ID_CELL_PROD
             , E.SITE_ID                      AS SITE_ID_CELL_PROD
             , E.PLANT_ID                     AS PLANT_ID_CELL_PROD
          FROM DM_PLN_MKT_FCST           A
             , GT_0039_SCM_MST_SITE_TO   B
             , SCP_MST_FINAL_ITEM        C
             , GT_0039_AS_SITE_PLANT     D
             , GT_0039_CFM_MKT_DMND_PLAN E
         WHERE B.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND C.OPERATION_GROUP != 'E'   /* 전극 제외 */
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND E.DIVISION_ID(+)   = A.DIVISION_ID
           AND E.PROJECT_CODE(+)  = A.PROJECT_CODE
           AND E.SCM_SITE_ID(+)   = A.SCM_SITE_ID
           AND E.ITEM_ID(+)       = A.ITEM_ID
           AND E.DOM_EXP(+)       = A.DOM_EXP
           AND E.FCST_TYPE(+)     = A.FCST_TYPE
           AND E.INCOTERMS(+)     = A.INCOTERMS
           AND E.MEASURE(+)       = A.MEASURE
           AND E.YYYYMMDD(+)      = A.YYYYMMDD
           AND E.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.MEASURE     = CASE WHEN B.SITE_TYPE = 'SALES' AND B.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                    WHEN B.VMI_YN = 'Y'                                    THEN 'VMI_In_Req'
                                    WHEN TRIM(A.ATTRIBUTE10) IS NULL                       THEN 'MKT_FCST'   /* AS-IS ISNULL(ATTRIBUTE10,'')='' - 이관 시 빈값이 공백으로 들어와 IS NULL 만으로는 빠진다 */
                               END
           AND A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
           AND A.QTY != 0
           AND D.SCM_SITE_ID IS NULL
         GROUP BY A.SCM_SITE_ID
                , B.COUNTRY
                , B.CITY
                , B.END_CUSTOMER
                , A.PROJECT_CODE
                , A.ITEM_ID
                , A.INCOTERMS
                , A.MEASURE
                , C.FLOW_ID
                , C.OPERATION_GROUP
                , C.NICK_NAME
                , E.CELL_PROD_SITE_ID
                , E.COMPANY_ID
                , E.SITE_ID
                , E.PLANT_ID;
        P_GATHER('GT_0039_MKT_FCST');

        /* ---------------------------------------------------------------------------------------- */
        /* BOM                                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_BOM';
        INSERT INTO GT_0039_SCP_BOM
        (
            MODEL_ID
          , COMPANY_ID
          , SITE_ID
          , PLANT_ID
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , CHILD_ELECTRODE_TYPE
        )
        SELECT DISTINCT
               A.MODEL_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.CHILD_ITEM_ID
             , CASE WHEN C.OPERATION_GROUP_ID NOT IN ('A', 'E')
                    THEN 'P'
                    ELSE C.OPERATION_GROUP_ID
               END                      AS CHILD_OPERATION_GROUP
             , SUBSTR(C.FLOW_ID, 1, 5)  AS CHILD_OPERATION_ID
             , C.ELECTRODE_TYPE         AS CHILD_ELECTRODE_TYPE
          FROM SCM_MST_MODEL_BOM   A
             , SCM_MST_ITEM_SN     B
             , SCP_MST_FINAL_ITEM  C
             , SCM_MST_ITEM_SN     D
         WHERE B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.COMPANY_ID  = A.CHILD_COMPANY_ID
           AND B.DIVISION_ID = A.CHILD_DIVISION_ID
           AND B.SITE_ID     = A.CHILD_SITE_ID
           AND B.ACTIVE_FLAG = 'Y'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND NVL(C.ATTRIBUTE8, ' ') NOT LIKE 'CA%'
           AND C.OPERATION_GROUP != 'E'
           AND D.ITEM_ID(+)     = A.PARENT_ITEM_ID
           AND D.COMPANY_ID(+)  = A.COMPANY_ID
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.SITE_ID(+)     = A.SITE_ID
           AND D.ACTIVE_FLAG(+) = 'Y'
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND A.ALT_PRIORITY = 'Y'
           AND (A.PARENT_ITEM_ID = '*' OR D.ITEM_ID IS NOT NULL)
           AND EXISTS ( SELECT 1
                          FROM GT_0039_MKT_FCST XA
                         WHERE A.MODEL_ID   = XA.SALES_ITEM_ID
                           AND A.COMPANY_ID = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.COMPANY_ID_CELL_PROD
                                                   ELSE A.COMPANY_ID
                                              END
                           AND A.SITE_ID    = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.SITE_ID_CELL_PROD
                                                   ELSE A.SITE_ID
                                              END
                           AND A.PLANT_ID   = CASE WHEN XA.CELL_PROD_SITE_ID IS NOT NULL AND C.OPERATION_GROUP = 'A'
                                                   THEN XA.PLANT_ID_CELL_PROD
                                                   ELSE A.PLANT_ID
                                              END );
        P_GATHER('GT_0039_SCP_BOM');

        /* ---------------------------------------------------------------------------------------- */
        /* PROJECT ROUTE                                                                             */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PROJECT_ROUTE';
        INSERT INTO GT_0039_PROJECT_ROUTE
        (
            ITEM_ID
          , SALES_SITE_ID
          , PROJECT_CODE
          , PLANT_SITE_ID
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , COUNTRY
          , CITY
          , PR_PRIORITY
        )
        SELECT A.ITEM_ID
             , A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.PLANT_SITE_ID
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , B.COUNTRY
             , B.CITY
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID
                                             , A.SALES_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.FROM_YYYYMMDD
                                             , A.TO_YYYYMMDD
                                      ORDER BY A.PRIORITY)  AS PR_PRIORITY
          FROM SCM_MST_SITE_ITEM_PRIORITY  A
             , GT_0039_SCM_MST_SITE_FROM   B
         WHERE B.SCM_SITE_ID = A.PLANT_SITE_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND A.TO_YYYYMMDD >= V_FROM_YYYYMMDD;
        P_GATHER('GT_0039_PROJECT_ROUTE');

        /* ---------------------------------------------------------------------------------------- */
        /* MKT FCST 기준 Project Route 존재하지 않는 데이터                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'PR_NOT_EXISTS';
        INSERT INTO GT_0039_PR_NOT_EXISTS
        (
            SALES_SITE_ID
          , PROJECT_CODE
          , SALES_ITEM_ID
          , INCOTERMS
          , MODEL_OPERATION_ID
          , MODEL_OPERATION_GROUP
          , MODEL_NICK_NAME
          , SALES_FROM_YYYYMMDD
          , SALES_TO_YYYYMMDD
          , QTY
          , MF_LAST_UPDATE_DATE
          , CELL_PROD_SITE_ID
          , COMPANY_ID_CELL_PROD
          , SITE_ID_CELL_PROD
          , PLANT_ID_CELL_PROD
          , CHILD_ITEM_ID
          , CHILD_OPERATION_GROUP
          , CHILD_OPERATION_ID
          , MASTER_INVLD_CD
          , MASTER_INVLD_CTN
        )
        SELECT A.SALES_SITE_ID
             , A.PROJECT_CODE
             , A.SALES_ITEM_ID
             , A.INCOTERMS
             , A.MODEL_OPERATION_ID
             , A.MODEL_OPERATION_GROUP
             , A.MODEL_NICK_NAME
             , A.SALES_FROM_YYYYMMDD
             , A.SALES_TO_YYYYMMDD
             , A.QTY
             , A.MF_LAST_UPDATE_DATE
             , A.CELL_PROD_SITE_ID
             , A.COMPANY_ID_CELL_PROD
             , A.SITE_ID_CELL_PROD
             , A.PLANT_ID_CELL_PROD
             , B.CHILD_ITEM_ID
             , B.CHILD_OPERATION_GROUP
             , B.CHILD_OPERATION_ID
             , 'COM01'                                       AS MASTER_INVLD_CD
             , 'Sales Period:' || A.SALES_FROM_YYYYMMDD || '~' || A.SALES_TO_YYYYMMDD
            || ', Target Item:' || B.CHILD_ITEM_ID
            || ', FCST Last Update :' || A.MF_LAST_UPDATE_DATE  AS MASTER_INVLD_CTN   /* 2025.08.13 수요 최종 변경일 추가 */
          FROM GT_0039_MKT_FCST A
             , GT_0039_SCP_BOM  B
         WHERE A.SALES_ITEM_ID = B.MODEL_ID
           AND B.COMPANY_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.COMPANY_ID_CELL_PROD
                                   ELSE B.COMPANY_ID
                              END
           AND B.SITE_ID    = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.SITE_ID_CELL_PROD
                                   ELSE B.SITE_ID
                              END
           AND B.PLANT_ID   = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                   THEN A.PLANT_ID_CELL_PROD
                                   ELSE B.PLANT_ID
                              END
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_PROJECT_ROUTE XA
                             WHERE XA.ITEM_ID = B.CHILD_ITEM_ID
                               AND XA.PLANT_SITE_ID = CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND B.CHILD_OPERATION_GROUP = 'A'
                                                           THEN A.CELL_PROD_SITE_ID
                                                           ELSE XA.PLANT_SITE_ID
                                                      END
                               AND XA.PROJECT_CODE  = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.PROJECT_CODE
                                                      END
                               AND XA.SALES_SITE_ID = CASE WHEN V_DIVISION_ID IN ('40', '82') OR B.CHILD_OPERATION_GROUP = 'E'
                                                           THEN '-'
                                                           ELSE A.SALES_SITE_ID
                                                      END );
        P_GATHER('GT_0039_PR_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* case 2 : BOD                                                                              */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'BOD';
        INSERT INTO GT_0039_BOD
        (
            BOD_ID
          , ROUTE_ID
          , DIVISION_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , TRANSPORT_MODE
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , BOD_VALID_YN
          , ROUTE_VALID_YN
        )
        SELECT A.BOD_ID
             , B.ROUTE_ID
             , A.DIVISION_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , B.TRANSPORT_MODE
             , A.ATTRIBUTE2  AS FROM_YYYYMMDD
             , A.ATTRIBUTE3  AS TO_YYYYMMDD
             , A.VALID_YN    AS BOD_VALID_YN
             , B.VALID_YN    AS ROUTE_VALID_YN
          FROM SCP_MST_BOD                A
             , SCP_MST_DISTRIBUTION_ROUTE B
         WHERE B.ROUTE_ID = A.ROUTE_ID;
        P_GATHER('GT_0039_BOD');

        /* ---------------------------------------------------------------------------------------- */
        /* Transport Mode                                                                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TRANSPORT_MODE';
        INSERT INTO GT_0039_TRANSPORT_MODE
        (
            FROM_COUNTRY
          , FROM_CITY
          , TO_COUNTRY
          , TO_CITY
          , TRANSPORT_MODE
        )
        SELECT DISTINCT
               FROM_COUNTRY
             , FROM_CITY
             , TO_COUNTRY
             , TO_CITY
             , TRANSPORT_MODE
          FROM SCP_MST_DISTRIBUTION_ROUTE
         WHERE VALID_YN = 'Y';
        P_GATHER('GT_0039_TRANSPORT_MODE');

        /* ---------------------------------------------------------------------------------------- */
        /* From Site - Project Route 기준                                                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'FROM_SITE_BY_PR';
        INSERT INTO GT_0039_FROM_SITE_BY_PR
        (
            DIVISION_ID
          , FROM_SITE
          , FROM_COUNTRY
          , FROM_CITY
          , ITEM_ID
          , PROJECT_CODE
          , SALES_SITE_ID
          , PLANT_TYPE
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
        )
        SELECT DISTINCT
               B.DIVISION_ID
             , A.SCM_SITE_ID                    AS FROM_SITE
             , A.COUNTRY                        AS FROM_COUNTRY
             , A.CITY                           AS FROM_CITY
             , B.ITEM_ID                        AS ITEM_ID
             , B.PROJECT_CODE                   AS PROJECT_CODE
             , C.SALES_SITE_ID
             , SUBSTR(C.PLANT_SITE_ID, -1)      AS PLANT_TYPE
             , C.FROM_YYYYMMDD
             , C.TO_YYYYMMDD
          FROM GT_0039_SCM_MST_SITE_FROM A   /* From site (Plant Site) */
             , SCM_MST_SITE_ITEM         B
             , GT_0039_PROJECT_ROUTE     C
         WHERE B.DIVISION_ID = V_DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND B.VALID_YN    = 'Y'
           AND C.PLANT_SITE_ID = B.SCM_SITE_ID
           AND C.PROJECT_CODE  = B.PROJECT_CODE
           AND C.ITEM_ID       = B.ITEM_ID
           AND NOT (A.OSP_YN = 'Y' AND A.OPERATION_GROUP = 'A');   /* From site 가 외주 Cell 사이트인 경우 제외 (소형 KR02149300_40-A) : asis 로직 */

        /* ---------------------------------------------------------------------------------------- */
        /* To Sales BOD 가 없는 경우 - Sales Model                                                   */
        /* BOD Requried Case 1 (asis 1.1과 1.2)                                                      */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'BOD_NOT_EXISTS';
        P_GATHER('GT_0039_FROM_SITE_BY_PR');
        INSERT INTO GT_0039_BOD_NOT_EXISTS
        (
            DIVISION_ID
          , ITEM_ID
          , FROM_SITE
          , FROM_COUNTRY
          , FROM_CITY
          , TO_SITE
          , TO_COUNTRY
          , TO_CITY
          , INCOTERMS
          , PROJECT_CODE
          , OPERATION_GROUP
          , NICK_NAME
        )
        SELECT DISTINCT
               B.DIVISION_ID
             , B.ITEM_ID
             , B.FROM_SITE
             , B.FROM_COUNTRY
             , B.FROM_CITY
             , A.SALES_SITE_ID           AS TO_SITE
             , A.TO_COUNTRY
             , A.TO_CITY
             , A.INCOTERMS
             , A.PROJECT_CODE
             , A.MODEL_OPERATION_GROUP   AS OPERATION_GROUP
             , A.MODEL_NICK_NAME         AS NICK_NAME
          FROM GT_0039_MKT_FCST        A
             , GT_0039_FROM_SITE_BY_PR B
         WHERE A.SALES_ITEM_ID = B.ITEM_ID   /* Sales Model */
           /* PJ20257329 2025.09.12 소형 Cell Prod Site 적용 */
           AND CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND A.MODEL_OPERATION_GROUP = 'A'
                    THEN A.CELL_PROD_SITE_ID
                    ELSE B.FROM_SITE
               END = B.FROM_SITE
           AND CASE WHEN V_DIVISION_ID IN ('40', '82') OR A.MODEL_OPERATION_GROUP = 'E'
                    THEN '-'
                    ELSE A.PROJECT_CODE
               END = B.PROJECT_CODE
           AND CASE WHEN V_DIVISION_ID IN ('40', '82') OR A.MODEL_OPERATION_GROUP = 'E'
                    THEN '-'
                    ELSE A.SALES_SITE_ID
               END = B.SALES_SITE_ID
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_BOD      XA
                                 , SCP_MST_BOD_ITEM XB   /* 7/2 추가 */
                             WHERE XB.BOD_ID = XA.BOD_ID
                               AND XA.DIVISION_ID = B.DIVISION_ID
                               AND XA.FROM_SITE   = B.FROM_SITE
                               AND XA.TO_SITE     = A.SALES_SITE_ID
                               AND XA.INCOTERMS   = A.INCOTERMS
                               AND XB.ITEM_ID     = B.ITEM_ID          /* 7/2 BOD item 확인 */
                               AND XB.TO_YYYYMMDD >= V_FROM_YYYYMMDD )
         UNION
        /* To Sales(VMI 및 AS창고) incoterms DAP BOD 가 없는 경우 - BOD Requried Case 2 (asis 2.1과 2.2) */
        SELECT DISTINCT
               B.DIVISION_ID
             , B.ITEM_ID
             , B.FROM_SITE
             , B.FROM_COUNTRY
             , B.FROM_CITY
             , A.SALES_SITE_ID           AS TO_SITE
             , A.TO_COUNTRY
             , A.TO_CITY
             , 'DAP'                     AS INCOTERMS
             , A.PROJECT_CODE
             , A.MODEL_OPERATION_GROUP   AS OPERATION_GROUP
             , A.MODEL_NICK_NAME         AS NICK_NAME
          FROM GT_0039_MKT_FCST        A
             , GT_0039_FROM_SITE_BY_PR B
         WHERE A.SALES_ITEM_ID = B.ITEM_ID
           AND CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND A.MODEL_OPERATION_GROUP = 'A'
                    THEN A.CELL_PROD_SITE_ID
                    ELSE B.FROM_SITE
               END = B.FROM_SITE
           AND CASE WHEN V_DIVISION_ID IN ('40', '82') OR A.MODEL_OPERATION_GROUP = 'E'
                    THEN '-'
                    ELSE A.PROJECT_CODE
               END = B.PROJECT_CODE
           AND CASE WHEN V_DIVISION_ID IN ('40', '82') OR A.MODEL_OPERATION_GROUP = 'E'
                    THEN '-'
                    ELSE A.SALES_SITE_ID
               END = B.SALES_SITE_ID
           AND A.MEASURE IN ('AS_In_Req', 'VMI_In_Req')
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_BOD      XA
                                 , SCP_MST_BOD_ITEM XB   /* 7/2 추가 */
                             WHERE XB.BOD_ID = XA.BOD_ID
                               AND XA.DIVISION_ID = B.DIVISION_ID
                               AND XA.FROM_SITE   = B.FROM_SITE
                               AND XA.TO_SITE     = A.SALES_SITE_ID
                               AND XA.INCOTERMS   = 'DAP'
                               AND XB.ITEM_ID     = B.ITEM_ID
                               AND XB.TO_YYYYMMDD >= V_FROM_YYYYMMDD );
        P_GATHER('GT_0039_BOD_NOT_EXISTS');

        /* ---------------------------------------------------------------------------------------- */
        /* case 3 : SCP Plan 버전 정보                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SCP_PLAN_VERSION';
        INSERT INTO GT_0039_SCP_PLAN_VERSION
        (
            DIVISION_ID
          , PLAN_TYPE
          , PLAN_SEQ
          , PLAN_START_YYYYMMDD
          , HORIZON_END_DATE
          , PLAN_STATUS
          , CONFIRM_FLAG
          , PLAN_PRIORITY
        )
        SELECT IA.DIVISION_ID
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IA.PLAN_START_YYYYMMDD
             , IA.HORIZON_END_DATE
             , IA.PLAN_STATUS
             , IA.CONFIRM_FLAG
             , IA.PLAN_PRIORITY
          FROM ( SELECT A.DIVISION_ID
                      , B.PLAN_TYPE
                      , B.PLAN_SEQ
                      , A.PLAN_NAME                            AS PLAN_START_YYYYMMDD
                      , SUBSTR(A.HORIZON_END_DATE, 1, 8)       AS HORIZON_END_DATE
                      , B.PLAN_STATUS
                      , B.CONFIRM_FLAG
                      , DENSE_RANK() OVER (PARTITION BY A.DIVISION_ID
                                               ORDER BY A.PLAN_NAME DESC
                                                      , B.INPUT_START_DATE DESC)  AS PLAN_PRIORITY
                   FROM SCM_MST_PLAN        A
                      , SCM_MST_PLAN_DETAIL B
                  WHERE B.DIVISION_ID = A.DIVISION_ID
                    AND B.PLAN_ID     = A.PLAN_ID
                    AND B.PLAN_STATUS = '1'   /* 정상 완료 */
                    AND A.DIVISION_ID = V_DIVISION_ID
                    AND A.PLAN_CYCLE  = 'WEEKLY'
                    AND A.PLAN_NAME   = V_FROM_YYYYMMDD ) IA
         WHERE IA.PLAN_PRIORITY = 1;
        P_GATHER('GT_0039_SCP_PLAN_VERSION');

        /* 계획 버전은 PLAN_PRIORITY = 1 로 한 건이다. GTT 와 조인하면 대용량 파티션 테이블에
           파티션 프루닝이 걸리지 않아 조회가 폭주하므로, 값을 변수로 받아 상수 조건으로 준다. */
        SELECT MAX(DIVISION_ID)
             , MAX(PLAN_TYPE)
             , MAX(PLAN_SEQ)
             , MAX(PLAN_START_YYYYMMDD)
             , MAX(HORIZON_END_DATE)
          INTO V_PLAN_DIVISION
             , V_PLAN_TYPE
             , V_PLAN_SEQ
             , V_PLAN_START
             , V_HORIZON_END
          FROM GT_0039_SCP_PLAN_VERSION;


        /* ---------------------------------------------------------------------------------------- */
        /* FG 출하계획 -- 6/27                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SHIP_PLAN_FG';
        INSERT INTO GT_0039_SHIP_PLAN_FG
        (
            DIVISION_ID
          , ITEM_ID
          , YYYYMMDD
          , BOD_ID
          , QTY
        )
        SELECT B.DIVISION_ID
             , B.ITEM_ID
             , B.YYYYMMDD
             , B.BOD_ID
             , B.QTY
          FROM SCP_ANL_SHIPMENT_PLAN_FG B
         WHERE B.PLAN_START_YYYYMMDD = V_PLAN_START
           AND B.DIVISION_ID         = V_PLAN_DIVISION
           AND B.PLAN_TYPE           = V_PLAN_TYPE
           AND B.SEQ                 = V_PLAN_SEQ
           AND B.YYYYMMDD           <= V_HORIZON_END   /* 6/13 */
           AND B.MEASURE = 'SHIP_PLAN_AMEND'
           AND B.QTY != 0;
        P_GATHER('GT_0039_SHIP_PLAN_FG');

        /* ---------------------------------------------------------------------------------------- */
        /* SEMI 출하계획 -- 6/27                                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SHIP_PLAN_SEMI';
        INSERT INTO GT_0039_SHIP_PLAN_SEMI
        (
            DIVISION_ID
          , ITEM_ID
          , YYYYMMDD
          , BOD_ID
          , QTY
        )
        SELECT B.DIVISION_ID
             , B.ITEM_ID
             , B.YYYYMMDD
             , B.BOD_ID
             , B.QTY
          FROM SCP_ANL_SHIPMENT_PLAN_SEMI B
         WHERE B.DIVISION_ID         = V_PLAN_DIVISION
           AND B.PLAN_START_YYYYMMDD = V_PLAN_START
           AND B.PLAN_TYPE           = V_PLAN_TYPE
           AND B.SEQ                 = V_PLAN_SEQ
           AND B.YYYYMMDD           <= V_HORIZON_END
           AND B.MEASURE = 'SHIP_PLAN_AMEND'
           AND B.QTY != 0;
        P_GATHER('GT_0039_SHIP_PLAN_SEMI');

        /* ---------------------------------------------------------------------------------------- */
        /* BOD Valid N 인 FG/SEMI 출하 계획                                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INVALID_BOD_SHIP_PLAN';
        INSERT INTO GT_0039_INVALID_BOD_SHIP_PLAN
        (
            DV
          , BOD_VALID_YN
          , DIVISION_ID
          , ITEM_ID
          , NICK_NAME
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , TRANSPORT_MODE
          , QTY
          , MIN_YMD
          , MAX_YMD
        )
        /* BOD Valid 'N' 이거나 BOD 유효기간 범위 밖 FG출하 계획 */
        SELECT 'FG'             AS DV
             , C.BOD_VALID_YN
             , A.DIVISION_ID
             , A.ITEM_ID
             , B.NICK_NAME
             , C.FROM_SITE
             , C.TO_SITE
             , C.INCOTERMS
             , C.TRANSPORT_MODE
             , SUM(A.QTY)       AS QTY
             , MIN(A.YYYYMMDD)  AS MIN_YMD
             , MAX(A.YYYYMMDD)  AS MAX_YMD
          FROM GT_0039_SHIP_PLAN_FG A
             , SCP_MST_FINAL_ITEM   B
             , GT_0039_BOD          C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.BOD_ID      = A.BOD_ID
           AND ( C.BOD_VALID_YN = 'N'
                 OR
                 NOT (A.YYYYMMDD BETWEEN C.FROM_YYYYMMDD AND C.TO_YYYYMMDD)   /* 유효기간 범위 밖 출하계획 */
               )
         GROUP BY C.BOD_VALID_YN
                , A.DIVISION_ID
                , A.ITEM_ID
                , B.NICK_NAME
                , C.FROM_SITE
                , C.TO_SITE
                , C.INCOTERMS
                , C.TRANSPORT_MODE
         UNION ALL
        /* BOD Valid 'N' 이거나 BOD 유효기간 범위 밖 SEMI출하 계획 */
        SELECT 'SEMI'           AS DV
             , C.BOD_VALID_YN
             , A.DIVISION_ID
             , A.ITEM_ID
             , B.NICK_NAME
             , C.FROM_SITE
             , C.TO_SITE
             , C.INCOTERMS
             , C.TRANSPORT_MODE
             , SUM(A.QTY)       AS QTY
             , MIN(A.YYYYMMDD)  AS MIN_YMD
             , MAX(A.YYYYMMDD)  AS MAX_YMD
          FROM GT_0039_SHIP_PLAN_SEMI A
             , SCP_MST_FINAL_ITEM     B
             , GT_0039_BOD            C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.BOD_ID      = A.BOD_ID
           AND ( C.BOD_VALID_YN = 'N'
                 OR
                 NOT (A.YYYYMMDD BETWEEN C.FROM_YYYYMMDD AND C.TO_YYYYMMDD)
               )
         GROUP BY C.BOD_VALID_YN
                , A.DIVISION_ID
                , A.ITEM_ID
                , B.NICK_NAME
                , C.FROM_SITE
                , C.TO_SITE
                , C.INCOTERMS
                , C.TRANSPORT_MODE;
        P_GATHER('GT_0039_INVALID_BOD_SHIP_PLAN');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인대상 데이터 전체                                                                      */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA';
        INSERT INTO GT_0039_TARGET_DATA
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        /* Project Route 미등록 */
        SELECT V_DIVISION_ID        AS DIVISION_ID
             , A.SALES_ITEM_ID      AS MODEL_ID
             , A.MODEL_NICK_NAME    AS NICK_NAME
             , A.MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.PROJECT_CODE       AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
               /* PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 */
            || CASE WHEN A.CELL_PROD_SITE_ID IS NOT NULL AND A.CHILD_OPERATION_GROUP = 'A'
                    THEN ' ,Cell Prod Site : ' || C.NAME
                    ELSE ''
               END                  AS MASTER_INVLD_CTN
          FROM GT_0039_PR_NOT_EXISTS      A
             , GT_0039_SCM_MST_SITE_TO    B
             , GT_0039_CELL_PROD_SITE_ID  C
         WHERE B.SCM_SITE_ID = A.SALES_SITE_ID
           AND C.CODE(+)     = A.CELL_PROD_SITE_ID
         UNION ALL
        /* BOD 미등록 */
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , 'BOD02'              AS MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , A.PROJECT_CODE       AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , NULL                 AS QTY
             , 'From Site:' || C.SITE_DESCRIPTION  AS MASTER_INVLD_CTN
          FROM GT_0039_BOD_NOT_EXISTS    A
             , GT_0039_SCM_MST_SITE_TO   B
             , GT_0039_SCM_MST_SITE_FROM C
         WHERE B.SCM_SITE_ID = A.TO_SITE
           AND C.SCM_SITE_ID = A.FROM_SITE
         UNION ALL
        /* BOD 유효기간 밖의 출하계획 또는 invalid BOD */
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , 'BOD03'              AS MASTER_INVLD_CD
             , B.SITE_DESCRIPTION   AS SALES_PLANT_SITE
             , NULL                 AS PROJECT_OPERATION
             , A.INCOTERMS          AS INCOTERMS_LINE
             , A.QTY
             , 'From Site:' || C.SITE_DESCRIPTION
            || ', FROM YMD : ' || A.MIN_YMD
            || ', TO_YMD : '   || A.MAX_YMD      AS MASTER_INVLD_CTN
          FROM GT_0039_INVALID_BOD_SHIP_PLAN A
             , GT_0039_SCM_MST_SITE_TO       B
             , GT_0039_SCM_MST_SITE_FROM     C
         WHERE B.SCM_SITE_ID = A.TO_SITE
           AND C.SCM_SITE_ID = A.FROM_SITE;
        P_GATHER('GT_0039_TARGET_DATA');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'TARGET_DATA_BC_NICK';
        INSERT INTO GT_0039_TARGET_DATA_BC_NICK
        (
            DIVISION_ID
          , MODEL_ID
          , NICK_NAME
          , BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , SALES_PLANT_SITE
          , PROJECT_OPERATION
          , INCOTERMS_LINE
          , QTY
          , MASTER_INVLD_CTN
        )
        SELECT A.DIVISION_ID
             , A.MODEL_ID
             , A.NICK_NAME
             , C.BASIC_NICK_NAME    AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.SALES_PLANT_SITE
             , A.PROJECT_OPERATION
             , A.INCOTERMS_LINE
             , A.QTY
             , A.MASTER_INVLD_CTN
          FROM GT_0039_TARGET_DATA  A
             , SCP_MST_FINAL_ITEM   B
             , SCP_MST_ITEM_BSI_IFO C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.MODEL_ID
           AND C.ITEM_ID(+)  = CASE WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                    ELSE A.MODEL_ID
                               END;
        P_GATHER('GT_0039_TARGET_DATA_BC_NICK');

        V_STEP := 'TARGET_DATA_PLAN_GROUP';
        P_LOAD_TARGET_DATA_PLAN_GROUP;

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT DISTINCT   /* PJ20257329 2025.09.12 중복 데이터 제거 */
                   A.DIVISION_ID
                 , A.MODEL_ID                       AS ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                              AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')      AS OPMZ_PLAN_GR_ID
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                     AS MASTER_INVLD_MSG
                 , A.SALES_PLANT_SITE
                 , A.PROJECT_OPERATION
                 , A.INCOTERMS_LINE
                 , A.QTY
                 , A.MASTER_INVLD_CTN
                 , A.DV                             /* 2025.08.13 확인 차원에서 추가 */
              FROM GT_0039_TGT_DATA_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND ( A.MODEL_ID  LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY MASTER_INVLD_MSG
                    , A.DIVISION_ID
                    , ITEM_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_BOD;


    /************************************************************************************************/
    /* Program ID  : SCP0039_GET_VALIDATION_INTRANSIT_INVENTORY                                     */
    /* Description : Intransit Inventory 조회                                                       */
    /*----------------------------------------------------------------------------------------------*/
    /* 2025/07/10  kh      Initial Release                                                          */
    /* 2025/08/14  hrkim   PJ20257329 scp plan operation 으로 공정 참조 범위 제한                    */
    /* 2025/08/26  hrkim   PJ20257329 plan_group_info 임시테이블 추가 사용                           */
    /* 2025/09/12  hrkim   PJ20257329 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용           */
    /* 2026.09.11  [MSSQL -> Oracle 전환]                                                           */
    /************************************************************************************************/
    PROCEDURE P_SCP0039_GET_VALIDATION_INTRANSIT_INV
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SEARCH_TYPE    IN  VARCHAR2,
        P_PLAN_GROUP_ID  IN  VARCHAR2,
        P_ITEM_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR
    )
    IS
        V_PROC_INPUT            VARCHAR2(4000);
        V_STEP                  VARCHAR2(100);
        V_DIVISION_ID           VARCHAR2(30 CHAR) := P_DIVISION_ID;
        V_PLAN_GROUP_ID         VARCHAR2(30 CHAR) := P_PLAN_GROUP_ID;
        V_FROM_YYYYMMDD         VARCHAR2(8  CHAR);
        V_TO_YYYYMMDD           VARCHAR2(8  CHAR);
        V_LAST_SUNDAY           VARCHAR2(8  CHAR);   /* 재고 기준 일자 */
        V_DM_CUTOFF_YYYYMMDD    VARCHAR2(8  CHAR);
        V_DM_VERSION_NO         VARCHAR2(50 CHAR);
    BEGIN

/*
--================================================================================================================================
### Intransit Invetory 요구사항

※ 조회되는 정보는 조회되는주 일요일 CUT-OFF된 재고로 제한
※ DEMAND GROUPING 고려해야함.

1) INTRANST INV에 모델 및 TO SITE 정보를 기반으로
 >> DP에 해당 SALES SITE정보 없는 경우
 ** 고객위탁 정보도 활용해야함 (SO RESERVED)

2) INTRANST INV에 모델, TO SITE, INCOTERMS 정보를 기반으로
 >>  DP에 해당 SALES SITE의 INCOTERMS 가 없는 경우

3) INTRANST INV 도착예상 일자정보를 기반으로
 >> 금주 월요일이 1주일이상 지연 경우
--================================================================================================================================
*/

        V_PROC_INPUT := 'P_DIVISION_ID='   || P_DIVISION_ID
                     || ',P_SEARCH_TYPE='  || P_SEARCH_TYPE
                     || ',P_PLAN_GROUP_ID='|| P_PLAN_GROUP_ID
                     || ',P_ITEM_ID='      || P_ITEM_ID;

        V_STEP := '기준 일자 정보';
        P_SET_BASE_DATE(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        /* 마지막 일요일 (재고 참조 기준일자) */
        V_LAST_SUNDAY := TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

        /* DM Cutoff YYYYMMDD / 버전 정보 */
        V_STEP := 'DM Cutoff / 버전 정보';
        SELECT MAX(IA.CUTOFF_YYYYMMDD)
             , MAX(IA.VERSION_NO)
          INTO V_DM_CUTOFF_YYYYMMDD
             , V_DM_VERSION_NO
          FROM ( SELECT A.CUTOFF_YYYYMMDD
                      , A.VERSION_NO
                   FROM DM_PLN_NET_DEMAND A   /* DIVISION_ID, CUTOFF_YYYYMMDD (IDX01_DM_PLN_NET_DEMAND) */
                      , DM_MST_VERSION     B  /* DIVISION_ID, VERSION_NO */
                  WHERE B.DIVISION_ID  = A.DIVISION_ID
                    AND B.VERSION_NO   = A.VERSION_NO
                    AND B.VERSION_TYPE = 'MF_W'
                    AND A.DIVISION_ID  = V_DIVISION_ID
                  ORDER BY A.CUTOFF_YYYYMMDD DESC
                         , A.VERSION_NO      DESC ) IA
         WHERE ROWNUM = 1;

        V_STEP := 'SCP Plan 공정 정보';
        P_LOAD_SCP_PLAN_OPERATION;

        V_STEP := 'Plan Group 정보';
        P_LOAD_PLAN_GROUP_INFO(V_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD);

        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0039_INTRANSIT_INVENTORY;
        DELETE FROM GT_0039_SALES_SITE_INVENTORY;
        DELETE FROM GT_0039_DEMAND_PLAN;
        DELETE FROM GT_0039_INT_TGT_CASE_1;
        DELETE FROM GT_0039_INT_TGT_CASE_2;
        DELETE FROM GT_0039_INT_TGT_CASE_3;
        DELETE FROM GT_0039_INT_TARGET_DATA;
        DELETE FROM GT_0039_INT_TGT_BC_NICK;
        DELETE FROM GT_0039_INT_TGT_PLAN_GROUP;
        DELETE FROM GT_0039_BOD_II;

        /* ---------------------------------------------------------------------------------------- */
        /* Intransit Inventory                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INTRANSIT_INVENTORY';
        INSERT INTO GT_0039_INTRANSIT_INVENTORY
        (
            GROUP_ID
          , GROUP_NAME
          , NICK_NAME
          , RESULT_DATE
          , RESULT_TYPE
          , DIVISION_ID
          , COMPANY_ID
          , PLANT_ID
          , SHIPMENT_NO
          , PROJECT_CODE
          , ITEM_ID
          , PLANT_ISSUE_DATE
          , INCOTERMS_ORG
          , INCOTERMS
          , SHIPTO_CODE
          , FROM_SCM_SITE_ID
          , TO_SCM_SITE_ID
          , SALES_SITE_DESCRIPTION
          , DELIVERY_QTY
          , UOM
          , TRANSPORT_MODE
          , F_DEST_ETA_DATE
          , F_DEST_ATA_DATE
        )
        SELECT NVL(D.GROUP_ID, 'NONE')             AS GROUP_ID
             , E.GROUP_NAME
             , C.NICK_NAME
             , A.RESULT_DATE
             , A.RESULT_TYPE
             , A.DIVISION_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , A.SHIPMENT_NO
             , A.PROJECT_CODE
             , A.ITEM_ID
             , A.PLANT_ISSUE_DATE
             , A.INCOTERMS                         AS INCOTERMS_ORG
             , NVL(A.FINAL_INCOTERMS, A.INCOTERMS) AS INCOTERMS
             , A.SHIPTO_CODE
             , A.FROM_SCM_SITE_ID
             , A.TO_SCM_SITE_ID
             , B.SITE_DESCRIPTION                  AS SALES_SITE_DESCRIPTION
             , A.DELIVERY_QTY
             , A.UOM
             , A.TRANSPORT_MODE
             , A.F_DEST_ETA_DATE
             , A.F_DEST_ATA_DATE
          FROM SCM_DNM_INTRANSIT_C       A
             , SCM_MST_SITE              B
             , SCP_MST_FINAL_ITEM        C
             , SCP_MST_ITEM_GROUP_DETAIL D   /* DIVISION_ID, PROJECT_CODE, ITEM_ID */
             , SCP_MST_ITEM_GROUP        E   /* DIVISION_ID, GROUP_ID */
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.TO_SCM_SITE_ID
           AND B.SITE_TYPE   = 'SALES'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND D.DIVISION_ID(+)  = A.DIVISION_ID
           AND D.PROJECT_CODE(+) = A.PROJECT_CODE
           AND D.ITEM_ID(+)      = A.ITEM_ID
           AND E.DIVISION_ID(+)  = D.DIVISION_ID
           AND E.GROUP_ID(+)     = D.GROUP_ID
           AND ( D.GROUP_ID IS NULL
                 OR EXISTS ( SELECT 1
                               FROM SCP_MST_ITEM_GROUP XA
                              WHERE XA.DIVISION_ID = D.DIVISION_ID
                                AND XA.GROUP_ID    = D.GROUP_ID
                                AND XA.VALID_YN    = 'Y' ) )
           AND A.RESULT_DATE = V_LAST_SUNDAY
           AND A.RESULT_TYPE IN ('C', 'B', 'I')   /* C(법인간)/B(SO Reserved)/I(GTS) */
           AND A.DIVISION_ID = V_DIVISION_ID;
        P_GATHER('GT_0039_INTRANSIT_INVENTORY');

        /* ---------------------------------------------------------------------------------------- */
        /* Sales Site Inventory                                                                      */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'SALES_SITE_INVENTORY';
        INSERT INTO GT_0039_SALES_SITE_INVENTORY
        (
            CUTOFF_DATE
          , STOCK_TYPE
          , COMPANY_ID
          , DIVISION_ID
          , PLANT_ID
          , NICK_NAME
          , ITEM_ID
          , CUSTOMER_CODE
          , SCM_SITE_ID
          , SALES_SITE_DESCRIPTION
          , SCM_QTY
          , QTY_UOM
        )
        SELECT A.CUTOFF_DATE
             , A.STOCK_TYPE
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.PLANT_ID
             , C.NICK_NAME
             , A.ITEM_ID
             , CASE A.STOCK_TYPE
                    WHEN 'VMI' THEN A.STORAGE_ID
                    ELSE NULL
               END                   AS CUSTOMER_CODE
             , A.SCM_SITE_ID
             , B.SITE_DESCRIPTION    AS SALES_SITE_DESCRIPTION
             , A.SCM_QTY
             , A.QTY_UOM
          FROM SCM_DNM_STOCK      A
             , SCM_MST_SITE       B
             , SCP_MST_FINAL_ITEM C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND B.SITE_TYPE   = 'SALES'
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.ITEM_ID
           AND A.CUTOFF_DATE = V_LAST_SUNDAY
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.SCM_QTY > 0;
        P_GATHER('GT_0039_SALES_SITE_INVENTORY');

        /* ---------------------------------------------------------------------------------------- */
        /* Demand Plan                                                                               */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'DEMAND_PLAN';
        INSERT INTO GT_0039_DEMAND_PLAN
        (
            DIVISION_ID
          , GROUP_ID
          , GROUP_NAME
          , ITEM_ID
          , SCM_SITE_ID
          , INCOTERMS
          , PROJECT_CODE
          , CUTOFF_YYYYMMDD
          , QTY
          , RN_1
          , RN_2
          , RN_3
        )
        SELECT A.DIVISION_ID
             , NVL(D.GROUP_ID, 'NONE')  AS GROUP_ID
             , D.GROUP_NAME
             , A.ITEM_ID
             , A.SCM_SITE_ID
             , CASE WHEN B.VMI_YN = 'Y'
                    THEN 'DAP'
                    ELSE A.INCOTERMS
               END                      AS INCOTERMS
             , A.PROJECT_CODE
             , A.CUTOFF_YYYYMMDD
             , A.QTY
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , NVL(C.ITEM_ID, A.ITEM_ID)
                                             , A.SCM_SITE_ID
                                             , A.PROJECT_CODE
                                      ORDER BY A.QTY DESC)  AS RN_1
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , NVL(C.ITEM_ID, A.ITEM_ID)
                                             , A.SCM_SITE_ID
                                             , A.PROJECT_CODE
                                             , A.INCOTERMS
                                      ORDER BY A.QTY DESC)  AS RN_2
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , NVL(C.ITEM_ID, A.ITEM_ID)
                                             , A.SCM_SITE_ID
                                      ORDER BY A.QTY DESC)  AS RN_3   /* sales site 재고 확인용 */
          FROM DM_PLN_NET_DEMAND        A
             , SCM_MST_SITE             B
             , SCP_MST_ITEM_GROUP_DETAIL C   /* DIVISION_ID, PROJECT_CODE, ITEM_ID */
             , SCP_MST_ITEM_GROUP        D   /* DIVISION_ID, GROUP_ID */
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.DIVISION_ID(+)  = A.DIVISION_ID
           AND C.PROJECT_CODE(+) = A.PROJECT_CODE
           AND C.ITEM_ID(+)      = A.ITEM_ID
           AND D.DIVISION_ID(+)  = C.DIVISION_ID
           AND D.GROUP_ID(+)     = C.GROUP_ID
           AND ( C.GROUP_ID IS NULL
                 OR EXISTS ( SELECT 1
                               FROM SCP_MST_ITEM_GROUP XA
                              WHERE XA.DIVISION_ID = C.DIVISION_ID
                                AND XA.GROUP_ID    = C.GROUP_ID
                                AND XA.VALID_YN    = 'Y' ) )
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND A.VERSION_NO      = V_DM_VERSION_NO
           AND A.CUTOFF_YYYYMMDD = V_DM_CUTOFF_YYYYMMDD;
        P_GATHER('GT_0039_DEMAND_PLAN');

        /* ---------------------------------------------------------------------------------------- */
        /* Intransit Inventory 확인 대상 Case 1                                                      */
        /* 1) INTRANST INV에 모델 및 TO SITE 정보를 기반으로 DP에 해당 SALES SITE정보 없는 경우       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INT_TGT_CASE_1';
        INSERT INTO GT_0039_INT_TGT_CASE_1
        (
            GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
          , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
          , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
          , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
        )
        SELECT A.GROUP_ID, A.GROUP_NAME, A.NICK_NAME, A.RESULT_DATE, A.RESULT_TYPE, A.DIVISION_ID, A.COMPANY_ID
             , A.PLANT_ID, A.SHIPMENT_NO, A.PROJECT_CODE, A.ITEM_ID, A.PLANT_ISSUE_DATE, A.INCOTERMS_ORG, A.INCOTERMS
             , A.SHIPTO_CODE, A.FROM_SCM_SITE_ID, A.TO_SCM_SITE_ID, A.SALES_SITE_DESCRIPTION, A.DELIVERY_QTY
             , A.UOM, A.TRANSPORT_MODE, A.F_DEST_ETA_DATE, A.F_DEST_ATA_DATE
          /* AS-IS 의 LEFT JOIN ON 절에 자기 테이블 컬럼(DP.PROJECT_CODE)을 되받는 CASE 가 있어
             Oracle (+) 로는 표현할 수 없다(ORA-01416). 이 한 곳만 ANSI OUTER JOIN 으로 둔다. */
          FROM GT_0039_INTRANSIT_INVENTORY A
          LEFT OUTER JOIN GT_0039_DEMAND_PLAN B
            ON B.DIVISION_ID  = A.DIVISION_ID
           AND B.ITEM_ID      = A.ITEM_ID
           AND B.SCM_SITE_ID  = A.TO_SCM_SITE_ID
           AND B.PROJECT_CODE = CASE WHEN A.PROJECT_CODE LIKE '000%'
                                       OR A.PROJECT_CODE = '-'
                                       OR A.PROJECT_CODE = 'TBD'
                                       OR TRIM(A.PROJECT_CODE) IS NULL
                                     THEN B.PROJECT_CODE
                                     ELSE A.PROJECT_CODE
                                END
           AND B.RN_1         = 1
         WHERE B.SCM_SITE_ID IS NULL
         UNION ALL
        SELECT NULL                    AS GROUP_ID
             , NULL                    AS GROUP_NAME
             , A.NICK_NAME
             , A.CUTOFF_DATE           AS RESULT_DATE
             , A.STOCK_TYPE            AS RESULT_TYPE
             , A.DIVISION_ID
             , NULL                    AS COMPANY_ID
             , NULL                    AS PLANT_ID
             , NULL                    AS SHIPMENT_NO
             , NULL                    AS PROJECT_CODE
             , A.ITEM_ID
             , NULL                    AS PLANT_ISSUE_DATE
             , NULL                    AS INCOTERMS_ORG
             , NULL                    AS INCOTERMS
             , NULL                    AS SHIPTO_CODE
             , NULL                    AS FROM_SCM_SITE_ID
             , A.SCM_SITE_ID           AS TO_SCM_SITE_ID
             , A.SALES_SITE_DESCRIPTION
             , A.SCM_QTY               AS DELIVERY_QTY
             , A.QTY_UOM               AS UOM
             , NULL                    AS TRANSPORT_MODE
             , NULL                    AS F_DEST_ETA_DATE
             , NULL                    AS F_DEST_ATA_DATE
          FROM GT_0039_SALES_SITE_INVENTORY A
             , GT_0039_DEMAND_PLAN          B
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.ITEM_ID(+)     = A.ITEM_ID
           AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND B.RN_3(+)        = 1
           AND B.SCM_SITE_ID IS NULL;
        P_GATHER('GT_0039_INT_TGT_CASE_1');

        /* ---------------------------------------------------------------------------------------- */
        /* Intransit Inventory 확인 대상 Case 2                                                      */
        /* 2) INTRANST INV에 모델, TO SITE, INCOTERMS 기준 DP에 해당 SALES SITE의 INCOTERMS 가 없는 것*/
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INT_TGT_CASE_2';
        INSERT INTO GT_0039_INT_TGT_CASE_2
        (
            GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
          , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
          , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
          , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
        )
        SELECT A.GROUP_ID, A.GROUP_NAME, A.NICK_NAME, A.RESULT_DATE, A.RESULT_TYPE, A.DIVISION_ID, A.COMPANY_ID
             , A.PLANT_ID, A.SHIPMENT_NO, A.PROJECT_CODE, A.ITEM_ID, A.PLANT_ISSUE_DATE, A.INCOTERMS_ORG, A.INCOTERMS
             , A.SHIPTO_CODE, A.FROM_SCM_SITE_ID, A.TO_SCM_SITE_ID, A.SALES_SITE_DESCRIPTION, A.DELIVERY_QTY
             , A.UOM, A.TRANSPORT_MODE, A.F_DEST_ETA_DATE, A.F_DEST_ATA_DATE
          /* AS-IS 의 LEFT JOIN ON 절에 자기 테이블 컬럼(DP.PROJECT_CODE)을 되받는 CASE 가 있어
             Oracle (+) 로는 표현할 수 없다(ORA-01416). 이 한 곳만 ANSI OUTER JOIN 으로 둔다. */
          FROM GT_0039_INTRANSIT_INVENTORY A
          LEFT OUTER JOIN GT_0039_DEMAND_PLAN B
            ON B.DIVISION_ID  = A.DIVISION_ID
           AND B.ITEM_ID      = A.ITEM_ID
           AND B.SCM_SITE_ID  = A.TO_SCM_SITE_ID
           AND B.PROJECT_CODE = CASE WHEN A.PROJECT_CODE LIKE '000%'
                                       OR A.PROJECT_CODE = '-'
                                       OR A.PROJECT_CODE = 'TBD'
                                       OR TRIM(A.PROJECT_CODE) IS NULL
                                     THEN B.PROJECT_CODE
                                     ELSE A.PROJECT_CODE
                                END
           AND B.INCOTERMS    = A.INCOTERMS
           AND B.RN_2         = 1
         WHERE B.SCM_SITE_ID IS NULL
           AND NOT EXISTS ( SELECT 1
                              FROM GT_0039_INT_TGT_CASE_1 XA
                             WHERE XA.DIVISION_ID    = A.DIVISION_ID
                               AND XA.ITEM_ID        = A.ITEM_ID
                               AND XA.TO_SCM_SITE_ID = A.TO_SCM_SITE_ID
                               AND XA.PROJECT_CODE   = A.PROJECT_CODE );
        P_GATHER('GT_0039_INT_TGT_CASE_2');

        /* ---------------------------------------------------------------------------------------- */
        /* Intransit Inventory 확인 대상 Case 3                                                      */
        /* 3) INTRANST INV 도착예상 일자정보 기준 금주 월요일이 1주일이상 지연 경우                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INT_TGT_CASE_3';
        INSERT INTO GT_0039_INT_TGT_CASE_3
        (
            GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
          , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
          , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
          , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
        )
        SELECT GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
             , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
             , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
             , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
          FROM GT_0039_INTRANSIT_INVENTORY
         WHERE F_DEST_ETA_DATE IS NOT NULL   /* 도착예정일 */
           AND TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') - TO_DATE(F_DEST_ETA_DATE, 'YYYYMMDD') > 7
           /* ★AS-IS 와 결과가 갈리는 자리 (구조적으로 재현 불가)
              F_DEST_ATA_DATE 는 이관 시 빈 문자열이 NULL 로 들어와 MSSQL 의 '빈 문자열' 과
              '진짜 NULL' 을 Oracle 에서 구분할 수 없다. AS-IS 는 진짜 NULL 만 미착으로 보아
              빈 문자열 건을 제외하지만(82 기준 8,197 건), 업무 의미로는 값이 비었으면 미착이므로
              아래 조건은 그 건을 포함한다. 포함 여부는 업무 확정 후 조정할 것. */
           AND F_DEST_ATA_DATE IS NULL;      /* 실제도착일(미착) */

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터                                                                     */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INT_TARGET_DATA';
        P_GATHER('GT_0039_INT_TGT_CASE_3');
        INSERT INTO GT_0039_INT_TARGET_DATA
        (
            MASTER_INVLD_CD
          , GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
          , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
          , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
          , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
        )
        SELECT 'INT01'  AS MASTER_INVLD_CD
             , GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
             , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
             , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
             , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
          FROM GT_0039_INT_TGT_CASE_1
         UNION ALL
        SELECT 'INT02'  AS MASTER_INVLD_CD
             , GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
             , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
             , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
             , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
          FROM GT_0039_INT_TGT_CASE_2
         UNION ALL
        SELECT 'INT03'  AS MASTER_INVLD_CD
             , GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
             , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
             , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
             , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
          FROM GT_0039_INT_TGT_CASE_3;
        P_GATHER('GT_0039_INT_TARGET_DATA');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Basic Cell Nickname 매핑                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INT_TGT_BC_NICK';
        INSERT INTO GT_0039_INT_TGT_BC_NICK
        (
            BASIC_CELL_NICK_NAME
          , MASTER_INVLD_CD
          , GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
          , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
          , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
          , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
        )
        SELECT C.BASIC_NICK_NAME  AS BASIC_CELL_NICK_NAME
             , A.MASTER_INVLD_CD
             , A.GROUP_ID, A.GROUP_NAME, A.NICK_NAME, A.RESULT_DATE, A.RESULT_TYPE, A.DIVISION_ID, A.COMPANY_ID
             , A.PLANT_ID, A.SHIPMENT_NO, A.PROJECT_CODE, A.ITEM_ID, A.PLANT_ISSUE_DATE, A.INCOTERMS_ORG, A.INCOTERMS
             , A.SHIPTO_CODE, A.FROM_SCM_SITE_ID, A.TO_SCM_SITE_ID, A.SALES_SITE_DESCRIPTION, A.DELIVERY_QTY
             , A.UOM, A.TRANSPORT_MODE, A.F_DEST_ETA_DATE, A.F_DEST_ATA_DATE
          FROM GT_0039_INT_TARGET_DATA A
             , SCP_MST_FINAL_ITEM      B
             , SCP_MST_ITEM_BSI_IFO    C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.ITEM_ID(+)  = CASE WHEN B.OPERATION_GROUP = 'P' THEN B.ATTRIBUTE1
                                    ELSE A.ITEM_ID
                               END;
        P_GATHER('GT_0039_INT_TGT_BC_NICK');

        /* ---------------------------------------------------------------------------------------- */
        /* 확인 대상 전체 데이터 - Plan Group 매핑                                                   */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'INT_TGT_PLAN_GROUP';
        INSERT INTO GT_0039_INT_TGT_PLAN_GROUP
        (
            OPMZ_PLAN_GR_ID, OPMZ_PLAN_GR_NAME, LINE_ID, BASIC_NICK_NAME, DV
          , BASIC_CELL_NICK_NAME, MASTER_INVLD_CD
          , GROUP_ID, GROUP_NAME, NICK_NAME, RESULT_DATE, RESULT_TYPE, DIVISION_ID, COMPANY_ID
          , PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS_ORG, INCOTERMS
          , SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, SALES_SITE_DESCRIPTION, DELIVERY_QTY
          , UOM, TRANSPORT_MODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE
        )
        SELECT NVL(B.OPMZ_PLAN_GR_ID  , C.OPMZ_PLAN_GR_ID  )  AS OPMZ_PLAN_GR_ID
             , NVL(B.OPMZ_PLAN_GR_NAME, C.OPMZ_PLAN_GR_NAME)  AS OPMZ_PLAN_GR_NAME
             , NVL(B.LINE_ID          , C.LINE_ID          )  AS LINE_ID
             , NVL(B.BASIC_NICK_NAME  , C.BASIC_NICK_NAME  )  AS BASIC_NICK_NAME
             , CASE WHEN B.LINE_ID IS NOT NULL THEN 'A'   /* item id mapping */
                    WHEN C.LINE_ID IS NOT NULL THEN 'B'   /* basic cell nick name mapping */
                    ELSE 'Z'
               END                                            AS DV
             , A.BASIC_CELL_NICK_NAME, A.MASTER_INVLD_CD
             , A.GROUP_ID, A.GROUP_NAME, A.NICK_NAME, A.RESULT_DATE, A.RESULT_TYPE, A.DIVISION_ID, A.COMPANY_ID
             , A.PLANT_ID, A.SHIPMENT_NO, A.PROJECT_CODE, A.ITEM_ID, A.PLANT_ISSUE_DATE, A.INCOTERMS_ORG, A.INCOTERMS
             , A.SHIPTO_CODE, A.FROM_SCM_SITE_ID, A.TO_SCM_SITE_ID, A.SALES_SITE_DESCRIPTION, A.DELIVERY_QTY
             , A.UOM, A.TRANSPORT_MODE, A.F_DEST_ETA_DATE, A.F_DEST_ATA_DATE
          FROM GT_0039_INT_TGT_BC_NICK  A
             , GT_0039_PLAN_GROUP_INFO  B   /* item_id 로 매핑 */
             , GT_0039_PLAN_GROUP_INFO  C   /* basic cell nick name 으로 매핑 */
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.ITEM_ID(+)     = A.ITEM_ID
           AND B.RN(+)          = 1
           AND C.DIVISION_ID(+)     = A.DIVISION_ID
           AND C.BASIC_NICK_NAME(+) = A.BASIC_CELL_NICK_NAME
           AND C.RN_NICK(+)         = 1;
        P_GATHER('GT_0039_INT_TGT_PLAN_GROUP');

        /* ---------------------------------------------------------------------------------------- */
        /* BOD                                                                                       */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'BOD';
        INSERT INTO GT_0039_BOD_II
        (
            BOD_ID
          , ROUTE_ID
          , DIVISION_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , TRANSPORT_MODE
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , BOD_VALID_YN
          , ROUTE_VALID_YN
          , RN
        )
        SELECT A.BOD_ID
             , B.ROUTE_ID
             , A.DIVISION_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , B.TRANSPORT_MODE
             , A.ATTRIBUTE2  AS FROM_YYYYMMDD
             , A.ATTRIBUTE3  AS TO_YYYYMMDD
             , A.VALID_YN    AS BOD_VALID_YN
             , B.VALID_YN    AS ROUTE_VALID_YN
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.FROM_SITE
                                             , A.TO_SITE
                                             , A.INCOTERMS
                                             , B.TRANSPORT_MODE
                                      ORDER BY A.VALID_YN DESC
                                             , B.VALID_YN DESC
                                             , A.PRIORITY
                                             , B.PRIORITY
                                             , A.BOD_ID DESC)  AS RN
          FROM SCP_MST_BOD                A
             , SCP_MST_DISTRIBUTION_ROUTE B
         WHERE B.ROUTE_ID = A.ROUTE_ID
           AND A.ATTRIBUTE3 >= V_FROM_YYYYMMDD;
        P_GATHER('GT_0039_BOD_II');

        /* ---------------------------------------------------------------------------------------- */
        /* 전체 확인 필요 대상 조회                                                                  */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1';
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.NICK_NAME
                 , A.BASIC_CELL_NICK_NAME
                 , CASE WHEN A.DV IN ('A', 'B')                THEN A.OPMZ_PLAN_GR_NAME
                        WHEN A.BASIC_CELL_NICK_NAME IS NULL    THEN '-'
                        ELSE A.BASIC_CELL_NICK_NAME || ' (예상)'
                   END                                      AS PLAN_GROUP
                 , NVL(A.OPMZ_PLAN_GR_ID, '-')              AS OPMZ_PLAN_GR_ID
                 , A.DV
                 , A.MASTER_INVLD_CD
                 , B.ATTRIBUTE2                             AS MASTER_INVLD_MSG
                 , A.FROM_SCM_SITE_ID                       AS PLANT_SITE
                 , A.TO_SCM_SITE_ID                         AS SALES_SITE
                 , A.INCOTERMS
                 , A.SHIPMENT_NO
                 , A.RESULT_TYPE
                 , A.DELIVERY_QTY
                 , TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD')  AS EXFACTORY_DATE     /* 출하일자 */
                 , TO_DATE(A.F_DEST_ETA_DATE , 'YYYYMMDD')  AS F_DEST_ETA_DATE    /* 도착예정일 */
                 , A.F_DEST_ATA_DATE                                              /* 실제도착일 */
                 , A.TRANSPORT_MODE
                 , C.BOD_ID
                 , V_FROM_YYYYMMDD                          AS PLAN_START_YYYYMMDD
                 , V_DM_CUTOFF_YYYYMMDD                     AS DM_CUTOFF_YYYYMMDD
                 , V_DM_VERSION_NO                          AS DM_VERSION_NO
              FROM GT_0039_INT_TGT_PLAN_GROUP A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , GT_0039_BOD_II              C
                 , ( SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
                       FROM DUAL
                     CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_ITEM_ID, ',') + 1, 0) ) IA
             WHERE B.LOOKUP_TYPE(+) = 'MASTER_INVLD_CD'
               AND B.SEGMENT1(+)    = A.MASTER_INVLD_CD
               AND B.VALID_YN(+)    = 'Y'
               AND C.DIVISION_ID(+)    = A.DIVISION_ID
               AND C.FROM_SITE(+)      = A.FROM_SCM_SITE_ID
               AND C.TO_SITE(+)        = A.TO_SCM_SITE_ID
               AND C.INCOTERMS(+)      = A.INCOTERMS
               AND C.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
               AND ( A.ITEM_ID   LIKE IA.TST
                  OR A.NICK_NAME LIKE IA.TST )
               AND ( P_PLAN_GROUP_ID IS NULL
                     OR A.OPMZ_PLAN_GR_ID IN ( SELECT TRIM(REGEXP_SUBSTR(P_PLAN_GROUP_ID, '[^,]+', 1, LEVEL))
                                                 FROM DUAL
                                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(P_PLAN_GROUP_ID, ',') + 1, 0) ) )
             ORDER BY A.MASTER_INVLD_CD
                    , A.DIVISION_ID
                    , A.ITEM_ID
                    , A.NICK_NAME
                    , A.BASIC_CELL_NICK_NAME
                    , PLAN_GROUP
                    , OPMZ_PLAN_GR_ID;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0039_GET_VALIDATION_INTRANSIT_INV;

END PKG_S39V6;