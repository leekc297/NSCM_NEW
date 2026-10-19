
/*=====================================================================================================================================================
 * Program ID   : DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL  
 * Description  : Sales Plan Waterfall 조회  
 * Program History  
 *=====================================================================================================================================================
 *   Date       In Charge      Description  
 *=====================================================================================================================================================
 * 2018/03/12	SeungJae.Hwnag	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2018/06/20	JYE				소형 개발  
 * 2018/07/27	JYE				scm_mst_site_customer 조인 조건 추가  
 * 2018/07/30	Son Young Suk	검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정   
 * 2018/08/09	JYE				멀티 오너 수정  
 * 2018/08/10	JYE				멀티 오너 팀 수정  
 * 2018/08/16	KHSONG			미래구간은 VALID_YN='Y' 인것만 추출   
 * 2018/08/20	khsong			Sales Plan 비물동 구분코드는 SCM_MST_SITE_ITEM 등록여부와 관계없이 보여줘야함  
 * 2018/08/24	Son Young Suk	INTERNAL_TXN 포함 여부로 조회  
 * 2018/09/07	JYE				INTERNAL_TXN, Cell Type 칼럼 추가  
 * 2018/09/19	Son Young Suk	MKT 칼럼 추가  
 * 2018/10/11	JYE				Cutoff 데이터는 버전에 상응하는 단가 적용  
 * 2018/11/02	JYE				칼럼 추가  
 * 2018/11/14	JYE				Cell Qty 환산 추가  
 * 2018/11/16	JYE				PRIORITY 칼럼 추가  
 * 2018/12/13	ytchoi			전체적인 쿼리 변경  
 *=====================================================================================================================================================
 * -- 속도개선을 위하여 mkt_fcst처럼 구조 변경한 버전    
 *=====================================================================================================================================================
 * 2019/01/08	KHSONG			Unit Price 인경우는 SUM하지 않고 AVG로 표기함  
 * 2019/01/18	KHSONG			중복제거위한 DISTINCT추가  
 * 2019/01/23	KHSONG			속도개선 조회조건추가  
 * 2019/01/25	KHSONG			누락컬럼 추가  
 * 2019/01/28	KHSONG			누락컬럼추가  
 * 2019/02/01	JYE				42, 44 추가  
 * 2019/02/13	KHSONG			[CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건  
 * 2019/03/22	KHSONG			고객군, 판매처 컬럼 NULL처리조건 추가  
 * 2019/04/19	KHSONG			[CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가  
 * 2019/05/07	KHSONG			[CSR ID:3985608] Biz Type이 없는건은 수량만 zero로 변환요청  
 * 2019/07/09	KHSONG			[CSR ID:4034895] GSCM RTF[system] Measure 관련 요청건  
 * 2019/09/19	KHSONG			[CSR ID:4082962] Cell Model Info 컬럼추가  
 * 2019/10/25	KHSONG			쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함  
 * 2020/01/16	HWI1993			COMPANY_ID 추가  
 * 2020/01/31	KHSONG			[C20200114-000201] ESS사업부 ENERGE, CELL_QUANTITY 컬럼/Measure추가 & 쿼리내 UNION 줄여서 속도개선  
 * 2020/02/18	KHSONG			C20200212-000304 : GSCM 차량대수 환산 오류 개선 요청 건  
 * 2020/03/09	KHSONG			C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가  
 * 2020/03/16	KHSONG			C20200224-000109 Sales Plan Waterfall 미산출 문의건 → Measure 기본값 Setting 로직 추가  
 * 2020/04/27	KHSONG			C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)  
 * 2020/05/20	KHSONG			C20200330-000121 (GSCM Sales Plan Waterfall MKT FCST[R+P] 로직 변경 요청의 건)  
 * 2020/07/10	P.C.I			[PJ20200138] Future Price Version_No 구분  
 * 2020/07/22	P.C.I			[PJ20200138] Future Price Version_No 구분 원복  
 * 2020/07/23	P.C.I			[C20200521-000202] Sales Plan waterfall 실적구간 표시 오류  
 * 2020/08/19	P.C.I			[C20200608-000117] 실적구간 Unit Price Measure는 QTY/Sales Amt로 계산   
 * 2020/08/12	hwi1993			C20200812-000104 [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경( 미래구간 & Current 버전 에만 적용 )  
								#temp_scm_mst_site_item join 하는 부분도 데이터의 로우가 아니라 속성을 참조하는 부분이라 active 제거함.  
 * 2020/09/28	hwi1993			[C20200928-000147][SCM PI팀] ESS 사내거래 ? Sales Plan Waterfall 수정 및 사내거래 포함시 실적구간 PRICE 로직 수정 ( INTERNAL QTY 포함하도록 )  
 * 2020/11/25	P.C.I			[C20201125-000012] COMPANY_ID 변경(Site -> Sales Site Project Model)  
 * 2021/03/15	P.C.I			[C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)  
 * 2021/06/02	hwi1993			[PJ20209642R] 중장기 싱글플랜  
 * 2021/06/23   P.C.I			[PJ20209642R] Sales Price 는 Sum 대신 Avg로 계산  
 * 2021/10/22	hwi1993			과제 속도개선 - wf 프로시저 표준화  
 * 2021/11/18	kdw2819			[과제] 자동차 사업부 JV Planner 의 조회 권한 추가  
 * 2021/11/19	ROSIA27			[C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건  
 * 2021/11/24	rosia27			[C20211118-000259] [SCM PI팀] GSCM 시스템 데이터를 마케팅(채권)자료로 활용하기 위한 기능 변경 건  
 * 2021/12/07	rosia27			[C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건  
 * 2022/03/04   kdw2819			[C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청  
 * 2022/04/13   HWI1993			GM JV 작업  
 * 2022/06/23	kdw2819			[C20220620-000557] GSCM DM 영역내, Version에 주차표기  
 * 2022/07/19	kdw2819			[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)  
 * 2022/12/14	rosia27			[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy  
 * 2023/02/02	heesan91		[E20230130-000233] [ESS영업관리팀] Waterfall 화면의 Version 값 주차(Week) 추가 요청의 건  
 * 2023/02/14	rosia27			[E20230214-000256] Waterfall화면 Version 추가 로직 변경 요청  
 * 2023/04/20   leetw85			[E20230410-000032] Column에 Sold-to, Sold-to Name 데이터 추가의 건  
 * 2023/12/19   JSSBAE			[E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall
 * 2024/02/01   hmin			[E20240115-000325] Sales Plan Waterfall 화면 조회속도 저하 개선 (테이블 with (nolock) 처리 및 DM_MST_ITEM_SINGLE_V  VIEW -> 테이블 변경처리
 * 2024/02/28	KCW3408			Sales Plan Waterfall 화면 조회속도 저하 개선 (조회 순서 변경)
 * 2024/04/17	KCW3408			이동계획 기타매출 추가 요건(TEXT추가)
 * 2024/05/17   kcw3408			이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024/06/24   kjj				이동계획 판가 매출 GROUP_ID 화면 표시
 * 2024/08/02   JSSBAE			[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024/08/26   JSSBAE			[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼메저 추가
 * 2024/08/13	KJJ				[PJ2024-50461] Team Mapping
 * 2024/09/12	JSSBAE			[E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024/11/04	KJJ				[PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴
 * 2024/11/15	KANG.H.J		[PJ2024-50611] 소형 매출 프로세스 개선	
 * 2024/11/25	KANG.H.J		[PJ2024-50611] 소형 매출 프로세스 개선 (기타매출-ETC FCST 추가. RTF에 없기 때문에 SalesAMT 누락됨)
 * 2024/12/04	KJJ				[PJ2024-50611] Catch Up만 등록 되었을 경우 UNIT PRICE 보이게 수정
 * 2024/12/18	KJJ				[PJ2024-50611] 기타매출, Catch Up 테이블 분리 - 작업중
 * 2025/03/18	dsiol			[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025/04/23	dsiol			[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가
 * 2025/04/29   JSSBAE			[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가
 * 2025/05/21   JSSBAE			[E20250520-000574]_SALES PLAN, SALES PLAN WATERFALL UI의 RTF_PR Measure 조회 로직 변경

select @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='Volvo_SE_GOT', @p_project_code='', @p_item_id='APVCC519H-A1-000', @p_item_type='ALL',   
@p_from_yyyymmdd='20211101', @p_now_yyyymmdd='20211115', @p_to_yyyymmdd='20211130', @p_created_by='hwi1993', @p_plant_site_id='ALL',   
@p_biztype='ALL', @p_version_type='current, SP_W_20211118_V001', @p_owner='', @p_internal_yn='N', @p_cell_yn='N', @p_bucket='daily'  

 *===================================================================================================================================================
   EXEC DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL_KJJ @p_division_id='40', @p_dept_id='ALL', @p_end_customer='ALL'  
   , @p_scm_site_id='ALL', @p_project_code='', @p_item_id='', @p_item_type='ALL', @p_from_yyyymmdd='20241101'  
   , @p_now_yyyymmdd='20241111', @p_to_yyyymmdd='20250430', @p_created_by='kjj0070', @p_plant_site_id='ALL'  
   , @p_biztype='ALL', @p_version_type='SP_W_20241119_V001(W47)', @p_owner='', @p_internal_yn='N', @p_cell_yn='N'  
   , @p_bucket='MONTHLY', @p_user_dept_id='ICT', @p_group_id='ADMIN'  
 */  
   
CREATE PROCEDURE [dbo].[DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL_0528수정전]    
	  @p_division_id		NVARCHAR(30)  
	, @p_dept_id            NVARCHAR(4000)  
	, @p_end_customer       NVARCHAR(4000)  
	, @p_scm_site_id        NVARCHAR(4000)  
	, @p_project_code       NVARCHAR(4000)  
	, @p_item_id            NVARCHAR(4000)  
	, @p_item_type          NVARCHAR(4000)  
	, @p_from_yyyymmdd      NVARCHAR(8)  
	, @p_now_yyyymmdd       NVARCHAR(8)  
	, @p_to_yyyymmdd        NVARCHAR(8)  
	, @p_created_by         NVARCHAR(4000)  
	, @p_plant_site_id      NVARCHAR(4000)  
	, @p_biztype            NVARCHAR(4000)  
	, @p_owner				NVARCHAR(4000)  
	, @p_internal_yn        NVARCHAR(1)  
	, @p_cell_yn			NVARCHAR(1)  
	, @p_version_type       NVARCHAR(4000)  
	, @p_bucket				NVARCHAR(20) -- 20211110 SALES PLAN WATERFALL 속도 개선  
	, @p_user_dept_id		NVARCHAR(50) -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가  
	, @p_group_id			NVARCHAR(50) -- JV Planner 일지 확인하기 위해 추가  
AS  
    
BEGIN    
	SET NOCOUNT ON;  
	--SET ANSI_WARNINGS OFF;   
	SET ANSI_NULLS ON  
	SET ANSI_WARNINGS ON;    
	
	DECLARE @Prod			NVARCHAR(MAX);  
	DECLARE @ColList		NVARCHAR(MAX);  
	DECLARE @OrderList		NVARCHAR(MAX);  
	DECLARE @nsql			NVARCHAR(MAX);  
	DECLARE @nsql2			NVARCHAR(MAX); 
	DECLARE @p_program_id	VARCHAR(50)	= 'DMF0022';  
	DECLARE @p_sheet_name	VARCHAR(50)	= 'Sales Plan Waterfall';   
	DECLARE @VERSION_NO		NVARCHAR(50);  
  
	SET		@ColList		= '';  
	SET		@OrderList		= '';  
	SET		@Prod			= '';  
	DECLARE @MEASURE		INT = 0;  
	DECLARE @i_count		INT = 0;    
  
	DECLARE @v_user_mea_cnt INT = 0; -- 20200316 KHSONG C20200224-000109  

	-----------------------------------------------------------------------------------------------------------------------------------  
	-- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
	-----------------------------------------------------------------------------------------------------------------------------------  
	DECLARE @v_start_yyyymmdd NVARCHAR(8)  
	SET		@v_start_yyyymmdd = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = @p_from_yyyymmdd )  
  
	-----------------------------------------------------------------------------------------------------------------------------------  
	-- [E20240115-000325] START 
	-----------------------------------------------------------------------------------------------------------------------------------  
	DECLARE @V_DM_PROGRAM_LOG_FLAG AS NVARCHAR(2) = 'N';

PRINT N'확인용로그적재여부1: ' + @V_DM_PROGRAM_LOG_FLAG

	SELECT @V_DM_PROGRAM_LOG_FLAG = ISNULL(SEGMENT2,'N') --LOG_FLAG
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
	WHERE LOOKUP_TYPE = 'DM_PROGRAM_LOG' 
	AND VALID_YN = 'Y'
	AND SEGMENT1 = @p_program_id
	--AND SEGMENT3 = @p_created_by  --사용자처리까지 조건처리할경우
	;
	
PRINT N'확인용로그적재여부2: ' + @V_DM_PROGRAM_LOG_FLAG
	--SET @V_DM_PROGRAM_LOG_FLAG = 'N'  
	-- Waterfall은 Edit_Flag 사용하지 않으므로 주석처리  
	-----------------------------------------------------------------------------------------------------------------------------------  
	-- [E20240115-000325] END 
	----------------------------------------------------------------------------------------------------------------------------------- 
