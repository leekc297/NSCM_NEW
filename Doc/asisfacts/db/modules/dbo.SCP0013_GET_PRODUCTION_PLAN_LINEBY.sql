


 /*
 * Program ID   : SCP0013_GET_PRODUCTION_PLAN_LINEBY
 * Description  : Production Plan Line 별 조회
 * Program History
 *===================================================================================================
 * Date         In Charge                 Description
 *===================================================================================================
 * 2018/04/19   byunghunjung	          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/02   byunghunjung	          Line Total Load(%) 추가
 * 2018/05/17   PJS				          FIX정보 조회 추가
 * 2018/05/22   byunghunjung	          Line Total Load(%) 조회시 item_id 제외
 * 2018/05/23   byunghunjung	          Item Id 조회시 Line 정보 표시토록 수정
 * 2018/05/29   byunghunjung	          working time = 0일 경우 LINE_TOTAL_LOAD = 0 으로 표시
 * 2018/05/29   PJS 주Sum		          집계방식 변경, FIX정보에 yyyymm_week추가
 * 2018/05/31   byunghunjung	          Item Id 조회시 scm mst site 있는 것만 표시토록 수정
 * 2018/06/12   PJS				          FIX정보에서 Item id 제외(plan line이 확정조회 되기 때문에 fix된 정보 표시 안되는 현상이 나타남)
 * 2018/06/19   byunghunjung	          PROD_PLAN_ENGINE Measure 추가
 * 2018/06/22   byunghunjung	          LINE_TOTAL_LOAD_ENGINE Measure 추가
 * 2018/07/12   YHW				          전극용 조회항목 추가
 * 2018/08/31	YHW				          NICK NAME 조회항목 추가
 * 2018/09/18   ygkim			          Cell Type Gr 컬럼 추가
 * 2018/09/19   ygkim			          속도 개선 LEFT JOIN 위치 변경
 * 2018/09/20   ygkim			          생산 실적 가져올때 Division 40, TCO Cell 일 경우 Line '-' 로 변경
 * 2018/09/27   ygkim			          생산 실적 조건 추가 (LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회, 외주PACKER의 업체코드)
 * 2018/10/01   ygkim			          생산 실적 조건 () 추가
 * 2018/10/04   ygkim			          계획 없는 Line Total 제외
 * 2018/10/08   ygkim			          생산 실적 CELL_TYPE_GROUP_CODE 가져오는 로직 수정
 * 2018/12/28	hwyoon			          셀 환산수량 measure 추가
 * 2019/06/04	hwyoon			          [CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
 * 2019/06/24	hwyoon			          [CSR ID:4022979] 모델 별 가용 생산 PKG Line과 loading % 표시 요청의 건
 * 2019/06/27	hwyoon			          [CSR ID:4025652] Amend 과거구간 생산실적 표기 요청의 건
 * 2019/08/12	hwyoon			          [CSR ID:4053788] 자체개선 - Tact TIme Except 입력 날짜 Validation 추가 외 3건
 *                                                  -> 과거실적 표기 시 Plan이 없는 경우에도 Amend Measure 생성하여 표시
 * 2019/08/29	hwyoon			          [CSR ID:4067015] 전극 과거구간 생산실적 환산 표기                  - 과거실적 수량 Cell수량으로 환산하여 RowData 추가
 * 2020/02/06	hwyoon			          ESS 외주 Pakcer Line 생산 Target 적용
 * 2020/02/18	hwyoon			          OUTPUT 수량 0 삭제 후 처리로직 추가
 * 2021/03/24	PJG		     	          EXTRA_SPEC 컬럼 추가
 * 2021/06/28   LWY                       PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)     - PRODUCTION_PLAN_LINE 속도개선
 * 2021/07/06   LWY                       MODEL 입력 조회 시 계획이 없을경우 조회 안되는 문제 수정 - 전체 조회는 되나 MODEL 입력 후 조회 시 조회 안되는 현상
 * 2021/07/22   LWY			              PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2021/10/13   KMJ			              PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)     - UI 속도 개선으로 Bucket별 조회로 수정
 * 2021/10/25   kdw			              PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)     - BOM기준 Parent ID 기준 정렬
 * 2021/11/02   KMJ			              PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)     - FIX 테이블 조회시 BUCKET별 조회 적용
 * 2021/11/04   KHJ			              PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)     - FIX 테이블 조회시 BUCKET별 조회 - WEEKLY 시 DISTINCT
 * 2021/11/24   khj79                     [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3)   - p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
 * 2022/05/06   lwy			              PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)     - Query OverFlow Tunning
 * 2022/05/13   LSC                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선                  - GM JV 추가
 * 2022/06/08   jahn1501                  [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3)   - 전극 단위 추가
 * 2022/07/19   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2   - 전극 단위 적용 수식 변경
 * 2022/08/31   LWY                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2   - Isuzu 추가
 * 2022/10/31   LWY                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2   - 실적집계 수정 (distinct -> sum(qty) group by)
 * 2023/01/02   LWY                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2   - 조회기준 변경(main / hist) - 당주,전주(main) / 당주,전주 이전(hist)
 * 2023/04/10   LWY				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행             - DIVISION_ID 공통화 작업(div_commonization)
 * 2023/06/12   LWY				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행             - Pack Line 가동율 개선
 * 2023.06.23   KJJ				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행             - Like 검색기능
 * 2023.07.26   vadabi3			          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행             - Model, Material 개선
 * 2023/08/25   chaan		    V1.1.2    PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2            - PROD PLAN(ENGINE STD J/R) 계산 Logic 개선
 * 2023/11/28   vadabi3		              PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2            - E20231124-001624 [SCM물류PI팀] SCM 시스템 'Production Plan Line' 메뉴의 완제품 셀 모델 코드 칼럼 추가를 위한 신규개발 건
 * 2023/12/14   vadabi3		              PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2            - #TblDynamicPivot_SCP0013_Perfor 이슈 개선
 * 2023/12/14   vadabi3		              PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2            - Temp Table 개선
 * 2024/01/08   KSG 		                        E20240104-001182 SCP 과거 전극 생산계획 조회시 ENGINE STR JR 표기 요청
	                                                  1.  @p_plan_start_yyyymmdd >= @v_min_yyyymmdd 인 경우만 'PROD_PLAN_ENGINE_STD_JR' MEASURE 정보 생성 중
	                                                    -> 전 구간 Measure 생성으로 변경
	                                                  2. SUBSTRING(A.PLAN_START_YYYYMMDD,0,7) = B.MONTH 조건으로 조회 Plant_date 에 해당하는 MONTH 정보 Join 중
	                                                    -> 과거 MONTH 에는 정보가 없으므로 당주 월요일이 속한 월 기준으로 MONTH 연결하도록 수정
	                                                  3. EE 외 전극 사업부도 표시되도록 처리
 * 2024-01-08   chaan           V1.1.3    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 * 2024-01-19   chaan           V1.1.4    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
 * 2024-02-19   vadabi3         V1.1.5    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - EE_HM 개선
 * 2024-03-05   chaan           V1.1.6    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 실적포함 조회시 속도 지연 개선
 * 2024-07-16   chaan           V1.1.7    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 8K Row oversizing 에러 수정
 * 2025-04-02   mrchois			V1.1.8	  PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - Extra Spec 조회조건 추가
 * 2025-09-01   hrkim					  PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용
 * 2026-01-26   YMH						  E20260123-001747 전극 실적 DIV 하드코딩 제거.
 * 2026-03-05	YMH						  E20260226-001691 82 Div Virtual Plant 실적 구간 데이터 조회 기능
 * 2026-04-21   ymh						  E20260415-000894 타 DIVISION에서 ESS 실적 안나오게 수정.
----------------------------------------------------------------------------------------------------------------------------------------
   EXEC SCP0013_GET_PRODUCTION_PLAN_LINEBY
   @p_division_id='81'
   , @p_operation_group='A'
   , @p_scm_site_id=''
   , @p_line_id=''
   , @p_model_id=''
   , @p_item_id=''
   , @p_from_yyyymmdd='20230717'
   , @p_to_yyyymmdd='20240717'
   , @p_plan_start_yyyymmdd='20230717'
   , @p_plan_type='PR'
   , @p_seq='2'
   , @p_program_id='SCP0013'
   , @p_sheet_name='LINE'
   , @p_user_id='pasun2'
	,@p_electrode_type		= ''
	,@p_nick_name			= ''
	,@p_cell_type_gr		= ''
	,@p_line_assign			= 'N'
	,@p_bucket				= 'DAILY'
	,@p_chk_all				= ''
   , @debug_mode='T'


EXEC SCP0013_GET_PRODUCTION_PLAN_LINEBY
   @p_division_id='EE'
 , @p_operation_group='E'
 , @p_scm_site_id=''
 , @p_line_id=''
 , @p_model_id=''
 , @p_item_id=''
 , @p_from_yyyymmdd='20230723'
 , @p_to_yyyymmdd='20241020'
 , @p_plan_start_yyyymmdd='20231120'
 , @p_plan_type='FN'
 , @p_seq='1'
 , @p_program_id='SCP0013'
 , @p_sheet_name='LINE'
 , @p_user_id='vadabi3'
 , @p_electrode_type=NULL
 , @p_nick_name=''
 , @debug_mode='F'
 , @p_line_assign='N'
 , @p_cell_type_gr=''
 , @p_bucket='WEEKLY', @p_chk_all='N'
  */

----CREATE PROCEDURE [dbo].[SCP0013_GET_PRODUCTION_PLAN_LINEBY]
CREATE PROCEDURE [dbo].[SCP0013_GET_PRODUCTION_PLAN_LINEBY]
	  @p_division_id			NVARCHAR(50)		= N''
	, @p_operation_group		NVARCHAR(50)		= N''
	, @p_scm_site_id			NVARCHAR(MAX)		= N''
	, @p_line_id				NVARCHAR(MAX)		= N''
	, @p_model_id				NVARCHAR(MAX)		= N''
	, @p_item_id				NVARCHAR(MAX)		= N''
	, @p_from_yyyymmdd			NVARCHAR(8)			= N''
    , @p_to_yyyymmdd			NVARCHAR(8)			= N''
	, @p_plan_start_yyyymmdd	NVARCHAR(8)			= N''
	, @p_plan_type				NVARCHAR(50)		= N''
	, @p_seq					NVARCHAR(50)		= N''
	, @p_program_id				NVARCHAR(300)		= N'SCP0013'
	, @p_sheet_name				NVARCHAR(150)		= N'LINE'
	, @p_user_id				NVARCHAR(100)		= N''
	, @p_electrode_type			NVARCHAR(30)		= N''
	, @p_nick_name				NVARCHAR(50)		= N''
	, @p_cell_type_gr			NVARCHAR(30)		= N''
	, @p_line_assign			NVARCHAR(30)		= N'N'
	, @p_bucket					NVARCHAR(10)		= N''
	, @p_chk_all				NVARCHAR(1)			= N'' -- 2021.11.24 :  체크 시 bucket='daily' 조회
	, @p_extra_spec				NVARCHAR(MAX)		= N''	-- Extra Spec 조회조건 추가
	, @debug_mode				NVARCHAR(20)		= N'F'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF
	SET NOCOUNT ON;


    --DECLARE @p_division_id			NVARCHAR(50)		= N'40';
    --DECLARE @p_operation_group		NVARCHAR(50)		= N'P';
    --DECLARE @p_scm_site_id			NVARCHAR(MAX)		= N'';
    --DECLARE @p_line_id				NVARCHAR(MAX)		= N'';
    --DECLARE @p_model_id				NVARCHAR(MAX)		= N'';
    --DECLARE @p_item_id				NVARCHAR(MAX)		= N'';
    --DECLARE @p_from_yyyymmdd		NVARCHAR(8)			= N'20240715';
    --DECLARE @p_to_yyyymmdd			NVARCHAR(8)			= N'20250713';
    --DECLARE @p_plan_start_yyyymmdd	NVARCHAR(8)			= N'20240715';
    --DECLARE @p_plan_type			NVARCHAR(50)		= N'PR';
    --DECLARE @p_seq					NVARCHAR(50)		= N'1';
    --DECLARE @p_program_id			NVARCHAR(300)		= N'SCP0013';
    --DECLARE @p_sheet_name			NVARCHAR(150)		= N'LINE';
    --DECLARE @p_user_id				NVARCHAR(100)		= N'iamarock';
    --DECLARE @p_electrode_type		NVARCHAR(30)		= N'';
    --DECLARE @p_nick_name			NVARCHAR(50)		= N'';
    --DECLARE @p_cell_type_gr			NVARCHAR(30)		= N'';
    --DECLARE @p_line_assign			NVARCHAR(30)		= N'N';
    --DECLARE @p_bucket				NVARCHAR(10)		= N'DAILY';
    --DECLARE @p_chk_all				NVARCHAR(1)			= N'N';
    --DECLARE @debug_mode				NVARCHAR(20)		= N'F';

	-- 20240108  E20240104-001182 EE JV 를 위한 Division Group 처리
    DECLARE @v_division_group   NVARCHAR(30);    
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.ATTRIBUTE4
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id
    ; 

	DECLARE @v_cnt_usr_measure	INT =0;
	SET @v_cnt_usr_measure = (
								SELECT COUNT(*)
								FROM scm_mst_titleset_user WITH(NOLOCK)
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  )
	IF (@debug_mode ='T')
		print '@v_cnt_usr_measure=' +convert(varchar,@v_cnt_usr_measure);

	DECLARE @v_item_input nvarchar(1) = 'N';
	DECLARE @v_min_yyyymmdd      AS NVARCHAR(8);   -- 2021/07/21

	DECLARE @v_plan_month        AS NVARCHAR(6); -- 20240108  E20240104-001182 STD 처리용 Plan 주차 월 정보
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8);
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8);
	DECLARE @v_from_result       AS NVARCHAR(8);
	DECLARE @v_to_result         AS NVARCHAR(8);
	
	SET @v_plan_month    = ''; -- 20240108  E20240104-001182 STD 처리용 Plan 주차 월 정보
	SET @v_from_yyyymmdd = '';
	SET @v_to_yyyymmdd   = '';
	SET @v_from_result   = '';
	SET @v_to_result     = '';

	-- 20240108  E20240104-001182 STD 처리용 Plan 주차 월 정보
	SELECT @v_plan_month = basis_yyyymm
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이 속한 월 기준

	SELECT @v_from_yyyymmdd = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd

	SELECT @v_from_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd;

	SELECT @v_to_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
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

	-- 실적용
	DECLARE @v_result_only CHAR(1) = 'N';
	IF @v_from_yyyymmdd > @v_to_yyyymmdd
	BEGIN
		set @v_result_only = 'Y';
	END


	PRINT 'Start. '+CONVERT(CHAR(23), GETDATE(), 21);

	declare @p_plan_end_yyyymmdd nvarchar(8);

	SELECT @p_plan_end_yyyymmdd= MAX_BASIS_YYYYMMDD
	FROM (
			SELECT MIN_BASIS_YYYYMMDD
					,DATEPART(DW,MIN_BASIS_YYYYMMDD ) AS MIN_PART
					,CONVERT(VARCHAR, CONVERT(DATETIME, MAX_BASIS_YYYYMMDD )-DATEPART(DW,MAX_BASIS_YYYYMMDD )+1,112)  AS MAX_BASIS_YYYYMMDD
					,DATEPART(DW,MAX_BASIS_YYYYMMDD ) AS MAX_PART
				FROM (	SELECT MIN(A.BASIS_YYYYMMDD) AS MIN_BASIS_YYYYMMDD , MAX(BASIS_YYYYMMDD) AS MAX_BASIS_YYYYMMDD
						FROM SCM_SYS_CALENDAR_M A  WITH(NOLOCK)
						WHERE A.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
						AND A.BASIS_YYYYMMDD <= CONVERT(varchar(8) , DATEADD(MM, convert(int,'18'), @p_plan_start_yyyymmdd), 112) -- 2021-05-27 : 중장기(12=>18로 변경)
					) T
			) U
	;

	-- 2021.11.24 : 체크 시 bucket='daily' 조회
	IF(@p_chk_all = 'Y')	SET @p_bucket = 'DAILY' ;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	-- Pivot용 Row Data 적재용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013;

	-- Model/NickName 조회 시 Plant, Line 추출용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_PlantLine_By_Search') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_PlantLine_By_Search;

	-- Line Assign 체크 시 T/T Plant, Line 추출용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_PlantLine_By_TT') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_PlantLine_By_TT;

	-- Base Row Date 조회
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_tmp') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_tmp;

	-- Line Load율 조회
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_load') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_load;

	-- Prod Plan(Amend) 로드율 계산용 Working Time 조회
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_working') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_working;

	-- 과거생산실적 조회
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_Perfor') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_Perfor;

	-- 생산계획 조회
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_plan') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_plan;

	-- Base Row Date-KEY 조회
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_key') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_key;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_working_data') IS NOT NULL
	    DROP TABLE #TblDynamicPivot_SCP0013_working_data;

	IF OBJECT_ID('tempdb..#TblLookUp_SCP0013') IS NOT NULL
		DROP TABLE #TblLookUp_SCP0013;

	IF OBJECT_ID('tempdb..#ISUZU_SCP0013') IS NOT NULL
		DROP TABLE #ISUZU_SCP0013;

	-- 2023/06/12 begin
	IF OBJECT_ID('tempdb..#TMP_WEEK_SCP0013') IS NOT NULL
		DROP TABLE #TMP_WEEK_SCP0013;
	
	IF OBJECT_ID('tempdb..#TMP_WEEK_CNT_SCP0013') IS NOT NULL
		DROP TABLE #TMP_WEEK_CNT_SCP0013;

	IF OBJECT_ID('tempdb..#TMP_WEEK_RATIO_SCP0013') IS NOT NULL
		DROP TABLE #TMP_WEEK_RATIO_SCP0013;

	IF OBJECT_ID('tempdb..#TMP_MONTH_SCP0013') IS NOT NULL
		DROP TABLE #TMP_MONTH_SCP0013;

	IF OBJECT_ID('tempdb..#TMP_MONTH_CNT_SCP0013') IS NOT NULL
		DROP TABLE #TMP_MONTH_CNT_SCP0013;

	IF OBJECT_ID('tempdb..#TMP_MONTH_RATIO_SCP0013') IS NOT NULL
		DROP TABLE #TMP_MONTH_RATIO_SCP0013;




	-- 임시테이블 초기화
	CREATE TABLE #TblDynamicPivot_SCP0013_PlantLine_By_Search (
		 SCM_SITE_ID	NVARCHAR(60)
		,LINE_ID		NVARCHAR(60)
	);

	CREATE TABLE #TblDynamicPivot_SCP0013_PlantLine_By_TT (
		 SCM_SITE_ID	NVARCHAR(60)
		,LINE_ID		NVARCHAR(60)
		,LINE_ASSIGN_KEY NVARCHAR(110)
	);

