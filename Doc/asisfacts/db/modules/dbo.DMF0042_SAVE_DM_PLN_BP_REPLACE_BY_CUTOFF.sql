/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/11/08  chano0612   [C20221025-000029] Business Plan Current버전 특정 컷오프 버전으로 덮어쓰기 기능 구현 요청의 건
 */



CREATE procedure [dbo].[DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF]  
				@p_division_id                NVARCHAR(30),   -- 부서코드
				@p_version_type               NVARCHAR(10),   -- 버전유형
				@p_yyyyMM_from                NVARCHAR(6),    -- 시작구간
				@p_yyyyMM_to                  NVARCHAR(6),    -- 끝구간
				@p_created_by                 NVARCHAR(50),   -- 작성자
				@p_version_no                 NVARCHAR(50)    -- 버전번호 (BP_M_20220822_V002)

AS

   DECLARE      @p_count                      INT -- 적용데이터 수량

--EXEC DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF '40', 'BP_M', '202401', '202401', 'chano0612', 'BP_M_20221115_V001'
BEGIN
	
	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF;

	-------------------------------------- 설정된 기간에서 기존 데이터 삭제 START

	BEGIN

		BEGIN
		  DELETE FROM DM_PLN_BP_FCST
		  WHERE DIVISION_ID = @p_division_id AND YYYYMM BETWEEN @p_yyyyMM_from AND @p_yyyyMM_to
		  PRINT @@ROWCOUNT
		END

		--PRINT 'DM_PLN_BP_FCST' + '_' + 'DELETE' + @@ROWCOUNT
	
	
		BEGIN
		  DELETE FROM DM_BP_EXCHANGE_RATE
		  WHERE DIVISION_ID = @p_division_id AND SUBSTRING(YYYYMMDD, 1, 6) BETWEEN @p_yyyyMM_from AND @p_yyyyMM_to
		  PRINT @@ROWCOUNT
		END

		--PRINT 'DM_BP_EXCHANGE_RATE' + '_' + 'DELETE' + @@ROWCOUNT
	

	END
	-------------------------------------- 설정된 기간에서 기존 데이터 삭제 END
	
	-------------------------------------- 컷오프데이터를 데이터를 삽입 START

	BEGIN TRY

	  BEGIN
		  INSERT INTO DM_PLN_BP_FCST(
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			ITEM_ID,
			FCST_TYPE,
			MEASURE,
			PLANT_SITE_ID,
			DEPT_ID,
			END_CUSTOMER,
			BIZ_TYPE,
			YYYYMM,
			CURRENCY,
			ITEM_USE,
			UNIT_ENERGY,
			INCOTERMS,
			CELL_PROD_SITE,
			DOM_EXP,
			QTY,
			CREATED_BY,
			CREATION_DATE,
			LAST_UPDATED_BY,
			LAST_UPDATE_DATE,
			ATTRIBUTE1,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10,
			CELL_PER_MODULE,
			CELL_PER_PACK,
			PROJECT_NAME,
			MODULE_PER_PACK)
		  SELECT 
  			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			ITEM_ID,
			FCST_TYPE,
			MEASURE,
			PLANT_SITE_ID,
			DEPT_ID,
			END_CUSTOMER,
			BIZ_TYPE,
			YYYYMM,
			CURRENCY,
			ITEM_USE,
			UNIT_ENERGY,
			INCOTERMS,
			CELL_PROD_SITE,
			DOM_EXP,
			QTY,
			CREATED_BY,
			CREATION_DATE,
			@p_created_by, --LAST_UPDATED_BY,
			GETDATE(), --LAST_UPDATE_DATE,
			@p_version_no, --ATTRIBUTE1,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10,
			CELL_PER_MODULE,
			CELL_PER_PACK,
			PROJECT_NAME,
			MODULE_PER_PACK
  
		  FROM DM_PLN_BP_FCST_C WITH(NOLOCK)
		  WHERE VERSION_NO = @p_version_no AND DIVISION_ID = @p_division_id AND YYYYMM BETWEEN @p_yyyyMM_from AND @p_yyyyMM_to
  	  
		  SET @p_count = @@ROWCOUNT;
		  PRINT @p_count
	  
	  END

	  --PRINT 'DM_PLN_BP_FCST' + '_' + 'INSERT' + @@ROWCOUNT
  

	  BEGIN
		  INSERT INTO DM_BP_EXCHANGE_RATE(
					  DIVISION_ID,
					  YYYYMMDD,
					  CURRENCY,
					  UNIT_CURRENCY,
					  EXCHANGE_PRICE,
					  CREATED_BY,
					  CREATION_DATE,
					  LAST_UPDATED_BY,
					  LAST_UPDATE_DATE,
					  ATTRIBUTE1,
					  ATTRIBUTE2,
					  ATTRIBUTE3,
					  ATTRIBUTE4,
					  ATTRIBUTE5,
					  ATTRIBUTE6,
					  ATTRIBUTE7,
					  ATTRIBUTE8,
					  ATTRIBUTE9,
					  ATTRIBUTE10
					  )
		  SELECT 
			DIVISION_ID,
			YYYYMMDD,
			CURRENCY,
			UNIT_CURRENCY,
			EXCHANGE_PRICE,
			CREATED_BY,
			CREATION_DATE,
			@p_created_by, --LAST_UPDATED_BY,
			GETDATE(),     --LAST_UPDATE_DATE,
			@p_version_no, --ATTRIBUTE1,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10
  
		  FROM DM_BP_EXCHANGE_RATE_C WITH(NOLOCK)
		  WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @p_version_no AND SUBSTRING(YYYYMMDD, 1, 6) BETWEEN @p_yyyyMM_from AND @p_yyyyMM_to

		  PRINT @@ROWCOUNT
		END
		  
		  COMMIT TRAN SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF ;
	  END TRY

	BEGIN CATCH

      -- ROLLBACK
	  BEGIN
		ROLLBACK TRAN SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF ;	
	  END

      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    END CATCH;
  
   

	-------------------------------------- 컷오프데이터를 데이터를 삽입 END
	

	BEGIN
	  SELECT @p_count AS CNT
	END

	--SELECT 'success'

	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END

	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRAN SAVE_SALES_SITE_DATA;
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			-- 2020.12.15 hwi1993
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'END', @n_log_count, @v_log_message, @v_description, @d_event_date;
		end

