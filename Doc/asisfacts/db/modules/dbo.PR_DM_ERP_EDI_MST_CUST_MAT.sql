/*
 * Program ID   : PR_DM_ERP_EDI_MST_CUST_MAT
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.06	   chano0612		  []  ERP, EDI MASTER DATA 정비 I/F
  
 */

 -- EXEC PR_DM_ERP_EDI_MST_CUST_MAT
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_DM_ERP_EDI_MST_CUST_MAT]	
AS

BEGIN

    SET NOCOUNT ON;

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);
    DECLARE @d_event_date				DATETIME;
	DECLARE @n_history_seq				BIGINT;
	DECLARE @V_DIVISION_ID			NVARCHAR(30);

	-- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_ERP_EDI_MST_CUST_MAT';
	DECLARE @V_BATCH_CHK_MSG	NVARCHAR(150) = N' '

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRY											

		BEGIN

			-- 테이블중복제거
			IF OBJECT_ID (N'tempdb..#TEMP_ERP_MST', N'U')				IS NOT NULL	DROP TABLE #TEMP_ERP_MST			

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID (N'dbo.#TEMP_ERP_MST', N'U')					IS NOT NULL	DROP TABLE #TEMP_ERP_MST			

			--#TEMP_EDI_NEW_ALL	
			CREATE TABLE #TEMP_ERP_MST	(
				NUM									INT					NULL,
				IFSEQNO							NVARCHAR(30)	NULL,
				SALES_ORG							NVARCHAR(8)		NULL,
				DISTRIBUTION_CHANNEL		NVARCHAR(4)		NULL,
				CUSTOMER_CODE				NVARCHAR(20)	NULL,
				ITEM_ID								NVARCHAR(36)	NULL,
				CUSTOMER_ITEM_ID			NVARCHAR(70)	NULL,
				CUSTOMER_ITEM_NAME		NVARCHAR(80)	NULL,
				PLANT								NVARCHAR(8)		NULL,
				ITEM_USAGE						NVARCHAR(8)		NULL,
				CREATE_DATE						NVARCHAR(20)	NULL,
				CREATE_TIME						NVARCHAR(20)	NULL,
				CREATE_USER_ID					NVARCHAR(200)	NULL
				);

			--ERP MST 데이터 처리
			UPDATE XIF_ERP_EDI_MST_CUST_MAT_R_SN
			SET TRANSFER_FLAG = 'P'
			WHERE TRANSFER_FLAG = 'N'
	
			-- 최신 IFSEQNO 를 확인한다.
			INSERT INTO #TEMP_ERP_MST ( NUM, IFSEQNO, SALES_ORG, DISTRIBUTION_CHANNEL, CUSTOMER_CODE, ITEM_ID, CUSTOMER_ITEM_ID
													   , CUSTOMER_ITEM_NAME, PLANT, ITEM_USAGE, CREATE_DATE, CREATE_TIME, CREATE_USER_ID )
			SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM
					 , A.IFSEQNO
					 , A.SALES_ORG
					 , A.DISTRIBUTION_CHANNEL
					 , A.CUSTOMER_CODE
					 , A.ITEM_ID
					 , REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A.CUSTOMER_ITEM_ID, ' ', ''), '-', ''), '.', ''), '/', ''), ',', ''), ':', ''), ';', ''), '+', ''), '_', ''), '(', ''), ')', ''), '*', ''), '^', ''), '$', ''), '#', '')
					 , A.CUSTOMER_ITEM_NAME
					 , A.PLANT
					 , A.ITEM_USAGE
					 , A.CREATE_DATE
					 , A.CREATE_TIME
					 , A.CREATE_USER_ID
			FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY SALES_ORG, DISTRIBUTION_CHANNEL, CUSTOMER_CODE, ITEM_ID, CUSTOMER_ITEM_ID ORDER BY IFSEQNO DESC) AS RNK
								 , IFSEQNO
								 , SALES_ORG
								 , DISTRIBUTION_CHANNEL
								 , CUSTOMER_CODE
								 , ITEM_ID
								 , CUSTOMER_ITEM_ID
								 , CUSTOMER_ITEM_NAME
								 , PLANT
								 , ITEM_USAGE
								 , CREATE_DATE
								 , CREATE_TIME
								 , CREATE_USER_ID
						FROM  XIF_ERP_EDI_MST_CUST_MAT_R_SN WITH(NOLOCK)
						WHERE ISNULL(CUSTOMER_ITEM_ID, '') <> ''
						AND TRANSFER_FLAG = 'P'
						GROUP BY IFSEQNO, SALES_ORG, DISTRIBUTION_CHANNEL, CUSTOMER_CODE, ITEM_ID
									 , CUSTOMER_ITEM_ID, CUSTOMER_ITEM_NAME, PLANT, ITEM_USAGE
									 , CREATE_DATE, CREATE_TIME, CREATE_USER_ID
					 ) A	
			WHERE RNK = 1
			ORDER BY A.IFSEQNO;

		END

