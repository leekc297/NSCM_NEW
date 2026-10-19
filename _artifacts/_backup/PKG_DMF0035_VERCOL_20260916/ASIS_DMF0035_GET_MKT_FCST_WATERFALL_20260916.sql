


/*=====================================================================================================================================================
 * Program ID   : DMF0035_GET_MKT_FCST_WATERFALL
 * Description  : MKT FCST Waterfall 조회
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 속도개선을 위해서 SALES PLAN을 참조해서 수정한 버전임
 * 2021.10.20	hwi1993		누락컬럼 추가 및 컬럼리스트 생성로직 변경
 * 2021.11.18	kdw2819		[과제]	자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021.11.19	ROSIA27		[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021.11.24	rosia27		[C20211118-000259] [SCM PI팀] GSCM 시스템 데이터를 마케팅(채권)자료로 활용하기 위한 기능 변경 건
 * 2021.12.03	rosia27		[C20211129-000286][SCM PI팀] GSCM 시스템 용량 정보를 마케팅(판가) 자료로 활용하기 위한 기능 변경건
 * 2021.12.07	rosia27		[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2021.12.08	rosia27		[C20211129-000218][ SCM PI팀] GSCM 데이터를 마케팅(판가) 자료로 활용키 위한 기능 변경 건
 * 2021.12.15	kdw2819		[C20211215-000076] 1년 이상 조회기간을 설정하여도 가능하도록 변경 건
 * 2022.02.24	HWI1993     [C20220218-000409] GSCM-DM AS Inventory 메저 계산 로직 수정 -- INV 메저 표시방법 변경, INTRANSIT 메저의 ATTR10 오류 수정
 * 2022.04.25	HWI1993		GM JV 작업
 * 2022.06.23	kdw2819		[C20220620-000557] GSCM DM 영역내, Version에 주차표기
 * 2022.06.30	HWI1993		[C20220615-000093] [영업마케팅PI] MKT_FCST Waterfall 內 SaftyStock LevelGap measure 추가 요청 건
 * 2022.07.28	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 * 2022.12.14	rosia27		[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023.01.25	rosia27		[C20230102-000937] MKT FCST Waterfall 조회 시 공란을 '0'으로 채울 수 있는 기능 구현 가능성 여부
 * 2023.02.02   heesan91	[E20230130-000233] [ESS영업관리팀] Waterfall 화면의 Version 값 주차(Week) 추가 요청의 건
 * 2023.03.16	rosia27		[E20230306-000253] MKT FCST Waterfall Cell Qty 표시 기능 구현 요청드립니다
 * 2023.05.03	kdmcc14		[EDI과제]
 * 2023.08.25   HMIN        [E20230802-000878] 자동차- MKT FCST Waterfall 화면에 AS From Site 칼럼 추가 건  
 * 2023.09.14   HMIN        [E20230906-000992] ESS 사업부 용량정보 표기 수정 - 1)Energy 관련 메저 누락 (21년도 기반영 CSR 에서 형식오류로 표출되지않았던 부분 수정)
 * 2023.10.25   HMIN        [E20231017-000634] [영업/마케팅 PI팀] MKT FCST Report 화면 칼럼추가 (SCP테이블정보) (요청자: 오윤종님)
 * 2023.12.07   kcw3408     [개발요청] 수요분석시스템_4_고객수요 Measure 통합 
 * 2023.12.19   JSSBAE      [E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall
 * 2024.01.15   JSSBAE      [E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
 * 2024.01.15   JSSBAE      [E20240102-000545] [마케팅PI] 82번 사업부 - VMI표기 로직 개선
 * 2024.03.07   kcw3408     DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
 * 2024.05.17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024.06.24   kjj			이동계획 판가 매출 GROUP_ID 화면 표시
 * 2024.08.02   JSSBAE		[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024.08.28	KJJ			[PJ2024-50461] Team Mapping
 * 2024.09.12	JSSBAE		[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.11.04	JSSBAE		[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건 
 *                           SSPM에 신규 추가 요청드린 'Project(S&OP Report)' 컬럼 MKT FCST Waterfall 사용자 화면에 추가 요청
 * 2024.11.12	JSSBAE		[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건
 * 2024.11.15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선		
 * 2024.11.26	JSSBAE	    [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정	
 * 2025.03.18	dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.03.27	jssbae		[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
 * 2025.04.23	dsiol		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가 - %SF% 추가
 * 2025.06.02   kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
 * 2025.07.07	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.08.06   JSSBAE		[E20250805-000706]_MKT FCST Waterfall 계획구간 Cell Prod Site 구분
 * 2025.08.11   JSSBAE		[E20250807-001418]_MKT FCST Waterfall UI Measure 오류 수정
 * 2026.01.23	JSSBAE		[E20260123-001715]_E20241015-000415 CSR 원복 요청
 *===================================================================================================================================================*/
 
CREATE PROCEDURE [dbo].[DMF0035_GET_MKT_FCST_WATERFALL]
      @p_division_id			NVARCHAR(30)
	, @p_dept_id				NVARCHAR(4000)
    , @p_end_customer			NVARCHAR(4000)
	, @p_scm_site_id			NVARCHAR(4000)
    , @p_project_code			NVARCHAR(4000)
	, @p_item_id				NVARCHAR(4000)
	, @p_item_type				NVARCHAR(4000)
	, @p_from_yyyymmdd			NVARCHAR(8)
	, @p_to_yyyymmdd			NVARCHAR(8)
	, @p_created_by				NVARCHAR(4000)
	, @p_plant_site_id			NVARCHAR(4000)
	, @p_biz_type				NVARCHAR(4000)
	, @p_owner					NVARCHAR(4000)
    , @p_version_no				NVARCHAR(4000)
	, @p_bucket					NVARCHAR(20)	-- 20211103 MKT FCST WATERFALL 속도 개선
	, @p_user_dept_id			NVARCHAR(50)	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
	, @p_group_id				NVARCHAR(50)	-- JV Planner 일지 확인하기 위해 추가
	, @p_cell_yn				NVARCHAR(01)
	, @p_sender_code			NVARCHAR(4000)	-- SENDER_CODE 추가

AS  
BEGIN
 --   DECLARE @p_division_id              NVARCHAR(30)        = N'82';
 --   DECLARE @p_dept_id                  NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_end_customer             NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_scm_site_id              NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_project_code             NVARCHAR(4000)      = N'';
 --   DECLARE @p_item_id                  NVARCHAR(4000)      = N'';
 --   DECLARE @p_item_type                NVARCHAR(4000)      = N'ALL';
 --   --DECLARE @p_from_yyyymmdd            NVARCHAR(8)         = N'20220516';
 --   --DECLARE @p_to_yyyymmdd              NVARCHAR(8)         = N'20220522';
 --   DECLARE @p_from_yyyymmdd            NVARCHAR(8)         = N'20220516';
 --   DECLARE @p_to_yyyymmdd              NVARCHAR(8)         = N'20220522';
 --   DECLARE @p_created_by               NVARCHAR(4000)      = N'iamarock';
 --   DECLARE @p_plant_site_id            NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_biz_type                 NVARCHAR(4000)      = N'ALL';
 --   DECLARE @p_owner					NVARCHAR(4000)      = N'';
 --   --DECLARE @p_version_no               NVARCHAR(4000)      = N'MF_W_20220517_V001';
 --   DECLARE @p_version_no               NVARCHAR(4000)      = N'CURRENT';
 --   DECLARE @p_user_dept_id			    NVARCHAR(50)        = N'ICO';
 --   DECLARE @p_group_id				    NVARCHAR(50)        = N'ADMIN';
	--DECLARE @p_bucket					NVARCHAR(10)	    = N'WEEK';

	SET NOCOUNT ON;
	--SET ANSI_WARNINGS OFF; 
	SET ANSI_NULLS ON
	SET ANSI_WARNINGS ON; 

	DECLARE	@Prod			NVARCHAR(MAX);
	DECLARE	@ColList		NVARCHAR(MAX);
	DECLARE	@OrderList		NVARCHAR(MAX);
	DECLARE	@nsql			NVARCHAR(MAX);
	DECLARE	@nsql2			NVARCHAR(MAX);
	DECLARE	@p_program_id	VARCHAR(50)	= 'DMF0035'
	DECLARE	@p_sheet_name	VARCHAR(50)	= 'MKT FCST Waterfall'
	DECLARE	@v_now_yyyymmdd	NCHAR(8)
	DECLARE	@MEASURE		INT	= 0;
	DECLARE	@i_count		INT	= 0;
  
PRINT @p_program_id + ' : A001-- :' + CONVERT(VARCHAR(30), GETDATE(), 121) ;   

	SET		@V_NOW_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112)
	SET		@ColList		= '';
	SET		@OrderList		= '';
	SET		@Prod			= '';
	--=================================================================================================================
	-- 20200316 KHSONG C20200224-000109 (START)
	--=================================================================================================================
	DECLARE @v_user_mea_cnt int =0;
	--=================================================================================================================
	-- 20200316 KHSONG C20200224-000109 (END)
	--=================================================================================================================
	
	--=================================================================================================================
	-- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
	--=================================================================================================================
	DECLARE @v_start_yyyymmdd	NVARCHAR(8)
	SET		@v_start_yyyymmdd = (SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = @p_from_yyyymmdd)
	
	--=================================================================================================================
	-- Temp Table 존재 여부 체크 (START)
	--=================================================================================================================
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V ;
	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE;
	IF OBJECT_ID (N'tempdb..#T_VERSION', N'U') IS NOT NULL 
		DROP TABLE #T_VERSION;
	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA;		
	-------------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] (START)
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#RAW_DATA_FINAL', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA_FINAL;
	-------------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] (END)
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#SCP_ITEM_INFO', N'U') IS NOT NULL 
		DROP TABLE #SCP_ITEM_INFO;		
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM;
	IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP', N'U') IS NOT NULL 
		DROP TABLE #T_COLUMN_SETUP;
	IF OBJECT_ID (N'tempdb..#T', N'U') IS NOT NULL 
		DROP TABLE #T;
	IF OBJECT_ID (N'tempdb..#T_LAST_DATA_SETUP', N'U') IS NOT NULL   
		DROP TABLE #T_LAST_DATA_SETUP;
	IF OBJECT_ID (N'tempdb..#T_LAST_DATA_SETUP_C', N'U') IS NOT NULL   
		DROP TABLE #T_LAST_DATA_SETUP_C;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_PLN_MKT_FCST', N'U') IS NOT NULL    -- [20240312] temp 테이블 추가
		DROP TABLE #TEMP_DM_PLN_MKT_FCST;	
	IF OBJECT_ID (N'tempdb..#WF', N'U') IS NOT NULL    
		DROP TABLE #WF;				
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL    
		DROP TABLE #TEMP_SCM_MST_SITE;		
	IF OBJECT_ID (N'tempdb..#CALENDAR', N'U') IS NOT NULL    
		DROP TABLE #CALENDAR;			
	IF OBJECT_ID (N'tempdb..#CAL_MONTH_END_DATE', N'U') IS NOT NULL    
		DROP TABLE #CAL_MONTH_END_DATE;		
	IF OBJECT_ID (N'tempdb..#CAL_WEEK_END_DATE', N'U') IS NOT NULL    
		DROP TABLE #CAL_WEEK_END_DATE;						
	-------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (START)
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V;	
	-------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)

	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	/*
	-------------------------------------------------------------------------------------------------------------------
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 (START) 
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_W_CELL_CF_DATA', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_W_CELL_CF_DATA;
	IF OBJECT_ID (N'tempdb..#TEMP_CELL_CF', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_CELL_CF;	
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM_CELL', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM_CELL;
	-------------------------------------------------------------------------------------------------------------------
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 (END)
	-------------------------------------------------------------------------------------------------------------------	
	*/
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	--=================================================================================================================
	-- Temp Table 존재 여부 체크 (END)
	--=================================================================================================================
PRINT @p_program_id + ' : A002-- :' + CONVERT(VARCHAR(30), GETDATE(), 121) ;   

	--=================================================================================================================
	-- Temp Table 생성 (START)
	--=================================================================================================================

	CREATE TABLE #T_VERSION 
	(	VERSION_NO		NVARCHAR(50)
	  , VERSION_NO_W	NVARCHAR(50)
	  , NOW_YYYYMMDD	NVARCHAR(8)
	)

	CREATE TABLE #RAW_DATA 
	(	VERSION_NO			NVARCHAR(50)
	  , CUTOFF_YYYYMMDD		CHAR(8)
	  , DIVISION_ID			NVARCHAR(30)
	  , PROJECT_CODE		NVARCHAR(50)
	  , SCM_SITE_ID			NVARCHAR(30)
	  , PLANT_SITE_ID		NVARCHAR(30)
	  , ITEM_ID				NVARCHAR(50)
	  , INCOTERMS			NVARCHAR(10)
	  , DOM_EXP				NVARCHAR(3)
	  , FCST_TYPE			NVARCHAR(20)
	  , MEASURE				NVARCHAR(50)
	  , MEASURE_GROUP		NVARCHAR(50)
	  , YYYYMMDD			CHAR(8)
	  , QTY					NUMERIC(30,10)
	  , VALID_YN			CHAR(1)
	  , PLAN_RESULT			CHAR(1)
	  , GUBUN				TINYINT
	  , CREATE_DATE			NVARCHAR(8)
	  , LAST_UPDATED_BY		NVARCHAR(300)
	  , SENDER_CODE			NVARCHAR(10)
	  , SENDER_NAME			NVARCHAR(100)
	  , AS_FROM_SITE		NVARCHAR(300)	--20230825
	  , CELL_PROD_SITE_ID	NVARCHAR(30)	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	)

	--[E20231017-000634]	
	CREATE TABLE #RAW_DATA_FINAL 
	(	VERSION_NO			NVARCHAR(50)
	  , CUTOFF_YYYYMMDD		CHAR(8)
	  , DIVISION_ID			NVARCHAR(30)
	  , PROJECT_CODE		NVARCHAR(50)
	  , SCM_SITE_ID			NVARCHAR(30)
	  , PLANT_SITE_ID		NVARCHAR(30)
	  --, FROM_SITE_ID		NVARCHAR(30)	--[PJ2024-50611] 소형 매출 프로세스 개선
	  , ITEM_ID				NVARCHAR(50)
	  , INCOTERMS			NVARCHAR(10)
	  , DOM_EXP				NVARCHAR(3)
	  , FCST_TYPE			NVARCHAR(20)
	  , MEASURE				NVARCHAR(50)
	  , MEASURE_GROUP		NVARCHAR(50)
	  , YYYYMMDD			CHAR(8)
	  , QTY					NUMERIC(30,10)
	  , VALID_YN			CHAR(1)
	  , PLAN_RESULT			CHAR(1)
	  , GUBUN				TINYINT
	  , CREATE_DATE			NVARCHAR(8)
	  , LAST_UPDATED_BY		NVARCHAR(300)
	  , SENDER_CODE			NVARCHAR(10)
	  , SENDER_NAME			NVARCHAR(100)
	  , AS_FROM_SITE		NVARCHAR(300)  
	  , CELL_NICKNAME		NVARCHAR(300) 
	  , PRODUCT_LEVEL1		NVARCHAR(300)
	  , PRODUCT_LEVEL2		NVARCHAR(300)
	  , PRODUCT_LEVEL3		NVARCHAR(300)
	  , NOTATION			NVARCHAR(8)		--[E20231128-000738] NOTATION 컬럼추가
	  , CELL_PROD_SITE_ID	NVARCHAR(30)	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	)

	-------------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] SCP 정보수집용 TABLE 생성 (START)
	-------------------------------------------------------------------------------------------------------------------
	CREATE TABLE #SCP_ITEM_INFO 
	(	DIVISION_ID				NVARCHAR(30)		
	  , ITEM_ID					NVARCHAR(50)		
	  , CELL_NICKNAME			NVARCHAR(300) 
	  , BASIC_NICKNAME_CELL40	NVARCHAR(300)
	  , NICKNAME_40				NVARCHAR(300)	
	  , GROUP_CODE1				NVARCHAR(300)
	  , GROUP_CODE4				NVARCHAR(300)
	  , GROUP_CODE5				NVARCHAR(300)
	  , GROUP_CODE6				NVARCHAR(300)
	  , GROUP_CODE7				NVARCHAR(300)
	  , CELL_TYPE_GROUP_NAME	NVARCHAR(300)
	)
	-------------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] SCP 정보수집용 TABLE 생성 (END)
	-------------------------------------------------------------------------------------------------------------------
	
	CREATE TABLE #T_LAST_DATA_SETUP 
	(	DIVISION_ID				NVARCHAR(30)		  
	  , PROJECT_CODE			NVARCHAR(50)  
	  , SCM_SITE_ID				NVARCHAR(30)  		  
	  , ITEM_ID					NVARCHAR(50)  
	  , DOM_EXP					NVARCHAR(3)  
	  , FCST_TYPE				NVARCHAR(20)  
	  , INCOTERMS				NVARCHAR(10)  		  
	  , MEASURE					NVARCHAR(50)  		  
	  , CREATE_DATE				NVARCHAR(8)
	  , LAST_UPDATED_BY			NVARCHAR(300)		  
	)

	CREATE TABLE #T_LAST_DATA_SETUP_C 
	(	VERSION_NO				NVARCHAR(100)
	  , DIVISION_ID				NVARCHAR(30)		  
	  , PROJECT_CODE			NVARCHAR(50)  
	  , SCM_SITE_ID				NVARCHAR(30)  		  
	  , ITEM_ID					NVARCHAR(50)  
	  , DOM_EXP					NVARCHAR(3)  
	  , FCST_TYPE				NVARCHAR(20)  
	  , INCOTERMS				NVARCHAR(10)  		  
	  , MEASURE					NVARCHAR(50)  		  
	  , CREATE_DATE				NVARCHAR(8)
	  , LAST_UPDATED_BY			NVARCHAR(300)		  
	)
	
	--=================================================================================================================
	-- Temp Table 생성 (END)
	--=================================================================================================================

	IF @p_version_no LIKE '%MF%' OR @p_version_no LIKE '%ME%' OR @p_version_no LIKE '%SF%' --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
	BEGIN
		INSERT INTO #T_VERSION ( VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD )
		SELECT A.TOKEN
			 , CASE WHEN D.DM_RTF_YN = 'N'  
			        THEN CONCAT(A.TOKEN, '(',C.WEEK_NAME,') (NO PLAN)') 
					ELSE CONCAT(A.TOKEN, '(',C.WEEK_NAME,')') END
			 , CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( B.YYYYMMDD, 'MON')), 112)
		FROM (SELECT  LEFT(token,  CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END) AS  TOKEN
		FROM dbo.String_Split(@p_version_no ,','))  AS A
		JOIN DM_MST_VERSION B WITH(NOLOCK) ON A.TOKEN = B.VERSION_NO AND B.DIVISION_ID = @p_division_id
		INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON B.YYYYMMDD = C.BASIS_YYYYMMDD
		LEFT JOIN SCP_PLN_INTERFACE_YN D WITH(NOLOCK)
			   ON B.DIVISION_ID			= D.DIVISION_ID
			  AND C.BASIS_START_DATE	= D.PLAN_START_YYYYMMDD
	END
	
	------------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	------------------------------------------------------------------------------------------
PRINT @p_program_id + ' : A003-- :' + CONVERT(VARCHAR(30), GETDATE(), 121) ;   

