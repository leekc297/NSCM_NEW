
/*
 * Program ID   : DMF0044_SAVE_BIZ_PLAN_VERSION_COPY
 * Description  : Sales REPORT 개발 (DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C) VERSION COPY PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190709 JSYOUN Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy
 * 20191022 KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4 
 * 20200113 HWI1993 COPY, DELETE 기능 추가
 * 20200116 hwi1993 company_id 추가
 * 20200129 hwi1993 SalesAmt_USD 메저 추가
 * 20200211 HWI1993	부서 없는 데이터 삭제
 * 20200326 P.C.I   [PREPARE] 환율 정보 copy
 */

CREATE PROCEDURE [dbo].[DMF0044_SAVE_BIZ_PLAN_VERSION_COPY_PROD]
    @p_division_id            NVARCHAR(30),
    @p_version_no             NVARCHAR(MAX),
    @p_version_description    NVARCHAR(MAX),
    @p_created_by             NVARCHAR(MAX),
	@p_action_type				NVARCHAR(2)		-- D:삭제, CR: 생성, CP:복사

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_program_name     NVARCHAR(150) = 'DMF0044_SAVE_BIZ_PLAN_VERSION_COPY';
    DECLARE @v_log_type         NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count        INTEGER = 0;
    DECLARE @v_log_message      NVARCHAR(1000);
    DECLARE @v_description      NVARCHAR(500);
    DECLARE @d_event_date       DATETIME;
    DECLARE @n_delete_count     INTEGER = 0;
    DECLARE @n_merge_count      INTEGER = 0;
    DECLARE @v_created_by       NVARCHAR(50) = 'mdf_batch';
	DECLARE @v_Ori_Version NVARCHAR(30)

    -- 시작 LOG  (START)
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)
    BEGIN TRANSACTION;

    ---------------------------------------------------------------------------------------------------------------------------
    BEGIN TRY
    ---------------------------------------------------------------------------------------------------------------------------

        -----------------------------------------------------------------------------------------------------
        --                                                                                 Validation (BEGIN)
        -----------------------------------------------------------------------------------------------------
        IF NOT EXISTS ( SELECT 1 
                          FROM SCM_MST_DIVISION WITH (NOLOCK) 
                         WHERE DIVISION_ID = @p_division_id )
            BEGIN
                SET @v_log_type = 'DIVISION_INVALID';
                GOTO ERR_RTN;
            END

		-- 기능과 버전이 안맞는 경우 ( 생성 : SP_W, BP_M 만 가능, 복사, 삭제 : REPORT_로 시작하는 버전만 가능 )
		IF @p_action_type IN ( 'CP', 'D' )
			AND NOT EXISTS ( SELECT 1 FROM DM_MDF_VERSION NOLOCK
								WHERE DIVISION_ID = @p_division_id 
									AND VERSION_NO  = @p_version_no )
			BEGIN
				SET @v_log_type = 'VERSION_NO_INVALID'
				GOTO ERR_RTN
			END

		IF @p_action_type = 'CR'
			AND NOT EXISTS ( SELECT 1 FROM DM_MST_VERSION NOLOCK
								WHERE DIVISION_ID = @p_division_id 
									AND VERSION_NO  = @p_version_no )
			BEGIN
				SET @v_log_type = 'VERSION_NO_INVALID'
				GOTO ERR_RTN
			END

		-- 삭제인데, Send_YN 이 Y 인 경우
		IF @p_action_type = 'D'
			AND EXISTS ( SELECT 1 FROM DM_MDF_VERSION WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id 
									AND VERSION_NO  = @p_version_no
									AND SEND_YN = 'Y' ) 
			BEGIN 
				SET @v_log_type = 'VERSION_NO_INVALID'
				GOTO ERR_RTN
			END
        -----------------------------------------------------------------------------------------------------
        --                                                                                 Validation (END)
        -----------------------------------------------------------------------------------------------------


        -----------------------------------------------------------------------------------------------------
        --     MDF VERSION MST INSERT (BEGIN)
        -----------------------------------------------------------------------------------------------------
        DECLARE @v_rp_version       VARCHAR(02);
        DECLARE @v_version_x        VARCHAR(50);

       -- 신규생성이나 복사일 경우 
		IF @p_action_type IN ( 'CR')
		BEGIN
			IF EXISTS ( SELECT 1 FROM DM_MDF_VERSION WITH (NOLOCK) WHERE 1=1
										AND DIVISION_ID		= @p_division_id
										AND ORI_VERSION_NO  = @p_version_no ) 
				BEGIN 
					SET @v_rp_version = (SELECT MAX(SUBSTRING(VERSION_NO,28,2)) FROM DM_MDF_VERSION WITH (NOLOCK) WHERE 1=1
											AND DIVISION_ID		= @p_division_id
											AND ORI_VERSION_NO  = @p_version_no ) 
				END

			IF @v_rp_version is null or @v_rp_version = ''
				BEGIN
					SET @v_rp_version = '01'
				END
			ELSE
				BEGIN
					SET @v_rp_version = @v_rp_version + 1
					SET @v_rp_version = replicate('0',2- DATALENGTH(@v_rp_version))+@v_rp_version
				
				END

			-- 최종 버전 셋팅
			set @v_version_x = 'REPORT_'+@p_version_no+'_R'+@v_rp_version

			INSERT INTO DM_MDF_VERSION
			(DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD,VER_CRE_SEQ,ORI_VERSION_NO,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT @p_division_id
				  ,@v_version_x AS VERSION_NO
				  ,@p_version_description,'REPORT_'+VERSION_TYPE VERSION_TYPE,'N',YYYYMMDD,VER_CRE_SEQ,VERSION_NO,@p_created_by,GETDATE(),@p_created_by,GETDATE(),NULL,NULL,NULL,NULL,NULL
				FROM DM_MST_VERSION WITH(NOLOCK) WHERE 1=1
					AND DIVISION_ID = @p_division_id 
					AND VERSION_NO  = @p_version_no

					
			--[PREPARE] 환율 정보 copy
			INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
			( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
			SELECT DIVISION_ID, @v_version_x as VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, @p_created_by,GETDATE()
				    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM   DM_BP_EXCHANGE_RATE_C with(nolock)
			WHERE  DIVISION_ID = @p_division_id
			AND    VERSION_NO  = @p_version_no
			;
		END
		ELSE IF @p_action_type IN ( 'CP')
		BEGIN
			SELECT @v_Ori_Version =ORI_VERSION_NO
			FROM DM_MDF_VERSION WITH (NOLOCK)
			WHERE DIVISION_ID		= @p_division_id
				AND VERSION_NO  = LEFT(@p_version_no, 29)


			IF EXISTS ( SELECT 1 FROM DM_MDF_VERSION WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID		= @p_division_id
									AND ORI_VERSION_NO  = @v_Ori_Version
									) 
			BEGIN 
				SET @v_rp_version = (SELECT MAX(SUBSTRING(VERSION_NO,28,2)) FROM DM_MDF_VERSION WITH (NOLOCK) WHERE 1=1
										AND DIVISION_ID		= @p_division_id
										AND ORI_VERSION_NO  = @v_Ori_Version
										) 
			END

			IF @v_rp_version is null or @v_rp_version = ''
				BEGIN
					SET @v_rp_version = '01'
				END
			ELSE
				BEGIN
					SET @v_rp_version = @v_rp_version + 1
					SET @v_rp_version = replicate('0',2- DATALENGTH(@v_rp_version))+@v_rp_version
				
				END

			-- 최종 버전 셋팅
			set @v_version_x = LEFT(N'REPORT_'+REPLACE(@p_version_no, N'REPORT_', ''), 25)+N'_R'+@v_rp_version

			INSERT INTO DM_MDF_VERSION
				(DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD
				,VER_CRE_SEQ,ORI_VERSION_NO,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT @p_division_id
				  ,@v_version_x AS VERSION_NO
				  ,@p_version_description,'REPORT_'+VERSION_TYPE VERSION_TYPE,'N',YYYYMMDD
				  ,VER_CRE_SEQ,VERSION_NO,@p_created_by,GETDATE(),@p_created_by,GETDATE(),NULL,NULL,NULL,NULL,NULL
			FROM DM_MST_VERSION WITH(NOLOCK) WHERE 1=1
				AND DIVISION_ID = @p_division_id 
				AND VERSION_NO  = @v_Ori_Version
				
			--[PREPARE] 환율 정보 copy
			INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
			( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
			SELECT DIVISION_ID, @v_version_x as VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, @p_created_by,GETDATE()
				    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM   DM_PLN_SALES_REPORT_EXCHANGE_C with(nolock)
			WHERE  DIVISION_ID = @p_division_id
			AND    VERSION_NO  = @p_version_no
			;

		END
		ELSE	-- 삭제일 경우 
		BEGIN
			UPDATE DM_MDF_VERSION
			SET SEND_YN = 'D'
			WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no

			DELETE 
			FROM DM_PLN_BP_FCST_REPORT_C 
			WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no

				
			--[PREPARE] 환율 정보 Delete
			DELETE FROM DM_PLN_SALES_REPORT_EXCHANGE_C
			WHERE  DIVISION_ID = @p_division_id
			AND    VERSION_NO  = @p_version_no
			;

		END
        -----------------------------------------------------------------------------------------------------
        --                                                                     MDF VERSION MST INSERT (END)
        -----------------------------------------------------------------------------------------------------

        -----------------------------------------------------------------------------------------------------
        --                                                                           요청VERSION COPY (BEGIN)
        -----------------------------------------------------------------------------------------------------
        --------------------------------------------------------- TEMP TABLE 확인후 초기화
        IF OBJECT_ID (N'tempdb..#TEMP_BP_FCST_01', N'U') IS NOT NULL
            DROP TABLE #TEMP_BP_FCST_01;

        IF OBJECT_ID (N'tempdb..#TEMP_BP_FCST_02', N'U') IS NOT NULL
            DROP TABLE #TEMP_BP_FCST_02;
        --------------------------------------------------------- TEMP TABLE 확인후 초기화

		IF @p_action_type = 'CR'
		BEGIN
			-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE,PLANT_SITE_ID
					, YYYYMM, SUM(QTY) AS QTY
					,(SELECT top 1 token 
						FROM [dbo].[String_Split]((SELECT OWNER 
													FROM SCM_MST_SITE_ITEM B WITH(NOLOCK) 
													WHERE B.DIVISION_ID  = A.DIVISION_ID 
													AND B.PROJECT_CODE = A.PROJECT_CODE 
													AND B.SCM_SITE_ID  = A.SCM_SITE_ID 
										AND B.ITEM_ID      = A.ITEM_ID), ',')) AS OWNER  -- 멀티OWNER인경우 1명만 추출
				INTO #TEMP_BP_FCST_01
				FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
				WHERE A.VERSION_NO = @p_version_no
				AND MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'Business_Plan')
				AND DIVISION_ID = @p_division_id
				GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE,PLANT_SITE_ID
					, YYYYMM
			;
			-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
					, A.CURRENCY
					, A.MEASURE
					, A.PLANT_SITE_ID
					, A.YYYYMM
					, A.QTY
					, A.OWNER
					, ISNULL((SELECT UPPER_DEPT_ID FROM SCM_MST_SSO_DEPT_INFO DU WITH(NOLOCK) WHERE VALID_YN = 'Y' AND DU.DEPT_ID = (SELECT DEPT_ID FROM SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) WHERE A.OWNER = SU.USER_ID)),'') AS DEPARTMENT_ID
					, ISNULL((SELECT DEPT_NAME_KO  FROM SCM_MST_SSO_DEPT_INFO DU WITH(NOLOCK) WHERE VALID_YN = 'Y' 
						AND DU.DEPT_ID = (SELECT UPPER_DEPT_ID FROM SCM_MST_SSO_DEPT_INFO DU WITH(NOLOCK) WHERE VALID_YN = 'Y' 
						AND DU.DEPT_ID = (select DEPT_ID from SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) WHERE A.OWNER = SU.USER_ID))),'') AS DEPARTMENT_NAME
					, ISNULL((SELECT DEPT_ID       FROM SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) WHERE A.OWNER = SU.USER_ID),'') AS DEPT_ID
					, ISNULL((SELECT DEPT_NAME_KO  FROM SCM_MST_SSO_DEPT_INFO DU WITH(NOLOCK) WHERE VALID_YN = 'Y' AND DU.DEPT_ID = (SELECT DEPT_ID FROM SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) WHERE A.OWNER = SU.USER_ID)),'') AS DEPT_NAME

					, ISNULL(SI.report_group2,'')    AS CUST_REPORT      -- Cust. (Report)
					, ISNULL(SI.attribute2,'')       AS END_CUST_REPORT  -- End Cust.(Report)
					, ISNULL(SI.report_group3,'')    AS PRODUCT_GROUP    -- Product Gr.(Report)
					, CASE WHEN ISNULL(SI.report_group4,'') <> '' THEN ISNULL(SI.report_group4,'') ELSE ISNULL(SI.report_group5,'') END AS ATTRIBUTE1       -- Pouch Gr.(Report)
					--, ISNULL(SI.report_group5,'')    AS ATTRIBUTE2       -- Cyl Gr. (Report)
					, ISNULL(B.COMPANY_ID, '') AS COMPANY_ID
				INTO #TEMP_BP_FCST_02
				FROM #TEMP_BP_FCST_01 A
					LEFT JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK)
						ON A.DIVISION_ID       = SI.DIVISION_ID
					AND A.SCM_SITE_ID       = SI.SCM_SITE_ID
					AND A.PROJECT_CODE      = SI.PROJECT_CODE
					AND A.iTEM_ID           = SI.ITEM_ID
					AND SI.VALID_YN         = 'Y'
					LEFT JOIN SCM_MST_SITE B WITH(NOLOCK)
						ON A.DIVISION_ID    = B.DIVISION_ID
					AND A.SCM_SITE_ID       = B.SCM_SITE_ID
			;


			
			-- Dept_ID 나 Department_ID 가 없는 건들 삭제
			DELETE FROM #TEMP_BP_FCST_02 WHERE DEPARTMENT_ID = '' OR DEPT_ID = ''