PRINT @p_program_id + ' : A001--' + CONVERT(VARCHAR(30), GETDATE(), 121)   
	-----------------------------------------------------------------------------------------------------------------------------------
	-- Temp Table 존재 여부 체크 START  
	-----------------------------------------------------------------------------------------------------------------------------------  
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
	IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP', N'U') IS NOT NULL   
		DROP TABLE #T_COLUMN_SETUP;  
	IF OBJECT_ID (N'tempdb..#T', N'U') IS NOT NULL   
		DROP TABLE #T;  
	IF OBJECT_ID (N'tempdb..#CALENDAR', N'U') IS NOT NULL   
		DROP TABLE #CALENDAR;      
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL   
		DROP TABLE #TEMP_SCM_MST_SITE;         
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_T', N'U') IS NOT NULL   
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_T;         
	IF OBJECT_ID (N'tempdb..#WF', N'U') IS NOT NULL   
		DROP TABLE #WF;   
	-----------------------------------------------------------------------------------------------------------------------------------       
  	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START 
	-----------------------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V; 
	-----------------------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END 
	-----------------------------------------------------------------------------------------------------------------------------------	 
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 END
	-----------------------------------------------------------------------------------------------------------------------------------
PRINT @p_program_id + ' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121)   
  
	/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )  
	   과거 구간은 전체 Data가 포함되어야 함.  
	   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.  
	   단위 환산이 되어야 함 */  
   
	----------------------------------------------------------------------------------------------------------------------------------- 
	-- 20200316 KHSONG C20200224-000109 START 
	-----------------------------------------------------------------------------------------------------------------------------------
	SELECT @v_user_mea_cnt = COUNT(*)  
	FROM   SCM_MST_TITLESET_USER U WITH(NOLOCK)  
	WHERE  1 = 1  
	AND    U.PROGRAM_ID      = @p_program_id  
	AND    U.SHEET_NAME      = @p_sheet_name  
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'  
	AND    U.USER_ID      = @p_created_by;  
  
	IF @v_user_mea_cnt = 0  
	BEGIN       
		INSERT INTO SCM_MST_TITLESET_USER  
		( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME  
		, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE  
		, LAST_UPDATED_BY, LAST_UPDATE_DATE	)  
		SELECT @p_created_by AS USER_ID, C.PROGRAM_ID AS PROGRAM_ID, C.SHEET_NAME, 'M' AS USER_INQUIRY_COLUMN_TYPE_CODE, C.COLUMN_NAME  
			 , C.SORT_ORDER_NO, 'N' AS SUB_TOTAL_FLAG, '' AS DATA_SORT_METHOD_CODE, @p_created_by AS CREATED_BY, CONVERT(varchar(19), GETDATE(), 121) AS CREATION_DATE 
			 , @p_created_by AS LAST_UPDATED_BY, CONVERT(varchar(19), GETDATE(), 121) AS LAST_UPDATE_DATE  
		FROM   SCM_MST_SHEET_MEASURE C WITH(NOLOCK)  
		WHERE  1 = 1  
		AND    C.PROGRAM_ID		= @p_program_id  
		AND    C.SHEET_NAME		= @p_sheet_name  
		AND    C.DEFAULT_FLAG	= 'Y'  
		AND    C.VALID_YN		= 'Y' ;  
	END;  
	----------------------------------------------------------------------------------------------------------------------------------- 
	-- 20200316 KHSONG C20200224-000109 END  
	----------------------------------------------------------------------------------------------------------------------------------- 	
PRINT @p_program_id + ' : A003--' + CONVERT(VARCHAR(30), GETDATE(), 121)   
  	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 START
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
	SELECT DISTINCT U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, 'N' AS SYSTEM_ADD  
	INTO #SELECT_MEASURE   -- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함  
	FROM SCM_MST_TITLESET_USER U WITH(NOLOCK)    
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)   
		   ON U.USER_ID		= T.SEGMENT4	-- 20200309 KHSONG TMM MEASURE 권한추가  
		  AND @p_created_by = T.SEGMENT4	-- USER_ID  
		  AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'  
		  AND T.VALID_YN	= 'Y'			-- VALID_YN 여부    
	WHERE 1 = 1  
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'  
	AND U.PROGRAM_ID   = @p_program_id  
	AND U.USER_ID      = @p_created_by  
	and U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by END  -- 20200309 KHSONG TMM MEASURE 권한추가  */
	
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
  
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 END
	-----------------------------------------------------------------------------------------------------------------------------------
PRINT @p_program_id + ' : A004--' + CONVERT(VARCHAR(30), GETDATE(), 121)   
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.  
	-----------------------------------------------------------------------------------------------------------------------------------  
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'LOC', 'KRW' ))  
	BEGIN  
		INSERT INTO #SELECT_MEASURE 
		( MEASURE, SYSTEM_ADD )  
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
		INSERT INTO #SELECT_MEASURE 
		( MEASURE, SYSTEM_ADD )  
		SELECT A.MEASURE, 'Y'  
		FROM (  SELECT 'MKT_FCST' AS MEASURE  
				UNION ALL  
				SELECT 'RTF_SYS_RP' AS MEASURE ) A  
		LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE  
		WHERE B.MEASURE IS NULL  
	END  
   
	-----------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 START
	-- 하단에서 실적구간의 RTF_PR 를 구하기 위해서 RTF_SYS_RP 를 추가해준다.
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'RTF_PR' )
	BEGIN
		INSERT INTO #SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM ( SELECT 'RTF_SYS_RP' AS MEASURE ) A
		LEFT OUTER JOIN #SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 END
	-----------------------------------------------------------------------------------------------------------------------------------
PRINT @p_program_id + ' : A005--' + CONVERT(VARCHAR(30), GETDATE(), 121)  
  
	CREATE TABLE #RAW_DATA 
	( VERSION_NO			NVARCHAR(50)  
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
	, COMPANY_ID			NVARCHAR(30)  
	, MEASURE			NVARCHAR(50)  
	, YYYYMMDD			CHAR(8)  
	, QTY				NUMERIC(30,10)  
	, VALID_YN			CHAR(1)  
	, PLAN_RESULT		CHAR(1)  
	, ATTRIBUTE1			NVARCHAR(150)  --[PJ2024-50611] 화면에서 저장한 dept_id
	, CELL_PROD_SITE_ID	NVARCHAR(60) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	)  

	-----------------------------------------------------------------------------------------------------------------------------------
	-- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')  
	-----------------------------------------------------------------------------------------------------------------------------------     
	IF ( @p_version_type LIKE '%CURRENT%' )  
	BEGIN   
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID   
			 , PLANT_SITE_ID, A.ITEM_ID, ISNULL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP   
			 , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD   
			 , A.QTY, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)  
		JOIN #SELECT_MEASURE B 
		  ON A.MEASURE		= B.MEASURE  
		JOIN SCM_MST_SITE C WITH(NOLOCK) 
		  ON A.DIVISION_ID	= C.DIVISION_ID 
		 AND A.SCM_SITE_ID	= C.SCM_SITE_ID 
		 AND C.VALID_YN		= 'Y'  
		--LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'  
		WHERE A.YYYYMMDD >= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd  
		AND   A.DIVISION_ID = @p_division_id  
		AND   A.QTY <> 0  
		--마이그레이션 된 데이터 지우면 조건삭제
		AND   A.FCST_TYPE	NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
									 WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
									 AND VALID_YN		= 'Y'  
									 AND SEGMENT1		= A.DIVISION_ID )
		AND   A.ITEM_ID		NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
									 WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
									 AND VALID_YN		= 'Y'  
									 AND SEGMENT1		= A.DIVISION_ID ) 
		AND	  A.MEASURE		NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
									 WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
									 AND VALID_YN = 'Y' )  

		-----------------------------------------------------------------------------------------------------------------------------------
		-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 START
		-----------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID   
			 , PLANT_SITE_ID, A.ITEM_ID, A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP   
			 , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD   
			 , A.QTY, 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_ETC_PLAN A WITH(NOLOCK)  
		JOIN #SELECT_MEASURE B 
		  ON A.MEASURE		= B.MEASURE  
		JOIN SCM_MST_SITE C WITH(NOLOCK) 
		  ON A.DIVISION_ID	= C.DIVISION_ID 
		 AND A.SCM_SITE_ID	= C.SCM_SITE_ID 
		 AND C.VALID_YN		= 'Y'  
		--LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'  
		WHERE A.YYYYMMDD	>= @p_now_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd  
		AND   A.DIVISION_ID	= @p_division_id  
		AND   A.QTY <> 0  
		-----------------------------------------------------------------------------------------------------------------------------------
		-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 END
		-----------------------------------------------------------------------------------------------------------------------------------
		UNION ALL    
		SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID   
			 , PLANT_SITE_ID, A.ITEM_ID, ISNULL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP   
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, A.YYYYMMDD  
			 , A.QTY + CASE WHEN @p_internal_yn = 'Y' AND @P_DIVISION_ID = '82' AND ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) ELSE 0 END AS QTY  
			 , 'R' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)  
		JOIN #SELECT_MEASURE B WITH(NOLOCK) 
		  ON A.MEASURE = B.MEASURE  
		WHERE A.YYYYMMDD >= @p_from_yyyymmdd AND A.YYYYMMDD < @p_now_yyyymmdd  
		AND   A.DIVISION_ID = @p_division_id  
		AND ( A.QTY <> 0 OR ISNUMERIC(ISNULL(A.ATTRIBUTE2,''))> 0) -- [C20200928-000147]  
		AND   A.MEASURE NOT IN ('RTF_PR') --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
	END  
	
PRINT @p_program_id + ' : A006--' + CONVERT(VARCHAR(30), GETDATE(), 121)  
  
	IF ( @p_version_type LIKE '%SP_%' )  
	BEGIN   
		INSERT INTO #RAW_DATA 
		( VERSION_NO
		, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID
		, ITEM_ID ,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE
		, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY
		, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT CASE WHEN @p_division_id ='82' AND  E.DM_RTF_YN = 'N' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,') (NO PLAN)')   
					WHEN @p_division_id ='82' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,')')  
					ELSE A.VERSION_NO END AS VERSION_NO  -- [E20230130-000233]  
				, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID
				, A.ITEM_ID, ISNULL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
				, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD, A.QTY
				, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_PLAN_C A WITH(NOLOCK)  
		JOIN #SELECT_MEASURE B 
		  ON A.MEASURE = B.MEASURE   
		JOIN SCM_MST_SITE C WITH(NOLOCK) 
		  ON A.DIVISION_ID	= C.DIVISION_ID 
		 AND A.SCM_SITE_ID	= C.SCM_SITE_ID 
		 AND C.VALID_YN		= 'Y'  
		--LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'  
		INNER JOIN SCM_SYS_CALENDAR_M D WITH (NOLOCK) 
				ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233] --[E20240115-000325] WITH(NOLOCK) 처리 
		LEFT JOIN SCP_PLN_INTERFACE_YN E WITH(NOLOCK) 
			   ON A.DIVISION_ID			= E.DIVISION_ID  
			  AND D.BASIS_START_DATE	= E.PLAN_START_YYYYMMDD --[E20230130-000233]  
		WHERE	A.YYYYMMDD >= @p_from_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd  
		AND		A.DIVISION_ID = @p_division_id  
		AND		A.QTY <> 0   
		AND		A.VERSION_NO IN ( SELECT LEFT(token, CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END ) FROM dbo.String_Split(@p_version_type ,','))   
		--마이그레이션 된 데이터 지우면 조건삭제
		AND A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
								 WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
								 AND VALID_YN			= 'Y'  
								 AND SEGMENT1			= A.DIVISION_ID )
		AND A.ITEM_ID NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							   WHERE LOOKUP_TYPE		= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
							   AND VALID_YN				= 'Y'  
							   AND SEGMENT1				= A.DIVISION_ID ) 
		AND A.MEASURE NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							   WHERE LOOKUP_TYPE		= 'SALES_PLAN_CATCHUP'
							   AND VALID_YN				= 'Y' ) 
		-----------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 START
		-----------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		SELECT CASE WHEN @p_division_id ='82' AND  E.DM_RTF_YN = 'N'  THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,') (NO PLAN)')   
					WHEN @p_division_id ='82' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,')')  
					ELSE A.VERSION_NO END AS VERSION_NO  -- [E20230130-000233]  
			 , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID   
			 , A.ITEM_ID, A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE  
			 , A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD, A.QTY  
			 , 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_ETC_PLAN_C A WITH(NOLOCK)  
		JOIN #SELECT_MEASURE B 
		  ON A.MEASURE = B.MEASURE   
		JOIN SCM_MST_SITE C WITH(NOLOCK) 
		 ON A.DIVISION_ID	= C.DIVISION_ID 
		AND A.SCM_SITE_ID	= C.SCM_SITE_ID 
		AND C.VALID_YN		= 'Y'  
		--LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'  
		INNER JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK) 
				ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233] --[E20240115-000325] WITH(NOLOCK) 처리 
		LEFT JOIN SCP_PLN_INTERFACE_YN E WITH(NOLOCK) 
			   ON A.DIVISION_ID			= E.DIVISION_ID  
			  AND D.BASIS_START_DATE	= E.PLAN_START_YYYYMMDD --[E20230130-000233]  
		WHERE   A.YYYYMMDD >= @p_from_yyyymmdd AND A.YYYYMMDD <= @p_to_yyyymmdd  
		AND		A.DIVISION_ID = @p_division_id  
		AND		A.QTY <> 0   
		AND		A.VERSION_NO IN (SELECT LEFT(token,  CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END ) FROM dbo.String_Split(@p_version_type ,','))  
  		-----------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 END
		-----------------------------------------------------------------------------------------------------------------------------------
 		UNION ALL    
		SELECT CASE WHEN @p_division_id ='82' AND  E.DM_RTF_YN = 'N'  THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,') (NO PLAN)')   
					WHEN @p_division_id ='82' THEN CONCAT(A.VERSION_NO , '(',D.WEEK_NAME,')')  
					ELSE A.VERSION_NO END AS  VERSION_NO  --[E20230130-000233]  
			 , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID   
			 , A.ITEM_ID, ISNULL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE  
			 , A.CURRENCY, A.COMPANY_ID, A.MEASURE, A.YYYYMMDD 
			 , A.QTY + CASE WHEN @p_internal_yn = 'Y' AND @P_DIVISION_ID = '82' AND ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) ELSE 0 END AS QTY 
			 , 'R' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_PLAN_RESULT_C A WITH(NOLOCK)  
		JOIN #SELECT_MEASURE B 
		  ON A.MEASURE = B.MEASURE  
		-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청  
		INNER JOIN SCM_SYS_CALENDAR_M D WITH (NOLOCK) 
				ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233]  [E20240115-000325] WITH (NOLOCK) 처리
		LEFT JOIN SCP_PLN_INTERFACE_YN E WITH (NOLOCK) 
			   ON A.DIVISION_ID			= E.DIVISION_ID  
			  AND D.BASIS_START_DATE	= E.PLAN_START_YYYYMMDD --[E20230130-000233]  
		WHERE   A.YYYYMMDD >= @p_from_yyyymmdd AND A.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.CUTOFF_YYYYMMDD, 'MON')), 112)  
		AND		A.DIVISION_ID = @p_division_id  
		AND   ( A.QTY <> 0 OR ISNUMERIC(ISNULL(A.ATTRIBUTE2,''))> 0) -- [C20200928-000147]  
		AND		A.VERSION_NO IN (SELECT LEFT(token,  CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END) FROM dbo.String_Split(@p_version_type ,','))   
		AND		A.MEASURE NOT IN ('RTF_PR') --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
	END  
