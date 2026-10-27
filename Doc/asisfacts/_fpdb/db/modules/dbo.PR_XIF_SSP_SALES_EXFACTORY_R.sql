
CREATE PROCEDURE [dbo].[PR_XIF_SSP_SALES_EXFACTORY_R]

-- ================================================================================================
-- Program ID          : FP00550
-- Program Name        : SY_XIF_SSP_SALES_EXFACTORY_R
-- Param               :
-- Batch Period        : 15 MINUTE
-- Description         :
--
-- Source System       : SCP
-- Destination System  : FP SDB
-- Source Table        : XIF_SSP_SALES_EXFACTORY_R
-- Destination Table   : FP_WEEKLY_DEMAND_SHIPMENT_H, FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H
--
-- Create Date		   : 2018.05.11
-- Update Date		   : 2018.06.28
--						 2018.07.23 1.2 PIYONG
--						 2018.08.02 1.3 PIYONG
--						 2018.08.16 1.4 PIYONG
--                       2018.08.21 1.5 KIMCD
--						 2018.09.17 1.6 PIYONG
--						 2018.10.11 1.7 PIYONG 
--						 2019.10.11 1.8 PIYONG
--						 2020.07.14 1.9 CYS
--                       2020.09.28 1.91 KIMCD
--                       2022.03.30 1.92 kimcd

-- Author              : PIYONG
-- Version             : 1.0
--                       2018-06-28 kimcd from to company가 동일한 경우 제외(동일 법인내 거래 제외)
--						 1.2 DIVISION 별 메일 발송
--						 1.3 PLANT 별 DEMAND_TYPE_MAPPING
--							 도착예정일, 도착지 컬럼 추가
--						 1.4 DIVISION EE(전극) 처리 로직 추가
--                       1.5 2018-08-21 KIMCD 도착지 코드(ship_to_code) 컬럼 추가
--						 1.6 CNA PRODUCTION_TYPE 조회 조건 추가
--						 1.7 A002 MARKET 값이 없을 경우 조건없이 'E' (CASE ->  'E')
--						 1.8 SSP 전송 기준을 PLANT로 변경
--						 1.9 2020-07-14 CVS 전극 Shipment Table 변경
--                       1.91 2020-09-28 kimcd 1시간 단위 주기 수신에서 시업 시간 기준 정보 수신 조건 추가
--                       1.92 2022-03-30 kimcd JV용 가상 Division 로직 추가
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SSP_SALES_EXFACTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER
	DECLARE @ROWCOUNT_E  INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @CNT_CHK	NUMERIC(10,0)	= 0
	DECLARE @PLAN_ID	NVARCHAR(50)
	DECLARE @DIVISION	NVARCHAR(50)
	DECLARE @DIVISION_NAME		NVARCHAR(150)			-- 2018-07-18 PIYONG ADD
	DECLARE @PLANT_ID			NVARCHAR(30)			-- 2019-10-10 PIYONG ADD
	DECLARE @SHOP_GROUP         NVARCHAR(50)            -- 2022-03-30 kimcd 공정 군 추가
	
	DECLARE @TEMP_DIVISION		TABLE (					-- 2019-10-10 PIYONG ADD
										DIVISION   NVARCHAR(30),
										SHOP_GROUP NVARCHAR(50)  -- 2022-03-30 kimcd 공정 군 추가
									  )
	DECLARE @yester_day NVARCHAR(8)  = CONVERT(NVARCHAR(8),DATEADD(D,-1,GETDATE()),112)  -- 2020-09-28 kimcd 기준일 어제 추가
	DECLARE @to_day     NVARCHAR(8)  = CONVERT(NVARCHAR(8),GETDATE(),112)                -- 2020-09-28 kimcd 기준일 오늘 추가
	DECLARE @key_day    NVARCHAR(10) = CONVERT(NVARCHAR(10),GETDATE(),120)               -- 2020-09-28 kimcd 기준일 오늘 추가
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN

		-- ================================================
		-- 로직 추가 start
		-- ================================================
		
		DECLARE @PROC_FLAG_CHK    NUMERIC(10,0)

		SET @PROC_FLAG_CHK = (
								SELECT COUNT(PROC_FLAG)
								  FROM [dbo].[SY_XIF_SSP_SALES_EXFACTORY_R]
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
							)

		IF @PROC_FLAG_CHK > 0

			BEGIN
				DECLARE CUR_DIVISION CURSOR FOR
					SELECT DIVISION, PLAN_ID, PLANT_ID, SHOP_GROUP_ID
					FROM  (
								SELECT DIVISION
										, MAX(PLAN_ID) AS PLAN_ID
										, PLANT_ID								-- 2019-10-10 PIYONG ADD
										, MAX(OPERATION_GROUP) AS SHOP_GROUP_ID -- 2022-03-30 kimcd 공정 군 추가
								  FROM [dbo].[SY_XIF_SSP_SALES_EXFACTORY_R]
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
								 GROUP BY DIVISION, PLANT_ID
							 ) A
					 ORDER BY DIVISION, PLANT_ID -- ORDER BY 를 GROUP BY 후 로 넘김 1.9 ver CHANGE
				
				OPEN CUR_DIVISION
				FETCH NEXT FROM CUR_DIVISION INTO @DIVISION
												, @PLAN_ID
												, @PLANT_ID								-- 2019-10-10 PIYONG ADD
												, @SHOP_GROUP       -- 2022-03-30 kimcd 공정 군 추가

				WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
					BEGIN
