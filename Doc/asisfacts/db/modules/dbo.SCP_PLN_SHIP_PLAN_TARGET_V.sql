




CREATE VIEW [dbo].[SCP_PLN_SHIP_PLAN_TARGET_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_SHIP_PLAN_TARGET_V
  * DESCRIPTION   : FP용 SHIP TARGET VIEW
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-03-28   YYDOK        INITIAL
  * 2018-05-02   YYDOK        주초월요일 날짜 가져오는 부분을 수정
  * 2018-07-02   YYDOK        소형 packer에 대하여 item id 12번째자리를 packer site의 suffix정보로 변경처리로직반영
  *                           EE 사업부인 경우,셀계획 제외처리,ORIGIN_DIVISION_ID
  * 2018-07-26   YYDOK        SHIP_TO_PARTY, RECEIVE_YYYYMMDD 추가반영
  * 2018-08-15   YYDOK        EE에 대해서,SHIP_ID,DEST_PLANT_ID,DESTINATION_SITE_TYPE,CUSTOMER누락조치(DIVISION_ID -> ORIGIN FROM/TO DIVISION ID)  
  * 2018.8.20    YYDOK        SHIP TO CODE 추가
  * 2020.09.14   KSG          C20200911-000156 법인간 거래 Incoterms에 의한 SCP_PLN_SHIP_PLAN_TARGET_V 변경 건
  *                              RECEIVE_YYYYMMDD_SSP 추가
  * 2021.04.23   KSG          C20210422-000470 개별 이동 계획 Project Code 추가를 위한, Veiw 수정 요청건
  * 2021.07.09   sclee         [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) : SCP_MST_BOD_V에서 SCP_MST_BOD_N_V로 변경
  * 2022-03-23   KSG          PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 가상 Division
  * 2023-04-04   HRK		  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
  ****************************************************************************/
  SELECT  P.DIVISION_ID
        , P.PLAN_START_YYYYMMDD
        , P.PLAN_TYPE
        , P.SEQ
        , P.DIVISION_ID + '^' +P.ITEM_ID + '^' + P.FROM_SITE + '^' + P.TO_SITE+ '^' +P.YYYYMMDD+ '^' + ISNULL(P.TRANSPORT_MODE,'')
           + '^' +  ( CASE PP.FCST_TYPE WHEN '-' THEN 'MPS' ELSE PP.FCST_TYPE END ) + '^' + ( CASE PP.DOM_EXP WHEN '-' THEN 'D' ELSE PP.DOM_EXP END ) 
           + '^' +  ISNULL(PP.PROJECT_CODE, '-')   -- 20210423 C20210422-000470 추가
                                             AS SHIP_ID
     --   , (CASE WHEN ( P.DIVISION_ID='40' AND P.OPERATION_GROUP ='P' ) THEN [dbo].[FN_GET_MOBILE_PACKER_ITEM_ID]( P.DIVISION_ID, P.FROM_SITE,P.ITEM_ID )
     --           ELSE  P.ITEM_ID
     --     END )                              AS ITEM_ID
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

        -- 20200914 C20200911-000156 RECEIVE_YYYYMMDD_SSP 추가
        , CASE WHEN BOD.LT_TOTAL_SSP IS NULL THEN MAX(CONVERT(VARCHAR,P.END_TIME,112))
               ELSE MAX(CONVERT(VARCHAR, DATEADD(DD, BOD.LT_TOTAL_SSP, P.START_TIME), 112)) 		
          END AS RECEIVE_YYYYMMDD_SSP
	   
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
        , ISNULL(PP.PROJECT_CODE, '-')       AS PROJECT_CODE -- 20210423 C20210422-000470 추가
     FROM dbo.SCP_PLN_SHIPMENT_PLAN p  WITH(NOLOCK)
		  INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK) -- PJ20230691R HM JV 가상 사업부 추가 대응
				  ON D.DIVISION_ID = P.DIVISION_ID
				 AND D.VALID_YN	   = 'Y'
     LEFT JOIN dbo.SCP_PLN_SHIPMENT_PLAN_PEGGING PP  WITH(NOLOCK)
            ON P.DIVISION_ID           = PP.DIVISION_ID
           AND P.PLAN_START_YYYYMMDD   = PP.PLAN_START_YYYYMMDD
           AND P.PLAN_TYPE             = PP.PLAN_TYPE
           AND P.SEQ                   = PP.SEQ
           AND P.ORDER_ID              = PP.ORDER_ID		   
     -- 20200914 C20200911-000156 RECEIVE_YYYYMMDD_SSP 추가
     LEFT JOIN SCP_MST_BOD_N_V BOD  WITH(NOLOCK) -- 20210709 PJ20209643 SCP_MST_BOD_V 에서 SCP_MST_BOD_N_V로 변경
            ON P.ORIGIN_FROM_DIVISION_ID    = BOD.DIVISION_ID
           AND P.BOD_ID                     = BOD.BOD_ID
           AND BOD.BOD_VALID_YN             = 'Y'
    WHERE 1=1
	  AND (D.ATTRIBUTE3 != 'EE'									-- PJ20230691R HM JV 가상 사업부 추가 대응
   			OR 
   		   (D.ATTRIBUTE3  = 'EE' AND P.OPERATION_GROUP = 'E')	-- PJ20230691R HM JV 가상 사업부 추가 대응
		   )  
      AND P.MEASURE                  = 'SHIP_PLAN'
      AND P.FROM_SITE <> P.TO_SITE

        --AND ( ( P.DIVISION_ID <> 'EE' ) OR ( P.DIVISION_ID = 'EE' AND P.OPERATION_GROUP <> 'A' )) 
        -- HM JV 대응 AND ( ( P.DIVISION_ID IN ('81','82','40','81_UC') )                    -- 20220323 PJ20216891 GM JV 추가
        -- HM JV 대응    OR ( P.DIVISION_ID IN ('EE', 'EE_UC') AND P.OPERATION_GROUP = 'E' ) -- 20220323 PJ20216891 GM JV 추가
        -- HM JV 대응     ) 
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
        , BOD.LT_TOTAL_SSP -- 20200914 C20200911-000156 RECEIVE_YYYYMMDD_SSP 추가
        , ISNULL(PP.PROJECT_CODE, '-')  -- 20210423 C20210422-000470 추가
    HAVING ROUND(SUM(PP.ALLOCATION_QTY),0)>= 1
      ;