/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.*/

	--=================================================================================================================
	-- 20200316 KHSONG C20200224-000109 (START)
	--=================================================================================================================
	SELECT @v_user_mea_cnt = COUNT(*)
	FROM SCM_MST_TITLESET_USER U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID						= @p_program_id
	AND    U.SHEET_NAME						= @p_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND    U.USER_ID						= @p_created_by;

	IF @v_user_mea_cnt = 0
	BEGIN	    
		INSERT INTO SCM_MST_TITLESET_USER
		( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
		, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
		, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
		SELECT @p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME
			  , C.SORT_ORDER_NO, 'N', '', @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
			  , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
		FROM   SCM_MST_SHEET_MEASURE C WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.PROGRAM_ID		= @p_program_id
		AND    C.SHEET_NAME		= @p_sheet_name
		AND    C.DEFAULT_FLAG	= 'Y'
		AND    C.VALID_YN		= 'Y';
	END
	
	--=================================================================================================================
	-- [E20250807-001418]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 START
	-- SCM_FCST은 40 사업부만 사용하나, 하단에서 생성하는 경우에 사업부에서 진행하게 되면서, 모든 사업부에 메져가 노출됨.
	--=================================================================================================================
	-- 원소스 주석처리함
	/*
	-------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (END)
	-------------------------------------------------------------------------
	SELECT DISTINCT
		ISNULL(U.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
		,U.SHEET_NAME
		,U.USER_ID
		,CASE  WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO'  )  THEN 'CUST. PSI' 
				WHEN U.COLUMN_NAME IN ( 'MKT_INV_I' ,'MKT_PRODUCT_S' ,'MKT_WHIN_P' ,'MKT_DIO'   )  THEN 'MKT PSI'  
				ELSE U.COLUMN_NAME 
			END AS MEASURE_GROUP
		,U.COLUMN_NAME AS MEASURE
		, CASE WHEN U.COLUMN_NAME IN ( 'CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG' )  THEN SMSM.SORT_ORDER_NO  -- 20231212 kcw3408 4_고객수요 Measure 통합
				ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO  
		,'N' AS SYSTEM_ADD
	INTO #SELECT_MEASURE 
	FROM SCM_MST_TITLESET_USER U  WITH(NOLOCK)
			JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
		    ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			AND U.SHEET_NAME = SMSM.SHEET_NAME
			AND U.COLUMN_NAME = SMSM.COLUMN_NAME
			AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
			AND SMSM.VALID_YN     = 'Y'	
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK) ON (U.USER_ID = T.SEGMENT4)  -- 20200309 KHSONG TMM MEASURE 권한추가
				AND @p_created_by	= T.SEGMENT4  -- USER_ID
				AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
				AND T.VALID_YN		= 'Y'       -- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND U.PROGRAM_ID						= 'DMF0035'
	AND U.SHEET_NAME						= 'Mkt Fcst Waterfall'
	AND U.USER_ID						= @p_created_by
	and U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by	END
	*/

	-- USER TITLE 정보와 MEASURE MASTER 정보를 JOIN하여 사업부별 정보를 보관한다. 
	SELECT DISTINCT ISNULL(U.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID, U.SHEET_NAME, U.USER_ID
		 , CASE WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO'  )  THEN 'CUST. PSI' 
				WHEN U.COLUMN_NAME IN ( 'MKT_INV_I' ,'MKT_PRODUCT_S' ,'MKT_WHIN_P' ,'MKT_DIO'   )  THEN 'MKT PSI'  
				ELSE U.COLUMN_NAME 
			END AS MEASURE_GROUP
		, U.COLUMN_NAME AS MEASURE
		, CASE WHEN U.COLUMN_NAME IN ( 'CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG' )  THEN SMSM.SORT_ORDER_NO  -- 20231212 kcw3408 4_고객수요 Measure 통합
				ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO  
		, 'N' AS SYSTEM_ADD
	INTO #SELECT_MEASURE 
	FROM (	SELECT A.PROGRAM_ID, A.USER_ID, A.COLUMN_NAME, A.SORT_ORDER_NO, A.SYSTEM_ADD, A.USER_INQUIRY_COLUMN_TYPE_CODE, A.SHEET_NAME, TOKEN AS DIVISION_ID
			FROM (	SELECT U.PROGRAM_ID, U.USER_ID, U.COLUMN_NAME, U.SORT_ORDER_NO, B.DIVISION_ID, U.USER_INQUIRY_COLUMN_TYPE_CODE, U.SHEET_NAME, 'N' AS SYSTEM_ADD
					FROM SCM_MST_TITLESET_USER U WITH (NOLOCK)
					INNER JOIN SCM_MST_SHEET_MEASURE B WITH(NOLOCK) 
							ON U.PROGRAM_ID		= B.PROGRAM_ID
							AND U.SHEET_NAME	= B.SHEET_NAME
							AND U.COLUMN_NAME	= B.COLUMN_NAME
					WHERE	1 = 1
					AND		U.PROGRAM_ID					= @p_program_id
					AND		U.SHEET_NAME					= @p_sheet_name
					AND		U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
					AND		U.USER_ID						= @p_created_by
					AND		B.VALID_YN						= 'Y' ) A
			CROSS APPLY STRING_SPLIT(A.DIVISION_ID, ',' )) U
	JOIN SCM_MST_SHEET_MEASURE SMSM WITH(NOLOCK)
	  ON  U.PROGRAM_ID	= SMSM.PROGRAM_ID
	 AND U.SHEET_NAME	= SMSM.SHEET_NAME
	 AND U.COLUMN_NAME	= SMSM.COLUMN_NAME
	 AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	 AND SMSM.VALID_YN	= 'Y'	
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK) 
		   ON (U.USER_ID	= T.SEGMENT4)  -- 20200309 KHSONG TMM MEASURE 권한추가
		  AND @p_created_by	= T.SEGMENT4  -- USER_ID
		  AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
		  AND T.VALID_YN	= 'Y'       -- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE		= 'M'
	AND U.PROGRAM_ID						= @p_program_id
	AND U.SHEET_NAME						= @p_sheet_name
	AND U.USER_ID							= @p_created_by
	AND U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by END
	AND U.DIVISION_ID = @p_division_id
  	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20250807-001418]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 END
	-----------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		SELECT ISNULL(A.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
			,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO + B.SORT_ORDER_NO
			,'N' AS SYSTEM_ADD
		FROM 
				(SELECT U.PROGRAM_ID
						, U.SHEET_NAME
						, U.USER_ID
						--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START
						--, 'CUST_FCST_EDI' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭 
						, 'CUST_FCST' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭 
						--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END
						, SMSM.SORT_ORDER_NO            -- 20231212 kcw3408 4_고객수요 Measure 통합
					FROM [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'	
					WHERE 1 = 1
					AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
					AND U.PROGRAM_ID   = 'DMF0035'
					AND U.SHEET_NAME   = 'Mkt Fcst Waterfall'
					AND U.USER_ID      = @p_created_by
					--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START
					--AND U.COLUMN_NAME  = 'CUST_FCST_EDI'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
					AND U.COLUMN_NAME  = 'CUST_FCST'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
					--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END
					) A
					,
					(
						 --[E20241126-000426]_CUST_FCST_EDI 추가 및 순서 변경 START
						 --SELECT 'Immidiate' MEASURE,0.14 AS SORT_ORDER_NO
						 SELECT 'Immidiate' MEASURE,0.15 AS SORT_ORDER_NO
						 UNION ALL									
						 --SELECT 'Planning_Forecast' MEASURE,0.17 AS SORT_ORDER_NO
						 SELECT 'Planning_Forecast' MEASURE,0.18 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Commercial_Agreement' MEASURE,0.12 AS SORT_ORDER_NO
						 SELECT 'Commercial_Agreement' MEASURE,0.13 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Firm_Temp' MEASURE,0.13 AS SORT_ORDER_NO
						 SELECT 'Firm_Temp' MEASURE,0.14 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Manumacturing_Material_Temp' MEASURE,0.15 AS SORT_ORDER_NO
						 SELECT 'Manumacturing_Material_Temp' MEASURE,0.16 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Material_Temp' MEASURE,0.16 AS SORT_ORDER_NO
						 SELECT 'Material_Temp' MEASURE,0.17 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Backorder' MEASURE,0.11 AS SORT_ORDER_NO
						 SELECT 'Backorder' MEASURE,0.12 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'CUST_FCST_EDI' MEASURE,0.11 AS SORT_ORDER_NO	--[E20241126-000426]_신규 추가
						 --[E20241126-000426]_CUST_FCST_EDI 추가 및 순서 변경 END
					) B
		WHERE 1=1
		GROUP BY A.PROGRAM_ID,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO + B.SORT_ORDER_NO		
		--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
		/*
		UNION ALL
		SELECT ISNULL(A.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
			,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO + B.SORT_ORDER_NO
			,'N' AS SYSTEM_ADD
		FROM 
				(SELECT U.PROGRAM_ID
						, U.SHEET_NAME
						, U.USER_ID
						,'CUST_FCST_EDI_ORG' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
						, SMSM.SORT_ORDER_NO                -- 20231212 kcw3408 4_고객수요 Measure 통합
					FROM [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'	
					WHERE 1 = 1
					AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
					AND U.PROGRAM_ID   = 'DMF0035'
					AND U.SHEET_NAME   = 'Mkt Fcst Waterfall'
					AND U.USER_ID      = @p_created_by
					AND U.COLUMN_NAME  = 'CUST_FCST_EDI_ORG'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
					) A
					,
					(
						 SELECT 'Immidiate[Org.]' MEASURE,0.14 AS SORT_ORDER_NO
						 UNION ALL									
						 SELECT 'Planning_Forecast[Org.]' MEASURE,0.17 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Commercial_Agreement[Org.]' MEASURE,0.12 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Firm_Temp[Org.]' MEASURE,0.13 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Manumacturing_Material_Temp[Org.]' MEASURE,0.15 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Material_Temp[Org.]' MEASURE,0.16 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Backorder[Org.]' MEASURE,0.11 AS SORT_ORDER_NO
					) B
		WHERE 1=1
		GROUP BY A.PROGRAM_ID,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO + B.SORT_ORDER_NO	
		*/
		--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END

		UNION ALL
		SELECT DISTINCT
			'DMF0035'					AS PROGRAM_ID
			, 'Mkt Fcst Waterfall'		AS SHEET_NAME     
			, @p_created_by			AS USER_ID
			, 'CUST_FCST'				AS MEASURE_GROUP
			, C.MEASURE					AS MEASURE
			, (SELECT SMSM.SORT_ORDER_NO       -- 20231212 kcw3408 4_고객수요 Measure 통합
				FROM [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'	
				WHERE 1 = 1
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
				AND U.PROGRAM_ID						= 'DMF0035'
				AND U.SHEET_NAME						= 'Mkt Fcst Waterfall'
				AND U.USER_ID							= @p_created_by
				AND U.COLUMN_NAME						= 'CUST_FCST') + 0.1  AS SORT_ORDER_NO
			,'N' AS SYSTEM_ADD
        FROM [dbo].[DM_MST_CUSTOMER_FCST] C  WITH(NOLOCK,INDEX (PK_DM_MST_CUSTOMER_FCST))
		WHERE 1 = 1
			AND C.MEASURE_GROUP = 'CUST_FCST'
			AND C.MEASURE      <> ''
			AND C.VALID_YN   = 'Y'
			AND EXISTS (SELECT *
						FROM [dbo].[SCM_MST_TITLESET_USER] X WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
						WHERE  1 = 1
							AND X.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
							AND X.PROGRAM_ID					= 'DMF0035'
							AND X.SHEET_NAME					= 'Mkt Fcst Waterfall'
							AND X.USER_ID						= @p_created_by
							AND X.COLUMN_NAME					= 'CUST_FCST'
							AND X.COLUMN_NAME					= C.MEASURE_GROUP)

		UNION ALL
		SELECT DISTINCT
			'DMF0035'					AS PROGRAM_ID
			, 'Mkt Fcst Waterfall'		AS SHEET_NAME     
			, @p_created_by			AS USER_ID
			, 'CUST_FCST_ORG'			AS MEASURE_GROUP
			, 'Customer Fcst[Org.]'		AS MEASURE
			, (SELECT SMSM.SORT_ORDER_NO         -- 20231212 kcw3408 4_고객수요 Measure 통합
				FROM [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'	
				WHERE 1 = 1
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
				AND U.PROGRAM_ID									= 'DMF0035'
				AND U.SHEET_NAME									= 'Mkt Fcst Waterfall'
				AND USER_ID											= @p_created_by
				AND U.COLUMN_NAME								= 'CUST_FCST_ORG') + 0.1  AS SORT_ORDER_NO
			,'N' AS SYSTEM_ADD
        FROM [dbo].[DM_MST_CUSTOMER_FCST] C  WITH(NOLOCK,INDEX (PK_DM_MST_CUSTOMER_FCST))
		WHERE 1 = 1
			AND C.MEASURE_GROUP = 'CUST_FCST'
			AND C.MEASURE      <> ''
			AND C.VALID_YN   = 'Y'
			AND EXISTS (SELECT *
						FROM [dbo].[SCM_MST_TITLESET_USER] X WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
						WHERE  1 = 1
							AND X.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
							AND X.PROGRAM_ID					= 'DMF0035'
							AND X.SHEET_NAME					= 'Mkt Fcst Waterfall'
							AND X.USER_ID						= @p_created_by
							AND X.COLUMN_NAME					= 'CUST_FCST_ORG'
							--AND X.COLUMN_NAME					= C.MEASURE_GROUP
							)

--select * from #SELECT_MEASURE;return;

			--SELECT DISTINCT
			--	CASE  WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO'  )  THEN 'CUST. PSI' 
			--			WHEN U.COLUMN_NAME IN ( 'MKT_INV_I' ,'MKT_PRODUCT_S' ,'MKT_WHIN_P' ,'MKT_DIO'   )  THEN 'MKT PSI'  
			--			ELSE U.COLUMN_NAME 
			--		END AS MEASURE_GROUP
			--	 , U.COLUMN_NAME AS MEASURE
			--	 , U.SORT_ORDER_NO
			--	 , 'N' AS SYSTEM_ADD
			--INTO #SELECT_MEASURE   -- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
			--FROM [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK)
			--WHERE 1 = 1
			--	AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
			--	AND U.PROGRAM_ID   = @p_program_id
			--	AND U.USER_ID      = @p_created_by

			------------------------------------------------------------------------------------------------------------------
			-- 변환 또는 환산이 필요할 경우 해당 본 메저도 추가해준다.
			------------------------------------------------------------------------------------------------------------------
			IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE LIKE 'MKT_FCST_RP%' )
			BEGIN
				INSERT INTO #SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', @p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					UNION ALL
					SELECT 'MKT_FCST' AS MEASURE_GROUP, 'MKT_FCST' AS MEASURE
					) A
				LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
			END

			IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE LIKE 'RTF_SYS_RP%' )
			BEGIN
				INSERT INTO #SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', @p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					) A
				LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
			END

			IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'LOC' )
			BEGIN
				INSERT INTO #SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', @p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					UNION ALL
					SELECT 'SALESAMT' AS MEASURE_GROUP,'SalesAmt_LOC' AS MEASURE
					) A
				LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
			END

			-----------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
			-- SCM_FCST 메저의 실적구간은 RTF_SYS_RP 를 가져와 보여주도록 한다.
			-----------------------------------------------------------------------------------------------------------------------------------
			IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' ))
			BEGIN
				INSERT INTO #SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', @p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					) A
				LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
			END

print 'D--' + convert(varchar(30), getdate(), 121)

			-- 테이블중복제거
			IF OBJECT_ID (N'tempdb..#T_EDI_SENDER', N'U')	IS NOT NULL	DROP TABLE #T_EDI_SENDER

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID (N'dbo.#T_EDI_SENDER', N'U')		IS NOT NULL	DROP TABLE #T_EDI_SENDER

			--#T_EDI_SENDER	
			CREATE TABLE #T_EDI_SENDER	(				
						SCM_SITE_ID					NVARCHAR(100)	NULL
						,SENDER_CODE 				NVARCHAR(10)	NULL
						,SENDER_NAME				NVARCHAR(200)	NULL)

			BEGIN
				INSERT INTO #T_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
				SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
				FROM SCM_MST_SITE A WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
				ON A.END_CUSTOMER = B.SEGMENT2
				AND A.DIVISION_ID = B.SEGMENT1
				AND B.LOOKUP_TYPE = 'EDI_END_CUSTOMER'
				GROUP BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
			END
			
			--------------------------------------------------
			-- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')
			--------------------------------------------------
			
			IF ( @p_version_no LIKE '%CURRENT%' )
			BEGIN
			
				BEGIN
					INSERT INTO #T_LAST_DATA_SETUP
					SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
							 , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
					FROM (
							  SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE			
										--[E20241126-000426]_CUST_FCST Measure 추가 START
	 								    --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
										--									    , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN								
	 								   , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'									   
																				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
																			    /*, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'*/							   
																				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
																				) THEN								
										--[E20241126-000426]_CUST_FCST Measure 추가 START
														   (CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																			  MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
																	ELSE MAX(A.ATTRIBUTE9) END)
												 ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  --FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
							  FROM (
									SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									,F.ATTRIBUTE9,F.LAST_UPDATE_DATE,F.LAST_UPDATED_BY
									FROM [dbo].[DM_PLN_MKT_FCST] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
									UNION ALL
									SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									,F.ATTRIBUTE9,F.LAST_UPDATE_DATE,F.LAST_UPDATED_BY
									FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
								   ) AS A
							  JOIN #SELECT_MEASURE B 
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
																 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'																 
																 ELSE B.MEASURE END)
							  WHERE A.DIVISION_ID = @p_division_id
							  AND A.YYYYMMDD >= CONVERT(NVARCHAR, DATEADD(YY, -1, @p_from_yyyymmdd ), 112)
							  AND A.YYYYMMDD <= @p_to_yyyymmdd
							  AND A.QTY <> 0
							  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
							  UNION ALL
							  SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE							
										--[E20241126-000426]_CUST_FCST Measure 추가 START
	 								    --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
	 								    , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
									    --[E20241126-000426]_CUST_FCST Measure 추가 END
																			    , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN
														   (CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																			  MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
																	ELSE MAX(A.ATTRIBUTE9) END)
												 ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  FROM DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
							  JOIN #SELECT_MEASURE B 
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
																 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
																 ELSE B.MEASURE END)
							  WHERE A.DIVISION_ID = @p_division_id
							  AND A.YYYYMMDD >= CONVERT(NVARCHAR, DATEADD(YY, -1, @p_from_yyyymmdd ), 112)
							  AND A.YYYYMMDD <= @p_to_yyyymmdd
							  AND A.QTY <> 0
							  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
						      ) X
					WHERE ISNULL(X.PROJECT_CODE, '') <> ''
					AND ISNULL(X.SCM_SITE_ID, '') <> ''
					AND ISNULL(X.ITEM_ID, '') <> ''
					GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
				END

				-- EDI LOOKUP 기간
				-- 테이블중복제거
				IF OBJECT_ID (N'tempdb..#TEMP_EDI_END_CUSTOMER', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID (N'dbo.#TEMP_EDI_END_CUSTOMER', N'U')					IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER

				--#TEMP_EDI_END_CUSTOMER	
				CREATE TABLE #TEMP_EDI_END_CUSTOMER	(
					DIVISION_ID				NVARCHAR(10)	NULL,
					END_CUSTOMER			NVARCHAR(100)	NULL,
					SCM_SITE_ID				NVARCHAR(60)	NULL,			
					FROM_WEEK				INT					NULL,
					FROM_DAY					NVARCHAR(30)	NULL,			
					TO_WEEK					INT					NULL,
					TO_DAY						NVARCHAR(30)	NULL,
					ACTIVE						NVARCHAR(30)	NULL
					);

				--EDI END_CUSTOMER별 기간 설정
				BEGIN			

					INSERT INTO #TEMP_EDI_END_CUSTOMER ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On' THEN
												  ISNULL(B.ATTRIBUTE1, '-1') 
										ELSE '-52' END) AS FROM_WEEK
							 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , ISNULL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
					ON B.LOOKUP_TYPE = 'EDI_END_CUSTOMER'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE ISNULL(A.END_CUSTOMER, '') <> ''
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

				END
											   
				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
				/*
				-- EDI[Org.] LOOKUP 기간
				-- 테이블중복제거
				IF OBJECT_ID (N'tempdb..#TEMP_EDI_END_CUSTOMER_ORG', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER_ORG

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID (N'dbo.#TEMP_EDI_END_CUSTOMER_ORG', N'U')				IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER_ORG

				--#TEMP_EDI_END_CUSTOMER_ORG	
				CREATE TABLE #TEMP_EDI_END_CUSTOMER_ORG	(
					DIVISION_ID				NVARCHAR(10)	NULL,
					END_CUSTOMER			NVARCHAR(100)	NULL,
					SCM_SITE_ID				NVARCHAR(60)	NULL,			
					FROM_WEEK				INT					NULL,
					FROM_DAY					NVARCHAR(30)	NULL,			
					TO_WEEK					INT					NULL,
					TO_DAY						NVARCHAR(30)	NULL,
					ACTIVE						NVARCHAR(30)	NULL
					);

				--EDI END_CUSTOMER_ORG별 기간 설정
				BEGIN			

					INSERT INTO #TEMP_EDI_END_CUSTOMER_ORG ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On' THEN
										 ISNULL(B.ATTRIBUTE1, '-1') 
							   ELSE '-52' END) AS FROM_WEEK
							 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , ISNULL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
					ON B.LOOKUP_TYPE = 'EDI_END_CUSTOMER_ORG'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE ISNULL(A.END_CUSTOMER, '') <> ''
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

				END											   
				*/
				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END

				-- RPA LOOKUP 기간
				-- 테이블중복제거
				IF OBJECT_ID (N'tempdb..#TEMP_RPA_END_CUSTOMER', N'U')			IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID (N'dbo.#TEMP_RPA_END_CUSTOMER', N'U')				IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER

				--#TEMP_EDI_END_CUSTOMER	
				CREATE TABLE #TEMP_RPA_END_CUSTOMER	(
					DIVISION_ID				NVARCHAR(10)	NULL,
					END_CUSTOMER			NVARCHAR(100)	NULL,
					SCM_SITE_ID				NVARCHAR(60)	NULL,			
					FROM_WEEK				INT					NULL,
					FROM_DAY					NVARCHAR(30)	NULL,			
					TO_WEEK					INT					NULL,
					TO_DAY						NVARCHAR(30)	NULL,
					ACTIVE						NVARCHAR(30)	NULL
					);

				--RPA END_CUSTOMER별 기간 설정
				BEGIN	

					INSERT INTO #TEMP_RPA_END_CUSTOMER ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On' THEN
												  ISNULL(B.ATTRIBUTE1, '-1') 
										ELSE '-52' END) AS FROM_WEEK
							 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , ISNULL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
					ON B.LOOKUP_TYPE = 'RPA_END_CUSTOMER'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE ISNULL(A.END_CUSTOMER, '') <> ''
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

				END
											   
				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
				/*
				-- RPA[Org.] LOOKUP 기간
				-- 테이블중복제거
				IF OBJECT_ID (N'tempdb..#TEMP_RPA_END_CUSTOMER_ORG', N'U')			IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER_ORG

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID (N'dbo.#TEMP_RPA_END_CUSTOMER_ORG', N'U')				IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER_ORG

				--#TEMP_EDI_END_CUSTOMER_ORG	
				CREATE TABLE #TEMP_RPA_END_CUSTOMER_ORG	(
					DIVISION_ID				NVARCHAR(10)	NULL,
					END_CUSTOMER			NVARCHAR(100)	NULL,
					SCM_SITE_ID				NVARCHAR(60)	NULL,			
					FROM_WEEK				INT					NULL,
					FROM_DAY					NVARCHAR(30)	NULL,			
					TO_WEEK					INT					NULL,
					TO_DAY						NVARCHAR(30)	NULL,
					ACTIVE						NVARCHAR(30)	NULL
					);

				--RPA END_CUSTOMER_ORG별 기간 설정
				BEGIN	

					INSERT INTO #TEMP_RPA_END_CUSTOMER_ORG ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On' THEN
										 ISNULL(B.ATTRIBUTE1, '-1') 
							   ELSE '-52' END) AS FROM_WEEK
							 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , ISNULL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
					ON B.LOOKUP_TYPE = 'RPA_END_CUSTOMER_ORG'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE ISNULL(A.END_CUSTOMER, '') <> ''
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

				END
				*/							   
				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
