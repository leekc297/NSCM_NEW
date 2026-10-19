







CREATE VIEW [dbo].[SSP_PLN_SHIP_PLAN_TARGET_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SSP_PLN_SHIP_PLAN_TARGET_V
  * DESCRIPTION   : FP용 SHIP TARGET VIEW(SSP)
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-05-11   YYDOK        INITIAL
  * 2018-07-02   YYDOK        소형 packer에 대하여 item id 12번째자리를 packer site의 suffix정보로 변경처리로직반영
  *                           EE 사업부인 경우,셀계획 제외처리,ORIGIN_DIVISION_ID 
  * 2018-07-26   YYDOK        SHIP_TO_PARTY, RECEIVE_YYYYMMDD 추가반영
  * 2018-08-15   YYDOK        EE에 대해서,SHIP_ID,DEST_PLANT_ID,DESTINATION_SITE_TYPE,CUSTOMER누락조치(DIVISION_ID -> ORIGIN FROM/TO DIVISION ID)
  * 2018.8.20    YYDOK        SHIP TO CODE 추가  
  ****************************************************************************/
  SELECT  P.DIVISION_ID
        , P.PLAN_START_YYYYMMDD
        , P.PLAN_TYPE
        , P.SEQ
        , P.DIVISION_ID + '^' +P.ITEM_ID + '^' + P.FROM_SITE + '^' + P.TO_SITE+ '^' +P.YYYYMMDD+ '^' + ISNULL(P.TRANSPORT_MODE,'')
           + '^' +  ( CASE PP.FCST_TYPE WHEN '-' THEN 'MPS' ELSE PP.FCST_TYPE END ) + '^' + ( CASE PP.DOM_EXP WHEN '-' THEN 'D' ELSE PP.DOM_EXP END ) 
                                             AS SHIP_ID
       -- , (CASE WHEN ( P.DIVISION_ID='40' AND P.OPERATION_GROUP ='P' ) THEN [dbo].[FN_GET_MOBILE_PACKER_ITEM_ID]( P.DIVISION_ID, P.FROM_SITE,P.ITEM_ID )
       --         ELSE  P.ITEM_ID
       --   END )                              AS ITEM_ID
        , P.ITEM_ID                          AS ITEM_ID
        , P.OPERATION_GROUP                  AS OPERATION_GROUP
        , P.FROM_SITE                        AS FROM_SITE
        , ( SELECT TOP 1 PLANT_ID 
              FROM SCM_MST_SITE WITH(NOLOCK)
             WHERE DIVISION_ID = P.ORIGIN_FROM_DIVISION_ID
               AND SCM_SITE_ID = P.FROM_SITE ) AS PLANT_ID
        , [dbo].[FN_GET_SITE_CUSTOMER_INFO] (P.ORIGIN_FROM_DIVISION_ID,P.TO_SITE,'SOLDTO_CODE')
                                             AS CUSTOMER_CODE
        ,[dbo].[FN_GET_SITE_CUSTOMER_INFO]  (P.ORIGIN_FROM_DIVISION_ID,P.TO_SITE,'SOLDTO_DESCRIPTION')
                                             AS CUSTOMER_NAME
        , [dbo].[FN_GET_SITE_CUSTOMER_INFO] (P.ORIGIN_FROM_DIVISION_ID,P.TO_SITE,'SHIPTO_CODE')
                                             AS SHIP_TO_CODE                                             
        ,[dbo].[FN_GET_SITE_CUSTOMER_INFO]  (P.ORIGIN_FROM_DIVISION_ID,P.TO_SITE,'SHIPTO_DESCRIPTION')
                                             AS SHIP_TO_PARTY
        , P.TO_SITE                          AS TO_SITE
        , ( SELECT TOP 1 PLANT_ID 
              FROM SCM_MST_SITE WITH(NOLOCK)
             WHERE DIVISION_ID = P.ORIGIN_TO_DIVISION_ID
               AND SCM_SITE_ID = P.TO_SITE ) AS TO_PLANT_ID
        , ( SELECT TOP 1 SITE_TYPE 
              FROM SCM_MST_SITE WITH(NOLOCK)
             WHERE DIVISION_ID = P.ORIGIN_TO_DIVISION_ID
               AND SCM_SITE_ID = P.TO_SITE ) AS TO_SITE_TYPE
        , ( SELECT basis_yyyymmdd
              FROM scm_sys_calendar_m cm WITH(NOLOCK)
             WHERE iso_yyyyww IN (SELECT iso_yyyyww
                                    FROM scm_sys_calendar_m WITH(NOLOCK)
                                   WHERE basis_yyyymmdd = P.YYYYMMDD )
               AND dayofweek = 'MON'             
           )                                 AS SHIP_WEEK
        , P.YYYYMMDD                         AS SHIP_YYYYMMDD
        , MAX(CONVERT(VARCHAR,P.END_TIME,112))    AS RECEIVE_YYYYMMDD
        , ROUND(SUM(PP.ALLOCATION_QTY),0)    AS SHIP_QTY
      --  , PP.FCST_TYPE                       AS FCST_TYPE
        , ( CASE PP.FCST_TYPE WHEN '-' THEN 'MPS'
                ELSE PP.FCST_TYPE
            END )                            AS FCST_TYPE   
        , P.TRANSPORT_MODE                   AS TRANSPORT_MODE
        , MAX(PP.ENG_DEMAND_PRIORITY)        AS PRIORITY
      --  , PP.DOM_EXP                         AS DOM_EXP
        , ( CASE PP.DOM_EXP WHEN '-' THEN 'D'
                ELSE PP.DOM_EXP
            END )                            AS DOM_EXP   
        , P.ORIGIN_FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID
        , P.ORIGIN_TO_DIVISION_ID            AS ORIGIN_TO_DIVISION_ID                    
        , 'SCP'                              AS CREATE_USER_ID
        , GETDATE()                          AS CREATE_DATE
        , 'SCP'                              AS MODIFY_USER_ID
        , GETDATE()                          AS MODIFY_DATE
     FROM dbo.SSP_PLN_SHIPMENT_PLAN p  WITH(NOLOCK)
     LEFT JOIN dbo.SSP_PLN_SHIPMENT_PLAN_PEGGING PP  WITH(NOLOCK)
            ON P.DIVISION_ID           = PP.DIVISION_ID
           AND P.PLAN_START_YYYYMMDD   = PP.PLAN_START_YYYYMMDD
           AND P.PLAN_TYPE             = PP.PLAN_TYPE
           AND P.SEQ                   = PP.SEQ
           AND P.ORDER_ID              = PP.ORDER_ID
    WHERE 1=1
      AND P.MEASURE                  = 'SHIP_PLAN'
   --   AND P.DIVISION_ID              = '81'
   --   AND P.PLAN_START_YYYYMMDD      = '20180326'
   --   AND P.PLAN_TYPE                = 'PR'
   --   AND P.SEQ                      = 1   
        AND ( ( P.DIVISION_ID <> 'EE' ) OR ( P.DIVISION_ID = 'EE' AND P.OPERATION_GROUP <> 'A' ))    
    GROUP BY
          P.DIVISION_ID
        , P.PLAN_START_YYYYMMDD
        , P.PLAN_TYPE
        , P.SEQ
        , P.ITEM_ID
        , P.OPERATION_GROUP          
        , P.FROM_SITE                                        
        , P.TO_SITE         
        , P.YYYYMMDD       
        , PP.FCST_TYPE       
        , P.TRANSPORT_MODE   
        , PP.DOM_EXP 
        , P.ORIGIN_FROM_DIVISION_ID
        , P.ORIGIN_TO_DIVISION_ID        
    HAVING ROUND(SUM(PP.ALLOCATION_QTY),0)>= 1               
      ;







