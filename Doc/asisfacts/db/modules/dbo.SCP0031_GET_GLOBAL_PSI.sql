

/*
 * Program ID   : SCP0031_GET_GLOBAL_PSI
 * Description  : GLOBAL PSI 조회
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2018/09/12	hwyoon		              Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/18	hwyoon		              아이템 ID/NICKNAME 조회조건 변경
 * 2018/09/20	hwyoon		              CELL/PACK 세트 조회로직 변경
 * 2018/09/27	hwyoon		              쿼리 성능 개선
 * 2018/11/09	hwyoon		              measure 조회(Invetory) 수정
 * 2018/11/19	hwyoon		              qty numeric(20,10)로 타입 수정
 * 2018/11/21	hwyoon		              LINE_TOTAL_LOAD_ENGINE measure 추가
 * 2018/11/22	hwyoon		              LINE_TOTAL_LOAD_ENGINE 출력오류 수정
 * 2018/11/29	hwyoon		              measure 출력순서조정(PRODJCTION, LINE_TOTAL_LOAD_ENGINE, SHIP_REQ, SHIP_PLAN 강제 셋팅)
 * 2018/12/17	hwyoon		              Measure Inventory 추가 (Pack Biz기준 Cell 재고)
 * 2019/02/28	hwyoon		              [CSR ID:3931058] 화면 Measure 색상 변경 건
 * 2019/04/29	hwyoon		              [CSR ID:3979166] GSCM Global PSI 및 simulator 과거구간 반영요청의 건
 * 2019/06/11	hwyoon		              [CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
 * 2019/08/26	hwyoon		              [CSR ID:4077274] 자체개선 - SCP 3개 메뉴 기능보완(Global PSI, Project Route, Master Validation) - From Site, To Site 조회조건 '-' 추가
 * 2019/10/21	hwyoon		              오류수정 - 출하실적 조회 시 "삭제" 수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
 * 2019/12/12	hwyoon		              UI Category 수정 - Operation Group 코드명 컬럼 추가 (Pack, Cell)
 * 2021/03/23	PJG                       C20210319-000345  Global PSI UI 개선 요청: 국가 or 팀별로 생산량이 보일 수 있게 요청 (TEAM 컬럼 추가)
 * 2021/05/13   khj79                     [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(LT_DAY 변경을 위한 scp_mst_bod_v 로 변경 )
 * 2021/07/15   khj79		              [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
 * 2021/11/19   KDW                       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - SQL튜닝 반영
 * 2021/12/14   KDW                       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
 * 2022/01/20   khj79                     PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - BOM Explosion > Sort 우선 순위 적용 > P (DC_LINK) ->  P(NOT DC_LINK) -> A -> E
 * 2022/03/24   chaan           V1.5      VMI 안전재고설정 추가
 * 2022/04/29   chaan		              81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2022/06/16   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - BOD L/T History 변경 (SCP_MST_BOD_N_V -> SCP_ANL_BOD_N_V_PLAN_H)
 * 2023/04/10   LWY			              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023/06/13   vadabi3		              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - [활성화] Final Item) Cell Type 기준 Sort 적용 
 * 2023/07/11   vadabi3		              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 특정 Measure) Monthly, Weekly Last Value 적용 개선
 * 2023/10/10   vadabi3		              PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 82주 개선
 * 2024-01-08   chaan           V1.1.12   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  EXEC SCP0031_GET_GLOBAL_PSI @p_from_yyyymmdd='20180910'
							 ,@p_to_yyyymmdd='20190908'
							 ,@p_division_id='81'
							 ,@p_item_id=''
							 ,@p_nick_name=''
							 ,@p_from_site=''
							 ,@p_to_site=''
							 ,@p_plan_start_yyyymmdd='20180910'
							 ,@p_plan_type='PR'
							 ,@p_seq='1'
							 ,@p_program_id='SCP0031'
							 ,@p_sheet_name='Global PSI'
							 ,@p_user_id='hwwoonins'
							 ,@debug_mode='T'

 */
