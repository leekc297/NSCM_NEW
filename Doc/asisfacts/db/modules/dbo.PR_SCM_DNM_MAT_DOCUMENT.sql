
/*====================================================================================================================
 * Program ID   : PR_SCM_DNM_MAT_DOCUMENT
 * Description  : 자재 입/출고 정보 I/F
 * Program History
 *====================================================================================================================
 *	  Date		In Charge		Description
 *====================================================================================================================
 * 2018.01.04	Kim Jaejung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *								참조: 인터페이스 대상에 해당하는 데이터만 비교 후 History 저장(INSERT 된 데이터는 남기지 않음)
 * 2020.09.03	HWI1993			[C20200416-000194] 등  VMI CSR 3건
 * 2020.10.23	hwi1993			[C20200416-000194] 배포시 오류때문에 재배포함. CSR은 [C20200416-000194], 수정사항은 없음.
 * 2020.10.23	hwi1993			원래 FP 에서 SLOC 중 일부를 제거하고 보내는 로직이 있어서 룩업을 추가함.
 * 2021.01.25	P.C.I			[C20210112-000453] IF Table 업데이트 완료 후 Truncate
 * 2021.03.25	hwi1993			[C20210325-000347] VMI Biz - 자재문서 보관 후 삭제처리
 * 2021.09.09	SJHAN			[C20210908-000163] Vmi in Req 실적 구간 로직 수정
 * 2021.09.17	hwi1993			[PJ20209643] AS 프로세스 - AS Plant 의 SLoC 추가
 * 2022.04.25	rosia27			[C20220411-000452]출하실적 IF 테이블 보관기간 증량 요청, [PJ20209643]수정로직 주석처리
 * 2025.03.08	chkim.68		[SCM.FP] RFC FP00975_ERP_MATERIAL_DOCUMENT 수신 중지하고 DM 수신 RFC 데이터를 사용
 * 2025.06.19	김준규			[IT20250117A] NERP 오펀차수별 Mapping Code적용
 * 2025.07.01	JSSBAE			[IT20250117A] NERP XIF 직접 UPDATE 하는 부분 제거하고 TEMP로 작업하도록 재수정
 ====================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_SCM_DNM_MAT_DOCUMENT]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	
	--====================================================================================================================
    -- LOG 용 변수 설정 (START)
	--====================================================================================================================
    DECLARE @v_batch_user	NVARCHAR(150) = 'scm_batch';
    DECLARE @v_program_name	NVARCHAR(150) = 'PR_SCM_DNM_MAT_DOCUMENT';
    DECLARE @v_log_type		NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno		NVARCHAR(30);
    DECLARE @n_history_seq	BIGINT;
	--====================================================================================================================
    -- LOG 용 변수 설정 (END)
	--====================================================================================================================
	--====================================================================================================================
    -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 (START)
	--====================================================================================================================
    DECLARE @V_NERP_ROLLIN_STAGE			NVARCHAR(30);
    DECLARE @V_NERP_RESULT_START_YYYYMMDD	NVARCHAR(8);

    SELECT TOP 1 @V_NERP_ROLLIN_STAGE		= LMD.SEGMENT1
          , @V_NERP_RESULT_START_YYYYMMDD	= LMD.SEGMENT3
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH(NOLOCK)
    JOIN   SCM_ADM_LOOKUP_MASTER ALM WITH(NOLOCK)
    ON     ALM.LOOKUP_TYPE	= LMD.LOOKUP_TYPE
    AND    ALM.LOOKUP_TYPE	= 'NERP_ROLLIN_STAGE'
    WHERE  ALM.VALID_YN		= 'Y'
    AND    LMD.VALID_YN		= 'Y';
	--====================================================================================================================
    -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 (END)
	--====================================================================================================================
	--====================================================================================================================
    -- 시작 LOG (START)
	--====================================================================================================================
    SET @v_log_type		= 'START';
    SET @v_log_message	= '########## Start of procedure ##########';
    SET @v_description	= '';
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--====================================================================================================================
    -- 시작 LOG (END)
	--====================================================================================================================

    BEGIN TRY
		BEGIN
			--====================================================================================================================
			-- 인터페이스 테이블 처리 ROW UPDATE
			--====================================================================================================================
			UPDATE XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN
			SET	  TRANSFER_FLAG = 'P'
			WHERE ISNULL(TRANSFER_FLAG,'N') = 'N';
			
			--====================================================================================================================
			--[IT20250117A]_NERP 데이터 보정작업 진행 START 
			--====================================================================================================================
			DECLARE @T_COMPANY_ID TABLE 
			(	OLD_COMPANY_ID	NVARCHAR(254) NOT NULL PRIMARY KEY
			,	NEW_COMPANY_ID	NVARCHAR(254) 
			,	MAX_ATTRIBUTE5	NVARCHAR(30));

			INSERT INTO @T_COMPANY_ID
			SELECT OLD_VALUE1, NEW_VALUE1, MAX(ATTRIBUTE5) AS ATTRIBUTE5
			FROM   NERP_CONV_MASTER NCM WITH(NOLOCK)
			WHERE  NCM.CODETYPE		= 'COMPANY_ID'
			AND    NCM.ATTRIBUTE5  <= @V_NERP_ROLLIN_STAGE
			GROUP BY OLD_VALUE1, NEW_VALUE1;
			
			DECLARE @n_update_cnt   INT			= 0; -- COUNT 로그를 잡기위해 변수로 선언한다
			DECLARE @d_start_date   DATETIME	= SYSDATETIME(); --Batch Event Date에 Start Date를 넣어서 실제 실행된 시간 비교

			IF OBJECT_ID (N'tempdb..#TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN', N'U') IS NOT NULL 
				DROP TABLE #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN;

			----------------------------------------------------------------------------------------------------------------------
			-- TEMP 테이블에 인터페이스 데이터를 담는다.
			----------------------------------------------------------------------------------------------------------------------
			SELECT *
			INTO #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN
			FROM XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
			WHERE TRANSFER_FLAG = 'P';
			
			----------------------------------------------------------------------------------------------------------------------
			-- NERP 오픈법인  중복방지를 위해 '@V_NERP_RESULT_START_YYYYMMDD 이전 "NERP" 데이터 삭제
			--@V_NERP_RESULT_START_YYYYMMDD 이전 NERP 데이터 삭제
			----------------------------------------------------------------------------------------------------------------------
			DELETE
			FROM   #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN
			WHERE  COMPANY_ID IN (SELECT DISTINCT NEW_COMPANY_ID FROM @T_COMPANY_ID WHERE MAX_ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE )
			AND    DOC_POSTING_DATE < @V_NERP_RESULT_START_YYYYMMDD;	
			
			SET @n_update_cnt = @@ROWCOUNT;			
			----------------------------------------------------------------------------------------------------------------------
			-- TEMP 테이블에 "NERP" DELETE 된 데이터 건수를 로그에 적재한다 
			----------------------------------------------------------------------------------------------------------------------
			SET @v_log_type    = 'APPEND';  
			SET @v_log_message = N'Delete NERP Result';  
			SET @d_event_date  = @d_start_date;
			SET @n_log_count   = @n_update_cnt;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  

			----------------------------------------------------------------------------------------------------------------------
			-- NERP 오픈법인  중복방지를 위해 @V_NERP_RESULT_START_YYYYMMDD 이후 "GERP" 데이터 삭제' 
			--@V_NERP_RESULT_START_YYYYMMDD 이후 GERP 데이터 삭제
			----------------------------------------------------------------------------------------------------------------------
			DELETE
			FROM   #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN
			WHERE  COMPANY_ID IN (SELECT DISTINCT OLD_COMPANY_ID FROM @T_COMPANY_ID WHERE MAX_ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE )
			AND    DOC_POSTING_DATE >= @V_NERP_RESULT_START_YYYYMMDD;	
			
			SET @n_update_cnt = @@ROWCOUNT;			

			----------------------------------------------------------------------------------------------------------------------
			-- TEMP 테이블에 "GERP" DELETE 된 데이터 건수를 로그에 적재한다 
			----------------------------------------------------------------------------------------------------------------------
			SET @v_log_type    = 'APPEND';  
			SET @v_log_message = N'Delete GERP Result';  
			SET @d_event_date  = @d_start_date;
			SET @n_log_count   = @n_update_cnt;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date; 
			
			----------------------------------------------------------------------------------------------------------------------
			-- 구코드로 들어온 데이터를 NERP 마스터로 UPDATE 한다
			----------------------------------------------------------------------------------------------------------------------
			UPDATE A
			SET   A.COMPANY_ID		= ISNULL( B.NEW_COMPANY_ID, A.COMPANY_ID)
				, A.CUSTOMER_CODE	= ISNULL( C.NEW_CUSTOMER_ID, A.CUSTOMER_CODE)
				, A.IO_PLANT_ID		= ISNULL( D.NEW_PLANT_ID, A.IO_PLANT_ID )
				, A.IO_STORAGE_ID	= ISNULL( E.NEW_STORAGE_CODE, A.IO_STORAGE_ID )
				, A.MOVEMENT_TYPE	= ISNULL( F.OLD_MOVEMENT_TYPE, A.MOVEMENT_TYPE)
				, A.PLANT_ID		= ISNULL( D.NEW_PLANT_ID, A.PLANT_ID )
				, A.STORAGE_ID		= ISNULL( G.NEW_STORAGE_CODE, A.STORAGE_ID )
				, A.VENDOR_CODE		= ISNULL( H.NEW_VENDOR_ID, A.VENDOR_CODE )
			FROM #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN A
			INNER JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_COMPANY_ID, NEW_VALUE1 AS NEW_COMPANY_ID
						 FROM  NERP_CONV_MASTER WITH(NOLOCK)
						 WHERE CODETYPE  = 'COMPANY_ID'
						 AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) B
				    ON A.COMPANY_ID = B.OLD_COMPANY_ID
			LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_CUSTOMER_ID, NEW_VALUE1 AS NEW_CUSTOMER_ID
						FROM  NERP_CONV_MASTER WITH(NOLOCK)
						WHERE CODETYPE  = 'END_CUSTOMER_ID'
						AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) C
				   ON A.CUSTOMER_CODE = C.OLD_CUSTOMER_ID
			LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_PLANT_ID, NEW_VALUE1 AS NEW_PLANT_ID
						FROM  NERP_CONV_MASTER WITH(NOLOCK)
						WHERE CODETYPE  = 'PLANT_ID'
						AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) D
				   ON A.PLANT_ID = D.OLD_PLANT_ID
			LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_PLANT_CODE, OLD_VALUE2 AS OLD_STORAGE_CODE, NEW_VALUE1 AS NEW_PLANT_CODE, NEW_VALUE2 AS NEW_STORAGE_CODE
						FROM  NERP_CONV_MASTER WITH(NOLOCK)
						WHERE CODETYPE  = 'STORAGE_ID'
						AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) E
				   ON A.IO_PLANT_ID		= E.OLD_PLANT_CODE
				  AND A.IO_STORAGE_ID	= E.OLD_STORAGE_CODE
			LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_MOVEMENT_TYPE, NEW_VALUE1 AS NEW_MOVEMENT_TYPE
						FROM  NERP_CONV_MASTER WITH(NOLOCK)
						WHERE CODETYPE  = 'MOVEMENT_TYPE_ID'
						AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) F
				   ON A.MOVEMENT_TYPE = F.OLD_MOVEMENT_TYPE
			LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_PLANT_CODE, OLD_VALUE2 AS OLD_STORAGE_CODE, NEW_VALUE1 AS NEW_PLANT_CODE, NEW_VALUE2 AS NEW_STORAGE_CODE
						FROM  NERP_CONV_MASTER WITH(NOLOCK)
						WHERE CODETYPE  = 'STORAGE_ID'
						AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) G
				   ON A.PLANT_ID	= G.OLD_PLANT_CODE
				  AND A.STORAGE_ID	= G.OLD_STORAGE_CODE
			LEFT JOIN ( SELECT DISTINCT OLD_VALUE1 AS OLD_VENDOR_ID, NEW_VALUE1 AS NEW_VENDOR_ID
						FROM  NERP_CONV_MASTER WITH(NOLOCK)
						WHERE CODETYPE  = 'VENDOR_ID'
						AND   ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE ) H
				   ON A.VENDOR_CODE = H.OLD_VENDOR_ID
			
			SET @n_update_cnt = @@ROWCOUNT;
			
			----------------------------------------------------------------------------------------------------------------------
			-- TEMP 테이블에 "GERP" NERP 데이터로 컨버젼 된 데이터 건수를 로그에 적재한다 
			----------------------------------------------------------------------------------------------------------------------
			SET @v_log_type    = 'APPEND';  
			SET @v_log_message = N'Update GERP Code';  
			SET @d_event_date  = @d_start_date;
			SET @n_log_count   = @n_update_cnt;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			
			--====================================================================================================================
			--[IT20250117A]_NERP 데이터 보정작업 진행 END 
			--====================================================================================================================
			--====================================================================================================================
			--[SCM.FP] RFC FP00975_ERP_MATERIAL_DOCUMENT 수신 중지하고 DM 수신 RFC 데이터를 사용 START
			-- SCM.FP START RFC IF(FP00975_ERP_MATERIAL_DOCUMENT)를 대체함 (이중 수신하지 않고, 이 프로시저에서 수신한 내용을 복사하여 사용함
			--====================================================================================================================
			BEGIN TRY
				INSERT INTO XIF_ERP_MATERIAL_DOCUMENT_R_SN
				( IFSEQNO, MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, TRADE_TYPE, DOC_TYPE, DOC_PROOF_DATE
				, DOC_POSTING_DATE, DOC_INPUT_DATE, INPUT_DATE, USER_NAME, MOVEMENT_TYPE, ITEM_ID, PLANT_ID
				, STORAGE_ID, BATCH_ID, INVENTORY_TYPE, INDICATOR, SPECIAL_STOCK_INDICATOR, SPECIAL_STOCK_INDICATOR_NAME, VENDOR_CODE
				, CUSTOMER_CODE, CURRENCY, MAT_AMOUNT, MAT_QTY, UOM, INPUT_QTY, INPUT_UOM
				, COMPANY_ID, IO_ITEM_ID, IO_PLANT_ID, IO_STORAGE_ID, IO_BATCH_ID, CREATE_DATE, CREATE_TIME
				, CREATE_USER_ID, UPDATE_DATE, UPDATE_TIME, UPDATE_USER_ID, TRANSFER_DATE, TRANSFER_TIME, TRANSFER_USER_ID
				, TRANSFER_FLAG, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
				, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
				SELECT IFSEQNO, MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, TRADE_TYPE, DOC_TYPE, DOC_PROOF_DATE
					 , DOC_POSTING_DATE, DOC_INPUT_DATE, INPUT_DATE, USER_NAME, MOVEMENT_TYPE, ITEM_ID, PLANT_ID
					 , STORAGE_ID, BATCH_ID, INVENTORY_TYPE, INDICATOR, SPECIAL_STOCK_INDICATOR, SPECIAL_STOCK_INDICATOR_NAME, VENDOR_CODE
					 , CUSTOMER_CODE, CURRENCY, MAT_AMOUNT, MAT_QTY, UOM, INPUT_QTY, INPUT_UOM
					 , COMPANY_ID, IO_ITEM_ID, IO_PLANT_ID, IO_STORAGE_ID, IO_BATCH_ID, CREATE_DATE, CREATE_TIME
					 , CREATE_USER_ID, UPDATE_DATE, UPDATE_TIME, UPDATE_USER_ID, TRANSFER_DATE, TRANSFER_TIME, TRANSFER_USER_ID
					 , 'N' AS TRANSFER_FLAG, 'FP' AS ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15  
				----------------------------------------------------------------------------------------------------------------------			   
				--[IT20250117A]_TEMP 테이블에서 가지고 오는것으로 변경 
				-- from XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN with(nolock)
				----------------------------------------------------------------------------------------------------------------------
				FROM #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN
				WHERE 1=1 
				AND TRANSFER_FLAG = 'P'
					PRINT 'SUCCESS MOVE FP MATERIAL THING'
            END TRY

            BEGIN CATCH
                PRINT 'FAIL MOVE FP MATERIAL THING'
            END CATCH			
			--======================================================================================================================
			--[SCM.FP] RFC FP00975_ERP_MATERIAL_DOCUMENT 수신 중지하고 DM 수신 RFC 데이터를 사용 END
			--======================================================================================================================
			--======================================================================================================================
			-- 지나간 배치까지 적용하기 위해 Cursor 로 처리 (START)
			--======================================================================================================================
			DECLARE CUR_MAT CURSOR FOR
			SELECT IFSEQNO			
			----------------------------------------------------------------------------------------------------------------------
			--[IT20250117A]_TEMP 테이블에서 가지고 오는것으로 변경 
			--FROM XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
			----------------------------------------------------------------------------------------------------------------------
			FROM   #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
			WHERE  TRANSFER_FLAG = 'P'
			GROUP BY IFSEQNO
			ORDER BY IFSEQNO ASC;
			
			----------------------------------------------------------------------------------------------------------------------
			-- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
			--[IT20250117A]_TEMP 테이블명 변경 scm_dnm_mat_document_temp$ -> #TEMP_SCM_DNM_MAT_DOCUMENT
			----------------------------------------------------------------------------------------------------------------------
			--IF OBJECT_ID('dbo.scm_dnm_mat_document_temp$') IS NOT NULL DROP TABLE scm_dnm_mat_document_temp$
			IF OBJECT_ID (N'tempdb..#TEMP_SCM_DNM_MAT_DOCUMENT', N'U') IS NOT NULL 
				DROP TABLE #TEMP_SCM_DNM_MAT_DOCUMENT
				
			----------------------------------------------------------------------------------------------------------------------
			-- 데이터가 누적 되기 때문에, history 비교 시 변경 대상이 되는 row 로만 temp table 생성
			----------------------------------------------------------------------------------------------------------------------
			SELECT * 			
			----------------------------------------------------------------------------------------------------------------------
			--[IT20250117A]_TEMP 테이블명 변경 scm_dnm_mat_document_temp$ -> #TEMP_SCM_DNM_MAT_DOCUMENT
			----------------------------------------------------------------------------------------------------------------------
			--INTO dbo.scm_dnm_mat_document_temp$
			INTO #TEMP_SCM_DNM_MAT_DOCUMENT
			FROM SCM_DNM_MAT_DOCUMENT WITH(NOLOCK)
			WHERE MAT_DOC_ID + MAT_DOC_YEAR + MAT_DOC_ITEM IN ( SELECT MAT_DOC_ID + MAT_DOC_YEAR + MAT_DOC_ITEM 																
																----------------------------------------------------------------------------------------------------------------------
																--[IT20250117A]_TEMP 테이블에서 가지고 오는것으로 변경 
																--FROM XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
																----------------------------------------------------------------------------------------------------------------------
																FROM #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
																WHERE TRANSFER_FLAG = 'P');

			OPEN CUR_MAT;
			FETCH NEXT FROM CUR_MAT INTO @v_ifseqno;

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				MERGE INTO SCM_DNM_MAT_DOCUMENT A
				USING (  /* PR_SCM_DNM_MAT_DOCUMENT */
						SELECT MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, TRADE_TYPE, DOC_TYPE, DOC_PROOF_DATE, DOC_POSTING_DATE
							 , DOC_INPUT_DATE, INPUT_DATE, USER_NAME, MOVEMENT_TYPE, ITEM_ID, PLANT_ID, STORAGE_ID
							 , BATCH_ID, INVENTORY_TYPE, INDICATOR, SPECIAL_STOCK_INDICATOR, SPECIAL_STOCK_INDICATOR_NAME, VENDOR_CODE, CUSTOMER_CODE
							 , CURRENCY, ISNULL(MAT_AMOUNT,0) AS MAT_AMOUNT, ISNULL(MAT_QTY,0) AS MAT_QTY, UOM, INPUT_QTY, INPUT_UOM, COMPANY_ID
							 , IO_ITEM_ID, IO_PLANT_ID, IO_STORAGE_ID, IO_BATCH_ID	
						------------------------------------------------------------------------
						--[IT20250117A]_TEMP 테이블에서 가지고 오는것으로 변경 
						--FROM XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
						------------------------------------------------------------------------
						FROM #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
						WHERE IFSEQNO = @v_ifseqno
						AND   TRANSFER_FLAG = 'P'
						-- [C20200416-000194] 아래 주석처리
						--AND movement_type+indicator IN( SELECT segment1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE lookup_type = 'MATERIAL_MOVEMENT_TYPE')
						-- [C20200416-000194] 아래 추가
						AND STORAGE_ID IN ( SELECT DISTINCT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
											WHERE LOOKUP_TYPE = 'DM_MAT_DOC_STORAGE_ID'
											--UNION ALL
											--SELECT DISTINCT SEGMENT4
											--FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
											--WHERE lookup_type = 'SSP_AS_DIV_SLOC' -- [PJ20209643]
										   )
						) B
				ON (          A.MAT_DOC_ID				= B.MAT_DOC_ID
						  AND A.MAT_DOC_YEAR            = B.MAT_DOC_YEAR
						  AND A.MAT_DOC_ITEM            = B.MAT_DOC_ITEM )
				WHEN MATCHED THEN
					UPDATE 
					SET A.TRADE_TYPE					= B.TRADE_TYPE
					  , A.DOC_TYPE						= B.DOC_TYPE
					  , A.DOC_PROOF_DATE				= B.DOC_PROOF_DATE
					  , A.DOC_POSTING_DATE				= B.DOC_POSTING_DATE
					  , A.DOC_INPUT_DATE				= B.DOC_INPUT_DATE
					  , A.INPUT_DATE					= B.INPUT_DATE
					  , A.USER_NAME						= B.USER_NAME
					  , A.MOVEMENT_TYPE					= B.MOVEMENT_TYPE
					  , A.ITEM_ID						= B.ITEM_ID
					  , A.PLANT_ID						= B.PLANT_ID
					  , A.STORAGE_ID					= B.STORAGE_ID
					  , A.BATCH_ID						= B.BATCH_ID
					  , A.INVENTORY_TYPE				= B.INVENTORY_TYPE
					  , A.INDICATOR						= B.INDICATOR
					  , A.SPECIAL_STOCK_INDICATOR		= B.SPECIAL_STOCK_INDICATOR
					  , A.SPECIAL_STOCK_INDICATOR_NAME	= B.SPECIAL_STOCK_INDICATOR_NAME
					  , A.VENDOR_CODE					= B.VENDOR_CODE
					  , A.CUSTOMER_CODE					= B.CUSTOMER_CODE
					  , A.CURRENCY						= B.CURRENCY
					  , A.MAT_AMOUNT					= B.MAT_AMOUNT
					  , A.MAT_QTY						= B.MAT_QTY
					  , A.UOM							= B.UOM
					  , A.INPUT_QTY						= B.INPUT_QTY
					  , A.INPUT_UOM						= B.INPUT_UOM
					  , A.COMPANY_ID					= B.COMPANY_ID
					  , A.IO_ITEM_ID					= B.IO_ITEM_ID
					  , A.IO_PLANT_ID					= B.IO_PLANT_ID
					  , A.IO_STORAGE_ID					= B.IO_STORAGE_ID
					  , A.IO_BATCH_ID					= B.IO_BATCH_ID
					  , A.LAST_UPDATED_BY				= @v_batch_user
					  , A.LAST_UPDATE_DATE				= GETDATE()
				WHEN NOT MATCHED THEN
					INSERT 
					( MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, TRADE_TYPE, DOC_TYPE, DOC_PROOF_DATE
					, DOC_POSTING_DATE, DOC_INPUT_DATE, INPUT_DATE, USER_NAME, MOVEMENT_TYPE, ITEM_ID
					, PLANT_ID, STORAGE_ID, BATCH_ID, INVENTORY_TYPE, INDICATOR, SPECIAL_STOCK_INDICATOR
					, SPECIAL_STOCK_INDICATOR_NAME, VENDOR_CODE, CUSTOMER_CODE, CURRENCY, MAT_AMOUNT, MAT_QTY
					, UOM, INPUT_QTY, INPUT_UOM, COMPANY_ID, IO_ITEM_ID, IO_PLANT_ID
					, IO_STORAGE_ID, IO_BATCH_ID, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
					VALUES 
					( B.MAT_DOC_ID, B.MAT_DOC_YEAR, B.MAT_DOC_ITEM, B.TRADE_TYPE, B.DOC_TYPE, B.DOC_PROOF_DATE
					, B.DOC_POSTING_DATE, B.DOC_INPUT_DATE, B.INPUT_DATE, B.USER_NAME, B.MOVEMENT_TYPE, B.ITEM_ID
					, B.PLANT_ID, B.STORAGE_ID, B.BATCH_ID, B.INVENTORY_TYPE, B.INDICATOR, B.SPECIAL_STOCK_INDICATOR
					, B.SPECIAL_STOCK_INDICATOR_NAME, B.VENDOR_CODE, B.CUSTOMER_CODE, B.CURRENCY, B.MAT_AMOUNT, B.MAT_QTY
					, B.UOM, B.INPUT_QTY, B.INPUT_UOM, B.COMPANY_ID, B.IO_ITEM_ID, B.IO_PLANT_ID
					, B.IO_STORAGE_ID, B.IO_BATCH_ID, 'Y', @v_batch_user, GETDATE(), @v_batch_user, GETDATE());
					
				--======================================================================================================================
				-- Merge LOG (START)
				--======================================================================================================================
				SET @v_log_type = 'APPEND';
				SET @v_log_message = 'MERGE INTO scm_dnm_mat_document';
				SET @v_description = 'ifseqno = ' + @v_ifseqno;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				--======================================================================================================================
				-- Merge LOG (END)
				--======================================================================================================================

				FETCH NEXT FROM CUR_MAT INTO @v_ifseqno
			END

			CLOSE CUR_MAT;
			DEALLOCATE CUR_MAT;
			
			--======================================================================================================================
			-- 지나간 배치까지 적용하기 위해 Cursor 로 처리 (END)
			--======================================================================================================================
			--======================================================================================================================
			-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리 (START)
			--======================================================================================================================
			SET @n_history_seq = NEXT VALUE FOR seq1_scm_dnm_mat_document_h

			INSERT INTO SCM_DNM_MAT_DOCUMENT_H
			( HISTORY_SEQ, MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, TRADE_TYPE, DOC_TYPE
			, DOC_PROOF_DATE, DOC_POSTING_DATE, DOC_INPUT_DATE, INPUT_DATE, USER_NAME, MOVEMENT_TYPE
			, ITEM_ID, PLANT_ID, STORAGE_ID, BATCH_ID, INVENTORY_TYPE, INDICATOR
			, SPECIAL_STOCK_INDICATOR, SPECIAL_STOCK_INDICATOR_NAME, VENDOR_CODE, CUSTOMER_CODE, CURRENCY, MAT_AMOUNT
			, MAT_QTY, UOM, INPUT_QTY, INPUT_UOM, COMPANY_ID, IO_ITEM_ID
			, IO_PLANT_ID, IO_STORAGE_ID, IO_BATCH_ID, VALID_YN, CREATION_DATE, LAST_UPDATE_DATE
			, CREATED_BY, LAST_UPDATED_BY, HISTORY_CREATION_DATE )
			----------------------------------------------------------------------------------------------------------------------
			--[IT20250117A]_A.*구조를 컬럼 하나씩 명시하는 구조로 변경한다.
			--SELECT @n_history_seq, A.*, @v_batch_user, @v_batch_user ,GETDATE()
			----------------------------------------------------------------------------------------------------------------------					
			SELECT @n_history_seq, A.MAT_DOC_ID, A.MAT_DOC_YEAR, A.MAT_DOC_ITEM, A.TRADE_TYPE, A.DOC_TYPE
				 , A.DOC_PROOF_DATE, A.DOC_POSTING_DATE, A.DOC_INPUT_DATE, A.INPUT_DATE, A.USER_NAME, A.MOVEMENT_TYPE
				 , A.ITEM_ID, A.PLANT_ID, A.STORAGE_ID, A.BATCH_ID, A.INVENTORY_TYPE, A.INDICATOR
				 , A.SPECIAL_STOCK_INDICATOR, A.SPECIAL_STOCK_INDICATOR_NAME, A.VENDOR_CODE, A.CUSTOMER_CODE, A.CURRENCY, A.MAT_AMOUNT
				 , A.MAT_QTY, A.UOM, A.INPUT_QTY, A.INPUT_UOM, A.COMPANY_ID, A.IO_ITEM_ID
				 , A.IO_PLANT_ID, A.IO_STORAGE_ID, A.IO_BATCH_ID, A.VALID_YN, A.CREATION_DATE, A.LAST_UPDATE_DATE	
				 , @v_batch_user, @v_batch_user ,GETDATE()
            FROM (	----------------------------------------------------------------------------------------------------------------------
					--[IT20250117A]_A.*구조를 컬럼 하나씩 명시하는 구조로 변경한다.
					--SELECT A.*,B.creation_date,B.last_update_date
					----------------------------------------------------------------------------------------------------------------------
					SELECT A.MAT_DOC_ID, A.MAT_DOC_YEAR, A.MAT_DOC_ITEM, A.TRADE_TYPE, A.DOC_TYPE
						 , A.DOC_PROOF_DATE, A.DOC_POSTING_DATE, A.DOC_INPUT_DATE, A.INPUT_DATE, A.USER_NAME
						 , A.MOVEMENT_TYPE, A.ITEM_ID, A.PLANT_ID, A.STORAGE_ID, A.BATCH_ID
						 , A.INVENTORY_TYPE, A.INDICATOR, A.SPECIAL_STOCK_INDICATOR, A.SPECIAL_STOCK_INDICATOR_NAME, A.VENDOR_CODE
						 , A.CUSTOMER_CODE, A.CURRENCY, A.MAT_AMOUNT, A.MAT_QTY, A.UOM
						 , A.INPUT_QTY, A.INPUT_UOM, A.COMPANY_ID, A.IO_ITEM_ID, A.IO_PLANT_ID
						 , A.IO_STORAGE_ID, A.IO_BATCH_ID, A.VALID_YN, B.CREATION_DATE, B.LAST_UPDATE_DATE
					FROM ( SELECT /* scm_dnm_mat_document_h */
								  MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, TRADE_TYPE, DOC_TYPE
								, DOC_PROOF_DATE, DOC_POSTING_DATE, DOC_INPUT_DATE, INPUT_DATE, USER_NAME
								, MOVEMENT_TYPE, ITEM_ID, PLANT_ID, STORAGE_ID, BATCH_ID
								, INVENTORY_TYPE, INDICATOR, SPECIAL_STOCK_INDICATOR, SPECIAL_STOCK_INDICATOR_NAME, VENDOR_CODE
								, CUSTOMER_CODE, CURRENCY, MAT_AMOUNT, MAT_QTY, UOM
								, INPUT_QTY, INPUT_UOM, COMPANY_ID, IO_ITEM_ID, IO_PLANT_ID
								, IO_STORAGE_ID, IO_BATCH_ID, VALID_YN
							----------------------------------------------------------------------------------------------------------------------
							--[IT20250117A]_TEMP 테이블명 변경 scm_dnm_mat_document_temp$ -> #TEMP_SCM_DNM_MAT_DOCUMENT
							--FROM scm_dnm_mat_document_temp$ WITH(NOLOCK)
							----------------------------------------------------------------------------------------------------------------------
							FROM #TEMP_SCM_DNM_MAT_DOCUMENT WITH(NOLOCK)
							EXCEPT
							SELECT /* scm_dnm_mat_document_h */
								  MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, TRADE_TYPE, DOC_TYPE
								, DOC_PROOF_DATE, DOC_POSTING_DATE, DOC_INPUT_DATE, INPUT_DATE, USER_NAME
								, MOVEMENT_TYPE, ITEM_ID, PLANT_ID, STORAGE_ID, BATCH_ID
								, INVENTORY_TYPE, INDICATOR, SPECIAL_STOCK_INDICATOR, SPECIAL_STOCK_INDICATOR_NAME, VENDOR_CODE
								, CUSTOMER_CODE, CURRENCY, MAT_AMOUNT, MAT_QTY, UOM
								, INPUT_QTY, INPUT_UOM, COMPANY_ID, IO_ITEM_ID, IO_PLANT_ID
								, IO_STORAGE_ID, IO_BATCH_ID, VALID_YN
							FROM SCM_DNM_MAT_DOCUMENT WITH(NOLOCK)
							WHERE MAT_DOC_ID + MAT_DOC_YEAR + MAT_DOC_ITEM IN ( SELECT MAT_DOC_ID + MAT_DOC_YEAR + MAT_DOC_ITEM 
																				----------------------------------------------------------------------------------------------------------------------
																				--[IT20250117A]_TEMP 테이블에서 가지고 오는것으로 변경 
																				--FROM XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
																				----------------------------------------------------------------------------------------------------------------------
																				FROM #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
																				WHERE TRANSFER_FLAG = 'P')) A
																				INNER JOIN #TEMP_SCM_DNM_MAT_DOCUMENT B WITH(NOLOCK)
																						ON A.MAT_DOC_ID		= B.MAT_DOC_ID
																					   AND A.MAT_DOC_YEAR	= B.MAT_DOC_YEAR
																					   AND A.MAT_DOC_ITEM	= B.MAT_DOC_ITEM ) A

			--======================================================================================================================
			-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리 (END)
			--======================================================================================================================
			--======================================================================================================================
			-- 취소전표 적용 [C20210908-000163] Vmi in Req 실적 구간 로직 수정 (START)
			--======================================================================================================================
			------------------------------------------------------------------------------------------------------------------------
			-- FLAG: A - 취소대상 문서ID, B - 취소전표       EX) A(10) + B(-10) = 0
			------------------------------------------------------------------------------------------------------------------------
			-- 취소전표번호가 존재할때
			-- UPDATE
			DECLARE @V_FLAG             VARCHAR(1)      -- FLAG = A, B (대상, 취소전표)
			DECLARE @V_MAT_DOC_ID       VARCHAR(30)     -- 문서번호
			DECLARE @V_MAT_DOC_YEAR     VARCHAR(4)      -- 년도
			DECLARE @V_MAT_DOC_ITEM     VARCHAR(4)      -- ITEM
			DECLARE @V_C_MAT_DOC_ID     VARCHAR(30)     -- 취소 문서번호
			DECLARE @V_C_MAT_DOC_YEAR   VARCHAR(30)     -- 취소 년도
			DECLARE @V_C_MAT_DOC_ITEM   VARCHAR(30)     -- 취소 ITEM

			DECLARE CUR_CANCEL_DOC CURSOR FOR

			SELECT MAT_DOC_ID, MAT_DOC_YEAR, MAT_DOC_ITEM, C_MAT_DOC_ID, C_MAT_DOC_YEAR, C_MAT_DOC_ITEM
			------------------------------------------------------------------------------------------------------------------------
			--[IT20250117A]_TEMP 테이블에서 가지고 오는것으로 변경 
			--FROM XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
			------------------------------------------------------------------------------------------------------------------------
			FROM #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN WITH(NOLOCK)
			WHERE ISNULL(C_MAT_DOC_ID , '') <> ''
			AND DOC_POSTING_DATE >= CONVERT(CHAR(6), DATEADD(MONTH, -1, GETDATE()), 112) + '01'
			AND ATTRIBUTE2 IS NULL
			ORDER BY C_MAT_DOC_ID

			OPEN CUR_CANCEL_DOC;
			FETCH NEXT FROM CUR_CANCEL_DOC INTO @V_MAT_DOC_ID, @V_MAT_DOC_YEAR, @V_MAT_DOC_ITEM, @V_C_MAT_DOC_ID, @V_C_MAT_DOC_YEAR, @V_C_MAT_DOC_ITEM;

            WHILE (@@FETCH_STATUS = 0)
            BEGIN
                ---------------------------------------------------------------------------------------------------------------
                -- 취소전표 UPDATE
                ---------------------------------------------------------------------------------------------------------------
                UPDATE SCM_DNM_MAT_DOCUMENT 
				SET ATTRIBUTE2 = 'B'
                WHERE MAT_DOC_ID = @V_MAT_DOC_ID AND MAT_DOC_YEAR = @V_MAT_DOC_YEAR AND MAT_DOC_ITEM = @V_MAT_DOC_ITEM

                ---------------------------------------------------------------------------------------------------------------
                -- 취소전표의 대상 UPDATE
                ---------------------------------------------------------------------------------------------------------------
                UPDATE SCM_DNM_MAT_DOCUMENT 
				SET ATTRIBUTE2 = 'A'
				,	ATTRIBUTE3 = @V_MAT_DOC_ID
				,	ATTRIBUTE4 = @V_MAT_DOC_YEAR
				,	ATTRIBUTE5 = @V_MAT_DOC_ITEM
                WHERE MAT_DOC_ID = @V_C_MAT_DOC_ID AND MAT_DOC_YEAR = @V_C_MAT_DOC_YEAR AND MAT_DOC_ITEM = @V_C_MAT_DOC_ITEM
                AND DOC_POSTING_DATE >= CONVERT(CHAR(6), DATEADD(MONTH, -1, GETDATE()), 112) + '01'

				FETCH NEXT FROM CUR_CANCEL_DOC INTO @V_MAT_DOC_ID, @V_MAT_DOC_YEAR, @V_MAT_DOC_ITEM, @V_C_MAT_DOC_ID, @V_C_MAT_DOC_YEAR, @V_C_MAT_DOC_ITEM;
            END

			CLOSE CUR_CANCEL_DOC;
			DEALLOCATE CUR_CANCEL_DOC;
  			--======================================================================================================================
			-- 취소전표 적용 [C20210908-000163] Vmi in Req 실적 구간 로직 수정 (END)
			--======================================================================================================================
 			--======================================================================================================================
			-- 처리 한 row 마킹
			--======================================================================================================================
			UPDATE XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN
			SET TRANSFER_FLAG = 'Y'
			WHERE TRANSFER_FLAG = 'P'

			--======================================================================================================================
			-- [IT20250117A]_생성한 TEMP 테이블 DROP (START)
			--======================================================================================================================
			IF OBJECT_ID (N'tempdb..#TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN', N'U') IS NOT NULL 
				DROP TABLE #TEMP_XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN;			
			IF OBJECT_ID (N'tempdb..#TEMP_SCM_DNM_MAT_DOCUMENT', N'U') IS NOT NULL 
				DROP TABLE #TEMP_SCM_DNM_MAT_DOCUMENT;
			--======================================================================================================================
			-- [IT20250117A]_생성한 TEMP 테이블 DROP (END)
			--======================================================================================================================
			--[C20210112-000453] IF Table 업데이트 완료 후 Truncate
			--TRUNCATE TABLE [LGCE_INF].[dbo].[XIF_ERP_MATERIAL_DOCUMENT_DM_R]

			DECLARE @v_day INT;
			SELECT @v_day = CONVERT(INT, CONCAT('-', SEGMENT1))
			FROM  SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE LOOKUP_TYPE	= 'DM_DOCUMENT_DAY'
			AND   VALID_YN		= 'Y'

			-- C20210325-000347
			DELETE FROM XIF_ERP_MATERIAL_DOCUMENT_DM_R_SN 
			WHERE TRANSFER_DATE < CONVERT(NVARCHAR(8), DATEADD(DD, @v_day, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112)
			
			--======================================================================================================================
			-- HISTORY LOG (START)
			--======================================================================================================================
			SET @v_log_type		= 'HISTORY';
			SET @n_log_count	= @@ROWCOUNT;
			SET @v_log_message	= 'INSERT INTO scm_dnm_mat_document_h';
			SET @v_description	= '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			--======================================================================================================================
			-- HISTORY LOG (END)
			--======================================================================================================================
			IF @@TRANCOUNT > 0
			BEGIN
				COMMIT WORK;
			END;
		END
    END TRY

    BEGIN CATCH
	IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
		END;		
		--======================================================================================================================
		-- ERROR LOG (START)
		--======================================================================================================================
		SET @v_log_type		= 'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
		--======================================================================================================================
		-- ERROR LOG (END)
		--======================================================================================================================
    END CATCH;	
	--======================================================================================================================
	-- 종료 LOG (START)
	--======================================================================================================================
	SET @v_log_type		= 'END';
	SET @v_log_message	= '########## END of procedure ##########';
	SET @v_description	= '';
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--======================================================================================================================
	-- 종료 LOG (END)
	--======================================================================================================================
  END;