-- [20240312] start

 				SELECT A.*, CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
							  WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
							  ELSE '' END AS MEASURE_GROUP   
				INTO #TEMP_DM_PLN_MKT_FCST
				--FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
				FROM (
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5
					  FROM [dbo].[DM_PLN_MKT_FCST] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
					  UNION ALL
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5
					  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
					 ) AS A
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				JOIN SCM_MST_SITE C (NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
				WHERE A.YYYYMMDD >= @v_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
					AND A.DIVISION_ID =@p_division_id
					AND A.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
												   	   --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
													   /*
													   , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
													   , 'Material_Temp[Org.]', 'Backorder[Org.]'
													   */							   
													   --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
													   , 'CUST_FCST', 'Customer FCST')
					AND A.QTY <> 0


				create index idx1_TEMP_DM_PLN_MKT_FCST on #TEMP_DM_PLN_MKT_FCST ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID)


 				INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)
				SELECT   'CURRENT' AS VERSION_NO
						, NULL AS CUTOFF_YYYYMMDD
						, A.DIVISION_ID 
						,A.PROJECT_CODE 
						,A.SCM_SITE_ID 
						,PLANT_SITE_ID 
						,A.ITEM_ID 
						,A.INCOTERMS 
						,A.DOM_EXP 
						,A.FCST_TYPE 
						,A.MEASURE
						,A.MEASURE_GROUP
						,A.YYYYMMDD 
						,A.QTY
						, 'P', 1
						--[E20241126-000426]_CUST_FCST 추가 START
						--,(CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						,(CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 END
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												  --[E20241126-000426]_CUST_FCST 추가 START
												   --AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												   AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												  --[E20241126-000426]_CUST_FCST 추가 END
										 WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
										   ELSE (SELECT CREATE_DATE FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
												   ) END)		
							  , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
													(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
													--[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
													-- ELSE A.LAST_UPDATED_BY + '_EXCEL' END)			
															 ELSE A.LAST_UPDATED_BY END)															  
										 --[E20241126-000426]_CUST_FCST 추가 START
										 --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
										 WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN										  
										 --[E20241126-000426]_CUST_FCST 추가 END
												   (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
																	  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
															 ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
												   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
																				   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
																				   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
																				   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
										   ELSE (SELECT LAST_UPDATED_BY FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE												   
												   ) END)										  
						 --[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN							  
						 --[E20241126-000426]_CUST_FCST 추가 END
											(CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
															   (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE4 END)
									ELSE NULL END)										  
						 --[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN						  
						 --[E20241126-000426]_CUST_FCST 추가 START
											(CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
															   (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE5 END)
									ELSE NULL END)

						--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
						, CASE WHEN A.DIVISION_ID IN ('81', '82') THEN ISNULL(A.ATTRIBUTE10, '')  ELSE '' END AS AS_FROM_SITE --20230825
						, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가 
				FROM #TEMP_DM_PLN_MKT_FCST AS A WITH(NOLOCK)

-- [20240312] end

 /* -- [20240312] 아래 쿼리를 위의 2개의 쿼리로 분리함.START

				INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE
										)
				SELECT   'CURRENT' AS VERSION_NO
						, NULL AS CUTOFF_YYYYMMDD
						, A.DIVISION_ID 
						,A.PROJECT_CODE 
						,A.SCM_SITE_ID 
						,PLANT_SITE_ID 
						,A.ITEM_ID 
						,A.INCOTERMS 
						,A.DOM_EXP 
						,A.FCST_TYPE 
						,A.MEASURE
						,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
							  WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
							  ELSE '' END AS MEASURE_GROUP
						,A.YYYYMMDD 
						,A.QTY
						, 'P', 1
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
										 WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
										   ELSE (SELECT CREATE_DATE FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
												   ) END)		
							  , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
													(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
															 ELSE A.LAST_UPDATED_BY + '_EXCEL' END)
										 WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
												   (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
																	  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
															 ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
												   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
																				   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
																				   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
																				   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
										   ELSE (SELECT LAST_UPDATED_BY FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE												   
												   ) END)
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
											(CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
															   (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE4 END)
									ELSE NULL END)		
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
											(CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
															   (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE5 END)
									ELSE NULL END)
						--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
						, CASE WHEN A.DIVISION_ID IN ('81', '82') THEN ISNULL(A.ATTRIBUTE10, '')  ELSE '' END AS AS_FROM_SITE --20230825
				FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				JOIN SCM_MST_SITE C (NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
				--JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
				WHERE A.YYYYMMDD >= @v_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
					AND A.DIVISION_ID =@p_division_id
					AND A.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
													   , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
													   , 'Material_Temp[Org.]', 'Backorder[Org.]', 'CUST_FCST', 'Customer FCST')
					AND A.QTY <> 0
 속도 개선활동 (2024.03.06) 아래 쿼리를 위의 2개의 쿼리로 분리함. END */

				--EDI 계획(CUST_FCST_EDI)

-- [20240312] 개별 insert 함				UNION ALL

				INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
														, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
														, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
														, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
														)
				SELECT   'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  ,A.PROJECT_CODE   
							  ,A.SCM_SITE_ID   
							  ,PLANT_SITE_ID   
							  ,A.ITEM_ID   
							  ,A.INCOTERMS   
							  ,A.DOM_EXP   
							  ,A.FCST_TYPE   
							  ,A.MEASURE  
							  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
								 WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
								 ELSE '' END AS MEASURE_GROUP  
							  ,A.YYYYMMDD   
							  ,A.QTY  
							  , 'P', 1
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 		
								AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
										ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)									 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
												  (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE4 END)										 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE5 END)											
							  , NULL AS AS_FROM_SITE
							  , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				--FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
				FROM (
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5
					  FROM [dbo].[DM_PLN_MKT_FCST] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
					  UNION ALL
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5
					  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
				 ) AS A
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE				
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
										ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE 1 = 1											   
				--[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. START
				/*
				AND A.ATTRIBUTE9 >= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																		, DT.BASIS_YYYYMMDD
																FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																													ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																AND DAYOFWEEK = D.FROM_DAY) E
													WHERE E.RK = D.FROM_WEEK)
				AND A.ATTRIBUTE9 <= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																					ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																		, DT.BASIS_YYYYMMDD
																FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																WHERE BASIS_YYYYMMDD >=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																													ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																AND DAYOFWEEK = D.TO_DAY) E
													WHERE E.RK = D.TO_WEEK) 
				*/
				--[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. END
				AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
				AND A.DIVISION_ID =@p_division_id			  
				AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
				AND A.QTY <> 0

				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 하여, 주석처리한다. START
				/*
				--EDI Org.계획(CUST_FCST_EDI[Org.])
-- [20240312] 개별 insert 함					UNION ALL
INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE
										)
				SELECT   'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  ,A.PROJECT_CODE   
							  ,A.SCM_SITE_ID   
							  ,PLANT_SITE_ID   
							  ,A.ITEM_ID   
							  ,A.INCOTERMS   
							  ,A.DOM_EXP   
							  ,A.FCST_TYPE   
							  ,A.MEASURE  
							  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
								 WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
								 ELSE '' END AS MEASURE_GROUP  
							  ,A.YYYYMMDD   
							  ,A.QTY  
							  , 'P', 1
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'))
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
										ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)									 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
												  (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE4 END)										 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE5 END)											
							  , NULL AS AS_FROM_SITE
				FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE				
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
										ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER_ORG D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER_ORG WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE 1 = 1
				
				AND A.ATTRIBUTE9 >= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																		, DT.BASIS_YYYYMMDD
																FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																													ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																AND DAYOFWEEK = D.FROM_DAY) E
													WHERE E.RK = D.FROM_WEEK)
				AND A.ATTRIBUTE9 <= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																					ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																		, DT.BASIS_YYYYMMDD
																FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																													ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																AND DAYOFWEEK = D.TO_DAY) E
													WHERE E.RK = D.TO_WEEK) 
				AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
				AND A.DIVISION_ID =@p_division_id
				AND A.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
				AND A.QTY <> 0
				*/
				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 하여, 주석처리한다. END

				--RPA계획(CUST_FCST) 
-- [20240312] 개별 insert 함					UNION ALL
INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)
				SELECT  'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  , A.PROJECT_CODE   
							  , A.SCM_SITE_ID   
							  , PLANT_SITE_ID   
							  , A.ITEM_ID   
							  , A.INCOTERMS   
							  , A.DOM_EXP   
							  , A.FCST_TYPE   
							  , A.MEASURE
							  , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										ELSE '' END AS MEASURE_GROUP  
							  , A.YYYYMMDD   
							  , A.QTY  
							  , 'P', 1
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								--[E20241126-000426]_Customer Fcst용으로 만든다 START
								--AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))		
								AND MEASURE IN ('CUSTOMER FCST'))					
								--[E20241126-000426]_Customer Fcst용으로 만든다 END				
							  , (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										--[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
										-- ELSE A.LAST_UPDATED_BY + '_EXCEL' END)			
										 ELSE A.LAST_UPDATED_BY END)												 
							  , NULL
							  , NULL
							  , NULL AS AS_FROM_SITE
							  , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				--FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
				FROM (
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY
					  FROM [dbo].[DM_PLN_MKT_FCST] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
					  UNION ALL
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY
					  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
					 ) AS A
				JOIN #SELECT_MEASURE B 
				ON A.MEASURE = B.MEASURE
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE 1 = 1
				--[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. START
				/*
				AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									 FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD
																												FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																												WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																												CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																									ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																												AND DAYOFWEEK = D.FROM_DAY) E
																									 WHERE E.RK = D.FROM_WEEK)
				AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									 FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																																	ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD
																												FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																												WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																												CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																									 ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																												AND DAYOFWEEK = D.TO_DAY) E
																									 WHERE E.RK = D.TO_WEEK)	
				*/																					 
				--[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. END
				AND A.YYYYMMDD >= @v_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
				AND A.DIVISION_ID = @p_division_id
				--[E20241126-000426]_Customer Fcst용으로 만든다 START
				--AND A.MEASURE	 IN ('CUST_FCST', 'Customer FCST') 
				AND A.MEASURE	 IN ('Customer FCST') 
				--[E20241126-000426]__Customer Fcst으로 만든다 END
				AND A.QTY <> 0
						 
				--[E20241126-000426]_CUST_FCST용으로 만든다 START
				INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)
				SELECT  'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  , A.PROJECT_CODE   
							  , A.SCM_SITE_ID   
							  , PLANT_SITE_ID   
							  , A.ITEM_ID   
							  , A.INCOTERMS   
							  , A.DOM_EXP   
							  , A.FCST_TYPE   
							  , A.MEASURE
							  , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										ELSE '' END AS MEASURE_GROUP  
							  , A.YYYYMMDD   
							  , A.QTY  
							  , 'P', 1
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST'))								
							  , A.LAST_UPDATED_BY 									 
							  , NULL
							  , NULL
							  , NULL AS AS_FROM_SITE
							  , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				--FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
				FROM (
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY
					  FROM [dbo].[DM_PLN_MKT_FCST] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
					  UNION ALL
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY
					  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
					 ) AS A
				JOIN #SELECT_MEASURE B 
				ON A.MEASURE = B.MEASURE
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE 1 = 1
				AND A.YYYYMMDD >= @v_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
				AND A.DIVISION_ID = @p_division_id
				AND A.MEASURE	 IN ('CUST_FCST')
				AND A.QTY <> 0				
				--[E20241126-000426]_CUST_FCST용으로 만든다 END

-- [20240312] 개별 insert 함					UNION ALL
INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)
				SELECT   'CURRENT' AS VERSION_NO
						, NULL AS CUTOFF_YYYYMMDD
						, A.DIVISION_ID 
						,A.PROJECT_CODE 
						,A.SCM_SITE_ID 
						,PLANT_SITE_ID 
						,A.ITEM_ID 
						,A.INCOTERMS 
						,A.DOM_EXP 
						,A.FCST_TYPE
						,A.MEASURE
						,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
							  WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
							  ELSE '' END AS MEASURE_GROUP
						,A.YYYYMMDD
						,A.QTY
						, 'R', 2
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 END
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   --[E20241126-000426]_CUST_FCST 추가 START
												   --AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												   AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												   --[E20241126-000426]_CUST_FCST 추가 END
										 WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
										   ELSE (SELECT CREATE_DATE FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE = A.MEASURE
												   ) END)		
							  , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
													(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
															--[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
															-- ELSE A.LAST_UPDATED_BY + '_EXCEL' END)
															 ELSE A.LAST_UPDATED_BY END)
										--[E20241126-000426]_CUST_FCST 추가 START
										 --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
										 WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
										--[E20241126-000426]_CUST_FCST 추가 END
												   (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
																	  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
															 ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
												   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
																				   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
																				   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
																				   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
										   ELSE (SELECT LAST_UPDATED_BY FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
												   AND MEASURE = A.MEASURE
												   ) END)
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 END
											(CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
															   (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE4 END)
									ELSE NULL END)		
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 END
											(CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
															   (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE5 END)
								ELSE NULL END)
						--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
                        , CASE WHEN A.DIVISION_ID IN ('81', '82') THEN ISNULL(A.ATTRIBUTE10, '')  ELSE '' END AS AS_FROM_SITE 
						--, '-' AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						, A.CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE  A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD < @v_now_yyyymmdd
					AND A.DIVISION_ID =@p_division_id
					AND A.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'														
													   --[E20241126-000426]_ORG데이터는 화면에서 보여주지 않기로 했으므로 주석처리한다. START
													   /*
													   , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
													   , 'Material_Temp[Org.]', 'Backorder[Org.]'							
													   */
													   --[E20241126-000426]_ORG데이터는 화면에서 보여주지 않기로 했으므로 주석처리한다. END
													   , 'CUST_FCST', 'Customer FCST'
													   ,'SCM_FCST') --SCM_FCST 조건 추가 [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
					AND A.QTY <> 0

				--EDI 실적(CUST_FCST_EDI)
-- [20240312] 개별 insert 함					UNION ALL
INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)
				SELECT   'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  ,A.PROJECT_CODE   
							  ,A.SCM_SITE_ID   
							  ,PLANT_SITE_ID   
							  ,A.ITEM_ID   
							  ,A.INCOTERMS   
							  ,A.DOM_EXP   
							  ,A.FCST_TYPE  
							  ,A.MEASURE  
							  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
								 WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
								 ELSE '' END AS MEASURE_GROUP  
							  ,A.YYYYMMDD  
							  ,A.QTY  
							  , 'R', 2
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
										ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)									 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
												  (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE4 END)										 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE5 END)
							  , NULL AS AS_FROM_SITE 
							  --, '-' AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							  , A.CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
										ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE  1 = 1
				--[E20241126-000426]_화면에서 보여주지 않는 데이터는 배치에서 삭제한다. START
				/*
				AND A.ATTRIBUTE9 >= (SELECT BASIS_YYYYMMDD 
												  FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																	 , DT.BASIS_YYYYMMDD
															 FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															 WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																														   CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																												 ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															 AND DAYOFWEEK = D.FROM_DAY) E
												  WHERE E.RK = D.FROM_WEEK)
				AND A.ATTRIBUTE9 <= (SELECT BASIS_YYYYMMDD 
												  FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																				 ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																	  , DT.BASIS_YYYYMMDD
															 FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															 WHERE BASIS_YYYYMMDD >=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																														   CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																												 ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															 AND DAYOFWEEK = D.TO_DAY) E
												  WHERE E.RK = D.TO_WEEK) 
				*/
				--[E20241126-000426]_화면에서 보여주지 않는 데이터는 배치에서 삭제한다. END
				AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD < @v_now_yyyymmdd
				AND A.DIVISION_ID =@p_division_id
				AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')												   													   
				AND A.QTY <> 0

--[E20241126-000426]_ORG데이터를 보여주지 않도록 하기로 했으므로 소스도 주석처리한다. START
/*
				--EDI Org. 실적(CUST_FCST_EDI[Org.])
-- [20240312] 개별 insert 함					UNION ALL
INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE
										)
				SELECT   'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  ,A.PROJECT_CODE   
							  ,A.SCM_SITE_ID   
							  ,PLANT_SITE_ID   
							  ,A.ITEM_ID   
							  ,A.INCOTERMS   
							  ,A.DOM_EXP   
							  ,A.FCST_TYPE  
							  ,A.MEASURE  
							  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
								 WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
								 ELSE '' END AS MEASURE_GROUP  
							  ,A.YYYYMMDD  
							  ,A.QTY  
							  , 'R', 2
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'))
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
										ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)									 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
												  (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE4 END)										 
							  , (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE5 END)
							  , NULL AS AS_FROM_SITE 
				FROM DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
										ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER_ORG D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER_ORG WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE  1 = 1
				AND A.ATTRIBUTE9 >= (SELECT BASIS_YYYYMMDD 
												  FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																	 , DT.BASIS_YYYYMMDD
															 FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															 WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																														   CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																												 ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															 AND DAYOFWEEK = D.FROM_DAY) E
												  WHERE E.RK = D.FROM_WEEK)
				AND A.ATTRIBUTE9 <= (SELECT BASIS_YYYYMMDD 
												  FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																				 ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																	  , DT.BASIS_YYYYMMDD
															 FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															 WHERE BASIS_YYYYMMDD >=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																														   CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																												 ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															 AND DAYOFWEEK = D.TO_DAY) E
												  WHERE E.RK = D.TO_WEEK) 
				AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD < @v_now_yyyymmdd
				AND A.DIVISION_ID =@p_division_id
				AND A.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
				AND A.QTY <> 0				
*/
--[E20241126-000426]_ORG데이터를 보여주지 않도록 하기로 했으므로 소스도 주석처리한다. END

				--RPA 실적(CUST_FCST)
-- [20240312] 개별 insert 함					UNION ALL
INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)
				SELECT  'CURRENT' AS VERSION_NO  
							, NULL AS CUTOFF_YYYYMMDD  
							, A.DIVISION_ID   
							, A.PROJECT_CODE   
							, A.SCM_SITE_ID   
							, PLANT_SITE_ID   
							, A.ITEM_ID   
							, A.INCOTERMS   
							, A.DOM_EXP   
							, A.FCST_TYPE  
							, A.MEASURE
							, CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
									WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
									ELSE '' END AS MEASURE_GROUP  
							, A.YYYYMMDD  
							, A.QTY  
							, 'R', 2
							, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
							WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
							AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
							--[E20241126-000426]_Customer Fcst용으로 만든다 START
							--AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))		
							AND MEASURE IN ('CUSTOMER FCST'))				
							--[E20241126-000426]_Customer Fcst용으로 만든다 START				
							, (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										--[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
										--ELSE A.LAST_UPDATED_BY + '_EXCEL' END)						
										ELSE A.LAST_UPDATED_BY END)													 
							, NULL
							, NULL							 
							, NULL AS AS_FROM_SITE 
							--, '-' AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							, A.CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B 
				ON A.MEASURE = B.MEASURE
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
										ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE 1 = 1 
				--[E20241126-000426]_화면에서 보여주지 않을 데이터는 배치에서 삭제하도록 한다. START
				/*
				AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									 FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD
																												FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																												WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																												CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																									ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																												AND DAYOFWEEK = D.FROM_DAY) E
																									 WHERE E.RK = D.FROM_WEEK)
				AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									 FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																																	ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD
																												FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																												WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																												CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																									ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																												AND DAYOFWEEK = D.TO_DAY) E
																									 WHERE E.RK = D.TO_WEEK)	
				*/
				--[E20241126-000426]_화면에서 보여주지 않을 데이터는 배치에서 삭제하도록 한다. END																
				AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD < @v_now_yyyymmdd
				AND A.DIVISION_ID =@p_division_id
				--[E20241126-000426]_Customer Fcst용으로 만든다 START
				--AND A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST')
				AND A.MEASURE IN ('CUSTOMER FCST')
				--[E20241126-000426]_Customer Fcst용으로 만든다 END
				AND A.QTY <> 0

				--[E20241126-000426]_CUST_FCST용으로 만든다 START
				INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)
				SELECT  'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  , A.PROJECT_CODE   
							  , A.SCM_SITE_ID   
							  , PLANT_SITE_ID   
							  , A.ITEM_ID   
							  , A.INCOTERMS   
							  , A.DOM_EXP   
							  , A.FCST_TYPE   
							  , A.MEASURE
							  , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										ELSE '' END AS MEASURE_GROUP  
							  , A.YYYYMMDD   
							  , A.QTY  
							  , 'P', 1
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST'))								
							  , A.LAST_UPDATED_BY 									 
							  , NULL
							  , NULL
							  , NULL AS AS_FROM_SITE
							  --, '-' AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							  , A.CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B 
				ON A.MEASURE = B.MEASURE
				LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID
					AND A.SCM_SITE_ID = C.SCM_SITE_ID
					AND C.SITE_TYPE		= 'SALES'
					AND C.VALID_YN		= 'Y'
					AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID
					AND D.END_CUSTOMER = C.END_CUSTOMER
					AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = A.DIVISION_ID
									 							AND END_CUSTOMER = C.END_CUSTOMER
									 							AND SCM_SITE_ID = A.SCM_SITE_ID), '-')
				WHERE 1 = 1															
				AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD < @v_now_yyyymmdd
				AND A.DIVISION_ID = @p_division_id
				AND A.MEASURE	 IN ('CUST_FCST')
				AND A.QTY <> 0				
				--[E20241126-000426]_CUST_FCST용으로 만든다 END


