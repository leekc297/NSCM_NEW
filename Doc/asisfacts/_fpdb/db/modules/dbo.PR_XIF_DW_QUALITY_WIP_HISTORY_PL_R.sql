
CREATE PROCEDURE [dbo].[PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R]

-- ================================================================================================
-- Program ID          : FP00871
-- Program Name        : PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R
-- Param               :
-- Batch Period        : 1Day
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_QUALITY_WIP_HISTORY_PL_R, XIF_DW_QUALITY_WIP_HISTORY_DEL_R
-- Destination Table   : SCM_QUALITY_RESULT_H
--
-- Create Date         : 2018.09.13
-- Update Date         : 2019.06.24 1.1 PIYONG
--						 2019.09.05 1.2 PIYONG
--						 2019.09.09 1.3 PIYONG
--						 2019.12.31 1.4 PIYONG
--						 2020.01.14 1.5 PIYONG
--						 2020.03.12 1.6 PIYONG
--						 2020.06.11 1.7 PIYONG
--						 2020.10.16 1.8 KIMCD
--						 2020.11.10 1.9 KIMCD


-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 SCM_ITEM_M 조인 조건 추가
--						 1.2 WC_TYPE 추가 D = DEGAS, Q= 특성
--						 1.3 SCM_DAILY_PRODUCT_RESULT_H 삭제 로직 수정
--						 1.4 빈강, 폴란드 로직 분리
--						 1.4 삭제 테이블 JOIN 조건 변경
--						 1.5 빈강, 폴란드 로직 분리
--							 빈강(CNB) 양품수량 생성시 재작업 수량 포함 -- 단옥미 고급주관 요청
--						 1.6 빈강 GROUP BY LOT_COMMENT 추가
--						 1.7 DELETE 테이블 JOIN 제거
--                       1.8 2020-10-16 KIMCD LOT_TYPE = 2 인 경우 불량 수량을 양산 실적에서 빼준다.
--                       1.9 2020-11-10 KIMCD 폴란드 Group by 절에도 LOT_TYPE, LOT_COMMENT 추가
--                       2.0 2023-05-08 FP Pjt. 당일실적 제외
-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(50) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R'
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
	DECLARE @V_IFSEQNO	      NVARCHAR(1000)
	--
	CREATE TABLE #WIP_HISTORY_TEMP (
									[COMPANY_ID] [nvarchar](30) NOT NULL,
									[DIVISION_ID] [nvarchar](30) NOT NULL,
									[SITE_ID] [nvarchar](30) NOT NULL,
									[PLANT_ID] [nvarchar](30) NOT NULL,
									[FACTORY_ID] [nvarchar](30) NOT NULL,
									[TOP_ITEM_ID] [nvarchar](30) NOT NULL,
									[ITEM_ID] [nvarchar](150) NOT NULL,
									[OPERATION_ID] [nvarchar](30) NOT NULL,
									[LOCATION] [nvarchar](30) NOT NULL,
									[PRODUCTION_TYPE] [nvarchar](30) NOT NULL,
									[MARKET] [nvarchar](30) NOT NULL,
									[LINE_ID] [nvarchar](30) NOT NULL,
									[ELECTRODE_TYPE] [nvarchar](50) NOT NULL,
									[PLAN_DATE] [datetime] NOT NULL,
									[ACTUAL_QTY] [numeric](20, 4) NOT NULL,
									[ACTUAL_SCRAP_QTY] [numeric](20, 4) NULL,
									[ACTUAL_GOOD_QTY] [numeric](20, 4) NULL,
									[QTY_LANE] [numeric](18, 5) NULL,
									[QTY] [numeric](18, 5) NULL,
									[DFCT_QTY2] [numeric](18, 5) NULL,
									[INSERT_ID] [nvarchar](150) NULL,
									[INSERT_TIME] [datetime] NULL,
									[UPDATE_ID] [nvarchar](150) NULL,
									[UPDATE_TIME] [datetime] NULL,

								 CONSTRAINT [PK_SCM_DAILY_PRODUCT_RESULT_H] PRIMARY KEY CLUSTERED 
								(
									[ITEM_ID] ASC,
									[TOP_ITEM_ID] ASC,
									[LINE_ID] ASC,
									[PLAN_DATE] ASC,
									[OPERATION_ID] ASC,
									[FACTORY_ID] ASC,
									[PRODUCTION_TYPE] ASC,
									[MARKET] ASC,
									[ELECTRODE_TYPE] ASC
								)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
								) ON [PRIMARY]

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
						     FROM SY_XIF_DW_QUALITY_WIP_HISTORY_PL_R -- WITH(NOLOCK)	-- 2020-01-17 PIYONG NOLOCK DEL
							WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
						 );

		 UPDATE SY_XIF_DW_QUALITY_WIP_HISTORY_PL_R
			SET TRANSFER_FLAG = 'P'
			   ,TRANSFER_DATE = GETDATE()
		  WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'
