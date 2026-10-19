
/*===================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST_CUTOFF
 * Description  : DM_PLN_MKT_FCST CUTOFF의 Cust.FCST(P+P) = Excel + RPA + EDI를 하도록 작업하는 프로시져
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/11/26	JSSBAE			[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
 * 2025/06/23	KANG.H.J		[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가

 ===================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST_CUTOFF]
	 @p_division_id		NVARCHAR(MAX)
   , @p_version_no		NVARCHAR(MAX)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	--------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	--------------------------------------------------------------------------------------------------------
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST_CUTOFF';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	DECLARE @v_batch_user			NVARCHAR(150) = 'MAKE_CUST_FCST_CUTOFF';
	
	--------------------------------------------------------------------------------------------------------
	-- TEMP 테이블 삭제한 후 시작한다. 
	--------------------------------------------------------------------------------------------------------	
	IF OBJECT_ID (N'tempdb..#TEMP_MKT_FCST_DATA_CUTOFF', N'U')			
	   IS NOT NULL	DROP TABLE #TEMP_MKT_FCST_DATA_CUTOFF
	IF OBJECT_ID (N'tempdb..#TEMP_MKT_FCST_DATA_CUTOFF', N'U')			
	   IS NOT NULL	DROP TABLE #TEMP_MKT_FCST_DATA_CUTOFF

	--------------------------------------------------------------------------------------------------------
	-- 시작 LOG (START)
	--------------------------------------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = 'DIVISION = ' + Convert(NVARCHAR(10), @p_division_id) + ' VERSION_NO = ' + Convert(NVARCHAR(100), @p_version_no) + '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--------------------------------------------------------------------------------------------------------
	-- 시작 LOG (END)
	--------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (START)
	--------------------------------------------------------------------------------------------------------
	BEGIN TRANSACTION MAKE_CUST_FCST_CUTOFF;
	
		BEGIN TRY
			--1. 데이터를 확인한다.
			SELECT A.DIVISION_ID
				 , A.VERSION_NO
				 , A.CUTOFF_TYPE
				 , A.CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , 'CUST_FCST' AS MEASURE
				 , A.YYYYMMDD
				 , A.PLANT_SITE_ID
				 , A.QTY
			INTO #TEMP_MAKE_CUST_FCST_CUTOFF
			FROM
			(
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
					 , INCOTERMS, PLANT_SITE_ID, YYYYMMDD
					 , SUM(QTY) AS QTY
				FROM DM_PLN_MKT_FCST_C WITH (NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no
				AND MEASURE IN ('Customer Fcst', 'CUST_FCST_EDI')
				GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
					   , INCOTERMS, PLANT_SITE_ID, YYYYMMDD
			) A
			GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
				   , A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
					   			 		  
		DECLARE @ROWCNT INT
		SET @ROWCNT = @@ROWCOUNT		
		
		--------------------------------------------------------------------------------------------------------
		-- 대상데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'TARGET DATA';  
		SET @v_description = N'#TEMP_MKT_FCST_CUTOFF_DATA INSERT';
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @ROWCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- 대상데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------

		--먼저 대상으로 잡힌 데이터를 삭제한다.
		DELETE DM_PLN_MKT_FCST_C
		FROM DM_PLN_MKT_FCST_C A
		INNER JOIN #TEMP_MAKE_CUST_FCST_CUTOFF B
				ON A.DIVISION_ID = B.DIVISION_ID
			   AND A.VERSION_NO = B.VERSION_NO
			   AND A.CUTOFF_TYPE = B.CUTOFF_TYPE
			   AND A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
			   AND A.PROJECT_CODE = B.PROJECT_CODE
			   AND A.SCM_SITE_ID = B.SCM_SITE_ID
			   AND A.ITEM_ID = B.ITEM_ID
			   AND A.DOM_EXP = B.DOM_EXP
			   AND A.FCST_TYPE = B.FCST_TYPE
			   AND A.INCOTERMS = B.INCOTERMS
			   AND A.MEASURE = B.MEASURE
			   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
			   AND A.YYYYMMDD = B.YYYYMMDD
				  
		DECLARE @DELETECNT INT
		SET @DELETECNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------
		-- DELETE 데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'MKT FCST CUTOFF DELETE DATA';  
		SET @v_description = N'MKT FCST CUTOFF DELETE';
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @DELETECNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- DELETE 데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------

		--삭제 후 데이터를 INSERT 한다.
		INSERT INTO DM_PLN_MKT_FCST_C
		(DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
		, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
		SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
			 , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
			 , @v_batch_user AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_batch_user AS LAST_UPDATED_BY ,GETDATE() AS LAST_UPDATE_DATE
			 , '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, '' AS ATTRIBUTE5
			 , '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
		FROM #TEMP_MAKE_CUST_FCST_CUTOFF
		
		DECLARE @INSERTCNT INT
		SET @INSERTCNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------
		-- INSERT 데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'MKT FCST CUTOFF INSERT DATA';  
		SET @v_description = N'MKT FCST CUTOFF INSERT';
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @INSERTCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- INSERT 데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------

		--1. 데이터를 확인한다.
		SELECT A.DIVISION_ID
				, A.VERSION_NO
				, A.CUTOFF_TYPE
				, A.CUTOFF_YYYYMMDD
				, A.PROJECT_CODE
				, A.SCM_SITE_ID
				, A.ITEM_ID
				, A.DOM_EXP
				, A.FCST_TYPE
				, A.INCOTERMS
				, 'CUST_FCST' AS MEASURE
				, A.YYYYMMDD
				, A.PLANT_SITE_ID
				, A.CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				, A.QTY
		INTO #TEMP_MAKE_CUST_FCST_RESULTE_CUTOFF 
		FROM
		(
			SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
					, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
					, CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					, SUM(QTY) AS QTY
			FROM DM_PLN_MKT_FCST_RESULT_C WITH (NOLOCK)
			WHERE DIVISION_ID = @p_division_id
			AND VERSION_NO = @p_version_no
			AND MEASURE IN ('Customer Fcst', 'CUST_FCST_EDI')
			--AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) --당주 월요일 이후 데이터
			GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
					, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
					, CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		) A
		GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
				, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMMDD
				, A.CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				, A.QTY
					   			 		  
		DECLARE @RESLUT_ROWCNT INT
		SET @RESLUT_ROWCNT = @@ROWCOUNT		
		
		--------------------------------------------------------------------------------------------------------
		-- 대상데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'TARGET DATA CUTOFF';  
		SET @v_description = N'#TEMP_MKT_FCST_RESULT_CUTOFF_DATA INSERT';
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @RESLUT_ROWCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- 대상데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------
		
		--먼저 대상으로 잡힌 데이터를 삭제한다.
		DELETE DM_PLN_MKT_FCST_RESULT_C
		FROM DM_PLN_MKT_FCST_RESULT_C A
		INNER JOIN #TEMP_MAKE_CUST_FCST_RESULTE_CUTOFF B
				ON A.DIVISION_ID = B.DIVISION_ID
			   AND A.VERSION_NO = B.VERSION_NO
			   AND A.CUTOFF_TYPE = B.CUTOFF_TYPE
			   AND A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
			   AND A.PROJECT_CODE = B.PROJECT_CODE
			   AND A.SCM_SITE_ID = B.SCM_SITE_ID
			   AND A.ITEM_ID = B.ITEM_ID
			   AND A.DOM_EXP = B.DOM_EXP
			   AND A.FCST_TYPE = B.FCST_TYPE
			   AND A.INCOTERMS = B.INCOTERMS
			   AND A.MEASURE = B.MEASURE
			   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
			   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			   AND A.YYYYMMDD = B.YYYYMMDD
				  
		DECLARE @RESLUT_DELETECNT INT
		SET @RESLUT_DELETECNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------
		-- DELETE 데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'MKT FCST RESULT CUTOFF DELETE DATA';  
		SET @v_description = N'MKT FCST RESULT CUTOFF DELETE';
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @RESLUT_DELETECNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- DELETE 데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------

		--삭제 후 데이터를 INSERT 한다.
		INSERT INTO DM_PLN_MKT_FCST_RESULT_C
		(DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
		, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		, CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		)
		SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
			 , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
			 , @v_batch_user AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_batch_user AS LAST_UPDATED_BY ,GETDATE() AS LAST_UPDATE_DATE
			 , '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, '' AS ATTRIBUTE5
			 , '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			 , CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		FROM #TEMP_MAKE_CUST_FCST_RESULTE_CUTOFF WITH(NOLOCK)
		
		DECLARE @RESULT_INSERTCNT INT
		SET @RESULT_INSERTCNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------
		-- INSERT 데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'MKT FCST RESULT CUTOFF INSERT DATA';  
		SET @v_description = N'MKT FCST RESULT CUTOFF INSERT';
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @RESULT_INSERTCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- INSERT 데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------

        COMMIT WORK;		
		END TRY

    BEGIN CATCH	 
	  ROLLBACK TRANSACTION MAKE_CUST_FCST_CUTOFF;
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  set @v_description = '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러로그 --*/
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	  
    END CATCH;	
	--------------------------------------------------------------------------------------------------------
	 -- 트랜잭션 (END)
	--------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------
	-- 종료 LOG (START)
	--------------------------------------------------------------------------------------------------------
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
	/*
    SET @v_description = 'MKT FCST CUTOFF  TARGET DATA= ' + Convert(NVARCHAR(10), @ROWCNT) +  ' / MKT FCST CUTOFF DELETE DATA= ' + Convert(NVARCHAR(10), @DELETECNT)
	                      +  ' / MKT FCST CUTOFF INSERT DATA= ' + Convert(NVARCHAR(10), @INSERTCNT) + 'MKT FCST RESULTE CUTOFF  TARGET DATA= ' 
						  + Convert(NVARCHAR(10), @RESLUT_ROWCNT) +  ' / MKT FCST RESULT CUTOFF  DELETE DATA= ' + Convert(NVARCHAR(10), @RESLUT_DELETECNT)
	                      +  ' / MKT FCST CUTOFF RESULT INSERT DATA= ' + Convert(NVARCHAR(10), @RESULT_INSERTCNT) + ' ';
    */
	SET @v_description = 'DIVISION = ' + Convert(NVARCHAR(10), @p_division_id) + ' VERSION_NO = ' + Convert(NVARCHAR(100), @p_version_no) + '';
	SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------------------------------------------------
	-- 종료 LOG (END)
	--------------------------------------------------------------------------------------------------------

	ERR_RTN:
	IF @v_log_type = 'INVALID'
	  BEGIN
	     ROLLBACK TRANSACTION MAKE_CUST_FCST_CUTOFF
         EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  END 

END	
