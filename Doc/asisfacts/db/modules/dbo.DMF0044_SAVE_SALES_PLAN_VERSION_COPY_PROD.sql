
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : DMF0044_SAVE_SALES_PLAN_VERSION_COPY
 * Description  : MDF REPORT 개발 (DM_PLN_SALES_PLAN_C -> DM_PLN_SALES_PLAN_REPORT_C) VERSION COPY PROCEDURE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/05/22	KHSONG			Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 2019/08/22	JSYOUN			DM_PLN_SALES_PLAN_REPORT_C PK에 CURRENCY 추가로 ISNULL(CURRENCY,'')로 변경 
 * 2019/09/06	JSYOUN			Item이 Dev% 인 경우 제외, 소거매출 로직 추가
 * 2019/09/16	JSYOUN			SCM_SITE_ID 가 없는 데이터 제외
 * 2019/09/17	JSYOUN			마지막 버전의 data_type = '2'인 데이터 copy
 * 2019/10/22	hwi1993			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4
 * 2019/10/22	hwi1993			팀이 없는 데이터 제외처리
 * 2019/11/21	hwi1993			버전 삭제기능, 실적포함복사기능 추가
 * 2020/01/07	hwi1993			버전 복사시 버전번호 채번로직 수정 ( 문자열에러남 )
 * 2020/01/14	hwi1993			Unit Price 생성로직 변경
 * 2020/01/22	HWI1993			SCM_SITE_ID, PROJECT_CODE 를 MAX 값으로 변경
 * 2020/02/07	HWI1993			실적부분에 SalesAmt_USD 메저 로직 추가
 * 2020/02/12	hwi1993			RTF 오류 수정. 1.ItemSingeV 의 BizType참조, 2.@p_Std_Date 부등호 조정 ( SAles Plan Waterfall 과 동일하게 )
 * 2020/02/12	hwi1993			실적 COPY 시 RESULT_C 테이블을 RESULT 테이블로 변경
 * 2020/02/17	hwi1993			Attribute1, 2에 복사/생성구분, 실적기준일 추가, Copy 시 SalesAmt_USD 메저 추가
 * 2020/02/18	hwi1993			복사시 기타매출 추가
 * 2020/03/26	P.C.I			[PJ20200138] 환율 정보 copy
 * 2020/04/03	hwi1993			Copy 시 Loc 메저 빠지는 오류 수정, SCM_Site_Id Max 값으로 처리
 * 2020/04/14	hwi1993			BP 버전 삭제 안되는 오류 수정
 * 2020/04/21	hwi1993			프로시저 정리, 자동차 과제 진행에 따른 테이블 및 로직 변경, SP/BP 통합, CUTOFF/ETC 테이블 분리
 * 2020/04/28	hwi1993			사업부별 메저 추가
 * 2020/04/29	hwi1993			C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
 * 2020/04/29	hwi1993			GDW 연동시 대소문자 구분 문제로 PROJECT_CODE 를 MASTER TABLE 의 코드로 사용함
 * 2020/05/14	hwi1993			계획구간의 COMPANY_ID 수정
 * 2020/05/20	hwi1993			Copy 시 사용하는 환율테이블 변경, Copy 시 플랜구간 로직 변경
 * 2020/05/25	hwi1993			create/copy 시 pjt_code, scm_site_id 가 일관성있게 뭉쳐지도록 변경
 * 2020/05/29	hwi1993			ETC 매출 복사 로직 보완, 기타 외 부서/팀 기타로 통합
 * 2020/06/04	hwi1993			환율테이블 변경(누락분에 적용)
 * 2020/06/12	hwi1993			실적불러오기 처리시 실적의 시작일자 결정로직 변경
 * 2020/06/16	hwi1993			1. 소형 ETC Copy 로직 변경, 2. 자동차 KRW,USD 메저 생성, Salesamt_USD 메저 생성, ETC 매출 복사제외
 * 2020/06/17	hwi1993			SOLDTO_CUST_REPORT 적용
 * 2020/06/19	hwi1993			자동차 메저 추가, 소형 부자재매출 수량 제거
 * 2020/06/26	hwi1993			소형 mkt fcst 메저 실적구간 수정
 * 2020/07/10	P.C.I			[PJ202001380] Exchange Rate Version_No 구분
 * 2020/07/13	hwi1993			자동차 Ford 환산정보(CAR) 예외처리
 * 2020/07/22	P.C.I			[PJ202001380] Exchange Rate Version_No 구분 원복
 * 2020/09/09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/10/15   P.C.I			[C20201014-000098] SP_M추가
 * 2020/10/16   P.C.I			[C20201014-000094] 82 사업부 비물동 구분코드 추가 
 * 2020/11/25   P.C.I			[C20201125-000012] COMPANY_ID 변경(Site -> Sales Site Project Model)
 * 2020/12/08   P.C.I			[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2021/03/15   P.C.I			[C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
 * 2021/03/17	HWI1993			[C20210315-000140] Sales Report 통화 컬럼 Null값으로 표기되는 오류 및 무상건 제외
 * 2021/03/31	kuniid			[C20210315-000347] Sales Report - GDW Transfer data에 VMI 관련 데이터 
 * 2021/07/02	HWI1993			[C20210615-000159] GSCM Sales Report의 BP version 의 실적 불러오기 추가
 * 2021/07/05	hwi1993			[C20210603-000220] GSCM Sales Report의 Sales amount (USD) 실적구간 반영 로직 부분 변경 요청의 건 
 * 2021/07/23	hwi1993			상반기과제 - 소형 마스터 정비
 * 2022/01/15	hwi1993			[C20211025-000405] 추가 요청사항 처리
 * 2022/01/26	hwi1993			[C20211025-000405] SalesReport키캆추가
 * 2022.04.13   hwi1993			GM JV 작업
 * 2022.12.09	HWI1993			선배포[C20221209-000209] COUNTRY KR NAME 컬럼 구분자 동작안함 오류 수정
 * 2023.09.07	jssbae			[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 
 * 2024.05.09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2024.11.19	KJJ				[PJ2024-50611] Sales Report 생성 시 ETC 제외 
 * 2024.11.15	KANG.H.J		[PJ2024-50611] 소형 매출 프로세스 개선		
 */
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
CREATE PROCEDURE [dbo].[DMF0044_SAVE_SALES_PLAN_VERSION_COPY_PROD]
--DECLARE 
	@p_division_id				NVARCHAR(30),
	@p_version_no				NVARCHAR(50),
	@p_version_description		NVARCHAR(MAX),
	@p_created_by				NVARCHAR(150),
	@p_result_date				NVARCHAR(10),		-- 실적기준일
	@p_action_type				NVARCHAR(2),		-- D:삭제, CR: 생성, CP:복사
	@p_mv_plan_yyyymm			NVARCHAR(6),		-- 이동계획 월
	@p_update_yn				NVARCHAR(1)			-- Y일 경우 마스터들을 최신 데이터로 업데이트한다.

AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name			NVARCHAR(150) = 'DMF0044_SAVE_SALES_PLAN_VERSION_COPY';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
	DECLARE @v_description			NVARCHAR(500);
	DECLARE @d_event_date			DATETIME;
    DECLARE @n_delete_count			INTEGER = 0;
    DECLARE @n_merge_count			INTEGER = 0;
	DECLARE @v_version_type			NVARCHAR(50);
	DECLARE @d_Result_Date			NCHAR(8); -- 실적구간을 판단하는 기준일자. @p_action_type 이 CR 일 경우 컷오프시점 기준으로 월요일까지의 일자들을 실적으로 보고, CP일 경우 지정된 날짜를 그대로 받는다.
	DECLARE @v_Ori_Version			NVARCHAR(30)
	DECLARE @v_err_mv_version_no	NVARCHAR(30)	-- 기 존재하는 이동계획버전
	
	-- copy 시 Result 에서 데이터를 불러오면 version 관련 컬럼이 없어서 Report_c 의 정보를 담아놓는 변수
	DECLARE @v_cp_VERSION_NO		NVARCHAR(30)	
	DECLARE @v_cp_CUTOFF_TYPE		NVARCHAR(20)	
	DECLARE @v_cp_CUTOFF_YYYYMMDD	NVARCHAR(8)	
	DECLARE @v_cp_MIN_YYYYMMDD		NVARCHAR(8)	-- Sales Report_C 테이블의 해당 버전의 시작일자. 이 날짜부터 실적을 복사한다.
	DECLARE @V_RESULT_YEAR_CNT		NVARCHAR(1)

	-- ETC 매출의 실적구간 관련 변수
	DECLARE @V_MAX_ETC_RESULT_VERSION_NO	NVARCHAR(30)
	DECLARE @V_ETC_RESULT_MONTH		NVARCHAR(6)
	DECLARE @V_MAX_DATA_SEQ			INT
	
	-- 실적구간의 시작일 지정
	SELECT @V_RESULT_YEAR_CNT = ATTRIBUTE1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
	WHERE LOOKUP_TYPE = 'SALES_REPORT_SETTING' 
		and segment1 = 'Result_Start_Year_Cnt' 
		and segment2 = @p_division_id

	IF ISNUMERIC(@V_RESULT_YEAR_CNT) > 0
	BEGIN
		SELECT @v_cp_MIN_YYYYMMDD = CONVERT(CHAR(4), DATEADD(YEAR, -1 * @V_RESULT_YEAR_CNT, GETDATE()), 112)+ '0101'
	END
		
	-- 버전 유형 확인
	SELECT @v_version_type = VERSION_TYPE
	FROM DM_MDF_VERSION
	WHERE DIVISION_ID = @p_division_id
		AND VERSION_NO = @p_version_no

	IF @v_version_type IS NULL
	BEGIN
		SELECT @v_version_type = VERSION_TYPE
		FROM DM_MST_VERSION
		WHERE DIVISION_ID = @p_division_id
			AND VERSION_NO = @p_version_no
	END
	
	-- [PJ202001380] Future Price Version_No 구분
	/*
	DECLARE @c_ER_version				  NVARCHAR(100);
    DECLARE @plan_start_yyyymmdd          NVARCHAR(08);
    DECLARE @c_cutoff_yyyymmdd			  NVARCHAR(08);

	-------------------------------------------------------------------------------------------------------------------------------------------	
	-- 변수값 셋팅
	-------------------------------------------------------------------------------------------------------------------------------------------	
	
	-- Weekly Cutoff 환율 Version No 조회 (40,81 : 화요일 /82 : SP Version과 동일)
	IF @v_version_type NOT LIKE N'REPORT%' AND @p_division_id IN ('40', '81') AND  substring(@p_version_no, 1, 4) = 'SP_W'
		BEGIN
			SET @c_cutoff_yyyymmdd	 = SUBSTRING(@p_version_no,6,8)
			SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@c_cutoff_yyyymmdd, 'MON')), 112)   -- 월요일
			SELECT @c_ER_version = ISNULL(MAX(VERSION_NO), @p_version_no)
			FROM   DM_MST_VERSION WITH(NOLOCK)
			WHERE  DIVISION_ID  = @p_division_id
			and    yyyymmdd    >= @plan_start_yyyymmdd
			and    yyyymmdd    <= @c_cutoff_yyyymmdd
			and    version_type = 'SP_W'
			and    CREATED_BY   = 'WITHOUT_SP_W'
		END
	
	ELSE

		BEGIN 
			SET @c_ER_version = @p_version_no
		END

	-------------------------------------------------------------------------------------------------------------------------------------------	
	*/

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION;

	---------------------------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	---------------------------------------------------------------------------------------------------------------------------	

		-- Div 에 관계없이 여기에 넣고, 나중에 집계하면서 Div 별 처리한다.
		CREATE TABLE #TEMP_VERSION_COPY (
		  DIVISION_ID			NVARCHAR(30)
		, VERSION_NO			NVARCHAR(30)
		, CUTOFF_TYPE			NVARCHAR(20)
		, CUTOFF_YYYYMMDD		NVARCHAR(8)
		, PROJECT_CODE			NVARCHAR(50)
		, SCM_SITE_ID			NVARCHAR(30)
		, ITEM_ID				NVARCHAR(50)
		, DOM_EXP				NVARCHAR(3)
		, FCST_TYPE				NVARCHAR(10)
		, INCOTERMS				NVARCHAR(10)
		, CURRENCY				NVARCHAR(5)
		, MEASURE				NVARCHAR(20)
		, PLANT_SITE_ID			NVARCHAR(30)
		, YYYYMMDD				NVARCHAR(8)
		, QTY					NUMERIC(30,10)
		, COMPANY_ID			NVARCHAR(30)
		, SOLDTO_CUST_REPORT	NVARCHAR(100)
		, DEPT_ID				NVARCHAR(30)
		, ITEM_USE				NVARCHAR(1)
		, END_CUSTOMER			NVARCHAR(50)
		, CELL_PROD_SITE		NVARCHAR(60)	--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
		)

		CREATE TABLE #TEMP_REPORT (
		  DIVISION_ID			NVARCHAR(30)
		, VERSION_NO			NVARCHAR(30)
		, CUTOFF_TYPE			NVARCHAR(20)
		, CUTOFF_YYYYMMDD		NVARCHAR(8)
		, PROJECT_CODE			NVARCHAR(50)
		, SCM_SITE_ID			NVARCHAR(30)
		, ITEM_ID				NVARCHAR(50)
		, DOM_EXP				NVARCHAR(3)
		, FCST_TYPE				NVARCHAR(10)
		, INCOTERMS				NVARCHAR(10)
		, CURRENCY				NVARCHAR(5)
		, MEASURE				NVARCHAR(20)
		, PLANT_SITE_ID			NVARCHAR(30)
		, YYYYMMDD				NVARCHAR(8)
		, OWNER					NVARCHAR(100)
		, DEPARTMENT_ID			NVARCHAR(10)
		, DEPARTMENT_NAME		NVARCHAR(50)
		, DEPT_ID				NVARCHAR(10)
		, DEPT_NAME				NVARCHAR(50)
		, CUST_REPORT			NVARCHAR(30)
		, END_CUST_REPORT		NVARCHAR(30)
		, PRODUCT_GROUP			NVARCHAR(30)
		, ATTRIBUTE1			NVARCHAR(150)
		, COMPANY_ID			NVARCHAR(30)
		, QTY					NUMERIC(30,10)
		, SOLDTO_CUST_REPORT	NVARCHAR(100)
		, APPLICATION			NVARCHAR(30)
		, CUST_GROUP_DTL		NVARCHAR(30)
		, COUNTRY				NVARCHAR(3)
		, CELL_PROD_SITE		NVARCHAR(60)	--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
		)

		CREATE TABLE #T_MEASURE (
		  PLAN_RESULT	NVARCHAR(50)
		, I_MEASURE		NVARCHAR(30)
		, O_MEASURE		NVARCHAR(30)
		, CALC_YN		NCHAR(1)		-- INPUT MEASURE 와 OUTPUT MEASURE 가 동일하지 않을 경우 'Y' 로 처리
		, QTY_AMT		NCHAR(3)
		, SRC_TABLE		NVARCHAR(50)
		)

	--[E20230906-001160]_DM SINGLE VIEW 수정
	SELECT DISTINCT ITEM_ID,ITEM_CLASS_NAME
			, CASE WHEN ISNUMERIC(ENERGE) > 0 THEN CAST(ENERGE AS NUMERIC(30,10)) ELSE 0 END AS ENERGY
			, CASE WHEN ISNUMERIC(CELL_QUANTITY) > 0 THEN CAST(CELL_QUANTITY AS NUMERIC(30,10)) ELSE 0 END AS CELL_QUANTITY
			, FORECAST_INFO_BIZ_TYPE	-- 소형 BIZ_TYPE ( 부자재 매출 제거에 사용 )
			, FORECAST_INFO_SPEC, NICK_NAME,FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM (
			SELECT	T1.DIVISION_ID, T1.ITEM_ID 
				  , MAX(T1.ITEM_CLASS_NAME)						AS ITEM_CLASS_NAME			--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
				  , MAX(T1.ENERGE)  							AS ENERGE
				  , MAX(T1.CELL_QUANTITY)						AS CELL_QUANTITY				  
				  , MAX(T2.FORECAST_INFO_BIZ_TYPE)				AS FORECAST_INFO_BIZ_TYPE 
				  , MAX(T2.FORECAST_INFO_SPEC)					AS FORECAST_INFO_SPEC
				  , MAX(T1.NICK_NAME)							AS NICK_NAME				--닉네임이 NULL인 경우가 있으므로 하나로 통일
				  , MAX(T2.FORECAST_INFO_CELL_MODEL)			AS FORECAST_INFO_CELL_MODEL
				  , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT)		AS FORECAST_INFO_CELL_PACK_COUNT
			FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
			INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID,12) AS ITEM_ID
							, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
							, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
							, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
							, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						 FROM  SCM_MST_ITEM_SN T2  WITH(NOLOCK) 
				         WHERE  DIVISION_ID =  @p_division_id
						 GROUP BY DIVISION_ID, LEFT(ITEM_ID,12)
					   ) T2 
					ON T1.DIVISION_ID = T2.DIVISION_ID
				   AND LEFT(T1.ITEM_ID,12) = T2.ITEM_ID
			WHERE 1=1
			AND		T1.DIVISION_ID = @p_division_id
			GROUP BY T1.DIVISION_ID, T1.ITEM_ID
			) G


	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-----------------------------------------------------------------------------------------

	CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON #TEMP_DM_MST_ITEM_SINGLE_V
	(
		item_id       ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	;
	------------------------------------------------------------------------------------------
	--                      20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	------------------------------------------------------------------------------------------


	------------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	------------------------------------------------------------------------------------------

	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
		, CASE WHEN ISNUMERIC(CELL_PER_CAR) > 0 THEN CAST(CELL_PER_CAR AS NUMERIC(30,10)) ELSE 0 END AS CELL_PER_CAR
		, CASE WHEN ISNUMERIC(CELL_PER_MODULE) > 0 THEN CAST(CELL_PER_MODULE AS NUMERIC(30,10)) ELSE 0 END AS CELL_PER_MODULE
		--, CURRENCY, LIABILITY_PERIOD
		--, SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID, VALID_YN, BPMS_EXIST, CUST_GROUP, CUST_GROUP_DTL, OWNER, APPLICATION
		--, ROUTE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
		--, ATTRIBUTE9, ATTRIBUTE10, REPORT_GROUP1, REPORT_GROUP2, REPORT_GROUP3, REPORT_GROUP4, REPORT_GROUP5, REPORT_GROUP6
		--, REPORT_GROUP7, REPORT_GROUP8, OS_CORP, CONTRIBUTION_TYPE, EDI_LT, SCP_VMI_LT
		--, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		--, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		--,(	SELECT SU.DEPT_ID  
		--	FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
		--	WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](SMSI.owner, ',')) ) DEPT_ID
	INTO #TEMP_SCM_MST_SITE_ITEM
	FROM SCM_MST_SITE_ITEM SMSI WITH(NOLOCK)
	WHERE SMSI.Division_id = @p_division_id

		-- 실적 기준일 지정
		IF ( @p_action_type = 'CR')
		BEGIN
			SELECT @d_Result_Date = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(YYYYMMDD, 'MON')), 112)
			FROM DM_MST_VERSION
			WHERE DIVISION_ID = @P_DIVISION_ID
				AND VERSION_NO = @P_VERSION_NO
		END
		ELSE IF (@p_action_type = 'CP')
		BEGIN
			-- 화면에서 실적기준일을 안받았을 경우 '' 으로 처리한다.
			SET @d_Result_Date = REPLACE(@p_result_date, '-', '')

			-- 말일자일 경우 해당월, 아니면 직전월
			IF @d_Result_Date <> ''
			BEGIN
				SET @V_ETC_RESULT_MONTH = CASE WHEN @d_Result_Date = CONVERT(CHAR(8), DATEADD(DAY, -1, CONVERT(CHAR(6), DATEADD(MONTH, 1, @d_Result_Date), 112)+N'01'), 112)
												THEN LEFT(@d_Result_Date, 6)
										ELSE
											CONVERT(CHAR(6), DATEADD(MONTH, -1, @d_Result_Date), 112)
										END
			END
		END

		IF ISDATE( ISNULL(@V_ETC_RESULT_MONTH,'') + '01') < 1 
			SET @V_ETC_RESULT_MONTH = CONVERT(CHAR(6), GETDATE(), 112)

		----------------------------------------------------------------------------------------------------- 
		--                                                   Validation (BEGIN)
		-----------------------------------------------------------------------------------------------------
		IF NOT EXISTS ( SELECT 1 FROM SCM_MST_DIVISION WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = @p_division_id ) 
			BEGIN 
				SET @v_log_type = 'DIVISION_INVALID'
				GOTO ERR_RTN
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

		-- 이동계획일 경우 DIV 별로 UNIQUE 한 지 확인
		IF ISDATE(@p_mv_plan_yyyymm + N'01') > 0
			AND EXISTS ( SELECT DIVISION_ID
							FROM DM_MDF_VERSION
							WHERE SEND_YN <> 'D'
								AND MV_PLAN_YYYYMM = @p_mv_plan_yyyymm
								AND DIVISION_ID = @p_division_id
						)
			AND @p_action_type = 'D'
			BEGIN 
				SELECT @v_err_mv_version_no = MAX(VERSION_NO)
				FROM DM_MDF_VERSION
				WHERE SEND_YN <> 'D'
					AND MV_PLAN_YYYYMM = @p_mv_plan_yyyymm
					AND DIVISION_ID = @p_division_id

				IF @v_err_mv_version_no IS NOT NULL
				BEGIN
					SELECT @v_log_type = N'이동계획 중복'
						, @v_description = N'이미 해당월의 이동계획이 있습니다.[' + RTRIM(@v_err_mv_version_no) + N']'
					GOTO ERR_RTN
				END
			END

		-- 1~3 담당 외에는 기타로 묶기 위애서 기타 부서코드를 찾는다.
		DECLARE @v_ETC_DEPARTMENT_ID NVARCHAR(30)
				, @v_ETC_DEPARTMENT_NAME NVARCHAR(100)
		SELECT @V_ETC_DEPARTMENT_ID = SEGMENT1
			, @v_ETC_DEPARTMENT_NAME = SEGMENT2
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'MDF_DEPARTMENT'
			AND A.SEGMENT3 = N'Y'
			AND A.ATTRIBUTE1 = 'Y'

			
		----------------------------------------------------------------------------------------------------- 
		--                                                                                 Validation (END)
		-----------------------------------------------------------------------------------------------------


		----------------------------------------------------------------------------------------------------- 
		--                                                   MDF VERSION MST INSERT (BEGIN)
		-----------------------------------------------------------------------------------------------------
		DECLARE @v_rp_version		NVARCHAR(2);	-- REPORT_VERSION
		DECLARE @V_RPT_SEQ			INT;
		DECLARE @v_version_x		NVARCHAR(50);

		DECLARE @V_VERSION_DATE			NCHAR(8)
				, @V_NEW_VERSION_NO		NVARCHAR(50)
				, @V_ORI_CUTOFF_VERSION	NVARCHAR(50)
				, @V_SP_BP				NCHAR(2)
		SET @V_VERSION_DATE			= CONVERT(CHAR(8), GETDATE(), 112) -- 채번 기준일자

		-- 버전처리
		IF @p_action_type IN ( 'CR')
		BEGIN

			SELECT @V_RPT_SEQ	= ISNULL(MAX(VER_CRE_SEQ),0) + 1
			FROM DM_MDF_VERSION WITH (NOLOCK)
			WHERE DIVISION_ID		= @p_division_id
				AND CONVERT(CHAR(8), CREATION_DATE, 112) = @V_VERSION_DATE

			-- [C20201014-000098] SP_M추가 ( LIKE '%SP_W' -> LIKE '%SP%' )
			SELECT @V_SP_BP		= CASE WHEN VERSION_TYPE LIKE '%SP%' THEN N'SP' ELSE N'BP' END
			FROM DM_MST_VERSION WITH(NOLOCK)
			WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @P_VERSION_NO
							
			-- 최종 버전 셋팅
			SET @V_NEW_VERSION_NO 
				=	CASE WHEN ISDATE(@p_mv_plan_yyyymm + N'01') > 0 THEN N'RP_' ELSE N'R_' END
					+ LEFT(@V_SP_BP, 1) 
					+ N'_' 
					+ @V_VERSION_DATE 
					+ N'_V' 
					+ REPLICATE('0', 3-LEN(@V_RPT_SEQ))+CAST(@V_RPT_SEQ AS NVARCHAR(3))
			
			INSERT INTO DM_MDF_VERSION (
				DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD,VER_CRE_SEQ,ORI_VERSION_NO, ORI_CUTOFF_VERSION_NO, MV_PLAN_YYYYMM
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT @p_division_id, @V_NEW_VERSION_NO AS VERSION_NO,@p_version_description
				, N'REPORT_'+ (CASE WHEN VERSION_TYPE = 'SP_M' THEN 'SP_W' ELSE VERSION_TYPE END) AS VERSION_TYPE -- [C20201014-000098] VERSION_TYPE이 SP_M인 경우 SP_W로 변경
				,'N', YYYYMMDD, @V_RPT_SEQ AS VER_CRE_SEQ, VERSION_NO AS ORI_VERSION_NO, VERSION_NO AS ORI_CUTOFF_VERSION_NO, @p_mv_plan_yyyymm
				,@p_created_by,GETDATE(),@p_created_by,GETDATE(),'CR' AS ATTRIBUTE1,NULL,NULL,NULL,NULL
			FROM DM_MST_VERSION WITH(NOLOCK) WHERE 1=1
				AND DIVISION_ID = @p_division_id 
				AND VERSION_NO  = @p_version_no
		
			--[PJ20200138] 환율 정보 copy
			--
			IF @V_SP_BP = 'SP'
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C (
					DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, @V_NEW_VERSION_NO as VERSION_NO
				     , N'REPORT_' + (CASE WHEN CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
				     , CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, @p_created_by,GETDATE()
					 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_MST_EXCHANGE_RATE_C with(nolock)
				WHERE  DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no
				--AND    VERSION_NO  = @c_ER_version -- [PJ202001380] Exchange Rate Version_No 구분
			END
			ELSE
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
					( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, @V_NEW_VERSION_NO as VERSION_NO
				     , N'REPORT_' +  CUTOFF_TYPE AS CUTOFF_TYPE
					 , CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, @p_created_by,GETDATE()
					 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_BP_EXCHANGE_RATE_C with(nolock)
				WHERE  DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no
				--AND    VERSION_NO  = @c_ER_version -- [PJ202001380] Exchange Rate Version_No 구분
			END
			;
		END
		ELSE IF @p_action_type IN ( 'CP')
		BEGIN

			SELECT @V_RPT_SEQ	= ISNULL(MAX(VER_CRE_SEQ),0) + 1
			FROM DM_MDF_VERSION WITH (NOLOCK)
			WHERE DIVISION_ID		= @p_division_id
				AND CONVERT(CHAR(8), CREATION_DATE, 112) = @V_VERSION_DATE
			
			-- [C20201014-000098] SP_M추가 ( LIKE '%SP_W' -> LIKE '%SP%' )
			SELECT @V_SP_BP		= CASE WHEN VERSION_TYPE LIKE '%SP%' THEN N'SP' ELSE N'BP' END
			FROM DM_MDF_VERSION WITH(NOLOCK)
			WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @P_VERSION_NO
							
			-- 최종 버전 셋팅
			SET @V_NEW_VERSION_NO 
				=	CASE WHEN ISDATE(@p_mv_plan_yyyymm + N'01') > 0 THEN N'RP_' ELSE N'R_' END
					+ LEFT(@V_SP_BP, 1) 
					+ N'_' 
					+ @V_VERSION_DATE 
					+ N'_V' 
					+ REPLICATE('0', 3-LEN(@V_RPT_SEQ))+CAST(@V_RPT_SEQ AS NVARCHAR(3))
					+ N'_C'
			INSERT INTO DM_MDF_VERSION
				(DIVISION_ID,VERSION_NO,VERSION_DESCRIPTION,VERSION_TYPE,SEND_YN,YYYYMMDD,VER_CRE_SEQ,ORI_VERSION_NO,ORI_CUTOFF_VERSION_NO, ETC_RESULT_MONTH, MV_PLAN_YYYYMM
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
			SELECT @p_division_id,@V_NEW_VERSION_NO AS VERSION_NO,@p_version_description, VERSION_TYPE AS VERSION_TYPE, 'N', YYYYMMDD
				  ,@V_RPT_SEQ, @P_VERSION_NO, ORI_CUTOFF_VERSION_NO, @V_ETC_RESULT_MONTH, @p_mv_plan_yyyymm
				  ,@p_created_by,GETDATE(),@p_created_by,GETDATE(),'CP' AS ATTRIBUTE1, @p_result_date AS ATTRIBUTE2, NULL, NULL, NULL
			FROM DM_MDF_VERSION WITH(NOLOCK) WHERE 1=1
				AND DIVISION_ID = @p_division_id 
				AND VERSION_NO  = @P_VERSION_NO								
					
			--[PJ20200138] 환율 정보 copy
			IF @V_SP_BP = 'SP'
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
					( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, @V_NEW_VERSION_NO as VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, @p_created_by,GETDATE()
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_PLN_SALES_REPORT_EXCHANGE_C with(nolock)
				WHERE  DIVISION_ID = @p_division_id
				AND    VERSION_NO  = @p_version_no

			END
			ELSE
			BEGIN
				INSERT INTO DM_PLN_SALES_REPORT_EXCHANGE_C
					( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
				SELECT DIVISION_ID, @V_NEW_VERSION_NO as VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, @p_created_by,GETDATE()
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_PLN_SALES_REPORT_EXCHANGE_C with(nolock)
				WHERE  DIVISION_ID = @p_division_id
				AND    VERSION_NO  = @p_version_no
			END

		END
		ELSE	-- 삭제일 경우 
		BEGIN
			UPDATE DM_MDF_VERSION
			SET SEND_YN = 'D'
			WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no
				
			DELETE 
			FROM DM_PLN_SALES_PLAN_REPORT_C 
			WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no

			DELETE 
			FROM DM_PLN_BP_FCST_REPORT_C 
			WHERE DIVISION_ID = @p_division_id
				AND VERSION_NO = @p_version_no
								
			--[PJ20200138] 환율 정보 Delete
			DELETE FROM DM_PLN_SALES_REPORT_EXCHANGE_C
			WHERE  DIVISION_ID = @p_division_id
			AND    VERSION_NO  = @p_version_no
			;
		END

		INSERT INTO #T_MEASURE ( PLAN_RESULT, I_MEASURE, O_MEASURE, CALC_YN, QTY_AMT, SRC_TABLE )
		SELECT SEGMENT3, SEGMENT4, SEGMENT5
			, CASE WHEN SEGMENT4 <> SEGMENT5 AND ATTRIBUTE2 <> '' THEN N'Y' ELSE N'N' END, ATTRIBUTE2, ATTRIBUTE1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		WHERE LOOKUP_TYPE = 'DM_SALES_REPORT_'+@p_action_type
			AND SEGMENT1 = @P_DIVISION_ID
			AND SEGMENT2 = @V_SP_BP

	--SELECT @P_DIVISION_ID , @P_ACTION_TYPE, @V_SP_BP
		
--SELECT 'X', 0
		----------------------------------------------------------------------------------------------------- 
		--                                                                        요청VERSION COPY (BEGIN)
		-----------------------------------------------------------------------------------------------------

		IF @p_action_type IN ( 'CR', 'CP' )
		BEGIN

			IF @p_action_type = 'CR'
			BEGIN

				-- [C20210315-000347]
				SELECT @v_cp_CUTOFF_TYPE = VERSION_TYPE
					,  @v_cp_CUTOFF_YYYYMMDD = YYYYMMDD
				FROM DM_MDF_VERSION
				WHERE DIVISION_ID = @p_division_id
					AND VERSION_NO = @V_NEW_VERSION_NO

				/* 20190916, SCM_SITE_ID 가 NULL 인 데이터는 제외한다. */
				IF @V_SP_BP = 'SP'
				BEGIN			
					INSERT INTO #TEMP_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
							,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							,CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청							
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , N'REPORT_'+(CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							, ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청							
					FROM DM_PLN_SALES_PLAN_C A WITH(NOLOCK)
					JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'PLAN' AND M.CALC_YN = 'N'
					WHERE	A.VERSION_NO = @p_version_no
						AND A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD >= @d_Result_Date -- 미래구간
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						, B.SALES_COMPANY, B.ATTRIBUTE1
					---------
					UNION ALL
					---------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , N'REPORT_'+(CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , CASE WHEN( ISNULL(A.CURRENCY,'') = '-' ) THEN ''   -- [C20210315-000347] 
														ELSE ISNULL(A.CURRENCY,'') END
														AS CURRENCY

						 , M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY						 
						 , A.COMPANY_ID
						 , B.ATTRIBUTE1
						 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청							
					FROM DM_PLN_SALES_PLAN_RESULT_C A WITH(NOLOCK)
					JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'RESULT' AND M.CALC_YN = 'N' AND M.SRC_TABLE = N'DM_PLN_SALES_PLAN_RESULT_C'
					WHERE	A.VERSION_NO = @p_version_no
						AND A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD < @d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID
						, A.COMPANY_ID, B.ATTRIBUTE1	
					---------
					UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
					---------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , N'REPORT_'+(CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, 'SalesAmt_USD' AS Measure ,A.PLANT_SITE_ID, A.YYYYMMDD
						 , SUM(CASE	WHEN ISNULL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/ISNULL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
						 , A.COMPANY_ID, B.ATTRIBUTE1
						 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					FROM DM_PLN_SALES_PLAN_RESULT_C A WITH(NOLOCK)
					JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
					LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP WITH (NOLOCK)
							 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTRING(A.YYYYMMDD,1,6)+'01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD'  AND FP.VERSION_NO = @V_NEW_VERSION_NO
					WHERE	A.VERSION_NO = @p_version_no
						AND A.MEASURE IN ('SalesAmt_KRW')
						AND A.CURRENCY <> 'USD'
						AND A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD < @d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
					---------
					UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다. ( LOC = USD 인 경우 )
					---------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , N'REPORT_'+(CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, 'SalesAmt_USD' AS Measure ,A.PLANT_SITE_ID, A.YYYYMMDD
						 ,SUM(A.QTY) AS QTY
						, A.COMPANY_ID, B.ATTRIBUTE1
						, ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					FROM DM_PLN_SALES_PLAN_RESULT_C A WITH(NOLOCK)
					JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
					WHERE	A.VERSION_NO = @p_version_no
						AND A.MEASURE IN ('SalesAmt_LOC')
						AND A.CURRENCY = 'USD'
						AND A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD < @d_Result_Date   -- 과거실적구간으로 추출
						AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
					--Start [C20201014-000094] 82 사업부 비물동 구분코드 추가 
					---------
					UNION ALL 
					---------					
					SELECT A.DIVISION_ID, A.VERSION_NO
					        , N'REPORT_'+(CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
							, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, SUM(A.QTY) AS QTY
							, B.SALES_COMPANY AS COMPANY_ID
							, B.ATTRIBUTE1
							, ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					FROM DM_PLN_SALES_PLAN_C A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'PLAN' AND M.CALC_YN = 'N'
					WHERE	A.VERSION_NO  = @p_version_no
						AND A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD   >= @d_Result_Date -- 미래구간
						AND D.COMPANY_ID IS NULL
						AND A.DIVISION_ID = '82'
						AND ISNULL(A.QTY,0) <> 0 
						AND A.FCST_TYPE <> 'ETC'--[PJ2024-50611] Sales Report 생성 시 ETC 제외
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, B.SALES_COMPANY
						, B.ATTRIBUTE1
					---------
					UNION ALL
					---------
					SELECT A.DIVISION_ID, A.VERSION_NO
					     , N'REPORT_'+(CASE WHEN A.CUTOFF_TYPE = 'SP_M' THEN 'SP_W' ELSE A.CUTOFF_TYPE END) AS CUTOFF_TYPE -- [C20201014-000098] CUTOFF_TYPE이 SP_M인 경우 SP_W로 변경
						 , A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
						 , A.COMPANY_ID, B.ATTRIBUTE1
						 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					FROM DM_PLN_SALES_PLAN_RESULT_C A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
					LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
					JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'RESULT' AND M.CALC_YN = 'N' AND M.SRC_TABLE = N'DM_PLN_SALES_PLAN_RESULT_C'
					WHERE	A.VERSION_NO  = @p_version_no
						AND A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD    < @d_Result_Date   -- 과거실적구간으로 추출
						--AND C.LOOKUP_TYPE IS NULL
						AND D.COMPANY_ID IS NULL
						AND A.DIVISION_ID = '82'
						AND ISNULL(A.QTY,0) <> 0 
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID
						, A.COMPANY_ID, B.ATTRIBUTE1					
					--End [C20201014-000094] 82 사업부 비물동 구분코드 추가 

					-- 소형 처리( 무상건 제외 )
					-- [C20210315-000140]
					IF @p_division_id = '40'
					BEGIN
						DELETE A
						FROM #TEMP_VERSION_COPY A
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.FCST_TYPE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND SEGMENT4 = 'FREE'
					END

					-- RTF_SCP 처리
					IF @p_division_id like '81%'
					BEGIN
						INSERT INTO #TEMP_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
								, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							    , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						SELECT A.DIVISION_ID, A.VERSION_NO, N'REPORT_SP_W' as Cutoff_Type, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, SUM(A.QTY) AS QTY
								, E.COMPANY_ID AS COMPANY_ID, B.ATTRIBUTE1
								, ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM DM_PLN_MKT_FCST_RESULT_C A WITH(NOLOCK)
						JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'PLAN' AND M.CALC_YN = 'N' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_RESULT_C'
						WHERE	A.VERSION_NO = 'MF_' + SUBSTRING(@p_version_no,4,15)
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD < @d_Result_Date   -- 과거실적구간으로 추출
							AND A.YYYYMMDD >= @v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, E.COMPANY_ID, B.ATTRIBUTE1
					END
					-- [C20210315-000347] 
					IF @p_division_id = '40'
					BEGIN

						DECLARE @VERSION_NO_VMI		NVARCHAR(50)
						-- SP 버전은 v002 등으로 재생성하더라도 보통 mf_w 는 v001 로 그대로 있으므로 끝자리는 고정한다.
						SET @VERSION_NO_VMI = 'MF_W_' + CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY( CONVERT (DATE, SUBSTRING(@p_version_no,6,8)), 'MON')), 112)  -- 당주 월요일 이후인건만 추출  
												+ '_V001'

						INSERT INTO #TEMP_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
							, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT							
							, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						SELECT A.DIVISION_ID, A.VERSION_NO							
								, @v_cp_CUTOFF_TYPE  , @v_cp_CUTOFF_YYYYMMDD --	, N'REPORT_SP_W' as Cutoff_Type , A.CUTOFF_YYYYMMDD 
								, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, SUM(A.QTY) AS QTY
								,'' AS COMPANY_ID  --, E.COMPANY_ID AS COMPANY_ID
								, B.ATTRIBUTE1
								, ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
						FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
						JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'PLAN' AND M.CALC_YN = 'N' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_C'
						WHERE	A.VERSION_NO = @VERSION_NO_VMI
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD >= @d_Result_Date   -- 미래구간
							AND MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							, E.COMPANY_ID, B.ATTRIBUTE1

						-- MKT FCST 테이블에서 데이터를 가져오면 Currency 및 Company_id 가 없어서 업데이트 해준다.
						-- 여기에서 하고 최종 INSERT 전에 한 번 더 해준다.
						UPDATE A
						SET CURRENCY = B.CURRENCY
						FROM #TEMP_VERSION_COPY A
						JOIN ( SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, LEFT(YYYYMMDD, 6) AS YYYYMM
									, MAX(CURRENCY) AS CURRENCY
								FROM DM_PLN_SALES_PLAN_C A
								WHERE A.VERSION_NO = @p_version_no
									AND A.DIVISION_ID = @p_division_id
									AND A.YYYYMMDD >= @d_Result_Date -- 미래구간
								GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, LEFT(YYYYMMDD, 6)
							) B ON A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID	= B.SCM_SITE_ID
								AND A.ITEM_ID		= B.ITEM_ID
								AND A.DOM_EXP		= B.DOM_EXP
								AND A.FCST_TYPE		= B.FCST_TYPE
								AND A.INCOTERMS		= B.INCOTERMS
								AND LEFT(A.YYYYMMDD,6)	= B.YYYYMM
						WHERE A.MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
							AND ISNULL(A.CURRENCY, '') = ''

						UPDATE A
						SET CURRENCY = B.CURRENCY
						FROM #TEMP_VERSION_COPY A
						JOIN ( SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
									, MAX(CURRENCY) AS CURRENCY
								FROM DM_PLN_SALES_PLAN_C A
								WHERE A.VERSION_NO = @p_version_no
									AND A.DIVISION_ID = @p_division_id
									AND A.YYYYMMDD >= @d_Result_Date -- 미래구간
								GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
							) B ON A.PROJECT_CODE = B.PROJECT_CODE
								AND A.SCM_SITE_ID	= B.SCM_SITE_ID
								AND A.ITEM_ID		= B.ITEM_ID
								AND A.DOM_EXP		= B.DOM_EXP
								AND A.FCST_TYPE		= B.FCST_TYPE
								AND A.INCOTERMS		= B.INCOTERMS
						WHERE A.MEASURE IN ('VMI_In_Plan', 'VMI_In_Req')
							AND ISNULL(A.CURRENCY, '') = ''

						UPDATE A
						SET COMPANY_ID = B.SALES_COMPANY 
						FROM #TEMP_VERSION_COPY A
						JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					END
				END
				ELSE
				BEGIN
					INSERT INTO #TEMP_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
							, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER
							, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					SELECT A.DIVISION_ID, A.VERSION_NO
					    , N'REPORT_'+ A.CUTOFF_TYPE AS CUTOFF_TYPE
						, A.CUTOFF_YYYYMMDD
						, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, '' AS INCOTERMS, A.CURRENCY, A.MEASURE,A.PLANT_SITE_ID
						, A.YYYYMM + N'01', SUM(A.QTY) AS QTY
						, ISNULL(B.SALES_COMPANY,'') AS COMPANY_ID
						, B.ATTRIBUTE1
						, CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID ELSE NULL END AS DEPT_ID
						, ISNULL(A.ITEM_USE,'') AS ITEM_USE, ISNULL(A.END_CUSTOMER,'') AS END_CUSTOMER
						, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					FROM DM_PLN_BP_FCST_C A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
					LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN ( SELECT DISTINCT I_MEASURE FROM #T_MEASURE ) M ON A.MEASURE = M.I_MEASURE
					WHERE A.VERSION_NO = @p_version_no
					--AND MEASURE IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'Business_Plan','CAR_QTY')
					AND A.DIVISION_ID = @p_division_id
					GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						, A.FCST_TYPE, A.CURRENCY, A.MEASURE, A.PLANT_SITE_ID
						, A.YYYYMM, B.ATTRIBUTE1
						--[C20201125-000012] COMPANY_ID 변경(Site -> Sales Site Project Model)
						--, ISNULL(C.COMPANY_ID,'')
						, ISNULL(B.SALES_COMPANY,'')
						, CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID ELSE NULL END
						, ISNULL(A.ITEM_USE,''), ISNULL(A.END_CUSTOMER,''), A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				END
			END
			ELSE IF @p_action_type = 'CP'
			BEGIN				
				SELECT @v_cp_CUTOFF_TYPE = VERSION_TYPE
					,  @v_cp_CUTOFF_YYYYMMDD = YYYYMMDD
				FROM DM_MDF_VERSION
				WHERE VERSION_NO = @p_version_no
				
				SELECT  @v_cp_VERSION_NO		= A.VERSION_NO
						, @v_cp_MIN_YYYYMMDD	= MIN(A.YYYYMMDD)
				FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
				WHERE	A.VERSION_NO = @p_version_no
					and A.Cutoff_type = @v_cp_CUTOFF_TYPE
					and A.Data_type = '1'
				GROUP BY A.VERSION_NO

				-- 실적 불러오기 처리시, 실적의 시작일자를 CUTOFF 일자를 기준으로 룩업에 세팅된 개월수만큼 전으로 가서 가져온다.
				DECLARE @V_MON_CNT INT

				SELECT @V_MON_CNT  = CAST(SEGMENT3 AS INT)
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
				WHERE LOOKUP_TYPE = 'DMF0044_CONFIG'
					AND SEGMENT1 = @P_DIVISION_ID
					AND SEGMENT2 = 'RESULT_START_PERIOD'

				SET @v_cp_MIN_YYYYMMDD = CONVERT(CHAR(8), DATEADD(MONTH, @V_MON_CNT * -1, @v_cp_CUTOFF_YYYYMMDD), 112)
				-------------------------------------------------------------------------------------------------------

				BEGIN
					-- 실적불러오기 선택을 하지 않은 순수한 복사시에만 기존 마스터 그대로 유지가 가능함. 아니면 항상 마스터 최신화 적용됨
					IF ( @P_UPDATE_YN <> 'Y' AND @d_Result_Date = '')
					BEGIN
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
							 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
							 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
							 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
							 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
							 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
							 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
							 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
							 -- 2021.7.23
							 , SOLDTO_CUST_REPORT
							 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
							 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
							 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
							 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
						SELECT A.DATA_TYPE, A.DIVISION_ID, @V_NEW_VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
							 , A.YYYYMMDD, A.CURRENCY, A.QTY, @p_created_by, GETDATE()
							 , @p_created_by, GETDATE(), A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
							 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
							 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
							 , A.SOLDTO_CUST_REPORT
							 , A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
							 , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION
							 , A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE
							 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM   DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'PLAN' AND M.CALC_YN = 'N'
						WHERE A.VERSION_NO = @p_version_no
							AND A.DATA_TYPE = '1'
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD > @d_Result_Date -- 미래구간
					END
					ELSE
					BEGIN
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
							 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
							 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
							 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
							 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
							 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
							 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
							 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
							 -- 2021.7.23
							 , SOLDTO_CUST_REPORT
							 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
							 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
							 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
							 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
						SELECT A.DATA_TYPE, A.DIVISION_ID, @V_NEW_VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , CASE WHEN LK1.SEGMENT1 IS NULL  THEN @v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
							 , CASE WHEN LK1.SEGMENT1 IS NULL  THEN @v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
							 , A.DEPT_ID, LK2.SEGMENT2 AS DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
							 , A.YYYYMMDD, A.CURRENCY, A.QTY, @p_created_by, GETDATE()
							 , @p_created_by, GETDATE()
							 , CASE WHEN ISNULL(B.REPORT_GROUP4,'') <> '' THEN ISNULL(B.REPORT_GROUP4,'') ELSE ISNULL(B.REPORT_GROUP5,'') END
							 , A.ATTRIBUTE2, A.ATTRIBUTE3
							 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
							 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
							 , B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
							 , DBO.FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )                AS OWNER_NAME
							 , B.CUST_GROUP_DTL
							 , CASE WHEN ISNULL(B.REPORT_GROUP4,'') <> '' THEN ISNULL(B.REPORT_GROUP4,'') ELSE ISNULL(B.REPORT_GROUP5,'') END AS PRODUCT_DETAILS
							 , C.FORECAST_INFO_SPEC, C.NICK_NAME
							 , B.REPORT_GROUP6 AS FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE
							 , D.SEGMENT2, B.APPLICATION, B.REPORT_GROUP1 AS APPLICATION_GR, F.COUNTRY_KR_NAME, B.ROUTE
							 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM   DM_PLN_SALES_PLAN_REPORT_C A
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
						LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
						LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
						LEFT OUTER JOIN SCM_MST_COUNTRY F ON E.COUNTRY = F.COUNTRY
						JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'PLAN' AND M.CALC_YN = 'N'
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'
													+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END AND LK1.VALID_YN = 'Y' AND LK1.SEGMENT3 = 'Y'
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
													+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END AND LK2.VALID_YN = 'Y'			
						WHERE A.VERSION_NO = @p_version_no
							AND A.DATA_TYPE = '1'
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD > @d_Result_Date -- 미래구간

					END
					-----------
					--UNION ALL -- 여기부터는 실적구간
					-----------
					BEGIN

						INSERT INTO #TEMP_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
								, DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT 
								, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						SELECT A.DIVISION_ID, @v_cp_VERSION_NO, @v_cp_CUTOFF_TYPE, @v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
						FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'RESULT' AND M.CALC_YN = 'N'
						WHERE	A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD <= @d_Result_Date   -- 과거실적구간으로 추출
							AND ISNULL(@d_Result_Date,'') <> ''
							AND A.YYYYMMDD >= @v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
						---------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
						---------				
						SELECT A.DIVISION_ID, @v_cp_VERSION_NO, @v_cp_CUTOFF_TYPE, @v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(CASE	WHEN ISNULL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/ISNULL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP WITH (NOLOCK)
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTRING(A.YYYYMMDD,1,6)+'01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = @V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_KRW'
							AND A.CURRENCY <> 'USD'
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD <= @d_Result_Date   -- 과거실적구간으로 추출
							AND ISNULL(@d_Result_Date,'') <> ''
							AND A.YYYYMMDD >= @v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
						---------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.	( LOC = USD )
						---------				
						SELECT A.DIVISION_ID, @v_cp_VERSION_NO, @v_cp_CUTOFF_TYPE, @v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(A.QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						WHERE	A.MEASURE = 'SalesAmt_LOC'
							AND A.CURRENCY = 'USD'
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD <= @d_Result_Date   -- 과거실적구간으로 추출
							AND ISNULL(@d_Result_Date,'') <> ''
							AND A.YYYYMMDD >= @v_cp_MIN_YYYYMMDD
							AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1
						--Start [C20201014-000094] 82 사업부 비물동 구분코드 추가 
						---------
						UNION ALL
						---------
						SELECT A.DIVISION_ID, @v_cp_VERSION_NO, @v_cp_CUTOFF_TYPE, @v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, M.O_MEASURE AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'RESULT' AND M.CALC_YN = 'N'
						WHERE	A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD   <= @d_Result_Date   -- 과거실적구간으로 추출
							AND ISNULL(@d_Result_Date,'') <> ''
							AND A.YYYYMMDD   >= @v_cp_MIN_YYYYMMDD
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND ISNULL(A.QTY,0) <> 0 
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''), M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1								
						---------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다.
						---------				
						SELECT A.DIVISION_ID, @v_cp_VERSION_NO, @v_cp_CUTOFF_TYPE, @v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(CASE	WHEN ISNULL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
										ELSE A.QTY/ISNULL(FP.EXCHANGE_PRICE,0)
										END) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP WITH (NOLOCK)
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTRING(A.YYYYMMDD,1,6)+'01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = @V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_KRW'
							AND A.CURRENCY <> 'USD'
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD   <= @d_Result_Date
							AND ISNULL(@d_Result_Date,'') <> ''
							AND A.YYYYMMDD   >= @v_cp_MIN_YYYYMMDD
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND ISNULL(A.QTY,0) <> 0 
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1	
						---------
						UNION ALL -- 실적은 SalesAmt_USD 가 없어서 생성해준다. ( LOC = USD )
						---------				
						SELECT A.DIVISION_ID, @v_cp_VERSION_NO, @v_cp_CUTOFF_TYPE, @v_cp_CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,'') AS CURRENCY, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
							 , SUM(A.QTY) AS QTY
							 , A.COMPANY_ID, B.ATTRIBUTE1
							 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
						FROM DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
						LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
						LEFT OUTER JOIN DM_PLN_SALES_REPORT_EXCHANGE_C FP WITH (NOLOCK)
								 ON A.DIVISION_ID = FP.DIVISION_ID AND SUBSTRING(A.YYYYMMDD,1,6)+'01' = FP.YYYYMMDD AND FP.UNIT_CURRENCY = 'USD' AND FP.VERSION_NO = @V_NEW_VERSION_NO
						WHERE	A.MEASURE = 'SalesAmt_LOC'
							AND A.CURRENCY = 'USD'
							AND A.DIVISION_ID = @p_division_id
							AND A.YYYYMMDD   <= @d_Result_Date
							AND ISNULL(@d_Result_Date,'') <> ''
							AND A.YYYYMMDD   >= @v_cp_MIN_YYYYMMDD
							--AND C.LOOKUP_TYPE IS NULL
							AND D.COMPANY_ID IS NULL
							AND A.DIVISION_ID = '82'
							AND ISNULL(A.QTY,0) <> 0 
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							, A.FCST_TYPE, A.INCOTERMS, ISNULL(A.CURRENCY,''),  A.PLANT_SITE_ID, A.YYYYMMDD, A.COMPANY_ID, B.ATTRIBUTE1				
						--End [C20201014-000094] 82 사업부 비물동 구분코드 추가 

						-- RTF_SCP 처리
						IF @p_division_id like '81%'
						BEGIN
							INSERT INTO #TEMP_VERSION_COPY (DIVISION_ID, VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
									  , DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY, COMPANY_ID, SOLDTO_CUST_REPORT
									  , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
							SELECT A.DIVISION_ID, A.VERSION_NO, N'REPORT_SP_W' as Cutoff_Type, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
								 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, '' AS CURRENCY, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								 , SUM(A.QTY) AS QTY
								 , B.SALES_COMPANY AS COMPANY_ID								
								 , B.ATTRIBUTE1
								 , ' ' AS CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
							FROM DM_PLN_MKT_FCST_RESULT_C A WITH(NOLOCK)
							JOIN SCM_MST_SITE_ITEM B WITH (NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK) ON A.ITEM_ID = C.SEGMENT1 AND A.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' -- 20190906 Sales Plan에서 기타매출 등록한 것 제외
							LEFT OUTER JOIN SCM_MST_COMPANY_SN D WITH (NOLOCK) ON A.SCM_SITE_ID = D.COMPANY_ID
							JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
							JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'PLAN' AND M.CALC_YN = 'N' AND M.SRC_TABLE = 'DM_PLN_MKT_FCST_RESULT_C'
							WHERE	A.VERSION_NO = 'MF_' + SUBSTRING(@p_version_no,4,15)
								AND A.DIVISION_ID = @p_division_id
								AND A.YYYYMMDD < @d_Result_Date   -- 과거실적구간으로 추출
								AND ISNULL(@d_Result_Date,'') <> ''
								AND A.YYYYMMDD >= @v_cp_MIN_YYYYMMDD
								AND C.LOOKUP_TYPE IS NULL
								AND D.COMPANY_ID IS NULL
							GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, B.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
								, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
								, B.SALES_COMPANY
								, B.ATTRIBUTE1
						END
					END

				END

			END

			-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- DIV 별로 키값에 맞춰서 묶어준다. ( YYYYMMDD 때문에 단순 MAX 처리로는 안되고, 키값전체를 이용해서 정리해줘야 한다. )
			-- Scm_site_id 와 Project Code 를 뭉친다.
			-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF @P_DIVISION_ID = '40'
			BEGIN

				-- [PJ2024-50611] 소형 매출 프로세스 개선
				IF (@p_action_type IN ('CR') AND @V_SP_BP = 'SP')		-- sales_plan 신규 생성일 경우만 진행
				BEGIN

					IF OBJECT_ID (N'tempdb..#TEMP_VERSION_COPY_RTF_ALLOCATION', N'U') IS NOT NULL 
						DROP TABLE #TEMP_VERSION_COPY_RTF_ALLOCATION
					;
		
					IF OBJECT_ID (N'tempdb..#TEMP_VERSION_COPY_RTF_ALLOCATION_KEY', N'U') IS NOT NULL 
						DROP TABLE #TEMP_VERSION_COPY_RTF_ALLOCATION_KEY
					;

					SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
						 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					INTO #TEMP_VERSION_COPY_RTF_ALLOCATION
					FROM #TEMP_VERSION_COPY WITH(NOLOCK)
					WHERE DIVISION_ID = @P_DIVISION_ID
					AND   MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
					;

					SELECT   DISTINCT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
							,DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, COMPANY_ID, SOLDTO_CUST_REPORT
							,DEPT_ID,ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					INTO #TEMP_VERSION_COPY_RTF_ALLOCATION_KEY
					FROM #TEMP_VERSION_COPY_RTF_ALLOCATION WITH(NOLOCK)
					;

					DELETE #TEMP_VERSION_COPY
					WHERE DIVISION_ID	= @P_DIVISION_ID
					AND   YYYYMMDD		> @d_Result_Date
					AND   MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
					;

					INSERT INTO #TEMP_VERSION_COPY
					(
						   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, CURRENCY, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
						 , COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, ITEM_USE, END_CUSTOMER, CELL_PROD_SITE
					)
					SELECT A.DIVISION_ID, A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID
							,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.CURRENCY,A.MEASURE
							,B.PLANT_SITE_ID
							,B.YYYYMMDD
							,B.QTY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							,A.DEPT_ID,A.ITEM_USE, A.END_CUSTOMER, B.FROM_SITE_ID AS CELL_PROD_SITE
					FROM #TEMP_VERSION_COPY_RTF_ALLOCATION A WITH(NOLOCK)
					INNER JOIN DM_PLN_RTF_ALLOCATION_C B WITH(NOLOCK)
					ON	A.DIVISION_ID   = B.DIVISION_ID
					AND A.PROJECT_CODE  = B.PROJECT_CODE
					AND A.SCM_SITE_ID   = B.SCM_SITE_ID
					AND A.ITEM_ID       = B.ITEM_ID
					AND A.DOM_EXP       = B.DOM_EXP		
					AND A.FCST_TYPE     = B.FCST_TYPE
					AND A.INCOTERMS     = B.INCOTERMS	
					AND A.MEASURE		= B.MEASURE
					AND A.YYYYMMDD		= B.YYYYMMDD
					WHERE A.DIVISION_ID = @P_DIVISION_ID
					AND   A.YYYYMMDD	> @d_Result_Date
					AND   B.MEASURE IN ('RTF_SYS_RP','VMI_In_Plan','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
					AND   B.VERSION_NO = @p_version_no
					AND   B.CUTOFF_TYPE	= @v_version_type
					;
				END
				
				-- 월별로 하나의 날짜로 변환시킴
				UPDATE #TEMP_VERSION_COPY
				SET YYYYMMDD = LEFT(YYYYMMDD, 6) + '01'

				-- VMI 의 경우 통화가 빠진 데이터가 있어서 여기서 업데이트 해준다.
				UPDATE A
				SET CURRENCY = B.CURRENCY 
				FROM #TEMP_VERSION_COPY A
				JOIN ( SELECT PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, END_CUSTOMER
						FROM #TEMP_VERSION_COPY
						WHERE ISNULL(CURRENCY,'') <> ''
						GROUP BY PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,CURRENCY, COMPANY_ID, SOLDTO_CUST_REPORT, DEPT_ID, END_CUSTOMER
					) B ON		A.PROJECT_CODE			= B.PROJECT_CODE
							AND A.SCM_SITE_ID			= B.SCM_SITE_ID
							AND A.ITEM_ID				= B.ITEM_ID
							AND A.DOM_EXP				= B.DOM_EXP
							AND A.FCST_TYPE				= B.FCST_TYPE
							AND A.INCOTERMS				= B.INCOTERMS
							AND A.COMPANY_ID			= B.COMPANY_ID
							AND ISNULL(A.SOLDTO_CUST_REPORT,'')	= ISNULL(B.SOLDTO_CUST_REPORT,'')
							AND A.DEPT_ID				= B.DEPT_ID
							AND ISNULL(A.END_CUSTOMER,'')		= ISNULL(B.END_CUSTOMER,'')
				WHERE ISNULL(A.CURRENCY, '') = ''

				UPDATE A
				SET CURRENCY = B.CURRENCY 
				FROM #TEMP_VERSION_COPY A
				JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, MAX(CURRENCY) AS CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
						FROM SCM_MST_FUTURE_PRICE A
						WHERE YYYYMMDD > @d_Result_Date
							AND A.DIVISION_ID = @P_DIVISION_ID
						GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					) B ON		A.DIVISION_ID			= B.DIVISION_ID
							AND	A.PROJECT_CODE			= B.PROJECT_CODE
							AND A.SCM_SITE_ID			= B.SCM_SITE_ID
							AND A.ITEM_ID				= B.ITEM_ID
							AND A.DOM_EXP				= B.DOM_EXP
							AND A.FCST_TYPE				= B.FCST_TYPE
							AND A.INCOTERMS				= B.INCOTERMS
				WHERE ISNULL(A.CURRENCY, '') = ''

				INSERT INTO #TEMP_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
						  , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
						  , CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
						  , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
						  , PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, COMPANY_ID, ATTRIBUTE1, SOLDTO_CUST_REPORT
						  , APPLICATION, CUST_GROUP_DTL, COUNTRY
						  , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						, D.UPPER_DEPT_ID AS DEPARTMENT_ID, E.SEGMENT2 AS DEPARTMENT_NAME
						, D.DEPT_ID AS DEPT_ID, F.SEGMENT2 AS DEPT_NAME
						, ISNULL(B.report_group2,'')	AS CUST_REPORT    -- (DMS)판매처
						, ISNULL(B.attribute2,'')	AS END_CUST_REPORT  -- (DMS)고객군
						, ISNULL(B.report_group3,'')	AS PRODUCT_GROUP
						, B.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
						, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY
						--[C20210304-000196] 소형 부자재 및 전극 매출 수량 표기(biz_type is null 제외)
						/*, CASE WHEN V.FORECAST_INFO_BIZ_TYPE IS NULL AND ( A.MEASURE LIKE '%RTF%' OR A.MEASURE LIKE '%MKT_FCST%' ) THEN 0
								ELSE A.QTY END AS QTY*/
						, A.QTY AS QTY
						, ISNULL(A.COMPANY_ID,'') AS COMPANY_ID
						, CASE WHEN ISNULL(B.report_group4,'') <> '' THEN ISNULL(B.report_group4,'') ELSE ISNULL(B.report_group5,'') END	AS ATTRIBUTE1
						, ISNULL(A.SOLDTO_CUST_REPORT, '')
						, B.APPLICATION, B.CUST_GROUP_DTL
						, G.COUNTRY
						, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청			
				FROM #TEMP_VERSION_COPY A
				JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
				JOIN SCM_MST_SSO_USER_INFO C ON LEFT(B.OWNER, CASE WHEN PATINDEX('%,%', B.OWNER) > 0 THEN PATINDEX('%,%', B.OWNER)-1 ELSE LEN(B.OWNER) END) = C.USER_ID
				JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = N'MDF_DEPARTMENT' AND E.VALID_YN = 'Y'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = N'DMF0044_DEPARTMENT_TEAM2' AND F.VALID_YN = 'Y'
				JOIN SCM_MST_SITE G ON B.DIVISION_ID = G.DIVISION_ID AND B.SCM_SITE_ID = G.SCM_SITE_ID
				LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V V ON A.ITEM_ID = V.ITEM_ID
							   
				-- 1~3 담당 외에는 기타로 묶는다.
				UPDATE A
				SET DEPARTMENT_ID = @v_ETC_DEPARTMENT_ID
				FROM #TEMP_REPORT A
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y' AND VALID_YN = 'Y'
				WHERE B.SEGMENT1 IS NULL

--SELECT * FROM #TEMP_REPORT WHERE MEASURE = 'MKT_FCST'					
				-- 인서트
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID				
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1
					-- 2021.7.23
					, SOLDTO_CUST_REPORT
					, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
					, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
					, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
					, ATTRIBUTE3	-- CELL MODEL
					, CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				SELECT A.DATA_TYPE, @P_DIVISION_ID, @V_NEW_VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
					 , A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
					 , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
					 , A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.QTY, A.COMPANY_ID
					 , @p_created_by, GETDATE(), @p_created_by, GETDATE(), A.ATTRIBUTE1
					 , B.ATTRIBUTE1 AS SOLDTO_CUST_REPORT
					 , DBO.FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ) AS OWNER_NAME
					 , A.CUST_GROUP_DTL
					 , CASE WHEN ISNULL(B.REPORT_GROUP4,'') <> '' THEN ISNULL(B.REPORT_GROUP4,'') ELSE ISNULL(B.REPORT_GROUP5,'') END AS PRODUCT_DETAILS
					 , C.FORECAST_INFO_SPEC, C.NICK_NAME
					 , B.REPORT_GROUP6 AS FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE
					 , D.SEGMENT2, A.APPLICATION, B.REPORT_GROUP1 AS APPLICATION_GR, F.COUNTRY_KR_NAME, B.ROUTE
					 , B.ATTRIBUTE5 AS CELL_MODEL
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				FROM (
					SELECT '1' AS DATA_TYPE, @P_DIVISION_ID AS DIVISION_ID, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
							, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.CUST_REPORT
							, A.END_CUST_REPORT, A.PRODUCT_GROUP
							, DBO.FN_SCM_SPLIT(A.MIX_VAL, 1, '^') AS PROJECT_CODE
							, DBO.FN_SCM_SPLIT(A.MIX_VAL, 2, '^') AS SCM_SITE_ID
							, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
							, A.PLANT_SITE_ID, B.YYYYMMDD, A.CURRENCY, SUM(B.QTY) as QTY, A.COMPANY_ID
							, B.ATTRIBUTE1
							, A.APPLICATION, A.CUST_GROUP_DTL
							, A.COUNTRY
							, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					FROM (
						-- 병합처리를 위해 키 중 병합되지 않은 키만 분리 ( 하지만 SCM_SITE_ID-PROJECT_CODE-ITEM_ID 간의 관계는 유지되어야 함 
						--- 그냥 MAX로 조합할 경우 SCM_MST_SITE_ITEM 에 JOIN 이 안됨 )
						SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.CURRENCY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							, MAX(CONCAT(ISNULL(A.PROJECT_CODE,''),'^',ISNULL(A.SCM_SITE_ID,''))) AS MIX_VAL
							, MAX(A.DOM_EXP) AS DOM_EXP
							, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.INCOTERMS) AS INCOTERMS, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
							, A.APPLICATION, A.CUST_GROUP_DTL, A.COUNTRY
						FROM #TEMP_REPORT A
						LEFT OUTER JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
						LEFT OUTER JOIN SCM_MST_COUNTRY C ON B.COUNTRY = C.COUNTRY
						GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.CURRENCY, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							, A.APPLICATION, A.CUST_GROUP_DTL, A.COUNTRY
						) A
					JOIN #TEMP_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
							AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
							AND A.DEPT_ID = B.DEPT_ID
							AND A.DEPT_NAME = B.DEPT_NAME
							AND A.CUST_REPORT = B.CUST_REPORT
							AND A.END_CUST_REPORT = B.END_CUST_REPORT
							AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
							AND A.ITEM_ID = B.ITEM_ID
							AND A.CURRENCY = B.CURRENCY
							AND A.COMPANY_ID = B.COMPANY_ID
							AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
							AND A.APPLICATION = B.APPLICATION
							AND A.CUST_GROUP_DTL = B.CUST_GROUP_DTL
							AND A.COUNTRY = B.COUNTRY
					GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
							, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
							, A.CUST_REPORT, A.END_CUST_REPORT, A.PRODUCT_GROUP
							, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
							, A.PLANT_SITE_ID, B.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, B.ATTRIBUTE1
							, A.APPLICATION, A.CUST_GROUP_DTL
							, A.MIX_VAL, A.COUNTRY, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					) A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY = F.COUNTRY
			END
			ELSE IF @P_DIVISION_ID like '81%'
			BEGIN				
				IF @V_SP_BP = 'SP'
				BEGIN
					-- 자동차는 팀 없는 건은 전송하지 않음.
					INSERT INTO #TEMP_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							  , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							  , PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							  , INCOTERMS, CURRENCY
							  , MEASURE, YYYYMMDD, QTY
							  , DOM_EXP, COMPANY_ID
							  , CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP 
							  , CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						 , D.UPPER_DEPT_ID AS DEPARTMENT_ID, ISNULL(E.SEGMENT2,'') AS DEPARTMENT_NAME
						 , D.DEPT_ID AS DEPT_ID, ISNULL(F.SEGMENT2,'') AS DEPT_NAME
						 , ISNULL(B.PROJECT_CODE,''), ISNULL(A.FCST_TYPE,''), ISNULL(A.PLANT_SITE_ID,''), ISNULL(A.ITEM_ID,''), ISNULL(A.SCM_SITE_ID,'')
						 , ISNULL(A.INCOTERMS,''), ISNULL(A.CURRENCY,'')
						 , A.MEASURE, A.YYYYMMDD, A.QTY
						 , ISNULL(A.DOM_EXP,''), ISNULL(A.COMPANY_ID,'') AS COMPANY_ID
						 , ''	AS CUST_REPORT    -- (DMS)판매처
						 , ''	AS END_CUST_REPORT  -- 
						 , ''	AS PRODUCT_GROUP
						 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					FROM #TEMP_VERSION_COPY A
					JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = N'MDF_DEPARTMENT' + @p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = N'DMF0044_DEPARTMENT_TEAM2' + @p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G ON A.FCST_TYPE = G.SEGMENT1 AND G.LOOKUP_TYPE = N'SALES_TYPE_CODE' AND G.SEGMENT4 <> 'FREE'
				END
				ELSE
				BEGIN
					INSERT INTO #TEMP_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, ISNULL(E.SEGMENT2,'') AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, ISNULL(F.SEGMENT2,'') AS DEPT_NAME
							, ISNULL(A.PROJECT_CODE,''), ISNULL(A.FCST_TYPE,''), ISNULL(A.PLANT_SITE_ID,''), ISNULL(A.ITEM_ID,''), ISNULL(A.SCM_SITE_ID,'')
							, ISNULL(A.INCOTERMS,''), ISNULL(A.CURRENCY,'')
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, ISNULL(A.DOM_EXP,''), ISNULL(A.COMPANY_ID,'') AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, A.END_CUSTOMER	AS END_CUST_REPORT  -- 
							, ''	AS PRODUCT_GROUP
						    , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					FROM #TEMP_VERSION_COPY A
					JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = N'MDF_DEPARTMENT' + @p_division_id
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = N'DMF0044_DEPARTMENT_TEAM2' + @p_division_id
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G ON A.FCST_TYPE = G.SEGMENT1 AND G.LOOKUP_TYPE = N'SALES_TYPE_CODE' AND G.SEGMENT4 <> 'FREE'			
				END		
--select * from #t_measure
--select measure, count(*) from #TEMP_VERSION_COPY group by measure											
--select measure, count(*) from #TEMP_REPORT group by measure

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID				
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE	
					, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				SELECT '1' AS DATA_TYPE, @P_DIVISION_ID, @V_NEW_VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, LEFT(B.YYYYMMDD, 6) + '01' AS YYYYMMDD, A.CURRENCY, SUM(B.QTY) as QTY, A.COMPANY_ID
						,'mdf_batch',GETDATE(),'mdf_batch',GETDATE()
						, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
				FROM (
					-- 병합처리를 위해 키 중 병합되지 않은 키만 분리 
					SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.FCST_TYPE, A.PLANT_SITE_ID, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
						, MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.COMPANY_ID) AS COMPANY_ID
					FROM #TEMP_REPORT A
					GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.FCST_TYPE, A.PLANT_SITE_ID, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
					) A
				JOIN #TEMP_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
						AND A.DEPT_ID = B.DEPT_ID
						AND A.DEPT_NAME = B.DEPT_NAME
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.INCOTERMS = B.INCOTERMS
						AND A.CURRENCY = B.CURRENCY
				GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, LEFT(B.YYYYMMDD,6), A.CURRENCY, A.COMPANY_ID, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		

			END
			ELSE IF @P_DIVISION_ID = '82'
			BEGIN
			
				IF @V_SP_BP = 'SP'
				BEGIN
					INSERT INTO #TEMP_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, ISNULL(E.SEGMENT2,'') AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, ISNULL(F.SEGMENT2,'') AS DEPT_NAME
							, ISNULL(B.PROJECT_CODE,''), ISNULL(A.FCST_TYPE,''), ISNULL(A.PLANT_SITE_ID,''), ISNULL(A.ITEM_ID,''), ISNULL(A.SCM_SITE_ID,'')
							, ISNULL(A.INCOTERMS,''), ISNULL(A.CURRENCY,'')
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, ISNULL(A.DOM_EXP,''), ISNULL(A.COMPANY_ID,'') AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  -- 
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					FROM #TEMP_VERSION_COPY A
					JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = N'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = N'DMF0044_DEPARTMENT_TEAM2_82'
				    ---------
					UNION ALL --[C20201014-000094] 82 사업부 비물동 구분코드 추가
					---------
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					        --[C20201014-000094] 82 사업부 비물동 구분코드 추가 (ISNULL(D.UPPER_DEPT_ID,''),  ISNULL(D.DEPT_ID,''))
							, ISNULL(D.UPPER_DEPT_ID, '') AS DEPARTMENT_ID, ISNULL(E.SEGMENT2,'') AS DEPARTMENT_NAME
							, ISNULL(D.DEPT_ID, '') AS DEPT_ID, ISNULL(F.SEGMENT2,'') AS DEPT_NAME
							, ISNULL(B.PROJECT_CODE,''), ISNULL(A.FCST_TYPE,''), ISNULL(A.PLANT_SITE_ID,''), ISNULL(A.ITEM_ID,''), ISNULL(A.SCM_SITE_ID,'')
							, ISNULL(A.INCOTERMS,''), ISNULL(A.CURRENCY,'')
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, ISNULL(A.DOM_EXP,''), ISNULL(A.COMPANY_ID,'') AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  -- 
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					FROM #TEMP_VERSION_COPY A
					--[C20201014-000094] 82 사업부 비물동 구분코드 추가 (JOIN -> LEFT OUTER JOIN)
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = N'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = N'DMF0044_DEPARTMENT_TEAM2_82'
					--[C20201014-000094] 82 사업부 비물동 구분코드 추가
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G WITH (NOLOCK) ON A.ITEM_ID = G.SEGMENT1 AND A.DIVISION_ID = G.SEGMENT3 AND G.LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID' 
					WHERE A.DIVISION_ID = '82'
				END
				ELSE
				BEGIN
					INSERT INTO #TEMP_REPORT (CUTOFF_TYPE, CUTOFF_YYYYMMDD
							, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
							, PROJECT_CODE, FCST_TYPE, PLANT_SITE_ID, ITEM_ID, SCM_SITE_ID
							, INCOTERMS, CURRENCY
							, MEASURE, YYYYMMDD, QTY
							, DOM_EXP, COMPANY_ID
							, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP
							, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					SELECT A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, D.UPPER_DEPT_ID AS DEPARTMENT_ID, ISNULL(E.SEGMENT2,'') AS DEPARTMENT_NAME
							, D.DEPT_ID AS DEPT_ID, ISNULL(F.SEGMENT2,'') AS DEPT_NAME
							, A.ITEM_USE AS PROJECT_CODE, '' AS FCST_TYPE, '' AS PLANT_SITE_ID, '' AS ITEM_ID, '' AS SCM_SITE_ID
							, '' AS INCOTERMS, ISNULL(A.CURRENCY,'')
							, A.MEASURE, A.YYYYMMDD, A.QTY
							, ISNULL(A.DOM_EXP,''), ISNULL(A.COMPANY_ID,'') AS COMPANY_ID
							, ''	AS CUST_REPORT    -- (DMS)판매처
							, ''	AS END_CUST_REPORT  -- 
							, ''	AS PRODUCT_GROUP
							, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					FROM #TEMP_VERSION_COPY A
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID = D.DEPT_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.UPPER_DEPT_ID = E.SEGMENT1 AND E.LOOKUP_TYPE = N'MDF_DEPARTMENT_82'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL F ON D.DEPT_ID = F.SEGMENT1 AND F.LOOKUP_TYPE = N'DMF0044_DEPARTMENT_TEAM2_82'

				END
						
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C (
					  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
					, CUST_REPORT, END_CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
					, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY, COMPANY_ID				
					, CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					, CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
				SELECT '1' AS DATA_TYPE, @P_DIVISION_ID, @V_NEW_VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, LEFT(B.YYYYMMDD, 6) + '01', A.CURRENCY, SUM(B.QTY) as QTY, A.COMPANY_ID
						,@p_created_by, GETDATE(), @p_created_by, GETDATE()
						, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					-- 병합처리를 위해 키 중 병합되지 않은 키만 분리 
					SELECT A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.INCOTERMS, A.CURRENCY, A.SCM_SITE_ID, A.ITEM_ID
						, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
						, MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.COMPANY_ID) AS COMPANY_ID
					FROM #TEMP_REPORT A
					GROUP BY A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID
						, A.INCOTERMS, A.CURRENCY
					) A
				JOIN #TEMP_REPORT B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						AND A.DEPARTMENT_NAME = B.DEPARTMENT_NAME
						AND A.DEPT_ID = B.DEPT_ID
						AND A.DEPT_NAME = B.DEPT_NAME
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.INCOTERMS = B.INCOTERMS
						AND A.CURRENCY = B.CURRENCY
				GROUP BY B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD
						, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
						, B.CUST_REPORT, B.END_CUST_REPORT, B.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, B.MEASURE
						, A.PLANT_SITE_ID, LEFT(B.YYYYMMDD, 6), A.CURRENCY, A.COMPANY_ID, B.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청


--SELECT @@ROWCOUNT AS ROW_CNT
--SELECT * FROM #TEMP_VERSION_COPY
--SELECT * FROM #TEMP_REPORT

			END		

			----------------------------------------------------------------------------------------------------- 
			--		PRICE 메저 생성
			-----------------------------------------------------------------------------------------------------
PRINT 'B'
				-- LOC 메저는 CP, CR 관계없이 추가한다. ( 실적구간때문에 Loc 메저를 새로 만들어야 하는데, 기존 계획구간에는 Loc 메저가 있을 수도 있어서 복사시에는 Loc 를 복사하지 않고, 여기에서 한꺼번에 새로 만들어준다.
				-- RTF 가 있는 품목들에 대해서 Unit Price ( LOC ) 를 만들어준다. SalesAmt_LOC / Unit Price ( LOCAL )
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
				(  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
				 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
				 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, COMPANY_ID
				 -- 2021.7.23
				 , SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC
				 , NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME
				 , APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, ATTRIBUTE3
				 , CELL_PROD_SITE) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID ,A.VERSION_NO ,A.CUTOFF_TYPE ,A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , MAX(A.DOM_EXP) AS DOM_EXP, MAX(A.FCST_TYPE) AS FCST_TYPE, MAX(A.INCOTERMS) AS INCOTERMS, 'LOC' AS MEASURE, MAX(A.PLANT_SITE_ID) AS PLANT_SITE_ID
					 , A.YYYYMM +'01' AS YYYYMMDD, A.CURRENCY
					 , CASE WHEN SUM(A.Qty) <> 0 THEN ROUND(SUM(B.Qty) / SUM(A.Qty), 3)
							ELSE 0 END AS Qty
					 , @p_created_by, GETDATE(), @p_created_by, GETDATE(), MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
					 , ISNULL(A.COMPANY_ID,'') AS COMPANY_ID
					 -- 2021.7.23
					 , MAX(A.SOLDTO_CUST_REPORT) AS SOLDTO_CUST_REPORT, MAX(A.OWNER_NAME) AS OWNER_NAME, MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL, MAX(A.PRODUCT_DETAILS) AS PRODUCT_DETAILS
					 , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC, MAX(A.NICK_NAME) AS NICK_NAME, MAX(A.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL, MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
					 , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE, MAX(A.COMPANY_NAME) AS COMPANY_NAME, MAX(A.APPLICATION) AS APPLICATION, MAX(A.APPLICATION_GR) AS APPLICATION_GR, A.COUNTRY_KR_NAME
					 , MAX(A.ROUTE) AS ROUTE, MAX(A.ATTRIBUTE3) AS CELL_MODEL
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						 , DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, LEFT(YYYYMMDD, 6) AS YYYYMM, CURRENCY, SUM(QTY) AS QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						 , ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						 , SOLDTO_CUST_REPORT
						 , OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						 , APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'LOC' AND M.QTY_AMT = N'QTY'
					WHERE DIVISION_ID = @P_DIVISION_ID
						--AND MEASURE IN ( 'RTF', 'Business_Plan')
						AND VERSION_NO = @V_NEW_VERSION_NO
					GROUP BY  DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, LEFT(YYYYMMDD, 6), CURRENCY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						) A
				JOIN (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, LEFT(YYYYMMDD, 6) AS YYYYMM, CURRENCY, SUM(QTY) AS QTY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.PLAN_RESULT = N'LOC' AND M.QTY_AMT = N'AMT'
					WHERE DIVISION_ID = @P_DIVISION_ID
						--AND MEASURE = 'SalesAmt_LOC'
						AND VERSION_NO = @V_NEW_VERSION_NO
					GROUP BY DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME
						, DEPT_ID, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, LEFT(YYYYMMDD, 6), CURRENCY
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE
						, SOLDTO_CUST_REPORT
						, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION
						, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
										AND A.YYYYMM = B.YYYYMM AND A.COMPANY_ID = B.COMPANY_ID AND A.CURRENCY = B.CURRENCY AND A.INCOTERMS = B.INCOTERMS
										AND A.COUNTRY_KR_NAME = B.COUNTRY_KR_NAME
										AND A.CELL_PROD_SITE  = B.CELL_PROD_SITE			--[PJ2024-50611] 소형 매출 프로세스 개선
				GROUP BY   A.DATA_TYPE, A.DIVISION_ID,A.VERSION_NO,A.CUTOFF_TYPE,A.CUTOFF_YYYYMMDD,A.DEPARTMENT_ID,A.DEPARTMENT_NAME,A.DEPT_ID,A.DEPT_NAME,A.END_CUST_REPORT,A.CUST_REPORT,A.PRODUCT_GROUP
							,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.MEASURE,A.YYYYMM, A.CURRENCY, ISNULL(A.COMPANY_ID,''), A.COUNTRY_KR_NAME, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		

PRINT 'C'

			-- 자동차 : KRW, USD 메저 생성
			IF ( @P_DIVISION_ID LIKE '81%' )
			BEGIN
					-- KRW
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID 
					 , CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, N'KRW' AS MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , A.QTY * EX.EXCHANGE_PRICE
					 , @p_created_by, GETDATE(), @p_created_by, GETDATE()
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청			
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						 , YYYYMMDD, CURRENCY, QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
						 , CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE DIVISION_ID = @P_DIVISION_ID
						AND MEASURE = 'LOC'
						AND VERSION_NO = @V_NEW_VERSION_NO
						) A
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX ON A.DIVISION_ID = EX.DIVISION_ID AND A.CUTOFF_TYPE = EX.CUTOFF_TYPE 
									AND A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND A.CURRENCY = EX.UNIT_CURRENCY 
									AND A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = @V_NEW_VERSION_NO
			
PRINT 'D'			
					-- USD
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID 
					 , CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					, A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, N'USD' AS MEASURE, A.PLANT_SITE_ID
					, A.YYYYMMDD, A.CURRENCY
					, CASE WHEN ISNULL(EX.EXCHANGE_PRICE, 0) <> 0 THEN ROUND( A.QTY / EX.EXCHANGE_PRICE, 3)
							ELSE 0 END AS QTY
					, @p_created_by, GETDATE(), @p_created_by, GETDATE()
					, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
					, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
				FROM (
					SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						 , YYYYMMDD, CURRENCY, QTY
						 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
						 , CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					WHERE DIVISION_ID = @P_DIVISION_ID
						AND MEASURE = 'KRW'
						AND VERSION_NO = @V_NEW_VERSION_NO
						) A
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX ON A.DIVISION_ID = EX.DIVISION_ID AND A.CUTOFF_TYPE = EX.CUTOFF_TYPE 
									AND A.CUTOFF_YYYYMMDD = EX.CUTOFF_YYYYMMDD AND EX.CURRENCY = 'KRW' AND EX.UNIT_CURRENCY = 'USD'
									AND A.YYYYMMDD = EX.YYYYMMDD AND EX.VERSION_NO = @V_NEW_VERSION_NO


			END

PRINT 'E'
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 사업부별 메저 생성 ( 사업부별로 특성이 있는 메저들은 수량메저들이고, 40은 없음 
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
			IF ( @P_DIVISION_ID LIKE '81%' )	-- RTF_System[R+P]CAR, RTF_System[R+P]CELL
			BEGIN
				IF ( @p_action_type = 'CP' )	-- 복사의 경우 실적구간이 있을 경우 계산되는 메저가 빠지는 구간이 있을 수 있어서 지우고 새로 생성
				BEGIN
					DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
					WHERE DIVISION_ID = @P_DIVISION_ID AND VERSION_NO = @V_NEW_VERSION_NO AND MEASURE IN ( N'RTF_SYS_RP_CAR', N'RTF_SYS_RP_CELL')
				END
				
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					 , CELL_PROD_SITE ) --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , CASE WHEN M.O_MEASURE IN ('RTF_SYS_RP_CAR', 'RTF_CAR') THEN
								CASE WHEN CHARINDEX('Cell', B.ITEM_CLASS_NAME) > 0 AND C.CELL_PER_CAR > 0 THEN A.QTY / C.CELL_PER_CAR
									WHEN  CHARINDEX('Module', B.ITEM_CLASS_NAME) > 0  AND C.CELL_PER_CAR > 0 AND C.CELL_PER_MODULE > 0 THEN A.QTY/ ( C.CELL_PER_CAR/ C.CELL_PER_MODULE )
									WHEN  CHARINDEX('Pack'  , B.ITEM_CLASS_NAME) > 0  THEN A.QTY
									ELSE 0 
								END
							WHEN M.O_MEASURE IN ('RTF_SYS_RP_CELL','RTF_CELL') THEN 
								CASE WHEN CHARINDEX('Cell', B.ITEM_CLASS_NAME) > 0 AND C.CELL_PER_CAR > 0 THEN A.QTY
									WHEN ( CHARINDEX('Module', B.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', B.ITEM_CLASS_NAME) > 0 ) AND C.CELL_PER_MODULE > 0 THEN A.QTY * C.CELL_PER_MODULE
									ELSE 0 
								END
						END AS QTY
					 , @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청		
				FROM   DM_PLN_SALES_PLAN_REPORT_C A (NOLOCK)
				JOIN #TEMP_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN #TEMP_SCM_MST_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
				JOIN SCM_MST_SITE D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID
				JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( N'RTF_SYS_RP_CAR', N'RTF_SYS_RP_CELL',N'RTF_CAR', N'RTF_CELL' ) AND M.PLAN_RESULT = N'PLAN'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON D.END_CUSTOMER = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = N'DM_CAR_QTY_FORD' AND A.ITEM_ID = LK1.SEGMENT3
				WHERE A.DIVISION_ID = @P_DIVISION_ID AND A.VERSION_NO = @V_NEW_VERSION_NO
					AND ( M.O_MEASURE NOT IN ( N'RTF_SYS_RP_CAR', N'RTF_CAR') OR LK1.SEGMENT1 IS NULL ) -- FORD 환산건은 별도 처리
					AND D.END_CUSTOMER = 'FORD'
				-- FORD 환산건 추가
				UNION ALL
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , ROUND(SUM(CAST(C.CELL_PER_MODULE AS INT) * CAST(A.QTY AS NUMERIC(13,1)))/MAX(LK1.SEGMENT4), 0) AS QTY
					 , @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM   DM_PLN_SALES_PLAN_REPORT_C A (NOLOCK)
				JOIN #TEMP_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN #TEMP_SCM_MST_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
				JOIN SCM_MST_SITE D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID
				JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( N'RTF_SYS_RP_CAR', N'RTF_CAR' ) AND M.PLAN_RESULT = N'PLAN'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON D.END_CUSTOMER = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = N'DM_CAR_QTY_FORD' AND A.ITEM_ID = LK1.SEGMENT3
				WHERE A.DIVISION_ID = @P_DIVISION_ID AND A.VERSION_NO = @V_NEW_VERSION_NO
					AND ( M.O_MEASURE IN ( N'RTF_SYS_RP_CAR', N'RTF_CAR') AND LK1.SEGMENT1 IS NOT NULL ) -- FORD 환산건
					AND D.END_CUSTOMER = 'FORD'
				GROUP BY A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, C.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청

			END
			ELSE IF @P_DIVISION_ID = '82'
			BEGIN
				IF ( @p_action_type = 'CP' )	-- 복사의 경우 실적구간이 있을 경우 계산되는 메저가 빠지는 구간이 있을 수 있어서 지우고 새로 생성
				BEGIN
					DELETE FROM DM_PLN_SALES_PLAN_REPORT_C
					WHERE DIVISION_ID = @P_DIVISION_ID AND VERSION_NO = @V_NEW_VERSION_NO AND MEASURE IN ( N'RTF_SYS_RP_CAR', N'RTF_SYS_RP_CELL')
				END

PRINT 'F'
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID 
					 , CELL_PROD_SITE	)--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청	
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, M.O_MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , CASE WHEN M.O_MEASURE IN ('RTF_CELL', 'RTF_SYS_RP_CELL') THEN A.QTY * B.CELL_QUANTITY
							WHEN M.O_MEASURE IN ('RTF_ENG', 'RTF_SYS_RP_ENG')	THEN A.QTY * B.ENERGY/1000	-- ENERGY 컬럼값이 KWh 이므로 1,000 으로 나눠준다.
							END AS QTY
					 , @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM   DM_PLN_SALES_PLAN_REPORT_C A (NOLOCK)
				JOIN #TEMP_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
				JOIN #T_MEASURE M ON A.MEASURE = M.I_MEASURE AND M.O_MEASURE IN ( N'RTF_CELL', N'RTF_ENG','RTF_SYS_RP_CELL', N'RTF_SYS_RP_ENG' ) AND M.PLAN_RESULT = N'PLAN' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
				WHERE A.DIVISION_ID = @P_DIVISION_ID AND A.VERSION_NO = @V_NEW_VERSION_NO
					--and a.item_id = 'EABB00252AA'
					--and a.yyyymmdd = '20191101'
					--and a.scm_site_id = 'Fluence_US_SAN'

				order by measure
PRINT 'G'


			END
			--RAISERROR('TEST', 16, 1)

			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 사업부별 메저 끝
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 기타매출 복사 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			/*
				기타매출 테이블에서 기타매출 테이블로 복사한다.
				COPY 시에는 실적 기준일이 있을 경우에는 해당 기준일을 기준으로 이전월은 실적으로 보고 해당 기간까지는 실적버전을 복사하고, 이 후 기간은 원본버전을 그대로 복사한다.
			              실적 기준일이 없을 경우에는 그냥 복사한다.
				CREATE 시에는 최신 버전을 그대로 복사한다.
			*/
			DECLARE @V_ETC_CUTOFF_TYPE NVARCHAR(20), @V_ETC_CUTOFF_YYYYMMDD NVARCHAR(8)
			
			SELECT TOP 1 
				@V_ETC_CUTOFF_TYPE = CUTOFF_TYPE
				, @V_ETC_CUTOFF_YYYYMMDD = CUTOFF_YYYYMMDD
			FROM DM_PLN_SALES_PLAN_REPORT_C
			WHERE DIVISION_ID = @P_DIVISION_ID
				AND VERSION_NO = @V_NEW_VERSION_NO

--select @V_ETC_CUTOFF_TYPE, @V_ETC_CUTOFF_YYYYMMDD, @V_NEW_VERSION_NO
			IF @p_action_type = 'CR'
			BEGIN

				INSERT INTO DM_PLN_SALES_ETC_REPORT_C (
					VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
					, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
					, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					-- 2021.07.23
					, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
					, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
					, DEPARTMENT_NAME, DEPT_NAME
					 )
				SELECT @V_NEW_VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, @V_ETC_CUTOFF_TYPE, @V_ETC_CUTOFF_YYYYMMDD
					, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
					, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_ID ELSE A.DEPT_ID END AS DEPT_ID
					, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
					, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
					, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY
					, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
					, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
					-- 2021.07.23
					, DBO.FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )                AS OWNER_NAME
					, B.CUST_GROUP_DTL, C.FORECAST_INFO_SPEC
					, ISNULL(LK3.ATTRIBUTE1, C.NICK_NAME ) AS NICK_NAME
					, ISNULL(CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2 ELSE 0 END, C.FORECAST_INFO_CELL_PACK_COUNT ) AS FORECAST_INFO_CELL_PACK_COUNT
					, D.SEGMENT2, F.COUNTRY_KR_NAME, B.ROUTE
					, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
					, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
				FROM DM_PLN_SALES_ETC_REPORT_C A
				LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
				--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
				LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 (NOLOCK) ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL' 
				WHERE A.DIVISION_ID = @P_DIVISION_ID
					AND A.VERSION_NO = ( SELECT TOP 1 A.VERSION_NO
										FROM DM_MDF_VERSION A
										JOIN (
											SELECT MAX(A.CREATION_DATE) AS CREATION_DATE
											FROM DM_MDF_VERSION A
											JOIN DM_PLN_SALES_ETC_REPORT_C B ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO = B.VERSION_NO
											WHERE A.DIVISION_ID = @P_DIVISION_ID
											) B ON A.CREATION_DATE = B.CREATION_DATE
										WHERE A.DIVISION_ID = @P_DIVISION_ID
										ORDER BY A.VERSION_NO DESC
										)
--RAISERROR('SS', 16, 1)
PRINT 'H'

			END
			ELSE IF @p_action_type = 'CP'
			BEGIN
				IF @D_RESULT_DATE = ''	-- 실적기준일이 없는 복사일 경우 그대로 복사
				BEGIN
					INSERT INTO DM_PLN_SALES_ETC_REPORT_C (
						VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
						, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, COMPANY_NAME, COUNTRY_KR_NAME, CUST_GROUP_DTL, DEPARTMENT_NAME, DEPT_NAME
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, NICK_NAME, OWNER_NAME, ROUTE
						  )
					SELECT @V_NEW_VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, @V_ETC_CUTOFF_TYPE, @V_ETC_CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
						, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
						, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY
						, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
						, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						, CASE WHEN @p_update_yn = 'Y' AND ISNULL(D.SEGMENT2,'') <> '' THEN D.SEGMENT2 ELSE A.COMPANY_NAME END AS COMPANY_NAME
						, CASE WHEN @p_update_yn = 'Y' AND ISNULL(F.COUNTRY_KR_NAME, '') <> '' THEN F.COUNTRY_KR_NAME ELSE A.COUNTRY_KR_NAME END AS COUNTRY_KR_NAME
						, CASE WHEN @p_update_yn = 'Y' AND ISNULL(B.CUST_GROUP_DTL, '') <> '' THEN B.CUST_GROUP_DTL ELSE A.CUST_GROUP_DTL END AS CUST_GROUP_DTL
						, CASE WHEN @p_update_yn = 'Y' AND @P_DIVISION_ID = '40' AND ISNULL(LK1.SEGMENT2,'') <> '' THEN LK1.SEGMENT2
								WHEN @p_update_yn = 'Y' AND @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_NAME 
								ELSE A.DEPARTMENT_NAME
								END AS DEPARTMENT_NAME
						, CASE WHEN @p_update_yn = 'Y' AND @P_DIVISION_ID = '40' AND ISNULL(LK2.SEGMENT2, '') <> '' THEN LK2.SEGMENT2
								WHEN @p_update_yn = 'Y' AND @P_DIVISION_ID = '40' AND LK2.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_NAME 
								ELSE A.DEPT_NAME 
								END AS DEPT_NAME
						, CASE WHEN @p_update_yn = 'Y' AND CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2 
																ELSE ISNULL(C.FORECAST_INFO_CELL_PACK_COUNT,0) 
																END <> 0 
											THEN CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2 
																ELSE ISNULL(C.FORECAST_INFO_CELL_PACK_COUNT,0) 
																END
								ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
						, CASE WHEN @p_update_yn = 'Y' AND ISNULL(C.FORECAST_INFO_SPEC,'') <> '' THEN C.FORECAST_INFO_SPEC ELSE A.FORECAST_INFO_SPEC END AS FORECAST_INFO_SPEC
						, CASE WHEN @p_update_yn = 'Y' AND ISNULL(LK3.ATTRIBUTE1, C.NICK_NAME ) IS NOT NULL THEN ISNULL(LK3.ATTRIBUTE1, C.NICK_NAME ) ELSE A.NICK_NAME END AS NICK_NAME
						, CASE WHEN @p_update_yn = 'Y' AND ISNULL(DBO.FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ),'') <> '' THEN DBO.FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' ) ELSE A.OWNER_NAME END AS OWNER_NAME
						, CASE WHEN @p_update_yn = 'Y' AND ISNULL(B.ROUTE, '') <> '' THEN B.ROUTE ELSE A.ROUTE END AS ROUTE
					FROM DM_PLN_SALES_ETC_REPORT_C A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 (NOLOCK) ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL' 
					WHERE A.DIVISION_ID = @P_DIVISION_ID
						AND A.VERSION_NO = @P_VERSION_NO
PRINT 'I'
				END
				ELSE	-- 실적기준일이 있는 복사일 경우 ( 최신화는 UI 에서 강제체크됨 )
				BEGIN

					-- 실적을 복사할 버전을 찾는다.
					SELECT @V_MAX_ETC_RESULT_VERSION_NO = MIN(A.VERSION_NO)
					FROM DM_MDF_VERSION A
					JOIN ( SELECT DIVISION_ID, MIN(ETC_RESULT_MONTH) AS ETC_RESULT_MONTH
							FROM DM_MDF_VERSION 
							WHERE DIVISION_ID = @P_DIVISION_ID
								AND ETC_RESULT_MONTH >= @V_ETC_RESULT_MONTH
								AND VERSION_NO <> @V_NEW_VERSION_NO
								AND VERSION_TYPE LIKE 'REPORT_SP%'
								AND SEND_YN <> 'D'
							GROUP BY DIVISION_ID
						) B ON A.DIVISION_ID = B.DIVISION_ID
							AND A.ETC_RESULT_MONTH = B.ETC_RESULT_MONTH
							AND A.VERSION_NO <> @V_NEW_VERSION_NO
					WHERE A.VERSION_TYPE LIKE 'REPORT_SP%'
						AND A.SEND_YN <> 'D'

					-- LOOKUP 에 복사할 버전이 지정되어있으면 해당 버전을 사용한다.
					IF EXISTS (
						SELECT SEGMENT2
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
						WHERE LOOKUP_TYPE = 'DM_SR_ETC_VERSION'
							AND SEGMENT1 = @P_DIVISION_ID
							AND SEGMENT2 <> ''
							)
					BEGIN

						SELECT @V_MAX_ETC_RESULT_VERSION_NO = SEGMENT2
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
						WHERE LOOKUP_TYPE = 'DM_SR_ETC_VERSION'
							AND SEGMENT1 = @P_DIVISION_ID
							AND SEGMENT2 <> ''

						IF NOT EXISTS (
								SELECT 1 FROM DM_MDF_VERSION NOLOCK
								WHERE DIVISION_ID = @P_DIVISION_ID 
								AND VERSION_NO  = @V_MAX_ETC_RESULT_VERSION_NO
								 )
						BEGIN
							SET @v_log_type = 'INVALID_ETC_VERSION'
							GOTO ERR_RTN
						END

					END


					SELECT @V_MAX_DATA_SEQ = MAX(DATA_SEQ)
					FROM DM_PLN_SALES_ETC_REPORT_C A
					WHERE A.DIVISION_ID = @P_DIVISION_ID
						AND A.VERSION_NO = @V_NEW_VERSION_NO
PRINT 'J'
--SELECT @V_MAX_ETC_RESULT_VERSION_NO, @V_NEW_VERSION_NO, @V_ETC_RESULT_MONTH, @V_MAX_DATA_SEQ

					INSERT INTO DM_PLN_SALES_ETC_REPORT_C (
						VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
						, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						-- 2021.07.23
						, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
						, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
						, DEPARTMENT_NAME, DEPT_NAME
						 )
					SELECT A.VERSION_NO, A.DIVISION_ID, A.DATA_SEQ, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD

						-- 최신화가 아닐 경우 기존 값 복사, 일치하는 부서가 없으면 DEAFULT 기타 부서로 세팅	
						, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_ID ELSE A.DEPARTMENT_ID END AS DEPARTMENT_ID
						, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_ID ELSE A.DEPT_ID END AS DEPT_ID
						, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT
						, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID
						, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
						, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						-- 2021.07.23
						, DBO.FN_GET_DM_MKT_OWNER_NAME (B.OWNER, ',', 'KO' )       AS OWNER_NAME
						, B.CUST_GROUP_DTL, C.FORECAST_INFO_SPEC
						, ISNULL(LK3.ATTRIBUTE1, C.NICK_NAME ) AS NICK_NAME
						, ISNULL(CASE WHEN ISNUMERIC(LK3.ATTRIBUTE2) > 0 THEN LK3.ATTRIBUTE2 ELSE 0 END, C.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
						, D.SEGMENT2, F.COUNTRY_KR_NAME, B.ROUTE
						
						, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS DEPARTMENT_NAME
						, CASE WHEN @P_DIVISION_ID = '40' AND LK1.SEGMENT1 IS NULL THEN @v_ETC_DEPARTMENT_NAME ELSE LK2.SEGMENT2 END AS DEPT_NAME
					FROM (
						SELECT 
							  @V_NEW_VERSION_NO AS VERSION_NO, DIVISION_ID
							, DENSE_RANK() OVER ( 
									ORDER BY DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
									, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME
									, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CURRENCY, COMPANY_ID
									, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
										 ) AS DATA_SEQ
							, @V_ETC_CUTOFF_TYPE AS CUTOFF_TYPE, @V_ETC_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
							, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
							, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY
							, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
							, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
							, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
							, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
							, DEPARTMENT_NAME, DEPT_NAME
						FROM (
							-- 계획구간
							SELECT DIVISION_ID
								, CUTOFF_TYPE, /* CUTOFF_YYYYMMDD ,*/ DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
								, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
								, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
								, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
								, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
								, DEPARTMENT_NAME, DEPT_NAME
							FROM DM_PLN_SALES_ETC_REPORT_C A
							WHERE A.DIVISION_ID = @P_DIVISION_ID
								AND A.VERSION_NO = @P_VERSION_NO
								AND A.YYYYMMDD > @d_Result_Date
							-- 실적구간
							UNION ALL
							SELECT A.DIVISION_ID, CUTOFF_TYPE, /* CUTOFF_YYYYMMDD ,*/ DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
								, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
								, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
								, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
								, OWNER_NAME, CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME
								, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE
								, DEPARTMENT_NAME, DEPT_NAME
							FROM DM_PLN_SALES_ETC_REPORT_C A
							WHERE A.DIVISION_ID = @P_DIVISION_ID
								AND A.VERSION_NO = @V_MAX_ETC_RESULT_VERSION_NO
								AND A.YYYYMMDD <= @d_Result_Date
							) A
						) A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY'
					--LEFT OUTER JOIN SCM_MST_SITE E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID
					LEFT OUTER JOIN SCM_MST_COUNTRY F ON A.COUNTRY_CODE = F.COUNTRY
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 (NOLOCK) ON A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END AND LK1.SEGMENT3 = 'Y'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 (NOLOCK) ON A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'+ CASE WHEN A.DIVISION_ID= '40' THEN '' ELSE '_' + A.DIVISION_ID END
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 (NOLOCK) ON A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL' 

				END
			END


			-- 1~3 담당이 아니면 기타로 처리
			IF @P_DIVISION_ID = '40'
			BEGIN
				UPDATE A
				SET DEPARTMENT_ID	= @v_ETC_DEPARTMENT_ID
					, DEPT_ID		= @v_ETC_DEPARTMENT_ID
				FROM DM_PLN_SALES_ETC_REPORT_C A
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DEPARTMENT_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'MDF_DEPARTMENT' AND B.SEGMENT3 = 'Y'
				WHERE B.SEGMENT1 IS NULL
					AND DIVISION_ID = @P_DIVISION_ID
					AND VERSION_NO = @V_NEW_VERSION_NO
			END

--VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT
--, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, ITEM_ID
--, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
--, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10


			-- 기타매출 복사 끝 ------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 20230907 
PRINT 'K'
			BEGIN
			UPDATE A
			SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT
			  , A.FORECAST_INFO_BIZ_TYPE = LOOKA.BIZ_TYPE
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			INNER JOIN ( 
						SELECT A.MODEL
							 , A.BIZ_TYPE
							 , A.CELL_PACK_COUNT
							 , A.MODEL_RANK 
							 , A.DIVISION_ID
						FROM 
						(
							SELECT SEGMENT2  AS MODEL       
								 , SEGMENT3  AS BIZ_TYPE
								 , SEGMENT4  AS CELL_PACK_COUNT
								 , SEGMENT1  AS DIVISION_ID
								 , RANK () OVER ( 
													PARTITION BY SEGMENT2
													ORDER BY DISPLAY_SEQ DESC
												 ) MODEL_RANK 
							FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
							WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' 
						) A
						WHERE MODEL_RANK = '1'
					  ) LOOKA
					ON LOOKA.MODEL = A.ITEM_ID		
				   AND LOOKA.DIVISION_ID = A.DIVISION_ID
			WHERE A.DIVISION_ID = '40'
			AND A.ITEM_ID = LOOKA.MODEL
			AND A.VERSION_NO = @V_NEW_VERSION_NO
			;

			END


		END


    -- IF @@TRANCOUNT > 0 

-- 트랜잭션 (COMMIT)
    COMMIT WORK;

	---------------------------------------------------------------------------------------------------------------------------	
	END TRY
	---------------------------------------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
	BEGIN CATCH
	--------------------------------------------------------------	

	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION;

		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
			

	--------------------------------------------------------------	
	END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
		IF @v_log_message IS NULL
		SELECT 'success'
		;

	
	--------------------------------------------------------- TEMP TABLE 확인후 초기화
	IF OBJECT_ID (N'tempdb..#TEMP_VERSION_COPY', N'U') IS NOT NULL 
		DROP TABLE #TEMP_VERSION_COPY
		
	IF OBJECT_ID (N'tempdb..#TEMP_REPORT', N'U') IS NOT NULL 
		DROP TABLE #TEMP_REPORT

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V
	
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM

	IF OBJECT_ID (N'tempdb..#T_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #T_MEASURE
	
	--------------------------------------------------------- TEMP TABLE 확인후 초기화


	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
	SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;

	ERR_RTN:
	IF @v_log_type = 'DIVISION_INVALID'
		BEGIN
			ROLLBACK TRANSACTION;
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;
			SELECT N'Division 값이 존재하지 않습니다.'
		END
		
	IF @v_log_type = 'VERSION_NO_INVALID'
		BEGIN
			ROLLBACK TRANSACTION;
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;
			SELECT N'VERSION 값이 존재하지 않습니다.'
		END

	IF @v_log_type = 'INVALID_ETC_VERSION'
		BEGIN
			ROLLBACK TRANSACTION;
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;
			SELECT N'룩업에 설정된 ETC 버전이 잘못되었습니다.'
		END

	IF @v_log_type = N'이동계획 중복'
		BEGIN
			ROLLBACK TRANSACTION;
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;
			SELECT @v_description
		END

	END;



