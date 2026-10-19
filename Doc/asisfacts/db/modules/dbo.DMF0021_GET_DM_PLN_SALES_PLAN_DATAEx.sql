
/*=====================================================================================================================================================
 * Program ID   : DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx
 * Description  : Sales Plan Plan 조회
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2021.11.02	hwi1993		2021 하반기 과제 - 속도개선을 위해서 구조 번경
 * 2021.11.18	kdw2819		[과제]	자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021.11.19	ROSIA27		[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021.12.07	rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2022.01.21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2022.03.22   kdw2819     [C20220318-000248] GSCM Sales Plan 및 Sales Monitoring의 Unit Price 컬럼값 표기 오류 수정 요청의 건
 * 2022.04.07	rosia27		[과제PJ20216891R]GM_JV
 * 2022.12.14	rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023.06.21   leetw85     [E20230619-000151]  GSCM.DM 소수점 표기 방식 변경
 * 2023.09.18	jssbae		[E20230912-000426]_소형사업부- Sales Plan 화면 'Module' Biz Type 표기 룩업
 * 2023.12.19   JSSBAE      [E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall
 * 2024.04.04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선)
 * 2024.04.16   KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
 * 2024.05.17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024.08.02   JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024.08.26   JSSBAE		[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼메저 추가
 * 2024.08.27	KJJ			[PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 * 2024.09.12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.11.04	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
 * 2024.11.27	KJJ			[PJ2024-50611] 소형사업부는 원래대로 ETC만 수정 가능하게 처리 : 잘못 추가된 로직 제거
 * 2024.11.28	KJJ			[PJ2024-50611] 소형사업부는 Catch Up도 수정 가능하게 처리
 * 2024.12.12	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.03.12   dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.04.15   dsiol		[PJ2025-50188]LGES SCM DM 소형사업부 매출계획 동기화 개선 : SCM_FCST - MEASURE 추가
 * 2025.04.29   JSSBAE		[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가
 * 2025.05.21   JSSBAE		[E20250520-000574]_SALES PLAN, SALES PLAN WATERFALL UI의 RTF_PR Measure 조회 로직 변경
 * 2025.06.02   kjiyoon		[PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
 * 2025.06.02	kjiyoon		[PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
 * 2025.07.02	JSSBAE		[E20250520-000605]_[영업.마케팅PI] Sales Plan - ETC Data 'Monthly' 입력 Bucket 기능 수정 요청
 * 2025.07.07	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.11.21	JSSBAE		[E20251120-001430]_Sales Plan 당주 구간 RTF 수정 불가 개선
 * 2026.04.01	JSSBAE		[E20260331-000648]_[자동차 SCM] 자동차사업부 '기준수요'기능 중 'RTF수정기능'만 우선 적용 요청 건
 * 2026.05.12	JSSBAE		[E20260512-000502]_자동차 사업부 Cell Prod Site ID
 * 2026.07.21	JSSBAE		[E20260720-000270]_DP 입력시 문제 발생 件
 *===================================================================================================================================================*/
 /* EXEC DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx @p_division_id='82', @p_dept_id='ALL', @p_end_customer='ALL', 
	@p_scm_site_id='8minute Energy_US_EFS', @p_project_code='', @p_item_id='', @p_item_type='ALL', @p_from_yyyymmdd='20230501', 
	@p_now_yyyymmdd='20230814', @p_to_yyyymmdd='20231031', @p_created_by='chano0612', @p_plant_site_id='ALL', 
	@p_biztype='ALL', @p_userinfo='ADMIN', @p_owner='', @p_internal_yn='N', @p_bucket='MONTHLY', @p_user_dept_id='ICH' */

CREATE PROCEDURE [dbo].[DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx]
	  @p_division_id				NVARCHAR(30)
	, @p_dept_id					NVARCHAR(4000)
	, @p_end_customer				NVARCHAR(4000)
	, @p_scm_site_id				NVARCHAR(4000)
	, @p_project_code				NVARCHAR(4000)
	, @p_item_id					NVARCHAR(4000)
	, @p_item_type					NVARCHAR(4000)
	, @p_from_yyyymmdd				NVARCHAR(8)
	, @p_now_yyyymmdd				NVARCHAR(8)
	, @p_to_yyyymmdd				NVARCHAR(8)
	, @p_created_by					NVARCHAR(4000)
	, @p_plant_site_id				NVARCHAR(4000)
	, @p_biztype					NVARCHAR(4000)
	, @p_owner						NVARCHAR(4000)
	, @p_internal_yn				NVARCHAR(1)
	, @p_userinfo					NVARCHAR(150)
	, @p_bucket						NVARCHAR(10)	-- 20211026 SALES PLAN 속도 개선
	, @p_user_dept_id				NVARCHAR(50)	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
AS  
  
BEGIN
	SET NOCOUNT ON;
	--SET ANSI_WARNINGS OFF; 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON; 
	
	--=================================================================================================================================
	-- 사용 변수 선언 (START)
	--=================================================================================================================================
	DECLARE	@Prod			NVARCHAR(MAX);
	DECLARE @ColList		NVARCHAR(MAX);
	DECLARE @OrderList		NVARCHAR(MAX);
	DECLARE @nsql			NVARCHAR(MAX);
	DECLARE @nsql2			NVARCHAR(MAX);
	DECLARE @p_program_id	VARCHAR(50)		= 'DMF0021';
	DECLARE @p_sheet_name	VARCHAR(50)		= 'Sales Plan';
	DECLARE @v_dept_list	VARCHAR(4000)	= '';
	DECLARE @v_group_id		VARCHAR(50)		= '';

	SET		@ColList				= '';
	SET		@OrderList				= '';
	SET		@Prod					= '';
	DECLARE	@MEASURE			INT	= 0;
	DECLARE	@i_count			INT	= 0;	
	-----------------------------------------------------------------------------------------------------------------------------------	
	-- 20200316 KHSONG C20200224-000109 (START)
	-----------------------------------------------------------------------------------------------------------------------------------	
	DECLARE @v_user_mea_cnt		INT = 0;
	-----------------------------------------------------------------------------------------------------------------------------------	
	-- 20200316 KHSONG C20200224-000109 (END)
	-----------------------------------------------------------------------------------------------------------------------------------	
	-- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
	DECLARE	@v_start_yyyymmdd	NVARCHAR(8)
	SET		@v_start_yyyymmdd = (SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = @p_from_yyyymmdd)
	--=================================================================================================================================
	-- 사용 변수 선언 (END)
	--=================================================================================================================================