CREATE PROCEDURE [dbo].[SCP0031_GET_GLOBAL_PSI]
-- CREATE PROCEDURE [dbo].[SCP0031_GET_GLOBAL_PSI]
	 @p_from_yyyymmdd			NVARCHAR(8),
	 @p_to_yyyymmdd				NVARCHAR(8),
     @p_division_id             NVARCHAR(30),
	 @p_item_id					NVARCHAR(MAX)='',
	 @p_nick_name				NVARCHAR(MAX)='',
	 @p_from_site				NVARCHAR(MAX)='',
	 @p_to_site					NVARCHAR(MAX)='',
	 @p_plan_start_yyyymmdd		NVARCHAR(8),
	 @p_plan_type				NVARCHAR(50),
	 @p_seq						NVARCHAR(50),
	 @p_program_id				NVARCHAR(MAX)='SCP0031',
	 @p_sheet_name				NVARCHAR(MAX)='Global PSI',
	 @p_user_id					NVARCHAR(MAX)='',
	 @p_bucket				    NVARCHAR(10),        --2021/12/14  p_chk_all 추가
     @p_chk_all				    NVARCHAR(1),         -- 2021/12/14 :  체크 시 bucket='daily' 조회
	 @debug_mode					NVARCHAR(1)='F'
 AS
 BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    --DECLARE @p_from_yyyymmdd			NVARCHAR(8)		= N'20240101';
    --DECLARE @p_to_yyyymmdd				NVARCHAR(8)		= N'20241229';
    --DECLARE @p_division_id              NVARCHAR(30)	= N'81';
    --DECLARE @p_item_id					NVARCHAR(MAX)	= N'';
    --DECLARE @p_nick_name				NVARCHAR(MAX)	= N'';
    --DECLARE @p_from_site				NVARCHAR(MAX)	= N'';
    --DECLARE @p_to_site					NVARCHAR(MAX)	= N'';
    --DECLARE @p_plan_start_yyyymmdd		NVARCHAR(8)		= N'20240101';
    --DECLARE @p_plan_type				NVARCHAR(50)	= N'PR';
    --DECLARE @p_seq						NVARCHAR(50)	= N'1';
    --DECLARE @p_program_id				NVARCHAR(MAX)	= N'SCP0031';
    --DECLARE @p_sheet_name				NVARCHAR(MAX)	= N'Global PSI';
    --DECLARE @p_user_id					NVARCHAR(MAX)	= N'iamarock';
    --DECLARE @p_bucket				    NVARCHAR(10)	= N'DAILY';
    --DECLARE @p_chk_all				    NVARCHAR(1)		= N'N';
    --DECLARE @debug_mode					NVARCHAR(1)		= N'F';


	PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)

	DECLARE @arr_item_id varchar(max) , @arr_from_site varchar(max) , @arr_to_site varchar(max);
	SELECT @arr_item_id		= ISNULL(@arr_item_id	+ ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_from_site   = ISNULL(@arr_from_site + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_from_site,',')
	SELECT @arr_to_site     = ISNULL(@arr_to_site	+ ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_to_site,',')

	DECLARE @v_cnt_usr_measure	nvarchar =0;
	SET @v_cnt_usr_measure = convert(nvarchar(50), ISNULL((
								SELECT COUNT(*)
								FROM scm_mst_titleset_user
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  ),0))

	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_result       AS NVARCHAR(8)='';
	DECLARE @v_to_result         AS NVARCHAR(8)='';


	SELECT @v_from_yyyymmdd = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd

	SELECT @v_from_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd;

	SELECT @v_to_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
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
	--2021/12/14 Start
	IF(@p_chk_all = 'Y')	SET @p_bucket = 'DAILY' ;-- 2021/12/14
	--2021/12/14 End
	/********************************************************************************
	 * 임시테이블만들기 - 조회조건 테이블
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_item') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_item;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_TEMP') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_TEMP;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_NICKITEM') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_NICKITEM

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_RANK') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_RANK

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_MEASURE') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_MEASURE

	--생산실적, 출하실적 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_RESULT') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_RESULT;

	--로드률 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_LOAD') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_LOAD;


	/* NICK NAME 조회조건으로 ITEM 추출 */
	SELECT distinct ITEM_ID
	INTO #TblDynamicPivot_SCP0031_NICKITEM
--	FROM SCM_MST_ITEM_SN
	FROM SCM_MST_ITEM_SN WITH(NOLOCK)

	WHERE 1=1
	AND NICK_NAME IS NOT NULL

	AND ISNULL(@p_nick_name,'') != ''
--	AND @p_nick_name != ''

	AND NICK_NAME LIKE @p_nick_name+'%'

	/* PSI CELL/PACK ITEM 세트 */
	SELECT CELL_ITEM_ID, ITEM_ID, RANK() OVER(ORDER BY CELL_ITEM_ID ASC) AS 'RANK'
	INTO #TblDynamicPivot_SCP0031_RANK
	FROM SCP_ANL_PSI_GLOBAL WITH(NOLOCK)
	WHERE DIVISION_ID = @p_division_id
	AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
	AND PLAN_TYPE = @p_plan_type
	AND SEQ = @p_seq
	AND YYYYMMDD >= @p_from_yyyymmdd
	AND YYYYMMDD <= @p_to_yyyymmdd
	GROUP BY CELL_ITEM_ID, ITEM_ID
	ORDER BY CELL_ITEM_ID

	/* 조회조건에 해당하는 세트 모두 추출 */
	SELECT A.CELL_ITEM_ID, A.ITEM_ID
	INTO #TblDynamicPivot_SCP0031_item
	FROM #TblDynamicPivot_SCP0031_RANK A
	WHERE A.RANK IN
		(
			SELECT B.RANK
			FROM #TblDynamicPivot_SCP0031_RANK B
			WHERE 1=1
			AND (
				(B.ITEM_ID IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_item_id,',')) )
				OR
				(B.ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0031_NICKITEM))
				OR
				(B.CELL_ITEM_ID IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_item_id,',')) )
				OR
				(B.CELL_ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0031_NICKITEM))
				)
		)
	;

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Search Item set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END

	/* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅
	SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME
			, CASE WHEN M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'	AND @v_cnt_usr_measure>0	THEN ISNULL( (SELECT T.SORT_ORDER_NO
																									FROM SCM_MST_TITLESET_USER T
																									WHERE T.PROGRAM_ID=M.program_id
																									AND T.SHEET_NAME=M.sheet_name
																									AND T.COLUMN_NAME='PRODUCTION'
																									AND T.USER_ID=U.user_id), U.SORT_ORDER_NO)
				   WHEN M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'	AND @v_cnt_usr_measure=0	THEN P.SORT_ORDER_NO
				   WHEN M.COLUMN_NAME='SHIP_PLAN'				AND @v_cnt_usr_measure>0	THEN ISNULL( (SELECT T.SORT_ORDER_NO
																									FROM SCM_MST_TITLESET_USER T
																									WHERE T.PROGRAM_ID=M.program_id
																									AND T.SHEET_NAME=M.sheet_name
																									AND T.COLUMN_NAME='SHIP_REQ'
																									AND T.USER_ID=U.user_id), U.SORT_ORDER_NO)
				   WHEN M.COLUMN_NAME='SHIP_PLAN'				AND @v_cnt_usr_measure=0	THEN S.SORT_ORDER_NO
				   ELSE ISNULL(U.sort_order_no, M.SORT_ORDER_NO)
			  END AS SORT_ORDER_NO
			  , M.ATTRIBUTE3 --MEASURE 별 COLOR RGB코드
	INTO #TblDynamicPivot_SCP0031_MEASURE
	FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)

	--LEFT JOIN SCM_MST_TITLESET_USER U ON U.program_id  = M.program_id AND U.sheet_name  = M.sheet_name
	--									AND U.column_name = M.column_name AND U.user_id = @p_user_id
	--LEFT JOIN SCM_MST_SHEET_MEASURE P ON P.program_id  = M.program_id AND P.sheet_name  = M.sheet_name AND P.column_name = 'PRODUCTION'
	--LEFT JOIN SCM_MST_SHEET_MEASURE S ON S.program_id  = M.program_id AND S.sheet_name  = M.sheet_name AND S.column_name = 'SHIP_REQ'
	LEFT JOIN SCM_MST_TITLESET_USER U WITH(NOLOCK) ON U.program_id  = M.program_id AND U.sheet_name  = M.sheet_name
										AND U.column_name = M.column_name AND U.user_id = @p_user_id
	LEFT JOIN SCM_MST_SHEET_MEASURE P WITH(NOLOCK) ON P.program_id  = M.program_id AND P.sheet_name  = M.sheet_name AND P.column_name = 'PRODUCTION'
	LEFT JOIN SCM_MST_SHEET_MEASURE S WITH(NOLOCK) ON S.program_id  = M.program_id AND S.sheet_name  = M.sheet_name AND S.column_name = 'SHIP_REQ'

	WHERE M.PROGRAM_ID='SCP0031'
	AND M.VALID_YN='Y'
	and (@v_cnt_usr_measure=0 or ISNULL(U.SORT_ORDER_NO,0)>0)

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Search Measure set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END

	/********************************************************************************
	 * 임시테이블만들기 - 본 테이블
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_FNL') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0031_FNL;
	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	DECLARE @mEXEC NVARCHAR(MAX);

	CREATE TABLE #TblDynamicPivot_SCP0031 (
		 DIVISION_ID		NVARCHAR(60)
		,OPERATION_GROUP	NVARCHAR(60)
		,CELL_ITEM_ID		NVARCHAR(100)
		,ITEM_ID			NVARCHAR(100)
		,TO_SITE			NVARCHAR(60)
		,TO_SITE2			NVARCHAR(60)
		,TO_BOH_QTY			BIGINT
		,FROM_BOH_QTY		BIGINT
		,INCOTERMS			NVARCHAR(20)
		,FROM_SITE			NVARCHAR(60)
		,TRANSPORT_MODE_LINE	NVARCHAR(100)
		,MEASURE			NVARCHAR(100)
		,B_yyyymmdd			NVARCHAR(10)
		,yyyymmdd			NVARCHAR(10)
		,yyyymm				NVARCHAR(6)
		,qty				numeric(30,10)
		,iso_week			INT
		,SORT_ORDER_NO		INT
		,COLUMN_LABEL_NAME	NVARCHAR(300)
		,BOD_ID				NVARCHAR(300)
		,ATTRIBUTE9			NVARCHAR(150)
		,ATTRIBUTE10		NVARCHAR(150)
		,ATTRIBUTE3				NVARCHAR(30)
	);

	--생산/출하 실적 Temp Table
	CREATE TABLE #TblDynamicPivot_SCP0031_RESULT (
		 DIVISION_ID		NVARCHAR(60)
		,OPERATION_GROUP	NVARCHAR(60)
		,CELL_ITEM_ID		NVARCHAR(100)
		,ITEM_ID			NVARCHAR(100)
		,TO_SITE			NVARCHAR(60)
		,TO_SITE2			NVARCHAR(60)
		,TO_BOH_QTY			BIGINT
		,FROM_BOH_QTY		BIGINT
		,INCOTERMS			NVARCHAR(20)
		,FROM_SITE			NVARCHAR(60)
		,TRANSPORT_MODE_LINE	NVARCHAR(100)
		,MEASURE			NVARCHAR(100)
		,SORT_ORDER_NO		INT
		,COLUMN_LABEL_NAME	NVARCHAR(300)
		,BOD_ID				NVARCHAR(300)
		,ATTRIBUTE9			NVARCHAR(150)
		,ATTRIBUTE10		NVARCHAR(150)
		,ATTRIBUTE3				NVARCHAR(30)
	);

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC + ' INSERT #TblDynamicPivot_SCP0031	 '+CHAR(10);
	SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.OPERATION_GROUP'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.CELL_ITEM_ID'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ITEM_ID'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, ISNULL(NULLIF(A.TO_SITE, '''') , ''-'') TO_SITE'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, CASE WHEN RIGHT(ISNULL(NULLIF(A.TO_SITE, '''') , ''-''), 2) = ''-S'' THEN LEFT(ISNULL(NULLIF(A.TO_SITE, '''') , ''-''), LEN(ISNULL(NULLIF(A.TO_SITE, '''') , ''-'')) - 2) ELSE ISNULL(NULLIF(A.TO_SITE, '''') , ''-'') END TO_SITE2 ' +CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TO_BOH_QTY'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_BOH_QTY'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.INCOTERMS '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_SITE '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TRANSPORT_MODE_LINE'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.MEASURE'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.yyyymmdd AS B_yyyymmdd'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, ''D_''+ A.yyyymmdd AS yyyymmdd'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, o.basis_yyyymm AS yyyymm'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, isnull(qty,0) AS qty'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, M.SORT_ORDER_NO'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, M.COLUMN_LABEL_NAME'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.BOD_ID'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE9'+CHAR(10); -- OPERATION ID
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE10'+CHAR(10); -- P:1, A:2
	SET @mEXEC = @mEXEC + '			, M.ATTRIBUTE3'+CHAR(10); -- UI용 MEASURE COLOR
	SET @mEXEC = @mEXEC + '	   FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)'+CHAR(10);

--	SET @mEXEC = @mEXEC + '	   INNER JOIN SCM_SYS_CALENDAR_M o on A.yyyymmdd = o.basis_yyyymmdd'+CHAR(10);
	SET @mEXEC = @mEXEC + '	   INNER JOIN SCM_SYS_CALENDAR_M o WITH(NOLOCK) on A.yyyymmdd = o.basis_yyyymmdd'+CHAR(10);
	
	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0031_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME=A.MEASURE'+CHAR(10);
	IF (NOT(@p_item_id IS NULL OR @p_item_id ='') OR NOT(@p_nick_name IS NULL OR @p_nick_name = ''))
		BEGIN
			SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0031_item I on A.CELL_ITEM_ID = I.CELL_ITEM_ID AND A.ITEM_ID=I.ITEM_ID'+CHAR(10);
		END;
	SET @mEXEC = @mEXEC + '	  WHERE A.DIVISION_ID			= '''+@p_division_id+''''+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+''''+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_TYPE				= '''+@p_plan_type+''''+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.SEQ					= '''+@p_seq+''''+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD >= '''+@p_from_yyyymmdd+''''+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD <= '''+@p_to_yyyymmdd+''''+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND ('''+@v_cnt_usr_measure+''' = 0 OR ISNULL(M.sort_order_no,0)>0) '+CHAR(10);

	IF NOT(@p_from_site IS NULL	OR  @p_from_site	='') BEGIN SET @mEXEC = @mEXEC+'   	AND isnull(NULLIF(A.FROM_SITE, '''') , ''-'')     IN ('+@arr_from_site+') '+CHAR(10); END;
	IF NOT(@p_to_site	IS NULL	OR  @p_to_site		='') BEGIN SET @mEXEC = @mEXEC+'   	AND isnull(NULLIF(A.TO_SITE, '''') , ''-'')       IN ('+@arr_to_site+') '+CHAR(10); END;

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

	EXEC (@mEXEC);


	IF @debug_mode ='T'
	BEGIN
		PRINT 'Search Rowdata set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END


	/********************************************************************************
	* 1. Line Load(%) Temp
	********************************************************************************/
	SELECT A.DIVISION_ID
		, A.OPERATION_GROUP
		, A.FROM_SITE
		, A.ATTRIBUTE9
		, A.TRANSPORT_MODE_LINE
		, round(sum(a.qty * (e.tact_time/60)),0) AS SUM_LOAD_QTY
		, CASE WHEN d.working_time <= 0.0 THEN 0
				ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
			END AS qty
		, d.working_time
		, A.yyyymmdd AS B_yyyymmdd
		, o.basis_yyyymm AS yyyymm
		, o.iso_week
		,'W_'+o.basis_yyyymm + o.iso_week AS week_yyyymmdd
		,'M_'+o.basis_yyyymm  AS month_yyyymmdd
   INTO #TblDynamicPivot_SCP0031_TEMP
 --  FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
 --  INNER JOIN SCM_SYS_CALENDAR_M o on A.yyyymmdd = o.basis_yyyymmdd
 --  INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK) ON M.PROGRAM_ID   = @p_program_id AND M.COLUMN_NAME  = A.MEASURE
	--JOIN scp_anl_working_time d WITH(NOLOCK) ON a.division_id = d.division_id and a.ATTRIBUTE9 = d.operation_id
   FROM SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
   INNER JOIN SCM_SYS_CALENDAR_M o WITH(NOLOCK) on A.yyyymmdd = o.basis_yyyymmdd
   INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK) ON M.PROGRAM_ID   = @p_program_id AND M.COLUMN_NAME  = A.MEASURE
	JOIN scp_anl_working_time d WITH(NOLOCK) ON a.division_id = d.division_id and a.ATTRIBUTE9 = d.operation_id

						and a.FROM_SITE=d.scm_site_id
						and a.TRANSPORT_MODE_LINE = d.line_id
						and a.yyyymmdd= d.yyyymmdd

	JOIN scp_anl_tact_time e WITH(NOLOCK) ON a.division_id = e.division_id and a.ATTRIBUTE9 = e.operation_id
						and a.FROM_SITE=e.scm_site_id
						and a.TRANSPORT_MODE_LINE = e.line_id
						and (CASE WHEN A.OPERATION_GROUP='P' THEN A.ITEM_ID ELSE A.CELL_ITEM_ID END) = e.item_id
						and a.yyyymmdd= e.yyyymmdd
  WHERE A.DIVISION_ID			= @p_division_id
	AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
	AND A.PLAN_TYPE				= @p_plan_type
	AND A.SEQ					= @p_seq
	AND A.YYYYMMDD >= @p_from_yyyymmdd
	AND A.YYYYMMDD <= @p_to_yyyymmdd
  	--AND (@v_cnt_usr_measure = 0 OR ISNULL(U.sort_order_no,0)>0)
	AND (@v_cnt_usr_measure = 0 OR ISNULL(M.sort_order_no,0)>0)
	AND a.MEASURE='PRODUCTION' -- 6초 75712행
  GROUP BY a.division_id, a.operation_group ,a.FROM_SITE ,a.ATTRIBUTE9 ,a.TRANSPORT_MODE_LINE, a.yyyymmdd,o.basis_yyyymm,o.iso_week, d.working_time
  ;

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Search Line Load set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END


	/********************************************************************************
	* 2. 과거 실적구간 temp
	********************************************************************************/
	IF(@v_from_result<@v_to_result)
	BEGIN
		INSERT INTO #TblDynamicPivot_SCP0031_RESULT
		SELECT DISTINCT
				 A.DIVISION_ID
			   , A.OPERATION_GROUP
			   , A.CELL_ITEM_ID
			   , A.ITEM_ID
			   , A.TO_SITE
			   , A.TO_SITE2
			   , A.TO_BOH_QTY
			   , A.FROM_BOH_QTY
			   , A.INCOTERMS
			   , A.FROM_SITE
			   , A.TRANSPORT_MODE_LINE
			   , A.MEASURE
			   , A.SORT_ORDER_NO
			   , A.COLUMN_LABEL_NAME
			   , A.BOD_ID
			   , A.ATTRIBUTE9
			   , A.ATTRIBUTE10
			   , A.ATTRIBUTE3
		FROM #TblDynamicPivot_SCP0031 A WITH(NOLOCK)
		WHERE A.MEASURE IN ('PRODUCTION','SHIP_PLAN','ALLOCATION') --2초
		;

		IF @debug_mode ='T'
		BEGIN
			PRINT 'Search Prev Result set End. '+CONVERT(CHAR(23), GETDATE(), 21)
		END

	END;


	-- Line Load(%) Insert
	SELECT A.DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.CELL_ITEM_ID
		   , A.ITEM_ID
		   , A.TO_SITE
		   , A.TO_SITE2
		   , A.TO_BOH_QTY
		   , A.FROM_BOH_QTY
		   , A.INCOTERMS
		   , A.FROM_SITE
		   , A.TRANSPORT_MODE_LINE
		   , 'LINE_TOTAL_LOAD_ENGINE' MEASURE
		   , A.B_yyyymmdd
		   , A.yyyymmdd
		   , A.yyyymm
		   , B.qty
		   , A.iso_week
		   --, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO -- 수정
		   , M.sort_order_no
		   , M.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.ATTRIBUTE10
		   , M.ATTRIBUTE3
		   , B.SUM_LOAD_QTY
		   , B.WORKING_TIME
		   , B.week_yyyymmdd
		   , B.month_yyyymmdd
	INTO #TblDynamicPivot_SCP0031_LOAD
	FROM #TblDynamicPivot_SCP0031 A WITH(NOLOCK)
	JOIN #TblDynamicPivot_SCP0031_TEMP B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND A.OPERATION_GROUP = B.OPERATION_GROUP
		AND A.FROM_SITE=B.FROM_SITE
		AND A.ATTRIBUTE9 = B.ATTRIBUTE9
		AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
		AND A.B_yyyymmdd = B.B_yyyymmdd
	INNER JOIN #TblDynamicPivot_SCP0031_MEASURE M WITH(NOLOCK) 
		ON M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'
	;

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input Line Load Daily End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END

	/*
	INSERT INTO #TblDynamicPivot_SCP0031
	SELECT A.DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.CELL_ITEM_ID
		   , A.ITEM_ID
		   , A.TO_SITE
		   , A.TO_BOH_QTY
		   , A.FROM_BOH_QTY
		   , A.INCOTERMS
		   , A.FROM_SITE
		   , A.TRANSPORT_MODE_LINE
		   , 'LINE_TOTAL_LOAD_ENGINE' MEASURE
		   , A.B_yyyymmdd
		   , A.yyyymmdd
		   , A.yyyymm
		   , B.qty
		   , A.iso_week
		   --, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO -- 수정
		   , M.sort_order_no
		   , M.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.ATTRIBUTE10
		   , M.ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0031 A WITH(NOLOCK)
	JOIN #TblDynamicPivot_SCP0031_TEMP B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND A.OPERATION_GROUP = B.OPERATION_GROUP
		AND A.FROM_SITE=B.FROM_SITE
		AND A.ATTRIBUTE9 = B.ATTRIBUTE9
		AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
		AND A.B_yyyymmdd = B.B_yyyymmdd
	INNER JOIN #TblDynamicPivot_SCP0031_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'
	;
	*/

	--Load율 개선(Daily)
	INSERT INTO #TblDynamicPivot_SCP0031
	SELECT A.DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.CELL_ITEM_ID
		   , A.ITEM_ID
		   , A.TO_SITE
		   , A.TO_SITE2
		   , A.TO_BOH_QTY
		   , A.FROM_BOH_QTY
		   , A.INCOTERMS
		   , A.FROM_SITE
		   , A.TRANSPORT_MODE_LINE
		   , A.MEASURE
		   , A.B_yyyymmdd
		   , A.yyyymmdd
		   , A.yyyymm
		   , A.qty
		   , A.iso_week
		   , A.sort_order_no
		   , A.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.ATTRIBUTE10
		   , A.ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0031_LOAD A WITH(NOLOCK)

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input Line Load Daily set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END

	--Load율 개선(Week)
	INSERT INTO #TblDynamicPivot_SCP0031
	SELECT DIVISION_ID
		   , OPERATION_GROUP
		   , CELL_ITEM_ID
		   , ITEM_ID
		   , TO_SITE
		   , TO_SITE2
		   , TO_BOH_QTY
		   , FROM_BOH_QTY
		   , INCOTERMS
		   , FROM_SITE
		   , TRANSPORT_MODE_LINE
		   , MEASURE
		   , '-' AS B_YYYYMMDD
		   , WEEK_YYYYMMDD AS YYYYMMDD
		   , '-' AS YYYYMM
		   , CASE WHEN SUM(working_time) <= 0.0 THEN 0
				ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(working_time) ) ,0 ) *100
			  END AS qty
		   , '-' AS iso_week
		   , sort_order_no
		   , COLUMN_LABEL_NAME
		   , BOD_ID
		   , ATTRIBUTE9
		   , ATTRIBUTE10
		   , ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0031_LOAD
	GROUP BY DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
			 , TO_SITE
			 , TO_SITE2
			 , TO_BOH_QTY
			 , FROM_BOH_QTY
			 , INCOTERMS
			 , FROM_SITE
			 , TRANSPORT_MODE_LINE
			 , MEASURE
			 , sort_order_no
			 , COLUMN_LABEL_NAME
			 , BOD_ID
			 , ATTRIBUTE9
			 , ATTRIBUTE10
			 , ATTRIBUTE3
			 , WEEK_YYYYMMDD
			 , MONTH_YYYYMMDD
	;

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input Line Load Week set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END


	--Load율 개선(Month)
	INSERT INTO #TblDynamicPivot_SCP0031
	SELECT DIVISION_ID
		   , OPERATION_GROUP
		   , CELL_ITEM_ID
		   , ITEM_ID
		   , TO_SITE
		   , TO_SITE2
		   , TO_BOH_QTY
		   , FROM_BOH_QTY
		   , INCOTERMS
		   , FROM_SITE
		   , TRANSPORT_MODE_LINE
		   , MEASURE
		   , '-' AS B_YYYYMMDD
		   , MONTH_YYYYMMDD AS YYYYMMDD
		   , '-' AS YYYYMM
		   , CASE WHEN SUM(working_time) <= 0.0 THEN 0
				ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(working_time) ) ,0 ) *100
			  END AS qty
		   , '-' AS iso_week
		   , sort_order_no
		   , COLUMN_LABEL_NAME
		   , BOD_ID
		   , ATTRIBUTE9
		   , ATTRIBUTE10
		   , ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0031_LOAD
	GROUP BY DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
			 , TO_SITE
			 , TO_SITE2
			 , TO_BOH_QTY
			 , FROM_BOH_QTY
			 , INCOTERMS
			 , FROM_SITE
			 , TRANSPORT_MODE_LINE
			 , MEASURE
			 , sort_order_no
			 , COLUMN_LABEL_NAME
			 , BOD_ID
			 , ATTRIBUTE9
			 , ATTRIBUTE10
			 , ATTRIBUTE3
			 , MONTH_YYYYMMDD
	;

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input Line Load Month set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END


	-- 생산/출하/매출 실적 insert
	IF(@v_from_result < @v_to_result)
	BEGIN
		-- 1. 생산실적 insert
		INSERT INTO #TblDynamicPivot_SCP0031
		SELECT  distinct
			r.division_id
		   	,a.operation_group
			,a.cell_item_id
			,a.item_id
			,a.to_site
			,a.to_site2
			,a.to_boh_qty
			,a.from_boh_qty
			,a.incoterms
			,a.from_site
			,a.transport_mode_line
			,a.measure
			,convert(nvarchar(8), r.plan_date,112) AS B_yyyymmdd
			,'D_'+convert(nvarchar(8), r.plan_date,112)  AS yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,r.actual_good_qty AS qty
			--,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week
			,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			,a.sort_order_no
			,a.column_label_name
			,a.bod_id
			,a.attribute9
			,a.attribute10
			,a.attribute3
		--FROM SCM_DNM_product_result_v r
		--JOIN scm_sys_calendar_m c on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd
		--LEFT OUTER JOIN SCP_MST_FINAL_ITEM b on r.division_id = b.division_id and r.item_id = b.item_id and r.scp_operation_group = b.operation_group
		FROM SCM_DNM_product_result_v r WITH(NOLOCK)
		JOIN scm_sys_calendar_m c WITH(NOLOCK)
			on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd
		LEFT OUTER JOIN SCP_MST_FINAL_ITEM b WITH(NOLOCK)
			on r.division_id = b.division_id and r.item_id = b.item_id and r.scp_operation_group = b.operation_group

		JOIN #TblDynamicPivot_SCP0031_RESULT A WITH(NOLOCK) ON A.MEASURE='PRODUCTION'
															AND A.DIVISION_ID=R.DIVISION_ID
															AND A.OPERATION_GROUP=R.scp_operation_group
															AND A.FROM_SITE=R.SCM_SITE_ID
															AND A.ITEM_ID=R.ITEM_ID
															AND A.ATTRIBUTE9=R.OPERATION_ID
															AND A.TRANSPORT_MODE_LINE=R.LINE_ID
		WHERE 1=1
			AND r.plan_date          >= convert(datetime, @v_from_result)
			AND r.plan_date          < convert(datetime, @v_to_result )
			AND r.division_id = @p_division_id
			AND r.scp_operation_group IN ('A','P')
			AND ( LEFT(r.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
											SELECT segment1 AS operation_id
												FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
											WHERE lookup_type = 'SCP_PLAN_OPERATION'
												AND SEGMENT1 <> 'F6000'
												AND valid_yn    = 'Y')
				OR r.operation_id IN (--외주PACKER의 업체코드
											SELECT plant_id  AS operation_id
											FROM SCM_MST_SITE WITH(NOLOCK)
											WHERE 1=1
											AND division_id = @p_division_id
											AND site_type   = 'PLANT'
											AND osp_yn      = 'Y'
											AND valid_yn    = 'Y'
											) )
		;

	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input Supply set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END

		-- 2. 출하실적 insert
		INSERT INTO #TblDynamicPivot_SCP0031
		SELECT
			r.division_id
		   	,a.operation_group
			,a.cell_item_id
			,a.item_id
			,a.to_site
			,a.to_site2
			,a.to_boh_qty
			,a.from_boh_qty
			,a.incoterms
			,a.from_site
			,a.transport_mode_line
			,a.measure
			,r.exfactory_date AS B_yyyymmdd
			,'D_'+r.exfactory_date  AS yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,r.exfactory_qty AS qty
			,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			,a.sort_order_no
			,a.column_label_name
			,a.bod_id
			,a.attribute9
			,a.attribute10
			,a.attribute3
		--FROM SCM_DNM_EXFACTORY_RESULT r
		--JOIN scm_sys_calendar_m c on r.exfactory_date = c.basis_yyyymmdd
		--LEFT OUTER JOIN SCM_MST_SITE b on b.scm_site_id = r.to_scm_site_id and b.site_type='PLANT'
		FROM SCM_DNM_EXFACTORY_RESULT r WITH(NOLOCK)
		JOIN scm_sys_calendar_m c WITH(NOLOCK)
			on r.exfactory_date = c.basis_yyyymmdd
		LEFT OUTER JOIN SCM_MST_SITE b WITH(NOLOCK)
			on b.scm_site_id = r.to_scm_site_id and b.site_type='PLANT'

		JOIN #TblDynamicPivot_SCP0031_RESULT A WITH(NOLOCK) ON A.MEASURE='SHIP_PLAN'
															AND A.DIVISION_ID=R.DIVISION_ID
															AND A.ITEM_ID=R.ITEM_ID
															AND A.FROM_SITE=R.FROM_SCM_SITE_ID
															AND A.TO_SITE=R.TO_SCM_SITE_ID
															AND A.TRANSPORT_MODE_LINE=R.TRANSPORT_MODE
		WHERE 1=1
			AND r.exfactory_date          >= convert(datetime, @v_from_result)
			AND r.exfactory_date          < convert(datetime, @v_to_result )
			AND r.division_id = @p_division_id
			AND (B.PLANT_ID IS NOT NULL OR (B.PLANT_ID IS NULL AND A.incoterms=R.incoterms)) -- FG의 경우 incoterms 비교
			AND r.EXFACTORY_STATUS IN ('D20','D30','D40')
		;

		PRINT 'Input Shipping set End. '+CONVERT(CHAR(23), GETDATE(), 21)

		-- 3. 매출실적 insert
		INSERT INTO #TblDynamicPivot_SCP0031
		SELECT
			r.division_id
		   	,a.operation_group
			,a.cell_item_id
			,a.item_id
			,a.to_site
			,a.to_site2
			,a.to_boh_qty
			,a.from_boh_qty
			,a.incoterms
			,a.from_site
			,a.transport_mode_line
			,a.measure
			,r.yyyymmdd AS B_yyyymmdd
			,'D_'+r.yyyymmdd  AS yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,r.qty AS qty
			,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			,a.sort_order_no
			,a.column_label_name
			,a.bod_id
			,a.attribute9
			,a.attribute10
			,a.attribute3
		--FROM dm_pln_sales_plan_result r 
		--JOIN scm_sys_calendar_m c on r.yyyymmdd = c.basis_yyyymmdd

		FROM dm_pln_sales_plan_result r WITH(NOLOCK)
		JOIN scm_sys_calendar_m c WITH(NOLOCK) on r.yyyymmdd = c.basis_yyyymmdd

		--JOIN SCM_MST_SITE b on b.scm_site_id = r.PLANT_SITE_ID and b.site_type='PLANT'
		JOIN #TblDynamicPivot_SCP0031_RESULT A WITH(NOLOCK) ON A.MEASURE='ALLOCATION'
															AND A.DIVISION_ID=R.DIVISION_ID
															AND A.ITEM_ID=R.ITEM_ID
															AND A.TO_SITE=R.SCM_SITE_ID
															AND A.incoterms=R.incoterms
		WHERE 1=1
			AND r.yyyymmdd          >= convert(datetime, @v_from_result)
			AND r.yyyymmdd          < convert(datetime, @v_to_result )
			AND r.division_id = @p_division_id
			AND r.measure = 'RTF'
		;

		IF @debug_mode ='T'
		BEGIN
			PRINT 'Input RTF set End. '+CONVERT(CHAR(23), GETDATE(), 21)
		END

	END
