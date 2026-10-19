
/*=====================================================================================================================================================
 * Program ID  : [DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA]
 * Description : Procedure 작성 가이드                                                              
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *=====================================================================================================================================================
 * Date        In Charge    Description                                                             
 *=====================================================================================================================================================
 * 2019/04/11	JYE			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/05/13	JYE			40사업부는 Incoterms, Fcst type, Dom exp 필수 제외
 * 2019/08/26	JYE			칼럼 수정
 * 2019/09/05	JYE			LEFT JOIN 으로 변경
 * 2019/10/02   KHSONG		조회시 DB Lock 현상으로 로직수정
 * 2019/10/18   KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4 
 * 2020/03/11   KHSONG		C20200103-000586 권한그룹을 LOOKUP
 * 2020/04/08	P.C.I		[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/07/10	hwi1993     소스정리
 * 2020/07/10	hwi1993		[C20200706-000011] BP 메저정리
 * 2020/09/04	hwi1993		[c20200722-000060] biz plan active YN
 * 2021/07/22	hwi1993		과제(중장기) pk 변경에 따른 컬럼추가
 * 2021/07/29	hwi1993		과제(중장기) owner 컬럼 길이 제한
 * 2022/03/02	rosia27		[C20220224-000160]DM_LONG_PLAN 기능 고도화 요청의 건
 * 2022/06/21	rosia27		[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2024/08/01	JSSBAE		[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청
 * 2024/08/26	JSSBAE		[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가
 * 2024/08/27	KJJ			[PJ2024-50461] Team Mapping
 * 2024/09/12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 *===================================================================================================================================================*/
 
CREATE PROCEDURE [dbo].[DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA]
	  @p_division_id			NVARCHAR(30)
	, @p_dept_id				NVARCHAR(4000)
	, @p_end_customer			NVARCHAR(4000)
	, @p_scm_site_id			NVARCHAR(4000)
	, @p_project_code			NVARCHAR(4000)
	, @p_item_id				NVARCHAR(4000)
	, @p_item_type				NVARCHAR(4000)
	, @p_from_yyyymmdd			NVARCHAR(8)
	, @p_now_yyyymmdd			NVARCHAR(8)
	, @p_to_yyyymmdd			NVARCHAR(8)
	, @p_created_by				NVARCHAR(50)
	, @p_plant_site_id			NVARCHAR(4000)
	, @p_biztype				NVARCHAR(4000)
	, @p_userinfo				NVARCHAR(50)
	, @p_owner					NVARCHAR(4000)
	, @p_qty_yn					NVARCHAR(1)
AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @Prod				VARCHAR(MAX);
	DECLARE @ColList			VARCHAR(MAX);
	DECLARE @GroupList			VARCHAR(MAX);
	DECLARE @nsql				NVARCHAR(MAX);
	DECLARE @nsql2				NVARCHAR(MAX);
	DECLARE @p_program_id		NVARCHAR(50)='DMF0042'
	DECLARE @MEASURE			INT = 0;
	DECLARE @i_count			INT = 0;
    DECLARE @v_dept_id			NVARCHAR(50) = '';
	DECLARE @v_group_id			NVARCHAR(50) = '';

	SET		@ColList	= '';
	SET		@GroupList	= '';
	SET		@Prod		= '';
	SET		@p_from_yyyymmdd	= SUBSTRING(@p_from_yyyymmdd, 1,6)
	SET		@p_to_yyyymmdd		= SUBSTRING(@p_to_yyyymmdd, 1,6)
	
	--============================================================================
	-- 사용자의 팀정보 & 권한
	--============================================================================
	SELECT @v_dept_id = ISNULL(( SELECT TOP 1 SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
								 WHERE LOOKUP_TYPE = 'PM_TEAM_MAPPING'
								 AND   VALID_YN = 'Y'
								 AND   SEGMENT1 = U.DEPT_ID ), U.DEPT_ID)
	FROM TB_FX_User U WITH(NOLOCK)
	WHERE U.UserID = @p_created_by

PRINT @p_program_id + ' : A001-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);  
	--============================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (START)
	--============================================================================
	IF ISNULL(( SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
				AND   VALID_YN = 'Y'
				AND   SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
				AND   SEGMENT1 = @p_userinfo), 0) > 0
	BEGIN
		SET @v_group_id = 'ADMIN'
	END
	--============================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	--============================================================================
PRINT @p_program_id + ' : A002-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);   
	--============================================================================
	-- TEMP TABLE DROP (START)
	--============================================================================
	IF OBJECT_ID (N'tempdb..#tmpPlanData', N'U') IS NOT NULL 
		DROP TABLE #tmpPlanData;

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V;

	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE;

	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA;

	IF OBJECT_ID (N'tempdb..#RAW_DATA_SUM', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA_SUM;

	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SSO_USER_INFO', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SSO_USER_INFO;

	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM;		
	--------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선  (START)
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V;

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V;

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V;	
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)
	--------------------------------------------------------------------------------------------------	
	--============================================================================
	-- TEMP TABLE DROP (END)
	--============================================================================
