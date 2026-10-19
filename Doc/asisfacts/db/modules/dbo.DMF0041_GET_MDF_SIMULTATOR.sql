/*
 * Program ID   : DMF0041_GET_MDF_SIMULTATOR
 * Description  :  MDF Simulator 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/02/18  JYE             Initial Release 
 ** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
 */
CREATE PROCEDURE [dbo].[DMF0041_GET_MDF_SIMULTATOR]
	@p_division_id			NVARCHAR(4000),
	@p_dept_id				NVARCHAR(4000),
	@p_application			NVARCHAR(4000),
	@p_model_type			NVARCHAR(4000),
	@p_mdf_version_no		NVARCHAR(50),
	@p_sp_version_no		NVARCHAR(50),
	@p_start_dt				NVARCHAR(08),
	@p_end_dt				NVARCHAR(08),
	@p_created_by			NVARCHAR(50),
	@p_user_group			NVARCHAR(50)
AS
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @PROD			NVARCHAR(MAX)=''
	DECLARE @SQL			NVARCHAR(MAX)=''
	DECLARE @v_group_id		nvarchar(50)='';
	DECLARE @v_team_id		nvarchar(50)='';

	-- 임시 테이블 삭제
	IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL 
		DROP TABLE #temp;
	IF OBJECT_ID (N'tempdb..#temp2', N'U') IS NOT NULL 
		DROP TABLE #temp2;
	IF OBJECT_ID (N'tempdb..#middle_sum', N'U') IS NOT NULL 
		DROP TABLE #middle_sum;
	IF OBJECT_ID (N'tempdb..#middle_sum2', N'U') IS NOT NULL 
		DROP TABLE #middle_sum2;
	IF OBJECT_ID (N'tempdb..#sales_plan_c', N'U') IS NOT NULL 
		DROP TABLE #sales_plan_c;
	IF OBJECT_ID (N'tempdb..#sales_plan_result_c', N'U') IS NOT NULL 
		DROP TABLE #sales_plan_result_c;

	-- #sales_plan_c TEMP TABLE
	--CREATE TABLE #sales_plan_c  (
 --            DIVISION_ID		NVARCHAR(30)   NOT NULL
	--		,VERSION_NO   		NVARCHAR(50)   NOT NULL
	--		,CUTOFF_TYPE		NVARCHAR(10)   NOT NULL
	--		,CUTOFF_YYYYMMDD	NVARCHAR(8)    NOT NULL
	--		,PROJECT_CODE		NVARCHAR(50)   NOT NULL
	--		,SCM_SITE_ID		NVARCHAR(30)   NOT NULL
	--		,ITEM_ID    		NVARCHAR(50)   NOT NULL
	--		,DOM_EXP			NVARCHAR(3)    NOT NULL
	--		,FCST_TYPE			NVARCHAR(20)   NOT NULL
	--		,INCOTERMS			NVARCHAR(10)   NOT NULL
	--		,MEASURE		    NVARCHAR(50)   NOT NULL
	--		,PLANT_SITE_ID		NVARCHAR(30)   NOT NULL
	--		,YYYYMMDD			NVARCHAR(8)    NOT NULL
	--		,CURRENCY			NVARCHAR(8)    NOT NULL
	--		,QTY				NUMERIC(20,10) NOT NULL
 --   )

	---- #sales_result_c TEMP TABLE
	--CREATE TABLE #sales_result_c  (
 --            DIVISION_ID		NVARCHAR(30)   NOT NULL
	--		,VERSION_NO   		NVARCHAR(50)   NOT NULL
	--		,CUTOFF_TYPE		NVARCHAR(10)   NOT NULL
	--		,CUTOFF_YYYYMMDD	NVARCHAR(8)    NOT NULL
	--		,PROJECT_CODE		NVARCHAR(50)   NOT NULL
	--		,SCM_SITE_ID		NVARCHAR(30)   NOT NULL
	--		,ITEM_ID    		NVARCHAR(50)   NOT NULL
	--		,DOM_EXP			NVARCHAR(3)    NOT NULL
	--		,FCST_TYPE			NVARCHAR(20)   NOT NULL
	--		,INCOTERMS			NVARCHAR(10)   NOT NULL
	--		,MEASURE		    NVARCHAR(50)   NOT NULL
	--		,PLANT_SITE_ID		NVARCHAR(30)   NOT NULL
	--		,YYYYMMDD			NVARCHAR(8)    NOT NULL
	--		,CURRENCY			NVARCHAR(8)    NOT NULL
	--		,QTY				NUMERIC(20,10) NOT NULL
 --   )

    SELECT DIVISION_ID	
	     , VERSION_NO   	
	     , CUTOFF_TYPE	
	     , CUTOFF_YYYYMMDD
	     , PROJECT_CODE	
	     , SCM_SITE_ID	
	     , ITEM_ID    	
	     , DOM_EXP		
	     , FCST_TYPE		
	     , INCOTERMS		
	     , MEASURE		
	     , PLANT_SITE_ID	
	     , YYYYMMDD		
	     , CURRENCY		
	     , QTY	
      INTO #sales_plan_c
      FROM [DM_PLN_SALES_PLAN_C] a WITH(NOLOCK)
     WHERE VERSION_NO = @p_sp_version_no
    ;
	
    SELECT DIVISION_ID	
	     , VERSION_NO   	
	     , CUTOFF_TYPE	
	     , CUTOFF_YYYYMMDD
	     , PROJECT_CODE	
	     , SCM_SITE_ID	
	     , ITEM_ID    	
	     , DOM_EXP		
	     , FCST_TYPE		
	     , INCOTERMS		
	     , MEASURE		
	     , PLANT_SITE_ID	
	     , YYYYMMDD		
	     , CURRENCY		
	     , QTY	
      INTO #sales_plan_result_c
      FROM DM_PLN_SALES_PLAN_RESULT_C a WITH(NOLOCK)
     WHERE VERSION_NO = @p_sp_version_no
    ;

	-- 권한 그룹
	--IF @p_user_group = 'ADMIN' OR @p_user_group = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN';

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_user_group
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	-- 팀 권한
	select @v_team_id = Dept_ID from [dbo].[TB_FX_User] WITH(NOLOCK) where UserID = @p_created_by;

	-- 단계1. 데이터 쿼리 ########################################################
	WITH MIDDLE_SUMMARY AS 
	(
		SELECT DISTINCT
			MDF.MDF_VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			, MEASURE
			, UNIT_CURRENCY
			, YYYYMM
			, ISNULL(QTY, 0) AS QTY
			, @p_sp_version_no AS SPVERSION_NO
		FROM DM_PLN_MDF_SIMULATOR_DATA MDF WITH(NOLOCK)
             INNER JOIN (SELECT DISTINCT '%' + TOKEN + '%' AS APP FROM dbo.String_Split(@p_application,',')) C
                ON APPLICATION LIKE C.APP
		WHERE MDF_VERSION_NO = @p_mdf_version_no
			--AND APPLICATION IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_application,','))
			AND ITEM_TYPE IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_model_type,','))
			AND DEPARTMENT_ID IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,','))

		UNION ALL
		-- 계획 구간(Current)
		SELECT 
			MDF.MDF_VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			,CASE WHEN A.MEASURE = 'RTF' THEN 'Cell_Qty'
				WHEN A.MEASURE = 'SalesAmt_USD' THEN 'Amt' END MEASURE
			,CASE WHEN A.MEASURE = 'RTF' THEN N'천팩' 
				WHEN A.MEASURE = 'SalesAmt_USD' THEN N'천$' END unit_currency  
			,SUBSTRING(A.YYYYMMDD,1,6) YYYYMM
