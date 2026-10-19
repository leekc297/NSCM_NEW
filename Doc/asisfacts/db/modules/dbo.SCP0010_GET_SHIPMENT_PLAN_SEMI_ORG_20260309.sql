
/*
 * Program ID   : SCP0010_GET_SHIPMENT_PLAN_SEMI
 * Description  : Shipment Plan 조회 
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2018/01/29   byunghunjung	          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018-05-16	KYH				          PR 수정 못하도록
 * 2018/05/22	byunghunjung	          order by 순서 변경
 * 2018/05/29	KYH				          fix정보 조회
 * 2018/05/31	KYH				          fix history저장 부분 수정 & 1년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월 sum값 표시
 * 2018/07/03	KYH				          fix정보 관련 날짜 추가
 * 2018/07/02	KYH				          신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
 * 2018/08/13	YHW				          #TblDynamicPivot_SCP0009_02 measure_order_no 데이터 타입 INT로 변경
 * 2018/09/14   ygkim			          속도 개선(함수제거)
 * 2018/10/04   ygkim                     SCP_MST_SHIPMENT_SEMI_DEPT_DAY 조인 추가, Dept_Day 컬럼 추가
 * 2018/11/30	YHW				          SHIP FROZEN 일수 조정
 * 2019/03/08	YHW				          [CSR:]실적구간 조회쿼리 수정
 * 2019/05/15	YHW				          [CSR ID:3992947] 사용자 PC환경에 따른 SHIP FROZEN 구간 미지정 현상 사전조치(Shipment Plan FG, SEMI)
 * 2019/10/21	YHW				          오류수정 - 출하실적 조회 시 "삭제"수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
 * 2020/03/12	YHW				          긴급수정 - Ship Frozen 전일기준->플랜일자 기준으로 변경
 * 2020/07/27	khj79			          [CSR ID :C20200716-000315] GSCM - Shipment plan semi에서 From site 추가 요청의건
 * 2021/07/12	kmj				          PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선
 * 2021/07/22   khj79			          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 중장기 프로젝트(기간82주로 연장)
 * 2021/07/20   khj79			          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022/01/26   khj79			          [PJ20216891] LGES Digital SCM 3 Level 가속화를 위한 개선 - DC LINK 수정(PACK -> PACK) 
 * 2022.05.13   LSC                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2022.05.26   LWY                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : Shiment Plan SEMI 출하실적 개선 (Copy : SHIP_PLAN -> SHIP_PLAN_AMEND)
 * 2022/06/27   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - BOD L/T History 변경 (SCP_MST_BOD_N_V => SCP_ANL_BOD_N_V_PLAN_H)
 * 2022/09/15   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 속도개선 작업
 * 2022-12-05   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS 출하확정구간 변경
 * 2023/04/10   LWY				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023.06.23   KJJ				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Like 검색기능
 * 2023.12.05   KSG                       E20231128-000517 Display the passed performance for Isuzu modue (AMDMO0001A) : 실적 조회 수정
 * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 * 2024-01-19   chaan           V1.1.1    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
 --------------------------------------------------------------------------------------------------------------------------------------
 * ex)
 *   EXEC SCP0010_GET_SHIPMENT_PLAN_SEMI_KYG @p_from_yyyymmdd='20180910', @p_to_yyyymmdd='20190908', @p_division_id='EE', @p_operation_group='E'
                   , @p_item_id='', @p_electype='', @p_plan_start_yyyymmdd='20180910', @p_plan_type='PR', @p_seq='1', @p_fromsite='' ,@p_tosite='', @p_program_id='SCP0010'
				   , @p_sheet_name='ELECTRODE', @p_user_id='addio777', @debug_mode='T'
 */