PRINT @p_program_id +' : A001--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (START)
	--=================================================================================================================================
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V;
	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE;
	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA;
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM;
	IF OBJECT_ID (N'tempdb..#T_PRICE', N'U') IS NOT NULL 
		DROP TABLE #T_PRICE;
	IF OBJECT_ID (N'tempdb..#TEMP_SHIPMENT_SITE', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SHIPMENT_SITE;
	IF OBJECT_ID (N'tempdb..#WF', N'U') IS NOT NULL 
		DROP TABLE #WF;		
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL    
		DROP TABLE #TEMP_SCM_MST_SITE;		 
	-----------------------------------------------------------------------------------------------------------------------------------	
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	-----------------------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V;
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선 속도개선 END
	-----------------------------------------------------------------------------------------------------------------------------------
	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (END)
	--=================================================================================================================================
PRINT @p_program_id +' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	--=================================================================================================================================
	-- 권한 관리 (START)
	--=================================================================================================================================
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (START)
	-----------------------------------------------------------------------------------------------------------------------------------
	IF ISNULL((	SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				WHERE LOOKUP_TYPE	= 'GET_ADMIN_GROUP'
				AND VALID_YN		= 'Y'
				AND SEGMENT1		= @p_userinfo
				AND SEGMENT2		= 'ALL'
				--AND SEGMENT3 = LEFT(@p_division_id,2)
			  ),0) > 0
	BEGIN
		SET @v_group_id = 'ADMIN'
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 그룹 + 화면 + 사업부 + MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 (START)
	-----------------------------------------------------------------------------------------------------------------------------------
	--Measure 별로 다른 권한을 부여해달라는 요청으로 인하여 GET_ADMIN_GROUP_MEASURE 룩업을 만들었음. 
	DECLARE @v_EDIT_AUTH_SalesAmt_LOC VARCHAR(1)	= 'N'; --SalesAmt_LOC
	DECLARE @v_EDIT_AUTH_RTF_SYS_RP VARCHAR(1)		= 'N'; --RTF_SYS_RP

	IF ISNULL(( SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				WHERE LOOKUP_TYPE	= 'GET_ADMIN_GROUP_MEASURE' 
				AND VALID_YN		= 'Y'
				AND SEGMENT1		= @p_userinfo --ADMIN , SCM PI Admin , DM ADMIN , DM Planner , SCP Planner
				AND SEGMENT2		= @p_program_id
				--[E20260331-000648]_DIVISION_ID별로 변경되었으므로 원소스 주석처리 후 수정 (START)
				--AND SEGMENT3		= LEFT(@p_division_id,2) --[E20260331-000648]_원소스 주석처리
				AND SEGMENT3		= @p_division_id
				--[E20260331-000648]_DIVISION_ID별로 변경되었으므로 원소스 주석처리 후 수정 (END)
				AND SEGMENT4		= 'SalesAmt_LOC' ),0) > 0
	BEGIN
		SET @v_EDIT_AUTH_SalesAmt_LOC = 'Y'
	END

	IF ISNULL((	SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				WHERE LOOKUP_TYPE	= 'GET_ADMIN_GROUP_MEASURE' 
				AND VALID_YN		= 'Y'
				AND SEGMENT1		= @p_userinfo --ADMIN , SCM PI Admin , DM ADMIN , DM Planner , SCP Planner
				AND SEGMENT2		= @p_program_id
				--[E20260331-000648]_DIVISION_ID별로 변경되었으므로 원소스 주석처리 후 수정 (START)
				--AND SEGMENT3		= LEFT(@p_division_id, 2) --[E20260331-000648]_원소스 주석처리
				AND SEGMENT3		= @p_division_id
				--[E20260331-000648]_DIVISION_ID별로 변경되었으므로 원소스 주석처리 후 수정 (END)
				AND SEGMENT4		= 'RTF_SYS_RP' ),0) > 0
	BEGIN
		SET @v_EDIT_AUTH_RTF_SYS_RP = 'Y'
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
PRINT @p_program_id +' : A003--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 사용자의 팀정보 & 권한 - [C20210504-000057] SalesPlan 권한은 있으나 편집안되는 현상 수정 2021/05/13 SJHan (START)
	-----------------------------------------------------------------------------------------------------------------------------------
	SET @v_dept_list = ( SELECT DISTINCT STUFF((	SELECT ',' + D.SEGMENT3 
													FROM (	SELECT LOOK.SEGMENT1, LOOK.SEGMENT3 
															FROM   TB_FX_User USR WITH(NOLOCK)
															INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK WITH(NOLOCK)
																	ON USR.DEPT_ID		= LOOK.SEGMENT1 
																   AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING' 
																   AND LOOK.VALID_YN	= 'Y'
															WHERE LOOK.VALID_YN	= 'Y' 
															AND USR.USERID		= @p_created_by
															UNION
															-- 매핑이 없는 경우 자기 부서
															SELECT DEPT_ID AS SEGMENT1, DEPT_ID AS SEGMENT3 
															FROM TB_FX_User WITH(NOLOCK) 
															WHERE USERID = @p_created_by
															) AS D
													WHERE D.SEGMENT1 = A.SEGMENT1
													FOR XML PATH('')), 1, 1, '') AS SEGMENT 
							FROM (	SELECT LOOK.SEGMENT1, LOOK.SEGMENT3 
									FROM   TB_FX_User USR WITH(NOLOCK)
									INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK WITH(NOLOCK)
											ON USR.DEPT_ID		= LOOK.SEGMENT1 
										   AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING' 
										   AND LOOK.VALID_YN	= 'Y'
									WHERE LOOK.VALID_YN = 'Y' AND USR.USERID = @p_created_by
									UNION
									SELECT DEPT_ID AS SEGMENT1, DEPT_ID AS SEGMENT3 
									FROM TB_FX_User WITH(NOLOCK) 
									WHERE USERID = @p_created_by ) A 
							WHERE A.SEGMENT1 = ( SELECT DEPT_ID FROM TB_FX_User WITH(NOLOCK) WHERE UserID = @p_created_by))

	-- DAILY 일 경우 EDIT 불가
	--IF @P_BUCKET = 'DAILY'
	--BEGIN
	--	SELECT @v_group_id = '', @v_dept_list = ''
	--END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 사용자의 팀정보 & 권한 - [C20210504-000057] SalesPlan 권한은 있으나 편집안되는 현상 수정 2021/05/13 SJHan (END)
	-----------------------------------------------------------------------------------------------------------------------------------
	--=================================================================================================================================
	-- 권한 관리 (END)
	--=================================================================================================================================
PRINT @p_program_id +' : A004--' + CONVERT(VARCHAR(30), GETDATE(), 121);

/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.*/
   
	--=================================================================================================================================
	-- 메져정보 셋팅 (START)
	--=================================================================================================================================
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (START)
	-----------------------------------------------------------------------------------------------------------------------------------
	SELECT @v_user_mea_cnt = COUNT(*)
	FROM   SCM_MST_TITLESET_USER U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID						= @p_program_id
	AND    U.SHEET_NAME						= @p_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND    U.USER_ID						= @p_created_by;

	IF @v_user_mea_cnt = 0
	BEGIN	    
		INSERT INTO [dbo].[SCM_MST_TITLESET_USER]
		( USER_ID
		, PROGRAM_ID
		, SHEET_NAME
		, USER_INQUIRY_COLUMN_TYPE_CODE
		, COLUMN_NAME
		, SORT_ORDER_NO
		, SUB_TOTAL_FLAG
		, DATA_SORT_METHOD_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE
		)
		SELECT @p_created_by
		     , C.PROGRAM_ID
			 , C.SHEET_NAME
			 , 'M'
			 , C.COLUMN_NAME
			 , C.SORT_ORDER_NO
			 , 'N'
			 , ''
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
		FROM   [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = @p_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'	;
	END;
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
PRINT @p_program_id +' : A005--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 (START)
	-- RTF_PR은 40 사업부만 사용하나, 생성은 모든 사업부에서 진행하게 되면서, 모든 사업부에 메져가 노출됨.
	-----------------------------------------------------------------------------------------------------------------------------------
	-- USER TITLE 정보와 MEASURE MASTER 정보를 JOIN하여 사업부별 정보를 보관한다. 
	SELECT T.USER_ID, T.MEASURE, T.SORT_ORDER_NO, T.SYSTEM_ADD, T.DIVISION_ID
	INTO #TEMP_SCM_MST_SHEET_MEASURE
	FROM (	SELECT A.USER_ID, A.MEASURE, A.SORT_ORDER_NO, A.SYSTEM_ADD, TOKEN AS DIVISION_ID
			FROM (	SELECT U.USER_ID, U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, B.DIVISION_ID, 'N' AS SYSTEM_ADD
					FROM SCM_MST_TITLESET_USER U WITH (NOLOCK)
					INNER JOIN SCM_MST_SHEET_MEASURE B WITH(NOLOCK) 
							ON U.PROGRAM_ID		= B.PROGRAM_ID
						   AND U.SHEET_NAME		= B.SHEET_NAME
						   AND U.COLUMN_NAME	= B.COLUMN_NAME
					WHERE	1 = 1
					AND		U.PROGRAM_ID					= @p_program_id
					AND		U.SHEET_NAME					= @p_sheet_name
					AND		U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
					AND		U.USER_ID						= @p_created_by 
					AND		B.VALID_YN						= 'Y' ) A
			CROSS APPLY STRING_SPLIT(A.DIVISION_ID, ',' )) T
	WHERE T.DIVISION_ID = @p_division_id

	/* 과거 쿼리는 주석처리 한다.
	SELECT DISTINCT	U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, 'N' AS SYSTEM_ADD
	INTO #SELECT_MEASURE   -- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
	FROM SCM_MST_TITLESET_USER U  WITH(NOLOCK)
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK) 
		   ON U.USER_ID		= T.SEGMENT4	-- 20200309 KHSONG TMM MEASURE 권한추가
		  AND @p_created_by	= T.SEGMENT4	-- USER_ID
		  AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
		  AND T.VALID_YN	= 'Y'			-- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND U.PROGRAM_ID   = @p_program_id
	AND U.USER_ID      = @p_created_by
	AND U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by	END  -- 20200309 KHSONG TMM MEASURE 권한추가 */ 

	SELECT DISTINCT U.MEASURE, U.SORT_ORDER_NO, U.SYSTEM_ADD
	INTO #SELECT_MEASURE   
	FROM #TEMP_SCM_MST_SHEET_MEASURE U  WITH(NOLOCK)
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK) 
		   ON U.USER_ID		= T.SEGMENT4	-- 20200309 KHSONG TMM MEASURE 권한추가
		  AND @p_created_by	= T.SEGMENT4	-- USER_ID
		  AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
		  AND T.VALID_YN	= 'Y'			-- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_ID = CASE WHEN U.MEASURE = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by	END 
	
PRINT @p_program_id +' : A006--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'LOC', 'KRW' ))
	BEGIN
		INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE
				UNION ALL
				SELECT 'SALESAMT_KRW' AS MEASURE
				UNION ALL
				SELECT 'SALESAMT_LOC' AS MEASURE ) A
		LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
	END

	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP' ))
	BEGIN
		INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'MKT_FCST' AS MEASURE
				UNION ALL
				SELECT 'RTF_SYS_RP' AS MEASURE	) A
		LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
	END
	
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
	-- 사용자가 UI에서 조회 할 MEASURE를 RTF_PR만 했을 경우 계산을 위해서 RTF_SYS_RP를 내부적으로 넣는 것이다. 실제로 표시는 안함.
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'RTF_PR' ))
	BEGIN
		INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE ) A
		LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
	END
	
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] RTF_BALANCE 추가 요청 
	-- 사용자가 UI에서 조회 할 MEASURE를 RTF_BALANCE만 했을 경우 계산을 위해서 RTF_SYS_RP,RTF_RP를 내부적으로 넣는 것이다. 실제로 표시는 안함.
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'RTF_BALANCE' ))
	BEGIN
		INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE
				UNION ALL
				SELECT 'RTF_PR' AS MEASURE	) A
		LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
	END

	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
	-- SCM_FCST 메저의 실적구간은 RTF_SYS_RP 를 가져와 보여주도록 한다.
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' ))
	BEGIN
		INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE) A
		LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
	END
	
PRINT @p_program_id +' : A007--' + CONVERT(VARCHAR(30), GETDATE(), 121);

	CREATE TABLE #RAW_DATA 
	( VERSION_NO		NVARCHAR(30)
	, CUTOFF_YYYYMMDD	CHAR(8)
	, DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, PLANT_SITE_ID		NVARCHAR(30)
	, ITEM_ID			NVARCHAR(50)
	, TEXT   			NVARCHAR(MAX)
	, INCOTERMS			NVARCHAR(10)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, CURRENCY			NVARCHAR(3)
	, COMPANY_ID		NVARCHAR(30)
	, MEASURE			NVARCHAR(50)
	, YYYYMMDD			CHAR(8)
	, QTY				NUMERIC(30,10)
	, VALID_YN			CHAR(1)
	, PLAN_RESULT		CHAR(1)
	, ATTRIBUTE1		NVARCHAR(150)  --[PJ2024-50611] 화면에서 저장한 dept_id
	, CELL_PROD_SITE_ID NVARCHAR(60) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	)

	CREATE TABLE #TEMP_SHIPMENT_SITE 
	( DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, ITEM_ID			NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, INCOTERMS			NVARCHAR(10)
	, FCST_TYPE			NVARCHAR(20)
	, SHIPMENT_SITE		NVARCHAR(30))	
PRINT @p_program_id +' : A008--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	-----------------------------------------------------------------------------------------------------------------------------------
	-- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')
	-----------------------------------------------------------------------------------------------------------------------------------			
	INSERT INTO #RAW_DATA 
	( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
	, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
	, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
	, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID 
		 , A.PLANT_SITE_ID, A.ITEM_ID, ISNULL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP 
		 , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD 
		 , A.QTY, 'P' AS PLAN_RESULT
		 --, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		 --[E20260331-000648]_원소스 주석처리 후 CELL_PROD_SITE_ID NULL인 경우 '-' 나오도록 수정 (START)
		 --, CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
		 , ISNULL(A.CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE 
		 --[E20260331-000648]_원소스 주석처리 후 CELL_PROD_SITE_ID NULL인 경우 '-' 나오도록 수정 (END)
	FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
	JOIN #SELECT_MEASURE B 
	  ON A.MEASURE = B.MEASURE
	JOIN SCM_MST_SITE C WITH(NOLOCK)
	  ON A.DIVISION_ID	= C.DIVISION_ID 
	 AND A.SCM_SITE_ID	= C.SCM_SITE_ID 
	 AND C.VALID_YN		= 'Y'
	--LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
	WHERE A.YYYYMMDD >= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd
	AND	  A.DIVISION_ID =@p_division_id
	AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' )) --[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정
	--마이그레이션 된 데이터 지우면 조건삭제
	AND	  A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							   WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
							   AND VALID_YN			= 'Y'  
							   AND SEGMENT1			= A.DIVISION_ID )
	AND	  A.ITEM_ID NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							 WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
							 AND VALID_YN		= 'Y'  
							 AND SEGMENT1		= A.DIVISION_ID ) 
	AND	  A.MEASURE NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							 WHERE LOOKUP_TYPE	= 'SALES_PLAN_CATCHUP'
							 AND VALID_YN		= 'Y' )
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 (START)
	-----------------------------------------------------------------------------------------------------------------------------------
	UNION ALL
	SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID 
		 , PLANT_SITE_ID, A.ITEM_ID, A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP 
		 , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD 
		 , A.QTY, 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	FROM DM_PLN_SALES_ETC_PLAN AS A WITH(NOLOCK)
	JOIN #SELECT_MEASURE B 
	  ON A.MEASURE = B.MEASURE
	JOIN SCM_MST_SITE C WITH(NOLOCK)
	  ON A.DIVISION_ID	= C.DIVISION_ID 
	 AND A.SCM_SITE_ID	= C.SCM_SITE_ID 
	 AND C.VALID_YN		= 'Y'
	WHERE A.YYYYMMDD >= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd
	AND	  A.DIVISION_ID = @p_division_id
	AND   A.QTY	<> 0
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
	UNION ALL
	SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID 
		 , PLANT_SITE_ID, A.ITEM_ID, ISNULL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP 
		 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, A.YYYYMMDD
		 , A.QTY + CASE WHEN @p_internal_yn = 'Y' AND @P_DIVISION_ID = '82' AND ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) ELSE 0 END AS QTY
		 , 'R' AS PLAN_RESULT
		 --, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		 , CELL_PROD_SITE_ID		--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
	FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
	JOIN #SELECT_MEASURE B 
	  ON A.MEASURE = B.MEASURE
	WHERE A.YYYYMMDD >= @p_from_yyyymmdd AND A.YYYYMMDD < @p_now_yyyymmdd
	AND	  A.DIVISION_ID = @p_division_id
	AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' )) --[PJ2025-50017]Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정
	AND   A.MEASURE NOT IN ('RTF_PR') --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
	
