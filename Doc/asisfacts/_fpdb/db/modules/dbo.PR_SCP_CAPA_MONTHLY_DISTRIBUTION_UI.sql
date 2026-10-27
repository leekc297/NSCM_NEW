

CREATE PROCEDURE [dbo].[PR_SCP_CAPA_MONTHLY_DISTRIBUTION_UI]
WITH EXEC AS CALLER
AS
BEGIN
	
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_proc_name 	NVARCHAR(150) = 'PR_SCP_CAPA_MONTHLY_DISTRIBUTION_UI';
    DECLARE @p_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @p_message  	NVARCHAR(1000);
    DECLARE @v_log_code   	NVARCHAR(10);
    DECLARE @p_descr		NVARCHAR(500);
    DECLARE @sysdate   		DATETIME = SYSDATETIME();
	DECLARE @v_progress		NUMERIC(20,10);
	DECLARE @v_table_name   NVARCHAR(150);
	DECLARE @v_temp1        NVARCHAR(1000);
	DECLARE @v_temp2        NVARCHAR(1000);

  	SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  	SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
	
	BEGIN TRY		
		--BEGIN TRAN
			
			BEGIN
			DECLARE @v_next_year_mm NVARCHAR(6)
			SET @v_next_year_mm = CONVERT(NVARCHAR(6), DATEADD(M, 12 , GETDATE() ),112);  -- EX > 현재월 202103 => 202203
			
			DECLARE @v_aft_mm NVARCHAR(6)
			SET @v_aft_mm = CONVERT(NVARCHAR(6), DATEADD(M, 13 , GETDATE() ),112);  -- EX > 현재월 : 202103 => 202204
			
			SET @n_log_count = @n_log_count + 1
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', NULL
			
			-- /////////////////////////////////////////////////////////////////
			-- SCM_WORK_CALENDAR_M정보 생성
			-- Not-Available, No-Load 일별 데이터
			-- /////////////////////////////////////////////////////////////////
			BEGIN

			SET @v_table_name = 'SCM_WORK_CALENDAR_M'
			
				-- 데이터 삭제
				DELETE FROM SCM_WORK_CALENDAR_M
				 WHERE CONVERT(NVARCHAR(6) , WORK_DATE , 112) = @v_aft_mm
				 
				
	            SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
				SET  @n_log_count 	= @n_log_count + 1
	            SET  @p_log_type 	= 'DELETE'
	            EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null				

				INSERT INTO SCM_WORK_CALENDAR_M
				(
					  COMPANY_ID	, DIVISION_ID		, SITE_ID		, PLANT_ID	, FACTORY_ID
					, OPERATION_ID	, LINE_ID			, ELECTRODE_TYPE, WORK_DATE	, LOSS_CODE
					, TIME_TERM
					, INSERT_ID		, INSERT_TIME		, UPDATE_ID		, UPDATE_TIME
				)
				SELECT X.COMPANY_ID		, X.DIVISION_ID	, X.SITE_ID			, X.PLANT_ID	, X.FACTORY_ID
					 , X.OPERATION_ID	, X.LINE_ID		, X.ELECTRODE_TYPE	, BASIS_YYYYMMDD, X.LOSS_CODE
					 , X.OFF_TIME
					 , 'CAPA_BATCH'		, SYSDATETIME()	, 'CAPA_BATCH'		, SYSDATETIME()
				  FROM (
							SELECT T.COMPANY_ID
								 , T.DIVISION_ID
								 , T.SITE_ID
								 , T.PLANT_ID
								 , T.FACTORY_ID
								 , T.OPERATION_ID
								 , T.LINE_ID
								 , T.ELECTRODE_TYPE
								 , T.LOSS_CODE
								 , C.BASIS_YYYYMMDD
								 , CASE WHEN C.CALENDAR_DAY  = '01' THEN CONVERT(INT,CONVERT(NUMERIC(20,10),T.TOTAL_TIME_TERM)) / MAX_DAY + CONVERT(INT,CONVERT(NUMERIC(20,10),T.TOTAL_TIME_TERM)) % MAX_DAY
										WHEN C.CALENDAR_DAY != '01' THEN CONVERT(INT,CONVERT(NUMERIC(20,10),T.TOTAL_TIME_TERM)) / MAX_DAY
									ELSE 0 END AS OFF_TIME
							  FROM (
									-- LINE , OPERATION , LOSS 별 월 합계
									SELECT A.COMPANY_ID
										 , A.DIVISION_ID
										 , A.SITE_ID
										 , A.PLANT_ID
										 , A.FACTORY_ID
										 , A.OPERATION_ID
										 , A.LINE_ID
										 , A.ELECTRODE_TYPE
										 , A.LOSS_CODE
										 , SUM(A.TIME_TERM) AS TOTAL_TIME_TERM
									  FROM SCM_WORK_CALENDAR_M A WITH(NOLOCK)
									  JOIN (SELECT SEGMENT1 AS LOSS_CODE
											  FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
											 WHERE LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
											   AND ATTRIBUTE3		= 'SCM_WORK_CALENDAR_M'
											) LV
										ON A.LOSS_CODE = LV.LOSS_CODE
									 WHERE CONVERT(NVARCHAR(6) , A.WORK_DATE , 112) = @v_next_year_mm
									 GROUP BY A.COMPANY_ID
											, A.DIVISION_ID
											, A.SITE_ID
											, A.PLANT_ID
											, A.FACTORY_ID
											, A.OPERATION_ID
											, A.LINE_ID
											, A.ELECTRODE_TYPE
											, A.LOSS_CODE
									) T
								 JOIN (SELECT 	YYYYMMDD AS BASIS_YYYYMMDD, DAY AS CALENDAR_DAY, MAX(DAY) OVER(PARTITION BY YYYYMM )  AS MAX_DAY
										 FROM 	TH_UIS_CAL WITH(NOLOCK)
										WHERE 	YYYYMM = @v_aft_mm ) C
								   ON 1 = 1
						 ) X
					 WHERE X.OFF_TIME > 0
				

			SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
			SET  @n_log_count 	= @n_log_count + 1
            SET  @p_log_type 	= 'INSERT'
            EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null				
			
			END
			
			
			-- /////////////////////////////////////////////////////////////////
			-- SCM_LOSS_M 정보 생성
			-- No-Run 의 월별 데이터
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				
			SET @v_table_name = 'SCM_LOSS_M'
		
				-- 데이터 삭제
				DELETE FROM SCM_LOSS_M
				 WHERE WORK_MONTH	= @v_aft_mm
				 ;

	        SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
			SET  @n_log_count 	= @n_log_count + 1
	        SET  @p_log_type 	= 'DELETE'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null				
				
				
				INSERT INTO SCM_LOSS_M
				(
					  COMPANY_ID	, DIVISION_ID		, SITE_ID		, PLANT_ID	, FACTORY_ID
					, OPERATION_ID	, LINE_ID			, ELECTRODE_TYPE, WORK_MONTH, LOSS_CODE
					, LOSS_RATE		, LOSS_RATE_RESULT	, DESCRIPTION
					, INSERT_ID		, INSERT_TIME		, UPDATE_ID		, UPDATE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID		, A.SITE_ID			, A.PLANT_ID, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID			, A.ELECTRODE_TYPE	, @v_aft_mm	, A.LOSS_CODE
					 , A.LOSS_RATE		, A.LOSS_RATE_RESULT, A.DESCRIPTION 
					 , 'CAPA_BATCH'		, SYSDATETIME()		, 'CAPA_BATCH'		, SYSDATETIME()
				  FROM SCM_LOSS_M A WITH(NOLOCK)

				 WHERE A.WORK_MONTH = @v_next_year_mm
			END
			
			SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET  @n_log_count 	= @n_log_count + 1
            SET  @p_log_type 	= 'INSERT'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null				
			

			-- /////////////////////////////////////////////////////////////////
			-- SCM_ITEM_LINE_ASSIGN_UI_M 정보 생성
			-- LINE ASSIGN 월별 데이터
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				
			SET @v_table_name = 'SCM_ITEM_LINE_ASSIGN_UI_M'

				-- 데이터 삭제
				DELETE FROM SCM_ITEM_LINE_ASSIGN_UI_M
				 WHERE MONTH	= @v_aft_mm
				 ;
			
			SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET  @n_log_count 	= @n_log_count + 1
            SET  @p_log_type 	= 'DELETE'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null			
				

				INSERT INTO SCM_ITEM_LINE_ASSIGN_UI_M
				(
					  COMPANY_ID		, DIVISION_ID	, SITE_ID		, PLANT_ID			, FACTORY_ID
					, ITEM_ID			, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, MONTH
					, LANE_QTY			, WORK_CENTER_ID, PRIORITY		, CERTIFICATION_FLAG, CERTIFICATION_DATE
					, ACTIVE_FLAG		, DESCRIPTION	, WIP_LEVEL_QTY
					, INSERT_ID			, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
				)
				SELECT A.COMPANY_ID	, A.DIVISION_ID		, A.SITE_ID		, A.PLANT_ID			, A.FACTORY_ID
					 , A.ITEM_ID	, A.OPERATION_ID	, A.LINE_ID		, A.ELECTRODE_TYPE		, @v_aft_mm
					 , A.LANE_QTY	, A.WORK_CENTER_ID	, A.PRIORITY	, A.CERTIFICATION_DATE	, A.CERTIFICATION_DATE
					 , A.ACTIVE_FLAG, A.DESCRIPTION		, A.WIP_LEVEL_QTY
					 , 'CAPA_BATCH'	, SYSDATETIME()	, 'CAPA_BATCH'	, SYSDATETIME()
				  FROM SCM_ITEM_LINE_ASSIGN_UI_M A WITH(NOLOCK)
				 WHERE A.MONTH = @v_next_year_mm
			END

			SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET  @n_log_count 	= @n_log_count + 1
            SET  @p_log_type 	= 'INSERT'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null				
			
			-- /////////////////////////////////////////////////////////////////
			-- SCM_TACT_TIME_UI_M 정보 생성
			-- TACT TIME , DAILY CAPA 월별 데이터
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				
			SET @v_table_name = 'SCM_TACT_TIME_UI_M'				
				
				-- 데이터 삭제
				DELETE FROM SCM_TACT_TIME_UI_M
				 WHERE MONTH	= @v_aft_mm
				 ;

			SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET  @n_log_count 	= @n_log_count + 1
            SET  @p_log_type 	= 'DELETE'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null			
				

				INSERT INTO SCM_TACT_TIME_UI_M
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, ITEM_ID		, MONTH
					, WORK_CENTER_ID, TACT_TIME		, TACT_TIME_UOM	, DAILY_CAPA	, DESCRIPTION
					, GPLM_TACT_TIME
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID			, A.PLANT_ID	, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID		, A.ELECTRODE_TYPE	, A.ITEM_ID		, @v_aft_mm
					 , A.WORK_CENTER_ID	, A.TACT_TIME	, A.TACT_TIME_UOM	, A.DAILY_CAPA	, A.DESCRIPTION 
					 , A.GPLM_TACT_TIME
					 , 'CAPA_BATCH'	, SYSDATETIME()	, 'CAPA_BATCH'	, SYSDATETIME()
				  FROM SCM_TACT_TIME_UI_M A WITH(NOLOCK)
				 WHERE A.MONTH = @v_next_year_mm
			END
			
            SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET  @n_log_count 	= @n_log_count + 1
            SET  @p_log_type 	= 'INSERT'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null			
			

			-- /////////////////////////////////////////////////////////////////
			-- SCM_YIELD_UI_M 정보 생성
			-- YIELD 월별 데이터
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				
			SET @v_table_name = 'SCM_YIELD_UI_M'
				
				-- 데이터 삭제
				DELETE FROM SCM_YIELD_UI_M
				 WHERE MONTH = @v_aft_mm
				 ;
				
            SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET  @n_log_count 	= @n_log_count + 1
            SET  @p_log_type 	= 'DELETE'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null				
				

				INSERT INTO SCM_YIELD_UI_M
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ITEM_ID		, MONTH		, WORK_CENTER_ID
					, YIELD			, DESCRIPTION	, RESULT_YIELD
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID		, A.PLANT_ID	, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID		, A.ITEM_ID		, @v_aft_mm		, A.WORK_CENTER_ID
					 , A.YIELD			, A.DESCRIPTION	, RESULT_YIELD
					 , 'CAPA_BATCH'		, SYSDATETIME()	, 'CAPA_BATCH'	, SYSDATETIME()
				  FROM SCM_YIELD_UI_M A WITH(NOLOCK)
				 WHERE A.MONTH = @v_next_year_mm
			END
			
            SET  @p_message = CONVERT(NVARCHAR, @@ROWCOUNT)
            SET  @n_log_count 	= @n_log_count + 1
    		SET  @p_log_type 	= 'INSERT'
			EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, @v_table_name, @p_log_type, @n_log_count, null, @p_message, null				

			
		END

		--COMMIT TRAN;
	END TRY
			

	BEGIN CATCH
		--IF @@TRANCOUNT > 0 ROLLBACK TRAN ;
		 --ROLLBACK TRAN ;
		 IF @@TRANCOUNT > 0
               COMMIT WORK 
			   BEGIN

            DECLARE 
               @v_error_message nvarchar(max),
               @v_error_procedure nvarchar(max),
               @v_error_line nvarchar(max)

            SET @v_error_message = ERROR_MESSAGE()

            SET @v_error_procedure = ERROR_PROCEDURE()

            SET @v_error_line = convert(nvarchar,ERROR_LINE())

            EXECUTE pr_log_process  @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, null, 'ERROR', null, @v_error_line, null, @v_error_message

            IF @@TRANCOUNT > 0
               COMMIT WORK 
         END
	END CATCH

	SET @n_log_count = @n_log_count + 1
	  EXEC PR_LOG_PROCESS @sysdate, @v_next_year_mm, @v_aft_mm, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END

