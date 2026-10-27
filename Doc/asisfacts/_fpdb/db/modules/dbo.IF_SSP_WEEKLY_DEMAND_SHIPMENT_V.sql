





CREATE VIEW [dbo].[IF_SSP_WEEKLY_DEMAND_SHIPMENT_V]
-- ================================================================================================
-- Program ID          : IF_SSP_WEEKLY_DEMAND_SHIPMENT_V
--
-- Program Name        : IF_SSP_WEEKLY_DEMAND_SHIPMENT_V
-- Param               :
-- Batch Period        : 
-- Description         : SSP의 최종 출하 계획 조회
--
-- Source System       : SCP SDB
-- Destination System  : FP SDB
-- Source Table        : [dbo].[SSP_ANL_SHIP_PLAN_FP_V]
-- Destination Table   : 
--
-- Create(Update) Date : 2022.09.21
-- Author              : kimcd
-- Version             : 2022-09-21	kimcd 출하 계획 전송하는 기준으로 현재 SSP 출하 계획 조회
-- ================================================================================================
AS
SELECT  A.COMPANY_ID,
		A.DIVISION_ID,
		A.SITE_ID,
		A.PLANT_ID,
		A.SHOP_GROUP_ID,
		A.ITEM_ID,
		A.TO_SITE_ID,
		A.TO_PLANT_ID,
		MAX(A.CUSTOMER_ID) AS CUSTOMER_ID,
		A.SHIP_DATE,
		MAX(A.SHIP_WEEK) AS SHIP_WEEK,
		SUM(A.SHIP_QTY) AS SHIP_QTY,
		A.PRODUCTION_TYPE,
		A.TRANSPORT_MODE,
		NULL AS BIZ_TYPE,
		NULL AS CONFIRM_TYPE,
		A.MARKET,
		MAX(A.SHIP_TO_PARTY) AS SHIP_TO_PARTY,
		MAX(A.RECEIVE_YYYYMMDD) AS RECEIVE_YYYYMMDD,
		MAX(A.SHIP_TO_CODE)     AS SHIP_TO_CODE
FROM  ( SELECT   A.COMPANY_ID
				,A.DIVISION_ID
				,P.SITE_ID
				,A.PLANT_ID
				,A.OPERATION_GROUP							 AS SHOP_GROUP_ID
				,ITEM_ID
				,ISNULL(( SELECT TOP 1 P.SITE_ID                                                                                                                        
							FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                             
							WHERE A.DEST_PLANT_ID = P.PLANT_ID		), A.DEST_SITE_CODE		) AS TO_SITE_ID
				,ISNULL(A.DEST_PLANT_ID, A.PLANT_ID)			 AS TO_PLANT_ID
				,CUSTOMER_CODE								 AS CUSTOMER_ID
				,EXFACTORY_YYYYMMDD							 AS SHIP_DATE
				,( SELECT TOP 1 [ISO_YYYYWW]
					FROM [DBO].[TH_UIS_CAL] WITH(NOLOCK)
					WHERE [YYYYMMDD] = A.EXFACTORY_YYYYMMDD)	 AS SHIP_WEEK
				,EXFACTORY_QTY AS SHIP_QTY
				,C.ATTRIBUTE2								 AS PRODUCTION_TYPE
				,TRANSPORT_MODE
				,CASE WHEN P.SITE_ID = 'A002'  THEN
						ISNULL( ( SELECT TOP 1 M.DEFAULT_MARKET 
									FROM SCM_MODEL_MARKET_M M WITH(NOLOCK)
									WHERE M.COMPANY_ID  = P.COMPANY_ID
									AND M.DIVISION_ID = P.DIVISION_ID
									AND M.SITE_ID     = P.SITE_ID                                                                                                                        
									AND M.ITEM_ID = A.ITEM_ID
									AND M.PRODUCTION_TYPE = C.ATTRIBUTE2		--2018-09-17 PIYONG 조건 추가
									AND ISNULL(M.ACTIVE_FLAG,'N') = 'Y'
								),  'E' --CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END	-- 2018-10-10 PIYONG  CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END -> 'E'
								)
				 ELSE
					 CASE WHEN A.MARKET = '-' THEN 'D' ELSE A.MARKET END
				 END	 								 AS MARKET
				,SHIP_TO_PARTY															--2018-08-02 PIYONG ADD
				,RECEIVE_YYYYMMDD														--2018-08-02 PIYONG ADD
				,SHIP_TO_CODE                                                           --2018-08-21 KIMCD 도착지 코드 ADD
			FROM [LGCE_SCMDEV].[dbo].[SSP_ANL_SHIP_PLAN_FP_V] A
				,(SELECT *
					FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
					WHERE W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
					AND ACTIVE_FLAG = 'Y') C
				,[SCM_PLANT_M] P
			WHERE A.EXFACTORY_QTY   > 0
			AND A.OPERATION_GROUP != 'E'
			AND A.ORDER_TYPE		 = C.SEGMENT1
			AND A.PLANT_ID		 = C.SEGMENT2		--2018-08-01 PIYONG
			AND A.PLANT_ID		 = P.PLANT_ID	
			-- 2018-06-28 kimcd 공급,수요가 같은 법인인 경우 정보 제외 끝
			AND NOT EXISTS ( SELECT  1
							 FROM	SCM_PLANT_M P WITH(NOLOCK),
									SCM_PLANT_M C WITH(NOLOCK)
							 WHERE  P.PLANT_ID = A.PLANT_ID
							 AND    C.PLANT_ID = A.DEST_PLANT_ID
							 AND    P.COMPANY_ID = C.COMPANY_ID)
			-- 2018-06-28 kimcd 공급,수요가 같은 법인인 경우 정보 제외 끝
		) A 
	GROUP BY A.COMPANY_ID,
		A.DIVISION_ID,
		A.SITE_ID,
		A.PLANT_ID,
		A.SHOP_GROUP_ID,
		A.ITEM_ID,
		A.TO_SITE_ID,
		A.TO_PLANT_ID,
		A.SHIP_DATE,
		A.PRODUCTION_TYPE,
		A.TRANSPORT_MODE,
		A.MARKET
