PROCEDURE         "PR_SCM_MST_FUTURE_PRICE_CUTOFF" 
(
      P_DIVISION_ID               IN VARCHAR2 /* NVARCHAR(30) division_id 전달받음 */
    , P_VER_TYPE                  IN VARCHAR2 /* NVARCHAR(MAX) 20180726 Sales Plan Weekly Cutoff Version Type (스칼라 값 → CLOB 대신 VARCHAR2: =비교/GROUP BY 사용) */
    , P_CREATED_BY                IN VARCHAR2 /* NVARCHAR(MAX) 20180726 */
    , P_SALES_PLAN_VER_RETURN_NO  IN VARCHAR2 /* NVARCHAR(MAX) 20180726 Sales Plan Weekly Cutoff Version No (스칼라 값 → VARCHAR2) */
    , P_MKT_PLAN_VER_RETURN_NO    IN VARCHAR2 DEFAULT 'MKT_FCST' /* [PJ2025-50188]_SALE_PLAN CUTOFF 하는경우에는 MKT_FCST도 받는다 (스칼라 값 → VARCHAR2) */
)
/* =============================================================================================================
 * Program ID   : PR_SCM_MST_FUTURE_PRICE_CUTOFF
 * Description  :
 * Program History
 *-------------------------------------------------------------------------------------------------------------
 *    Date        In Charge        Description
 *-------------------------------------------------------------------------------------------------------------
 * 2017.02.12  JHBAEK/KHSONG    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28  KHSONG           DW I/F 테이블 생성 Procedure 호출 추가 -> 임시주석처리됨
 * 2018.07.26  KHSONG           PR_DM_PLN_SALES_PLAN_CUTOFF에서 호출받으면서 parameter 추가
 * 2020.10.20  P.C.I            [C20201005-000282] 당주 월요일부터 Sales Price Cutoff
 * 2022.04.07  hwi1993          GM JV 작업
 * 2025.02.05  KANG.H.J         [PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025.07.23  JSSBAE           [PJ2025-50188]_소형 매출계획 동기화 개선 고도화 [Sales Price Cutoff 개선]
 * 2026.07.06  ZIONEX           [PJ202650304]  NextSCM Migration
 * ============================================================================================================= */
IS


    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'PR_SCM_MST_FUTURE_PRICE_CUTOFF';
    V_LOG_TYPE                  VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT                 NUMBER(10) := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(500 CHAR);
    D_EVENT_DATE                DATE;
    V_VER_RETURN_NO             VARCHAR2(100 CHAR);   /* cut off Generated Number */
    V_OK_DESCRIPTION            VARCHAR2(1200 CHAR);  /* cut off Generated Number */
    /* [C20201005-000282] 당주 월요일부터 Sales Price Cutoff */
    V_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR);

    /* [PJ2025-50188]_데이터가 실제로 필요한 것만 받기 위해 일자와, 메져를 변수에 담는다 (START) */
    V_PLAN_TO_YYYYMM            VARCHAR2(6 CHAR);