PRINT '1'
			INSERT INTO DM_PLN_BP_FCST_REPORT_C
				 ( DATA_TYPE ,DIVISION_ID ,VERSION_NO ,CUTOFF_TYPE
				 , CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				 , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP
				 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP
				 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMM, CURRENCY, QTY, CREATED_BY
				 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID )


			SELECT '1' AS DATA_TYPE, A.DIVISION_ID, @v_version_x AS VERSION_NO, 'REPORT_'+A.CUTOFF_TYPE AS CUTOFF_TYPE 
				 , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
				 , A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
				 , A.PROJECT_CODE, '' AS PROJECT_NAME, MAX(A.SCM_SITE_ID),A.ITEM_ID, MAX(A.DOM_EXP)
				 , MAX(A.FCST_TYPE), ISNULL(MAX(A.INCOTERMS),''), A.MEASURE, MAX(A.PLANT_SITE_ID)
				 , A.YYYYMM, A.CURRENCY, SUM(QTY) AS QTY, @v_created_by
				 , GETDATE(), @v_created_by, GETDATE(), MAX(A.ATTRIBUTE1), A.COMPANY_ID
			  FROM #TEMP_BP_FCST_02 A
			 GROUP BY A.DIVISION_ID, A.CUTOFF_TYPE
					, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
					, A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
					, A.PROJECT_CODE, A.ITEM_ID, A.MEASURE
					, A.YYYYMM, A.CURRENCY, A.COMPANY_ID
				 --, ATTRIBUTE2--, CURRENCY


