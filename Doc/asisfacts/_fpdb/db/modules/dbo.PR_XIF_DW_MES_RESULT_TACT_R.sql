
CREATE PROCEDURE [dbo].[PR_XIF_DW_MES_RESULT_TACT_R]

-- ================================================================================================
-- Program ID          : FP02432
-- Program Name        : PR_XIF_DW_MES_RESULT_TACT_R
-- Param               :
-- Batch Period        : 각 법인별 시업 시간 + 1
-- Description         :
--
-- Source System       : DW
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_MES_RESULT_TACT_R
-- Destination Table   : FP_RESULT_TACT_H, SCM_TACT_TIME_H
--
-- Create Date		   : 2021.10.15
-- Update Date		   : 2022.03.30

-- Author              : kimcd
-- Version             : 1.0 2021-10-15 kimcd A9000 공정만 실적 Tact Time 입수
--                       1.1 2022-03-30 kimcd JV용 가상 Division 로직 반영
-- ================================================================================================
-- PARAMETER
 @P_SITE_ID  NVARCHAR(50) = NULL
,@P_BASIS_START_TIME  NVARCHAR(6) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_MES_RESULT_TACT_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


	--변수
	DECLARE @V_SITE_ID            NVARCHAR(50) = @P_SITE_ID
	DECLARE @V_BASIS_START_TIME   NVARCHAR(50) = @P_BASIS_START_TIME
	DECLARE @MONTH                NVARCHAR(10)
	DECLARE @FROM_DATE            DATETIME
	DECLARE @TO_DATE              DATETIME
	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY

		-- ================================================
		-- 로직 추가
		-- ================================================
		UPDATE [dbo].[SY_XIF_DW_MES_RESULT_TACT_R]
		SET    PROC_FLAG = 'P'
		WHERE  PROC_FLAG = 'N'

		---------------------------------------------------------------------------------------------------------------------------------------------------------
		--2019-10-08 PIYONG ADD
		MERGE INTO [FP_RESULT_TACT_H] H
		USING (	SELECT   R.[COMPANY_ID]
						,R.[DIVISION_ID]
						,R.[SITE_ID]
						,R.[PLANT_ID]
						,R.[FACTORY_ID]
						,R.TOP_ITEM_ID
						,R.ITEM_ID
						,R.[OPERATION_ID]
						,R.[MES_LINE_ID]
						,R.[EQUIPMENT_ID]
						,R.PLAN_DATE
						,R.[CAL_TACT_TIME_AVG]
						,R.[TACT_LOGIC_AVG]
						,R.[EQPT_STD_VELOCITY]
						,R.[EQPT_SPEED_UNIT]
						,R.[EQPT_STD_SEC]
						,R.[NOTCH_CAVITY]
						,R.[MBOM_CELL_QTY]
						,R.[JUMBO_ROLL]
						,R.[PITCH]
						,R.[LANE_QTY]
						,R.[INPUT_QTY]
						,R.PCK_SLOW_YN
						,R.[PART_AREA_ID]
				FROM ( SELECT    E.[COMPANY_ID]
								,E.[DIVISION_ID]
								,RT.[SITE_ID]
								,E.[PLANT_ID]
								,E.[FACTORY_ID]
								,RT.[MODEL_ID] AS TOP_ITEM_ID
								,RT.[PROD_ID]  AS ITEM_ID
								,RT.[OPERATION_ID]
								,E.[MES_LINE_ID]
								,RT.[EQUIPMENT_ID]
								,CONVERT(DATETIME, RT.[WORK_DATE], 112)  AS PLAN_DATE
								,RT.[CAL_TACT_TIME_AVG]
								,RT.[TACT_LOGIC_AVG]
								,RT.[EQPT_STD_VELOCITY]
								,RT.[EQPT_SPEED_UNIT]
								,RT.[EQPT_STD_SEC]
								,RT.[NOTCH_CAVITY]
								,RT.[MBOM_CELL_QTY]
								,RT.[JUMBO_ROLL]
								,RT.[PITCH]
								,RT.[LANE_QTY]
								,RT.[INPUT_QTY]
								,ISNULL(RT.[PCK_SLOW_YN], 'Y') AS PCK_SLOW_YN
								,RT.[PART_AREA_ID]
								,ROW_NUMBER() OVER (PARTITION BY RT.[EQUIPMENT_ID],RT.[PROD_ID],RT.[WORK_DATE],RT.[OPERATION_ID],RT.[MODEL_ID],E.[MES_LINE_ID],E.[FACTORY_ID] ORDER BY RT.[IF_SEQ] DESC) AS ROW_NUM
						FROM  [SY_XIF_DW_MES_RESULT_TACT_R] RT (NOLOCK)
							 ,[SCM_EQUIPMENT_M]             E  (NOLOCK)
						WHERE RT.[SITE_ID]      = E.[SITE_ID]
						AND   RT.[EQUIPMENT_ID] = E.[EQUIPMENT_ID]
						AND   RT.[OPERATION_ID] = E.[OPERATION_ID]
						AND   RT.[PROC_FLAG]    = 'P'
						AND   RT.[OPERATION_ID] = 'A9000' -- 실적 Tact Time에서 사용 가능한 정보는 A9000 공정만임.
						) R
				WHERE R.ROW_NUM = 1
				) R
		ON ( H.[EQUIPMENT_ID]     = R.[EQUIPMENT_ID]
				AND H.[ITEM_ID]      = R.[ITEM_ID]
				AND H.[PLAN_DATE]    = R.[PLAN_DATE]
				AND H.[OPERATION_ID] = R.[OPERATION_ID]
				AND H.[TOP_ITEM_ID]  = R.[TOP_ITEM_ID]
				AND H.[LINE_ID]      = R.[MES_LINE_ID]
				AND H.[FACTORY_ID]   = R.[FACTORY_ID] )
		WHEN MATCHED THEN
			UPDATE
			SET [CAL_TACT_TIME_AVG]  = R.[CAL_TACT_TIME_AVG],
				[TACT_LOGIC_AVG]     = R.[TACT_LOGIC_AVG],
				[EQPT_STD_VELOCITY]  = R.[EQPT_STD_VELOCITY],
				[EQPT_SPEED_UNIT]    = R.[EQPT_SPEED_UNIT],
				[EQPT_STD_SEC]       = R.[EQPT_STD_SEC],
				[NOTCH_CAVITY]       = R.[NOTCH_CAVITY],
				[MBOM_CELL_QTY]      = R.[MBOM_CELL_QTY],
				[JUMBO_ROLL]         = R.[JUMBO_ROLL],
				[PITCH]              = R.[PITCH],
				[LANE_QTY]           = R.[LANE_QTY],
				[INPUT_QTY]          = R.[INPUT_QTY],
				[PCK_SLOW_YN]        = R.[PCK_SLOW_YN],
				[PART_AREA_ID]       = R.[PART_AREA_ID],
				[UPDATE_ID]          = @v_proc_name,
				[UPDATE_TIME]        = GETDATE()
		WHEN NOT MATCHED THEN
			INSERT ([COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[TOP_ITEM_ID],
					[ITEM_ID],
					[OPERATION_ID],
					[LINE_ID],
					[EQUIPMENT_ID],
					[PLAN_DATE],
					[CAL_TACT_TIME_AVG],
					[TACT_LOGIC_AVG],
					[EQPT_STD_VELOCITY],
					[EQPT_SPEED_UNIT],
					[EQPT_STD_SEC],
					[NOTCH_CAVITY],
					[MBOM_CELL_QTY],
					[JUMBO_ROLL],
					[PITCH],
					[LANE_QTY],
					[INPUT_QTY],
					[PCK_SLOW_YN],
					[PART_AREA_ID],
					[INSERT_ID],
					[INSERT_TIME],
					[UPDATE_ID],
					[UPDATE_TIME])
			VALUES ([COMPANY_ID],
					[DIVISION_ID],
					[SITE_ID],
					[PLANT_ID],
					[FACTORY_ID],
					[TOP_ITEM_ID],
					[ITEM_ID],
					[OPERATION_ID],
					[MES_LINE_ID],
					[EQUIPMENT_ID],
					[PLAN_DATE],
					[CAL_TACT_TIME_AVG],
					[TACT_LOGIC_AVG],
					[EQPT_STD_VELOCITY],
					[EQPT_SPEED_UNIT],
					[EQPT_STD_SEC],
					[NOTCH_CAVITY],
					[MBOM_CELL_QTY],
					[JUMBO_ROLL],
					[PITCH],
					[LANE_QTY],
					[INPUT_QTY],
					[PCK_SLOW_YN],
					[PART_AREA_ID],
					@v_proc_name,
					GETDATE(),
					@v_proc_name,
					GETDATE()) ;

		UPDATE [dbo].[SY_XIF_DW_MES_RESULT_TACT_R]
		SET    PROC_FLAG = 'Y',
			   PROC_DATE = GETDATE()
		WHERE  PROC_FLAG = 'P';

			-- 매월 5일~10일에만 실행
			IF '5' <= DAY(GETDATE()) -- AND 10 >= DAY(GETDATE()) 
				BEGIN
					SELECT @MONTH     = LEFT(CONVERT(NVARCHAR,DATEADD(m,-1, GETDATE()),112), 6),
						   @FROM_DATE = LEFT(CONVERT(NVARCHAR,DATEADD(m,-1, GETDATE()),121), 7) + '-01',
						   @TO_DATE   = CONVERT(VARCHAR(10),DATEADD(S, -1, DATEADD(MM, DATEDIFF(M, 0, GETDATE()), 0)),121)


					MERGE INTO [dbo].[SCM_TACT_TIME_M] TM
					USING (	SELECT RT.[COMPANY_ID]
								  ,RT.[DIVISION_ID]
								  ,RT.[SITE_ID]
								  ,RT.[PLANT_ID]
								  ,RT.[FACTORY_ID]
								  ,RT.[OPERATION_ID]
								  ,E.[LINE_ID]
								  ,RT.[ITEM_ID]	
								  ,RT.[RESULT_TT]/E.EQPT_CNT AS RESULT_TT
								  ,@MONTH               AS MONTH
							FROM  ( SELECT MAX(RT.[COMPANY_ID])  AS COMPANY_ID
										,MAX(RT.[DIVISION_ID]) AS DIVISION_ID
										,MAX(RT.[SITE_ID])     AS SITE_ID
										,MAX(RT.[PLANT_ID])    AS PLANT_ID
										,MAX(RT.[FACTORY_ID])  AS FACTORY_ID
										,RT.[OPERATION_ID]
										,RT.[LINE_ID]
										,RT.[ITEM_ID]
										,SUM(TACT_INPUT_QTY/SUM_QTY)  AS RESULT_TT
									FROM (  SELECT [COMPANY_ID]
												,[DIVISION_ID]
												,[SITE_ID]
												,[PLANT_ID]
												,[FACTORY_ID]
												,[OPERATION_ID]
												,[LINE_ID]
												,[ITEM_ID]
												,[EQUIPMENT_ID]
												,[TACT_LOGIC_AVG] * RT.[INPUT_QTY] AS TACT_INPUT_QTY
												,SUM(RT.[INPUT_QTY]) OVER (PARTITION BY RT.[LINE_ID], RT.[OPERATION_ID], RT.[ITEM_ID]) AS SUM_QTY
											FROM  [dbo].[FP_RESULT_TACT_H] RT (NOLOCK)
											WHERE RT.[PLAN_DATE] >= @FROM_DATE
											AND   RT.[PLAN_DATE] <= @TO_DATE
											AND   RT.[INPUT_QTY] >  0
											AND   RT.[DIVISION_ID] IN  (SELECT  '81' UNION
											                            SELECT  '82' UNION
																		SELECT PD.PSEUDO_DIVISION_ID
																		FROM   DBO.SCM_PSEUDO_DIVISION_M PD (NOLOCK)
																		WHERE  PD.ORIGINAL_DIVISION_ID IN  ('81', '82')) -- 40(소형)은 정보 사용 불가
																		-- 2022-03-30 kimcd JV용 가상 Division 로직 반영
											AND   RT.[PCK_SLOW_YN] = 'Y'
											AND   RT.[PLANT_ID]  IN ( SELECT SLV.SEGMENT1 AS PLANT_ID
																	FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
																		, SCM_PLANT_M          P   (NOLOCK)
																	WHERE P.PLANT_ID         = SLV.SEGMENT1
																	AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																	AND SLV.ACTIVE_FLAG      = 'Y'
																	AND SLV.SEGMENT2         = @V_BASIS_START_TIME
																	AND P.SITE_ID            = @V_SITE_ID) 
											   ) RT
									GROUP BY  RT.[LINE_ID]
											, RT.[OPERATION_ID]
											, RT.[ITEM_ID] ) RT,
									(SELECT E.COMPANY_ID
										  , E.DIVISION_ID
										  , E.SITE_ID
										  , E.PLANT_ID
										  , E.FACTORY_ID
										  , E.LINE_ID
										  , E.MES_LINE_ID
										  , COUNT(*) AS EQPT_CNT
									 FROM   SCM_EQUIPMENT_M E (NOLOCK)
									 WHERE  E.PLANT_ID IN ( SELECT SLV.SEGMENT1 AS PLANT_ID
															FROM SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
																, SCM_PLANT_M          P   (NOLOCK)
															WHERE P.PLANT_ID         = SLV.SEGMENT1
															AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															AND SLV.ACTIVE_FLAG      = 'Y'
															AND SLV.SEGMENT2         = @V_BASIS_START_TIME
															AND P.SITE_ID            = @V_SITE_ID)
									 AND    E.EQUIPMENT_TYPE = 'M'
									 AND    E.ACTIVE_FLAG    = 'Y'
									 AND    E.OPERATION_ID   = 'A9000'
									 GROUP BY E.COMPANY_ID
										    , E.DIVISION_ID
										    , E.SITE_ID
										    , E.PLANT_ID
										    , E.FACTORY_ID
										    , E.LINE_ID
										    , E.MES_LINE_ID
									 ) E
							WHERE RT.[COMPANY_ID]  = E.[COMPANY_ID]
							AND	  RT.[DIVISION_ID] = E.[DIVISION_ID]
							AND	  RT.[SITE_ID]     = E.[SITE_ID]
							AND	  RT.[PLANT_ID]    = E.[PLANT_ID]
							AND	  RT.[FACTORY_ID]  = E.[FACTORY_ID]
							AND	  RT.[LINE_ID]	   = E.[MES_LINE_ID] ) R
						ON (TM.[COMPANY_ID]      = R.[COMPANY_ID]
							AND TM.[DIVISION_ID] = R.[DIVISION_ID]
							AND TM.[SITE_ID]     = R.[SITE_ID]
							AND TM.[PLANT_ID]    = R.[PLANT_ID]
							AND TM.FACTORY_ID    = R.[FACTORY_ID]
							AND TM.OPERATION_ID  = R.[OPERATION_ID]
							AND TM.[LINE_ID]     = R.[LINE_ID]
							AND TM.[ITEM_ID]     = R.[ITEM_ID]
							AND TM.[MONTH]       = R.[MONTH] )
					WHEN MATCHED THEN
						UPDATE
						SET    TM.RESULT_TACT_TIME = R.RESULT_TT
							  ,TM.UPDATE_ID        = @v_proc_name
							  ,TM.UPDATE_TIME	   = GETDATE()
					--WHEN NOT MATCHED THEN
					--	INSERT ([COMPANY_ID],
					--			[DIVISION_ID],
					--			[SITE_ID],
					--			[PLANT_ID],
					--			[FACTORY_ID],
					--			[OPERATION_ID],
					--			[LINE_ID],
					--			[ELECTRODE_TYPE],
					--			[ITEM_ID],
					--			[MONTH],
					--			[INSERT_ID],
					--			[INSERT_TIME],
					--			[UPDATE_ID],
					--			[UPDATE_TIME],
					--			[RESULT_TACT_TIME])
					--	VALUES ( R.[COMPANY_ID]
					--			,R.[DIVISION_ID]
					--			,R.[SITE_ID]
					--			,R.[PLANT_ID]
					--			,R.[FACTORY_ID]
					--			,R.[OPERATION_ID]
					--			,R.[LINE_ID]
					--			,'-'   -- ELECTODE_TYPE
					--			,R.[ITEM_ID]
					--			,R.[MONTH]
					--			,@v_proc_name
					--			,GETDATE()
					--			,@v_proc_name
					--			,GETDATE()
					--			,R.[RESULT_TT]
					--			)
								;
				END

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