BEGIN

    V_PLAN_START_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');   /* 월요일 */

    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A001: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);

    /* ============================================================================================= */
    /* TEMP TABLE DROP   ( Oracle GTT: 세션 시작 시 자동 비어있음. DROP 불필요. 데이터 정리는 DELETE 로 처리 ) */
    /* ============================================================================================= */
    DELETE
      FROM GT_SMFP_USE_MEASURE;

    DELETE
      FROM GT_SMFP_MKT_FCST_DATA;

    /* ============================================================================================= */
    /* 사업부별 사용하는 메져 TEMP 테이블에 데이터 적재 */
    /* ============================================================================================= */
    INSERT
      INTO GT_SMFP_USE_MEASURE
         ( MEASURE )
    SELECT SEGMENT3 AS MEASURE
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'CUTOFF_USE_MEASURE'
       AND SEGMENT1 = 'SALES_PRICE'
       AND SEGMENT2 = P_DIVISION_ID;

    /* [PJ2025-50188]_데이터가 실제로 필요한 것만 받기 위해 일자와, 메져를 변수에 담는다 (END) */
    /* ============================================================================================= */
    /* 시작 LOG  (START) */
    /* ============================================================================================= */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    /* ============================================================================================= */
    /* 시작 LOG  (END) */
    /* ============================================================================================= */
    /* ============================================================================================= */
    /* 트랜잭션 (START)    ( BEGIN TRANSACTION PR_SCM_MST_FUTURE_PRICE_CUTOFF; Oracle: 암시적 트랜잭션 ) */
    /* ============================================================================================= */
    BEGIN

        /* [PJ2025-50188]_삭제는 SP_W든 SP_D든 MF_D든 MF_W든 동일하게 진행하므로 공통 먼저 하도록 순서 변경 (START) */
        /* ============================================================================================= */
        /* CUTOFF 데이터 삭제 진행 */
        /* ============================================================================================= */
        DECLARE
        BEGIN
            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A002: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);
            /* 1). INSERT전 중복체크 후 삭제 */
            /* SCM_MST_FUTURE_PRICE_C 삭제 */
            DELETE
              FROM SCM_MST_FUTURE_PRICE_C
             WHERE DIVISION_ID = P_DIVISION_ID
               AND VERSION_NO = P_SALES_PLAN_VER_RETURN_NO
               AND CUTOFF_TYPE = P_VER_TYPE
               AND YYYYMMDD >= V_PLAN_START_YYYYMMDD;   /* [C20201005-000282] 당주 월요일부터 Sales Price Cutoff */
            /* DM_PLN_CFM_SELLING_PRICE_C CUTOFF */
            DELETE
              FROM DM_PLN_CFM_SELLING_PRICE_C
             WHERE DIVISION_ID = P_DIVISION_ID
               AND VERSION_NO = P_SALES_PLAN_VER_RETURN_NO
               AND CUTOFF_TYPE = P_VER_TYPE
               AND YYYYMMDD >= V_PLAN_START_YYYYMMDD;
        END;
        /* [PJ2025-50188]_삭제는 SP_W든 SP_D든 MF_D든 MF_W든 동일하게 진행하므로 공통 먼저 하도록 순서 변경 (END) */

        /* [PJ2025-50188]_VERSION_TYPE이 S로 시작하는 경우 DM_PLN_SALES_PLAN_C 테이블로 CUTOFF (START) */
        /* IF LEFT(@p_ver_type, 1) = 'S' */
        IF SUBSTR(P_VER_TYPE, 1, 2) = 'SP' THEN    /* [PJ2025-50188]_VERSION_TYPE이 SP_W / SF_W를 구분하기 위해서 SP로 변경 (2025.07.28. 강현준) */

            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A003: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);

            /* 20180726 version 추출 필요없음 주석처리
                -- version no 추출
                EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]
                        ,@p_version_description
                        ,@p_ver_type
                        ,@p_created_by
                        ,@v_ver_return_no  OUTPUT
                        ,@v_OK_description OUTPUT
            */

            /* CUTOFF된 MKT FCST 데이터에서 지정한 메져로 데이터를 추출한다. */
            INSERT
              INTO GT_SMFP_MKT_FCST_DATA
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , YYYYMMDD )
            SELECT T.DIVISION_ID
                 , T.PROJECT_CODE
                 , T.SCM_SITE_ID
                 , T.ITEM_ID
                 , T.DOM_EXP
                 , T.FCST_TYPE
                 , T.INCOTERMS
                 , T.PLANT_SITE_ID
                 , T.CELL_PROD_SITE_ID
                 , MAX(T.YYYYMMDD) AS YYYYMMDD
              FROM ( SELECT A.DIVISION_ID
                          , A.PROJECT_CODE
                          , A.SCM_SITE_ID
                          , A.ITEM_ID
                          , A.DOM_EXP
                          , A.FCST_TYPE
                          , A.INCOTERMS
                          , A.PLANT_SITE_ID
                          , A.CELL_PROD_SITE_ID
                          , A.YYYYMMDD
                       FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                          , GT_SMFP_USE_MEASURE TM
                      WHERE A.MEASURE = TM.MEASURE
                        AND A.DIVISION_ID = P_DIVISION_ID
                        AND A.VERSION_NO = P_MKT_PLAN_VER_RETURN_NO
                        AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
                      UNION ALL
                     SELECT A.DIVISION_ID
                          , A.PROJECT_CODE
                          , A.SCM_SITE_ID
                          , A.ITEM_ID
                          , A.DOM_EXP
                          , A.FCST_TYPE
                          , A.INCOTERMS
                          , A.PLANT_SITE_ID
                          , '-' AS CELL_PROD_SITE_ID
                          , A.YYYYMMDD
                       FROM DM_PLN_MKT_FCST_C A
                          , GT_SMFP_USE_MEASURE TM
                      WHERE A.MEASURE = TM.MEASURE
                        AND A.DIVISION_ID = P_DIVISION_ID
                        AND A.VERSION_NO = P_MKT_PLAN_VER_RETURN_NO
                        AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
                   ) T
             GROUP BY T.DIVISION_ID
                    , T.PROJECT_CODE
                    , T.SCM_SITE_ID
                    , T.ITEM_ID
                    , T.DOM_EXP
                    , T.FCST_TYPE
                    , T.INCOTERMS
                    , T.CELL_PROD_SITE_ID
                    , T.PLANT_SITE_ID;

            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A004: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);
            /* 실제 SALES PLAN CUTOFF에 존재하는 데이터 중 SALES PRICE를 사용하는 메져의 MAX날짜를 구해 TO날짜로 설정한다. */
            /* 월까지만 구하는 이유는, 데이터가 존재하는 월의 데이터까지는 모두 가져오기 위해서 (화면에서 월 평균값을 보여줌) */
            SELECT SUBSTR(MAX(A.YYYYMMDD), 1, 6)
              INTO V_PLAN_TO_YYYYMM
              FROM GT_SMFP_MKT_FCST_DATA A;

            /* 2). INSERT 작업 */
            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A005: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO||' / MAX_PLAN_TO_YYYYMM: ' ||V_PLAN_TO_YYYYMM);
            /* SCM_MST_FUTURE_PRICE_C TABLE INSERT */
            /* [PJ2025-50188]_JOIN문을 사용해야 함으로, 어디에 속한 컬럼인지 ALIAS를 모두 적는다. (START) */
            /* [PJ2025-50188]_SALES PLAN_C에서 실제로 사용할 데이터만 가지고 오도록 한다. */
            INSERT
              INTO SCM_MST_FUTURE_PRICE_C
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , PLANT_SITE_ID
                 , ITEM_ID
                 , YYYYMMDD
                 , CURRENCY
                 , MEASURE
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , PRICE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10 )
            SELECT P_DIVISION_ID
                 , P_SALES_PLAN_VER_RETURN_NO   /* sales plan Weekly Cufoff에서 수행된 version no 를 저장  20180726 */
                 , P_VER_TYPE AS CUTOFF_TYPE
                 , TO_CHAR(SYSDATE, 'YYYYMMDD') AS CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , A.PLANT_SITE_ID
                 , A.ITEM_ID
                 , A.YYYYMMDD
                 , A.CURRENCY
                 , A.MEASURE
                 , A.DOM_EXP
                 , A.FCST_TYPE
                 , A.INCOTERMS
                 , A.PRICE
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , P_CREATED_BY AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , A.ATTRIBUTE1
                 , A.ATTRIBUTE2
                 , A.ATTRIBUTE3
                 , A.ATTRIBUTE4
                 , A.ATTRIBUTE5
                 , A.ATTRIBUTE6
                 , A.ATTRIBUTE7
                 , A.ATTRIBUTE8
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
              FROM SCM_MST_FUTURE_PRICE A
                 , ( SELECT SC.DIVISION_ID
                          , SC.PROJECT_CODE
                          , SC.SCM_SITE_ID
                          , SC.ITEM_ID
                          , SC.DOM_EXP
                          , SC.FCST_TYPE
                          , SC.INCOTERMS
                          , SC.PLANT_SITE_ID
                       FROM GT_SMFP_MKT_FCST_DATA SC
                      GROUP BY SC.DIVISION_ID
                             , SC.PROJECT_CODE
                             , SC.SCM_SITE_ID
                             , SC.ITEM_ID
                             , SC.DOM_EXP
                             , SC.FCST_TYPE
                             , SC.INCOTERMS
                             , SC.PLANT_SITE_ID
                   ) B
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND A.PROJECT_CODE = B.PROJECT_CODE
               AND A.SCM_SITE_ID = B.SCM_SITE_ID
               AND A.ITEM_ID = B.ITEM_ID
               AND A.DOM_EXP = B.DOM_EXP
               AND A.FCST_TYPE = B.FCST_TYPE
               AND A.INCOTERMS = B.INCOTERMS
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD   /* [C20201005-000282] 당주 월요일부터 Sales Price Cutoff */
               AND SUBSTR(A.YYYYMMDD, 1, 6) < V_PLAN_TO_YYYYMM;   /* [PJ2025-50188]_소형 매출계획 동기화 개선 TO 날짜를 설정한다. */

            /* [PJ2025-50017] 소형 매출계획 동기화 개선 START */
            IF P_DIVISION_ID = '40' THEN   /* [PJ2025-50188]_40 사업부만 사용하는 테이블로, 40 사업부만 실행하도록 IF문으로 구분함 */

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A006: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);
                /* DM_PLN_CFM_SELLING_PRICE_C TABLE INSERT */
                /* [PJ2025-50188]_JOIN문을 사용해야 함으로, 어디에 속한 컬럼인지 ALIAS를 모두 적는다. */
                /* [PJ2025-50188]_SALES PLAN_C에서 실제로 사용할 데이터만 가지고 오도록 한다. */
                INSERT
                  INTO DM_PLN_CFM_SELLING_PRICE_C
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , END_CUSTOMER
                     , SCM_SITE_ID
                     , PLANT_SITE_ID
                     , CELL_PROD_SITE_ID
                     , ITEM_ID
                     , YYYYMMDD
                     , CURRENCY
                     , MEASURE
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , PRICE
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE )
                SELECT A.DIVISION_ID
                     , P_SALES_PLAN_VER_RETURN_NO AS VERSION_NO
                     , P_VER_TYPE AS CUTOFF_TYPE
                     , TO_CHAR(SYSDATE, 'YYYYMMDD') AS CUTOFF_YYYYMMDD
                     , A.PROJECT_CODE
                     , A.END_CUSTOMER
                     , A.SCM_SITE_ID
                     , A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.ITEM_ID
                     , A.YYYYMMDD
                     , A.CURRENCY
                     , A.MEASURE
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.PRICE
                     , P_CREATED_BY AS CREATED_BY
                     , SYSDATE AS CREATION_DATE
                     , P_CREATED_BY AS LAST_UPDATED_BY
                     , SYSDATE AS LAST_UPDATE_DATE
                  FROM DM_PLN_CFM_SELLING_PRICE A
                     , ( SELECT SC.DIVISION_ID
                              , SC.PROJECT_CODE
                              , SC.SCM_SITE_ID
                              , SC.ITEM_ID
                              , SC.DOM_EXP
                              , SC.FCST_TYPE
                              , SC.INCOTERMS
                              , SC.PLANT_SITE_ID
                              , SC.CELL_PROD_SITE_ID
                           FROM GT_SMFP_MKT_FCST_DATA SC
                          GROUP BY SC.DIVISION_ID
                                 , SC.PROJECT_CODE
                                 , SC.SCM_SITE_ID
                                 , SC.ITEM_ID
                                 , SC.DOM_EXP
                                 , SC.FCST_TYPE
                                 , SC.INCOTERMS
                                 , SC.PLANT_SITE_ID
                                 , SC.CELL_PROD_SITE_ID
                       ) B
                 WHERE A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
                   AND SUBSTR(A.YYYYMMDD, 1, 6) <= V_PLAN_TO_YYYYMM;   /* [PJ2025-50188]_소형 매출계획 동기화 개선 TO 날짜를 설정한다. */
            END IF;
            /* [PJ2025-50017] 소형 매출계획 동기화 개선 END */
        /* [PJ2025-50188]_VERSION_TYPE이 S가 아니고 40 사업부인 경우 MKT FCST CUTOFF (START) */
        ELSE
            IF P_DIVISION_ID = '40' THEN

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A007: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);
                /* 실제 SALES PLAN CUTOFF에 존재하는 데이터 중 SALES PRICE를 사용하는 메져의 MAX날짜를 구해 TO날짜로 설정한다. */
                /* 월까지만 구하는 이유는, 데이터가 존재하는 월의 데이터까지는 모두 가져오기 위해서 (화면에서 월 평균값을 보여줌) */
                SELECT SUBSTR(MAX(A.YYYYMMDD), 1, 6)
                  INTO V_PLAN_TO_YYYYMM
                  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                     , GT_SMFP_USE_MEASURE B
                 WHERE A.MEASURE = B.MEASURE
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO = P_SALES_PLAN_VER_RETURN_NO
                   AND A.CUTOFF_TYPE = P_VER_TYPE
                   AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD;

                /* 2). INSERT 작업 */
                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A008: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);
                /* DM_PLN_CFM_SELLING_PRICE_C TABLE INSERT */
                INSERT
                  INTO DM_PLN_CFM_SELLING_PRICE_C
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , END_CUSTOMER
                     , SCM_SITE_ID
                     , PLANT_SITE_ID
                     , CELL_PROD_SITE_ID
                     , ITEM_ID
                     , YYYYMMDD
                     , CURRENCY
                     , MEASURE
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , PRICE
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE )
                SELECT A.DIVISION_ID
                     , P_SALES_PLAN_VER_RETURN_NO AS VERSION_NO
                     , P_VER_TYPE AS CUTOFF_TYPE
                     , TO_CHAR(SYSDATE, 'YYYYMMDD') AS CUTOFF_YYYYMMDD
                     , A.PROJECT_CODE
                     , A.END_CUSTOMER
                     , A.SCM_SITE_ID
                     , A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.ITEM_ID
                     , A.YYYYMMDD
                     , A.CURRENCY
                     , A.MEASURE
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.PRICE
                     , P_CREATED_BY AS CREATED_BY
                     , SYSDATE AS CREATION_DATE
                     , P_CREATED_BY AS LAST_UPDATED_BY
                     , SYSDATE AS LAST_UPDATE_DATE
                  FROM DM_PLN_CFM_SELLING_PRICE A
                     , ( SELECT MC.DIVISION_ID
                              , MC.VERSION_NO
                              , MC.CUTOFF_TYPE
                              , MC.CUTOFF_YYYYMMDD
                              , MC.PROJECT_CODE
                              , MC.END_CUSTOMER
                              , MC.SCM_SITE_ID
                              , MC.ITEM_ID
                              , MC.DOM_EXP
                              , MC.FCST_TYPE
                              , MC.INCOTERMS
                              , MC.PLANT_SITE_ID
                              , MC.CELL_PROD_SITE_ID
                           FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C MC
                              , GT_SMFP_USE_MEASURE TM
                          WHERE MC.MEASURE = TM.MEASURE
                            AND MC.DIVISION_ID = P_DIVISION_ID
                            AND MC.VERSION_NO = P_SALES_PLAN_VER_RETURN_NO
                            AND MC.CUTOFF_TYPE = P_VER_TYPE
                            AND MC.YYYYMMDD >= V_PLAN_START_YYYYMMDD
                          GROUP BY MC.DIVISION_ID
                                 , MC.VERSION_NO
                                 , MC.CUTOFF_TYPE
                                 , MC.CUTOFF_YYYYMMDD
                                 , MC.PROJECT_CODE
                                 , MC.END_CUSTOMER
                                 , MC.SCM_SITE_ID
                                 , MC.ITEM_ID
                                 , MC.DOM_EXP
                                 , MC.FCST_TYPE
                                 , MC.INCOTERMS
                                 , MC.PLANT_SITE_ID
                                 , MC.CELL_PROD_SITE_ID
                       ) B
                 WHERE A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.END_CUSTOMER = B.END_CUSTOMER
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD
                   AND SUBSTR(A.YYYYMMDD, 1, 6) <= V_PLAN_TO_YYYYMM;
            /* 2026.09.30   AJS   81 계열 MKT FCST 확정 시 판가 확정 추가 (START) */
            ELSIF SUBSTR(P_DIVISION_ID, 1, 2) = '81' THEN

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A009: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / VERSION_NO: ' ||P_MKT_PLAN_VER_RETURN_NO);

                /* 81 계열은 판가 원장이 SCM_MST_FUTURE_PRICE  */
                /* 확정된 MKT FCST 데이터 중 단가 확정 대상 메져의 MAX 일자를 구해 TO 일자로 설정한다 */
                SELECT SUBSTR(MAX(A.YYYYMMDD), 1, 6)
                  INTO V_PLAN_TO_YYYYMM
                  FROM DM_PLN_MKT_FCST_C A
                     , GT_SMFP_USE_MEASURE B
                 WHERE A.MEASURE = B.MEASURE
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO = P_SALES_PLAN_VER_RETURN_NO
                   AND A.CUTOFF_TYPE = P_VER_TYPE
                   AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD;

                /* 2). INSERT 작업 */
                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME||' A010: ' ||'DIVISION_ID: ' ||P_DIVISION_ID||' / VERSION_TYPE: ' ||P_VER_TYPE||' / VERSION_NO: ' ||P_SALES_PLAN_VER_RETURN_NO||' / MAX_PLAN_TO_YYYYMM: ' ||V_PLAN_TO_YYYYMM);

                /* SCM_MST_FUTURE_PRICE_C TABLE INSERT */
                INSERT
                  INTO SCM_MST_FUTURE_PRICE_C
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , PLANT_SITE_ID
                     , ITEM_ID
                     , YYYYMMDD
                     , CURRENCY
                     , MEASURE
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , PRICE
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     , ATTRIBUTE1
                     , ATTRIBUTE2
                     , ATTRIBUTE3
                     , ATTRIBUTE4
                     , ATTRIBUTE5
                     , ATTRIBUTE6
                     , ATTRIBUTE7
                     , ATTRIBUTE8
                     , ATTRIBUTE9
                     , ATTRIBUTE10 )
                SELECT P_DIVISION_ID
                     , P_SALES_PLAN_VER_RETURN_NO   /* MKT FCST 확정에서 생성된 VERSION_NO 를 저장 */
                     , P_VER_TYPE AS CUTOFF_TYPE
                     , TO_CHAR(SYSDATE, 'YYYYMMDD') AS CUTOFF_YYYYMMDD
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.PLANT_SITE_ID
                     , A.ITEM_ID
                     , A.YYYYMMDD
                     , A.CURRENCY
                     , A.MEASURE
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.PRICE
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , P_CREATED_BY AS LAST_UPDATED_BY
                     , SYSDATE AS LAST_UPDATE_DATE
                     , A.ATTRIBUTE1
                     , A.ATTRIBUTE2
                     , A.ATTRIBUTE3
                     , A.ATTRIBUTE4
                     , A.ATTRIBUTE5
                     , A.ATTRIBUTE6
                     , A.ATTRIBUTE7
                     , A.ATTRIBUTE8
                     , A.ATTRIBUTE9
                     , A.ATTRIBUTE10
                  FROM SCM_MST_FUTURE_PRICE A
                     , ( SELECT MC.DIVISION_ID
                              , MC.PROJECT_CODE
                              , MC.SCM_SITE_ID
                              , MC.ITEM_ID
                              , MC.DOM_EXP
                              , MC.FCST_TYPE
                              , MC.INCOTERMS
                              , MC.PLANT_SITE_ID
                           FROM DM_PLN_MKT_FCST_C MC
                              , GT_SMFP_USE_MEASURE TM
                          WHERE MC.MEASURE = TM.MEASURE
                            AND MC.DIVISION_ID = P_DIVISION_ID
                            AND MC.VERSION_NO = P_SALES_PLAN_VER_RETURN_NO
                            AND MC.CUTOFF_TYPE = P_VER_TYPE
                            AND MC.YYYYMMDD >= V_PLAN_START_YYYYMMDD
                          GROUP BY MC.DIVISION_ID
                                 , MC.PROJECT_CODE
                                 , MC.SCM_SITE_ID
                                 , MC.ITEM_ID
                                 , MC.DOM_EXP
                                 , MC.FCST_TYPE
                                 , MC.INCOTERMS
                                 , MC.PLANT_SITE_ID
                       ) B
                 WHERE A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.YYYYMMDD >= V_PLAN_START_YYYYMMDD   /* 당주 월요일부터 판가 확정 */
                   AND SUBSTR(A.YYYYMMDD, 1, 6) < V_PLAN_TO_YYYYMM;
            /* 2026.09.30   AJS   81 계열 MKT FCST 확정 시 판가 확정 추가 (END) */
            END IF;
        /* [PJ2025-50188]_VERSION_TYPE이 S가 아니고 40 사업부인 경우 MKT FCST CUTOFF (END) */
        END IF;

        /* 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가 */
        /* EXEC [dbo].PR_DM_TO_XIF_SCM_MST_FUTURE_PRICE_C @p_division_id, @v_ver_return_no */
        /* ========================================================================================== */
        /* CUTOFF DATA INSERT (END) */
        /* ========================================================================================== */

    /* ============================================================================================= */
    /* 트랜잭션 (COMMIT) */
    /* ============================================================================================= */
        /* [원자성] MSSQL 원본의 COMMIT 은 상위 BEGIN TRAN 내부 실행이라 @@TRANCOUNT 감소일 뿐 실커밋이 아니었다.
           Oracle COMMIT 은 즉시 실커밋이라 상위(PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING,PR_DM_PLN_SALES_PLAN_CUTOFF)의 ROLLBACK 을 무력화한다 -> 제거. 커밋은 호출자 책임. */

    /* ============================================================================================= */
    /* 트랜잭션 (ERROR) */
    /* ============================================================================================= */
    EXCEPTION
        WHEN OTHERS THEN
            /* ROLLBACK */
            ROLLBACK;

            V_LOG_TYPE := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' ||TO_CHAR(SQLCODE);
            D_EVENT_DATE := SYSDATE;

            DBMS_OUTPUT.PUT_LINE('[' ||TO_CHAR(SQLCODE)||']' ||SQLERRM);   /*-- 에러메시지 DISPLAY --*/
    END;

    /* ============================================================================================= */
    /* 종료 LOG  (START) */
    /* ============================================================================================= */
    /* 수행결과 성공여부 DISPLAY */
    IF V_LOG_MESSAGE IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('success');
    END IF;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    /* ============================================================================================= */
    /* 종료 LOG  (END) */
    /* ============================================================================================= */
END;