PRINT @p_program_id +' : A009--' + CONVERT(VARCHAR(30), GETDATE(), 121);		

	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP')
	BEGIN
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE
			 , SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
			 , QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A 
		WHERE A.MEASURE = 'MKT_FCST'
		AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
							   ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
						  END -- [C20200521-000202] Version cutoff 기준으로 MKT_FCST 조회
		AND A.YYYYMMDD <= @p_to_yyyymmdd

		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
			 , QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A 
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= @p_from_yyyymmdd 
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
							  ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
						 END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 (START)
	-- 사용자가 UI에서 조회 할 MEASURE를 RTF_PR만 했을 경우 계산을 위해서 RTF_SYS_RP를 내부적으로 넣는 것이다. 실제로 표시는 안함.
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'RTF_PR')
	BEGIN
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE ,SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID,'RTF_PR' AS MEASURE, YYYYMMDD
			 , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A 
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= @p_from_yyyymmdd 
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
							  ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
						 END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 (END)
	-----------------------------------------------------------------------------------------------------------------------------------	
PRINT @p_program_id +' : A010--' + CONVERT(VARCHAR(30), GETDATE(), 121);		

	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] RTF_BALANCE 추가 요청 (START)
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'RTF_BALANCE')
	BEGIN
		INSERT INTO #RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY
		, PLAN_RESULT, CELL_PROD_SITE_ID) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		-- P : PLAN(계획) 구간
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'RTF_BALANCE' AS MEASURE, A.YYYYMMDD
			 , (SUM(CASE WHEN MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) - SUM(CASE WHEN MEASURE = 'RTF_PR' THEN A.QTY ELSE 0 END)) AS QTY
			 , 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM #RAW_DATA A 
			WHERE A.MEASURE IN('RTF_SYS_RP','RTF_PR')
			AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
								   ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
							  END
			AND A.YYYYMMDD <= @p_to_yyyymmdd
			AND A.QTY > 0
			GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
				   , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
				   , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] RTF_BALANCE 추가 요청 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 (START)
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'SCM_FCST')
	BEGIN
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE ,SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID,'SCM_FCST' AS MEASURE, YYYYMMDD
			 , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A 
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= @p_from_yyyymmdd 
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
							  ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
						 END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
PRINT @p_program_id +' : A011--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- 메져정보 셋팅 (END)
	--=================================================================================================================================
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 아래서부터는 CURRENCY를 사용해야 하므로 여기서 UPDATE 한다.
	-----------------------------------------------------------------------------------------------------------------------------------
	UPDATE A
	SET CURRENCY = B.CURRENCY
	FROM #RAW_DATA A
	JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK) 
	  ON A.DIVISION_ID	= B.DIVISION_ID 
	 AND A.PROJECT_CODE	= B.PROJECT_CODE 
	 AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
	 AND A.ITEM_ID		= B.ITEM_ID
	WHERE ISNULL(A.CURRENCY, '') = ''

	IF ( @p_internal_yn <> 'Y')
	BEGIN
		DELETE FROM #RAW_DATA 
		WHERE SCM_SITE_ID IN ( SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK))
	END			
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 START
	-----------------------------------------------------------------------------------------------------------------------------------
	/* 20230918_[E20230912-000426]_소형사업부- Sales Plan 화면 'Module' Biz Type 표기 룩업
	-- 차후 걷어내야 하므로, 원소스 주석처리함.
	SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
			, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
			, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
			, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
			, ENERGE, CELL_QUANTITY
			, MDM_PROJECT_NAME, CELL_TYPE
		INTO #TEMP_DM_MST_ITEM_SINGLE_V
		FROM DM_MST_ITEM_SINGLE_V A
		join ( select distinct division_id, item_id from #raw_data ) b on a.division_id = b.division_id and a.item_id = b.item_id
	WHERE A.DIVISION_ID = @p_division_id
	*/
	/* 2024-04-04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선) */
		
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	--원소스 주석처리
	/*
	SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
			, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
			, CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE A.FORECAST_INFO_BIZ_TYPE END AS FORECAST_INFO_BIZ_TYPE				
			, CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.CELL_PACK_COUNT ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
			, FORECAST_INFO_PRODUCT_GROUP
			, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
				--[E20240731-000852]_ENERGE 컬럼 아래에서 처리할 예정이므로, 원래 사용했던 부분은 주석처리
				--, ENERGE 
			, CELL_QUANTITY
			, MDM_PROJECT_NAME, CELL_TYPE			
			--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 START 
			, ENERGE AS ENERGE_WH
			, CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 7))) ELSE NULL END AS ENERGE
			--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 END 
		INTO #TEMP_DM_MST_ITEM_SINGLE_V
		--FROM DM_MST_ITEM_SINGLE_V A WITH(NOLOCK)
		FROM    
            (
			SELECT	T1.DIVISION_ID,
					T1.ITEM_ID, 
					MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
					case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
									when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
									when T1.item_type = 'Q' then 3
									else 4 end )  
													when 1 then 'P' 
													when 2 then 'H'
													when 3 then 'Q'
													else 'R' end	AS ITEM_TYPE,
					MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
					MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
					MAX(T1.SPEC								)		AS SPEC,
					MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
					MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
					MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
					MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
					MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
					MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
					MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
					MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
					MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
					MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
					MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
					MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
					MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
				FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
				INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID, 12) AS ITEM_ID
								, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
								, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
								, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
								, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
								, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
								, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
								, MAX(CELL_TYPE) AS CELL_TYPE
							FROM  SCM_MST_ITEM_SN T2 WITH(NOLOCK) 
							WHERE  DIVISION_ID =  @p_division_id
							GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
						) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
					AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
				where 1=1
				AND		T1.DIVISION_ID = @p_division_id
				--AND		T1.ACTIVE_FLAG = 'Y'  --이걸 막아야 건수가 동일해짐 수정전/후 count
				--WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
				--LGCE_FPDEV_TR.DBO.SCM_ITEM_M T1
				group by T1.DIVISION_ID, T1.ITEM_ID
        ) A
		LEFT JOIN ( 
						SELECT A.MODEL
								, A.BIZ_TYPE
								, A.CELL_PACK_COUNT
								, A.MODEL_RANK 
						FROM 
						(
							SELECT SEGMENT2  AS MODEL       
									, SEGMENT3  AS BIZ_TYPE
									, SEGMENT4  AS CELL_PACK_COUNT
									, RANK () OVER ( 
													PARTITION BY SEGMENT2
													ORDER BY DISPLAY_SEQ DESC
												) MODEL_RANK 
							FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
							WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' 
							AND SEGMENT1 = '40'
						) A
						WHERE MODEL_RANK = '1'
					) LOOKA
				ON LOOKA.MODEL = A.ITEM_ID			
		join ( select distinct division_id, item_id from #raw_data ) b 
			on a.division_id = b.division_id and a.item_id = b.item_id
	WHERE A.DIVISION_ID = @p_division_id
	*/
PRINT @p_program_id +' : A012--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	
	--=================================================================================================================================
	-- MDM -> FP테이블 LGCE_SCMDPROD 동의어 SCM_MST_ITEM_SN 셋팅 VIEW 테이블을 사용하니, 화면이 느려져서 TEMP에 담는작업함 (START)
	--=================================================================================================================================
	-----------------------------------------------------------------------------------------------------------------------------------
	--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	-----------------------------------------------------------------------------------------------------------------------------------
	SELECT *
	INTO #TEMP_DM_MST_ITEM_SINGLE_ORI_V
	FROM SCM_MST_ITEM_SN WITH(NOLOCK)		
	WHERE DIVISION_ID = @p_division_id		
	
	-----------------------------------------------------------------------------------------------------------------------------------
	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	-----------------------------------------------------------------------------------------------------------------------------------
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
	
	-----------------------------------------------------------------------------------------------------------------------------------
	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	-----------------------------------------------------------------------------------------------------------------------------------
	SELECT DIVISION_ID, LEFT(ITEM_ID, 12) AS ITEM_ID
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

	SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
		 , CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE A.FORECAST_INFO_BIZ_TYPE END AS FORECAST_INFO_BIZ_TYPE				
		 , CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.CELL_PACK_COUNT ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_QUANTITY, MDM_PROJECT_NAME, CELL_TYPE			
		 -----------------------------------------------------------------------------------------------------------------------------------
		 -- [E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 START 
		 -----------------------------------------------------------------------------------------------------------------------------------
		 , ENERGE AS ENERGE_WH
		 , CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 7))) ELSE NULL END AS ENERGE
		 -----------------------------------------------------------------------------------------------------------------------------------
		 -- [E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 END 
		 -----------------------------------------------------------------------------------------------------------------------------------
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM (	SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME
				 , T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
				 , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG
				 , T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC	
			FROM #TEMP_DM_MST_ITEM_SINGLE_A_V T1 WITH(NOLOCK)	
			INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_B_V T2 ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTRING(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
			WHERE 1=1 ) A
	LEFT JOIN (	SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK 
				FROM (	SELECT SEGMENT2  AS MODEL, SEGMENT3  AS BIZ_TYPE, SEGMENT4  AS CELL_PACK_COUNT
							 , RANK () OVER ( PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC ) AS MODEL_RANK 
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)	WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40') A
				WHERE MODEL_RANK = '1' ) LOOKA ON LOOKA.MODEL = A.ITEM_ID			
	JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM #RAW_DATA ) B ON  A.DIVISION_ID = B.DIVISION_ID AND  A.ITEM_ID = B.ITEM_ID
	WHERE A.DIVISION_ID = @p_division_id	
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
	-----------------------------------------------------------------------------------------------------------------------------------
	CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
	( DIVISION_ID ASC, ITEM_ID ASC) WITH 
	( PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	
	--=================================================================================================================================
	-- MDM -> FP테이블 LGCE_SCMDPROD 동의어 SCM_MST_ITEM_SN 셋팅 VIEW 테이블을 사용하니, 화면이 느려져서 TEMP에 담는작업함 (END)
	--=================================================================================================================================
	/* [E20240731-000852]_MDM에서 DM으로 ENERGE I/F 단위는 WH인데, 82사업부는 KW기준
							40번 사업부는 WH기준으로 보여주길 원하므로 82사업부인 경우에만 KWH로 나오도록 조건 추가 
	IF ( @P_DIVISION_ID = '82' )
	BEGIN
		--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 START
		--해당 테이블의 데이터를 쓰므로, 데이터 완료된 후 KWH로 변경한다.
		UPDATE #TEMP_DM_MST_ITEM_SINGLE_V
		SET ENERGE = CASE WHEN ISNUMERIC(ENERGE) > 0 THEN ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 4) ELSE NULL END
		FROM #TEMP_DM_MST_ITEM_SINGLE_V
		WHERE DIVISION_ID = '82'
		--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 END
	END
	*/
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	-----------------------------------------------------------------------------------------------------------------------------------
PRINT @p_program_id +' : A013--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	--=================================================================================================================================
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL, CELL_PER_CAR, CELL_PER_MODULE
		 , CURRENCY, SALES_COMPANY, SALES_PLANT, SALES_PLAN_ADJUST_YN, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
		 , REPORT_GROUP6, A.OWNER, DBO.FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'EN' ) AS OWNER_NAME
		 , DBO.FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
		 , ( SELECT SU.DEPT_ID FROM SCM_MST_SSO_USER_INFO SU WITH(NOLOCK)
			 WHERE SU.USER_ID = (SELECT TOP 1 token FROM [dbo].[String_Split](a.owner, ','))) AS DEPT_ID, VALID_YN
	INTO #TEMP_SCM_MST_SITE_ITEM
	FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
	JOIN ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM #RAW_DATA ) B
	  ON A.DIVISION_ID	= B.DIVISION_ID 
	 AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
	 AND A.PROJECT_CODE = B.PROJECT_CODE 
	 AND A.ITEM_ID		= B.ITEM_ID
	WHERE A.DIVISION_ID = @p_division_id
	--=================================================================================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	--=================================================================================================================================
	--DELETE A
	--FROM #RAW_DATA A
	--LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
	--WHERE A.PLAN_RESULT = 'P' 
	--	AND A.ITEM_ID NOT IN ('ETC', 'ED_D','TOOLING','MDF')
	--	AND ISNULL(B.VALID_YN,'') <> 'Y'
	--  AND A.VERSION_NO = 'CURRENT'	( 수정 전 로직이 버전구분 없이 처리 )
	
PRINT @p_program_id +' : A014--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- [PJ2024-50611] 화면에서 저장한 dept_id 업데이트 (START)
	-- 화면에서 병합되어야 하므로 RESULT에도 동일한 값이 필요함
	--=================================================================================================================================
	UPDATE A
	SET ATTRIBUTE1 = B.ATTRIBUTE1
	FROM #RAW_DATA A
	JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
				, ATTRIBUTE1, REMARK_TEXT --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 필드추가
				, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			--FROM [dbo].[DM_PLN_SALES_PLAN] WITH(NOLOCK)
			FROM DM_PLN_SALES_ETC_PLAN WITH(NOLOCK)--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			WHERE DIVISION_ID	= '40'
			AND   FCST_TYPE		= 'ETC'
			AND   YYYYMMDD		>= @p_now_yyyymmdd AND YYYYMMDD <= @p_to_yyyymmdd
			AND   QTY <> 0 ) B
	  ON A.DIVISION_ID			= B.DIVISION_ID 
	 AND A.PROJECT_CODE			= B.PROJECT_CODE 
	 AND A.SCM_SITE_ID			= B.SCM_SITE_ID 
	 AND A.ITEM_ID				= B.ITEM_ID
	 AND A.DOM_EXP				= B.DOM_EXP
	 AND A.FCST_TYPE			= B.FCST_TYPE
	 AND A.INCOTERMS			= B.INCOTERMS
	 AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
	 AND A.YYYYMMDD				= B.YYYYMMDD
	 AND A.TEXT					= B.REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 조인추가
	 AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	--=================================================================================================================================
	-- [PJ2024-50611] 화면에서 저장한 dept_id 처리 (END)
	--=================================================================================================================================	
PRINT @p_program_id +' : A015--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 ) (START) 
	--=================================================================================================================================
	BEGIN 
		IF ( @p_project_code <> '') -- 소형은 UI 에서 PROJECT DISABLE 됨
		BEGIN
			DELETE A
			FROM #RAW_DATA A
			JOIN SCM_MST_PROJECT B WITH(NOLOCK) 
			  ON A.DIVISION_ID = B.DIVISION_ID 
			 AND A.PROJECT_CODE = B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_project_code,',')) C	
						 ON B.PROJECT_CODE LIKE '%' + C.TOKEN + '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_project_code,',')) D	
						 ON B.PROJECT_NAME LIKE '%' + D.TOKEN + '%'
			WHERE C.TOKEN IS NULL
			AND   D.TOKEN IS NULL
		END

		IF ( @p_item_id <> '')
		BEGIN
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_item_id,',')) C	
						 ON A.ITEM_ID LIKE '%' + C.TOKEN + '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token	FROM dbo.String_Split(@p_item_id,',')) D	
						 ON B.NICK_NAME LIKE '%' + D.TOKEN + '%'
			WHERE C.TOKEN IS NULL  
			AND   D.TOKEN IS NULL
		END

		IF ( @p_owner <> '')
		BEGIN
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B
						 ON A.ITEM_ID		= B.ITEM_ID 
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
						AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_owner,',')) C	
						 ON B.OWNER LIKE '%' + C.TOKEN + '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_owner,',')) D	
						 ON B.OWNER_NAME LIKE '%' + D.TOKEN + '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_owner,',')) E	
						 ON B.OWNER_NAME_KO LIKE '%' + E.TOKEN + '%'
			WHERE C.TOKEN IS NULL  
			AND   D.TOKEN IS NULL  
			AND   E.TOKEN IS NULL
		END					