--PRINT ( 'A1--07--09 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
				/*
				IF EXISTS ( SELECT * FROM #SELECT_MEASURE
							   WHERE MEASURE IN ('CUST_FCST_ORG', 'Customer Fcst[Org.]') )
				BEGIN

					INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE 
										)
					SELECT  'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  , A.PROJECT_CODE   
							  , A.SCM_SITE_ID   
							  , PLANT_SITE_ID   
							  , A.ITEM_ID   
							  , A.INCOTERMS   
							  , A.DOM_EXP   
							  , A.FCST_TYPE   
							  , 'CUST_FCST_ORG' AS MEASURE
							  , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										ELSE '' END AS MEASURE_GROUP  
							  , A.YYYYMMDD   
							  , A.QTY  
							  , 'P', 1
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))								
							  , (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										 ELSE A.LAST_UPDATED_BY + '_EXCEL' END)										 
							  , NULL
							  , NULL
							  , NULL AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'CUST_FCST'
						AND B.MEASURE = 'CUST_FCST_ORG'
					LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
					ON A.DIVISION_ID = C.DIVISION_ID
						AND A.SCM_SITE_ID = C.SCM_SITE_ID
						AND C.SITE_TYPE		= 'SALES'
						AND C.VALID_YN		= 'Y'
						AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
											ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
					LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG D WITH(NOLOCK)
					ON A.DIVISION_ID = D.DIVISION_ID
						AND D.END_CUSTOMER = C.END_CUSTOMER
						AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 								WHERE DIVISION_ID = A.DIVISION_ID
									 								AND END_CUSTOMER = C.END_CUSTOMER
									 								AND SCM_SITE_ID = A.SCM_SITE_ID), '-')				
					WHERE 1 = 1
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																										 FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																															, DT.BASIS_YYYYMMDD
																													FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																													WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																													CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																										ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																													AND DAYOFWEEK = D.FROM_DAY) E
																										 WHERE E.RK = D.FROM_WEEK)
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																										 FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																																		ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																															, DT.BASIS_YYYYMMDD
																													FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																													WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																													CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																										ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																													AND DAYOFWEEK = D.TO_DAY) E
																										 WHERE E.RK = D.TO_WEEK)				
					AND A.YYYYMMDD >= @v_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
					AND A.DIVISION_ID = @p_division_id
					AND A.MEASURE = 'CUST_FCST'
					AND A.QTY <> 0

					UNION ALL
					SELECT  'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  , A.PROJECT_CODE   
							  , A.SCM_SITE_ID   
							  , PLANT_SITE_ID   
							  , A.ITEM_ID   
							  , A.INCOTERMS   
							  , A.DOM_EXP   
							  , A.FCST_TYPE   
							  , 'Customer FCST[Org.]' AS MEASURE
							  , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										ELSE '' END AS MEASURE_GROUP  
							  , A.YYYYMMDD   
							  , A.QTY  
							  , 'P', 1
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))								
							  , (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										 ELSE A.LAST_UPDATED_BY + '_EXCEL' END)										 
							  , NULL
							  , NULL
							  , NULL AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'Customer FCST'
						AND B.MEASURE = 'Customer FCST[Org.]'
					LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
					ON A.DIVISION_ID = C.DIVISION_ID
						AND A.SCM_SITE_ID = C.SCM_SITE_ID
						AND C.SITE_TYPE		= 'SALES'
						AND C.VALID_YN		= 'Y'
						AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
											ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
					LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG D WITH(NOLOCK)
					ON A.DIVISION_ID = D.DIVISION_ID
						AND D.END_CUSTOMER = C.END_CUSTOMER
						AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 								WHERE DIVISION_ID = A.DIVISION_ID
									 								AND END_CUSTOMER = C.END_CUSTOMER
									 								AND SCM_SITE_ID = A.SCM_SITE_ID), '-')		
					WHERE 1 = 1
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																										 FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																															, DT.BASIS_YYYYMMDD
																													FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																													WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																													CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																										ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																													AND DAYOFWEEK = D.FROM_DAY) E
																										 WHERE E.RK = D.FROM_WEEK)
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																										 FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																																		ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																															, DT.BASIS_YYYYMMDD
																													FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																													WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																													CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																										ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																													AND DAYOFWEEK = D.TO_DAY) E
																										 WHERE E.RK = D.TO_WEEK)			
					AND A.YYYYMMDD >= @v_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
					AND A.DIVISION_ID =@p_division_id
					AND A.MEASURE = 'Customer FCST'
					AND A.QTY <> 0

					UNION ALL
					SELECT  'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  , A.PROJECT_CODE   
							  , A.SCM_SITE_ID   
							  , PLANT_SITE_ID   
							  , A.ITEM_ID   
							  , A.INCOTERMS   
							  , A.DOM_EXP   
							  , A.FCST_TYPE  
							  , 'CUST_FCST_ORG' AS MEASURE
							  , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										ELSE '' END AS MEASURE_GROUP  
							  , A.YYYYMMDD  
							  , A.QTY  
							  , 'R', 2
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))								
							  , (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										 ELSE A.LAST_UPDATED_BY + '_EXCEL' END)										 
							  , NULL
							  , NULL		
							  , NULL AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'CUST_FCST'
						AND B.MEASURE = 'CUST_FCST_ORG'
					LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
					ON A.DIVISION_ID = C.DIVISION_ID
						AND A.SCM_SITE_ID = C.SCM_SITE_ID
						AND C.SITE_TYPE		= 'SALES'
						AND C.VALID_YN		= 'Y'
						AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
											ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
					LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG D WITH(NOLOCK)
					ON A.DIVISION_ID = D.DIVISION_ID
						AND D.END_CUSTOMER = C.END_CUSTOMER
						AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 								WHERE DIVISION_ID = A.DIVISION_ID
									 								AND END_CUSTOMER = C.END_CUSTOMER
									 								AND SCM_SITE_ID = A.SCM_SITE_ID), '-')		
					WHERE  1 = 1
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																										FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD
																												FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																												WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																												CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																									ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																												AND DAYOFWEEK = D.FROM_DAY) E
																										WHERE E.RK = D.FROM_WEEK)
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																										FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																																	ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD
																												FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																												WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																												CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																									ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																												AND DAYOFWEEK = D.TO_DAY) E
																										WHERE E.RK = D.TO_WEEK)			
					AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD < @v_now_yyyymmdd
					AND A.DIVISION_ID =@p_division_id
					AND A.MEASURE = 'CUST_FCST'
					AND A.QTY <> 0

					UNION ALL
					SELECT  'CURRENT' AS VERSION_NO  
							  , NULL AS CUTOFF_YYYYMMDD  
							  , A.DIVISION_ID   
							  , A.PROJECT_CODE   
							  , A.SCM_SITE_ID   
							  , PLANT_SITE_ID   
							  , A.ITEM_ID   
							  , A.INCOTERMS   
							  , A.DOM_EXP   
							  , A.FCST_TYPE  
							  , 'Customer FCST[Org.]' AS MEASURE
							  , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										ELSE '' END AS MEASURE_GROUP  
							  , A.YYYYMMDD  
							  , A.QTY  
							  , 'R', 2
							  , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS 
								AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))								
							  , (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										 ELSE A.LAST_UPDATED_BY + '_EXCEL' END)										 
							  , NULL
							  , NULL	
							  , NULL AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'Customer FCST'
						AND B.MEASURE = 'Customer FCST[Org.]'
					LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
					ON A.DIVISION_ID = C.DIVISION_ID
						AND A.SCM_SITE_ID = C.SCM_SITE_ID
						AND C.SITE_TYPE		= 'SALES'
						AND C.VALID_YN		= 'Y'
						AND (CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(C.END_CUSTOMER, '-')
											ELSE ISNULL(REPLACE(C.END_CUSTOMER, '-', ''), '') END) <> ''
					LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG D WITH(NOLOCK)
					ON A.DIVISION_ID = D.DIVISION_ID
						AND D.END_CUSTOMER = C.END_CUSTOMER
						AND D.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 								WHERE DIVISION_ID = A.DIVISION_ID
									 								AND END_CUSTOMER = C.END_CUSTOMER
									 								AND SCM_SITE_ID = A.SCM_SITE_ID), '-')		
					WHERE  1 = 1
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																										 FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																															, DT.BASIS_YYYYMMDD
																													FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																													WHERE BASIS_YYYYMMDD <=(CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																													CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																										ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																													AND DAYOFWEEK = D.FROM_DAY) E
																										 WHERE E.RK = D.FROM_WEEK)
					AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																										 FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2
																																		ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																															, DT.BASIS_YYYYMMDD 
																													FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																													WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																													CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																										ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																													AND DAYOFWEEK = D.TO_DAY) E
																										 WHERE E.RK = D.TO_WEEK)			
					AND A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD < @v_now_yyyymmdd
					AND A.DIVISION_ID =@p_division_id
					AND A.MEASURE = 'Customer FCST'
					AND A.QTY <> 0

				END
				
				*/
				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
			END

--SELECT @P_FROM_YYYYMMDD, @v_now_yyyymmdd
--SELECT * FROM #SELECT_MEASURE


print 'E1--' + convert(varchar(30), getdate(), 121)
			IF ( @p_version_no LIKE '%MF%' OR @p_version_no LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
			BEGIN
			
				BEGIN
					INSERT INTO #T_LAST_DATA_SETUP_C
					SELECT X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
							 , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
					FROM (
							  SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
										--[E20241126-000426]_CUST_FCST 추가 START
	 								    --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
	 								    , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
										--[E20241126-000426]_CUST_FCST 추가 END
																			   --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
																			   -- , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
																			   --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
																				) THEN
														   (CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																			  MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
																	ELSE MAX(A.ATTRIBUTE9) END)
											     ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  --FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
								FROM (
									  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									  ,F.LAST_UPDATED_BY,F.LAST_UPDATE_DATE,F.ATTRIBUTE9,F.VERSION_NO,F.CUTOFF_TYPE
									  FROM [dbo].[DM_PLN_MKT_FCST_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
									  UNION ALL
									  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									  ,F.LAST_UPDATED_BY,F.LAST_UPDATE_DATE,F.ATTRIBUTE9,F.VERSION_NO,F.CUTOFF_TYPE
									  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
									 ) AS A
							  JOIN #SELECT_MEASURE B WITH(NOLOCK)
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 ELSE B.MEASURE END)
							  JOIN #T_VERSION C WITH(NOLOCK)
							  ON A.VERSION_NO = C.VERSION_NO
								AND (A.CUTOFF_TYPE LIKE '%MF%' OR A.CUTOFF_TYPE LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
							  WHERE A.DIVISION_ID = @p_division_id							  
							  AND A.QTY <> 0
							  GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
							  UNION ALL
							  SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
										--[E20241126-000426]_CUST_FCST 추가 START
	 								    --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
	 								    , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
										--[E20241126-000426]_CUST_FCST 추가 END
																			   --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
																			   --, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
																			   --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
																				) THEN
														   (CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																			  MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
																	ELSE MAX(A.ATTRIBUTE9) END)
											     ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  FROM DM_PLN_MKT_FCST_RESULT_C A WITH(NOLOCK)
							  JOIN #SELECT_MEASURE B 
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 ELSE B.MEASURE END)
							  JOIN #T_VERSION C WITH(NOLOCK)
							  ON A.VERSION_NO = C.VERSION_NO
								AND (A.CUTOFF_TYPE LIKE '%MF%' OR A.CUTOFF_TYPE LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
							  WHERE A.DIVISION_ID = @p_division_id							  
							  AND A.QTY <> 0
							  GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
							  ) X
					WHERE ISNULL(X.PROJECT_CODE, '') <> ''
					AND ISNULL(X.SCM_SITE_ID, '') <> ''
					AND ISNULL(X.ITEM_ID, '') <> ''
					GROUP BY X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
				END

				INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE, CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
										)  
				SELECT   CASE WHEN @p_division_id ='82' THEN E.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO
						,A.CUTOFF_YYYYMMDD
						,A.DIVISION_ID 
						,A.PROJECT_CODE 
						,A.SCM_SITE_ID 
						,A.PLANT_SITE_ID 
						,A.ITEM_ID 
						,A.INCOTERMS 
						,A.DOM_EXP 
						,A.FCST_TYPE
						,A.MEASURE
						,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
							  WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
							  ELSE '' END AS MEASURE_GROUP
						,A.YYYYMMDD 
						,A.QTY
						,'P', 3
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 END
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   --[E20241126-000426]_CUST_FCST 추가 START
												   --AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												   AND MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												   --[E20241126-000426]_CUST_FCST 추가 START
										 WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
										   ELSE (SELECT CREATE_DATE FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE = A.MEASURE
												   ) END)		
							  , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
													(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
															--[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
															-- ELSE A.LAST_UPDATED_BY + '_EXCEL' END)		
															 ELSE A.LAST_UPDATED_BY END)																			   
										 --[E20241126-000426]_CUST_FCST 추가 START
										 --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
										 WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
										 --[E20241126-000426]_CUST_FCST 추가 END
												   (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
																	  (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
															 ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
												   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
																				   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
																				   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
																				   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
										   ELSE (SELECT LAST_UPDATED_BY FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE = A.MEASURE												   
												   ) END)									   
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN					   
						, (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN					   
						--[E20241126-000426]_CUST_FCST 추가 END
											(CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
															   (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE4 END)
									ELSE NULL END)						   
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 END
											(CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
															   (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE5 END)
								ELSE NULL END)								
						--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
						, CASE WHEN A.DIVISION_ID IN ('81', '82') THEN ISNULL(A.ATTRIBUTE10,'')  ELSE '' END  AS AS_FROM_SITE 
						--[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 START
						--, '-' AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						, A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						--[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 END
				--FROM DM_PLN_MKT_FCST_C AS A WITH(NOLOCK)
				FROM (
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.LAST_UPDATE_DATE,F.ATTRIBUTE4,F.ATTRIBUTE5,F.ATTRIBUTE9,F.VERSION_NO,F.CUTOFF_TYPE,F.CUTOFF_YYYYMMDD
					  FROM [dbo].[DM_PLN_MKT_FCST_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
					  UNION ALL
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.LAST_UPDATE_DATE,F.ATTRIBUTE4,F.ATTRIBUTE5,F.ATTRIBUTE9,F.VERSION_NO,F.CUTOFF_TYPE,F.CUTOFF_YYYYMMDD
					  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
					 ) AS A
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE 
				JOIN SCM_MST_SITE C (NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
				--JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
				JOIN #T_VERSION E ON A.VERSION_NO = E.VERSION_NO
					AND (E.VERSION_NO LIKE '%MF%' OR E.VERSION_NO LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
				WHERE   A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
						AND A.YYYYMMDD >= E.NOW_YYYYMMDD
						AND A.DIVISION_ID = @p_division_id
						AND A.MEASURE NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
						AND A.QTY <> 0 
				
				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
				/*
				UNION ALL
				SELECT   CASE WHEN @p_division_id ='82' THEN E.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO  
							  ,A.CUTOFF_YYYYMMDD  
							  ,A.DIVISION_ID   
							  ,A.PROJECT_CODE   
							  ,A.SCM_SITE_ID   
							  ,A.PLANT_SITE_ID   
							  ,A.ITEM_ID   
							  ,A.INCOTERMS   
							  ,A.DOM_EXP   
							  ,A.FCST_TYPE  
							  ,A.MEASURE  
							  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
								 WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
								 ELSE '' END AS MEASURE_GROUP  
							  ,A.YYYYMMDD   
							  ,A.QTY  
							  ,'P', 3
							  ,(SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
								AND MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'))
							  ,(CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												 (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
										ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)
							  ,(CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
												 (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE4 END)										 
							  ,(CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												 (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
										ELSE A.ATTRIBUTE5 END)
							  , NULL  AS AS_FROM_SITE 
				FROM DM_PLN_MKT_FCST_C AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE 
				JOIN SCM_MST_SITE C (NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
				--JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
				JOIN #T_VERSION E ON A.VERSION_NO = E.VERSION_NO
					AND E.VERSION_NO LIKE '%MF%'
				WHERE   A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd						
						AND A.DIVISION_ID = @p_division_id
						AND A.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
						AND A.QTY <> 0 
				*/
				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END

				UNION ALL
				SELECT   CASE WHEN @p_division_id ='82' THEN C.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO 
						,A.CUTOFF_YYYYMMDD
						,A.DIVISION_ID 
						,A.PROJECT_CODE 
						,A.SCM_SITE_ID 
						,A.PLANT_SITE_ID 
						,A.ITEM_ID 
						,A.INCOTERMS 
						,A.DOM_EXP 
						,A.FCST_TYPE
						,A.MEASURE
						,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
							  WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
							  ELSE '' END AS MEASURE_GROUP
						,A.YYYYMMDD 
						,A.QTY
						,'R', 4	   
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 START
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO												   
												   --[E20241126-000426]_CUST_FCST 추가 START
												   --AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												   AND MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
												   --[E20241126-000426]_CUST_FCST 추가 END
										 WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
										WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
										   ELSE (SELECT CREATE_DATE FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												  WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												  AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												  AND MEASURE = A.MEASURE
												  ) END)		
							  , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
													(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
															--[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
															 --ELSE A.LAST_UPDATED_BY + '_EXCEL' END)					
															 ELSE A.LAST_UPDATED_BY END)															  
										 --[E20241126-000426]_CUST_FCST 추가 START
										 --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
										 WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN									  
										 --[E20241126-000426]_CUST_FCST 추가 END
												   (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
																	 (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
															 ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)
										 WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
												  (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
												   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
																				   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
																				   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
																				   AND MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
										   ELSE (SELECT LAST_UPDATED_BY FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
												   WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
												   AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
												   AND MEASURE = A.MEASURE
												   ) END)										  
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN						  
						--[E20241126-000426]_CUST_FCST 추가 END
											(CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
															   (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE4 END)
									ELSE NULL END)										  
						--[E20241126-000426]_CUST_FCST 추가 START
						--, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						, (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
						--[E20241126-000426]_CUST_FCST 추가 END
											(CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
															   (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
													 ELSE A.ATTRIBUTE5 END)
								ELSE NULL END)
						--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
						, CASE WHEN A.DIVISION_ID IN ('81', '82') THEN ISNULL(A.ATTRIBUTE10,'')  ELSE '' END  AS AS_FROM_SITE 
						--, '-' AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						, A.CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM DM_PLN_MKT_FCST_RESULT_C AS A WITH(NOLOCK)
				JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				JOIN #T_VERSION C ON A.VERSION_NO = C.VERSION_NO
					AND (C.VERSION_NO LIKE '%MF%' OR C.VERSION_NO LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
				WHERE   A.YYYYMMDD >= @p_from_yyyymmdd
						AND A.YYYYMMDD < C.NOW_YYYYMMDD
						AND A.DIVISION_ID =@p_division_id
						AND A.MEASURE NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
											 ,'SCM_FCST') --SCM_FCST 조건 추가 [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
						AND A.QTY <> 0

				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START		
				/*
				IF EXISTS ( SELECT * FROM #SELECT_MEASURE
							   WHERE MEASURE IN ('CUST_FCST_ORG', 'Customer Fcst[Org.]') )
				BEGIN

					INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
										, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
										, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
										, AS_FROM_SITE --20230825
										)  
					SELECT   CASE WHEN @p_division_id ='82' THEN E.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO  
							  ,A.CUTOFF_YYYYMMDD  
							  ,A.DIVISION_ID   
							  ,A.PROJECT_CODE   
							  ,A.SCM_SITE_ID   
							  ,A.PLANT_SITE_ID   
							  ,A.ITEM_ID   
							  ,A.INCOTERMS   
							  ,A.DOM_EXP   
							  ,A.FCST_TYPE  
							  , 'CUST_FCST_ORG' AS MEASURE
							  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
								 WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
								 ELSE '' END AS MEASURE_GROUP  
							  ,A.YYYYMMDD   
							  ,A.QTY  
							  ,'P', 3
							  ,(SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
								WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
								AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
								AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))								
							  ,(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
								 	    ELSE A.LAST_UPDATED_BY + '_EXCEL' END)
							  ,NULL
							  ,NULL
							  , NULL  AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST_C AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'CUST_FCST'
						AND B.MEASURE = 'CUST_FCST_ORG' 
					JOIN SCM_MST_SITE C (NOLOCK) 
					ON A.DIVISION_ID = C.DIVISION_ID 
						AND A.SCM_SITE_ID = C.SCM_SITE_ID 
						AND C.VALID_YN = 'Y'				
					JOIN #T_VERSION E ON A.VERSION_NO = E.VERSION_NO
						AND E.VERSION_NO LIKE '%MF%'
					WHERE   A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
							AND A.YYYYMMDD >= E.NOW_YYYYMMDD
							AND A.DIVISION_ID = @p_division_id
							AND A.MEASURE = 'CUST_FCST'
							AND A.QTY <> 0 

					UNION ALL
					SELECT   CASE WHEN @p_division_id ='82' THEN E.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO  
								  ,A.CUTOFF_YYYYMMDD  
								  ,A.DIVISION_ID   
								  ,A.PROJECT_CODE   
								  ,A.SCM_SITE_ID   
								  ,A.PLANT_SITE_ID   
								  ,A.ITEM_ID   
								  ,A.INCOTERMS   
								  ,A.DOM_EXP   
								  ,A.FCST_TYPE  
								  , 'Customer FCST[Org.]' AS MEASURE
								  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
									 WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
									 ELSE '' END AS MEASURE_GROUP  
								  ,A.YYYYMMDD   
								  ,A.QTY  
								  ,'P', 3
								  ,(SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
									WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
									AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
									AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))								
								  ,(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
								 			ELSE A.LAST_UPDATED_BY + '_EXCEL' END)
								  ,NULL
								  ,NULL
								  , NULL  AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST_C AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'Customer FCST'
						AND B.MEASURE = 'Customer FCST[Org.]' 
					JOIN SCM_MST_SITE C (NOLOCK) 
					ON A.DIVISION_ID = C.DIVISION_ID 
						AND A.SCM_SITE_ID = C.SCM_SITE_ID 
						AND C.VALID_YN = 'Y'				
					JOIN #T_VERSION E ON A.VERSION_NO = E.VERSION_NO
						AND E.VERSION_NO LIKE '%MF%'
					WHERE   A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd
							AND A.YYYYMMDD >= E.NOW_YYYYMMDD
							AND A.DIVISION_ID = @p_division_id
							AND A.MEASURE = 'Customer FCST'
							AND A.QTY <> 0 
					
					UNION ALL
					SELECT   CASE WHEN @p_division_id ='82' THEN C.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO   
								  ,A.CUTOFF_YYYYMMDD  
								  ,A.DIVISION_ID   
								  ,A.PROJECT_CODE   
								  ,A.SCM_SITE_ID   
								  ,A.PLANT_SITE_ID   
								  ,A.ITEM_ID   
								  ,A.INCOTERMS   
								  ,A.DOM_EXP   
								  ,A.FCST_TYPE  
								  ,'CUST_FCST_ORG' AS MEASURE
								  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										   WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										   ELSE '' END AS MEASURE_GROUP  
								  ,A.YYYYMMDD   
								  ,A.QTY  
								  ,'R', 4 
								  ,(SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
									WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
									AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
									AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))											
								  ,(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										    ELSE A.LAST_UPDATED_BY + '_EXCEL' END)											 
								  ,NULL
								  ,NULL
								  , NULL  AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST_RESULT_C AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'CUST_FCST'
						AND B.MEASURE = 'CUST_FCST_ORG'
					JOIN #T_VERSION C ON A.VERSION_NO = C.VERSION_NO
						AND C.VERSION_NO LIKE '%MF%'
					WHERE   A.YYYYMMDD >= @p_from_yyyymmdd
							AND A.YYYYMMDD < C.NOW_YYYYMMDD
							AND A.DIVISION_ID =@p_division_id
							AND A.MEASURE = 'CUST_FCST'
							AND A.QTY <> 0 

					UNION ALL
					SELECT   CASE WHEN @p_division_id ='82' THEN C.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO   
								  ,A.CUTOFF_YYYYMMDD  
								  ,A.DIVISION_ID   
								  ,A.PROJECT_CODE   
								  ,A.SCM_SITE_ID   
								  ,A.PLANT_SITE_ID   
								  ,A.ITEM_ID   
								  ,A.INCOTERMS   
								  ,A.DOM_EXP   
								  ,A.FCST_TYPE  
								  ,'Customer FCST[Org.]' AS MEASURE
								  ,CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'  
										   WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP  
										   ELSE '' END AS MEASURE_GROUP  
								  ,A.YYYYMMDD   
								  ,A.QTY  
								  ,'R', 4 
								  ,(SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
									WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
									AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
									AND MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))											
								  ,(CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY + '_RPA'
										    ELSE A.LAST_UPDATED_BY + '_EXCEL' END)											 
								  ,NULL
								  ,NULL
								  , NULL  AS AS_FROM_SITE 
					FROM DM_PLN_MKT_FCST_RESULT_C AS A WITH(NOLOCK)
					JOIN #SELECT_MEASURE B 
					ON A.MEASURE = 'Customer FCST'
						AND B.MEASURE = 'Customer FCST[Org.]'
					JOIN #T_VERSION C ON A.VERSION_NO = C.VERSION_NO
						AND C.VERSION_NO LIKE '%MF%'
					WHERE   A.YYYYMMDD >= @p_from_yyyymmdd
							AND A.YYYYMMDD < C.NOW_YYYYMMDD
							AND A.DIVISION_ID =@p_division_id
							AND A.MEASURE = 'Customer FCST'
							AND A.QTY <> 0 

				END
				*/
				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END		

			END

			--EDI 소급적용
			IF ( @p_version_no LIKE '%ME%' )
			BEGIN

				BEGIN

					INSERT INTO #T_LAST_DATA_SETUP_C
					SELECT X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
							 , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
					FROM (
							  SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
										--[E20241126-000426]_CUST_FCST 추가 START
	 								    --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
	 								    , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
									    --[E20241126-000426]_CUST_FCST 추가 END
																				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START		
																				--, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
																				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END		
																				) THEN
														   (CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																			  MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
																	ELSE MAX(A.ATTRIBUTE9) END)
												  ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  --FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
								FROM (
									  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									  ,F.LAST_UPDATED_BY,F.LAST_UPDATE_DATE,F.ATTRIBUTE9,F.VERSION_NO
									  FROM [dbo].[DM_PLN_MKT_FCST_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
									  UNION ALL
									  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									  ,F.LAST_UPDATED_BY,F.LAST_UPDATE_DATE,F.ATTRIBUTE9,F.VERSION_NO
									  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
							 ) AS A
							  JOIN #SELECT_MEASURE B 
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 ELSE B.MEASURE END)
							  JOIN #T_VERSION C WITH(NOLOCK)
							  ON A.VERSION_NO = C.VERSION_NO
								AND C.VERSION_NO LIKE '%ME%'
							  WHERE A.DIVISION_ID = @p_division_id							  
							  AND A.QTY <> 0
							  GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
							  UNION ALL
							  SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
									   --[E20241126-000426]_CUST_FCST 추가 START
	 								   --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
	 								   , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
									   --[E20241126-000426]_CUST_FCST 추가 END
																				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START		
																				--, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
																				--[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END		
																				) THEN
														   (CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																			  MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
																	ELSE MAX(A.ATTRIBUTE9) END)
												  ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  FROM DM_PLN_MKT_FCST_RESULT_C A WITH(NOLOCK)
							  JOIN #SELECT_MEASURE B 
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 ELSE B.MEASURE END)
							  JOIN #T_VERSION C WITH(NOLOCK)
							  ON A.VERSION_NO = C.VERSION_NO
								AND C.VERSION_NO LIKE '%ME%'
							  WHERE A.DIVISION_ID = @p_division_id							  
							  AND A.QTY <> 0
							  GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
							  ) X
					WHERE ISNULL(X.PROJECT_CODE, '') <> ''
					AND ISNULL(X.SCM_SITE_ID, '') <> ''
					AND ISNULL(X.ITEM_ID, '') <> ''
					GROUP BY X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
				END

				INSERT INTO #RAW_DATA ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
							, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
							, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
							, AS_FROM_SITE ,CELL_PROD_SITE_ID  -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							)  
				SELECT    A.VERSION_NO
							, A.CUTOFF_YYYYMMDD  
							, A.DIVISION_ID   
							, A.PROJECT_CODE   
							, A.SCM_SITE_ID   
							, A.PLANT_SITE_ID   
							, A.ITEM_ID   
							, A.INCOTERMS   
							, A.DOM_EXP   
							, A.FCST_TYPE  
							, A.MEASURE  
							, '' AS MEASURE_GROUP  
							, A.YYYYMMDD   
							, A.QTY  
							, 'P', 5
							, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_C WITH(NOLOCK)
							  WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
							  AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND VERSION_NO = A.VERSION_NO
							  --[E20241126-000426]_CUST_FCST 추가 START
							  --AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
							  AND MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
							  --[E20241126-000426]_CUST_FCST 추가 END
													   --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START		
													   --, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
													   --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END	
													   ))
							, (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) + '_EDI'
									   ELSE A.ATTRIBUTE5 + '_' + A.LAST_UPDATED_BY END)										 
							, (CASE WHEN ISNULL(A.ATTRIBUTE4, '') = '' THEN
												(SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
									   ELSE A.ATTRIBUTE4 END)									 
							, (CASE WHEN ISNULL(A.ATTRIBUTE5, '') = '' THEN
												(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID)
									   ELSE A.ATTRIBUTE5 END)									   
							--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
							, CASE WHEN A.DIVISION_ID IN ('81', '82') THEN ISNULL(A.ATTRIBUTE10,'')  ELSE '' END  AS AS_FROM_SITE 							
							--[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 START
							--, '-' AS CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가					
							, A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가					
							--[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 END
				--FROM DM_PLN_MKT_FCST_C AS A WITH(NOLOCK)
				FROM (
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5,F.VERSION_NO,F.CUTOFF_YYYYMMDD
					  FROM [dbo].[DM_PLN_MKT_FCST_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 2
					  UNION ALL
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5,F.VERSION_NO,F.CUTOFF_YYYYMMDD
					  FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN_C] F WITH(NOLOCK) WHERE (CASE WHEN @p_division_id = '40' THEN 1 ELSE 2 END) = 1
					 ) AS A
				JOIN #SELECT_MEASURE B 
				ON A.MEASURE = B.MEASURE 
				JOIN SCM_MST_SITE C (NOLOCK) 
				ON A.DIVISION_ID = C.DIVISION_ID 
					AND A.SCM_SITE_ID = C.SCM_SITE_ID 
					AND C.VALID_YN = 'Y'				
				JOIN #T_VERSION E 
				ON A.VERSION_NO = E.VERSION_NO
					AND E.VERSION_NO LIKE '%ME%'
				WHERE A.YYYYMMDD >= @p_from_yyyymmdd 
				AND A.YYYYMMDD <= @p_to_yyyymmdd
				AND A.DIVISION_ID = @p_division_id						
				AND A.QTY <> 0 

			END
print 'E2--' + convert(varchar(30), getdate(), 121)			

/*
	SELECT a.DIVISION_ID, a.ITEM_ID, ITEM_CLASS
			, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
			, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
			, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
			, ENERGE, CELL_QUANTITY
			, MDM_PROJECT_NAME, CELL_TYPE, SCP_EXTRA_SPEC
	 INTO #TEMP_DM_MST_ITEM_SINGLE_V
	 FROM DM_MST_ITEM_SINGLE_V A
	 join ( select distinct division_id, item_id from #raw_data ) b on a.division_id = b.division_id and a.item_id = b.item_id
	WHERE A.DIVISION_ID = @p_division_id
*/

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	--원소스 주석처리
	/*
	--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 START
	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
		,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY 
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
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
						GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
					) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
				AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
			where 1=1
			AND		T1.DIVISION_ID = @P_DIVISION_ID
			AND		T1.ACTIVE_FLAG = 'Y'
			--WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
			--LGCE_FPDEV_TR.DBO.SCM_ITEM_M T1
			group by T1.DIVISION_ID, T1.ITEM_ID
	) T2	
	INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							ON	T2.ITEM_ID		like  b.tst 
							OR	T2.NICK_NAME	like  b.tst 						
	WHERE DIVISION_ID = @p_division_id					
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
			,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY
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
	SELECT DIVISION_ID
		 , ITEM_ID
		 , ITEM_NAME
		 , ITEM_CLASS 
		 , ITEM_CLASS_NAME
		 , NICK_NAME
		 , ITEM_TYPE
		 , MATERIAL_CLASS_NAME
		 , ITEM_UOM
		 , SPEC
		 , MDM_PROJECT_NAME
		 , MIN_CAPACITY
		 , FORECAST_INFO_BIZ_TYPE
		 , FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL
		 , FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_SPEC
		 , FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG
		 , CELL_TYPE
		 , ENERGE
		 , CELL_QUANTITY
		 , SCP_EXTRA_SPEC 
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM 
	(
		SELECT T1.DIVISION_ID
			 , T1.ITEM_ID
			 , T1.ITEM_NAME							AS ITEM_NAME
			 , T1.ITEM_CLASS						AS ITEM_CLASS
			 , T1.ITEM_CLASS_NAME					AS ITEM_CLASS_NAME
			 , T1.NICK_NAME							AS NICK_NAME
			 , T1.ITEM_TYPE							AS ITEM_TYPE				
			 , T1.MATERIAL_CLASS_NAME				AS MATERIAL_CLASS_NAME
			 , T1.ITEM_UOM							AS ITEM_UOM
			 , T1.SPEC								AS SPEC
			 , T1.MDM_PROJECT_NAME					AS MDM_PROJECT_NAME
			 , T1.MIN_CAPACITY						AS MIN_CAPACITY
			 , T2.FORECAST_INFO_BIZ_TYPE			AS FORECAST_INFO_BIZ_TYPE
			 , T2.FORECAST_INFO_PRODUCT_GROUP		AS FORECAST_INFO_PRODUCT_GROUP
			 , T2.FORECAST_INFO_CELL_MODEL			AS FORECAST_INFO_CELL_MODEL
			 , T2.FORECAST_INFO_CELL_PACK_COUNT		AS FORECAST_INFO_CELL_PACK_COUNT
			 , T2.FORECAST_INFO_SPEC				AS FORECAST_INFO_SPEC
			 , T2.FORECAST_INFOR_VERSION			AS FORECAST_INFOR_VERSION
			 , T1.ACTIVE_FLAG						AS ACTIVE_FLAG
			 , T2.CELL_TYPE							AS CELL_TYPE
			 , T1.ENERGE							AS ENERGE
			 , T1.CELL_QUANTITY						AS CELL_QUANTITY
			 , T1.SCP_EXTRA_SPEC					AS SCP_EXTRA_SPEC	
		FROM #TEMP_DM_MST_ITEM_SINGLE_A_V T1 WITH(NOLOCK)					
		INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_B_V T2 
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
		WHERE 1=1
	) T2						
	WHERE DIVISION_ID = @p_division_id					
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC 

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

	--해당 테이블의 데이터를 쓰므로, 데이터 완료된 후 KWH로 변경한다.
	UPDATE #TEMP_DM_MST_ITEM_SINGLE_V
	SET ENERGE = CASE WHEN ISNUMERIC(ENERGE) > 0 THEN ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 4) ELSE NULL END
	FROM #TEMP_DM_MST_ITEM_SINGLE_V
	--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 END

print 'E3A--' + convert(varchar(30), getdate(), 121)		
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	/*
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 START		
	CREATE TABLE #TEMP_W_CELL_CF_DATA
	(	  DIVISION_ID			VARCHAR(8) NULL
		, ITEM_ID				VARCHAR(200) NULL
		, ACCUMULATED_CHILD_QTY VARCHAR(300) NULL  )

	--조회시에 속도가 느려지는 부분이 있으므로, 81번 사업부가 아니라면 굳이 태우지 않는다.
	IF ( @P_DIVISION_ID LIKE '81%' )		
	BEGIN
		IF (SELECT COUNT(*)
			FROM SCM_MST_TITLESET_USER WITH (NOLOCK)
			WHERE USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
			AND PROGRAM_ID = @p_program_id
			AND USER_ID = @p_created_by
			AND COLUMN_NAME = 'CELL_PER_MODULE') > 0
		BEGIN
			SELECT CT.COMPANY_ID
					, MAX(CT.DIVISION_ID) AS DIVISION_ID
					, CT.SITE_ID 
					, CT.PLANT_ID
					, CT.MODEL_ID
					, CT.CHILD_ITEM_ID
					, SUM(CT.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
					, MAX(CT.CHILD_UOM) AS CHILD_UOM
			INTO #TEMP_CELL_CF
			FROM  (	SELECT CT.COMPANY_ID
						 , CT.DIVISION_ID
						 , CT.SITE_ID 
						 , CT.PARENT_ITEM_ID
						 , CT.MODEL_ID
						 , CT.CHILD_ITEM_ID 
						 , CT.PLANT_ID
						 , CT.ACCUMULATED_CHILD_QTY
						 , CT.CHILD_UOM
						 , ALT_PRIORITY
				FROM (  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, 
								PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM, 
								ACCUMULATED_CHILD_QTY, ALT_PRIORITY 
						FROM SCM_MODEL_COMP_TEMP_SN WITH(NOLOCK)
						GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, 
								PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM, 
								ACCUMULATED_CHILD_QTY, ALT_PRIORITY 
						) CT 
					,( SELECT SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
						FROM SCM_MST_ITEM_SN SIM WITH(NOLOCK)
						INNER JOIN SCM_MST_ITEM_CLASS_SN ICM WITH(NOLOCK)
								ON ICM.CLASS_ID = SIM.ITEM_CLASS
						INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
								ON B.LOOKUP_TYPE = 'DM_CELL_ITEM_LEVEL_ID'
								AND ICM.LEVEL_1_ID = B.SEGMENT1
						GROUP BY SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
						) CL
				WHERE  CT.COMPANY_ID  = CL.COMPANY_ID
				AND    CT.DIVISION_ID = CL.DIVISION_ID
				AND    CT.SITE_ID     = CL.SITE_ID
				AND    CT.CHILD_ITEM_ID = CL.ITEM_ID
				AND ((CL.FLOW_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID')/*('P5500', 'P9500')*/
					  AND CT.PARENT_ITEM_ID <>  '*')
					  OR CL.FLOW_ID NOT IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID'))
				AND    CT.ALT_PRIORITY      = 'Y'
			)  CT
			GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID
			
print 'E3B--' + convert(varchar(30), getdate(), 121)		

			INSERT INTO #TEMP_W_CELL_CF_DATA
			( DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY )
			SELECT T.DIVISION_ID, T.ITEM_ID, T.ACCUMULATED_CHILD_QTY
			FROM
			(  SELECT C.DIVISION_ID, C.ITEM_ID
					 , CASE WHEN D.ACCUMULATED_CHILD_QTY IS NULL THEN ( SELECT MAX(B.ACCUMULATED_CHILD_QTY)
																		FROM #TEMP_CELL_CF B
																		WHERE B.MODEL_ID LIKE CONCAT(SUBSTRING(C.ITEM_ID,1,10),'%'))
							ELSE D.ACCUMULATED_CHILD_QTY END AS ACCUMULATED_CHILD_QTY
				FROM (  SELECT	A.ITEM_ID, A.DIVISION_ID
						FROM	SCM_MST_SITE_ITEM A  WITH(NOLOCK),
								(   SELECT	DIVISION_ID, ITEM_ID                      
									FROM	SCM_MST_ITEM_SN  WITH(NOLOCK)
									GROUP BY DIVISION_ID, ITEM_ID   
								) B    
						WHERE	 1=1
						AND		 A.DIVISION_ID = B.DIVISION_ID
						AND		 A.ITEM_ID = B.ITEM_ID
						GROUP BY A.ITEM_ID, A.DIVISION_ID
				) C
				LEFT OUTER JOIN ( SELECT MODEL_ID, MAX(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
								  FROM #TEMP_CELL_CF
								  GROUP BY MODEL_ID
								 ) D
							 ON D.MODEL_ID = C.ITEM_ID
			) T
			GROUP BY T.DIVISION_ID, T.ITEM_ID, T.ACCUMULATED_CHILD_QTY
		END		
	END

	SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, CELL.ACCUMULATED_CHILD_QTY
	INTO #TEMP_SCM_MST_SITE_ITEM_CELL
	FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
	LEFT OUTER JOIN ( SELECT DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY
						FROM #TEMP_W_CELL_CF_DATA 
						GROUP BY DIVISION_ID, ITEM_ID, ACCUMULATED_CHILD_QTY
					) CELL 
					ON A.DIVISION_ID	= CELL.DIVISION_ID
				AND A.ITEM_ID		= CELL.ITEM_ID
	WHERE A.DIVISION_ID = @P_DIVISION_ID
	GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, CELL.ACCUMULATED_CHILD_QTY
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 END
	*/
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 END

print 'E3C--' + convert(varchar(30), getdate(), 121)		

	SELECT distinct A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
	        , A.APPLICATION, A.CUST_GROUP, A.ROUTE, A.CUST_GROUP_DTL
			, A.CELL_PER_CAR
			--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 START
			/*
			--, A.CELL_PER_MODULE 
			--[E20241015-000415]_81%인 경우에는 요청한 정보로 보여주고, 81% 아닌경우는 현황과 동일하게 작동한다. START
			, CASE WHEN @p_division_id LIKE '81%' THEN C.ACCUMULATED_CHILD_QTY ELSE A.CELL_PER_MODULE END AS CELL_PER_MODULE
			--[E20241015-000415]_81%인 경우에는 요청한 정보로 보여주고, 81% 아닌경우는 현황과 동일하게 작동한다. END
			*/
			, A.CELL_PER_MODULE 
			--[E20260123-001715]_[E20240904-001037] 소스 주석처리하고, 원소스로 복원 END
			, A.SALES_COMPANY
			, A.ATTRIBUTE1, A.ATTRIBUTE2
			, A.ATTRIBUTE5
			, A.ATTRIBUTE7
			, A.ATTRIBUTE8
			, A.REPORT_GROUP6
			, A.OWNER
			, DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'EN' )                AS OWNER_NAME
			, DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
			,(	SELECT SU.DEPT_ID  
				FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
				WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ',')) ) DEPT_ID
			, A.VALID_YN
			, A.PROJECT_S_OP_REPORT	--[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건 
	INTO #TEMP_SCM_MST_SITE_ITEM
	FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
	join ( select distinct division_id, SCM_SITE_ID, PROJECT_CODE, item_id from #raw_data ) b 
	  on a.division_id = b.division_id and A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND a.item_id = b.item_id	
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	/*
	--[E20241015-000415]_요청한 정보 + SCM_MST_SITE_ITEM한 데이터를 보여준다 START
	JOIN #TEMP_SCM_MST_SITE_ITEM_CELL C
	  ON A.DIVISION_ID = C.DIVISION_ID and A.SCM_SITE_ID = C.SCM_SITE_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.ITEM_ID = C.ITEM_ID
	--[E20241015-000415]_요청한 정보 + SCM_MST_SITE_ITEM한 데이터를 보여준다 END
	*/
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 END
	WHERE A.Division_id = @p_division_id

	DELETE A
	FROM #RAW_DATA A
	LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
	WHERE ( A.VERSION_NO = 'CURRENT' AND A.PLAN_RESULT = 'P' AND ISNULL(B.VALID_YN,'') <> 'Y')
		OR B.Division_id IS NULL
	
print 'E4--' + convert(varchar(30), getdate(), 121)			

			IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP')
			BEGIN
				INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
													, MEASURE, MEASURE_GROUP,YYYYMMDD,QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
													, AS_FROM_SITE , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
													)
				SELECT   VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
					,'MKT_FCST_RP' AS MEASURE
					,CASE WHEN A.DIVISION_ID = '40' THEN 'MKT_FCST_RP'
					      ELSE '' END AS MEASURE_GROUP
					, YYYYMMDD, QTY, PLAN_RESULT, 5
					, CREATE_DATE
					, LAST_UPDATED_BY
					, SENDER_CODE
					, SENDER_NAME
					, AS_FROM_SITE 
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #RAW_DATA A 
				WHERE A.MEASURE = 'MKT_FCST'
					AND A.PLAN_RESULT = 'P'

				INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
													, MEASURE, MEASURE_GROUP,YYYYMMDD,QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
													, AS_FROM_SITE ,CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
													)  
				SELECT   VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
					,'MKT_FCST_RP' AS MEASURE
					,CASE WHEN A.DIVISION_ID = '40' THEN 'MKT_FCST_RP'
					      ELSE '' END AS MEASURE_GROUP
					, YYYYMMDD, QTY, PLAN_RESULT, 6
					, CREATE_DATE
					, LAST_UPDATED_BY
					, SENDER_CODE
					, SENDER_NAME
					, AS_FROM_SITE 
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #RAW_DATA A 
				WHERE MEASURE = 'RTF_SYS_RP'
					AND A.PLAN_RESULT= 'R'
			END

			
			-----------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 START
			-----------------------------------------------------------------------------------------------------------------------------------
			IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'SCM_FCST')
			BEGIN
				INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
													, MEASURE, MEASURE_GROUP,YYYYMMDD,QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
													, AS_FROM_SITE ,CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
													)  
				SELECT   VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,INCOTERMS,DOM_EXP,FCST_TYPE
					,'SCM_FCST' AS MEASURE
					,CASE WHEN A.DIVISION_ID = '40' THEN 'SCM_FCST'
					      ELSE '' END AS MEASURE_GROUP
					, YYYYMMDD, QTY, PLAN_RESULT, 6
					, CREATE_DATE
					, LAST_UPDATED_BY
					, SENDER_CODE
					, SENDER_NAME
					, AS_FROM_SITE 
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #RAW_DATA A 
				WHERE MEASURE = 'RTF_SYS_RP'
					AND A.PLAN_RESULT= 'R'
			END
			-----------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 END
			-----------------------------------------------------------------------------------------------------------------------------------

		CREATE clustered INDEX idx_t1 ON #raw_data (division_id, project_code, scm_site_id, item_id )
