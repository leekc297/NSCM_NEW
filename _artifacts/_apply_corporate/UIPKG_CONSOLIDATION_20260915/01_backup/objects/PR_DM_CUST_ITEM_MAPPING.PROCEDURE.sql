-- SOURCE-FRESH: SCM_MGR.PR_DM_CUST_ITEM_MAPPING PROCEDURE LAST_DDL=2026-09-02 17:30:27 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_DM_CUST_ITEM_MAPPING" (P_ACCEPT_FLAG VARCHAR2 /* 업무구분(EDI, RPA) */

                                                    )
/*
    * Program ID  : PR_DM_CUST_ITEM_MAPPING
    * Description  : N:N Model Mapping 데이터 기초값 생성
    * 테이블
      DM_CUST_ITEM_MAPPING_M
      DM_CUST_ITEM_MAPPING_DTL_N
      DM_CUST_ITEM_MAPPING_DTL_H
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    2024.04.18    kcw3408        N:N Model Mapping_배치작업 신규
    2024.12.19    KANG.H.J       N:N Model Mapping_RPA/EXCEL 로직 삭제
    2026.03.22    김준규           [PJ20264226] NextSCM Pilot 설계 및 개발
    2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
    */
    /*
    PR_DM_CUST_ITEM_MAPPING('EDI');    --EDI(PR_DM_DNM_EDI_CALLOFF CALL)
    PR_DM_CUST_ITEM_MAPPING('RPA');    --RPA/ECEL(PR_DM_PLN_CUST_FCST_TO_MKT_FCST,PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 CALL)
    PR_DM_CUST_ITEM_MAPPING('EXCEL');  --RPA/EXCEL 수기입력건
    */
    /* ------------------------------------------------------------------------------------------------------------------------------- */
 AS

    V_PROGRAM_NAME     VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE         VARCHAR2(30 CHAR);
    N_LOG_COUNT        INTEGER := 0;
    V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
    V_DESCRIPTION      VARCHAR2(500 CHAR);
    D_EVENT_DATE       DATE;
    N_DELETE_COUNT     INTEGER := 0;
    N_INSERT_COUNT     INTEGER := 0;
    V_CREATED_BY       VARCHAR2(150 CHAR) := 'SYS_BATCH_DATA';
    V_0MONTH_TUESDAY   VARCHAR2(08 CHAR);
    V_DELIMITER        VARCHAR2(1 CHAR);
    V_ACCEPT_FLAG      VARCHAR2(10 CHAR);
    V_CNT              INTEGER := 0;
    V_FROM_YYYYMMDD    VARCHAR2(08 CHAR);
    V_DELETE_YYYYMMDD  VARCHAR2(08 CHAR);
    V_VALID_START_DATE VARCHAR2(08 CHAR);
    V_VALID_END_DATE   VARCHAR2(08 CHAR);
    V_IN_PARA_DATA     CLOB;
    V_STEP             VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_accept_flag' VALUE P_ACCEPT_FLAG);


    DELETE FROM GT_DCIM_DM_DNM_EDI_CALLOFF_ITE;
    DELETE FROM GT_DCIM_DM_CUST_ITEM_MAPPING_D;


    /* LOG 용 변수 설정 */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := 'PR_DM_CUST_ITEM_MAPPING: ' || P_ACCEPT_FLAG;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY);

    BEGIN
        /* 오윤종 PI 요청으로 셋팅함 */
        V_FROM_YYYYMMDD   := '20240101';
        V_DELETE_YYYYMMDD := TO_CHAR(ADD_MONTHS(SYSDATE, -12), 'YYYYMMDD');
        /* v_from_yyyymmdd := TO_CHAR(TO_CHAR(ADD_MONTHS(SYSDATE, - 12), 'YYYYMMDD') || '1201', 'YYYYMMDD') */
        V_VALID_START_DATE := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_VALID_END_DATE   := '20991231';
        V_ACCEPT_FLAG      := P_ACCEPT_FLAG;
    END;

    DBMS_OUTPUT.PUT_LINE('A1--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || P_ACCEPT_FLAG);

    IF V_ACCEPT_FLAG = 'EDI'
    /*
              대상추출(DM_CUST_ITEM_MAPPING_M 에 없는건 추출 _EDI
            */
     THEN
        /* 테이블중복제거 */
        /* 임시확인용테이블 중복제거 */
        INSERT
        INTO GT_DCIM_DM_DNM_EDI_CALLOFF_ITE
            SELECT A.DIVISION_ID
                  ,A.SENDER_CODE
                  ,A.SENDER_NAME
                  ,NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ') UNLOADING_POINT
                  ,NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ') CUSTOMER_PLANT
                  ,NVL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)), ' ') CUST_MATERIAL_CODE
                  ,A.SHIPTO_CODE
                  ,A.SOLDTO_CODE
                  ,A.ITEM_ID
                  ,A.SCM_SITE_ID
                  ,A.EDI_INCOTERMS
                  ,A.PROJECT_CODE
                  ,NVL(B.END_CUSTOMER, ' ') END_CUSTOMER
                  ,CASE A.ERP_FCST_TYPE
                       WHEN 'M' THEN
                        'MPS'
                       WHEN 'S' THEN
                        'SMC'
                       ELSE
                        'MPS'
                   END AS FCST_TYPE
                  ,'E' AS DOM_EXP
            FROM   DM_DNM_EDI_CALLOFF_ITEM A
            LEFT   OUTER JOIN SCM_MST_SITE B
            ON     A.DIVISION_ID = B.DIVISION_ID
            AND    A.SCM_SITE_ID = B.SCM_SITE_ID
            AND    B.SITE_TYPE = 'SALES'
            /* AND B.VALID_YN        = 'Y' */
            WHERE  A.CREATE_DATE >= V_FROM_YYYYMMDD
            AND    A.STATUS_CODE = 'S'
            AND    A.ERP_STATUS IS NULL
            AND    A.SENDER_NAME <> 'LUCID'
            GROUP  BY A.DIVISION_ID
                     ,A.SENDER_CODE
                     ,A.SENDER_NAME
                     ,A.UNLOADING_POINT
                     ,A.CUSTOMER_PLANT
                     ,A.CUST_MATERIAL_CODE
                     ,A.SHIPTO_CODE
                     ,A.SOLDTO_CODE
                     ,A.ITEM_ID
                     ,A.SCM_SITE_ID
                     ,A.STATUS_CODE
                     ,A.SSPM_STATUS
                     ,A.EDI_INCOTERMS
                     ,A.PROJECT_CODE
                     ,B.END_CUSTOMER
                     ,A.SALES_PLANT_SITE_STATUS
                     ,A.ERP_STATUS
                     ,A.ERP_FCST_TYPE;

        INSERT INTO DM_CUST_ITEM_MAPPING_M
            (DIVISION_ID
            ,DATA_TYPE_CODE
            ,END_CUSTOMER
            ,SCM_SITE_ID
            ,PROJECT_CODE
            ,FCST_TYPE
            ,INCOTERMS
            ,DOM_EXP
            ,ITEM_ID
            ,ACTIVE_YN
            ,UNLOADING_POINT
            ,CUSTOMER_PLANT
            ,SOLDTO_CODE
            ,SHIPTO_CODE
            ,CUSTOMER_ITEM_ID
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE)
            SELECT T1.DIVISION_ID
                  ,T1.DATA_TYPE_CODE
                  ,T1.END_CUSTOMER
                  ,T1.SCM_SITE_ID
                  ,T1.PROJECT_CODE
                  ,T1.FCST_TYPE
                  ,T1.INCOTERMS
                  ,T1.DOM_EXP
                  ,T1.ITEM_ID
                  ,T1.ACTIVE_YN
                  ,T1.UNLOADING_POINT
                  ,T1.CUSTOMER_PLANT
                  ,T1.SOLDTO_CODE
                  ,T1.SHIPTO_CODE
                  ,T1.CUST_MATERIAL_CODE
                  ,'BATCH SYSTEM' AS CREATED_BY
                  ,SYSTIMESTAMP CREATION_DATE
                  ,'BATCH SYSTEM' AS LAST_UPDATED_BY
                  ,SYSTIMESTAMP LAST_UPDATE_DATE
            FROM   (SELECT DISTINCT A.DIVISION_ID
                                   ,'EDI' AS DATA_TYPE_CODE
                                   ,NVL(A.END_CUSTOMER, '-') END_CUSTOMER
                                   ,A.SCM_SITE_ID
                                   ,A.PROJECT_CODE
                                   ,A.FCST_TYPE
                                   ,A.EDI_INCOTERMS INCOTERMS
                                   ,A.DOM_EXP
                                   ,A.ITEM_ID
                                   ,'Y' AS ACTIVE_YN
                                   ,A.UNLOADING_POINT
                                   ,A.CUSTOMER_PLANT
                                   ,A.SOLDTO_CODE
                                   ,A.SHIPTO_CODE
                                   ,A.CUST_MATERIAL_CODE
                                   ,ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE, A.FCST_TYPE, A.EDI_INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE ORDER BY A.UNLOADING_POINT, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE) NUM
                    FROM   GT_DCIM_DM_DNM_EDI_CALLOFF_ITE A) T1
            LEFT   OUTER JOIN DM_CUST_ITEM_MAPPING_M T2
            ON     T1.DIVISION_ID = T2.DIVISION_ID
            AND    T1.DATA_TYPE_CODE = T2.DATA_TYPE_CODE
            AND    T1.END_CUSTOMER = T2.END_CUSTOMER
            AND    T1.SCM_SITE_ID = T2.SCM_SITE_ID
            AND    T1.PROJECT_CODE = T2.PROJECT_CODE
            AND    T1.FCST_TYPE = T2.FCST_TYPE
            AND    T1.INCOTERMS = T2.INCOTERMS
            AND    T1.DOM_EXP = T2.DOM_EXP
            AND    T1.ITEM_ID = T2.ITEM_ID
                  /* JSSBAE */
            AND    (RTRIM(LTRIM(T1.UNLOADING_POINT)) = RTRIM(LTRIM(T2.UNLOADING_POINT)) OR
                  (RTRIM(LTRIM(T1.UNLOADING_POINT)) IS NULL AND RTRIM(LTRIM(T2.UNLOADING_POINT)) IS NULL))
            AND    (RTRIM(LTRIM(T1.CUSTOMER_PLANT)) = RTRIM(LTRIM(T2.CUSTOMER_PLANT)) OR
                  (RTRIM(LTRIM(T1.CUSTOMER_PLANT)) IS NULL AND RTRIM(LTRIM(T2.CUSTOMER_PLANT)) IS NULL))
            AND    (RTRIM(LTRIM(T1.CUST_MATERIAL_CODE)) = RTRIM(LTRIM(T2.CUSTOMER_ITEM_ID)) OR
                  (RTRIM(LTRIM(T1.CUST_MATERIAL_CODE)) IS NULL AND RTRIM(LTRIM(T2.CUSTOMER_ITEM_ID)) IS NULL))
            WHERE  T2.DIVISION_ID IS NULL
            AND    T1.NUM = 1;
    END IF;

    DBMS_OUTPUT.PUT_LINE('A2--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    /*
      대상추출(DM_CUST_ITEM_MAPPING_M 에 없는건 추출 _EXCEL,RPA
    */
    /*
    IF v_accept_flag = 'RPA'

        -- 테이블중복제거
        -- 임시확인용테이블 중복제거
        SELECT DISTINCT
               A.DIVISION_ID
             , CASE WHEN A.CREATED_BY LIKE '%robot'
                    THEN 'RPA'
                    ELSE 'EXCEL'
               END AS DATA_TYPE_CODE
            , '' AS UNLOADING_POINT
            , '' AS CUSTOMER_PLANT
            , '' AS CUST_MATERIAL_CODE
            , K.SHIPTO_CODE
            , K.SOLDTO_CODE
            , A.ITEM_ID
            , A.SCM_SITE_ID
            , A.INCOTERMS
            , A.PROJECT_CODE
            , B.END_CUSTOMER
            , A.FCST_TYPE
            , A.DOM_EXP
            INTO #TEMP_DM_PLN_CUSTOMER_PSI
            FROM DM_PLN_CUSTOMER_PSI A
               LEFT OUTER JOIN SCM_MST_SITE B
                 ON A.DIVISION_ID = B.DIVISION_ID
                AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND B.SITE_TYPE    = 'SALES'
                AND B.VALID_YN      = 'Y'
                 LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K
                ON B.DIVISION_ID = K.DIVISION_ID
               AND B.SCM_SITE_ID = K.SCM_SITE_ID
               AND K.REP_YN = 'Y'
            WHERE A.YYYYMMDD >= v_from_yyyymmdd
            AND A.MEASURE_GROUP = 'CUST_FCST'
            AND A.MEASURE IN ('Customer FCST');
            --AND REPLACE(TO_CHAR(A.CREATION_DATE, 'YYYYMMDD'), '-', '')  >= v_from_yyyymmdd

       INSERT INTO DM_CUST_ITEM_MAPPING_M (
             DIVISION_ID
            ,DATA_TYPE_CODE
            ,END_CUSTOMER
            ,SCM_SITE_ID
            ,PROJECT_CODE
            ,FCST_TYPE
            ,INCOTERMS
            ,DOM_EXP
            ,ITEM_ID
            ,ACTIVE_YN
            ,UNLOADING_POINT
            ,CUSTOMER_PLANT
            ,SOLDTO_CODE
            ,SHIPTO_CODE
            ,CUSTOMER_ITEM_ID
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
            )
       SELECT T1.DIVISION_ID
            , T1.DATA_TYPE_CODE
            , T1.END_CUSTOMER
            , T1.SCM_SITE_ID
            , T1.PROJECT_CODE
            , T1.FCST_TYPE
            , T1.INCOTERMS
            , T1.DOM_EXP
            , T1.ITEM_ID
            , T1.ACTIVE_YN
            , T1.UNLOADING_POINT
            , T1.CUSTOMER_PLANT
            , T1.SOLDTO_CODE
            , T1.SHIPTO_CODE
            , T1.CUSTOMER_ITEM_ID
            ,'BATCH SYSTEM' AS CREATED_BY
            ,SYSTIMESTAMP CREATION_DATE
            ,'BATCH SYSTEM' AS LAST_UPDATED_BY
            ,SYSTIMESTAMP LAST_UPDATE_DATE
        FROM
            (SELECT DISTINCT
                    A.DIVISION_ID
                  , A.DATA_TYPE_CODE
                  , A.END_CUSTOMER
                  , A.SCM_SITE_ID
                  , A.PROJECT_CODE
                  , A.FCST_TYPE
                  , A.INCOTERMS
                  , A.DOM_EXP
                  , A.ITEM_ID
                  , 'Y' AS ACTIVE_YN
                  , A.UNLOADING_POINT
                  , A.CUSTOMER_PLANT
                  , A.SOLDTO_CODE
                  , A.SHIPTO_CODE
                  , A.CUST_MATERIAL_CODE CUSTOMER_ITEM_ID
                  , ROW_NUMBER() OVER (
                    PARTITION BY A.DATA_TYPE_CODE,A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE, A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID
                               ,A.UNLOADING_POINT,A.CUSTOMER_PLANT,A.CUST_MATERIAL_CODE
                   ORDER BY A.UNLOADING_POINT,A.CUSTOMER_PLANT,A.CUST_MATERIAL_CODE) NUM
               FROM #TEMP_DM_PLN_CUSTOMER_PSI A
            ) T1
            LEFT OUTER JOIN
            DM_CUST_ITEM_MAPPING_M(T2);
                ON T1.DIVISION_ID = T2.DIVISION_ID
               AND T1.DATA_TYPE_CODE = T2.DATA_TYPE_CODE
               AND T1.END_CUSTOMER = T2.END_CUSTOMER
               AND T1.SCM_SITE_ID = T2.SCM_SITE_ID
               AND T1.PROJECT_CODE = T2.PROJECT_CODE
               AND T1.FCST_TYPE = T2.FCST_TYPE
               AND T1.INCOTERMS = T2.INCOTERMS
               AND T1.DOM_EXP = T2.DOM_EXP
               AND T1.ITEM_ID = T2.ITEM_ID
               --JSSBAE
         WHERE T2.DIVISION_ID IS NULL
           AND T1.NUM  = 1
    */
    /* 수기 입력건 1회성 작업 */
    /*
    IF v_accept_flag = 'EXCEL'

        -- 테이블중복제거
        -- 임시확인용테이블 중복제거
        SELECT DISTINCT
               A.DIVISION_ID
             , CASE WHEN A.CREATED_BY LIKE '%robot'
                    THEN 'RPA'
                    ELSE 'EXCEL'
               END AS DATA_TYPE_CODE
            , '' AS UNLOADING_POINT
            , '' AS CUSTOMER_PLANT
            , '' AS CUST_MATERIAL_CODE
            , K.SHIPTO_CODE
            , K.SOLDTO_CODE
            , A.ITEM_ID
            , A.SCM_SITE_ID
            , A.INCOTERMS
            , A.PROJECT_CODE
            , B.END_CUSTOMER
            , A.FCST_TYPE
            , A.DOM_EXP
            INTO #TEMP_DM_PLN_CUST_FCST_H
            FROM DM_PLN_CUST_FCST_H A
               LEFT OUTER JOIN SCM_MST_SITE B
                 ON A.DIVISION_ID = B.DIVISION_ID
                AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND B.SITE_TYPE    = 'SALES'
                AND B.VALID_YN      = 'Y'
                 LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K
                ON B.DIVISION_ID = K.DIVISION_ID
               AND B.SCM_SITE_ID = K.SCM_SITE_ID
               AND K.REP_YN = 'Y'
            WHERE A.YYYYMMDD >= v_from_yyyymmdd
            AND A.MEASURE IN ('Customer FCST');
            --AND REPLACE(TO_CHAR(A.CREATION_DATE, 'YYYYMMDD'), '-', '')  >= v_from_yyyymmdd

       INSERT INTO DM_CUST_ITEM_MAPPING_M (
             DIVISION_ID
            ,DATA_TYPE_CODE
            ,END_CUSTOMER
            ,SCM_SITE_ID
            ,PROJECT_CODE
            ,FCST_TYPE
            ,INCOTERMS
            ,DOM_EXP
            ,ITEM_ID
            ,ACTIVE_YN
            ,UNLOADING_POINT
            ,CUSTOMER_PLANT
            ,SOLDTO_CODE
            ,SHIPTO_CODE
            ,CUSTOMER_ITEM_ID
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
            )
       SELECT T1.DIVISION_ID
            , T1.DATA_TYPE_CODE
            , T1.END_CUSTOMER
            , T1.SCM_SITE_ID
            , T1.PROJECT_CODE
            , T1.FCST_TYPE
            , T1.INCOTERMS
            , T1.DOM_EXP
            , T1.ITEM_ID
            , T1.ACTIVE_YN
            , T1.UNLOADING_POINT
            , T1.CUSTOMER_PLANT
            , T1.SOLDTO_CODE
            , T1.SHIPTO_CODE
            , T1.CUSTOMER_ITEM_ID
            ,'BATCH SYSTEM' AS CREATED_BY
            ,SYSTIMESTAMP CREATION_DATE
            ,'BATCH SYSTEM' AS LAST_UPDATED_BY
            ,SYSTIMESTAMP LAST_UPDATE_DATE
        FROM
            (SELECT DISTINCT
                    A.DIVISION_ID
                  , A.DATA_TYPE_CODE
                  , A.END_CUSTOMER
                  , A.SCM_SITE_ID
                  , A.PROJECT_CODE
                  , A.FCST_TYPE
                  , A.INCOTERMS
                  , A.DOM_EXP
                  , A.ITEM_ID
                  , 'Y' AS ACTIVE_YN
                  , A.UNLOADING_POINT
                  , A.CUSTOMER_PLANT
                  , A.SOLDTO_CODE
                  , A.SHIPTO_CODE
                  , A.CUST_MATERIAL_CODE CUSTOMER_ITEM_ID
                  , ROW_NUMBER() OVER (
                    PARTITION BY A.DATA_TYPE_CODE,A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE, A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID
                               ,A.UNLOADING_POINT,A.CUSTOMER_PLANT,A.CUST_MATERIAL_CODE
                   ORDER BY A.UNLOADING_POINT,A.CUSTOMER_PLANT,A.CUST_MATERIAL_CODE) NUM
               FROM #TEMP_DM_PLN_CUST_FCST_H A
            ) T1
            LEFT OUTER JOIN
            DM_CUST_ITEM_MAPPING_M(T2);
                ON T1.DIVISION_ID = T2.DIVISION_ID
               AND T1.DATA_TYPE_CODE = T2.DATA_TYPE_CODE
               AND T1.END_CUSTOMER = T2.END_CUSTOMER
               AND T1.SCM_SITE_ID = T2.SCM_SITE_ID
               AND T1.PROJECT_CODE = T2.PROJECT_CODE
               AND T1.FCST_TYPE = T2.FCST_TYPE
               AND T1.INCOTERMS = T2.INCOTERMS
               AND T1.DOM_EXP = T2.DOM_EXP
               AND T1.ITEM_ID = T2.ITEM_ID
         WHERE T2.DIVISION_ID IS NULL
           AND T1.NUM  = 1
    */
    DBMS_OUTPUT.PUT_LINE('A3--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    IF V_ACCEPT_FLAG = 'EDI'
    /*
              대상추출(DM_CUST_ITEM_MAPPING_DTL_N 에 없는건 초기 적재
            */
     THEN
        /* 테이블중복제거 */
        /* 임시확인용테이블 중복제거 */
        INSERT
        INTO GT_DCIM_DM_CUST_ITEM_MAPPING_D
            SELECT T1.DIVISION_ID
                  ,T1.DATA_TYPE_CODE
                  ,NVL(T1.END_CUSTOMER, ' ') END_CUSTOMER
                  ,T1.SCM_SITE_ID
                  ,T1.PROJECT_CODE
                  ,T1.FCST_TYPE
                  ,T1.INCOTERMS
                  ,T1.DOM_EXP
                  ,T1.ITEM_ID
                  ,T1.UNLOADING_POINT
                  ,T1.CUSTOMER_PLANT
                  ,T1.CUSTOMER_ITEM_ID
                  ,T1.ACTIVE_YN
                  ,T1.SOLDTO_CODE
                  ,T1.SHIPTO_CODE
                  ,V_VALID_START_DATE VALID_START_DATE
                  ,V_VALID_END_DATE VALID_END_DATE
                  ,T1.ITEM_ID MAPPING_ITEM_ID
                  ,'BATCH SYSTEM' AS CREATED_BY
                  ,SYSTIMESTAMP CREATION_DATE
                  ,'BATCH SYSTEM' AS LAST_UPDATED_BY
                  ,SYSTIMESTAMP LAST_UPDATE_DATE
            FROM   DM_CUST_ITEM_MAPPING_M T1
            LEFT   OUTER JOIN DM_CUST_ITEM_MAPPING_DTL_N T2
            ON     T1.DIVISION_ID = T2.DIVISION_ID
            AND    T1.DATA_TYPE_CODE = T2.DATA_TYPE_CODE
            AND    T1.END_CUSTOMER = T2.END_CUSTOMER
            AND    T1.SCM_SITE_ID = T2.SCM_SITE_ID
            AND    T1.PROJECT_CODE = T2.PROJECT_CODE
            AND    T1.FCST_TYPE = T2.FCST_TYPE
            AND    T1.INCOTERMS = T2.INCOTERMS
            AND    T1.DOM_EXP = T2.DOM_EXP
            AND    T1.ITEM_ID = T2.ITEM_ID
            AND    (RTRIM(LTRIM(T1.UNLOADING_POINT)) = RTRIM(LTRIM(T2.UNLOADING_POINT)) OR
                  (RTRIM(LTRIM(T1.UNLOADING_POINT)) IS NULL AND RTRIM(LTRIM(T2.UNLOADING_POINT)) IS NULL))
            AND    (RTRIM(LTRIM(T1.CUSTOMER_PLANT)) = RTRIM(LTRIM(T2.CUSTOMER_PLANT)) OR
                  (RTRIM(LTRIM(T1.CUSTOMER_PLANT)) IS NULL AND RTRIM(LTRIM(T2.CUSTOMER_PLANT)) IS NULL))
            AND    (RTRIM(LTRIM(T1.CUSTOMER_ITEM_ID)) = RTRIM(LTRIM(T2.CUSTOMER_ITEM_ID)) OR
                  (RTRIM(LTRIM(T1.CUSTOMER_ITEM_ID)) IS NULL AND RTRIM(LTRIM(T2.CUSTOMER_ITEM_ID)) IS NULL))
            WHERE  T2.DIVISION_ID IS NULL
            AND    T1.ACTIVE_YN = 'Y';

        INSERT INTO DM_CUST_ITEM_MAPPING_DTL_N
            (DIVISION_ID
            ,DATA_TYPE_CODE
            ,END_CUSTOMER
            ,SCM_SITE_ID
            ,PROJECT_CODE
            ,FCST_TYPE
            ,INCOTERMS
            ,DOM_EXP
            ,ITEM_ID
            ,UNLOADING_POINT
            ,CUSTOMER_PLANT
            ,CUSTOMER_ITEM_ID
            ,VALID_START_DATE
            ,VALID_END_DATE
            ,MAPPING_ITEM_ID
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE)
            SELECT T1.DIVISION_ID
                  ,T1.DATA_TYPE_CODE
                  ,T1.END_CUSTOMER
                  ,T1.SCM_SITE_ID
                  ,T1.PROJECT_CODE
                  ,T1.FCST_TYPE
                  ,T1.INCOTERMS
                  ,T1.DOM_EXP
                  ,T1.ITEM_ID
                  ,T1.UNLOADING_POINT
                  ,T1.CUSTOMER_PLANT
                  ,T1.CUSTOMER_ITEM_ID
                  ,T1.VALID_START_DATE
                  ,T1.VALID_END_DATE
                  ,T1.MAPPING_ITEM_ID
                  ,T1.CREATED_BY
                  ,T1.CREATION_DATE
                  ,T1.LAST_UPDATED_BY
                  ,T1.LAST_UPDATE_DATE
            FROM   GT_DCIM_DM_CUST_ITEM_MAPPING_D T1;
    END IF;

    IF V_ACCEPT_FLAG = 'EDI'
    /*
              대상추출(DM_CUST_ITEM_MAPPING_DTL_N 에 없는건 초기 적재
            */
     THEN
        INSERT INTO DM_CUST_ITEM_MAPPING_DTL_H
            (DIVISION_ID
            ,DATA_TYPE_CODE
            ,END_CUSTOMER
            ,SCM_SITE_ID
            ,PROJECT_CODE
            ,FCST_TYPE
            ,INCOTERMS
            ,DOM_EXP
            ,ITEM_ID
            ,UNLOADING_POINT
            ,CUSTOMER_PLANT
            ,CUSTOMER_ITEM_ID
            ,ACTIVE_YN
            ,SOLDTO_CODE
            ,SHIPTO_CODE
            ,VALID_START_DATE
            ,VALID_END_DATE
            ,MAPPING_ITEM_ID
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE)
            SELECT T1.DIVISION_ID
                  ,T1.DATA_TYPE_CODE
                  ,T1.END_CUSTOMER
                  ,T1.SCM_SITE_ID
                  ,T1.PROJECT_CODE
                  ,T1.FCST_TYPE
                  ,T1.INCOTERMS
                  ,T1.DOM_EXP
                  ,T1.ITEM_ID
                  ,T1.UNLOADING_POINT
                  ,T1.CUSTOMER_PLANT
                  ,T1.CUSTOMER_ITEM_ID
                  ,T1.ACTIVE_YN
                  ,T1.SOLDTO_CODE
                  ,T1.SHIPTO_CODE
                  ,T1.VALID_START_DATE
                  ,T1.VALID_END_DATE
                  ,T1.MAPPING_ITEM_ID
                  ,T1.CREATED_BY
                  ,T1.CREATION_DATE
                  ,T1.LAST_UPDATED_BY
                  ,T1.LAST_UPDATE_DATE
            FROM   GT_DCIM_DM_CUST_ITEM_MAPPING_D T1;
        /* 1년전 데이타 삭제 */
        DELETE FROM DM_CUST_ITEM_MAPPING_DTL_H
        WHERE  1 = 1
        AND    TO_CHAR(CREATION_DATE, 'YYYYMMDD') <= V_DELETE_YYYYMMDD
        AND    TO_CHAR(LAST_UPDATE_DATE, 'YYYYMMDD') <= V_DELETE_YYYYMMDD;
    END IF;

    DBMS_OUTPUT.PUT_LINE('A4--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));


EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            ,'ERROR'
                            ,0
                            ,SQLERRM
                            ,NULL
                            ,SYSDATE
                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                            ,P_SQL_ERR_CODE  => SQLCODE
                            ,P_SQL_ERR_MSG   => SQLERRM
                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
