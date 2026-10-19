/*    
 * Program ID   : PR_SCP_ANL_PLN_ARCHIVE_COMPRESSION
 * Description  : 
 * OutTable     :   
 * Program History
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2020.02.28   khj79          [C20200310-000428] Final Plan에 대하여 2년이 지난 Data는 Archive Table 보관하고, 운영 DB 삭제 요청의 건 
                               SCP ANL ARCHIVE 테이블 COMPRESSION(압축은 테이블 생성되고 한번만 실행)

 ***  운영 반영 시 

 */


CREATE PROCEDURE [dbo].[PR_SCP_ANL_PLN_ARCHIVE_COMPRESSION]
AS
BEGIN

	DECLARE @v_tableName    varchar(500); -- 원본 테이블 명

	-- Dynamic Query 용 변수 설정
	DECLARE @v_sql                 NVARCHAR(MAX); -- 삭제 SQL

	-- LOG 용 변수 설정
	DECLARE @v_batch_user          NVARCHAR(150) = N'scp_batch';
	DECLARE @v_program_name        NVARCHAR(150) = N'PR_SCP_ANL_PLN_ARCHIVE_COMPRESSION';
	DECLARE @v_log_type            NVARCHAR(30); -- START/END/ERROR/...	
	DECLARE @n_log_count           INTEGER = 0;
	DECLARE @v_log_message         NVARCHAR(1000);
	DECLARE @v_description         NVARCHAR(500);
	DECLARE @d_event_date          DATETIME;

	-- 테이블 리스트 커서 생성
	DECLARE tableCursor cursor FAST_FORWARD FOR
	SELECT TABLE_NAME
	  FROM INFORMATION_SCHEMA.TABLES A
	 WHERE A.TABLE_NAME LIKE 'SCP_ANL_%' 
	   AND (A.TABLE_NAME LIKE '%_AR'     -- ARCHIVE 테이블
	        OR A.TABLE_NAME LIKE '%_SWITCH' -- SWITCH 테이블
		   )
	;

	-- 시작 LOG      
	SET @v_log_type    = N'START';      
	SET @v_log_message = N'########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date  = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	BEGIN TRY
		OPEN tableCursor
		FETCH NEXT FROM tableCursor INTO @v_tableName WHILE @@FETCH_STATUS = 0
		BEGIN
	
		-- ARCHIVE 테이블 존재 유무 확인. 존재하면 압축 실행
		IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME= @v_tableName)
			BEGIN
				SET @v_sql = 'ALTER TABLE ' + @v_tableName + ' REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE) ';

				EXEC(@v_sql);
			END
		ELSE
			BEGIN
				PRINT N'테이블 [' +  @v_tableName + N'] 테이블 이 존재하지 않습니다.'
			END


		FETCH NEXT FROM tableCursor INTO @v_tableName
		END
		-- Cursor 종료
		CLOSE tableCursor
		DEALLOCATE tableCursor
	END TRY

	BEGIN CATCH
		PRINT N'오류가 발생 되었습니다.'
		CLOSE tableCursor
		DEALLOCATE tableCursor
		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
		END;

		--ERROR LOG
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = @v_tableName;
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END CATCH

	-- 종료 LOG
	SET @v_log_type    = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date  = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END