PRINT '2'

			-- UNIT Price ( LOC ) 를 생성해준다. ( 월단위 )
			-- RTF 가 있는 품목들에 대해서 Unit Price ( LOC ) 를 만들어준다. SalesAmt_LOC / RTF = Unit Price ( LOCAL )
			INSERT INTO DM_PLN_BP_FCST_REPORT_C
				 ( DATA_TYPE ,DIVISION_ID ,VERSION_NO ,CUTOFF_TYPE
				 , CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				 , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP
				 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP
				 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMM, CURRENCY, QTY, CREATED_BY
				 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID )
			SELECT '1' AS DATA_TYPE, A.DIVISION_ID, @v_version_x AS VERSION_NO, 'REPORT_'+A.CUTOFF_TYPE AS CUTOFF_TYPE 
					 , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
					 , A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
					 , A.PROJECT_CODE, '' AS PROJECT_NAME, A.SCM_SITE_ID,A.ITEM_ID, A.DOM_EXP
					 , A.FCST_TYPE, ISNULL(A.INCOTERMS,'') AS INCOTERMS, N'LOC' AS MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMM, A.CURRENCY
					 , CASE WHEN B.QTY <> 0 THEN ROUND(A.QTY /B.QTY, 0)
							ELSE 0 END
					 , @v_created_by
					 , GETDATE(), @v_created_by, GETDATE(), A.ATTRIBUTE1, A.COMPANY_ID
			FROM (
				SELECT '1' AS DATA_TYPE, A.DIVISION_ID, @v_version_x AS VERSION_NO, A.CUTOFF_TYPE
					 , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
					 , A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
					 , A.PROJECT_CODE, '' AS PROJECT_NAME, A.SCM_SITE_ID,A.ITEM_ID, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMM, A.CURRENCY, QTY AS QTY
					 , A.ATTRIBUTE1, A.COMPANY_ID
				  FROM #TEMP_BP_FCST_02 A
				  WHERE A.MEASURE = 'SalesAmt_LOC'
				) A
			JOIN (
				SELECT '1' AS DATA_TYPE, A.DIVISION_ID, @v_version_x AS VERSION_NO, A.CUTOFF_TYPE
					 , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
					 , A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
					 , A.PROJECT_CODE, '' AS PROJECT_NAME, A.SCM_SITE_ID,A.ITEM_ID, A.DOM_EXP
					 , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMM, A.CURRENCY, QTY AS QTY
					 , A.ATTRIBUTE1, A.COMPANY_ID
				  FROM #TEMP_BP_FCST_02 A
				  WHERE A.MEASURE = 'Business_Plan'
				) B ON  A.DIVISION_ID = B.DIVISION_ID 
						-- VERSION, 
						AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
						AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
						AND A.DEPT_ID = B.DEPT_ID
						AND A.DEPT_NAME = B.DEPT_NAME
						AND A.END_CUST_REPORT = B.END_CUST_REPORT
						AND A.CUST_REPORT = B.CUST_REPORT
						AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
						AND A.PROJECT_CODE = B.PROJECT_CODE 
						AND A.SCM_SITE_ID = B.SCM_SITE_ID 
						AND A.ITEM_ID = B.ITEM_ID
						AND A.YYYYMM = B.YYYYMM 
						AND A.COMPANY_ID = B.COMPANY_ID 
						AND A.CURRENCY = B.CURRENCY 



			-----------------------------------------------------------------------------------------------------
			--                                                                           요청VERSION COPY (END)
			-----------------------------------------------------------------------------------------------------

