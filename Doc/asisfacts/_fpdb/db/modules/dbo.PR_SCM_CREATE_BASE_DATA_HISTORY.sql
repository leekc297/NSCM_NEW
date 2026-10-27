
CREATE PROCEDURE [dbo].[PR_SCM_CREATE_BASE_DATA_HISTORY]
-- ================================================================================================
-- Program ID          : FP00552
-- Program Name        : PR_SCM_CREATE_BASE_DATA_HISTORY
-- Param               :
-- Batch Period        : 1 MONTH
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : [SCM_ITEM_LINE_ASSIGN_M] [SCM_ITEM_LINE_ASSIGN_EXCEPT_M] [SCM_TACT_TIME_M] [SCM_TACT_TIME_EXCEPT_M]
--                       [SCM_YIELD_M] [SCM_YIELD_EXCEPT_M] [SCM_LOSS_M][SCM_WORK_CALENDAR_M]
-- Destination Table   : [HIST_SCM_ITEM_LINE_ASSIGN_M] [HIST_SCM_ITEM_LINE_ASSIGN_EXCEPT_M] [HIST_SCM_TACT_TIME_M] [HIST_SCM_TACT_TIME_EXCEPT_M]
--                       [HIST_SCM_YIELD_M] [HIST_SCM_YIELD_EXCEPT_M] [HIST_SCM_LOSS_M] [HIST_SCM_WORK_CALENDAR_M]
--
-- Create(Update) Date : 2021.11.25
-- Author              : KIMCD
-- Version             : 1.0 2021-11-25 최초 개발
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_CREATE_BASE_DATA_HISTORY'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	--LOGCAL 변수
	DECLARE @condition_month  NVARCHAR(6)
	DECLARE @condition_date   DATETIME
	
	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- ================================================
		-- 로직 추가
		-- ================================================
		IF DAY( GETDATE()) = '1'
		BEGIN
		SELECT @condition_month = CONVERT(NVARCHAR(6), DATEADD(MM, DATEDIFF(MM,0,GETDATE())-1, 0), 112)
		SELECT @condition_date  = DATEADD(MM, DATEDIFF(MM,0,GETDATE())-1, 0)

		BEGIN TRAN
			SET @v_temp2 = 'SCM_ITEM_LINE_ASSIGN_M'
			INSERT INTO [HIST_SCM_ITEM_LINE_ASSIGN_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[ITEM_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[MONTH]
				  ,[LANE_QTY]
				  ,[WORK_CENTER_ID]
				  ,[PRIORITY]
				  ,[CERTIFICATION_FLAG]
				  ,[CERTIFICATION_DATE]
				  ,[ACTIVE_FLAG]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[WIP_LEVEL_QTY] )
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[ITEM_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[MONTH]
				  ,[LANE_QTY]
				  ,[WORK_CENTER_ID]
				  ,[PRIORITY]
				  ,[CERTIFICATION_FLAG]
				  ,[CERTIFICATION_DATE]
				  ,[ACTIVE_FLAG]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[WIP_LEVEL_QTY]
			FROM   [SCM_ITEM_LINE_ASSIGN_M]
			WHERE  [MONTH] < @condition_month

			DELETE
			FROM   [SCM_ITEM_LINE_ASSIGN_M]
			WHERE  [MONTH] < @condition_month
		COMMIT TRAN;

		BEGIN TRAN
			SET @v_temp2 = 'SCM_ITEM_LINE_ASSIGN_EXCEPT_M'
			INSERT INTO [HIST_SCM_ITEM_LINE_ASSIGN_EXCEPT_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[ITEM_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[WORK_CENTER_ID]
				  ,[PRIORITY]
				  ,[START_TIME]
				  ,[END_TIME]
				  ,[DESCRIPTION]
				  ,[ACTIVE_FLAG]
				  ,[LANE_QTY]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME] )
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[ITEM_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[WORK_CENTER_ID]
				  ,[PRIORITY]
				  ,[START_TIME]
				  ,[END_TIME]
				  ,[DESCRIPTION]
				  ,[ACTIVE_FLAG]
				  ,[LANE_QTY]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
			FROM   [SCM_ITEM_LINE_ASSIGN_EXCEPT_M]
			WHERE  [START_TIME] < @condition_date

			DELETE
			FROM   [SCM_ITEM_LINE_ASSIGN_EXCEPT_M]
			WHERE  [START_TIME] < @condition_date
		COMMIT TRAN;

		BEGIN TRAN
			SET @v_temp2 = 'SCM_TACT_TIME_M'
			INSERT INTO [HIST_SCM_TACT_TIME_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[ITEM_ID]
				  ,[MONTH]
				  ,[WORK_CENTER_ID]
				  ,[TACT_TIME]
				  ,[TACT_TIME_UOM]
				  ,[DAILY_CAPA]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[GPLM_TACT_TIME]
				  ,[RESULT_TACT_TIME]
				  ,[DAILY_CAPA_PM])
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[ITEM_ID]
				  ,[MONTH]
				  ,[WORK_CENTER_ID]
				  ,[TACT_TIME]
				  ,[TACT_TIME_UOM]
				  ,[DAILY_CAPA]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[GPLM_TACT_TIME]
				  ,[RESULT_TACT_TIME]
				  ,[DAILY_CAPA_PM]
			FROM   [SCM_TACT_TIME_M]
			WHERE  [MONTH] < @condition_month

			DELETE
			FROM   [SCM_TACT_TIME_M]
			WHERE  [MONTH] < @condition_month
		COMMIT TRAN;

		BEGIN TRAN
			SET @v_temp2 = 'SCM_TACT_TIME_EXCEPT_M'
			INSERT INTO [HIST_SCM_TACT_TIME_EXCEPT_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[ITEM_ID]
				  ,[WORK_CENTER_ID]
				  ,[TACT_TIME]
				  ,[TACT_TIME_UOM]
				  ,[DAILY_CAPA]
				  ,[START_TIME]
				  ,[END_TIME]
				  ,[ACTIVE_FLAG]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[DAILY_CAPA_PM])
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[ITEM_ID]
				  ,[WORK_CENTER_ID]
				  ,[TACT_TIME]
				  ,[TACT_TIME_UOM]
				  ,[DAILY_CAPA]
				  ,[START_TIME]
				  ,[END_TIME]
				  ,[ACTIVE_FLAG]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[DAILY_CAPA_PM]
			FROM   [SCM_TACT_TIME_EXCEPT_M]
			WHERE  [START_TIME] < @condition_date

			DELETE
			FROM   [SCM_TACT_TIME_EXCEPT_M]
			WHERE  [START_TIME] < @condition_date
		COMMIT TRAN;

		BEGIN TRAN
			SET @v_temp2 = 'SCM_YIELD_M'
			INSERT INTO [HIST_SCM_YIELD_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ITEM_ID]
				  ,[MONTH]
				  ,[WORK_CENTER_ID]
				  ,[YIELD]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[RESULT_YIELD] )
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ITEM_ID]
				  ,[MONTH]
				  ,[WORK_CENTER_ID]
				  ,[YIELD]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
				  ,[RESULT_YIELD]
			FROM   [SCM_YIELD_M]
			WHERE  [MONTH] < @condition_month

			DELETE
			FROM   [SCM_YIELD_M]
			WHERE  [MONTH] < @condition_month
		COMMIT TRAN;

		BEGIN TRAN
			SET @v_temp2 = 'SCM_YIELD_EXCEPT_M'
			INSERT INTO [HIST_SCM_YIELD_EXCEPT_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ITEM_ID]
				  ,[WORK_CENTER_ID]
				  ,[YIELD]
				  ,[START_TIME]
				  ,[END_TIME]
				  ,[ACTIVE_FLAG]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME] )
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ITEM_ID]
				  ,[WORK_CENTER_ID]
				  ,[YIELD]
				  ,[START_TIME]
				  ,[END_TIME]
				  ,[ACTIVE_FLAG]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
			FROM   [SCM_YIELD_EXCEPT_M]
			WHERE  [START_TIME] < @condition_date

			DELETE
			FROM   [SCM_YIELD_EXCEPT_M]
			WHERE  [START_TIME] < @condition_date
		COMMIT TRAN;

		BEGIN TRAN
			SET @v_temp2 = 'SCM_LOSS_M'
			INSERT INTO [HIST_SCM_LOSS_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[WORK_MONTH]
				  ,[LOSS_CODE]
				  ,[LOSS_RATE]
				  ,[LOSS_RATE_RESULT]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME] )
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[WORK_MONTH]
				  ,[LOSS_CODE]
				  ,[LOSS_RATE]
				  ,[LOSS_RATE_RESULT]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
			FROM   [SCM_LOSS_M]
			WHERE  [WORK_MONTH] < @condition_month

			DELETE
			FROM   [SCM_LOSS_M]
			WHERE  [WORK_MONTH] < @condition_month
		COMMIT TRAN;

		BEGIN TRAN
			SET @v_temp2 = 'SCM_WORK_CALENDAR_M'
			INSERT INTO [HIST_SCM_WORK_CALENDAR_M]
				(  [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[WORK_DATE]
				  ,[LOSS_CODE]
				  ,[TIME_TERM]
				  ,[TIME_TERM_RESULT]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME] )
			SELECT [COMPANY_ID]
				  ,[DIVISION_ID]
				  ,[SITE_ID]
				  ,[PLANT_ID]
				  ,[FACTORY_ID]
				  ,[OPERATION_ID]
				  ,[LINE_ID]
				  ,[ELECTRODE_TYPE]
				  ,[WORK_DATE]
				  ,[LOSS_CODE]
				  ,[TIME_TERM]
				  ,[TIME_TERM_RESULT]
				  ,[DESCRIPTION]
				  ,[INSERT_ID]
				  ,[INSERT_TIME]
				  ,[UPDATE_ID]
				  ,[UPDATE_TIME]
			FROM   [SCM_WORK_CALENDAR_M]
			WHERE  WORK_DATE < @condition_date

			DELETE
			FROM   [SCM_WORK_CALENDAR_M]
			WHERE  WORK_DATE < @condition_date
		COMMIT TRAN;

		END;

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, @v_temp2, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