--		    AND IFSEQNO = @V_IFSEQNO				 --PIYONG 2018-07-17 DEL


		IF @V_IFSEQNO != 'NULL' AND @V_IFSEQNO IS NOT NULL
			BEGIN
				--2018-03-13 추가
				-- 일자별 실적
				IF (  SELECT DISTINCT CASE WHEN [PLANT] NOT IN ('G631', 'G634') THEN 1 ELSE 0 END
						FROM SY_XIF_DW_QUALITY_WIP_HISTORY_PL_R WH WITH (INDEX=IDX_XIF_DW_QUALITY_WIP_HISTORY_PL_R)
					   WHERE TRANSFER_FLAG = 'P'
														   ) = 1 
					BEGIN
						SELECT GETDATE(), 'INSERT #WIP_HISTORY_TEMP PL'

						INSERT INTO #WIP_HISTORY_TEMP
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
								,CONVERT(DATE, OP_END_TIME, 112) AS PLAN_DATE
								,A.INPUT_QTY AS ACTUAL_QTY
								,A.ERR_QTY AS ACTUAL_SCRAP_QTY
								,A.CURR_QTY AS ACTUAL_GOOD_QTY
								,A.CURR_QTY AS QTY_LANE
								,A.CURR_QTY AS QTY
								,A.ERR_QTY AS DFCT_QTY2
								,'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R' AS [INSERT_ID]
								,GETDATE() AS [INSERT_TIME]
								,'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R' AS [UPDATE_ID]
								,GETDATE() AS [UPDATE_TIME]
							FROM (
								SELECT C.MODEL_ID
										,BUILDING
										,LINE_ID
										,OP_END_TIME
										,SUM(INPUT_QTY) AS INPUT_QTY
										,SUM(ERR_QTY) AS ERR_QTY
										,SUM(CURR_QTY) - ISNULL(SUM(GOOD_REWORK_ERR_QTY),0) AS CURR_QTY  -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량을 양품 수량에서 뺌 
										,WC_TYPE						-- 2019-09-05 PIYONG ADD
									FROM (
										SELECT (SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE [FACTORY_ID] =  ISNULL(LM.FACTORY_ID, A.[BUILDING]) ) AS [PLANT]
												,ISNULL(LM.FACTORY_ID, A.[BUILDING]) AS BUILDING 
												,ISNULL(LM.[LINE_ID], A.LINE_ID ) AS LINE_ID
												,A.[OP_END_TIME]
												,A.[MODEL_ID]
												,A.[LOT_ID]
												,A.[INPUT_QTY]
												,A.[ERR_QTY]
												,A.[CURR_QTY]
												,A.[WC_TYPE]			-- 2019-09-05 PIYONG ADD
												,A.GOOD_REWORK_ERR_QTY -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량 합 
											FROM (
												SELECT (SELECT TOP 1 SITE_ID FROM SCM_PLANT_M WHERE PLANT_ID =  PLANT) AS SITE_ID
														,[PLANT]
														,[BUILDING]
														,MAX([INPUT_QTY]) AS  [INPUT_QTY]
														,SUM([ERR_QTY]) AS [ERR_QTY]
														,MAX(CASE WHEN LOT_TYPE = 2 THEN 0 ELSE [CURR_QTY] END) AS [CURR_QTY] -- 2020-10-16 kimcd 양품 재작업 양품 수량 제외 
														,[OP_END_TIME]
														,LINE_ID
														,FORM_LINE_ID
														,MODEL_ID
														,SHIFT
														,LOT_ID
														,WC_TYPE		-- 2019-09-05 PIYONG ADD
														,SUM(CASE WHEN LOT_TYPE = 2 THEN ERR_QTY ELSE 0 END) AS GOOD_REWORK_ERR_QTY -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량 합
														,LOT_TYPE    -- 2020-11-10 KIMCD 폴란드 Group by 절에도 LOT_TYPE, LOT_COMMENT 추가
														,LOT_COMMENT -- 2020-11-10 KIMCD 폴란드 Group by 절에도 LOT_TYPE, LOT_COMMENT 추가
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
																,[FORM_LINE_ID]
																,[SHIFT]
																,[LOT_TYPE]
																,[TR_TYPE]
																,[WC_TYPE]		-- 2019-09-05 PIYONG ADD
																,[LOT_COMMENT]  -- 2020-11-10 KIMCD 폴란드 Group by 절에도 LOT_TYPE, LOT_COMMENT 추가
																,ROW_NUMBER() OVER(PARTITION BY [DIVISION_ID], [PLANT], [BUILDING]
																								, OP_END_TIME, LINE_ID, FORM_LINE_ID, MODEL_ID, SHIFT, LOT_ID, LOT_TYPE, LOSS_CODE
																								, LOT_COMMENT, WC_TYPE				-- 2019-09-05 PIYONG ADD WC_TYPE
																						ORDER BY UPD_TIME DESC, TR_TYPE ) NUM		--2018-06-12 PIYONG ADD 최종 변경된 데이터 추출
															FROM SY_XIF_DW_QUALITY_WIP_HISTORY_PL_R WH WITH (INDEX=IDX_XIF_DW_QUALITY_WIP_HISTORY_PL_R)
															WHERE TRANSFER_FLAG = 'P'
															AND OP_END_TIME < convert(nvarchar,  getdate(), 112)  --2023-05-08, 당일 실적 제외
												--		     AND IFSEQNO = @V_IFSEQNO				 --PIYONG 2018-07-17 DEL
												/*			--PIYONG 2020-06-11 DEL
															AND NOT EXISTS (
																			SELECT 1
																				FROM [SY_XIF_DW_QUALITY_WIP_HISTORY_DEL_R] WD
																				WHERE WH.IFSEQNO = WD.IFSEQNO
																		--	   AND WH.WORKDATE = WD.WORKDATE			-- 2019-12-31 PIYONG DEL
																				AND WH.DIVISION_ID = WD.DIVISION_ID
																				AND WH.PLANT = WD.PLANT
																				AND WH.BUILDING = WD.BUILDING
																				AND WH.OP_END_TIME = WD.OP_END_TIME
																				AND WH.LINE_ID = WD.LINE_ID 
																				AND WH.FORM_LINE_ID = WD.FORM_LINE_ID
																				AND WH.MODEL_ID = WD.MODEL_ID
																				AND WH.SHIFT = WD.SHIFT
																				AND WH.LOT_ID = WD.LOT_ID
																				AND WH.LOT_TYPE = WD.LOT_TYPE
																				AND WH.LOSS_CODE = WD.LOSS_CODE
																				AND WH.LOT_COMMENT = WD.LOT_COMMENT
																				AND WH.UPD_TIME >= WD.UPD_TIME
																				AND WH.UPDDTTM <= WD.UPDDTTM		-- 2019-12-31 PIYONG CHANGE WH.UPDDTTM = WD.UPDDTTM  -> WH.UPDDTTM <= WD.UPDDTTM
																				AND WH.WC_TYPE = WD.WC_TYPE			-- 2019-09-05 PIYONG ADD
																			)
													*/
														) A 
													WHERE NUM =1
													AND ISNULL(TR_TYPE, 'I') != 'D'				--2018-06-12 PIYONG ADD  입력, 수정된 데이터만 추출
													GROUP BY [PLANT]
														,[BUILDING]
														,[OP_END_TIME]
														,LINE_ID
														,FORM_LINE_ID
														,MODEL_ID
														,SHIFT
														,LOT_ID
														,WC_TYPE								-- 2019-09-05 PIYONG ADD
														,LOT_TYPE    -- 2020-11-10 KIMCD 폴란드 Group by 절에도 LOT_TYPE, LOT_COMMENT 추가
														,LOT_COMMENT -- 2020-11-10 KIMCD 폴란드 Group by 절에도 LOT_TYPE, LOT_COMMENT 추가
												) A
												,SCM_SYS_LOOKUP_VALUE      SLV WITH(NOLOCK)
										-- 2018-05-14 PIYONG ADD
												,(
													SELECT *
														FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
														AND ACTIVE_FLAG = 'Y'		) SSLV
												LEFT OUTER JOIN (
																SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																	FROM SCM_LINE_M
																	WHERE OPERATION_ID IN ( 'F4000', 'F6000')
																	AND ACTIVE_FLAG = 'Y'
																) LM
															ON SSLV.SEGMENT5 = LM.LINE_ID
															AND SSLV.SEGMENT1 = LM.SITE_ID
											-- 2018-05-14 PIYONG ADD 끝
											WHERE A.OP_END_TIME       >= CONVERT( nvarchar(10), GETDATE()-30, 112)	 --  2018-04-10 PIYONG -2에서 -30일로 변경
											AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND SLV.SEGMENT1         = A.[PLANT]
											AND SLV.ACTIVE_FLAG      = 'Y' 
											AND A.LINE_ID  = SSLV.SEGMENT2
											AND A.SITE_ID = SSLV.SEGMENT1
											AND A.BUILDING = SSLV.ATTRIBUTE1
										) A  -- 2018-03-15 kimcd 시업 시간 기준으로 조회문 수정
										,FP_MODEL_LOT_M C WITH(NOLOCK)
									WHERE A.MODEL_ID = C.MODEL_LOT_ID
									AND A.BUILDING = C.FACTORY_ID
									AND A.PLANT = C.PLANT_ID
									GROUP BY C.MODEL_ID
										,BUILDING
										,LINE_ID
										,OP_END_TIME
										,WC_TYPE					-- 2019-09-05 PIYONG ADD
																									) A
								,SCM_FACTORY_M  B
								,SCM_ITEM_M M
							WHERE 1=1
							AND A.BUILDING = B.FACTORY_ID
							AND A.MODEL_ID = M.ITEM_ID
							AND B.DIVISION_ID = M.DIVISION_ID
							AND B.SITE_ID = M.SITE_ID
							AND B.COMPANY_ID = M.COMPANY_ID			--2019-06-24 PIYONG ADD
						;
					END
				ELSE
					BEGIN


						INSERT INTO #WIP_HISTORY_TEMP 							
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
								,CONVERT(DATE, OP_END_TIME, 112) AS PLAN_DATE
								,A.INPUT_QTY AS ACTUAL_QTY
								,A.ERR_QTY AS ACTUAL_SCRAP_QTY
								,A.CURR_QTY AS ACTUAL_GOOD_QTY
								,A.CURR_QTY AS QTY_LANE
								,A.CURR_QTY AS QTY
								,A.ERR_QTY AS DFCT_QTY2
								,'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R' AS [INSERT_ID]
								,GETDATE() AS [INSERT_TIME]
								,'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R' AS [UPDATE_ID]
								,GETDATE() AS [UPDATE_TIME]
							FROM (
								SELECT C.MODEL_ID
										,BUILDING
										,LINE_ID
										,OP_END_TIME
										,SUM(INPUT_QTY) AS INPUT_QTY
										,SUM(ERR_QTY) AS ERR_QTY
										,SUM(CURR_QTY) - ISNULL(SUM(GOOD_REWORK_ERR_QTY),0) AS CURR_QTY  -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량을 양품 수량에서 뺌 
										,WC_TYPE						-- 2019-09-05 PIYONG ADD
									FROM (
										SELECT (SELECT TOP 1 PLANT_ID FROM SCM_FACTORY_M WHERE [FACTORY_ID] =  ISNULL(LM.FACTORY_ID, A.[BUILDING]) ) AS [PLANT]
												,ISNULL(LM.FACTORY_ID, A.[BUILDING]) AS BUILDING 
												,ISNULL(LM.[LINE_ID], A.LINE_ID ) AS LINE_ID
												,A.[OP_END_TIME]
												,A.[MODEL_ID]
												,A.[LOT_ID]
												,A.[INPUT_QTY]
												,A.[ERR_QTY]
												,A.[CURR_QTY]
												,A.[WC_TYPE]			-- 2019-09-05 PIYONG ADD
												,A.GOOD_REWORK_ERR_QTY -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량 합 
											FROM (
												SELECT (SELECT TOP 1 SITE_ID FROM SCM_PLANT_M WHERE PLANT_ID =  PLANT) AS SITE_ID
														,[PLANT]
														,[BUILDING]
														,MAX([INPUT_QTY]) AS  [INPUT_QTY]
														,SUM([ERR_QTY]) AS [ERR_QTY]
														,MAX(CASE WHEN LOT_TYPE = 2 THEN 0 ELSE [CURR_QTY] END) AS [CURR_QTY]  -- 2020-10-16 kimcd 양품 재작업 양품 실적에서 제외 
														,[OP_END_TIME]
														,LINE_ID
														,FORM_LINE_ID
														,MODEL_ID
														,SHIFT
														,LOT_ID
														,WC_TYPE		-- 2019-09-05 PIYONG ADD
														,LOT_TYPE
														,LOT_COMMENT							-- 2020-03-12 PIYONG ADD
														,SUM(CASE WHEN LOT_TYPE = 2 THEN ERR_QTY ELSE 0 END) AS GOOD_REWORK_ERR_QTY -- 2020-10-16 kimcd 양품 재작업 유형의 불량 수량 합 
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
																,[FORM_LINE_ID]
																,[SHIFT]
																,[LOT_TYPE]
																,[TR_TYPE]
																,[WC_TYPE]		-- 2019-09-05 PIYONG ADD
																,LOT_COMMENT							-- 2020-03-12 PIYONG ADD
																,ROW_NUMBER() OVER(PARTITION BY [DIVISION_ID], [PLANT], [BUILDING]
																							 , OP_END_TIME, LINE_ID, FORM_LINE_ID , MODEL_ID, SHIFT, LOT_ID, LOT_TYPE
																							 , LOSS_CODE, LOT_COMMENT, WC_TYPE	-- 2019-09-05 PIYONG ADD WC_TYPE
																					   ORDER BY UPD_TIME DESC, TR_TYPE ) NUM		--2018-06-12 PIYONG ADD 최종 변경된 데이터 추출
															FROM SY_XIF_DW_QUALITY_WIP_HISTORY_PL_R WH WITH (INDEX=IDX_XIF_DW_QUALITY_WIP_HISTORY_PL_R)
															WHERE TRANSFER_FLAG = 'P'
												--		   AND IFSEQNO = @V_IFSEQNO				 --PIYONG 2018-07-17 DEL
												/*			--PIYONG 2020-06-11 DEL
															AND NOT EXISTS (
																			SELECT 1
																				FROM [SY_XIF_DW_QUALITY_WIP_HISTORY_DEL_R] WD
																				WHERE WH.IFSEQNO = WD.IFSEQNO
																		--	   AND WH.WORKDATE = WD.WORKDATE
																				AND WH.DIVISION_ID = WD.DIVISION_ID
																				AND WH.PLANT = WD.PLANT
																				AND WH.BUILDING = WD.BUILDING
																				AND WH.OP_END_TIME = WD.OP_END_TIME
																				AND WH.LINE_ID = WD.LINE_ID 
																				AND WH.FORM_LINE_ID = WD.FORM_LINE_ID
																				AND WH.MODEL_ID = WD.MODEL_ID
																				AND WH.SHIFT = WD.SHIFT
																				AND WH.LOT_ID = WD.LOT_ID
																				AND WH.LOT_TYPE = WD.LOT_TYPE
																				AND WH.LOSS_CODE = WD.LOSS_CODE
																				AND WH.LOT_COMMENT = WD.LOT_COMMENT
																				AND WH.UPD_TIME >= WD.UPD_TIME
																				AND WH.UPDDTTM <= WD.UPDDTTM
																				AND WH.WC_TYPE = WD.WC_TYPE					-- 2019-09-05 PIYONG ADD
																			)
												*/
														) A 
													WHERE NUM =1
													AND ISNULL(TR_TYPE, 'I') != 'D'				--2018-06-12 PIYONG ADD  입력, 수정된 데이터만 추출
													GROUP BY [PLANT]
														,[BUILDING]
														,[OP_END_TIME]
														,LINE_ID
														,FORM_LINE_ID
														,MODEL_ID
														,SHIFT
														,LOT_ID
														,WC_TYPE								-- 2019-09-05 PIYONG ADD
														,LOT_TYPE								-- 2020-01-15 PIYONG ADD
														,LOT_COMMENT							-- 2020-03-12 PIYONG ADD
												) A
												,SCM_SYS_LOOKUP_VALUE      SLV WITH(NOLOCK)
										-- 2018-05-14 PIYONG ADD
												,(
													SELECT *
														FROM [dbo].[SCM_SYS_LOOKUP_VALUE]
														WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
														AND ACTIVE_FLAG = 'Y'		) SSLV
												LEFT OUTER JOIN (
																SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID
																	FROM SCM_LINE_M
																	WHERE OPERATION_ID IN ( 'F4000', 'F6000')
																	AND ACTIVE_FLAG = 'Y'
																) LM
															ON SSLV.SEGMENT5 = LM.LINE_ID
															AND SSLV.SEGMENT1 = LM.SITE_ID
											-- 2018-05-14 PIYONG ADD 끝
											WHERE A.OP_END_TIME       >= CONVERT( nvarchar(10), GETDATE()-30, 112)	 --  2018-04-10 PIYONG -2에서 -30일로 변경
											AND SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND SLV.SEGMENT1         = A.[PLANT]
											AND SLV.ACTIVE_FLAG      = 'Y' 
											AND A.LINE_ID  = SSLV.SEGMENT2
											AND A.SITE_ID = SSLV.SEGMENT1
											AND A.BUILDING = SSLV.ATTRIBUTE1
										) A  -- 2018-03-15 kimcd 시업 시간 기준으로 조회문 수정
										,FP_MODEL_LOT_M C WITH(NOLOCK)
									WHERE A.MODEL_ID = C.MODEL_LOT_ID
									AND A.BUILDING = C.FACTORY_ID
									AND A.PLANT = C.PLANT_ID
									GROUP BY C.MODEL_ID
										,BUILDING
										,LINE_ID
										,OP_END_TIME
										,WC_TYPE					-- 2019-09-05 PIYONG ADD
																									) A
								,SCM_FACTORY_M  B
								,SCM_ITEM_M M
							WHERE 1=1
							AND A.BUILDING = B.FACTORY_ID
							AND A.MODEL_ID = M.ITEM_ID
							AND B.DIVISION_ID = M.DIVISION_ID
							AND B.SITE_ID = M.SITE_ID
							AND B.COMPANY_ID = M.COMPANY_ID			--2019-06-24 PIYONG ADD
						;
					END

 
				MERGE SCM_DAILY_PRODUCT_RESULT_H A
				USING (
						SELECT COMPANY_ID
								,DIVISION_ID
								,SITE_ID
								,PLANT_ID
								,FACTORY_ID
   								,TOP_ITEM_ID
								,ITEM_ID
   								,OPERATION_ID
   								,[LOCATION]
								,[PRODUCTION_TYPE]
   								,[MARKET]
								,LINE_ID
								,[ELECTRODE_TYPE]
								,'-' AS [EQUIPMENT_ID]
								,PLAN_DATE
								,ACTUAL_QTY
								,ACTUAL_SCRAP_QTY
								,ACTUAL_GOOD_QTY
								,QTY_LANE
								,QTY
								,DFCT_QTY2
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
							FROM #WIP_HISTORY_TEMP
						) B
					ON ( A.[FACTORY_ID]			= B.[FACTORY_ID]
						AND A.[LINE_ID]			= B.[LINE_ID]
						AND A.[PLAN_DATE]		= B.[PLAN_DATE]
						AND A.[OPERATION_ID]	= B.[OPERATION_ID]
						AND A.[TOP_ITEM_ID]		= B.[TOP_ITEM_ID]
						AND A.[ITEM_ID]			= B.[ITEM_ID]
						AND A.[FP_PRODUCTION_TYPE]	= B.[PRODUCTION_TYPE]
						AND A.[LOCATION]		= B.[LOCATION]
						AND A.[MARKET]			= B.[MARKET]
						AND A.[ELECTRODE_TYPE]	= B.[ELECTRODE_TYPE]
						AND A.[EQUIPMENT_ID]	= B.[EQUIPMENT_ID]
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
						,[FP_PRODUCTION_TYPE]
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
						,B.[PRODUCTION_TYPE]
						,B.[EQUIPMENT_ID]
						,B.[INSERT_ID]
						,B.[INSERT_TIME]
						,B.[UPDATE_ID]
						,B.[UPDATE_TIME]
					)
				;

				SET @ROWCOUNT = @@ROWCOUNT
 
				DELETE 
				  FROM SCM_DAILY_PRODUCT_RESULT_H
				  WHERE [SITE_ID]      = @P_SITE_ID
				   AND [OPERATION_ID] IN ( 'F4000', 'F6000')						--2019-09-09 PIYONG DEGAS ADD
				   AND [PLAN_DATE]   >= CAST(DATEADD(DD, -30, GETDATE()) AS DATE)
				   AND [UPDATE_TIME]  < CONVERT(DATE, GETDATE()) -- 변경 대상 중에 오늘 변경 안 된 것 삭제
				   AND INSERT_ID		= 'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R'
			END;

		UPDATE SY_XIF_DW_QUALITY_WIP_HISTORY_PL_R
		   SET TRANSFER_FLAG = 'Y'
			  ,TRANSFER_DATE = getdate()
		 WHERE TRANSFER_FLAG = 'P'
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