PRINT @p_program_id + ' : A003-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);   
	--============================================================================
    -- TEMP TABLE CREATE (START)
	--============================================================================
	CREATE TABLE #RAW_DATA 
	( DIVISION_ID						NVARCHAR(30)
	, PROJECT_CODE						NVARCHAR(50)
	, END_CUSTOMER40					NVARCHAR(50)
	, PLANT_SITE_ID						NVARCHAR(30)
	, ITEM_ID							NVARCHAR(100)
	, INCOTERMS							NVARCHAR(100)
	--, INCOTERMS82						NVARCHAR(100) -- [PJ20200138] Incoterms 삭제
	--, DOM_EXP							NVARCHAR(100)
	, FCST_TYPE							NVARCHAR(100)
	, MEASURE							NVARCHAR(100)
	, CELL_PROD_SITE					NVARCHAR(100) --[C20220513-000327]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
	, COLNAME							NVARCHAR(100)
	, SORT_ORDER_NO						NVARCHAR(100)
	, CALENDAR_YYYYQQ					NVARCHAR(100)
	, CALENDAR_YYYY						NVARCHAR(100)
	, YYYYMM							NVARCHAR(6)
	, QTY								NUMERIC(30,10)
	, CURRENCY							NVARCHAR(100)
	, FORECAST_INFO_CELL_PACK_COUNT     NVARCHAR(100)
	, BIZ_TYPE_NAME40					NVARCHAR(100)
	, CELL_TYPE							NVARCHAR(100)
	, ITEM_CLASS_NAME					NVARCHAR(100)
	, ITEM_NAME							NVARCHAR(100)
	, ITEM_TYPE							NVARCHAR(100)
	, NICK_NAME							NVARCHAR(100)
	, MIN_CAPACITY						NVARCHAR(100)
	, EDIT_FLAG							NVARCHAR(100)
	, APPLICATION						NVARCHAR(100)
	, CUST_GROUP						NVARCHAR(100)
	, FORECAST_INFO_CELL_MODEL			NVARCHAR(150)
	, OWNER								NVARCHAR(100)
	, DEPT_ID							NVARCHAR(100)
	, VMI_YN							NVARCHAR(100)
	, ROUTE								NVARCHAR(100)
	, FORECAST_INFO_PRODUCT_GROUP		NVARCHAR(100)
	, FORECAST_INFO_ALL					NVARCHAR(100)
	, FORECAST_INFO_SPEC				NVARCHAR(100)
	, FORECAST_INFOR_VERSION			NVARCHAR(100)
	, MDM_PROJECT_NAME					NVARCHAR(100)
	, CUST_GROUP_DTL					NVARCHAR(100)
	, DMS_SALES							NVARCHAR(100)
	, DMS_CUSTOMER						NVARCHAR(100)
	, PROJECT_NAME						NVARCHAR(100)
	, PROJECT_OWNER						NVARCHAR(100)
	, PROJECT_STATUS					NVARCHAR(100)
	, END_CUSTOMER						NVARCHAR(100)
	, CITY_NAME							NVARCHAR(100)
	, COUNTRY_NAME						NVARCHAR(100)
	--, INCOTERMS40						NVARCHAR(100) -- [PJ20200138] Incoterms 삭제
	, FCST_TYPE40						NVARCHAR(100)
	--, DOM_EXP40						NVARCHAR(100)
	, REPORT_GROUP1						NVARCHAR(100)
	, REPORT_GROUP2						NVARCHAR(100)
	, REPORT_GROUP3						NVARCHAR(100)
	, REPORT_GROUP4						NVARCHAR(100)
	, REPORT_GROUP5						NVARCHAR(100)
	, REPORT_GROUP6						NVARCHAR(100)
	, REPORT_GROUP7						NVARCHAR(100)
	, REPORT_GROUP8						NVARCHAR(100)
	, BIZ_TYPE_NAME81					NVARCHAR(100)
	, PROJECT_CODE82					NVARCHAR(100)
	, BIZ_TYPE_NAME82					NVARCHAR(100)
	, ITEM_ID40							NVARCHAR(100)
	, SCM_SITE_ID40						NVARCHAR(100)
	, SCM_SITE_ID81						NVARCHAR(100)
	, SCM_SITE_ID82						NVARCHAR(100)
	--, CELL_PER_PACK					NVARCHAR(100)
	--, CELL_PER_MODULE					NVARCHAR(100)
	--, MODULE_PER_PACK					NVARCHAR(100)
	, DEPT_ID40							NVARCHAR(100)
	, PRODUCT_GROUP_NAME				NVARCHAR(100)
	, ITEM_USE							NVARCHAR(100) -- [PJ20200138] item_use, unit_energy 추가
	, UNIT_ENERGY						NVARCHAR(100)
	, CELL_PER_CAR						NVARCHAR(100)
	, MODULE_PER_CAR 					NVARCHAR(100)
	, ENERGE_WH							NVARCHAR(100) --[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
	, ENERGE_KWH 						NVARCHAR(100) --[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
    );	
	--============================================================================
    -- TEMP TABLE CREATE (END)
	--============================================================================
	--============================================================================
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (START)
	--============================================================================
    -- 20191002 KHSONG 주석처리 (BEGIN)
	/*
	  -- 기존로직
	SELECT *
	 INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM DM_MST_ITEM_SINGLE_V WITH(NOLOCK)
	  WHERE DIVISION_ID = @p_division_id
		--and CASE WHEN @p_item_id = ''			THEN @p_item_id			ELSE ITEM_ID			END  in  (SELECT DISTINCT token FROM dbo.String_Split(@p_item_id,','		))
	*/
    -- 20191002 KHSONG 주석처리 (END)
	
	--------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (START)
	--원소스 주석처리
	/*
	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)
	-----------------------------------------------------------------------------------------	

	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE		
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START 
		,ENERGE AS ENERGE_WH
		,CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 7))) ELSE NULL END AS ENERGE_KWH
		--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END 
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	 FROM 
			(SELECT *
			FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							ON	T2.ITEM_ID		like  b.tst 
							OR	T2.NICK_NAME	like  b.tst 						
			  WHERE DIVISION_ID = @p_division_id
			) G
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME
		,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE	
		,ENERGE --[E20240731-000852]_ENERGE 컬럼 추가
	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-----------------------------------------------------------------------------------------
	*/
	
	--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	SELECT *
	INTO #TEMP_DM_MST_ITEM_SINGLE_ORI_V
	FROM SCM_MST_ITEM_SN WITH(NOLOCK)		
	WHERE DIVISION_ID = @p_division_id		

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1	
						  WHEN T1.ITEM_TYPE = 'H' THEN 2	
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )  
									WHEN 1 THEN 'P' 
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 , MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC		
	INTO #TEMP_DM_MST_ITEM_SINGLE_A_V
	FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T1 WITH(NOLOCK)				
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	SELECT DIVISION_ID
		 , LEFT(ITEM_ID, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	INTO #TEMP_DM_MST_ITEM_SINGLE_B_V
	FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T2 WITH(NOLOCK) 
	GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)

	--TEMP 테이블에 넣은 데이터를 JOIN 한다.
	SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		 , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC 
		 --------------------------------------------------------------------------------------------------
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 START 
		 , ENERGE AS ENERGE_WH
		 , CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 7))) ELSE NULL END AS ENERGE_KWH
		 --[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 END 
		 --------------------------------------------------------------------------------------------------
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM 
	( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE			
		   , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE
		   , T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC
		   , T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
		FROM #TEMP_DM_MST_ITEM_SINGLE_A_V T1 WITH(NOLOCK)					
		INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_B_V T2 WITH(NOLOCK) 
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID					
		INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
				ON	T1.ITEM_ID		like  b.tst 
				OR	T1.NICK_NAME	like  b.tst 		
		WHERE 1=1
	) T2								
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC 

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)
	--------------------------------------------------------------------------------------------------
	
	CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON #TEMP_DM_MST_ITEM_SINGLE_V
	( DIVISION_ID  ASC
	, ITEM_ID      ASC ) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	;
PRINT @p_program_id + ' : A004-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);   

	--============================================================================
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	--============================================================================	
	--============================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	--============================================================================	
	SELECT *
	INTO #TEMP_SCM_MST_SSO_USER_INFO
	FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK)
	ORDER BY USER_ID 

	-- 2020.4.23 속도문제로 쿼리 변경
	SELECT *
		, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		,( SELECT SU.DEPT_ID  FROM #TEMP_SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) WHERE SU.USER_ID 
			= (SELECT top 1 token FROM [dbo].[String_Split](SMSI.owner, ',')) ) DEPT_ID
		,SMSI.SALES_PLAN_ADJUST_YN AS EDIT_FLAG
	INTO #TEMP_SCM_MST_SITE_ITEM
	FROM SCM_MST_SITE_ITEM SMSI WITH(NOLOCK)
	WHERE SMSI.DIVISION_ID = @p_division_id
	
	--============================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	--============================================================================
	
	/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
	   과거 구간은 전체 Data가 포함되어야 함.
	   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
	   단위 환산이 되어야 함.
	*/

	SELECT U.PROGRAM_ID, U.SHEET_NAME--, U.USER_ID
		 , U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO
	INTO #SELECT_MEASURE
	FROM SCM_MST_SHEET_MEASURE U WITH(NOLOCK)
	WHERE 1 = 1
	--AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND U.PROGRAM_ID = @p_program_id
	AND U.DIVISION_ID LIKE '%' + @p_division_id + '%'
	--AND U.USER_ID      = @p_created_by
