/*    
 * Program ID   : PR_SCP_ANL_PLN_ARCHIVE_SWITCH
 * Description  : 
 * OutTable     :   
 * Program History
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2020.03.02   khj79          [C20200310-000428] Final Plan에 대하여 2년이 지난 Data는 Archive Table 보관하고, 운영 DB 삭제 요청의 건 
                               SCP ANL ARCHIVE 테이블 SWITCH

 ***  운영 반영 시 

 */
     

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PLN_ARCHIVE_SWITCH]
(
  @p_partition_yyyy varchar(4)
 )
AS 
BEGIN

	DECLARE @v_tableArchive VARCHAR(500); -- ARCHIVE 테이블 명
	DECLARE @v_tableSwitch  VARCHAR(500); -- SWITCH 테이블 명

	DECLARE @v_partitionNum INT; -- partition 번호

	DECLARE @v_sql NVARCHAR(MAX); -- 삭제 SQL

	-- LOG 용 변수 설정
	DECLARE @v_batch_user          NVARCHAR(150) = N'scp_batch';
	DECLARE @v_program_name        NVARCHAR(150) = N'PR_SCP_ANL_PLN_ARCHIVE_SWITCH_' + @p_partition_yyyy;
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
	   AND A.TABLE_NAME LIKE '%_AR'  -- ARCHIVE 테이블
	;

	-- 시작 LOG      
	SET @v_log_type    = N'START';      
	SET @v_log_message = N'########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date  = SYSDATETIME();      
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRY
		OPEN tableCursor
		FETCH NEXT FROM tableCursor INTO @v_tableArchive WHILE @@FETCH_STATUS = 0
		BEGIN
		
			-- 파티션 번호 확인
			SELECT @v_partitionNum = $partition.PF_NVARCHAR_Y(@p_partition_yyyy);

			-- SWITCH 테이블 설정
			SET @v_tableSwitch = replace(@v_tableArchive,'_AR', '_SWITCH');
		
			-- SWITCH 테이블 존재 유무 확인. 존재하면 데이터 이동
			IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME= @v_tableSwitch)
				BEGIN
					SET @v_sql = N'ALTER TABLE ' + @v_tableArchive + ' SWITCH PARTITION ' + Cast(@v_partitionNum as varchar) + ' TO ' + @v_tableSwitch + ' PARTITION ' + CAST(@v_partitionNum as varchar) ;
					PRINT @v_sql;
					EXEC (@v_sql);


					SET @v_sql = N'TRUNCATE TABLE ' + @v_tableSwitch;
					PRINT @v_sql;

					EXEC (@v_sql);

					FETCH NEXT FROM tableCursor INTO @v_tableArchive
				END
			ELSE
				BEGIN
					PRINT @v_tableArchive;
					FETCH NEXT FROM tableCursor INTO @v_tableArchive
				END
		END

		-- Cursor 종료
		CLOSE tableCursor
		DEALLOCATE tableCursor

	END TRY

	BEGIN CATCH
		CLOSE tableCursor
		DEALLOCATE tableCursor
		PRINT N'오류가 발생 되었습니다.'

		-- ERROR LOG
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = @p_partition_yyyy + '::' + @v_tableArchive+ '::' + @v_tableSwitch + '::' + CAST(@v_partitionNum as varchar);
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END CATCH

	-- 종료 LOG
	SET @v_log_type    = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = @p_partition_yyyy + '::' + CAST(@v_partitionNum as varchar);
	SET @d_event_date  = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END
