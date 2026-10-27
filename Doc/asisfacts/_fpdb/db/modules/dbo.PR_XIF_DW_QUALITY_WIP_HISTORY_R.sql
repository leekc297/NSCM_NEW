
CREATE PROCEDURE [dbo].[PR_XIF_DW_QUALITY_WIP_HISTORY_R]

-- ================================================================================================
-- Program ID          : FP00871
-- Program Name        : PR_XIF_DW_QUALITY_WIP_HISTORY_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_QUALITY_WIP_HISTORY_R
-- Destination Table   : SCM_QUALITY_RESULT_H
--
-- Create Date         : 2017.11.29
-- Update Date         : 2018.03.13 piyong
--                       2018.03.15 kimcd
--						 2018.04.09 piyong
--						 2018.04.10 piyong	
--						 2018.05.14 PIYONG
--						 2018.06.08 PIYONG
--						 2018.06.12 1.6 PIYONG
--						 2018.07.17 1.7 PIYONG
--						 2018.08.07 1.8 PIYONG
--                       2019.06.22 1.9 kimcd
--						 2019.09.05 1.10 PIYONG
--						 2019.09.09 1.11 PIYONG
--						 2020.06.11 1.12 PIYONG
--						 2020.06.30 1.13 PIYONG
--						 2020.10.16 1.14 KIMCD

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1  SCM_QUALITY_WIP_HISTORY_H 추가
--						      SCM_DAILY_PRODUCT_RESULT_H 추가
--                       1.2  시업 시간 기준으로 일별 취합 로직 변경
--						 1.3  2018-04-09 PIYONG SCM_QUALITY_WIP_HISTORY_H 테이블 주석 처리
--						 1.4  FP_PRODUCTION_TYPE add
--						 1.4  FORMATION_LINE_MAPPING LOOK UP 기준으로 LINE_ID, FACTORY_ID, PLANT_ID 설정
--						 1.5  OP_END_TIME 날짜 계산 로직 삭제
--						 1.6  I/F 테이블 조건 추가하여 데이터 추출
--						 1.7  조건에서 IFSEQNO 제거
--						 1.8  데이터 삭제 조건 추가
--                       1.9  2019-06-22 kimcd scm_item_m 조인 조건에 company_id 추가
--						 1.10 WC_TYPE 추가 D=DEGAS Q=특성
--						 1.11 SCM_DAILY_PRODUCT_RESULT_H 삭제 로직 수정
--						 1.12 PARTITION BY 조건 추가
--						 1.13 삭제 조건 변경
--                       1.14 2020-10-16 KIMCD LOT_TYPE = 2 인 경우 불량 수량을 양산 실적에서 빼준다.
--                       1.15 2023-05-08 FP Pjt. 당일실적 제외
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_QUALITY_WIP_HISTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @COMPANY          NVARCHAR(1000)
	DECLARE @DIVISION         NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)
	DECLARE @ITEM_ID          NVARCHAR(1000)
	DECLARE @PLANT_ID         NVARCHAR(1000)
	DECLARE @PROD_VERSION     NVARCHAR(1000)
	DECLARE @EFF_START_DATE   NVARCHAR(1000)
	DECLARE @EFF_END_DATE     NVARCHAR(1000)
	DECLARE @WORK_CENTER_ID   NVARCHAR(1000)
	DECLARE @LINE_CODE        NVARCHAR(1000)
	DECLARE @OPERATION        NVARCHAR(1000)
	DECLARE @PRIORITY         NVARCHAR(1000)
	DECLARE @VALID_YN         NVARCHAR(1000)
	DECLARE @BOM_VERSION      NVARCHAR(1000)
	DECLARE @V_IFSEQNO	      NVARCHAR(1000)
	DECLARE @TEMP_FACTORY	  TABLE (		-- 2019-09-27 PIYONG ADD
										IFSEQNO		NVARCHAR(150)
										,FACTORY_ID NVARCHAR(30)
									)

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
		SET @V_IFSEQNO = (
						   SELECT MAX(IFSEQNO)
						     FROM [dbo].[SY_XIF_DW_QUALITY_WIP_HISTORY_R]-- WITH(NOLOCK)	-- 2020-01-17 PIYONG NOLOCK DEL
							WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
						 );

		 UPDATE [dbo].[SY_XIF_DW_QUALITY_WIP_HISTORY_R]
			SET TRANSFER_FLAG = 'P'
			   ,TRANSFER_DATE = GETDATE()
		  WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