PRINT @p_program_id + ' : A005-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);   
	
	--============================================================================
	-- (1) DM_PLN_BP_FCST
	--============================================================================
	IF @p_division_id = '40'
	BEGIN
		INSERT INTO #RAW_DATA
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER40--,A.SCM_SITE_ID
			 , PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS  -- [PJ20200138] Incoterms 삭제
			 --,A.INCOTERMS AS INCOTERMS82 -- [PJ20200138] Incoterms 삭제
			 --,A.DOM_EXP
			 , A.FCST_TYPE, A.MEASURE
			 --[E20240731-000845]_조회당시 코드값으로 넘기도록 수정(원소스 주석처리)
			 --,LK1.ATTRIBUTE1 AS CELL_PROD_SITE
			 , LK1.SEGMENT1 AS CELL_PROD_SITE, 'M_' + YYYYMM AS COLNAME, SM.SORT_ORDER_NO
			 , CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ, CAL.CALENDAR_YYYY AS CALENDAR_YYYY
			 , A.YYYYMM, A.QTY
			 , CASE WHEN A.CURRENCY = '' THEN SI.CURRENCY ELSE ISNULL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY 
			 , ISV.FORECAST_INFO_CELL_PACK_COUNT
			 , ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40 
			 --,A.BIZ_TYPE AS BIZ_TYPE_NAME40
			 , ( SELECT LMD.SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH(NOLOCK) 
				 WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
			 , ISNULL(ISV.ITEM_CLASS_NAME, '') AS ITEM_CLASS_NAME, ISNULL(ISV.ITEM_NAME, '') AS ITEM_NAME
			 , ISNULL(ISV.ITEM_TYPE, '') AS ITEM_TYPE, ISNULL(ISV.NICK_NAME, '') AS NICK_NAME
			 , ISV.MIN_CAPACITY
			 --,CASE WHEN ISV.ITEM_ID IS NULL THEN 'N' WHEN isnull(SI.EDIT_FLAG,'')  = 'N' THEN 'N' ELSE 'Y' END + '_'   + 
			 , CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = @v_dept_id THEN 'Y'
					WHEN @v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG				
			 , SI.APPLICATION, SI.CUST_GROUP, SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL, SI.OWNER_NAME OWNER
			 --,CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE S.DEPT_ID END AS DEPT_ID
			 --[PJ2024-50461] Team Mapping------------------------------------
			 --,A.DEPT_ID  AS DEPT_ID
			 , SI.DEPT_ID  AS DEPT_ID
			 --[PJ2024-50461] Team Mapping------------------------------------
			 , S.VMI_YN, SI.ROUTE, ISV.FORECAST_INFO_PRODUCT_GROUP, ISV.FORECAST_INFO_SPEC + ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
			 , ISV.FORECAST_INFO_SPEC, ISV.FORECAST_INFOR_VERSION, ISV.MDM_PROJECT_NAME, SI.CUST_GROUP_DTL
			 , ISNULL(SI.ATTRIBUTE1, '') AS DMS_SALES, ISNULL(SI.ATTRIBUTE2, '') AS DMS_CUSTOMER
			 --,MP.BIZ_TYPE as BIZ_TYPE_NAME
			 , A.PROJECT_NAME, '' AS PROJECT_OWNER, '' AS PROJECT_STATUS, A.END_CUSTOMER, S.CITY_NAME, S.COUNTRY_NAME
			 --,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- [PJ20200138] Incoterms 삭제
			 , A.FCST_TYPE AS FCST_TYPE40		-- 20190513
			 --,A.DOM_EXP AS DOM_EXP40			-- 20190513
			 , SI.REPORT_GROUP1, SI.REPORT_GROUP2, SI.REPORT_GROUP3, SI.REPORT_GROUP4, SI.REPORT_GROUP5, SI.REPORT_GROUP6
			 , SI.REPORT_GROUP7, SI.REPORT_GROUP8
			 -- 201990826
			 , A.BIZ_TYPE AS BIZ_TYPE_NAME81, A.PROJECT_CODE AS PROJECT_CODE82, A.BIZ_TYPE AS BIZ_TYPE_NAME82
			 , A.ITEM_ID AS ITEM_ID40, A.SCM_SITE_ID AS SCM_SITE_ID40, A.SCM_SITE_ID AS SCM_SITE_ID81
			 , A.SCM_SITE_ID AS SCM_SITE_ID82 --,A.CELL_PER_PACK--,A.CELL_PER_MODULE--,A.MODULE_PER_PACK
			 , SI.DEPT_ID AS DEPT_ID40
			 -- 201990826
			 , '' AS PRODUCT_GROUP_NAME, A.ITEM_USE  -- [PJ20200138] item_use, unit_energy 추가
			 , A.UNIT_ENERGY, 0 AS CELL_PER_CAR, 0 AS MODULE_PER_CAR, ISV.ENERGE_WH	--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
			 , ISV.ENERGE_KWH --[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
		FROM DM_PLN_BP_FCST A WITH(NOLOCK)
		INNER JOIN SCM_MST_SITE S1 WITH(NOLOCK)
				ON A.DIVISION_ID = S1.DIVISION_ID AND A.SCM_SITE_ID = S1.SCM_SITE_ID
			 --AND S1.VALID_YN	  = 'Y'	-- [c20200722-000060]
		INNER JOIN SCM_MST_SITE_ITEM S2 WITH(NOLOCK)
				ON A.DIVISION_ID = S2.DIVISION_ID AND A.PROJECT_CODE = S2.PROJECT_CODE
				AND A.SCM_SITE_ID = S2.SCM_SITE_ID AND A.ITEM_ID = S2.ITEM_ID
			  --AND S2.VALID_YN			= 'Y'	--[c20200722-000060]
		INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_V ISV WITH(NOLOCK)
				ON A.DIVISION_ID = ISV.DIVISION_ID AND A.ITEM_ID = ISV.ITEM_ID
		LEFT JOIN #TEMP_SCM_MST_SITE_ITEM SI WITH(NOLOCK)
			   ON A.DIVISION_ID	= SI.DIVISION_ID AND A.SCM_SITE_ID = SI.SCM_SITE_ID	
			  AND A.PROJECT_CODE = SI.PROJECT_CODE AND A.ITEM_ID = SI.ITEM_ID
			--AND SI.VALID_YN			= 'Y'	--[c20200722-000060]
		LEFT JOIN (	SELECT X.DIVISION_ID, X.SOLDTO_CUSTOMER, X.END_CUSTOMER, X.DEPT_ID, X.SCM_SITE_ID, X.VMI_YN, X.VALID_YN, Y.CITY_NAME, Z.COUNTRY_NAME 
					FROM SCM_MST_SITE X WITH(NOLOCK), SCM_MST_CITY Y WITH(NOLOCK), SCM_MST_COUNTRY Z WITH(NOLOCK)
					WHERE X.CITY = Y.CITY AND X.COUNTRY = Z.COUNTRY	) S 
			   ON A.DIVISION_ID	= S.DIVISION_ID
			  AND A.SCM_SITE_ID	= S.SCM_SITE_ID
			--AND S.VALID_YN			= 'Y'	--[c20200722-000060]
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WITH(NOLOCK) ON A.CELL_PROD_SITE = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'
		-------------------------- Project 조건 ------------------------------------------------------
		INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) b1
		ON      CASE WHEN @p_project_code = '' THEN @p_project_code			
	    			ELSE A.PROJECT_CODE  END like  b1.tst 
			OR   CASE WHEN @p_project_code = '' THEN @p_project_code			
					ELSE A.PROJECT_NAME  END like  b1.tst 
		-----------------------------------------------------------------------------------------------
		-------------------------- Model 조건 ---------------------------------------------------------
		INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b2
		ON      CASE WHEN @p_item_id = '' THEN @p_item_id			
					ELSE A.ITEM_ID  END like  b2.tst 
			OR   CASE WHEN @p_item_id = '' THEN @p_item_id			
					ELSE ISV.NICK_NAME  END like  b2.tst 
		-----------------------------------------------------------------------------------------------
		-------------------------- Owner 조건 ---------------------------------------------------------
		INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) b3
		ON      CASE WHEN @p_owner = '' THEN @p_owner			
					ELSE SI.OWNER         END like  b3.tst 
			OR   CASE WHEN @p_owner = '' THEN @p_owner			
					ELSE SI.OWNER_NAME    END like  b3.tst 
			OR   CASE WHEN @p_owner = '' THEN @p_owner			
					ELSE SI.OWNER_NAME_KO END like  b3.tst 
		-----------------------------------------------------------------------------------------------
		INNER JOIN #SELECT_MEASURE SM WITH(NOLOCK)
				ON SM.MEASURE = A.MEASURE
		INNER JOIN ( SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM 
					 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
					 WHERE ( BASIS_YYYYMM >= @p_from_yyyymmdd AND BASIS_YYYYMM <= @p_to_yyyymmdd )
					 GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) AS CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
		WHERE 1=1
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
					ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
			END IN ( SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_dept_id,',') AS P WHERE 
							(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE 
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.data
							)
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   			ELSE isnull(
					CASE WHEN @p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
					,'')
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(
						CASE WHEN @p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
					,'') END) = P.data
					)						   
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.data
					)
		AND CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.PLANT_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_plant_site_id,',') as P Where 
					(CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.data
					)
		AND CASE WHEN @p_item_type = 'ALL' THEN 'ALL'
		   			ELSE ISV.ITEM_TYPE			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_item_type,',') as P Where 
					(CASE WHEN @p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.data
					)
		AND CASE WHEN @p_biztype = 'ALL' THEN 'ALL'
		   			ELSE
					CASE WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_biztype,',') as P Where 
					(CASE WHEN @p_biztype = 'ALL' THEN 'ALL' ELSE 
					CASE WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END) = P.data
					)
		AND (A.YYYYMM >= @p_from_yyyymmdd AND A.YYYYMM <= @p_to_yyyymmdd)
		AND A.DIVISION_ID = @p_division_id
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'
                ;
				