PRINT @p_program_id + ' : A007--' + CONVERT(VARCHAR(30), GETDATE(), 121)  

	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20240115-000325] START
	-----------------------------------------------------------------------------------------------------------------------------------
	DECLARE @d_event_date   DATETIME;
	IF (@V_DM_PROGRAM_LOG_FLAG = 'Y')
	BEGIN 	
		SET @d_event_date = SYSDATETIME();
		EXEC  PR_DM_SYS_LOG_BATCH @p_program_id, 'SM-T', 0, 'E2--', '', @d_event_date, @p_created_by;
	END
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20240115-000325] END
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP')  
	BEGIN  
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID,'MKT_FCST_RP' AS MEASURE, YYYYMMDD
			 , QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A  WITH(NOLOCK)  
		WHERE A.MEASURE = 'MKT_FCST'  
		AND   A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd  
								 ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)  
								 END -- [C20200521-000202] Version cutoff 기준으로 MKT_FCST 조회  
		AND   A.YYYYMMDD <= @p_to_yyyymmdd  
  
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
			 , QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A WITH(NOLOCK)  
		WHERE MEASURE = 'RTF_SYS_RP'  
		AND A.YYYYMMDD >= @p_from_yyyymmdd   
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd  
							  ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)  
						 END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회  
	END  
	
	-----------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 START
	-----------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'RTF_PR')  
	BEGIN    
		INSERT INTO #RAW_DATA 
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
				, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
				, FCST_TYPE, CURRENCY, COMPANY_ID,'RTF_PR' AS MEASURE, YYYYMMDD
				, QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM #RAW_DATA A WITH(NOLOCK)  
		WHERE MEASURE = 'RTF_SYS_RP'  
		AND A.YYYYMMDD >= @p_from_yyyymmdd   
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd  
							  ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)  
						  END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회     
	END 
	-----------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 END
	-----------------------------------------------------------------------------------------------------------------------------------
	/* 20240308 kcw3408 index 추가 */
	--create index idx1_RAW_DATA on #RAW_DATA ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID)  
PRINT @p_program_id + ' : A008--' + CONVERT(VARCHAR(30), GETDATE(), 121)    
	-----------------------------------------------------------------------------------------------------------------------------------
	-- 아래서부터는 CURRENCY를 사용해야 하므로 여기서 UPDATE 한다. 
	----------------------------------------------------------------------------------------------------------------------------------- 
	UPDATE A  
	SET CURRENCY = B.CURRENCY  
	FROM #RAW_DATA A WITH(NOLOCK) 
	JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
	  ON A.DIVISION_ID	= B.DIVISION_ID 
	 AND A.PROJECT_CODE = B.PROJECT_CODE 
	 AND A.SCM_SITE_ID	= B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID  
	WHERE ISNULL(A.CURRENCY, '') = ''  
  
	IF ( @p_internal_yn <> 'Y')  
	BEGIN  
		DELETE FROM #RAW_DATA   
		WHERE SCM_SITE_ID IN ( SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK)) 
	END       
PRINT @p_program_id + ' : A009--' + CONVERT(VARCHAR(30), GETDATE(), 121)    

 --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
 --원소스 주석처리
 /*
--[E20240115-000325] DM_MST_ITEM_SINGLE_V -> SCM_MST_ITEM_SN
--20240129 SM 해당 구간에 멈춰서 조치--------------------------------------------
--해당구간추가 후 아래 DM_MST_ITEM_SINGLE_v 사용구간 주석처리
  SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS  
   , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY  
   , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP  
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
  --FROM DM_MST_ITEM_SINGLE_V A  
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
  join ( select distinct division_id, item_id from #RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id  
  WHERE A.DIVISION_ID = @p_division_id
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
	FROM  #TEMP_DM_MST_ITEM_SINGLE_ORI_V T2 WITH(NOLOCK) 
	GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
	
	SELECT A.DIVISION_ID
		 , A.ITEM_ID
		 , A.ITEM_NAME
		 , A.ITEM_CLASS 
		 , A.ITEM_CLASS_NAME
		 , A.NICK_NAME
		 , A.ITEM_TYPE
		 , A.MATERIAL_CLASS_NAME
		 , A.ITEM_UOM
		 , A.SPEC
		 , A.MDM_PROJECT_NAME
		 , A.MIN_CAPACITY
		 , A.FORECAST_INFO_BIZ_TYPE
		 , A.FORECAST_INFO_PRODUCT_GROUP
		 , A.FORECAST_INFO_CELL_MODEL
		 , A.FORECAST_INFO_CELL_PACK_COUNT
		 , A.FORECAST_INFO_SPEC
		 , A.FORECAST_INFOR_VERSION
		 , A.ACTIVE_FLAG
		 , A.CELL_TYPE
		 , A.CELL_QUANTITY
		 , A.SCP_EXTRA_SPEC 
		 , A.ENERGE AS ENERGE_WH
		 , CASE WHEN ISNUMERIC(A.ENERGE) > 0 THEN (CONVERT(NUMERIC(15,3),ROUND((CONVERT(NUMERIC(15,3), A.ENERGE))/1000, 7))) ELSE NULL END AS ENERGE
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
  ) A
  join ( select distinct division_id, item_id from #RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id  
  WHERE A.DIVISION_ID = @p_division_id
  GROUP BY A.DIVISION_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_CLASS, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MATERIAL_CLASS_NAME
		, A.ITEM_UOM, A.SPEC, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_PRODUCT_GROUP
		, A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
		, A.ACTIVE_FLAG, A.CELL_TYPE, A.ENERGE, A.CELL_QUANTITY, A.SCP_EXTRA_SPEC 

--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
(division_id   ASC
,item_id       ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;

/* [E20240731-000852]_MDM에서 DM으로 ENERGE I/F 단위는 WH인데, 82사업부는 KW기준
						40번 사업부는 WH기준으로 보여주길 원하므로 82사업부인 경우에만 KWH로 나오도록 조건 추가
--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 START
--해당 테이블의 데이터를 쓰므로, 데이터 완료된 후 KWH로 변경한다.
UPDATE #TEMP_DM_MST_ITEM_SINGLE_V
SET ENERGE = CASE WHEN ISNUMERIC(ENERGE) > 0 THEN ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 4) ELSE NULL END
FROM #TEMP_DM_MST_ITEM_SINGLE_V
--[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 END
*/

 ------------------------------------------------------------------------END

 --[E20240115-000325] ▼ 주석처리
 -------------------------------------------------------------------------------------------  
 ----                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)  
 -------------------------------------------------------------------------------------------  
 --SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS  
 --  , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY  
 --  , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP  
 --  , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION  
 --  , ENERGE, CELL_QUANTITY  
 --  , MDM_PROJECT_NAME, CELL_TYPE  
 -- INTO #TEMP_DM_MST_ITEM_SINGLE_V  
 -- FROM DM_MST_ITEM_SINGLE_V A  WITH (NOLOCK)  --[E20240115-000325] WITH (NOLOCK) 처리
 -- join ( select distinct division_id, item_id from #RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id  
 --WHERE A.DIVISION_ID = @p_division_id  
  
 -------------------------------------------------------------------------------------------  
 ----                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)  
 -------------------------------------------------------------------------------------------  
  
 ------------------------------------------------------------------------------------------  
 --                                 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)  
 ------------------------------------------------------------------------------------------  