--select * from #raw_data;return;

print 'E5--' + convert(varchar(30), getdate(), 121)

			--------------------------------------------------------------------------------------------------------------------------------------------
			-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
			--------------------------------------------------------------------------------------------------------------------------------------------
			BEGIN -- 필터링 시작

				IF ( @p_project_code <> '') -- 소형은 UI 에서 PROJECT DISABLE 됨
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					JOIN SCM_MST_PROJECT B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_project_code,',') 
									) C	ON B.PROJECT_CODE LIKE '%' + C.TOKEN + '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_project_code,',') 
									) D	ON B.PROJECT_NAME LIKE '%' + D.TOKEN + '%'

					WHERE C.TOKEN IS NULL AND D.TOKEN IS NULL
				END

--select * from #raw_data;return;
				IF ( @p_item_id <> '')
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_item_id,',') 
									) C	ON A.ITEM_ID LIKE '%' + C.TOKEN + '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_item_id,',') 
									) D	ON B.NICK_NAME LIKE '%' + D.TOKEN + '%'
					WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL
				END

--select * from #raw_data;return;
				IF ( @p_owner <> '')
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_owner,',') 
									) C	ON B.OWNER LIKE '%' + C.TOKEN + '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_owner,',') 
									) D	ON B.OWNER_NAME LIKE '%' + D.TOKEN + '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_owner,',') 
									) E	ON B.OWNER_NAME_KO LIKE '%' + E.TOKEN + '%'
					WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL  AND E.TOKEN IS NULL
				END
				
				IF ( @p_dept_id <> 'ALL')
				BEGIN
				--[PJ2024-50461] Team Mapping------------------------------------
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
						LEFT OUTER JOIN (	SELECT DISTINCT token 
											FROM dbo.String_Split(@p_dept_id,',') 
										) C	ON B.DEPT_ID = C.TOKEN
						WHERE C.TOKEN IS NULL
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
						LEFT OUTER JOIN SCM_MST_SITE B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = @P_DIVISION_ID
						LEFT OUTER JOIN (	SELECT DISTINCT token 
											FROM dbo.String_Split(@p_dept_id,',') 
										) C	ON B.DEPT_ID = C.TOKEN
						WHERE C.TOKEN IS NULL
					END
					*/
				END
				
				IF ( @p_end_customer <> 'ALL')
				BEGIN
					IF ( @P_DIVISION_ID = '40')
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN (	SELECT DISTINCT token 
											FROM dbo.String_Split(@p_end_customer,',') 
										) C	ON A.PROJECT_CODE = C.TOKEN
						WHERE C.TOKEN IS NULL
					END
					ELSE
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN SCM_MST_SITE B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = @P_DIVISION_ID
						LEFT OUTER JOIN (	SELECT DISTINCT token 
											FROM dbo.String_Split(@p_end_customer,',') 
										) C	ON B.END_CUSTOMER = C.TOKEN
						WHERE C.TOKEN IS NULL
					END
				END
				
				IF ( @p_scm_site_id <> 'ALL')
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_scm_site_id,',') 
									) C	ON A.SCM_SITE_ID = C.TOKEN
					WHERE C.TOKEN IS NULL
				END
				
				IF ( @p_plant_site_id <> 'ALL')
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_plant_site_id,',') 
									) C	ON A.PLANT_SITE_ID = C.TOKEN
					WHERE C.TOKEN IS NULL
				END

				IF ( @p_item_type <> 'ALL')
				BEGIN
					DELETE A
					FROM #RAW_DATA A
					LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split(@p_item_type,',') 
									) C	ON B.ITEM_TYPE = C.TOKEN
					WHERE C.TOKEN IS NULL
				END

				IF ( @p_biz_type <> 'ALL')
				BEGIN
					IF( @P_DIVISION_ID = '40' )
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
						LEFT OUTER JOIN (	SELECT DISTINCT token 
											FROM dbo.String_Split(@p_biz_type,',') 
										) C	ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
						WHERE C.TOKEN IS NULL
					END
					ELSE
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						JOIN SCM_MST_PROJECT B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
						LEFT OUTER JOIN (	SELECT DISTINCT token 
											FROM dbo.String_Split(@p_biz_type,',') 
										) C	ON B.BIZ_TYPE LIKE '%' + C.TOKEN + '%'
						WHERE C.TOKEN IS NULL
					END
				END

				IF ( @p_sender_code <> 'ALL')
				BEGIN
				  DELETE A  
				  FROM #RAW_DATA A  
				  LEFT OUTER JOIN (SELECT DISTINCT token
						FROM dbo.String_Split(@p_sender_code,',')
						) C ON A.SENDER_CODE = C.TOKEN
				  WHERE C.TOKEN IS NULL
				END

			END -- 필터링 끝