PRINT @p_program_id + ' : A006-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);  
	END
    ELSE
	BEGIN

            INSERT INTO #RAW_DATA
			     ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER40, PLANT_SITE_ID, ITEM_ID
				 , INCOTERMS, FCST_TYPE, MEASURE, CELL_PROD_SITE, COLNAME
				 , SORT_ORDER_NO, CALENDAR_YYYYQQ, CALENDAR_YYYY, YYYYMM, QTY
				 , CURRENCY, FORECAST_INFO_CELL_PACK_COUNT, BIZ_TYPE_NAME40, CELL_TYPE, ITEM_CLASS_NAME
				 , ITEM_NAME, ITEM_TYPE, NICK_NAME, MIN_CAPACITY, EDIT_FLAG

				 , APPLICATION, CUST_GROUP
				 , FORECAST_INFO_CELL_MODEL
				 , OWNER
				 , DEPT_ID
				 , VMI_YN, ROUTE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
				 , FORECAST_INFOR_VERSION, MDM_PROJECT_NAME, CUST_GROUP_DTL, DMS_SALES, DMS_CUSTOMER

				 , PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS, END_CUSTOMER, CITY_NAME
				 , COUNTRY_NAME, FCST_TYPE40, REPORT_GROUP1, REPORT_GROUP2
				 
				 , REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6, REPORT_GROUP7
				 , REPORT_GROUP8, BIZ_TYPE_NAME81, PROJECT_CODE82, BIZ_TYPE_NAME82, ITEM_ID40
				 , SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PRODUCT_GROUP_NAME
				 , ITEM_USE, UNIT_ENERGY, CELL_PER_CAR, MODULE_PER_CAR
				 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
				 , ENERGE_WH, ENERGE_KWH
				 )
   			SELECT  
				A.DIVISION_ID
				,A.PROJECT_CODE
				,A.PROJECT_CODE AS END_CUSTOMER40
				--,A.SCM_SITE_ID
				,PLANT_SITE_ID
				,A.ITEM_ID
				,A.INCOTERMS -- [PJ20200138] Incoterms 삭제
				--,A.INCOTERMS AS INCOTERMS82 -- [PJ20200138] Incoterms 삭제
				--,A.DOM_EXP
				,A.FCST_TYPE
				,A.MEASURE
				,A.CELL_PROD_SITE
				,'M_' + YYYYMM AS COLNAME
				,SM.SORT_ORDER_NO
				,CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
				,CAL.CALENDAR_YYYY AS CALENDAR_YYYY
				,A.YYYYMM ,A.QTY
				,CASE WHEN A.CURRENCY = '' THEN SI.CURRENCY ELSE ISNULL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY 
				,ISV.FORECAST_INFO_CELL_PACK_COUNT
				,ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40 
				--,A.BIZ_TYPE AS BIZ_TYPE_NAME40
				,(SELECT LMD.SEGMENT2  AS NAME FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] LMD WITH(NOLOCK) WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
				,isnull(ISV.ITEM_CLASS_NAME,'')AS ITEM_CLASS_NAME
				,isnull(ISV.ITEM_NAME,'')AS ITEM_NAME
				,isnull(ISV.ITEM_TYPE,'')AS ITEM_TYPE
				,isnull(ISV.NICK_NAME,'')AS NICK_NAME
				,ISV.MIN_CAPACITY
				--,CASE WHEN ISV.ITEM_ID IS NULL THEN 'N' WHEN isnull(SI.EDIT_FLAG,'')  = 'N' THEN 'N' ELSE 'Y' END + '_'   + 

				--[PJ2024-50461] Team Mapping------------------------------------
				/*,CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = @v_dept_id THEN 'Y'
						WHEN @v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG*/		
				,CASE WHEN SI.DEPT_ID = @v_dept_id THEN 'Y'
										WHEN @v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG
				--[PJ2024-50461] Team Mapping------------------------------------						
				,SI.APPLICATION
				,SI.CUST_GROUP
				,SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL
				,LEFT(SI.OWNER_NAME, 100) AS OWNER
				--------,CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE S.DEPT_ID END AS DEPT_ID

				--[PJ2024-50461] Team Mapping------------------------------------
				--,A.DEPT_ID  AS DEPT_ID
				,SI.DEPT_ID AS DEPT_ID
				--[PJ2024-50461] Team Mapping------------------------------------

				,S.VMI_YN 
				,SI.ROUTE
				,ISV.FORECAST_INFO_PRODUCT_GROUP
				,ISV.FORECAST_INFO_SPEC+ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
				,ISV.FORECAST_INFO_SPEC
				,ISV.FORECAST_INFOR_VERSION
				,ISV.MDM_PROJECT_NAME 
				,SI.CUST_GROUP_DTL
				,ISNULL(SI.attribute1,'') DMS_SALES
				,ISNULL(SI.attribute2,'') DMS_CUSTOMER
							----,MP.BIZ_TYPE as BIZ_TYPE_NAME
				,CASE WHEN MP.PROJECT_NAME = '' OR MP.PROJECT_NAME IS NULL THEN A.PROJECT_NAME ELSE MP.PROJECT_NAME END PROJECT_NAME
				,MP.PROJECT_OWNER
				,MP.PROJECT_STATUS
				,A.END_CUSTOMER
				,S.CITY_NAME
				,S.COUNTRY_NAME
				--,A.INCOTERMS AS INCOTERMS40		-- 20190513 -- [PJ20200138] Incoterms 삭제
				,A.FCST_TYPE AS FCST_TYPE40		-- 20190513
				--,A.DOM_EXP AS DOM_EXP40			-- 20190513
				,SI.REPORT_GROUP1
				,SI.REPORT_GROUP2
				,SI.REPORT_GROUP3
				,SI.REPORT_GROUP4
				,SI.REPORT_GROUP5
				,SI.REPORT_GROUP6
				,SI.REPORT_GROUP7
				,SI.REPORT_GROUP8
				-- 201990826
				,A.BIZ_TYPE as BIZ_TYPE_NAME81
				,A.PROJECT_CODE AS PROJECT_CODE82
				,A.BIZ_TYPE AS BIZ_TYPE_NAME82
				,A.ITEM_ID AS ITEM_ID40
				,A.SCM_SITE_ID AS SCM_SITE_ID40
				,A.SCM_SITE_ID AS SCM_SITE_ID81
				,A.SCM_SITE_ID AS SCM_SITE_ID82
				--,A.CELL_PER_PACK
				--,A.CELL_PER_MODULE
				--,A.MODULE_PER_PACK
				,SI.DEPT_ID AS DEPT_ID40
				-- 201990826
				,MP.PRODUCT_GROUP_NAME
				,A.ITEM_USE  -- [PJ20200138] item_use, unit_energy 추가
				,A.UNIT_ENERGY
				,ISNULL(S2.CELL_PER_CAR, 0) AS CELL_PER_CAR
				,ISNULL(S2.CELL_PER_CAR / S2.CELL_PER_MODULE, 0) AS MODULE_PER_CAR
				,ISV.ENERGE_WH			--[E20240731-000852]_WH 단위 ENERGE 컬럼 추가
				,ISV.ENERGE_KWH			--[E20240731-000852]_KWH 단위 ENERGE 컬럼 추가
			FROM [DM_PLN_BP_FCST] AS A WITH(NOLOCK)
				LEFT JOIN SCM_MST_SITE S1 WITH(NOLOCK)
					ON (A.DIVISION_ID		= S1.DIVISION_ID
					AND A.SCM_SITE_ID		= S1.SCM_SITE_ID
					--AND S1.VALID_YN	  = 'Y'	--[c20200722-000060]
					)
				LEFT JOIN SCM_MST_SITE_ITEM S2 WITH(NOLOCK)
					ON (A.DIVISION_ID		= S2.DIVISION_ID
					AND A.PROJECT_CODE		= S2.PROJECT_CODE
					AND A.SCM_SITE_ID		= S2.SCM_SITE_ID
					AND A.ITEM_ID			= S2.ITEM_ID
					--AND S2.VALID_YN			= 'Y' --[c20200722-000060]
					)
				LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V ISV WITH(NOLOCK)
					ON A.DIVISION_ID		= ISV.DIVISION_ID
					AND A.ITEM_ID			= ISV.ITEM_ID
				LEFT JOIN #TEMP_SCM_MST_SITE_ITEM SI WITH(NOLOCK)
					 ON A.DIVISION_ID		= SI.DIVISION_ID
					AND A.SCM_SITE_ID		= SI.SCM_SITE_ID
					AND A.PROJECT_CODE		= SI.PROJECT_CODE
					AND A.iTEM_ID			= SI.ITEM_ID
					--AND SI.VALID_YN			= 'Y'	-- [c20200722-000060]
				LEFT JOIN SCM_MST_PROJECT MP WITH(NOLOCK)
					ON A.DIVISION_ID		= MP.DIVISION_ID
					AND A.PROJECT_CODE		= MP.PROJECT_CODE
				LEFT JOIN (
							SELECT X.DIVISION_ID,X.SOLDTO_CUSTOMER, X.END_CUSTOMER, X.DEPT_ID, X.SCM_SITE_ID, X.VMI_YN, X.VALID_YN, Y.CITY_NAME, Z.COUNTRY_NAME 
							FROM SCM_MST_SITE X WITH(NOLOCK), SCM_MST_CITY Y WITH(NOLOCK), SCM_MST_COUNTRY z WITH(NOLOCK)
							WHERE x.city = y.city  and x.country = z.country
						) S 
					ON A.DIVISION_ID		= S.DIVISION_ID
					AND A.SCM_SITE_ID		= S.SCM_SITE_ID
					--AND S.VALID_YN			= 'Y'	-- [c20200722-000060]
				-------------------------- Project 조건 ------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) b1
				ON      CASE WHEN @p_project_code = '' THEN @p_project_code			
	    					ELSE A.PROJECT_CODE  END like  b1.tst 
					OR   CASE WHEN @p_project_code = '' THEN @p_project_code			
							ELSE A.PROJECT_NAME  END like  b1.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Model 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b2
				ON      CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE A.ITEM_ID  END like  b2.tst 
					OR   CASE WHEN @p_item_id = '' THEN @p_item_id			
							ELSE ISV.NICK_NAME  END like  b2.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Owner 조건 ---------------------------------------------------------
				INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) b3
				ON      CASE WHEN @p_owner = '' THEN @p_owner			
							ELSE SI.OWNER         END like  b3.tst 
					OR   CASE WHEN @p_owner = '' THEN @p_owner			
							ELSE SI.OWNER_NAME    END like  b3.tst 
					OR   CASE WHEN @p_owner = '' THEN @p_owner			
							ELSE SI.OWNER_NAME_KO END like  b3.tst 
				-----------------------------------------------------------------------------------------------
				INNER JOIN #SELECT_MEASURE AS SM WITH(NOLOCK)
				ON SM.MEASURE = A.MEASURE
				INNER JOIN (SELECT CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM 
					FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
					WHERE (BASIS_YYYYMM >= @p_from_yyyymmdd AND BASIS_YYYYMM <= @p_to_yyyymmdd)
					GROUP BY CALENDAR_YYYY, CALENDAR_YYYYQQ, BASIS_YYYYMM) AS CAL
				ON CAL.BASIS_YYYYMM = A.YYYYMM
			WHERE 1=1
			--[PJ2024-50461] Team Mapping------------------------------------
				AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
							ELSE SI.DEPT_ID
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
							(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE 
								SI.DEPT_ID
							END) = P.data
							)