PRINT @p_program_id +' : A016--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
		IF ( @p_dept_id <> 'ALL')
		BEGIN		
			-----------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2024-50461] Team Mapping (START)
			-- 기타매출은 기존 SALE SITE 정보를 이용하므로 검색시도 구분해야함	
			-----------------------------------------------------------------------------------------------------------------------------------		
			-----------------------------------------------------------------------------------------------------------------------------------
			--기타매출 이외
			-----------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B 
						 ON A.ITEM_ID		= B.ITEM_ID 
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
						AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,',')) C	
						 ON B.DEPT_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
			AND   A.FCST_TYPE <> 'ETC'
					
			-----------------------------------------------------------------------------------------------------------------------------------
			--기타매출(40 이외 사업부)		
			-----------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) 
						 ON A.SCM_SITE_ID = B.SCM_SITE_ID 
						AND B.DIVISION_ID = @P_DIVISION_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,',')) C	
						 ON B.DEPT_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
			AND   A.FCST_TYPE = 'ETC' 
			AND A.DIVISION_ID <> '40' --[PJ2024-50611] 40 이외 사업부는 기타일 경우 SCM_MST_SITE 에서 가져옴
		
			-----------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2024-50611]_기타매출(40사업부) (START)
			-----------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id,',')) C	
						 ON A.ATTRIBUTE1 = C.TOKEN --[PJ2024-50611] 40사업부 기타매출은 ATTRIBUTE1 에 부서코드 있음
			WHERE C.TOKEN IS NULL
			AND   A.FCST_TYPE	= 'ETC' 
			AND   A.DIVISION_ID = '40'
			-----------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2024-50611]기타매출(40사업부) (END)
			-----------------------------------------------------------------------------------------------------------------------------------
			/*
				IF ( @P_DIVISION_ID = '40')
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_dept_id,',') 
									) C	ON B.DEPT_ID = C.TOKEN
					WHERE C.TOKEN IS NULL
				END
				ELSE
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					LEFT OUTER JOIN SCM_MST_SITE B WITH (NOLOCK) ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = @P_DIVISION_ID
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_dept_id,',') 
									) C	ON B.DEPT_ID = C.TOKEN
					WHERE C.TOKEN IS NULL
				END
				*/
			-----------------------------------------------------------------------------------------------------------------------------------
			--[PJ2024-50461] Team Mapping end
			-----------------------------------------------------------------------------------------------------------------------------------
		END
PRINT @p_program_id +' : A017--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
				
		IF ( @p_end_customer <> 'ALL')
		BEGIN
			IF ( @P_DIVISION_ID = '40')
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_end_customer,',')) C	
							 ON A.PROJECT_CODE = C.TOKEN
				WHERE C.TOKEN IS NULL
			END
			ELSE
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) 
							 ON A.SCM_SITE_ID = B.SCM_SITE_ID 
							AND B.DIVISION_ID = @P_DIVISION_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_end_customer,',')) C	
							 ON B.END_CUSTOMER = C.TOKEN
				WHERE C.TOKEN IS NULL
			END
		END
PRINT @p_program_id +' : A018--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
				
		IF ( @p_scm_site_id <> 'ALL')
		BEGIN
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN (	SELECT DISTINCT token FROM dbo.String_Split(@p_scm_site_id,',')) C	
						 ON A.SCM_SITE_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
		END
				
		IF ( @p_plant_site_id <> 'ALL')
		BEGIN
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN ( SELECT DISTINCT token	FROM dbo.String_Split(@p_plant_site_id,',')) C	
						 ON A.PLANT_SITE_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
		END
PRINT @p_program_id +' : A019--' + CONVERT(VARCHAR(30), GETDATE(), 121);	

		IF ( @p_item_type <> 'ALL')
		BEGIN
			DELETE A
			FROM #RAW_DATA A
			LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B 
						 ON A.ITEM_ID = B.ITEM_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token	FROM dbo.String_Split(@p_item_type,',')) C	
						 ON B.ITEM_TYPE = C.TOKEN
			WHERE C.TOKEN IS NULL
		END

		IF ( @p_biztype <> 'ALL')
		BEGIN
			IF( @P_DIVISION_ID = '40' )
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B 
							 ON A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_biztype,',')) C	
							 ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
				WHERE C.TOKEN IS NULL
			END
			ELSE
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				JOIN SCM_MST_PROJECT B WITH(NOLOCK) 
				  ON A.DIVISION_ID	= B.DIVISION_ID 
				 AND A.PROJECT_CODE = B.PROJECT_CODE
				LEFT OUTER JOIN ( SELECT DISTINCT token	FROM dbo.String_Split(@p_biztype,',')) C	
							 ON B.BIZ_TYPE LIKE '%' + C.TOKEN + '%'
				WHERE C.TOKEN IS NULL
			END
		END
	END 
	--=================================================================================================================================
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 ) (END) 
	--=================================================================================================================================
PRINT @p_program_id +' : A020--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- 실적구간 PRICE 처리 (START)
	--=================================================================================================================================	
	-----------------------------------------------------------------------------------------------------------------------------------
	-- LOC 메져 생성		
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'LOC')
	BEGIN
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC' AS MEASURE, A.YYYYMMDD
			 , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			   FROM #RAW_DATA A WITH(NOLOCK)
			   WHERE YYYYMMDD >= @v_start_yyyymmdd 
			   AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
								   ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
							  END
			   AND A.MEASURE = 'RTF_SYS_RP'
			   GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					  , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					  , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 ) A
		JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
		  			, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			   FROM #RAW_DATA AS A WITH(NOLOCK)
			   WHERE YYYYMMDD >= @v_start_yyyymmdd 
			   AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
								   ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
							  END
			   AND A.MEASURE = 'SalesAmt_LOC'
			   GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					  , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT,A.INCOTERMS, A.DOM_EXP
					  , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			  ) B 
		  ON A.VERSION_NO				= B.VERSION_NO 
		 AND A.DIVISION_ID				= B.DIVISION_ID
		 AND A.PROJECT_CODE				= B.PROJECT_CODE
		 AND A.SCM_SITE_ID				= B.SCM_SITE_ID
		 AND A.PLANT_SITE_ID			= B.PLANT_SITE_ID
		 AND A.ITEM_ID					= B.ITEM_ID
		 AND A.INCOTERMS				= B.INCOTERMS
		 AND A.DOM_EXP					= B.DOM_EXP
		 AND A.FCST_TYPE				= B.FCST_TYPE
		 AND A.CURRENCY					= B.CURRENCY
		 AND A.YYYYMMDD					= B.YYYYMMDD
		 AND ISNULL(A.COMPANY_ID,'')	= ISNULL(B.COMPANY_ID,'')
		 AND A.CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	END
