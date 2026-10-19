

/*    
 * Program ID   : PR_SCP_ANL_PLN_ARCHIVE_INSERT_PURGE
 * Description  : 
 * OutTable     :   
 * Program History
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2020.03.10   khj79          [C20200310-000428] Final Plan에 대하여 2년이 지난 Data는 Archive Table 보관하고, 운영 DB 삭제 요청의 건 
                               SCP ANL ARCHIVE 테이블 INSERT 및 원본 데이터 PURGE

 ***  운영 반영 시 

 */

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PLN_ARCHIVE_INSERT_PURGE]
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON;        -- 결과 집합 문구 미표출
	SET XACT_ABORT ON;     -- 런타임 오류 발생 시 전체 롤백
	SET ANSI_WARNINGS OFF; -- 경고 메시지 미표출

	DECLARE @v_std_yyyymmdd VARCHAR(8); -- 106주 월요일 일자(약2년)
	DECLARE	@v_min_yyyymmdd VARCHAR(8); -- 106주 월요일 이전 데이터 중 오랜된 날짜
	
	DECLARE @v_tableName    VARCHAR(500); -- 원본 테이블 명
	DECLARE @v_tableArchive VARCHAR(500); -- ARCHIVE 테이블 명

	DECLARE @v_result_cnt   INT; -- 삭제 실행 건수
	DECLARE @v_tot_count    INT; -- 삭제 실행 총 건수
	
	-- Dynamic Query 용 변수 설정
	DECLARE @v_sql          NVARCHAR(MAX); -- 삭제 SQL

	-- DB 설정
	DECLARE @X_DB_NAME NVARCHAR(100);
	SELECT @X_DB_NAME  = DB_NAME();

	-- LOG 용 변수 설정
	DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';
	DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PLN_ARCHIVE_INSERT_PURGE';
	DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...	
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;

	-- 테이블 리스트 커서 생성
	DECLARE tableCursor cursor FAST_FORWARD FOR
	SELECT TABLE_NAME
	  FROM INFORMATION_SCHEMA.TABLES A
	 WHERE 1=1
	   AND ( A.TABLE_NAME LIKE 'SCP_ANL_%' OR A.TABLE_NAME LIKE 'SCP_PLN_%' )
	   AND A.TABLE_NAME NOT LIKE '%_V%'    -- 5개
	   AND A.TABLE_NAME NOT LIKE '%_FIX%'
	   AND A.TABLE_NAME NOT IN ('SCP_ANL_PRODUCTION_PLAN_FIX_H', 'SCP_ANL_SHIPMENT_PLAN_FIX_H' 
								,'SCP_PLN_TH_ENG_STOCK_PLAN','SCP_PLN_TH_ENG_STOCK_PLAN'
								,'SCP_ANL_TACT_TIME','SCP_ANL_WORKING_TIME')
	   AND A.TABLE_NAME NOT LIKE '%_AR'      -- ARCHIVE 테이블 제외
	   AND A.TABLE_NAME NOT LIKE '%_SWITCH'  -- SWITCH 테이블 제외
	 ORDER BY TABLE_NAME
	;

	-- 시작 LOG      
	SET @v_log_type    = N'START';      
	SET @v_log_message = N'########## Start of procedure ##########';
	SET @v_description = @v_std_yyyymmdd;
	SET @d_event_date  = SYSDATETIME();      
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRY
			-- 총 삭제 건수 초기화
			SET @v_tot_count = 0;

			OPEN tableCursor
			FETCH NEXT FROM tableCursor INTO @v_tableName WHILE @@FETCH_STATUS = 0
			BEGIN
		
			-- 테이블 이름 저장
			SET @v_tableArchive =  @v_tablename+'_AR' ;

			-- 삭제 날짜 설정(minimum 날짜)
			SET @v_std_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7*106, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 106주 전 월요일 일자

			IF @X_DB_NAME = 'LGCE_SCMDEV'
				BEGIN
					SET @v_std_yyyymmdd = '20191231';
				END

			SET @v_sql = 'SELECT @v_min_yyyymmdd = MIN(PLAN_START_YYYYMMDD)             ' + 
							'  FROM ' + @v_tablename + ' WITH(NOLOCK)                   ' + 
							' WHERE PLAN_START_YYYYMMDD <= ''' + @v_std_yyyymmdd  + ''' ' +
							--'   AND ISNULL(ATTRIBUTE5,''N'') != ''Y''                   ' +  /*테스트 삭제 */
							'   AND PLAN_TYPE = ''FN''                                  ';

			EXEC sp_executesql @v_sql, N'@v_min_yyyymmdd nvarchar(max) output' , @v_min_yyyymmdd OUTPUT;

			-- ARCHIVE 테이블 존재 유무 확인. 존재하면 데이터 INSERT
			IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME= @v_tableArchive)
				BEGIN

				-- DATA INSERT ( 원본 테이블 => ARCHIVE 테이블)
				SET @v_sql = ' INSERT /* PR_SCP_ANL_PLN_ARCHIVE_INSERT_PURGE */ ' + @v_tableArchive + 
							 '     SELECT * FROM '  + @v_tableName + ' WITH(NOLOCK)         ' + 
							 '      WHERE DIVISION_ID = DIVISION_ID                         ' +
							 '        AND PLAN_TYPE = ''FN''                                ' +
							 '        AND PLAN_START_YYYYMMDD = ''' + @v_min_yyyymmdd + ''' ' ;
						
				PRINT @v_sql;
				EXEC(@v_sql);
				END
		
			-- 원본 테이블 삭제
			SET @v_result_cnt = 1;

			WHILE(@v_result_cnt > 0)
				BEGIN
					--SET @v_sql = ' UPDATE TOP(5000) ' + @v_tableName +
					--				'    SET ATTRIBUTE5 = ''Y'' ' +
					--				'  WHERE DIVISION_ID = DIVISION_ID ' +
					--				'    AND PLAN_TYPE = ''FN'' ' +
					--				'    AND PLAN_START_YYYYMMDD = ''' + @v_min_yyyymmdd + ''' '  +
					--				'    AND ISNULL(ATTRIBUTE5,''N'') != ''Y'' ' 
									;
					SET @v_sql = ' DELETE /* PR_SCP_ANL_PLN_ARCHIVE_INSERT_PURGE */ TOP(10000) FROM '+ @v_tablename +
					             '  WHERE DIVISION_ID = DIVISION_ID ' +
								 '    AND PLAN_TYPE = ''FN'' ' +
								 '    AND PLAN_START_YYYYMMDD = ''' + @v_min_yyyymmdd + ''' ' ;
					EXEC (@v_sql);
					SET @v_result_cnt = @@ROWCOUNT;
					SET @n_log_count = @n_log_count + @v_result_cnt; -- 총 삭제 건수(로그 저장)
				END

			FETCH NEXT FROM tableCursor INTO @v_tableName
			END

			-- Cursor 종료
			CLOSE tableCursor
			DEALLOCATE tableCursor
	END TRY

	BEGIN CATCH
		PRINT ERROR_MESSAGE();
		CLOSE tableCursor
		DEALLOCATE tableCursor

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
		END;

		-- ERROR LOG
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = @v_std_yyyymmdd + '::' + @v_min_yyyymmdd + '::' + @v_tableName+ '::' + @v_tableArchive;
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END CATCH

	-- 종료 LOG
	SET @v_log_type    = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = @v_std_yyyymmdd + '::' + @v_min_yyyymmdd;
	SET @d_event_date  = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
