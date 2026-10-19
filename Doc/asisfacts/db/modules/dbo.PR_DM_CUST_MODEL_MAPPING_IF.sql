
/*============================================================================================================================
 * Program ID   : PR_DM_CUST_MODEL_MAPPING_IF
 * Description  : N:N Model Mapping 데이터 기초값 생성 
 * 테이블		: DM_CUST_MODEL_MAPPING_M
 * Program History
 *=============================================================================================================================
 *	 Date		In Charge		Description
 *=============================================================================================================================
 * 2024.12.09    KANG.H.J		[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2025.09.16    JSSBAE			[E20250910-000974]_NN Mapping Master 컬럼 추가 요청
 * 2025.10.22    JSSBAE			[E20251016-001453]_ERP NN Mapping 데이터 반영 수행시간 단축 및 로그 보완

 EXEC PR_DM_CUST_MODEL_MAPPING_IF 'ERP'    --ERP만 해당함.
 *============================================================================================================================*/

CREATE   PROCEDURE [dbo].[PR_DM_CUST_MODEL_MAPPING_IF]  
	@p_accept_flag		NVARCHAR(10)	-- 업무구분(ERP)
AS 
 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON; 
	
	--====================================================================================================	
	-- LOG 용 변수 설정 (START)
	--====================================================================================================
	DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_DM_CUST_MODEL_MAPPING_IF';
	DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
	DECLARE @N_LOG_COUNT		INTEGER = 0;
	DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
	DECLARE @V_DESCRIPTION		NVARCHAR(500);
	DECLARE @D_EVENT_DATE		DATETIME;
	DECLARE @N_DELETE_COUNT		INTEGER = 0;
	DECLARE @N_INSERT_COUNT     INTEGER = 0;
	DECLARE @V_CREATED_BY		NVARCHAR(150)	= 'SYS_BATCH_DATA'; 
	--====================================================================================================	
	-- LOG 용 변수 설정 (END)
	--====================================================================================================
		
	--====================================================================================================
	-- 시작 LOG (START)
	--====================================================================================================
	SET @V_LOG_TYPE		= 'START';
	SET @V_LOG_MESSAGE	= '########## START OF PROCEDURE ##########';
	SET @V_DESCRIPTION	= 'PR_DM_CUST_MODEL_MAPPING_IF: ' +  @p_accept_flag;
	SET @D_EVENT_DATE	= SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
	--====================================================================================================
	-- 시작 LOG (END)
	--====================================================================================================
 
	DECLARE @v_delimiter		NVARCHAR(1);
    DECLARE @v_accept_flag		NVARCHAR(10)	= @p_accept_flag ;
	DECLARE @v_CNT				INTEGER			= 0; 
			 
	--====================================================================================================
	-- [E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (START)
	--====================================================================================================
	IF OBJECT_ID (N'tempdb..#TEMP_EDI_CALLOFF_ITEM_MAPPING_IF', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_EDI_CALLOFF_ITEM_MAPPING_IF;
		
	CREATE TABLE #TEMP_EDI_CALLOFF_ITEM_MAPPING_IF
	( DIVISION_ID			NVARCHAR(30)
	, COMPANY_ID			NVARCHAR(30)
	, SOLDTO_CODE			NVARCHAR(10)
	, SHIPTO_CODE			NVARCHAR(10)
	, UNLOADING_POINT		NVARCHAR(35)
	, CUSTOMER_PLANT		NVARCHAR(50)
	, CUST_MATERIAL_CODE	NVARCHAR(50)
	, SCM_SITE_ID			NVARCHAR(30)
	, PROJECT_CODE			NVARCHAR(50)
	, ITEM_ID				NVARCHAR(50)
	, DC_LEVEL				NVARCHAR(50))

	--====================================================================================================
	-- [E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (END)
	--====================================================================================================

PRINT @V_PROGRAM_NAME + ' : A001--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;		
	 
	IF @v_accept_flag = 'ERP'  
	BEGIN	
PRINT @V_PROGRAM_NAME + ' : A002--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;		
		------------------------------------------------------------------------------------------------------
		-- 기 점검시 'X'로 처리된 것을 'N'으로 변환하여 재점검할 수 있도록 조치함.
		------------------------------------------------------------------------------------------------------
		UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN 
		   SET TRANSFER_FLAG = 'N'
		 WHERE TRANSFER_FLAG = 'X';
		 
PRINT @V_PROGRAM_NAME + ' : A003--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;		

		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (START)
		------------------------------------------------------------------------------------------------------------------------------------
		SET @v_log_type    = 'APPEND';
		SET @v_log_message = N'PR_DM_CUST_MODEL_MAPPING_IF TRANSFER_FLAG컬럼:X값 N으로 UPDATE';
		SET @v_description = + N'[PR_DM_CUST_MODEL_MAPPING_IF : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (END)
		------------------------------------------------------------------------------------------------------------------------------------

		UPDATE X
		   SET X.TRANSFER_FLAG = 'X'
		  FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN X
		 WHERE X.TRANSFER_FLAG = 'N'
		   AND NOT EXISTS (	/*아래 내용은 기준정보가 있기 때문에 이를 제외하고 'X' 처리함.*/
							SELECT IF_SEQ, SEQ
							  FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN A WITH(NOLOCK)
							 INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
								     ON A.DIVISION_ID	= B.DIVISION_ID
							        AND B.VALID_YN		= 'Y'
							 INNER JOIN SCM_MST_SITE_CUSTOMER C WITH(NOLOCK)
									 ON A.DIVISION_ID	= C.DIVISION_ID
							        AND B.SCM_SITE_ID	= C.SCM_SITE_ID
							        AND A.SOLDTO_CODE	= C.SOLDTO_CODE
							        AND A.SHIPTO_CODE	= C.SHIPTO_CODE
							        AND C.VALID_YN		= 'Y'
							 INNER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK)
									 ON  A.DIVISION_ID	= C.DIVISION_ID
							        AND B.SCM_SITE_ID	= D.SCM_SITE_ID
							        AND A.ITEM_ID		= D.ITEM_ID
							        AND ISNULL(D.ATTRIBUTE6, '')  != '' -- 2025.01.10 Philsu Park: Incoterms 등록되어 있어야 함.
 							        AND ISNULL(D.SALES_PLANT, '') != '' -- 2025.01.10 Philsu Park: Plant Site 등록되어 있어야 함.
							 INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E WITH(NOLOCK)
									 ON  A.ERP_SA_ORG_ID= E.SEGMENT1
							        AND E.LOOKUP_TYPE	= 'DM_EDI_COMPANY_DIVISION_MAPPING' 
							        AND E.SEGMENT3		= 'Y'
							 WHERE TRANSFER_FLAG IN ('N')
							   AND A.IF_SEQ = X.IF_SEQ
							   AND A.SEQ	= X.SEQ	);

PRINT @V_PROGRAM_NAME + ' : A004--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;		

		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (START)
		------------------------------------------------------------------------------------------------------------------------------------
		SET @v_log_type    = 'APPEND';
		SET @v_log_message = N'PR_DM_CUST_MODEL_MAPPING_IF TRANSFER_FLAG컬럼:N값 X으로 UPDATE';
		SET @v_description = + N'[PR_DM_CUST_MODEL_MAPPING_IF : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (END)
		------------------------------------------------------------------------------------------------------------------------------------

		DECLARE @if_seq			VARCHAR(50);
		DECLARE @seq			NUMERIC(20,10);
		DECLARE @idx			INT;
		SET     @idx = 0;

		DECLARE CUR_XIF_CUST_DEMAND_MAPPING_MST_R CURSOR FOR  
		SELECT IF_SEQ, SEQ
		FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN WITH(NOLOCK)
		WHERE TRANSFER_FLAG IN ('N') -- 'X'는 기준정보가 없는 모델이라 적재필요성 없음.	
		;

		OPEN CUR_XIF_CUST_DEMAND_MAPPING_MST_R; 

		FETCH NEXT FROM CUR_XIF_CUST_DEMAND_MAPPING_MST_R
		INTO	@if_seq, @seq

		WHILE(@@FETCH_STATUS = 0) 
		BEGIN
PRINT @V_PROGRAM_NAME + ' : A005--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;		

			UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN 
			SET TRANSFER_FLAG	= 'P'
			WHERE IF_SEQ		= @if_seq
			AND   SEQ			= @seq;

			BEGIN TRY	-- MERGE 문 실패할 경우 CATCH문을 통해서 예외처리함.
				MERGE INTO DM_CUST_MODEL_MAPPING_M A
				USING 
				(	SELECT   'ERP'				AS DATA_TYPE_CODE
							, E.SEGMENT2		AS DIVISION_ID			--A.DIVISION_ID (81로만 오기 때문에 / JOINT VENTURE 고려 필요함.)
							, A.ERP_SA_ORG_ID	AS COMPANY_ID
							, A.SOLDTO_CODE
							, A.SHIPTO_CODE
							, ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'')							AS UNLOADING_POINT
							, SUBSTRING (ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),''), 1, 4)			AS CUSTOMER_PLANT
							, ISNULL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)),'')							AS CUST_MATERIAL_CODE
							, B.END_CUSTOMER														AS END_CUSTOMER
							, B.SCM_SITE_ID
							, D.PROJECT_CODE
							, 'MPS'										AS FCST_TYPE
							, D.ATTRIBUTE6								AS INCOTERMS
							, 'E'										AS DOM_EXP
							, A.ITEM_ID
							, A.VALID_FROM_DATE							AS VALID_START_DATE
							, A.VALID_TO_DATE							AS VALID_END_DATE
							, 'Y'										AS ACTIVE_YN
							, @V_PROGRAM_NAME							AS CREATED_BY 
							, GETDATE()									AS CREATION_DATE
							, @V_PROGRAM_NAME							AS LAST_UPDATED_BY 
							, GETDATE()									AS LAST_UPDATE_DATE
					-- IF_SEQ, SEQ 기준으로 1건만. USING 절에서 오류 방지. 2026.08.19. 자이오넥스 홍성대  
					--FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN A WITH(NOLOCK)
                    FROM ( SELECT *, ROW_NUMBER() OVER ( PARTITION BY IF_SEQ, SEQ
                                                         ORDER BY TRANSFER_DATE DESC ) AS ROW_NUMS
                             FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN WITH(NOLOCK) ) A
					------------------------------------------------------------------------------------------------------------------------------------------
					--[E20250910-000974]_JV가 받아들여지려면 해당 부분으로 수정해야함 위치변경 (START)
					------------------------------------------------------------------------------------------------------------------------------------------					
					INNER JOIN ( SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3
								   FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
								  WHERE LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING' 
									AND	SEGMENT3    = 'Y' ) E
							ON A.ERP_SA_ORG_ID				= E.SEGMENT1
						   AND E.LOOKUP_TYPE				= 'DM_EDI_COMPANY_DIVISION_MAPPING' 
						   AND E.SEGMENT3					= 'Y'
					------------------------------------------------------------------------------------------------------------------------------------------
					--[E20250910-000974]_JV가 받아들여지려면 해당 부분으로 수정해야함 위치변경 (END)
					------------------------------------------------------------------------------------------------------------------------------------------	
					INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
						  --ON A.DIVISION_ID				= B.DIVISION_ID --[E20250910-000974]_주석처리
							ON E.SEGMENT2					= B.DIVISION_ID --[E20250910-000974]_변경
						   AND B.VALID_YN					= 'Y'
					INNER JOIN SCM_MST_SITE_CUSTOMER C WITH(NOLOCK)
						  --ON A.DIVISION_ID				= C.DIVISION_ID --[E20250910-000974]_주석처리
							ON E.SEGMENT2					= C.DIVISION_ID --[E20250910-000974]_변경
						   AND B.SCM_SITE_ID				= C.SCM_SITE_ID
						   AND A.SOLDTO_CODE				= C.SOLDTO_CODE
						   AND A.SHIPTO_CODE				= C.SHIPTO_CODE
						   AND C.VALID_YN					= 'Y'
						   --AND C.REP_YN					= 'Y'
					INNER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK)
						  --ON A.DIVISION_ID				= D.DIVISION_ID --[E20250910-000974]_주석처리
							ON E.SEGMENT2					= D.DIVISION_ID --[E20250910-000974]_변경
						   AND B.SCM_SITE_ID				= D.SCM_SITE_ID
						   AND A.ITEM_ID					= D.ITEM_ID
						   AND ISNULL(D.ATTRIBUTE6, '')		!= '' -- 2025.01.10 Philsu Park: Incoterms 등록되어 있어야 함.
						   AND ISNULL(D.SALES_PLANT, '')	!= '' -- 2025.01.10 Philsu Park: Plant Site 등록되어 있어야 함.
					WHERE A.TRANSFER_FLAG	= 'P'
					  AND A.IF_SEQ			= @if_seq
					  AND A.SEQ				= @seq
					  -- IF_SEQ, SEQ 기준으로 1건만. USING 절에서 오류 방지. 2026.08.19. 자이오넥스 홍성대
					  AND A.ROW_NUMS        = 1
					  ) B
				ON	(	A.DATA_TYPE_CODE	= B.DATA_TYPE_CODE
			   AND		A.DIVISION_ID		= B.DIVISION_ID
			   AND		A.COMPANY_ID		= B.COMPANY_ID
			   AND		A.SOLDTO_CODE		= B.SOLDTO_CODE
			   AND		A.SHIPTO_CODE		= B.SHIPTO_CODE
			   AND		ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'')	= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)),'')
			   AND		ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)),'')
			   AND		ISNULL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'')	= ISNULL(RTRIM(LTRIM(B.CUST_MATERIAL_CODE)),'')
			   AND		A.SCM_SITE_ID		= B.SCM_SITE_ID
			   AND		A.PROJECT_CODE		= B.PROJECT_CODE
			   AND		A.FCST_TYPE			= B.FCST_TYPE
			   AND		A.INCOTERMS			= B.INCOTERMS
			   AND		A.DOM_EXP			= B.DOM_EXP
			   AND		A.ITEM_ID			= B.ITEM_ID	)
				WHEN MATCHED THEN
				UPDATE SET 	A.END_CUSTOMER		= B.END_CUSTOMER
						  , A.VALID_START_DATE	= B.VALID_START_DATE
						  , A.VALID_END_DATE	= B.VALID_END_DATE
						  , A.ACTIVE_YN			= B.ACTIVE_YN
						  , A.LAST_UPDATED_BY	= @V_PROGRAM_NAME 
						  , A.LAST_UPDATE_DATE	= GETDATE()
				WHEN NOT MATCHED THEN
				INSERT ( DATA_TYPE_CODE, DIVISION_ID, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, CUSTOMER_PLANT, CUSTOMER_ITEM_ID, END_CUSTOMER, SCM_SITE_ID
					   , PROJECT_CODE, FCST_TYPE, INCOTERMS, DOM_EXP, ITEM_ID, MAPPING_ITEM_ID, VALID_START_DATE, VALID_END_DATE, ACTIVE_YN, CREATED_BY
					   , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
				VALUES ( B.DATA_TYPE_CODE, B.DIVISION_ID, B.COMPANY_ID, B.SOLDTO_CODE, B.SHIPTO_CODE, B.UNLOADING_POINT, B.CUSTOMER_PLANT, B.CUST_MATERIAL_CODE, B.END_CUSTOMER, B.SCM_SITE_ID
					   , B.PROJECT_CODE, B.FCST_TYPE, B.INCOTERMS, B.DOM_EXP, B.ITEM_ID, B.ITEM_ID, B.VALID_START_DATE, B.VALID_END_DATE, B.ACTIVE_YN, B.CREATED_BY 
					   , B.CREATION_DATE, B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE	);

PRINT @V_PROGRAM_NAME + ' : A007--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;		

				UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN 
				SET TRANSFER_FLAG	= 'Y'
				WHERE IF_SEQ		= @if_seq
				AND   SEQ			= @seq	;
			END TRY

			BEGIN CATCH			
				------------------------------------------------------------------------------------------------------
				-- DM_CUST_MODEL_MAPPING_M에 MERGE 실패할 경우 X로 업데이트하여 정리함.
				------------------------------------------------------------------------------------------------------
				UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN 
				SET TRANSFER_FLAG	= 'X'
				WHERE IF_SEQ		= @if_seq
				AND   SEQ			= @seq;

PRINT @V_PROGRAM_NAME + ' : A008--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;		

				--====================================================================================================
				-- ERROR LOG (START)
				--====================================================================================================     
				SET @v_log_type		= 'ERROR';
				SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
				SET @v_description	= 'ERROR_LINE : ' + STR(ERROR_LINE());
				SET @d_event_date	= SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				--====================================================================================================
				-- ERROR LOG (END)
				--====================================================================================================     
			
PRINT @V_PROGRAM_NAME + ' : A009--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;					 
			END CATCH;

			FETCH NEXT FROM CUR_XIF_CUST_DEMAND_MAPPING_MST_R 
			INTO	@if_seq, @seq
		END
		
		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (START)
		------------------------------------------------------------------------------------------------------------------------------------
		SET @v_log_type    = 'APPEND';
		SET @v_log_message = N'PR_DM_CUST_MODEL_MAPPING_IF 1차 UPDATE 완료';
		SET @v_description = + N'[PR_DM_CUST_MODEL_MAPPING_IF : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (END)
		------------------------------------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------------------------------------------
		--[E20251016-001453]_위치 변경 (START)
		------------------------------------------------------------------------------------------------------------------------------------------
		--[E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (START)
		------------------------------------------------------------------------------------------------------------------------------------------
		IF ( SELECT  COUNT(*) FROM DM_DNM_EDI_CALLOFF_ITEM WITH(NOLOCK)  WHERE ISNULL(DC_LEVEL,'') != '' ) > 0 
		BEGIN
			INSERT INTO #TEMP_EDI_CALLOFF_ITEM_MAPPING_IF
			( DIVISION_ID, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT
			, CUSTOMER_PLANT, CUST_MATERIAL_CODE, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, DC_LEVEL )
			SELECT A.DIVISION_ID, A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE, A.UNLOADING_POINT
					, A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.DC_LEVEL
			FROM (	SELECT DIVISION_ID, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT
							, CUSTOMER_PLANT, CUST_MATERIAL_CODE, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, DC_LEVEL
							, ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, CUSTOMER_PLANT, CUST_MATERIAL_CODE, SCM_SITE_ID, PROJECT_CODE, ITEM_ID ORDER BY IFSEQNO DESC) AS ROW_NUMS
						FROM DM_DNM_EDI_CALLOFF_ITEM WITH(NOLOCK)
						WHERE ISNULL(DC_LEVEL,'') != '') A
			WHERE A.ROW_NUMS = 1

			IF ( SELECT COUNT(*) FROM #TEMP_EDI_CALLOFF_ITEM_MAPPING_IF) > 0
			BEGIN
				UPDATE A
				SET A.DC_LEVEL = B.DC_LEVEL
				FROM DM_CUST_MODEL_MAPPING_M A
				INNER JOIN #TEMP_EDI_CALLOFF_ITEM_MAPPING_IF B
						ON A.DIVISION_ID	= B.DIVISION_ID
						AND A.COMPANY_ID		= B.COMPANY_ID
						AND A.SOLDTO_CODE	= B.SOLDTO_CODE
						AND A.SHIPTO_CODE	= B.SHIPTO_CODE
						AND ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'')	= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)),'')
						AND ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)),'')
						AND ISNULL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'')	= ISNULL(RTRIM(LTRIM(B.CUST_MATERIAL_CODE)),'')
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
						AND A.ITEM_ID		= B.ITEM_ID					
			END					
		END	
		
		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (START)
		------------------------------------------------------------------------------------------------------------------------------------
		SET @v_log_type    = 'APPEND';
		SET @v_log_message = N'PR_DM_CUST_MODEL_MAPPING_IF DC_LEVEL UPDATE 완료';
		SET @v_description = + N'[PR_DM_CUST_MODEL_MAPPING_IF : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
		------------------------------------------------------------------------------------------------------------------------------------
		-- APPEND LOG (END)
		------------------------------------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------------------------------------------
		--[E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (END)
		------------------------------------------------------------------------------------------------------------------------------------------
		--[E20251016-001453]_위치 변경 (END)
		------------------------------------------------------------------------------------------------------------------------------------------

		CLOSE CUR_XIF_CUST_DEMAND_MAPPING_MST_R; 
		DEALLOCATE CUR_XIF_CUST_DEMAND_MAPPING_MST_R;

	END;	
	
	--====================================================================================================
	-- 종료 LOG (START)
	--====================================================================================================   
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--====================================================================================================
	-- 종료 LOG (END)
	--====================================================================================================   
		
PRINT @V_PROGRAM_NAME + ' : A010--' + CONVERT(NVARCHAR(30), GETDATE(), 121)  + ' / ' + @p_accept_flag;					

END;