--			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN (  A.QTY * ISNULL(i.FORECAST_INFO_CELL_PACK_COUNT,1) ) /1000
			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN A.QTY
				 WHEN A.MEASURE = 'SalesAmt_USD' THEN A.QTY / 1000 END) QTY   
			, 'Current' AS SPVERSION_NO
--		FROM [10.34.221.78,7433].[LGCE_SCMDEV].[dbo].[DM_PLN_SALES_PLAN] A WITH(NOLOCK)
		FROM [dbo].[DM_PLN_SALES_PLAN] A WITH(NOLOCK)
			,SCM_MST_SITE_ITEM SI  WITH(NOLOCK)
			,( 
				-- key 기준 Mapping
				SELECT 
					DISTINCT 
					MDF_VERSION_NO
					, DIVISION_ID
					, DEPARTMENT_ID
					, DMS_SALES
					, DMS_CUSTOMER
					, APPLICATION
					, BIZ_TYPE
					, ITEM_TYPE 
					, CASE WHEN ITEM_TYPE = N'원통형'  THEN 'MCC'     
						WHEN ITEM_TYPE = N'파우치형' THEN 'MCP'
						WHEN ITEM_TYPE = N'각형' THEN 'MCR' END ITEM_TYPE2
					, CASE WHEN BIZ_TYPE = 'PACK'  THEN 'MP'     
						WHEN BIZ_TYPE = 'CELL'  THEN 'MC'END BIZ_TYPE2
				FROM DM_PLN_MDF_SIMULATOR_DATA WITH(NOLOCK) 
                     INNER JOIN (SELECT DISTINCT '%' + TOKEN + '%' AS APP FROM dbo.String_Split(@p_application,',')) C
                        ON APPLICATION LIKE C.APP
				WHERE MDF_VERSION_NO = @p_mdf_version_no
					AND DIVISION_ID = @p_division_id
					--AND APPLICATION IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_application,','))
					AND ITEM_TYPE IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_model_type,','))
					AND DEPARTMENT_ID IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,','))
			) MDF
			,DM_MST_ITEM_SINGLE_V   i WITH(NOLOCK) 
			,(
				SELECT 
					B.USER_ID
					, B.USER_NAME
					, B.USER_NAME_EN
					, B.DEPT_ID
					, C.DEPT_NAME_KO
					, C.UPPER_DEPT_ID
				FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
				INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
		WHERE 1=1
			AND A.YYYYMMDD >= @p_start_dt -- 당주 월요일
			AND A.YYYYMMDD < @p_end_dt  -- 조회 끝 기준 
			AND A.MEASURE in ( 'RTF' ,'SalesAmt_USD' )
			AND A.DIVISION_ID  = SI.DIVISION_ID
			AND A.PROJECT_CODE = SI.PROJECT_CODE
			AND A.SCM_SITE_ID  = SI.SCM_SITE_ID
			AND A.ITEM_ID      = SI.ITEM_ID
			AND A.DIVISION_ID  = MDF.DIVISION_ID
			AND DMS_SALES      LIKE '%' + SI.ATTRIBUTE1 + '%'  -- DMS 판매처
			AND SI.ATTRIBUTE2  = MDF.DMS_CUSTOMER            -- DMS_고객군
			AND SI.ATTRIBUTE5  LIKE MDF.ITEM_TYPE2 +'%'      -- CELL 모델 
			AND SI.ITEM_ID     LIKE MDF.BIZ_TYPE2 +'%'       -- BIZ 적용 모델
			--AND SI.APPLICATION = MDF.APPLICATION  -- 기기
			AND MDF.APPLICATION LIKE '%' + SI.APPLICATION + '%'  -- 기기
			AND SI.DIVISION_ID = I.DIVISION_ID
			AND SI.ITEM_ID     = I.ITEM_ID
			AND TEAM.USER_ID   IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](SI.OWNER, ','))
			AND TEAM.UPPER_DEPT_ID = MDF.DEPARTMENT_ID
			AND @p_sp_version_no LIKE '%Current%'
		GROUP BY 
			MDF.MDF_VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			, A.MEASURE
			, SUBSTRING(A.YYYYMMDD,1,6)


		UNION ALL
		-- 실적 구간(Current)
		SELECT 
			MDF.MDF_VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			,CASE WHEN A.MEASURE = 'RTF' THEN N'Cell_Qty' 
				WHEN A.MEASURE = 'SalesAmt_LOC' THEN N'Amt' END MEASURE
			,CASE WHEN A.MEASURE = 'RTF' THEN N'천팩' 
				WHEN A.MEASURE = 'SalesAmt_LOC' THEN N'천$' END UNIT_CURRENCY  
			,SUBSTRING(A.YYYYMMDD,1,6) YYYYMM
