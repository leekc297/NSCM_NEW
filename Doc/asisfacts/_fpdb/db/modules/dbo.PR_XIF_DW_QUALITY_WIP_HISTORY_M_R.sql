
CREATE PROCEDURE [dbo].[PR_XIF_DW_QUALITY_WIP_HISTORY_M_R]

-- ================================================================================================
-- Program ID          : FP00871
-- Program Name        : PR_XIF_DW_QUALITY_WIP_HISTORY_M_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_TC_TRAY_R, XIF_DW_TC_TRAY_PROCESS_R, XIF_DW_TT_TRAY_JUDG_RESULT_R, XIF_DW_TM_OP_R
-- Destination Table   : SCM_DAILY_PRODUCT_RESULT_H
--
-- Create Date         : 2020.02.14
-- Update Date         : 

-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 2023-05-08 FP Pjt. 당일실적 제외
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = NULL,
@P_SOURCE_INDEX NVARCHAR(10) = 'OC',
@P_BASE_TIME NVARCHAR(6) = '060000'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_QUALITY_WIP_HISTORY_M_R'
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
			-- 일자별 실적
			MERGE SCM_DAILY_PRODUCT_RESULT_H A
			USING ( 
					SELECT COMPANY_ID
							,DIVISION_ID
							,SITE_ID
							,PLANT_ID
							,FACTORY_ID
   							,TOP_ITEM_ID
							,ITEM_ID
   							,OPERATION_ID	-- WC_TYPE( Grading(511), 특성(581, I11)
   							,'-' AS [LOCATION]
							,'MASS' AS [PRODUCTION_TYPE]
   							,'D' AS [MARKET]
							,LINE_ID
							,'-' AS [ELECTRODE_TYPE]
							,'-' AS [EQUIPMENT_ID]
							,PLAN_DATE
							,SUM( ACTUAL_QTY ) AS ACTUAL_QTY
							,SUM( ACTUAL_SCRAP_QTY ) AS ACTUAL_SCRAP_QTY
							,SUM( ACTUAL_GOOD_QTY ) AS ACTUAL_GOOD_QTY
							,SUM( QTY_LANE ) AS QTY_LANE
							,SUM( QTY ) AS QTY
							,SUM( DFCT_QTY2 ) AS DFCT_QTY2
							,'PR_XIF_DW_QUALITY_WIP_HISTORY_M_R' AS [INSERT_ID]
							,GETDATE() AS [INSERT_TIME]
							,'PR_XIF_DW_QUALITY_WIP_HISTORY_M_R' AS [UPDATE_ID]
							,GETDATE() AS [UPDATE_TIME]
					  FROM (
							SELECT A.COMPANY_ID
									,A.DIVISION_ID
									,A.SITE_ID
									,A.PLANT_ID
									,ISNULL(LM.FACTORY_ID, A.BUILDING ) AS FACTORY_ID
   									,A.MODEL_ID AS TOP_ITEM_ID
									,A.MODEL_ID AS ITEM_ID
   									,CASE WHEN WC_TYPE = '511' THEN 'F4700' ELSE A.FORMATION_FLOW_ID END AS OPERATION_ID	-- WC_TYPE(특성(581) Grading(511)
									,ISNULL(LM.LINE_ID, A.LINE_ID ) AS LINE_ID
									,CONVERT(DATE, OP_END_TIME, 112) AS PLAN_DATE
									,A.INPUT_QTY AS ACTUAL_QTY
									,A.ERR_QTY AS ACTUAL_SCRAP_QTY
									,A.CURR_QTY AS ACTUAL_GOOD_QTY
									,A.CURR_QTY AS QTY_LANE
									,A.CURR_QTY AS QTY
									,A.ERR_QTY AS DFCT_QTY2
							  FROM (
									SELECT F.COMPANY_ID
											,F.DIVISION_ID
											,F.SITE_ID
											,F.PLANT_ID
											,MODEL_ID
											,BUILDING
											,LINE_ID
											,OP_END_TIME
											,SUM(INPUT_QTY) AS INPUT_QTY
											,SUM(ERR_QTY) AS ERR_QTY
											,SUM(CURR_QTY) AS CURR_QTY
											,WC_TYPE
											,FORMATION_FLOW_ID
									  FROM (										
											SELECT [BUILDING]
												   ,[OP_ID] AS WC_TYPE
												   ,LINE_ID
												   ,[PROD_CD] AS MODEL_ID
												   ,[OP_START_TIME] AS OP_END_TIME
												   ,SUM(IN_CELL_CNT ) AS INPUT_QTY
												   ,SUM(NOW_CELL_CNT) AS CURR_QTY
												   ,SUM( ERR_CNT ) AS ERR_QTY
											  FROM (
													SELECT A.[BUILDING]
															,A.[TRAY_NO]
															,A.[ROUTE_ID]
															,A.[OP_ID]
															,A.LINE_ID
															,A.[PROD_CD]
															,A.OP_START_TIME
															,SUM(IN_CELL_CNT ) AS IN_CELL_CNT
															,SUM(NOW_CELL_CNT ) AS NOW_CELL_CNT
															,SUM(GRADE_GOOD_QTY ) AS GRADE_GOOD_QTY	--FCS UI 값
															,SUM( IN_CELL_CNT - NOW_CELL_CNT ) AS ERR_CNT
													  FROM (
															SELECT TP.[BUILDING]
																   ,TP.[TRAY_NO]
																   ,TP.[ROUTE_ID]
																   ,TP.[OP_ID]
																   ,T.LINE_ID
																   ,T.[PROD_CD]
																   ,CASE WHEN SUBSTRING(TP.[OP_START_TIME], 9, 6) <= @P_BASE_TIME THEN
																			CONVERT( NVARCHAR(8), DATEADD(DAY, -1, CONVERT( DATE, SUBSTRING(  TP.[OP_START_TIME], 1,8), 112 ) ), 112 )
																		 ELSE
																			CONVERT( NVARCHAR(8), TP.[OP_START_TIME], 112 )
																		 END AS OP_START_TIME
																   ,CONVERT( INT,JR.IN_CELL_CNT  ) AS IN_CELL_CNT
																   ,CONVERT( INT, JR.NOW_CELL_CNT) AS  NOW_CELL_CNT		--실제관리되는 값
																   ,CONVERT( INT, JR.GRADE_GOOD_QTY) AS GRADE_GOOD_QTY	--FCS UI 값
																   ,CONVERT( INT, JR.GRADE_ERR_QTY) AS  ERR_CNT
															  FROM [SY_XIF_DW_TC_TRAY_PROCESS_R] TP
																   INNER JOIN [SY_XIF_DW_TC_TRAY_R] T
																		   ON ( TP.[SOURCE_INDEX] = T.[SOURCE_INDEX]
																				AND TP.[BUILDING] = T.[BUILDING]
																				AND TP.[TRAY_NO] = T.[TRAY_NO]
																				AND TP.[ROUTE_ID] = T.[ROUTE_ID]
																		--		AND TP.[OP_ID] = T.[OP_ID]				-- 2020-04-07 piyong del
																			 )
																   INNER JOIN [SY_XIF_DW_TT_TRAY_JUDG_RESULT_R] JR
																		   ON ( TP.[SOURCE_INDEX] = JR.[SOURCE_INDEX]
																				AND TP.[BUILDING] = JR.[BUILDING]
																				AND TP.[TRAY_NO] = JR.[TRAY_NO]
																			)
															 WHERE TP.[SOURCE_INDEX] LIKE @P_SOURCE_INDEX+'%'
															   AND TP.[OP_START_TIME] >= CONVERT(NVARCHAR(8), GETDATE()-3, 112) + @P_BASE_TIME
														--	   AND T.[PROD_CD] = 'MCCH120020B1'
   														--	   AND T.LINE_ID = 'C80'
															   AND TP.[OP_ID] IN ( '511', '581' , 'I11' )
														--	   AND TP.[BUILDING] = 'M2'
														   ) A 
													 WHERE A.OP_START_TIME < CONVERT(nvarchar, getdate(), 112)     --1.1 2023-05-08 FP Pjt. 당일실적 제외
													 GROUP BY [BUILDING]
														   ,[TRAY_NO]
														   ,[ROUTE_ID]
														   ,[OP_ID]
														   ,LINE_ID
														   ,[PROD_CD]
														   ,OP_START_TIME
	
												   ) AA
											 GROUP BY [BUILDING]
											--	   ,[ROUTE_ID]
												   ,[OP_ID]
												   ,LINE_ID
												   ,[PROD_CD]
												   ,[OP_START_TIME]
										   ) A
										   INNER JOIN SCM_FACTORY_M F
												   ON A.[BUILDING] = F.FACTORY_ID
										   INNER JOIN (
														SELECT COMPANY_ID
																, DIVISION_ID
																, SITE_ID
																, ITEM_ID
																, FLOW_ID
																, FORMATION_FLOW_ID
														  FROM (
																SELECT COMPANY_ID
																		, DIVISION_ID
																		, SITE_ID
																		, ITEM_ID
																		, FLOW_ID
																		, RIGHT(FORMATION_FLOW_ID, 5) AS FORMATION_FLOW_ID
																   FROM SCM_ITEM_M
																  WHERE FORMATION_FLOW_ID IS NOT NULL
																	AND SITE_ID = @P_SITE_ID
																  GROUP BY COMPANY_ID
																		,DIVISION_ID
																		,SITE_ID
																		,ITEM_ID
																		,FLOW_ID
																		,RIGHT(FORMATION_FLOW_ID, 5)
																) B
													  ) BB
												   ON BB.COMPANY_ID		= F.COMPANY_ID
												  AND BB.DIVISION_ID	= F.DIVISION_ID
												  AND BB.SITE_ID		= F.SITE_ID
												  AND BB.ITEM_ID		= A.MODEL_ID
									 WHERE INPUT_QTY > 0
									 GROUP BY F.COMPANY_ID
											,F.DIVISION_ID
											,F.SITE_ID
											,F.PLANT_ID
											,MODEL_ID
											,BUILDING
											,LINE_ID
											,OP_END_TIME
											,WC_TYPE
											,FORMATION_FLOW_ID
								   ) A
								   INNER JOIN ( 
												SELECT *
												  FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
												 WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
												   AND ACTIVE_FLAG = 'Y'							) SSLV
										   ON (
												A.LINE_ID  = SSLV.SEGMENT2
												AND @P_SITE_ID = SSLV.SEGMENT1
												AND A.BUILDING = SSLV.ATTRIBUTE1
											  )
									LEFT OUTER JOIN (
													 SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
													   FROM SCM_LINE_M
													  WHERE OPERATION_ID LIKE 'F%'
													    AND DIVISION_ID = '40'
													) LM
												 ON (
													 SSLV.SEGMENT5 = LM.LINE_ID
													 AND SSLV.SEGMENT1 = LM.SITE_ID
													)
						   ) AA
					GROUP BY COMPANY_ID
							,DIVISION_ID
							,SITE_ID
							,PLANT_ID
							,FACTORY_ID
   							,TOP_ITEM_ID
							,ITEM_ID
   							,OPERATION_ID
							,LINE_ID
							,PLAN_DATE
				  ) B
			  ON (
					A.[ITEM_ID]				= B.[ITEM_ID]
					AND A.[TOP_ITEM_ID]			= B.[TOP_ITEM_ID]
					AND A.[LINE_ID]				= B.[LINE_ID]
					AND A.[PLAN_DATE]			= B.[PLAN_DATE]
					AND A.[OPERATION_ID]		= B.[OPERATION_ID]
					AND A.[FACTORY_ID]			= B.[FACTORY_ID]
					AND A.[FP_PRODUCTION_TYPE]	= B.[PRODUCTION_TYPE]
				--	AND A.[LOCATION]			= B.[LOCATION]
					AND A.[MARKET]				= B.[MARKET]
					AND A.[EQUIPMENT_ID]		= B.[EQUIPMENT_ID]
					AND A.[ELECTRODE_TYPE]		= B.[ELECTRODE_TYPE]
				)
			 WHEN MATCHED THEN
				UPDATE 
				   SET A.[COMPANY_ID]			= B.COMPANY_ID
						,A.[DIVISION_ID]		= B.[DIVISION_ID]
						,A.[SITE_ID]			= B.[SITE_ID]
						,A.[PLANT_ID]			= B.[PLANT_ID]
						,A.[ACTUAL_QTY]			= B.[ACTUAL_QTY]
						,A.[ACTUAL_GOOD_QTY]	= B.[ACTUAL_GOOD_QTY]
						,A.[ACTUAL_SCRAP_QTY]	= B.[ACTUAL_SCRAP_QTY]
						,A.[QTY_LANE]			= B.[QTY_LANE]
						,A.[QTY]				= B.[QTY]
						,A.[DFCT_QTY2]			= B.[DFCT_QTY2]
						,A.[UPDATE_ID]			= B.[UPDATE_ID]
						,A.[UPDATE_TIME]		= B.[UPDATE_TIME]
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

		--	SET @ROWCOUNT = @@ROWCOUNT
     
			DELETE W
			  FROM SCM_DAILY_PRODUCT_RESULT_H W
			 WHERE W.[SITE_ID]      = @P_SITE_ID
			   AND W.[OPERATION_ID] IN ( 'F4700', 'F5100', 'F5300','F5500','F5600','F6000')
			   AND W.[PLAN_DATE]   >= CAST(DATEADD(DD, -3, GETDATE()) AS DATE)
			   AND W.[UPDATE_TIME]  < CONVERT(DATE, GETDATE()) -- 변경 대상 중에 오늘 변경 안 된 것 삭제
			   AND W.INSERT_ID		= 'PR_XIF_DW_QUALITY_WIP_HISTORY_M_R'


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