--select * from #raw_data;return;

print 'E6--' + convert(varchar(30), getdate(), 121)	

			-- 계획구간 PRICE 처리
			IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'LOC' )
			BEGIN
				INSERT INTO #RAW_DATA 
						( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
						, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
				SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID 
								,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, C.MEASURE, 'MKT_FCST_RP' AS MEASURE_GROUP, A.YYYYMMDD, C.PRICE, 'P', 9
								, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME  
				FROM (
						SELECT   DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID 
								,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME  
						FROM	#RAW_DATA A
						WHERE   A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN @V_NOW_YYYYMMDD
										      ELSE CONVERT(NCHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.CUTOFF_YYYYMMDD, 'MON')), 112)
										      END  and A.YYYYMMDD <= @p_to_yyyymmdd
								AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP') 
						) A
				JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
				JOIN SCM_MST_FUTURE_PRICE C (NOLOCK) ON A.DIVISION_ID		= C.DIVISION_ID
														AND A.PROJECT_CODE		= C.PROJECT_CODE
														AND A.SCM_SITE_ID		= C.SCM_SITE_ID
														AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
														AND A.ITEM_ID			= C.ITEM_ID
														AND A.INCOTERMS			= C.INCOTERMS
														AND A.DOM_EXP			= C.DOM_EXP
														AND A.FCST_TYPE			= C.FCST_TYPE
														AND B.basis_start_date	= C.YYYYMMDD
														AND C.YYYYMMDD			<= @p_to_yyyymmdd
				JOIN #SELECT_MEASURE D ON C.MEASURE = D.MEASURE

			END
--select * from #raw_data;return;

