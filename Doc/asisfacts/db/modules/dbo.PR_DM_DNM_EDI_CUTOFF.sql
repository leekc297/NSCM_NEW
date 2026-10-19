---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*
 * Program ID   : PR_DM_DNM_EDI_CUTOFF
 * Description  : EDI 데이터 위클리 컷오프
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.12.03     HWI1993 Initial Release [PJ20209643] EDI 분석 툴 
 * 2021.12.30	hwi1993		컷오프 일자 기준으로 실적구간은 backlog ( scheduling_type = '83' )만으로 구성
 * 2022.02.03	HWI1993		컷오프 주기 변경 ( WEEKLY --> DAILY ) 
 * 2022.02.24   kdw2819     [과제][PJ20216891R] LGES Digital SCM 3 Level 가속화를 위한 개선 - BMW EDI WATERFALL
   2022.04.05   HWI1993     GM JV 작업
 */

CREATE PROCEDURE [dbo].[PR_DM_DNM_EDI_CUTOFF]
AS
BEGIN


	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_ver_description		NVARCHAR(MAX);
	DECLARE @v_ver_type				NVARCHAR(MAX);
	DECLARE @v_rolling_type			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	DECLARE @n_history_seq			INTEGER;
	DECLARE @v_plan_week			NVARCHAR(MAX);
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	
    DECLARE	@v_yyyymmdd		        NCHAR(8);	    -- 실적 backlog 날짜(CUTOFF 날짜의 전주 일요일)  

	SET @v_division_id		 = NULL;	
	SET @v_ver_description	 = NULL;	
	SET @v_ver_type			 = NULL;	
	SET @v_rolling_type		 = NULL;	
	SET @v_created_by		 = NULL;	
    SET @v_yyyymmdd          = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	---- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_EDI_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	/*
		-----------------------------------------------------------------------------------------
		100
			: START LOG
		-----------------------------------------------------------------------------------------
	*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = ''
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN 

	BEGIN TRY


		BEGIN
			EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
			'81',
			N'EDI CALLOFF WEEKLY CUTOFF',
			N'EC_D',
			N'EDI_SYS',
			@v_ver_return_no  OUTPUT,
			@v_OK_description OUTPUT

			
            -- 실적 backlog 날짜(CUTOFF 날짜의 전주 일요일)  
            SET @v_yyyymmdd = CONVERT(NCHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'SUN')), 112)
			-- 1. BMW 고객사 정보를 가져온다. ( SHIPTO, SOLDTO )

			CREATE TABLE #T_CUSTOMER (
			SOLDTO_CODE		NVARCHAR(10),
			SHIPTO_CODE		NVARCHAR(10),
			)
			
			CREATE TABLE #T_PO (
			PO_NO               NVARCHAR(35)
			, MAX_NO	        NVARCHAR(35)
            -- [과제] BMW
            , UNLOADING_POINT	NVARCHAR(35)
            , SOLDTO_CODE	    NVARCHAR(10)
            , SHIPTO_CODE	    NVARCHAR(10)
			)

			INSERT INTO #T_CUSTOMER ( SOLDTO_CODE, SHIPTO_CODE )
			SELECT DISTINCT B.SOLDTO_CODE, B.SHIPTO_CODE
			FROM SCM_MST_SITE A
			JOIN SCM_MST_SITE_CUSTOMER B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON A.END_CUSTOMER = C.SEGMENT2 AND A.DIVISION_ID = C.SEGMENT1 AND C.LOOKUP_TYPE = 'DM_EDI_CUTOFF_CUSTOMER'

			-- 2. 데이터 추출
			INSERT INTO #T_PO ( PO_NO, MAX_NO, UNLOADING_POINT, SOLDTO_CODE, SHIPTO_CODE )
			SELECT CUSTOMER_PO_NO, MAX(TRY_PARSE(CUSTOMER_CALL_OFF_NO AS INT)) AS MAX_NO, UNLOADING_POINT, A.SOLDTO_CODE, A.SHIPTO_CODE
			FROM DM_DNM_EDI_CALLOFF_ITEM A
			JOIN #T_CUSTOMER B ON A.SOLDTO_CODE = B.SOLDTO_CODE AND A.SHIPTO_CODE = B.SHIPTO_CODE
			WHERE CREATE_DATE >= CONVERT(NCHAR(8), DATEADD(MONTH, -1, GETDATE()), 112)
			GROUP BY CUSTOMER_PO_NO, UNLOADING_POINT, A.SOLDTO_CODE, A.SHIPTO_CODE


			IF EXISTS (
				SELECT *
				FROM DM_DNM_EDI_CALLOFF_ITEM_C
				WHERE DIVISION_ID LIKE '81%'
					AND VERSION_NO = @v_ver_return_no
					)
			BEGIN 
				DELETE 
				FROM DM_DNM_EDI_CALLOFF_ITEM_C
				WHERE DIVISION_ID LIKE '81%'
					AND VERSION_NO = @v_ver_return_no
			END


			INSERT INTO DM_DNM_EDI_CALLOFF_ITEM_C
				 ( EDI_IF_SEQ, SUB_NO, YYYYMMDD, VERSION_NO, DIVISION_ID
				 , CUST_MATERIAL_CODE, QTY, ORIGIN_QTY, CUTOFF_TYPE
				 , CUTOFF_YYYYMMDD, CUSTOMER_PO_NO, CUSTOMER_CALL_OFF_NO, SOLDTO_CODE, COMPANY_ID
				 , MESSAGE_REFERENCE, MESSAGE_TYPE, DOC_IDENTIFINER, SHIPTO_CODE, PARTNER_TYPE
				 , SHIPTO_SEQ, SHIP_TO_ITEM_SEQ, ITEM_ID, CUSTOMER_PLANT, UNLOADING_POINT
				 , SCHEDULING_TYPE, RDD_START, UOM, RDD_END, CUSTOMER_CALL_OFF_DATE
				 , PREVIOUS_CALL_OFF_NO, PREVIOUS_CALL_OFF_DATE, COMPANY_NAME, SHIPTO_NAME1, SHIPTO_NAME2
				 , TRANSACTION_FLAG, ERP_FCST_TYPE, CREATE_USER_ID, CREATE_DATE, CREATE_TIME
				 , UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME, VALID_YN, CREATED_BY
				 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
				 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			-- 계획
			SELECT EDI_IF_SEQ, SUB_NO, YYYYMMDD, @v_ver_return_no AS VERSION_NO, DIVISION_ID
				 , CUST_MATERIAL_CODE, QTY, ORIGIN_QTY, 'EC_D' AS CUTOFF_TYPE
				 , CONVERT(NCHAR(8), GETDATE(), 112) AS CUTOFF_YYYYMMDD, CUSTOMER_PO_NO, CUSTOMER_CALL_OFF_NO, B.SOLDTO_CODE, COMPANY_ID
				 , MESSAGE_REFERENCE, MESSAGE_TYPE, DOC_IDENTIFINER, B.SHIPTO_CODE, PARTNER_TYPE
				 , SHIPTO_SEQ, SHIP_TO_ITEM_SEQ, ITEM_ID, CUSTOMER_PLANT, B.UNLOADING_POINT
				 , SCHEDULING_TYPE, RDD_START, UOM, RDD_END, CUSTOMER_CALL_OFF_DATE
				 , PREVIOUS_CALL_OFF_NO, PREVIOUS_CALL_OFF_DATE, COMPANY_NAME, SHIPTO_NAME1, SHIPTO_NAME2
				 , TRANSACTION_FLAG, ERP_FCST_TYPE, CREATE_USER_ID, CREATE_DATE, CREATE_TIME
				 , UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME, VALID_YN, CREATED_BY
				 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
				 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM  #T_PO A
			JOIN DM_DNM_EDI_CALLOFF_ITEM B ON A.PO_NO = B.CUSTOMER_PO_NO AND A.MAX_NO = B.CUSTOMER_CALL_OFF_NO AND A.UNLOADING_POINT = B.UNLOADING_POINT AND A.SOLDTO_CODE = B.SOLDTO_CODE AND A.SHIPTO_CODE = B.SHIPTO_CODE
			WHERE B.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일 이후 데이터는 SCHEDULING_TYPE 4, 10, 24  만 처리
				AND B.SCHEDULING_TYPE IN ('4','10','24')
			
			UNION ALL	-- 실적구간
			SELECT EDI_IF_SEQ, SUB_NO, @v_yyyymmdd AS YYYYMMDD, @v_ver_return_no AS VERSION_NO, DIVISION_ID
				 , CUST_MATERIAL_CODE, QTY, ORIGIN_QTY, 'EC_D' AS CUTOFF_TYPE
				 , CONVERT(NCHAR(8), GETDATE(), 112) AS CUTOFF_YYYYMMDD, CUSTOMER_PO_NO, CUSTOMER_CALL_OFF_NO, B.SOLDTO_CODE, COMPANY_ID
				 , MESSAGE_REFERENCE, MESSAGE_TYPE, DOC_IDENTIFINER, B.SHIPTO_CODE, PARTNER_TYPE
				 , SHIPTO_SEQ, SHIP_TO_ITEM_SEQ, ITEM_ID, CUSTOMER_PLANT, B.UNLOADING_POINT
				 , SCHEDULING_TYPE, RDD_START, UOM, RDD_END, CUSTOMER_CALL_OFF_DATE
				 , PREVIOUS_CALL_OFF_NO, PREVIOUS_CALL_OFF_DATE, COMPANY_NAME, SHIPTO_NAME1, SHIPTO_NAME2
				 , TRANSACTION_FLAG, ERP_FCST_TYPE, CREATE_USER_ID, CREATE_DATE, CREATE_TIME
				 , UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME, VALID_YN, CREATED_BY
				 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
				 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM  #T_PO A
			JOIN DM_DNM_EDI_CALLOFF_ITEM B ON A.PO_NO = B.CUSTOMER_PO_NO AND A.MAX_NO = B.CUSTOMER_CALL_OFF_NO AND A.UNLOADING_POINT = B.UNLOADING_POINT AND A.SOLDTO_CODE = B.SOLDTO_CODE AND A.SHIPTO_CODE = B.SHIPTO_CODE
			WHERE B.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일 이후 데이터는 SCHEDULING_TYPE 4, 10, 24  만 처리
				AND B.SCHEDULING_TYPE IN ('83')
			



			-- 3. INSERT 
			--INSERT INTO DM_DNM_EDI_CALLOFF_ITEM_C
			--	 ( EDI_IF_SEQ, SUB_NO, YYYYMMDD, VERSION_NO, DIVISION_ID
			--	 , CUST_MATERIAL_CODE, QTY, ORIGIN_QTY, CUTOFF_TYPE
			--	 , CUTOFF_YYYYMMDD, CUSTOMER_PO_NO, CUSTOMER_CALL_OFF_NO, SOLDTO_CODE, COMPANY_ID
			--	 , MESSAGE_REFERENCE, MESSAGE_TYPE, DOC_IDENTIFINER, SHIPTO_CODE, PARTNER_TYPE
			--	 , SHIPTO_SEQ, SHIP_TO_ITEM_SEQ, ITEM_ID, CUSTOMER_PLANT, UNLOADING_POINT
			--	 , SCHEDULING_TYPE, RDD_START, UOM, RDD_END, CUSTOMER_CALL_OFF_DATE
			--	 , PREVIOUS_CALL_OFF_NO, PREVIOUS_CALL_OFF_DATE, COMPANY_NAME, SHIPTO_NAME1, SHIPTO_NAME2
			--	 , TRANSACTION_FLAG, ERP_FCST_TYPE, CREATE_USER_ID, CREATE_DATE, CREATE_TIME
			--	 , UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME, VALID_YN, CREATED_BY
			--	 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			--	 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
			--	 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			--SELECT EDI_IF_SEQ, SUB_NO, YYYYMMDD, VERSION_NO, DIVISION_ID
			--	 , CUST_MATERIAL_CODE, QTY, ORIGIN_QTY, CUTOFF_TYPE
			--	 , CUTOFF_YYYYMMDD, CUSTOMER_PO_NO, CUSTOMER_CALL_OFF_NO, SOLDTO_CODE, COMPANY_ID
			--	 , MESSAGE_REFERENCE, MESSAGE_TYPE, DOC_IDENTIFINER, SHIPTO_CODE, PARTNER_TYPE
			--	 , SHIPTO_SEQ, SHIP_TO_ITEM_SEQ, ITEM_ID, CUSTOMER_PLANT, UNLOADING_POINT
			--	 , SCHEDULING_TYPE, RDD_START, UOM, RDD_END, CUSTOMER_CALL_OFF_DATE
			--	 , PREVIOUS_CALL_OFF_NO, PREVIOUS_CALL_OFF_DATE, COMPANY_NAME, SHIPTO_NAME1, SHIPTO_NAME2
			--	 , TRANSACTION_FLAG, ERP_FCST_TYPE, CREATE_USER_ID, CREATE_DATE, CREATE_TIME
			--	 , UPDATE_USER_ID, UPDATE_DATE, UPDATE_TIME, VALID_YN, CREATED_BY
			--	 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			--	 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
			--	 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			--FROM   DM_DNM_EDI_CALLOFF_ITEM
			
		END;

		COMMIT TRAN ;	
 
	END TRY
    BEGIN CATCH
			ROLLBACK TRAN  ;	


			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date = SYSDATETIME();
			SELECT 'catch', @v_log_message 

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @v_ver_return_no
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
  END; 