--			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN (  A.QTY * ISNULL(i.FORECAST_INFO_CELL_PACK_COUNT,1) ) /1000
			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN A.QTY
				WHEN A.MEASURE = 'SalesAmt_LOC' THEN A.QTY / 1000 END) QTY   
			, 'Current' AS SPVERSION_NO
--		FROM [10.34.221.78,7433].[LGCE_SCMDEV].[dbo].[DM_PLN_SALES_PLAN_RESULT] A WITH(NOLOCK)
		FROM [dbo].[DM_PLN_SALES_PLAN_RESULT] A WITH(NOLOCK)
			,SCM_MST_SITE_ITEM SI  WITH(NOLOCK)
			,( 
			  -- key 기준 Mapping
				SELECT 
					DISTINCT 
					MDF_VERSION_NO
					, DIVISION_ID
					, DEPARTMENT_ID
					, DMS_SALES
					, DMS_CUSTOMER
					, APPLICATION
					, BIZ_TYPE
					, ITEM_TYPE
					, CASE WHEN ITEM_TYPE = N'원통형'  THEN 'MCC'     
						WHEN ITEM_TYPE = N'파우치형' THEN 'MCP'
						WHEN ITEM_TYPE = N'각형' THEN 'MCR' END ITEM_TYPE2
					, CASE WHEN BIZ_TYPE = 'PACK'  THEN 'MP'     
						WHEN BIZ_TYPE = 'CELL'  THEN 'MC'END BIZ_TYPE2
				FROM DM_PLN_MDF_SIMULATOR_DATA WITH(NOLOCK) 
                     INNER JOIN (SELECT DISTINCT '%' + TOKEN + '%' AS APP FROM dbo.String_Split(@p_application,',')) C
                        ON APPLICATION LIKE C.APP
				WHERE MDF_VERSION_NO = @p_mdf_version_no
					AND DIVISION_ID = @p_division_id
					--AND APPLICATION IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_application,','))
					AND ITEM_TYPE IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_model_type,','))
					AND DEPARTMENT_ID IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,','))
			) MDF
			, DM_MST_ITEM_SINGLE_V   i WITH(NOLOCK) 
			,(
				SELECT 
				B.USER_ID
				, B.USER_NAME
				, B.USER_NAME_EN
				, B.DEPT_ID
				, C.DEPT_NAME_KO
				, C.UPPER_DEPT_ID
				FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
				INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
		WHERE 1=1
			AND A.YYYYMMDD >= @p_start_dt -- 조회 시작 기준 
			AND A.YYYYMMDD < @p_end_dt -- 당주 월요일
			AND A.MEASURE in ( 'RTF' ,'SalesAmt_LOC' ) -- 실적은 USD Measure가 없음.. 
			AND A.DIVISION_ID  = SI.DIVISION_ID
			AND A.PROJECT_CODE = SI.PROJECT_CODE
			AND A.SCM_SITE_ID  = SI.SCM_SITE_ID
			AND A.ITEM_ID      = SI.ITEM_ID
			AND A.DIVISION_ID  = MDF.DIVISION_ID
			AND DMS_SALES      LIKE '%' +SI.ATTRIBUTE1 + '%'  -- DMS 판매처
			AND SI.ATTRIBUTE2  = MDF.DMS_CUSTOMER            -- DMS_고객군
			AND SI.ATTRIBUTE5  LIKE MDF.ITEM_TYPE2 +'%'      -- CELL 모델 
			AND SI.ITEM_ID     LIKE MDF.BIZ_TYPE2 +'%'       -- BIZ 적용 모델
			--AND SI.APPLICATION = MDF.APPLICATION  -- 기기
			AND MDF.APPLICATION LIKE '%' + SI.APPLICATION + '%'  -- 기기
			AND SI.DIVISION_ID = I.DIVISION_ID
			AND SI.ITEM_ID     = I.ITEM_ID
			AND TEAM.USER_ID   IN (SELECT TOP 1 TOKEN FROM [DBO].String_Split(SI.OWNER, ','))
			AND TEAM.UPPER_DEPT_ID = MDF.DEPARTMENT_ID
			AND @p_sp_version_no LIKE '%Current%'
		GROUP BY 
			MDF.MDF_VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			, A.MEASURE
			, SUBSTRING(A.YYYYMMDD, 1, 6)

			--select distinct version_no from [10.34.221.78,7433].[LGCE_SCMDEV].[dbo].[DM_PLN_SALES_PLAN_C]
		UNION ALL
		-- 계획 구간(버전)
		SELECT 
			MDF.MDF_VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			,CASE WHEN A.MEASURE = 'RTF' THEN N'Cell_Qty' 
				WHEN A.MEASURE = 'SalesAmt_USD' THEN N'Amt' END MEASURE
			,CASE WHEN A.MEASURE = 'RTF' THEN N'천팩' 
				WHEN A.MEASURE = 'SalesAmt_USD' THEN N'천$' END UNIT_CURRENCY  
			,SUBSTRING(A.YYYYMMDD,1,6) yyyymm
--			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN (  A.QTY * ISNULL(i.FORECAST_INFO_CELL_PACK_COUNT,1) ) /1000
			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN A.QTY
					WHEN A.MEASURE = 'SalesAmt_USD' THEN A.QTY / 1000 END) QTY
			, A.VERSION_NO AS SPVERSION_NO
