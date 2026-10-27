
CREATE PROCEDURE [dbo].[PR_XIF_PLM_SPECIAL_GOODS_MASTER_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_PLM_SPECIAL_GOODS_MASTER_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : PLM
-- Destination System  : FP SDB
-- Source Table        : XIF_PLM_SPECIAL_GOODS_MASTER_R
-- Destination Table   : FP_PLM_SPECIAL_GOODS_MASTER_R
--
-- Create Date		   : 2017.05.16
-- Update Date		   :

-- Author              : piyong
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PLM_SPECIAL_GOODS_MASTER_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			UPDATE [dbo].[SY_XIF_PLM_SPECIAL_GOODS_MASTER_R]
			   SET PROC_FLAG = 'P'
			 WHERE PROC_FLAG = 'N'


			 MERGE INTO [DBO].[FP_PLM_SPECIAL_GOODS_MASTER_R] A
				USING (  SELECT *
						   FROM (SELECT [SPECIAL_GOODS_ID]
										,[BUSINESS_UNIT_CODE]
										,[TEAM_CODE]
										,[TITLE]
										,[CELL_TYPE]
										,[CELL_TYPE_NAME]
										,[PROJECT_CODE]
										,[CUSTOMER_CODE]
										,[CUSTOMER_NAME]
										,[DEVELOPMENT_STEP]
										,[DEVELOPMENT_STEP_NAME]
										,[REASON]
										,[REASON_NAME]
										,[MINIMUM_VOLUME]
										,[NORMINAL_VOLUME]
										,[SPG_PROD_QNT]
										,[SPG_PROD_AMOUNT]
										,[AMOUNT_PER_CELL]
										,[YIELD_ELEC]
										,[ELEC_UNIT]
										,[YIELD_WINDING]
										,[WINDING_UNIT]
										,[YIELD_ASSY]
										,[ASSY_UNIT]
										,[YIELD_VITAL]
										,[VITAL_UNIT]
										,[DEV_HISTORY]
										,[REASON_DESC]
										,[ACHIEVE_WAY]
										,[FUTURE_PLAN]
										,[REQUESTED_TERM]
										,[STATUS]
										,[GATE_INTEGRATION_COMMENT]
										,[PROJECT_NAME]
										,[START_YEAR_1ST]
										,[START_MONTH_1ST]
										,[END_YEAR_1ST]
										,[END_MONTH_1ST]
										,[START_YEAR_2ND]
										,[START_MONTH_2ND]
										,[END_YEAR_2ND]
										,[END_MONTH_2ND]
										,[START_YEAR_3RD]
										,[START_MONTH_3RD]
										,[END_YEAR_3RD]
										,[END_MONTH_3RD]
										,[START_YEAR_4TH]
										,[START_MONTH_4TH]
										,[END_YEAR_4TH]
										,[END_MONTH_4TH]
										,[START_YEAR_5TH]
										,[START_MONTH_5TH]
										,[END_YEAR_5TH]
										,[END_MONTH_5TH]
										,[RELATION_PROJECT_CODE]
										,[RELATION_PROJECT_NAME]
										,[RISK_ASSAY_MEASURE]
										,[GATE_REASON_COMMENT]
										,[PRIOR_APPROVAL]
										,[ECO_FLAG]
										,[ECO_CONTENT]
										,[ISSUE_CONTENT]
										,[DETAIL_SCHEDULE_CONTENT]
										,[CREATED_BY_ID]
										,[CREATION_DATE]
										,[UPDATED_BY_ID]
										,[UPDATE_DATE]
										,CASE ATTR_01 WHEN 'AUTO' THEN '40'
													  WHEN 'MOBILE' THEN '81'
													  WHEN 'ESS' THEN '82'
													   END AS [DIVISION_ID]
										,ROW_NUMBER() OVER ( PARTITION BY SPECIAL_GOODS_ID ORDER BY IF_SEQ) ROWUMBER
								   FROM [dbo].[SY_XIF_PLM_SPECIAL_GOODS_MASTER_R]
								  WHERE PROC_FLAG = 'P'
								) C
					      WHERE ROWUMBER = 1 
					  )B
				  ON ( A.SPECIAL_GOODS_ID = B.SPECIAL_GOODS_ID )
				WHEN MATCHED THEN

					UPDATE SET A.[DIVISION_ID]				  = B.[DIVISION_ID]
								,A.[BUSINESS_UNIT_CODE]       = B.[BUSINESS_UNIT_CODE]
								,A.[TEAM_CODE]				  = B.[TEAM_CODE]
								,A.[TITLE]					  = B.[TITLE]
								,A.[CELL_TYPE]				  = B.[CELL_TYPE]
								,A.[CELL_TYPE_NAME]			  = B.[CELL_TYPE_NAME]
								,A.[PROJECT_CODE]			  = B.[PROJECT_CODE]
								,A.[CUSTOMER_CODE]			  = B.[CUSTOMER_CODE]
								,A.[CUSTOMER_NAME]			  = B.[CUSTOMER_NAME]
								,A.[DEVELOPMENT_STEP]		  = B.[DEVELOPMENT_STEP]
								,A.[DEVELOPMENT_STEP_NAME]	  = B.[DEVELOPMENT_STEP_NAME]
								,A.[REASON]					  = B.[REASON]
								,A.[REASON_NAME]			  = B.[REASON_NAME]
								,A.[MINIMUM_VOLUME]			  = B.[MINIMUM_VOLUME]
								,A.[NORMINAL_VOLUME]		  = B.[NORMINAL_VOLUME]
								,A.[SPG_PROD_QNT]			  = B.[SPG_PROD_QNT]
								,A.[SPG_PROD_AMOUNT]		  = B.[SPG_PROD_AMOUNT]
								,A.[AMOUNT_PER_CELL]		  = B.[AMOUNT_PER_CELL]
								,A.[YIELD_ELEC]				  = B.[YIELD_ELEC]
								,A.[ELEC_UNIT]				  = B.[ELEC_UNIT]
								,A.[YIELD_WINDING]			  = B.[YIELD_WINDING]
								,A.[WINDING_UNIT]			  = B.[WINDING_UNIT]
								,A.[YIELD_ASSY]				  = B.[YIELD_ASSY]
								,A.[ASSY_UNIT]				  = B.[ASSY_UNIT]
								,A.[YIELD_VITAL]			  = B.[YIELD_VITAL]
								,A.[VITAL_UNIT]				  = B.[VITAL_UNIT]
								,A.[DEV_HISTORY]			  = B.[DEV_HISTORY]
								,A.[REASON_DESC]			  = B.[REASON_DESC]
								,A.[ACHIEVE_WAY]			  = B.[ACHIEVE_WAY]
								,A.[FUTURE_PLAN]			  = B.[FUTURE_PLAN]
								,A.[REQUESTED_TERM]			  = B.[REQUESTED_TERM]
								,A.[STATUS]					  = B.[STATUS]
								,A.[GATE_INTEGRATION_COMMENT] = B.[GATE_INTEGRATION_COMMENT]
								,A.[PROJECT_NAME]			  = B.[PROJECT_NAME]
								,A.[START_YEAR_1ST]			  = B.[START_YEAR_1ST]
								,A.[START_MONTH_1ST]		  = B.[START_MONTH_1ST]
								,A.[END_YEAR_1ST]			  = B.[END_YEAR_1ST]
								,A.[END_MONTH_1ST]			  = B.[END_MONTH_1ST]
								,A.[START_YEAR_2ND]			  = B.[START_YEAR_2ND]
								,A.[START_MONTH_2ND]		  = B.[START_MONTH_2ND]
								,A.[END_YEAR_2ND]			  = B.[END_YEAR_2ND]
								,A.[END_MONTH_2ND]			  = B.[END_MONTH_2ND]
								,A.[START_YEAR_3RD]			  = B.[START_YEAR_3RD]
								,A.[START_MONTH_3RD]		  = B.[START_MONTH_3RD]
								,A.[END_YEAR_3RD]			  = B.[END_YEAR_3RD]
								,A.[END_MONTH_3RD]			  = B.[END_MONTH_3RD]
								,A.[START_YEAR_4TH]			  = B.[START_YEAR_4TH]
								,A.[START_MONTH_4TH]		  = B.[START_MONTH_4TH]
								,A.[END_YEAR_4TH]			  = B.[END_YEAR_4TH]
								,A.[END_MONTH_4TH]			  = B.[END_MONTH_4TH]
								,A.[START_YEAR_5TH]			  = B.[START_YEAR_5TH]
								,A.[START_MONTH_5TH]		  = B.[START_MONTH_5TH]
								,A.[END_YEAR_5TH]			  = B.[END_YEAR_5TH]
								,A.[END_MONTH_5TH]			  = B.[END_MONTH_5TH]
								,A.[RELATION_PROJECT_CODE]	  = B.[RELATION_PROJECT_CODE]
								,A.[RELATION_PROJECT_NAME]	  = B.[RELATION_PROJECT_NAME]
								,A.[RISK_ASSAY_MEASURE]		  = B.[RISK_ASSAY_MEASURE]
								,A.[GATE_REASON_COMMENT]	  = B.[GATE_REASON_COMMENT]
								,A.[PRIOR_APPROVAL]			  = B.[PRIOR_APPROVAL]
								,A.[ECO_FLAG]				  = B.[ECO_FLAG]
								,A.[ECO_CONTENT]			  = B.[ECO_CONTENT]
								,A.[ISSUE_CONTENT]			  = B.[ISSUE_CONTENT]
								,A.[DETAIL_SCHEDULE_CONTENT]  = B.[DETAIL_SCHEDULE_CONTENT]
								,A.[UPDATED_ID]			      = B.[UPDATED_BY_ID]
								,A.[UPDATE_TIME]			  = B.[UPDATE_DATE]

				WHEN NOT MATCHED THEN

					INSERT ([DIVISION_ID]
							,[SPECIAL_GOODS_ID]
							,[BUSINESS_UNIT_CODE]
							,[TEAM_CODE]
							,[TITLE]
							,[CELL_TYPE]
							,[CELL_TYPE_NAME]
							,[PROJECT_CODE]
							,[CUSTOMER_CODE]
							,[CUSTOMER_NAME]
							,[DEVELOPMENT_STEP]
							,[DEVELOPMENT_STEP_NAME]
							,[REASON]
							,[REASON_NAME]
							,[MINIMUM_VOLUME]
							,[NORMINAL_VOLUME]
							,[SPG_PROD_QNT]
							,[SPG_PROD_AMOUNT]
							,[AMOUNT_PER_CELL]
							,[YIELD_ELEC]
							,[ELEC_UNIT]
							,[YIELD_WINDING]
							,[WINDING_UNIT]
							,[YIELD_ASSY]
							,[ASSY_UNIT]
							,[YIELD_VITAL]
							,[VITAL_UNIT]
							,[DEV_HISTORY]
							,[REASON_DESC]
							,[ACHIEVE_WAY]
							,[FUTURE_PLAN]
							,[REQUESTED_TERM]
							,[STATUS]
							,[GATE_INTEGRATION_COMMENT]
							,[PROJECT_NAME]
							,[START_YEAR_1ST]
							,[START_MONTH_1ST]
							,[END_YEAR_1ST]
							,[END_MONTH_1ST]
							,[START_YEAR_2ND]
							,[START_MONTH_2ND]
							,[END_YEAR_2ND]
							,[END_MONTH_2ND]
							,[START_YEAR_3RD]
							,[START_MONTH_3RD]
							,[END_YEAR_3RD]
							,[END_MONTH_3RD]
							,[START_YEAR_4TH]
							,[START_MONTH_4TH]
							,[END_YEAR_4TH]
							,[END_MONTH_4TH]
							,[START_YEAR_5TH]
							,[START_MONTH_5TH]
							,[END_YEAR_5TH]
							,[END_MONTH_5TH]
							,[RELATION_PROJECT_CODE]
							,[RELATION_PROJECT_NAME]
							,[RISK_ASSAY_MEASURE]
							,[GATE_REASON_COMMENT]
							,[PRIOR_APPROVAL]
							,[ECO_FLAG]
							,[ECO_CONTENT]
							,[ISSUE_CONTENT]
							,[DETAIL_SCHEDULE_CONTENT]
							,[INSERT_TIME]
							,[INSERT_ID]
							,[UPDATE_TIME]
							,[UPDATED_ID]
					) VALUES (
						B.[DIVISION_ID]
						,B.[SPECIAL_GOODS_ID]
						,B.[BUSINESS_UNIT_CODE]
						,B.[TEAM_CODE]
						,B.[TITLE]
						,B.[CELL_TYPE]
						,B.[CELL_TYPE_NAME]
						,B.[PROJECT_CODE]
						,B.[CUSTOMER_CODE]
						,B.[CUSTOMER_NAME]
						,B.[DEVELOPMENT_STEP]
						,B.[DEVELOPMENT_STEP_NAME]
						,B.[REASON]
						,B.[REASON_NAME]
						,B.[MINIMUM_VOLUME]
						,B.[NORMINAL_VOLUME]
						,B.[SPG_PROD_QNT]
						,B.[SPG_PROD_AMOUNT]
						,B.[AMOUNT_PER_CELL]
						,B.[YIELD_ELEC]
						,B.[ELEC_UNIT]
						,B.[YIELD_WINDING]
						,B.[WINDING_UNIT]
						,B.[YIELD_ASSY]
						,B.[ASSY_UNIT]
						,B.[YIELD_VITAL]
						,B.[VITAL_UNIT]
						,B.[DEV_HISTORY]
						,B.[REASON_DESC]
						,B.[ACHIEVE_WAY]
						,B.[FUTURE_PLAN]
						,B.[REQUESTED_TERM]
						,B.[STATUS]
						,B.[GATE_INTEGRATION_COMMENT]
						,B.[PROJECT_NAME]
						,B.[START_YEAR_1ST]
						,B.[START_MONTH_1ST]
						,B.[END_YEAR_1ST]
						,B.[END_MONTH_1ST]
						,B.[START_YEAR_2ND]
						,B.[START_MONTH_2ND]
						,B.[END_YEAR_2ND]
						,B.[END_MONTH_2ND]
						,B.[START_YEAR_3RD]
						,B.[START_MONTH_3RD]
						,B.[END_YEAR_3RD]
						,B.[END_MONTH_3RD]
						,B.[START_YEAR_4TH]
						,B.[START_MONTH_4TH]
						,B.[END_YEAR_4TH]
						,B.[END_MONTH_4TH]
						,B.[START_YEAR_5TH]
						,B.[START_MONTH_5TH]
						,B.[END_YEAR_5TH]
						,B.[END_MONTH_5TH]
						,B.[RELATION_PROJECT_CODE]
						,B.[RELATION_PROJECT_NAME]
						,B.[RISK_ASSAY_MEASURE]
						,B.[GATE_REASON_COMMENT]
						,B.[PRIOR_APPROVAL]
						,B.[ECO_FLAG]
						,B.[ECO_CONTENT]
						,B.[ISSUE_CONTENT]
						,B.[DETAIL_SCHEDULE_CONTENT]
						,B.[CREATION_DATE]
						,B.[CREATED_BY_ID]
						,B.[UPDATE_DATE]
						,B.[UPDATED_BY_ID]
					)

				;

			UPDATE [dbo].[SY_XIF_PLM_SPECIAL_GOODS_MASTER_R]
			   SET PROC_FLAG = 'Y'
				   ,PROC_DATE = GETDATE()
			 WHERE PROC_FLAG = 'P'
			;

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



