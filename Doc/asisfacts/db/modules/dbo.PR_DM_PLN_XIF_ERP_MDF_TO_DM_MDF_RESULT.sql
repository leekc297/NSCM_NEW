/*
 * Program ID   : PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT
 * Description  : CSR ID 3787992 전지사업본부 MDF(판매장려금) 실적 정보 IF 정보 이관
 *                XIF_ERP_FI_MDF_R    -> DM_PLN_MDF_RESULT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20181114     KHSONG         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 이관시 db명 구분필요! 개발기 : LGCE_INFDEV, 운영기 : LGCE_INF
 *  2024.03.15	P.C.I			[PJ20228272] NERP 하드코딩 대응 및 개선, LGCE_INF.DBO.XIF_ERP_FI_MDF_R -> XIF_ERP_FI_MDF_R_SN 변경
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user	NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq	BIGINT;
	DECLARE @v_ifseqno		NVARCHAR(30); -- 누락된 전체 데이터 insert
	DECLARE @v_result_count NVARCHAR(30);

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRAN
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
	BEGIN TRY	
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--                                                                                신규 수신받은 건이 있을때만 처리 (START)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		IF ( ( SELECT COUNT(1) 
		       FROM  XIF_ERP_FI_MDF_R_SN WITH(NOLOCK) --[PJ20228272] NERP 대응 (LGCE_INF.DBO.XIF_ERP_FI_MDF_R -> XIF_ERP_FI_MDF_R_SN 변경)
		       WHERE ISNULL(transfer_flag,'N') = 'N'  
			   --and BIZ_AREA IN ( '1519','1819','1829' ) 
			   AND BIZ_AREA IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT', 'BIZ_AREA')) --[PJ20228272] NERP 대응
			   )
		   ) > 0
		BEGIN

		  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_ERP_MDF_TO_DM')
			BEGIN
				CLOSE CUR_ERP_MDF_TO_DM
				DEALLOCATE CUR_ERP_MDF_TO_DM
			END;

			-- 인터페이스 테이블 처리 ROW UPDATE
			UPDATE  XIF_ERP_FI_MDF_R_SN --[PJ20228272] NERP 대응 (LGCE_INF.DBO.XIF_ERP_FI_MDF_R -> XIF_ERP_FI_MDF_R_SN 변경)
			SET    transfer_flag = 'P'
			WHERE  ISNULL(transfer_flag,'N') = 'N'

			-- 지나간 배치까지 적용하기 위해 Cursor 로 처리
			DECLARE CUR_ERP_MDF_TO_DM CURSOR FOR
		  
			SELECT ifseqno
			FROM    XIF_ERP_FI_MDF_R_SN WITH(NOLOCK) --[PJ20228272] NERP 대응 (LGCE_INF.DBO.XIF_ERP_FI_MDF_R -> XIF_ERP_FI_MDF_R_SN 변경)
			WHERE  transfer_flag = 'P'
			GROUP BY ifseqno
			ORDER BY ifseqno ASC;

			OPEN CUR_ERP_MDF_TO_DM;
			FETCH NEXT FROM CUR_ERP_MDF_TO_DM INTO @v_ifseqno ;

			----------------------------------------------------------------------------------------------------- ◇◇◇◇◇
			--                                                                           CUR_ERP_MDF_TO_DM CURSOR (START)
			----------------------------------------------------------------------------------------------------- ◇◇◇◇◇
			WHILE (@@FETCH_STATUS = 0)
			----------------------------------------------------------------------------------------------------- ◇◇◇◇◇
			  BEGIN
			----------------------------------------------------------------------------------------------------- ◇◇◇◇◇
			  
			  DELETE FROM [dbo].[DM_PLN_MDF_RESULT]
			  WHERE  1=1
						--AND BIZ_AREA			IN ( '1519','1819','1829' )
						AND BIZ_AREA			IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT', 'BIZ_AREA')) --[PJ20228272] NERP 대응
						AND EXISTS (SELECT ifseqno FROM XIF_ERP_FI_MDF_R_SN WITH(NOLOCK) --[PJ20228272] NERP 대응 (LGCE_INF.DBO.XIF_ERP_FI_MDF_R -> XIF_ERP_FI_MDF_R_SN 변경)
											WHERE 1=1
												AND ifseqno  = @v_ifseqno
												AND SALES_POSTING_DATE	= DM_PLN_MDF_RESULT.SALES_POSTING_DATE
												AND COMPANY_ID			= DM_PLN_MDF_RESULT.COMPANY_ID
												AND BIZ_AREA			= DM_PLN_MDF_RESULT.BIZ_AREA
									)

			  MERGE INTO [dbo].[DM_PLN_MDF_RESULT] A		
			  USING (
					 SELECT
							 IFSEQNO
							,COMPANY_ID
							,BIZ_AREA
							,GL_ACCOUNT_CODE
							,PROFIT_CENTER
							,SALES_WORK_PLACE
							,DEBIT_CREDIT_INDICATOR
							,WBS_TYPE
							,ITEM_TEXT
							,CURRENCY
							,AMOUNT
							,LOCAL_AMOUNT
							,DOCUMENT_TYPE
							,ACCOUNTING_DOC_NO
							,SYSTEM_INPUT_DATE
							,SALES_POSTING_DATE
							,DESIGNATED_NUMBER
							,VAT_CODE
							,COST_CENTER
							,YYYYMM
							,ACCOUNT_TYPE
							,PAY_BACK_DOC_NO
							,PAY_BACK_DATE
							,REFERENCE_KEY
							,CUSTOMER_CODE
							,CUSTOMER_NAME
							,TRANSACTION_FLAG
							,CREATE_USER_ID
							,CREATE_DATE
							,CREATE_TIME
							,UPDATE_USER_ID
							,UPDATE_DATE
							,UPDATE_TIME
							,TRANSFER_DATE
							,TRANSFER_TIME
					 FROM   XIF_ERP_FI_MDF_R_SN WITH(NOLOCK) --[PJ20228272] NERP 대응 (LGCE_INF.DBO.XIF_ERP_FI_MDF_R -> XIF_ERP_FI_MDF_R_SN 변경)
					 WHERE  ifseqno				= @v_ifseqno	
						AND transfer_flag		= 'P'
						--AND BIZ_AREA			IN ( '1519','1819','1829' )
						AND BIZ_AREA			IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT', 'BIZ_AREA')) --[PJ20228272] NERP 대응
					) B
			  ON(     
						  A.SALES_POSTING_DATE	= B.SALES_POSTING_DATE
					  AND A.COMPANY_ID			= B.COMPANY_ID
					  AND A.BIZ_AREA			= B.BIZ_AREA
				)
			  WHEN MATCHED THEN
				 UPDATE SET 
							 /*A.DIVISION_ID					=  case when B.BIZ_AREA = '1519' then '40'
																	when B.BIZ_AREA = '1819' then '81'
																	when B.BIZ_AREA = '1829' then '82' end*/
							 A.DIVISION_ID					=  [dbo].FN_GET_LOOKUP_VALUE_DESC('PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT', 'BIZ_AREA',B.BIZ_AREA, '') --[PJ20228272] NERP 대응
							,A.GL_ACCOUNT_CODE				=  B.GL_ACCOUNT_CODE
							,A.COMPANY_ID					=  B.COMPANY_ID
							,A.BIZ_AREA						=  B.BIZ_AREA
							,A.PROFIT_CENTER				=  B.PROFIT_CENTER
							,A.SALES_WORK_PLACE				=  B.SALES_WORK_PLACE
							,A.DEBIT_CREDIT_INDICATOR		=  B.DEBIT_CREDIT_INDICATOR
							,A.WBS_TYPE						=  B.WBS_TYPE
							,A.ITEM_TEXT					=  B.ITEM_TEXT
							,A.CURRENCY						=  B.CURRENCY
							,A.AMOUNT						=  B.AMOUNT
							,A.LOCAL_AMOUNT					=  B.LOCAL_AMOUNT
							,A.DOCUMENT_TYPE				=  B.DOCUMENT_TYPE
							,A.ACCOUNTING_DOC_NO			=  B.ACCOUNTING_DOC_NO
							,A.SYSTEM_INPUT_DATE			=  B.SYSTEM_INPUT_DATE
							,A.SALES_POSTING_DATE			=  B.SALES_POSTING_DATE
							,A.DESIGNATED_NUMBER			=  B.DESIGNATED_NUMBER
							,A.VAT_CODE						=  B.VAT_CODE
							,A.COST_CENTER					=  B.COST_CENTER
							,A.YYYYMM						=  B.YYYYMM
							,A.ACCOUNT_TYPE					=  B.ACCOUNT_TYPE
							,A.PAY_BACK_DOC_NO				=  B.PAY_BACK_DOC_NO
							,A.PAY_BACK_DATE				=  B.PAY_BACK_DATE
							,A.REFERENCE_KEY				=  B.REFERENCE_KEY
							,A.CUSTOMER_CODE				=  B.CUSTOMER_CODE
							,A.CUSTOMER_NAME				=  B.CUSTOMER_NAME
							,A.TRANSACTION_FLAG				=  B.TRANSACTION_FLAG
							,A.CREATE_USER_ID				=  B.CREATE_USER_ID
							,A.CREATE_DATE					=  B.CREATE_DATE
							,A.CREATE_TIME					=  B.CREATE_TIME
							,A.UPDATE_USER_ID				=  B.UPDATE_USER_ID
							,A.UPDATE_DATE					=  B.UPDATE_DATE
							,A.UPDATE_TIME					=  B.UPDATE_TIME
							,A.TRANSFER_DATE				=  B.TRANSFER_DATE
							,A.TRANSFER_TIME				=  B.TRANSFER_TIME
							,A.CREATED_BY					=  @v_batch_user
							,A.CREATION_DATE				=  GETDATE()
							,A.last_updated_by				=  @v_batch_user
							,A.last_update_date				=  GETDATE()
							,A.ATTRIBUTE1					=  'ING'  -- 작업진행중인 데이터를 표시
							,A.ATTRIBUTE2					= 'IFSEQNO : '+@v_ifseqno  -- 확인용
					                
			  WHEN NOT MATCHED THEN
				 INSERT (  
							 DIVISION_ID
							,COMPANY_ID
							,BIZ_AREA
							,GL_ACCOUNT_CODE			
							,PROFIT_CENTER			
							,SALES_WORK_PLACE			
							,DEBIT_CREDIT_INDICATOR	
							,WBS_TYPE					
							,ITEM_TEXT				
							,CURRENCY					
							,AMOUNT					
							,LOCAL_AMOUNT				
							,DOCUMENT_TYPE			
							,ACCOUNTING_DOC_NO		
							,SYSTEM_INPUT_DATE		
							,SALES_POSTING_DATE		
							,DESIGNATED_NUMBER		
							,VAT_CODE					
							,COST_CENTER				
							,YYYYMM					
							,ACCOUNT_TYPE				
							,PAY_BACK_DOC_NO			
							,PAY_BACK_DATE			
							,REFERENCE_KEY			
							,CUSTOMER_CODE			
							,CUSTOMER_NAME			
							,TRANSACTION_FLAG			
							,CREATE_USER_ID			
							,CREATE_DATE				
							,CREATE_TIME				
							,UPDATE_USER_ID			
							,UPDATE_DATE				
							,UPDATE_TIME				
							,TRANSFER_DATE			
							,TRANSFER_TIME			
							,CREATED_BY				
							,CREATION_DATE			
							,last_updated_by			
							,last_update_date	
							,ATTRIBUTE1		
							,ATTRIBUTE2		
						)
				 VALUES (   
							 /*case   when B.BIZ_AREA = '1519' then '40'
									when B.BIZ_AREA = '1819' then '81'
									when B.BIZ_AREA = '1829' then '82' end      */
							 [dbo].FN_GET_LOOKUP_VALUE_DESC('PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT', 'BIZ_AREA',B.BIZ_AREA, '') --[PJ20228272] NERP 대응
							,COMPANY_ID
							,BIZ_AREA
							,GL_ACCOUNT_CODE		
							,PROFIT_CENTER			
							,SALES_WORK_PLACE		
							,DEBIT_CREDIT_INDICATOR	
							,WBS_TYPE				
							,ITEM_TEXT				
							,CURRENCY				
							,AMOUNT					
							,LOCAL_AMOUNT			
							,DOCUMENT_TYPE			
							,ACCOUNTING_DOC_NO		
							,SYSTEM_INPUT_DATE		
							,SALES_POSTING_DATE		
							,DESIGNATED_NUMBER		
							,VAT_CODE				
							,COST_CENTER			
							,YYYYMM					
							,ACCOUNT_TYPE			
							,PAY_BACK_DOC_NO		
							,PAY_BACK_DATE			
							,REFERENCE_KEY			
							,CUSTOMER_CODE			
							,CUSTOMER_NAME			
							,TRANSACTION_FLAG		
							,CREATE_USER_ID			
							,CREATE_DATE			
							,CREATE_TIME			
							,UPDATE_USER_ID			
							,UPDATE_DATE			
							,UPDATE_TIME			
							,TRANSFER_DATE			
							,TRANSFER_TIME			
							,@v_batch_user   
							,GETDATE()
							,@v_batch_user
							,GETDATE()
							,'ING'  -- 작업진행중인 데이터를 표시
							,'IFSEQNO : '+@v_ifseqno  -- 확인용
						)
			;

			-- 처리 한 row 마킹
			UPDATE  XIF_ERP_FI_MDF_R_SN --[PJ20228272] NERP 대응 (LGCE_INF.DBO.XIF_ERP_FI_MDF_R -> XIF_ERP_FI_MDF_R_SN 변경)
			SET transfer_flag    = 'Y' 
			WHERE transfer_flag  = 'P'
			  and ifseqno	     = @v_ifseqno	
			;
		
			FETCH NEXT FROM CUR_ERP_MDF_TO_DM INTO  @v_ifseqno
			END

			CLOSE CUR_ERP_MDF_TO_DM;
			DEALLOCATE CUR_ERP_MDF_TO_DM; 

			----------------------------------------------------------------------------------------------------- ◇◇◇◇◇
			--                                                                           CUR_ERP_MDF_TO_DM CURSOR (END)
			----------------------------------------------------------------------------------------------------- ◇◇◇◇◇

			-- 처리된 ROWS ADD COUNT
			set @v_result_count = @v_result_count + (select ISNULL(count(1),0) from DM_PLN_MDF_RESULT	WITH(NOLOCK) WHERE ATTRIBUTE1 = 'ING')
			;
			-- 처리된 ROWS UPDATE
			UPDATE DM_PLN_MDF_RESULT SET ATTRIBUTE1 = 'COMPLETED' WHERE ATTRIBUTE1 = 'ING'
			;

		END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--                                                                                신규 수신받은 건이 있을때만 처리 (END)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇


		IF @@TRANCOUNT > 0
			BEGIN
				COMMIT WORK;
			END;


    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
    END TRY
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    BEGIN CATCH
		IF @@TRANCOUNT > 0
		  BEGIN
			ROLLBACK TRAN
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'DM_PLN_MDF_RESULT Merge Count : ' + ISNULL(@v_result_count,0);
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