--		    AND IFSEQNO = @V_IFSEQNO				 --PIYONG 2018-07-17 DEL


		--2018-04-09 주석 처리		  		 
		--2018-03-13 추가
		/*
		MERGE INTO SCM_QUALITY_WIP_HISTORY_H A
		USING ( SELECT *
			     FROM (
						SELECT [WORKDATE]
							  ,[DIVISION_ID]
							  ,[PLANT]
							  ,[BUILDING]
							  ,[LINE_ID]
							  ,[OP_END_TIME]
							  ,[MODEL_ID]
							  ,[TRAY_NO]
							  ,[LOT_NO]
							  ,[LOT_ID]
							  ,[TRAYCNT]
							  ,[INPUT_QTY]
							  ,[ERR_QTY]
							  ,[CURR_QTY]
							  ,ROW_NUMBER() over ( partition by [TRAY_NO], [LOT_NO] order by TRANSFER_DATE desc) ROWUMBER
						 FROM [dbo].[SY_XIF_DW_QUALITY_WIP_HISTORY_R]
						WHERE TRANSFER_FLAG = 'P'
						  AND IFSEQNO = @V_IFSEQNO
					  )  C
				WHERE C.ROWUMBER = 1
			  ) B
		   ON (
				A.[TRAY_NO]  = B.[TRAY_NO]
				AND A.[LOT_NO] = B.[LOT_NO]
			  )
		 WHEN MATCHED THEN
			UPDATE SET A.[WORKDATE]			= B.[WORKDATE]
						,A.[DIVISION_ID]	= B.[DIVISION_ID]
						,A.[PLANT]			= B.[PLANT]
						,A.[BUILDING]		= B.[BUILDING]
						,A.[LINE_ID]		= B.[LINE_ID]
						,A.[OP_END_TIME]	= B.[OP_END_TIME]
						,A.[MODEL_ID]		= B.[MODEL_ID]
						,A.[LOT_ID]			= B.[LOT_ID]
						,A.[TRAYCNT]		= B.[TRAYCNT]
						,A.[INPUT_QTY]		= B.[INPUT_QTY]
						,A.[ERR_QTY]		= B.[ERR_QTY]
						,A.[CURR_QTY]		= B.[CURR_QTY]
		WHEN NOT MATCHED THEN
			INSERT ( 
				[TRAY_NO]
				,[LOT_NO]
				,[WORKDATE]
				,[DIVISION_ID]
				,[PLANT]
				,[BUILDING]
				,[LINE_ID]
				,[OP_END_TIME]
				,[MODEL_ID]  
				,[LOT_ID]
				,[TRAYCNT]
				,[INPUT_QTY]
				,[ERR_QTY]
				,[CURR_QTY]
			) VALUES (
				B.[TRAY_NO]
				,B.[LOT_NO]
				,B.[WORKDATE]
				,B.[DIVISION_ID]
				,B.[PLANT]
				,B.[BUILDING]
				,B.[LINE_ID]
				,B.[OP_END_TIME]
				,B.[MODEL_ID]  
				,B.[LOT_ID]
				,B.[TRAYCNT]
				,B.[INPUT_QTY]
				,B.[ERR_QTY]
				,B.[CURR_QTY]
			)
		;
		*/
		IF @V_IFSEQNO != 'NULL' AND @V_IFSEQNO IS NOT NULL
			BEGIN
				--------------------------------------------------------------------------------------------------
				--2019-09-27 PIYONG ADD
				INSERT INTO @TEMP_FACTORY
				SELECT DISTINCT IFSEQNO , BUILDING
				  FROM [dbo].[SY_XIF_DW_QUALITY_WIP_HISTORY_R]
				 WHERE TRANSFER_FLAG = 'P'
				UNION ALL
				SELECT DISTINCT R.IFSEQNO, L.BUILDING
				 FROM (
						SELECT DISTINCT IFSEQNO , LINE_ID
						  FROM [dbo].[SY_XIF_DW_QUALITY_WIP_HISTORY_R]
						 WHERE TRANSFER_FLAG = 'P'
					  ) R
					  ,(
						SELECT SEGMENT2 AS LINE_ID, ATTRIBUTE2 AS BUILDING
						  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
						 WHERE LOOKUP_TYPE_CODE = 'FORMATION_EXCEPTION_MAPPING'
						   AND ACTIVE_FLAG = 'Y'
					  ) L
				WHERE R.LINE_ID = L.LINE_ID
				--2019-09-27 PIYONG ADD
				--------------------------------------------------------------------------------------------------

				--2018-03-13 추가
				-- 일자별 실적
				MERGE SCM_DAILY_PRODUCT_RESULT_H A
					USING ( 
							SELECT B.COMPANY_ID
								   ,B.DIVISION_ID
								   ,B.SITE_ID
								   ,B.PLANT_ID
								   ,B.FACTORY_ID
   								   ,A.MODEL_ID AS TOP_ITEM_ID
								   ,A.MODEL_ID AS ITEM_ID
   								   ,CASE WHEN WC_TYPE = 'D' THEN 'F4000' ELSE 'F6000' END AS OPERATION_ID		-- 2019-09-05 PIYONG ADD
   								   ,'-' AS [LOCATION]
								   ,'MASS' AS [PRODUCTION_TYPE]
   								   ,'D' AS [MARKET]
								   ,A.LINE_ID
								   ,'-' AS [ELECTRODE_TYPE]
								   ,'-' AS [EQUIPMENT_ID]
								   ,CONVERT(DATE, OP_END_TIME, 112) AS PLAN_DATE
								   ,A.INPUT_QTY AS ACTUAL_QTY
								   ,A.ERR_QTY AS ACTUAL_SCRAP_QTY
								   ,A.CURR_QTY AS ACTUAL_GOOD_QTY
								   ,A.CURR_QTY AS QTY_LANE
								   ,A.CURR_QTY AS QTY
								   ,A.ERR_QTY AS DFCT_QTY2
								   ,'PR_XIF_DW_QUALITY_WIP_HISTORY_R' AS [INSERT_ID]
								   ,GETDATE() AS [INSERT_TIME]
								   ,'PR_XIF_DW_QUALITY_WIP_HISTORY_R' AS [UPDATE_ID]
								   ,GETDATE() AS [UPDATE_TIME]
							  FROM (
/*									--2019-09-27 PIYONG DEL 중복 데이터으로 인한 로직 변경

									 SELECT C.MODEL_ID
											,BUILDING
											,LINE_ID
											,OP_END_TIME
											,SUM(INPUT_QTY) AS INPUT_QTY
											,SUM(ERR_QTY) AS ERR_QTY
											,SUM(CURR_QTY) AS CURR_QTY
											,WC_TYPE							-- 2019-09-05 PIYONG ADD
									   FROM (
											 SELECT (SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE [FACTORY_ID] =  ISNULL(LM.FACTORY_ID, A.[BUILDING]) ) AS [PLANT]
													,ISNULL(LM.FACTORY_ID, A.[BUILDING]) AS BUILDING 
													,ISNULL(LM.[LINE_ID], A.LINE_ID ) AS LINE_ID
													--2018-06-08 PIYONG 날짜 로직 삭제
													/*
													,CASE WHEN SUBSTRING(A.[OP_END_TIME],1,8) + SLV.SEGMENT2 > A.OP_END_TIME THEN
														DATEADD(DD,-1,CONVERT(DATE, SUBSTRING(A.[OP_END_TIME],1,8), 112) )
														ELSE
														CONVERT(DATE, SUBSTRING(A.[OP_END_TIME],1,8), 112)
														END AS OP_END_TIME
													*/
													,A.[OP_END_TIME]
													,A.[MODEL_ID]
													,A.[LOT_ID]
													,A.[INPUT_QTY]
													,A.[ERR_QTY]
													,A.[CURR_QTY]
												  --,SLV.[SEGMENT2]			--2018-06-08 PIYONG DEL
												    ,WC_TYPE					-- 2019-09-05 PIYONG ADD
											   FROM (
													---------------------------------------------------------------------------------
													--2018-06-12 PIYONG ADD  GROUP BY 추가  
													 SELECT (SELECT TOP 1 SITE_ID FROM SCM_PLANT_M WHERE PLANT_ID =  PLANT) AS SITE_ID
															,[PLANT]
															,[BUILDING]
															,MAX([INPUT_QTY]) AS  [INPUT_QTY]
															,SUM([ERR_QTY]) AS [ERR_QTY]
															,MAX([CURR_QTY]) AS [CURR_QTY]
															,[OP_END_TIME]
															,LINE_ID
															,FORM_LINE_ID
															,MODEL_ID
															,SHIFT
															,LOT_ID
															,WC_TYPE							-- 2019-09-05 PIYONG ADD
													   FROM (
															  SELECT [DIVISION_ID]
																	 ,[PLANT]
																	 ,[BUILDING]
																	 ,[LINE_ID]
																	 ,[OP_END_TIME]
																	 ,[MODEL_ID]
																	 ,[LOT_ID]
																	 ,[INPUT_QTY]
																	 ,[ERR_QTY]
																	 ,[CURR_QTY]
																	 ,[FORM_LINE_ID]	--2018-06-12 PIYONG ADD
																	 ,[SHIFT]			--2018-06-12 PIYONG ADD
																	 ,[LOT_TYPE]		--2018-06-12 PIYONG ADD
																	 ,[TR_TYPE]			--2018-06-12 PIYONG ADD
																	 ,LOT_COMMENT
																	 ,WC_TYPE			-- 2019-09-05 PIYONG ADD
																	 ,ROW_NUMBER() OVER(PARTITION BY OP_END_TIME, LINE_ID, FORM_LINE_ID, MODEL_ID, SHIFT, LOT_ID, LOT_TYPE, LOSS_CODE,
																									 LOT_COMMENT, WC_TYPE				-- 2019-09-05 PIYONG ADD
																							ORDER BY UPD_TIME DESC, TR_TYPE ) NUM		--2018-06-12 PIYONG ADD 최종 변경된 데이터 추출
																FROM SY_XIF_DW_QUALITY_WIP_HISTORY_R
															   WHERE TRANSFER_FLAG = 'P'
												  --		     AND IFSEQNO = @V_IFSEQNO				 --PIYONG 2018-07-17 DEL

															) A 
													  WHERE NUM =1
														AND ISNULL(TR_TYPE, 'I') != 'D'				--2018-06-12 PIYONG ADD  입력, 수정된 데이터만 추출
													  ---------------------------------------------------------------------------------
													  --2018-06-12 PIYONG ADD  GROUP BY 추가  
													  GROUP BY [PLANT]
															,[BUILDING]
															,[OP_END_TIME]
															,LINE_ID
															,FORM_LINE_ID
															,MODEL_ID
															,SHIFT
															,LOT_ID
															,LOT_COMMENT
														---------------------------------------------------------------------------------
															,WC_TYPE								-- 2019-09-05 PIYONG ADD
													) A
													,SCM_SYS_LOOKUP_VALUE      SLV WITH(NOLOCK)
											-- 2018-05-14 PIYONG ADD
													,(SELECT *
														FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
													   WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
														 AND ACTIVE_FLAG = 'Y'		) SSLV
													LEFT OUTER JOIN (SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																	   FROM SCM_LINE_M
																	  WHERE OPERATION_ID = 'F6000'
																		AND ACTIVE_FLAG = 'Y'
																	) LM
																 ON SSLV.SEGMENT5 = LM.LINE_ID
																AND SSLV.SEGMENT1 = LM.SITE_ID
											  -- 2018-05-14 PIYONG ADD 끝
											  WHERE A.OP_END_TIME       >= CONVERT( nvarchar(10), GETDATE()-30, 112)	 --  2018-04-10 PIYONG -2에서 -30일로 변경
											  AND   SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											  AND   SLV.SEGMENT1         = A.[PLANT]
											  AND   SLV.ACTIVE_FLAG      = 'Y' 
											  AND   A.LINE_ID  = SSLV.SEGMENT2
											  AND   A.SITE_ID = SSLV.SEGMENT1
											) A  -- 2018-03-15 kimcd 시업 시간 기준으로 조회문 수정
											,FP_MODEL_LOT_M C WITH(NOLOCK)
									  WHERE A.MODEL_ID = C.MODEL_LOT_ID
										AND A.BUILDING = C.FACTORY_ID
										AND A.PLANT = C.PLANT_ID
									  GROUP BY C.MODEL_ID
											,BUILDING
											,LINE_ID
											,OP_END_TIME
											,WC_TYPE						-- 2019-09-05 PIYONG ADD
*/
									----------------------------------------------------------------------------------------------------------------------------
									--2019-09-27 PIYONG ADD
									   SELECT MODEL_ID
											  ,BUILDING
											  ,LINE_ID
											  ,OP_END_TIME
											  ,SUM(INPUT_QTY) AS INPUT_QTY
											  ,SUM(ERR_QTY) AS ERR_QTY
											  ,SUM(CURR_QTY) - ISNULL(SUM(GOOD_REWORK_ERR_QTY),0) AS CURR_QTY  -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량을 양품 수량에서 뺌 
											  ,WC_TYPE
									     FROM (
											   SELECT [BUILDING]
													  ,MAX([INPUT_QTY]) AS  [INPUT_QTY]
													  ,SUM([ERR_QTY]) AS [ERR_QTY]
													  ,MAX(CASE WHEN LOT_TYPE = 2 THEN 0 ELSE [CURR_QTY] END) AS [CURR_QTY]  -- 2020-10-16 kimcd 양품 재작업 양품 실적 수량에서 제외
													  ,[OP_END_TIME]
													  ,LINE_ID
													  ,MODEL_ID
													  ,WC_TYPE							-- 2019-09-05 PIYONG ADD
													  ,[LOT_ID]
													  ,[SHIFT]
													  ,SUM(CASE WHEN LOT_TYPE = 2 THEN ERR_QTY ELSE 0 END) AS GOOD_REWORK_ERR_QTY -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량 합 
											     FROM (
														SELECT C.MODEL_ID
																,PLANT
																,BUILDING
																,LINE_ID
																,[OP_END_TIME]
																,[LOT_ID]
																,[INPUT_QTY]
																,[ERR_QTY]
																,[CURR_QTY]
																,[FORM_LINE_ID]
																,[SHIFT]
																,[LOT_TYPE]
																,[TR_TYPE]
																,LOT_COMMENT
																,WC_TYPE
																,LOSS_CODE
																,UPD_TIME
																,IFSEQNO
																,ROW_NUMBER() OVER(PARTITION BY C.MODEL_ID, OP_END_TIME, LINE_ID, FORM_LINE_ID, A.MODEL_ID, SHIFT, LOT_ID, LOT_TYPE, LOSS_CODE,
																								LOT_COMMENT, WC_TYPE				-- 2019-09-05 PIYONG ADD -- 2020-06-11 PIYONG ADD C.MODEL_ID
																						ORDER BY UPD_TIME DESC, TR_TYPE ) NUM		--2018-06-12 PIYONG ADD 최종 변경된 데이터 추출
														   FROM (
																	SELECT (SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE [FACTORY_ID] =  ISNULL(LM.FACTORY_ID, A.[BUILDING]) ) AS [PLANT]
																			,ISNULL(LM.FACTORY_ID, A.[BUILDING]) AS BUILDING 
																			,ISNULL(LM.[LINE_ID], A.LINE_ID ) AS LINE_ID
																			,[OP_END_TIME]
																			,[MODEL_ID]
																			,[LOT_ID]
																			,[INPUT_QTY]
																			,[ERR_QTY]
																			,[CURR_QTY]
																			,[FORM_LINE_ID]
																			,[SHIFT]
																			,[LOT_TYPE]
																			,[TR_TYPE]
																			,LOT_COMMENT
																			,WC_TYPE
																			,LOSS_CODE
																			,UPD_TIME
																			,IFSEQNO
																	  FROM (
																				---------------------------------------------------------------------------------
																				--2018-06-12 PIYONG ADD  GROUP BY 추가  
																			SELECT (SELECT TOP 1 F.SITE_ID FROM SCM_FACTORY_M F WITH(NOLOCK) WHERE F.FACTORY_ID =  BUILDING ) AS SITE_ID   -- 2024-12-31 김춘동 PLANT ID 이슈 처리
																					, [DIVISION_ID]
																					,[PLANT]
																					,[BUILDING]
																					,[LINE_ID]
																					,[OP_END_TIME]
																					,[MODEL_ID]
																					,[LOT_ID]
																					,[INPUT_QTY]
																					,[ERR_QTY]
																					,[CURR_QTY]
																					,[FORM_LINE_ID]	--2018-06-12 PIYONG ADD
																					,[SHIFT]			--2018-06-12 PIYONG ADD
																					,[LOT_TYPE]		--2018-06-12 PIYONG ADD
																					,[TR_TYPE]			--2018-06-12 PIYONG ADD
																					,LOT_COMMENT
																					,WC_TYPE			-- 2019-09-05 PIYONG ADD
																					,LOSS_CODE
																					,UPD_TIME
																					,IFSEQNO
																			   FROM SY_XIF_DW_QUALITY_WIP_HISTORY_R WITH (INDEX=IDX_XIF_DW_QUALITY_WIP_HISTORY_R)
																			  WHERE 1=1 --IFSEQNO       = @V_IFSEQNO	 --PIYONG 2018-07-17 DEL
																				AND TRANSFER_FLAG = 'P'
																				AND OP_END_TIME < convert(nvarchar,  getdate(), 112)  --2023-05-08, 당일 실적 제외
																			--	AND MODEL_ID ='YR1'
																			--	AND [OP_END_TIME] = '20190902'
																			--	AND LOT_ID ='YR1SH031'
																		) A
																		-- 2018-05-14 PIYONG ADD
																		LEFT OUTER JOIN (SELECT *
																							FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
																							WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
																							AND ACTIVE_FLAG = 'Y'		) SSLV
																						ON A.LINE_ID = SSLV.SEGMENT2
																					AND A.SITE_ID = SSLV.SEGMENT1
																					AND A.BUILDING = SSLV.ATTRIBUTE1
																		LEFT OUTER JOIN (SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																							FROM SCM_LINE_M
																							WHERE OPERATION_ID IN ( 'F4000', 'F6000')
																							AND ACTIVE_FLAG = 'Y'
																						) LM
																						ON SSLV.SEGMENT5 = LM.LINE_ID
																					AND SSLV.SEGMENT1 = LM.SITE_ID
																	WHERE A.OP_END_TIME >= CONVERT( nvarchar(10), GETDATE()-30, 112)	 --  2018-04-10 PIYONG -2에서 -30일로 변경
																) A
																,FP_MODEL_LOT_M C WITH(NOLOCK)
															WHERE A.MODEL_ID = C.MODEL_LOT_ID
															AND A.BUILDING = C.FACTORY_ID
															AND A.PLANT = C.PLANT_ID
															AND FACTORY_ID IN ( SELECT FACTORY_ID FROM @TEMP_FACTORY WHERE IFSEQNO = A.IFSEQNO )		--2019-09-27 PIYONG ADD
														) R
												WHERE NUM =1
													AND ISNULL(TR_TYPE, 'I') != 'D'		
												GROUP BY  [PLANT]
															,[BUILDING]
															,[OP_END_TIME]
															,LINE_ID
															,FORM_LINE_ID
															,MODEL_ID
															,SHIFT
															,LOT_ID
															,LOT_COMMENT
															,WC_TYPE
											
																	 
											)A
									  WHERE INPUT_QTY > 0 
									  GROUP BY MODEL_ID
											,BUILDING
											,LINE_ID
											,OP_END_TIME
											,WC_TYPE
								    ) A
									,SCM_FACTORY_M  B
									,SCM_ITEM_M M
								WHERE 1=1
								  AND A.BUILDING = B.FACTORY_ID
								  AND A.MODEL_ID = M.ITEM_ID
								  AND B.DIVISION_ID = M.DIVISION_ID
								  AND B.SITE_ID = M.SITE_ID
								  AND B.COMPANY_ID = M.COMPANY_ID -- 2019-06-22 kimcd 조인 조건에 company_id 추가
								--2019-09-27 PIYONG ADD
								----------------------------------------------------------------------------------------------------------------------------


						  ) B
					   ON ( A.[FACTORY_ID] = B.[FACTORY_ID]
							AND A.[LINE_ID] = B.[LINE_ID]
							AND A.[PLAN_DATE] = B.[PLAN_DATE]
							AND A.[OPERATION_ID] = B.[OPERATION_ID]
							AND A.[TOP_ITEM_ID] = B.[TOP_ITEM_ID]
							AND A.[ITEM_ID] = B.[ITEM_ID]
							AND A.[FP_PRODUCTION_TYPE] = B.[PRODUCTION_TYPE]
							AND A.[LOCATION] = B.[LOCATION]
							AND A.[MARKET] = B.[MARKET]
							AND A.[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
							AND A.[EQUIPMENT_ID] = B.[EQUIPMENT_ID]
						  )
					 WHEN MATCHED THEN
						UPDATE 
						   SET A.[COMPANY_ID]		 = B.COMPANY_ID
							   ,A.[DIVISION_ID]		 = B.[DIVISION_ID]
							   ,A.[SITE_ID]			 = B.[SITE_ID]
							   ,A.[PLANT_ID]		 = B.[PLANT_ID]
							   ,A.[ACTUAL_QTY]		 = B.[ACTUAL_QTY]
							   ,A.[ACTUAL_GOOD_QTY]	 = B.[ACTUAL_GOOD_QTY]
							   ,A.[ACTUAL_SCRAP_QTY] = B.[ACTUAL_SCRAP_QTY]
							   ,A.[QTY_LANE]		 = B.[QTY_LANE]
							   ,A.[QTY]				 = B.[QTY]
							   ,A.[DFCT_QTY2]		 = B.[DFCT_QTY2]
							   ,A.[UPDATE_ID]		 = B.[UPDATE_ID]
							   ,A.[UPDATE_TIME]		 = B.[UPDATE_TIME]
					 WHEN NOT MATCHED THEN
						INSERT (
						  [COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[FACTORY_ID]
						  ,[TOP_ITEM_ID]
						  ,[ITEM_ID]
						  ,[OPERATION_ID]
						  ,[LOCATION]
						  ,[PRODUCTION_TYPE]
						  ,[MARKET]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
						  ,[PLAN_DATE]
						  ,[ACTUAL_QTY]
						  ,[ACTUAL_GOOD_QTY]
						  ,[ACTUAL_SCRAP_QTY]
						  ,[QTY_LANE]
						  ,[QTY]
						  ,[DFCT_QTY2]
						  ,[FP_PRODUCTION_TYPE]	--2018-04-10 piyong add
						  ,[EQUIPMENT_ID]
						  ,[INSERT_ID]
						  ,[INSERT_TIME]
						  ,[UPDATE_ID]
						  ,[UPDATE_TIME]
						) VALUES (
						  B.[COMPANY_ID]
						  ,B.[DIVISION_ID]
						  ,B.[SITE_ID]
						  ,B.[PLANT_ID]
						  ,B.[FACTORY_ID]
						  ,B.[TOP_ITEM_ID]
						  ,B.[ITEM_ID]
						  ,B.[OPERATION_ID]
						  ,B.[LOCATION]
						  ,B.[PRODUCTION_TYPE]
						  ,B.[MARKET]
						  ,B.[LINE_ID]
						  ,B.[ELECTRODE_TYPE]
						  ,B.[PLAN_DATE]
						  ,B.[ACTUAL_QTY]
						  ,B.[ACTUAL_GOOD_QTY]
						  ,B.[ACTUAL_SCRAP_QTY]
						  ,B.[QTY_LANE]
						  ,B.[QTY]
						  ,B.[DFCT_QTY2]
						  ,B.[PRODUCTION_TYPE]	--2018-04-10 piyong add
						  ,B.[EQUIPMENT_ID]
						  ,B.[INSERT_ID]
						  ,B.[INSERT_TIME]
						  ,B.[UPDATE_ID]
						  ,B.[UPDATE_TIME]
						)
					;
					;

				SET @ROWCOUNT = @@ROWCOUNT
     
				DELETE W
				  FROM SCM_DAILY_PRODUCT_RESULT_H W
				 WHERE W.[SITE_ID]      = @P_SITE_ID
				   AND W.[OPERATION_ID] IN ( 'F4000', 'F6000')						--2019-09-09 PIYONG DEGAS ADD
				   AND W.[PLAN_DATE]   >= CASE WHEN W.FACTORY_ID = 'S3' AND CAST(DATEADD(DD, 29, '20200629' ) AS DATE) >= GETDATE() THEN  -- 2020-06-30 PIYONG CHANGE RDB 전환으로 데이터가 06월 29일 부터 있음
												'20200629'
											   ELSE
												CAST(DATEADD(DD, -29, GETDATE()) AS DATE)
											   END
				   AND W.[UPDATE_TIME]  < CONVERT(DATE, GETDATE()) -- 변경 대상 중에 오늘 변경 안 된 것 삭제
				   AND W.INSERT_ID		= 'PR_XIF_DW_QUALITY_WIP_HISTORY_R'			-- 2018-08-07 PIYONG ADD
			END;

		UPDATE [dbo].[SY_XIF_DW_QUALITY_WIP_HISTORY_R]
		   SET TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = getdate()
		 WHERE TRANSFER_FLAG = 'P'
--		    AND IFSEQNO = @V_IFSEQNO				 --PIYONG 2018-07-17 DEL
		;

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END