--2021/11/02 Start UI 속도 개선
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_FNL') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_FNL ;

	SELECT *
	  INTO #TblDynamicPivot_SCP0031_FNL
	  FROM #TblDynamicPivot_SCP0031
	;

	ALTER TABLE #TblDynamicPivot_SCP0031_FNL ADD WEEK_YN CHAR(1);
	ALTER TABLE #TblDynamicPivot_SCP0031_FNL ADD MONTH_YN CHAR(1);
	--MODEL_INVENTORY, WH_IN_BALANCE, BALANCE, CHAR_AVAILABLE, ACTIVATE_PROGRESS

		--chaan begin V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경)
        INSERT INTO #TblDynamicPivot_SCP0031_FNL
        SELECT    F.DIVISION_ID
				, F.OPERATION_GROUP
				, F.CELL_ITEM_ID
				, F.ITEM_ID
				, F.TO_SITE
				, F.TO_SITE2
				, F.TO_BOH_QTY
				, F.FROM_BOH_QTY
				, F.INCOTERMS
				, F.FROM_SITE
				, F.TRANSPORT_MODE_LINE
				, F.MEASURE
				, F.B_yyyymmdd
				, F.yyyymmdd
				, F.yyyymm
				, F.QTY
				, F.iso_week
				, C.SORT_ORDER_NO
				, C.COLUMN_LABEL_NAME
				, F.BOD_ID
				, F.ATTRIBUTE9
				, F.ATTRIBUTE10
				, C.ATTRIBUTE3
				, F.WEEK_YN
				, F.MONTH_YN

        FROM    (

                    SELECT    S.DIVISION_ID
                            , S.OPERATION_GROUP
                            , S.CELL_ITEM_ID
                            , S.ITEM_ID
                            , S.TO_SITE
                            , S.TO_SITE2
                            , S.TO_BOH_QTY
                            , S.FROM_BOH_QTY
                            , S.INCOTERMS
                            , S.FROM_SITE
                            , S.TRANSPORT_MODE_LINE
                            , 'GAP' AS MEASURE
                            , S.B_yyyymmdd
                			, S.yyyymmdd
                            , S.yyyymm
                      		, (ISNULL(B.qty, 0) - ISNULL(S.qty, 0)) AS QTY
                  			, S.iso_week
                            , S.SORT_ORDER_NO
                            , S.COLUMN_LABEL_NAME
                            , S.BOD_ID
                            , S.ATTRIBUTE9
                            , S.ATTRIBUTE10
                            , S.ATTRIBUTE3
                            , S.WEEK_YN
                            , S.MONTH_YN
                    FROM
                            (
                                SELECT  *
                                FROM    #TblDynamicPivot_SCP0031_FNL
                                WHERE   MEASURE = 'SAFETY_STOCK'
                            ) S
                            LEFT JOIN -- Safet Stocck 을 기준으로 하므로 Safety Stock 행이 없으면 Gap 행도 만들 수 없음
                            (
                                SELECT  *
                                FROM    #TblDynamicPivot_SCP0031_FNL
                                WHERE   MEASURE = 'WH_IN_BALANCE'
                            ) B ON
									S.DIVISION_ID = B.DIVISION_ID
								AND S.OPERATION_GROUP = B.OPERATION_GROUP
								AND S.CELL_ITEM_ID = B.CELL_ITEM_ID
								AND S.ITEM_ID = B.ITEM_ID
								AND S.TO_SITE = B.TO_SITE
								AND S.TO_SITE2 = B.TO_SITE2
								--AND S.TO_BOH_QTY = B.TO_BOH_QTY
								--AND S.FROM_BOH_QTY = B.FROM_BOH_QTY
								AND S.INCOTERMS = B.INCOTERMS
								AND S.FROM_SITE = B.FROM_SITE
								AND S.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
								AND S.B_yyyymmdd = B.B_yyyymmdd
								AND S.yyyymmdd = B.yyyymmdd
								AND S.yyyymm = B.yyyymm
								AND S.iso_week = B.iso_week
								AND S.BOD_ID = B.BOD_ID
								--AND S.ATTRIBUTE9 = B.ATTRIBUTE9
								--AND S.ATTRIBUTE10 = B.ATTRIBUTE10
								--AND S.ATTRIBUTE3 = B.ATTRIBUTE3
                ) F
                LEFT JOIN
                    (
        --                SELECT DISTINCT
        --                          M.PROGRAM_ID
        --                        , M.SHEET_NAME
        --                        , M.COLUMN_NAME
        --                        , M.COLUMN_LABEL_NAME
        --                        , T.SORT_ORDER_NO
        --                        , 'GAP' AS MEASURE
								--, M.ATTRIBUTE9
								--, M.ATTRIBUTE10
								--, M.ATTRIBUTE3
        --                FROM    SCM_MST_SHEET_MEASURE M,
        --                        SCM_MST_TITLESET_USER T
        --                WHERE   1=1
        --                    AND M.PROGRAM_ID  = T.PROGRAM_ID
			     --           AND M.SHEET_NAME  = T.SHEET_NAME
        --                    AND M.COLUMN_NAME = 'GAP'
        --                    AND T.PROGRAM_ID  = @p_program_id
			     --           AND T.SHEET_NAME  = @p_sheet_name
						  --  AND T.USER_ID     = @p_user_id
                        SELECT    M.PROGRAM_ID
                                , M.SHEET_NAME
                                , M.COLUMN_NAME
                                , M.COLUMN_LABEL_NAME
                                , T.SORT_ORDER_NO
                                , 'GAP' AS MEASURE
								, M.ATTRIBUTE9
								, M.ATTRIBUTE10
								, M.ATTRIBUTE3
--                        FROM    SCM_MST_SHEET_MEASURE M,
--                                SCM_MST_TITLESET_USER T
                        FROM    SCM_MST_SHEET_MEASURE M WITH(NOLOCK),
                                SCM_MST_TITLESET_USER T WITH(NOLOCK)
/*
JOIN 문으로 재작성 검토

exec sp_spaceused SCM_MST_SHEET_MEASURE
	--name					rows	reserved	data	index_size	unused
	--SCM_MST_SHEET_MEASURE	1250                	832 KB	464 KB	136 KB	232 KB
exec sp_helpindex SCM_MST_SHEET_MEASURE
	--index_name	index_description	index_keys
	--PK_SCM_MST_SHEET_MEASURE	clustered, unique located on PRIMARY	PROGRAM_ID, SHEET_NAME, COLUMN_NAME

exec sp_spaceused SCM_MST_TITLESET_USER
	--name					rows	reserved	data	index_size	unused
	--SCM_MST_TITLESET_USER	177732              	62064 KB	55280 KB	5976 KB	808 KB
exec sp_helpindex SCM_MST_TITLESET_USER
	--index_name	index_description	index_keys
	--PK_SCM_MST_TITLESET_USER	clustered, unique, primary key located on PRIMARY	USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME

--경고! 최대 키 길이는 900바이트입니다. 인덱스 'IDX01_SCM_MST_TITLESET_USER'의 최대 길이는 1200바이트입니다. 큰 값을 조합한 일부 경우에는 삽입/업데이트 작업을 수행할 수 없습니다.
--CREATE INDEX IDX01_SCM_MST_TITLESET_USER ON SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME, COLUMN_NAME)

CREATE INDEX IDX01_SCM_MST_TITLESET_USER ON SCM_MST_TITLESET_USER (USER_ID, PROGRAM_ID, SHEET_NAME) INCLUDE (COLUMN_NAME)

DROP INDEX IDX01_SCM_MST_TITLESET_USER ON SCM_MST_TITLESET_USER
*/
                        WHERE   1=1
                            AND M.PROGRAM_ID  = T.PROGRAM_ID
			                AND M.SHEET_NAME  = T.SHEET_NAME
                            AND M.COLUMN_NAME = T.COLUMN_NAME
                            AND M.COLUMN_NAME = 'GAP'
                            AND T.PROGRAM_ID  = @p_program_id
			                AND T.SHEET_NAME  = @p_sheet_name
						    AND T.USER_ID     = @p_user_id

                    ) C ON F.MEASURE = C.MEASURE;
		--chaan end V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경)

	UPDATE A
	   SET WEEK_YN = 'Y'
	  FROM #TblDynamicPivot_SCP0031_FNL A
	  JOIN (
			SELECT ISO_WEEK , PARTIAL_WEEK_NAME,CALENDAR_YYYY , MAX(BASIS_YYYYMMDD) AS YYYYMMDD
			  FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			 WHERE BASIS_YYYYMMDD >= @p_from_yyyymmdd
			   AND BASIS_YYYYMMDD <= @p_to_yyyymmdd  -- 마지막 구간 오류 발생으로 1개월 더함
			  GROUP BY ISO_WEEK, PARTIAL_WEEK_NAME,CALENDAR_YYYY
			) X
			ON RIGHT(A.YYYYMMDD,8) = X.YYYYMMDD
	   WHERE MEASURE IN ( 'MODEL_INVENTORY' ,'WH_IN_BALANCE','BALANCE','CHAR_AVAILABLE','ACTIVATE_PROGRESS','SAFETY_STOCK','GAP','DIO')
	;

	UPDATE A
	   SET MONTH_YN = 'Y'
	  FROM #TblDynamicPivot_SCP0031_FNL A
	  JOIN (
			SELECT  BASIS_YYYYMM, MAX(BASIS_YYYYMMDD) AS YYYYMMDD
			  FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			 WHERE BASIS_YYYYMMDD >= @p_from_yyyymmdd
			   AND BASIS_YYYYMMDD <= @p_to_yyyymmdd  -- 마지막 구간 오류 발생으로 1개월 더함
			  GROUP BY BASIS_YYYYMM
			) X
			ON RIGHT(A.YYYYMMDD,8) = X.YYYYMMDD
	   WHERE MEASURE IN ( 'MODEL_INVENTORY' ,'WH_IN_BALANCE','BALANCE','CHAR_AVAILABLE','ACTIVATE_PROGRESS','SAFETY_STOCK','GAP','DIO');


