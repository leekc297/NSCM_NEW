PROCEDURE PR_SSP_ANL_SHIPMENT_PLAN_FG
(
      P_PLAN_CYCLE           IN VARCHAR2
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2 /* PLAN_NAME */
    , P_PLAN_ID              IN VARCHAR2
    , P_MODELING_ID          IN VARCHAR2
    , P_SEQ                  IN VARCHAR2
    , P_PLAN_TYPE            IN VARCHAR2
    , P_MASTER_ID            IN VARCHAR2
    , P_DIVISION_ID          IN VARCHAR2
    , P_ENGINE_PLAN_ID       IN VARCHAR2
    , P_USER_ID              IN VARCHAR2 DEFAULT 'ssp_batch'
    /* -- , @p_debug       INT OUTPUT */
)
/*
 * Program ID   : PR_SSP_ANL_SHIPMENT_PLAN_FG
 * Description  : PR_SSP_ANL_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_SHIPMENT_PLAN_FG    @p_plan_cycle          ='DAILY'
                                                    , @p_plan_start_yyyymmdd ='20180807'
                                                    , @p_plan_id             ='103802'
                                                    , @p_modeling_id         ='201'
                                                    , @p_seq                 ='1'
                                                    , @p_plan_type           ='SP'
                                                    , @p_master_id           ='81::DAILY'
                                                    , @p_division_id         ='81'
                                                    , @p_engine_plan_id      ='103802::SP::1'
                                                    , @p_user_id             = 'KTH'
                 -- UI 실행
                 EXEC SSP0009_GET_SHIPMENT_PLAN_FG     @p_from_yyyymmdd        ='20180807'
                                                     , @p_to_yyyymmdd         ='20181001'
                                                     , @p_division_id         ='81'
                                                     , @p_biz_type            ='A'
                                                     , @p_project_code        ='A15HC2001'
                                                     , @p_item_id             ='ACLN1007I-A1'
                                                     , @p_plan_start_yyyymmdd ='20180807'
                                                     , @p_plan_type           ='SP'
                                                     , @p_seq                 ='1'
                                                     , @p_program_id          = 'SSP0009'
                                                     , @p_sheet_name          = 'Shipment Plan FG'
                                                     , @p_user_id             = 'middleware'

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.06.12   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.18   KTH         8주(56일) 추가 로직
 * 2018.07.16   KTH         전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가
                            SCP_MST_FINAL_ITEM_V로 변경, TMP_SSP_PLN_NET_DEMAND_V로 변경
                            파라미터 변경 (PLN과 동일하게 변경),MEASURE를 0으로 추가 로직 변경
 * 2018.07.19   KTH         INCOTERMS 수정
 * 2018.07.27   KTH         INCOTERMS 수정(BOD_ID -> DEMAND_ID)
 * 2018.08.07   KTH         MEASURE(WH_IN_BALANCE) 로직 추가( to site기준의 BOH + 특정일자까지 누적 Fcst qty * (-1) + 특정일자까지 누적 WH_IN total 누적수량)
 * 2018.08.22   KTH         최종입력시점에 MAX(INCOTERMS) 를 INCOTERMS 로 변경함.
 * 2018.09.14   KTH         UNPEGGING 제외 조건 추가 (ENG_DEMAND_ID 는 UNPEGGING 아님)
 * 2018.09.17   KTH         소형(40) Balance데이타 생성시 월별로 계산,Balance(WH_IN) 삭제,  삭제시 속도 개선
 * 2018.11.21   KTH         SHIP_REQ 로직변경(YYYYMMDD = LPST) 추가
 * 2019.08.02   KTH         BALANCE 입력(소형(40)일 경우)  월별 BALANCE 적용로직 삭제
 * 2026.07.06   ZIONEX      [PJ202650304] NextSCM Migration
 */
AS


    /* LOG 용 변수 설정 */
    V_BATCH_USER    VARCHAR2(150 CHAR) := 'ssp_batch';
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SSP_ANL_SHIPMENT_PLAN_FG';
    V_LOG_TYPE      VARCHAR2(30 CHAR); /* START/END/ERROR/... */
    N_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    V_TABLE_ID      VARCHAR2(150 CHAR) := 'SSP_ANL_SHIPMENT_PLAN_FG';
    D_EVENT_DATE    DATE;

    /* 임시 실행시간 확인용 */
    V_START_TIME    DATE := SYSDATE;
    V_EXEC_TIME     VARCHAR2(10 CHAR) := ''; /* '[00:00]'; */

    X_INT           NUMBER := 1;
    X_MEASURE       VARCHAR2(100 CHAR);

    V_ROWCOUNT      NUMBER;
    V_TOTAL_SEC     NUMBER;
    V_MIN           NUMBER;
    V_SEC           NUMBER;
    V_ERR_MSG       VARCHAR2(1000 CHAR);