PRINT @p_program_id +' : A021--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	-----------------------------------------------------------------------------------------------------------------------------------
	-- KRW 메져 생성		
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'KRW' )
	BEGIN
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW' AS MEASURE, A.YYYYMMDD
			 , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					,A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #RAW_DATA A WITH(NOLOCK)
				WHERE YYYYMMDD >= @v_start_yyyymmdd 
				AND   YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
									  ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
								 END
				AND	  A.MEASURE = 'RTF_SYS_RP'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					   , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					   , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
					   , A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 ) A
		JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
		  			, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #RAW_DATA A WITH(NOLOCK)
				WHERE YYYYMMDD >= @v_start_yyyymmdd 
				AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd
									ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)
							   END
				AND A.MEASURE = 'SalesAmt_KRW'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					   , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					   , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			) B 
		  ON A.VERSION_NO				= B.VERSION_NO 
		 AND A.DIVISION_ID				= B.DIVISION_ID
		 AND A.PROJECT_CODE				= B.PROJECT_CODE
		 AND A.SCM_SITE_ID				= B.SCM_SITE_ID
		 AND A.PLANT_SITE_ID			= B.PLANT_SITE_ID
		 AND A.ITEM_ID					= B.ITEM_ID
		 AND A.INCOTERMS				= B.INCOTERMS
		 AND A.DOM_EXP					= B.DOM_EXP
		 AND A.FCST_TYPE				= B.FCST_TYPE
		 AND A.CURRENCY					= B.CURRENCY
		 AND A.YYYYMMDD					= B.YYYYMMDD
		 AND ISNULL(A.COMPANY_ID,'')	= ISNULL(B.COMPANY_ID,'')
		 AND A.CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	END
	--=================================================================================================================================
	-- 실적구간 PRICE 처리 (END)
	--=================================================================================================================================	
PRINT @p_program_id +' : A022--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- 계획구간 PRICE 처리 (START)
	--=================================================================================================================================
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 'KRW', 'LOC', 'USD' 메져 생성		
	-- 40사업부 PRICE: DM_PLN_CFM_SELLING_PRICE 테이블 사용, 타 사업부 PRICE: SCM_MST_FUTURE_PRICE
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD'))
	BEGIN
		IF ( @P_DIVISION_ID = '40') 
		BEGIN
			INSERT INTO #RAW_DATA 
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
			, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
				 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
				 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
						, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				   FROM	#RAW_DATA A
				   WHERE A.YYYYMMDD >= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd
				   AND   A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up' )--[PJ2024-50611] Catch_Up 추가
				  ) A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) 
			  ON A.YYYYMMDD				= B.BASIS_YYYYMMDD
			JOIN DM_PLN_CFM_SELLING_PRICE C WITH(NOLOCK) 
			  ON A.DIVISION_ID			= C.DIVISION_ID
			 AND A.PROJECT_CODE			= C.PROJECT_CODE
			 AND A.SCM_SITE_ID			= C.SCM_SITE_ID
			 AND A.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
			 AND A.ITEM_ID				= C.ITEM_ID
			 AND A.INCOTERMS			= C.INCOTERMS
			 AND A.DOM_EXP				= C.DOM_EXP
			 AND A.FCST_TYPE			= C.FCST_TYPE
			 AND B.BASIS_START_DATE		= C.YYYYMMDD
			 AND C.YYYYMMDD				<= @p_to_yyyymmdd
			JOIN #SELECT_MEASURE D 
			  ON C.MEASURE				= D.MEASURE
		END
		ELSE -- ( @P_DIVISION_ID <> '40')
		BEGIN
			INSERT INTO #RAW_DATA 
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
			, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
				 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
				 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
						 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
						 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				   FROM	#RAW_DATA A
				   WHERE A.YYYYMMDD >= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd
				   AND   A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up' )--[PJ2024-50611] Catch_Up 추가
				 ) A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) 
			  ON A.YYYYMMDD			= B.BASIS_YYYYMMDD
			JOIN SCM_MST_FUTURE_PRICE C WITH(NOLOCK) 
			  ON A.DIVISION_ID		= C.DIVISION_ID
			 AND A.PROJECT_CODE		= C.PROJECT_CODE
			 AND A.SCM_SITE_ID		= C.SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= C.PLANT_SITE_ID
			 AND A.ITEM_ID			= C.ITEM_ID
			 AND A.INCOTERMS		= C.INCOTERMS
			 AND A.DOM_EXP			= C.DOM_EXP
			 AND A.FCST_TYPE		= C.FCST_TYPE
			 AND B.basis_start_date	= C.YYYYMMDD
			 AND C.YYYYMMDD			<= @p_to_yyyymmdd
			JOIN #SELECT_MEASURE D 
			  ON C.MEASURE = D.MEASURE
		END
	END
	--=================================================================================================================================
	-- 계획구간 PRICE 처리 (END)
	--=================================================================================================================================
PRINT @p_program_id +' : A023--' + CONVERT(VARCHAR(30), GETDATE(), 121);	

	--=================================================================================================================================
	-- 필요없는 메저 삭제 (START) -> 사용자가 선택한 메져가 아니라, 메져를 만들기 위해 임의로 추가한 메져를 삭제한다.
	--=================================================================================================================================
	DELETE A
	FROM #RAW_DATA A
	JOIN #SELECT_MEASURE B 
	  ON A.MEASURE = B.MEASURE
	WHERE B.SYSTEM_ADD = 'Y'	
	--=================================================================================================================================
	-- 필요없는 메저 삭제 (END)
	--=================================================================================================================================	
	--=================================================================================================================================
	-- 물리적으로 생성하지 않는 메져의 경우 하단에서 생성해준다 (START)
	-- MEASURE: 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY'
	-- 화면: MKT FCST[R+P] CAR, MKT FCST[R+P] CELL, RTF[R+P] CAR, RTF[R+P] CELL, RTF[R+P] Energy(MWH), MKT FCST[R+P] Energy(MWH)
	--=================================================================================================================================
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY'))
	BEGIN			
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
			 , CASE	WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') 
					THEN CASE WHEN CHARINDEX('Cell',   C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR
							  WHEN  CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0  AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN QTY/ ( D.CELL_PER_CAR/ D.CELL_PER_MODULE )
							  WHEN  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0  THEN A.QTY
							  ELSE 0 
						 END 
					WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' 
					THEN CASE WHEN CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
							  WHEN ( CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', C.ITEM_CLASS_NAME) > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
							  ELSE 0 
						 END
					WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
					-----------------------------------------------------------------------------------------------------------------------------------
					-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
					-----------------------------------------------------------------------------------------------------------------------------------
					WHEN B.MEASURE_CALC = 'RTF_ENERGY' 
					THEN CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (A.QTY * C.ENERGE)/1000	END
					-----------------------------------------------------------------------------------------------------------------------------------
					-- 20221214 ROSIA27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
					-----------------------------------------------------------------------------------------------------------------------------------
					WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' 
					THEN CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (A.QTY * C.ENERGE)/1000	END
					ELSE 0 
				END
			 , A.PLAN_RESULT 
			 , A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A WITH(NOLOCK)
		JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP' 
						   ELSE 'RTF_SYS_RP'
					  END AS MEASURE_ORI
					, A.MEASURE AS MEASURE_CALC
				FROM #SELECT_MEASURE A
				WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY')
			  ) B 
		  ON A.MEASURE		= B.MEASURE_ORI
		JOIN #TEMP_DM_MST_ITEM_SINGLE_V C 
		  ON A.ITEM_ID		= C.ITEM_ID 
		 AND A.DIVISION_ID	= C.DIVISION_ID
		LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D 
					 ON A.DIVISION_ID	= D.DIVISION_ID 
					AND A.SCM_SITE_ID	= D.SCM_SITE_ID 
					AND A.PROJECT_CODE	= D.PROJECT_CODE 
					AND A.ITEM_ID		= D.ITEM_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' )
	END	
	--=================================================================================================================================
	-- 물리적으로 생성하지 않는 메져의 경우 하단에서 생성해준다 (END)
	--=================================================================================================================================
PRINT @p_program_id +' : A024--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- 20221214 ROSIA27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy (START)
	--=================================================================================================================================
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ('MKT_FCST_ENERGY'))
	BEGIN
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
			 , CASE	WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'MKT_FCST_RP' AND A.PLAN_RESULT = 'P' 
					THEN CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (A.QTY * C.ENERGE)/1000	END
					ELSE 0 
			   END
			 , A.PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A WITH(NOLOCK)
		JOIN ( SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC
		   	   FROM #SELECT_MEASURE A
			   WHERE MEASURE IN ('MKT_FCST_ENERGY')
			  ) B 
		  ON A.MEASURE		= B.MEASURE_ORI
		JOIN #TEMP_DM_MST_ITEM_SINGLE_V C 
		  ON A.ITEM_ID		= C.ITEM_ID 
		 AND A.DIVISION_ID	= C.DIVISION_ID
		LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D 
					 ON A.DIVISION_ID	= D.DIVISION_ID
					AND A.SCM_SITE_ID	= D.SCM_SITE_ID 
					AND A.PROJECT_CODE	= D.PROJECT_CODE 
					AND A.ITEM_ID		= D.ITEM_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP')
	END
	--=================================================================================================================================
	-- 20221214 ROSIA27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy (END)
	--=================================================================================================================================
PRINT @p_program_id +' : A025--' + CONVERT(VARCHAR(30), GETDATE(), 121);		
	--=================================================================================================================================
	-- 컬럼리스트 생성 (START)
	--=================================================================================================================================
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
	-----------------------------------------------------------------------------------------------------------------------------------	
	BEGIN
		DECLARE @v_sql_text			AS NVARCHAR(MAX);
		DECLARE @V_PV_LIST			AS NVARCHAR(MAX);
		DECLARE @V_PV_COL_LIST		AS NVARCHAR(MAX);
		DECLARE @v_column_name		AS NVARCHAR(100);
		DECLARE @v_column           AS NVARCHAR(1000);
		DECLARE @v_orderby          AS NVARCHAR(1000);
		DECLARE @v_column_text      AS NVARCHAR(1000);
		DECLARE @v_PV_column_name   AS NVARCHAR(100);
		DECLARE @v_PV_NAME			AS NVARCHAR(50);
		DECLARE @v_column_type      AS NVARCHAR(50);
		
		DECLARE @v_column_value     AS NVARCHAR(50);
		DECLARE @v_sort_order_no    AS NVARCHAR(50);
		DECLARE @v_sum_qty			AS NVARCHAR(1000);
		DECLARE @v_qty_div			AS NVARCHAR(1000);
		DECLARE @v_avg_qty			AS NVARCHAR(1000);
    
		-----------------------------------------------------------------------------------------------------------------------------------
		--날짜컬럼 
		-----------------------------------------------------------------------------------------------------------------------------------
		SELECT @V_PV_LIST = '', @V_PV_COL_LIST = ''
		DECLARE c_bucket CURSOR FAST_FORWARD FOR 

		SELECT '[D_' + a.basis_yyyymmdd + '] AS D_' + A.BASIS_YYYYMMDD AS COLUMN_NAME
				, '[D_' + a.basis_yyyymmdd + ']' AS PV_NAME
				, A.BASIS_YYYYMMDD + '_' + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
		FROM  SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
		WHERE A.BASIS_YYYYMMDD >= @p_from_yyyymmdd -- '20171101'  CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
		AND   A.BASIS_YYYYMMDD <= @p_to_yyyymmdd   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
		AND	  @P_BUCKET = 'DAILY'
		UNION ALL
		SELECT '[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + '] AS W_' + A.BASIS_YYYYMM + A.ISO_WEEK AS COLUMN_NAME
				, '[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + ']' AS PV_NAME
				, A.BASIS_START_DATE + '_' + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
		FROM  SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
		WHERE A.BASIS_YYYYMMDD >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
		AND   A.BASIS_YYYYMMDD <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
		GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
		UNION ALL
		SELECT '[M_' + A.BASIS_YYYYMM + '] AS M_' + A.BASIS_YYYYMM AS COLUMN_NAME
				, '[M_' + A.BASIS_YYYYMM + ']' AS PV_NAME
				, MIN(A.BASIS_START_DATE) + '_' + CONVERT(CHAR(2), 1) AS SORT_ORDER_NO
		FROM   SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
		WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
		AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
		GROUP BY A.BASIS_YYYYMM
		ORDER BY SORT_ORDER_NO;

		OPEN c_bucket;
		FETCH NEXT FROM c_bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
									WHILE @@FETCH_STATUS = 0   
		BEGIN  
			SELECT @V_PV_COL_LIST	= @V_PV_COL_LIST + CASE WHEN @V_PV_COL_LIST <> '' THEN ',' ELSE '' END + @v_PV_column_name
					, @V_PV_LIST		= @V_PV_LIST + CASE WHEN @V_PV_LIST <> '' THEN ',' ELSE '' END + @v_PV_name
    
			FETCH NEXT FROM c_Bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
		END;

		CLOSE c_bucket;  
		DEALLOCATE c_bucket;