print 'F--' + convert(varchar(30), getdate(), 121)

		------------------------------------------------------------------------------------------
		--	필요없는 메저 삭제 
		------------------------------------------------------------------------------------------


		IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY'))
		BEGIN
			
			INSERT INTO #RAW_DATA 
					(VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
					, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					)  
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID 
					,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, B.MEASURE_CALC, A.MEASURE_GROUP, A.YYYYMMDD
					,CASE	WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
								CASE WHEN CHARINDEX('Cell',   C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR
									WHEN  CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0  AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN QTY/ ( D.CELL_PER_CAR/ D.CELL_PER_MODULE )
									WHEN  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0  THEN A.QTY
									ELSE 0 
								END 
							WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
								CASE WHEN CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
									WHEN ( CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', C.ITEM_CLASS_NAME) > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
									ELSE 0 
								END
							WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
							-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
							WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
								CASE WHEN ISNUMERIC(C.ENERGE) > 0 
									THEN (C.ENERGE * A.QTY)/1000
								END
							-- 20221214 rosia27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
							WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' THEN
								CASE WHEN ISNUMERIC(C.ENERGE) > 0 
									THEN (C.ENERGE * A.QTY)/1000
								END
							ELSE 0 
					END
					, A.PLAN_RESULT, 7
					, A.CREATE_DATE
					, A.LAST_UPDATED_BY
					, A.SENDER_CODE
					, A.SENDER_NAME
					, A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM	#RAW_DATA A WITH(NOLOCK)
			JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP' 
								ELSE 'RTF_SYS_RP'
								END AS MEASURE_ORI
						, A.MEASURE AS MEASURE_CALC
					FROM #SELECT_MEASURE A
					WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY')
					) B ON A.MEASURE = B.MEASURE_ORI
			JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
			LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
			WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' )

		END

		-- 20221214 rosia27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
		IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_ENERGY'))
		BEGIN
			INSERT INTO #RAW_DATA 
					(VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
					, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					)  
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID 
					,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, B.MEASURE_CALC, A.MEASURE_GROUP, A.YYYYMMDD
					,CASE   WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND A.PLAN_RESULT = 'P' THEN
								CASE WHEN ISNUMERIC(C.ENERGE) > 0 
									THEN (C.ENERGE * A.QTY)/1000
								END
							ELSE 0 
					END
					, A.PLAN_RESULT, 8
					, A.CREATE_DATE
					, A.LAST_UPDATED_BY
					, A.SENDER_CODE
					, A.SENDER_NAME
					, A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM	#RAW_DATA A WITH(NOLOCK)
			JOIN ( SELECT  'MKT_FCST_RP' AS MEASURE_ORI
						, A.MEASURE AS MEASURE_CALC
					FROM #SELECT_MEASURE A
					WHERE MEASURE IN ('MKT_FCST_ENERGY')
					) B ON A.MEASURE = B.MEASURE_ORI
			JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
			WHERE A.MEASURE IN ( 'MKT_FCST_RP')
		END

		DELETE A
		FROM #RAW_DATA A
		JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.SYSTEM_ADD = 'Y'

--select * from #raw_data;return;

print 'G--' + convert(varchar(30), getdate(), 121)


		------------------------------------------------------------------------------------------
		--	 [개발요청] 수요분석시스템_4_고객수요 Measure 통합(Cust. Fcst[Org.]에 CUST_FCST_EDI[Org.]를 추가) 20231207
		------------------------------------------------------------------------------------------		
			--[E20241030-000923]_CUST_FCST 데이터를 생성하기 때문에, 만들어 줄 필요가 없음. START
			/*
			IF EXISTS ( SELECT *
						FROM #RAW_DATA
						WHERE MEASURE IN ('CUST_FCST_EDI','CUST_FCST_EDI_ORG') )
			BEGIN  
				INSERT INTO #RAW_DATA 
						 ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
						 , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
						 , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME 
						 , AS_FROM_SITE  
						)
				SELECT    DISTINCT 
						  A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
						, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
						, CASE WHEN A.MEASURE IN ('CUST_FCST_EDI')  THEN 'CUST_FCST'  ELSE  'CUST_FCST_ORG'  END AS MEASURE
						, CASE WHEN A.MEASURE IN ('CUST_FCST_EDI')  THEN 'CUST_FCST'  ELSE  'CUST_FCST_ORG'  END AS MEASURE_GROUP
						, A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.GUBUN, A.CREATE_DATE
						, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME 
						, A.AS_FROM_SITE
				FROM #RAW_DATA A WITH(NOLOCK) 
				WHERE A.MEASURE IN ('CUST_FCST_EDI','CUST_FCST_EDI_ORG') 
			END
			*/ 				
			--[E20241030-000923]_CUST_FCST 데이터를 생성하기 때문에, 만들어 줄 필요가 없음. END
		------------------------------------------------------------------------------------------
		--	컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
		------------------------------------------------------------------------------------------


		-- 컬럼리스트 생성
		BEGIN
			DECLARE @v_sql_text          AS NVARCHAR(MAX);
			DECLARE @V_PV_LIST			 AS NVARCHAR(MAX);
			DECLARE @V_PV_COL_LIST		 AS NVARCHAR(MAX);
			DECLARE @V_PV_COL			 AS NVARCHAR(MAX);
			DECLARE @v_column_name		 AS NVARCHAR(100)
			DECLARE @v_column            AS NVARCHAR(1000);
			DECLARE @v_orderby           AS NVARCHAR(1000);
			DECLARE @v_column_text       AS NVARCHAR(1000);
			DECLARE @v_PV_column_name    AS NVARCHAR(100);
			DECLARE @v_PV_NAME			 AS NVARCHAR(50);
			DECLARE @v_column_type       AS NVARCHAR(50);
			DECLARE @v_column_value      AS NVARCHAR(50);
			DECLARE @v_sort_order_no    AS NVARCHAR(50);
    
			-----	날짜컬럼 -----------------------------------------------------------------------------------------------------------
			SELECT @V_PV_LIST = '', @V_PV_COL_LIST = '', @V_PV_COL = ''
			DECLARE c_bucket CURSOR FAST_FORWARD FOR 
				SELECT 
					 '[D_' + a.basis_yyyymmdd + '] AS D_' + A.BASIS_YYYYMMDD  AS column_name
					 ,'[D_' + a.basis_yyyymmdd + ']' AS PV_name
					 , a.basis_yyyymmdd + '_' + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
				WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd -- '20171101'  CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    a.basis_yyyymmdd <= @p_to_yyyymmdd   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				AND	   @p_bucket = 'DAILY'
				UNION ALL
				SELECT '[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + '] AS W_' + a.basis_yyyymm + a.iso_week  AS column_name
					 ,'[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + ']' AS PV_name
					 , a.basis_start_date + '_' + CONVERT(CHAR(2), 21) AS sort_order_no
				FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
				WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    a.basis_yyyymmdd <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				AND	   @p_bucket != 'ONLY_WEEKLY'
				GROUP BY a.basis_yyyymm
					   , a.iso_week    
					   , a.basis_start_date
				UNION ALL
				SELECT '[M_' + A.BASIS_YYYYMM + '] AS M_' + a.basis_yyyymm  AS column_name
					  , '[M_' + A.BASIS_YYYYMM + ']' AS PV_name
					  , MIN(a.basis_start_date) + '_' + CONVERT(CHAR(2), 1) AS sort_order_no
				FROM    [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
				WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				AND    a.basis_yyyymmdd <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
				AND	   @p_bucket != 'ONLY_WEEKLY'
				GROUP BY a.basis_yyyymm
				-- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
				UNION ALL
				SELECT '[W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK + '] AS W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6) + A.ISO_WEEK  AS COLUMN_NAME
					, '[W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK + ']' AS PV_NAME 
					, MAX(BASIS_YYYYMMDD)+ '_' +CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
				FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd 
				AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
				AND	   @p_bucket = 'ONLY_WEEKLY'
				GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
				ORDER BY sort_order_no  
				;

			OPEN c_bucket;
			FETCH NEXT FROM c_bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
										WHILE @@FETCH_STATUS = 0   
			BEGIN  
				SELECT @V_PV_COL_LIST	= @V_PV_COL_LIST + CASE WHEN @V_PV_COL_LIST <> '' THEN ',' ELSE '' END + @v_PV_column_name
					   , @V_PV_LIST		= @V_PV_LIST + CASE WHEN @V_PV_LIST <> '' THEN ',' ELSE '' END + @v_PV_name
					   , @V_PV_COL		= @V_PV_COL + CASE WHEN @V_PV_COL <> '' THEN ',' ELSE '' END + 'ISNULL(' +@v_PV_name+', 0) AS ' + @v_PV_name
                PRINT '@V_PV_COL_LIST:'+isnull(@V_PV_COL_LIST,'null')
                PRINT '@V_PV_LIST:'+isnull(@V_PV_LIST,'null')
                PRINT '@V_PV_COL:'+isnull(@V_PV_COL,'null')
				FETCH NEXT FROM c_Bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
			END;

			CLOSE c_bucket;  
			DEALLOCATE c_bucket;


			
    /* 20240518 KCW3408 속도개선_템프사용 */
    SELECT B.SCM_SITE_ID
	     , B.DIVISION_ID
	     , B.DEPT_ID
		 , K.SOLDTO_CODE
		 , B.VMI_YN
		 , B.END_CUSTOMER
		 , B.SOLDTO_CUSTOMER
		 , H.CITY_NAME 
		 , J.COUNTRY_NAME
		 , L.SHIPTO_DESCRIPTION
		 , L.SOLDTO_DESCRIPTION  
      INTO #TEMP_SCM_MST_SITE      
      FROM SCM_MST_SITE  B WITH(NOLOCK)  
      LEFT OUTER JOIN 
	       SCM_MST_SITE_CUSTOMER  K WITH(NOLOCK)
		   ON B.DIVISION_ID = K.DIVISION_ID 
		  AND B.SCM_SITE_ID = K.SCM_SITE_ID 
		  AND K.REP_YN = 'Y'    
      LEFT OUTER JOIN 
	       SCM_MST_CITY    H WITH(NOLOCK)
		   ON B.CITY = H.CITY     
      LEFT OUTER JOIN 
           SCM_MST_COUNTRY    J WITH(NOLOCK) 
		   ON B.COUNTRY = J.COUNTRY      
      LEFT OUTER JOIN 
	       SCM_MST_CUSTOMER   L WITH(NOLOCK)
		   ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE

			-----	일반 컬럼 -----------------------------------------------------------------------------------------------------------
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
	

			IF @i_Count = 0 
			BEGIN
				SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
					   , @OrderList = @OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM 
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT --TOP 100 
						C.SORT_ORDER_NO, 
						C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
					FROM [SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
					WHERE 1 = 1
						AND    C.PROGRAM_ID  = @p_Program_Id
						AND    C.SHEET_NAME  = @p_sheet_name
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
					   , @OrderList = @OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM 
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					 /*
					 kjj 수정(2024.6.24)
					 - GROUP_ID 화면표시 위해 [SCM_MST_TITLESET_USER] 조인 추가
					 - ITEM_ID의 정렬보다 무조건 바로 앞에 GROUP_ID가 위치하게 
					 */
				SELECT --TOP 100 
					--U.SORT_ORDER_NO
					CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  ISNULL(TU.SORT_ORDER_NO,95) - 0.5 ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO--kjj 수정(2024.6.24)
					, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE  
				FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
					INNER JOIN [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
						ON     U.PROGRAM_ID  = C.PROGRAM_ID
						AND    U.SHEET_NAME  = C.SHEET_NAME
						AND    U.COLUMN_NAME = C.COLUMN_NAME
						AND    U.PROGRAM_ID  = @p_Program_Id
						AND    U.SHEET_NAME  = @p_sheet_name
						AND    U.USER_ID = @p_created_by
						AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
						AND	   U.COLUMN_NAME NOT IN ( 'MEASURE','VERSION_NO') 
						LEFT OUTER JOIN [dbo].[SCM_MST_TITLESET_USER] TU WITH(NOLOCK)
						ON     TU.PROGRAM_ID  = C.PROGRAM_ID
						AND    TU.SHEET_NAME  = C.SHEET_NAME 
						AND    TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
						AND	   TU.COLUMN_NAME IN ('ITEM_ID') 
						AND    TU.USER_ID = @p_created_by
						--AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	-- 20190125 일단 주석처리 KHSONG
				---------
				UNION ALL
				---------
				/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
				/* kjj 수정(2024.6.24)
					UI 카테고리에서 GROUP_ID 표시되게 하였으므로 불필요한 조인 제거
				*/
				SELECT TOP 100 
				    	--CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  ISNULL(U.SORT_ORDER_NO,135) - 0.5 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
						C.SORT_ORDER_NO
					 , C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
				FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
				       /*LEFT OUTER JOIN [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
						ON     U.PROGRAM_ID  = C.PROGRAM_ID
						AND    U.SHEET_NAME  = C.SHEET_NAME 
						AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
						AND	   U.COLUMN_NAME IN ('ITEM_ID') 
						AND    U.USER_ID = @p_created_by*/
				WHERE  1 = 1
						AND    C.PROGRAM_ID  = @p_Program_Id
						AND    C.SHEET_NAME  = @p_sheet_name
						AND    C.VISIBLE_FLAG = 'N'
						AND    C.DEFAULT_FLAG = ''
						AND    C.VALID_YN     = 'Y'
						--AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	 -- 20190125 일단 주석처리 KHSONG
				) tbColList	
				ORDER BY SORT_ORDER_NO
			END
			SELECT @ColList = LEFT(@ColList, LEN(@ColList)-1)	
			SELECT @OrderList = LEFT(@OrderList, LEN(@OrderList)-1)	
	
			--[E20231128-000738]해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
			SELECT @ColList = @ColList + ',[NOTATION]'			

			--SELECT @ColList = REPLACE(@ColList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')
			--SELECT @OrderList = REPLACE(@OrderList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')
			SELECT @ColList = REPLACE(@ColList,'[VERSION_NO]','[VERSION_SORT],[VERSION_NO]')
			SELECT @ColList = REPLACE(@ColList,'[MEASURE]','[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]')
			SELECT @OrderList = REPLACE(@OrderList,'[VERSION_NO]','[VERSION_SORT] DESC,[VERSION_NO]')
			SELECT @OrderList = REPLACE(@OrderList,'[MEASURE]','[SORT_ORDER_NO]')

		END	--	컬럼생성 끝	---------------------------------------------------------------------------------------------------------------------
  
--SELECT * FROM #SELECT_MEASURE
--SELECT @ORDERlIST

  --select @V_PV_COL_LIST,   @V_PV_LIST,   @v_orderby,   @v_orderby
/*
			, DBO.FN_GET_DM_SALES_PLAN_WATERFALL_QTY2(A.MEASURE, ISNULL(D.ITEM_CLASS_NAME,''''), ISNULL(A.QTY,0), ISNULL(C.CELL_PER_CAR,0), ISNULL(C.CELL_PER_MODULE,0)
						, ''' + @p_cell_yn + N''', ISNULL(D.FORECAST_INFO_CELL_PACK_COUNT, 0), ''' + @P_DIVISION_ID + N''', ISNULL(D.FORECAST_INFO_BIZ_TYPE, '''')) AS QTY
*/

--select * from #raw_data where item_id = 'AMFMCC727-A1'
--	and division_id = '81'
--	--and scm_site_id = 'Ford_MX_TPZ'
--	--and project_code = 'A15FD5002'
--	and yyyymmdd = '20210831'
  /*
  2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
    UI Category Setup 에 등록(GROUP_ID) ORDER BY 필요, GROUP_ID 추가함
  */

		BEGIN	-- CTE 에서 사용할 SELECT COLUMN 정리
			
			DECLARE @V_SQL_SELECT NVARCHAR(4000)
			DECLARE @V_SQL_GROUPBY	NVARCHAR(4000)

			CREATE TABLE #T_COLUMN_SETUP (
				TBL_ALIAS			NVARCHAR(10)
			, COLUMN_NAME			NVARCHAR(100)
			, COLUMN_STRING		NVARCHAR(1000)
			, SORT_KEY			INT
			)
					
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DIVISION_ID', N'A.DIVISION_ID')
				--[PJ2024-50461] Team Mapping------------------------------------
				--INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID', N'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID', N'C.DEPT_ID')
				--[PJ2024-50461] Team Mapping------------------------------------
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER40', N'CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE '' '' END AS END_CUSTOMER40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER', N'ISNULL(B.END_CUSTOMER,'' '') AS END_CUSTOMER')  
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME', N'G.BIZ_TYPE AS BIZ_TYPE_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'COUNTRY_NAME', N'B.COUNTRY_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CITY_NAME', N'B.CITY_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID', N'A.SCM_SITE_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_CODE', N'A.PROJECT_CODE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_NAME', N'G.PROJECT_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_STATUS', N'G.PROJECT_STATUS')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_OWNER', N'G.PROJECT_OWNER')
			    INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'GROUP_ID', N'ISNULL(I.GROUP_ID,'' '') AS GROUP_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID', N'A.ITEM_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID40', N'A.ITEM_ID AS ITEM_ID40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_NAME', N'ISNULL(D.ITEM_NAME, '''') AS ITEM_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NICK_NAME', N'ISNULL(D.NICK_NAME, '''') AS NICK_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'INCOTERMS', N'A.INCOTERMS')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_TYPE', N'ISNULL(D.ITEM_TYPE, '''') AS ITEM_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FCST_TYPE', N'A.FCST_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DOM_EXP', N'A.DOM_EXP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PLANT_SITE_ID', N'A.PLANT_SITE_ID')
				--INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FROM_SITE_ID', N'A.FROM_SITE_ID')		-- [PJ2024-50611] 소형 매출 프로세스 개선
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VERSION_NO', N'A.VERSION_NO')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP', N'C.CUST_GROUP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP_DTL', N'C.CUST_GROUP_DTL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OWNER', N'C.OWNER_NAME AS OWNER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'APPLICATION', N'C.APPLICATION')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ROUTE', N'C.ROUTE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MDM_PROJECT_NAME', N'D.MDM_PROJECT_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MIN_CAPACITY', N'D.MIN_CAPACITY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME40', N'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_PRODUCT_GROUP', N'D.FORECAST_INFO_PRODUCT_GROUP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_MODEL', N'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_PACK_COUNT', N'D.FORECAST_INFO_CELL_PACK_COUNT')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_ALL', N'D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_SPEC', N'D.FORECAST_INFO_SPEC')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFOR_VERSION', N'D.FORECAST_INFOR_VERSION')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_MODEL_NICK_NAME', N'ISNULL(F.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VMI_YN', N'B.VMI_YN')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_TYPE', N'E.SEGMENT2 AS CELL_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_CAR', N'C.CELL_PER_CAR')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_MODULE', N'C.CELL_PER_MODULE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MODULE_PER_CAR', N'CASE WHEN C.CELL_PER_MODULE  <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ENERGE', N'D.ENERGE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QUANTITY', N'D.CELL_QUANTITY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRIORITY', N'C.ATTRIBUTE7 AS PRIORITY')				
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE', N'CASE WHEN A.MEASURE = ''Customer FCST'' THEN 
																																										(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA[P+P]'' 
																																												 ELSE ''Cust.FCST_EXCEL[P+P]'' END)
																																							  WHEN A.MEASURE = ''Customer FCST[Org.]'' THEN 
																																										(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA[Org.]'' 
																																												 ELSE ''Cust.FCST_EXCEL[Org.]'' END)
																																							  ELSE A.MEASURE END AS MEASURE')  
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE_GROUP', N'M.MEASURE_GROUP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_SALES', N'ISNULL(C.ATTRIBUTE1,'''') AS DMS_SALES')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_CUSTOMER', N'ISNULL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'REPORT_GROUP6', N'C.REPORT_GROUP6')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'TEAM_NAME_KO', N'N.DEPT_NAME_KO AS TEAM_NAME_KO')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_NAME_KO', N'O.DEPT_NAME_KO')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_BIZ_TYPE', N'D.FORECAST_INFO_BIZ_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE', N'G.BIZ_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CUSTOMER', N'B.SOLDTO_CUSTOMER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID40', N'CASE WHEN A.DIVISION_ID = ''40'' THEN A.SCM_SITE_ID ELSE '''' END AS SCM_SITE_ID40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_USE_YN', N'CASE  WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Req''  THEN ''Y''							
																																									WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN ( ''MKT_FCST_RP'',''MKT_FCST'' ) THEN ''Y''
																																									WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Plan'' THEN ''Y''																							
																																									WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE in (''RTF'',''RTF_SCP'',''RTF_SYS_RP'') THEN ''Y''																	
																																									ELSE ''N'' END AS SCP_USE_YN')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VERSION_SORT', N'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_EXTRA_SPEC', N'D.SCP_EXTRA_SPEC')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SALES_COMPANY', N'C.SALES_COMPANY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CODE', N'B.SOLDTO_CODE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_CELL', N'C.ATTRIBUTE8 AS KWH_CELL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_MODULE', N'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_MODULE * C.ATTRIBUTE8)) 
																									ELSE NULL END 
																									AS KWH_MODULE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_PACK', N'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_CAR * C.ATTRIBUTE8)) 
																									ELSE NULL END 
																									AS KWH_PACK')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATE_DATE', N'A.CREATE_DATE AS LAST_UPDATE_DATE')				
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATED_BY', N'A.LAST_UPDATED_BY AS LAST_UPDATED_BY')				
				--[E20241030-000923]_CUST_FCST 메져 추가 
				--INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_CODE', N'CASE WHEN A.MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_CODE', N'CASE WHEN A.MEASURE IN (''CUST_FCST'', ''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																																																   , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN A.SENDER_CODE ELSE '' '' END AS SENDER_CODE')  
				--[E20241030-000923]_CUST_FCST 메져 추가 
				--INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_NAME', N'CASE WHEN A.MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_NAME', N'CASE WHEN A.MEASURE IN (''CUST_FCST'', ''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																																																   , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN A.SENDER_NAME ELSE '' '' END AS SENDER_NAME') 	
				--INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'AS_FROM_SITE', N'CASE WHEN A.DIVISION_ID = ''81'' THEN ''1'' ELSE '''' END AS_FROM_SITE') --20230825		
				--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'AS_FROM_SITE', N'CASE WHEN A.DIVISION_ID IN ( ''81'', ''82'') THEN A.AS_FROM_SITE ELSE '''' END AS_FROM_SITE') --20230825

				--[E20231017-000634]	
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_NICKNAME',  N'A.CELL_NICKNAME  AS CELL_NICKNAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRODUCT_LEVEL1', N'A.PRODUCT_LEVEL1 AS PRODUCT_LEVEL1')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRODUCT_LEVEL2', N'A.PRODUCT_LEVEL2 AS PRODUCT_LEVEL2')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRODUCT_LEVEL3', N'A.PRODUCT_LEVEL3 AS PRODUCT_LEVEL3')
				--[E20231128-000738]해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NOTATION', N'A.NOTATION AS NOTATION')
				
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
														ELSE COLUMN_STRING 
														END
				FROM #T 
				WHERE SEQ = @I

				SET @I += 1

			END
		END

--select * from #RAW_DATA; return;

		--[E20231017-000634] SCP정보수집	
		INSERT INTO #SCP_ITEM_INFO (DIVISION_ID, ITEM_ID,	  CELL_NICKNAME, BASIC_NICKNAME_CELL40, NICKNAME_40
								  , GROUP_CODE1, GROUP_CODE4, GROUP_CODE5,	 GROUP_CODE6, GROUP_CODE7
								  , CELL_TYPE_GROUP_NAME)
		SELECT *
		FROM (
			SELECT  SCP_P.DIVISION_ID
				  , SCP_P.ITEM_ID
				  , SCP_P.CELL_NICKNAME
				  , SCP_P.BASIC_NICKNAME_CELL40
				  , SCP_P.NICKNAME_40
				  , SCP_P.GROUP_CODE1
				  , SCP_P.GROUP_CODE4
				  , SCP_P.GROUP_CODE5
				  , SCP_P.GROUP_CODE6
				  , SCP_P.GROUP_CODE7
				  , CASE WHEN SCP_P.LEVEL_EXCEPT = 'EC' THEN 'POUCH'
						 WHEN SCP_P.LEVEL_EXCEPT = 'AM' THEN 'CYLINDRICAL'
						 WHEN SUBSTRING(SCP_P.ITEM_ID, 3, 1) = 'M' AND SCP_P.OPERATION_ID = 'P9500' THEN 'POUCH'
					ELSE SCP_G.CELL_TYPE_GROUP_NAME END AS CELL_TYPE_GROUP_NAME
			FROM (/* #TBLDYNAMICPIVOT_SCP0017_PRE */
					SELECT DIVISION_ID
						, FLOW_ID                       AS OPERATION_ID
						, ITEM_ID
						, SUBSTRING(A.ITEM_ID, 3, 1)    AS CELL_TYPE_CODE
						, SUBSTRING(A.ITEM_ID, 1, 2)    AS LEVEL_EXCEPT -- 예외적용
						, CASE WHEN SUBSTRING(A.DIVISION_ID, 1, 2) = '81'  THEN GROUP_CODE1
								WHEN A.DIVISION_ID = '82'                  THEN LEVEL2_CODE
							ELSE '' END AS CELL_NICKNAME
						, CASE WHEN SUBSTRING(A.ITEM_ID, 1, 2) = 'EC' THEN 'ESS'
							   WHEN SUBSTRING(A.ITEM_ID, 1, 2) = 'AM' THEN 'M50L'
						  ELSE CASE WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
																	   WHERE B.DIVISION_ID = A.DIVISION_ID 
																		--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 원소스 주석처리
																		--AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
																		AND B.ITEM_ID = (SELECT TOP 1 DOE FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V B WITH(NOLOCK) 
																						WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL))
									ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
										  WHERE B.DIVISION_ID = A.DIVISION_ID 
										  --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 원소스 주석처리
										  --AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
										  AND B.ITEM_ID = (SELECT TOP 1 DOE FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V B WITH(NOLOCK) 
										  WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)) END
						  END  AS BASIC_NICKNAME_CELL40
						, A.NICK_NAME  AS NICKNAME_40
						, A.GROUP_CODE4
						, A.GROUP_CODE5
						, A.GROUP_CODE6
						, A.GROUP_CODE7
						, A.GROUP_CODE1
						, CASE WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C' ELSE 'E' END  AS FLOW_TYPE	
					FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
					WHERE   1=1
					  AND (SUBSTRING(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 = '' OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
					  AND A.DIVISION_ID = @p_division_id
					  AND (( @p_item_id IS NULL OR @p_item_id ='') OR A.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
					  --AND (( @P_OPERATION_GROUP	IS NULL OR @P_OPERATION_GROUP ='') OR A.OPERATION_GROUP	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_OPERATION_GROUP, ',')))					  
			) SCP_P
			LEFT OUTER JOIN (
							/* #TBLDYNAMICPIVOT_SCP0017_CELL_TYPE_GROUP */
							SELECT  A.CODE                    AS CELL_TYPE_CODE
								, SUBSTRING(A.NAME, 1, 1)   AS FLOW_TYPE
								, A.GROUP_CODE              AS CELL_TYPE_GROUP_CODE
								, G.NAME                    AS CELL_TYPE_GROUP_NAME
								, A.DISPLAY_SEQ		
							FROM    
							(
								SELECT    B.SEGMENT1 CODE
										, B.SEGMENT2 NAME
										, B.SEGMENT3 GROUP_CODE
										, B.DISPLAY_SEQ
								FROM    SCM_ADM_LOOKUP_MASTER A		WITH(NOLOCK)
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE			       
								AND B.VALID_YN = 'Y'
								WHERE   1=1
								 AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_CODE'
								 AND A.VALID_YN      = 'Y'
							) A
							JOIN
							(
								SELECT    B.SEGMENT1 CODE
										, B.SEGMENT2 NAME
								FROM    SCM_ADM_LOOKUP_MASTER A		WITH(NOLOCK)
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
								WHERE   1=1
									AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_GROUP'
									AND A.VALID_YN      = 'Y'
							) G ON A.GROUP_CODE = G.CODE
			) SCP_G ON SCP_G.FLOW_TYPE = SCP_P.FLOW_TYPE AND SCP_G.CELL_TYPE_CODE  = SCP_P.CELL_TYPE_CODE  
		)  T;
		
		/* (DM + SCP) */
		INSERT INTO  #RAW_DATA_FINAL (
						  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
						, PLANT_SITE_ID
						--, FROM_SITE_ID
						, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP		
						, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN				
						, CREATE_DATE, LAST_UPDATED_BY	
						, SENDER_CODE, SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME
						, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
						, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		)
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			  , A.PLANT_SITE_ID
			  --, '-' AS FROM_SITE_ID				--[PJ2024-50611] 소형 매출 프로세스 개선
			  , A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.MEASURE_GROUP		
			  , A.YYYYMMDD, A.QTY, A.VALID_YN, A.PLAN_RESULT, A.GUBUN				
			  , A.CREATE_DATE, A.LAST_UPDATED_BY	
			  , A.SENDER_CODE, A.SENDER_NAME, A.AS_FROM_SITE
			  , B.CELL_NICKNAME  /* SUBSTRING(A.DIVISION_ID, 1,2) = '81' (GROUP_CODE1) 82 ESS (LEVEL2_CODE)  40 소형 ('') */
			  , CASE WHEN SUBSTRING(A.DIVISION_ID, 1,2) = '81' OR A.DIVISION_ID = '82' THEN GROUP_CODE6
					 ELSE B.CELL_TYPE_GROUP_NAME END PRODUCT_LEVEL1
			  , CASE WHEN SUBSTRING(A.DIVISION_ID, 1,2) = '81' OR A.DIVISION_ID = '82' THEN GROUP_CODE7
					 ELSE B.BASIC_NICKNAME_CELL40 END PRODUCT_LEVEL2
			  , CASE WHEN SUBSTRING(A.DIVISION_ID, 1,2) = '81' THEN GROUP_CODE5
					 WHEN A.DIVISION_ID = '82'				  THEN GROUP_CODE4
					 ELSE B.NICKNAME_40 END PRODUCT_LEVEL3	
			  , ISNULL(C.SEGMENT3, 'DEFAULT') AS NOTATION
			  , A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A WITH (NOLOCK)
		--LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B WITH (NOLOCK)  ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID 
		LEFT OUTER JOIN #SCP_ITEM_INFO B WITH (NOLOCK)  ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID 
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C (NOLOCK) ON C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION' AND A.MEASURE = C.SEGMENT2 AND A.DIVISION_ID = C.SEGMENT1
		WHERE 1=1
		

	--[E20240102-000545]_[마케팅PI] 82번 사업부 - VMI표기 로직 개선  START
	-------------------------------------------------------------------------------------------------------------------------
	/*
	CSR번호: [E20240102-000545]_[마케팅PI] 82번 사업부 - VMI표기 로직 개선 
	요청자: 오윤종
	작업이유: VMI_INV 메져의 데이터가 필요하다는 요청에 따라, 데이터를 생성하지는 않고,
			조회하는 기간 내에는 마지막 VMI_INV를 뿌려달라는 요청에 따라 해당 부분작업을 생성한다.
	대상데이터: VMI_INV는 MKT_FCST 데이터에 영향을 받으므로, 
			  VMI_INV 메져가 생성된 날짜 이후에 MKT_FCST메져의 QTY가 0이 아닌 VMI_INV 메져를 대상으로 데이터를 추출한다. 
	*/
	-------------------------------------------------------------------------------------------------------------------------
	--82번 사업부만 작업요청 대상	
	PRINT ( 'VMIINV--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

	IF @p_division_id = '82'
	BEGIN 

		IF OBJECT_ID (N'tempdb..#TempVmiInv', N'U') IS NOT NULL 
				DROP TABLE #TempVmiInv
		IF OBJECT_ID (N'tempdb..#TempVmiInvResult', N'U') IS NOT NULL 
				DROP TABLE #TempVmiInvResult

		CREATE TABLE #TempVmiInv 
		(	  DIVISION_ID		NVARCHAR(30)
			, PROJECT_CODE		NVARCHAR(50)
			, SCM_SITE_ID		NVARCHAR(30)
			, ITEM_ID			NVARCHAR(50)
			, DOM_EXP			NVARCHAR(3)
			, FCST_TYPE			NVARCHAR(20)
			, INCOTERMS			NVARCHAR(10)
			, MEASURE			NVARCHAR(50)
			, YYYYMMDD			CHAR(8)
			, PLANT_SITE_ID		NVARCHAR(30)
			, QTY				NUMERIC(30,10)
			, CELL_PROD_SITE_ID NVARCHAR(30) -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		)
			
		IF ( @p_version_no LIKE '%CURRENT%' )
		BEGIN
			--1). 해당 PERIOD 기간내의 VMI_INV, MKT_FCST, VMI_In_Plan, VMI_In_Req가 존재하는 데이터를 우선 구해서 TEMP에 넣어둔다. 

			INSERT INTO #TempVmiInv
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
			 ,CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.YYYYMMDD, B.PLANT_SITE_ID, B.QTY
			,B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM
			(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					 , RANK() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, CELL_PROD_SITE_ID ORDER BY YYYYMMDD DESC) AS SEQ -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM 
				(
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST WITH (NOLOCK)
					WHERE DIVISION_ID = @p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					UNION ALL
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					--,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					, CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST_RESULT WITH (NOLOCK)
					WHERE DIVISION_ID = @p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD >= @p_from_yyyymmdd
					AND YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) --RESULT 데이터를 참고하는 경우에는 당주 월요일 이전 데이터를 가져와야된다.
				) A
			) B
			WHERE SEQ = '1'
		END
		ELSE
			BEGIN
			INSERT INTO #TempVmiInv
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
			 ,CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.YYYYMMDD, B.PLANT_SITE_ID, B.QTY
			,B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM
			(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					 , RANK() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE ORDER BY YYYYMMDD DESC) AS SEQ
					 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM 
				(
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST_C WITH (NOLOCK)
					WHERE DIVISION_ID = @p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					UNION ALL
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST_RESULT_C WITH (NOLOCK)
					WHERE DIVISION_ID = @p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD >= @p_from_yyyymmdd
					AND YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) --RESULT 데이터를 참고하는 경우에는 당주 월요일 이전 데이터를 가져와야된다.
				) A
			) B
			WHERE SEQ = '1'
		END

		--2). 아이템둘 중, 'VMI_INV'메져의 YYYYMMDD보다 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req'메져는 대상정보에서 삭제한다. 
		DELETE C
		FROM #TempVmiInv C
		JOIN
		(
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM 
				(
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM #TempVmiInv
					WHERE MEASURE = 'VMI_INV'
				) A
			JOIN (
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM #TempVmiInv
					WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
				 ) B
			  ON A.DIVISION_ID		= B.DIVISION_ID
			 AND A.PROJECT_CODE		= B.PROJECT_CODE
			 AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			 AND A.ITEM_ID			= B.ITEM_ID
			 AND A.DOM_EXP			= B.DOM_EXP
			 AND A.FCST_TYPE		= B.FCST_TYPE
			 AND A.INCOTERMS		= B.INCOTERMS
			 AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
			 AND B.YYYYMMDD		   >= A.YYYYMMDD + 1
			 AND A.CELL_PROD_SITE_ID= B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		) T
		ON C.DIVISION_ID		= T.DIVISION_ID
		AND C.PROJECT_CODE		= T.PROJECT_CODE
		AND C.SCM_SITE_ID		= T.SCM_SITE_ID
		AND C.ITEM_ID			= T.ITEM_ID
		AND C.DOM_EXP			= T.DOM_EXP
		AND C.FCST_TYPE			= T.FCST_TYPE
		AND C.INCOTERMS			= T.INCOTERMS
		AND C.PLANT_SITE_ID		= T.PLANT_SITE_ID
		AND C.CELL_PROD_SITE_ID	= T.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가

		--3). 'VMI_INV' 메져 외의 타 데이터는 모두 삭제한다. 
		DELETE
		FROM #TempVmiInv
		WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req');
	
		--4). 들어가있는 데이터와 형식을 동일하게 맞추기위해서, 데이터 형식을 맞춰주는 작업을 진행한다.
		SELECT B.VERSION_NO, B.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE
			 , B.MEASURE_GROUP, A.YYYYMMDD, A.QTY, B.VALID_YN, B.PLAN_RESULT, B.GUBUN, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.AS_FROM_SITE
			 , B.CELL_NICKNAME, B.PRODUCT_LEVEL1, B.PRODUCT_LEVEL2, B.PRODUCT_LEVEL3, B.NOTATION
			 , B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		INTO #TempVmiInvResult
		FROM #TempVmiInv A
		JOIN #RAW_DATA_FINAL B 
		  ON A.DIVISION_ID		= B.DIVISION_ID
		 AND A.PROJECT_CODE		= B.PROJECT_CODE
		 AND A.SCM_SITE_ID		= B.SCM_SITE_ID
		 AND A.ITEM_ID			= B.ITEM_ID
		 AND A.DOM_EXP			= B.DOM_EXP
		 AND A.FCST_TYPE		= B.FCST_TYPE
		 AND A.INCOTERMS		= B.INCOTERMS
		 AND A.MEASURE			= B.MEASURE
		 AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
		 AND A.YYYYMMDD			= B.YYYYMMDD
		 AND A.CELL_PROD_SITE_ID= B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가

		--5). PERIOD 기간만큼 데이터를 생성한다. 
		INSERT INTO #TempVmiInvResult
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
		, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
		, SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION 
		, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		)
		SELECT DISTINCT	B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.MEASURE
			 , B.MEASURE_GROUP, A.BASIS_YYYYMMDD, B.QTY, B.VALID_YN, B.PLAN_RESULT, B.GUBUN, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.AS_FROM_SITE
			 , B.CELL_NICKNAME, B.PRODUCT_LEVEL1, B.PRODUCT_LEVEL2, B.PRODUCT_LEVEL3, B.NOTATION
			 , B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM SCM_SYS_CALENDAR_M A WITH (NOLOCK)
		LEFT OUTER JOIN #TempVmiInvResult B 
					 ON A.BASIS_YYYYMMDD	> B.YYYYMMDD 	
		WHERE A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
		AND A.BASIS_YYYYMMDD > B.YYYYMMDD 
	
		--모수로 잡았던 데이터는 삭제한다.
		DELETE A
		FROM #TempVmiInvResult A
		WHERE DIVISION_ID = '82'
		AND MEASURE = 'VMI_INV'
		AND EXISTS ( SELECT division_id 
					 FROM #TempVmiInv Z
					 WHERE 1=1
  					 AND A.division_id    = Z.division_id      
  					 AND A.project_code   = Z.project_code   
					 AND A.scm_site_id    = Z.scm_site_id  
					 AND A.item_id        = Z.item_id      
					 AND A.dom_exp        = Z.dom_exp      
					 AND A.fcst_type      = Z.fcst_type    
					 AND A.incoterms      = Z.incoterms    
					 AND A.plant_site_id  = Z.plant_site_id
					 AND A.YYYYMMDD		  = Z.YYYYMMDD
					 AND A.CELL_PROD_SITE_ID = Z.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					 );

		--6). 임시로 만든 데이터를, 주 임시테이블에 INSERT 한다.  
		INSERT INTO #RAW_DATA_FINAL
		(  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
		 , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
		 , SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
		 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		 )
		SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
			 , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
	  		 , SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
			 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #TempVmiInvResult
	END


	/* [PJ2024-50611] 소형 매출 프로세스 개선*/

	--IF @p_division_id = '40'
	--BEGIN 
	--	-- 1) #RAW_DATA_FINAL 의 Measure = 'RTF_SYS_RP / RTF_SCP'가 있는 것은 삭제한다. 단, 계획구간에서만

	--	SELECT * 
	--	INTO #RAW_DATA_FINAL_TEMP40 
	--	FROM #RAW_DATA_FINAL WITH(NOLOCK) 
	--	WHERE DIVISION_ID = @p_division_id
	--	AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN')
	--	AND   YYYYMMDD >= @V_NOW_YYYYMMDD
	--	;

	--	SELECT  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
	--			, MEASURE, MEASURE_GROUP
	--			, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
	--			, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
	--			, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
	--	INTO #RAW_DATA_FINAL_TEMP40_KEY 
	--	FROM #RAW_DATA_FINAL_TEMP40 WITH(NOLOCK) 
	--	GROUP BY VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP
	--			, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
	--			, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
	--			, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가

	--	DELETE #RAW_DATA_FINAL
	--	WHERE DIVISION_ID = @p_division_id
	--	AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN')
	--	AND   YYYYMMDD >= @V_NOW_YYYYMMDD
	--	;

	--	--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
	--	--DM_PLN_RTF_ALLOCATION 관련 구문 삭제

	--	--IF ( @p_version_no LIKE '%CURRENT%' )
	--	--BEGIN

	--	--	-- 2-1) #RAW_DATA_FINAL 에 DM_PLN_RTF_ALLOCATION 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.

	--	--	INSERT INTO #RAW_DATA_FINAL
	--	--	SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
	--	--		, B.PLANT_SITE_ID
	--	--		, B.FROM_SITE_ID
	--	--		, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.MEASURE_GROUP
	--	--		, B.YYYYMMDD, B.QTY
	--	--		, A.VALID_YN, A.PLAN_RESULT, A.GUBUN, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
	--	--		, A.AS_FROM_SITE, A.CELL_NICKNAME, A.PRODUCT_LEVEL1, A.PRODUCT_LEVEL2, A.PRODUCT_LEVEL3, A.NOTATION
	--	--	FROM  #RAW_DATA_FINAL_TEMP40_KEY A WITH(NOLOCK)   
	--	--	INNER JOIN DM_PLN_RTF_ALLOCATION B WITH(NOLOCK)
	--	--	ON 1=1
	--	--	 AND  A.DIVISION_ID		= B.DIVISION_ID
	--	--	 AND  A.PROJECT_CODE	= B.PROJECT_CODE
	--	--	 AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
	--	--	 AND  A.ITEM_ID			= B.ITEM_ID
	--	--	 AND  A.INCOTERMS		= B.INCOTERMS
	--	--	 AND  A.DOM_EXP			= B.DOM_EXP
	--	--	 AND  A.FCST_TYPE		= B.FCST_TYPE
	--	--	 AND  A.MEASURE			= B.MEASURE 
	--	--	 AND  B.YYYYMMDD		>= @V_NOW_YYYYMMDD
	--	--;

	--	--END
	--	--ELSE IF ( @p_version_no LIKE '%MF%' OR @p_version_no LIKE '%ME%')
	--	--BEGIN

	--	--	-- 2-2) #RAW_DATA_FINAL 에 DM_PLN_RTF_ALLOCATION_C 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.

	--	--	INSERT INTO #RAW_DATA_FINAL
	--	--	SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
	--	--		, B.PLANT_SITE_ID
	--	--		, B.FROM_SITE_ID
	--	--		, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.MEASURE_GROUP
	--	--		, B.YYYYMMDD, B.QTY
	--	--		, A.VALID_YN, A.PLAN_RESULT, A.GUBUN, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
	--	--		, A.AS_FROM_SITE, A.CELL_NICKNAME, A.PRODUCT_LEVEL1, A.PRODUCT_LEVEL2, A.PRODUCT_LEVEL3, A.NOTATION
	--	--	FROM  #RAW_DATA_FINAL_TEMP40_KEY A WITH(NOLOCK)     
	--	--	INNER JOIN DM_PLN_RTF_ALLOCATION_C B WITH(NOLOCK) 
	--	--	ON 1=1
	--	--	 AND  A.VERSION_NO		= B.VERSION_NO
	--	--	 AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
	--	--	 AND  A.DIVISION_ID		= B.DIVISION_ID
	--	--	 AND  A.PROJECT_CODE	= B.PROJECT_CODE
	--	--	 AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
	--	--	 AND  A.ITEM_ID			= B.ITEM_ID
	--	--	 AND  A.INCOTERMS		= B.INCOTERMS
	--	--	 AND  A.DOM_EXP			= B.DOM_EXP
	--	--	 AND  A.FCST_TYPE		= B.FCST_TYPE
	--	--	 AND  A.MEASURE			= B.MEASURE
	--	--	 AND  B.YYYYMMDD		>= @V_NOW_YYYYMMDD
	--	--;


	--	--END
	--END
	
	/* @v_sql_text 안쪽데이타 빼냄 */
	BEGIN
		SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM
		INTO #CALENDAR
		FROM (
			SELECT SUBSTRING(MAX(BASIS_YYYYMMDD),1,6) + ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW,  ISO_WEEK
			FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
			WHERE BASIS_YYYYMMDD >=  @P_FROM_YYYYMMDD
			AND	  BASIS_YYYYMMDD <=  @P_TO_YYYYMMDD
			GROUP BY  ISO_YYYYWW, ISO_WEEK
		) AS A
		JOIN SCM_SYS_CALENDAR_M AS B WITH(NOLOCK)
		ON A.ISO_YYYYWW = B.ISO_YYYYWW
		AND A.ISO_WEEK = B.ISO_WEEK

		SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
		INTO #CAL_MONTH_END_DATE
          FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) 
         WHERE BASIS_YYYYMMDD BETWEEN  @P_FROM_YYYYMMDD AND @P_TO_YYYYMMDD 
         GROUP BY BASIS_YYYYMM
		 
		SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
		INTO #CAL_WEEK_END_DATE
          FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) 
         WHERE BASIS_YYYYMMDD BETWEEN  @P_FROM_YYYYMMDD AND @P_TO_YYYYMMDD 
         GROUP BY ISO_YYYYWW+PARTIAL_WEEK_NAME
	END		  

--[E20240102-000545]_[마케팅PI] 82번 사업부 - VMI표기 로직 개선  END
-------------------------------------------------------------------------------------------------------------------------
		--[E20230906-000992]ENERGY MEASURE에 한해 표기형식변경 (MKT FCST 화면값과 일치화)
		--SELECT cast(CASE WHEN ''Y'' = N''[@CellQtyYN]'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and isnull(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END as int) AS QTY

		SET @v_sql_text = N'		
		SELECT CASE WHEN A.MEASURE  IN (''RTF_ENERGY'' ,''MKT_FCST_ENERGY'') THEN 
					cast(CASE WHEN ''Y'' = N''[@CellQtyYN]'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and isnull(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END as NUMERIC(30,10))
		       ELSE 
		            cast(CASE WHEN ''Y'' = N''[@CellQtyYN]'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and isnull(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END as int) 					
			   END AS QTY			 
			 , CASE WHEN ''' + @P_BUCKET + ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
			 , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW
			 , M.SORT_ORDER_NO
			 , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN
             , CASE WHEN C3.WEEK_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN
			 , C.PROJECT_S_OP_REPORT	--[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건 
		 	 , CASE WHEN LEN(ISNULL(EE.ATTRIBUTE1,'''')) = 0 THEN ''Common'' ELSE EE.ATTRIBUTE1 END AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            , [@SQL_SELECT]
		INTO #WF
		--FROM #RAW_DATA A
		FROM #RAW_DATA_FINAL A
        LEFT OUTER JOIN #TEMP_SCM_MST_SITE B WITH(NOLOCK)  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID   
		LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM C WITH(NOLOCK) ON  A.DIVISION_ID = C.DIVISION_ID	AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
		LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V D WITH(NOLOCK) ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E WITH(NOLOCK) ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
		LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V F WITH(NOLOCK) ON D.DIVISION_ID = F.DIVISION_ID AND ISNULL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID
		LEFT OUTER JOIN SCM_MST_PROJECT G WITH(NOLOCK) ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
		LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I WITH(NOLOCK) ON A.DIVISION_ID = I.DIVISION_ID	AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
		JOIN #SELECT_MEASURE M ON A.MEASURE = M.MEASURE

		--[PJ2024-50461] Team Mapping------------------------------------
		--LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N WITH(NOLOCK) ON CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END = N.DEPT_ID 
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N WITH(NOLOCK) ON C.DEPT_ID = N.DEPT_ID 
		--[PJ2024-50461] Team Mapping------------------------------------

		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO O WITH(NOLOCK) ON N.UPPER_DEPT_ID = O.DEPT_ID
		JOIN #CALENDAR						CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD 
		LEFT OUTER JOIN #CAL_MONTH_END_DATE C2 ON A.YYYYMMDD = C2.MONTH_END_DATE
        LEFT OUTER JOIN #CAL_WEEK_END_DATE C3 ON A.yyyymmdd = C3.WEEK_END_DATE 
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL EE WITH(NOLOCK)
		ON  EE.LOOKUP_TYPE = ''SP_CELL_PROD_SITE''
		AND EE.SEGMENT1 = CASE WHEN LEN(ISNULL(A.CELL_PROD_SITE_ID,'''')) = 0 THEN ''-'' ELSE A.CELL_PROD_SITE_ID END -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		AND EE.SEGMENT2 = ''-''
		AND EE.SEGMENT3 = ''-''
		AND EE.SEGMENT4 = ''-''
		AND EE.SEGMENT5 = ''-''
		AND EE.VALID_YN = ''Y''
		option (hash join)
		
        print ''H_p--'' + convert(varchar(30), getdate(), 121) '

		IF @p_division_id = '40'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
								SELECT [@V_COLUMN]
										, ' + @V_PV_COL + '    
								FROM ( '
		END
		ELSE
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
								SELECT [@V_COLUMN]
										, [@V_PV_COL_LIST]    
								FROM ( '
		END
		
		IF @p_bucket = 'DAILY'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
								SELECT [@V_COLUMN], ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
								FROM   #WF F
								WHERE F.QTY <> 0
					
								UNION ALL '
		END 

		IF @p_bucket != 'ONLY_WEEKLY'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
						SELECT [@V_COLUMN], ''W_'' + F.BASIS_YYYYMM + F.ISO_WEEK AS YYYYMMDD 
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' ) 
											THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)   
														ELSE 0 
													END 
										WHEN F.MEASURE = ''LOC'' 
											THEN AVG(F.QTY) 
										ELSE SUM(F.QTY) 
									END AS QTY
						FROM #WF F
						WHERE F.QTY <> 0
						GROUP BY [@V_COLUMN], F.BASIS_YYYYMM, F.ISO_WEEK, F.WEEK_END_YN
					
						UNION ALL
						SELECT [@V_COLUMN], ''M_'' + F.BASIS_YYYYMM AS YYYYMMDD
							, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
											THEN	CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)  
														ELSE 0 
													END
										WHEN F.MEASURE = ''LOC''
											THEN AVG(F.QTY) 
										ELSE SUM(F.QTY) 
									END AS QTY
						FROM #WF F
						WHERE F.QTY <> 0
						GROUP BY [@V_COLUMN], F.BASIS_YYYYMM, F.MONTH_END_YN
					
						) F
					PIVOT (
						SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )
						) AS PVT
					ORDER BY [@V_ORDERBY]

					option ( order group ) 
					  '; 
		END
		ELSE IF @p_bucket = 'ONLY_WEEKLY'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
						SELECT [@V_COLUMN], ''W_'' + F.BASIS_YYYYMMWW AS YYYYMMDD 
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' ) 
											THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)   
														ELSE 0 
													END 
										WHEN F.MEASURE = ''LOC'' 
											THEN AVG(F.QTY) 
										ELSE SUM(F.QTY) 
									END AS QTY
						FROM #WF F
						WHERE F.QTY <> 0
						GROUP BY [@V_COLUMN], F.BASIS_YYYYMMWW, F.ISO_WEEK, F.WEEK_END_YN
						) F
					PIVOT (
						SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )
						) AS PVT
					ORDER BY [@V_ORDERBY]

					option ( order group ) 
					  '; 
		END