BEGIN
    V_BATCH_USER := P_USER_ID;

  /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SSP_ANL_SHIPMENT_PLAN_FG INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER
                        );

    BEGIN
        /* BEGIN TRAN TX_FG */
          /*----------------------------------------------------------------------------------------------------------- */
          /* 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서 */
          /*----------------------------------------------------------------------------------------------------------- */
          /* 원본: IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL DROP TABLE ... / CREATE TABLE ...(선언폭=GT_SASF_FG) */
          /* => GTT GT_SASF_FG 사용, 진입부 DELETE 로 초기화. */
          DELETE FROM GT_SASF_FG;

            /*----------------------------------------------------------------------------------------------------------- */
            /* Measure 확인 (FG) */
            /*----------------------------------------------------------------------------------------------------------- */
            /*
            --SHIP PLAN FG MEASURE
            SELECT DBO.FN_GET_MEASURE_CODE('Ship Plan')           -- SHIP_PLAN              -- 1 SHIP_PLAN 입력 (FG)
            SELECT DBO.FN_GET_MEASURE_CODE('Ship Req')            -- SHIP_REQ               -- 1 SHIP_REQ 입력(FG)

            SELECT DBO.FN_GET_MEASURE_CODE('WH In')                 -- WH_IN                -- 2 WH_IN 입력 FG
            SELECT DBO.FN_GET_MEASURE_CODE('Intransit')             -- INTRANSIT            -- 3 INTRANSIT 입력  FG
            SELECT DBO.FN_GET_MEASURE_CODE('MKT FCST')              -- MKT_FCST             -- 4 MKT_FCST 입력 FG

            SELECT * FROM DBO.SCM_MST_SHEET_MEASURE WITH(NOLOCK)  WHERE PROGRAM_ID ='SCP0009'  -- shipment plan FG

                       MKT_FCST         MKT FCST
                       INTRANSIT       Intransit
                       WH_IN_TOTAL      WH In Total  = SUM(WH_IN) + INTRANSIT
                       BALANCE         Balance      = BOH - MKT_FCST + WH_IN_TOTAL
                       WH_IN           WH In
                       SHIP_REQ         Ship Req
                       SHIP_PLAN       Ship Plan
                       SHIP_PLAN_AMEND Ship Plan Amend
            */

            /*----------------------------------------------------------------------------------------------------------- */
            /* 1-1. SHIP_REQ 입력 (FG) */
            /*----------------------------------------------------------------------------------------------------------- */
            INSERT INTO GT_SASF_FG
                  (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,TRANSPORT_MODE
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
        )
            SELECT DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,MAX(OPERATION_GROUP)
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,TRANSPORT_MODE
                  ,MEASURE
                  ,YYYYMMDD
                  ,SUM(QTY) AS QTY /* sum */
             FROM (
                    SELECT
                          B.DIVISION_ID
                         ,B.PLAN_START_YYYYMMDD /* plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0) */
                         ,B.PLAN_TYPE
                         ,B.SEQ
                         ,B.OPERATION_GROUP
                         ,A.PROJECT_CODE
                         ,B.ITEM_ID
                         ,B.TO_SITE
                         ,A.INCOTERMS
                         ,B.FROM_SITE
                         ,B.BOD_ID
                         ,B.TRANSPORT_MODE
                         ,B.MEASURE
                         ,B.YYYYMMDD
                         ,A.ALLOCATION_QTY         AS QTY
                     FROM SSP_PLN_SHIPMENT_PLAN_PEGGING A
                        , SSP_PLN_SHIPMENT_PLAN B


                     WHERE 1 = 1
                     AND A.DIVISION_ID           = B.DIVISION_ID(+)
                     AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD(+)
                     AND A.PLAN_TYPE             = B.PLAN_TYPE(+)
                     AND A.SEQ                   = B.SEQ(+)
                     AND A.ORDER_ID              = B.ORDER_ID(+)
                  /* AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID */
                     AND B.MEASURE(+)            = 'SHIP_REQ'
                     AND B.SEMI_YN(+)            = 'N'
/* AND B.ENG_DEMAND_ID        <> 'UNPEGGING' */
                       AND A.DIVISION_ID         = P_DIVISION_ID /* '81' */
                       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD /* '20180409' */
                       AND A.PLAN_TYPE           = P_PLAN_TYPE /* 'PR' */
                       AND A.SEQ                 = P_SEQ /* '9' */
                       AND B.DIVISION_ID         IS NOT NULL
                       AND B.SEMI_YN               = 'N'
                       AND A.ENG_DEMAND_ID        <> 'UNPEGGING'
                       AND TO_DATE(B.YYYYMMDD, 'YYYYMMDD') = A.LPST
/* AND B.ENG_DEMAND_ID        <> 'UNPEGGING' */
                ) X
             GROUP BY
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,TRANSPORT_MODE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ;

            /*----------------------------------------------------------------------------------------------------------- */
            /* 1-2. SHIP_PLAN 입력 (FG) */
            /*----------------------------------------------------------------------------------------------------------- */
            INSERT INTO GT_SASF_FG
                  (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,TRANSPORT_MODE
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  )
            SELECT DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,MAX(OPERATION_GROUP)
                  ,NVL(NULLIF(RTRIM(PROJECT_CODE),''), '/') AS PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,TRANSPORT_MODE
                  ,MEASURE
                  ,YYYYMMDD
                  ,SUM(QTY) AS QTY /* sum */
             FROM (
                   SELECT
                          B.DIVISION_ID
                         ,B.PLAN_START_YYYYMMDD /* plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0) */
                         ,B.PLAN_TYPE
                         ,B.SEQ
                         ,B.OPERATION_GROUP
                         ,A.PROJECT_CODE
                         ,B.ITEM_ID
                         ,B.TO_SITE
                         ,A.INCOTERMS
                         ,B.FROM_SITE
                         ,B.BOD_ID
                         ,B.TRANSPORT_MODE
                         ,B.MEASURE
                         ,B.YYYYMMDD
                         ,A.ALLOCATION_QTY         AS QTY
                     FROM SSP_PLN_SHIPMENT_PLAN_PEGGING A
                        , SSP_PLN_SHIPMENT_PLAN B


                     WHERE 1 = 1
                     AND A.DIVISION_ID           = B.DIVISION_ID(+)
                     AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD(+)
                     AND A.PLAN_TYPE             = B.PLAN_TYPE(+)
                     AND A.SEQ                   = B.SEQ(+)
                     AND A.ORDER_ID              = B.ORDER_ID(+)
                  /* AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID */
                     AND B.MEASURE(+)            = 'SHIP_PLAN'
                     AND B.SEMI_YN(+)            = 'N'
/* AND B.ENG_DEMAND_ID        <> 'UNPEGGING' */
                       AND A.DIVISION_ID         = P_DIVISION_ID /* '81' */
                       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD /* '20180409' */
                       AND A.PLAN_TYPE           = P_PLAN_TYPE /* 'PR' */
                       AND A.SEQ                 = P_SEQ /* '9' */
                       AND B.DIVISION_ID         IS NOT NULL
                       AND A.ENG_DEMAND_ID        <> 'UNPEGGING'
/* AND B.ENG_DEMAND_ID        <> 'UNPEGGING' */
                ) X
             GROUP BY
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,NVL(NULLIF(RTRIM(PROJECT_CODE),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,TRANSPORT_MODE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ;

            /*----------------------------------------------------------------------------------------------------------- */
            /* 2-1. WH_IN 입력 FG : SSP_ANL_PROBLEM_REPORT_PEGGING */
            /*----------------------------------------------------------------------------------------------------------- */
            INSERT INTO GT_SASF_FG
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,TRANSPORT_MODE
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  )
            SELECT DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,'-'                      AS BOD_ID
                  ,'-'                      AS TRANSPORT_MODE
                  ,'WH_IN'                  AS MEASURE
                  ,YYYYMMDD
                  ,SUM(QTY)                 AS QTY
                  FROM (
                        SELECT A.DIVISION_ID
                              ,A.PLAN_START_YYYYMMDD
                              ,A.PLAN_TYPE
                              ,A.SEQ
                              ,A.OPERATION_GROUP
                              ,SUBSTR(FN_SCM_SPLIT(A.ENG_DEMAND_ID,2,'::'), 1, 100)                             AS PROJECT_CODE
                              ,A.ITEM_ID
                              ,A.TO_SITE
                              ,FN_SCM_SPLIT(FN_SCM_SPLIT(A.STOCK_PLAN_LOT_ID,2,'::'),2,'~') AS INCOTERMS
                              /* ,dbo.fn_scm_split(a.eng_demand_id,7,'::')                             AS from_site */
                              ,FN_SCM_SPLIT(A.STOCK_PLAN_LOT_ID,5,'::')                         AS FROM_SITE
                              ,SUBSTR((CASE WHEN FN_SCM_SPLIT(A.STOCK_PLAN_LOT_ID,4,'::') < P_PLAN_START_YYYYMMDD THEN P_PLAN_START_YYYYMMDD
                                     ELSE FN_SCM_SPLIT(A.STOCK_PLAN_LOT_ID,4,'::')
                                     END), 1, 8)                                                           AS YYYYMMDD
                              ,A.PLANNED_QTY                            AS QTY
                          FROM SSP_ANL_PROBLEM_REPORT_PEGGING A
                          WHERE 1=1
                            AND A.DIVISION_ID            = P_DIVISION_ID /* N'81'          -- */
                            AND A.PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD /* N'20180521'    -- */
                            AND A.PLAN_TYPE              = P_PLAN_TYPE /* N'PR'          -- */
                            AND A.SEQ                    = P_SEQ /* N'1'           -- */
                            AND A.STOCK_PLAN_LOT_ID   LIKE 'INT%'

                      ) X
             GROUP BY
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,YYYYMMDD
                  ;

            /*----------------------------------------------------------------------------------------------------------- */
            /* 2-2. WH_IN 입력 FG : SSP_PLN_SHIPMENT_PLAN_PEGGING */
            /*----------------------------------------------------------------------------------------------------------- */
            INSERT INTO GT_SASF_FG
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,TRANSPORT_MODE
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  )
            SELECT DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,MAX(OPERATION_GROUP)
                  ,NVL(NULLIF(RTRIM(PROJECT_CODE),''), '/') AS PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,'-'   AS BOD_ID
                  ,'-'   AS TRANSPORT_MODE
                  ,MEASURE
                  ,YYYYMMDD
                  ,SUM(QTY)
                  FROM (

                        SELECT
                          B.DIVISION_ID
                         ,B.PLAN_START_YYYYMMDD /* plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0) */
                         ,B.PLAN_TYPE
                         ,B.SEQ
                         ,B.OPERATION_GROUP
                         ,A.PROJECT_CODE
                         ,B.ITEM_ID
                         ,B.TO_SITE
                         ,A.INCOTERMS
                         ,B.FROM_SITE
                         ,B.BOD_ID
                         ,B.TRANSPORT_MODE
                         ,'WH_IN' AS MEASURE
                         ,TO_CHAR(B.END_TIME, 'YYYYMMDD') AS YYYYMMDD
                         ,A.ALLOCATION_QTY         AS QTY
                     FROM SSP_PLN_SHIPMENT_PLAN_PEGGING A
                        , SSP_PLN_SHIPMENT_PLAN B


              WHERE 1 = 1
                     AND A.DIVISION_ID           = B.DIVISION_ID(+)
                     AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD(+)
                     AND A.PLAN_TYPE             = B.PLAN_TYPE(+)
                     AND A.SEQ                   = B.SEQ(+)
                     AND A.ORDER_ID              = B.ORDER_ID(+)
                  /* AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID */
                     AND B.MEASURE(+)            = 'SHIP_PLAN'
                     AND B.SEMI_YN(+)            = 'N'
/* AND B.ENG_DEMAND_ID        <> 'UNPEGGING' */
                       AND A.DIVISION_ID         = P_DIVISION_ID /* '81' */
                       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD /* '20180409' */
                       AND A.PLAN_TYPE           = P_PLAN_TYPE /* 'PR' */
                       AND A.SEQ                 = P_SEQ /* '9' */
                       AND B.DIVISION_ID         IS NOT NULL
                       AND A.ENG_DEMAND_ID        <> 'UNPEGGING'
/* AND B.ENG_DEMAND_ID        <> 'UNPEGGING' */

                      ) X
             GROUP BY
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,PROJECT_CODE
                  ,NVL(PROJECT_CODE,'/')
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,MEASURE
                  ,YYYYMMDD
                  ;

            /*----------------------------------------------------------------------------------------------------------- */
          /* 7. ALLOCATION 추가 */
          /*----------------------------------------------------------------------------------------------------------- */
           INSERT INTO GT_SASF_FG
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  )
                 SELECT A.DIVISION_ID /* DIVISION_ID */
                       ,A.PLAN_START_YYYYMMDD /* PLAN_START_YYYYMMDD */
                       ,A.PLAN_TYPE /* PLAN_TYPE */
                       ,A.SEQ /* SEQ */
                       ,A.OPERATION_GROUP /* OPERATION_GROUP */
                       ,A.PROJECT_CODE /* PROJECT_CODE */
                       ,A.ITEM_ID /* ITEM_ID */
                       ,A.SALES_SITE_ID         AS TO_SITE /* TO_SITE */
                       ,A.INCOTERMS /* INCOTERMS */
                       ,'-'                     AS FROM_SITE /* FROM_SITE */
                       ,'-'                     AS BOD_ID /* BOD_ID */
                       ,'ALLOCATION'            AS MEASURE /* MEASURE */
                       ,A.YYYYMMDD /* YYYYMMDD */
                       ,SUM(NVL(A.ALLOCATION_QTY,0))  AS QTY /* QTY */
                  FROM SSP_PLN_ALLOCATION A
                 WHERE 0 = 0
                   AND A.DIVISION_ID         = P_DIVISION_ID /* '81' */
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD /* '20180409' */
                   AND A.PLAN_TYPE           = P_PLAN_TYPE /* 'PR' */
                   AND A.SEQ                 = P_SEQ /* '9' */
                  GROUP BY
                       DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
                      ,PROJECT_CODE
                      ,ITEM_ID
                      ,SALES_SITE_ID
                      ,INCOTERMS
                      ,FROM_SITE
                      ,YYYYMMDD
                      ;
            /*----------------------------------------------------------------------------------------------------------- */
            /* 5. MKT_FCST 입력 FG */
           /*----------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_SASF_NET_DEMAND;

            INSERT INTO GT_SASF_NET_DEMAND
                  (
                    DIVISION_ID
                   ,PLAN_START_YYYYMMDD
                   ,PLAN_TYPE
                   ,SEQ
                   ,MASTER_ID
                   ,ENG_PLAN_ID
                   ,PROJECT_CODE
                   ,ITEM_ID
                   ,SALES_SITE_ID
                   ,INCOTERMS
                   ,YYYYMMDD
                   ,SPLIT_QTY
                  )
           SELECT
                     A.DIVISION_ID
                    ,A.PLAN_START_YYYYMMDD
                    ,A.PLAN_TYPE
                    ,A.SEQ
                    ,A.MASTER_ID
                    ,A.ENG_PLAN_ID
                    ,NVL(NULLIF(RTRIM(A.PROJECT_CODE),''), '/')  AS PROJECT_CODE
                    ,A.ITEM_ID
                    ,A.SALES_SITE_ID
                    ,A.INCOTERMS
                    ,A.YYYYMMDD
                    ,A.SPLIT_QTY
                FROM SCP_PLN_NET_DEMAND_V A
               WHERE VALIDATE_CONVERSION(A.SEQ AS NUMBER) = 1
                 AND A.DIVISION_ID           = P_DIVISION_ID
                 AND A.PLAN_START_YYYYMMDD   = P_PLAN_START_YYYYMMDD
                 AND A.PLAN_TYPE             = P_PLAN_TYPE
                 AND A.SEQ                   = P_SEQ
                 AND A.MASTER_ID             = P_MASTER_ID
                 AND A.ENG_PLAN_ID           = P_ENGINE_PLAN_ID
                 ;

             INSERT INTO GT_SASF_FG
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  /* ,ORIGIN_FROM_DIVISION_ID */
                  /* ,ORIGIN_TO_DIVISION_ID */
                  /* ,ELECTRODE_TYPE */
                  ,QTY
                  )

              SELECT
                     SUBSTR(A.DIVISION_ID, 1, 30)                                    AS DIVISION_ID
                    ,SUBSTR(A.PLAN_START_YYYYMMDD, 1, 8)                             AS PLAN_START_YYYYMMDD
                    ,SUBSTR(A.PLAN_TYPE, 1, 50)                                      AS PLAN_TYPE
                    ,A.SEQ
                    ,C.OPERATION_GROUP   AS OPERATION_GROUP
                    ,SUBSTR(A.PROJECT_CODE, 1, 100)                                  AS PROJECT_CODE
                    ,SUBSTR(A.ITEM_ID, 1, 100)                                       AS ITEM_ID
                    ,SUBSTR(A.SALES_SITE_ID, 1, 100)                                 AS TO_SITE
                    ,SUBSTR(A.INCOTERMS, 1, 100)                                     AS INCOTERMS
                    , '-'                                                       AS FROM_SITE
                    , '-'                                                       AS BOD_ID
                    ,'MKT_FCST'                                                 AS MEASURE
                    ,SUBSTR(A.YYYYMMDD, 1, 8)                                        AS YYYYMMDD
                    ,SUM(A.SPLIT_QTY)
                FROM GT_SASF_NET_DEMAND A
                   , SCP_MST_FINAL_ITEM_V C
                /* [FMT ③ §4.72] ANSI INNER JOIN -> 콤마 + WHERE 조인조건. */
                /* ON 의 A.DIVISION_ID = P_DIVISION_ID 는 아래 WHERE 에 동일 술어가 있어 옮기지 않는다(로직 동일). */
               WHERE A.ITEM_ID             = C.ITEM_ID
                 AND VALIDATE_CONVERSION(A.SEQ AS NUMBER) = 1
                 AND A.DIVISION_ID           = P_DIVISION_ID
                 AND A.PLAN_START_YYYYMMDD   = P_PLAN_START_YYYYMMDD
                 AND A.PLAN_TYPE             = P_PLAN_TYPE
                 AND A.SEQ                   = P_SEQ
                 AND A.MASTER_ID             = P_MASTER_ID
                 AND A.ENG_PLAN_ID           = P_ENGINE_PLAN_ID