--		FROM [10.34.221.78,7433].[LGCE_SCMDEV].[dbo].[DM_PLN_SALES_PLAN_C] a WITH(NOLOCK)
		FROM #sales_plan_c a WITH(NOLOCK)
			, SCM_MST_SITE_ITEM SI  WITH(NOLOCK)
			, ( 
				-- key 기준 Mapping
				SELECT 
					DISTINCT 
					MDF_VERSION_NO
					, DIVISION_ID
					, DEPARTMENT_ID
					, DMS_SALES
					, DMS_CUSTOMER
					, APPLICATION
					, BIZ_TYPE
					, ITEM_TYPE
					, CASE WHEN ITEM_TYPE = N'원통형'  THEN 'MCC'     
						WHEN ITEM_TYPE = N'파우치형' THEN 'MCP'
						WHEN ITEM_TYPE = N'각형' THEN 'MCR' END ITEM_TYPE2
					, CASE WHEN BIZ_TYPE = 'PACK'  THEN 'MP'     
						WHEN BIZ_TYPE = 'CELL'  THEN 'MC'END BIZ_TYPE2
				FROM DM_PLN_MDF_SIMULATOR_DATA WITH(NOLOCK)
                     INNER JOIN (SELECT DISTINCT '%' + TOKEN + '%' AS APP FROM dbo.String_Split(@p_application,',')) C
                        ON APPLICATION LIKE C.APP
				WHERE --MDF_VERSION_NO = @p_mdf_version_no
					DIVISION_ID = @p_division_id
					--AND APPLICATION IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_application,','))
					AND ITEM_TYPE IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_model_type,','))
					AND DEPARTMENT_ID IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,','))
			) MDF
			, DM_MST_ITEM_SINGLE_V I WITH(NOLOCK) 
			, (
				SELECT 
					B.USER_ID
					, B.USER_NAME
					, B.USER_NAME_EN
					, B.DEPT_ID
					, C.DEPT_NAME_KO
					, C.UPPER_DEPT_ID
				FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
				INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
		WHERE 1=1
			AND A.YYYYMMDD >= @p_start_dt -- 당주 월요일
			AND A.YYYYMMDD < @p_end_dt  -- 조회 끝 기준 
			AND A.MEASURE in ( 'RTF' ,'SalesAmt_USD' )
			AND A.DIVISION_ID  = SI.DIVISION_ID
			AND A.PROJECT_CODE = SI.PROJECT_CODE
			AND A.SCM_SITE_ID  = SI.SCM_SITE_ID
			AND A.ITEM_ID      = SI.ITEM_ID
			AND A.DIVISION_ID  = MDF.DIVISION_ID
			AND DMS_SALES      LIKE '%' +SI.ATTRIBUTE1 + '%'  -- DMS 판매처
			AND SI.ATTRIBUTE2  = MDF.DMS_CUSTOMER            -- DMS_고객군
			AND SI.ATTRIBUTE5  LIKE MDF.ITEM_TYPE2 +'%'      -- CELL 모델 
			AND SI.ITEM_ID     LIKE MDF.BIZ_TYPE2 +'%'       -- BIZ 적용 모델
			--AND SI.APPLICATION = MDF.APPLICATION  -- 기기
			AND MDF.APPLICATION LIKE '%' + SI.APPLICATION + '%'  -- 기기
			AND SI.DIVISION_ID = I.DIVISION_ID
			AND SI.ITEM_ID     = I.ITEM_ID
			AND TEAM.USER_ID   IN (SELECT TOP 1 TOKEN FROM [DBO].String_Split(SI.OWNER, ','))
			AND TEAM.UPPER_DEPT_ID = MDF.DEPARTMENT_ID
			--AND a.VERSION_NO = @p_sp_version_no
		GROUP BY 
			MDF.MDF_VERSION_NO
			, A.VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			, A.MEASURE
			, SUBSTRING(A.YYYYMMDD,1,6)


		UNION ALL
		-- 실적 구간(버전)
		SELECT 
			MDF.MDF_VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			,CASE WHEN A.MEASURE = 'RTF' THEN N'Cell_Qty' 
				WHEN A.MEASURE = 'SalesAmt_LOC' THEN N'Amt' END MEASURE
			,CASE WHEN A.MEASURE = 'RTF' THEN N'천팩' 
				WHEN A.MEASURE = 'SalesAmt_LOC' THEN N'천$' END UNIT_CURRENCY  
			,SUBSTRING(A.YYYYMMDD,1,6) YYYYMM
--			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN (  A.QTY * ISNULL(i.FORECAST_INFO_CELL_PACK_COUNT,1) ) /1000
			,SUM(CASE WHEN A.MEASURE = 'RTF' THEN A.QTY
			WHEN A.MEASURE = 'SalesAmt_LOC' THEN A.QTY / 1000 END) QTY   
			, a.VERSION_NO AS SPVERSION_NO
--		FROM [10.34.221.78,7433].[LGCE_SCMDEV].[dbo].[DM_PLN_SALES_PLAN_RESULT_C] a WITH(NOLOCK)
		FROM #sales_plan_result_c a WITH(NOLOCK)
			,SCM_MST_SITE_ITEM SI  WITH(NOLOCK)
			,( 
				-- key 기준 Mapping
				SELECT 
					DISTINCT 
					MDF_VERSION_NO
					, DIVISION_ID
					, DEPARTMENT_ID
					, DMS_SALES
					, DMS_CUSTOMER
					, APPLICATION
					, BIZ_TYPE
					, ITEM_TYPE
					, CASE WHEN ITEM_TYPE = N'원통형'  THEN 'MCC'     
						WHEN ITEM_TYPE = N'파우치형' THEN 'MCP'
						WHEN ITEM_TYPE = N'각형' THEN 'MCR' END ITEM_TYPE2
					, CASE WHEN BIZ_TYPE = 'PACK'  THEN 'MP'     
						WHEN BIZ_TYPE = 'CELL'  THEN 'MC'END BIZ_TYPE2
				FROM DM_PLN_MDF_SIMULATOR_DATA WITH(NOLOCK) 
                     INNER JOIN (SELECT DISTINCT '%' + TOKEN + '%' AS APP FROM dbo.String_Split(@p_application,',')) C
                        ON APPLICATION LIKE C.APP
				WHERE --MDF_VERSION_NO = @p_mdf_version_no 
					DIVISION_ID = @p_division_id
					--AND APPLICATION IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_application,','))
					AND ITEM_TYPE IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_model_type,','))
					AND DEPARTMENT_ID IN  (SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,','))
			) MDF
			, DM_MST_ITEM_SINGLE_V I WITH(NOLOCK) 
			, (
				SELECT 
					B.USER_ID
					, B.USER_NAME
					, B.USER_NAME_EN
					, B.DEPT_ID
					, C.DEPT_NAME_KO
					, C.UPPER_DEPT_ID
				FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK) 
				INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK) 
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
		WHERE 1=1
			AND A.YYYYMMDD >= @p_start_dt -- 조회 시작 기준 
			AND A.YYYYMMDD < @p_END_dt -- 당주 월요일
			AND A.MEASURE in ( 'RTF' ,'SalesAmt_LOC' ) -- 실적은 USD Measure가 없음.. 
			AND A.DIVISION_ID  = SI.DIVISION_ID
			AND A.PROJECT_CODE = SI.PROJECT_CODE
			AND A.SCM_SITE_ID  = SI.SCM_SITE_ID
			AND A.ITEM_ID      = SI.ITEM_ID
			AND A.DIVISION_ID  = MDF.DIVISION_ID
			AND DMS_SALES      LIKE '%' +SI.ATTRIBUTE1 + '%'  -- DMS 판매처
			AND SI.ATTRIBUTE2  = MDF.DMS_CUSTOMER            -- DMS_고객군
			AND SI.ATTRIBUTE5  LIKE MDF.ITEM_TYPE2 +'%'      -- CELL 모델 
			AND SI.ITEM_ID     LIKE MDF.BIZ_TYPE2 +'%'       -- BIZ 적용 모델
			--AND SI.APPLICATION = MDF.APPLICATION  -- 기기
			AND MDF.APPLICATION LIKE '%' + SI.APPLICATION + '%'  -- 기기
			AND SI.DIVISION_ID = I.DIVISION_ID
			AND SI.ITEM_ID     = I.ITEM_ID
			AND TEAM.USER_ID   IN (SELECT TOP 1 TOKEN FROM [DBO].String_Split(SI.OWNER, ','))
			AND TEAM.UPPER_DEPT_ID = MDF.DEPARTMENT_ID
			--AND a.VERSION_NO = @p_sp_version_no
		GROUP BY 
			MDF.MDF_VERSION_NO
			, A.VERSION_NO
			, MDF.DIVISION_ID
			, MDF.DEPARTMENT_ID
			, MDF.DMS_CUSTOMER
			, MDF.DMS_SALES
			, MDF.APPLICATION
			, MDF.BIZ_TYPE
			, MDF.ITEM_TYPE
			, A.MEASURE
			, SUBSTRING(A.YYYYMMDD,1,6)
	)
    SELECT *
      INTO #middle_sum
      FROM MIDDLE_SUMMARY;

		--SELECT 
		--	A.MDF_VERSION_NO
		--	, A.DIVISION_ID
		--	, A.DEPARTMENT_ID
		--	, A.DMS_CUSTOMER
		--	, A.DMS_SALES
		--	, A.APPLICATION
		--	, A.BIZ_TYPE
		--	, A.ITEM_TYPE
		--	, A.MEASURE
		--	, A.UNIT_CURRENCY
		--	, A.YYYYMM
		--	--, SUM(A.QTY*B.QTY) QTY
		--	, SUM(A.QTY) QTY
		--	, A.SPVERSION_NO
  --      INTO #middle_sum2
		--FROM #middle_sum A 
		--	  --,MIDDLE_SUMMARY B
		--WHERE A.MEASURE = 'Cell_Qty'	--N'금액'
		--	--AND B.MEASURE = 'Amt'		--N'기본계약조건'
		--	--AND A.MDF_VERSION_NO  = B.MDF_VERSION_NO
		--	--AND A.DIVISION_ID     = B.DIVISION_ID
		--	--AND A.DEPARTMENT_ID   = B.DEPARTMENT_ID
		--	--AND A.DMS_CUSTOMER    = B.DMS_CUSTOMER
		--	--AND A.DMS_SALES       = B.DMS_SALES
		--	--AND A.APPLICATION     = B.APPLICATION
		--	--AND A.BIZ_TYPE        = B.BIZ_TYPE
		--	--AND A.ITEM_TYPE       = B.ITEM_TYPE
		--	--AND A.YYYYMM          = B.YYYYMM
		--GROUP BY 
		--	A.MDF_VERSION_NO
		--	, A.SPVERSION_NO
		--	, A.DIVISION_ID
		--	, A.DEPARTMENT_ID
		--	, A.DMS_CUSTOMER
		--	, A.DMS_SALES
		--	, A.APPLICATION
		--	, A.BIZ_TYPE
		--	, A.ITEM_TYPE
		--	, A.MEASURE
		--	, A.UNIT_CURRENCY
		--	, A.YYYYMM
  --      ;
	-- 없는 measure(Cell_Qty, Amt) 추가.
	WITH MIDDLE_SUMMARY2 as (
  --      select *
  --        from #middle_sum2 m
		--UNION ALL -- 바로 위 쿼리에서 A.MEASURE = N'Cell_Qty' AND B.MEASURE = N'Amt' 조건이 안 맞을 수 있어 몽땅 넣어 줌.
		SELECT 
			MDF_VERSION_NO
			, DIVISION_ID
			, DEPARTMENT_ID
			, DMS_CUSTOMER
			, DMS_SALES
			, APPLICATION
			, BIZ_TYPE
			, ITEM_TYPE
			, MEASURE
			, UNIT_CURRENCY
			, YYYYMM
			, 0 AS QTY
			, SPVERSION_NO
		FROM (
		SELECT 
				MDF_VERSION_NO
				, DIVISION_ID
				, DEPARTMENT_ID
				, DMS_CUSTOMER
				, DMS_SALES
				, APPLICATION
				, BIZ_TYPE
				, ITEM_TYPE
				, 'Cell_Qty' MEASURE
				, N'천팩' UNIT_CURRENCY
				, YYYYMM
				, SPVERSION_NO
			FROM #middle_sum
			GROUP BY
				MDF_VERSION_NO
				, SPVERSION_NO
				, DIVISION_ID
				, DEPARTMENT_ID
				, DMS_CUSTOMER
				, DMS_SALES
				, APPLICATION
				, BIZ_TYPE
				, ITEM_TYPE
				, YYYYMM
		UNION ALL
		SELECT 
				MDF_VERSION_NO
				, DIVISION_ID
				, DEPARTMENT_ID
				, DMS_CUSTOMER
				, DMS_SALES
				, APPLICATION
				, BIZ_TYPE
				, ITEM_TYPE
				, 'Amt' MEASURE
				, N'천$' UNIT_CURRENCY
				, YYYYMM
				, SPVERSION_NO
			FROM #middle_sum
			GROUP BY
				MDF_VERSION_NO
				, SPVERSION_NO
				, DIVISION_ID
				, DEPARTMENT_ID
				, DMS_CUSTOMER
				, DMS_SALES
				, APPLICATION
				, BIZ_TYPE
				, ITEM_TYPE
				, YYYYMM
		) SUB
        where not exists (select 1 
                            from #middle_sum m
                           where m.MDF_VERSION_NO = sub.MDF_VERSION_NO
                             and m.DIVISION_ID = sub.DIVISION_ID
                             and m.DEPARTMENT_ID = sub.DEPARTMENT_ID
                             and m.DMS_CUSTOMER = sub.DMS_CUSTOMER
                             and m.DMS_SALES = sub.DMS_SALES
                             and m.APPLICATION = sub.APPLICATION
                             and m.ITEM_TYPE = sub.ITEM_TYPE
                             and m.BIZ_TYPE = sub.BIZ_TYPE
                             and m.MEASURE = sub.MEASURE
                             and m.UNIT_CURRENCY = sub.UNIT_CURRENCY
                             and m.YYYYMM = sub.YYYYMM
                             and m.SPVERSION_NO = sub.SPVERSION_NO
                         )
	)
	-- 없는 measure(MDF_Basic) 추가.
	,MIDDLE_SUMMARY30 as (
		SELECT 
			A.MDF_VERSION_NO
			, A.DIVISION_ID
			, A.DEPARTMENT_ID
			, A.DMS_CUSTOMER
			, A.DMS_SALES
			, A.APPLICATION
			, A.BIZ_TYPE
			, A.ITEM_TYPE
			, 'MDF_Basic' MEASURE
			, N'천$' UNIT_CURRENCY
			, A.YYYYMM
			, SUM(A.QTY*B.QTY) QTY
			, A.SPVERSION_NO
		FROM #middle_sum A
			  ,#middle_sum B
		--WHERE A.MEASURE = 'Amt'	--N'금액'
		WHERE A.MEASURE = 'Cell_Qty'	--N'팩수량'
			AND B.MEASURE = 'Contract_Term'		--N'기본계약조건'
			AND A.MDF_VERSION_NO  = B.MDF_VERSION_NO
			AND A.DIVISION_ID     = B.DIVISION_ID
			AND A.DEPARTMENT_ID   = B.DEPARTMENT_ID
			AND A.DMS_CUSTOMER    = B.DMS_CUSTOMER
			AND A.DMS_SALES       = B.DMS_SALES
			AND A.APPLICATION     = B.APPLICATION
			AND A.BIZ_TYPE        = B.BIZ_TYPE
			AND A.ITEM_TYPE       = B.ITEM_TYPE
			AND A.YYYYMM          = B.YYYYMM
		GROUP BY 
			A.MDF_VERSION_NO
			, A.SPVERSION_NO
			, A.DIVISION_ID
			, A.DEPARTMENT_ID
			, A.DMS_CUSTOMER
			, A.DMS_SALES
			, A.APPLICATION
			, A.BIZ_TYPE
			, A.ITEM_TYPE
			, A.YYYYMM
    )
	,MIDDLE_SUMMARY3 as (
        select * from MIDDLE_SUMMARY30
		UNION ALL -- 바로 위 쿼리에서 A.MEASURE = N'Amt' AND B.MEASURE = N'Contract_Term' 조건이 안 맞을 수 있어 몽땅 넣어 줌.
		SELECT 
			MDF_VERSION_NO
			, DIVISION_ID
			, DEPARTMENT_ID
			, DMS_CUSTOMER
			, DMS_SALES
			, APPLICATION
			, BIZ_TYPE
			, ITEM_TYPE
			, MEASURE
			, UNIT_CURRENCY
			, YYYYMM
			, 0 AS QTY
			, SPVERSION_NO
		FROM (
			SELECT 
				MDF_VERSION_NO
				, DIVISION_ID
				, DEPARTMENT_ID
				, DMS_CUSTOMER
				, DMS_SALES
				, APPLICATION
				, BIZ_TYPE
				, ITEM_TYPE
				, 'MDF_Basic' MEASURE		--N'MDF(기본)'
				, N'천$' UNIT_CURRENCY
				, YYYYMM
				, SPVERSION_NO
			FROM #middle_sum
			GROUP BY
				MDF_VERSION_NO
				, SPVERSION_NO
				, DIVISION_ID
				, DEPARTMENT_ID
				, DMS_CUSTOMER
				, DMS_SALES
				, APPLICATION
				, BIZ_TYPE
				, ITEM_TYPE
				, YYYYMM
		) SUB
        where not exists (select 1 
                            from MIDDLE_SUMMARY30 m
                           where m.MDF_VERSION_NO = sub.MDF_VERSION_NO
                             and m.DIVISION_ID = sub.DIVISION_ID
                             and m.DEPARTMENT_ID = sub.DEPARTMENT_ID
                             and m.DMS_CUSTOMER = sub.DMS_CUSTOMER
                             and m.DMS_SALES = sub.DMS_SALES
                             and m.APPLICATION = sub.APPLICATION
                             and m.ITEM_TYPE = sub.ITEM_TYPE
                             and m.BIZ_TYPE = sub.BIZ_TYPE
                             and m.MEASURE = sub.MEASURE
                             and m.UNIT_CURRENCY = sub.UNIT_CURRENCY
                             and m.YYYYMM = sub.YYYYMM
                             and m.SPVERSION_NO = sub.SPVERSION_NO
                         )
	)
	
	SELECT * 
	INTO #temp
	FROM #middle_sum

	UNION ALL

	SELECT * FROM MIDDLE_SUMMARY2

	UNION ALL

	SELECT * FROM MIDDLE_SUMMARY3

	UNION ALL
	
	SELECT 
		A.MDF_VERSION_NO
		, A.DIVISION_ID
		, A.DEPARTMENT_ID
		, A.DMS_CUSTOMER
		, A.DMS_SALES
		, A.APPLICATION
		, A.BIZ_TYPE
		, A.ITEM_TYPE
		, N'Total' MEASURE		-- N'Total'
		, N'천$' UNIT_CURRENCY
		, A.YYYYMM
		, SUM(ISNULL(A.QTY,0) + ISNULL(B.QTY,0)) QTY
		, A.SPVERSION_NO
	FROM #middle_sum A
		,MIDDLE_SUMMARY3 B
	WHERE A.MEASURE = 'MDF_Add'		--N'MDF(추가)'
		AND B.MEASURE = 'MDF_Basic'		--N'MDF(기본)'
		AND A.MDF_VERSION_NO  = B.MDF_VERSION_NO
		AND A.DIVISION_ID     = B.DIVISION_ID
		AND A.DEPARTMENT_ID   = B.DEPARTMENT_ID
		AND A.DMS_CUSTOMER    = B.DMS_CUSTOMER
		AND A.DMS_SALES       = B.DMS_SALES
		AND A.APPLICATION     = B.APPLICATION
		AND A.BIZ_TYPE        = B.BIZ_TYPE
		AND A.ITEM_TYPE       = B.ITEM_TYPE
		AND A.YYYYMM          = B.YYYYMM
	GROUP BY
		A.MDF_VERSION_NO
		, A.SPVERSION_NO
		, A.DIVISION_ID
		, A.DEPARTMENT_ID
		, A.DMS_CUSTOMER
		, A.DMS_SALES
		, A.APPLICATION
		, A.BIZ_TYPE
		, A.ITEM_TYPE
		, A.YYYYMM;

	-- 단계2. 데이터 정리 ########################################################
	SELECT distinct
		MDF_VERSION_NO,
		DIVISION_ID,
		DEPARTMENT_ID,
		DMS_CUSTOMER	,
		DMS_SALES,
		APPLICATION,
		BIZ_TYPE,
		ITEM_TYPE,
		MEASURE,
		UNIT_CURRENCY,
		SPVERSION_NO,
		CASE MEASURE WHEN 'Cell_Qty' THEN 1
			WHEN 'Amt' THEN 2
			WHEN 'Contract_Term' THEN 3
			WHEN 'MDF_Basic' THEN 4 
			WHEN 'MDF_Add' THEN 5 
			ELSE 6 END AS ORDERNO,
		'M_' + YYYYMM AS YYYYMM,
		ISNULL(QTY, 0) AS QTY,
		CASE WHEN (MEASURE = 'Contract_Term' OR MEASURE = 'MDF_Add') 
			AND ((@v_group_id = 'ADMIN') OR (@v_team_id = DEPARTMENT_ID))
		THEN 'Y' ELSE 'N' 
		END AS EDIT_FLAG--,
		--CASE WHEN ((@v_group_id = 'ADMIN') OR (@v_team_id = DEPARTMENT_ID)) THEN 'Y' ELSE 'N' END AS EDIT_FLAG2		-- DMS_Sales 수정 용도
	INTO #temp2
	FROM #temp
	WHERE MDF_VERSION_NO = @p_mdf_version_no
		AND SPVERSION_NO = @p_sp_version_no



	--SELECT * from #temp2

	-- 단계3. PIVOT 기간 쿼리 ########################################################
	SELECT @PROD = @PROD + '[M_' + BASIS_YYYYMM + '],'
	FROM (
		SELECT 
		DISTINCT BASIS_YYYYMM
		FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) 
		WHERE BASIS_YYYYMMDD >= @P_START_DT
		AND BASIS_YYYYMMDD < @p_end_dt
		
	) A				
	ORDER BY BASIS_YYYYMM
	IF @PROD <> ''
	BEGIN
		SELECT @PROD = LEFT(@PROD, LEN(@PROD)-1)
	END

	--SELECT  @PROD

	-- 단계4. 실행 쿼리 ########################################################
	SELECT  @SQL = '
SELECT  
	MDF_VERSION_NO,
	DIVISION_ID,
	DEPARTMENT_ID,
	DMS_CUSTOMER	,
	DMS_SALES,
	APPLICATION,
	BIZ_TYPE,
	ITEM_TYPE,
	MEASURE,
	UNIT_CURRENCY,
	SPVERSION_NO,
	ORDERNO,	
	EDIT_FLAG,
	--EDIT_FLAG2,
	' + @PROD + '
From(
	SELECT 
		*
	FROM #temp2
	) T
PIVOT (SUM(QTY) FOR YYYYMM IN (' + @PROD + ')
) AS PVT
ORDER BY
	MDF_VERSION_NO,
	DIVISION_ID,
	DEPARTMENT_ID,
	DMS_CUSTOMER	,
	DMS_SALES,
	APPLICATION,
	BIZ_TYPE,
	ITEM_TYPE,
	--SPVERSION_NO,
	ORDERNO';

--SET @SQL = REPLACE(@SQL,'[@v_group_id]', @v_group_id);

--SELECT @SQL 
execute dbo. SP_executesql @SQL 

-- xml확인할경우
--SELECT CONVERT(TEXT, @v_sql_text)
--FOR XML PATH('')--,ROOT('x')

END
