
/*========================================================================================================================================
 * Program ID   : PR_DM_LONGPLAN_40_DELETE_IMPORT
 * Description  : 소형 중장기계획용 - 2022년 이후 데이터 원복 ( MF, SP )
 * Called by	: 필요에 의해 직접 수행
 * Parameters	: @p_division_id 사업부, @p_version_no 특정버전 NO, @p_created_by 생성자
 * Auth			: HWI1993
 * Date			: 2021.08.06
 * 시행예제		: EXEC PR_DM_LONGPLAN_40_DELETE_IMPORT '40', 'BP_M_20250820_V003', 'E20250818-000190'
 *
 * Change History
 *========================================================================================================================================
 *   Date       In Charge		Description
 *========================================================================================================================================
 * 2021.08.06	HWI1993			최초생성
 * 2022.11.25	HWI1993			검증 스크립트 추가
 * 2025.08.19	jssbae			[E20250818-000190]_소형사업부 사업계획 수립 지원을 위한 Biz Plan → FCST&PRICE MGMT 동기화 기능 개발
========================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_LONGPLAN_40_DELETE_IMPORT]
	  @p_division_id			NVARCHAR(10)
	, @p_version_no				NVARCHAR(30)
	, @p_created_by				NVARCHAR(100)


AS
BEGIN 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON;
	
	--============================================================================================
	-- LOG 용 변수 설정
	--============================================================================================
    DECLARE @v_program_name				NVARCHAR(150) = 'PR_DM_LONGPLAN_40_DELETE_IMPORT';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);
    DECLARE @d_event_date				DATETIME;
	DECLARE	@v_OK_description			NVARCHAR(1200);	-- cut off Generated Number	
	
	--============================================================================================
	-- 시작 LOG  (START)
	--============================================================================================
	SET @v_log_type			= 'START';
	SET @v_log_message		= '########## Start of procedure ##########';
    SET @v_description		= N'@p_division_id :' + @p_division_id + '/'+ N'@p_version_no :' + @p_version_no + '/'+ N'@p_created_by :' + @p_created_by + '/ '+ N'소형 중장기'
	SET @d_event_date		= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--============================================================================================
	-- 시작 LOG  (END)
	--============================================================================================

	BEGIN TRY		
		DECLARE @V_RESTRICT_START_YYYYMMDD	NCHAR(8)
			  , @V_RESTRICT_START_YYYYMM	NCHAR(6)
			  -- [E20250818-000190]_입력제한일 START만 존재하여 END 추가 (START)
			  , @V_RESTRICT_END_YYYYMMDD	NCHAR(8)
			  , @V_RESTRICT_END_YYYYMM		NCHAR(6)
			  -- [E20250818-000190]_입력제한일 START만 존재하여 END 추가 (END)
			  
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_입력제한일 START만 존재하여 END 추가
	    -- 1. 룩업"DM_LONG_PLAN_START_YYYYMMDD"에 ATTRIBUTE1(입력제한일)이 입력되어 있는지 체크한다.
		-------------------------------------------------------------------------------------------------------------------
		SELECT @V_RESTRICT_START_YYYYMMDD	= ATTRIBUTE1 
			 , @V_RESTRICT_START_YYYYMM		= LEFT(ATTRIBUTE1, 6)
			 , @V_RESTRICT_END_YYYYMMDD		= ATTRIBUTE2			-- [E20250818-000190]_입력제한일 START만 존재하여 END 추가
			 , @V_RESTRICT_END_YYYYMM		= LEFT(ATTRIBUTE2, 6)	-- [E20250818-000190]_입력제한일 START만 존재하여 END 추가
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		 WHERE LOOKUP_TYPE = 'DM_LONG_PLAN_START_YYYYMMDD'
		   AND SEGMENT1	= @p_division_id
		   AND VALID_YN = 'Y'
			
		IF ISDATE(@V_RESTRICT_START_YYYYMMDD) < 1
		BEGIN
			RAISERROR( N'입력제한 시작일자가 설정되지 않았습니다.', 16, 1) 
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

		IF NOT EXISTS ( SELECT * FROM DM_PLN_BP_FCST_C WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @p_version_no )
		BEGIN
			RAISERROR( N'지정한 버전이 존재하지 않습니다.', 16, 1) 
		END
		
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_TEMP 테이블 DROP (START)
		-------------------------------------------------------------------------------------------------------------------		
		IF OBJECT_ID (N'tempdb..#TEMP_LOOK_UP_DATA', N'U') IS NOT NULL 	
			DROP TABLE #TEMP_LOOK_UP_DATA;

		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_TEMP 테이블 DROP (END)
		-------------------------------------------------------------------------------------------------------------------			
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_매핑할 룩업 데이터를 TEMP테이블에 담아준다. (START)
		-------------------------------------------------------------------------------------------------------------------		
		SELECT A.SEGMENT1 AS BP_CELL_PROD_SITE_ID, A.SEGMENT2 AS MGMT_CELL_PROD_SITE_ID, TOKEN AS PRODUCT_DETAILS
		INTO #TEMP_LOOK_UP_DATA
		FROM ( SELECT SEGMENT1, SEGMENT2, ATTRIBUTE1
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'MAPPING_CELL_PROD_SITE'
					AND VALID_YN = 'Y' ) A
		CROSS APPLY STRING_SPLIT(A.ATTRIBUTE1, ',') 
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_매핑할 룩업 데이터를 TEMP테이블에 담아준다. (END)
		-------------------------------------------------------------------------------------------------------------------		
		
		-------------------------------------------------------------------------------------------------------------------
		-- 2. 입력한 MKT FCST를 삭제한다.
		-------------------------------------------------------------------------------------------------------------------
		DELETE FROM DM_PLN_MKT_FCST 
		WHERE DIVISION_ID = @p_division_id
		AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD 
		AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
		
		-------------------------------------------------------------------------------------------------------------------
		-- 3. [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN을 삭제한다. (START)
		-------------------------------------------------------------------------------------------------------------------
		DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN 
		WHERE DIVISION_ID = @p_division_id
		AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD 
		AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가

		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN을 삭제한다. (END)
		-------------------------------------------------------------------------------------------------------------------
			   
		-------------------------------------------------------------------------------------------------------------------
		-- 4. @p_version_no 버전이 존재하지 않는 경우
		-------------------------------------------------------------------------------------------------------------------
		IF ISNULL(@p_version_no, '') = ''
		BEGIN
			-------------------------------------------------------------------------------------------------------------------
			-- 1). DM_PLN_BP_FCST 테이블의 BUSINESS_PLAN 메져로 DM_PLN_MKT_FCST 테이블의 MKT_FCST 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_MKT_FCST
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
			, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP, A.FCST_TYPE, A.INCOTERMS
				 , 'MKT_FCST' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM +'01' AS YYYYMMDD, SUM(A.QTY) AS QTY, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
				 , @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			  FROM DM_PLN_BP_FCST A WITH(NOLOCK)
			 WHERE A.DIVISION_ID = @p_division_id
			   AND A.YYYYMM	>= @V_RESTRICT_START_YYYYMM
			   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
			   AND A.MEASURE = 'BUSINESS_PLAN'
			   AND ISNULL(A.INCOTERMS, '') <> ''
			   AND ISNULL(A.FCST_TYPE, '') <> ''
			   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
			 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)), A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMM
			 
			-------------------------------------------------------------------------------------------------------------------
			-- 2). DM_PLN_BP_FCST 테이블의 BUSINESS_PLAN 메져로 DM_PLN_MKT_FCST 테이블의 VMI_In_Req 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_MKT_FCST
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP, A.FCST_TYPE, A.INCOTERMS
				 , 'VMI_In_Req' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM + '01' AS YYYYMMDD, SUM(A.QTY) AS QTY, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
				 , @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			  FROM DM_PLN_BP_FCST A WITH(NOLOCK)
			  JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID 
			 WHERE A.DIVISION_ID = @p_division_id
			   AND A.YYYYMM >= @V_RESTRICT_START_YYYYMM
			   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
			   AND A.MEASURE = 'BUSINESS_PLAN'
			   AND ISNULL(A.INCOTERMS, '') <> ''
			   AND ISNULL(A.FCST_TYPE, '') <> ''
			   AND B.VMI_YN = 'Y'
			   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
			GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)), A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMM
			
			-------------------------------------------------------------------------------------------------------------------
			-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN 테이블에 데이터 적재하는 내용을 추가한다. (START)
			-------------------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------------------
			-- 3). DM_PLN_BP_FCST 테이블의 BUSINESS_PLAN 메져로 DM_PLN_CFM_MKT_DEMAND_PLAN 테이블의 MKT_FCST 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY
			, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
				 , T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM +'01' AS YYYYMMDD, SUM(T.QTY) AS QTY, @p_created_by AS CREATED_BY 
				 , GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			FROM ( 	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , 'MKT_FCST' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM, A.QTY
						 , CASE WHEN ISNULL(C.ITEM_ID, '') != '' AND ISNULL(D.MGMT_CELL_PROD_SITE_ID, '') != '' THEN D.MGMT_CELL_PROD_SITE_ID
								WHEN ISNULL(C.ITEM_ID, '') != '' AND ISNULL(D.MGMT_CELL_PROD_SITE_ID, '') = '' THEN '-'	 
								ELSE '-' END AS CELL_PROD_SITE_ID				 
					  FROM DM_PLN_BP_FCST A WITH(NOLOCK)
					 INNER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID  AND A.PROJECT_CODE = B.PROJECT_CODE AND LTRIM(RTRIM(A.ITEM_ID)) = B.ITEM_ID
					 LEFT OUTER JOIN (  SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE DIVISION_ID = '40' AND FORECAST_INFO_BIZ_TYPE = 'CELL' AND ACTIVE_FLAG = 'Y'	GROUP BY ITEM_ID ) C ON A.ITEM_ID = C.ITEM_ID
					 LEFT OUTER JOIN #TEMP_LOOK_UP_DATA D ON A.CELL_PROD_SITE = D.BP_CELL_PROD_SITE_ID AND B.REPORT_GROUP4 = CASE WHEN ISNULL(D.PRODUCT_DETAILS,'') = '' THEN B.REPORT_GROUP4 ELSE D.PRODUCT_DETAILS END
					 WHERE A.DIVISION_ID = @p_division_id
					   AND A.YYYYMM	>= @V_RESTRICT_START_YYYYMM
					   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
					   AND A.MEASURE = 'BUSINESS_PLAN'
					   AND ISNULL(A.INCOTERMS, '') <> ''
					   AND ISNULL(A.FCST_TYPE, '') <> ''
					   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
				) T
			GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM
			 
			-------------------------------------------------------------------------------------------------------------------
			-- 4). DM_PLN_BP_FCST 테이블의 BUSINESS_PLAN 메져로 DM_PLN_CFM_MKT_DEMAND_PLAN 테이블의 VMI_In_Req 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY
			, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
				 , T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM +'01' AS YYYYMMDD, SUM(T.QTY) AS QTY, @p_created_by AS CREATED_BY 
				 , GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			FROM ( 	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , 'VMI_In_Req' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM, A.QTY
						 , CASE WHEN ISNULL(D.ITEM_ID, '') != '' AND ISNULL(E.MGMT_CELL_PROD_SITE_ID, '') != '' THEN E.MGMT_CELL_PROD_SITE_ID
								WHEN ISNULL(D.ITEM_ID, '') != '' AND ISNULL(E.MGMT_CELL_PROD_SITE_ID, '') = ''	THEN '-'	 
								ELSE '-' END AS CELL_PROD_SITE_ID				 
					  FROM DM_PLN_BP_FCST A WITH(NOLOCK)
					 INNER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID 
					 INNER JOIN SCM_MST_SITE_ITEM C WITH(NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID  AND A.PROJECT_CODE = C.PROJECT_CODE AND LTRIM(RTRIM(A.ITEM_ID)) = C.ITEM_ID
					 LEFT OUTER JOIN (  SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE DIVISION_ID = '40' AND FORECAST_INFO_BIZ_TYPE = 'CELL' AND ACTIVE_FLAG = 'Y'	GROUP BY ITEM_ID ) D ON A.ITEM_ID = D.ITEM_ID
					 LEFT OUTER JOIN #TEMP_LOOK_UP_DATA E ON A.CELL_PROD_SITE = E.BP_CELL_PROD_SITE_ID AND C.REPORT_GROUP4 = CASE WHEN ISNULL(E.PRODUCT_DETAILS,'') = '' THEN C.REPORT_GROUP4 ELSE E.PRODUCT_DETAILS END
					 WHERE A.DIVISION_ID = @p_division_id
					   AND A.YYYYMM	>= @V_RESTRICT_START_YYYYMM
					   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
					   AND A.MEASURE = 'BUSINESS_PLAN'
					   AND ISNULL(A.INCOTERMS, '') <> ''
					   AND ISNULL(A.FCST_TYPE, '') <> ''
					   AND B.VMI_YN = 'Y'
					   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
				) T
			GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM
			-------------------------------------------------------------------------------------------------------------------
			-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN 테이블에 데이터 적재하는 내용을 추가한다. (END)
			-------------------------------------------------------------------------------------------------------------------

		END
		ELSE		
		-------------------------------------------------------------------------------------------------------------------
		-- 5. @p_version_no 버전이 존재하는 경우
		-------------------------------------------------------------------------------------------------------------------
		BEGIN
			-------------------------------------------------------------------------------------------------------------------
			-- 1). DM_PLN_BP_FCST_C 테이블의 BUSINESS_PLAN 메져로 DM_PLN_MKT_FCST 테이블의 MKT_FCST 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_MKT_FCST
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
			, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP, A.FCST_TYPE, A.INCOTERMS
				 , 'MKT_FCST' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM + '01' AS YYYYMMDD, SUM(A.QTY) AS QTY, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
				 , @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			  FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
			 WHERE A.DIVISION_ID = @p_division_id
			   AND A.VERSION_NO = @p_version_no
			   AND A.YYYYMM >= @V_RESTRICT_START_YYYYMM
			   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
			   AND A.MEASURE = 'BUSINESS_PLAN'
			   AND ISNULL(A.INCOTERMS, '') <> ''
			   AND ISNULL(A.FCST_TYPE, '') <> ''
			   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
			 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)), A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMM
					 
			-------------------------------------------------------------------------------------------------------------------
			-- 2). DM_PLN_BP_FCST_C 테이블의 BUSINESS_PLAN 메져로 DM_PLN_MKT_FCST 테이블의 VMI_In_Req 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_MKT_FCST
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
			, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP
				 , A.FCST_TYPE, A.INCOTERMS, 'VMI_In_Req' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM + '01' AS YYYYMMDD, SUM(A.QTY) AS QTY, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
				 , @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			  FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
			  JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID 
			 WHERE A.DIVISION_ID = @p_division_id
			   AND A.VERSION_NO	= @p_version_no
			   AND A.YYYYMM	>= @V_RESTRICT_START_YYYYMM
			   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
			   AND A.MEASURE = 'BUSINESS_PLAN'
			   AND ISNULL(A.INCOTERMS, '') <> ''
			   AND ISNULL(A.FCST_TYPE, '') <> ''
			   AND B.VMI_YN	= 'Y'
			   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
			GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)), A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMM

			-------------------------------------------------------------------------------------------------------------------
			-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN 테이블에 데이터 적재하는 내용을 추가한다. (START)
			-------------------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------------------
			-- 3). DM_PLN_BP_FCST_C 테이블의 BUSINESS_PLAN 메져로 DM_PLN_CFM_MKT_DEMAND_PLAN 테이블의 MKT_FCST 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY
			, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
				 , T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM +'01' AS YYYYMMDD, SUM(T.QTY) AS QTY, @p_created_by AS CREATED_BY 
				 , GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			FROM ( 	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , 'MKT_FCST' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM, A.QTY
						 , CASE WHEN ISNULL(C.ITEM_ID, '') != '' AND ISNULL(D.MGMT_CELL_PROD_SITE_ID, '') != '' THEN D.MGMT_CELL_PROD_SITE_ID
								WHEN ISNULL(C.ITEM_ID, '') != '' AND ISNULL(D.MGMT_CELL_PROD_SITE_ID, '') = '' THEN '-'	 
								ELSE '-' END AS CELL_PROD_SITE_ID			
					  FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
					 INNER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID  AND A.PROJECT_CODE = B.PROJECT_CODE AND LTRIM(RTRIM(A.ITEM_ID)) = B.ITEM_ID
					 LEFT OUTER JOIN (  SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE DIVISION_ID = '40' AND FORECAST_INFO_BIZ_TYPE = 'CELL' AND ACTIVE_FLAG = 'Y'	GROUP BY ITEM_ID ) C ON A.ITEM_ID = C.ITEM_ID
					 LEFT OUTER JOIN #TEMP_LOOK_UP_DATA D ON A.CELL_PROD_SITE = D.BP_CELL_PROD_SITE_ID AND B.REPORT_GROUP4 = CASE WHEN ISNULL(D.PRODUCT_DETAILS,'') = '' THEN B.REPORT_GROUP4 ELSE D.PRODUCT_DETAILS END
					 WHERE A.DIVISION_ID = @p_division_id
					   AND A.VERSION_NO	= @p_version_no
					   AND A.YYYYMM	>= @V_RESTRICT_START_YYYYMM
					   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
					   AND A.MEASURE = 'BUSINESS_PLAN'
					   AND ISNULL(A.INCOTERMS, '') <> ''
					   AND ISNULL(A.FCST_TYPE, '') <> ''
					   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
				) T
			GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM
			 
			-------------------------------------------------------------------------------------------------------------------
			-- 4). DM_PLN_BP_FCST_C 테이블의 BUSINESS_PLAN 메져로 DM_PLN_CFM_MKT_DEMAND_PLAN 테이블의 VMI_In_Req 메져를 생성한다.
			-------------------------------------------------------------------------------------------------------------------
			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY
			, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
				 , T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM +'01' AS YYYYMMDD, SUM(T.QTY) AS QTY, @p_created_by AS CREATED_BY 
				 , GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4
				 , '' AS ATTRIBUTE5, '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
			FROM ( 	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, LTRIM(RTRIM(A.ITEM_ID)) AS ITEM_ID, 'E' AS DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , 'VMI_In_Req' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMM, A.QTY
						 , CASE WHEN ISNULL(D.ITEM_ID, '') != '' AND ISNULL(E.MGMT_CELL_PROD_SITE_ID, '') != '' THEN E.MGMT_CELL_PROD_SITE_ID
								WHEN ISNULL(D.ITEM_ID, '') != '' AND ISNULL(E.MGMT_CELL_PROD_SITE_ID, '') = ''	THEN '-'	 
								ELSE '-' END AS CELL_PROD_SITE_ID	
					 FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
					 INNER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID 
					 INNER JOIN SCM_MST_SITE_ITEM C WITH(NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID  AND A.PROJECT_CODE = C.PROJECT_CODE AND LTRIM(RTRIM(A.ITEM_ID)) = C.ITEM_ID
					 LEFT OUTER JOIN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE DIVISION_ID = '40' AND FORECAST_INFO_BIZ_TYPE = 'CELL' AND ACTIVE_FLAG = 'Y'	GROUP BY ITEM_ID ) D ON A.ITEM_ID = D.ITEM_ID
					 LEFT OUTER JOIN #TEMP_LOOK_UP_DATA E ON A.CELL_PROD_SITE = E.BP_CELL_PROD_SITE_ID AND C.REPORT_GROUP4 = CASE WHEN ISNULL(E.PRODUCT_DETAILS,'') = '' THEN C.REPORT_GROUP4 ELSE E.PRODUCT_DETAILS END
					 WHERE A.DIVISION_ID = @p_division_id
					   AND A.VERSION_NO	= @p_version_no
					   AND A.YYYYMM >= @V_RESTRICT_START_YYYYMM
					   AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
					   AND A.MEASURE = 'BUSINESS_PLAN'
					   AND ISNULL(A.INCOTERMS, '') <> ''
					   AND ISNULL(A.FCST_TYPE, '') <> ''
					   AND B.VMI_YN = 'Y'
					   AND A.QTY <> 0	-- [E20250818-000190]_0이 아닌경우에만 넣는 조건 추가
				) T
			GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, T.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMM
			-------------------------------------------------------------------------------------------------------------------
			-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN 테이블에 데이터 적재하는 내용을 추가한다. (END)
			-------------------------------------------------------------------------------------------------------------------
		END
		
		-------------------------------------------------------------------------------------------------------------------
		-- 6. SP 재계산
		-------------------------------------------------------------------------------------------------------------------
		EXEC [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW] @p_division_id, 'SYSTEM'	
		
		-------------------------------------------------------------------------------------------------------------------
		-- 7. 데이터 검증
		-------------------------------------------------------------------------------------------------------------------		
		
		IF ISNULL(@P_VERSION_NO, '') != ''
		BEGIN 
			--1). DM_PLN_BP_FCST_C, DM_PLN_MKT_FCST ITEM별 SUM 확인 
			SELECT N'DM_PLN_BP_FCST_C테이블과 DM_PLN_MKT_FCST DIFF 건' AS TYPE, COUNT(*) AS CNT
			FROM 
			(	SELECT YYYYMM, ITEM_ID, SUM(QTY) AS BP_QTYSUM
				FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
				WHERE DIVISION_ID	= @p_division_id
				AND VERSION_NO		= @p_version_no
				AND YYYYMM			>= @V_RESTRICT_START_YYYYMM
				AND YYYYMM			<= @V_RESTRICT_END_YYYYMM
				AND MEASURE			= 'BUSINESS_PLAN'
				AND QTY <> 0
				AND ISNULL(A.INCOTERMS, '') <> ''
				AND ISNULL(A.FCST_TYPE, '') <> ''
				GROUP BY YYYYMM, ITEM_ID 
			) A
			FULL OUTER JOIN  (	SELECT LEFT(YYYYMMDD,6) AS YYYYMM, ITEM_ID, SUM(QTY) AS IMPORT_QTYSUM
								FROM DM_PLN_MKT_FCST A WITH(NOLOCK) 
								LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
								WHERE A.DIVISION_ID = @p_division_id
								AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
								AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD
								AND MEASURE = CASE WHEN ISNULL(B.VMI_YN,'')  = 'Y' THEN 'VMI_IN_REQ' ELSE 'MKT_FCST' END 
								AND QTY <> 0
								GROUP BY LEFT(YYYYMMDD,6), ITEM_ID ) B
						 ON A.ITEM_ID = B.ITEM_ID
						AND A.YYYYMM = B.YYYYMM
			WHERE (A.BP_QTYSUM <> B.IMPORT_QTYSUM) OR (ISNULL(A.ITEM_ID, '') = '') OR (ISNULL(B.ITEM_ID, '') = '')

			--2). DM_PLN_BP_FCST_C, DM_PLN_CFM_MKT_DEMAND_PLAN CELL_PROD_SITE별,ITEM별 SUM 확인 
			SELECT N'DM_PLN_BP_FCST_C 테이블과 DM_PLN_CFM_MKT_DEMAND_PLAN DIFF 건' AS TYPE, COUNT(*) AS CNT
			FROM 
			(	
				SELECT T.YYYYMM, T.ITEM_ID, SUM(T.QTY) AS BP_QTYSUM, T.CELL_PROD_SITE--, T.CELL_YN, T.BP_CELL_PROD_SITE--, T.PRODUCT_DETAIL
				FROM ( 	SELECT A.YYYYMM, A.ITEM_ID, A.QTY, A.CELL_PROD_SITE AS BP_CELL_PROD_SITE, C.REPORT_GROUP4 AS PRODUCT_DETAIL, CASE WHEN ISNULL(D.ITEM_ID, '') != '' THEN 'Y' ELSE 'N' END AS CELL_YN
							 , CASE WHEN ISNULL(D.ITEM_ID, '') != '' AND ISNULL(E.MGMT_CELL_PROD_SITE_ID, '') != '' THEN E.MGMT_CELL_PROD_SITE_ID
									WHEN ISNULL(D.ITEM_ID, '') != '' AND ISNULL(E.MGMT_CELL_PROD_SITE_ID, '') = ''	THEN '-'	 
									ELSE '-' END AS CELL_PROD_SITE				 
						FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
						INNER JOIN SCM_MST_SITE_ITEM C WITH(NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID  AND A.PROJECT_CODE = C.PROJECT_CODE AND LTRIM(RTRIM(A.ITEM_ID)) = C.ITEM_ID
						LEFT OUTER JOIN (  SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE DIVISION_ID = '40' AND FORECAST_INFO_BIZ_TYPE = 'CELL' AND ACTIVE_FLAG = 'Y'	GROUP BY ITEM_ID ) D ON A.ITEM_ID = D.ITEM_ID
						LEFT OUTER JOIN #TEMP_LOOK_UP_DATA E ON A.CELL_PROD_SITE = E.BP_CELL_PROD_SITE_ID AND C.REPORT_GROUP4 = CASE WHEN ISNULL(E.PRODUCT_DETAILS,'') = '' THEN C.REPORT_GROUP4 ELSE E.PRODUCT_DETAILS END
						WHERE A.DIVISION_ID = @p_division_id
						AND A.VERSION_NO = @p_version_no
						AND A.YYYYMM >= @V_RESTRICT_START_YYYYMM
						AND A.YYYYMM <= @V_RESTRICT_END_YYYYMM
						AND A.MEASURE = 'BUSINESS_PLAN'
						AND A.QTY <> 0
						AND ISNULL(A.INCOTERMS, '') <> ''
						AND ISNULL(A.FCST_TYPE, '') <> ''
					 ) T
				GROUP BY T.YYYYMM, T.ITEM_ID, T.CELL_PROD_SITE--, T.CELL_YN, T.PRODUCT_DETAIL, T.CELL_PROD_SITE, T.BP_CELL_PROD_SITE
			) A
			FULL OUTER JOIN  (	SELECT T.YYYYMM, T.ITEM_ID, T.CELL_PROD_SITE_ID, SUM(T.QTY) AS IMPORT_QTYSUM
								FROM (	SELECT LEFT(A.YYYYMMDD,6) AS YYYYMM, A.ITEM_ID, A.CELL_PROD_SITE_ID, A.QTY
										FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK) 
										LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
										WHERE A.DIVISION_ID = @p_division_id
										AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
										AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD
										AND MEASURE = CASE WHEN ISNULL(B.VMI_YN,'')  = 'Y' THEN 'VMI_IN_REQ' ELSE 'MKT_FCST' END 
										AND QTY <> 0
									 ) T
								GROUP BY T.YYYYMM, T.ITEM_ID, T.CELL_PROD_SITE_ID
							 ) B
						 ON A.ITEM_ID = B.ITEM_ID
						AND A.YYYYMM = B.YYYYMM
						AND A.CELL_PROD_SITE = B.CELL_PROD_SITE_ID
			WHERE (A.BP_QTYSUM <> B.IMPORT_QTYSUM) OR (ISNULL(A.ITEM_ID, '') = '') OR (ISNULL(B.ITEM_ID, '') = '')
		END

		-- 1). DM_PLN_MKT_FCST 데이터 조회
		SELECT YYYYMMDD, ITEM_ID, SUM(QTY) AS IMPORT_QTYSUM
		  FROM DM_PLN_MKT_FCST A WITH(NOLOCK) 
		  LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
		 WHERE A.DIVISION_ID = @p_division_id
		   AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
		   AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
		   AND MEASURE = CASE WHEN ISNULL(B.VMI_YN,'')  = 'Y' THEN 'VMI_IN_REQ' ELSE 'MKT_FCST' END 
		   AND QTY <> 0
		 GROUP BY YYYYMMDD, ITEM_ID
		 ORDER BY 1, 2
		 
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN 검증내역 추가한다. (START)
		-------------------------------------------------------------------------------------------------------------------
		-- 2). DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 조회
		SELECT YYYYMMDD, ITEM_ID, SUM(QTY) AS IMPORT_QTYSUM
		  FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK) 
		  LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
		 WHERE A.DIVISION_ID = @p_division_id
		   AND YYYYMMDD	>= @V_RESTRICT_START_YYYYMMDD
		   AND YYYYMMDD <= @V_RESTRICT_END_YYYYMMDD -- [E20250818-000190]_입력제한일 END 추가
		   AND MEASURE = CASE WHEN ISNULL(B.VMI_YN,'')  = 'Y' THEN 'VMI_IN_REQ' ELSE 'MKT_FCST' END 
		   AND QTY <> 0
		 GROUP BY YYYYMMDD, ITEM_ID
		 ORDER BY 1, 2
		-------------------------------------------------------------------------------------------------------------------
		-- [E20250818-000190]_DM_PLN_CFM_MKT_DEMAND_PLAN 검증내역 추가한다. (END)
		-------------------------------------------------------------------------------------------------------------------
		
		-------------------------------------------------------------------------------------------------------------------
		-- 7. DM_PLN_BP_FCST, DM_PLN_BP_FCST_C 데이터 검증
		-------------------------------------------------------------------------------------------------------------------
		IF ISNULL(@P_VERSION_NO, '') = ''
		BEGIN 
			--1). DM_PLN_BP_FCST 데이터 조회
			SELECT YYYYMM, ITEM_ID, SUM(QTY) AS BP_QTYSUM
			  FROM DM_PLN_BP_FCST A WITH(NOLOCK)
			 WHERE DIVISION_ID = @p_division_id
			   AND YYYYMM >= @V_RESTRICT_START_YYYYMM
			   AND YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
			   AND MEASURE = 'BUSINESS_PLAN'
			   AND QTY <> 0
			   AND ISNULL(A.INCOTERMS, '') <> ''
			   AND ISNULL(A.FCST_TYPE, '') <> ''
			 GROUP BY YYYYMM, ITEM_ID
			 ORDER BY 1, 2
		END 
		ELSE
		BEGIN
			--2). DM_PLN_BP_FCST_C 데이터 조회
			SELECT YYYYMM, ITEM_ID, SUM(QTY) AS BP_QTYSUM
			  FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
			 WHERE DIVISION_ID = @p_division_id
			   AND VERSION_NO = @p_version_no
			   AND YYYYMM >= @V_RESTRICT_START_YYYYMM
			   AND YYYYMM <= @V_RESTRICT_END_YYYYMM -- [E20250818-000190]_입력제한일 END 추가
			   AND MEASURE = 'BUSINESS_PLAN'
			   AND QTY <> 0
			   AND ISNULL(A.INCOTERMS, '') <> ''
			   AND ISNULL(A.FCST_TYPE, '') <> ''
			 GROUP BY YYYYMM, ITEM_ID
			 ORDER BY 1, 2
		END

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
    SET @v_description	= N'@p_division_id :' + @p_division_id + '/'+ N'@p_version_no :' + @p_version_no + '/'+ N'@p_created_by :' + @p_created_by + '/ '+ N'소형 중장기'
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	-------------------------------------------------------------------------------------------
	-- 종료 LOG  (END)
	-------------------------------------------------------------------------------------------
END


