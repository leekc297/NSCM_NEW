
/*================================================================================================================================
 * Program ID   : PR_DM_LONGPLAN_40_BACKUP
 * Description  : 소형 중장기계획용 - 2022년 이후 데이터 백업 ( SP, BP )
 * Called by	: 필요에 의해 직접 수행
 * Parameters	: @p_division_id 사업부, @p_created_by 생성자
 * Auth			: HWI1993
 * Date			: 2021.08.06
 * 시행예제		: EXEC PR_DM_LONGPLAN_40_BACKUP '40', 'E20250818-000190'
 *
 * Change History
 *================================================================================================================================
 *   Date       In Charge	Description
 *================================================================================================================================
 * 2021.08.06	HWI1993		최초생성
 * 2022.11.25	HWI1993		검증 스크립트 추가
 * 2025.08.19	jssbae		[E20250818-000190]_소형사업부 사업계획 수립 지원을 위한 Biz Plan → FCST&PRICE MGMT 동기화 기능 개발
================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_LONGPLAN_40_BACKUP]
	  @p_division_id		NVARCHAR(10)
	, @p_created_by			NVARCHAR(100)


AS
BEGIN 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON;
	
	--============================================================================================
	-- LOG 용 변수 설정
	--============================================================================================
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_LONGPLAN_40_BACKUP';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	
	
	--============================================================================================
	-- 시작 LOG  (START)
	--============================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
    SET @v_description	= N'@p_division_id :' + @p_division_id + '/ '+ N'@p_created_by :' + @p_created_by + '/ '+ N'소형 중장기'
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--============================================================================================
	-- 시작 LOG  (END)
	--============================================================================================

	BEGIN TRY
		DECLARE @V_MF_VERSION				NVARCHAR(100);
		DECLARE @V_SP_VERSION				NVARCHAR(100);
		DECLARE @V_RESTRICT_START_YYYYMMDD	NCHAR(8)
		
		-------------------------------------------------------------------------------------------------------------------
	    -- 1. 룩업"DM_LONG_PLAN_START_YYYYMMDD"에 ATTRIBUTE1(입력제한일)이 입력되어 있는지 체크한다.
		-------------------------------------------------------------------------------------------------------------------
		SELECT @V_RESTRICT_START_YYYYMMDD = ATTRIBUTE1 
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		 WHERE LOOKUP_TYPE = 'DM_LONG_PLAN_START_YYYYMMDD'
		   AND SEGMENT1	= @p_division_id
		   AND VALID_YN = 'Y'
			
		IF ISDATE(@V_RESTRICT_START_YYYYMMDD) < 1
		BEGIN
			RAISERROR( N'입력제한 일자가 설정되지 않았습니다.', 16, 1) 
		END

		-------------------------------------------------------------------------------------------------------------------
	    -- 2. MKT FCST Cutoff Version 생성 (START)
		-------------------------------------------------------------------------------------------------------------------
		EXEC [dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
			 @p_division_id
			, N'중장기용 백업'
			, 'MF_M' -- @c_ver_type
			, @p_created_by
			, @V_MF_VERSION  OUTPUT
			, @v_OK_description OUTPUT;			
			
		-------------------------------------------------------------------------------------------------------------------
	    -- 3. SALES PLAN Cutoff Version 생성
		-------------------------------------------------------------------------------------------------------------------
		EXEC [dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
			 @p_division_id
			, N'중장기용 백업'
			, 'SP_M' -- @c_ver_type
			, @p_created_by
			, @V_SP_VERSION  OUTPUT
			, @v_OK_description OUTPUT;			
		
		-------------------------------------------------------------------------------------------------------------------
		-- 4. SP를 백업하기 전에 SP 재계산
		-------------------------------------------------------------------------------------------------------------------
		EXEC [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW] @p_division_id, 'SYSTEM'		
		
		-------------------------------------------------------------------------------------------------------------------
		-- 5. DM_PLN_MKT_FCST = > DM_PLN_MKT_FCST_C 테이블에 데이터 BACKUP
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO DM_PLN_MKT_FCST_C
		( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
		, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
		, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
		, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT DIVISION_ID, @V_MF_VERSION AS VERSION_NO, 'MF_M' AS CUTOFF_TYPE, CONVERT(CHAR(8), GETDATE(), 112) AS CUTOFF_YYYYMMDD, PROJECT_CODE
			 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, @p_created_by AS CREATED_BY
			 , GETDATE() AS CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
			 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		  FROM DM_PLN_MKT_FCST WITH(NOLOCK)
		 WHERE YYYYMMDD >= CONVERT(VARCHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		   AND DIVISION_ID = @p_division_id
		   
		-------------------------------------------------------------------------------------------------------------------
		-- 6. [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN => DM_PLN_CFM_MKT_DEMAND_PLAN_C 테이블에 데이터 BACKUP (START)
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
		( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
		, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
		, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
		, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT DIVISION_ID, @V_MF_VERSION AS VERSION_NO, 'MF_M' AS CUTOFF_TYPE, CONVERT(CHAR(8), GETDATE(), 112) AS CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
			 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, @p_created_by AS CREATED_BY
			 , GETDATE() AS CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
			 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		  FROM DM_PLN_CFM_MKT_DEMAND_PLAN WITH(NOLOCK)
		 WHERE YYYYMMDD >= CONVERT(VARCHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		   AND DIVISION_ID = @p_division_id		   
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN => DM_PLN_CFM_MKT_DEMAND_PLAN_C 테이블에 데이터 BACKUP (END)
		-------------------------------------------------------------------------------------------------------------------	  		   
		-------------------------------------------------------------------------------------------------------------------
		-- 7. DM_PLN_SALES_PLAN => DM_PLN_SALES_PLAN_C 테이블에 데이터 BACKUP 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO DM_PLN_SALES_PLAN_C
		( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
		, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY
		, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
		, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID /* [E20250818-000190]_컬럼추가 */ )
		SELECT DIVISION_ID, @V_SP_VERSION AS VERSION_NO, 'SP_M' AS CUTOFF_TYPE, CONVERT(CHAR(8), GETDATE(), 112) AS CUTOFF_YYYYMMDD, PROJECT_CODE
			 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, @p_created_by AS CREATED_BY
			 , GETDATE() AS CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
			 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID /* [E20250818-000190]_컬럼추가 */ 
		  FROM DM_PLN_SALES_PLAN WITH(NOLOCK)
		 WHERE YYYYMMDD >= CONVERT(VARCHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		   AND DIVISION_ID = @p_division_id 		   

		-------------------------------------------------------------------------------------------------------------------
		-- 8. 데이터 검증
		-------------------------------------------------------------------------------------------------------------------
		-- 1). DM_PLN_MKT_FCST_C, DM_PLN_MKT_FCST 메져별 건수와 데이터 비교		
		SELECT N'DM_PLN_MKT_FCST_C테이블과 DM_PLN_MKT_FCST DIFF 건' AS TYPE, COUNT(*) AS CNT
		FROM (	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				 FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
				WHERE VERSION_NO	= @V_MF_VERSION
				  AND DIVISION_ID	= @p_division_id
				  AND YYYYMMDD		>= @V_RESTRICT_START_YYYYMMDD
				  AND QTY <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY ) A	
		FULL OUTER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					  	    FROM DM_PLN_MKT_FCST WITH(NOLOCK)
						   WHERE DIVISION_ID = @p_division_id
							 AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
							 AND QTY <> 0
						   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY ) B
					 ON A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DOM_EXP		= B.DOM_EXP
					AND A.FCST_TYPE		= B.FCST_TYPE
					AND A.INCOTERMS		= B.INCOTERMS
					AND A.MEASURE		= B.MEASURE
					AND A.YYYYMMDD		= B.YYYYMMDD
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
		WHERE ((A.QTY <> B.QTY) OR (ISNULL(A.DIVISION_ID,'') = '') OR (ISNULL(B.DIVISION_ID,'') = '')) 
		 
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN_C, DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 건수 확인 (START)
		-------------------------------------------------------------------------------------------------------------------	  
		-- 2). DM_PLN_CFM_MKT_DEMAND_PLAN_C, DM_PLN_CFM_MKT_DEMAND_PLAN 메져별 건수와 SUM 확인 
		
		SELECT N'DM_PLN_CFM_MKT_DEMAND_PLAN_C테이블과 DM_PLN_CFM_MKT_DEMAND_PLAN DIFF 건' AS TYPE, COUNT(*) AS CNT
		FROM (	SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY
				 FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH(NOLOCK)
				WHERE VERSION_NO	= @V_MF_VERSION
				  AND DIVISION_ID	= @p_division_id
				  AND YYYYMMDD		>= @V_RESTRICT_START_YYYYMMDD
				  AND QTY <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY ) A	
		FULL OUTER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY
					  	    FROM DM_PLN_CFM_MKT_DEMAND_PLAN WITH(NOLOCK)
						   WHERE DIVISION_ID = @p_division_id
							 AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
							 AND QTY <> 0
						   GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY ) B
					 ON A.DIVISION_ID		= B.DIVISION_ID
					AND A.PROJECT_CODE		= B.PROJECT_CODE
					AND A.END_CUSTOMER		= B.END_CUSTOMER
					AND A.SCM_SITE_ID		= B.SCM_SITE_ID
					AND A.ITEM_ID			= B.ITEM_ID
					AND A.DOM_EXP			= B.DOM_EXP
					AND A.FCST_TYPE			= B.FCST_TYPE
					AND A.INCOTERMS			= B.INCOTERMS
					AND A.MEASURE			= B.MEASURE
					AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
					AND A.YYYYMMDD			= B.YYYYMMDD
					AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
		WHERE ((A.QTY <> B.QTY) OR (ISNULL(A.DIVISION_ID,'') = '') OR (ISNULL(B.DIVISION_ID,'') = '')) 

		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN_C, DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 건수 확인 (END)
		-------------------------------------------------------------------------------------------------------------------	 
		-- 3). DM_PLN_SALES_PLAN_C, DM_PLN_SALES_PLAN 메져별 건수와 SUM 확인 
		
		SELECT N'DM_PLN_SALES_PLAN_C테이블과 DM_PLN_SALES_PLAN DIFF 건' AS TYPE, COUNT(*) AS CNT
		FROM (	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY
				 FROM DM_PLN_SALES_PLAN_C WITH(NOLOCK)
				WHERE VERSION_NO	= @V_SP_VERSION
				  AND DIVISION_ID	= @p_division_id
				  AND YYYYMMDD		>= @V_RESTRICT_START_YYYYMMDD
				  AND QTY <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY ) A	
		FULL OUTER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY
					  	    FROM DM_PLN_SALES_PLAN WITH(NOLOCK)
						   WHERE DIVISION_ID = @p_division_id
							 AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
							 AND QTY <> 0
						   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY ) B
					 ON A.DIVISION_ID		= B.DIVISION_ID
					AND A.PROJECT_CODE		= B.PROJECT_CODE
					AND A.SCM_SITE_ID		= B.SCM_SITE_ID
					AND A.ITEM_ID			= B.ITEM_ID
					AND A.DOM_EXP			= B.DOM_EXP
					AND A.FCST_TYPE			= B.FCST_TYPE
					AND A.INCOTERMS			= B.INCOTERMS
					AND A.MEASURE			= B.MEASURE
					AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
					AND A.YYYYMMDD			= B.YYYYMMDD
					AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
		WHERE ((A.QTY <> B.QTY) OR (ISNULL(A.DIVISION_ID,'') = '') OR (ISNULL(B.DIVISION_ID,'') = '')) 
	END TRY

	BEGIN CATCH		
		-------------------------------------------------------------------------------------------	
		-- ERROR LOG  (START)		
		-------------------------------------------------------------------------------------------	
		SET @v_log_type		= 'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		-------------------------------------------------------------------------------------------	
		-- ERROR LOG  (END)		
		-------------------------------------------------------------------------------------------	
	END CATCH
	
	-------------------------------------------------------------------------------------------	
	-- 종료 LOG  (START)		
	-------------------------------------------------------------------------------------------	
    SET @v_log_type		= 'END';
    SET @v_log_message	= '########## END of procedure ##########';
    SET @v_description	= N'@p_division_id :' + @p_division_id + '/ '+ N'@p_created_by :' + @p_created_by + '/ '+ N'@V_SP_VERSION :' + @V_SP_VERSION + '/ '+ N'@V_MF_VERSION :' + @V_MF_VERSION + '/ '+ N'@V_RESTRICT_START_YYYYMMDD :' + @V_RESTRICT_START_YYYYMMDD + '/ '+ N'소형 중장기'
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	-------------------------------------------------------------------------------------------	
	-- 종료 LOG  (END)		
	-------------------------------------------------------------------------------------------	
END