/*
				AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
							ELSE CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
							(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE 
								CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END
							END) = P.data
							)
*/
				--[PJ2024-50461] Team Mapping------------------------------------

				AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   					ELSE isnull(
							CASE WHEN @p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							,'')
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
							(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(
								CASE WHEN @p_division_id = '40' THEN A.PROJECT_CODE ELSE A.END_CUSTOMER END
							,'') END) = P.data
							)						   
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   					ELSE A.SCM_SITE_ID			
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
							(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.data
							)
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL'
		   					ELSE A.PLANT_SITE_ID			
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_plant_site_id,',') as P Where 
							(CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.data
							)
				AND CASE WHEN @p_item_type = 'ALL' THEN 'ALL'
		   					ELSE ISV.ITEM_TYPE			
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_item_type,',') as P Where 
							(CASE WHEN @p_item_type = 'ALL' THEN 'ALL' ELSE ISV.ITEM_TYPE END) = P.data
							)
				AND CASE WHEN @p_biztype = 'ALL' THEN 'ALL'
		   					ELSE
							CASE WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
					END IN (
							Select * from dbo.UF_FX_String_SplitForIN (@p_biztype,',') as P Where 
							(CASE WHEN @p_biztype = 'ALL' THEN 'ALL' ELSE 
							CASE WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE ELSE A.BIZ_TYPE END
							END) = P.data
							)
				AND (A.YYYYMM >= @p_from_yyyymmdd and A.YYYYMM <= @p_to_yyyymmdd)
				AND A.DIVISION_ID = @p_division_id
                AND ( ( @p_item_id IS NULL OR  @p_item_id     ='' ) OR A.ITEM_ID   IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) ) 
				--AND A.MEASURE IN ('Business_Plan','KRW','USD','LOC','SalesAmt_KRW','SalesAmt_USD','SalesAmt_LOC')
				--and A.currency = 'KRW'
         ;

        END

	IF @p_qty_yn = 'Y'
	BEGIN
		IF OBJECT_ID (N'tempdb..#DLT_ITEM_ID', N'U') IS NOT NULL 
			DROP TABLE #DLT_ITEM_ID

		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.FCST_TYPE, A.PLANT_SITE_ID, A.DEPT_ID, A.END_CUSTOMER
			 , A.MEASURE, A.ITEM_ID40, A.SCM_SITE_ID40, A.SCM_SITE_ID81, A.SCM_SITE_ID82, A.DEPT_ID40, A.PROJECT_CODE82, A.END_CUSTOMER40, A.FCST_TYPE40
			 , A.INCOTERMS, A.CURRENCY, A.CELL_PROD_SITE
			 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
			 , A.ENERGE_WH, A.ENERGE_KWH
		INTO #DLT_ITEM_ID 
		FROM #RAW_DATA A WITH(NOLOCK)
		INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
						  , ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
						  , INCOTERMS, CURRENCY, CELL_PROD_SITE		
					 FROM #RAW_DATA WITH(NOLOCK)
					 WHERE MEASURE = 'Business_Plan'
					 GROUP BY DIVISION_ID, PROJECT_CODE, ITEM_ID, FCST_TYPE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER
					 	    , ITEM_ID40, SCM_SITE_ID40, SCM_SITE_ID81, SCM_SITE_ID82, DEPT_ID40, PROJECT_CODE82, END_CUSTOMER40, FCST_TYPE40
					 	    , INCOTERMS, CURRENCY, CELL_PROD_SITE
					 HAVING SUM(QTY) = 0) B
				 ON A.DIVISION_ID		= B.DIVISION_ID
				AND A.PROJECT_CODE		= B.PROJECT_CODE
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.FCST_TYPE			= B.FCST_TYPE
				AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
				AND A.DEPT_ID			= B.DEPT_ID
				AND A.ITEM_ID40			= B.ITEM_ID40
				AND A.SCM_SITE_ID40		= B.SCM_SITE_ID40
				AND A.SCM_SITE_ID81		= B.SCM_SITE_ID81
				AND A.SCM_SITE_ID82		= B.SCM_SITE_ID82
				AND A.DEPT_ID40			= B.DEPT_ID40
				AND A.PROJECT_CODE82	= B.PROJECT_CODE82
				AND A.END_CUSTOMER40	= B.END_CUSTOMER40
				AND A.FCST_TYPE40		= B.FCST_TYPE40
				AND A.INCOTERMS			= B.INCOTERMS
				AND A.CURRENCY			= B.CURRENCY
				AND A.CELL_PROD_SITE	= B.CELL_PROD_SITE

		DELETE A FROM #RAW_DATA A
		INNER JOIN #DLT_ITEM_ID B WITH(NOLOCK)
				ON A.DIVISION_ID		= B.DIVISION_ID
			   AND A.PROJECT_CODE		= B.PROJECT_CODE
			   AND A.ITEM_ID			= B.ITEM_ID
			   AND A.FCST_TYPE			= B.FCST_TYPE
			   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			   AND A.DEPT_ID			= B.DEPT_ID
			   AND A.END_CUSTOMER		= B.END_CUSTOMER
			   AND A.ITEM_ID40			= B.ITEM_ID40
			   AND A.SCM_SITE_ID40		= B.SCM_SITE_ID40
			   AND A.SCM_SITE_ID81		= B.SCM_SITE_ID81
			   AND A.SCM_SITE_ID82		= B.SCM_SITE_ID82
			   AND A.DEPT_ID40			= B.DEPT_ID40
			   AND A.PROJECT_CODE82		= B.PROJECT_CODE82
			   AND A.END_CUSTOMER40		= B.END_CUSTOMER40
			   AND A.FCST_TYPE40		= B.FCST_TYPE40
			   AND A.INCOTERMS			= B.INCOTERMS
			   AND A.CURRENCY			= B.CURRENCY
			   AND A.CELL_PROD_SITE		= B.CELL_PROD_SITE
	END
	