-- E20260226-001691 82 Div Virtual Plant 실적 구간 데이터 조회 기능
		-- ESS 혼용생산 로직 처리를 위해 혼용생산MAP정보 임시테이블(#JV_ESS_MAP) 추가.
		IF OBJECT_ID('TEMPDB..#JV_ESS_MAP')		IS NOT NULL DROP TABLE #JV_ESS_MAP
	
		SELECT 
			PLANT.COMPANY_ID , PLANT.DIVISION_ID , PLANT.PLANT_ID , LINE.LINE_ID , [SITE].SCM_SITE_ID 
			, [R_SITE].COMPANY_ID AS LINK_COMPANY_ID , [R_SITE].DIVISION_ID AS LINK_DIVISION_ID, PLANT.LINK_PLANT_ID , LINE.LINK_LINE_ID , [SITE].ATTRIBUTE9 AS LINK_SCM_SITE_ID
		INTO #JV_ESS_MAP
		FROM
		(
			SELECT COMPANY_ID , DIVISION_ID , PLANT_ID , LINK_PLANT_ID FROM SCM_MST_PLANT_SN VP 
			WHERE VP.PLANT_TYPE = 'VIRTUAL'		
		) AS PLANT
			JOIN 
			(
				SELECT 
				DISTINCT COMPANY_ID , DIVISION_ID , PLANT_ID , LINE_ID , LINK_LINE_ID
				, LEFT(OPERATION_ID,1) AS SCP_OPERATION_GROUP
				FROM SCM_MST_LINE_SN VL WITH(NOLOCK) 
				WHERE VIRTUAL_LINE_YN = 'Y'
				AND VL.ACTIVE_FLAG		= 'Y'
				AND LEFT(OPERATION_ID,1) IN ('A','E','P')
			) AS LINE
			ON	PLANT.COMPANY_ID	= LINE.COMPANY_ID
			AND PLANT.DIVISION_ID	= LINE.DIVISION_ID
			AND PLANT.PLANT_ID		= LINE.PLANT_ID
			JOIN 
			(
				 SELECT * 
				 FROM SCM_MST_SITE SI
				 WHERE SITE_TYPE = 'PLANT'
				 AND VALID_YN = 'Y' 
				 AND ATTRIBUTE9 <> '-'		
			) AS [SITE]
			ON	PLANT.COMPANY_ID			= [SITE].COMPANY_ID
			AND PLANT.DIVISION_ID			= [SITE].DIVISION_ID
			AND PLANT.PLANT_ID				= [SITE].PLANT_ID
			AND LINE.SCP_OPERATION_GROUP	= [SITE].OPERATION_GROUP
			JOIN 
			(
				SELECT * 
				FROM SCM_MST_SITE SI
				WHERE SITE_TYPE = 'PLANT'
				AND VALID_YN = 'Y' 
			) AS [R_SITE]
			ON [SITE].ATTRIBUTE9 = [R_SITE].SCM_SITE_ID

	
	-- 2023.01.02
	--SELECT @v_min_yyyymmdd = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](@p_program_id, @p_division_id, @p_plan_type, @p_operation_group, @p_seq);
	SELECT @v_min_yyyymmdd = replace(convert(char(10),dateadd(d,datepart(dw,GETDATE()) * -1 - 5,GETDATE()),120),'-',''); -- previous monday

	-- Model/NickName 조회여부 및 Plant, Line 추출
	IF (ISNULL(@p_nick_name,'')!='' OR ISNULL(@p_item_id,'')!='')
	BEGIN
		SET @v_item_input = 'Y';

		IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
		BEGIN
			INSERT INTO #TblDynamicPivot_SCP0013_PlantLine_By_Search
			SELECT distinct SCM_SITE_ID, line_id
			FROM scp_anl_production_plan A WITH(NOLOCK)
			WHERE 1=1
			AND division_id	         = @p_division_id
			AND operation_group      = @p_operation_group
			AND plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
			AND plan_type            = @p_plan_type
			AND seq				     = @p_seq
			AND LINE_ID				 != '*'
			/*AND ( (@p_nick_name=NULL OR @p_nick_name='') OR
				item_id              IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+@p_nick_name+'%')
			)
			AND ( (@p_item_id=NULL OR @p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))*/
			AND item_id IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, @p_nick_name))
			-- 2021/07/06 LWY
			UNION
			SELECT distinct SCM_SITE_ID, line_id
			FROM SCM_DNM_PRODUCT_RESULT_V A  WITH(NOLOCK)
			WHERE 1=1
			AND division_id	         = @p_division_id
			AND company_id IN (
											SELECT DISTINCT company_id  AS operation_id
											FROM SCM_MST_SITE  WITH(NOLOCK)
											WHERE 1=1
											AND ( @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) OR division_id = @p_division_id ) --div_commonization
											AND site_type   = 'PLANT'
											AND valid_yn    = 'Y'
											) 
			AND scp_operation_group  = @p_operation_group
			AND plan_date  >= @v_from_result
			AND plan_date  <  @v_to_result
			AND LINE_ID				 != '*'
			/*AND ( (@p_nick_name=NULL OR @p_nick_name='') OR
				item_id IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+@p_nick_name+'%')
			)
			AND ( (@p_item_id=NULL OR @p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))*/
			AND item_id IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, @p_nick_name))
			-- 2021/07/06 LWY
			-- E20260226-001691 YMH E20260226-001691 82 Div Virtual Plant 실적 구간 데이터 조회 기능조치를 위해 로직 시작
			-- 실적은 UI에서 보여지는 기준의 VP 정보로 반영되니 VP정보로 입력함.
			UNION
			SELECT SCM_SITE_ID , LINE_ID FROM #JV_ESS_MAP WHERE DIVISION_ID = @p_division_id
			-- E20260226-001691 YMH E20260226-001691 82 Div Virtual Plant 실적 구간 데이터 조회 기능조치를 위해 로직 끝
		END
		ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
		BEGIN
			INSERT INTO #TblDynamicPivot_SCP0013_PlantLine_By_Search
			SELECT distinct SCM_SITE_ID, line_id
			FROM hist_scp_anl_production_plan A WITH(NOLOCK)
			WHERE 1=1
			AND division_id	         = @p_division_id
			AND operation_group      = @p_operation_group
			AND plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
			AND plan_type            = @p_plan_type
			AND seq				     = @p_seq
			AND LINE_ID				 != '*'
			/*AND ( (@p_nick_name=NULL OR @p_nick_name='') OR
				item_id              IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+@p_nick_name+'%')
			)
			AND ( (@p_item_id=NULL OR @p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))*/
			AND item_id IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, @p_nick_name))
			UNION
			SELECT distinct SCM_SITE_ID, line_id
			FROM SCM_DNM_PRODUCT_RESULT_V A  WITH(NOLOCK)
			WHERE 1=1
			AND division_id	         = @p_division_id
			AND company_id IN (
											SELECT DISTINCT company_id  AS operation_id
											FROM SCM_MST_SITE  WITH(NOLOCK)
											WHERE 1=1
											AND ( @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) OR division_id = @p_division_id ) --div_commonization
											AND site_type   = 'PLANT'
											AND valid_yn    = 'Y'
											) 
			AND scp_operation_group  = @p_operation_group
			AND plan_date  >= @v_from_result
			AND plan_date  <  @v_to_result
			AND LINE_ID				 != '*'
			/*AND ( (@p_nick_name=NULL OR @p_nick_name='') OR
				item_id IN (
					SELECT distinct ITEM_ID
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					WHERE 1=1
					AND NICK_NAME IS NOT NULL
					AND NICK_NAME LIKE '%'+@p_nick_name+'%')
			)
			AND ( (@p_item_id=NULL OR @p_item_id='') OR item_id LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))*/
			AND item_id IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, @p_nick_name))
			-- E20260226-001691 YMH E20260226-001691 82 Div Virtual Plant 실적 구간 데이터 조회 기능조치를 위해 로직 시작
			UNION
			SELECT SCM_SITE_ID , LINE_ID FROM #JV_ESS_MAP WHERE DIVISION_ID = @p_division_id
			-- E20260226-001691 YMH E20260226-001691 82 Div Virtual Plant 실적 구간 데이터 조회 기능조치를 위해 로직 끝
		END;
	END


	-- Line Assign용 Plant, Line 추출
	IF (@p_line_assign='Y')
	BEGIN
		INSERT INTO #TblDynamicPivot_SCP0013_PlantLine_By_TT
		SELECT DISTINCT T.PLANT_SITE_ID AS SCM_SITE_ID, T.LINE_ID, T.PLANT_SITE_ID+T.LINE_ID+T.OPERATION_ID AS LINE_ASSIGN_KEY
		FROM scp_mst_tact_time T WITH(NOLOCK)
		JOIN scm_mst_site S WITH(NOLOCK)  ON T.division_id = S.division_id AND T.plant_site_id = S.scm_site_id AND S.OSP_YN='N' --외주 제외
		JOIN SCM_MST_LINE_SN LS WITH(NOLOCK)  ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=S.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
									AND LS.OPERATION_ID=T.OPERATION_ID AND LS.LINE_ID=T.LINE_ID AND LS.ACTIVE_FLAG='Y' -- 활성화 된 라인
		JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK)  ON V.ITEM_ID=T.ITEM_ID AND ISNULL(V.TCO_CELL_YN,'-')='N' -- TCO Cell 제외
		WHERE 1=1
		AND T.VALID_YN		= 'Y'
		--AND (@p_division_id IN ('EE','EE_UC') or T.DIVISION_ID	= @p_division_id)
		AND (@p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) or T.DIVISION_ID	= @p_division_id) --div_commonization
		AND T.OPERATION_ID	<> 'P5000' -- P5000공정 제외
		--AND ( (@p_item_id=NULL OR @p_item_id='') OR T.item_id LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))
		AND ( (@p_item_id=NULL OR @p_item_id='') OR T.item_id IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))
		-- 외주
		UNION ALL

		SELECT DISTINCT a.scm_site_id, '-' as LINE_ID, a.scm_site_id+'-'+b.vendor_code AS LINE_ASSIGN_KEY
		FROM scm_mst_site a WITH(NOLOCK)
		JOIN SCM_MST_VENDOR b WITH(NOLOCK)  ON a.plant_id = b.vendor_code
		JOIN SCM_MST_SITE_ITEM_PRIORITY c WITH(NOLOCK)  ON a.division_id = c.DIVISION_ID and a.scm_site_id = c.plant_site_id
		JOIN SCP_MST_OUTSOURCING_CAPA d WITH(NOLOCK)  ON a.division_id = d.division_id and a.scm_site_id = d.plant_site_id and c.item_id = d.item_id
		WHERE (@p_division_id='EE' or a.division_id = @p_division_id) --a.division_id = @p_division_id
		AND a.osp_yn ='Y' -- 외주
		-- ESS 외주 Pakcer Line 생산 Target 적용
		AND isnull(a.attribute1,'N') IN ('','N')
		AND a.valid_yn ='Y'
		AND c.valid_yn ='Y' -- Project Route
		--AND d.item_id LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ','))
		AND ( (@p_item_id=NULL OR @p_item_id='') OR d.item_id IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))

		-- ESS 외주 Pakcer Line 생산 Target 적용
		UNION ALL

		SELECT DISTINCT T.PLANT_SITE_ID AS SCM_SITE_ID, T.LINE_ID, T.PLANT_SITE_ID+T.LINE_ID+b.vendor_code AS LINE_ASSIGN_KEY
		FROM scp_mst_tact_time_osp T WITH(NOLOCK)
		JOIN scm_mst_site S WITH(NOLOCK)  ON T.division_id = S.division_id AND T.plant_site_id = S.scm_site_id AND S.OSP_YN='Y' AND ISNULL(S.ATTRIBUTE1,'N')='Y' AND S.VALID_YN='Y'
		JOIN SCM_MST_VENDOR b WITH(NOLOCK)  ON s.plant_id = b.vendor_code
		JOIN SCM_MST_LINE_OSP LS WITH(NOLOCK)  ON LS.DIVISION_ID=S.DIVISION_ID AND LS.SCM_SITE_ID=S.scm_site_id AND LS.VALID_YN='Y' AND T.LINE_ID=LS.LINE_ID
		WHERE 1=1
		AND T.VALID_YN		= 'Y'
		--AND (@p_division_id IN ('EE','EE_UC') or T.DIVISION_ID	= @p_division_id)
		AND (@p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) or T.DIVISION_ID	= @p_division_id) --div_commonization
		--AND T.item_id LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ','))
		AND ( (@p_item_id=NULL OR @p_item_id='') OR T.item_id IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')));
	END


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/

		CREATE TABLE #TblDynamicPivot_SCP0013_tmp (
			 DIVISION_ID				NVARCHAR(128)
			,PLAN_START_YYYYMMDD		NVARCHAR(128)
			,PLAN_TYPE					NVARCHAR(128)
			,SEQ						NVARCHAR(128)
			,OPERATION_GROUP			NVARCHAR(128)
			,SCM_SITE_ID				NVARCHAR(128)
			,ITEM_ID					NVARCHAR(128)
			,LINE_ID					NVARCHAR(128)
			,OPERATION_ID				NVARCHAR(128)
			,MEASURE					NVARCHAR(128)
			,YYYYMMDD					NVARCHAR(8)
			,QTY						NUMERIC(20,10)
			,CELL_QTY					NUMERIC(20,10)
			,SCM_SITE_ID2				NVARCHAR(128)
			,ORIGIN_DIVISION_ID			NVARCHAR(128)
			,ELECTRODE_TYPE				NVARCHAR(30)
			,CELL_TYPE_GROUP_CODE		NVARCHAR(128)
		)

		-- qty > 0 추출
		IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
		BEGIN
			INSERT INTO #TblDynamicPivot_SCP0013_tmp
			SELECT
				 a.DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,a.OPERATION_GROUP
				,SCM_SITE_ID
				,a.ITEM_ID
				,LINE_ID
				,OPERATION_ID
				,MEASURE
				,YYYYMMDD
				,QTY
				,CELL_QTY
				,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN LEFT(a.scm_site_id , LEN(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
				,ORIGIN_DIVISION_ID
				,a.ELECTRODE_TYPE
				,b.CELL_TYPE_GROUP_CODE

			FROM scp_anl_production_plan a WITH(NOLOCK)
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b  WITH(NOLOCK)
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group

			WHERE 1=1
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd
			AND a.division_id	       = @p_division_id
			AND a.operation_group      = @p_operation_group
			AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
			AND a.plan_type            = @p_plan_type
			AND a.seq				   = @p_seq
			AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			AND ( ( @p_cell_type_gr IS NULL OR    @p_cell_type_gr    ='' ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM dbo.String_Split(@p_cell_type_gr    ,',')) )
			and isnull(a.qty,0) > 0
			;

			-- 20240108 E20240104-001182 'PROD_PLAN_ENGINE_STD_JR' AS MEASURE 생성 부분 IF 문 밖으로 처리

		END
		ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
		BEGIN
			INSERT INTO #TblDynamicPivot_SCP0013_tmp
			SELECT
				 a.DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,a.OPERATION_GROUP
				,SCM_SITE_ID
				,a.ITEM_ID
				,LINE_ID
				,OPERATION_ID
				,MEASURE
				,YYYYMMDD
				,QTY
				,CELL_QTY
				,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN LEFT(a.scm_site_id , LEN(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
				,ORIGIN_DIVISION_ID
				,a.ELECTRODE_TYPE
				,b.CELL_TYPE_GROUP_CODE

			FROM hist_scp_anl_production_plan a	WITH(NOLOCK)
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b  WITH(NOLOCK)
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group
			WHERE 1=1
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd
			AND a.division_id	       = @p_division_id
			AND a.operation_group      = @p_operation_group
			AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
			AND a.plan_type            = @p_plan_type
			AND a.seq				   = @p_seq
			AND ( ( @p_scm_site_id IS NULL OR    @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			AND ( ( @p_cell_type_gr IS NULL OR    @p_cell_type_gr    ='' ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM dbo.String_Split(@p_cell_type_gr    ,',')) )
			and isnull(a.qty,0) > 0
			;
		END
		
        -- 20240108  E20240104-001182 IF 문 밖으로 처리 : START
		--PROD_PLAN_ENGINE 기준으로 전극단위 추가 및 계산
		--전극 단위 가 M 일때 QTY / LANE , EA 일때 QTY / (LANE * CELL_CF)
		--IF (@p_division_id = 'EE' and @p_operation_group = 'E')
		IF (@v_division_group = 'EE' and @p_operation_group = 'E') -- 20240108  E20240104-001182  @v_division_group 조건으로 변경
			BEGIN
				INSERT INTO #TblDynamicPivot_SCP0013_tmp
				SELECT    A.DIVISION_ID
						, A.PLAN_START_YYYYMMDD
						, A.PLAN_TYPE
						, A.SEQ
						, A.OPERATION_GROUP
						, A.SCM_SITE_ID
						, A.ITEM_ID
						, A.LINE_ID
						, A.OPERATION_ID
						, 'PROD_PLAN_ENGINE_STD_JR' AS MEASURE
						, A.YYYYMMDD
						, CASE
						    WHEN X.ITEM_UOM =  'M' THEN 
							    CASE
								    WHEN B.LANE_QTY  = 0  THEN A.QTY / 1.0
								    ELSE A.QTY / (B.LANE_QTY / CONVERT(NUMERIC(20, 10), ISNULL(F.ATTRIBUTE1, 1.0))) 
							    END
						    --	WHEN 'EA' THEN 
							    --CASE B.LANE_QTY 
							    --	WHEN 0 THEN (A.QTY / H.CELL_CF) / (1 / F.ATTRIBUTE1) 
							    --	ELSE (A.QTY / H.CELL_CF) / (B.LANE_QTY / F.ATTRIBUTE1)
							    --END 
						    WHEN X.ITEM_UOM =  'EA' THEN 
                                CASE
                                    WHEN F.ATTRIBUTE1 = '1'                           THEN A.QTY / ISNULL(FG.JOMBO_ROLL, ISNULL(FW.JOMBO_ROLL, 1.0)) / (1.0 / CONVERT(NUMERIC(20, 10), ISNULL(F.ATTRIBUTE1, 1.0)))
                                    WHEN F.ATTRIBUTE1 = '2' AND FW.JOMBO_ROLL IS NULL THEN A.QTY / ISNULL(FG.JOMBO_ROLL, 1.0)
                                END
						    ELSE QTY 
						  END AS QTY
						, 0 CELL_QTY
						, A.SCM_SITE_ID2
						, A.ORIGIN_DIVISION_ID
						, A.ELECTRODE_TYPE
						, A.CELL_TYPE_GROUP_CODE

				FROM	#TblDynamicPivot_SCP0013_tmp A
						LEFT JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B ON 
								A.ITEM_ID = B.ITEM_ID AND LANE_QTY <> 0
						--AND SUBSTRING(A.PLAN_START_YYYYMMDD,0,7) = B.MONTH
						AND B.MONTH   = @v_plan_month -- 20240108  E20240104-001182  당주가 속한 월 조건으로 변경
							AND A.LINE_ID = B.LINE_ID
						--LEFT JOIN (SELECT ITEM_UOM, MIN(DIVISION_ID) FROM SCM_MST_ITEM_SN X WITH(NOLOCK) ON A.ITEM_ID = X.ITEM_ID AND X.COMPANY_ID = 'C100' GROUP BY ITEM_UOM)
						LEFT JOIN (
									SELECT DISTINCT 
											  ITEM_ID
											, ITEM_UOM
											, MIN(DIVISION_ID) AS DIVISION_ID
									FROM	SCM_MST_ITEM_SN WITH(NOLOCK)
									WHERE	1=1 --COMPANY_ID = 'C100'
									GROUP BY ITEM_ID, ITEM_UOM
								  ) X ON 
								A.ITEM_ID = X.ITEM_ID
						LEFT JOIN SCP_MST_ITEM_CELL_CF H WITH(NOLOCK) ON 
								A.ITEM_ID = H.ITEM_ID --CELL
						LEFT JOIN (
                                    SELECT    A.SCM_SITE_ID
                                            , A.LINE_ID
                                            , A.ITEM_ID
                                            , A.ATTRIBUTE1
                                            , A.JOMBO_ROLL
                                    FROM    (
                                                SELECT    C.ITEM_ID
                                                        , C.VALUE    AS JOMBO_ROLL
                                                        , F.SEGMENT1 AS SCM_SITE_ID
                                                        , F.SEGMENT4 AS LINE_ID
                                                        , F.ATTRIBUTE1
                                                        , ROW_NUMBER() OVER (PARTITION BY     C.SITE_ID
                                                                                            , F.SEGMENT4
                                                                                            , C.ITEM_ID
                                                                             ORDER BY C.APPLY_DATE DESC) RN
                                                FROM    [dbo].[SCM_MST_ITEM_CONV_CALC_SN] C
                                                        INNER JOIN (
                                                                        SELECT    F.SEGMENT1
                                                                                , F.SEGMENT3
                                                                                , F.SEGMENT4
                                                                                , F.ATTRIBUTE1
                                                                        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL F WITH(NOLOCK)
                                                                        WHERE   1=1
                                                                            AND F.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%'
                                                                    ) F ON
                                                                C.FACTORY_ID = F.SEGMENT3
                                                WHERE   1=1
                                                    AND C.CATEGORY            = 'Jumbo Roll (cell/m)'
                                                    AND C.VERSION_TYPE        = 'MASS'
                                                    AND C.MAX_VER_FLAG        = 'Y'
                                            ) A
                                    WHERE   1=1
                                        AND A.RN = 1
                                  ) F ON
								A.SCM_SITE_ID = F.SCM_SITE_ID
							AND A.LINE_ID     = F.LINE_ID
							AND A.ITEM_ID     = F.ITEM_ID
						LEFT JOIN (
                                    SELECT    A.SCM_SITE_ID
                                            , A.LINE_ID
                                            , A.ITEM_ID
                                            , A.ATTRIBUTE1
                                            , A.JOMBO_ROLL
                                    FROM    (
                                                SELECT    C.ITEM_ID
                                                        , C.VALUE    AS JOMBO_ROLL
                                                        , F.SEGMENT1 AS SCM_SITE_ID
                                                        , F.SEGMENT4 AS LINE_ID
                                                        , F.ATTRIBUTE1
                                                        , ROW_NUMBER() OVER (PARTITION BY     C.SITE_ID
                                                                                            , F.SEGMENT4
                                                                                            , C.ITEM_ID
                                                                             ORDER BY C.APPLY_DATE DESC) RN
                                                FROM    [dbo].[SCM_MST_ITEM_CONV_CALC_SN] C
                                                        INNER JOIN (
                                                                        SELECT    F.SEGMENT1
                                                                                , F.SEGMENT3
                                                                                , F.SEGMENT4
                                                                                , F.ATTRIBUTE1
                                                                        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL F WITH(NOLOCK)
                                                                        WHERE   1=1
                                                                            AND F.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%'
                                                                    ) F ON
                                                                C.FACTORY_ID = F.SEGMENT3
                                                WHERE   1=1
                                                    AND C.CATEGORY            = 'Jumbo Roll (cell/m)'
                                                    AND C.VERSION_TYPE        = 'MASS'
                                                    AND C.MAX_VER_FLAG        = 'Y'
                                                    AND C.PROD_VERSION_TYPE   = 'GENERAL'
                                            ) A
                                    WHERE   1=1
                                        AND A.RN = 1
                                  ) FG ON
								A.SCM_SITE_ID = FG.SCM_SITE_ID
							AND A.LINE_ID     = FG.LINE_ID
							AND A.ITEM_ID     = FG.ITEM_ID
						LEFT JOIN (
                                    SELECT    A.SCM_SITE_ID
                                            , A.LINE_ID
                                            , A.ITEM_ID
                                            , A.ATTRIBUTE1
                                            , A.JOMBO_ROLL
                                    FROM    (
                                                SELECT    C.ITEM_ID
                                                        , C.VALUE    AS JOMBO_ROLL
                                                        , F.SEGMENT1 AS SCM_SITE_ID
                                                        , F.SEGMENT4 AS LINE_ID
                                                        , F.ATTRIBUTE1
                                                        , ROW_NUMBER() OVER (PARTITION BY     C.SITE_ID
                                                                                            , F.SEGMENT4
                                                                                            , C.ITEM_ID
                                                                             ORDER BY C.APPLY_DATE DESC) RN
                                                FROM    [dbo].[SCM_MST_ITEM_CONV_CALC_SN] C
                                                        INNER JOIN (
                                                                        SELECT    F.SEGMENT1
                                                                                , F.SEGMENT3
                                                                                , F.SEGMENT4
                                                                                , F.ATTRIBUTE1
                                                                        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL F WITH(NOLOCK)
                                                                        WHERE   1=1
                                                                            AND F.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%'
                                                                    ) F ON
                                                                C.FACTORY_ID = F.SEGMENT3
                                                WHERE   1=1
                                                    AND C.CATEGORY            = 'Jumbo Roll (cell/m)'
                                                    AND C.VERSION_TYPE        = 'MASS'
                                                    AND C.MAX_VER_FLAG        = 'Y'
                                                    AND C.PROD_VERSION_TYPE   = 'WIDE'
                                            ) A
                                    WHERE   1=1
                                        AND A.RN = 1
                                  ) FW ON
								A.SCM_SITE_ID = FW.SCM_SITE_ID
							AND A.LINE_ID     = FW.LINE_ID
							AND A.ITEM_ID     = FW.ITEM_ID
				WHERE	MEASURE = 'PROD_PLAN_ENGINE';
			END
        -- 20240108  E20240104-001182 IF 문 밖으로 처리 : END

		PRINT '1. Base Row.    '+CONVERT(CHAR(23), GETDATE(), 21)

--TESTING : NOK
--select * from #TblDynamicPivot_SCP0013_tmp;return;


		CREATE TABLE #TblDynamicPivot_SCP0013_key (
			 DIVISION_ID				NVARCHAR(128)
			,PLAN_START_YYYYMMDD		NVARCHAR(128)
			,PLAN_TYPE					NVARCHAR(128)
			,SEQ						NVARCHAR(128)
			,OPERATION_GROUP			NVARCHAR(128)
			,SCM_SITE_ID				NVARCHAR(128)
			,ITEM_ID					NVARCHAR(128)
			,LINE_ID					NVARCHAR(128)
			,OPERATION_ID				NVARCHAR(128)
			,MEASURE					NVARCHAR(128)
			,SCM_SITE_ID2				NVARCHAR(128)
			,ORIGIN_DIVISION_ID			NVARCHAR(128)
			,ELECTRODE_TYPE				NVARCHAR(30)
			,CELL_TYPE_GROUP_CODE		NVARCHAR(128)
		);

		IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
		BEGIN
			INSERT INTO #TblDynamicPivot_SCP0013_key
			SELECT distinct
		     a.DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,a.OPERATION_GROUP
			,SCM_SITE_ID
			,a.ITEM_ID
			,LINE_ID
			,OPERATION_ID
			,MEASURE
			,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN LEFT(a.scm_site_id , LEN(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
			,ORIGIN_DIVISION_ID
			,a.ELECTRODE_TYPE
			,b.CELL_TYPE_GROUP_CODE

			FROM scp_anl_production_plan a 	WITH(NOLOCK)
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b  WITH(NOLOCK)
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group
			WHERE 1=1
			AND a.yyyymmdd			  = @p_plan_start_yyyymmdd

			AND a.division_id	       = @p_division_id
			AND a.operation_group      = @p_operation_group
			AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
			AND a.plan_type            = @p_plan_type
			AND a.seq				   = @p_seq
			AND A.LINE_ID				 != '*'
			AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			AND ( ( @p_cell_type_gr IS NULL OR         @p_cell_type_gr         ='' ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM dbo.String_Split(@p_cell_type_gr    ,',')) )
			;

		END
		ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
		BEGIN
			INSERT INTO #TblDynamicPivot_SCP0013_key
			SELECT distinct
		     a.DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,a.OPERATION_GROUP
			,SCM_SITE_ID
			,a.ITEM_ID
			,LINE_ID
			,OPERATION_ID
			,MEASURE
			,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN LEFT(a.scm_site_id , LEN(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
			,ORIGIN_DIVISION_ID
			,a.ELECTRODE_TYPE
			,b.CELL_TYPE_GROUP_CODE

			FROM hist_scp_anl_production_plan a WITH(NOLOCK)
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM b  WITH(NOLOCK)
			ON a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group
			WHERE 1=1
			AND a.yyyymmdd			  = @p_plan_start_yyyymmdd

			AND a.division_id	       = @p_division_id
			AND a.operation_group      = @p_operation_group
			AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
			AND a.plan_type            = @p_plan_type
			AND a.seq				   = @p_seq
			AND A.LINE_ID				 != '*'
			AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			AND ( ( @p_line_id IS NULL OR         @p_line_id      ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			AND ( ( @p_cell_type_gr IS NULL OR         @p_cell_type_gr         ='' ) OR b.CELL_TYPE_GROUP_CODE         IN (SELECT token FROM dbo.String_Split(@p_cell_type_gr    ,',')) )
			;
		END



		PRINT '1.1 Base Row Key Find.    '+CONVERT(CHAR(23), GETDATE(), 21);

		insert into #TblDynamicPivot_SCP0013_tmp
		SELECT distinct a.DIVISION_ID
					,a.PLAN_START_YYYYMMDD
					,a.PLAN_TYPE
					,a.SEQ
					,a.OPERATION_GROUP
					,a.SCM_SITE_ID
					,a.ITEM_ID
					,a.LINE_ID
					,a.OPERATION_ID
					,a.MEASURE
					,o.basis_yyyymmdd as YYYYMMDD
					,0 as QTY
					,0 as CELL_QTY
					,a.SCM_SITE_ID2
					,a.ORIGIN_DIVISION_ID
					,a.ELECTRODE_TYPE
					,a.CELL_TYPE_GROUP_CODE
		FROM #TblDynamicPivot_SCP0013_key A
			 CROSS APPLY (  SELECT basis_yyyymmdd
							  FROM scm_sys_calendar_m  WITH(NOLOCK)
							--WHERE basis_yyyymmdd>=@v_from_yyyymmdd
							--  AND basis_yyyymmdd<=@v_to_yyyymmdd
							 where basis_yyyymmdd = @v_to_yyyymmdd
						)  o
		WHERE 1=1
		  AND NOT EXISTS (SELECT 'X'
							FROM #TblDynamicPivot_SCP0013_tmp B
						   WHERE B.SCM_SITE_ID=A.SCM_SITE_ID
							 AND B.ITEM_ID=A.ITEM_ID
							 AND B.LINE_ID=A.LINE_ID
							 AND B.OPERATION_ID=A.OPERATION_ID
							 AND B.MEASURE=A.MEASURE
							 AND B.YYYYMMDD = o.basis_yyyymmdd
						 )

						 and 'N' = @v_result_only
		;


		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_key') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_key;

		PRINT '1.2 Key Row Insert.    '+CONVERT(CHAR(23), GETDATE(), 21);


		--Working Time 추출
		SELECT DIVISION_ID
			   , PLANT_SITE_ID AS SCM_SITE_ID
			   , OPERATION_ID
			   , LINE_ID
			   , YYYYMMDD
			   , WORKING_TIME
		INTO #TblDynamicPivot_SCP0013_working_data
		FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @v_from_yyyymmdd, @v_to_yyyymmdd, @p_line_id)
		;

		PRINT '2. Working Time Base.    '+CONVERT(CHAR(23), GETDATE(), 21)

		--CREATE TABLE #TblDynamicPivot_SCP0013_working (
		--		 division_id			NVARCHAR(2)
		--		,scm_site_id			NVARCHAR(30)
		--		,operation_id			NVARCHAR(30)
		--		,line_id				NVARCHAR(50)
		--		,yyyymmdd				NVARCHAR(8)
		--		,working_time			INT
		--		--,week_yyyymm			NVARCHAR(10)
		--		--,yyyymm					NVARCHAR(6)
		--		--,week_working_time		INT
		--		--,month_working_time		INT
		--);

		--INSERT INTO #TblDynamicPivot_SCP0013_working
		--select a.division_id
		--     , a.scm_site_id
		--	 , a.operation_id
		--	 , a.line_id
		--	 , a.yyyymmdd
		--	 , a.working_time
		--	 --, b.week_yyyymm
		--	 --, left(a.yyyymmdd,6) as yyyymm
		--	 --, sum(working_time) over( partition by a.division_id, a.scm_site_id, a.operation_id, a.line_id, b.week_yyyymm) as week_working_time
		--	 --, sum(working_time) over( partition by a.division_id, a.scm_site_id, a.operation_id, a.line_id, left(b.basis_yyyymmdd,6)) as month_working_time
		--  --into #TblDynamicPivot_SCP0013_working
		--  from #TblDynamicPivot_SCP0013_working_data a
		----		, (SELECT basis_yyyymmdd , 'W_' + basis_yyyymm + iso_week as week_yyyymm , iso_yyyyww
		----			FROM scm_sys_calendar_m  WITH(NOLOCK)
		----			WHERE basis_yyyymmdd>= @v_from_yyyymmdd
		----			AND basis_yyyymmdd <= @v_to_yyyymmdd
		----		)b
		----where a.yyyymmdd = b.basis_yyyymmdd
  --       ;

		PRINT '2.1 Working Time.    '+CONVERT(CHAR(23), GETDATE(), 21)

		-- LINE 로드율 추출
		SELECT A.*
		INTO #TblDynamicPivot_SCP0013_load
		FROM (
			-- LINE_TOTAL_LOAD_AMEND 추가
			SELECT distinct
					a.division_id
					,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
					,@p_plan_type AS PLAN_TYPE
					,@p_seq AS PLAN_SEQ
					,a.operation_group
					,a.scm_site_id	,'-' as item_id	,a.operation_id	,a.line_id
					,'LINE_TOTAL_LOAD_AMEND' AS measure
					, CASE WHEN d.working_time <= 0.0 THEN 0
							ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						END AS qty
					, ISNULL(round(sum(a.qty * (e.tact_time/60)),0), 0) AS CAPA_TACT
					--, ISNULL( d.working_time ,0 ) AS working_time
					,@p_from_yyyymmdd AS from_yyyymmdd
					,'D_'+a.yyyymmdd AS yyyymmdd
					--,c.basis_yyyymm AS yyyymm
					--,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
					,ISNULL(NULLIF(a.origin_division_id,''),'-') origin_division_id
					,'-' electrode_type
					,'L' CELL_TYPE_GROUP_CODE
					--,'W_'+c.basis_yyyymm + c.iso_week AS week_yyyymmdd
					--,'M_'+c.basis_yyyymm  AS month_yyyymmdd
			FROM #TblDynamicPivot_SCP0013_tmp a
			--JOIN scm_sys_calendar_m c WITH(NOLOCK)  ON a.yyyymmdd = c.basis_yyyymmdd
			LEFT OUTER JOIN #TblDynamicPivot_SCP0013_working_data d  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
					and a.SCM_SITE_ID2=d.scm_site_id
					and a.line_id = d.line_id
					and a.yyyymmdd= d.yyyymmdd
			LEFT OUTER JOIN scp_anl_tact_time e WITH(NOLOCK)  ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
					and a.SCM_SITE_ID2=e.scm_site_id
					and a.line_id = e.line_id
					and a.item_id = e.item_id
					and a.yyyymmdd= e.yyyymmdd
			WHERE 1=1
			AND a.line_id			  <> '*'
			AND a.measure              = upper('PROD_PLAN_AMEND')
			GROUP BY a.division_id, a.operation_group		,a.scm_site_id		,a.operation_id		,a.line_id, a.yyyymmdd,
						d.working_time
						, a.origin_division_id
			UNION
			-- LINE_TOTAL_LOAD_ENGINE 추가
			SELECT distinct
						a.division_id
					,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
					,@p_plan_type AS PLAN_TYPE
					,@p_seq AS PLAN_SEQ
					,a.operation_group
					,a.scm_site_id	,'-' as item_id	,a.operation_id	,a.line_id
					,'LINE_TOTAL_LOAD_ENGINE' AS measure
					, CASE WHEN d.working_time <= 0.0 THEN 0
							ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						END AS qty
					, ISNULL(round(sum(a.qty * (e.tact_time/60)),0), 0) AS CAPA_TACT
					--, ISNULL( d.working_time ,0 ) AS working_time
					,@p_from_yyyymmdd AS from_yyyymmdd
					,'D_'+a.yyyymmdd AS yyyymmdd
					--,c.basis_yyyymm AS yyyymm
					--,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
					,ISNULL(NULLIF(a.origin_division_id,''),'-') origin_division_id
					,'-' electrode_type
					,'L' CELL_TYPE_GROUP_CODE
					--,'W_'+c.basis_yyyymm + c.iso_week AS week_yyyymmdd
					--,'M_'+c.basis_yyyymm  AS month_yyyymmdd
			FROM #TblDynamicPivot_SCP0013_tmp a
			--JOIN scm_sys_calendar_m c WITH(NOLOCK)  ON a.yyyymmdd = c.basis_yyyymmdd
			LEFT OUTER JOIN scp_anl_working_time d WITH(NOLOCK)  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
					and a.SCM_SITE_ID2 = d.scm_site_id
					and a.line_id = d.line_id
					and a.yyyymmdd= d.yyyymmdd
			LEFT OUTER JOIN scp_anl_tact_time e WITH(NOLOCK)  ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
					and a.SCM_SITE_ID2 = e.scm_site_id
					and a.line_id = e.line_id
					and a.item_id = e.item_id
					and a.yyyymmdd= e.yyyymmdd
			WHERE 1=1
			AND a.line_id			  <> '*'
			AND a.measure              = upper('PROD_PLAN_ENGINE')
			GROUP BY a.division_id, a.operation_group		,a.scm_site_id		,a.operation_id		,a.line_id, a.yyyymmdd ,
						d.working_time
						, origin_division_id
		) A

		PRINT '3. Line Load Base.    '+CONVERT(CHAR(23), GETDATE(), 21)

		-- 2022.08.31 start
		IF OBJECT_ID('tempdb..#ISUZU_SCP0013') IS NOT NULL
		  BEGIN
			  DROP TABLE #ISUZU_SCP0013;
		  END

		  -- Isuzu Item
		  SELECT A.ITEM_ID
		  INTO #ISUZU_SCP0013
		  FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)


		  INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
		  WHERE A.IS_YN = 'Y'
		  ;
		-- 2022.08.31 end


		/* 2022.10.31
		--생산실적 추출
		SELECT *
		INTO #TblDynamicPivot_SCP0013_Perfor
		    FROM(
				   SELECT  distinct
						 (CASE WHEN @p_division_id='EE' THEN 'EE' WHEN @p_division_id='EE_UC' THEN 'EE_UC' ELSE r.division_id END) AS division_id
		   				,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
						,@p_plan_type AS PLAN_TYPE
						,@p_seq AS PLAN_SEQ
   						,r.scp_operation_group as operation_group
   						,r.scm_site_id	,r.item_id	,r.operation_id
						,(case when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTRING(r.item_id,2,1) = 'T' or SUBSTRING(r.item_id,2,1) = 'I' or SUBSTRING(r.item_id,2,1) = 'D') then '-' else r.LINE_ID end) line_id
   						,'PROD_PLAN_ENGINE' AS measure
   						,r.actual_good_qty AS qty
						,@p_from_yyyymmdd AS from_yyyymmdd
						,'D_'+convert(nvarchar(8), r.plan_date,112)  AS yyyymmdd
						--,c.basis_yyyymm AS yyyymm
						--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
						,r.division_id as origin_division_id
						,ISNULL(NULLIF(r.electrode_type,''),'-') electrode_type
						,b.CELL_TYPE_GROUP_CODE
						,'' AS LINE_ASSIGN_KEY
				   --FROM SCM_DNM_product_result_v r
				   --FROM SCM_DNM_product_result_v_khj79 r
				   FROM SCM_DNM_PRODUCT_RESULT_V r WITH(NOLOCK)
				   --JOIN scm_sys_calendar_m c WITH(NOLOCK)  on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd
				   LEFT OUTER JOIN SCP_MST_FINAL_ITEM b WITH(NOLOCK)  on r.division_id = b.division_id and r.item_id = b.item_id and r.scp_operation_group = b.operation_group
				   WHERE 1=1
				     AND r.plan_date          >= convert(datetime, @v_from_result)
				     AND r.plan_date          < convert(datetime, @v_to_result )
				     AND ( @p_division_id IN ('EE','EE_UC') OR r.division_id = @p_division_id )
				     AND r.scp_operation_group =  @p_operation_group
					 AND ( LEFT(r.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
														SELECT segment1 AS operation_id
															FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
														WHERE lookup_type = 'SCP_PLAN_OPERATION'
															AND SEGMENT1 <> 'F6000'
															AND valid_yn    = 'Y')
							-- 2022.08.31 start
							OR (
                             LEFT(r.operation_id,5) = 'P5000'
                             AND EXISTS (
                                         SELECT 1
                                         FROM   #ISUZU_SCP0013 A
                                         WHERE  A.ITEM_ID = r.ITEM_ID
                                        )
                            )
							-- 2022.08.31 end

							OR r.operation_id IN (--외주PACKER의 업체코드
														SELECT plant_id  AS operation_id
														FROM SCM_MST_SITE  WITH(NOLOCK)
														WHERE 1=1
														AND ( @p_division_id IN ('EE','EE_UC') OR division_id = @p_division_id )
														AND site_type   = 'PLANT'
														AND osp_yn      = 'Y'
														AND valid_yn    = 'Y'
														) )
				     AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR r.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
					 AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type='' ) OR r.electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrode_type,',')) )
			) a
			where (( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
		;
		*/



	CREATE TABLE #TblDynamicPivot_SCP0013_Perfor
	(
			 division_id			 NVARCHAR(128)  NULL
			,plan_start_yyyymmdd     NVARCHAR(128)   NULL
			,PLAN_TYPE			     NVARCHAR(128)  NULL
			,PLAN_SEQ				 NVARCHAR(128)  NULL
			,operation_group		 NVARCHAR(128)  NULL
			,scm_site_id			 NVARCHAR(128)  NULL
			,item_id				 NVARCHAR(128) NULL
			,operation_id			 NVARCHAR(128)  NULL
			,line_id				 NVARCHAR(128)  NULL

			,measure				 NVARCHAR(128) NULL
			,qty					 numeric(20,10)
			,from_yyyymmdd			 NVARCHAR(8)  NULL
			,yyyymmdd				 NVARCHAR(10)  NULL
			,origin_division_id		 NVARCHAR(128)  NULL
			,electrode_type			 NVARCHAR(30)  NULL
			,CELL_TYPE_GROUP_CODE	 NVARCHAR(128)  NULL
			,LINE_ASSIGN_KEY		 NVARCHAR(128) NULL
	)

	--생산실적 추출
	IF @v_from_yyyymmdd > @v_from_result
		BEGIN -- 실적 보여줌


		INSERT INTo #TblDynamicPivot_SCP0013_Perfor
		(
			 division_id			 
			,plan_start_yyyymmdd     
			,PLAN_TYPE			     
			,PLAN_SEQ				 
			,operation_group		 
			,scm_site_id			 
			,item_id				 
			,operation_id			 
			,line_id				 
			,measure				 
			,qty					 
			,from_yyyymmdd			 
			,yyyymmdd				 
			,origin_division_id		 
			,electrode_type			 
			,CELL_TYPE_GROUP_CODE	 
			,LINE_ASSIGN_KEY		 		
		)
		SELECT *
		    FROM(

				   SELECT
				         --distinct
						 --(CASE WHEN @p_division_id='EE' THEN 'EE' WHEN @p_division_id='EE_UC' THEN 'EE_UC' ELSE r.division_id END) AS division_id
						 -- 20260126 E20260123-001747 YMH 하드코등 제거를 위해 기존로직 주석처리
						 /*
						 (CASE 
						  WHEN @p_division_id='EE' THEN 'EE' 
						  WHEN @p_division_id='EE_UC' THEN 'EE_UC' 
						  WHEN @p_division_id='EE_HM' THEN 'EE_HM' 
						  ELSE r.division_id 
						  END) AS division_id --div_commonization
						*/
						 -- 20260126 E20260123-001747 YMH 하드코등 제거를 위한 로직 추가.
						 @p_division_id AS division_id
		   				,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
						,@p_plan_type AS PLAN_TYPE
						,@p_seq AS PLAN_SEQ
   						,r.scp_operation_group as operation_group
   						,r.scm_site_id	,r.item_id	,r.operation_id
						,(case 
						when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTRING(r.item_id,2,1) = 'T' or SUBSTRING(r.item_id,2,1) = 'I' or SUBSTRING(r.item_id,2,1) = 'D') 
						then '-' 
						else r.LINE_ID 
						end
						) line_id
   						,'PROD_PLAN_ENGINE' AS measure
   						,isnull(sum(r.actual_good_qty),0) AS qty
						,@p_from_yyyymmdd AS from_yyyymmdd
						,'D_'+convert(nvarchar(8), r.plan_date,112)  AS yyyymmdd
						--,c.basis_yyyymm AS yyyymm
						--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
						,r.division_id as origin_division_id
						,ISNULL(NULLIF(r.electrode_type,''),'-') electrode_type
						,b.CELL_TYPE_GROUP_CODE
						,'' AS LINE_ASSIGN_KEY
				   --FROM SCM_DNM_product_result_v r
				   --FROM SCM_DNM_product_result_v_khj79 r
				   FROM SCM_DNM_PRODUCT_RESULT_V r WITH(NOLOCK)
				   --JOIN scm_sys_calendar_m c WITH(NOLOCK)  on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd
				   LEFT OUTER JOIN SCP_MST_FINAL_ITEM b WITH(NOLOCK)  on r.division_id = b.division_id and r.item_id = b.item_id and r.scp_operation_group = b.operation_group
				   WHERE 1=1
				     AND r.plan_date          >= convert(datetime, @v_from_result)
				     AND r.plan_date          < convert(datetime, @v_to_result )
				     --AND ( @p_division_id IN ('EE','EE_UC') OR r.division_id = @p_division_id )
					 AND ( @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) OR r.division_id = @p_division_id ) --div_commonization
				     AND r.company_id IN (
														SELECT DISTINCT company_id  AS operation_id
														FROM SCM_MST_SITE  WITH(NOLOCK)
														WHERE 1=1
														AND ( @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) OR division_id = @p_division_id ) --div_commonization
														AND site_type   = 'PLANT'
														AND valid_yn    = 'Y'
														) 
				     AND r.scp_operation_group =  @p_operation_group
					 AND ( LEFT(r.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
														SELECT segment1 AS operation_id
															FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
														WHERE lookup_type = 'SCP_PLAN_OPERATION'
															AND SEGMENT1 <> 'F6000'
															AND valid_yn    = 'Y')
							-- 2022.08.31 start
							OR (
                             LEFT(r.operation_id,5) = 'P5000'
                             AND EXISTS (
                                         SELECT 1
                                         FROM   #ISUZU_SCP0013 A
                                         WHERE  A.ITEM_ID = r.ITEM_ID
                                        )
                            )
							-- 2022.08.31 end

							OR r.operation_id IN (--외주PACKER의 업체코드
														SELECT plant_id  AS operation_id
														FROM SCM_MST_SITE  WITH(NOLOCK)
														WHERE 1=1
														--AND ( @p_division_id IN ('EE','EE_UC') OR division_id = @p_division_id )
														AND ( @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) OR division_id = @p_division_id ) --div_commonization
														AND site_type   = 'PLANT'
														AND osp_yn      = 'Y'
														AND valid_yn    = 'Y'
														) )
				     AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR r.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
					 AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type='' ) OR r.electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrode_type,',')) )
				group by
				         --(CASE WHEN @p_division_id='EE' THEN 'EE' WHEN @p_division_id='EE_UC' THEN 'EE_UC' ELSE r.division_id END)
						 -- 20260126 E20260123-001747 YMH 하드코등 제거를 위해 기존로직 주석처리
						 /*
						 (CASE 
						  WHEN @p_division_id='EE' THEN 'EE' 
						  WHEN @p_division_id='EE_UC' THEN 'EE_UC' 
						  WHEN @p_division_id='EE_HM' THEN 'EE_HM' 
						  ELSE r.division_id 
						  END) --div_commonization
						  */
   						 r.scp_operation_group
   						,r.scm_site_id
						,r.item_id
						,r.operation_id
						,(case when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTRING(r.item_id,2,1) = 'T' or SUBSTRING(r.item_id,2,1) = 'I' or SUBSTRING(r.item_id,2,1) = 'D') then '-' else r.LINE_ID end)
						,'D_'+convert(nvarchar(8), r.plan_date,112)
						,r.division_id
						,ISNULL(NULLIF(r.electrode_type,''),'-')
						,b.CELL_TYPE_GROUP_CODE


			) a
			WHERE  (( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			  AND A.origin_division_id in 									
	                (												
					select division_id 								
					from SCM_MST_DIVISION with(nolock)								
					where attribute4 in (								
									select attribute4				
									from SCM_MST_DIVISION with(nolock)				
									where division_id = @p_division_id				
									)				
					and attribute3 <> 'EE'								
	               ) --div_commonization	
		;

		-- E20260226-001691 YMH 82 Div Virtual Plant 실적 구간 데이터 조회 기능조치를 위해 로직 시작
		-- ESS 혼용생산 로직 처리를 위해 혼용생산 실적 정보 임시테이블(#TblDynamicPivot_SCP0013_Perfor_ESS_JV) 추가.
		SELECT
			 r.division_id AS division_id
			,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			,@p_plan_type AS PLAN_TYPE
			,@p_seq AS PLAN_SEQ
			,r.scp_operation_group as operation_group
			,r.scm_site_id	,r.item_id	,r.operation_id
			,(case 
			when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTRING(r.item_id,2,1) = 'T' or SUBSTRING(r.item_id,2,1) = 'I' or SUBSTRING(r.item_id,2,1) = 'D') 
			then '-' 
			else r.LINE_ID 
			end
			) line_id
			,'PROD_PLAN_ENGINE' AS measure
			,isnull(sum(r.actual_good_qty),0) AS qty
			,@p_from_yyyymmdd AS from_yyyymmdd
			,'D_'+convert(nvarchar(8), r.plan_date,112)  AS yyyymmdd
			--,c.basis_yyyymm AS yyyymm
			--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
			,r.division_id as origin_division_id
			,ISNULL(NULLIF(r.electrode_type,''),'-') electrode_type
			,b.CELL_TYPE_GROUP_CODE
			,'' AS LINE_ASSIGN_KEY
			INTO #TblDynamicPivot_SCP0013_Perfor_ESS_JV
		FROM SCM_DNM_PRODUCT_RESULT_V r WITH(NOLOCK)
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM B WITH(NOLOCK)  ON R.DIVISION_ID = B.DIVISION_ID AND R.ITEM_ID = B.ITEM_ID AND R.SCP_OPERATION_GROUP = B.OPERATION_GROUP
		WHERE 1=1
		AND r.plan_date          >= convert(datetime, @v_from_result)
		AND r.plan_date          < convert(datetime, @v_to_result )
		AND EXISTS 
		( 
				SELECT * FROM #JV_ESS_MAP AS ESS_MAP 
				WHERE ESS_MAP.LINK_DIVISION_ID = R.division_id
				AND ESS_MAP.LINK_COMPANY_ID = R.COMPANY_ID
				AND ESS_MAP.LINK_PLANT_ID = R.PLANT_ID
				AND ESS_MAP.LINK_SCM_SITE_ID = R.SCM_SITE_ID
				AND ESS_MAP.DIVISION_ID = @p_division_id -- E20260415-000894 타 DIVISION에서 ESS 실적 안나오게 수정.
		) 
		AND r.scp_operation_group =  @p_operation_group
		AND 
		( 
			LEFT(r.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
											SELECT segment1 AS operation_id
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
											WHERE lookup_type = 'SCP_PLAN_OPERATION'
											AND SEGMENT1 <> 'F6000'
											AND valid_yn    = 'Y'
										)
			-- 2022.08.31 start
			OR (
				LEFT(r.operation_id,5) = 'P5000'
				AND EXISTS (
					SELECT 1
					FROM   #ISUZU_SCP0013 A
					WHERE  A.ITEM_ID = r.ITEM_ID
				)
			)
			-- 2022.08.31 end

			OR r.operation_id IN (--외주PACKER의 업체코드
				SELECT plant_id  AS operation_id
				FROM SCM_MST_SITE  WITH(NOLOCK)
				WHERE 1=1
				--AND ( @p_division_id IN ('EE','EE_UC') OR division_id = @p_division_id )
				AND ( @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) OR division_id = @p_division_id ) --div_commonization
				AND site_type   = 'PLANT'
				AND osp_yn      = 'Y'
				AND valid_yn    = 'Y'
				) 
		)
		--AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR r.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) ) -- E20260415-000894 주석처리
		AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type='' ) OR r.electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrode_type,',')) )

		group by
		r.scp_operation_group
		,r.scm_site_id
		,r.item_id
		,r.operation_id
		,(case when r.division_id = '40' and r.scp_operation_group = 'A' and (SUBSTRING(r.item_id,2,1) = 'T' or SUBSTRING(r.item_id,2,1) = 'I' or SUBSTRING(r.item_id,2,1) = 'D') then '-' else r.LINE_ID end)
		,'D_'+convert(nvarchar(8), r.plan_date,112)
		,r.division_id
		,ISNULL(NULLIF(r.electrode_type,''),'-')
		,b.CELL_TYPE_GROUP_CODE


		-- 화면에 보이는 가상라인으로 JV혼용실적임시테이블 데이터 업데이트.
		UPDATE A
			SET   A.division_id				= B.DIVISION_ID
			    , A.SCM_SITE_ID				= B.SCM_SITE_ID
				, A.origin_division_id		= B.DIVISION_ID
				, A.LINE_ID					= B.LINE_ID
		FROM #TblDynamicPivot_SCP0013_Perfor_ESS_JV AS A
			JOIN #JV_ESS_MAP AS B
			ON	A.DIVISION_ID	= B.LINK_DIVISION_ID
			AND A.SCM_SITE_ID	= B.LINK_SCM_SITE_ID
			AND A.LINE_ID		= B.LINK_LINE_ID

		INSERT INTo #TblDynamicPivot_SCP0013_Perfor
		(
			 DIVISION_ID			 
			,PLAN_START_YYYYMMDD     
			,PLAN_TYPE			     
			,PLAN_SEQ				 
			,OPERATION_GROUP		 
			,SCM_SITE_ID			 
			,ITEM_ID				 
			,OPERATION_ID			 
			,LINE_ID				 
			,MEASURE				 
			,QTY					 
			,FROM_YYYYMMDD			 
			,YYYYMMDD				 
			,ORIGIN_DIVISION_ID		 
			,ELECTRODE_TYPE			 
			,CELL_TYPE_GROUP_CODE	 
			,LINE_ASSIGN_KEY		 		
		)
		SELECT * FROM #TblDynamicPivot_SCP0013_Perfor_ESS_JV AS A
		WHERE  (( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
		AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) ) -- E20260415-000894 scm_site_id 변경후 조회
		AND A.DIVISION_ID = @p_division_id -- E20260415-000894 타 DIVISION에서 ESS 실적 안나오게 수정.
		;

		-- E20260226-001691 YMH 82 Div Virtual Plant 실적 구간 데이터 조회 기능조치를 위해 로직 끝

		IF OBJECT_ID('tempdb..#ISUZU_SCP0013') IS NOT NULL
		DROP TABLE #ISUZU_SCP0013;
		END;


		PRINT '4. Prod Performance.    '+CONVERT(CHAR(23), GETDATE(), 21)

		--생산계획 추출
		SELECT distinct
			a.division_id
			,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			,@p_plan_type AS PLAN_TYPE
			,@p_seq AS PLAN_SEQ
			,a.operation_group
			,a.scm_site_id,a.item_id ,a.operation_id,a.line_id
			,a.measure
			,a.qty
			,@p_from_yyyymmdd AS from_yyyymmdd
			,'D_'+a.yyyymmdd AS yyyymmdd
			--,c.basis_yyyymm AS yyyymm
			--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
			,ISNULL(NULLIF(a.origin_division_id,''),'-') origin_division_id
			,ISNULL(NULLIF(a.electrode_type,''),'-') electrode_type
			,CELL_TYPE_GROUP_CODE
			,'' AS LINE_ASSIGN_KEY
		INTO #TblDynamicPivot_SCP0013_plan
		FROM #TblDynamicPivot_SCP0013_tmp a
		JOIN scm_mst_sheet_measure b WITH(NOLOCK)  on a.measure = b.column_name
		--JOIN scm_sys_calendar_m c WITH(NOLOCK)  on a.yyyymmdd = c.basis_yyyymmdd
		WHERE 1=1
		AND b.program_id           = @p_program_id
		AND b.sheet_name           = @p_sheet_name
		AND b.valid_yn		       = 'Y'
		AND a.measure			   in ( 'PROD_PLAN_AMEND' , 'PROD_PLAN_ENGINE' ,'ELEC_RTF', 'PROD_PLAN_ENGINE_STD_JR')
		AND ( @p_operation_group = 'A'  OR ISNULL(B.ATTRIBUTE1,'') <>'A')
		AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrode_type,',')) )

		PRINT '4.1 Prod Plna.    '+CONVERT(CHAR(23), GETDATE(), 21)

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/

	 SELECT
			 t.division_id+t.scm_site_id+t.plan_start_yyyymmdd+plan_type+convert(varchar,plan_seq) as cp_key
			,t.division_id + t.operation_group+ t.scm_site_id+ t.item_id+t.line_id + t.operation_id + t.origin_division_id + t.electrode_type as fix_key
			,t.division_id
			,t.plan_start_yyyymmdd
			,t.plan_type
			,t.plan_seq
