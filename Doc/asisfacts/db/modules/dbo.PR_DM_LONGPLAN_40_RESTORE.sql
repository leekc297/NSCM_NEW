
/*================================================================================================================================
 * Program ID   : PR_DM_LONGPLAN_40_RESTORE
 * Description  : 소형 중장기계획용 - 2022년 이후 데이터 원복 ( MF, SP )
 * Called by	: 필요에 의해 직접 수행
 * Parameters	: @p_division_id 사업부, @p_mf_version_no 백업한 버전NO
 * Auth			: HWI1993
 * Date			: 2021.08.06
 * 시행예제		: EXEC PR_DM_LONGPLAN_40_RESTORE '40', 'MF_M_20250820_V003'
 *
 * Change History
 *================================================================================================================================
 *   Date       In Charge		Description
 *================================================================================================================================
 * 2021.08.06	HWI1993			최초생성
 * 2022.11.25	HWI1993			검증 스크립트 추가
 * 2025.08.19	jssbae			[E20250818-000190]_소형사업부 사업계획 수립 지원을 위한 Biz Plan → FCST&PRICE MGMT 동기화 기능 개발
================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_LONGPLAN_40_RESTORE]
	  @p_division_id			NVARCHAR(10)
	, @p_mf_version_no			NVARCHAR(50)

AS
BEGIN 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON;
	
	--============================================================================================
	-- LOG 용 변수 설정
	--============================================================================================
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_LONGPLAN_40_RESTORE_1024';
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
    SET @v_description	= N'@p_division_id :' + @p_division_id + '/'+ N'@p_mf_version_no :' + @p_mf_version_no + '/'+ N'소형 중장기'
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--============================================================================================
	-- 시작 LOG  (END)
	--============================================================================================

	BEGIN TRY		
		DECLARE @V_RESTRICT_START_YYYYMMDD		NCHAR(8)
			  , @V_RESTRICT_START_YYYYMM		NCHAR(6)
			  , @V_SP_VERSION_NO				NVARCHAR(50)	
			  -- [E20250818-000190]_입력제한일 START만 존재하여 END 추가 (START)
			  , @V_RESTRICT_END_YYYYMMDD		NCHAR(8)
			  , @V_RESTRICT_END_YYYYMM			NCHAR(6)
			  -- [E20250818-000190]_입력제한일 START만 존재하여 END 추가 (END)		  
			  
		-------------------------------------------------------------------------------------------------------------------
	    -- 1. 룩업"DM_LONG_PLAN_START_YYYYMMDD"에 ATTRIBUTE1(입력제한일)이 입력되어 있는지 체크한다.
		-------------------------------------------------------------------------------------------------------------------
		SELECT @V_RESTRICT_START_YYYYMMDD	= ATTRIBUTE1 
			 , @V_RESTRICT_END_YYYYMMDD		= ATTRIBUTE2			-- [E20250818-000190]_입력제한일 START만 존재하여 END 추가
			 , @V_RESTRICT_END_YYYYMM		= LEFT(ATTRIBUTE2, 6)	-- [E20250818-000190]_입력제한일 START만 존재하여 END 추가
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		 WHERE LOOKUP_TYPE = 'DM_LONG_PLAN_START_YYYYMMDD'
		   AND SEGMENT1 = @p_division_id
		   AND VALID_YN = 'Y'
			
		IF ISDATE(@V_RESTRICT_START_YYYYMMDD) < 1
		BEGIN
			RAISERROR( N'입력제한 일자가 설정되지 않았습니다.', 16, 1) 
		END		
		
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_입력제한일 START만 존재하여 END 추가 (START)
		-------------------------------------------------------------------------------------------------------------------
		IF ISDATE(@V_RESTRICT_END_YYYYMMDD) < 1
		BEGIN
			RAISERROR( N'입력제한 종료일자가 설정되지 않았습니다.', 16, 1) 
		END			  
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_입력제한일 START만 존재하여 END 추가 (END)
		-------------------------------------------------------------------------------------------------------------------			  
		-------------------------------------------------------------------------------------------------------------------
	    -- 2. SALES PLAN VERSION을 확인한다. 
		-------------------------------------------------------------------------------------------------------------------
		SELECT @V_SP_VERSION_NO = B.VERSION_NO
		  FROM DM_MST_VERSION A WITH(NOLOCK)
		  JOIN DM_MST_VERSION B WITH(NOLOCK) ON A.YYYYMMDD = B.YYYYMMDD AND A.DIVISION_ID = B.DIVISION_ID AND A.VER_CRE_SEQ = B.VER_CRE_SEQ AND B.VERSION_TYPE = 'SP_M'
		 WHERE A.DIVISION_ID = @p_division_id
		   AND A.VERSION_NO = @p_mf_version_no

		IF @V_SP_VERSION_NO IS NULL
		BEGIN
			RAISERROR( N'SP VERSION 을 못찾았습니다.', 16, 1) 
		END
		
		-------------------------------------------------------------------------------------------------------------------
		-- 3. DM_PLN_MKT_FCST, DM_PLN_CFM_MKT_DEMAND_PLAN를 삭제한다.
		-------------------------------------------------------------------------------------------------------------------
		-- 1). DM_PLN_MKT_FCST을 삭제한다.
		DELETE FROM DM_PLN_MKT_FCST 
		WHERE DIVISION_ID = @p_division_id
		  AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
		  AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
		
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN을 삭제한다. (START)
		-------------------------------------------------------------------------------------------------------------------
		-- 2). DM_PLN_CFM_MKT_DEMAND_PLAN을 삭제한다.
		DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN 
		WHERE DIVISION_ID = @p_division_id
		 AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
		 AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가

		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN을 삭제한다. (END)
		-------------------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------------------
		-- 4. 백업한 CUTOFF 데이터로 CURRENT 데이터를 넣어준다.
		-------------------------------------------------------------------------------------------------------------------
		-- 1). DM_PLN_MKT_FCST INSERT 
		INSERT INTO DM_PLN_MKT_FCST
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
		, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
		, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
		, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
			 , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
			 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7
			 , A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
		  FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
		 WHERE A.DIVISION_ID = @p_division_id
		   AND A.YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
		   AND A.YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
		   AND A.VERSION_NO = @p_mf_version_no
		   
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN에 데이터를 넣어준다. (START)
		-------------------------------------------------------------------------------------------------------------------
		-- 2). DM_PLN_CFM_MKT_DEMAND_PLAN INSERT 
		INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
		( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
		, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
		, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
			 , A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2
			 , A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
		  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH(NOLOCK)
		 WHERE A.DIVISION_ID = @p_division_id
		   AND A.YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
		   AND A.YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
		   AND A.VERSION_NO = @p_mf_version_no
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN에 데이터를 넣어준다. (END)
		-------------------------------------------------------------------------------------------------------------------
		
		-------------------------------------------------------------------------------------------------------------------
		-- 5. SP 재계산
		-------------------------------------------------------------------------------------------------------------------
		EXEC [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW] @p_division_id, 'SYSTEM'		
		
		-------------------------------------------------------------------------------------------------------------------
		-- 6. 데이터 검증
		-------------------------------------------------------------------------------------------------------------------
		-- 1). DM_PLN_MKT_FCST_C, DM_PLN_MKT_FCST 메져별 건수와 데이터 비교		
		SELECT N'DM_PLN_MKT_FCST_C테이블과 DM_PLN_MKT_FCST DIFF 건' AS TYPE, COUNT(*) AS CNT
		FROM (	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				 FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
				WHERE VERSION_NO	= @p_mf_version_no
				  AND DIVISION_ID	= @p_division_id
				  AND YYYYMMDD		>= @V_RESTRICT_START_YYYYMMDD
				  AND YYYYMMDD		<= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
				  AND QTY <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY ) A	
		FULL OUTER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					  	    FROM DM_PLN_MKT_FCST WITH(NOLOCK)
						   WHERE DIVISION_ID = @p_division_id
							 AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
							 AND YYYYMMDD	<= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
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
				WHERE VERSION_NO	= @p_mf_version_no
				  AND DIVISION_ID	= @p_division_id
				  AND YYYYMMDD		>= @V_RESTRICT_START_YYYYMMDD
				  AND YYYYMMDD		<= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
				  AND QTY <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY ) A	
		FULL OUTER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY
					  	    FROM DM_PLN_CFM_MKT_DEMAND_PLAN WITH(NOLOCK)
						   WHERE DIVISION_ID = @p_division_id
							 AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
							 AND YYYYMMDD	<= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
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
				WHERE VERSION_NO	= @V_SP_VERSION_NO
				  AND DIVISION_ID	= @p_division_id
				  AND YYYYMMDD		>= @V_RESTRICT_START_YYYYMMDD
				  AND YYYYMMDD		<= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
				  AND QTY <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY ) A	
		FULL OUTER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY
					  	    FROM DM_PLN_SALES_PLAN WITH(NOLOCK)
						   WHERE DIVISION_ID = @p_division_id
							 AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
							 AND YYYYMMDD	<= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
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
	-- 종료 LOG (START)
	-------------------------------------------------------------------------------------------
    SET @v_log_type		= 'END';
    SET @v_log_message	= '########## END of procedure ##########';
    SET @v_description	= N'@p_division_id :' + @p_division_id + '/'+ N'@p_mf_version_no :' + @p_mf_version_no + '/ '+ N'@V_RESTRICT_START_YYYYMMDD :' + @V_RESTRICT_START_YYYYMMDD + '/ '+ N'소형 중장기'
    SET @d_event_date	= SYSDATETIME();
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	-------------------------------------------------------------------------------------------
	-- 종료 LOG (END)
	-------------------------------------------------------------------------------------------
END