/* AND ISNUMERIC(A.seq)        = 1 */
            GROUP BY
                     A.DIVISION_ID
                    ,A.PLAN_START_YYYYMMDD
                    ,A.PLAN_TYPE
                    ,A.SEQ
                    ,C.OPERATION_GROUP
                    ,A.PROJECT_CODE
                    ,A.ITEM_ID
                    ,A.SALES_SITE_ID
                    ,A.INCOTERMS
                    ,A.YYYYMMDD
                    ;

            /*----------------------------------------------------------------------------------------------------------- */
            /* 5. SHIP_PLAN_AMEND 입력 FG */
            /*----------------------------------------------------------------------------------------------------------- */
                 INSERT INTO GT_SASF_FG
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  )
              SELECT DIVISION_ID /* DIVISION_ID */
                  ,PLAN_START_YYYYMMDD /* PLAN_START_YYYYMMDD */
                  ,PLAN_TYPE /* PLAN_TYPE */
                  ,SEQ /* SEQ */
                  ,OPERATION_GROUP /* OPERATION_GROUP */
                  ,NVL(NULLIF(RTRIM(PROJECT_CODE),''), '/') AS PROJECT_CODE /* PROJECT_CODE */
                  ,ITEM_ID /* ITEM_ID */
                  ,TO_SITE /* TO_SITE */
                  ,INCOTERMS /* INCOTERMS */
                  ,FROM_SITE /* FROM_SITE */
                  ,BOD_ID /* BOD_ID */
                 ,'SHIP_PLAN_AMEND' AS MEASURE /* MEASURE */
                  ,YYYYMMDD /* YYYYMMDD */
                  ,QTY /* QTY */
              FROM GT_SASF_FG
              WHERE MEASURE ='SHIP_PLAN'
              ;

          /*----------------------------------------------------------------------------------------------------------- */
          /* 6. WH_IN_TOTAL 입력 FG  = SUM(WH_IN) + INTRANSIT */
          /*----------------------------------------------------------------------------------------------------------- */
          /*
                 INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  )
              SELECT DIVISION_ID                                  --DIVISION_ID
                    ,PLAN_START_YYYYMMDD                          --PLAN_START_YYYYMMDD
                    ,PLAN_TYPE                                    --PLAN_TYPE
                    ,SEQ                   --SEQ
                    ,OPERATION_GROUP                              --OPERATION_GROUP
                    ,PROJECT_CODE                                 --PROJECT_CODE
                    ,ITEM_ID                                      --ITEM_ID
                    ,TO_SITE                                      --TO_SITE
                    ,INCOTERMS                                    --INCOTERMS
                    ,'-'                  AS FROM_SITE            --FROM_SITE
                    ,'-'         AS BOD_ID               --BOD_ID
                    ,'WH_IN_TOTAL'        AS MEASURE              --MEASURE
                    ,YYYYMMDD                                     --YYYYMMDD
                    ,SUM(ISNULL(QTY,0))                           --QTY
               FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG  WITH(NOLOCK)
              WHERE MEASURE IN ('WH_IN','INTRANSIT')
              GROUP BY
                    DIVISION_ID
                   ,PLAN_START_YYYYMMDD
                   ,PLAN_TYPE
                   ,SEQ
                   ,OPERATION_GROUP
                   ,PROJECT_CODE
                   ,ITEM_ID
                   ,TO_SITE
                   ,INCOTERMS
                   ,YYYYMMDD
                   ;
           */

          /*----------------------------------------------------------------------------------------------------------- */
          /* 7-1. MKT_FCST OR INTRANSIT OR WH_IN_TOTAL 이 존재하지 않는 경우, 해당 MEASURE를 0으로 추가 */
          /* (비고) FROM SITE TO SITE 출하계획이 존재하지 않는 경우, 관련 MEASURE가 미생성되는 것은 허용함 */
          /* ( WH_IN, SHIP_REQ, SHIP_PLAN, SHIP_PLAN_AMEND ) */
          /*----------------------------------------------------------------------------------------------------------- */

          WHILE X_INT < 3
          LOOP

               X_MEASURE := ( CASE X_INT WHEN 1 THEN 'MKT_FCST'
                                                 WHEN 2 THEN 'ALLOCATION'
                                                /* WHEN 3 THEN 'WH_IN_TOTAL' */
                                     END);


                INSERT INTO GT_SASF_FG
                     (
                       DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
                      ,PROJECT_CODE
                      ,ITEM_ID
                      ,TO_SITE
                      ,INCOTERMS
                      ,FROM_SITE
                      ,BOD_ID
                      ,MEASURE
                      ,YYYYMMDD
                      /* ,ORIGIN_FROM_DIVISION_ID */
                      /* ,ORIGIN_TO_DIVISION_ID */
                      /* ,ELECTRODE_TYPE */
                      ,QTY
                      )
               SELECT
                      SUB.DIVISION_ID /* DIVISION_ID */
                     ,SUB.PLAN_START_YYYYMMDD /* PLAN_START_YYYYMMDD */
                     ,SUB.PLAN_TYPE /* PLAN_TYPE */
                     ,SUB.SEQ /* SEQ */
                     ,SUB.OPERATION_GROUP /* OPERATION_GROUP */
                     ,SUB.PROJECT_CODE /* PROJECT_CODE */
                     ,SUB.ITEM_ID /* ITEM_ID */
                     ,SUB.TO_SITE /* TO_SITE */
                     ,SUB.INCOTERMS /* INCOTERMS */
                     ,SUB.FROM_SITE /* FROM_SITE */
                     ,SUB.BOD_ID /* BOD_ID */
                     ,SUB.MEASURE /* MEASURE */
                     ,SUB.YYYYMMDD /* YYYYMMDD */
                     /* ,SUB.ORIGIN_FROM_DIVISION_ID */
                     /* ,SUB.ORIGIN_TO_DIVISION_ID */
                     /* ,SUB.ELECTRODE_TYPE */
                     ,0   AS QTY /* QTY */
                FROM
                    (
                        SELECT
                               DIVISION_ID
                              ,PLAN_START_YYYYMMDD
                              ,PLAN_TYPE
                              ,SEQ
                              ,OPERATION_GROUP
                              ,PROJECT_CODE
                              ,ITEM_ID
                              ,TO_SITE
                              ,INCOTERMS
                              ,'-'        AS FROM_SITE
                              ,'-'        AS BOD_ID
                              ,X_MEASURE AS MEASURE
                              ,YYYYMMDD
                              /* ,ORIGIN_FROM_DIVISION_ID */
                              /* ,ORIGIN_TO_DIVISION_ID */
                              /* ,ELECTRODE_TYPE */
                         FROM
                              ( /* 56 DAYS */
                                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                                   FROM SCM_SYS_CALENDAR_M    C
                                  WHERE 1=1
                                    AND C.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                                    AND C.BASIS_YYYYMMDD <  TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD') /* 8주(56일) */
                              ) A
                            , (
                                 SELECT DISTINCT
                                        DIVISION_ID
                                       ,PLAN_START_YYYYMMDD
                                       ,PLAN_TYPE
                                       ,SEQ
                                       ,OPERATION_GROUP
                                       ,PROJECT_CODE
                                       ,ITEM_ID
                                       ,TO_SITE
                                       ,INCOTERMS
                                       /* ,ORIGIN_FROM_DIVISION_ID */
                                       /* ,ORIGIN_TO_DIVISION_ID */
                                       /* ,ELECTRODE_TYPE */
                                  FROM GT_SASF_FG X
                                 WHERE 1=1
                              ) B
                    ) SUB
                    WHERE 1=1
                      AND NOT EXISTS (
                                       SELECT 'X'
                                         FROM GT_SASF_FG Z
                                        WHERE 1=1
                                          AND Z.DIVISION_ID              = SUB.DIVISION_ID
                                          AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD
                                          AND Z.PLAN_TYPE                = SUB.PLAN_TYPE
                                          AND Z.SEQ    = SUB.SEQ
                                          AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP
                                          AND Z.PROJECT_CODE             = SUB.PROJECT_CODE
                                          AND Z.ITEM_ID                  = SUB.ITEM_ID
                                          AND Z.TO_SITE                  = SUB.TO_SITE
                                          AND Z.INCOTERMS                = SUB.INCOTERMS
                                          AND Z.MEASURE                  = X_MEASURE
                                          AND Z.YYYYMMDD                 = SUB.YYYYMMDD
                                          /* AND Z.ORIGIN_FROM_DIVISION_ID  = SUB.ORIGIN_FROM_DIVISION_ID */
                                          /* AND Z.ORIGIN_TO_DIVISION_ID    = SUB.ORIGIN_TO_DIVISION_ID */
                                          /* AND Z.ELECTRODE_TYPE           = SUB.ELECTRODE_TYPE */
                                     );

               X_INT := X_INT + 1;

           END LOOP;

          /*----------------------------------------------------------------------------------------------------------- */
          /* 7-2. MEASURE별 BUCKET일자별 0 채우기 */
          /*----------------------------------------------------------------------------------------------------------- */

            INSERT INTO GT_SASF_FG
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,YYYYMMDD
                  /* ,ORIGIN_FROM_DIVISION_ID */
                  /* ,ORIGIN_TO_DIVISION_ID */
                  /* ,ELECTRODE_TYPE */
                  ,QTY
                  )
           SELECT
                  SUB.DIVISION_ID /* DIVISION_ID */
                 ,SUB.PLAN_START_YYYYMMDD /* PLAN_START_YYYYMMDD */
                 ,SUB.PLAN_TYPE /* PLAN_TYPE */
                 ,SUB.SEQ /* SEQ */
                 ,SUB.OPERATION_GROUP /* OPERATION_GROUP */
                 ,SUB.PROJECT_CODE /* PROJECT_CODE */
                 ,SUB.ITEM_ID /* ITEM_ID */
                 ,SUB.TO_SITE /* TO_SITE */
                 ,SUB.INCOTERMS /* INCOTERMS */
                 ,SUB.FROM_SITE /* FROM_SITE */
                 ,SUB.BOD_ID /* BOD_ID */
                 ,SUB.MEASURE /* MEASURE */
                 ,SUB.YYYYMMDD /* YYYYMMDD */
                 /* ,SUB.ORIGIN_FROM_DIVISION_ID */
                 /* ,SUB.ORIGIN_TO_DIVISION_ID */
                 /* ,SUB.ELECTRODE_TYPE */
                 ,0   AS QTY /* QTY */
            FROM
                (
                    SELECT
                           DIVISION_ID
                          ,PLAN_START_YYYYMMDD
                          ,PLAN_TYPE
                          ,SEQ
                          ,OPERATION_GROUP
                          ,PROJECT_CODE
                          ,ITEM_ID
                          ,TO_SITE
                          ,INCOTERMS
                          ,FROM_SITE
                          ,BOD_ID
                          ,MEASURE
                          ,YYYYMMDD
                          /* ,ORIGIN_FROM_DIVISION_ID */
                          /* ,ORIGIN_TO_DIVISION_ID */
                          /* ,ELECTRODE_TYPE */
                     FROM
                          ( /* 56 DAYS */
                             SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                               FROM SCM_SYS_CALENDAR_M    C
                             WHERE 1=1
                                AND C.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
/* AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112) */
                                AND C.BASIS_YYYYMMDD <  TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD') /* 8주(56일) */
                          ) A
                        , (
                             SELECT DISTINCT
                                    DIVISION_ID
                                   ,PLAN_START_YYYYMMDD
                                   ,PLAN_TYPE
                                   ,SEQ
                                   ,OPERATION_GROUP
                                   ,PROJECT_CODE
                                   ,ITEM_ID
                                   ,TO_SITE
                                   ,INCOTERMS
                                   ,FROM_SITE
                                   ,BOD_ID
                                   ,MEASURE
                                   /* ,ORIGIN_FROM_DIVISION_ID */
                                   /* ,ORIGIN_TO_DIVISION_ID */
                                   /* ,ELECTRODE_TYPE */
                              FROM GT_SASF_FG X
                             WHERE 1=1
                          ) B
                ) SUB
                WHERE 1=1
                  AND NOT EXISTS (
                                   SELECT 'X'
                                     FROM GT_SASF_FG Z
                                    WHERE 1=1
                                      AND Z.DIVISION_ID              = SUB.DIVISION_ID
                                      AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD
                                      AND Z.PLAN_TYPE                = SUB.PLAN_TYPE
                                      AND Z.SEQ          = SUB.SEQ
                                      AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP
                                      AND Z.PROJECT_CODE             = SUB.PROJECT_CODE
                                      AND Z.ITEM_ID                  = SUB.ITEM_ID
                                      AND Z.TO_SITE                  = SUB.TO_SITE
                                      AND Z.INCOTERMS                = SUB.INCOTERMS
                                      AND Z.FROM_SITE                = SUB.FROM_SITE
                                      AND Z.BOD_ID                   = SUB.BOD_ID
                                      AND Z.MEASURE                  = SUB.MEASURE
                                      AND Z.YYYYMMDD                 = SUB.YYYYMMDD
                                      /* AND Z.ORIGIN_FROM_DIVISION_ID  = SUB.ORIGIN_FROM_DIVISION_ID */
                                      /* AND Z.ORIGIN_TO_DIVISION_ID    = SUB.ORIGIN_TO_DIVISION_ID */
                                      /* AND Z.ELECTRODE_TYPE          = SUB.ELECTRODE_TYPE */
                                 );

          /*----------------------------------------------------------------------------------------------------------- */
          /* 8. BALANCE 계산값 생성 */
          /*----------------------------------------------------------------------------------------------------------- */
          /*----------------------------------------------------------------------------------------------------------- */
          /* 8.1 BALANCE에 사용할 MEASURE 임시테이블 생성  ('MKT_FCST','ALLOCATION') OR ('MKT_FCST','WH_IN')  = ('MKT_FCST','WH_IN','ALLOCATION') */
          /*---------------------------------------------------------------------------------------------------------- */
             DELETE FROM GT_SASF_Z;
             INSERT INTO GT_SASF_Z
                  (
                    DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,YYYYMMDD
                  )
             SELECT   DISTINCT
                    DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,YYYYMMDD
                  /* ,ORIGIN_FROM_DIVISION_ID */
                  /* ,ORIGIN_TO_DIVISION_ID */
                  /* ,ELECTRODE_TYPE */
              FROM GT_SASF_FG
              WHERE 1=1
                AND MEASURE            IN ('MKT_FCST','ALLOCATION')
                GROUP BY
                    DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,YYYYMMDD
                  ,OPERATION_GROUP
                  /* ,ORIGIN_FROM_DIVISION_ID */
                  /* ,ORIGIN_TO_DIVISION_ID */
                  /* ,ELECTRODE_TYPE */
                  ;

             DELETE FROM GT_SASF_Y;
             INSERT INTO GT_SASF_Y
                  (
                    DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,YYYYMMDD
                  )
         SELECT   DISTINCT
                    DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,YYYYMMDD
                  /* ,ORIGIN_FROM_DIVISION_ID */
                  /* ,ORIGIN_TO_DIVISION_ID */
                  /* ,ELECTRODE_TYPE */
              FROM GT_SASF_FG
              WHERE 1=1
                AND MEASURE            IN ('MKT_FCST','WH_IN')
                GROUP BY
                    DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,TO_SITE
                  ,INCOTERMS
                  ,YYYYMMDD
                  ,OPERATION_GROUP
                  ;

          /*----------------------------------------------------------------------------------------------------------- */
          /* 8.2 BALANCE에 사용할 #BOH 임시테이블 생성 */
          /*---------------------------------------------------------------------------------------------------------- */
          /*
                select @x_site_type = site_type
                  from scm_mst_site     s with(nolock)
                 where 1=1
                   and s.division_id    = @p_division_id
                   and s.scm_site_id    = @p_scm_site_id
                   ;

               if @x_site_type = 'PLANT'
               begin

                    select @x_boh_qty = sum(isnull(psi_boh_qty,0))
                      from ssp_pln_plant_onhand with(nolock)
                     where division_id               = @p_division_id
                       and stock_type    NOT IN ( 'FOR_STOCKPLAN','FORMING','FORMED','CHARING','CHAR','A_MOVE_WH','A_OUT_WH')   --셀 활성화진행중 이후 특성,창고재고 제외
                       and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd
                       and plan_type                 = @p_plan_type
                       and seq                       = @p_plan_seq
                       and site_id                   = @p_scm_site_id
                       and item_id                   = @p_item_id
                       and yyyymmdd                  = @p_yyyymmdd
                       ;

               end
            else
               begin

                    select @x_boh_qty = sum(isnull(psi_boh_qty,0))
                      from ssp_pln_sales_onhand with(nolock)
                     where division_id               = @p_division_id
                       and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd
                       and plan_type                 = @p_plan_type
                       and seq                       = @p_plan_seq
                       and site_id                   = @p_scm_site_id
                       and item_id                   = @p_item_id
                       and yyyymmdd                  = @p_yyyymmdd
                       ;

               end
                */
             DELETE FROM GT_SASF_BOH;
             INSERT INTO GT_SASF_BOH
                  (
                    DIVISION_ID
                 ,PLAN_START_YYYYMMDD
                 ,PLAN_TYPE
                 ,SEQ
                 ,SITE_ID
                 ,ITEM_ID
                 ,PSI_BOH_QTY
                  )
           SELECT DIVISION_ID
                 ,PLAN_START_YYYYMMDD
                 ,PLAN_TYPE
                 ,SEQ
                 ,SITE_ID
                 ,ITEM_ID
                 ,PSI_BOH_QTY
             FROM SSP_PLN_SALES_ONHAND
            WHERE 0 = 0
              AND DIVISION_ID               = P_DIVISION_ID /* '81' */
