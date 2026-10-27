
CREATE PROCEDURE [dbo].[PR_SCM_DEMAND_INFO_H_INSERT]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_DEMAND_INFO_H_INSERT
-- Param               :
-- Batch Period        : 1 DAY
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H, FP_WEEKLY_DEMAND_PRODUCT_H, FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H
--						 FP_WEEKLY_DEMAND_PRODUCT_SRS_H, FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H, FP_WEEKLY_DEMAND_PRODUCT_TEST_H
-- Destination Table   : SCM_DEMAND_INFO_H
--
-- Create(Update) Date : 2022.05.12
-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 2019-01-04 kimcd  shop 기준으로 정보 형성
--                       1.2 2019-02-11 kimcd  FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H 형성 작업 활성화
--						 1.3 2019-09-18 PIYONG 시업 시간 기준  생성, 조회 조건 추가
--                       1.4 2019-10-10 kimcd  FP_WEEKLY_DEMAND_SHIPMENT_H Plant별 집계로 수정
--                                             SSP Plant별 정보 생산에 따른 구분자 추가
--                       1.5 2021-11-05 kimcd  FP_WEEKLY_DEMAND_SHIPMENT_H 이력 취합을 전일부터 취합하도록 수정
--                                             <- 전일 최종 변경된 정보 취합
--                       1.6 2022-05-12 kimcd  시업 시간별 Site 조회 로직 보완
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_DEMAND_INFO_H_INSERT'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	--LOGCAL 변수
	DECLARE @this_date		DATE
	DECLARE @this_week		NVARCHAR(10)
	DECLARE @scp_plan_id	NVARCHAR(30)
	DECLARE @division_id	NVARCHAR(30)
	DECLARE @site_id		NVARCHAR(30)
	DECLARE @plant_id		NVARCHAR(30)
	DECLARE @shop_group_id  NVARCHAR(10) -- 2019-01-04 kimcd shop 정보 추가
	DECLARE @TEMP_PLANT		TABLE (			-- 2019-09-18 PIYONG ADD
										PLANT_ID NVARCHAR(30)
								  )
	DECLARE @CHECK_INSERT_TIME DATETIME -- 2021-11-05 kimcd 형성 시간 점검용 기준
	DECLARE @CHECK_Y_DATE      DATE -- 2021-11-05 kimcd 어제 일자 설정

	DECLARE C_PRODUCT_H CURSOR FOR
		SELECT [SCP_PLAN_ID]
			  ,[DIVISION_ID]
			  ,[SHOP_GROUP_ID]  -- 2019-01-04 kimcd shop 정보 추가
			  ,(SELECT WEEK
				  FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
				 WHERE DATE_ID = CONVERT( DATETIME, SUBSTRING([SCP_PLAN_ID], 1, 8), 112)) AS THIS_WEEK
		 FROM (
				SELECT MAX([SCP_PLAN_ID]) AS [SCP_PLAN_ID]
					   ,[DIVISION_ID]
					   ,[SHOP_GROUP_ID]  -- 2019-01-04 kimcd shop 정보 추가
				  FROM [FP_WEEKLY_DEMAND_PRODUCT_H]
				 GROUP BY [DIVISION_ID]
				         ,[SHOP_GROUP_ID]  -- 2019-01-04 kimcd shop 정보 추가
			  ) A

	DECLARE C_SHIPMENT_ELEC_H CURSOR FOR
		SELECT [SCP_PLAN_ID]
			  ,[DIVISION_ID]
			  ,SUBSTRING([SCP_PLAN_ID], 1, 8) AS THIS_DATE
		 FROM (
				SELECT MAX([SCP_PLAN_ID]) AS [SCP_PLAN_ID]
					   ,[DIVISION_ID]
				  FROM [FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H]
				 GROUP BY [DIVISION_ID]
		 	  ) A

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			SET @site_id =  (
								SELECT DISTINCT SITE_ID
								  FROM DBO.SCM_PLANT_M S WITH(NOLOCK)
								 WHERE SUBSTRING(REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':',''), 12, 3) = (
																															SELECT DISTINCT SUBSTRING(V.SEGMENT2, 1, 3)
																															  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
																															 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																															   AND V.ACTIVE_FLAG = 'Y'
																															   AND V.SEGMENT1    = S.PLANT_ID -- 2022-05-12 kimcd  시업 시간별 Site 조회 로직 보완
																														)
							)
			SET @CHECK_INSERT_TIME = CONVERT(DATETIME, CONVERT(NVARCHAR(15), GETDATE(), 120) + '0:00:00', 120) -- 2021-11-05 kimcd 형성 시간 제한 기준 설정
			SET @CHECK_Y_DATE = DATEADD( D, -1, GETDATE()) -- 2021-11-05 kimcd 어제 일자 설정
			
			--------------------------------------------------------------------------------------------------------------------------------
			--2019-09-18 PIYONG ADD
			INSERT INTO @TEMP_PLANT
			 SELECT PLANT_ID
			   FROM SCM_PLANT_M S
			  WHERE SUBSTRING( REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':',''), 12,  3) = (
																														SELECT DISTINCT LEFT(V.SEGMENT2, 3)	--10분을 주기 위해 3자리
																														  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
																														 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																														   AND V.ACTIVE_FLAG = 'Y'
																														   AND V.SEGMENT1    = S.PLANT_ID
																													   )
			--2019-09-18 PIYONG ADD END
			--------------------------------------------------------------------------------------------------------------------------------
			DECLARE C_SHIPMENT_H CURSOR FOR
				SELECT [SCP_PLAN_ID]
					  ,[DIVISION_ID]
					  ,[SHOP_GROUP_ID]  -- 2019-01-04 kimcd shop 정보 추가
					  ,@CHECK_Y_DATE   AS THIS_DATE
					  ,[PLANT_ID] -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가
				 FROM (
						SELECT MAX([SCP_PLAN_ID]) AS [SCP_PLAN_ID]
							   ,[DIVISION_ID]
							   ,[SHOP_GROUP_ID]  -- 2019-01-04 kimcd shop 정보 추가
							   ,[PLANT_ID]       -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가
						  FROM [FP_WEEKLY_DEMAND_SHIPMENT_H]
						  WHERE SITE_ID = @site_id  -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가
						  AND   PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT) -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가
						  AND   INSERT_TIME < @CHECK_INSERT_TIME -- 2021-11-05 kimcd 형성 시간 제한 기준 설정
						 GROUP BY [DIVISION_ID]
								 ,[SHOP_GROUP_ID]  -- 2019-01-04 kimcd shop 정보 추가
								 ,[PLANT_ID]       -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가
		 			 ) A  -- 2019-10-10 kimcd cursor 위치 변경.


	        IF @site_id IS NOT NULL AND @site_id != ''
				BEGIN

					-- 2019-02-11 kimcd FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H 형성 작업 활성화 시작
					SET @v_temp2 = 'FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H'
					SELECT @this_week = WEEK
				    FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
				    WHERE DATE_ID = CONVERT( DATE, DATEADD( D, -1, [dbo].[FN_SITE_TIME] (@site_id)), 120)

					DELETE
					  FROM SCM_DEMAND_INFO_H
					 WHERE DEMAND_TABLE_TYPE = @v_temp2
					   AND SITE_ID = @site_id
					   AND MFG_WEEK >= @this_week
					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD

					INSERT INTO SCM_DEMAND_INFO_H (
						[DEMAND_TABLE_TYPE]
						,[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[PLAN_ID]
						,[TARGET_ID]
						,[ITEM_ID]
						,[MFG_DATE]
						,[MFG_WEEK]
						,[MFG_QTY]
						,[PRODUCTION_TYPE]
						,[PKG_TYPE]
						,[CUSTOMER_ID]
						,[SALES_PERSION_ID]
						,[MARKET]
						,[DEMAND_INSERT_ID]
						,[DEMAND_INSERT_TIME]
						,[DEMAND_UPDATE_ID]
						,[DEMAND_UPDATE_TIME]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
					)
					SELECT @v_temp2
						   ,[COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[CELL_PLAN_ID]
						   ,[CELL_TARGET_ID]
						   ,[ITEM_ID]
						   ,[MFG_DATE]
						   ,[MFG_WEEK]
						   ,[MFG_QTY]
						   ,[PRODUCTION_TYPE]
						   ,[PKG_TYPE]
						   ,[CUSTOMER_ID]
						   ,[SALES_PERSION_ID]
						   ,[MARKET]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME]
						   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
						   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
					  FROM [FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H] A
					 WHERE [MFG_WEEK] >= @this_week
					   AND EXISTS (
									SELECT 1
									  FROM (
											SELECT MAX([CELL_PLAN_ID]) AS [CELL_PLAN_ID]
												   ,[COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]											--2019-09-18 PIYONG ADD
											  FROM [FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H]
											  WHERE SITE_ID = @site_id
						  					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD
											 GROUP BY [COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]										--2019-09-18 PIYONG ADD
										   ) B
									 WHERE A.[CELL_PLAN_ID] = B.[CELL_PLAN_ID]
									   AND A.[COMPANY_ID] = B.[COMPANY_ID]
									   AND A.[DIVISION_ID] = B.[DIVISION_ID]
									   AND A.[SITE_ID] = B.[SITE_ID]
									   AND A.[PLANT_ID] = B.[PLANT_ID]								--2019-09-18 PIYONG ADD
								   )
					;
					-- 2019-02-11 kimcd FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H 형성 작업 활성화 끝

					SET @v_temp2 = 'FP_WEEKLY_DEMAND_PRODUCT_H'
					-- 최종 PLAN_ID에 최소WEEK 찾아서 다시 생성
					OPEN C_PRODUCT_H
					FETCH NEXT FROM C_PRODUCT_H INTO @scp_plan_id,
													 @division_id,
													 @shop_group_id,  -- 2019-01-04 kimcd shop 정보 추가
													 @this_week

					WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN

							DELETE
							  FROM SCM_DEMAND_INFO_H
							 WHERE DEMAND_TABLE_TYPE = @v_temp2
							   AND MFG_WEEK >= @this_week
							   AND [DIVISION_ID] = @division_id
							   AND [SITE_ID] = @site_id
							   AND [SHOP_GROUP_ID] = @shop_group_id  -- 2019-01-04 kimcd shop 정보 추가
		   					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD

		                                                                                                                
							INSERT INTO SCM_DEMAND_INFO_H (
								[DEMAND_TABLE_TYPE]
								,[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[SHOP_GROUP_ID]
								,[PLAN_ID]
								,[TARGET_ID]
								,[MARKET]
								,[ITEM_ID]
								,[MFG_WEEK]
								,[MFG_QTY]
								,[CHG_QTY]
								,[PRODUCTION_TYPE]
								,[SAMPLE_FROM_DATE]
								,[SAMPLE_TO_DATE]
								,[LINE_ID]
								,[PRIORITY]
								,[PERIOD_TYPE]
								,[CONFIRM_TYPE]
								,[DEMAND_TYPE]
								,[OPERATION_ID]
								,[DEMAND_INSERT_ID]
								,[DEMAND_INSERT_TIME]
								,[DEMAND_UPDATE_ID]
								,[DEMAND_UPDATE_TIME]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
							)
							SELECT @v_temp2
									,[COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[SHOP_GROUP_ID]
									,[SCP_PLAN_ID]
									,[SCP_TARGET_ID]
									,[MARKET]
									,[ITEM_ID]
									,[MFG_WEEK]
									,[MFG_QTY]
									,[CHG_QTY]
									,[PRODUCTION_TYPE]
									,[SAMPLE_FROM_DATE]
									,[SAMPLE_TO_DATE]
									,[LINE_ID]
									,[PRIORITY]
									,[PERIOD_TYPE]
									,[CONFIRM_TYPE]
									,[DEMAND_TYPE]
									,[OPERATION_ID]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,'PR_SCM_DEMAND_INFO_H_INSERT'
									,GETDATE()
									,'PR_SCM_DEMAND_INFO_H_INSERT'
									,GETDATE()
							   FROM [FP_WEEKLY_DEMAND_PRODUCT_H]
							  WHERE MFG_WEEK >= @this_week
								AND [SCP_PLAN_ID] = @scp_plan_id
								AND [DIVISION_ID] = @division_id
								AND [SITE_ID] = @site_id
								AND [SHOP_GROUP_ID] = @shop_group_id  -- 2019-01-04 kimcd shop 정보 추가
							    AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD
							;

							FETCH NEXT FROM C_PRODUCT_H INTO @scp_plan_id,
															 @division_id,
															 @shop_group_id,  -- 2019-01-04 kimcd shop 정보 추가
															 @this_week

						END  -- WHILE @@FETCH_STATUS = 0  C_SITE
					CLOSE C_PRODUCT_H;
					DEALLOCATE C_PRODUCT_H;   -- 메모리 해제

/*
					SET @v_temp2 = 'FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H'

					DELETE
					  FROM SCM_DEMAND_INFO_H
					 WHERE DEMAND_TABLE_TYPE = @v_temp2
					   AND MFG_WEEK >= @this_week

                                                                                                                  
					INSERT INTO SCM_DEMAND_INFO_H (
							[DEMAND_TABLE_TYPE]
							,[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[PLAN_ID]
							,[TARGET_ID]
							,[ITEM_ID]
							,[OPERATION_ID]
							,[MFG_DATE]
							,[MFG_WEEK]
							,[MFG_QTY]
							,[PRODUCTION_TYPE]
							,[PRIORITY]
							,[DEMAND_TYPE]
							,[DEMAND_INSERT_ID]
							,[DEMAND_INSERT_TIME]
							,[DEMAND_UPDATE_ID]
							,[DEMAND_UPDATE_TIME]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
					)
					SELECT @v_temp2
						   ,[COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[MOBILE_PLAN_ID]
						   ,[MOBILE_TARGET_ID]
						   ,[ITEM_ID]
						   ,[OPERATION_ID]
						   ,[MFG_DATE]
						   ,[MFG_WEEK]
						   ,[MFG_QTY]
						   ,[PRODUCTION_TYPE]
						   ,[PRIORITY]
						   ,[DEMAND_TYPE]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME]
	   					   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
						   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
					  FROM [FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H] A
					 WHERE MFG_WEEK >= @this_week
					   AND EXISTS (
									SELECT 1
									  FROM (
											SELECT MAX([MOBILE_PLAN_ID]) AS [MOBILE_PLAN_ID]
												   ,[COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]
												   ,[FACTORY_ID]
											  FROM [FP_WEEKLY_DEMAND_PRODUCT_MOBILE_COATER_H]
											 GROUP BY [COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]
												   ,[FACTORY_ID]
										   ) B
									 WHERE A.[MOBILE_PLAN_ID] = B.[MOBILE_PLAN_ID]
									   AND A.[COMPANY_ID] = B.[COMPANY_ID]
									   AND A.[DIVISION_ID] = B.[DIVISION_ID]
									   AND A.[SITE_ID] = B.[SITE_ID]
									   AND A.[PLANT_ID] = B.[PLANT_ID]
									   AND A.[FACTORY_ID] = B.[FACTORY_ID]
								  )
					;




					SET @v_temp2 = 'FP_WEEKLY_DEMAND_PRODUCT_SRS_H'

					DELETE
					  FROM SCM_DEMAND_INFO_H
					 WHERE DEMAND_TABLE_TYPE = @v_temp2
					   AND MFG_WEEK >= @this_week


					INSERT INTO SCM_DEMAND_INFO_H (
							[DEMAND_TABLE_TYPE]
							,[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[PLAN_ID]
							,[TARGET_ID]
							,[ITEM_ID]
							,[MFG_DATE]
							,[MFG_WEEK]
							,[MFG_QTY]
							,[PRODUCTION_TYPE]
							,[PRIORITY]
							,[DEMAND_TYPE]
							,[DEMAND_INSERT_ID]
							,[DEMAND_INSERT_TIME]
							,[DEMAND_UPDATE_ID]
							,[DEMAND_UPDATE_TIME]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
					)
					SELECT @v_temp2
						   ,[COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[SRS_PLAN_ID]
						   ,[SRS_TARGET_ID]
						   ,[ITEM_ID]
						   ,[MFG_DATE]
						   ,[MFG_WEEK]
						   ,[MFG_QTY]
						   ,[PRODUCTION_TYPE]
						   ,[PRIORITY]
						   ,[DEMAND_TYPE]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME]
						   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
						   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
					  FROM [FP_WEEKLY_DEMAND_PRODUCT_SRS_H] A
					 WHERE MFG_WEEK >= @this_week
					   AND EXISTS (
									SELECT 1
									  FROM (
											SELECT MAX([SRS_PLAN_ID]) AS [SRS_PLAN_ID]
												   ,[COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]
											  FROM [FP_WEEKLY_DEMAND_PRODUCT_SRS_H]
											 GROUP BY [COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]
										   ) B
									 WHERE A.[SRS_PLAN_ID] = B.[SRS_PLAN_ID]
									   AND A.[COMPANY_ID] = B.[COMPANY_ID]
									   AND A.[DIVISION_ID] = B.[DIVISION_ID]
									   AND A.[SITE_ID] = B.[SITE_ID]
									   AND A.[PLANT_ID] = B.[PLANT_ID]
								  )
					;

*/
			-- 사이트별 시업시간 기준으로 전일 데이터 부터 다시 생성

					SET @v_temp2 = 'FP_WEEKLY_DEMAND_PRODUCT_TEST_H'

					DELETE
					  FROM SCM_DEMAND_INFO_H
					 WHERE DEMAND_TABLE_TYPE = @v_temp2
					   AND [DUE_DATE] >= CAST(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (@site_id)-1, 120) AS datetime)
					   AND SITE_ID = @site_id
   					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD


					INSERT INTO SCM_DEMAND_INFO_H (
							[DEMAND_TABLE_TYPE]
							,[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[PLAN_ID]
							,[TARGET_ID]
							,[MODEL]
							,[ITEM_ID]
							,[FACTORY_ID]
							,[LINE_ID]
							,[OPERATION_ID]
							,[MARKET]
							,[DUE_DATE]
							,[SEQ]
							,[MFG_WEEK]
							,[MFG_QTY]
							,[DESCRIPTION]
							,[DEMAND_TYPE]
							,[IS_PREV_SCHEDULE]
							,[DEMAND_INSERT_ID]
							,[DEMAND_INSERT_TIME]
							,[DEMAND_UPDATE_ID]
							,[DEMAND_UPDATE_TIME]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
					)
					SELECT @v_temp2
							,[COMPANY_ID]
							,[DIVISION_ID]
							,[SITE_ID]
							,[PLANT_ID]
							,[SCP_PLAN_ID]
							,[TEST_TARGET_ID]
							,[MODEL]
							,[ITEM_ID]
							,[FACTORY_ID]
							,[LINE_ID]
							,[OPERATION_ID]
							,[MARKET]
							,[DUE_DATE]
							,[SEQ]
							,[MFG_WEEK]
							,[MFG_QTY]
							,[DESCRIPTION]
							,[DEMAND_TYPE]
							,[IS_PREV_SCHEDULE]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
							,'PR_SCM_DEMAND_INFO_H_INSERT'
							,GETDATE()
							,'PR_SCM_DEMAND_INFO_H_INSERT'
							,GETDATE()
					   FROM [FP_WEEKLY_DEMAND_PRODUCT_TEST_H] A
					  WHERE [DUE_DATE] >= CAST(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (@site_id)-1, 120) AS datetime)
						AND SITE_ID = @site_id
					    AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD
						;

/*
					SET @v_temp2 = 'FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H'

					DELETE
					  FROM SCM_DEMAND_INFO_H
					 WHERE DEMAND_TABLE_TYPE = @v_temp2
					   AND MFG_WEEK >= @this_week

					INSERT INTO SCM_DEMAND_INFO_H (
						[DEMAND_TABLE_TYPE]
						,[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[SHOP_GROUP_ID]
						,[PLAN_ID]
						,[TARGET_ID]
						,[FP_TARGET_ID]
						,[ITEM_ID]
						,[BASE_DATE]
						,[MFG_DATE]
						,[MFG_WEEK]
						,[MFG_QTY]
						,[PRODUCTION_TYPE]
						,[MARKET]
						,[DEMAND_INSERT_ID]
						,[DEMAND_INSERT_TIME]
						,[DEMAND_UPDATE_ID]
						,[DEMAND_UPDATE_TIME]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
					)
					SELECT @v_temp2
						   ,[COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[SHOP_GROUP_ID]
						   ,[SCP_PLAN_ID]
						   ,[SCP_TARGET_ID]
						   ,[FP_TARGET_ID]
						   ,[ITEM_ID]
						   ,[BASE_DATE]
						   ,[SHIP_DATE]
						   ,[SHIP_WEEK]
						   ,[SHIP_QTY]
						   ,[PRODUCTION_TYPE]
						   ,[MARKET]
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME]
						   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
						   ,'PR_SCM_DEMAND_INFO_H_INSERT'
						   ,GETDATE()
					  FROM [FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H] A
					 WHERE [SHIP_WEEK] >= @this_week
					   AND EXISTS (
									SELECT 1
									  FROM (
											SELECT MAX([SCP_PLAN_ID]) AS [SCP_PLAN_ID]
												   ,[COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]
											  FROM [FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H]
											 GROUP BY [COMPANY_ID]
												   ,[DIVISION_ID]
												   ,[SITE_ID]
												   ,[PLANT_ID]
										   ) B
									 WHERE A.[SCP_PLAN_ID] = B.[SCP_PLAN_ID]
									   AND A.[COMPANY_ID] = B.[COMPANY_ID]
									   AND A.[DIVISION_ID] = B.[DIVISION_ID]
									   AND A.[SITE_ID] = B.[SITE_ID]
									   AND A.[PLANT_ID] = B.[PLANT_ID]
								  )
					;

*/
-- 최종 PLAN_ID 에 최소 WEEK부터 다시 생성
					SET @v_temp2 = 'FP_WEEKLY_DEMAND_SHIPMENT_H'

					OPEN C_SHIPMENT_H
					FETCH NEXT FROM C_SHIPMENT_H INTO @scp_plan_id,
													 @division_id,
													 @shop_group_id,  -- 2019-01-04 kimcd shop 정보 추가
													 @this_date,
													 @plant_id        -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가

					WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN

							DELETE
							  FROM SCM_DEMAND_INFO_H
							 WHERE DEMAND_TABLE_TYPE = @v_temp2
							   AND BASE_DATE >= @this_date
							   AND [DIVISION_ID] = @division_id
							   AND [SITE_ID] = @site_id
							   AND [SHOP_GROUP_ID] = @shop_group_id  -- 2019-01-04 kimcd shop 정보 추가
							   AND [PLANT_ID]      = @plant_id       -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가
		   					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD

							INSERT INTO SCM_DEMAND_INFO_H (
								[DEMAND_TABLE_TYPE]
								,[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[SHOP_GROUP_ID]
								,[PLAN_ID]
								,[TARGET_ID]
								,[FP_TARGET_ID]
								,[ITEM_ID]
								,[BASE_DATE]
								,[MFG_DATE]
								,[MFG_WEEK]
								,[MFG_QTY]
								,[PRODUCTION_TYPE]
								,[MARKET]
								,[DEMAND_INSERT_ID]
								,[DEMAND_INSERT_TIME]
								,[DEMAND_UPDATE_ID]
								,[DEMAND_UPDATE_TIME]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
							)
							SELECT @v_temp2
								   ,[COMPANY_ID]
								   ,[DIVISION_ID]
								   ,[SITE_ID]
								   ,[PLANT_ID]
								   ,[SHOP_GROUP_ID]
								   ,[SCP_PLAN_ID]
								   ,[SCP_TARGET_ID]
								   ,[FP_TARGET_ID]
								   ,[ITEM_ID]
								   ,[SHIP_DATE]
								   ,[SHIP_DATE]
								   ,[SHIP_WEEK]
								   ,[SHIP_QTY]
								   ,[PRODUCTION_TYPE]
								   ,[MARKET]
								   ,[INSERT_ID]
								   ,[INSERT_TIME]
								   ,[UPDATE_ID]
								   ,[UPDATE_TIME]
								   ,'PR_SCM_DEMAND_INFO_H_INSERT'
								   ,GETDATE()
								   ,'PR_SCM_DEMAND_INFO_H_INSERT'
								   ,GETDATE()
							  FROM [FP_WEEKLY_DEMAND_SHIPMENT_H] A
							 WHERE [SHIP_DATE] >= @this_date
   							   AND [SCP_PLAN_ID] = @scp_plan_id
							   AND [DIVISION_ID] = @division_id
							   AND [SITE_ID] = @site_id
							   AND [SHOP_GROUP_ID] = @shop_group_id  -- 2019-01-04 kimcd shop 정보 추가
							   AND [PLANT_ID]      = @plant_id       -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가
		   					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD
							;
						FETCH NEXT FROM C_SHIPMENT_H INTO @scp_plan_id,
														 @division_id,
														 @shop_group_id,  -- 2019-01-04 kimcd shop 정보 추가
														 @this_date,
														 @plant_id        -- 2019-10-10  kimcd SSP Plant별 정보 생산에 따른 구분자 추가

						END  -- WHILE @@FETCH_STATUS = 0  C_SITE

					CLOSE C_SHIPMENT_H;
					DEALLOCATE C_SHIPMENT_H;

					SET @v_temp2 = 'FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H'

					OPEN C_SHIPMENT_ELEC_H
					FETCH NEXT FROM C_SHIPMENT_ELEC_H INTO @scp_plan_id,
															@division_id,
															@this_date

					WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
						BEGIN
	
							DELETE
							  FROM SCM_DEMAND_INFO_H
							 WHERE DEMAND_TABLE_TYPE = @v_temp2
							   AND BASE_DATE >= @this_date
							   AND [DIVISION_ID] = @division_id
							   AND [SITE_ID] = @site_id
		   					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD

							INSERT INTO SCM_DEMAND_INFO_H (
								[DEMAND_TABLE_TYPE]
								,[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[SHOP_GROUP_ID]
								,[PLAN_ID]
								,[TARGET_ID]
								,[FP_TARGET_ID]
								,[ITEM_ID]
								,[BASE_DATE]
								,[MFG_DATE]
								,[MFG_WEEK]
								,[MFG_QTY]
								,[PRODUCTION_TYPE]
								,[MARKET]
								,[DEMAND_INSERT_ID]
								,[DEMAND_INSERT_TIME]
								,[DEMAND_UPDATE_ID]
								,[DEMAND_UPDATE_TIME]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
							)
							SELECT @v_temp2
								   ,[COMPANY_ID]
								   ,[DIVISION_ID]
								   ,[SITE_ID]
								   ,[PLANT_ID]
								   ,[SHOP_GROUP_ID]
								   ,[SCP_PLAN_ID]
								   ,[SCP_TARGET_ID]
								   ,[FP_TARGET_ID]
								   ,[ITEM_ID]
								   ,[SHIP_DATE]
								   ,[SHIP_DATE]
								   ,[SHIP_WEEK]
								   ,[SHIP_QTY]
								   ,[PRODUCTION_TYPE]
								   ,[MARKET]
								   ,[INSERT_ID]
								   ,[INSERT_TIME]
								   ,[UPDATE_ID]
								   ,[UPDATE_TIME]
								   ,'PR_SCM_DEMAND_INFO_H_INSERT'
								   ,GETDATE()
								   ,'PR_SCM_DEMAND_INFO_H_INSERT'
								   ,GETDATE()
							  FROM [FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] A
							 WHERE [SHIP_DATE] >= @this_date
   							   AND [SCP_PLAN_ID] = @scp_plan_id
							   AND [DIVISION_ID] = @division_id
							   AND [SITE_ID] = @site_id
		   					   AND PLANT_ID IN (SELECT PLANT_ID FROM @TEMP_PLANT)	--2019-09-18 PIYONG ADD
							;
						FETCH NEXT FROM C_SHIPMENT_ELEC_H INTO @scp_plan_id,
																@division_id,
																@this_date

						END  -- WHILE @@FETCH_STATUS = 0  C_SITE
					CLOSE C_SHIPMENT_ELEC_H;
					DEALLOCATE C_SHIPMENT_ELEC_H;

				END  -- WHILE @@FETCH_STATUS = 0  C_SITE


		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, @v_temp2, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