-- PJ20257329 2025.09.01 변경전 --2021.10.25 Start kwon
-- PJ20257329 2025.09.01 변경전 			,(SELECT TOP 1 IIF(BOM.PARENT_ITEM_ID='*',BOM.MODEL_ID,BOM.PARENT_ITEM_ID) FROM SCM_MST_BOM_SN BOM
-- PJ20257329 2025.09.01 변경전 		       WHERE BOM.CHILD_ITEM_ID= t.ITEM_ID) AS PARENT_ITEM_ID
-- PJ20257329 2025.09.01 변경전 --2021.10.25 End
		------------------------------------------------------------------------------------------------------------
 		-- Start  : PJ20257329 2025.09.01 SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용
		--			UI에서 많은 양의 데이터를 조회하지 않기 때문에 기존 스칼라 서브 쿼리 형태 유지 
		------------------------------------------------------------------------------------------------------------
			,(SELECT TOP 1 IIF(BOM.PARENT_ITEM_ID='*' OR CM.SCP_EXC_YN = 'Y'
							  ,BOM.MODEL_ID
							  ,BOM.PARENT_ITEM_ID) 
				FROM SCM_MST_BOM_SN BOM WITH(NOLOCK)
					 INNER JOIN SCM_MST_ITEM_SN MM WITH(NOLOCK)	-- model
							 ON MM.COMPANY_ID	= BOM.COMPANY_ID
							AND MM.DIVISION_ID	= BOM.DIVISION_ID
							AND MM.SITE_ID		= BOM.SITE_ID
							AND MM.ITEM_ID		= BOM.MODEL_ID 
					 LEFT JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK)	-- parent가 '*'인 경우가 있음
							 ON IM.COMPANY_ID	= BOM.COMPANY_ID
							AND IM.DIVISION_ID	= BOM.DIVISION_ID
							AND IM.SITE_ID		= BOM.SITE_ID
							AND IM.ITEM_ID		= BOM.PARENT_ITEM_ID 
					 LEFT  JOIN SCM_MST_ITEM_CLASS_M CM			-- parent item class (SCP Exclude class 여부 참조) 
						     ON CM.CLASS_ID		= IM.ITEM_CLASS	
 		       WHERE BOM.CHILD_ITEM_ID= T.ITEM_ID
			   ORDER BY CASE WHEN MM.SCP_OPERATION_GROUP = 'E' THEN 1 
							 WHEN MM.SCP_OPERATION_GROUP = 'A' THEN 2
							 ELSE 9 END ) 
			  AS PARENT_ITEM_ID
		------------------------------------------------------------------------------------------------------------
		-- End  : PJ20257329 2025.09.01 SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용
		------------------------------------------------------------------------------------------------------------
			,t.operation_group
			,t.scm_site_id
			,t.operation_id
			,t.line_id
			,t.item_id
			,t.measure
			,m.column_label_name as measure_name
			,isnull(n.sort_order_no,m.sort_order_no ) AS sort_order_no
			,t.qty
			,t.from_yyyymmdd
			,t.yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			,t.origin_division_id
			,t.electrode_type
			,t.CELL_TYPE_GROUP_CODE
			,CASE X.ITEM_UOM WHEN 'EA' THEN CASE t.measure WHEN 'PROD_PLAN_AMEND' THEN 'EA'
															WHEN 'PROD_PLAN_ENGINE' THEN 'EA'
															WHEN 'PROD_PLAN_ENGINE_CELL_QTY' THEN 'EA'
															WHEN 'PROD_PLAN_ENGINE_STD_JR' THEN 'M'
															ELSE '' END
							 WHEN 'M' THEN CASE t.measure WHEN 'PROD_PLAN_AMEND' THEN 'M'
							 								WHEN 'PROD_PLAN_ENGINE' THEN 'M'
							 								WHEN 'PROD_PLAN_ENGINE_CELL_QTY' THEN 'EA'
							 								WHEN 'PROD_PLAN_ENGINE_STD_JR' THEN 'M'
							 								ELSE '' END
							 ELSE X.ITEM_UOM END UNIT
	 INTO  #TblDynamicPivot_SCP0013

	 FROM (
			 --생산계획
		  SELECT division_id
				,plan_start_yyyymmdd
				,PLAN_TYPE
				,PLAN_SEQ
				,operation_group
				,scm_site_id
				,item_id
				,operation_id
				,line_id
				,measure
				,qty
				,from_yyyymmdd
				,yyyymmdd
				--,yyyymm
				--,iso_week
				,origin_division_id
				,electrode_type
				,CELL_TYPE_GROUP_CODE
				,LINE_ASSIGN_KEY
			FROM #TblDynamicPivot_SCP0013_plan

		   UNION
		   --CELL 환산수량
		   SELECT DISTINCT
				 a.division_id
				,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
				,@p_plan_type AS PLAN_TYPE
				,@p_seq AS PLAN_SEQ
				,a.operation_group
				,a.scm_site_id,a.item_id ,a.operation_id,a.line_id
				,'PROD_PLAN_ENGINE_CELL_QTY' AS measure
				,a.CELL_QTY as qty
				,@p_from_yyyymmdd AS from_yyyymmdd
				,'D_'+a.yyyymmdd AS yyyymmdd
				--,c.basis_yyyymm AS yyyymm
				--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
				,ISNULL(NULLIF(a.origin_division_id,''),'-') origin_division_id
				,ISNULL(NULLIF(a.electrode_type,''),'-') electrode_type
				,CELL_TYPE_GROUP_CODE
				,'' AS LINE_ASSIGN_KEY
			FROM #TblDynamicPivot_SCP0013_tmp a
			JOIN scm_mst_sheet_measure b WITH(NOLOCK)  on a.measure = b.column_name
			--JOIN scm_sys_calendar_m c WITH(NOLOCK)  on a.yyyymmdd = c.basis_yyyymmdd
			WHERE 1=1
			AND b.program_id           = @p_program_id
			AND b.sheet_name           = @p_sheet_name
			AND b.valid_yn		       = 'Y'
			AND a.measure			   = 'PROD_PLAN_ENGINE'
			AND ( @p_operation_group = 'A'  OR ISNULL(B.ATTRIBUTE1,'') <>'A')
			AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrode_type,',')) )
			AND @p_operation_group = 'E'
		   UNION
		   -- 생산 실적 (PROD_PLAN_ENGINE)
		   SELECT division_id
				  , plan_start_yyyymmdd
				  , PLAN_TYPE
				  , PLAN_SEQ
				  , operation_group
				  , scm_site_id
				  , item_id
				  , operation_id
				  , line_id
				  , 'PROD_PLAN_ENGINE' AS measure
				  , qty
				  , from_yyyymmdd
				  , yyyymmdd
				  --, yyyymm
				  --, iso_week
				  , origin_division_id
				  , electrode_type
				  , CELL_TYPE_GROUP_CODE
				  , LINE_ASSIGN_KEY
		   FROM #TblDynamicPivot_SCP0013_Perfor
		   UNION
		   -- 생산 실적 (PROD_PLAN_ENGINE_CELL_QTY) 셀 환산수량
		   SELECT a.division_id
				  , a.plan_start_yyyymmdd
				  , a.PLAN_TYPE
				  , a.PLAN_SEQ
				  , a.operation_group
				  , a.scm_site_id
				  , a.item_id
				  , a.operation_id
				  , a.line_id
				  , 'PROD_PLAN_ENGINE_CELL_QTY' AS measure
				  --, a.qty
				  ,ISNULL(a.qty,0.00)
                    * ( SELECT ISNULL( MIN(Y.CONVERT_QTY_CELL),1)
                          FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
                         WHERE Y.ITEM_ID    = a.item_id
                           AND Y.CONVERT_QTY_CELL IS NOT NULL ) AS qty
				  , a.from_yyyymmdd
				  , a.yyyymmdd
				  --, a.yyyymm
				  --, a.iso_week
				  , a.origin_division_id
				  , a.electrode_type
				  , a.CELL_TYPE_GROUP_CODE
				  , a.LINE_ASSIGN_KEY
		   FROM #TblDynamicPivot_SCP0013_Perfor a
		   WHERE @p_operation_group = 'E'
		   UNION
		   -- 생산 실적 (PROD_PLAN_AMEND)
		   SELECT a.division_id
				  , a.plan_start_yyyymmdd
				  , a.PLAN_TYPE
				  , a.PLAN_SEQ
				  , a.operation_group
				  , a.scm_site_id
				  , a.item_id
				  , a.operation_id
				  , a.line_id
				  , 'PROD_PLAN_AMEND' AS measure
				  , a.qty
				  , a.from_yyyymmdd
				  , a.yyyymmdd
				  --, a.yyyymm
				  --, a.iso_week
				  , a.origin_division_id
				  , a.electrode_type
				  , a.CELL_TYPE_GROUP_CODE
				  , a.LINE_ASSIGN_KEY
		   FROM #TblDynamicPivot_SCP0013_Perfor a

			UNION

			SELECT a.division_id
					,a.plan_start_yyyymmdd
					,a.PLAN_TYPE
					,a.PLAN_SEQ
					,a.operation_group
					,a.scm_site_id
					,a.item_id
					,a.operation_id
					,a.line_id
					,a.measure
					,a.qty
					,a.from_yyyymmdd
					,a.yyyymmdd
					--,a.yyyymm
					--,a.iso_week
					,a.origin_division_id
					,a.electrode_type
					,a.CELL_TYPE_GROUP_CODE
					,a.scm_site_id+a.line_id+a.operation_id AS LINE_ASSIGN_KEY
			FROM #TblDynamicPivot_SCP0013_load a
			--join (select distinct line_id, scm_site_id, month_working_time , operation_id, YYYYMMDD
			--			from #TblDynamicPivot_SCP0013_working   ) b
			--		on a.yyyymmdd = b.yyyymmdd
			--		and a.line_id = b.line_id
			--		and	a.SCM_SITE_ID = b.SCM_SITE_ID
			--		and a.operation_id = b.operation_id

		) T
		JOIN scm_sys_calendar_m c WITH(NOLOCK)  on RIGHT(T.yyyymmdd, 8) = c.basis_yyyymmdd
		LEFT JOIN scm_mst_sheet_measure m WITH(NOLOCK)  on t.measure = m.column_name
		LEFT OUTER JOIN	scm_mst_titleset_user n WITH(NOLOCK)  ON n.program_id  = m.program_id
										   AND n.sheet_name  = m.sheet_name
										   AND n.column_name = m.column_name
										   AND n.user_id     = @p_user_id
		--LEFT JOIN scm_mst_item_sn X WITH(NOLOCK) ON  t.division_id = x.division_id AND T.ITEM_ID = X.ITEM_ID AND X.COMPANY_ID = 'C100'
          LEFT JOIN (SELECT DISTINCT ITEM_ID
          			      , ITEM_UOM
          			      , MIN(DIVISION_ID) AS DIVISION_ID
          			   FROM SCM_MST_ITEM_SN WITH(NOLOCK)
          			  WHERE 1=1 --COMPANY_ID = 'C100'
          			  GROUP BY ITEM_ID, ITEM_UOM) X ON T.ITEM_ID = X.ITEM_ID
		WHERE 1=1
		AND m.valid_yn		       = 'Y'
		AND m.program_id           = @p_program_id
		AND m.sheet_name           = @p_sheet_name
		AND ( @p_operation_group = 'A'  OR ISNULL(m.ATTRIBUTE1,'') <>'A')
		AND ( @v_cnt_usr_measure = 0
					OR EXISTS (SELECT 1
								 FROM scm_mst_titleset_user WITH(NOLOCK)
								WHERE program_id  = @p_program_id
								  AND sheet_name  = @p_sheet_name
								  AND user_id     = @p_user_id
								  AND column_name = m.column_name)
				  )
        AND ( ( @p_line_id IS NULL OR @p_line_id ='' ) OR t.line_id IN (SELECT token FROM dbo.String_Split(@p_line_id,',')) )



		AND (
				( @v_item_input ='N' )
				OR t.scm_site_id+t.line_id IN (SELECT scm_site_id+line_id FROM #TblDynamicPivot_SCP0013_PlantLine_By_Search)

				OR ( t.LINE_ASSIGN_KEY IN (SELECT LINE_ASSIGN_KEY FROM #TblDynamicPivot_SCP0013_PlantLine_By_TT)
						AND t.measure in ('LINE_TOTAL_LOAD_ENGINE','LINE_TOTAL_LOAD_AMEND')
				   )
			)
		;


		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_PlantLine_By_Search') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_PlantLine_By_Search;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_PlantLine_By_TT') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_PlantLine_By_TT;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_load') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_load;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_Perfor') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_Perfor;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_plan') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_plan;


		PRINT '5. OutDataSet.    '+CONVERT(CHAR(23), GETDATE(), 21)

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/
		BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);
		DECLARE @mQry_field NVARCHAR(MAX);


		SET @mQuery = '';
		SET @mQry_field = '';





		SELECT		 @mQry_field = @mQry_field + ', ISNULL(' + yyyymmdd + ', 0) AS ' + yyyymmdd
					--, @mQuery = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'isnull(SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  WHEN yyyymmdd != '''+yyyymmdd+'''	AND  a.measure not like ''LINE_TOTAL%'' AND yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END ), 0) AS ' + yyyymmdd
					--						WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'isnull(SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  WHEN yyyymmdd != '''+yyyymmdd+'''	AND  a.measure not like ''LINE_TOTAL%'' AND iso_week = RIGHT('''+yyyymmdd+''',6) THEN  QTY  END ), 0) AS ' + yyyymmdd
					--						WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'isnull(SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  END ), 0) AS ' + yyyymmdd
									   --END +''+CHAR(10)


					  , @mQuery   = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY ELSE 0 END ) / IIF(MEASURE LIKE ''LINE_TOTAL%'', '+A.CNT+', 1) AS ' + yyyymmdd
													  WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN QTY ELSE 0 END ) / IIF(MEASURE LIKE ''LINE_TOTAL%'', '+A.CNT+', 1) AS ' + yyyymmdd
													  WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY ELSE 0 END ) AS ' + yyyymmdd
													 END +''+CHAR(10)

		FROM (

				SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
					, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
					, CONVERT(NVARCHAR(10),COUNT(1)) AS CNT
				FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				AND (@p_bucket= 'DAILY' OR @p_bucket = 'WEEKLY')
				GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

				UNION ALL

				SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
						,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						,CONVERT(NVARCHAR(10),COUNT(1)) AS CNT
				FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				GROUP BY a.basis_yyyymm, a.month_name

				UNION ALL

				SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
						, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
						, CONVERT(NVARCHAR(10),COUNT(1)) AS CNT
				FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				AND @p_bucket= 'DAILY'
				GROUP BY a.basis_yyyymmdd
		) AS A
		ORDER BY sort_order_no  ;

        
        --EXEC DEBUG_LOG @mQuery, 'T';RETURN; --chaan

		IF( LEN(@mQuery)>0)
			SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

			DECLARE @arr_cell_type_gr varchar(max)
			SELECT @arr_cell_type_gr     = ISNULL(@arr_cell_type_gr + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_cell_type_gr,',')

			IF @p_cell_type_gr is not null or @p_cell_type_gr != ''
				BEGIN
					SET @arr_cell_type_gr = @arr_cell_type_gr + ',''L''';
				END

			-- Extra Spec 조회조건 추가 2025-04-02 mrchois
			DECLARE @arr_extra_spec NVARCHAR(max)
			SELECT @arr_extra_spec     = ISNULL(@arr_extra_spec + ', ' + 'N''' + token +'''', 'N'''+token+'''')     FROM dbo.String_Split(@p_extra_spec,',')

			IF OBJECT_ID('tempdb..#TblLookUp_SCP0013') IS NOT NULL
			DROP TABLE #TblLookUp_SCP0013;

			SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2
			INTO #TblLookUp_SCP0013
			 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE 1 = 1
			AND LOOKUP_TYPE IN ('CELL_TYPE_GROUP_CODE','OPERATION_GROUP')

			DECLARE @arr_model_id VARCHAR(MAX);

			SELECT @arr_model_id	= ISNULL(@arr_model_id	+ ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_model_id,',')


			----------------------------------------------------------------------
			-- RESULT 1
			----------------------------------------------------------------------
			SET @mEXEC = N'
	            IF OBJECT_ID(''tempdb..#tblSCP0013_RAW_TEMP'') IS NOT NULL
		            DROP TABLE #tblSCP0013_RAW_TEMP;

				SELECT	  A.CP_KEY,FIX_KEY
						, A.DIVISION_ID
						, A.OPERATION_GROUP
						, A.SCM_SITE_ID
						, A.LINE_ID
						, A.PARENT_ITEM_ID
						, DBO.FN_GET_ITEM_PROD_OP(A.DIVISION_ID,A.OPERATION_GROUP, A.ITEM_ID) AS MODEL_ID
						, A.ITEM_ID
						, A.MEASURE
						, A.MEASURE_NAME
						, A.OPERATION_ID,A.PLAN_TYPE, A.PLAN_SEQ, A.PLAN_START_YYYYMMDD,A.FROM_YYYYMMDD,A.SORT_ORDER_NO
						, A.ORIGIN_DIVISION_ID
						, A.ELECTRODE_TYPE
						, A.CELL_TYPE_GROUP_CODE
						, A.UNIT'
						+ @mQuery + '
                INTO    #tblSCP0013_RAW_TEMP
				FROM	#TblDynamicPivot_SCP0013 A
				WHERE	1=1
					AND A.ORIGIN_DIVISION_ID NOT IN (SELECT DIVISION_ID FROM DBO.FN_GET_DIVISION_DIV(''EE''))	--div_commonization
				GROUP BY	  A.CP_KEY
							, A.FIX_KEY
							, A.DIVISION_ID
							, A.OPERATION_GROUP
							, A.SCM_SITE_ID
							, A.LINE_ID 
							, A.PARENT_ITEM_ID
							, A.ITEM_ID
							, A.MEASURE
							, A.MEASURE_NAME
							, A.OPERATION_ID
							, A.PLAN_TYPE
							, A.PLAN_SEQ
							, A.PLAN_START_YYYYMMDD
							, A.FROM_YYYYMMDD
							, A.SORT_ORDER_NO
							, A.ORIGIN_DIVISION_ID
							, A.ELECTRODE_TYPE
							, A.CELL_TYPE_GROUP_CODE
							, A.UNIT;


	            IF OBJECT_ID(''tempdb..#tblSCP0013_RAW'') IS NOT NULL
		            DROP TABLE #tblSCP0013_RAW;


			    SELECT	  (
						    SELECT TOP 1 
								    X.SITE_DESCRIPTION 
						    FROM	SCM_MST_SITE X WITH (NOLOCK) 
						    WHERE	1=1 
							    AND X.SCM_SITE_ID = A.SCM_SITE_ID
						    ) AS SCM_SITE_DESCRIPTION
					    , (
						    SELECT TOP 1 
								    DIVISION_NAME 
						    FROM	SCM_MST_DIVISION WITH(NOLOCK) 
						    WHERE	1=1 
							    AND DIVISION_ID = A.DIVISION_ID
						    ) AS DIVISION_NAME
					    , (
						    SELECT TOP 1 
								    ISNULL(NICK_NAME, '''') 
						    FROM	SCM_MST_ITEM_SN WITH(NOLOCK) 
						    WHERE	1=1 
							    AND ITEM_ID = A.ITEM_ID 
							    AND NICK_NAME IS NOT NULL 
						    ) AS NICK_NAME
					    , (
						    SELECT TOP 1 CELL_ITEM_ID
						    FROM	DBO.SCP_MST_FINAL_ITEM X with (nolock)   
						    WHERE	1=1 
							    AND X.DIVISION_ID = A.ORIGIN_DIVISION_ID 
							    AND X.ITEM_ID = A.ITEM_ID
						    ) AS CELL_ID
					    , (
						    SELECT TOP 1 
								    ISNULL(NULLIF(SCP_EXTRA_SPEC,''''),''-'') 
						    FROM	DBO.SCM_MST_ITEM_SN X  
						    WHERE	1=1 
							    AND X.DIVISION_ID = ''40'' 
							    AND X.DIVISION_ID = A.DIVISION_ID 
							    AND X.ITEM_ID = A.ITEM_ID
						    )	AS EXTRA_SPEC
					    , A.*
                INTO    #tblSCP0013_RAW
			    FROM	#tblSCP0013_RAW_TEMP A;


				SELECT	  ISNULL(B.SEGMENT2,''-'') AS CELL_TYPE_GROUP_CODE
						, ISNULL(C.SEGMENT2,''-'') OPERATION_GROUP_NAME
						, T.*
				FROM	#tblSCP0013_RAW T
						LEFT OUTER JOIN #TBLLOOKUP_SCP0013 B ON
								B.LOOKUP_TYPE = ''CELL_TYPE_GROUP_CODE'' 
							AND B.SEGMENT1 = T.CELL_TYPE_GROUP_CODE
						LEFT OUTER JOIN #TBLLOOKUP_SCP0013 C ON 
								C.LOOKUP_TYPE = ''OPERATION_GROUP'' 
							AND C.SEGMENT1 = T.OPERATION_GROUP
				WHERE	1=1';


			IF NOT(@p_cell_type_gr IS NULL OR  @p_cell_type_gr    ='')
			BEGIN
				SET @mEXEC = @mEXEC + N'
						AND (ISNULL(T.CELL_TYPE_GROUP_CODE,''L'')  IN ('+@arr_cell_type_gr+'))';
			END;

			IF (NOT(@p_model_id IS NULL OR @p_model_id =''))
			BEGIN
				SET @mEXEC = @mEXEC + N'
						AND MODEL_ID IN ('+@arr_model_id+')';
			END;

			-- Extra Spec 조회조건 추가 2025-04-02 mrchois
			IF (NOT(@p_extra_spec IS NULL OR @p_extra_spec =''))
			BEGIN
				SET @mEXEC = @mEXEC + N'
						AND T.EXTRA_SPEC IN ('+@arr_extra_spec+')';
			END;


			SET @mEXEC = @mEXEC + N'
					ORDER BY	  T.DIVISION_ID
								, T.OPERATION_GROUP
								, T.SCM_SITE_ID
								, T.LINE_ID 
								, T.OPERATION_ID 
								, T.PARENT_ITEM_ID DESC
								, T.ITEM_ID DESC
								, T.SORT_ORDER_NO ASC';

--TESTING : OK
--exec debug_log @mEXEC, 'T';return;

            EXEC (@mEXEC);


			IF OBJECT_ID('tempdb..#TblLookUp_SCP0013') IS NOT NULL
			DROP TABLE #TblLookUp_SCP0013;

			IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013;

			PRINT '6. OutDataSet Pivot.    '+CONVERT(CHAR(23), GETDATE(), 21)

			IF @p_bucket= 'DAILY'
			BEGIN

				----------------------------------------------------------------------
				-- RESULT 2, DAILY
				----------------------------------------------------------------------
			SELECT   division_id
					,operation_group
					,scm_site_id
					,item_id
					,line_id
					,operation_id
					--,division_id + operation_group + scm_site_id + item_id + line_id + operation_id + ISNULL(NULLIF(origin_division_id,''),'-') + ISNULL(NULLIF(electrode_type,''),'-') as fix_key
					--,'D_'+yyyymmdd AS yyyymmdd
					--,'W_'+b.basis_yyyymm + iso_week AS	yyyymm_week
					--,ISNULL(NULLIF(origin_division_id,''),'-') origin_division_id
					--,ISNULL(NULLIF(electrode_type,''),'-') electrode_type

					,'' as fix_key
					,yyyymmdd
					,b.basis_yyyymm as basis_yyyymm
					,iso_week
					,ISNULL(NULLIF(origin_division_id,''),'-') origin_division_id
					,ISNULL(NULLIF(electrode_type,''),'-') electrode_type

				FROM dbo.SCP_ANL_PRODUCTION_PLAN_FIX A  WITH(NOLOCK)    --WITH(NOLOCK INDEX(IX01_SCP_ANL_PRODUCTION_PLAN_FIX))
				    INNER JOIN scm_sys_calendar_m B WITH(NOLOCK)  ON A.yyyymmdd =B.BASIS_YYYYMMDD
				WHERE 1=1
				AND a.yyyymmdd			  >= @p_from_yyyymmdd
				AND a.yyyymmdd			  <= @p_to_yyyymmdd
				AND a.division_id	       = @p_division_id
				AND a.operation_group      = @p_operation_group
				AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
				AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
				AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrode_type,',')) )
			   --ORDER BY fix_key,yyyymmdd


			END

			ELSE
			BEGIN

				----------------------------------------------------------------------
				-- RESULT 2, NO DAILY
				----------------------------------------------------------------------
				SELECT DISTINCT division_id
					,operation_group
					,scm_site_id
					,item_id
					,line_id
					,operation_id
					--,division_id + operation_group + scm_site_id + item_id + line_id + operation_id + ISNULL(NULLIF(origin_division_id,''),'-') + ISNULL(NULLIF(electrode_type,''),'-') as fix_key
					--,'D_'+yyyymmdd AS yyyymmdd
					--,'W_'+b.basis_yyyymm + iso_week AS	yyyymm_week
					--,ISNULL(NULLIF(origin_division_id,''),'-') origin_division_id
					--,ISNULL(NULLIF(electrode_type,''),'-') electrode_type

					,'' as fix_key
					--,yyyymmdd
					,b.basis_yyyymm as basis_yyyymm
					,iso_week
					,ISNULL(NULLIF(origin_division_id,''),'-') origin_division_id
					,ISNULL(NULLIF(electrode_type,''),'-') electrode_type

				FROM dbo.SCP_ANL_PRODUCTION_PLAN_FIX A  WITH(NOLOCK)    --WITH(NOLOCK INDEX(IX01_SCP_ANL_PRODUCTION_PLAN_FIX))
				    INNER JOIN scm_sys_calendar_m B WITH(NOLOCK)  ON A.yyyymmdd =B.BASIS_YYYYMMDD
				WHERE 1=1
				AND a.yyyymmdd			  >= @p_from_yyyymmdd
				AND a.yyyymmdd			  <= @p_to_yyyymmdd
				AND a.division_id	       = @p_division_id
				AND a.operation_group      = @p_operation_group
				AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
				AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
				AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type='' ) OR a.electrode_type IN (SELECT token FROM dbo.String_Split(@p_electrode_type,',')) )
			   --ORDER BY fix_key,yyyymmdd
			END
			;


			PRINT '7. Fix Data.    '+CONVERT(CHAR(23), GETDATE(), 21)

			-----------------------------------------------------------------------------------

			-- 2023/06/12 begin
			IF OBJECT_ID('tempdb..#TMP_WEEK_SCP0013') IS NOT NULL
			BEGIN
				DROP TABLE #TMP_WEEK_SCP0013;
			END

			IF OBJECT_ID('tempdb..#TMP_WEEK_CNT_SCP0013') IS NOT NULL
			BEGIN
				DROP TABLE #TMP_WEEK_CNT_SCP0013;
			END

			IF OBJECT_ID('tempdb..#TMP_WEEK_RATIO_SCP0013') IS NOT NULL
			BEGIN
				DROP TABLE #TMP_WEEK_RATIO_SCP0013;
			END

			IF OBJECT_ID('tempdb..#TMP_MONTH_SCP0013') IS NOT NULL
			BEGIN
				DROP TABLE #TMP_MONTH_SCP0013;
			END

			IF OBJECT_ID('tempdb..#TMP_MONTH_CNT_SCP0013') IS NOT NULL
			BEGIN
				DROP TABLE #TMP_MONTH_CNT_SCP0013;
			END

			IF OBJECT_ID('tempdb..#TMP_MONTH_RATIO_SCP0013') IS NOT NULL
			BEGIN
				DROP TABLE #TMP_MONTH_RATIO_SCP0013;
			END


		------------------------------------------------------
		-- weekly :: working_time = 0 제외 cnt
		------------------------------------------------------

		SELECT   a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				,a.measure
				,'W_'+b.basis_yyyymm + b.iso_week AS yyyymmdd
				,SUM(ISNULL(A.QTY,0)) AS SUM_QTY
		into #TMP_WEEK_SCP0013
		FROM (
				-- LINE_TOTAL_LOAD_ENGINE
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_ENGINE' AS measure
						,@p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						,CASE WHEN d.working_time <= 0.0 THEN 0
							  ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						 END AS qty

						,case when isnull(d.WORKING_TIME,0) > 0 then 1 else 0 end as cnt


				FROM #TblDynamicPivot_SCP0013_tmp a
				LEFT OUTER JOIN scp_anl_working_time d WITH(NOLOCK)  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e WITH(NOLOCK)  ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2 = e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_ENGINE')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd ,d.working_time, origin_division_id

				UNION ALL

				-- LINE_TOTAL_LOAD_AMEND
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_AMEND' AS measure
						,@p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						, CASE WHEN d.working_time <= 0.0 THEN 0
							   ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
						  END AS qty

						, case when isnull(f.WORKING_TIME,0) > 0 then 1 else 0 end as cnt

				FROM #TblDynamicPivot_SCP0013_tmp a
				LEFT OUTER JOIN #TblDynamicPivot_SCP0013_working_data d  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2=d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e WITH(NOLOCK)  ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2=e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				LEFT OUTER JOIN scp_anl_working_time f WITH(NOLOCK)  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = f.scm_site_id
						and a.line_id = f.line_id
						and a.yyyymmdd= f.yyyymmdd


				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_AMEND')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd, d.working_time, a.origin_division_id, f.working_time


		) A
		LEFT JOIN scm_sys_calendar_m b on a.YYYYMMDD = b.BASIS_YYYYMMDD
		GROUP BY a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				--,a.YYYYMMDD
				,b.basis_yyyymm, b.iso_week
				,a.measure
		;

----------------------------------------
		select   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,sum(isnull(a.cnt,0)) as cnt
		  INTO #TMP_WEEK_CNT_SCP0013
		  from (
				select b.division_id
					  ,b.scm_site_id
					  ,b.operation_id
					  ,b.line_id
					  --,a.BASIS_YYYYMMDD
					  ,'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
					  ,case when isnull(b.WORKING_TIME,0) > 0 then 1 else 0 end as cnt
				from scm_sys_calendar_m a
				join scp_anl_working_time b on a.BASIS_YYYYMMDD = b.YYYYMMDD
					and b.DIVISION_ID = @p_division_id
					AND ( ( @p_scm_site_id IS NULL OR @p_scm_site_id ='' ) OR scm_site_id IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
					AND ( ( @p_line_id IS NULL OR @p_line_id ='' ) OR line_id IN (SELECT token FROM dbo.String_Split(@p_line_id,',')) )
				where 1 = 1
				and a.BASIS_YYYYMMDD between @p_from_yyyymmdd AND @p_to_yyyymmdd
			   ) a
		group by
			   a.division_id
			  ,a.scm_site_id
			  ,a.operation_id
			  ,a.line_id
			  ,a.yyyymmdd
		;
----------------------------------------

		SELECT   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,a.measure
				,isnull((a.SUM_QTY / b.cnt), 0) as ratio
		  INTO #TMP_WEEK_RATIO_SCP0013
		  FROM #TMP_WEEK_SCP0013 A
		  JOIN #TMP_WEEK_CNT_SCP0013 B
		    ON A.DIVISION_ID = B.DIVISION_ID
		   AND A.SCM_SITE_ID = B.SCM_SITE_ID
		   AND A.OPERATION_ID = B.OPERATION_ID
		   AND A.LINE_ID = B.LINE_ID
		   AND A.yyyymmdd = B.yyyymmdd
		;

		IF OBJECT_ID('tempdb..#TMP_WEEK_SCP0013') IS NOT NULL
		DROP TABLE #TMP_WEEK_SCP0013;
		
		IF OBJECT_ID('tempdb..#TMP_WEEK_CNT_SCP0013') IS NOT NULL
		DROP TABLE #TMP_WEEK_CNT_SCP0013;



		------------------------------------------------------
		-- monthly :: working_time = 0 제외 cnt
		------------------------------------------------------
		SELECT   a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				,a.measure
				,'M_'+b.basis_yyyymm AS yyyymmdd
				,SUM(ISNULL(A.QTY,0)) AS SUM_QTY

		into #TMP_MONTH_SCP0013

		FROM (
				-- LINE_TOTAL_LOAD_ENGINE
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_ENGINE' AS measure
						,@p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						,CASE WHEN d.working_time <= 0.0 THEN 0
								ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
							END AS qty

						,case when isnull(d.WORKING_TIME,0) > 0 then 1 else 0 end as cnt


				FROM #TblDynamicPivot_SCP0013_tmp a
				LEFT OUTER JOIN scp_anl_working_time d WITH(NOLOCK)  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e WITH(NOLOCK)  ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2 = e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_ENGINE')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd ,d.working_time, origin_division_id

				UNION ALL

				-- LINE_TOTAL_LOAD_AMEND
				SELECT distinct
						 a.division_id
						,a.scm_site_id
						,a.operation_id
						,a.line_id
						,'LINE_TOTAL_LOAD_AMEND' AS measure
						,@p_from_yyyymmdd AS from_yyyymmdd
						,a.yyyymmdd AS yyyymmdd

						, CASE WHEN d.working_time <= 0.0 THEN 0
								ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
							END AS qty

						, case when isnull(f.WORKING_TIME,0) > 0 then 1 else 0 end as cnt

				FROM #TblDynamicPivot_SCP0013_tmp a
				LEFT OUTER JOIN #TblDynamicPivot_SCP0013_working_data d  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2=d.scm_site_id
						and a.line_id = d.line_id
						and a.yyyymmdd= d.yyyymmdd
				LEFT OUTER JOIN scp_anl_tact_time e WITH(NOLOCK)  ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id
						and a.SCM_SITE_ID2=e.scm_site_id
						and a.line_id = e.line_id
						and a.item_id = e.item_id
						and a.yyyymmdd= e.yyyymmdd
				LEFT OUTER JOIN scp_anl_working_time f WITH(NOLOCK)  ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id
						and a.SCM_SITE_ID2 = f.scm_site_id
						and a.line_id = f.line_id
						and a.yyyymmdd= f.yyyymmdd


				WHERE 1=1
				AND a.line_id			  <> '*'
				AND a.measure              = upper('PROD_PLAN_AMEND')
				GROUP BY a.division_id, a.operation_group, a.scm_site_id, a.operation_id, a.line_id, a.yyyymmdd, d.working_time, a.origin_division_id, f.working_time


		) A
		LEFT JOIN scm_sys_calendar_m b on a.YYYYMMDD = b.BASIS_YYYYMMDD
		GROUP BY a.DIVISION_ID
				,a.SCM_SITE_ID
				,a.OPERATION_ID
				,a.LINE_ID
				--,a.YYYYMMDD
				,b.basis_yyyymm
				,a.measure
		;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_tmp') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_tmp;


		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_working_data') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0013_working_data;
--------------------------------------

		select   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,sum(isnull(a.cnt,0)) as cnt
		into #TMP_MONTH_CNT_SCP0013
		  from (
				select b.division_id
					  ,b.scm_site_id
					  ,b.operation_id
					  ,b.line_id
					  --,a.MONTH_NAME AS yyyymmdd
					  ,'M_'+a.basis_yyyymm AS yyyymmdd
					  ,case when isnull(b.WORKING_TIME,0) > 0 then 1 else 0 end as cnt
				from scm_sys_calendar_m a
				join scp_anl_working_time b on a.BASIS_YYYYMMDD = b.YYYYMMDD
					and b.DIVISION_ID = @p_division_id
					AND ( ( @p_scm_site_id IS NULL OR @p_scm_site_id ='' ) OR scm_site_id IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
					AND ( ( @p_line_id IS NULL OR @p_line_id ='' ) OR line_id IN (SELECT token FROM dbo.String_Split(@p_line_id,',')) )
				where 1 = 1
				and a.BASIS_YYYYMMDD between @p_from_yyyymmdd AND @p_to_yyyymmdd
			   ) a
		group by
			   a.division_id
			  ,a.scm_site_id
			  ,a.operation_id
			  ,a.line_id
			  ,a.yyyymmdd
		;

		SELECT   a.division_id
				,a.scm_site_id
				,a.operation_id
				,a.line_id
				,a.yyyymmdd
				,a.measure
				,isnull((a.SUM_QTY / b.cnt), 0) as ratio
		  INTO #TMP_MONTH_RATIO_SCP0013
		  FROM #TMP_MONTH_SCP0013 A
		  JOIN #TMP_MONTH_CNT_SCP0013 B
		    ON A.DIVISION_ID = B.DIVISION_ID
		   AND A.SCM_SITE_ID = B.SCM_SITE_ID
		   AND A.OPERATION_ID = B.OPERATION_ID
		   AND A.LINE_ID = B.LINE_ID
		   AND A.yyyymmdd = B.yyyymmdd
		;
		
		IF OBJECT_ID('tempdb..#TMP_MONTH_SCP0013') IS NOT NULL
		DROP TABLE #TMP_MONTH_SCP0013;

		IF OBJECT_ID('tempdb..#TMP_MONTH_CNT_SCP0013') IS NOT NULL
		DROP TABLE #TMP_MONTH_CNT_SCP0013;

			----------------------------------------------------------------------
			-- RESULT 3, WEEKLY PIVOT
			----------------------------------------------------------------------
			DECLARE @SQL2 varchar(max)

			SELECT @SQL2 = 'SELECT division_id, scm_site_id, operation_id, line_id, measure'
			SELECT @SQL2 = @SQL2 + ',MAX(CASE WHEN yyyymmdd=''' + yyyymmdd + ''' THEN isnull(ratio,0) END) AS ' + yyyymmdd
			  FROM (select distinct yyyymmdd as yyyymmdd
				    from #TMP_WEEK_RATIO_SCP0013) t

			SELECT @SQL2 = @SQL2 + ' FROM #TMP_WEEK_RATIO_SCP0013 GROUP BY division_id, scm_site_id, operation_id, line_id, measure'

			print (@SQL2)
			EXEC (@SQL2)
			IF OBJECT_ID('tempdb..#TMP_WEEK_RATIO_SCP0013') IS NOT NULL
			DROP TABLE #TMP_WEEK_RATIO_SCP0013;



			----------------------------------------------------------------------
			-- RESULT 4, MONTHLY PIVOT
			----------------------------------------------------------------------
			DECLARE @SQL3 varchar(max)

			SELECT @SQL3 = 'SELECT division_id, scm_site_id, operation_id, line_id, measure'
			SELECT @SQL3 = @SQL3 + ',MAX(CASE WHEN yyyymmdd=''' + yyyymmdd + ''' THEN isnull(ratio,0) END) AS ' + yyyymmdd
			  FROM (select distinct yyyymmdd as yyyymmdd
				    from #TMP_MONTH_RATIO_SCP0013) t

			SELECT @SQL3 = @SQL3 + ' FROM #TMP_MONTH_RATIO_SCP0013 GROUP BY division_id, scm_site_id, operation_id, line_id, measure'

			print (@SQL3)
			EXEC (@SQL3)

			IF OBJECT_ID('tempdb..#TMP_MONTH_RATIO_SCP0013') IS NOT NULL
			DROP TABLE #TMP_MONTH_RATIO_SCP0013;


			-- 2023/06/12 end


		END;

		--임시테이블 삭제
		IF OBJECT_ID('tempdb..#ISUZU_SCP0013') IS NOT NULL
			DROP TABLE #ISUZU_SCP0013;
		IF OBJECT_ID('tempdb..#TMP_MONTH_CNT_SCP0013') IS NOT NULL
			DROP TABLE #TMP_MONTH_CNT_SCP0013;
		IF OBJECT_ID('tempdb..#TMP_MONTH_RATIO_SCP0013') IS NOT NULL
			DROP TABLE #TMP_MONTH_RATIO_SCP0013;
		IF OBJECT_ID('tempdb..#TMP_MONTH_SCP0013') IS NOT NULL
			DROP TABLE #TMP_MONTH_SCP0013;
		IF OBJECT_ID('tempdb..#TMP_WEEK_CNT_SCP0013') IS NOT NULL
			DROP TABLE #TMP_WEEK_CNT_SCP0013;
		IF OBJECT_ID('tempdb..#TMP_WEEK_RATIO_SCP0013') IS NOT NULL
			DROP TABLE #TMP_WEEK_RATIO_SCP0013;
		IF OBJECT_ID('tempdb..#TMP_WEEK_SCP0013') IS NOT NULL
			DROP TABLE #TMP_WEEK_SCP0013;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_Perfor') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_Perfor;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_PlantLine_By_Search') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_PlantLine_By_Search;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_PlantLine_By_TT') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_PlantLine_By_TT;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_key') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_key;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_load') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_load;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_plan') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_plan;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_tmp') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_tmp;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_working') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_working;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_working_data') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_working_data;
		IF OBJECT_ID('tempdb..#TblLookUp_SCP0013') IS NOT NULL
			DROP TABLE #TblLookUp_SCP0013;
		IF OBJECT_ID('tempdb..#JV_ESS_MAP') IS NOT NULL
			DROP TABLE #JV_ESS_MAP;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_Perfor_ESS_JV') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_Perfor_ESS_JV;
			
		
END