/* and stock_type                NOT IN ( 'FOR_STOCKPLAN','FORMING','FORMED','CHARING','CHAR','A_MOVE_WH','A_OUT_WH')  --셀 활성화진행중 이후 특성,창고재고 제외 */
              AND PLAN_START_YYYYMMDD       = P_PLAN_START_YYYYMMDD /* '20180416' */
              AND PLAN_TYPE                 = P_PLAN_TYPE /* 'PR' */
              AND SEQ                       = P_SEQ /* 1 */
              AND YYYYMMDD                  = P_PLAN_START_YYYYMMDD /* 계획시작일 */
              ;

          /*----------------------------------------------------------------------------------------------------------- */
          /* 8.3 BALANCE 입력 */
          /*---------------------------------------------------------------------------------------------------------- */
          /* BALANCE 속도 때문에 CLUSTERED INDEX 추가 함. */
            /* DROP INDEX #tmp_SSP_ANL_SHIPMENT_PLAN_FG.IX01_#tmp_SSP_ANL_SHIPMENT_PLAN_FG */
          /* Oracle: GTT 세션 인덱스 런타임 생성 불가/불요(물리 최적화). 원본 CLUSTERED INDEX 정의는 배포시 GTT DDL에서 검토. */
          /* CREATE CLUSTERED INDEX IX01 ON #tmp ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PROJECT_CODE, ITEM_ID, TO_SITE, INCOTERMS, MEASURE, YYYYMMDD ) */
              /* 00:27초 */
            /* PRINT N'BALANCE 계산전'; */


              INSERT INTO GT_SASF_FG
                      (
                        DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,PROJECT_CODE
                        ,ITEM_ID
                        ,TO_SITE
                        ,INCOTERMS
                        ,FROM_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        /* ,ORIGIN_FROM_DIVISION_ID */
                        /* ,ORIGIN_TO_DIVISION_ID */
                        /* ,ELECTRODE_TYPE */
                        ,QTY
                        )
                SELECT
                        Z.DIVISION_ID
                       ,Z.PLAN_START_YYYYMMDD
                       ,Z.PLAN_TYPE
                       ,Z.SEQ
                       ,Z.OPERATION_GROUP
                       ,Z.PROJECT_CODE
                       ,Z.ITEM_ID
                       ,Z.TO_SITE
                       ,Z.INCOTERMS
                       ,'-' AS FROM_SITE
                       ,'-' AS BOD_ID
                       ,'BALANCE' AS MEASURE
                       ,Z.YYYYMMDD
                       /* ,Z.ORIGIN_FROM_DIVISION_ID */
                       /* ,Z.ORIGIN_TO_DIVISION_ID */
                       /* ,Z.ELECTRODE_TYPE */
                       ,( SELECT
                               NVL( SUM(CASE MEASURE WHEN 'MKT_FCST'   THEN -1 * NVL(QTY,0)
                                                        WHEN 'ALLOCATION' THEN      NVL(QTY,0)
                                                 ELSE 0.0
                                     END),0)
                           FROM GT_SASF_FG X
                         WHERE 1=1
                           AND X.DIVISION_ID          = Z.DIVISION_ID
                           AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD
                           AND X.PLAN_TYPE            = Z.PLAN_TYPE
                           AND X.SEQ                  = Z.SEQ
                           AND X.PROJECT_CODE         = Z.PROJECT_CODE
                           AND X.ITEM_ID              = Z.ITEM_ID
                           AND X.TO_SITE              = Z.TO_SITE
                           AND X.INCOTERMS            = Z.INCOTERMS
                           AND X.MEASURE              IN ('MKT_FCST','ALLOCATION')
                           /* AND X.ORIGIN_FROM_DIVISION_ID   = Z.ORIGIN_FROM_DIVISION_ID */
                           /* AND X.ORIGIN_TO_DIVISION_ID     = Z.ORIGIN_TO_DIVISION_ID */
                           /* AND X.ELECTRODE_TYPE            = Z.ELECTRODE_TYPE */
                           AND X.YYYYMMDD            <= Z.YYYYMMDD
                         )     AS PSI_BOH_QTY
                 FROM GT_SASF_Z Z
                WHERE 1=1
                AND Z.YYYYMMDD   < TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD') /* 8주(56일) 추가 */
                ;

          /*----------------------------------------------------------------------------------------------------------- */
          /* 8.3 BALANCE 입력(소형(40)일 경우)  월별 BALANCE 적용 */
          /*---------------------------------------------------------------------------------------------------------- */
          /*
          IF @p_division_id = '40'  -- MEASURE ='BALANCE'
          BEGIN
                UPDATE XX
                SET XX.QTY   = ISNULL((YY.ALLOCATION_SUM_MONTH + MKT_FCST_SUM_MONTH), 0)
                FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG XX with (nolock)
                INNER JOIN  (
                               SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ
                                  ,PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,'BALANCE' AS MEASURE,YYYYMMDD
                               ,(SUM((CASE WHEN MEASURE ='ALLOCATION' THEN ISNULL(QTY,0) ELSE 0 END))  OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,SUBSTRING(YYYYMMDD,1,6) ORDER BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,YYYYMMDD))       AS ALLOCATION_SUM_MONTH
                               ,(SUM((CASE WHEN MEASURE ='MKT_FCST'   THEN ISNULL(QTY,0) ELSE 0 END))  OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,SUBSTRING(YYYYMMDD,1,6) ORDER BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,YYYYMMDD) * -1)  AS MKT_FCST_SUM_MONTH
                               FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X with (nolock)
                               WHERE 0 = 0
                               AND  X.MEASURE in ('ALLOCATION','MKT_FCST')
                           ) YY
                       ON  XX.DIVISION_ID             = YY.DIVISION_ID
                       AND XX.PLAN_START_YYYYMMDD     = YY.PLAN_START_YYYYMMDD
                       AND XX.PLAN_TYPE               = YY.PLAN_TYPE
                       AND XX.SEQ                     = YY.SEQ
                       AND XX.PROJECT_CODE            = YY.PROJECT_CODE
                       AND XX.ITEM_ID                 = YY.ITEM_ID
                       AND XX.TO_SITE                 = YY.TO_SITE
                       AND XX.INCOTERMS               = YY.INCOTERMS
                       AND XX.YYYYMMDD                = YY.YYYYMMDD
                       AND XX.MEASURE                 = YY.MEASURE        -- 'MKT_FCST_SUM_MONTH'
                       AND XX.MEASURE                 = 'BALANCE'
          END  -- @p_division_id = '40'
          */
          /*----------------------------------------------------------------------------------------------------------- */
          /* 8.4 WH_IN_BALANCE 입력(to site기준의 BOH + 특정일자까지 누적 Fcst qty * (-1) + 특정일자까지 누적 WH_IN total 누적수량 ) */
          /*----------------------------------------------------------------------------------------------------------- */
          /* 기존의 RTF Balance는 Allocation에 대해서 Balance를 표현하였으며,WH_in total수량에 대한 Balance는 BOH( 기초재고)를 감안하여, Fcst매출을 차감한 실물기준 재고예상을 보여주는 것입니다. */
            /* FN_GET_SSP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd, plan_type, seq, to_site , item_id,from_yyyymmdd) , 1) as int) as boh */
          IF P_DIVISION_ID <>  '40' /* MEASURE ='BALANCE' */
          THEN
              INSERT INTO GT_SASF_FG
                      (
                        DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,PROJECT_CODE
                        ,ITEM_ID
                        ,TO_SITE
                        ,INCOTERMS
                        ,FROM_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        /* ,ORIGIN_FROM_DIVISION_ID */
                        /* ,ORIGIN_TO_DIVISION_ID */
                        /* ,ELECTRODE_TYPE */
                        ,QTY
                        )
                SELECT
                              Y.DIVISION_ID
                              ,Y.PLAN_START_YYYYMMDD
                              ,Y.PLAN_TYPE
                              ,Y.SEQ
                              ,Y.OPERATION_GROUP
                              ,Y.PROJECT_CODE
                              ,Y.ITEM_ID
                              ,Y.TO_SITE
                              ,Y.INCOTERMS
                              ,'-' AS FROM_SITE
                              ,'-' AS BOD_ID
                              ,'WH_IN_BALANCE' AS MEASURE
                              ,Y.YYYYMMDD
                              /* ,Y.ORIGIN_FROM_DIVISION_ID */
                              /* ,Y.ORIGIN_TO_DIVISION_ID */
                              /* ,Y.ELECTRODE_TYPE */
                              ,( SELECT
                                      NVL( SUM(CASE MEASURE WHEN 'MKT_FCST'  THEN -1 * NVL(QTY,0)
                                                                WHEN 'WH_IN'    THEN      NVL(QTY,0)
                                                        ELSE 0.0
                                            END),0)
                                  FROM GT_SASF_FG X
                                WHERE 1=1
                                  AND X.DIVISION_ID          = Y.DIVISION_ID
                                  AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD
                                  AND X.PLAN_TYPE            = Y.PLAN_TYPE
                                  AND X.SEQ                  = Y.SEQ
                                  AND X.PROJECT_CODE         = Y.PROJECT_CODE
                                  AND X.ITEM_ID              = Y.ITEM_ID
                                  AND X.TO_SITE              = Y.TO_SITE
                                  AND X.INCOTERMS            = Y.INCOTERMS
                                  AND X.MEASURE              IN ('MKT_FCST','WH_IN')
                                  /* AND X.ORIGIN_FROM_DIVISION_ID   = Y.ORIGIN_FROM_DIVISION_ID */
                                  /* AND X.ORIGIN_TO_DIVISION_ID     = Y.ORIGIN_TO_DIVISION_ID */
                                  /* AND X.ELECTRODE_TYPE            = Y.ELECTRODE_TYPE */
                                  AND X.YYYYMMDD             <= Y.YYYYMMDD
                                )  + NVL(BOH.PSI_BOH_QTY,0) AS PSI_BOH_QTY
                          FROM GT_SASF_Y Y
                             , GT_SASF_BOH BOH

                        WHERE 1=1
                          AND Y.DIVISION_ID          = BOH.DIVISION_ID(+)
                          AND Y.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD(+)
                          AND Y.PLAN_TYPE            = BOH.PLAN_TYPE(+)
                          AND Y.SEQ                  = BOH.SEQ(+)
                          AND Y.TO_SITE              = BOH.SITE_ID(+)
                          AND Y.ITEM_ID              = BOH.ITEM_ID(+)
                        AND Y.YYYYMMDD   < TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD') /* 8주(56일) 추가 */
                        ;
          END IF;
           /*----------------------------------------------------------------------------------------------------------- */
            /* 10. MKT_FCST ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE UPDATE */
            /*----------------------------------------------------------------------------------------------------------- */

             UPDATE GT_SASF_FG X
               SET X.ORIGIN_FROM_DIVISION_ID =
                   ( SELECT MAX(Y.DIVISION_ID)
                       FROM SCM_MST_SITE Y /* from   PLANT_SITE_ID */
                      WHERE 0 = 0
/* AND Y.SITE_TYPE   = 'PLANT' */
                        AND (CASE WHEN X.DIVISION_ID = 'EE' THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN '0' ELSE Y.DIVISION_ID END )
                        AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SITE,'-S','')
                        AND Y.VALID_YN ='Y' );

            UPDATE GT_SASF_FG X
               SET X.ORIGIN_TO_DIVISION_ID =
                   ( SELECT MAX(Y.DIVISION_ID)
                       FROM SCM_MST_SITE Y /* to   SALES_SITE_ID */
                      WHERE 0 = 0
/* AND Y.SITE_TYPE   = 'PLANT' */
                        AND (CASE WHEN X.DIVISION_ID = 'EE' THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN '0' ELSE Y.DIVISION_ID END )
                        AND Y.SCM_SITE_ID  = REPLACE(X.TO_SITE,'-S','')
                        AND Y.VALID_YN ='Y' );

            UPDATE GT_SASF_FG X
               SET ( X.ELECTRODE_TYPE, X.OPERATION_GROUP ) =
                   ( SELECT Y.ELECTRODE_TYPE, Y.OPERATION_GROUP
                       FROM SCP_MST_FINAL_ITEM_V Y
                      WHERE 0 = 0
                        AND X.ITEM_ID          = Y.ITEM_ID
                        AND ROWNUM = 1 )
             WHERE X.DIVISION_ID      = P_DIVISION_ID
               AND EXISTS ( SELECT 1
                              FROM SCP_MST_FINAL_ITEM_V Y2
                             WHERE X.ITEM_ID = Y2.ITEM_ID );
            V_ROWCOUNT := SQL%ROWCOUNT;

          /*----------------------------------------------------------------------------------------------------------- */
          /* 11. SSP_ANL_SHIPMENT_PLAN_FG 삭제 */
          /*----------------------------------------------------------------------------------------------------------- */
            /* DELETE FROM SSP_ANL_SHIPMENT_PLAN_FG */
            /* WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */
            /* 소형(40) 삭제시 속도 계선. */
            /* SELECT @@ROWCOUNT */
            /* 1000 [1043::PR::2][07:23] */
            /* 10000 [1043::PR::2][10:12] */
            /* 100000 [1043::PR::2][05:38] */
            WHILE V_ROWCOUNT > 0 /* 상단의 UPDATE문 @@ROWCOUNT */
            LOOP
              DELETE
              FROM SSP_ANL_SHIPMENT_PLAN_FG
              WHERE DIVISION_ID = P_DIVISION_ID AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD AND PLAN_TYPE = P_PLAN_TYPE AND SEQ = P_SEQ
                AND ROWNUM <= 10000;
              V_ROWCOUNT := SQL%ROWCOUNT;
            END LOOP;

           /*----------------------------------------------------------------------------------------------------------- */
          /* 12. SSP_ANL_SHIPMENT_PLAN_FG 입력 */
          /*----------------------------------------------------------------------------------------------------------- */
          INSERT INTO /* PR_SSP_ANL_SHIPMENT_PLAN_FG */
                      SSP_ANL_SHIPMENT_PLAN_FG
                     (
                        DIVISION_ID
                       ,PLAN_START_YYYYMMDD
                       ,PLAN_TYPE
                       ,SEQ
                       ,BIZ_TYPE /* OPERATION_GROUP */
                       ,PROJECT_CODE
                       ,ITEM_ID
                       ,TO_SITE
                       ,INCOTERMS
                       ,FROM_SITE
                       ,BOD_ID
/* ,TRANSPORT_MODE */
                       ,MEASURE
                       ,YYYYMMDD
                       ,ORIGIN_FROM_DIVISION_ID
                       ,ORIGIN_TO_DIVISION_ID
                       ,ELECTRODE_TYPE
                       ,QTY
                       ,CREATED_BY
                       ,CREATION_DATE
                       ,LAST_UPDATED_BY
                       ,LAST_UPDATE_DATE
                       )
                    SELECT
                           DIVISION_ID
                          ,PLAN_START_YYYYMMDD
                          ,PLAN_TYPE
                          ,SEQ
                          ,NVL(NULLIF(RTRIM(OPERATION_GROUP),''), '/')
                          ,SUBSTR(NVL(PROJECT_CODE, '-'), 1, 50)
                          ,SUBSTR(ITEM_ID, 1, 50)
                          ,SUBSTR(TO_SITE, 1, 30)