print 'C--' + convert(varchar(30), getdate(), 121)  
  
 ------------------------------------------------------------------------------------------  
 -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)  
 ------------------------------------------------------------------------------------------  
   
 SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID  
         , APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL  
   , CELL_PER_CAR, CELL_PER_MODULE, SALES_COMPANY, CURRENCY  
   , ATTRIBUTE1, ATTRIBUTE2  
   , ATTRIBUTE5  
   , ATTRIBUTE7  
   , ATTRIBUTE8  
   , REPORT_GROUP6  
   , a.OWNER  
   , DBO.FN_GET_DM_MKT_OWNER_NAME (a.OWNER, ',', 'EN' )                AS OWNER_NAME  
   , DBO.FN_GET_DM_MKT_OWNER_NAME (a.OWNER, ',', 'KO' )                AS OWNER_NAME_KO  
   ,( SELECT SU.DEPT_ID    
    FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)  
    WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](a.owner, ',')) ) DEPT_ID  
   , VALID_YN  
 INTO #TEMP_SCM_MST_SITE_ITEM  
 FROM SCM_MST_SITE_ITEM a WITH(NOLOCK)  
 join ( select distinct division_id, SCM_SITE_ID, PROJECT_CODE, item_id from #RAW_DATA ) b 
 on a.division_id = b.division_id and A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND a.item_id = b.item_id  
 WHERE a.Division_id = @p_division_id  
  
   
 --SELECT VERSION_NO, A.MEASURE, LEFT(YYYYMMDD, 6), SUM(QTY)  
 --FROM #RAW_DATA A  
 --LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID  
 --WHERE A.VERSION_NO = 'CURRENT'   
 -- AND A.PLAN_RESULT = 'P'   
 -- AND A.ITEM_ID NOT IN ('ETC', 'ED_D','TOOLING','MDF')  
 -- AND ( ISNULL(B.VALID_YN,'') <> 'Y' OR B.Division_id IS NULL)  
 --GROUP BY VERSION_NO, A.MEASURE, LEFT(YYYYMMDD, 6)  
  
   
 --SELECT VERSION_NO, A.MEASURE, LEFT(YYYYMMDD, 6), SUM(QTY)  
 --FROM #RAW_DATA A  
 --LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID  
 --WHERE A.VERSION_NO = 'CURRENT'   
 -- AND A.PLAN_RESULT = 'P'   
 -- AND B.Division_id IS NULL  
 --GROUP BY VERSION_NO, A.MEASURE, LEFT(YYYYMMDD, 6)  
  
   
 --SELECT * FROM #RAW_DATA  
 --WHERE PROJECT_CODE = 'G-21-222' AND SCM_SITE_ID = 'Terra-Gen_US_EWA' AND ITEM_ID = 'EEA00334AB' AND YYYYMMDD LIKE '202110%'  
  
  
--SELECT * 
-- FROM #RAW_DATA A  
  
 DELETE A  
 FROM #RAW_DATA A  
 LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B WITH(NOLOCK)
     ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID  
 WHERE A.PLAN_RESULT = 'P'   
  --AND A.ITEM_ID NOT IN ('ETC', 'ED_D','TOOLING','MDF','Sample','SI',N'물동보상금')  --[PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴
  --[PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴 start
AND A.ITEM_ID NOT IN 
(
	select segment3 from SCM_ADM_LOOKUP_MASTER_DETAIL
	where LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
	and SEGMENT1 = A.DIVISION_ID
)
--[PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴 --end

  AND ISNULL(B.VALID_YN,'') <> 'Y'  
  --AND A.VERSION_NO = 'CURRENT' ( 수정 전 로직이 버전구분 없이 처리 )  
 

 ----SELECT @@ROWCOUNT  
  
--select version_no, measure, PLAN_RESULT, count(*) from #RAW_DATA  
--group by version_no, measure, PLAN_RESULT  
--order by 1, 2  
--------------------------------------------------------------------------------------------------------------
IF (@V_DM_PROGRAM_LOG_FLAG = 'Y')
BEGIN
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_DM_SYS_LOG_BATCH @p_program_id, 'SM-T', 0, 'DE--', '', @d_event_date, @p_created_by; --[E20240115-000325]
END
--------------------------------------------------------------------------------------------------------------  

	--[PJ2024-50611] 화면에서 저장한 dept_id 업데이트 start
			UPDATE A
			SET ATTRIBUTE1 = B.ATTRIBUTE1
			FROM #RAW_DATA A
			JOIN 
			(
				SELECT [DIVISION_ID]
					  ,[PROJECT_CODE]
					  ,[SCM_SITE_ID]
					  ,[ITEM_ID]
					  ,[DOM_EXP]
					  ,[FCST_TYPE]
					  ,[INCOTERMS]
					  ,[MEASURE]
					  ,[PLANT_SITE_ID]
					  ,[YYYYMMDD]
					  ,[ATTRIBUTE1]
					  ,REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 필드추가
					  ,'-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				  --FROM [dbo].[DM_PLN_SALES_PLAN] WITH(NOLOCK)
				  FROM [dbo].[DM_PLN_SALES_ETC_PLAN] WITH(NOLOCK)--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
				  WHERE DIVISION_ID = '40'
				  AND FCST_TYPE = 'ETC'
				  AND YYYYMMDD >= @p_now_yyyymmdd and YYYYMMDD <= @p_to_yyyymmdd
				  AND QTY <> 0
			) B
			ON A.DIVISION_ID = B.DIVISION_ID 
			AND A.PROJECT_CODE = B.PROJECT_CODE 
			AND A.SCM_SITE_ID = B.SCM_SITE_ID 
			AND A.ITEM_ID = B.ITEM_ID
			AND A.DOM_EXP = B.DOM_EXP
			AND A.FCST_TYPE = B.FCST_TYPE
			AND A.INCOTERMS = B.INCOTERMS
			AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
			AND A.YYYYMMDD = B.YYYYMMDD
			AND A.TEXT = B.REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 조인추가
	--[PJ2024-50611] 화면에서 저장한 dept_id 처리 end
  
   --------------------------------------------------------------------------------------------------------------------------------------------  
   -- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )  
   --------------------------------------------------------------------------------------------------------------------------------------------  
   BEGIN -- 필터링 시작  
  
    IF ( @p_project_code <> '') -- 소형은 UI 에서 PROJECT DISABLE 됨  
    BEGIN  
     DELETE A  
     FROM #RAW_DATA A  
     JOIN SCM_MST_PROJECT B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_project_code,',')   
         ) C ON B.PROJECT_CODE LIKE '%' + C.TOKEN + '%'  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_project_code,',')   
         ) D ON B.PROJECT_NAME LIKE '%' + D.TOKEN + '%'  
  
     WHERE C.TOKEN IS NULL AND D.TOKEN IS NULL  
    END  
  
    IF ( @p_item_id <> '')  
    BEGIN  
     DELETE A  
     FROM #RAW_DATA A  
     LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B WITH(NOLOCK) 
	      ON A.ITEM_ID = B.ITEM_ID  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_item_id,',')   
         ) C ON A.ITEM_ID LIKE '%' + C.TOKEN + '%'  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_item_id,',')   
         ) D ON B.NICK_NAME LIKE '%' + D.TOKEN + '%'  
     WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL  
    END  
  
    IF ( @p_owner <> '')  
    BEGIN  
     DELETE A  
     FROM #RAW_DATA A  
     LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B WITH(NOLOCK) 
	      ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_owner,',')   
         ) C ON B.OWNER LIKE '%' + C.TOKEN + '%'  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_owner,',')   
         ) D ON B.OWNER_NAME LIKE '%' + D.TOKEN + '%'  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_owner,',')   
         ) E ON B.OWNER_NAME_KO LIKE '%' + E.TOKEN + '%'  
     WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL  AND E.TOKEN IS NULL  
    END  
      
    IF ( @p_dept_id <> 'ALL')  
    BEGIN  
	--[PJ2024-50461] Team Mapping------------------------------------
		--기타매출은 기존 SALE SITE 정보를 이용하므로 검색시도 구분해야함

		--기타매출 이외
		DELETE A  
		FROM #RAW_DATA A  
		LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B WITH(NOLOCK) 
			ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE  
		LEFT OUTER JOIN ( SELECT DISTINCT token   
			FROM dbo.String_Split(@p_dept_id,',')   
			) C ON B.DEPT_ID = C.TOKEN  
		WHERE C.TOKEN IS NULL  
		AND A.FCST_TYPE <> 'ETC'

		--기타매출(40 이외 사업부)
		DELETE A
		FROM #RAW_DATA A
		LEFT OUTER JOIN SCM_MST_SITE B WITH (NOLOCK) ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = @P_DIVISION_ID
		LEFT OUTER JOIN (	SELECT DISTINCT token 
							FROM dbo.String_Split(@p_dept_id,',') 
						) C	ON B.DEPT_ID = C.TOKEN
		WHERE C.TOKEN IS NULL
		AND A.FCST_TYPE = 'ETC' AND A.DIVISION_ID <> '40' --[PJ2024-50611] 40 이외 사업부는 기타일 경우 SCM_MST_SITE 에서 가져옴

		----[PJ2024-50611]기타매출(40사업부) START
		DELETE A
		FROM #RAW_DATA A
		LEFT OUTER JOIN (	SELECT DISTINCT token 
							FROM dbo.String_Split(@p_dept_id,',') 
						) C	ON A.ATTRIBUTE1 = C.TOKEN --[PJ2024-50611] 40사업부 기타매출은 ATTRIBUTE1 에 부서코드 있음
		WHERE C.TOKEN IS NULL
		AND A.FCST_TYPE = 'ETC' AND A.DIVISION_ID = '40'
		----[PJ2024-50611]기타매출(40사업부) END


	/*
     IF ( @P_DIVISION_ID = '40')  
     BEGIN  
      DELETE A  
      FROM #RAW_DATA A  
      LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B WITH(NOLOCK) 
	       ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE  
      LEFT OUTER JOIN ( SELECT DISTINCT token   
           FROM dbo.String_Split(@p_dept_id,',')   
          ) C ON B.DEPT_ID = C.TOKEN  
      WHERE C.TOKEN IS NULL  
     END  
     ELSE  
     BEGIN  
      DELETE A  
      FROM #RAW_DATA A  
      LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) 
	       ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = @P_DIVISION_ID  
      LEFT OUTER JOIN ( SELECT DISTINCT token   
           FROM dbo.String_Split(@p_dept_id,',')   
          ) C ON B.DEPT_ID = C.TOKEN  
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
      LEFT OUTER JOIN ( SELECT DISTINCT token   
           FROM dbo.String_Split(@p_end_customer,',')   
          ) C ON A.PROJECT_CODE = C.TOKEN  
      WHERE C.TOKEN IS NULL  
     END  
     ELSE  
     BEGIN  
      DELETE A  
      FROM #RAW_DATA A  
      LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) 
	       ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = @P_DIVISION_ID  
      LEFT OUTER JOIN ( SELECT DISTINCT token   
           FROM dbo.String_Split(@p_end_customer,',')   
          ) C ON B.END_CUSTOMER = C.TOKEN  
      WHERE C.TOKEN IS NULL  
     END  
    END  
      
    IF ( @p_scm_site_id <> 'ALL')  
    BEGIN  
     DELETE A  
     FROM #RAW_DATA A  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_scm_site_id,',')   
         ) C ON A.SCM_SITE_ID = C.TOKEN  
     WHERE C.TOKEN IS NULL  
    END  
      
    IF ( @p_plant_site_id <> 'ALL')  
    BEGIN  
     DELETE A  
     FROM #RAW_DATA A  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_plant_site_id,',')   
         ) C ON A.PLANT_SITE_ID = C.TOKEN  
     WHERE C.TOKEN IS NULL  
    END  
  
    IF ( @p_item_type <> 'ALL')  
    BEGIN  
     DELETE A  
     FROM #RAW_DATA A  
     LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID  
     LEFT OUTER JOIN ( SELECT DISTINCT token   
          FROM dbo.String_Split(@p_item_type,',')   
         ) C ON B.ITEM_TYPE = C.TOKEN  
     WHERE C.TOKEN IS NULL  
    END  
  
    IF ( @p_biztype <> 'ALL')  
    BEGIN  
     IF( @P_DIVISION_ID = '40' )  
     BEGIN  
      DELETE A  
      FROM #RAW_DATA A  
      LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID  
      LEFT OUTER JOIN ( SELECT DISTINCT token   
           FROM dbo.String_Split(@p_biztype,',')   
          ) C ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN  
      WHERE C.TOKEN IS NULL  
     END  
     ELSE  
     BEGIN  
      DELETE A  
      FROM #RAW_DATA A  
      JOIN SCM_MST_PROJECT B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE  
      LEFT OUTER JOIN ( SELECT DISTINCT token   
           FROM dbo.String_Split(@p_biztype,',')   
          ) C ON B.BIZ_TYPE LIKE '%' + C.TOKEN + '%'  
      WHERE C.TOKEN IS NULL  
     END  
    END  
  
   END -- 필터링 끝  
  
  
  
print 'E4--' + convert(varchar(30), getdate(), 121)  
--SELECT COUNT(*) FROM #RAW_DATA  
  
  -- 실적구간 PRICE 처리  
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'LOC')  
  BEGIN  
    INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,TEXT,INCOTERMS,DOM_EXP,FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE,YYYYMMDD,QTY, PLAN_RESULT, CELL_PROD_SITE_ID )  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,'' AS TEXT 
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC' AS MEASURE, A.YYYYMMDD  
       , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R', A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    FROM (  
     SELECT   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID 
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD   
       ,SUM(A.QTY) AS QTY ,A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
     FROM #RAW_DATA AS A WITH(NOLOCK)  
     WHERE   YYYYMMDD >= @v_start_yyyymmdd   
       and YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd  
               ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)  
             END  
       AND A.MEASURE = 'RTF_SYS_RP'  
     GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
     ) A  
    JOIN (  
     SELECT   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가3
       ,SUM(A.QTY) AS QTY  
     FROM #RAW_DATA AS A WITH(NOLOCK)  
     WHERE   YYYYMMDD >= @v_start_yyyymmdd   
       and YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd  
               ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)  
             END  
       AND A.MEASURE = 'SalesAmt_LOC'  
     GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
     ) B ON A.VERSION_NO = B.VERSION_NO   
      AND A.DIVISION_ID = B.DIVISION_ID  
      AND A.PROJECT_CODE = B.PROJECT_CODE  
      AND A.SCM_SITE_ID = B.SCM_SITE_ID  
      AND A.PLANT_SITE_ID = B.PLANT_SITE_ID  
      AND A.ITEM_ID = B.ITEM_ID  
      AND A.INCOTERMS = B.INCOTERMS  
      AND A.DOM_EXP = B.DOM_EXP  
      AND A.FCST_TYPE = B.FCST_TYPE  
      AND A.CURRENCY = B.CURRENCY  
      AND A.YYYYMMDD = B.YYYYMMDD  
      AND ISNULL(A.COMPANY_ID,'') = ISNULL(B.COMPANY_ID,'')
	  AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
  END  
  
print 'E5--' + convert(varchar(30), getdate(), 121)    
--------------------------------------------------------------------------------------------------------------
IF (@V_DM_PROGRAM_LOG_FLAG = 'Y')
BEGIN 	
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_DM_SYS_LOG_BATCH @p_program_id, 'SM-T', 0, 'E5--', '', @d_event_date, @p_created_by; --[E20240115-000325]
END
--------------------------------------------------------------------------------------------------------------
  
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE = 'KRW' )  
  BEGIN  
    INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,TEXT,INCOTERMS,DOM_EXP,FCST_TYPE, CURRENCY, COMPANY_ID,MEASURE,YYYYMMDD,QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,'' AS TEXT 
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW' AS MEASURE, A.YYYYMMDD  
       , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R', A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    FROM (  
     SELECT   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
       ,SUM(A.QTY) AS QTY  
     FROM #RAW_DATA AS A WITH(NOLOCK)  
     WHERE   YYYYMMDD >= @v_start_yyyymmdd   
       and YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd  
               ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)  
             END  
       AND A.MEASURE = 'RTF_SYS_RP'  
     GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
     ) A  
    JOIN (  
     SELECT   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
       ,SUM(A.QTY) AS QTY  
     FROM #RAW_DATA AS A WITH(NOLOCK)  
     WHERE   YYYYMMDD >= @v_start_yyyymmdd   
       and YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN @p_now_yyyymmdd  
               ELSE CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112)  
             END  
       AND A.MEASURE = 'SalesAmt_KRW'  
     GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
       ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
     ) B ON A.VERSION_NO = B.VERSION_NO   
      AND A.DIVISION_ID = B.DIVISION_ID  
      AND A.PROJECT_CODE = B.PROJECT_CODE  
      AND A.SCM_SITE_ID = B.SCM_SITE_ID  
      AND A.PLANT_SITE_ID = B.PLANT_SITE_ID  
      AND A.ITEM_ID = B.ITEM_ID  
      AND A.INCOTERMS = B.INCOTERMS  
      AND A.DOM_EXP = B.DOM_EXP  
      AND A.FCST_TYPE = B.FCST_TYPE  
      AND A.CURRENCY = B.CURRENCY  
      AND A.YYYYMMDD = B.YYYYMMDD  
      AND ISNULL(A.COMPANY_ID,'') = ISNULL(B.COMPANY_ID,'')
	  AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
        
  END  
  
print 'E6--' + convert(varchar(30), getdate(), 121)    
  
  -- 계획구간 PRICE 처리  
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD' ))  
   AND @p_version_type LIKE '%CURRENT%'   
  BEGIN  

		IF ( @P_DIVISION_ID = '40') 
		BEGIN
			INSERT INTO #RAW_DATA   
				(VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT  
				,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM (  
				SELECT   DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,A.TEXT   
				,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,B.basis_start_date, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #RAW_DATA A  WITH(NOLOCK) 
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  
				WHERE   A.YYYYMMDD >= @p_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd  
				AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up', 'SCM_FCST' ) --[PJ2025-50188] SCM_FCST - MEASURE 추가
				--[PJ2024-50611] Catch Up만 등록 되었을 경우 UNIT PRICE 보이게 수정
				) A  
			JOIN DM_PLN_CFM_SELLING_PRICE C WITH(NOLOCK) ON A.DIVISION_ID  = C.DIVISION_ID  
						AND A.PROJECT_CODE  = C.PROJECT_CODE  
						AND A.SCM_SITE_ID  = C.SCM_SITE_ID  
						AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
						AND A.PLANT_SITE_ID  = C.PLANT_SITE_ID  
						AND A.ITEM_ID   = C.ITEM_ID  
						AND A.INCOTERMS   = C.INCOTERMS  
						AND A.DOM_EXP   = C.DOM_EXP  
						AND A.FCST_TYPE   = C.FCST_TYPE  
						AND A.basis_start_date = C.YYYYMMDD  
						AND C.YYYYMMDD   <= @p_to_yyyymmdd  
			JOIN #SELECT_MEASURE D ON C.MEASURE = D.MEASURE  
		END
		ELSE -- ( @P_DIVISION_ID <> '40')  
		BEGIN
			INSERT INTO #RAW_DATA   
				(VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT  
				,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID     --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM (  
				SELECT   DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,A.TEXT   
				,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,B.basis_start_date, A.CELL_PROD_SITE_ID    --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #RAW_DATA A  WITH(NOLOCK) 
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  
				WHERE   A.YYYYMMDD >= @p_now_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd  
				AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
				--[PJ2024-50611] Catch Up만 등록 되었을 경우 UNIT PRICE 보이게 수정
				) A  
			JOIN SCM_MST_FUTURE_PRICE C WITH(NOLOCK) ON A.DIVISION_ID  = C.DIVISION_ID  
						AND A.PROJECT_CODE  = C.PROJECT_CODE  
						AND A.SCM_SITE_ID  = C.SCM_SITE_ID  
						AND A.PLANT_SITE_ID  = C.PLANT_SITE_ID  
						AND A.ITEM_ID   = C.ITEM_ID  
						AND A.INCOTERMS   = C.INCOTERMS  
						AND A.DOM_EXP   = C.DOM_EXP  
						AND A.FCST_TYPE   = C.FCST_TYPE  
						AND A.basis_start_date = C.YYYYMMDD  
						AND C.YYYYMMDD   <= @p_to_yyyymmdd  
			JOIN #SELECT_MEASURE D ON C.MEASURE = D.MEASURE  
		END  
  END  
  
print 'E7--' + convert(varchar(30), getdate(), 121)    
  
--------------------------------------------------------------------------------------------------------------
IF (@V_DM_PROGRAM_LOG_FLAG = 'Y')
BEGIN 	
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_DM_SYS_LOG_BATCH @p_program_id, 'SM-T', 0, 'E7--', '', @d_event_date, @p_created_by; --[E20240115-000325]
END
--------------------------------------------------------------------------------------------------------------  
 
    
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD' ))  
   AND @p_version_type LIKE '%SP_%'  
  BEGIN  
  
     CREATE TABLE #T_PRICE (  
     DIVISION_ID NVARCHAR(30)  
   , VERSION_NO VARCHAR(50)  
   , PROJECT_CODE NVARCHAR(50)  
   , SCM_SITE_ID NVARCHAR(30)  
   , PLANT_SITE_ID NVARCHAR(30)  
   , ITEM_ID  NVARCHAR(50)
   , YYYYMMDD  NVARCHAR(8)   
   , CURRENCY  NVARCHAR(10) 
   , MEASURE  NVARCHAR(50) 
   , DOM_EXP  NVARCHAR(3)  
   , FCST_TYPE  NVARCHAR(20)  
   , INCOTERMS  NVARCHAR(10) 
   , PRICE  NUMERIC(30,10)  
   , CELL_PROD_SITE_ID NVARCHAR(60) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
   )  

	IF ( @P_DIVISION_ID = '40') 
	BEGIN
		INSERT INTO #T_PRICE (DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
		                    , CURRENCY   , MEASURE   , DOM_EXP     , FCST_TYPE  , INCOTERMS    , PRICE  , CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE , A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD
			 , A.CURRENCY  	, A.MEASURE   , A.DOM_EXP      , A.FCST_TYPE  , A.INCOTERMS    , A.PRICE  , A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		--INTO #T_PRICE  
		FROM DM_PLN_CFM_SELLING_PRICE_C A  WITH (NOLOCK) --[E20240115-000325] WITH (NOLOCK)처리 
		JOIN #SELECT_MEASURE C WITH (NOLOCK) ON A.MEASURE = C.MEASURE  
		JOIN (  
			SELECT   DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
			,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM #RAW_DATA A WITH(NOLOCK)  
						-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청  
			WHERE   A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) and A.YYYYMMDD <= @p_to_yyyymmdd  
			AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' ) --[PJ2025-50188] SCM_FCST - MEASURE 추가			
			) B ON A.DIVISION_ID  = B.DIVISION_ID  
			AND A.PROJECT_CODE  = B.PROJECT_CODE  
			AND A.SCM_SITE_ID  = B.SCM_SITE_ID  
			AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID  
			AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			AND A.ITEM_ID   = B.ITEM_ID  
			AND A.INCOTERMS   = B.INCOTERMS  
			AND A.DOM_EXP   = B.DOM_EXP  
			AND A.FCST_TYPE   = B.FCST_TYPE  
		WHERE A.DIVISION_ID = @P_DIVISION_ID  
		AND A.VERSION_NO IN (SELECT LEFT(token, CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END) FROM dbo.String_Split(@p_version_type ,','))   
		AND A.YYYYMMDD <= @p_to_yyyymmdd  
	END
	ELSE -- ( @P_DIVISION_ID <> '40')
	BEGIN
		INSERT INTO #T_PRICE (DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
		                    , CURRENCY   , MEASURE   , DOM_EXP     , FCST_TYPE  , INCOTERMS    , PRICE  , CELL_PROD_SITE_ID )  
		SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID , A.YYYYMMDD
		     , A.CURRENCY   , A.MEASURE   , A.DOM_EXP     , A.FCST_TYPE  , A.INCOTERMS    , A.PRICE   , '-' 
																									  --SCM_MST_FUTURE_PRICE_C 테이블에서는 CELL_PROD_SITE_ID를 안쓰기 때문에 의미는 없음.
		--INTO #T_PRICE  
		FROM SCM_MST_FUTURE_PRICE_C A  WITH (NOLOCK) --[E20240115-000325] WITH (NOLOCK)처리 
		JOIN #SELECT_MEASURE C WITH (NOLOCK) ON A.MEASURE = C.MEASURE  
		JOIN (  
			SELECT   DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID   
			,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD   
			FROM #RAW_DATA A WITH(NOLOCK)  
						-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청  
			WHERE   A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) and A.YYYYMMDD <= @p_to_yyyymmdd  
			AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
			) B ON A.DIVISION_ID  = B.DIVISION_ID  
			AND A.PROJECT_CODE  = B.PROJECT_CODE  
			AND A.SCM_SITE_ID  = B.SCM_SITE_ID  
			AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID  
			AND A.ITEM_ID   = B.ITEM_ID  
			AND A.INCOTERMS   = B.INCOTERMS  
			AND A.DOM_EXP   = B.DOM_EXP  
			AND A.FCST_TYPE   = B.FCST_TYPE  
		WHERE A.DIVISION_ID = @P_DIVISION_ID  
		AND A.VERSION_NO IN (SELECT LEFT(token, CASE WHEN CHARINDEX('(',token) = 0 THEN LEN(token) ELSE CHARINDEX('(',token)-1 END) FROM dbo.String_Split(@p_version_type ,','))   
		AND A.YYYYMMDD <= @p_to_yyyymmdd  
	END

print 'E7_1--' + convert(varchar(30), getdate(), 121)   

   IF @p_division_id <> '82' AND @p_division_id <> '40'
   BEGIN  
    print 'E7_1_1--' + convert(varchar(30), getdate(), 121) 
    INSERT INTO #RAW_DATA   
      (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  )  
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,A.TEXT   
        ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID  
    FROM (  
      SELECT   DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT  
        ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD ,B.basis_start_date, A.CELL_PROD_SITE_ID  
      FROM #RAW_DATA A WITH(NOLOCK)  
      JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
      -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청  
      WHERE   A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) and A.YYYYMMDD <= @p_to_yyyymmdd  
        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
      ) A  
   -- JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD    /* 20240228 KCW3408 속도개선 */
    JOIN #T_PRICE C WITH(NOLOCK) ON A.DIVISION_ID  = C.DIVISION_ID  
          AND A.PROJECT_CODE  = C.PROJECT_CODE  
          AND A.SCM_SITE_ID  = C.SCM_SITE_ID  
          AND A.PLANT_SITE_ID  = C.PLANT_SITE_ID  
          AND A.ITEM_ID   = C.ITEM_ID  
          AND A.INCOTERMS   = C.INCOTERMS  
          AND A.DOM_EXP   = C.DOM_EXP  
          AND A.FCST_TYPE   = C.FCST_TYPE  
          AND A.basis_start_date = C.YYYYMMDD          
          AND A.VERSION_NO  = C.VERSION_NO  
  --  JOIN  #SELECT_MEASURE D WITH(NOLOCK)  ON C.MEASURE = D.MEASURE  
   END  
   ELSE IF @p_division_id = '82'
   BEGIN  
    print 'E7_1_2--' + convert(varchar(30), getdate(), 121)   
    INSERT INTO #RAW_DATA   
      (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  )  
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT  
        ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID  
    FROM (  
      SELECT   DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT  
        ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,B.basis_start_date, A.CELL_PROD_SITE_ID    
      FROM #RAW_DATA A WITH(NOLOCK)  
      JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD   /* 20240228 KCW3408 속도개선 */
      -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청  
      WHERE   A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) and A.YYYYMMDD <= @p_to_yyyymmdd  
        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
      ) A  
    --JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
    JOIN #T_PRICE C WITH(NOLOCK) ON A.DIVISION_ID  = C.DIVISION_ID  
          AND A.PROJECT_CODE  = C.PROJECT_CODE  
          AND A.SCM_SITE_ID  = C.SCM_SITE_ID  
          AND A.PLANT_SITE_ID  = C.PLANT_SITE_ID  
          AND A.ITEM_ID   = C.ITEM_ID  
          AND A.INCOTERMS   = C.INCOTERMS  
          AND A.DOM_EXP   = C.DOM_EXP  
          AND A.FCST_TYPE   = C.FCST_TYPE  
          AND A.basis_start_date = C.YYYYMMDD          
          AND SUBSTRING(A.VERSION_NO, 0, CHARINDEX('(',A.VERSION_NO)) = C.VERSION_NO --[E20230130-000233]  
               
  -- JOIN #SELECT_MEASURE D ON C.MEASURE = D.MEASURE  
   END  
   ELSE IF @p_division_id = '40'
   BEGIN  
	print 'E7_1_3--' + convert(varchar(30), getdate(), 121)   
    INSERT INTO #RAW_DATA   
      (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  )  
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT  
        ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD, C.PRICE, 'P', A.CELL_PROD_SITE_ID  
    FROM (  
      SELECT   DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT  
        ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD,B.basis_start_date, A.CELL_PROD_SITE_ID    
      FROM #RAW_DATA A WITH(NOLOCK)  
      JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD   /* 20240228 KCW3408 속도개선 */
      -- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청  
      WHERE   A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON')), 112) and A.YYYYMMDD <= @p_to_yyyymmdd  
        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' ) --[PJ2025-50188] SCM_FCST - MEASURE 추가
      ) A  
    --JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
    JOIN #T_PRICE C WITH(NOLOCK) ON A.DIVISION_ID  = C.DIVISION_ID  
          AND A.PROJECT_CODE  = C.PROJECT_CODE  
          AND A.SCM_SITE_ID  = C.SCM_SITE_ID  
          AND A.PLANT_SITE_ID  = C.PLANT_SITE_ID  
          AND A.ITEM_ID   = C.ITEM_ID  
          AND A.INCOTERMS   = C.INCOTERMS  
          AND A.DOM_EXP   = C.DOM_EXP  
          AND A.FCST_TYPE   = C.FCST_TYPE  
          AND A.basis_start_date = C.YYYYMMDD          
          AND SUBSTRING(A.VERSION_NO, 0, CHARINDEX('(',A.VERSION_NO)) = C.VERSION_NO --[E20230130-000233]  
          AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
  -- JOIN #SELECT_MEASURE D ON C.MEASURE = D.MEASURE  
   END  
  END  
  