/*
						-------------------------------------------------------------------------------------------------
						--2019-10-11 PIYONG DEL
						SET @CNT_CHK = (
										SELECT COUNT(1) -- 값이 0 보다 크면 수행을 하면 안됨.
										  FROM (
												SELECT (
														SELECT COUNT(1)
														  FROM [dbo].[SY_XIF_SSP_SALES_EXFACTORY_R] A
														 WHERE A.PLAN_ID		  = @PLAN_ID
														   AND A.DIVISION		  = @DIVISION
														   AND ISNULL(A.PROC_FLAG,'N') = 'N'
														   AND A.DIVISION         = W.SEGMENT1
														   AND A.OPERATION_GROUP  = W.SEGMENT2
														   AND A.PLANT_ID		  = W.SEGMENT4
														) COUNTS
														,W.SEGMENT1
												   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
												  WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
													AND ATTRIBUTE4 = 'Y'
													AND ACTIVE_FLAG = 'Y'
												) X
										  WHERE COUNTS = 0
											AND SEGMENT1 IN (
															  SELECT DISTINCT DIVISION
																FROM [dbo].[SY_XIF_SSP_SALES_EXFACTORY_R] A
															   WHERE A.PLAN_ID		   = @PLAN_ID
																 AND A.DIVISION        = @DIVISION
																 AND A.PLANT_ID		   = @PLANT_ID
																 AND ISNULL(A.PROC_FLAG,'N') = 'N'
															)
								)


						IF @CNT_CHK = 0
							BEGIN


						--2019-10-11 PIYONG DEL
						-------------------------------------------------------------------------------------------------

*/ 
						-- SSP Target수신 정보를 SDB로 적재
						INSERT INTO [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_H]	-- 2020-07-14 CVS  [FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] 전극 관련 table 변경 1.9 ver CHANGE
						(
							COMPANY_ID
							,DIVISION_ID
							,SITE_ID
							,PLANT_ID
							,SHOP_GROUP_ID
							,SCP_PLAN_ID
							,SCP_TARGET_ID
							,FP_TARGET_ID
							,ITEM_ID
							,TO_SITE_ID
							,TO_PLANT_ID
							,CUSTOMER_ID
							,SHIP_DATE
							,SHIP_WEEK
							,SHIP_QTY
							,PRODUCTION_TYPE
							,TRANSPORT_MODE	
							,BIZ_TYPE					
							,CONFIRM_TYPE			
							,MARKET
							--,CELL_MODEL 2020-07-14 CVS 제거
							,SHIP_TO_PARTY		--2018-08-02 PIYONG ADD
							,RECEIVE_YYYYMMDD	--2018-08-02 PIYONG ADD
							,SHIP_TO_CODE       --2018-08-21 KIMCD 도착지 코드 ADD
							,FACTORY_ID 	-- 2020-07-14 CVS 추가된 컬럼 1.9 ver CHANGE
							,POST_OPER 		-- 2020-07-14 CVS 추가된 컬럼 1.9 ver CHANGE
							,REMARKS 		-- 2020-07-14 CVS 추가된 컬럼 1.9 ver CHANGE
							,INSERT_ID
							,INSERT_TIME
							,UPDATE_ID
							,UPDATE_TIME
						)
						SELECT A.COMPANY_ID,
							   A.DIVISION_ID,
							   A.SITE_ID,
							   A.PLANT_ID,
							   A.SHOP_GROUP_ID,
							   A.SCP_PLAN_ID,
							   A.SCP_TARGET_ID,
							   A.FP_TARGET_ID,
							   MAX(A.ITEM_ID) AS ITEM_ID,
							   MAX(A.TO_SITE_ID) AS TO_SITE_ID,
							   MAX(A.TO_PLANT_ID) AS TO_PLANT_ID,
							   MAX(A.CUSTOMER_ID) AS CUSTOMER_ID,
							   A.SHIP_DATE      AS SHIP_DATE, --2018-08-21 KIMCD group by에 포함
							   MAX(A.SHIP_WEEK) AS SHIP_WEEK,
							   SUM(A.SHIP_QTY) AS SHIP_QTY,
							   MAX(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE,
							   MAX(A.TRANSPORT_MODE) AS TRANSPORT_MODE,
							   NULL AS BIZ_TYPE,
							   NULL AS CONFIRM_TYPE,
							   A.MARKET,
							   --'-', CELL_MODEL 2020-07-14 CVS 제거
							   MAX(A.SHIP_TO_PARTY) AS SHIP_TO_PARTY,				--2018-08-02 PIYONG ADD
							   MAX(A.RECEIVE_YYYYMMDD) AS RECEIVE_YYYYMMDD,			--2018-08-02 PIYONG ADD
							   MAX(A.SHIP_TO_CODE) AS SHIP_TO_CODE,                 --2018-08-21 KIMCD 도착지 코드 ADD
							   MAX(A.FACTORY_ID) AS FACTORY_ID, 	-- 2020-07-14 CVS 추가된 컬럼 1.9 ver CHANGE
							   MAX(A.POST_OPER) AS POST_OPER, 		-- 2020-07-14 CVS 추가된 컬럼 1.9 ver CHANGE
							   MAX(A.REMARKS) AS REMARKS, 			-- 2020-07-14 CVS 추가된 컬럼 1.9 ver CHANGE
							   'SY_XIF_SSP_SALES_EXFACTORY_R' AS INSERT_ID,
							   GETDATE() AS INSERT_TIME,
							   'SY_XIF_SSP_SALES_EXFACTORY_R' AS UPDATE_ID,
							   GETDATE() AS UPDATE_TIME
						  FROM (
								SELECT P.COMPANY_ID
									   ,B.SEGMENT3 AS DIVISION_ID					-- 2018-08-16 PIYONG CHANGE A.DIVISION -> B.SEGMENT3
									   ,P.SITE_ID
									   ,A.PLANT_ID
									   ,A.OPERATION_GROUP							 AS SHOP_GROUP_ID
									   ,@PLAN_ID AS SCP_PLAN_ID
									   ,SHIP_ID AS SCP_TARGET_ID
									   ,'-' AS FP_TARGET_ID
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
									   ,SHIP_METHOD AS TRANSPORT_MODE
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
											 END							 	     AS MARKET
									   ,SHIP_TO_PARTY					--2018-08-02 PIYONG ADD
									   ,RECEIVE_YYYYMMDD				--2018-08-02 PIYONG ADD
									   ,A.SHIP_TO_CODE                  --2018-08-21 KIMCD 도착지 코드 ADD
									   ,A.ATTR_03	AS FACTORY_ID 	    -- 2020-07-15 CVS 추가된 컬럼 1.9 ver CHANGE
									   ,A.ATTR_04	AS POST_OPER 		-- 2020-07-15 CVS 추가된 컬럼 1.9 ver CHANGE
									   ,A.ATTR_05	AS REMARKS 		    -- 2020-07-15 CVS 추가된 컬럼 1.9 ver CHANGE
								  FROM [dbo].[SY_XIF_SSP_SALES_EXFACTORY_R] A
									   ,(
											SELECT  W.SEGMENT4  PLANT
												   ,W.SEGMENT3  -- 2018-08-16 PIYONG ADD
												   ,W.SEGMENT2  OPERATION_GROUP
												   ,W.SEGMENT1  DIVISION
												   ,(SELECT CASE WHEN ( @key_day + ' ' + LEFT(X.SEGMENT2, 2) +':'+ SUBSTRING(X.SEGMENT2, 3, 2) +':00' )
												                      < CONVERT(NVARCHAR(20), [DBO].[FN_SITE_TIME] ( XP.SITE_ID ), 120)
															     THEN
																	 @to_day
																 ELSE @yester_day END  AS FROM_DATE
												     FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] X WITH(NOLOCK), SCM_PLANT_M   XP (NOLOCK)
													 WHERE  X.SEGMENT1         = XP.PLANT_ID
													 AND    X.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													 AND    X.SEGMENT1         = W.SEGMENT4
													 AND    X.ACTIVE_FLAG      = 'Y')   AS FROM_DATE -- 2020-09-28 kimcd 기준일자 추가  
											  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
											 WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
											   AND ATTRIBUTE4 = 'Y'   
									   ) B
									   ,(SELECT *
										  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
										 WHERE W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
										   AND ACTIVE_FLAG = 'Y') C
									   ,[SCM_PLANT_M] P
								 WHERE A.PLAN_ID		 = @PLAN_ID
								   AND A.DIVISION		 = @DIVISION
								   AND A.PLANT_ID		 = @PLANT_ID			--2019-10-10 PIYONG ADD
								   AND ISNULL(A.PROC_FLAG,'N') = 'N'
							   	   AND A.EXFACTORY_QTY   > 0
								   AND A.OPERATION_GROUP = 'E'
								   AND A.ITEM_ID LIKE 'APC%' -- 2022-03-30 kimcd 전극 공정 군에서는 전극만 정보 수신한다.
								  -- AND (  -- 2022-03-30 kimcd EE 외 다른 Division ID 들어올 수 있어서 조건 막음
										--A.DIVISION != 'EE'
										--OR (
										--	A.DIVISION = 'EE'  AND A.ITEM_ID LIKE 'APC%'
										--   )
									 --  ) -- 2018-08-16 PIYONG ADD
								   AND A.OPERATION_GROUP = B.OPERATION_GROUP 
								   AND A.PLANT_ID	     = B.PLANT 
								   AND A.DIVISION        = B.DIVISION
								   AND A.EXFACTORY_YYYYMMDD >= B.FROM_DATE  -- 2020-09-28 kimcd 기준일자 추가  
								   AND A.ORDER_TYPE		 = C.SEGMENT1
								   AND A.PLANT_ID		 = C.SEGMENT2			--2018-08-01 PIYONG
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
							   A.SCP_PLAN_ID,
							   A.SCP_TARGET_ID,
							   A.FP_TARGET_ID,
							   A.SHIP_DATE, --2018-08-21 KIMCD group by에 포함
							   A.MARKET
						;

						SET @ROWCOUNT_E = @@ROWCOUNT
					
						INSERT INTO [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_H]
						(
							COMPANY_ID
							,DIVISION_ID
							,SITE_ID
							,PLANT_ID
							,SHOP_GROUP_ID
							,SCP_PLAN_ID
							,SCP_TARGET_ID
							,FP_TARGET_ID
							,ITEM_ID
							,TO_SITE_ID
							,TO_PLANT_ID
							,CUSTOMER_ID
							,SHIP_DATE
							,SHIP_WEEK
							,SHIP_QTY
							,PRODUCTION_TYPE
							,TRANSPORT_MODE
							,BIZ_TYPE
							,CONFIRM_TYPE
							,MARKET
							,SHIP_TO_PARTY				--2018-08-02 PIYONG ADD
							,RECEIVE_YYYYMMDD			--2018-08-02 PIYONG ADD
							,SHIP_TO_CODE               --2018-08-21 KIMCD 도착지 코드 ADD
							,INSERT_ID
							,INSERT_TIME
							,UPDATE_ID
							,UPDATE_TIME
						)
						SELECT A.COMPANY_ID,
							   A.DIVISION_ID,
							   A.SITE_ID,
							   A.PLANT_ID,
							   A.SHOP_GROUP_ID,
							   A.SCP_PLAN_ID,
							   A.SCP_TARGET_ID,
							   A.FP_TARGET_ID,
							   MAX(A.ITEM_ID) AS ITEM_ID,
							   MAX(A.TO_SITE_ID) AS TO_SITE_ID,
							   MAX(A.TO_PLANT_ID) AS TO_PLANT_ID,
							   MAX(A.CUSTOMER_ID) AS CUSTOMER_ID,
							   MAX(A.SHIP_DATE) AS SHIP_DATE,
							   MAX(A.SHIP_WEEK) AS SHIP_WEEK,
							   SUM(A.SHIP_QTY) AS SHIP_QTY,
							   MAX(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE,
							   MAX(A.TRANSPORT_MODE) AS TRANSPORT_MODE,
							   NULL AS BIZ_TYPE,
							   NULL AS CONFIRM_TYPE,
							   A.MARKET,
							   MAX(A.SHIP_TO_PARTY) AS SHIP_TO_PARTY,				--2018-08-02 PIYONG ADD
							   MAX(A.RECEIVE_YYYYMMDD) AS RECEIVE_YYYYMMDD,			--2018-08-02 PIYONG ADD
							   MAX(A.SHIP_TO_CODE)     AS SHIP_TO_CODE,             --2018-08-21 KIMCD 도착지 코드 ADD
							   'SY_XIF_SSP_SALES_EXFACTORY_R' AS INSERT_ID,
							   GETDATE() AS INSERT_TIME,
							   'SY_XIF_SSP_SALES_EXFACTORY_R' AS UPDATE_ID,
							   GETDATE() AS UPDATE_TIME
						  FROM (
								SELECT P.COMPANY_ID
									   ,B.SEGMENT3 AS DIVISION_ID					-- 2018-08-16 PIYONG CHANGE A.DIVISION -> B.SEGMENT3
									   ,P.SITE_ID
									   ,A.PLANT_ID
									   ,A.OPERATION_GROUP							 AS SHOP_GROUP_ID
									   ,@PLAN_ID AS SCP_PLAN_ID
									   ,SHIP_ID AS SCP_TARGET_ID
									   ,'-' AS FP_TARGET_ID
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
									   ,SHIP_METHOD AS TRANSPORT_MODE
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
								  FROM [dbo].[SY_XIF_SSP_SALES_EXFACTORY_R] A
									   ,(
											SELECT  W.SEGMENT4  PLANT
												   ,W.SEGMENT3  -- 2018-08-16 PIYONG ADD
												   ,W.SEGMENT2  OPERATION_GROUP
												   ,W.SEGMENT1  DIVISION
												   ,(SELECT CASE WHEN ( @key_day + ' ' + LEFT(X.SEGMENT2, 2) +':'+ SUBSTRING(X.SEGMENT2, 3, 2) +':00' )
												                      < CONVERT(NVARCHAR(20), [DBO].[FN_SITE_TIME] ( XP.SITE_ID ), 120)
															     THEN
																	 @to_day
																 ELSE @yester_day END  AS FROM_DATE
												     FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] X WITH(NOLOCK), SCM_PLANT_M   XP (NOLOCK)
													 WHERE  X.SEGMENT1         = XP.PLANT_ID
													 AND    X.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													 AND    X.SEGMENT1         = W.SEGMENT4
													 AND    X.ACTIVE_FLAG      = 'Y')   AS FROM_DATE -- 2020-09-28 kimcd 기준일자 추가
											  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
											 WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
											   AND ATTRIBUTE4 = 'Y'   
									   ) B
									   ,(SELECT *
										  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
										 WHERE W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
										   AND ACTIVE_FLAG = 'Y') C
									   ,[SCM_PLANT_M] P
								 WHERE A.PLAN_ID	     = @PLAN_ID
								   AND A.DIVISION        = @DIVISION
								   AND A.PLANT_ID		 = @PLANT_ID	-- 2019-10-10 PIYONG ADD
								   AND ISNULL(A.PROC_FLAG,'N') = 'N'
							   	   AND A.EXFACTORY_QTY   > 0
								   AND A.OPERATION_GROUP != 'E'
								   AND A.OPERATION_GROUP = B.OPERATION_GROUP 
								   AND A.PLANT_ID	     = B.PLANT 
								   AND A.DIVISION        = B.DIVISION
								   AND A.EXFACTORY_YYYYMMDD >= B.FROM_DATE  -- 2020-09-28 kimcd 기준일자 추가  
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
							   A.SCP_PLAN_ID,
							   A.SCP_TARGET_ID,
							   A.FP_TARGET_ID,
							   A.MARKET
						;
						
						SET @ROWCOUNT = @@ROWCOUNT


						MERGE INTO [DBO].[SCM_SCP_PLAN_H] A
						USING (
							   SELECT @PLAN_ID AS SCP_PLAN_ID,
									  'SHIPMENT' AS SCP_PLAN_TYPE,
									  CONVERT(DATETIME, SUBSTRING(@PLAN_ID, 1, 8)) AS PLAN_START_TIME,
									  200 AS PLAN_HORIZON,
									  200 AS DEMAND_HORIZON,
									  SUBSTRING(@PLAN_ID, 1, 4) + 
										REPLICATE('0', 2 - LEN(DATEPART(WW, SUBSTRING(@PLAN_ID, 1, 8)) )) +
											CAST(DATEPART(WW, SUBSTRING(@PLAN_ID, 1, 8))  AS VARCHAR)  AS PLAN_WEEK	--2019-05-29 PIYONG CHANGE 단자리 주차앞에 0 생성하도록 변경
							  ) B
						   ON (
								A.SCP_PLAN_ID = B.SCP_PLAN_ID
						      )
						 WHEN MATCHED THEN

							UPDATE SET  A.[SCP_PLAN_TYPE]     = B.[SCP_PLAN_TYPE]
									   ,A.[PLAN_START_TIME]   = B.[PLAN_START_TIME]
									   ,A.[PLAN_HORIZON]      = B.[PLAN_HORIZON]
									   ,A.[DEMAND_HORIZON]    = B.[DEMAND_HORIZON]
									   ,A.UPDATE_ID           = 'SY_XIF_SSP_SALES_EXFACTORY_R'
									   ,A.UPDATE_TIME         = GETDATE()

						 WHEN NOT MATCHED THEN

							INSERT ([SCP_PLAN_ID]
								   ,[SCP_PLAN_TYPE]
								   ,[PLAN_START_TIME]
								   ,[PLAN_HORIZON]
								   ,[DEMAND_HORIZON]
								   ,[PLAN_WEEK]
								   ,[INSERT_ID]
								   ,[INSERT_TIME]
								   ,[UPDATE_ID]
								   ,[UPDATE_TIME]
							) VALUES (
									B.SCP_PLAN_ID,
									B.SCP_PLAN_TYPE,
									B.PLAN_START_TIME,
									B.PLAN_HORIZON,
									B.DEMAND_HORIZON,
									B.PLAN_WEEK,
									'SY_XIF_SSP_SALES_EXFACTORY_R',
									GETDATE(),
									'SY_XIF_SSP_SALES_EXFACTORY_R',
									GETDATE()
						   )

						;


						UPDATE [dbo].[SY_XIF_SSP_SALES_EXFACTORY_R]
						   SET PROC_FLAG = 'Y'
							   ,PROC_DATE = GETDATE()
						 WHERE PROC_FLAG = 'N'
						   AND PLAN_ID =  @PLAN_ID
						   AND DIVISION = @DIVISION
						   AND PLANT_ID = @PLANT_ID
						;
		

						IF ( @ROWCOUNT > 0 OR @ROWCOUNT_E >0 )
							BEGIN
								-- 2018-07-23 PIYONG ADD
								INSERT INTO @TEMP_DIVISION
								SELECT @DIVISION, @SHOP_GROUP   -- 2022-03-30 kimcd 공정 군 추가
							END					

--					END																		-- 2019-10-11 PIYONG DEL

					FETCH NEXT FROM CUR_DIVISION INTO @DIVISION
													, @PLAN_ID
													, @PLANT_ID								-- 2019-10-10 PIYONG ADD
													, @SHOP_GROUP       -- 2022-03-30 kimcd 공정 군 추가


					END  -- WHILE @@FETCH_STATUS = 0  CUR_DIVISION
				
				CLOSE CUR_DIVISION;
				DEALLOCATE CUR_DIVISION;   -- 메모리 해제


			END	



			--------------------------------------------------------------------------------------------------------------------------------
			-- 2019-10-10 PIYONG ADD
			DECLARE CUR_MAIL CURSOR FOR
				SELECT DISTINCT DIVISION, SHOP_GROUP  -- 2022-03-30 kimcd 공정 군 추가
				  FROM @TEMP_DIVISION

			OPEN CUR_MAIL
			FETCH NEXT FROM CUR_MAIL INTO @DIVISION
										, @SHOP_GROUP
				WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
					BEGIN
						SET @DIVISION_NAME = (
												SELECT TOP 1 DIVISION_NAME
													FROM SCM_DIVISION_M
													WHERE DIVISION_ID = @DIVISION
													ORDER BY DIVISION_NAME
												)

						-- 2018-08-16 PIYONG ADD
						--IF @DIVISION = 'EE'
						IF @SHOP_GROUP = 'E'
							BEGIN
								SET @DIVISION_NAME = @DIVISION + ' Electrode'
							END

						INSERT INTO dbo.SCM_MAILING_H
						(   [MAIL_PKEY]
							,[MAIL_SEQ]
							,[MAIL_DATETIME]
							,[MAIL_SUBJECT]
							,[MAIL_BODY]
							,[MAIL_QUERY]
							,[ATTACH_FILE_NAME]
							,[MAIL_RECEIVER_LIST]
							,[MAIL_PROFILE_NAME]
							,[MAIL_SEND_FLAG]
							,[MESSAGE]
							,[CREATE_USER_ID]
							,[CREATE_DATE]
							,[MODIFY_USER_ID]
							,[MODIFY_DATE]
						)
						SELECT [MAIL_PKEY]
								, NEXT VALUE FOR SEQ_SCM_MAIL
								, NULL
								, REPLACE([MAIL_SUBJECT],'@DIVISION_NAME',@DIVISION_NAME)
								, REPLACE( REPLACE([MAIL_BODY],'@V_SCP_PLAN_ID',@PLAN_ID) ,'@DIVISION_NAME',@DIVISION_NAME)
								, [MAIL_QUERY]
								, [ATTACH_FILE_NAME]
								, [MAIL_RECEIVER_LIST]+ ISNULL(	-- 2018-07-18 PIYONG CHANGE
																(
																	SELECT ATTRIBUTE1
																		FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
																		WHERE LOOKUP_TYPE_CODE = 'TARGET_INFO_MAIL'
																		AND SEGMENT1 ='SSP_SALES'
																		AND SEGMENT3 = @DIVISION
																		AND ACTIVE_FLAG = 'Y'
																)
																, ';')
								,'FP_MAIL_TEST'
								, 'N'
								, NULL  
								, @v_proc_name
								, getdate()
								, @v_proc_name
								, getdate()
						 FROM [SCM_MAILING_LIST_M]
						WHERE MAIL_PKEY = 'SSP_SALES'+@DIVISION

						FETCH NEXT FROM CUR_MAIL INTO @DIVISION
													, @SHOP_GROUP

					END
				
			CLOSE CUR_MAIL;
			DEALLOCATE CUR_MAIL;   -- 메모리 해제

			-- 2019-10-10 PIYONG ADD END
			--------------------------------------------------------------------------------------------------------------------------------

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN
		
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		
		-- cursor 중복 오류로 인해 추가함 1.9 ver add
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_DIVISION')
		BEGIN
			CLOSE CUR_DIVISION
			DEALLOCATE CUR_DIVISION
		END
        -- cursor 중복 오류로 인해 추가함 1.9 ver add
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_MAIL')
		BEGIN
			CLOSE CUR_MAIL
			DEALLOCATE CUR_MAIL
		END

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