PRINT @p_program_id + ' : A007-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);  
		
	SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER40--,X.SCM_SITE_ID
		 , X.PLANT_SITE_ID, X.ITEM_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--,X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--,X.DOM_EXP
		 , X.FCST_TYPE, X.MEASURE, X.CELL_PROD_SITE, 'Q_' + REPLACE(CALENDAR_YYYYQQ, 'Q', '_') AS COLNAME
		 , X.SORT_ORDER_NO, X.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ, X.CALENDAR_YYYY,  X.CALENDAR_YYYYQQ AS YYYYMM
		 --,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan' 
		 , CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
				THEN SUM(QTY) ELSE MAX(QTY) END QTY
		 , X.CURRENCY
		 , MAX(X.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT, MAX(X.BIZ_TYPE_NAME40) AS BIZ_TYPE_NAME40
		 , MAX(X.CELL_TYPE) AS CELL_TYPE, MAX(X.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(X.ITEM_NAME) AS ITEM_NAME
		 , MAX(X.ITEM_TYPE) AS ITEM_TYPE, MAX(X.NICK_NAME) AS NICK_NAME, MAX(X.MIN_CAPACITY) AS MIN_CAPACITY
		 , MAX(X.EDIT_FLAG) AS EDIT_FLAG, MAX(X.APPLICATION) AS APPLICATION, MAX(X.CUST_GROUP) AS CUST_GROUP
		 , MAX(X.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(X.OWNER) AS OWNER, X.DEPT_ID AS DEPT_ID
		 , MAX(X.VMI_YN) AS VMI_YN, MAX(X.ROUTE) AS ROUTE, MAX(X.FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(X.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL, MAX(X.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(X.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION, MAX(X.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
		 , MAX(X.CUST_GROUP_DTL) AS CUST_GROUP_DTL, MAX(X.DMS_SALES) AS DMS_SALES, MAX(X.DMS_CUSTOMER) AS DMS_CUSTOMER--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		 , MAX(X.PROJECT_NAME) AS PROJECT_NAME, MAX(X.PROJECT_OWNER) AS PROJECT_OWNER, MAX(X.PROJECT_STATUS) AS PROJECT_STATUS
		 , MAX(X.END_CUSTOMER) AS END_CUSTOMER, MAX(X.CITY_NAME) AS CITY_NAME, MAX(X.COUNTRY_NAME) AS COUNTRY_NAME
		 --, MAX(X.INCOTERMS40) AS INCOTERMS40 		-- 20190513 -- [PJ20200138] Incoterms 삭제
		 , MAX(X.FCST_TYPE40) AS FCST_TYPE40		-- 20190513
		 --, MAX(X.DOM_EXP40) AS DOM_EXP40 			-- 20190513
		 , MAX(X.REPORT_GROUP1) AS REPORT_GROUP1, MAX(X.REPORT_GROUP2) AS REPORT_GROUP2, MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		 , MAX(X.REPORT_GROUP4) AS REPORT_GROUP4, MAX(X.REPORT_GROUP5) AS REPORT_GROUP5, MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		 , MAX(X.REPORT_GROUP7) AS REPORT_GROUP7, MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		 -- 201990826
		 , MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81, MAX(X.PROJECT_CODE82) AS PROJECT_CODE82, MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		 , MAX(X.ITEM_ID40) AS ITEM_ID40, MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40, MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		 , MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		 , MAX(X.DEPT_ID40) AS DEPT_ID40
		 -- 201990826
		 , X.PRODUCT_GROUP_NAME, X.ITEM_USE, X.UNIT_ENERGY-- [PJ20200138] item_use, unit_energy 추가		
		 , MAX(ISNULL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR
		 , MAX(ISNULL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (START)
		, X.ENERGE_WH, X.ENERGE_KWH
		 --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (END)
	INTO #RAW_DATA_SUM
	FROM #RAW_DATA X WITH(NOLOCK)
	GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.PROJECT_NAME, X.END_CUSTOMER, X.END_CUSTOMER40, X.SCM_SITE_ID40, X.SCM_SITE_ID81
		   , X.SCM_SITE_ID82, X.PLANT_SITE_ID, X.ITEM_ID, X.ITEM_ID40, X.DEPT_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--, X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--, X.DOM_EXP
		   , X.FCST_TYPE, X.SORT_ORDER_NO, X.BIZ_TYPE_NAME40, X.BIZ_TYPE_NAME81, X.BIZ_TYPE_NAME82, X.CALENDAR_YYYY
		   , X.CALENDAR_YYYYQQ, X.CURRENCY, X.MEASURE, X.PRODUCT_GROUP_NAME,  X.ITEM_USE -- [PJ20200138] item_use, unit_energy 추가
		   , X.UNIT_ENERGY, X.CELL_PROD_SITE
		   --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (START)
		   , X.ENERGE_WH, X.ENERGE_KWH
		   --[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가 (END)

PRINT @p_program_id + ' : A008-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 

	INSERT INTO #RAW_DATA_SUM
	SELECT X.DIVISION_ID, X.PROJECT_CODE, X.END_CUSTOMER40--,X.SCM_SITE_ID
		 , X.PLANT_SITE_ID, X.ITEM_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제
		 --,X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제
		 --,X.DOM_EXP
		 , X.FCST_TYPE, X.MEASURE, X.CELL_PROD_SITE, 'Y_' + X.CALENDAR_YYYY AS COLNAME
		 , X.SORT_ORDER_NO, X.CALENDAR_YYYY AS CALENDAR_YYYYQQ, X.CALENDAR_YYYY, X.CALENDAR_YYYY AS YYYYMM
		--,CASE WHEN MEASURE = 'KRW' OR MEASURE = 'USD' OR MEASURE = 'LOC' OR MEASURE = 'Business_Plan' 
		 , CASE WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
				THEN SUM(QTY) ELSE MAX(QTY) END QTY
		 , X.CURRENCY, MAX(X.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT, MAX(X.BIZ_TYPE_NAME40) AS BIZ_TYPE_NAME40
		, MAX(X.CELL_TYPE) AS CELL_TYPE, MAX(X.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME, MAX(X.ITEM_NAME) AS ITEM_NAME
		, MAX(X.ITEM_TYPE) AS ITEM_TYPE, MAX(X.NICK_NAME) AS NICK_NAME, MAX(X.MIN_CAPACITY) AS MIN_CAPACITY
		, MAX(X.EDIT_FLAG) AS EDIT_FLAG, MAX(X.APPLICATION) AS APPLICATION, MAX(X.CUST_GROUP) AS CUST_GROUP
		, MAX(X.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(X.OWNER) AS OWNER, X.DEPT_ID AS DEPT_ID
		, MAX(X.VMI_YN) AS VMI_YN, MAX(X.ROUTE) ROUTE, MAX(X.FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		, MAX(X.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL, MAX(X.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		, MAX(X.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION, MAX(X.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME, MAX(X.CUST_GROUP_DTL) CUST_GROUP_DTL
		, MAX(X.DMS_SALES) AS DMS_SALES, MAX(X.DMS_CUSTOMER) AS DMS_CUSTOMER--,MAX(X.BIZ_TYPE_NAME) BIZ_TYPE_NAME
		, MAX(X.PROJECT_NAME) AS PROJECT_NAME, MAX(X.PROJECT_OWNER) AS PROJECT_OWNER, MAX(X.PROJECT_STATUS) AS PROJECT_STATUS
		, MAX(X.END_CUSTOMER) AS END_CUSTOMER, MAX(X.CITY_NAME) AS CITY_NAME, MAX(X.COUNTRY_NAME) AS COUNTRY_NAME--,MAX(X.INCOTERMS40)	INCOTERMS40 		-- 20190513 -- [PJ20200138] Incoterms 삭제
		, MAX(X.FCST_TYPE40) AS FCST_TYPE40-- 20190513--,MAX(X.DOM_EXP40)		DOM_EXP40 			-- 20190513
		, MAX(X.REPORT_GROUP1) AS REPORT_GROUP1, MAX(X.REPORT_GROUP2) AS REPORT_GROUP2, MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
		, MAX(X.REPORT_GROUP4) AS REPORT_GROUP4, MAX(X.REPORT_GROUP5) AS REPORT_GROUP5, MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
		, MAX(X.REPORT_GROUP7) AS REPORT_GROUP7, MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		-- 201990826
		, MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81, MAX(X.PROJECT_CODE82) AS PROJECT_CODE82, MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
		, MAX(X.ITEM_ID40) AS ITEM_ID40, MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40, MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
		, MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82
		--,MAX(X.CELL_PER_PACK) AS CELL_PER_PACK
		--,MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE
		--,MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK
		, MAX(X.DEPT_ID40) AS DEPT_ID40
		-- 201990826
		, X.PRODUCT_GROUP_NAME, X.ITEM_USE -- [PJ20200138] item_use, unit_energy 추가
		, X.UNIT_ENERGY, MAX(ISNULL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR, MAX(ISNULL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		, X.ENERGE_WH, X.ENERGE_KWH
	FROM #RAW_DATA X WITH(NOLOCK)
	GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.PROJECT_NAME, X.END_CUSTOMER, X.END_CUSTOMER40, X.SCM_SITE_ID40
		   , X.SCM_SITE_ID81, X.SCM_SITE_ID82, X.PLANT_SITE_ID, X.ITEM_ID, X.ITEM_ID40, X.DEPT_ID, X.INCOTERMS -- [PJ20200138] Incoterms 삭제--, X.INCOTERMS82 -- [PJ20200138] Incoterms 삭제--, X.DOM_EXP
		   , X.FCST_TYPE, X.SORT_ORDER_NO, X.BIZ_TYPE_NAME40, X.BIZ_TYPE_NAME81, X.BIZ_TYPE_NAME82, X.CALENDAR_YYYY
		   , X.CALENDAR_YYYYQQ, X.CURRENCY, X.MEASURE, X.PRODUCT_GROUP_NAME, X.ITEM_USE -- [PJ20200138] item_use, unit_energy 추가
		   , X.UNIT_ENERGY, X.CELL_PROD_SITE
		--[E20240731-000852]_WH, KWH 단위 ENERGE 컬럼 추가
		   , X.ENERGE_WH, X.ENERGE_KWH

	-- ################ #RAW_DATA and Quarter&Year Sum ###########################

	INSERT INTO #RAW_DATA
	SELECT * 
	FROM #RAW_DATA_SUM WITH(NOLOCK)
	
PRINT @p_program_id + ' : A009-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 

BEGIN
    SELECT  @i_Count = Count(*)
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			WHERE  1 = 1
			AND    U.PROGRAM_ID  = @p_Program_Id
			AND    U.SHEET_NAME  = 'Biz Plan'    
			AND    U.USER_ID     = @p_created_by
			AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	
	--print @i_Count
	
PRINT @p_program_id + ' : A0010-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
	IF @i_Count = 0 

		BEGIN
			SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
				   , @GroupList = @GroupList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM 
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT
							C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
						FROM [SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
						WHERE 1 = 1
							AND    C.PROGRAM_ID  = @p_Program_Id
							AND    C.SHEET_NAME  = 'Biz Plan'  
							AND    ( C.DEFAULT_FLAG = 'Y' OR 
								(    C.VISIBLE_FLAG = 'N'
								AND    C.DEFAULT_FLAG = ''
								AND    C.VALID_YN     = 'Y'
								)
								)
				) tbColList	
			ORDER BY SORT_ORDER_NO
		END

	ELSE 

		BEGIN
			SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
				   , @GroupList = @GroupList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM 
					(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT
						U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE  
					FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
								 , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
					WHERE  1 = 1
							AND    U.PROGRAM_ID  = C.PROGRAM_ID
							AND    U.SHEET_NAME  = C.SHEET_NAME
							AND    U.COLUMN_NAME = C.COLUMN_NAME
							AND    U.PROGRAM_ID  = @p_Program_Id
							AND    U.SHEET_NAME  = 'Biz Plan'
							AND    U.USER_ID     = @p_created_by
							AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'   
							AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )
					UNION ALL
					SELECT TOP 100 
						C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
					FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
					WHERE  1 = 1
							AND    C.PROGRAM_ID  = @p_Program_Id
							AND    C.SHEET_NAME  = 'Biz Plan'
							AND    C.VISIBLE_FLAG = 'N'
							AND    C.DEFAULT_FLAG = ''
							AND    C.VALID_YN     = 'Y'
							AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	
					) tbColList	
			ORDER BY SORT_ORDER_NO
		END
	END

	SELECT @ColList = LEFT(@ColList, LEN(@ColList)-1)	
	SELECT @GroupList = LEFT(@GroupList, LEN(@GroupList)-1)			
    

    PRINT '-------------2! : ' +  CONVERT(CHAR(23), getdate(), 21)


	
PRINT @p_program_id + ' : A010-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
--	print  @ColList	

-- 5. 피벗 결과 내기위한 날짜 리스트.
		-- @Prod = '';
		SELECT @Prod = @Prod + '[' + A.COLNAME + '],'
			FROM (SELECT DISTINCT COLNAME FROM #RAW_DATA WITH(NOLOCK)) A				
		ORDER BY COLNAME

		IF @Prod = '' 
			BEGIN
				SET @Prod = 'D_99999999'
			END
		ELSE
			BEGIN
				Select @Prod = LEFT(@Prod, LEN(@Prod)-1)
			END
    PRINT '-------------3! : ' +  CONVERT(CHAR(23), getdate(), 21)

	
PRINT @p_program_id + ' : A011-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
-- 6. 최종 피벗 내기.
-- MEASURE에 따른 앞에 SORT_ORDER_NO 위한 삽입

SELECT @ColList = REPLACE(@ColList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')
SELECT @GroupList = REPLACE(@GroupList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')
--SELECT @GroupList = REPLACE(@GroupList,'[CELL_PER_PACK] ASC,[CELL_PER_MODULE] ASC,[MODULE_PER_PACK] ASC,', '')
SELECT @GroupList = REPLACE(@GroupList,'[CELL_PER_CAR] ASC,[MODULE_PER_CAR] ASC,', '')
--select @ColList 
--return(0)
	-- Temp Table 삭제
	--IF OBJECT_ID (N'dbo.TEMP_SKH_0326_SALES_PLAN_TOBE', N'U') IS NOT NULL 
	--	DROP TABLE TEMP_SKH_0326_SALES_PLAN_TOBE
	--	;
PRINT '-------------4! : ' +  CONVERT(CHAR(23), getdate(), 21)

		SET  @nsql2 = '
		SELECT  
				 ' + @ColList + '
				,' + @Prod + '
			--INTO TEMP_SKH_0326_SALES_PLAN_TOBE
		From(
			--SELECT COLNAME, SUM(QTY) AS QTY, ' + @ColList + '
			SELECT COLNAME, case when MEASURE in (''LOC'',''USD'',''KRW'') then MAX(QTY) else SUM(QTY) end AS QTY, ' + @ColList + '  -- 20190108 KHSONG Unit Price 인경우는 SUM하지 않고 AVG로 표기함
			FROM #RAW_DATA WITH(NOLOCK)
			GROUP BY COLNAME, ' + @ColList + '
			) T
		PIVOT (MAX(QTY) FOR COLNAME IN (' + @prod + ')
		) AS PVT

		ORDER BY 
				 ' + @GroupList + '			
		'
		
PRINT @p_program_id + ' : A012-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
--SELECT @GroupList 
--select @nsql2 
     --select convert(text, @nsql2)
     --for xml path('')--,root('x')  

execute dbo.SP_executesql @NSQL2 

--중장기 계획 관련 날짜 취득
DECLARE @FROM_YYYYMM NCHAR(6), @TO_YYYYMM NCHAR(6), @VALID_YN NCHAR(1);

SELECT @FROM_YYYYMM = ATTRIBUTE1, @TO_YYYYMM = ATTRIBUTE2, @VALID_YN = VALID_YN
FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
WHERE A.LOOKUP_TYPE = 'DM_LONG_PLAN'
AND A.SEGMENT1 = @p_division_id
AND A.SEGMENT2 = 'Biz Plan'
AND A.VALID_YN = 'Y'

PRINT @FROM_YYYYMM;

SELECT @VALID_YN AS VALID_YN 
	, @FROM_YYYYMM AS START_YYYYMM
    , @TO_YYYYMM AS END_YYYYMM
    , MIN(A.START_YYYYQQ) AS START_YYYYQQ
    , MAX(A.END_YYYYQQ) AS END_YYYYQQ
    , MIN(A.START_YYYY) AS START_YYYY
    , MAX(A.END_YYYY) AS END_YYYY
FROM (
    SELECT 
          MIN(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS START_YYYYQQ
        , MAX(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS END_YYYYQQ
        , NULL AS START_YYYY
        , NULL AS END_YYYY
    FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
    LEFT OUTER JOIN ( 
            SELECT DISTINCT CALENDAR_YYYYQQ
            FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
            WHERE BASIS_YYYYMM <  @FROM_YYYYMM
                OR BASIS_YYYYMM > @TO_YYYYMM
                ) B ON A.CALENDAR_YYYYQQ = B.CALENDAR_YYYYQQ
    WHERE A.BASIS_YYYYMM BETWEEN @FROM_YYYYMM AND @TO_YYYYMM
        AND B.CALENDAR_YYYYQQ IS NULL
    UNION ALL
    SELECT 
          NULL AS START_YYYYMM
        , NULL AS END_YYYYMM
        , MIN(A.CALENDAR_YYYY) AS START_YYYY
        , MAX(A.CALENDAR_YYYY) AS END_YYYY
    FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
    LEFT OUTER JOIN ( 
            SELECT DISTINCT CALENDAR_YYYY
            FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
            WHERE BASIS_YYYYMM <  @FROM_YYYYMM
                OR BASIS_YYYYMM > @TO_YYYYMM
                ) B ON A.CALENDAR_YYYY = B.CALENDAR_YYYY
    WHERE A.BASIS_YYYYMM BETWEEN @FROM_YYYYMM AND @TO_YYYYMM
        AND B.CALENDAR_YYYY IS NULL
    ) A
		
END