print 'J--' + convert(varchar(30), getdate(), 121)  
  
  ------------------------------------------------------------------------------------------  
  -- 필요없는 메저 삭제   
  ------------------------------------------------------------------------------------------  
  DELETE A  
  FROM #RAW_DATA A  
  JOIN #SELECT_MEASURE B WITH(NOLOCK) ON A.MEASURE = B.MEASURE  
  WHERE B.SYSTEM_ADD = 'Y'  
  
  IF EXISTS ( SELECT * FROM #SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY'))  
  BEGIN  
     
   INSERT INTO #RAW_DATA   
     (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  )  
   SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,A.TEXT   
     ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD  
     ,CASE WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN  
        CASE WHEN CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR  
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
         THEN (A.QTY * C.ENERGE)/1000  
        END  
       -- 20221214 rosia27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy  
       WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' THEN  
        CASE WHEN ISNUMERIC(C.ENERGE) > 0   
         THEN (C.ENERGE * A.QTY)/1000  
        END  
       ELSE 0   
     END  
     , A.PLAN_RESULT
	 , A.CELL_PROD_SITE_ID
   FROM #RAW_DATA A WITH(NOLOCK)  
   JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP'   
        ELSE 'RTF_SYS_RP'  
        END AS MEASURE_ORI  
      , A.MEASURE AS MEASURE_CALC  
     FROM #SELECT_MEASURE A WITH(NOLOCK) 
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
     (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  )  
   SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID,A.TEXT   
     ,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD  
     ,CASE   WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND A.PLAN_RESULT = 'P' THEN  
        CASE WHEN ISNUMERIC(C.ENERGE) > 0   
         THEN (C.ENERGE * A.QTY)/1000  
        END  
       ELSE 0   
     END  
     , A.PLAN_RESULT  
	 , A.CELL_PROD_SITE_ID
   FROM #RAW_DATA A WITH(NOLOCK)  
   JOIN ( SELECT  'MKT_FCST_RP' AS MEASURE_ORI  
      , A.MEASURE AS MEASURE_CALC  
     FROM #SELECT_MEASURE A  WITH(NOLOCK)
     WHERE MEASURE IN ('MKT_FCST_ENERGY')  
     ) B ON A.MEASURE = B.MEASURE_ORI  
   JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID  
   WHERE A.MEASURE IN ( 'MKT_FCST_RP')  
  END  
  
print 'K--' + convert(varchar(30), getdate(), 121)  

--------------------------------------------------------------------------------------------------------------
IF (@V_DM_PROGRAM_LOG_FLAG = 'Y')
BEGIN 	
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_DM_SYS_LOG_BATCH @p_program_id, 'SM-T', 0, 'K--', '', @d_event_date, @p_created_by; --[E20240115-000325]
END
--------------------------------------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------------------  
  -- 컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.  
  ------------------------------------------------------------------------------------------  
  
  
  -- 컬럼리스트 생성  
  BEGIN  
   DECLARE @v_sql_text          AS NVARCHAR(MAX);  
   DECLARE @V_PV_LIST    AS NVARCHAR(MAX);  
   DECLARE @V_PV_COL_LIST   AS NVARCHAR(MAX);  
   DECLARE @v_column_name   AS NVARCHAR(100)  
   DECLARE @v_column            AS NVARCHAR(1000);  
   DECLARE @v_orderby           AS NVARCHAR(1000);  
   DECLARE @v_column_text       AS NVARCHAR(1000);  
   DECLARE @v_PV_column_name    AS NVARCHAR(100);  
   DECLARE @v_PV_NAME    AS NVARCHAR(50);  
   DECLARE @v_column_type       AS NVARCHAR(50);  
   DECLARE @v_column_value      AS NVARCHAR(50);  
   DECLARE @v_sort_order_no     AS NVARCHAR(50);  
  
   DECLARE @v_sum_qty     AS NVARCHAR(1000); --[E20230619-000151]  GSCM.DM 소수점 표기 방식 변경  
   DECLARE @v_qty_div AS NVARCHAR(1000); --[E20230619-000151]  GSCM.DM 소수점 표기 방식 변경  
   DECLARE @v_avg_qty    AS NVARCHAR(1000); --[E20230619-000151]  GSCM.DM 소수점 표기 방식 변경  
      
   ----- 날짜컬럼 -----------------------------------------------------------------------------------------------------------  
   SELECT @V_PV_LIST = '', @V_PV_COL_LIST = ''  
   DECLARE c_bucket CURSOR FAST_FORWARD FOR   
    SELECT   
      '[D_' + a.basis_yyyymmdd + '] AS D_' + A.BASIS_YYYYMMDD  AS column_name  
      ,'[D_' + a.basis_yyyymmdd + ']' AS PV_name  
      , a.basis_yyyymmdd + '_' + CONVERT(CHAR(2), 31) AS sort_order_no  
    FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)   
    WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd -- '20171101'  CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)  
    AND    a.basis_yyyymmdd <= @p_to_yyyymmdd   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)  
    AND    @p_bucket = 'DAILY'  
    UNION ALL  
    SELECT '[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + '] AS W_' + a.basis_yyyymm + a.iso_week  AS column_name  
      ,'[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + ']' AS PV_name  
      , a.basis_start_date + '_' + CONVERT(CHAR(2), 21) AS sort_order_no  
    FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)   
    WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)  
    AND    a.basis_yyyymmdd <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)  
    AND    @p_bucket != 'ONLY_WEEKLY'  
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
    AND    @p_bucket != 'ONLY_WEEKLY'  
    GROUP BY a.basis_yyyymm  
    -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)  
    UNION ALL  
    SELECT '[W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK + '] AS W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6) + A.ISO_WEEK  AS COLUMN_NAME  
     , '[W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK + ']' AS PV_NAME   
     , MAX(BASIS_YYYYMMDD)+ '_' +CONVERT(CHAR(2), 21) AS SORT_ORDER_NO  
    FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)   
    WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd   
    AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd  
    AND    @p_bucket = 'ONLY_WEEKLY'  
    GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME  
    ORDER BY sort_order_no    
    ;  
  
   OPEN c_bucket;  
   FETCH NEXT FROM c_bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no  
          WHILE @@FETCH_STATUS = 0     
   BEGIN    
    SELECT @V_PV_COL_LIST = @V_PV_COL_LIST + CASE WHEN @V_PV_COL_LIST <> '' THEN ',' ELSE '' END + @v_PV_column_name  
        , @V_PV_LIST  = @V_PV_LIST + CASE WHEN @V_PV_LIST <> '' THEN ',' ELSE '' END + @v_PV_name  
      
    FETCH NEXT FROM c_Bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no  
   END;  
  
   CLOSE c_bucket;   
   DEALLOCATE c_bucket;  
  
    /* 20240228 KCW3408 속도개선_템프사용 */
    SELECT B.SCM_SITE_ID
	     , B.DIVISION_ID
	     , B.DEPT_ID
		 , K.SOLDTO_CODE
		 , B.VMI_YN
		 , B.END_CUSTOMER
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
		   
    SELECT D.*
	     , E.SEGMENT2
		 , ISNULL(F.NICK_NAME,'') AS CELL_MODEL_NICK_NAME
      INTO #TEMP_DM_MST_ITEM_SINGLE_V_T      
      FROM #TEMP_DM_MST_ITEM_SINGLE_V D WITH(NOLOCK)
      LEFT OUTER JOIN 
	       SCM_ADM_LOOKUP_MASTER_DETAIL E WITH(NOLOCK)
		   ON D.CELL_TYPE = E.SEGMENT1 
		  AND E.LOOKUP_TYPE = 'CELL_TYPE'    
      LEFT OUTER JOIN 
	       #TEMP_DM_MST_ITEM_SINGLE_V F WITH(NOLOCK)
		   ON D.DIVISION_ID = F.DIVISION_ID 
		  AND ISNULL(D.FORECAST_INFO_CELL_MODEL,'') = F.ITEM_ID

    
CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V_T] ON [#TEMP_DM_MST_ITEM_SINGLE_V_T]
(division_id   ASC
,item_id       ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;

   ----- 일반 컬럼 -----------------------------------------------------------------------------------------------------------  
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
   
  -- print @i_Count  
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
      AND    U.USER_ID     = @p_created_by  
      AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'     
		LEFT OUTER JOIN [dbo].[SCM_MST_TITLESET_USER] TU WITH(NOLOCK)
		ON     TU.PROGRAM_ID  = C.PROGRAM_ID
		AND    TU.SHEET_NAME  = C.SHEET_NAME 
		AND    TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
		AND	   TU.COLUMN_NAME IN ('ITEM_ID') 
		AND    TU.USER_ID = @p_created_by

      --AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') ) -- 20190125 일단 주석처리 KHSONG  
    ---------  
    UNION ALL  
    ---------  
	/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
	/* kjj 수정(2024.6.24)
		UI 카테고리에서 GROUP_ID 표시되게 하였으므로 불필요한 조인 제거
	*/
    SELECT TOP 100   
	       --CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  ISNULL(U.SORT_ORDER_NO,95) - 0.5 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
		   C.SORT_ORDER_NO
       ,   C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE     
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
      --AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )  -- 20190125 일단 주석처리 KHSONG  
    ) tbColList   
    ORDER BY SORT_ORDER_NO  
   END  
   SELECT @ColList = LEFT(@ColList, LEN(@ColList)-1)   
   SELECT @OrderList = LEFT(@OrderList, LEN(@OrderList)-1)   
   
   --[E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall		
   SELECT @ColList = @ColList + ',[NOTATION]'

   --SELECT @ColList = REPLACE(@ColList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')  
   --SELECT @OrderList = REPLACE(@OrderList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')  
   SELECT @ColList = REPLACE(@ColList,'[VERSION_NO]','[VERSION_SORT],[VERSION_NO]')  
   SELECT @OrderList = REPLACE(@OrderList,'[VERSION_NO]','[VERSION_SORT] DESC,[VERSION_NO]')  
   SELECT @OrderList = REPLACE(@OrderList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]')  
  
  END -- 컬럼생성 끝 ---------------------------------------------------------------------------------------------------------------------  
    
  --select @V_PV_COL_LIST,   @V_PV_LIST,   @v_orderby,   @v_orderby  
/*  
   , DBO.FN_GET_DM_SALES_PLAN_WATERFALL_QTY2(A.MEASURE, ISNULL(D.ITEM_CLASS_NAME,''''), ISNULL(A.QTY,0), ISNULL(C.CELL_PER_CAR,0), ISNULL(C.CELL_PER_MODULE,0)  
      , ''' + @p_cell_yn + N''', ISNULL(D.FORECAST_INFO_CELL_PACK_COUNT, 0), ''' + @P_DIVISION_ID + N''', ISNULL(D.FORECAST_INFO_BIZ_TYPE, '''')) AS QTY  
*/  
  
--SELECT * FROM #RAW_DATA  
  
--select version_no, measure, count(*) from #RAW_DATA  
--group by version_no, measure  
--order by 1, 2  
  /*
  2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
    UI Category Setup 에 등록(GROUP_ID) ORDER BY 필요, GROUP_ID 추가함
  */
  
  BEGIN -- CTE 에서 사용할 SELECT COLUMN 정리  
     
   DECLARE @V_SQL_SELECT NVARCHAR(4000)  
   DECLARE @V_SQL_GROUPBY NVARCHAR(4000)  
  
   CREATE TABLE #T_COLUMN_SETUP (  
    TBL_ALIAS   NVARCHAR(10)  
   , COLUMN_NAME   NVARCHAR(100)  
   , COLUMN_STRING  NVARCHAR(1000)  
   , SORT_KEY   INT  
   )  
  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'VERSION_NO', 'A.VERSION_NO', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'DIVISION_ID', 'A.DIVISION_ID', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE', 'A.PROJECT_CODE', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID', 'A.SCM_SITE_ID', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'PLANT_SITE_ID', 'A.PLANT_SITE_ID', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'GROUP_ID', 'ISNULL(I.GROUP_ID,'' '') AS GROUP_ID', 1) 
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID', 'A.ITEM_ID', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'TEXT','CASE WHEN LEN(A.TEXT) = 0   THEN '' '' ELSE A.TEXT END  AS TEXT' , 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'INCOTERMS', 'A.INCOTERMS', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'DOM_EXP', 'A.DOM_EXP', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'FCST_TYPE', 'A.FCST_TYPE', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'MEASURE', 'A.MEASURE', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'INTERNAL_YN', 'CASE WHEN LEN(A.SCM_SITE_ID) > 2 AND LEN(A.SCM_SITE_ID) < 6  THEN ''Y'' ELSE ''N'' END AS INTERNAL_YN', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'YYYYMMDD', 'A.YYYYMMDD', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'QTY', 'A.QTY', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'VMI_YN', 'B.VMI_YN', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'END_CUSTOMER', 'B.END_CUSTOMER', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'AC', 'CURRENCY', 'CASE WHEN A.CURRENCY <> '''' THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A', 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID', 1) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
   --[PJ2024-50461] Team Mapping------------------------------------
   --INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID', 1)  
   --INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'C.DEPT_ID', 1)  
	--기타매출은 모델이 없으므로 기존의 Site 의 팀으로 조회
	--INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN B.DEPT_ID ELSE C.DEPT_ID END AS DEPT_ID', 1)
	--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1))
	INSERT INTO #T_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID', 1)
	--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1))
   --[PJ2024-50461] Team Mapping------------------------------------
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
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'FORECAST_INFO_CELL_MODEL', 'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'PRIORITY', 'C.ATTRIBUTE7 AS PRIORITY', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'KWH_CELL', 'C.ATTRIBUTE8 AS KWH_CELL', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP6', 'ISNULL(C.REPORT_GROUP6,'''') AS REPORT_GROUP6', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'AC', 'KWH_MODULE', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_MODULE * C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'AC', 'KWH_PACK', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_CAR * C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'ENERGE', 'D.ENERGE', 1)  
   --[E20240731-000852]_40 사업부 용 ENERGE 컬럼 추가 START
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'ENERGE_WH', 'D.ENERGE_WH', 1) 
   --[E20240731-000852]_40 사업부 용 ENERGE 컬럼 추가 END
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
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'CELL_TYPE', 'D.SEGMENT2 AS CELL_TYPE', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'D', 'CELL_MODEL_NICK_NAME', 'D.CELL_MODEL_NICK_NAME', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'BIZ_TYPE_NAME', 'G.BIZ_TYPE AS BIZ_TYPE_NAME', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PROJECT_NAME', 'G.PROJECT_NAME', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PROJECT_OWNER', 'G.PROJECT_OWNER', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PROJECT_STATUS', 'G.PROJECT_STATUS', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'G', 'PRODUCT_GROUP_NAME', 'G.PRODUCT_GROUP_NAME', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'CITY_NAME', 'B.CITY_NAME', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'COUNTRY_NAME', 'B.COUNTRY_NAME', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'SHIPTO_DESCRIPTION', 'B.SHIPTO_DESCRIPTION', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'M', 'SORT_ORDER_NO', 'M.SORT_ORDER_NO', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'C', 'SALES_COMPANY', 'C.SALES_COMPANY', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'SOLDTO_CODE', 'B.SOLDTO_CODE', 1)  
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'B', 'SOLDTO_DESCRIPTION', 'B.SOLDTO_DESCRIPTION', 1) --[E20230410-000032] 20230420추가     
   --[E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall		
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'O', 'SEGMENT3', 'ISNULL(O.SEGMENT3, ''DEFAULT'') AS NOTATION', 1)
   ----[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 START
   INSERT INTO #T_COLUMN_SETUP VALUES ( 'A','SCP_USE_YN', N'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN ( ''VMI_In_Req'', ''VMI_In_Plan'')  THEN ''Y''							
																  WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN ( ''MKT_FCST_RP'',''MKT_FCST'', ''RTF'',''RTF_SCP'',''RTF_SYS_RP'',''RTF_PR'') THEN ''Y''										
															 ELSE ''N'' END AS SCP_USE_YN', 1)
   ----[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 END
  
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
  

	/* [PJ2024-50611] 소형 매출 프로세스 개선*/
  	IF @p_division_id = '40'
	BEGIN 
		-- 1) #RAW_DATA_FINAL 의 Measure = 'RTF_SYS_RP / RTF_SCP'가 있는 것은 삭제한다. 단, 계획구간에서만

		SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			  , PLANT_SITE_ID
			  , ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID    
		INTO #RAW_DATA_TEMP40 
		FROM #RAW_DATA WITH(NOLOCK) 
		WHERE DIVISION_ID = @p_division_id
		AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
		AND   YYYYMMDD >= @p_now_yyyymmdd
		;

		SELECT  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE
			  , CURRENCY, COMPANY_ID, MEASURE, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
		INTO #RAW_DATA_TEMP40_KEY 
		FROM #RAW_DATA_TEMP40 WITH(NOLOCK) 
		GROUP BY VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE
			   , CURRENCY, COMPANY_ID, MEASURE, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID

		
		-- 기타매출은 제외하고 삭제함. (기타매출은 RTF에 없기 때문에 기존 SalesPlan 데이터 유지
		DELETE #RAW_DATA
		WHERE DIVISION_ID = @p_division_id
		AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
		AND   YYYYMMDD >= @p_now_yyyymmdd
		-- 기타매출은 제외하고 삭제
		AND   ITEM_ID NOT IN (
						SELECT DISTINCT ITEM_ID 
						--FROM DM_PLN_SALES_PLAN Z WITH(NOLOCK)
						FROM DM_PLN_SALES_ETC_PLAN Z WITH(NOLOCK)--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
						WHERE Z.DIVISION_ID = @p_division_id
						AND   Z.FCST_TYPE = 'ETC'
						AND   Z.YYYYMMDD >= @p_now_yyyymmdd
						AND   Z.ITEM_ID NOT IN (
													SELECT ITEM_ID
													FROM SCP_MST_FINAL_ITEM WITH(NOLOCK)
													WHERE DIVISION_ID = @p_division_id
												)	
		)
		;

		IF ( @p_version_type LIKE '%CURRENT%' )
		BEGIN

			-- 2-1) #RAW_DATA_FINAL 에 DM_PLN_SALES_PLAN 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.
			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C

			INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
								  , PLANT_SITE_ID
								  , ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
								  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)    
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			    , B.PLANT_SITE_ID
				, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID
				, A.MEASURE
				, B.YYYYMMDD, B.QTY
				, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM  #RAW_DATA_TEMP40_KEY A WITH(NOLOCK)   
			INNER JOIN DM_PLN_SALES_PLAN B WITH(NOLOCK) 
			ON 1=1
			 AND  A.DIVISION_ID		  = B.DIVISION_ID
			 AND  A.PROJECT_CODE	  = B.PROJECT_CODE
			 AND  A.SCM_SITE_ID		  = B.SCM_SITE_ID
			 AND  A.ITEM_ID			  = B.ITEM_ID
			 AND  A.INCOTERMS		  = B.INCOTERMS
			 AND  A.DOM_EXP			  = B.DOM_EXP
			 AND  A.FCST_TYPE		  = B.FCST_TYPE
			 AND  A.MEASURE			  = B.MEASURE
			 AND  B.YYYYMMDD		  >= @p_now_yyyymmdd
			 AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			;

			--UPDATE A
			--SET   A.PLANT_SITE_ID = B.PLANT_SITE_ID
			--	, A.FROM_SITE_ID  = B.FROM_SITE_ID
			--FROM  #RAW_DATA A WITH(NOLOCK)   
			--INNER JOIN DM_PLN_RTF_ALLOCATION B WITH(NOLOCK) 
			--ON 1=1
			-- AND  A.DIVISION_ID		= B.DIVISION_ID
			-- AND  A.PROJECT_CODE	= B.PROJECT_CODE
			-- AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
			-- AND  A.ITEM_ID			= B.ITEM_ID
			-- AND  A.INCOTERMS		= B.INCOTERMS
			-- AND  A.DOM_EXP			= B.DOM_EXP
			-- AND  A.FCST_TYPE		= B.FCST_TYPE
			-- AND  A.MEASURE			= 'RTF_ENERGY'
			-- AND  B.MEASURE			= 'RTF_SCP'
			-- AND  A.YYYYMMDD		= B.YYYYMMDD
			-- AND  A.YYYYMMDD		>= @p_now_yyyymmdd
			-- AND  B.YYYYMMDD		>= @p_now_yyyymmdd
			--;


			IF OBJECT_ID (N'tempdb..#temp_RTF_ENERGY', N'U') IS NOT NULL   
				DROP TABLE #temp_RTF_ENERGY  
			; 

			SELECT *
			INTO #temp_RTF_ENERGY
			FROM #RAW_DATA A WITH(NOLOCK)   
			WHERE A.DIVISION_ID = @p_division_id
			AND   A.MEASURE		= 'RTF_ENERGY'
			;

			DELETE #RAW_DATA 
			WHERE DIVISION_ID = @p_division_id
			AND   MEASURE	= 'RTF_ENERGY'
			;

			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C

			INSERT INTO #RAW_DATA ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
								  , PLANT_SITE_ID
								  , ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
								  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)    
			SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			    , B.PLANT_SITE_ID
				, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID
				, A.MEASURE
				, B.YYYYMMDD, A.QTY
				, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM  #temp_RTF_ENERGY A WITH(NOLOCK)   
			INNER JOIN DM_PLN_SALES_PLAN B WITH(NOLOCK)   
			ON 1=1
			 AND  A.DIVISION_ID		  = B.DIVISION_ID
			 AND  A.PROJECT_CODE	  = B.PROJECT_CODE
			 AND  A.SCM_SITE_ID		  = B.SCM_SITE_ID
			 AND  A.PLANT_SITE_ID	  = B.PLANT_SITE_ID
			 AND  A.ITEM_ID			  = B.ITEM_ID
			 AND  A.INCOTERMS		  = B.INCOTERMS
			 AND  A.DOM_EXP			  = B.DOM_EXP
			 AND  A.FCST_TYPE		  = B.FCST_TYPE
			 AND  A.YYYYMMDD		  = B.YYYYMMDD
			 AND  A.MEASURE			  = 'RTF_ENERGY'
			 AND  B.MEASURE			  = 'RTF_SYS_RP'
			 AND  B.YYYYMMDD		  >= @p_now_yyyymmdd
			 AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			;

			MERGE INTO #RAW_DATA A
			USING (
					SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY, A.CELL_PROD_SITE_ID
					FROM #RAW_DATA A WITH(NOLOCK)
					INNER JOIN ( 
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
									FROM #RAW_DATA WITH(NOLOCK)
									WHERE DIVISION_ID = @p_division_id
									AND   VERSION_NO = @p_version_type
									AND   MEASURE = 'RTF_SYS_RP'
									AND   YYYYMMDD >= @p_now_yyyymmdd
									GROUP BY  DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID
								) B
					ON 1=1
					AND  A.DIVISION_ID		= B.DIVISION_ID
					AND  A.PROJECT_CODE		= B.PROJECT_CODE
					AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
					AND  A.PLANT_SITE_ID	= B.PLANT_SITE_ID			
					AND  A.ITEM_ID			= B.ITEM_ID
					AND  A.INCOTERMS		= B.INCOTERMS
					AND  A.DOM_EXP			= B.DOM_EXP
					AND  A.FCST_TYPE		= B.FCST_TYPE
					AND  A.YYYYMMDD			= B.YYYYMMDD
					WHERE A.DIVISION_ID       = @p_division_id
					AND   A.VERSION_NO        = @p_version_type
					AND   A.MEASURE           = 'RTF_SYS_RP'
					AND   A.YYYYMMDD         >= @p_now_yyyymmdd
					AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			) B
			ON ( 1=1
			AND  A.DIVISION_ID		 = B.DIVISION_ID
			AND  A.PROJECT_CODE		 = B.PROJECT_CODE
			AND  A.SCM_SITE_ID		 = B.SCM_SITE_ID
			AND  A.PLANT_SITE_ID	 = B.PLANT_SITE_ID			
			AND  A.ITEM_ID			 = B.ITEM_ID
			AND  A.INCOTERMS		 = B.INCOTERMS
			AND  A.DOM_EXP			 = B.DOM_EXP
			AND  A.FCST_TYPE		 = B.FCST_TYPE
			AND  A.YYYYMMDD			 = B.YYYYMMDD
			AND  A.MEASURE			 = 'RTF_ENERGY'
			AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			)
			WHEN MATCHED THEN
				UPDATE	SET A.QTY	= A.QTY * (B.QTY/B.SUM_QTY)
			;



		END
		ELSE IF ( @p_version_type LIKE '%SP%')
		BEGIN
			-- 2-2) #RAW_DATA_FINAL 에 DM_PLN_SALES_PLAN_C 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.
			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C

			INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
								  , PLANT_SITE_ID
								  , ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
								  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)    
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			    , B.PLANT_SITE_ID
				, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID
				, A.MEASURE
				, B.YYYYMMDD, B.QTY
				, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM  #RAW_DATA_TEMP40_KEY A WITH(NOLOCK)     
			INNER JOIN DM_PLN_SALES_PLAN_C B WITH(NOLOCK) 
			ON 1=1
			 AND  A.DIVISION_ID		  = B.DIVISION_ID
			 AND  A.VERSION_NO		  = B.VERSION_NO
			 AND  A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
			 AND  A.PROJECT_CODE	  = B.PROJECT_CODE
			 AND  A.SCM_SITE_ID		  = B.SCM_SITE_ID
			 AND  A.ITEM_ID			  = B.ITEM_ID
			 AND  A.INCOTERMS		  = B.INCOTERMS
			 AND  A.DOM_EXP			  = B.DOM_EXP
			 AND  A.FCST_TYPE		  = B.FCST_TYPE
			 AND  A.MEASURE			  = B.MEASURE
			 AND  B.YYYYMMDD		  >= @p_now_yyyymmdd
			 AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			;


			--UPDATE A
			--SET   A.PLANT_SITE_ID = B.PLANT_SITE_ID
			--	, A.FROM_SITE_ID  = B.FROM_SITE_ID
			--FROM  #RAW_DATA A WITH(NOLOCK)   
			--INNER JOIN DM_PLN_RTF_ALLOCATION_C B WITH(NOLOCK) 
			--ON 1=1
			-- AND  A.VERSION_NO		= B.VERSION_NO
			-- AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
			-- AND  A.DIVISION_ID		= B.DIVISION_ID
			-- AND  A.PROJECT_CODE	= B.PROJECT_CODE
			-- AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
			-- AND  A.ITEM_ID			= B.ITEM_ID
			-- AND  A.INCOTERMS		= B.INCOTERMS
			-- AND  A.DOM_EXP			= B.DOM_EXP
			-- AND  A.FCST_TYPE		= B.FCST_TYPE
			-- AND  A.MEASURE			= 'RTF_ENERGY'
			-- AND  B.MEASURE			= 'RTF_SCP'
			-- AND  A.YYYYMMDD		= B.YYYYMMDD
			-- AND  A.YYYYMMDD		>= @p_now_yyyymmdd
			-- AND  B.YYYYMMDD		>= @p_now_yyyymmdd
			--;

			
			IF OBJECT_ID (N'tempdb..#temp_RTF_ENERGY_C', N'U') IS NOT NULL   
				DROP TABLE #temp_RTF_ENERGY_C 
			; 

			SELECT *
			INTO #temp_RTF_ENERGY_C
			FROM #RAW_DATA A WITH(NOLOCK)   
			WHERE A.DIVISION_ID = @p_division_id
			AND   A.MEASURE		= 'RTF_ENERGY'
			;

			DELETE #RAW_DATA 
			WHERE DIVISION_ID = @p_division_id
			AND   MEASURE	= 'RTF_ENERGY'
			;

			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C

			INSERT INTO #RAW_DATA (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
								  , PLANT_SITE_ID
								  , ITEM_ID,TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
								  , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)    
			SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			    , B.PLANT_SITE_ID
				, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID
				, A.MEASURE
				, B.YYYYMMDD, A.QTY
				, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM  #temp_RTF_ENERGY_C A WITH(NOLOCK)   
			INNER JOIN DM_PLN_SALES_PLAN_C B WITH(NOLOCK)   
			ON 1=1
			 AND  A.DIVISION_ID		  = B.DIVISION_ID
			 AND  A.VERSION_NO		  = B.VERSION_NO
			 AND  A.CUTOFF_YYYYMMDD	  = B.CUTOFF_YYYYMMDD
			 AND  A.PROJECT_CODE	  = B.PROJECT_CODE
			 AND  A.SCM_SITE_ID		  = B.SCM_SITE_ID
			 AND  A.PLANT_SITE_ID	  = B.PLANT_SITE_ID
			 AND  A.ITEM_ID			  = B.ITEM_ID
			 AND  A.INCOTERMS		  = B.INCOTERMS
			 AND  A.DOM_EXP			  = B.DOM_EXP
			 AND  A.FCST_TYPE		  = B.FCST_TYPE
			 AND  A.YYYYMMDD		  = B.YYYYMMDD
			 AND  A.MEASURE			  = 'RTF_ENERGY'
			 AND  B.MEASURE			  = 'RTF_SYS_RP'
			 AND  B.YYYYMMDD		  >= @p_now_yyyymmdd
			 AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			;

			MERGE INTO #RAW_DATA A
			USING (
					SELECT DISTINCT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					              , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY
								  , ROUND(CASE WHEN B.SUM_QTY  <> 0 THEN A.QTY / B.SUM_QTY ELSE 0 END , 9) AS RATIO -- 2025.01.23 0 나누기 오류 수정
								  --, ROUND(A.QTY/B.SUM_QTY, 9) AS RATIO
								  , A.CELL_PROD_SITE_ID
					FROM #RAW_DATA A WITH(NOLOCK)
					INNER JOIN ( 
									SELECT DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
									FROM #RAW_DATA WITH(NOLOCK)
									WHERE DIVISION_ID = @p_division_id
									AND   MEASURE = 'RTF_SYS_RP'
									AND   YYYYMMDD >= @p_now_yyyymmdd
									GROUP BY  DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID
								) B
					ON 1=1
					AND  A.DIVISION_ID		= B.DIVISION_ID
					AND  A.VERSION_NO		= B.VERSION_NO
					AND  A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD
					AND  A.PROJECT_CODE		= B.PROJECT_CODE
					AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
					AND  A.PLANT_SITE_ID	= B.PLANT_SITE_ID			
					AND  A.ITEM_ID			= B.ITEM_ID
					AND  A.INCOTERMS		= B.INCOTERMS
					AND  A.DOM_EXP			= B.DOM_EXP
					AND  A.FCST_TYPE		= B.FCST_TYPE
					AND  A.YYYYMMDD			= B.YYYYMMDD
					WHERE A.DIVISION_ID       = @p_division_id
					AND   A.MEASURE           = 'RTF_SYS_RP'
					AND   A.YYYYMMDD         >= @p_now_yyyymmdd
					AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			) B
			ON ( 1=1
			AND  A.DIVISION_ID		 = B.DIVISION_ID
			AND  A.VERSION_NO		 = B.VERSION_NO
			AND  A.CUTOFF_YYYYMMDD	 = B.CUTOFF_YYYYMMDD
			AND  A.PROJECT_CODE		 = B.PROJECT_CODE
			AND  A.SCM_SITE_ID		 = B.SCM_SITE_ID
			AND  A.PLANT_SITE_ID	 = B.PLANT_SITE_ID			
			AND  A.ITEM_ID			 = B.ITEM_ID
			AND  A.INCOTERMS		 = B.INCOTERMS
			AND  A.DOM_EXP			 = B.DOM_EXP
			AND  A.FCST_TYPE		 = B.FCST_TYPE
			AND  A.YYYYMMDD			 = B.YYYYMMDD
			AND  A.MEASURE			 = 'RTF_ENERGY'
			AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			)
			WHEN MATCHED THEN
				UPDATE	SET A.QTY	= A.QTY * B.RATIO--(B.QTY / B.SUM_QTY)-- 2025.01.23 0 나누기 오류 수정
			;

		END
	END

  
    SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM  
    INTO #CALENDAR  
    FROM (  
     SELECT SUBSTRING(MAX(BASIS_YYYYMMDD),1,6) + ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW,  ISO_WEEK  
     FROM SCM_SYS_CALENDAR_M  WITH (NOLOCK)
     WHERE BASIS_YYYYMMDD >=  @p_from_yyyymmdd  
     AND   BASIS_YYYYMMDD <=  @p_TO_yyyymmdd   
     GROUP BY  ISO_YYYYWW, ISO_WEEK  
    ) AS A  
    JOIN SCM_SYS_CALENDAR_M AS B  WITH (NOLOCK) 
    ON A.ISO_YYYYWW = B.ISO_YYYYWW  
    AND A.ISO_WEEK = B.ISO_WEEK  


 --SELECT count(*) FROM #RAW_DATA  
 --WHERE PROJECT_CODE = 'G-21-222' AND SCM_SITE_ID = 'Terra-Gen_US_EWA' AND ITEM_ID = 'EEA00334AB'   
 --AND YYYYMMDD LIKE '202110%'  
    
