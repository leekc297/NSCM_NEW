/*
 * Program ID   : PR_DM_ERP_EDI_MST_STRUCT
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.04.06	   chano0612		  []  ERP, EDI MASTER DATA 정비 I/F
 2023.10.04	   chutoc730		  []  EDI CALLOFF_PARTNER 를 통한 GM 데이터 처리 추가
  
 */

 -- EXEC PR_DM_ERP_EDI_MST_STRUCT
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_DM_ERP_EDI_MST_STRUCT]	
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
	DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_ERP_EDI_MST_STRUCT';
	DECLARE @V_BATCH_CHK_MSG	NVARCHAR(150) = N' '

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRY

		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		-- EDI MASTER STRUCT 최신 데이터만 이관 START
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		BEGIN

			-- 테이블중복제거
			IF OBJECT_ID (N'tempdb..#TEMP_ERP_MST', N'U')				IS NOT NULL	DROP TABLE #TEMP_ERP_MST			

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID (N'dbo.#TEMP_ERP_MST', N'U')					IS NOT NULL	DROP TABLE #TEMP_ERP_MST			

			--#TEMP_EDI_NEW_ALL	
			CREATE TABLE #TEMP_ERP_MST	(
				NUM									INT					NULL,
				IFSEQNO							NVARCHAR(30)	NULL,
				SALES_ORG							NVARCHAR(40)	NULL,
				EDI_TYPE							NVARCHAR(80)	NULL,
				EDI_TRANSACTION				NVARCHAR(40)	NULL,
				EDI_CUST_GROUP				NVARCHAR(40)	NULL,
				CUSTOMER_PLANT				NVARCHAR(40)	NULL,
				SOLDTO_CODE					NVARCHAR(200)	NULL,
				SHIPTO_CODE						NVARCHAR(200)	NULL,				
				DELETE_FLAG						NVARCHAR(50)	NULL,
				CREATE_DATE						NVARCHAR(20)	NULL,
				CREATE_TIME						NVARCHAR(20)	NULL,
				CREATE_USER_ID					NVARCHAR(200)	NULL
				);

			--ERP MST 데이터 처리
			UPDATE XIF_ERP_EDI_MST_STRUCT_R_SN
			SET TRANSFER_FLAG = 'P'
			WHERE TRANSFER_FLAG = 'N'
	
			-- 최신 IFSEQNO 를 확인한다.
			INSERT INTO #TEMP_ERP_MST ( NUM, IFSEQNO, SALES_ORG, EDI_TYPE, EDI_TRANSACTION, EDI_CUST_GROUP
													   , CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE, DELETE_FLAG
													   , CREATE_DATE, CREATE_TIME, CREATE_USER_ID )
			SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM
					 , A.IFSEQNO
					 , A.SALES_ORG
					 , A.EDI_TYPE
					 , A.EDI_TRANSACTION
					 , A.EDI_CUST_GROUP
					 , A.CUSTOMER_PLANT
					 , A.SOLDTO_CODE
					 , A.SHIPTO_CODE
					 , A.DELETE_FLAG
					 , A.CREATE_DATE
					 , A.CREATE_TIME
					 , A.CREATE_USER_ID
			FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY SALES_ORG, EDI_TYPE, EDI_TRANSACTION, EDI_CUST_GROUP, CODE_KEY3, DESC1, CODE_VALUE ORDER BY IFSEQNO DESC) AS RNK
								 , IFSEQNO
								 , SALES_ORG
								 , EDI_TYPE
								 , EDI_TRANSACTION
								 , EDI_CUST_GROUP
								 , ISNULL(CODE_KEY3, '') AS CUSTOMER_PLANT
								 , DESC1 AS SOLDTO_CODE
								 , CODE_VALUE AS SHIPTO_CODE						
								 , ISNULL(DELETE_FLAG, '') AS DELETE_FLAG
								 , CREATE_DATE
								 , CREATE_TIME
								 , CREATE_USER_ID
						FROM  XIF_ERP_EDI_MST_STRUCT_R_SN WITH(NOLOCK)
						WHERE ISNULL(DESC1, '') <> ''
						AND TRANSFER_FLAG = 'P'
						GROUP BY IFSEQNO, SALES_ORG, EDI_TYPE, EDI_TRANSACTION, EDI_CUST_GROUP, CODE_KEY3, DESC1, CODE_VALUE, ISNULL(DELETE_FLAG, ''), CREATE_DATE, CREATE_TIME, CREATE_USER_ID
					 ) A	
			WHERE RNK = 1
			ORDER BY A.IFSEQNO;

		END

