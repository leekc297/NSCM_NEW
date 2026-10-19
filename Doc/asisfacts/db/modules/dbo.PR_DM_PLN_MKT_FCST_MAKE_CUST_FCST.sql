/*===================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST
 * Description  : DM_PLN_MKT_FCST의 Cust.FCST(P+P) = Excel + RPA + EDI를 하도록 작업하는 프로시져
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/11/26	JSSBAE			[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
 ===================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST]
	 @p_division_id		NVARCHAR(MAX)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	--------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	--------------------------------------------------------------------------------------------------------
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	DECLARE @v_batch_user			NVARCHAR(150) = 'MAKE_CUST_FCST';
	
	--------------------------------------------------------------------------------------------------------
	-- TEMP 테이블 삭제한 후 시작한다. 
	--------------------------------------------------------------------------------------------------------	
	IF OBJECT_ID (N'tempdb..#TEMP_MKT_FCST_DATA', N'U')			
	   IS NOT NULL	DROP TABLE #TEMP_MKT_FCST_DATA

	--------------------------------------------------------------------------------------------------------
	-- 시작 LOG (START)
	--------------------------------------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--------------------------------------------------------------------------------------------------------
	-- 시작 LOG (END)
	--------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (START)
	--------------------------------------------------------------------------------------------------------
	BEGIN TRANSACTION MAKE_CUST_FCST;
	
		BEGIN TRY
			--1. 데이터를 확인한다.
			SELECT A.DIVISION_ID
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
			INTO #TEMP_MKT_FCST_DATA
			FROM
			(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD, PLANT_SITE_ID
					 , SUM(QTY) AS QTY
				FROM DM_PLN_MKT_FCST WITH (NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND MEASURE IN ('Customer Fcst', 'CUST_FCST_EDI')
				AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) --당주 월요일 이후 데이터
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD, PLANT_SITE_ID
			) A
			GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
					   			 		  
		DECLARE @ROWCNT INT
		SET @ROWCNT = @@ROWCOUNT		
		
		--------------------------------------------------------------------------------------------------------
		-- 대상데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'TARGET DATA';  
		SET @v_description = N'#TEMP_MKT_FCST_DATA INSERT: DIVISION_ID ' + @p_division_id;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @ROWCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- 대상데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------
		--당주 월요일 이후의 대상이 될 데이터를 먼저 삭제한다.
		DELETE DM_PLN_MKT_FCST
		FROM DM_PLN_MKT_FCST A
		WHERE DIVISION_ID = @p_division_id
		AND MEASURE = 'CUST_FCST'
		AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) --당주 월요일 이후 데이터
				  
		DECLARE @DELETECNT INT
		SET @DELETECNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------
		-- DELETE 데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'MKT FCST DELETE DATA';  
		SET @v_description = N'MKT FCST DELETE: DIVISION_ID ' + @p_division_id;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @DELETECNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- DELETE 데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------

		--삭제 후 데이터를 INSERT 한다.
		INSERT INTO DM_PLN_MKT_FCST
		(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
		, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			 , QTY, @v_batch_user AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_batch_user AS LAST_UPDATED_BY ,GETDATE() AS LAST_UPDATE_DATE
			 , '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, '' AS ATTRIBUTE5
			 , '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
		FROM #TEMP_MKT_FCST_DATA
		
		DECLARE @INSERTCNT INT
		SET @INSERTCNT = @@ROWCOUNT

		--------------------------------------------------------------------------------------------------------
		-- INSERT 데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'MKT FCST INSERT DATA';  
		SET @v_description = N'MKT FCST INSERT: DIVISION_ID ' + @p_division_id;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @INSERTCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		--------------------------------------------------------------------------------------------------------
		-- INSERT 데이터 LOG (END)
		--------------------------------------------------------------------------------------------------------

        COMMIT WORK;		
		END TRY

    BEGIN CATCH	 
	  ROLLBACK TRANSACTION MAKE_CUST_FCST;
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
    SET @v_description = 'MKT FCST TARGET DIVISION_ID: ' + @p_division_id + ' DATA= ' + Convert(NVARCHAR(10), @ROWCNT) +  ' / MKT FCST DELETE DATA= ' + Convert(NVARCHAR(10), @DELETECNT)
	                      +  ' / MKT FCST INSERT DATA= ' + Convert(NVARCHAR(10), @INSERTCNT) + '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------------------------------------------------
	-- 종료 LOG (END)
	--------------------------------------------------------------------------------------------------------

	ERR_RTN:
	IF @v_log_type = 'INVALID'
	  BEGIN
	     ROLLBACK TRANSACTION MAKE_CUST_FCST
         EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  END 

END	