PRINT @p_program_id +' : A026--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
			
		-----------------------------------------------------------------------------------------------------------------------------------
        /* 20240518 KCW3408 속도개선_템프사용 */
		-----------------------------------------------------------------------------------------------------------------------------------
		BEGIN
			SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN
				 , B.END_CUSTOMER, H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION  					 
				 , B.ATTRIBUTE3  --20240913 SM 임시작업 존재하지 않는 경우 화면 오류 발생으로 임의로 지정함
			INTO #TEMP_SCM_MST_SITE      
			FROM SCM_MST_SITE B WITH(NOLOCK)  
			LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K WITH(NOLOCK)
					     ON B.DIVISION_ID	= K.DIVISION_ID 
					    AND B.SCM_SITE_ID	= K.SCM_SITE_ID 
					    AND K.REP_YN		= 'Y'    
			LEFT OUTER JOIN SCM_MST_CITY H WITH(NOLOCK)
						 ON B.CITY = H.CITY     
			LEFT OUTER JOIN SCM_MST_COUNTRY J WITH(NOLOCK) 
						 ON B.COUNTRY = J.COUNTRY      
			LEFT OUTER JOIN SCM_MST_CUSTOMER L WITH(NOLOCK)
						 ON K.DIVISION_ID = L.DIVISION_ID 
						AND K.SHIPTO_CODE = L.SHIPTO_CODE 
						AND K.SOLDTO_CODE = L.SOLDTO_CODE
		END
		
		-----------------------------------------------------------------------------------------------------------------------------------
		-- 일반 컬럼
		-----------------------------------------------------------------------------------------------------------------------------------
		SET @v_column_name = '';
		SET @v_column = '';
		SET @v_orderby = '';
			
		SELECT  @i_Count = Count(*)
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = @p_Program_Id
		AND    U.SHEET_NAME  = @p_sheet_name
		AND    U.USER_ID     = @p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		