print 'H--' + convert(varchar(30), getdate(), 121)

	  --SELECT @v_sql_text;
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_COL_LIST]'    , @v_PV_LIST    );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_LIST]'		, @v_PV_LIST    );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_column]'			, @ColList       );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'		, @OrderList      );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_SELECT]'		, @V_SQL_SELECT      );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_GROUPBY]'		, @V_SQL_GROUPBY      );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@CellQtyYN]'      , @p_cell_yn);
		 
		EXEC SP_EXECUTESQL @v_sql_text; 
--		print @v_sql_text; 


		SELECT ISO_WEEK, BASIS_DATE 
		FROM [dbo].[SCM_SYS_CALENDAR_M] 
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE(), 112) 

		-- 테스트용 코드
		--SELECT ISO_WEEK, BASIS_DATE 
		--FROM [dbo].[SCM_SYS_CALENDAR_M] 
		--WHERE BASIS_YYYYMMDD = '20220725'
		

		-- 20190711 정열 관련 추가
		 /*
		DECLARE @ORDER NVARCHAR(MAX)=''
		SELECT @ORDER = @ORDER + T1.COLUMN_NAME + ' ' + T1.DATA_SORT_METHOD_CODE + ','
		FROM   ( 
				SELECT U.COLUMN_NAME,U.DATA_SORT_METHOD_CODE
				--,SORT_ORDER_NO
				,CASE WHEN U.COLUMN_NAME = 'GROUP_ID' THEN  ISNULL(TU.SORT_ORDER_NO,95) - 0.5 ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO--kjj 수정(2024.6.24)
				FROM   [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
				       LEFT OUTER JOIN [dbo].[SCM_MST_TITLESET_USER] TU WITH(NOLOCK)
						ON     TU.PROGRAM_ID  = U.PROGRAM_ID
						AND    TU.SHEET_NAME  = U.SHEET_NAME 
						AND    TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
						AND	   TU.COLUMN_NAME IN ('ITEM_ID') 
						AND    TU.USER_ID = @p_created_by

				WHERE  1 = 1
				AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'C'
				AND    U.PROGRAM_ID						= 'DMF0035'
				AND    U.SHEET_NAME						= 'Mkt Fcst Waterfall'
				AND    U.USER_ID						= @p_created_by

				/* kjj 수정(2024.6.24)
					UI 카테고리에서 GROUP_ID 표시되게 하였으므로 불필요한 UNION 제거
				*/
				/*
				UNION ALL 
				SELECT  C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
				      , CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  ISNULL(U.SORT_ORDER_NO,135) - 0.5 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO 
				FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
				       LEFT OUTER JOIN [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
						ON     U.PROGRAM_ID  = C.PROGRAM_ID
						AND    U.SHEET_NAME  = C.SHEET_NAME 
						AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
						AND	   U.COLUMN_NAME IN ('ITEM_ID') 
						AND    U.USER_ID = @p_created_by
				WHERE  1 = 1
						AND    C.PROGRAM_ID  = 'DMF0035'
						AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'
						AND    C.COLUMN_NAME = 'GROUP_ID' 
						AND    C.VISIBLE_FLAG = 'N'
						AND    C.DEFAULT_FLAG = ''
						AND    C.VALID_YN     = 'Y'
						*/
				) T1
		ORDER BY T1.SORT_ORDER_NO  --20200508 KHSONG 팀이 그룹별 합산이 안되서 추가함
		--SELECT SUBSTRING(@ORDER, 1, LEN(@ORDER) - 1) AS DATA_ORDER
		--SELECT @ORDER + 'VERSION_SORT DESC, SORT_ORDER_NO' AS DATA_ORDER 
		*/




		/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
		 /*
		 kjj 수정(2024.6.24)
		 - GROUP_ID 화면표시 위해 [SCM_MST_TITLESET_USER] 조인 추가
		 - ITEM_ID의 정렬보다 무조건 바로 앞에 GROUP_ID가 위치하게 
		 =>2024.06.25. 불필요한 정렬이므로 위의 정렬 값 그대로 리턴..추후 화면에서도 제거해야 함
		 */
		SET @OrderList = REPLACE(@OrderList,'['		, ''      );
		SET @OrderList = REPLACE(@OrderList,']'		, ''    );
		SELECT @OrderList   AS DATA_ORDER 
		
		 
		--select * from #SELECT_MEASURE
		
		-- xml확인할경우
		--SELECT CONVERT(TEXT, @v_sql_text)
		--FOR XML PATH('')--,ROOT('x') 



--SELECT COUNT(*) FROM #RAW_DATA




--execute dbo.SP_executesql @NSQL2 

print 'I--' + convert(varchar(30), getdate(), 121)


	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (BEGIN)
	------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V
		;
	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE
		;
	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA
		;
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM
		;
	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (END)
	------------------------------------------------------------------------------------------


print 'J--' + convert(varchar(30), getdate(), 121)

END


