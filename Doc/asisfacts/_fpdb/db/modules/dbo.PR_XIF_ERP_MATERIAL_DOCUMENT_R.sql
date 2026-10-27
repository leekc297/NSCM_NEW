

CREATE PROCEDURE [dbo].[PR_XIF_ERP_MATERIAL_DOCUMENT_R] 

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_MATERIAL_DOCUMENT_R
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_MATERIAL_DOCUMENT_R
-- Destination Table   : SCM_FCS_MATERIAL_DOCUMENT_H
--
-- Create Date		   : 2018.07.11
-- Update Date		   : 2018.07.19 PIYONG 1.1
--						 2019.09.17 PIYONG 1.2
--                       2019.10.13 KIMCD  1.2
--                       2020.04.13 KIMCD  1.3
--                       2020.10.29 KIMCD  1.4
--                       2021.01.04 KIMCD  1.5

-- Author              : piyong
-- Version             : 1.0
--						 1.1 SCM 데이터 입력 로직 추가
--						 1.2 조회 조건 변경 SITE-> PLANT별시업 시간
--                       1.2 2019-10-13 kimcd 시업 시간 이후 1시간 이내 작업하는 것으로 조건 수정
--                       1.3 2020-04-13 kimcd I/F 정보를 임시 Back up table에 정보 형성함
--                       1.4 2020-10-29 kimcd SCP 정보 입력 부분 주석 처리, 이력형성 주석 처리
--                       1.5 2021-01-04 kimcd 한국, 법인 ERP 서버에서 중복 정보 형성됨. Plant ID를 key로 추가함
--                       1.6 2024-08-29 kimcd AS 출고 정보 수신 작업 추가
-- ================================================================================================

AS

BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_MATERIAL_DOCUMENT_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @IFSEQNO		bigint;
	DECLARE @MAT_DOC_ID		nvarchar(30);
	DECLARE @MAT_DOC_YEAR	nvarchar(4);
	DECLARE @MAT_DOC_ITEM	nvarchar(4);
	DECLARE @PLANT_ID		nvarchar(10); -- 2021-01-04 kimcd key 추가

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRANSACTION PR_XIF_ERP_MATERIAL_TO_DM_RESULT;  
	
	BEGIN TRY

		DECLARE CUR_MATERIAL CURSOR FOR
			SELECT [IFSEQNO]
				   ,[MAT_DOC_ID]
				   ,[MAT_DOC_YEAR]
				   ,[MAT_DOC_ITEM]
				   ,EMD.[PLANT_ID] -- 2021-01-04 kimcd key 추가
			  FROM SY_XIF_ERP_MATERIAL_DOCUMENT_R EMD
			 INNER JOIN (
						 SELECT SEGMENT1 AS PLANT_ID
							    , SEGMENT2 AS STORAGE_ID
							    , SEGMENT3 AS MOVEMENT_TYPE
						   FROM [SCM_SYS_LOOKUP_VALUE]
						  WHERE LOOKUP_TYPE_CODE = 'ERP_MATERIAL_DOCUMENT_MAPPING'
							AND ACTIVE_FLAG = 'Y'
						) SSLV
					 ON EMD.PLANT_ID = SSLV.PLANT_ID
					AND EMD.STORAGE_ID = SSLV.STORAGE_ID
					AND EMD.MOVEMENT_TYPE = SSLV.MOVEMENT_TYPE
				    AND EMD.PLANT_ID IN (
										  SELECT PLANT_ID
											FROM SCM_PLANT_M S
										   WHERE /*	--2019-09-17 PIYONG DEL
													SITE_ID = (
														     SELECT DISTINCT SITE_ID
															   FROM DBO.SCM_SITE_M S WITH(NOLOCK)
															  WHERE SUBSTRING(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120), 12, 2) = (
																																					  SELECT DISTINCT SUBSTRING(V.SEGMENT2, 1, 2)
																																						FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
																																							 ,SCM_FACTORY_M                F  WITH(NOLOCK)
																																					   WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																						 AND V.ACTIVE_FLAG = 'Y'
																																						 AND V.SEGMENT1    = F.PLANT_ID
																																						 AND F.SITE_ID     = S.SITE_ID
																																					 ) 
															)
												 */
												 ---------------------------------------------------------------------------------------------------------------------------------------------------------
												 --2019-09-17 PIYONG ADD
												 CONVERT(NVARCHAR(20), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120)	-- 현재 시간
												 BETWEEN (														-- 기준 시간
															SELECT DISTINCT CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
																			LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
															  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
															 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															   AND V.ACTIVE_FLAG = 'Y'
															   AND V.SEGMENT1    = S.PLANT_ID
														 )
													 AND (
															SELECT DISTINCT DATEADD(MI, 60,	-- 2019-10-13 kimcd class 작업 지연으로 60분으로 작업 대기 시간 연장. 기준 시간 30분 후
																					CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
																					LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
																																					 )
															  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
															 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															   AND V.ACTIVE_FLAG = 'Y'
															   AND V.SEGMENT1    = S.PLANT_ID
														 )
												 --2019-09-17 PIYONG ADD END
												 ---------------------------------------------------------------------------------------------------------------------------------------------------------
										)
			 ORDER BY IFSEQNO;

		-- 2024-08-29 kimcd AS 출고 정보 수신 작업 추가 시작
		DECLARE CUR_AS_MATERIAL CURSOR FOR
			SELECT [IFSEQNO]
				   ,[MAT_DOC_ID]
				   ,[MAT_DOC_YEAR]
				   ,[MAT_DOC_ITEM]
				   ,EMD.[PLANT_ID]
			  FROM SY_XIF_ERP_MATERIAL_DOCUMENT_R EMD
			 INNER JOIN (
						 SELECT SEGMENT1 AS PLANT_ID
							    , SEGMENT2 AS STORAGE_ID
							    , SEGMENT3 AS MOVEMENT_TYPE
						   FROM [SCM_SYS_LOOKUP_VALUE]
						  WHERE LOOKUP_TYPE_CODE = 'ERP_AS_DOCUMENT_MAPPING'
							AND ACTIVE_FLAG = 'Y'
						) SSLV
					 ON EMD.PLANT_ID = SSLV.PLANT_ID
					AND EMD.STORAGE_ID = SSLV.STORAGE_ID
					AND EMD.MOVEMENT_TYPE = SSLV.MOVEMENT_TYPE
				    AND EMD.PLANT_ID IN (
										  SELECT PLANT_ID
											FROM SCM_PLANT_M S
										   WHERE CONVERT(NVARCHAR(20), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120)	-- 현재 시간
												 BETWEEN (														-- 기준 시간
															SELECT DISTINCT CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
																			LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
															  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
															 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															   AND V.ACTIVE_FLAG = 'Y'
															   AND V.SEGMENT1    = S.PLANT_ID
														 )
													 AND (
															SELECT DISTINCT DATEADD(MI, 60,	-- 2019-10-13 kimcd class 작업 지연으로 60분으로 작업 대기 시간 연장. 기준 시간 30분 후
																					CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
																					LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
																																					 )
															  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
															 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															   AND V.ACTIVE_FLAG = 'Y'
															   AND V.SEGMENT1    = S.PLANT_ID
														 )
										)
			 ORDER BY IFSEQNO;
	    -- 2024-08-29 kimcd AS 출고 정보 수신 작업 추가 종료

		--DECLARE CUR_SCM CURSOR FOR
		--	SELECT [IFSEQNO]
		--		   ,[MAT_DOC_ID]
		--		   ,[MAT_DOC_YEAR]
		--		   ,[MAT_DOC_ITEM]
		--	  FROM SY_XIF_ERP_MATERIAL_DOCUMENT_R EMD
		--	 WHERE EMD.STORAGE_ID  IN (
		--								'6216'	,'6217'	,'6402'	,'6402'	,'6403'	,'6406'	,'6408'	,'6409'	,'6419'	,'6420'	,'6423'	,'6424'	,'6425'	
		--								,'6426'	,'6429'	,'6430'	,'6434'	,'6435'	,'6441'	,'6442'	,'6451'	,'6452'	,'6455'	,'6456'	,'6457'	,'6458'
		--								,'6460'	,'6462'	,'6463'	,'6464'	,'6465'	,'6466'	,'6468'	,'6469'	,'6471'	,'6472'	,'6501'
		--							   ,'A216'	,'A217'	,'A402'	,'A402'	,'A403'	,'A406'	,'A408'	,'A409'	,'A419'	,'A420'	,'A423'	,'A424'	,'A425'	
		--							   ,'A426'	,'A429'	,'A430'	,'A434'	,'A435'	,'A441'	,'A442'	,'A451'	,'A452'	,'A455'	,'A456'	,'A457'	,'A458'	
		--							   ,'A460'	,'A462'	,'A463'	,'A464'	,'A465'	,'A466'	,'A468'	,'A469'	,'A471'	,'A472'	,'A501'
		--							   ,'B216'	,'B217'	,'B402'	,'B402'	,'B403'	,'B406'	,'B408'	,'B409'	,'B419'	,'B420'	,'B423'	,'B424'	,'B425'	
		--							   ,'B426'	,'B429'	,'B430'	,'B434'	,'B435'	,'B441'	,'B442'	,'B451'	,'B452'	,'B455'	,'B456'	,'B457'	,'B458'
		--					   			,'B460'	,'B462'	,'B463'	,'B464'	,'B465'	,'B466'	,'B468'	,'B469'	,'B471'	,'B472'	,'B501'
		--							  )
		--	   AND EMD.PLANT_ID IN (
		--							SELECT PLANT_ID
		--							  FROM SCM_PLANT_M S
		--							 WHERE /*	--2019-09-17 PIYONG DEL
		--									SITE_ID = (
		--												SELECT DISTINCT SITE_ID
		--												FROM DBO.SCM_SITE_M S WITH(NOLOCK)
		--												WHERE SUBSTRING(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120), 12, 2) = (
		--																																		SELECT DISTINCT SUBSTRING(V.SEGMENT2, 1, 2)
		--																																		FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
		--																																				,SCM_FACTORY_M                F  WITH(NOLOCK)
		--																																		WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		--																																			AND V.ACTIVE_FLAG = 'Y'
		--																																			AND V.SEGMENT1    = F.PLANT_ID
		--																																			AND F.SITE_ID     = S.SITE_ID
		--																																		) 
		--											)
		--								   */
		--								   ---------------------------------------------------------------------------------------------------------------------------------------------------------
		--								   --2019-09-17 PIYONG ADD
		--								   CONVERT(NVARCHAR(20), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120)	-- 현재 시간
		--								   BETWEEN (														-- 기준 시간
		--											SELECT DISTINCT CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
		--															LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
		--											  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
		--											 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		--											   AND V.ACTIVE_FLAG = 'Y'
		--											   AND V.SEGMENT1    = S.PLANT_ID
		--										   )
		--									   AND (
		--											SELECT DISTINCT DATEADD(MI, 30,						-- 기준 시간 30분 후
		--																			CONVERT(NVARCHAR(11), [DBO].[FN_SITE_TIME] ( S.SITE_ID ), 120) +
		--																			LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
		--																																			 )
		--											  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
		--											 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		--											   AND V.ACTIVE_FLAG = 'Y'
		--											   AND V.SEGMENT1    = S.PLANT_ID
		--										   )
		--									--2019-09-17 PIYONG ADD END
		--									---------------------------------------------------------------------------------------------------------------------------------------------------------
		--							)
		--	 ORDER BY IFSEQNO
		-- 2024-08-29 kimcd CUR_SCM 커서 주석 처리

		OPEN CUR_MATERIAL;
			
		FETCH NEXT FROM CUR_MATERIAL INTO @IFSEQNO
										  ,@MAT_DOC_ID
										  ,@MAT_DOC_YEAR
										  ,@MAT_DOC_ITEM
										  ,@PLANT_ID  -- 2021-01-04 kimcd key 추가

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				MERGE INTO SCM_FCS_MATERIAL_DOCUMENT_H A
					USING (
							SELECT [IFSEQNO]
									,[MAT_DOC_ID]
									,[MAT_DOC_YEAR]
									,[MAT_DOC_ITEM]
									,[TRADE_TYPE]
									,[DOC_TYPE]
									,[DOC_PROOF_DATE]
									,[DOC_POSTING_DATE]
									,[DOC_INPUT_DATE]
									,[INPUT_DATE]
									,[USER_NAME]
									,EMD.[MOVEMENT_TYPE]
									,[ITEM_ID]
									,EMD.[PLANT_ID]
									,EMD.[STORAGE_ID]
									,[BATCH_ID]
									,[INVENTORY_TYPE]
									,[INDICATOR]
									,[SPECIAL_STOCK_INDICATOR]
									,[SPECIAL_STOCK_INDICATOR_NAME]
									,[VENDOR_CODE]
									,[CUSTOMER_CODE]
									,[CURRENCY]
									,[MAT_AMOUNT]
									,[MAT_QTY]
									,[UOM]
									,[INPUT_QTY]
									,[INPUT_UOM]
									,[COMPANY_ID]
									,[IO_ITEM_ID]
									,[IO_PLANT_ID]
									,[IO_STORAGE_ID]
									,[IO_BATCH_ID]
									,[CREATE_DATE]
									,[CREATE_TIME]
									,[CREATE_USER_ID]
									,[UPDATE_DATE]
									,[UPDATE_TIME]
									,[UPDATE_USER_ID]
							  FROM SY_XIF_ERP_MATERIAL_DOCUMENT_R EMD
							 WHERE [IFSEQNO] = @IFSEQNO
							   AND [MAT_DOC_ID] = @MAT_DOC_ID
							   AND [MAT_DOC_YEAR] = @MAT_DOC_YEAR
							   AND [MAT_DOC_ITEM] = @MAT_DOC_ITEM
							   AND [PLANT_ID]     = @PLANT_ID  -- 2021-01-04 kimcd key 추가
						  ) B
					   ON (
							A.[MAT_DOC_ID] = B.[MAT_DOC_ID]
							AND A.[MAT_DOC_YEAR] = B.[MAT_DOC_YEAR]
							AND A.[MAT_DOC_ITEM] = B.[MAT_DOC_ITEM]
							AND A.[PLANT_ID]     = B.[PLANT_ID] -- 2021-01-04 kimcd key 추가
						  )
					 WHEN MATCHED THEN
							UPDATE SET A.[IFSEQNO]	= B.[IFSEQNO]
									,A.[MAT_DOC_ID]	= B.[MAT_DOC_ID]
									,A.[MAT_DOC_YEAR] = B.[MAT_DOC_YEAR]
									,A.[MAT_DOC_ITEM] = B.[MAT_DOC_ITEM]
									,A.[TRADE_TYPE]	= B.[TRADE_TYPE]
									,A.[DOC_TYPE] = B.[DOC_TYPE]
									,A.[DOC_PROOF_DATE]	= B.[DOC_PROOF_DATE]
									,A.[DOC_POSTING_DATE] = B.[DOC_POSTING_DATE]
									,A.[DOC_INPUT_DATE]	= B.[DOC_INPUT_DATE]
									,A.[INPUT_DATE]	= B.[INPUT_DATE]
									,A.[USER_NAME] = B.[USER_NAME]
									,A.[MOVEMENT_TYPE] = B.[MOVEMENT_TYPE]
									,A.[ITEM_ID] = B.[ITEM_ID]
									-- ,A.[PLANT_ID] = B.[PLANT_ID] -- 2021-01-04 kimcd key 추가
									,A.[STORAGE_ID]	= B.[STORAGE_ID]
									,A.[BATCH_ID] = B.[BATCH_ID]
									,A.[INVENTORY_TYPE]	= B.[INVENTORY_TYPE]
									,A.[INDICATOR] = B.[INDICATOR]
									,A.[SPECIAL_STOCK_INDICATOR] = B.[SPECIAL_STOCK_INDICATOR]
									,A.[SPECIAL_STOCK_INDICATOR_NAME] = B.[SPECIAL_STOCK_INDICATOR_NAME]
									,A.[VENDOR_CODE] = B.[VENDOR_CODE]
									,A.[CUSTOMER_CODE] = B.[CUSTOMER_CODE]
									,A.[CURRENCY] = B.[CURRENCY]
									,A.[MAT_AMOUNT]	= B.[MAT_AMOUNT]
									,A.[MAT_QTY] = B.[MAT_QTY]
									,A.[UOM] = B.[UOM]
									,A.[INPUT_QTY] = B.[INPUT_QTY]
									,A.[INPUT_UOM] = B.[INPUT_UOM]
									,A.[COMPANY_ID]	= B.[COMPANY_ID]
									,A.[IO_ITEM_ID]	= B.[IO_ITEM_ID]
									,A.[IO_PLANT_ID] = B.[IO_PLANT_ID]
									,A.[IO_STORAGE_ID] = B.[IO_STORAGE_ID]
									,A.[IO_BATCH_ID] = B.[IO_BATCH_ID]
									,A.[CREATE_DATE] = B.[CREATE_DATE]
									,A.[CREATE_TIME] = B.[CREATE_TIME]
									,A.[CREATE_USER_ID]	= B.[CREATE_USER_ID]
									,A.[UPDATE_DATE] = B.[UPDATE_DATE]
									,A.[UPDATE_TIME] = B.[UPDATE_TIME]
									,A.[UPDATE_USER_ID]	= B.[UPDATE_USER_ID]
									,A.[TRANSFER_DATE] = GETDATE()
									,A.[TRANSFER_USER_ID] = 'PR_XIF_ERP_MATERIAL_DOCUMENT_R'
					 WHEN NOT MATCHED THEN
						INSERT (
								[IFSEQNO]
								,[MAT_DOC_ID]
								,[MAT_DOC_YEAR]
								,[MAT_DOC_ITEM]
								,[TRADE_TYPE]
								,[DOC_TYPE]
								,[DOC_PROOF_DATE]
								,[DOC_POSTING_DATE]
								,[DOC_INPUT_DATE]
								,[INPUT_DATE]
								,[USER_NAME]
								,[MOVEMENT_TYPE]
								,[ITEM_ID]
								,[PLANT_ID]
								,[STORAGE_ID]
								,[BATCH_ID]
								,[INVENTORY_TYPE]
								,[INDICATOR]
								,[SPECIAL_STOCK_INDICATOR]
								,[SPECIAL_STOCK_INDICATOR_NAME]
								,[VENDOR_CODE]
								,[CUSTOMER_CODE]
								,[CURRENCY]
								,[MAT_AMOUNT]
								,[MAT_QTY]
								,[UOM]
								,[INPUT_QTY]
								,[INPUT_UOM]
								,[COMPANY_ID]
								,[IO_ITEM_ID]
								,[IO_PLANT_ID]
								,[IO_STORAGE_ID]
								,[IO_BATCH_ID]
								,[CREATE_DATE]
								,[CREATE_TIME]
								,[CREATE_USER_ID]
								,[UPDATE_DATE]
								,[UPDATE_TIME]
								,[UPDATE_USER_ID]
								,[TRANSFER_DATE]
								,[TRANSFER_USER_ID]
						) VALUES (
								[IFSEQNO]
								,B.[MAT_DOC_ID]
								,B.[MAT_DOC_YEAR]
								,B.[MAT_DOC_ITEM]
								,B.[TRADE_TYPE]
								,B.[DOC_TYPE]
								,B.[DOC_PROOF_DATE]
								,B.[DOC_POSTING_DATE]
								,B.[DOC_INPUT_DATE]
								,B.[INPUT_DATE]
								,B.[USER_NAME]
								,B.[MOVEMENT_TYPE]
								,B.[ITEM_ID]
								,B.[PLANT_ID]
								,B.[STORAGE_ID]
								,B.[BATCH_ID]
								,B.[INVENTORY_TYPE]
								,B.[INDICATOR]
								,B.[SPECIAL_STOCK_INDICATOR]
								,B.[SPECIAL_STOCK_INDICATOR_NAME]
								,B.[VENDOR_CODE]
								,B.[CUSTOMER_CODE]
								,B.[CURRENCY]
								,B.[MAT_AMOUNT]
								,B.[MAT_QTY]
								,B.[UOM]
								,B.[INPUT_QTY]
								,B.[INPUT_UOM]
								,B.[COMPANY_ID]
								,B.[IO_ITEM_ID]
								,B.[IO_PLANT_ID]
								,B.[IO_STORAGE_ID]
								,B.[IO_BATCH_ID]
								,B.[CREATE_DATE]
								,B.[CREATE_TIME]
								,B.[CREATE_USER_ID]
								,B.[UPDATE_DATE]
								,B.[UPDATE_TIME]
								,B.[UPDATE_USER_ID]
								,GETDATE()
								,'PR_XIF_ERP_MATERIAL_DOCUMENT_R'
						)
				;

				FETCH NEXT FROM CUR_MATERIAL INTO @IFSEQNO
												  ,@MAT_DOC_ID
												  ,@MAT_DOC_YEAR
												  ,@MAT_DOC_ITEM
												  ,@PLANT_ID  -- 2021-01-04 kimcd key 추가

				;

			END

		CLOSE CUR_MATERIAL;
		DEALLOCATE CUR_MATERIAL;

		---------------------------------------------------------------------------------------
		-- 2024-08-29 kimcd AS 출고 정보 수신 작업 추가 시작
		OPEN CUR_AS_MATERIAL;
			
		FETCH NEXT FROM CUR_AS_MATERIAL INTO @IFSEQNO
										    ,@MAT_DOC_ID
										    ,@MAT_DOC_YEAR
										    ,@MAT_DOC_ITEM
										    ,@PLANT_ID;

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				MERGE INTO SCM_AS_MATERIAL_DOCUMENT_H A
					USING (
							SELECT [IFSEQNO]
									,[MAT_DOC_ID]
									,[MAT_DOC_YEAR]
									,[MAT_DOC_ITEM]
									,[TRADE_TYPE]
									,[DOC_TYPE]
									,[DOC_PROOF_DATE]
									,[DOC_POSTING_DATE]
									,[DOC_INPUT_DATE]
									,[INPUT_DATE]
									,[USER_NAME]
									,EMD.[MOVEMENT_TYPE]
									,[ITEM_ID]
									,EMD.[PLANT_ID]
									,EMD.[STORAGE_ID]
									,[BATCH_ID]
									,[INVENTORY_TYPE]
									,[INDICATOR]
									,[SPECIAL_STOCK_INDICATOR]
									,[SPECIAL_STOCK_INDICATOR_NAME]
									,[VENDOR_CODE]
									,[CUSTOMER_CODE]
									,[CURRENCY]
									,[MAT_AMOUNT]
									,[MAT_QTY]
									,[UOM]
									,[INPUT_QTY]
									,[INPUT_UOM]
									,[COMPANY_ID]
									,[IO_ITEM_ID]
									,[IO_PLANT_ID]
									,[IO_STORAGE_ID]
									,[IO_BATCH_ID]
									,[CREATE_DATE]
									,[CREATE_TIME]
									,[CREATE_USER_ID]
									,[UPDATE_DATE]
									,[UPDATE_TIME]
									,[UPDATE_USER_ID]
							  FROM SY_XIF_ERP_MATERIAL_DOCUMENT_R EMD
							 WHERE [IFSEQNO] = @IFSEQNO
							   AND [MAT_DOC_ID] = @MAT_DOC_ID
							   AND [MAT_DOC_YEAR] = @MAT_DOC_YEAR
							   AND [MAT_DOC_ITEM] = @MAT_DOC_ITEM
							   AND [PLANT_ID]     = @PLANT_ID  -- 2021-01-04 kimcd key 추가
						  ) B
					   ON (
							A.[MAT_DOC_ID] = B.[MAT_DOC_ID]
							AND A.[MAT_DOC_YEAR] = B.[MAT_DOC_YEAR]
							AND A.[MAT_DOC_ITEM] = B.[MAT_DOC_ITEM]
							AND A.[PLANT_ID]     = B.[PLANT_ID] -- 2021-01-04 kimcd key 추가
						  )
					 WHEN MATCHED THEN
							UPDATE SET A.[IFSEQNO]	= B.[IFSEQNO]
									,A.[MAT_DOC_ID]	= B.[MAT_DOC_ID]
									,A.[MAT_DOC_YEAR] = B.[MAT_DOC_YEAR]
									,A.[MAT_DOC_ITEM] = B.[MAT_DOC_ITEM]
									,A.[TRADE_TYPE]	= B.[TRADE_TYPE]
									,A.[DOC_TYPE] = B.[DOC_TYPE]
									,A.[DOC_PROOF_DATE]	= B.[DOC_PROOF_DATE]
									,A.[DOC_POSTING_DATE] = B.[DOC_POSTING_DATE]
									,A.[DOC_INPUT_DATE]	= B.[DOC_INPUT_DATE]
									,A.[INPUT_DATE]	= B.[INPUT_DATE]
									,A.[USER_NAME] = B.[USER_NAME]
									,A.[MOVEMENT_TYPE] = B.[MOVEMENT_TYPE]
									,A.[ITEM_ID] = B.[ITEM_ID]
									-- ,A.[PLANT_ID] = B.[PLANT_ID] -- 2021-01-04 kimcd key 추가
									,A.[STORAGE_ID]	= B.[STORAGE_ID]
									,A.[BATCH_ID] = B.[BATCH_ID]
									,A.[INVENTORY_TYPE]	= B.[INVENTORY_TYPE]
									,A.[INDICATOR] = B.[INDICATOR]
									,A.[SPECIAL_STOCK_INDICATOR] = B.[SPECIAL_STOCK_INDICATOR]
									,A.[SPECIAL_STOCK_INDICATOR_NAME] = B.[SPECIAL_STOCK_INDICATOR_NAME]
									,A.[VENDOR_CODE] = B.[VENDOR_CODE]
									,A.[CUSTOMER_CODE] = B.[CUSTOMER_CODE]
									,A.[CURRENCY] = B.[CURRENCY]
									,A.[MAT_AMOUNT]	= B.[MAT_AMOUNT]
									,A.[MAT_QTY] = B.[MAT_QTY]
									,A.[UOM] = B.[UOM]
									,A.[INPUT_QTY] = B.[INPUT_QTY]
									,A.[INPUT_UOM] = B.[INPUT_UOM]
									,A.[COMPANY_ID]	= B.[COMPANY_ID]
									,A.[IO_ITEM_ID]	= B.[IO_ITEM_ID]
									,A.[IO_PLANT_ID] = B.[IO_PLANT_ID]
									,A.[IO_STORAGE_ID] = B.[IO_STORAGE_ID]
									,A.[IO_BATCH_ID] = B.[IO_BATCH_ID]
									,A.[CREATE_DATE] = B.[CREATE_DATE]
									,A.[CREATE_TIME] = B.[CREATE_TIME]
									,A.[CREATE_USER_ID]	= B.[CREATE_USER_ID]
									,A.[UPDATE_DATE] = B.[UPDATE_DATE]
									,A.[UPDATE_TIME] = B.[UPDATE_TIME]
									,A.[UPDATE_USER_ID]	= B.[UPDATE_USER_ID]
									,A.[TRANSFER_DATE] = GETDATE()
									,A.[TRANSFER_USER_ID] = 'PR_XIF_ERP_MATERIAL_DOCUMENT_R'
					 WHEN NOT MATCHED THEN
						INSERT (
								[IFSEQNO]
								,[MAT_DOC_ID]
								,[MAT_DOC_YEAR]
								,[MAT_DOC_ITEM]
								,[TRADE_TYPE]
								,[DOC_TYPE]
								,[DOC_PROOF_DATE]
								,[DOC_POSTING_DATE]
								,[DOC_INPUT_DATE]
								,[INPUT_DATE]
								,[USER_NAME]
								,[MOVEMENT_TYPE]
								,[ITEM_ID]
								,[PLANT_ID]
								,[STORAGE_ID]
								,[BATCH_ID]
								,[INVENTORY_TYPE]
								,[INDICATOR]
								,[SPECIAL_STOCK_INDICATOR]
								,[SPECIAL_STOCK_INDICATOR_NAME]
								,[VENDOR_CODE]
								,[CUSTOMER_CODE]
								,[CURRENCY]
								,[MAT_AMOUNT]
								,[MAT_QTY]
								,[UOM]
								,[INPUT_QTY]
								,[INPUT_UOM]
								,[COMPANY_ID]
								,[IO_ITEM_ID]
								,[IO_PLANT_ID]
								,[IO_STORAGE_ID]
								,[IO_BATCH_ID]
								,[CREATE_DATE]
								,[CREATE_TIME]
								,[CREATE_USER_ID]
								,[UPDATE_DATE]
								,[UPDATE_TIME]
								,[UPDATE_USER_ID]
								,[TRANSFER_DATE]
								,[TRANSFER_USER_ID]
						) VALUES (
								[IFSEQNO]
								,B.[MAT_DOC_ID]
								,B.[MAT_DOC_YEAR]
								,B.[MAT_DOC_ITEM]
								,B.[TRADE_TYPE]
								,B.[DOC_TYPE]
								,B.[DOC_PROOF_DATE]
								,B.[DOC_POSTING_DATE]
								,B.[DOC_INPUT_DATE]
								,B.[INPUT_DATE]
								,B.[USER_NAME]
								,B.[MOVEMENT_TYPE]
								,B.[ITEM_ID]
								,B.[PLANT_ID]
								,B.[STORAGE_ID]
								,B.[BATCH_ID]
								,B.[INVENTORY_TYPE]
								,B.[INDICATOR]
								,B.[SPECIAL_STOCK_INDICATOR]
								,B.[SPECIAL_STOCK_INDICATOR_NAME]
								,B.[VENDOR_CODE]
								,B.[CUSTOMER_CODE]
								,B.[CURRENCY]
								,B.[MAT_AMOUNT]
								,B.[MAT_QTY]
								,B.[UOM]
								,B.[INPUT_QTY]
								,B.[INPUT_UOM]
								,B.[COMPANY_ID]
								,B.[IO_ITEM_ID]
								,B.[IO_PLANT_ID]
								,B.[IO_STORAGE_ID]
								,B.[IO_BATCH_ID]
								,B.[CREATE_DATE]
								,B.[CREATE_TIME]
								,B.[CREATE_USER_ID]
								,B.[UPDATE_DATE]
								,B.[UPDATE_TIME]
								,B.[UPDATE_USER_ID]
								,GETDATE()
								,'PR_XIF_ERP_MATERIAL_DOCUMENT_R'
						)
				;

				FETCH NEXT FROM CUR_AS_MATERIAL INTO @IFSEQNO
												    ,@MAT_DOC_ID
												    ,@MAT_DOC_YEAR
												    ,@MAT_DOC_ITEM
												    ,@PLANT_ID

				;

			END

		CLOSE CUR_AS_MATERIAL;
		DEALLOCATE CUR_AS_MATERIAL;
		-- 2024-08-29 kimcd AS 출고 정보 수신 작업 추가 종료
		---------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------SCP 데이터 -------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------
		--OPEN CUR_SCM;	
		--FETCH NEXT FROM CUR_SCM INTO @IFSEQNO
		--								  ,@MAT_DOC_ID
		--								  ,@MAT_DOC_YEAR
		--								  ,@MAT_DOC_ITEM

		--WHILE (@@FETCH_STATUS = 0)
		--	BEGIN
		--		MERGE INTO [LGCE_SCMPROD].[DBO].[SCM_DNM_MAT_DOCUMENT] A
		--		USING ( 
		--				SELECT MAT_DOC_ID
		--					   ,MAT_DOC_YEAR
		--					   ,MAT_DOC_ITEM
		--					   ,TRADE_TYPE
		--					   ,DOC_TYPE
		--					   ,DOC_PROOF_DATE
		--					   ,DOC_POSTING_DATE
		--					   ,DOC_INPUT_DATE
		--					   ,INPUT_DATE
		--					   ,USER_NAME
		--					   ,MOVEMENT_TYPE
		--					   ,ITEM_ID
		--					   ,PLANT_ID
		--					   ,STORAGE_ID
		--					   ,BATCH_ID
		--					   ,INVENTORY_TYPE
		--					   ,INDICATOR
		--					   ,SPECIAL_STOCK_INDICATOR
		--					   ,SPECIAL_STOCK_INDICATOR_NAME
		--					   ,VENDOR_CODE
		--					   ,CUSTOMER_CODE
		--					   ,CURRENCY
		--					   ,ISNULL(MAT_AMOUNT,0) MAT_AMOUNT
		--					   ,ISNULL(MAT_QTY,0) MAT_QTY
		--					   ,UOM
		--					   ,INPUT_QTY
		--					   ,INPUT_UOM
		--					   ,COMPANY_ID
		--					   ,IO_ITEM_ID
		--					   ,IO_PLANT_ID
		--					   ,IO_STORAGE_ID
		--					   ,IO_BATCH_ID
		--				  FROM [DBO].SY_XIF_ERP_MATERIAL_DOCUMENT_R A WITH(NOLOCK)
		--				 WHERE [IFSEQNO] = @IFSEQNO
		--				   AND [MAT_DOC_ID] = @MAT_DOC_ID
		--				   AND [MAT_DOC_YEAR] = @MAT_DOC_YEAR
		--				   AND [MAT_DOC_ITEM] = @MAT_DOC_ITEM
		--			  ) B
		--		   ON ( 
		--		         A.MAT_DOC_ID				=  B.MAT_DOC_ID
		--				 AND A.MAT_DOC_YEAR			=  B.MAT_DOC_YEAR
		--				 AND A.MAT_DOC_ITEM			=  B.MAT_DOC_ITEM
		--			  )
		--		 WHEN MATCHED THEN
		--			UPDATE SET 		 
		--					A.trade_type					=  B.trade_type
		--					,A.doc_type						=  B.doc_type
		--					,A.doc_proof_date				=  B.doc_proof_date
		--					,A.doc_posting_date				=  B.doc_posting_date
		--					,A.doc_input_date				=  B.doc_input_date
		--					,A.input_date					=  B.input_date
		--					,A.user_name					=  B.user_name
		--					,A.movement_type				=  B.movement_type
		--					,A.item_id						=  B.item_id
		--					,A.plant_id						=  B.plant_id
		--					,A.storage_id					=  B.storage_id
		--					,A.batch_id						=  B.batch_id
		--					,A.inventory_type				=  B.inventory_type
		--					,A.indicator					=  B.indicator
		--					,A.special_stock_indicator		=  B.special_stock_indicator
		--					,A.special_stock_indicator_name =  B.special_stock_indicator_name
		--					,A.vendor_code					=  B.vendor_code
		--					,A.customer_code				=  B.customer_code
		--					,A.currency						=  B.currency
		--					,A.mat_amount					=  B.mat_amount
		--					,A.mat_qty						=  B.mat_qty
		--					,A.uom							=  B.uom
		--					,A.input_qty					=  B.input_qty
		--					,A.input_uom					=  B.input_uom
		--					,A.company_id					=  B.company_id
		--					,A.io_item_id					=  B.io_item_id
		--					,A.io_plant_id					=  B.io_plant_id
		--					,A.io_storage_id				=  B.io_storage_id
		--					,A.io_batch_id					=  B.io_batch_id
		--					,A.last_updated_by				=  'BATCH_MAT_DOC'
		--					,A.last_update_date				=  GETDATE()
		--		 WHEN NOT MATCHED THEN
		--			INSERT (  
		--					mat_doc_id
		--					,mat_doc_year
		--					,mat_doc_item
		--					,trade_type
		--					,doc_type
		--					,doc_proof_date
		--					,doc_posting_date
		--					,doc_input_date
		--					,input_date
		--					,user_name
		--					,movement_type
		--					,item_id
		--					,plant_id
		--					,storage_id
		--					,batch_id
		--					,inventory_type
		--					,indicator
		--					,special_stock_indicator
		--					,special_stock_indicator_name
		--					,vendor_code
		--					,customer_code
		--					,currency
		--					,mat_amount
		--					,mat_qty
		--					,uom
		--					,input_qty
		--					,input_uom
		--					,company_id
		--					,io_item_id
		--					,io_plant_id
		--					,io_storage_id
		--					,io_batch_id
		--					,valid_yn
		--					,created_by
		--					,creation_date
		--					,last_updated_by
		--					,last_update_date						  								
		--			) VALUES (   
		--					B.mat_doc_id
		--					,B.mat_doc_year
		--					,B.mat_doc_item
		--					,B.trade_type
		--					,B.doc_type
		--					,B.doc_proof_date
		--					,B.doc_posting_date
		--					,B.doc_input_date
		--					,B.input_date
		--					,B.user_name
		--					,B.movement_type
		--					,B.item_id
		--					,B.plant_id
		--					,B.storage_id
		--					,B.batch_id
		--					,B.inventory_type
		--					,B.indicator
		--					,B.special_stock_indicator
		--					,B.special_stock_indicator_name
		--					,B.vendor_code
		--					,B.customer_code
		--					,B.currency
		--					,B.mat_amount
		--					,B.mat_qty
		--					,B.uom
		--					,B.input_qty
		--					,B.input_uom
		--					,B.company_id
		--					,B.io_item_id
		--					,B.io_plant_id
		--					,B.io_storage_id
		--					,B.io_batch_id
		--					,'Y'
		--					,'BATCH_MAT_DOC'
		--					,GETDATE()
		--					,'BATCH_MAT_DOC'
		--					,GETDATE() 
		--				)
		--			;

		--			FETCH NEXT FROM CUR_SCM INTO @IFSEQNO
		--										,@MAT_DOC_ID
		--										,@MAT_DOC_YEAR
		--										,@MAT_DOC_ITEM

		--		;

		--	END

		--CLOSE CUR_SCM;
		--DEALLOCATE CUR_SCM;

		------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------SCP 데이터 -------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------

		-- 2020-04-13 kimcd 임시 Backup Table에 정보 넣기 시작
		--INSERT INTO [DBO].[SY_XIF_ERP_MATERIAL_DOCUMENT_R_BK]
		--	(  [IFSEQNO]
		--	  ,[MAT_DOC_ID]
		--	  ,[MAT_DOC_YEAR]
		--	  ,[MAT_DOC_ITEM]
		--	  ,[TRADE_TYPE]
		--	  ,[DOC_TYPE]
		--	  ,[DOC_PROOF_DATE]
		--	  ,[DOC_POSTING_DATE]
		--	  ,[DOC_INPUT_DATE]
		--	  ,[INPUT_DATE]
		--	  ,[USER_NAME]
		--	  ,[MOVEMENT_TYPE]
		--	  ,[ITEM_ID]
		--	  ,[PLANT_ID]
		--	  ,[STORAGE_ID]
		--	  ,[BATCH_ID]
		--	  ,[INVENTORY_TYPE]
		--	  ,[INDICATOR]
		--	  ,[SPECIAL_STOCK_INDICATOR]
		--	  ,[SPECIAL_STOCK_INDICATOR_NAME]
		--	  ,[VENDOR_CODE]
		--	  ,[CUSTOMER_CODE]
		--	  ,[CURRENCY]
		--	  ,[MAT_AMOUNT]
		--	  ,[MAT_QTY]
		--	  ,[UOM]
		--	  ,[INPUT_QTY]
		--	  ,[INPUT_UOM]
		--	  ,[COMPANY_ID]
		--	  ,[IO_ITEM_ID]
		--	  ,[IO_PLANT_ID]
		--	  ,[IO_STORAGE_ID]
		--	  ,[IO_BATCH_ID]
		--	  ,[CREATE_DATE]
		--	  ,[CREATE_TIME]
		--	  ,[CREATE_USER_ID]
		--	  ,[UPDATE_DATE]
		--	  ,[UPDATE_TIME]
		--	  ,[UPDATE_USER_ID]
		--	  ,[TRANSFER_DATE]
		--	  ,[TRANSFER_TIME]
		--	  ,[TRANSFER_USER_ID]
		--	  ,[TRANSFER_FLAG]
		--	  ,[ATTRIBUTE1]
		--	  ,[ATTRIBUTE2]
		--	  ,[ATTRIBUTE3]
		--	  ,[ATTRIBUTE4]
		--	  ,[ATTRIBUTE5]
		--	  ,[ATTRIBUTE6]
		--	  ,[ATTRIBUTE7]
		--	  ,[ATTRIBUTE8]
		--	  ,[ATTRIBUTE9]
		--	  ,[ATTRIBUTE10]
		--	  ,[ATTRIBUTE11]
		--	  ,[ATTRIBUTE12]
		--	  ,[ATTRIBUTE13]
		--	  ,[ATTRIBUTE14]
		--	  ,[ATTRIBUTE15])
		--SELECT [IFSEQNO]
		--	  ,[MAT_DOC_ID]
		--	  ,[MAT_DOC_YEAR]
		--	  ,[MAT_DOC_ITEM]
		--	  ,[TRADE_TYPE]
		--	  ,[DOC_TYPE]
		--	  ,[DOC_PROOF_DATE]
		--	  ,[DOC_POSTING_DATE]
		--	  ,[DOC_INPUT_DATE]
		--	  ,[INPUT_DATE]
		--	  ,[USER_NAME]
		--	  ,[MOVEMENT_TYPE]
		--	  ,[ITEM_ID]
		--	  ,[PLANT_ID]
		--	  ,[STORAGE_ID]
		--	  ,[BATCH_ID]
		--	  ,[INVENTORY_TYPE]
		--	  ,[INDICATOR]
		--	  ,[SPECIAL_STOCK_INDICATOR]
		--	  ,[SPECIAL_STOCK_INDICATOR_NAME]
		--	  ,[VENDOR_CODE]
		--	  ,[CUSTOMER_CODE]
		--	  ,[CURRENCY]
		--	  ,[MAT_AMOUNT]
		--	  ,[MAT_QTY]
		--	  ,[UOM]
		--	  ,[INPUT_QTY]
		--	  ,[INPUT_UOM]
		--	  ,[COMPANY_ID]
		--	  ,[IO_ITEM_ID]
		--	  ,[IO_PLANT_ID]
		--	  ,[IO_STORAGE_ID]
		--	  ,[IO_BATCH_ID]
		--	  ,[CREATE_DATE]
		--	  ,[CREATE_TIME]
		--	  ,[CREATE_USER_ID]
		--	  ,[UPDATE_DATE]
		--	  ,[UPDATE_TIME]
		--	  ,[UPDATE_USER_ID]
		--	  ,[TRANSFER_DATE]
		--	  ,[TRANSFER_TIME]
		--	  ,[TRANSFER_USER_ID]
		--	  ,[TRANSFER_FLAG]
		--	  ,[ATTRIBUTE1]
		--	  ,[ATTRIBUTE2]
		--	  ,[ATTRIBUTE3]
		--	  ,[ATTRIBUTE4]
		--	  ,[ATTRIBUTE5]
		--	  ,[ATTRIBUTE6]
		--	  ,[ATTRIBUTE7]
		--	  ,[ATTRIBUTE8]
		--	  ,[ATTRIBUTE9]
		--	  ,[ATTRIBUTE10]
		--	  ,[ATTRIBUTE11]
		--	  ,[ATTRIBUTE12]
		--	  ,[ATTRIBUTE13]
		--	  ,[ATTRIBUTE14]
		--	  ,[ATTRIBUTE15]
		--  FROM SY_XIF_ERP_MATERIAL_DOCUMENT_R
		-- WHERE ATTRIBUTE1 = 'FP'
		
		-- 2020-04-13 kimcd 임시 Backup Table에 정보 넣기 끝

		-- INTERFACE TABLE 데이터 삭제처리
		DELETE 
		  FROM SY_XIF_ERP_MATERIAL_DOCUMENT_R
		 WHERE ATTRIBUTE1 = 'FP'
		;

		COMMIT WORK;

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', 0, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
	-----------------------------------------------------------------------------------------------------------------------------------------
	END TRY
	-----------------------------------------------------------------------------------------------------------------------------------------

	----------------------------------------------------------------	
	BEGIN CATCH
	----------------------------------------------------------------	
		---- 트랜잭션 (END)

		ROLLBACK TRANSACTION PR_XIF_ERP_MATERIAL_TO_DM_RESULT;

		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
	----------------------------------------------------------------	
	END CATCH;
	----------------------------------------------------------------	


  END;
