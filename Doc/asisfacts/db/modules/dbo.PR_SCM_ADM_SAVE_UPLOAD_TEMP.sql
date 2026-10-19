/*
 * Program ID   : PR_SCM_ADM_SAVE_UPLOAD_TEMP
 * Description  : PSI UPLOAD SAVE
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2018.01.02   SongDH     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.01.11   hwyoon     한글깨짐 수정
 * 2023.08.02   chkim.68   DataTable (UpdateBatch) 방식 Excel Upload의 경우, Upload 데이터 무시, Validation만 실시
 *
 */
CREATE PROCEDURE [dbo].[PR_SCM_ADM_SAVE_UPLOAD_TEMP]

	@p_program_id			NVARCHAR(MAX), --DMF0009^DMF0012^DMF0010
	@p_sheet_name			NVARCHAR(MAX), --sss^sss^sss
	@p_column_values		NVARCHAR(MAX), --site|itemid|12|11|22|33|^site|itemid|12|11|22|33|^site|itemid|12|11|22|33|
	@p_created_by			NVARCHAR(MAX) 

AS

BEGIN

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    --SET XACT_ABORT ON;
	SET NOCOUNT ON; 
    
	DECLARE @v_program_id			NVARCHAR(MAX);
	DECLARE @v_sheet_name			NVARCHAR(MAX);
	DECLARE @v_column_values		NVARCHAR(MAX);
	DECLARE @v_column_dtl_values	NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	SET @v_program_id = NULL;
	SET @v_sheet_name = NULL;
	SET @v_column_values = NULL;
	SET @v_column_dtl_values = NULL;
	SET @v_created_by = NULL;

	DECLARE @v_sql					NVARCHAR(MAX);
	DECLARE @v_columns				NVARCHAR(MAX);
	DECLARE @v_values				NVARCHAR(MAX);
	DECLARE @v_sysdate				NVARCHAR(MAX);
	SET @v_sql = NULL;
	SET @v_columns = NULL;
	SET @v_values = NULL;
	SET @v_sysdate = NULL;

    DECLARE @v_sql_text      AS NVARCHAR(MAX);
	SET @v_sql_text = NULL;
    DECLARE @v_procedure     AS NVARCHAR(150);
    DECLARE @v_creation_date AS NVARCHAR(40);  

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'   -- 데이터 구분자
	DECLARE @v_delimiter1 NVARCHAR(1)
	SET @v_delimiter1 = '|'  -- 데이터 구분자1
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @dtl_loop_cnt		INTEGER = 0;
	DECLARE @dtl_sub_loop_cnt	INTEGER = 0;

	DECLARE @recv_active_flag	AS NVARCHAR(MAX);
	SET @recv_active_flag = NULL;
	SET @recv_active_flag = @p_program_id;
	DECLARE @recv_dtl_active_flag	AS NVARCHAR(MAX);
	SET @recv_dtl_active_flag = NULL;
	--SET @recv_dtl_active_flag = @p_program_id;

	DECLARE @n_upd_seq		INTEGER = 0;
	--SET @n_upd_seq = 0;

	-- 트랜잭션 (START)
	--	BEGIN TRANSACTION;

	--------------------------------------------------------------------------------------------	
	--	BEGIN TRY
	--------------------------------------------------------------------------------------------	

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_program_id, @v_delimiter);    
		SET @v_sysdate = CONVERT(CHAR(19), CURRENT_TIMESTAMP, 120);

		--SELECT    @max_loop_cnt;
		-- TABLE TYPE UPLOAD인 경우 대응
		IF ISNULL(@p_column_values,'') <> 'TABLEUPLOAD' BEGIN
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			SET @recv_dtl_active_flag = NULL;
			SET @recv_dtl_active_flag = @v_program_id;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_program_id = [dbo].[SCM_ARR_SPL_VAL](@p_program_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_program_id;
					  
				SET @v_sheet_name = [dbo].[SCM_ARR_SPL_VAL](@p_sheet_name, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_sheet_name;

				SET @v_column_values = [dbo].[SCM_ARR_SPL_VAL](@p_column_values, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_column_values;

				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_created_by;

				
				BEGIN
				
				SET @n_upd_seq = NEXT VALUE FOR SEQ1_SCM_ADM_EXCEL_UPLOAD;
				--SELECT @n_upd_seq;

				SET @v_columns = 'UPLOAD_ID,PROGRAM_ID,SHEET_NAME,UPLOAD_STATUS_CODE,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE';
				--SELECT @v_columns;

			--	SET @v_sysdate = CONVERT(CHAR(19), CURRENT_TIMESTAMP, 120);

				SET @v_values = CAST(@n_upd_seq AS NVARCHAR(10)) + ',''' + @v_program_id + ''',''' + @v_sheet_name + ''',''UPLOAD' + ''',''' + @v_created_by + ''',''' + @v_sysdate + ''',''' + @v_created_by + ''',''' + @v_sysdate;
				--SELECT @v_values; 
				-- CONVERT(INT,  CAST(@n_upd_seq AS NVARCHAR(10))) + CAST(@n_upd_seq AS NVARCHAR(10))
		--		 SET @v_end_week = CONVERT(CHAR(4), SUBSTRING(@v_start_week, 1, 4) + 1) + CONVERT(CHAR(2), SUBSTRING(@v_start_week, 5, 2) -26);
		--	SET @v_end_yyyymmdd = CONVERT(CHAR(8), DATEADD(YEAR, 1, CURRENT_TIMESTAMP), 112);

					-- 프로시저 LOOP 길이를 판단
					SET @dtl_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@v_column_values, @v_delimiter1);    -- sdfjshd^1|2|3|^~~
					--SELECT    @dtl_loop_cnt;

						--	WHILE LEN(@p_active_flag) > 0
						WHILE  @dtl_sub_loop_cnt < @dtl_loop_cnt
						
						BEGIN    
			
							-- @mst_loop_cnt 1증가
							SET @dtl_sub_loop_cnt = @dtl_sub_loop_cnt + 1;
							--SELECT @dtl_sub_loop_cnt,'@dtl_sub_loop_cnt'	;	

							-- 각 컬럼들에 대한 스플릿처리로직 스타트
							--BEGIN

								SET @v_column_dtl_values = [dbo].[SCM_ARR_SPL_VAL](@v_column_values, @v_delimiter1 , @dtl_sub_loop_cnt) ;    
								--SELECT @v_column_dtl_values;
								--SELECT @dtl_sub_loop_cnt;

								SET @v_columns = @v_columns + ',ATTRIBUTE' + CAST(@dtl_sub_loop_cnt AS NVARCHAR(10)) ;
								--SELECT @v_columns,'@v_columns';

								--IF @dtl_sub_loop_cnt = 1 
								--BEGIN 
								--	SET @v_values = @v_values + ',' + @v_column_dtl_values; 
								--END	
								--IF @dtl_sub_loop_cnt > 1 
								BEGIN 
									SET @v_values = @v_values + ''',N''' + @v_column_dtl_values; 
								END

								--SET @v_values = @v_values + ',' + @v_column_dtl_values; 
								--SELECT @v_values,'@v_values';

							--END

						END	
						

					SET @dtl_sub_loop_cnt = 0;
				END

				--SELECT @v_column_values;

				
				BEGIN
					
					--SELECT @v_created_by;
					SET @v_sql = 'INSERT INTO [dbo].[SCM_ADM_EXCEL_UPLOAD] (' + @v_columns +') VALUES (' + @v_values+ ''')';
					
					-- INSERT INTO [dbo].[SCM_ADM_EXCEL_UPLOAD] (UPLOAD_ID,PROGRAM_ID,SHEET_NAME,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6) VALUES (30,DMF0012,sss2,OKAniel,2018-01-05 18:22:29,OKAniel,2018-01-05 18:22:29siteitemid12112232)
					-- INSERT INTO [dbo].[SCM_ADM_EXCEL_UPLOAD] (UPLOAD_ID,PROGRAM_ID,SHEET_NAME,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6) VALUES (70,'DMF0009','sss1','OKAniel','2018-01-05 21:14:18','OKAniel','2018-01-05 21:14:18','site','itemid','12','11','22','31')

					--SELECT @v_sql;

					EXEC SP_EXECUTESQL @v_sql;
PRINT '1';

				END		

PRINT '2';

			END
		END

		--	[dbo].[SCM_ADM_EXCEL_UPLOAD]
		END ELSE
		BEGIN
PRINT '3';
			SET @v_program_id = ISNULL(@p_program_id,'')
			SET @v_sheet_name = ISNULL(@p_sheet_name,'')
			SET @v_created_by = ISNULL(@p_created_by,'')
		END

	
	--END
	
  	-- 트랜잭션 (COMMIT)
     --   COMMIT WORK;

	--------------------------------------------------------------------------------------------	
	--	END TRY
	--------------------------------------------------------------------------------------------	


	--------------------------------------------------------------	
    --BEGIN CATCH
	--------------------------------------------------------------	
      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
   --   SET @v_log_type = 'ERROR';
   --   SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
   --   SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
   --   SET @d_event_date = SYSDATETIME();

	  --SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION;

	--------------------------------------------------------------	
    --END CATCH;
	--------------------------------------------------------------	

	
PRINT '4';
			BEGIN
PRINT '5';
			--DECLARE @v_creation_date AS NVARCHAR(40);
			-- yyyymmddhh24miss
			SET @v_creation_date = CONVERT(CHAR(19), CURRENT_TIMESTAMP, 120) 
	

			--SET @v_sql_text = '';

		
			SET @v_sql_text = 
			(
				SELECT
					Z.OK
				FROM
				(
					SELECT 
						A.STORAGE_SQL_ID AS OK
						--A.STORAGE_SQL_ID + '(0.' + @v_created_by +')' AS OK
					FROM [dbo].[SCM_ADM_EXCEL_COLUMNS] A   WITH(NOLOCK)
					WHERE 1 = 1
					AND  A.PROGRAM_ID = @v_program_id
					AND  A.SHEET_NAME = @v_sheet_name
				) Z
			)
			;
PRINT '6';

--SELECT @v_sql_text;
			--SET @v_sql_text = '';
			--SELECT @v_sql_text;
			--SELECT @v_created_by;
			--SELECT @v_creation_date;
			--SELECT @v_program_id;
			--SELECT @v_sheet_name;
	--		EXEC SP_EXECUTESQL @v_sql_text;



			EXEC @v_sql_text '0', @v_created_by  ;	--[dbo].[PR_DM_PNL_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PNL_VERSION_CREATE]

PRINT @v_sql_text		
				
			---- LOG 용 변수 설정
			--DECLARE @v_program_name NVARCHAR(150) = 'DM0014_EXCEL_UPLOAD';
			--DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
			--DECLARE @n_log_count    INTEGER = 0;
			--DECLARE @v_log_message  NVARCHAR(1000);
			--DECLARE @v_description  NVARCHAR(500);
			--DECLARE @d_event_date   DATETIME;

			--SET @v_sql_text = 'PR_SCM_SYS_LOG_BATCH';
			--EXEC   @v_sql_text @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		END
	

END;						