CREATE PROCEDURE [dbo].[SCP0010_GET_SHIPMENT_PLAN_SEMI_ORG_20260309]
--CREATE PROCEDURE [dbo].[SCP0010_GET_SHIPMENT_PLAN_SEMI]
	@p_from_yyyymmdd		NVARCHAR(MAX),
	@p_to_yyyymmdd			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_operation_group		NVARCHAR(MAX),	
	@p_item_id				NVARCHAR(MAX),
	@p_electype				NVARCHAR(MAX) ,
	@p_plan_start_yyyymmdd  NVARCHAR(8)  ,
	@p_plan_type			NVARCHAR(50) ,
	@p_seq					NVARCHAR(50) ,
	@p_fromsite				NVARCHAR(MAX),
	@p_tosite				NVARCHAR(MAX),
	@p_program_id			NVARCHAR(MAX) = 'SCP0010' ,
	@p_sheet_name			NVARCHAR(MAX),
	@p_user_id				NVARCHAR(MAX),
	@debug_mode				NVARCHAR(MAX) = 'T'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	---- PARAMETER -> 변수 설정
	--DECLARE @p_from_yyyymmdd		NVARCHAR(8)		= N'20240101';
	--DECLARE @p_to_yyyymmdd			NVARCHAR(8)		= N'20241229';
	--DECLARE @p_division_id			NVARCHAR(30)	= N'81';
	--DECLARE @p_operation_group		NVARCHAR(10)	= N'A';
	--DECLARE @p_item_id				NVARCHAR(MAX)	= N'';
	--DECLARE @p_electype				NVARCHAR(MAX)	= N'';
	--DECLARE @p_plan_start_yyyymmdd  NVARCHAR(8)		= N'20240101';
	--DECLARE @p_plan_type			NVARCHAR(50)	= N'PR';
	--DECLARE @p_seq					NVARCHAR(50)	= N'1';
	--DECLARE @p_fromsite				NVARCHAR(MAX)	= N'';
	--DECLARE @p_tosite				NVARCHAR(MAX)	= N'';
	--DECLARE @p_program_id			NVARCHAR(10)	= N'SCP0010';
	--DECLARE @p_sheet_name			NVARCHAR(30)	= N'CELL';
	--DECLARE @p_user_id				NVARCHAR(30)	= N'iamarock';
	--DECLARE @debug_mode				NVARCHAR(10)	= N'F';


	declare @v_data_cnt nvarchar(8);
	set @v_data_cnt =0;
	
	DECLARE @v_cnt_usr_measure	nvarchar =0;

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*) 
								FROM scm_mst_titleset_user WITH(NOLOCK) 
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name 
								 AND user_id     =  @p_user_id
							  )
    DECLARE @v_from_yyyymmdd     AS NVARCHAR(8);
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8);
	DECLARE @v_from_result       AS NVARCHAR(8);
	DECLARE @v_to_result         AS NVARCHAR(8);

	SET @v_from_yyyymmdd = '';
	SET @v_to_yyyymmdd   = '';
	SET @v_from_result   = '';
	SET @v_to_result     = '';
	
	  SELECT @v_from_yyyymmdd = C.BASIS_START_DATE
	  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C  with(nolock)	
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd

	  SELECT @v_from_result = C.BASIS_START_DATE
	  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	 with(nolock)
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd; 

	  SELECT @v_to_result = C.BASIS_START_DATE
	  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	 with(nolock)
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd; 
  
	  IF @v_from_yyyymmdd > @v_from_result
		  BEGIN -- 실적 보여줌
		  SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		  SET @v_to_result     = @v_from_yyyymmdd;
		  END;
	  ELSE IF @v_from_yyyymmdd <= @v_from_result
		  BEGIN -- 실적 없음
		  SET @v_to_yyyymmdd   = @p_to_yyyymmdd;	  
		  SET @v_from_result = CONVERT(CHAR(8), DATEADD(MM, 6, convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_to_result = CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd)), 112)
		  END;
	  ELSE IF @v_from_yyyymmdd > @v_to_result
		  BEGIN
		  SET @v_from_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_from_result = @p_from_yyyymmdd;
		  SET @v_to_result = @p_to_yyyymmdd;
		  END;
	  ELSE IF @v_from_yyyymmdd = @v_to_result
		  BEGIN
		  SET @v_to_yyyymmdd = @v_from_yyyymmdd
		  SET @v_from_result = @p_from_yyyymmdd;
		  SET @v_to_result = @p_to_yyyymmdd;
		  END;

	 IF @debug_mode ='T'
		BEGIN
			PRINT '----------------------------------';
			PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
			PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
			PRINT 'v_from_result =' +@v_from_result;
			PRINT 'v_to_result =' +@v_to_result	;
			PRINT '----------------------------------';
		END;

    DECLARE @arr_item_id varchar(max);
	DECLARE @arr_elec_type varchar(max);

	SELECT @arr_item_id     = ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_elec_type     = ISNULL(@arr_elec_type + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_electype,',')

	DECLARE @mEXEC NVARCHAR(MAX);

	/********************************************************************************
	* 임시테이블만들기 - measure
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_MEASURE') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0010_MEASURE
  

			SELECT
				a.column_name								AS measure
				,a.column_label_name						AS measure_name
				,isnull(b.sort_order_no, a.sort_order_no )	AS user_sort_order_no
			INTO #TblDynamicPivot_SCP0010_MEASURE
			FROM scm_mst_sheet_measure a WITH(NOLOCK) 
			LEFT JOIN  scm_mst_titleset_user b WITH(NOLOCK) ON b.program_id  = a.program_id
										   AND b.sheet_name  = a.sheet_name
										   AND b.column_name = a.column_name
										   AND B.USER_ID = @p_user_id
		    WHERE A.PROGRAM_ID = @p_program_id
			AND A.SHEET_NAME = @p_sheet_name
			AND A.VALID_YN = 'Y'
			AND ( @v_cnt_usr_measure = 0
					OR EXISTS (SELECT 1
							    FROM scm_mst_titleset_user WITH(NOLOCK)
								WHERE program_id	= @p_program_id
								AND sheet_name		= @p_sheet_name
								AND user_id			= @p_user_id
								AND column_name		= a.column_name)
				  )

	  
   /********************************************************************************
	* 임시테이블만들기 - 기준정보 생성, 0 포함
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_STD') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0010_STD

		CREATE TABLE #TblDynamicPivot_SCP0010_STD (
		  DIVISION_ID				NVARCHAR(30)
		  , PLAN_START_YYYYMMDD		NVARCHAR(8)
		  ,	PLAN_TYPE				NVARCHAR(50)
		  , SEQ						NVARCHAR(128)
		  , OPERATION_GROUP			NVARCHAR(10)
		  , ITEM_ID					NVARCHAR(50)
		  , FROM_SITE				NVARCHAR(30)
		  , BOD_ID					NVARCHAR(150)
		  , MEASURE					NVARCHAR(50)
		  , TO_SITE					NVARCHAR(30)
		  , ORIGIN_FROM_DIVISION_ID	NVARCHAR(30)
		  , ORIGIN_TO_DIVISION_ID	NVARCHAR(30)
		  , ELECTRODE_TYPE			NVARCHAR(30)
		  , MEASURE_LABEL			NVARCHAR(50)
		  , MEASURE_ORDER_NO		INT
		  , TRANSPORT_MODE			NVARCHAR(50)
		  , LT_DAY					NVARCHAR(10)
		)		

		INSERT #TblDynamicPivot_SCP0010_STD	

		SELECT
				A.DIVISION_ID
				, A.PLAN_START_YYYYMMDD
				, A.PLAN_TYPE
				, A.SEQ
				, A.OPERATION_GROUP
				, A.ITEM_ID
				, A.FROM_SITE
				, A.BOD_ID
				, A.MEASURE
				, A.TO_SITE
				, A.ORIGIN_FROM_DIVISION_ID
				, ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID, ''), '-') AS ORIGIN_TO_DIVISION_ID
				, ISNULL(NULLIF(A.ELECTRODE_TYPE, ''), '-') AS ELECTRODE_TYPE
				, ME.MEASURE_NAME AS MEASURE_LABEL
				, ME.USER_SORT_ORDER_NO AS MEASURE_ORDER_NO
				, ISNULL(NULLIF(C.TRANSPORT_MODE, ''), '-') AS TRANSPORT_MODE
				, C.LT_TOTAL AS LT_DAY
		FROM (
			SELECT DISTINCT
				A.DIVISION_ID
				, A.PLAN_START_YYYYMMDD
				, A.PLAN_TYPE
				, A.SEQ
				, A.OPERATION_GROUP
				, A.ITEM_ID
				, A.FROM_SITE
				, A.BOD_ID
				, A.MEASURE
				, A.TO_SITE
				, A.ORIGIN_FROM_DIVISION_ID
				, A.ORIGIN_TO_DIVISION_ID
				, A.ELECTRODE_TYPE
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
			WHERE A.DIVISION_ID			= @p_division_id
			AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
			AND A.PLAN_TYPE				= @p_plan_type
			AND A.SEQ					= @p_seq
			AND A.OPERATION_GROUP		= @p_operation_group
			AND (( @p_item_id	IS NULL OR @p_item_id	= '')	OR A.ITEM_ID		IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))
			AND (( @p_fromsite	IS NULL OR @p_fromsite = '')	OR A.FROM_SITE		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_fromsite, ',')))
			--AND A.YYYYMMDD				= @p_plan_start_yyyymmdd
			AND A.YYYYMMDD				>= @p_from_yyyymmdd
			AND A.YYYYMMDD				<= @p_to_yyyymmdd
			AND (( @p_tosite	IS NULL OR @p_tosite = '')		OR A.TO_SITE		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_tosite, ',')))
			AND (( @p_electype	IS NULL OR @p_electype = '')	OR A.ELECTRODE_TYPE IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_electype, ',')))
			GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, FROM_SITE, BOD_ID, MEASURE
				, TO_SITE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE
		) A 
		INNER MERGE JOIN #TblDynamicPivot_SCP0010_MEASURE ME 
			ON A.MEASURE = ME.MEASURE
		-- BOD 2단계 : SCP_MST_BOD_V -> SCP_MST_BOD_N_V
/*		LEFT JOIN SCP_MST_BOD_N_V C WITH(NOLOCK)
			ON (CASE @p_division_id WHEN 'EE' THEN A.ORIGIN_FROM_DIVISION_ID WHEN 'EE_UC' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END) = C.DIVISION_ID
			AND A.BOD_ID = C.BOD_ID
			AND A.FROM_SITE = C.FROM_SITE
		LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)--SCP_MST_BOD_N_V C WITH(NOLOCK)
			 ON A.DIVISION_ID  = C.DIVISION_ID
			AND A.BOD_ID    = C.BOD_ID
			AND A.FROM_SITE = C.FROM_SITE
			AND C.PLAN_SEQ  = @p_seq
			AND C.PLAN_TYPE = @p_plan_type
			AND C.PLAN_NAME = @p_plan_start_yyyymmdd*/
		LEFT JOIN (SELECT *
					FROM SCP_ANL_BOD_N_V_PLAN_H WITH(NOLOCK)--SCP_MST_BOD_N_V C WITH(NOLOCK)
					WHERE 1=1
					AND PLAN_SEQ = @p_seq
					AND PLAN_TYPE = @p_plan_type
					AND PLAN_NAME = @p_plan_start_yyyymmdd 
					AND (( @p_fromsite	IS NULL OR @p_fromsite	= '') OR FROM_SITE = @p_fromsite)
					) C
			 ON A.DIVISION_ID  = C.DIVISION_ID
			AND A.BOD_ID    = C.BOD_ID
			AND A.FROM_SITE = C.FROM_SITE			
		;

	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------	
	IF( @debug_mode ='T')
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mEXEC);
		WHILE @POS <= @LEN
		BEGIN
			PRINT SUBSTRING(@mEXEC,@POS,4000);
			SET @POS = @POS+4000;
		END;
	END;
	-----------------------------------------------------------


   /********************************************************************************
	* 임시테이블만들기 - 계획 생성, 0 제외
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_VALUE_1') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0010_VALUE_1

		SELECT
			X.DIVISION_ID
			, X.ITEM_ID
			, X.ELECTRODE_TYPE
			, X.ORIGIN_FROM_DIVISION_ID
			, X.FROM_SITE
			, X.TRANSPORT_MODE
			, X.BOD_ID		-- BOD 2단계 개발
			, X.MEASURE
			, X.ORIGIN_TO_DIVISION_ID
			, X.TO_SITE
			, F.YYYYMMDD
			, F.QTY
		INTO #TblDynamicPivot_SCP0010_VALUE_1
		FROM #TblDynamicPivot_SCP0010_STD X
		JOIN SCP_ANL_SHIPMENT_PLAN_SEMI F WITH(NOLOCK)
			ON X.DIVISION_ID = F.DIVISION_ID
			AND X.PLAN_START_YYYYMMDD = F.PLAN_START_YYYYMMDD
			AND X.PLAN_TYPE =F.PLAN_TYPE
			AND X.SEQ = F.SEQ
			AND X.OPERATION_GROUP = F.OPERATION_GROUP
			AND X.ITEM_ID = F.ITEM_ID
			AND X.FROM_SITE = F.FROM_SITE
			AND X.BOD_ID = F.BOD_ID
			AND X.MEASURE = F.MEASURE
		WHERE F.QTY					<> 0
		AND F.YYYYMMDD				>= @p_from_yyyymmdd
		AND F.YYYYMMDD				<= @p_to_yyyymmdd



	/********************************************************************************
	* 임시테이블만들기 - 실적 생성, 0 제외
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_VALUE_2') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0010_VALUE_2

		SELECT
			X.DIVISION_ID
			, X.ITEM_ID
			, X.ELECTRODE_TYPE
			, X.ORIGIN_FROM_DIVISION_ID
			, X.FROM_SITE
			, X.TRANSPORT_MODE
			, X.MEASURE
			, ISNULL(C.BOD_ID,'-')	AS BOD_ID	-- BOD 2단계
			, X.ORIGIN_TO_DIVISION_ID
			, X.TO_SITE
			, R.EXFACTORY_DATE AS YYYYMMDD
			, SUM(R.EXFACTORY_QTY) AS QTY
		INTO #TblDynamicPivot_SCP0010_VALUE_2
		FROM (	SELECT DISTINCT
					   DIVISION_ID
					 , ITEM_ID
					 , ELECTRODE_TYPE
					 , ORIGIN_FROM_DIVISION_ID
					 , FROM_SITE
					 , TRANSPORT_MODE
					 , MEASURE
					 , ORIGIN_TO_DIVISION_ID
					 , TO_SITE
				  FROM #TblDynamicPivot_SCP0010_STD
				)X  
		JOIN SCM_DNM_EXFACTORY_RESULT R WITH(NOLOCK)
		  --ON (CASE WHEN @p_division_id IN ('EE','EE_UC') THEN 'Y' ELSE 'N' END = 'Y' OR X.DIVISION_ID = R.DIVISION_ID)
		  ON (CASE WHEN @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) THEN 'Y' ELSE 'N' END = 'Y' OR X.DIVISION_ID = R.DIVISION_ID) --div_commonization
		 AND X.ITEM_ID			= R.ITEM_ID
		 AND X.FROM_SITE		= R.FROM_SCM_SITE_ID
		 AND X.TO_SITE			= R.TO_SCM_SITE_ID
		 AND X.TRANSPORT_MODE	= R.TRANSPORT_MODE
		 AND X.MEASURE			= 'SHIP_PLAN'
		-- BOD 2단계
		JOIN (SELECT *
					FROM SCP_ANL_BOD_N_V_PLAN_H WITH(NOLOCK)--SCP_MST_BOD_N_V C WITH(NOLOCK)
					WHERE 1=1
					AND PLAN_SEQ = @p_seq
					AND PLAN_TYPE = @p_plan_type
					AND PLAN_NAME = @p_plan_start_yyyymmdd 
					AND (( @p_fromsite	IS NULL OR @p_fromsite	= '') OR FROM_SITE = @p_fromsite)
					) C 
		  ON X.DIVISION_ID		= C.DIVISION_ID
		 AND R.FROM_SCM_SITE_ID	= C.FROM_SITE
		 AND R.TO_SCM_SITE_ID	= C.TO_SITE
		 --AND R.INCOTERMS		= C.INCOTERMS -- 20231205 E20231128-000517 조건 삭제 : Semi BOD 는 전부 DAP 이므로 실적과 다르기 때문임
		 AND R.TRANSPORT_MODE	= C.TRANSPORT_MODE
		 AND R.EXFACTORY_DATE	>= C.FROM_YYYYMMDD
		 AND R.EXFACTORY_DATE	<= C.TO_YYYYMMDD
		 
        -- 20231205 E20231128-000517 실적 조회 수정 : SSP 가이드
        JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
        ON  L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만
        AND L.VALID_YN = 'Y'
        AND L.SEGMENT1    = R.SSP_TYPE
		 
		WHERE R.EXFACTORY_QTY			> 0
		AND R.EXFACTORY_DATE			>= @v_from_result
		AND R.EXFACTORY_DATE			<  @v_to_result
		AND ISNULL(R.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- R.EXFACTORY_STATUS IN ('D20', 'D30', 'D40') -- 20231205 E20231128-000517 조건 변경
		GROUP BY X.DIVISION_ID, X.ITEM_ID, X.ELECTRODE_TYPE, X.ORIGIN_FROM_DIVISION_ID, X.FROM_SITE, X.TRANSPORT_MODE, X.MEASURE
			, X.ORIGIN_TO_DIVISION_ID, X.TO_SITE, R.EXFACTORY_DATE, C.BOD_ID  -- BOD 2단계 개발
		;
		
		-------------------------------------------------
		-- 2022.05.26
		-- SHIP_PLAN -> SHIP_PLAN_AMEND Copy...
		-------------------------------------------------
		INSERT INTO #TblDynamicPivot_SCP0010_VALUE_2
		SELECT    X.DIVISION_ID
				, X.ITEM_ID
				, X.ELECTRODE_TYPE
				, X.ORIGIN_FROM_DIVISION_ID
				, X.FROM_SITE
				, X.TRANSPORT_MODE
				, 'SHIP_PLAN_AMEND' AS MEASURE --X.MEASURE
				, X.BOD_ID
				, X.ORIGIN_TO_DIVISION_ID
				, X.TO_SITE
				, X.YYYYMMDD
				, X.QTY
		  FROM #TblDynamicPivot_SCP0010_VALUE_2 X
		 WHERE 1 = 1
		   AND MEASURE = 'SHIP_PLAN'
		;

	/********************************************************************************
	* 임시테이블만들기 - 계획 + 실적
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_DATA') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0010_DATA

		CREATE TABLE #TblDynamicPivot_SCP0010_DATA
		(
		    DIVISION_ID					NVARCHAR(30)
		  , ITEM_ID						NVARCHAR(50)
		  , ELECTRODE_TYPE				NVARCHAR(50)
		  , ORIGIN_FROM_DIVISION_ID		NVARCHAR(30)
		  , FROM_SITE					NVARCHAR(30)
		  , TRANSPORT_MODE				NVARCHAR(30)
		  , BOD_ID						NVARCHAR(30) -- BOD 2단계 개발
		  , MEASURE						NVARCHAR(30)
		  , ORIGIN_TO_DIVISION_ID		NVARCHAR(30)
		  , TO_SITE						NVARCHAR(30)
		  , YYYYMMDD					NVARCHAR(8)
		  , QTY							NUMERIC(20,10)
		)

		INSERT INTO #TblDynamicPivot_SCP0010_DATA
		(
			  DIVISION_ID
			, ITEM_ID
			, ELECTRODE_TYPE
			, ORIGIN_FROM_DIVISION_ID
			, FROM_SITE
			, TRANSPORT_MODE
			, BOD_ID			-- BOD 2단계 개발
			, MEASURE
			, ORIGIN_TO_DIVISION_ID
			, TO_SITE
			, YYYYMMDD
			, QTY
		)
		SELECT 
			  DIVISION_ID
			, ITEM_ID
			, ELECTRODE_TYPE
			, ORIGIN_FROM_DIVISION_ID
			, FROM_SITE
			, TRANSPORT_MODE
			, BOD_ID			-- BOD 2단계 개발
			, MEASURE
			, ORIGIN_TO_DIVISION_ID
			, TO_SITE
			, YYYYMMDD
			, QTY
		FROM #TblDynamicPivot_SCP0010_VALUE_1 V

		UNION ALL

		SELECT 
			  DIVISION_ID
			, ITEM_ID
			, ELECTRODE_TYPE
			, ORIGIN_FROM_DIVISION_ID
			, FROM_SITE
			, TRANSPORT_MODE
			, BOD_ID			-- BOD 2단계 개발
			, MEASURE
			, ORIGIN_TO_DIVISION_ID
			, TO_SITE
			, YYYYMMDD
			, QTY
		FROM #TblDynamicPivot_SCP0010_VALUE_2 V
		;


	/********************************************************************************
	* 임시테이블만들기- Main 조회 테이블
	********************************************************************************/	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_01') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0010_01

	SELECT   (m.division_id + m.operation_group + m.item_id + m.from_site) as key_idx
			, m.division_id	
			, m.operation_group	
			, m.item_id		
			, m.electrode_type
			, m.ORIGIN_FROM_DIVISION_ID
			, m.from_site
			, m.transport_mode
			, ISNULL(m.lt_day, 0) AS lt_day
			, m.measure		
			, m.measure_label 	
			, m.measure_order_no
			, m.origin_to_division_id
			, m.to_site
			, m.bod_id
			, @p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			, @p_plan_type AS plan_type
			, @p_seq AS seq
			,'D_'+ ISNULL(n.yyyymmdd, @v_from_yyyymmdd) AS yyyymmdd
			, o.basis_yyyymm AS yyyymm
			, RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week
			, ISNULL(n.qty, 0) AS QTY
			, @p_from_yyyymmdd as from_yyyymmdd
			, @p_to_yyyymmdd as to_yyyymmdd

	INTO  #TblDynamicPivot_SCP0010_01 
	FROM (
			SELECT 
				A.DIVISION_ID
				, A.PLAN_START_YYYYMMDD
				, A.PLAN_TYPE
				, A.SEQ
				, A.OPERATION_GROUP
				, A.ITEM_ID
				, A.FROM_SITE
				, A.BOD_ID
				, ME.MEASURE
				, A.TO_SITE
				, A.ORIGIN_FROM_DIVISION_ID
				, A.ORIGIN_TO_DIVISION_ID
				, A.ELECTRODE_TYPE
				, A.MEASURE_LABEL
				, A.MEASURE_ORDER_NO
				, A.TRANSPORT_MODE
				, A.LT_DAY
			FROM #TblDynamicPivot_SCP0010_STD A
			LEFT JOIN ( SELECT MEASURE FROM #TblDynamicPivot_SCP0010_MEASURE ) ME
			ON ME.MEASURE = A.MEASURE
		)  m
		LEFT JOIN #TblDynamicPivot_SCP0010_DATA n
			ON m.division_id				= n.division_id
			AND m.item_id					= n.item_id
			AND m.electrode_type			= n.electrode_type
			AND m.origin_from_division_id	= n.origin_from_division_id
			AND m.FROM_SITE					= n.FROM_SITE
			AND m.transport_mode			= n.transport_mode
			AND m.measure					= n.measure
			AND m.origin_to_division_id		= n.origin_to_division_id
			AND m.to_site					= n.to_site
			AND m.bod_id					= n.bod_id	-- BOD 2단계 개발
			--AND m.yyyymmdd		 = n.yyyymmdd
		JOIN scm_sys_calendar_m o on ISNULL(n.yyyymmdd, @v_from_yyyymmdd) = o.basis_yyyymmdd
	;

	/********************************************************************************      
	 * BOH temp 테이블 생성  
	 ********************************************************************************/  
	
	IF OBJECT_ID('tempdb..#BOH_E') IS NOT NULL              
		DROP TABLE #BOH_E  
	IF OBJECT_ID('tempdb..#BOH_A') IS NOT NULL              
		DROP TABLE #BOH_A
        --dbo.FN_GET_SCP_ANL_BOH_QTY     
        --dbo.FN_GET_SCP_ANL_CHAR_BOH_QTY

	IF @p_operation_group = 'E'
		BEGIN
			select *
			into #BOH_E
			from( 
					select 'E' AS OPERATION_GROUP
							, X.site_id
							,X.item_id
							,cast(round(sum(isnull(X.psi_boh_qty,0)),1) as int)  AS psi_boh_qty
						from scp_pln_plant_onhand X with(nolock) 
						WHERE X.DIVISION_ID =  @p_division_id
						and X.stock_type    NOT IN ( 'FOR_STOCKPLAN','FORMING','FORMED','CHARING','CHAR','A_MOVE_WH','A_OUT_WH')   --셀 활성화진행중 이후 특성,창고재고 제외 
						AND X.plan_start_yyyymmdd        = @p_plan_start_yyyymmdd  
						and X.plan_type                 = @p_plan_type  
						and X.seq                       = @p_seq  
						--and X.site_id                   = @p_scm_site_id  
						--and X.item_id                   = @p_item_id  
						and X.yyyymmdd                  = @p_plan_start_yyyymmdd  
						group by X.site_id
							,X.item_id
			) a
		END
	ELSE
		BEGIN
			select *
			into #BOH_A
			from( 
					select  'A' AS OPERATION_GROUP
						,X.site_id
						,X.item_id
						,cast(round(sum(isnull(X.psi_boh_qty,0)),1) as int)	psi_boh_qty	   
						from scp_pln_plant_onhand X with(nolock)  
						where X.division_id               = @p_division_id  
						and X.stock_type                IN ('CHAR','A_MOVE_WH','A_OUT_WH') --특성완료재고  
						and X.plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  
						and X.plan_type                 = @p_plan_type  
						and X.seq                       = @p_seq  
						--and site_id                   = @p_scm_site_id  
						--and item_id                   = @p_item_id  
						and X.yyyymmdd                  = @p_plan_start_yyyymmdd  
					group by  X.site_id
						,X.item_id
			) a
		END
	/********************************************************************************      
	 * ESS 출하확정구간 임시테이블 생성 
	 ********************************************************************************/ 
    IF OBJECT_ID('tempdb..#ESS_TYPE_INFO') IS NOT NULL	
		   DROP TABLE #ESS_TYPE_INFO
		   
		;WITH ESS_TYPE_INFO AS
		(
			SELECT *
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			 WHERE 1=1
			   AND LOOKUP_TYPE = 'ESS_SHIP_PLAN_SITE'
		)
		SELECT S.DIVISION_ID
		     , S.SCM_SITE_ID
		     , S.PLANT_ID
		     , S.OPERATION_GROUP 
		     , S.SITE_DESCRIPTION 
		     , S.SITE_TYPE 
		     , S.SITE_ID 
		     , S.CITY 
		     , S.COUNTRY 
		     , S.DEPT_ID 
		     , S.VMI_YN 
		     , S.VALID_YN 
		     , S.NEW_YN 
		     , S.OSP_YN 
     		 , CASE WHEN CAST(ISNULL(S.SHIP_FROZEN,0) AS INT) > ISNULL(CAST(I.SEGMENT3 AS INT),0) THEN S.SHIP_FROZEN ELSE I.SEGMENT3 END SHIP_FROZEN
		  INTO #ESS_TYPE_INFO
		  FROM SCM_MST_SITE S WITH(NOLOCK)
		  LEFT JOIN ESS_TYPE_INFO I ON S.SCM_SITE_ID = I.SEGMENT1
		   AND S.SITE_DESCRIPTION = I.SEGMENT2
   
	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/		
	BEGIN
		DECLARE @mQry_sum NVARCHAR(MAX);
		DECLARE @mDAY_QTY NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mDAY_QTY='QTY';
		SET @mQry_sum = '';

		    SET @mQry_sum = '';
			-- 중장기 수정 : NULL 값 처리
		    --SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+' END ) AS ' + yyyymmdd
						--							WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 6) THEN  '+@mDAY_QTY+'  END ) AS ' + yyyymmdd
						--					        WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  '+@mDAY_QTY+'  END ) AS ' + yyyymmdd
						--			           END +''+CHAR(10)
			SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'ISNULL(SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+' END ),0) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'ISNULL(SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 6) THEN  '+@mDAY_QTY+'  END ),0) AS ' + yyyymmdd
											        WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'ISNULL(SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  '+@mDAY_QTY+'  END ),0) AS ' + yyyymmdd
												END +''+CHAR(10)
			FROM (
					SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
						, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a with(nolock)
					WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

					UNION ALL

					SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
							,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a with(nolock)
					WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.month_name

					UNION ALL

					SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
							, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a with(nolock)
					WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					GROUP BY a.basis_yyyymmdd

				) AS A
			ORDER BY sort_order_no  ;

			-- 중장기 프로젝트(기간 82주로 연장) : MSSQL 오류로 GROUPPING SUB QUERY 로 변경
			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'      SELECT																									'+CHAR(10);
			--SET @mEXEC = @mEXEC+'      		 a.key_idx																							'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.division_id																						'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.operation_group																					'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.item_id																							'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.ELECTRODE_TYPE																						'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.ORIGIN_FROM_DIVISION_ID																			'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.from_site																							'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.ORIGIN_TO_DIVISION_ID																				'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.to_site																							'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.bod_id																								'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,ISNULL(a.transport_mode, ''-'') as transport_mode 													'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,ISNULL(a.lt_day, 0) as lt_day																		'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.measure																							'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.measure_order_no																					'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.measure_label 																						'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,a.plan_start_yyyymmdd, a.plan_type, a.seq,a.from_yyyymmdd,a.to_yyyymmdd										'+CHAR(10);
			SET @mEXEC = @mEXEC+'			A.*																									'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,dbo.fn_get_division_name(division_id) AS division_name												'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,(select TOP 1 DIVISION_NAME from SCM_MST_DIVISION where DIVISION_ID = a.division_id) division_name     '+CHAR(10);
			-- 20220126 : DC LINK 수정 (PACK -> PACK)
			--SET @mEXEC = @mEXEC+' 			,(case when a.OPERATION_GROUP =''A'' then ''Cell'' else ''Electrode'' end) as OPERATION_GROUP_DESC 	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,(case when a.OPERATION_GROUP =''A'' then ''Cell'' WHEN a.OPERATION_GROUP = ''P'' then ''Pack'' else ''Electrode'' end) as OPERATION_GROUP_DESC 	'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,dbo.FN_GET_ITEM_NICKNAME(division_id, item_id ) AS Nick_name										'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,(SELECT TOP 1 NICK_NAME FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK) WHERE 1=1 AND ITEM_ID = a.item_id)	Nick_name '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,dbo.FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, FROM_SITE ) AS FROM_SITE_DESCRIPTION					'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,(select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = a.FROM_SITE) FROM_SITE_DESCRIPTION '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, TO_SITE ), ''-'') AS T0_SITE_DESCRIPTION		'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,isnull((select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = a.TO_SITE),''-'') T0_SITE_DESCRIPTION '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,  cast( round(  (CASE WHEN operation_group = ''E'' THEN dbo.FN_GET_SCP_ANL_BOH_QTY      (division_id, plan_start_yyyymmdd, plan_type, seq, from_site, item_id, from_yyyymmdd ) '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			         WHEN operation_group = ''A'' THEN dbo.FN_GET_SCP_ANL_CHAR_BOH_QTY (division_id, plan_start_yyyymmdd, plan_type, seq, from_site, item_id, from_yyyymmdd )				'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			     END ) , 1) as int) AS BOH																																					'+CHAR(10);

			IF @p_operation_group = 'E'
				BEGIN
					SET @mEXEC = @mEXEC+' 			,  (SELECT psi_boh_qty  
															FROM #BOH_E X WITH  (NOLOCK) 
															WHERE 0 = 0						
		 														AND  X.ITEM_ID          = a.item_id
																AND  X.site_id          = a.from_site
																AND  X.OPERATION_GROUP  = a.operation_group
																) AS boh							'+CHAR(10);
				END
			ELSE
				BEGIN
					SET @mEXEC = @mEXEC+' 			,  (SELECT psi_boh_qty  
															FROM #BOH_A X WITH  (NOLOCK) 
															WHERE 0 = 0						
		 														AND  X.ITEM_ID          = a.item_id
																AND  X.site_id          = a.from_site
																AND  X.OPERATION_GROUP  = a.operation_group
																) AS boh							'+CHAR(10);
				END

			/* -- 20230314 PI 요청으로 ESS 도 From 기준 Ship Frozen 적용 : START
			IF @p_division_id IN ('82')
				BEGIN
					-- 동일 지역 법인 내 이동인 경우 전 구간 수정 가능
					SET @mEXEC = @mEXEC+' 			,CASE WHEN F.SITE_ID=T.SITE_ID AND F.OSP_YN=''N'' AND T.OSP_YN=''N'' THEN (select CONVERT(CHAR(10),convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112), 23)) '+CHAR(10);
					-- Ship Frozen 구간 : UI 수정 불가 구간 처리 : 82 는 To Plant SIte의 Ship Frozen 기준으로 적용 중임
					SET @mEXEC = @mEXEC+' 				  ELSE CONVERT(CHAR(10), DATEADD(DAY, ISNULL(T.SHIP_FROZEN, 0) , CONVERT(DATE, '''+@p_plan_start_yyyymmdd+''', 112)) , 23)							'+CHAR(10);
					SET @mEXEC = @mEXEC+' 			 END AS SHIP_FROZEN											'+CHAR(10);
				END
			ELSE
				BEGIN
					-- 20230310 전극 계열인 경우 전 구간 수정 가능
					SET @mEXEC = @mEXEC+' 			,CASE WHEN A.DIVISION_ID =''EE'' OR A.DIVISION_ID =''EE_UC'' THEN (select CONVERT(CHAR(10),convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112), 23)) '+CHAR(10);
					-- 동일 지역 법인 내 이동인 경우 전 구간 수정 가능
					SET @mEXEC = @mEXEC+' 			      WHEN F.SITE_ID=T.SITE_ID AND F.OSP_YN=''N'' AND T.OSP_YN=''N'' THEN (select CONVERT(CHAR(10),convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112), 23)) '+CHAR(10);
					-- Ship Frozen 구간 : UI 수정 불가 구간 처리 : From Site 기준
					SET @mEXEC = @mEXEC+' 				  ELSE CONVERT(CHAR(10), DATEADD(DAY, ISNULL(F.SHIP_FROZEN, 0) , CONVERT(DATE, '''+@p_plan_start_yyyymmdd+''', 112)) , 23)							'+CHAR(10);
					SET @mEXEC = @mEXEC+' 			 END AS SHIP_FROZEN											'+CHAR(10);
				END
			*/-- 20230314 PI 요청으로 ESS 도 From 기준 Ship Frozen 적용 : END

			-- 1. 전극 계열인 경우 전 구간 수정 가능 : 20230310 추가
			-- 2. 동일 지역 법인 내 이동인 경우 전 구간 수정 가능
			-- 3. Ship Frozen 구간 : UI 수정 불가 구간 처리 : From Site 기준
			--SET @mEXEC = @mEXEC+' 			,CASE WHEN A.DIVISION_ID =''EE'' OR A.DIVISION_ID =''EE_UC'' THEN (select CONVERT(CHAR(10),convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112), 23)) '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,CASE WHEN A.DIVISION_ID IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''EE'')) THEN (select CONVERT(CHAR(10),convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112), 23)) '+CHAR(10); --div_commonization

			SET @mEXEC = @mEXEC+' 			      WHEN F.SITE_ID=T.SITE_ID AND F.OSP_YN=''N'' AND T.OSP_YN=''N'' THEN (select CONVERT(CHAR(10),convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112), 23)) '+CHAR(10);
			SET @mEXEC = @mEXEC+' 				  ELSE CONVERT(CHAR(10), DATEADD(DAY, ISNULL(F.SHIP_FROZEN, 0) , CONVERT(DATE, '''+@p_plan_start_yyyymmdd+''', 112)) , 23)							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			 END AS SHIP_FROZEN											'+CHAR(10);

			SET @mEXEC = @mEXEC+' 			, bod.FROM_YYYYMMDD		AS BOD_FROM_YYYYMMDD				'+CHAR(10); -- BOD 2단계 개발
			SET @mEXEC = @mEXEC+' 			, bod.TO_YYYYMMDD		AS BOD_TO_YYYYMMDD					'+CHAR(10); -- BOD 2단계 개발
			SET @mEXEC = @mEXEC+' 			,isnull(b.DEPARTURE_DAY,''X'') Dept_Day						'+CHAR(10);

			SET @mEXEC = @mEXEC+'    from ( 															'+CHAR(10);
			SET @mEXEC = @mEXEC+'			SELECT A.KEY_IDX											'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.DIVISION_ID										'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.OPERATION_GROUP									'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.ITEM_ID											'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.FROM_SITE											'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.ELECTRODE_TYPE										'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.TO_SITE											'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.BOD_ID												'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , ISNULL(A.TRANSPORT_MODE,''-'')	AS TRANSPORT_MODE	'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , ISNULL(a.lt_day, 0)				AS LT_DAY			'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.MEASURE											'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.MEASURE_ORDER_NO									'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.MEASURE_LABEL 										'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.PLAN_START_YYYYMMDD								'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.PLAN_TYPE											'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.SEQ												'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.FROM_YYYYMMDD										'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.TO_YYYYMMDD										'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.ORIGIN_FROM_DIVISION_ID							'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 , A.ORIGIN_TO_DIVISION_ID								'+CHAR(10);
			SET @mEXEC = @mEXEC+' 				 '+@mQry_sum	;
			SET @mEXEC = @mEXEC+'			  FROM #TblDynamicPivot_SCP0010_01	a						'+CHAR(10);
			SET @mEXEC = @mEXEC+'			 GROUP BY A.KEY_IDX											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.DIVISION_ID										'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.OPERATION_GROUP									'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.ITEM_ID											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.FROM_SITE										'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.ELECTRODE_TYPE									'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.TO_SITE											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.BOD_ID 											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.TRANSPORT_MODE									'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.LT_DAY											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.MEASURE											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.MEASURE_ORDER_NO								'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.MEASURE_LABEL									'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.PLAN_START_YYYYMMDD								'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.PLAN_TYPE										'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.SEQ												'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.FROM_YYYYMMDD									'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.TO_YYYYMMDD 									'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.ORIGIN_FROM_DIVISION_ID							'+CHAR(10);
			SET @mEXEC = @mEXEC+'					, A.ORIGIN_TO_DIVISION_ID							'+CHAR(10);
			SET @mEXEC = @mEXEC+'			) A															'+CHAR(10);
			
		    SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCP_MST_SHIPMENT_SEMI_DEPT_DAY b on b.division_id = a.division_id and b.item_id = a.item_id and b.VALID_YN = ''Y''      '+CHAR(10);
			-- BOD 2단계 개발 : 추가 FROM , TO
			--SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCP_MST_BOD_N_V bod with(nolock) on bod.BOD_ID = a.BOD_ID      '+CHAR(10);
			SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCP_ANL_BOD_N_V_PLAN_H bod with(nolock) on bod.BOD_ID = a.BOD_ID AND bod.DIVISION_ID = a.DIVISION_ID AND bod.FROM_SITE=a.FROM_SITE AND bod.PLAN_NAME = '''+@p_plan_start_yyyymmdd+''' AND bod.PLAN_TYPE = '''+@p_plan_type+''' AND bod.PLAN_SEQ = '''+@p_seq+''' '+CHAR(10);
			--IF @p_division_id IN ('EE','EE_UC')
			IF @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				BEGIN 
					SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCM_MST_SITE F on F.DIVISION_ID=a.origin_from_division_id	AND F.SCM_SITE_ID=a.from_site	AND F.VALID_YN=''Y''		'+CHAR(10);
					SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCM_MST_SITE T on T.DIVISION_ID=a.ORIGIN_TO_DIVISION_ID		AND T.SCM_SITE_ID=a.to_site		AND T.VALID_YN=''Y''		'+CHAR(10); 
				END
			ELSE IF @p_division_id IN ('82') --ESS 출하구간 수정
				BEGIN
					SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN #ESS_TYPE_INFO F on F.DIVISION_ID=a.division_id		AND F.SCM_SITE_ID=a.from_site	AND F.VALID_YN=''Y'' 	'+CHAR(10);
					SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN #ESS_TYPE_INFO T on T.DIVISION_ID=a.division_id		AND T.SCM_SITE_ID=a.to_site		AND T.VALID_YN=''Y'' 	'+CHAR(10); 
				END
			ELSE
				BEGIN 
					SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCM_MST_SITE F on F.DIVISION_ID=a.division_id		AND F.SCM_SITE_ID=a.from_site	AND F.VALID_YN=''Y'' 	'+CHAR(10);
					SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCM_MST_SITE T on T.DIVISION_ID=a.division_id		AND T.SCM_SITE_ID=a.to_site		AND T.VALID_YN=''Y'' 	'+CHAR(10); 
				END

			--SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCM_MST_SITE F on F.DIVISION_ID=a.origin_from_division_id	AND F.SCM_SITE_ID=a.from_site	AND F.VALID_YN=''Y''		'+CHAR(10);
			--SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN SCM_MST_SITE T on T.DIVISION_ID=a.ORIGIN_TO_DIVISION_ID		AND T.SCM_SITE_ID=a.to_site		AND T.VALID_YN=''Y''		'+CHAR(10);
			SET @mEXEC = @mEXEC+'      WHERE 1=1																													 '+CHAR(10);
			--SET @mEXEC = @mEXEC+'	   GROUP BY a.key_idx, a.division_id, a.operation_group, a.item_id, a.from_site ,a.ELECTRODE_TYPE, a.to_site, a.bod_id ,a.transport_mode, a.lt_day,     '+CHAR(10); 
			--SET @mEXEC = @mEXEC+'	   			a.measure,a.measure_order_no,a.measure_label ,a.plan_start_yyyymmdd, a.plan_type, a.seq,a.from_yyyymmdd,a.to_yyyymmdd , a.ORIGIN_FROM_DIVISION_ID, a.ORIGIN_TO_DIVISION_ID, b.DEPARTURE_DAY  '+CHAR(10);
			--SET @mEXEC = @mEXEC+'	   			,F.SITE_TYPE, F.OSP_YN, F.SITE_ID, F.SHIP_FROZEN, T.SITE_TYPE, T.OSP_YN, T.SITE_ID  '+CHAR(10);
			-- byte 오류로 order by 를 UI 에서 함
			--SET @mEXEC = @mEXEC+'	   ORDER BY a.division_id, a.operation_group, a.item_id, a.from_site, a.to_site desc,a.bod_id, a.measure_order_no				  '+CHAR(10);
			
			-----------------------------------------------------------
			-- DEBUG QRY 출력
			-----------------------------------------------------------	
			IF( @debug_mode ='T')
			BEGIN				
				SET @POS =1;
				SET @LEN =LEN(@mEXEC);
				WHILE @POS <= @LEN
					BEGIN
						PRINT SUBSTRING(@mEXEC,@POS,4000);
						SET @POS = @POS+4000;
					END;
			END;
			-----------------------------------------------------------			

			EXEC (@mEXEC);

	END;


		--	임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_01') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0010_01;        
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_DATA') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0010_DATA
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_VALUE_1') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0010_VALUE_1
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_VALUE_2') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0010_VALUE_2
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_STD') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0010_STD
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0010_MEASURE') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0010_MEASURE
		IF OBJECT_ID('tempdb..#BOH_E') IS NOT NULL	
			DROP TABLE #BOH_E
		IF OBJECT_ID('tempdb..#BOH_A') IS NOT NULL	
			DROP TABLE #BOH_A
		IF OBJECT_ID('tempdb..#ESS_TYPE_INFO') IS NOT NULL
			DROP TABLE #ESS_TYPE_INFO
	;
	

	-- 수정가능여부 구간 조회
	declare @todayLimit date = convert(date , getdate() , 112 );
	
	SELECT
		case
			when DATEDIFF(week , @todayLimit , @p_plan_start_yyyymmdd) < 0 then 'N'
			--when a.PLAN_TYPE ='FN' then 'N'			
			--when a.PLAN_TYPE ='MA' and confirm_yn='Y' then 'Y'
			--when a.PLAN_TYPE ='SE' then 'Y'
			--when a.PLAN_TYPE ='PR' then 'N'		-- 2018-05-16 PR 수정 못하도록
			--else 'N'
			else 'Y'
		end as is_editable
		--'Y' as is_editable
		, plan_name	, plan_seq , plan_type,	CONFIRM_FLAG, plan_start_yyyymmdd, PLAN_STATUS, confirm_yn, plan_type_seq, basis_start_date
		, convert(date , @p_plan_start_yyyymmdd, 112) as plan_start_date
	FROM (
			--SELECT   d.division_id
			--		,p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(CONVERT(NVARCHAR,d.plan_seq),2)  AS plan_version_id
			--		,p.plan_name
			--		,d.plan_seq
			--		,d.plan_type	
			--		,vv.CONFIRM_FLAG
			--		,p.plan_name as plan_start_yyyymmdd
			--		,CASE WHEN ISNULL(d.CONFIRM_FLAG,'')='' THEN 'N' ELSE d.CONFIRM_FLAG END AS confirm_yn		
			--FROM scm_mst_plan_detail d
			--inner join scm_mst_modeling m on m.modeling_id = d.modeling_id	and m.plan_cycle  = 'WEEKLY' and m.division_id = d.division_id	and m.modeling_id = d.modeling_id
			--inner join scm_mst_plan p on p.division_id = d.division_id	and p.plan_cycle  = m.plan_cycle and p.plan_id     = d.plan_id
			--inner join SCP_PLAN_VERSION_V vv on d.division_id = vv.division_id and d.plan_type   = vv.plan_type	and d.plan_seq    = vv.plan_seq	and p.plan_name   = vv.plan_start_yyyymmdd
			--WHERE 1=1
			--and d.division_id = @p_division_id
			--and d.plan_type   = @p_plan_type
			--and d.plan_seq    = @p_seq
			--and p.plan_name   = @p_plan_start_yyyymmdd

			SELECT
				p.plan_name
				,d.plan_seq
				,d.plan_type	
				,vv.CONFIRM_FLAG
				,p.plan_name as plan_start_yyyymmdd
				, d.PLAN_STATUS
				,CASE WHEN ISNULL(d.CONFIRM_FLAG,'')='' THEN 'N' ELSE d.CONFIRM_FLAG END AS confirm_yn
				, case d.plan_type when 'PR' then 0 when 'MA' then 1 when 'SE' then 2 when 'FN' then 3 end plan_type_seq
			FROM scm_mst_plan_detail d with(nolock)
			inner join scm_mst_modeling m with(nolock) on m.modeling_id = d.modeling_id	and m.plan_cycle  = 'WEEKLY' and m.division_id = d.division_id	and m.modeling_id = d.modeling_id
			inner join scm_mst_plan p with(nolock) on p.division_id = d.division_id	and p.plan_cycle  = m.plan_cycle and p.plan_id     = d.plan_id
			inner join SCP_PLAN_VERSION_V vv with(nolock) on d.division_id = vv.division_id and d.plan_type   = vv.plan_type	and d.plan_seq    = vv.plan_seq	and p.plan_name   = vv.plan_start_yyyymmdd
			WHERE 1=1
			and d.division_id = @p_division_id
			and p.plan_name   = @p_plan_start_yyyymmdd
			and d.PLAN_TYPE IN ('PR', 'MA', 'SE', 'FN', 'TE')
			and d.DISPLAY_YN='Y'
	) a
	,(SELECT basis_start_date FROM scm_sys_calendar_m  with(nolock)	WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)) b;
	;

	-- 05/25
	-- FIX 추가관련
	--SELECT 
	--	(@p_division_id + a.biz_type + a.item_id + a.from_site) as key_idx 
	--	, FIX_ID
	--	, to_site
	--	, bod_id
	--	,'D_'+yyyymmdd AS yyyymmdd
	--from SCP_ANL_SHIPMENT_PLAN_FIX a  with(nolock INDEX(PK_SCP_ANL_SHIPMENT_PLAN_FIX_1))
	--where division_id = @p_division_id
	--and biz_type= @p_operation_group
	--and a.yyyymmdd >= @p_from_yyyymmdd
	--and a.yyyymmdd <= @p_to_yyyymmdd
	--and ( (@p_item_id is null or @p_item_id = '') or a.ITEM_ID in (select token from dbo.String_Split(@p_item_id, ',')) )
	--and ( (@p_electype is null or @p_electype = '') or a.ELECTRODE_TYPE in (select token from dbo.String_Split(@p_electype , ',')) )
	--;

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC + 'SELECT'																												+ CHAR(10);
	SET @mEXEC = @mEXEC + '		('''+@p_division_id+''' + '''+@p_operation_group+''' + A.ITEM_ID + A.FROM_SITE) AS KEY_IDX'						+ CHAR(10);
	SET @mEXEC = @mEXEC + '		, FIX_ID'																										+ CHAR(10);
	SET @mEXEC = @mEXEC + '		, TO_SITE'																										+ CHAR(10);
	SET @mEXEC = @mEXEC + '		, BOD_ID'																										+ CHAR(10);
	SET @mEXEC = @mEXEC + '		, ''D_'' + YYYYMMDD AS YYYYMMDD'																				+ CHAR(10);
	SET @mEXEC = @mEXEC + 'FROM SCP_ANL_SHIPMENT_PLAN_FIX A WITH(NOLOCK)'																		+ CHAR(10);
	SET @mEXEC = @mEXEC + 'WHERE DIVISION_ID	= '''+@p_division_id+''''																		+ CHAR(10);
	SET @mEXEC = @mEXEC + 'AND	 BIZ_TYPE		= '''+@p_operation_group+''''																	+ CHAR(10);
	--IF NOT(@p_item_id IS NULL    OR  @p_item_id ='') BEGIN SET @mEXEC = @mEXEC+' AND ( A.ITEM_ID			IN ('+ @arr_item_id +') )'			+ CHAR(10); END;
	IF NOT(@p_item_id IS NULL    OR  @p_item_id ='') BEGIN SET @mEXEC = @mEXEC+' AND ( A.ITEM_ID			IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(''' + @p_item_id + ''', '''')))'		+ CHAR(10); END;


	SET @mEXEC = @mEXEC + 'AND	 YYYYMMDD		>= '''+@p_from_yyyymmdd+''''																	+ CHAR(10);
	SET @mEXEC = @mEXEC + 'AND	 YYYYMMDD		<= '''+@p_to_yyyymmdd+''''																		+ CHAR(10);
	IF NOT(@p_electype IS NULL   OR  @p_electype='') BEGIN SET @mEXEC = @mEXEC+' AND ( A.ELECTRODE_TYPE		IN ('+ @arr_elec_type +') )'		+ CHAR(10); END;

	EXEC (@mEXEC);

		-----------------------------------------------------------
		-- DEBUG QRY 출력
		-----------------------------------------------------------	
		IF( @debug_mode ='T')
		BEGIN				
			SET @POS =1;
			SET @LEN =LEN(@mEXEC);
			WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mEXEC,@POS,4000);
					SET @POS = @POS+4000;
				END;
		END;
		-----------------------------------------------------------		

END