PRINT @p_program_id +' : A027--' + CONVERT(VARCHAR(30), GETDATE(), 121);
		IF @i_Count = 0 
		BEGIN
			SELECT @ColList		= @ColList + '[' + COLUMN_NAME + '],'
				 , @OrderList	= @OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
			FROM 
			(-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
			  SELECT --TOP 100 
			  	   C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
			  FROM SCM_MST_SHEET_COLUMNS C WITH(NOLOCK)
			  WHERE 1 = 1
			  AND   C.PROGRAM_ID  = @p_Program_Id
			  AND   C.SHEET_NAME  = @p_sheet_name
			  AND ( C.DEFAULT_FLAG = 'Y' OR ( C.VISIBLE_FLAG = 'N' AND C.DEFAULT_FLAG = '' AND C.VALID_YN = 'Y' ))  
			) tbColList	
			ORDER BY SORT_ORDER_NO
		END
		ELSE 
		BEGIN
			SELECT @ColList		= @ColList + '[' + COLUMN_NAME + '],'
				 , @OrderList	= @OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
			FROM 
			( -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
				SELECT --TOP 100 
						U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE  
				FROM SCM_MST_TITLESET_USER U WITH(NOLOCK)
				INNER JOIN SCM_MST_SHEET_COLUMNS C WITH(NOLOCK)
						ON U.PROGRAM_ID		= C.PROGRAM_ID
					   AND U.SHEET_NAME		= C.SHEET_NAME
					   AND U.COLUMN_NAME	= C.COLUMN_NAME
					   AND U.PROGRAM_ID		= @p_Program_Id
					   AND U.SHEET_NAME		= @p_sheet_name
					   AND U.USER_ID		= @p_created_by
					   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'   
					 --AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	-- 20190125 일단 주석처리 KHSONG
				---------
				UNION ALL
				-----------------------------------------------------------------------------------------------------------------------------------
				/* 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
				-----------------------------------------------------------------------------------------------------------------------------------
				SELECT TOP 100 
					CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  ISNULL(U.SORT_ORDER_NO,85) - 0.5 
						 -- [PJ2024-50611] Catch Up 입력가능 : 수정여부 필드(순서 400)가 MEASURE(순서 500) 앞에서 정렬되어 메저 순서가 제대로 표시되지 않으므로 MEASURE 뒤로 돌림(510으로 만듬) --START
						 WHEN C.COLUMN_NAME = 'SALES_PLAN_ADJUST_YN' THEN ISNULL(C.SORT_ORDER_NO,400) + 110 
						 -- [PJ2024-50611] Catch Up 입력가능 : 수정여부 필드(순서 400)가 MEASURE(순서 500) 앞에서 정렬되어 메저 순서가 제대로 표시되지 않으므로 MEASURE 뒤로 돌림(510으로 만듬) --END
						 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
					, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
				FROM SCM_MST_SHEET_COLUMNS C WITH(NOLOCK)
				LEFT OUTER JOIN SCM_MST_TITLESET_USER U WITH(NOLOCK)
						     ON U.PROGRAM_ID	= C.PROGRAM_ID
							AND U.SHEET_NAME	= C.SHEET_NAME 
							AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'C' 
							AND U.COLUMN_NAME IN ('ITEM_ID') 
							AND U.USER_ID		= @p_created_by
				WHERE  1 = 1
				AND C.PROGRAM_ID	= @p_Program_Id
				AND C.SHEET_NAME	= @p_sheet_name
				AND C.VISIBLE_FLAG	= 'N'
				AND C.DEFAULT_FLAG	= ''
				AND C.VALID_YN		= 'Y'
				--AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	 -- 20190125 일단 주석처리 KHSONG
				) tbColList	
				ORDER BY SORT_ORDER_NO
		END
		
		SELECT @ColList		= LEFT(@ColList, LEN(@ColList)-1)	
		SELECT @OrderList	= LEFT(@OrderList, LEN(@OrderList)-1)	
			
		--SELECT @ColList = REPLACE(@ColList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')
		--SELECT @OrderList = REPLACE(@OrderList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')
		--[E20231128-000738]해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
		SELECT @ColList		= @ColList + ',[NOTATION]'
		SELECT @ColList		= REPLACE(@ColList,'[VERSION_NO]','[VERSION_SORT],[VERSION_NO]')
		SELECT @OrderList	= REPLACE(@OrderList,'[VERSION_NO]','[VERSION_SORT] DESC,[VERSION_NO]')
		SELECT @OrderList	= REPLACE(@OrderList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')
			
	END	
	--=================================================================================================================================
	-- 컬럼리스트 생성 (END)
	--=================================================================================================================================/
PRINT @p_program_id +' : A028--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	--=================================================================================================================================
	-- SHIPMENT 컬럼 (START)
	--=================================================================================================================================
	--[PJ20200138] Shipment Site 임시테이블 추가
	DECLARE @v_SHIP_DIVISION_ID				NVARCHAR(30)
		  , @v_SHIP_PLAN_START_YYYYMMDD		NVARCHAR(8) 
		  , @v_SHIP_PLAN_TYPE				NVARCHAR(50) 
		  , @v_SHIP_PPLAN_SEQ				INT
		  , @v_SHIP_PPLAN_ID				NVARCHAR(30) 
		  , @v_SHIP_PMODELING_ID			NVARCHAR(30) 
			
	IF @ColList LIKE N'%SHIPMENT_SITE%' AND @P_DIVISION_ID = '82'
	BEGIN
		SELECT @v_SHIP_DIVISION_ID			= DIVISION_ID
			 , @v_SHIP_PLAN_START_YYYYMMDD	= PLAN_START_YYYYMMDD
			 , @v_SHIP_PLAN_TYPE			= PLAN_TYPE
			 , @v_SHIP_PPLAN_SEQ			= PLAN_SEQ
			 , @v_SHIP_PPLAN_ID				= PLAN_ID
			 , @v_SHIP_PMODELING_ID			= MODELING_ID
		FROM (  SELECT *
				FROM ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
							, ROW_NUMBER() OVER ( ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC ) ROW_NUM 
					   FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
					   WHERE  1=1
					   AND    DIVISION_ID	= '82'
					   AND    PLAN_CYCLE   = 'WEEKLY'
					   AND    PLAN_TYPE	= 'FN'
					   AND    PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -60, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) A
			  ) PV
		WHERE PV.ROW_NUM = 1

		-- 2020.11.26 hwi1993	FROM_SITE 를 MAX 값으로 변경 ( 안그러면 모델의 생산지를 변경할 경우 중복오류남 )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE AS SCM_SITE_ID, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE
		INTO #TEMP_SHIPMENT_SITE_ROW --[C20201202-000394][ESS] Shipment Site(생산지) 중복 콤마(,) 처리
		FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)							
		INNER JOIN SCM_SYS_CALENDAR_M O WITH(NOLOCK) 
				ON A.YYYYMMDD = O.basis_yyyymmdd
		LEFT OUTER JOIN ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE
							   , MAX(REPLACE(SUBSTRING(ENG_DEMAND_ID, CHARINDEX(N'::', ENG_DEMAND_ID, CHARINDEX(N'::', ENG_DEMAND_ID, CHARINDEX(N'::', ENG_DEMAND_ID, CHARINDEX(N'::', ENG_DEMAND_ID)+1)+1)+1)+2, 3), ':', '')) AS FCST_TYPE
						  FROM   SCP_ANL_PROBLEM_REPORT_PEGGING WITH(NOLOCK)
						  WHERE  DIVISION_ID			= @v_SHIP_DIVISION_ID
						  AND    PLAN_START_YYYYMMDD	= @v_SHIP_PLAN_START_YYYYMMDD
						  AND    PLAN_TYPE				= @v_SHIP_PLAN_TYPE
						  AND    SEQ					= @v_SHIP_PPLAN_SEQ
						  AND    PEGGING_OPERATION_CODE IN ( 'CSHIP', 'PSHIP' )
						  GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE ) FC 
					 ON  A.ITEM_ID		= FC.ITEM_ID 
					 AND A.FROM_SITE	= FC.FROM_SITE 
					 AND A.TO_SITE		= FC.TO_SITE
		WHERE A.DIVISION_ID			= @v_SHIP_DIVISION_ID
		AND   A.PLAN_START_YYYYMMDD	= @v_SHIP_PLAN_START_YYYYMMDD
		AND   A.PLAN_TYPE			= @v_SHIP_PLAN_TYPE
		AND   A.SEQ					= @v_SHIP_PPLAN_SEQ
		AND   A.MEASURE				= 'SHIP_PLAN'
		AND   A.QTY					> 0 
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE
		
		--[C20201202-000394][ESS] Shipment Site(생산지) 중복 중복 콤마(,) 처리
		INSERT INTO #TEMP_SHIPMENT_SITE 
		( DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE, SHIPMENT_SITE )
		SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE
			 , ISNULL([1],'') 
				+ CASE WHEN [2] IS NULL THEN '' ELSE ',' + [2] END
				+ CASE WHEN [3] IS NULL THEN '' ELSE ',' + [3] END
				+ CASE WHEN [4] IS NULL THEN '' ELSE ',' + [4] END
				+ CASE WHEN [5] IS NULL THEN '' ELSE ',' + [5] END AS SHIPMENT_SITE
		FROM (  SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS
					 , A.FCST_TYPE, A.FROM_SITE
					 , ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS, A.FCST_TYPE ORDER BY A.FROM_SITE) AS ROW_NUM
				FROM #TEMP_SHIPMENT_SITE_ROW A	) A
		PIVOT (	MAX(FROM_SITE) FOR ROW_NUM IN ( [1], [2], [3], [4], [5] )) AS PVT
	END
PRINT @p_program_id +' : A030--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
	--=================================================================================================================================
	-- SHIPMENT 컬럼 (END)
	--=================================================================================================================================
	-----------------------------------------------------------------------------------------------------------------------------------
	/* 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
	UI Category Setup 에 등록(GROUP_ID) ORDER BY 필요, GROUP_ID 추가함 */
	-----------------------------------------------------------------------------------------------------------------------------------
	BEGIN	-- CTE 에서 사용할 SELECT COLUMN 정리			
		DECLARE @V_SQL_SELECT	NVARCHAR(4000)
		DECLARE @V_SQL_GROUPBY	NVARCHAR(4000)

		IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP', N'U') IS NOT NULL 			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (20250718 SQL VALIDATOR에 의해 추가됨.)
			DROP TABLE #T_COLUMN_SETUP;	

		CREATE TABLE #T_COLUMN_SETUP 
		( TBL_ALIAS			NVARCHAR(10)
		, COLUMN_NAME		NVARCHAR(100)
		, COLUMN_STRING		NVARCHAR(1000)
		, SORT_KEY			INT	)
			
 		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'VERSION_NO', 'A.VERSION_NO', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'DIVISION_ID', 'A.DIVISION_ID', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE', 'A.PROJECT_CODE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID', 'A.SCM_SITE_ID', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'PLANT_SITE_ID', 'A.PLANT_SITE_ID', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'GROUP_ID', 'ISNULL(I.GROUP_ID,'' '') AS GROUP_ID', 1)

		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID', 'A.ITEM_ID', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'TEXT','CASE WHEN LEN(A.TEXT) = 0   THEN '' '' ELSE A.TEXT END  AS TEXT' , 1) 
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'TEXT4082','CASE WHEN LEN(A.TEXT) = 0   THEN '' '' ELSE A.TEXT END  AS TEXT4082' , 1) --[PJ2024-50611]40, 82용 text 컬럼 추가
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'INCOTERMS', 'A.INCOTERMS', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'DOM_EXP', 'A.DOM_EXP', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'FCST_TYPE', 'A.FCST_TYPE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'MEASURE', 'A.MEASURE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'INTERNAL_YN', 'CASE WHEN LEN(A.SCM_SITE_ID) > 2 AND LEN(A.SCM_SITE_ID) < 6  THEN ''Y'' ELSE ''N'' END AS INTERNAL_YN', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'YYYYMMDD', 'A.YYYYMMDD', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'QTY', 'A.QTY', 1)
		--INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'QTY', 'FORMAT(A.QTY,''#,##0.##########'')', 1)
			
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'VMI_YN', 'B.VMI_YN', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'END_CUSTOMER', 'ISNULL(B.END_CUSTOMER,'' '') AS END_CUSTOMER', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'AC', 'CURRENCY', 'CASE WHEN A.CURRENCY <> '''' THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY', 1)

		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID', 1) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		-----------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 (START)
		-----------------------------------------------------------------------------------------------------------------------------------
		--INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID', 1)
		--INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'C.DEPT_ID', 1)
		--INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN B.DEPT_ID ELSE C.DEPT_ID END AS DEPT_ID', 1)----[PJ2024-50461]
		-----------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 (END)
		-----------------------------------------------------------------------------------------------------------------------------------		
		-----------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) (START)
		-----------------------------------------------------------------------------------------------------------------------------------
		--기존 case에서 한번 더 분기
		/*	1.40사업부
				- FCST_TYPE = ETC
				=> ATTRIBUTE1 
				- ELSE
				=>SCM_MST_SITE_ITEM : 기존 그대로

			2.그 외 사업부
				- FCST_TYPE = 'ETC'
				=> SCM_MST_SITE : 기존 그대로
				- ELSE
				=>SCM_MST_SITE_ITEM : 기존 그대로	*/
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID', 1)
		-----------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) (END)
		-----------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'APPLICATION', 'C.APPLICATION', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP', 'C.CUST_GROUP', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'OWNER', 'C.OWNER_NAME AS OWNER', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'ROUTE', 'C.ROUTE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP_DTL', 'C.CUST_GROUP_DTL', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_CAR', 'C.CELL_PER_CAR', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_MODULE', 'C.CELL_PER_MODULE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'AC', 'COMPANY_ID', 'CASE WHEN ISNULL(A.COMPANY_ID, '''') = '''' THEN C.SALES_COMPANY ELSE A.COMPANY_ID END AS COMPANY_ID', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'MODULE_PER_CAR', 'CASE WHEN C.CELL_PER_MODULE  <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'DMS_SALES', 'ISNULL(C.ATTRIBUTE1,'''') AS DMS_SALES', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'DMS_CUSTOMER', 'ISNULL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL', 'C.ATTRIBUTE5 AS CELL_MODEL', 1) --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'PRIORITY', 'C.ATTRIBUTE7 AS PRIORITY', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'KWH_CELL', 'C.ATTRIBUTE8 AS KWH_CELL', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL_INFO', 'ISNULL(C.REPORT_GROUP6,'''') AS CELL_MODEL_INFO', 1) --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'AC', 'KWH_MODULE', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_MODULE * C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'AC', 'KWH_PACK', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_CAR * C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'ENERGE', 'D.ENERGE', 1)
		
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'ENERGE_WH', 'D.ENERGE_WH', 1) --[E20240731-000852]_40 사업부 용 ENERGE 컬럼 추가
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'CELL_QUANTITY', 'D.CELL_QUANTITY', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'ITEM_CLASS_NAME', 'ISNULL(D.ITEM_CLASS_NAME, '''') AS ITEM_CLASS_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'ITEM_NAME', 'ISNULL(D.ITEM_NAME, '''') AS ITEM_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'ITEM_TYPE', 'ISNULL(D.ITEM_TYPE, '''') AS ITEM_TYPE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'NICK_NAME', 'ISNULL(D.NICK_NAME, '''') AS NICK_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'MIN_CAPACITY', 'D.MIN_CAPACITY', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'E', 'CELL_TYPE', 'E.SEGMENT2 AS CELL_TYPE', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'F', 'CELL_MODEL_NICK_NAME', 'ISNULL(F.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'BIZ_TYPE_NAME', 'G.BIZ_TYPE AS BIZ_TYPE_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PROJECT_NAME', 'G.PROJECT_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PROJECT_OWNER', 'G.PROJECT_OWNER', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PROJECT_STATUS', 'G.PROJECT_STATUS', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PRODUCT_GROUP_NAME', 'G.PRODUCT_GROUP_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'CITY_NAME', 'B.CITY_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'COUNTRY_NAME', 'B.COUNTRY_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'SHIPTO_DESCRIPTION', 'B.SHIPTO_DESCRIPTION', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'M', 'SORT_ORDER_NO', 'M.SORT_ORDER_NO', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'CELL_NAME', 'C.ATTRIBUTE9 AS CELL_NAME', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'DISTRIBUTION_CHANNEL', 'B.ATTRIBUTE3 AS DISTRIBUTION_CHANNEL', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'SALES_COMPANY', 'C.SALES_COMPANY', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'SALES_PLANT', 'C.SALES_PLANT', 1)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'N', 'SHIPMENT_SITE', 'N.SHIPMENT_SITE', 1)		
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'O', 'SEGMENT3', 'ISNULL(O.SEGMENT3, ''DEFAULT'') AS NOTATION', 1) --[E20231128-000738]해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
		-----------------------------------------------------------------------------------------------------------------------------------
		--[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 (START)
		-----------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A','SCP_USE_YN', N'CASE  WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN ( ''VMI_In_Req'', ''VMI_In_Plan'')  THEN ''Y''							
																		WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN ( ''RTF_PR'',''MKT_FCST_RP'',''MKT_FCST'', ''RTF'',''RTF_SCP'',''RTF_SYS_RP'' ) THEN ''Y''										
																    ELSE ''N'' END AS SCP_USE_YN', 1)
		-----------------------------------------------------------------------------------------------------------------------------------
		--[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 (END)
		-----------------------------------------------------------------------------------------------------------------------------------
		--[E20260512-000502]_FROM SITE ID 컬럼 추가 (START)
		INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'FROM_SITE_ID', 'CASE WHEN ISNULL(A.CELL_PROD_SITE_ID,''-'') = ''-'' THEN ''N/A'' ELSE A.CELL_PROD_SITE_ID END AS FROM_SITE_ID', 1) 
		--[E20260512-000502]_FROM SITE ID 컬럼 추가 (END)


		SELECT B.COLUMN_STRING, ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
		INTO #T
		FROM  DBO.UF_FX_String_Split(@ColList, ',') A
		JOIN #T_COLUMN_SETUP B ON replace(replace(A.TOKEN, '[', ''), ']','') = B.COLUMN_NAME

		DECLARE @I INT, @CNT INT

		SELECT @I = 1, @CNT = COUNT(*), @V_SQL_SELECT = '', @V_SQL_GROUPBY = ''
		FROM #T

		WHILE ( @I <= @CNT )
		BEGIN
			SELECT @V_SQL_SELECT = @V_SQL_SELECT + CASE WHEN @I = 1 THEN '' ELSE ',' END + COLUMN_STRING
				 , @V_SQL_GROUPBY = @V_SQL_GROUPBY + CASE WHEN @I = 1 THEN '' ELSE ',' END 
												   + CASE WHEN PATINDEX(N'% AS %', COLUMN_STRING) > 0
														  THEN LEFT(COLUMN_STRING, PATINDEX(N'% AS %', COLUMN_STRING) -1)
														  ELSE COLUMN_STRING END
			FROM #T 
			WHERE SEQ = @I

			SET @I += 1
		END
	END
	----- [E20230619-000151] ss
	IF @p_division_id = '82'
	BEGIN
		SET @v_qty_div = 'CONVERT(float,FORMAT(A.QTY,N''##0.##########''))';
		--SET @v_qty_div = 'A.QTY';
		SET @v_sum_qty = 'SUM(QTY)';
		SET @v_avg_qty = 'AVG(QTY)';
	END
	ELSE
	BEGIN
		SET @v_qty_div = 'A.QTY';
		SET @v_sum_qty = 'SUM(QTY)';
		SET @v_avg_qty = 'AVG(QTY)';
	END
	---- [E20230619-000151] ee
	-----------------------------------------------------------------------------------------------------------------------------------
	--[E20231128-000738]숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 룩업테이블 추가
	-----------------------------------------------------------------------------------------------------------------------------------
	SET @v_sql_text = N'
	SELECT			
		' + @v_qty_div +   ' AS QTY
		, CASE WHEN ''' + @P_BUCKET + N''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
		, M.SORT_ORDER_NO
		, CASE WHEN D.ITEM_ID IS NULL THEN ''N_''
				--[PJ2024-50611]소형사업부는 원래대로 ETC만 수정 가능하게 처리 : 잘못 추가된 로직 제거 start
				--WHEN A.DIVISION_ID = ''40'' THEN ''N_''  --[PJ2024-50611] 소형사업부는 무조건 수정가능하게 N처리함
				--[PJ2024-50611]소형사업부는 원래대로 ETC만 수정 가능하게 처리 : 잘못 추가된 로직 제거 end
				WHEN A.DIVISION_ID = ''40'' AND A.MEASURE = ''Catch_Up'' THEN ''N_''  --소형사업부는 Catch Up도 수정 가능하게 처리
				--[E20260331-000648]_81, 81_JV도 RTF_SYS_RP 메져를 수정가능하도록 해당 내역 추가 (원소스 주석처리) (START)
				--WHEN A.DIVISION_ID = ''40'' AND A.MEASURE = ''RTF_SYS_RP'' THEN ''N_''  --소형사업부는 RTF_SYS_RP도 수정 가능하게 처리 --[E20260331-000648]_(원소스 주석처리)
				WHEN ( A.DIVISION_ID = ''40'' OR A.DIVISION_ID LIKE ''81%'') AND A.MEASURE = ''RTF_SYS_RP'' THEN ''N_''  --소형사업부는 RTF_SYS_RP도 수정 가능하게 처리--[E20260331-000648]_81, 81_JV사업부 추가
				--[E20260331-000648]_81, 81_JV도 RTF_SYS_RP 메져를 수정가능하도록 해당 내역 추가 (원소스 주석처리) (END)
				WHEN ISNULL(C.SALES_PLAN_ADJUST_YN,'''')=''N'' THEN ''N_''
				ELSE  ''Y_''
				END 
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 --start
		--+  CASE	WHEN ''' + @v_dept_list + N''' LIKE ''%''+ B.DEPT_ID +''%'' THEN ''Y''
		--+  CASE	WHEN ''' + @v_dept_list + N''' LIKE ''%''+ CASE WHEN A.FCST_TYPE = ''ETC'' THEN B.DEPT_ID ELSE C.DEPT_ID END +''%'' THEN ''Y''
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 --end
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) start
		+  CASE	WHEN ''' + @v_dept_list + N''' LIKE ''%''+ CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END +''%'' THEN ''Y''	
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) end
				WHEN ''' + @v_group_id + N''' =''ADMIN'' THEN ''Y'' 
			ELSE ''N''
			END as SALES_PLAN_ADJUST_YN
		, CAL.BASIS_YYYYMM, CAL.ISO_WEEK
		, ISNULL(O.SEGMENT3, ''DEFAULT'') AS NOTATION
		, [@SQL_SELECT]
	INTO #WF
	FROM #RAW_DATA A
    LEFT OUTER JOIN #TEMP_SCM_MST_SITE B WITH(NOLOCK)  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID   
	LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM		C (NOLOCK) ON  A.DIVISION_ID = C.DIVISION_ID	AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
	LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V	D (NOLOCK) ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E (NOLOCK) ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
	LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V	F (NOLOCK) ON D.DIVISION_ID = F.DIVISION_ID AND ISNULL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID
	LEFT OUTER JOIN SCM_MST_PROJECT				G (NOLOCK) ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE 
	LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL	I (NOLOCK) ON A.DIVISION_ID = I.DIVISION_ID	AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID 
	JOIN #SELECT_MEASURE						M ON A.MEASURE = M.MEASURE
	LEFT OUTER JOIN #TEMP_SHIPMENT_SITE			N ON A.DIVISION_ID = N.DIVISION_ID AND A.PROJECT_CODE = N.PROJECT_CODE AND A.SCM_SITE_ID = N.SCM_SITE_ID 
														AND A.ITEM_ID = N.ITEM_ID AND A.FCST_TYPE = N.FCST_TYPE AND A.INCOTERMS = N.INCOTERMS
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL O (NOLOCK) ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1
	JOIN SCM_SYS_CALENDAR_M						CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD AND CAL.BASIS_DATE BETWEEN CONVERT(DATETIME, ''' + @p_from_yyyymmdd + N''') AND DATEADD(DAY, 1, CONVERT(DATETIME, ''' + @p_TO_yyyymmdd + N'''))

		
			SELECT [@V_COLUMN]
					, SORT_ORDER_NO
					, [@V_PV_COL_LIST]    
			FROM ( '

	IF @P_BUCKET = 'DAILY'
	BEGIN
		SET @v_sql_text = @v_sql_text + N'
							SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
							FROM   #WF F
							--WHERE QTY <> 0
							WHERE 1=1
							--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 START
							AND (
									(F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0)
									OR
									(F.MEASURE = ''RTF_SYS_RP'')
								)
							--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 END
							UNION ALL '
	END
	-- 1274,1280 라인의 AVG,SUM의 QTY 부분 포맷수정 -- 20230621  이전소스 1274: THEN AVG(QTY)  ELSE SUM(QTY) END as QTY / 1280:THEN AVG(QTY)  ELSE SUM(QTY)
	SET @v_sql_text = @v_sql_text + N'
				SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' + F.BASIS_YYYYMM + F.ISO_WEEK AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN '+@v_avg_qty+'  ELSE '+@v_sum_qty+' END as QTY --[PJ20209642R] Sales Price 는 Sum 대신 Avg로 계산
				FROM #WF F
				--WHERE QTY <> 0
				WHERE 1=1
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 START
				AND (
						(F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0)
						OR
						(F.MEASURE = ''RTF_SYS_RP'')
					)
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 END
				GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK
					
				UNION ALL
				SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' + F.BASIS_YYYYMM AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN '+@v_avg_qty+'  ELSE '+@v_sum_qty+' END --[PJ20209642R] Sales Price 는 Sum 대신 Avg로 계산

				FROM #WF F
				--JOIN SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
				--WHERE QTY <> 0
				WHERE 1=1
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 START
				AND (
						(F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0)
						OR
						(F.MEASURE = ''RTF_SYS_RP'')
					)
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 END
				GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.BASIS_YYYYMM
					
				) F
			PIVOT (
				SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )
				) AS PVT
			ORDER BY [@v_orderby]
				'; 
				
PRINT @p_program_id +' : A033--' + CONVERT(VARCHAR(30), GETDATE(), 121);	

	--SELECT @v_sql_text;
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_COL_LIST]'    , @v_PV_LIST    );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_LIST]'		, @v_PV_LIST    );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_column]'			, @ColList       );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'		, @OrderList      );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_SELECT]'		, @V_SQL_SELECT      );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_GROUPBY]'		, @V_SQL_GROUPBY      );
		
  --PRINT @v_PV_LIST
  --select @ColList, @V_SQL_SELECT
  --select @v_sql_text

	-- 개발중에는 텍스트만 확인하고 실행은 안한다.
	/*
	SELECT CONVERT(TEXT, @v_sql_text)
	FOR XML PATH('')--,ROOT('x')
	*/
	--SELECT N'v_sql_text 길이',LEN(@v_sql_text)

	EXEC SP_EXECUTESQL @v_sql_text;

	--PRINT SUBSTRING(@v_sql_text, 1, 2000) + SUBSTRING(@v_sql_text, 1999, 4000)

	/* --기존 쿼리
	SELECT 'M_' + A.BASIS_YYYYMM AS THIS_YYYYMM, 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK AS THIS_YYYYMMWW, A.BASIS_DATE 
		, 'M_' + B.BASIS_YYYYMM AS PRE_YYYYMM, 'W_' + B.BASIS_YYYYMM + B.ISO_WEEK AS PRE_YYYYMMWW
		, A.BASIS_YYYYMM, A.ISO_WEEK
	FROM (
		SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE 
		FROM [dbo].[SCM_SYS_CALENDAR_M] 
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE(), 112) 
		) A
	JOIN (
		SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE 
		FROM [dbo].[SCM_SYS_CALENDAR_M] 
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(DAY, -7, GETDATE()), 112) 
		) B ON 1=1 */
	-----------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] 예를들어서 BASIS_YYYYMMDD 가 20250331,20250401 2개는 같은 주차지만 A랑 B로 나눠져있다. 4월 첫주 일 때 0331도 수정 가능하게 변경
	-----------------------------------------------------------------------------------------------------------------------------------
	SELECT 'M_' + A.BASIS_YYYYMM AS THIS_YYYYMM, 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK AS THIS_YYYYMMWW, A.BASIS_DATE 
		, 'M_' + B.BASIS_YYYYMM AS PRE_YYYYMM, 'W_' + B.BASIS_YYYYMM + B.ISO_WEEK AS PRE_YYYYMMWW
		, A.BASIS_YYYYMM, A.ISO_WEEK
	FROM (	-----------------------------------------------------------------------------------------------------------------------------------
			--[E20250520-000605]_주차 기준으로 데이터를 조회하는 경우 주차는 MIN이 맞으나, 월기준은 MAX로 조회해야함. 원소스 주석처리
			-----------------------------------------------------------------------------------------------------------------------------------
			--SELECT MIN(BASIS_YYYYMM) AS BASIS_YYYYMM, MIN(ISO_WEEK) AS ISO_WEEK, MIN(BASIS_DATE) AS BASIS_DATE
			SELECT MAX(BASIS_YYYYMM) AS BASIS_YYYYMM, MIN(ISO_WEEK) AS ISO_WEEK, MIN(BASIS_DATE) AS BASIS_DATE
			FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			--[E20251120-001430]_파셔주차인 경우, 걸쳐있는 데이터일때 달이 더 큰걸 가지고와 데이터 혼동 발생 데이터 구하는 조건 START
			WHERE BASIS_YYYYMM = (	SELECT BASIS_YYYYMM
									FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
									--[E20260720-000270]_당일날짜로 들어가게 되면서 파셜닐짜를 정상적으로 못잡게되어 무조건 당주 월요일날짜로 잡도록 수정
									WHERE BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)--CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112)
								)
			--[E20251120-001430]_파셔주차인 경우, 걸쳐있는 데이터일때 달이 더 큰걸 가지고와 데이터 혼동 발생 데이터 구하는 조건 END		
			AND ISO_YYYYWW = (
								SELECT ISO_YYYYWW
								FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
								--[E20260720-000270]_당일날짜로 들어가게 되면서 파셜닐짜를 정상적으로 못잡게되어 무조건 당주 월요일날짜로 잡도록 수정
								WHERE BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)--CONVERT(VARCHAR(8),GETDATE(), 112) 
								)
		) A
	JOIN (
		SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE 
		FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
		--[E20260720-000270]_당일날짜로 들어가게 되면서 파셜닐짜를 정상적으로 못잡게되어 무조건 당주 월요일날짜로 잡도록 수정
		WHERE BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112) --CONVERT(VARCHAR(8),DATEADD(DAY, -7, GETDATE()), 112) 
		) B ON 1=1
		
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] 그룹 + 화면 + 사업부 + MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 
	-----------------------------------------------------------------------------------------------------------------------------------
									--SalesAmt_LOC								  --RTF_SYS_RP
	SELECT @v_EDIT_AUTH_SalesAmt_LOC AS EDIT_AUTH_SalesAmt_LOC , @v_EDIT_AUTH_RTF_SYS_RP AS EDIT_AUTH_RTF_SYS_RP

	-- xml확인할경우
	--SELECT CONVERT(TEXT, @v_sql_text)
	--FOR XML PATH('')--,ROOT('x') 
	   
	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (START)
	--=================================================================================================================================
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V;
	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE;
	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA;
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM;
	IF OBJECT_ID (N'tempdb..#T_PRICE', N'U') IS NOT NULL 
		DROP TABLE #T_PRICE;
	IF OBJECT_ID (N'tempdb..#TEMP_SHIPMENT_SITE', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SHIPMENT_SITE;
	IF OBJECT_ID (N'tempdb..#WF', N'U') IS NOT NULL 
		DROP TABLE #WF;		
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL    
		DROP TABLE #TEMP_SCM_MST_SITE			
	-----------------------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	-----------------------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V;	
	IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP', N'U') IS NOT NULL 			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (20250718 SQL VALIDATOR에 의해 추가됨.)
		DROP TABLE #T_COLUMN_SETUP;	



	-----------------------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
	-----------------------------------------------------------------------------------------------------------------------------------
	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (END)
	--=================================================================================================================================
	
PRINT @p_program_id +' : A034--' + CONVERT(VARCHAR(30), GETDATE(), 121);	

END