SELECT COUNT(*) FROM #TEMP_ERP_MST

		--GSCM 기존 데이터 삭제
		BEGIN

			DELETE FROM DM_DNM_ERP_EDI_MST_SALES_SITE
			WHERE 1 = 1
			AND EXISTS ( SELECT X.SALES_ORG, X.EDI_TYPE, X.EDI_TRANSACTION, X.EDI_CUST_GROUP, X.CUSTOMER_PLANT
										, X.SOLDTO_CODE, X.SHIPTO_CODE
								FROM #TEMP_ERP_MST X WITH(NOLOCK)
								WHERE DM_DNM_ERP_EDI_MST_SALES_SITE.COMPANY_ID		= X.SALES_ORG
								AND DM_DNM_ERP_EDI_MST_SALES_SITE.EDI_TYPE				= X.EDI_TYPE
								AND DM_DNM_ERP_EDI_MST_SALES_SITE.EDI_TRANSACTION	= X.EDI_TRANSACTION
								AND DM_DNM_ERP_EDI_MST_SALES_SITE.EDI_CUST_GROUP	= X.EDI_CUST_GROUP
								AND DM_DNM_ERP_EDI_MST_SALES_SITE.CUSTOMER_PLANT	= X.CUSTOMER_PLANT
								AND DM_DNM_ERP_EDI_MST_SALES_SITE.SOLDTO_CODE		= X.SOLDTO_CODE
								AND DM_DNM_ERP_EDI_MST_SALES_SITE.SHIPTO_CODE		= X.SHIPTO_CODE
							 );

		END
		
--EXEC PR_DM_ERP_EDI_MST_STRUCT_KIM