--select * from #T_COLUMN_SETUP  
--[E20240115-000325] SCM_SYS_CALENDER_M WITH (NOLOCK) 처리
  SET @v_sql_text = N'  
   
  SELECT '  
 
  IF @p_cell_yn = 'Y'  
  BEGIN  
   SET @v_sql_text = @v_sql_text + N' DBO.FN_GET_DM_SALES_PLAN_WATERFALL_QTY2(  
   A.MEASURE, ISNULL(D.ITEM_CLASS_NAME,'''')  
   , ISNULL(A.QTY,0)  
   , ISNULL(C.CELL_PER_CAR,0)  
   , ISNULL(C.CELL_PER_MODULE,0)  
   , ''Y''  
   , ISNULL(D.FORECAST_INFO_CELL_PACK_COUNT, 0)  
   , ''' + @P_DIVISION_ID + N''', ISNULL(D.FORECAST_INFO_BIZ_TYPE, '''')  
   ) AS QTY '  
  END  
  
  ----- [E20230619-000151] ss  
  ELSE IF @p_division_id = '82'  
  BEGIN  
   SET @v_sql_text = @v_sql_text + N' CONVERT(float,FORMAT(A.QTY,N''##0.##########'')) AS QTY '  
     
  END  
  ------ [E20230619-000151] ee  
  ELSE  
  BEGIN  
     
   -- SET @v_sql_text = @v_sql_text + N' A.QTY AS QTY ' --이전버전[E20230619-000151]  
    SET @v_sql_text = @v_sql_text + N' A.QTY AS QTY '  --수정후[E20230619-000151]  
  END  
  
  SET @v_sql_text = @v_sql_text + N'  
     
   , CASE WHEN ''' + @P_BUCKET + ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD  
   , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW  
   , M.SORT_ORDER_NO  
   , CAL.END_FLAG  
   , ISNULL(O.SEGMENT3, ''DEFAULT'') AS NOTATION
   , [@SQL_SELECT]  
  into #WF  
  FROM #RAW_DATA A  
  JOIN #SELECT_MEASURE      M WITH(NOLOCK) ON A.MEASURE = M.MEASURE  
  JOIN #CALENDAR        CAL WITH(NOLOCK)  ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD  
  LEFT OUTER JOIN #TEMP_SCM_MST_SITE B WITH(NOLOCK)  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID  
  LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM  C WITH(NOLOCK) ON  A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID  
  LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V_T D WITH(NOLOCK) ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID  
  LEFT OUTER JOIN SCM_MST_PROJECT    G WITH(NOLOCK) ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE  
  LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL	I (NOLOCK) ON A.DIVISION_ID = I.DIVISION_ID	AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL O WITH(NOLOCK) ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1
    
  
   print ''L_1--'' + convert(varchar(30), getdate(), 121)  

    SELECT [@V_COLUMN]  
      , SORT_ORDER_NO  
      , [@V_PV_COL_LIST]      
    FROM ( '  
  IF @p_bucket = 'DAILY'  
  BEGIN  
   SET @v_sql_text = @v_sql_text + N'  
     SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY  
     FROM   #WF F  
     WHERE F.QTY <> 0  
       
     UNION ALL'  
  END   
  
  IF @p_bucket != 'ONLY_WEEKLY'  
  BEGIN  
   SET @v_sql_text = @v_sql_text + N'  
      SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' + F.BASIS_YYYYMM + F.ISO_WEEK AS YYYYMMDD  
        , CASE WHEN F.MEASURE IN ( ''KRW'', ''USD'', ''LOC'')   
           THEN AVG(F.QTY)    
          ELSE SUM(F.QTY)   
         END AS QTY 
      FROM #WF F  WITH(NOLOCK)
      WHERE F.QTY <> 0  
      GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK  
       
      UNION ALL  
      SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' + F.BASIS_YYYYMM AS YYYYMMDD  
        , CASE WHEN F.MEASURE IN ( ''KRW'', ''USD'', ''LOC'')   
           THEN AVG(F.QTY)    
          ELSE SUM(F.QTY)   
         END AS QTY 
      FROM #WF F  WITH(NOLOCK)
      WHERE F.QTY <> 0  
      GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.BASIS_YYYYMM  
       
      ) F  
     PIVOT (  
      SUM(F.QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )  
      ) AS PVT  
     ORDER BY [@v_orderby] 
	option ( order group )  
       ';  
  END   
  ELSE IF @p_bucket = 'ONLY_WEEKLY'  
  BEGIN  
   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)  
   /* [PJ20209642R] Sales Price 는 Sum 대신 Avg로 계산 */ 
   SET @v_sql_text = @v_sql_text + N'  
      SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' + F.BASIS_YYYYMMWW  AS YYYYMMDD  
        , CASE WHEN F.MEASURE IN ( ''KRW'', ''USD'', ''LOC'')   
           THEN AVG(F.QTY)    
          ELSE SUM(F.QTY)   
         END AS QTY   
      FROM #WF F  WITH(NOLOCK)
      WHERE F.QTY <> 0  
      GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.BASIS_YYYYMMWW, F.ISO_WEEK  
      ) F  
     PIVOT (  
      SUM(F.QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )  
      ) AS PVT  
     ORDER BY [@v_orderby] 	 
	option ( order group )  
   ';  
  END  
  
  
print 'L--' + convert(varchar(30), getdate(), 121)  
--------------------------------------------------------------------------------------------------------------
IF (@V_DM_PROGRAM_LOG_FLAG = 'Y')
BEGIN 	
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_DM_SYS_LOG_BATCH @p_program_id, 'SM-T', 0, 'L--', '', @d_event_date, @p_created_by; --[E20240115-000325]
END
--------------------------------------------------------------------------------------------------------------
 
  -- SELECT @v_sql_text;  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_COL_LIST]'    , @v_PV_LIST    );  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_LIST]'  , @v_PV_LIST    );  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_column]'   , @ColList       );  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'  , @OrderList      );  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_SELECT]'  , @V_SQL_SELECT      );  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_GROUPBY]'  , @V_SQL_GROUPBY      );  

  --SELECT @v_sql_text;  
  --select @ColList, @V_SQL_SELECT  

  EXEC SP_EXECUTESQL @v_sql_text;   
  
  SELECT ISO_WEEK, BASIS_DATE   
  FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK) --[E20240115-000325] WITH (NOLOCK) 처리
  WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE(), 112)   
  --select * from #SELECT_MEASURE  
    
  -- xml확인할경우  
  --SELECT CONVERT(TEXT, @v_sql_text)  
  --FOR XML PATH('')--,ROOT('x')   
  
  
  
--SELECT COUNT(*) FROM #RAW_DATA  
--SELECT * FROM #RAW_DATA  
  
  
  
--execute dbo.SP_executesql @NSQL2   
  
print 'Q--' + convert(varchar(30), getdate(), 121)  
--------------------------------------------------------------------------------------------------------------
IF (@V_DM_PROGRAM_LOG_FLAG = 'Y')
BEGIN 	
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_DM_SYS_LOG_BATCH @p_program_id, 'SM-T', 0, 'Q--', '', @d_event_date, @p_created_by; --[E20240115-000325]
END
--------------------------------------------------------------------------------------------------------------  
  
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
 --                       Temp Table 존재 여부 체크 (END)  
 ------------------------------------------------------------------------------------------  
  
  
print 'R--' + convert(varchar(30), getdate(), 121)  
  
END