/* ,MAX(ISNULL(INCOTERMS, '-'))  AS INCOTERMS */
                          ,SUBSTR(NVL(INCOTERMS, '-'), 1, 10)  AS INCOTERMS
                          ,SUBSTR(NVL(FROM_SITE, '-'), 1, 30)
                          ,NVL(BOD_ID,'-')
/* ,TRANSPORT_MODE */
                          ,MEASURE
                          ,YYYYMMDD
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,SUM(QTY) AS QTY
                          ,V_BATCH_USER AS CREATED_BY
                          ,SYSDATE       AS CREATION_DATE
                          ,V_BATCH_USER AS LAST_UPDATED_BY
                          ,SYSDATE       AS LAST_UPDATED_BY
                      FROM GT_SASF_FG
                     WHERE 1=1
                     AND YYYYMMDD < TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 56, 'YYYYMMDD') /* 8주(56일) 추가 */
                     GROUP BY DIVISION_ID
                          ,PLAN_START_YYYYMMDD
                          ,PLAN_TYPE
                          ,SEQ
                          ,NVL(NULLIF(RTRIM(OPERATION_GROUP),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */ /* GROUP BY 는 위 SELECT 적재식과 동일해야 함(ORA-00979 방지) */
                          ,NVL(PROJECT_CODE, '-') /* GROUP BY 는 위 SELECT 적재식과 동일해야 함(ORA-00979 방지 / PK 중복 ORA-00001 방지) */
                          ,ITEM_ID
                          ,TO_SITE
                          ,NVL(INCOTERMS, '-')
                          ,NVL(FROM_SITE, '-') /* GROUP BY 는 위 SELECT 적재식과 동일해야 함(ORA-00979 방지 / PK 중복 ORA-00001 방지) */
                          ,NVL(BOD_ID,'-')
                          ,MEASURE
                          ,YYYYMMDD
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ;

        /*--------------------------------------------------------- */
        /* 실행 Logic END -- */
        /*--------------------------------------------------------- */
        /* IF @@TRANCOUNT > 0 */
        /* BEGIN */
        /* COMMIT TRAN TX_FG; */
        /* END; */


        /* TXN LOG */
        V_LOG_TYPE := 'TXN';
        N_LOG_COUNT := 1; /* 원본 @@ROWCOUNT : 직전 스칼라 SET(@v_log_type) 이후라 항상 1 */
        V_LOG_MESSAGE := 'INSERT INTO '||V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE := SYSDATE;

        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER
                            );

    EXCEPTION
      WHEN OTHERS THEN
      /* IF @@TRANCOUNT > 0 */
      /* BEGIN */
      /* ROLLBACK TRAN TX_FG */
      /* END; */

      /* ERROR LOG (하위단계 proc·무TRAN → 롤백/RAISE 신설 없음, 원본 CATCH 흡수형 return -1) */
        V_ERR_MSG := SQLERRM;
        V_LOG_TYPE := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(V_ERR_MSG, 1, 1000);
        V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
        D_EVENT_DATE := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER
                            );
/* PRINT @@ERROR */
        RETURN;
    END;

/* 임시 운영반영시에 주석처리 할것. */
    V_TOTAL_SEC := TRUNC((SYSDATE - V_START_TIME) * 86400);
    V_MIN := TRUNC(V_TOTAL_SEC / 60);
    V_SEC := MOD(V_TOTAL_SEC, 60);

    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(V_MIN)) > 2 OR LENGTH(TO_CHAR(V_SEC)) > 2
                        THEN NULL
                        ELSE LPAD(TO_CHAR(V_MIN), 2, '0') || ':' || LPAD(TO_CHAR(V_SEC), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    /* 원본 '[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']' : + NULL 전파 재현(CASE 가드) */
    V_DESCRIPTION := CASE WHEN P_MASTER_ID IS NULL OR P_ENGINE_PLAN_ID IS NULL OR V_EXEC_TIME IS NULL
                          THEN NULL
                          ELSE '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']'
                     END;
    D_EVENT_DATE :=  SYSDATE  ;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER
                        );
    RETURN;

  END;