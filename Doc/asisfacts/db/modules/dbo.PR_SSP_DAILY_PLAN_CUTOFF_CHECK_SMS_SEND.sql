

/*
 * Program ID   : PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND
 * Description  : CUTOFF 실행 기준시간 초과 SMS 알림
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2026.07.23   강주용		[E20260723-001370] SSP Plan 장애 발생 알람 체계 정비
 */
 
CREATE PROCEDURE [dbo].[PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND]
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_DAILY_PLAN_CUTOFF_CHECK_SMS_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_text		   NVARCHAR(200);
    DECLARE @v_code		   NVARCHAR(10);

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
   
	BEGIN TRY
		BEGIN
    
			declare @rs nvarchar(10);
			declare @message nvarchar(100);

			set @rs = '';
			set @message = '';

			DECLARE @company_id VARCHAR(30);
			DECLARE @div_txt VARCHAR(30);
			
			DECLARE CUR_DEALY CURSOR 
			FOR  

				SELECT COMPANY_ID, DIV_TXT
				FROM (
					SELECT '8X' AS DIV_TXT --81/82
						 , COMPANY_ID
					 	 , CASE WHEN COMPANY_ID = 'WA00' THEN '16:20' --초과 기준 시간
								WHEN COMPANY_ID = 'NJ00' THEN '10:40'
								WHEN COMPANY_ID = 'NB00' THEN '10:40'
								WHEN COMPANY_ID = 'HM00' THEN '09:30'
								WHEN COMPANY_ID = 'HQ00' THEN '07:30'
								WHEN COMPANY_ID = 'HG00' THEN '20:40'
								WHEN COMPANY_ID = 'GM00' THEN '21:10'
								WHEN COMPANY_ID = 'HD00' THEN '21:40'
								WHEN COMPANY_ID = 'MI00' THEN '20:40'
								WHEN COMPANY_ID = 'NA00' THEN '10:40'
								WHEN COMPANY_ID = 'ST00' THEN '20:40'
							END AS CUTOFF_TIME
					FROM SSP_MST_SHIP_PLAN_SCHEDULE WITH(NOLOCK) 
					WHERE 1 = 1
					AND PLAN_START_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112) --운영용
					AND CURRENT_PLAN_DATE_YN != 'Y'

					UNION ALL --전극
					SELECT 'EE' AS DIV_TXT
						 , COMPANY_ID
						 , CASE WHEN COMPANY_ID = 'WA00' THEN '15:50' --초과 기준 시간
								WHEN COMPANY_ID = 'NJ00' THEN '11:50'
								WHEN COMPANY_ID = 'NB00' THEN '10:50'
								WHEN COMPANY_ID = 'HM00' THEN '09:50'
								WHEN COMPANY_ID = 'HQ00' THEN '07:50'
								WHEN COMPANY_ID = 'HG00' THEN '21:00'
								WHEN COMPANY_ID = 'GM00' THEN '20:00'
								WHEN COMPANY_ID = 'HD00' THEN '20:50'
								WHEN COMPANY_ID = 'MI00' THEN '20:50'
								WHEN COMPANY_ID = 'NA00' THEN '10:50'
								WHEN COMPANY_ID = 'ST00' THEN '20:50'
							END AS CUTOFF_TIME
					FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK) 
					WHERE 1 = 1
					AND PLAN_START_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112) --운영용
					AND CURRENT_PLAN_DATE_YN != 'Y'

					UNION ALL --소형
					SELECT '40' AS DIV_TXT
						 , COMPANY_ID 
						 , CUTOFF_TIME
					  FROM (SELECT 'NJ00' AS COMPANY_ID
								 , '11:10' AS CUTOFF_TIME
								 , COUNT(ATTRIBUTE10) AS ROW_CNT
							FROM   SSP_ANL_SHIP_PLAN_40 (NOLOCK)
							WHERE  1 = 1
							AND    DIVISION_ID = '40'
							AND    PLAN_START_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112)
							AND    MEASURE = 'SHIP_CONFIRM'
							AND    ATTRIBUTE10 = 'NJ00'
							UNION ALL
							SELECT 'AZ00' AS COMPANY_ID
								 , '10:40' AS CUTOFF_TIME
								 , COUNT(ATTRIBUTE10) AS ROW_CNT
							FROM   SSP_ANL_SHIP_PLAN_40 (NOLOCK)
							WHERE  1 = 1
							AND    DIVISION_ID = '40'
							AND    PLAN_START_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112)
							AND    MEASURE = 'SHIP_CONFIRM'
							AND    ATTRIBUTE10 = 'AZ00'
							UNION ALL
							SELECT 'HQ00' AS COMPANY_ID
								 , '08:10' AS CUTOFF_TIME
								 , COUNT(ATTRIBUTE10) AS ROW_CNT
							FROM   SSP_ANL_SHIP_PLAN_40 (NOLOCK)
							WHERE  1 = 1
							AND    DIVISION_ID = '40'
							AND    PLAN_START_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112)
							AND    MEASURE = 'SHIP_CONFIRM'
							AND    ATTRIBUTE10 = 'HQ00'
					) A
					WHERE ROW_CNT = 0
				) A
				WHERE A.CUTOFF_TIME < CONVERT(CHAR(5),GETDATE(),108) --현시각
				AND A.CUTOFF_TIME >= CONVERT(CHAR(5),DATEADD(MI,-10,GETDATE()),108) --현시각 10 분전
				;

			OPEN CUR_DEALY; 

			FETCH NEXT FROM CUR_DEALY 
			INTO @company_id, @div_txt 

			WHILE(@@FETCH_STATUS = 0) 
			BEGIN	

				SET @v_text = N'[' + @div_txt +' CUTOFF DELAY - ' + @company_id + N']'
				SET @v_code = '106'

				--PRINT '===============================================';			
				EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text

				FETCH NEXT FROM CUR_DEALY 
				INTO @company_id,@div_txt
			END 

			CLOSE CUR_DEALY; 
			DEALLOCATE CUR_DEALY;	

		END; 

    END TRY

    BEGIN CATCH
        
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_DEALY')
			BEGIN
				CLOSE CUR_DEALY ;
				DEALLOCATE CUR_DEALY ;
			END

      -- ERROR LOG
	  INSERT INTO scm_sys_log_batch (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

      return -1 
    END CATCH;

    -- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description  = N'';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    return 1 

  END;