--2021/11/02 End UI 속도 개선
	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
	begin
		-- SUM 컬럼 문자열 생성 begin
		DECLARE @mQry_sum NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';

		SELECT  @mQry_sum = @mQry_sum+','+
			CASE
			  WHEN CHARINDEX('M_', yyyymmdd) = 1 THEN
				'SUM( CASE WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) AND MEASURE IN       ( ''MODEL_INVENTORY'' ,''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''SAFETY_STOCK'',''GAP'', ''DIO'') AND MONTH_YN = ''Y''       THEN convert(numeric(15,2),QTY) '
				+         'WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) AND MEASURE NOT IN   ( ''MODEL_INVENTORY'' ,''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''LINE_TOTAL_LOAD_ENGINE'',''SAFETY_STOCK'',''GAP'', ''DIO'') THEN convert(numeric(15,2),QTY) ELSE 0 END   ) AS ' + yyyymmdd
			  WHEN CHARINDEX('W_', yyyymmdd) = 1 THEN
				'SUM( CASE WHEN iso_week=RIGHT('''+yyyymmdd+''',6) AND MEASURE IN     ( ''MODEL_INVENTORY'' ,''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''SAFETY_STOCK'',''GAP'', ''DIO'') AND WEEK_YN = ''Y''        THEN convert(numeric(15,2),QTY) '
				+		  'WHEN iso_week=RIGHT('''+yyyymmdd+''',6) AND MEASURE NOT IN ( ''MODEL_INVENTORY'' ,''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''LINE_TOTAL_LOAD_ENGINE'',''SAFETY_STOCK'',''GAP'', ''DIO'') THEN convert(numeric(15,2),QTY) ELSE 0 END   ) AS ' + yyyymmdd
			  WHEN CHARINDEX('D_', yyyymmdd) = 1 THEN
				' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
		    END +''+CHAR(10)
		FROM (
			SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
				, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
--			FROM [dbo].[scm_sys_calendar_m] a
			FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)

			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			AND ( @p_bucket = 'DAILY' OR @p_bucket = 'WEEKLY' )
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
			UNION ALL
			SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
			  ,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
--			FROM [dbo].[scm_sys_calendar_m] a
			FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)
			
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name
			
			UNION ALL

			SELECT 'D_'+a.basis_yyyymmdd AS yyyymmdd
			  , a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no

--			FROM [dbo].[scm_sys_calendar_m] a
			FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)

			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			AND @p_bucket= 'DAILY'
			GROUP BY a.basis_yyyymmdd
		) AS A
		ORDER BY sort_order_no;
		-- SUM 컬럼 문자열 생성 end


		-----------------------------------------------------------
		-- DEBUG QRY 출력
		-----------------------------------------------------------
		--IF( @debug_mode ='T')
			--BEGIN
				--SET @POS =1;
				--SET @LEN =LEN(@mQry_sum);
				--WHILE @POS <= @LEN
					--BEGIN
						--PRINT SUBSTRING(@mQry_sum,@POS,4000);
						--SET @POS = @POS+4000;
					--END;
			--END;


		SET @mEXEC = '';
		--2021/11/19 SQL튜닝 반영 DEL
		/*
		-- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
		--        UI에서 합계계산 시 COLUMN COUNT INDEX 계산
		SET @mEXEC = @mEXEC + 'SELECT CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE convert(nvarchar(50), ('+CHAR(10);
		--SET @mEXEC = @mEXEC + '										CASE	WHEN ISNULL(l.segment3, '''') = '''' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  '+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''A''            THEN 0'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''B''            THEN ISNULL(r.lt_departure_inland, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''C''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''D''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''E''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''F''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												ELSE                                     ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)'+CHAR(10);
		--SET @mEXEC = @mEXEC + '										END ) ) END AS LT_DAY'+CHAR(10);
		SET @mEXEC = @mEXEC + '		     B.lt_total )) END AS LT_DAY'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(NULLIF( A.CELL_QTY_PACK_T, '''') , ''-'') AS CELL_QTY_PACK'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(d.segment2,''-'') AS OPERATION_GROUP_NAME'+CHAR(10);
		SET @mEXEC = @mEXEC + '	       , ISNULL(H.DEPT_NAME_KO, ''-'') AS DEPT_NAME	                            '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.*'+CHAR(10);


		--IF @p_division_id != 'EE'
		--BEGIN
		--    SET @mEXEC = @mEXEC + '        , CASE WHEN A.TO_SITE = ''-'' THEN '''''+CHAR(10);
		--    SET @mEXEC = @mEXEC + '          ELSE (SELECT TOP 1 BB.DEPT_NAME_KO FROM SCM_MST_SSO_USER_INFO AA WITH (NOLOCK) '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                                           INNER JOIN SCM_MST_SSO_DEPT_INFO BB WITH (NOLOCK) ON AA.DEPT_ID = BB.DEPT_ID  '+CHAR(10);
		--	SET @mEXEC = @mEXEC + '                                           INNER JOIN SCM_MST_SITE_ITEM CC WITH (NOLOCK) ON AA.USER_ID = CC.OWNER        '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               WHERE CC.ITEM_ID = A.ITEM_ID                                      '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                 AND CC.DIVISION_ID = A.DIVISION_ID AND CC.SCM_SITE_ID = A.TO_SITE) END AS DEPT_NAME      '+CHAR(10);

		--END
		--ELSE BEGIN
		--    SET @mEXEC = @mEXEC + '        , CASE WHEN A.TO_SITE = ''-'' THEN '''''+CHAR(10);
		--    SET @mEXEC = @mEXEC + '          ELSE (SELECT TOP 1 BB.DEPT_NAME_KO FROM SCM_MST_SSO_USER_INFO AA WITH (NOLOCK) '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                                     INNER JOIN SCM_MST_SSO_DEPT_INFO BB WITH (NOLOCK) ON AA.DEPT_ID = BB.DEPT_ID  '+CHAR(10);
		--	SET @mEXEC = @mEXEC + '                                     INNER JOIN SCM_MST_SITE_ITEM CC WITH (NOLOCK) ON AA.USER_ID = CC.OWNER        '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               WHERE CC.ITEM_ID = A.ITEM_ID                  '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               AND CC.DIVISION_ID = A.DIVISION_ID AND CC.SCM_SITE_ID = A.TO_SITE2) END AS DEPT_NAME      '+CHAR(10);
		--END;

		--SET @mEXEC = @mEXEC + '        , G.DEPT_NAME_KO AS DEPT_NAME'+CHAR(10);

		SET @mEXEC = @mEXEC + ' FROM ('+CHAR(10);
		*/
		--2021/11/19 SQL튜닝 반영 DEL
		SET @mEXEC = @mEXEC + ' SELECT            A.DIVISION_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.OPERATION_GROUP'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CELL_ITEM_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ITEM_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID AND X.NICK_NAME IS NOT NULL ) AS NICK_NAME'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, CASE WHEN A.OPERATION_GROUP=''A'' THEN ''-'' ELSE (SELECT TOP 1 convert(nvarchar(50), ceiling(V.ACCUMULATED_CHILD_QTY) ) '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									FROM DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									WHERE V.DIVISION_ID=A.DIVISION_ID AND V.OPERATION_GROUP_ID=''A'''+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									AND V.MODEL_ID  = A.ITEM_ID AND V.CHILD_ITEM_ID=A.CELL_ITEM_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									) END AS CELL_QTY_PACK_T'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_SITE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_SITE2'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID=A.TO_SITE), '''') , ''-'') AS TO_SITE_DESCRIPTION'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_BOH_QTY'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_BOH_QTY'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( A.INCOTERMS, '''') , ''-'') AS INCOTERMS'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_SITE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID=A.FROM_SITE), '''') , ''-'') AS FROM_SITE_DESCRIPTION'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( A.TRANSPORT_MODE_LINE, '''') , ''-'') AS TRANSPORT_MODE_LINE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.BOD_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE10'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.MEASURE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.COLUMN_LABEL_NAME MEASURE_LABEL'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.SORT_ORDER_NO'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE3 AS MEASURE_COLOR'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				' + @mQry_sum +''+CHAR(10);
		SET @mEXEC = @mEXEC + ' 		into #TempTable'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0031_FNL A WITH(NOLOCK)'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 		GROUP BY A.DIVISION_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.OPERATION_GROUP'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CELL_ITEM_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ITEM_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_SITE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_SITE2'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_BOH_QTY'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_BOH_QTY'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.INCOTERMS'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_SITE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TRANSPORT_MODE_LINE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.BOD_ID'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE10'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.MEASURE'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.SORT_ORDER_NO'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.COLUMN_LABEL_NAME'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE3'+CHAR(10);
		--2021/11/19 SQL튜닝 반영 ADD
		SET @mEXEC = @mEXEC + 'option (maxdop 16) ;'+CHAR(10);
		--2021/11/19 SQL튜닝 반영 ADD
		--2021/11/19 SQL튜닝 반영 DEL
		--SET @mEXEC = @mEXEC + '      ) A'+CHAR(10);
		--2021/11/19 SQL튜닝 반영 DEL
		--2021/11/19 SQL튜닝 반영 ADD
		-- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
		SET @mEXEC = @mEXEC + 'SELECT CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE convert(nvarchar(50), ('+CHAR(10);
		SET @mEXEC = @mEXEC + '		     B.lt_total )) END AS LT_DAY'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(NULLIF( A.CELL_QTY_PACK_T, '''') , ''-'') AS CELL_QTY_PACK'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(d.segment2,''-'') AS OPERATION_GROUP_NAME'+CHAR(10);
		SET @mEXEC = @mEXEC + '	       , ISNULL(H.DEPT_NAME_KO, ''-'') AS DEPT_NAME	                            '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.*'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , dbo.FN_GET_SCP_CELL_TYPE_SORT(v.cell_type) AS cell_type_sort '+CHAR(10); -- 20230613 Final Item) Cell Type Sort
		SET @mEXEC = @mEXEC + ' FROM #TempTable as A'+CHAR(10);
		--2021/11/19 SQL튜닝 반영 ADD

		--PJ20209642 : BOD LT 1단계 개발 ( scp_mst_bod_v.lt_total 로 변경)
		--SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod b WITH(NOLOCK)'+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON B.DIVISION_ID=A.DIVISION_ID AND B.BOD_ID=A.BOD_ID AND B.FROM_SITE=A.FROM_SITE '+CHAR(10);
		--SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_distribution_route r WITH(NOLOCK)'+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON R.route_id = B.route_id'+CHAR(10);
		--SET @mEXEC = @mEXEC + '      LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL l WITH(NOLOCK)'+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON l.lookup_type = ''INCOTERMS'' AND l.valid_yn    = ''Y'' AND b.incoterms = l.segment1'+CHAR(10);
		-- BOD 2단계 : scp_mst_bod_v -> scp_mst_bod_n_v
		--SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_v b WITH(NOLOCK)'+CHAR(10);
--chaan Row size limit 에러 수정		SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_n_v b WITH(NOLOCK)'+CHAR(10);
		SET @mEXEC = @mEXEC + '      LEFT MERGE JOIN SCP_ANL_BOD_N_V_PLAN_H b WITH(NOLOCK)'+CHAR(10);--chaan Row size limit 에러 수정
		SET @mEXEC = @mEXEC + '				ON B.DIVISION_ID=A.DIVISION_ID AND B.BOD_ID=A.BOD_ID AND B.FROM_SITE=A.FROM_SITE AND B.PLAN_NAME = '''+@p_plan_start_yyyymmdd+''' AND B.PLAN_TYPE = '''+@p_plan_type+''' AND B.PLAN_SEQ = '''+@p_seq+''' '+CHAR(10);

		SET @mEXEC = @mEXEC + '		 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d on d.LOOKUP_TYPE = ''OPERATION_GROUP'' and d.segment1 = a.operation_group'+CHAR(10);

		/********** DEPT NAME START **********/
			SET @mEXEC = @mEXEC+'			LEFT MERGE JOIN SCM_MST_SITE E '+CHAR(10);
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			BEGIN
				SET @mEXEC = @mEXEC+'			   ON E.division_id	= a.division_id '+CHAR(10);
				SET @mEXEC = @mEXEC+'			  AND E.SCM_SITE_ID	= a.TO_SITE '+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'			   on E.division_id	= a.origin_to_division_id '+CHAR(10);
				SET @mEXEC = @mEXEC+'			  and E.scm_site_id	= a.TO_SITE2'+CHAR(10);
			END
			SET @mEXEC = @mEXEC+'				  AND E.VALID_YN       = ''Y'' '+CHAR(10);


			SET @mEXEC = @mEXEC+'			LEFT MERGE JOIN ( SELECT *'+CHAR(10);
			SET @mEXEC = @mEXEC+'							  , ROW_NUMBER() OVER(PARTITION BY division_id , scm_site_id ,item_id  ORDER BY PROJECT_CODE) AS RANK_NUMBER '+CHAR(10);
			SET @mEXEC = @mEXEC+'			             FROM SCM_MST_SITE_ITEM  '+CHAR(10);
			SET @mEXEC = @mEXEC+'			             WHERE VALID_YN		=''Y'' '+CHAR(10);
			SET @mEXEC = @mEXEC+'			           ) F'+CHAR(10);

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			BEGIN
				SET @mEXEC = @mEXEC+'			    on F.division_id	= a.division_id '+CHAR(10);
				SET @mEXEC = @mEXEC+'			    and F.scm_site_id	= a.TO_SITE'+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'			    on F.division_id	= a.origin_to_division_id '+CHAR(10);
				SET @mEXEC = @mEXEC+'			    and F.scm_site_id	= a.TO_SITE2'+CHAR(10);
			END

			SET @mEXEC = @mEXEC+'					and F.item_id		= a.item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'					and F.VALID_YN		=''Y'' '+CHAR(10);
			SET @mEXEC = @mEXEC+'			        AND F.RANK_NUMBER  = 1'+CHAR(10);  -- PROJECT_CODE 가 없어 1건만 가져오기 위해 처리

			SET @mEXEC = @mEXEC+'			LEFT MERGE JOIN [dbo].[SCM_MST_SSO_USER_INFO] G WITH(NOLOCK) '+CHAR(10);
			SET @mEXEC = @mEXEC+'				   ON  substring( F.OWNER, 0, case when charindex('','',F.OWNER) = 0 then len(F.OWNER)+1 else charindex('','',F.OWNER) end ) = G.USER_ID '+CHAR(10);

			SET @mEXEC = @mEXEC+'			LEFT MERGE JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] H WITH(NOLOCK) '+CHAR(10);
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'				   ON  CASE WHEN a.DIVISION_ID = ''40'' THEN G.DEPT_ID ELSE E.DEPT_ID END  = H.DEPT_ID '+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'				   ON  CASE WHEN a.origin_to_division_id = ''40'' THEN G.DEPT_ID ELSE E.DEPT_ID END  = H.DEPT_ID '+CHAR(10);
			/********** DEPT NAME END **********/

		--SET @mEXEC = @mEXEC + '      LEFT OUTER JOIN SCM_MST_SITE_ITEM E WITH(NOLOCK)     '+CHAR(10);
		--IF @p_division_id != 'EE'
		--	BEGIN
		--		SET @mEXEC = @mEXEC+'			   ON A.DIVISION_ID	= E.DIVISION_ID                                     '+CHAR(10);
		--		SET @mEXEC = @mEXEC+'			  AND A.TO_SITE = E.SCM_SITE_ID     		                                    '+CHAR(10);
		--		SET @mEXEC = @mEXEC+'			  AND A.ITEM_ID	= E.ITEM_ID 			                                            '+CHAR(10);
		--	END
		--	ELSE
		--	BEGIN
		--		SET @mEXEC = @mEXEC+'			   ON A.DIVISION_ID	= E.DIVISION_ID 	                                    '+CHAR(10);
		--		SET @mEXEC = @mEXEC+'			  AND A.TO_SITE2 = E.SCM_SITE_ID                                        '+CHAR(10);
		--		SET @mEXEC = @mEXEC+'			  AND A.ITEM_ID	= E.ITEM_ID 				                                                '+CHAR(10);
		--	END
		--SET @mEXEC = @mEXEC + '      INNER JOIN SCM_MST_SSO_USER_INFO F WITH(NOLOCK)     '+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON E.OWNER = F.USER_ID	                                                                     '+CHAR(10);
		--SET @mEXEC = @mEXEC + '      INNER JOIN SCM_MST_SSO_DEPT_INFO G WITH(NOLOCK)     '+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON F.DEPT_ID = G.DEPT_ID                                                                '+CHAR(10);
		-- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
		SET @mEXEC = @mEXEC + '      LEFT MERGE JOIN scm_mst_final_item_v v 									                                    '+CHAR(10);
		SET @mEXEC = @mEXEC + '				ON v.DIVISION_ID=A.DIVISION_ID AND v.ITEM_ID=A.ITEM_ID AND v.OPERATION_GROUP_ID=A.OPERATION_GROUP  '+CHAR(10);
		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC'+CHAR(10);
		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.BOD_ID , A.MEASURE_LABEL DESC'+CHAR(10); -- BOD 2단계
		-- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
		SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, v.RACK_YN DESC, v.DC_YN DESC, cell_type_sort, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE DESC, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.BOD_ID , A.MEASURE_LABEL DESC'+CHAR(10);


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
		EXEC (@mEXEC);

		PRINT 'Input Pivot set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	end;


	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_FNL') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_FNL;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_LOAD') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_LOAD;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_MEASURE') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_MEASURE;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_NICKITEM') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_NICKITEM;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_RANK') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_RANK;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_RESULT') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_RESULT;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_TEMP') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_TEMP;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0031_item') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0031_item;

END



  