PRINT '3'
			----------------------------------------------------------------------------------------------------- 
			--                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (START)
			-----------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_BP_FCST_REPORT_C
				 ( DATA_TYPE ,DIVISION_ID ,VERSION_NO ,CUTOFF_TYPE
				 , CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				 , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP
				 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP
				 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMM, CURRENCY, QTY, CREATED_BY
				 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID )
			SELECT A.DATA_TYPE , A.DIVISION_ID ,@v_version_x , A.CUTOFF_TYPE
				 , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
				 , A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
				 , A.PROJECT_CODE, MAX(A.PROJECT_NAME), MAX(A.SCM_SITE_ID), A.ITEM_ID, MAX(DOM_EXP)
				 , MAX(A.FCST_TYPE), ISNULL(MAX(A.INCOTERMS),''), A.MEASURE, MAX(A.PLANT_SITE_ID)
				 , YYYYMM, CURRENCY, SUM(QTY), MAX(A.CREATED_BY)
				 , MAX(A.CREATION_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1)
				 , ISNULL(A.COMPANY_ID, B.COMPANY_ID)
			  FROM DM_PLN_BP_FCST_REPORT_C A WITH (NOLOCK)
			  LEFT JOIN SCM_MST_SITE B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
			 WHERE A.DIVISION_ID = @p_division_id
			   AND VERSION_NO = (SELECT MAX(VERSION_NO) 
								   FROM DM_PLN_BP_FCST_REPORT_C WITH (NOLOCK) 
								  WHERE CUTOFF_TYPE = 'REPORT_BP_M'
									AND DATA_TYPE = '2'
								)
			   AND CUTOFF_TYPE = 'REPORT_BP_M'
			   AND DATA_TYPE = '2'
			GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE
					, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
					, A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
					, A.PROJECT_CODE, A.ITEM_ID, A.MEASURE
					, A.YYYYMM, A.CURRENCY, ISNULL(A.COMPANY_ID, B.COMPANY_ID)
			;
		END
		ELSE IF @p_action_type = 'CP'
		BEGIN