SELECT COUNT(*) FROM #TEMP_ERP_MST
		
		--GSCM 기존 데이터 삭제
		BEGIN

			DELETE FROM DM_DNM_ERP_EDI_MST_CUST_MATERIAL
			WHERE 1 = 1
			AND EXISTS ( SELECT X.CUSTOMER_CODE, X.ITEM_ID, X.CUSTOMER_ITEM_ID FROM #TEMP_ERP_MST X WITH(NOLOCK)
								WHERE DM_DNM_ERP_EDI_MST_CUST_MATERIAL.SALES_ORG				= X.SALES_ORG
								AND DM_DNM_ERP_EDI_MST_CUST_MATERIAL.DISTRIBUTION_CHANNEL	= X.DISTRIBUTION_CHANNEL
								AND DM_DNM_ERP_EDI_MST_CUST_MATERIAL.CUSTOMER_CODE			= X.CUSTOMER_CODE
								AND DM_DNM_ERP_EDI_MST_CUST_MATERIAL.ITEM_ID							= X.ITEM_ID
								AND DM_DNM_ERP_EDI_MST_CUST_MATERIAL.CUSTOMER_ITEM_ID		= X.CUSTOMER_ITEM_ID
				);

		END
	
-- EXEC PR_DM_ERP_EDI_MST_CUST_MAT

		--ERP MST -> GSCM I/F
		BEGIN

			INSERT INTO DM_DNM_ERP_EDI_MST_CUST_MATERIAL
						( IFSEQNO, COMPANY_ID, SALES_ORG, DISTRIBUTION_CHANNEL, CUSTOMER_CODE, SCM_SITE_ID
						, ITEM_ID, CUSTOMER_ITEM_ID, CUSTOMER_ITEM_NAME, PLANT, ITEM_USAGE, CREATE_DATE, CREATE_TIME
						, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATE_TIME, LAST_UPDATED_BY )
			SELECT    IFSEQNO
						, ''
						, SALES_ORG
						, DISTRIBUTION_CHANNEL
						, CUSTOMER_CODE
						, (SELECT TOP 1 SCM_SITE_ID FROM SCM_MST_SITE_CUSTOMER WITH(NOLOCK) 
						   WHERE SOLDTO_CODE = CUSTOMER_CODE
						   AND VALID_YN = 'Y'
						   AND REP_YN = 'Y') AS SCM_SITE_ID
						, ITEM_ID
						, CUSTOMER_ITEM_ID
						, CUSTOMER_ITEM_NAME
						, PLANT
						, ITEM_USAGE
						, CREATE_DATE
						, CREATE_TIME
						, CREATE_USER_ID
						, CONVERT(NVARCHAR, GETDATE(), 112) AS UPDATE_DATE
						, REPLACE(CONVERT(NVARCHAR, GETDATE(), 8), ':', '') AS UPDATE_TIME
						, 'BATCHSD' AS UPDATE_USER_ID 
			FROM #TEMP_ERP_MST

		END

		--최신 IFSEQNO로 XIF_ERP_EDI_MST_CUST_MAT_R_SN 에 TRANSFER_FLAG = 'Y' 를 업데이트 해 준다.
		BEGIN

			UPDATE XIF_ERP_EDI_MST_CUST_MAT_R_SN 
			SET TRANSFER_FLAG = 'Y' 
			WHERE TRANSFER_FLAG = 'P'

		END
		
     END TRY
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    BEGIN CATCH
      SET @v_log_type = 'E';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
	  SELECT @v_log_message

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

ERR_RTN:
	

END