--ERP MST -> GSCM I/F
		BEGIN

			INSERT INTO DM_DNM_ERP_EDI_MST_SALES_SITE
						( IFSEQNO, COMPANY_ID, EDI_TYPE, EDI_TRANSACTION, EDI_CUST_GROUP, CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE
						, DELETE_FLAG, CREATE_DATE, CREATE_TIME, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATE_TIME, LAST_UPDATED_BY )			
			SELECT    IFSEQNO
						, SALES_ORG
						, EDI_TYPE
						, EDI_TRANSACTION
						, EDI_CUST_GROUP
						, CUSTOMER_PLANT
						, SOLDTO_CODE
						, SHIPTO_CODE
						, DELETE_FLAG
						, CREATE_DATE
						, CREATE_TIME
						, CREATE_USER_ID
						, CONVERT(NVARCHAR, GETDATE(), 112) AS LAST_UPDATE_DATE
						, REPLACE(CONVERT(NVARCHAR, GETDATE(), 8), ':', '') AS LAST_UPDATE_TIME
						, 'BATCHSD' AS LAST_UPDATED_BY
			FROM #TEMP_ERP_MST

		END

		--최신 IFSEQNO로 XIF_ERP_EDI_MST_STRUCT_R_SN 에 TRANSFER_FLAG = 'Y' 를 업데이트 해 준다.
		BEGIN

			UPDATE XIF_ERP_EDI_MST_STRUCT_R_SN 
			SET TRANSFER_FLAG = 'Y' 
			WHERE TRANSFER_FLAG = 'P'

		END
		
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		-- EDI MASTER STRUCT 최신 데이터만 이관 END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		-- EDI CALLOFF_PARTNER 최신 데이터만 이관 START
		-- EDI MASTER MODEL 최신 데이터만 이관 START
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		-- XIF_ERP_EDI_MST_MODEL_R_SN 전송건에 대해 최신 데이터만 이관 되도록 구현
		-- 신규 테이블 생성
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		-- EDI MASTER MODEL 최신 데이터만 이관 END
		-- EDI CALLOFF_PARTNER 최신 데이터만 이관 END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  


		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		-- EDI SOLDTO / SHIPTO CODE 누락건 정비 START
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		BEGIN
		
			DECLARE @i INT=1, @v_CNT INT=0;			
			DECLARE @v_COMPANY_ID				NVARCHAR(60);
			DECLARE @v_SENDER_CODE				NVARCHAR(20);
			DECLARE @v_SENDER_NAME			NVARCHAR(200);
			DECLARE @v_SOLDTO_CODE			NVARCHAR(40);
			DECLARE @v_SHIPTO_CODE				NVARCHAR(40);
			DECLARE @v_UNLOADING_POINT		NVARCHAR(100);
			DECLARE @v_CUSTOMER_PLANT		NVARCHAR(20);

			DECLARE @m_POSTAL_CODE			NVARCHAR(40);
			DECLARE @m_SOLDTO_CODE			NVARCHAR(40);
			DECLARE @m_SHIPTO_CODE			NVARCHAR(40);
			
			--ERP EDI MST MODEL 데이터
			-- 테이블중복제거
			IF OBJECT_ID (N'tempdb..#TEMP_ERP_EDI_MST_MODEL', N'U')				IS NOT NULL	DROP TABLE #TEMP_ERP_EDI_MST_MODEL

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID (N'dbo.#TEMP_ERP_EDI_MST_MODEL', N'U')					IS NOT NULL	DROP TABLE #TEMP_ERP_EDI_MST_MODEL

			--#TEMP_ERP_EDI_MST_MODEL	
			CREATE TABLE #TEMP_ERP_EDI_MST_MODEL	(
				NUM									INT					NULL,
				IFSEQNO							NVARCHAR(30)	NULL,
				COMPANY_ID						NVARCHAR(20)	NULL,
				SALES_ORG							NVARCHAR(20)	NULL,
				CUSTOMER_CODE				NVARCHAR(40)	NULL,
				[LANGUAGE]						NVARCHAR(10)	NULL,
				OBJECT_TYPE						NVARCHAR(20)	NULL,
				CODE_KEY1						NVARCHAR(80)	NULL,
				CODE_KEY2						NVARCHAR(80)	NULL,				
				CODE_KEY3						NVARCHAR(80)	NULL,
				DESC1								NVARCHAR(200)	NULL,
				DESC2								NVARCHAR(200)	NULL,
				DESC3								NVARCHAR(200)	NULL,
				REMARKS							NVARCHAR(600)	NULL
				);
			
			INSERT INTO #TEMP_ERP_EDI_MST_MODEL
			SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM
					 , A.IFSEQNO
					 , A.COMPANY_ID
					 , A.SALES_ORG
					 , A.CUSTOMER_CODE
					 , A.[LANGUAGE]
					 , A.OBJECT_TYPE
					 , A.CODE_KEY1
					 , A.CODE_KEY2
					 , A.CODE_KEY3
					 , A.DESC1
					 , A.DESC2
					 , A.DESC3
					 , A.REMARKS
			FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, SALES_ORG, CUSTOMER_CODE, [LANGUAGE], OBJECT_TYPE, CODE_KEY1, CODE_KEY2, CODE_KEY3, DESC1, DESC2, DESC3, REMARKS ORDER BY IFSEQNO DESC) AS RNK
								 , IFSEQNO
								 , COMPANY_ID
								 , SALES_ORG
								 , CUSTOMER_CODE
								 , [LANGUAGE]
								 , OBJECT_TYPE
								 , ISNULL(CODE_KEY1, '') AS CODE_KEY1
								 , ISNULL(CODE_KEY2, '') AS CODE_KEY2
								 , ISNULL(CODE_KEY3, '') AS CODE_KEY3
								 , DESC1
								 , DESC2
								 , DESC3
								 , REMARKS
						FROM  XIF_ERP_EDI_MST_MODEL_R_SN WITH(NOLOCK)
						WHERE ISNULL(CODE_KEY2, '') <> ''
						AND ISNULL(CODE_KEY3, '') <> ''
						AND ISNULL(DELETE_FLAG, 'N') = 'N'
						--AND TRANSFER_FLAG = 'P'
						GROUP BY IFSEQNO, COMPANY_ID, SALES_ORG, CUSTOMER_CODE, [LANGUAGE], OBJECT_TYPE
									  , CODE_KEY1, CODE_KEY2, CODE_KEY3, DESC1, DESC2, DESC3, REMARKS
					 ) A	
			WHERE RNK = 1
			ORDER BY A.IFSEQNO
			
			--ERP EDI CALLOFF PARTNER 데이터  #2023.10.04	   chutoc730		  []  EDI CALLOFF_PARTNER 를 통한 GM 데이터 처리 추가#
			-- 테이블중복제거
			IF OBJECT_ID (N'tempdb..#TEMP_ERP_EDI_CALLOFF_PARTNER', N'U')				IS NOT NULL	DROP TABLE #TEMP_ERP_EDI_CALLOFF_PARTNER

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID (N'dbo.#TEMP_ERP_EDI_CALLOFF_PARTNER', N'U')					IS NOT NULL	DROP TABLE #TEMP_ERP_EDI_CALLOFF_PARTNER

			--#TEMP_ERP_EDI_CALLOFF_PARTNER	
			CREATE TABLE #TEMP_ERP_EDI_CALLOFF_PARTNER	(
				NUM									INT					NULL,
				IFSEQNO							NVARCHAR(30)	NULL,
				COMPANY_ID						NVARCHAR(20)	NULL,
				SALES_ORG							NVARCHAR(20)	NULL,
				CUSTOMER_CODE				NVARCHAR(40)	NULL,
				[LANGUAGE]						NVARCHAR(10)	NULL,
				OBJECT_TYPE						NVARCHAR(20)	NULL,
				CODE_KEY1						NVARCHAR(80)	NULL,
				CODE_KEY2						NVARCHAR(80)	NULL,				
				CODE_KEY3						NVARCHAR(80)	NULL,
				DESC1								NVARCHAR(200)	NULL,
				DESC2								NVARCHAR(200)	NULL,
				DESC3								NVARCHAR(200)	NULL,
				REMARKS							NVARCHAR(600)	NULL
				);
			
			INSERT INTO #TEMP_ERP_EDI_CALLOFF_PARTNER
			SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM
					 , A.IFSEQNO
					 , A.COMPANY_ID
					 , A.SALES_ORG
					 , A.CUSTOMER_CODE
					 , A.[LANGUAGE]
					 , A.OBJECT_TYPE
					 , A.CODE_KEY1
					 , A.CODE_KEY2
					 , A.CODE_KEY3
					 , A.DESC1
					 , A.DESC2
					 , A.DESC3
					 , A.REMARKS
			FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, SENDER_NAME, SENDER_CODE, COUNTRY, PARTNER_TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE15 ORDER BY IFSEQNO DESC) AS RNK
								 , IFSEQNO
								 , COMPANY_ID
								 , SENDER_NAME AS SALES_ORG
								 , SENDER_CODE AS CUSTOMER_CODE
								 , COUNTRY AS [LANGUAGE]
								 , PARTNER_TYPE AS OBJECT_TYPE
								 , ISNULL(ATTRIBUTE1, '') AS CODE_KEY1
								 , ISNULL(ATTRIBUTE2, '') AS CODE_KEY2
								 , ISNULL(ATTRIBUTE3, '') AS CODE_KEY3
								 , ATTRIBUTE11 AS DESC1
								 , ATTRIBUTE12 AS DESC2
								 , ATTRIBUTE13 AS DESC3
								 , ATTRIBUTE15 AS REMARKS
						FROM  XIF_ERP_EDI_CALLOFF_PARTNER_R_SN WITH(NOLOCK)
						WHERE ISNULL(ATTRIBUTE3, '') <> ''
						AND ISNULL(TRANSFER_FLAG, 'N') = 'N'
						AND PARTNER_TYPE = 'ST'
						AND SENDER_NAME = 'GM'
						--AND TRANSFER_FLAG = 'P'
						GROUP BY IFSEQNO, COMPANY_ID, SENDER_NAME, SENDER_CODE, COUNTRY, PARTNER_TYPE
									  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE15
					 ) A	
			WHERE RNK = 1
			ORDER BY A.IFSEQNO
			--#2023.10.04	   chutoc730		  []  EDI CALLOFF_PARTNER 를 통한 GM 데이터 처리 추가#

			--ERP EDI MST STRUCT
			-- 테이블중복제거
			IF OBJECT_ID (N'tempdb..#TEMP_ERP_EDI_MST_STRUCT', N'U')				IS NOT NULL	DROP TABLE #TEMP_ERP_EDI_MST_STRUCT

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID (N'dbo.#TEMP_ERP_EDI_MST_STRUCT', N'U')					IS NOT NULL	DROP TABLE #TEMP_ERP_EDI_MST_STRUCT

			--#TEMP_ERP_EDI_MST_MODEL	
			CREATE TABLE #TEMP_ERP_EDI_MST_STRUCT	(
				NUM									INT					NULL,
				IFSEQNO							NVARCHAR(30)	NULL,				
				SALES_ORG							NVARCHAR(40)	NULL,
				EDI_TYPE							NVARCHAR(80)	NULL,
				EDI_TRANSACTION				NVARCHAR(40)	NULL,
				EDI_CUST_GROUP				NVARCHAR(40)	NULL,
				CODE_KEY1						NVARCHAR(200)	NULL,
				CODE_KEY2						NVARCHAR(200)	NULL,				
				CODE_KEY3						NVARCHAR(200)	NULL,
				CODE_VALUE						NVARCHAR(600)	NULL,
				DESC1								NVARCHAR(600)	NULL			
				);

			INSERT INTO #TEMP_ERP_EDI_MST_STRUCT
			SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM
				 	 , A.IFSEQNO
				 	 , A.SALES_ORG
				 	 , A.EDI_TYPE
				 	 , A.EDI_TRANSACTION
				 	 , A.EDI_CUST_GROUP
				 	 , A.CODE_KEY1
				 	 , A.CODE_KEY2
				 	 , A.CODE_KEY3
				 	 , A.CODE_VALUE
				 	 , A.DESC1
			FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY SALES_ORG, EDI_TYPE, EDI_TRANSACTION, EDI_CUST_GROUP, CODE_KEY1, CODE_KEY2, CODE_KEY3, CODE_VALUE, DESC1 ORDER BY IFSEQNO DESC) AS RNK
								 , IFSEQNO
								 , SALES_ORG
								 , EDI_TYPE
								 , EDI_TRANSACTION
								 , EDI_CUST_GROUP
								 , ISNULL(CODE_KEY1, '') AS CODE_KEY1
								 , ISNULL(CODE_KEY2, '') AS CODE_KEY2
								 , ISNULL(CODE_KEY3, '') AS CODE_KEY3
								 , ISNULL(CODE_VALUE, '') AS CODE_VALUE
								 , ISNULL(DESC1, '') AS DESC1								 
						FROM  XIF_ERP_EDI_MST_STRUCT_R_SN WITH(NOLOCK)
						WHERE ISNULL(CODE_KEY3, '') <> ''
						AND ISNULL(CODE_VALUE, '') <> ''
						AND ISNULL(DELETE_FLAG, 'N') = 'N'
						GROUP BY IFSEQNO, SALES_ORG, EDI_TYPE, EDI_TRANSACTION, EDI_CUST_GROUP
									  , CODE_KEY1, CODE_KEY2, CODE_KEY3, CODE_VALUE, DESC1
					 ) A	
			WHERE RNK = 1
			ORDER BY A.IFSEQNO;

			--EDI MST 정비 데이터
			-- 테이블중복제거
			IF OBJECT_ID (N'tempdb..#TEMP_DM_DNM_EDI_MST_STATUS', N'U')			IS NOT NULL	DROP TABLE #TEMP_DM_DNM_EDI_MST_STATUS

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID (N'dbo.#TEMP_DM_DNM_EDI_MST_STATUS', N'U')					IS NOT NULL	DROP TABLE #TEMP_DM_DNM_EDI_MST_STATUS

			CREATE TABLE #TEMP_DM_DNM_EDI_MST_STATUS (  
					  NUM							INT  
					, DIVISION_ID					NVARCHAR(100)  
					, COMPANY_ID				NVARCHAR(100)  
					, SENDER_CODE				NVARCHAR(100)  
					, SENDER_NAME				NVARCHAR(100)  
					, SOLDTO_CODE				NVARCHAR(100)  
					, SHIPTO_CODE				NVARCHAR(100)  
					, UNLOADING_POINT		NVARCHAR(100)  
					, CUSTOMER_PLANT			NVARCHAR(100)					
					)
						
			INSERT INTO #TEMP_DM_DNM_EDI_MST_STATUS  
			SELECT ROW_NUMBER() OVER(ORDER BY SENDER_NAME ) AS NUM  
					 , DIVISION_ID   
					 , COMPANY_ID   
					 , SENDER_CODE   
					 , SENDER_NAME  
					 , ISNULL(SOLDTO_CODE, '')
					 , ISNULL(SHIPTO_CODE, '')
					 , ISNULL(UNLOADING_POINT, '')
					 , ISNULL(CUSTOMER_PLANT, '')
			FROM DM_DNM_EDI_CALLOFF_ITEM WITH(NOLOCK)  
			WHERE 1 = 1
			AND CREATE_DATE >= '20230101'			
			AND ((ISNULL(SOLDTO_CODE, '') = '' OR ISNULL(SHIPTO_CODE, '') = '')
					OR (SOLDTO_CODE = UNLOADING_POINT OR SOLDTO_CODE = CUSTOMER_PLANT)
					OR (SHIPTO_CODE = UNLOADING_POINT OR SHIPTO_CODE = CUSTOMER_PLANT))
			AND STATUS_CODE IN ('U', 'E')
			AND ERP_STATUS = 'ING_ERP'
			GROUP BY DIVISION_ID, COMPANY_ID, SENDER_CODE, SENDER_NAME  
 						  , SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, CUSTOMER_PLANT   
			
			SELECT @v_CNT = COUNT(1) FROM #TEMP_DM_DNM_EDI_MST_STATUS WITH(NOLOCK)


			WHILE @i <= @v_CNT
			BEGIN

				SET @m_POSTAL_CODE = ''
				SET @m_SHIPTO_CODE = ''
				SET @m_SOLDTO_CODE = ''

				SELECT @v_DIVISION_ID = DIVISION_ID
						 , @v_COMPANY_ID = COMPANY_ID
						 , @v_SENDER_CODE = SENDER_CODE
						 , @v_SENDER_NAME = SENDER_NAME
						 , @v_SOLDTO_CODE = SOLDTO_CODE
						 , @v_SHIPTO_CODE = SHIPTO_CODE
						 , @v_UNLOADING_POINT = UNLOADING_POINT
						 , @v_CUSTOMER_PLANT = CUSTOMER_PLANT
				FROM #TEMP_DM_DNM_EDI_MST_STATUS WITH(NOLOCK)
				WHERE NUM = @i				
			
				--AUDI/VW, SKODA
				IF @v_SENDER_NAME = 'AUDI/VW' OR @v_SENDER_NAME = 'SKODA'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT TOP 1 @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = @v_UNLOADING_POINT
								AND DESC1 = '1000'
								AND DESC2 = @v_CUSTOMER_PLANT							
								GROUP BY ISNULL(CODE_KEY3, '')
								ORDER BY ISNULL(CODE_KEY3, '') ASC

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_POSTAL_CODE = ISNULL(POSTAL_CODE, '') FROM DM_DNM_EDI_CALLOFF_PARTNER WITH(NOLOCK)
								WHERE CREATE_DATE >= '20230101'
								AND SENDER_NAME = @v_SENDER_NAME
								AND SHIPTO_CODE = (CASE WHEN @v_SHIPTO_CODE = '' THEN @m_SHIPTO_CODE ELSE @v_SHIPTO_CODE END)
								AND PARTNER_TYPE = 'BY'
								GROUP BY ISNULL(POSTAL_CODE, '')

								IF @m_POSTAL_CODE <> ''
									BEGIN
										SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
										WHERE 1 = 1
										AND COMPANY_ID = @v_COMPANY_ID
										AND CODE_KEY2 = @m_POSTAL_CODE										
										AND DESC1 = '1000'
										AND DESC3 = 'A'
										AND REMARKS = 'SP'
										GROUP BY ISNULL(CODE_KEY3, '')

										IF @m_SOLDTO_CODE <> ''
											BEGIN
												UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
												SET SOLDTO_CODE = @m_SOLDTO_CODE
												WHERE NUM = @i
											END
									END
							END																					

					END

				--BMW
				IF @v_SENDER_NAME = 'BMW'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = @v_UNLOADING_POINT
								AND DESC1 = '1100'
								AND DESC2 = @v_CUSTOMER_PLANT
								AND DESC3 = 'A'
								AND REMARKS = 'ST'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = @v_UNLOADING_POINT
								AND DESC1 = '1100'
								AND DESC2 = @v_CUSTOMER_PLANT
								AND DESC3 = 'A'
								AND REMARKS = 'ST_TO_BY'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END							
							END									

					END

				--DRX
				IF @v_SENDER_NAME = 'DRX'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = @v_CUSTOMER_PLANT
								AND DESC1 = '2100'
								AND DESC2 = @v_CUSTOMER_PLANT
								AND DESC3 = 'B'
								AND REMARKS = 'SH'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND DESC1 = '2100'								
								AND REMARKS = 'SP'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END									
							END									

					END
								
				--PORSCHE
				IF @v_SENDER_NAME = 'PORSCHE'
					BEGIN
						
						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = @v_UNLOADING_POINT
								AND DESC1 = '2000'
								AND DESC2 = @v_CUSTOMER_PLANT
								AND DESC3 = 'A'
								AND REMARKS = 'ST'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_POSTAL_CODE = ISNULL(POSTAL_CODE, '') FROM DM_DNM_EDI_CALLOFF_PARTNER WITH(NOLOCK)
								WHERE CREATE_DATE >= '20230101'
								AND SENDER_NAME = @v_SENDER_NAME
								AND SHIPTO_CODE = (CASE WHEN @v_SHIPTO_CODE = '' THEN @m_SHIPTO_CODE ELSE @v_SHIPTO_CODE END)
								AND PARTNER_TYPE = 'BY'
								GROUP BY ISNULL(POSTAL_CODE, '')

								IF @m_POSTAL_CODE <> ''
									BEGIN
										SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
										WHERE 1 = 1 
										AND COMPANY_ID = @v_COMPANY_ID
										AND CODE_KEY2 = @m_POSTAL_CODE										
										AND DESC1 = '2000'
										AND DESC2 = 'PORSCHE'
										AND DESC3 = 'A'
										AND REMARKS = 'SP'
										GROUP BY ISNULL(CODE_KEY3, '')

										IF @m_SOLDTO_CODE <> ''
											BEGIN
												UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
												SET SOLDTO_CODE = @m_SOLDTO_CODE
												WHERE NUM = @i
											END
									END
							END								

					END				
				
				--FORD
				IF @v_SENDER_NAME = 'FORD'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND DESC1 = '6000'
								AND DESC3 = 'F'
								AND REMARKS = 'SH'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN								
								SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND DESC1 = '6000'
								AND DESC3 = 'F'
								AND REMARKS = 'SP'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END									
							END						
						
					END

				--PEUGEOT(PSA)
				IF @v_SENDER_NAME = 'PEUGEOT'
					BEGIN
						
						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(DESC1, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = 'SH'								
								AND CODE_KEY3 = @v_UNLOADING_POINT
								AND DESC3 = 'C'								
								GROUP BY ISNULL(DESC1, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN								
								SELECT @m_SOLDTO_CODE = ISNULL(DESC1, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = 'SP'
								AND CODE_KEY3 = @v_UNLOADING_POINT								
								AND DESC3 = 'C'								
								GROUP BY ISNULL(DESC1, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END									
							END											

					END

				--PISTON
				IF @v_SENDER_NAME = 'PISTON'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY1 = 'CUSTOMER'
								AND CODE_KEY2 = 'PISTON SH'
								AND DESC1 = '6100'
								AND DESC2 = 'PA9'	--ERP로직 정비 후 주석처리
								AND DESC3 = 'E'
								AND REMARKS = 'SH'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN								
								SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY1 = 'CUSTOMER'
								AND CODE_KEY2 = 'PISTON SP'
								AND DESC1 = '6100'
								AND DESC2 = 'PA9'	--ERP로직 정비 후 주석처리
								AND DESC3 = 'E'
								AND REMARKS = 'SP'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END									
							END						

					END

				--VOLVO
				IF @v_SENDER_NAME = 'VOLVO'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(DESC1, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = 'SH'
								AND CODE_KEY3 = @v_UNLOADING_POINT
								AND DESC3 = 'CV'
								GROUP BY ISNULL(DESC1, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						 IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN								
								SELECT @m_SOLDTO_CODE = ISNULL(DESC1, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = 'SP'
								AND CODE_KEY3 = @v_UNLOADING_POINT
								AND DESC3 = 'CV'								
								GROUP BY ISNULL(DESC1, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END									
							END						
						
					END

				--WEBASTO
				IF @v_SENDER_NAME = 'WEBASTO'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_VALUE, '') FROM #TEMP_ERP_EDI_MST_STRUCT WITH(NOLOCK)
								WHERE 1 = 1
								AND EDI_TYPE = 'VA'
								AND EDI_TRANSACTION = '4905'
								AND CODE_KEY2 = 'SHIPTO'
								AND CODE_KEY3 = @v_CUSTOMER_PLANT								
								GROUP BY ISNULL(CODE_VALUE, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						 IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SOLDTO_CODE = ISNULL(DESC1, '') FROM #TEMP_ERP_EDI_MST_STRUCT WITH(NOLOCK)
								WHERE 1 = 1
								AND EDI_TYPE = 'VA'
								AND EDI_TRANSACTION = '4905'
								AND CODE_KEY2 = 'SHIPTO'
								AND CODE_KEY3 = @v_CUSTOMER_PLANT								
								GROUP BY ISNULL(DESC1, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END

							END

					END

				--FCA
				IF @v_SENDER_NAME = 'FCA'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_VALUE, '') FROM #TEMP_ERP_EDI_MST_STRUCT WITH(NOLOCK)
								WHERE CODE_KEY2 = 'SHIPTO'
								AND CODE_KEY3 = @v_CUSTOMER_PLANT
								AND EDI_TYPE = 'OD'
								GROUP BY ISNULL(CODE_VALUE, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SOLDTO_CODE = ISNULL(DESC1, '') FROM #TEMP_ERP_EDI_MST_STRUCT WITH(NOLOCK)
								WHERE CODE_KEY2 = 'SHIPTO'
								AND CODE_KEY3 = @v_CUSTOMER_PLANT
								AND EDI_TYPE = 'OD'
								GROUP BY ISNULL(DESC1, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END

							END										

					END

				--MAGNA
				IF @v_SENDER_NAME = 'MAGNA'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND DESC1 = '5000'
								AND DESC2 = @v_CUSTOMER_PLANT
								AND DESC3 = 'B'
								AND REMARKS = 'SH'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN								
								SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND DESC1 = '5000'
								AND DESC2 = (CASE WHEN @v_CUSTOMER_PLANT = 'PRE' THEN 'JLR' 
															  WHEN @v_CUSTOMER_PLANT = 'THO' THEN 'BMW'
															  ELSE '' END)
								AND DESC3 = 'B'
								AND REMARKS = 'SP'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END									
							END						

					END

				--DAIMLER				
				IF @v_SENDER_NAME = 'DAIMLER'

					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND CODE_KEY2 = @v_UNLOADING_POINT
								AND DESC1 = '3000'
								AND DESC2 = @v_CUSTOMER_PLANT
								AND DESC3 = 'B'
								AND REMARKS = 'SH'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN								
								SELECT @m_SOLDTO_CODE = ISNULL(CODE_KEY3, '') FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND DESC1 = '3000'
								AND DESC2 = @v_CUSTOMER_PLANT
								AND DESC3 = 'B'
								AND REMARKS = 'SP'
								GROUP BY ISNULL(CODE_KEY3, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END									
							END						

					END


				--LUCID
				--GM	#2023.10.04	   chutoc730		  []  EDI CALLOFF_PARTNER 를 통한 GM 데이터 처리 추가#	
				IF @v_SENDER_NAME = 'GM'
					BEGIN

						--Shipto. Code = Unloading Point = Customer Plant Code
						IF (@v_SHIPTO_CODE = '' OR @v_SHIPTO_CODE = @v_UNLOADING_POINT OR @v_SHIPTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SHIPTO_CODE = ISNULL(B.CODE_VALUE, '') 
								FROM #TEMP_ERP_EDI_CALLOFF_PARTNER AS A WITH(NOLOCK) JOIN #TEMP_ERP_EDI_MST_STRUCT AS B WITH(NOLOCK)
								ON ISNULL(A.CODE_KEY3, '') = ISNULL(B.CODE_KEY3, '') AND A.COMPANY_ID = B.SALES_ORG
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND ISNULL(B.CODE_KEY2, '') = 'SHIPTO'
								GROUP BY ISNULL(B.CODE_VALUE, '')

								IF @m_SHIPTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SHIPTO_CODE = @m_SHIPTO_CODE
										WHERE NUM = @i
									END
							END

						--Soldto. Code = Unloading Point = Customer Plant Code
						IF (@v_SOLDTO_CODE = '' OR @v_SOLDTO_CODE = @v_UNLOADING_POINT OR @v_SOLDTO_CODE = @v_CUSTOMER_PLANT)
							BEGIN
								SELECT @m_SOLDTO_CODE = ISNULL(CODE_VALUE, '') 
								FROM #TEMP_ERP_EDI_CALLOFF_PARTNER AS A WITH(NOLOCK) JOIN #TEMP_ERP_EDI_MST_STRUCT AS B WITH(NOLOCK)
								ON ISNULL(A.CODE_KEY3, '') = ISNULL(A.CODE_KEY3, '') AND A.COMPANY_ID = B.SALES_ORG
								WHERE 1 = 1 
								AND COMPANY_ID = @v_COMPANY_ID
								AND ISNULL(A.CODE_KEY2, '') = 'SOLDOT'
								GROUP BY ISNULL(B.CODE_VALUE, '')

								IF @m_SOLDTO_CODE <> ''
									BEGIN
										UPDATE #TEMP_DM_DNM_EDI_MST_STATUS
										SET SOLDTO_CODE = @m_SOLDTO_CODE
										WHERE NUM = @i
									END							
							END									

					END		
				--#2023.10.04	   chutoc730		  []  EDI CALLOFF_PARTNER 를 통한 GM 데이터 처리 추가#			
				--VA4905

				SET @i = @i + 1

			END
			

			--EDI_CALLOFF_ITEM 테이블에 SHIPTO_CODE 정비
			BEGIN
				UPDATE A
				SET A.SHIPTO_CODE = B.SHIPTO_CODE
					, A.ATTRIBUTE10 = 'C'
					, A.STATUS_CODE = 'U'
					, LAST_UPDATE_DATE = GETDATE()  
					, LAST_UPDATED_BY = 'scm_batch'  
				FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK)
				JOIN #TEMP_DM_DNM_EDI_MST_STATUS B WITH(NOLOCK)
				ON A.DIVISION_ID = B.DIVISION_ID
					AND A.COMPANY_ID = B.COMPANY_ID
					AND A.SENDER_CODE = B.SENDER_CODE
					AND A.SENDER_NAME = B.SENDER_NAME
					AND A.UNLOADING_POINT = B.UNLOADING_POINT
					AND A.CUSTOMER_PLANT = B.CUSTOMER_PLANT
				WHERE ISNULL(A.SHIPTO_CODE, '') = ''				
				AND STATUS_CODE IN ('U', 'E')				
			END

			--EDI_CALLOFF_ITEM 테이블에 SOLDTO_CODE 정비
			BEGIN
				UPDATE A
				SET A.SOLDTO_CODE = B.SOLDTO_CODE
					, A.ATTRIBUTE10 = 'C'
					, A.STATUS_CODE = 'U'
					, LAST_UPDATE_DATE = GETDATE()  
					, LAST_UPDATED_BY = 'scm_batch'  
				FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK)
				JOIN #TEMP_DM_DNM_EDI_MST_STATUS B WITH(NOLOCK)
				ON A.DIVISION_ID = B.DIVISION_ID
					AND A.COMPANY_ID = B.COMPANY_ID
					AND A.SENDER_CODE = B.SENDER_CODE
					AND A.SENDER_NAME = B.SENDER_NAME
					AND A.UNLOADING_POINT = B.UNLOADING_POINT
					AND A.CUSTOMER_PLANT = B.CUSTOMER_PLANT
				WHERE ISNULL(A.SOLDTO_CODE, '') = ''				
				AND STATUS_CODE IN ('U', 'E')				
			END


--SELECT * FROM #TEMP_ERP_EDI_MST_MODEL WITH(NOLOCK)
--SELECT * FROM #TEMP_ERP_EDI_MST_STRUCT
SELECT * FROM #TEMP_DM_DNM_EDI_MST_STATUS WITH(NOLOCK)
--SELECT @v_CNT

--EXEC PR_DM_ERP_EDI_MST_STRUCT

		END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  
		-- EDI SOLDTO / SHIPTO CODE 누락건 정비 END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇  


	END TRY

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