PRINT '4'
			-- PK 변경전의 DATA 를 COPY 하는 경우때문에 GROUP BY  처리함
			INSERT INTO DM_PLN_BP_FCST_REPORT_C
				 ( DATA_TYPE ,DIVISION_ID ,VERSION_NO ,CUTOFF_TYPE
				 , CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
				 , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP
				 , PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP
				 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMM, CURRENCY, QTY, CREATED_BY
				 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID )
			SELECT A.DATA_TYPE , A.DIVISION_ID ,@v_version_x , A.CUTOFF_TYPE
				 , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
				 , A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
				 , A.PROJECT_CODE, MAX(A.PROJECT_NAME), MAX(A.SCM_SITE_ID), A.ITEM_ID, MAX(DOM_EXP)
				 , MAX(A.FCST_TYPE), ISNULL(MAX(A.INCOTERMS),''), A.MEASURE, MAX(A.PLANT_SITE_ID)
				 , YYYYMM, CURRENCY, SUM(QTY), MAX(A.CREATED_BY)
				 , MAX(A.CREATION_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.ATTRIBUTE1)
				 , A.COMPANY_ID
			  FROM DM_PLN_BP_FCST_REPORT_C A WITH (NOLOCK)
			 WHERE DIVISION_ID = @p_division_id
			   AND VERSION_NO = @p_version_no
			GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.CUTOFF_TYPE
					, A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID
					, A.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP
					, A.PROJECT_CODE, A.ITEM_ID, A.MEASURE
					, A.YYYYMM, A.CURRENCY, A.COMPANY_ID




		END
		----------------------------------------------------------------------------------------------------- 
		--                                 20190917 JSYOUN  마지막 버전의 data_type = '2'인 데이터 copy (END)
		-----------------------------------------------------------------------------------------------------
    -- IF @@TRANCOUNT > 0

    -- 트랜잭션 (COMMIT)
    COMMIT WORK;

    ---------------------------------------------------------------------------------------------------------------------------
    END TRY
    ---------------------------------------------------------------------------------------------------------------------------

    --------------------------------------------------------------
    BEGIN CATCH
    --------------------------------------------------------------
        -- ROLLBACK
        -- ERROR LOG VALUE SAVE
        SET @v_log_type = 'ERROR';
        SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
        SET @d_event_date = SYSDATETIME();

        SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

    -- 트랜잭션 (END)
    ROLLBACK TRANSACTION;

    --------------------------------------------------------------
    END CATCH;
    --------------------------------------------------------------

    -- 수행결과 성공여부 DISPLAY
    IF @v_log_message IS NULL
    SELECT 'success'
   ;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
    SET @d_event_date = SYSDATETIME();

    -- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    ERR_RTN:
    IF @v_log_type = 'DIVISION_INVALID'
        BEGIN
            ROLLBACK TRANSACTION;
            SET @v_log_message = '########## END of procedure ##########';
            SET @v_description = '';
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
            SELECT N'Division 값이 존재하지 않습니다.'
        END

    IF @v_log_type = 'VERSION_NO_INVALID'
        BEGIN
            ROLLBACK TRANSACTION;
            SET @v_log_message = '########## END of procedure ##########';
            SET @v_description = '';
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
            SELECT N'VERSION 값이 존재하지 않습니다.'
        END

END;









