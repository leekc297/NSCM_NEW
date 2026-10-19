

/*
 * Program ID   : [SCP0098_COPY_MONTH_WEEK]
 * Description  : 전 주차 & 전 월 카테고리 정보 복사
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/04/01   LJS			    init
 */
CREATE PROCEDURE [dbo].[SCP0098_COPY_MONTH_WEEK]
	   @p_user_id nvarchar(MAX) = '-'
	 , @p_day_type nvarchar(MAX) = '-'
	 , @debug_mode nvarchar(MAX) = '-'
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0098_COPY_MONTH_WEEK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

    -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

	-- BUCKET 확인
	DECLARE @v_bucket_type NVARCHAR(10) = '';
	DECLARE @v_from_yyyymmdd NVARCHAR(8) = '';
	DECLARE @v_to_yyyymmdd NVARCHAR(8) = '';

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		DECLARE @v_userid NVARCHAR(MAX);
		DECLARE @v_type NVARCHAR(MAX);
		DECLARE @v_debug NVARCHAR(MAX);

		DECLARE @v_curWeek NVARCHAR(6);  -- 금주
		DECLARE @v_befWeek NVARCHAR(6);  -- 전주
		DECLARE @v_curMonth NVARCHAR(6); -- 금월
		DECLARE @v_befMonth NVARCHAR(6); -- 전월

		SELECT @v_userid = @p_user_id
		     , @v_type   = @p_day_type
			 , @v_debug  = @debug_mode
		;

		SELECT @v_curWeek = ISO_YYYYWW
		FROM   SCM_SYS_CALENDAR_M A WITH(NOLOCK)
		WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR,GETDATE(),112)
		;

		SELECT @v_befWeek = ISO_YYYYWW
		FROM   SCM_SYS_CALENDAR_M A WITH(NOLOCK)
		WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR,GETDATE()-7,112)
		;
		
		SELECT @v_curMonth = BASIS_YYYYMM
		FROM   SCM_SYS_CALENDAR_M A WITH(NOLOCK)
		WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR,GETDATE(),112)
		;

		SELECT @v_befMonth = BASIS_YYYYMM
		FROM   SCM_SYS_CALENDAR_M A WITH(NOLOCK)
		WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR,DATEADD(MONTH,-1,GETDATE()),112)
		;

		IF @v_type = 'WEEK'
		BEGIN
			-- 주 복사(실제는 일단위) : 전주 -> 당주
			MERGE INTO SCP_MST_CAPA_WORK AS A
			USING (
				SELECT A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.MEASURE
					 , CONVERT(VARCHAR ,B.BASIS_DATE+7 ,112) AS YYYYMMDD
					 , A.VALUE
					 , 'COPY_WEEK_' + @v_userid AS CREATED_BY, GETDATE() AS CREATION_DATE
					 , 'COPY_WEEK_' + @v_userid AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
					 , A.PROD_READY_RATE
				FROM   SCP_MST_CAPA_WORK A WITH(NOLOCK), (
					SELECT B.BASIS_YYYYMMDD, B.BASIS_DATE
					FROM   SCM_SYS_CALENDAR_M B WITH(NOLOCK)
					WHERE  ISO_YYYYWW = @v_befWeek
				) B
				WHERE A.YYYYMMDD = B.BASIS_YYYYMMDD
				AND   A.MEASURE IN ( 'DAILY_CAPA', 'LOAD_RATE', 'NO_WORK', 'RAMP_UP' )
			) AS B
			ON  A.DIVISION_ID  = B.DIVISION_ID
			AND A.PLANT_ID     = B.PLANT_ID
			AND A.FACTORY_ID   = B.FACTORY_ID
			AND A.OPERATION_ID = B.OPERATION_ID
			AND A.LINE_ID      = B.LINE_ID
			AND A.MEASURE      = B.MEASURE
			AND A.YYYYMMDD     = B.YYYYMMDD

			WHEN MATCHED THEN
				UPDATE SET 
					  VALUE            = B.VALUE
					, LAST_UPDATED_BY  = B.LAST_UPDATED_BY
					, LAST_UPDATE_DATE = B.LAST_UPDATE_DATE

			WHEN NOT MATCHED THEN
				INSERT (
					  DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID
					, MEASURE, YYYYMMDD, VALUE
					, CREATED_BY, CREATION_DATE
					, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					, PROD_READY_RATE
				)
				VALUES (

					  B.DIVISION_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID
					, B.MEASURE, B.YYYYMMDD, B.VALUE
					, B.CREATED_BY, B.CREATION_DATE
					, B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE
					, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.ATTRIBUTE5
					, B.ATTRIBUTE6, B.ATTRIBUTE7, B.ATTRIBUTE8, B.ATTRIBUTE9, B.ATTRIBUTE10
					, B.PROD_READY_RATE
				)
			;

		END
		ELSE -- @v_type = 'MONTH'
		BEGIN
			-- 월복사 : 전월->당월 
			MERGE INTO SCP_MST_CAPA AS A
			USING (
				SELECT A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID
					 , @v_curMonth AS YYYYMM, A.VALUE
					 , 'COPY_MONTH_' + @v_userid AS CREATED_BY, GETDATE() AS CREATION_DATE			-- user_id
					 , 'COPY_MONTH_' + @v_userid AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE	-- user_id
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
				FROM   SCP_MST_CAPA A WITH(NOLOCK)
				WHERE  A.YYYYMM = @v_befMonth
			) AS B
			ON  A.DIVISION_ID  = B.DIVISION_ID
			AND A.PLANT_ID     = B.PLANT_ID
			AND A.FACTORY_ID   = B.FACTORY_ID
			AND A.OPERATION_ID = B.OPERATION_ID
			AND A.LINE_ID      = B.LINE_ID
			AND A.ITEM_ID      = B.ITEM_ID
			AND A.YYYYMM       = B.YYYYMM

			WHEN MATCHED THEN
				UPDATE SET 
					  VALUE            = B.VALUE
					, LAST_UPDATED_BY  = B.LAST_UPDATED_BY
					, LAST_UPDATE_DATE = B.LAST_UPDATE_DATE

			WHEN NOT MATCHED THEN
				INSERT (
					  DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID
					, LINE_ID, ITEM_ID
					, YYYYMM, VALUE
					, CREATED_BY, CREATION_DATE
					, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				)
				VALUES (
					  B.DIVISION_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID
					, B.LINE_ID, B.ITEM_ID
					, B.YYYYMM, B.VALUE
					, B.CREATED_BY, B.CREATION_DATE
					, B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE
					, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.ATTRIBUTE5
					, B.ATTRIBUTE6, B.ATTRIBUTE7, B.ATTRIBUTE8, B.ATTRIBUTE9, B.ATTRIBUTE10
				)
			;

		END


		
		-- 임시 운영반영시에 주석처리 할것.    
		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();
		
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리			
			
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			--SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END




