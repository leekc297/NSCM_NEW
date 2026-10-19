

/*
 * Program ID   : SCP0012_GET_PSI
 * Description  : PSI 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge	Description
 *===================================================================================================
 * 2018/03/08   KYH			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/31   KYH			1년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월의 sum이 표시된다
 * 2018/07/02   KYH			신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
 * 2018/09/17   ygkim		생산, 출하 실적 추가
 * 2018/09/18   ygkim		Cell Type Gr 컬럼 추가
 * 2018/09/19   ygkim		속도 개선 LEFT JOIN 위치 변경
 * 2018/09/20   ygkim		생산 실적 가져올때 Division 40, TCO Cell 일 경우 Line 조건 제외
 * 2018/11/21	hwyoon		BOH 계산식 변경
 * 2018/11/22	hwyoon		LINE_TOTAL_LOAD_ENGINE 추가
 * 2019/06/11	hwyoon		(긴급) AMEND LINE_TOTAL_LOAD_ENGINE SUM 제외
 * 2019/10/21	hwyoon		오류수정 - 출하실적 조회 시 "삭제"수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
 * 2022/04/21	LWY  		1. LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 실적 조회 시 Weekly, Monly 집계 오류 수정
                            2. 출하실적 분리적용 - SCM_DNM_EXFACTORY_RESULT (내부실적) / SCM_DNM_SCS_SHIP_RESULT (외부협력사 실적)
 * 2022/04/29	LWY  		LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 과거 실적 구간 표시 ( Production(Amend), Shipment(Amend) )
 * 2022.05.13   LSC         PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2023/04/10   LWY			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023/07/05   HRK			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화코드 분리 대응 (CP 기준 조회 적용 : CA->CP 치환 적용)
 * 2023/07/17	HRK			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (8월 해외 오픈 대응)
 * 2023/07/26	HRK			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : SCP_MST_CELL_PROD_ASSY_MAP 참조시 Valid_yn = 'Y' 조건 추가

   EXEC SCP0012_GET_PSI @p_from_yyyymmdd='20180514', @p_to_yyyymmdd='20181118', @p_division_id='81', @p_operation_group='A', @p_From_Site='A040-A,G382-A,G451-A,G481-A', @p_item_id='', @p_program_id=NULL, @p_plan_start_yyyymmdd='20180514', @p_plan_type='PR
', @p_seq='7', @p_user_id=NULL
 */

CREATE PROCEDURE [dbo].[SCP0012_GET_PSI_NEW]
@p_from_yyyymmdd		 NVARCHAR(MAX) ,
@p_to_yyyymmdd			 NVARCHAR(MAX) ,
@p_division_id			 NVARCHAR(MAX) ,
@p_operation_group		 NVARCHAR(MAX) ,
@p_From_Site			 NVARCHAR(300) ,
@p_item_id				 NVARCHAR(300) ,
@p_electype			 NVARCHAR(300) ,
@p_program_id			 NVARCHAR(MAX) = 'SCP0012',
@p_plan_start_yyyymmdd  NVARCHAR(8) ,
@p_plan_type			 NVARCHAR(50),
@p_seq					 NVARCHAR(50),
@p_user_id				 NVARCHAR(MAX),
@p_cell_type_gr		 NVARCHAR(30) = '',
@debug_mode			 NVARCHAR(max) = 'F'
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8);
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8);
	DECLARE @v_from_result       AS NVARCHAR(8);
	DECLARE @v_to_result         AS NVARCHAR(8);

	SET @v_from_yyyymmdd = '';
	SET @v_to_yyyymmdd   = '';
	SET @v_from_result   = '';
	SET @v_to_result     = '';

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
	 /********************************************************************************
	 * 임시테이블만들기
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0012') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0012;

	/********************************************************************************
	 * 임시테이블만들기
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0012_TEMP') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0012_TEMP;

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	DECLARE @mEXEC NVARCHAR(MAX);

	CREATE TABLE #TblDynamicPivot_SCP0012 (
		 division_id	NVARCHAR(60)	,PLAN_START_YYYYMMDD	NVARCHAR(10)
		,PLAN_TYPE	NVARCHAR(100)	,SEQ			int
		,OPERATION_GROUP	NVARCHAR(20)	,OPERATION_GROUP_DESC			NVARCHAR(300)
		,FROM_SITE		NVARCHAR(60)	,ORIGIN_FROM_DIVISION_ID			NVARCHAR(60)
		,ORIGIN_TO_DIVISION_ID	NVARCHAR(60)	,ITEM_ID	NVARCHAR(100)
		,ELECTRODE_TYPE	NVARCHAR(60)	,PSI_TYPE	NVARCHAR(20)
		,PSI_NAME	NVARCHAR(100)	,PSI_VALUE	NVARCHAR(100)
		,PSI_SEQ	NVARCHAR(100)	,INVENTORY_SEQ	NVARCHAR(100)
		,yyyymmdd	NVARCHAR(10)	,yyyymm	NVARCHAR(10)
		,qty	BIGINT	,iso_week	INT
		,ATTRIBUTE9	NVARCHAR(150)
		,b_yyyymmdd	NVARCHAR(10)
	);


	/********************************************************************************
	 * BOH temp 테이블 생성
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
		DROP TABLE #BOH

	select a.*
	INTO #BOH
	from (
		SELECT SUM(ISNULL(PSI_BOH_QTY,0)) AS BOH, SITE_ID, ITEM_ID, 'Model Inventory' AS PSI_VALUE
		--INTO #BOH
		FROM SCP_PLN_PLANT_ONHAND WITH (NOLOCK, INDEX(PK_SCP_PLN_PLANT_ONHAND))
		WHERE DIVISION_ID             = @p_division_id
			AND STOCK_TYPE     NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전 제외
			AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
			AND PLAN_TYPE             = @p_plan_type
			AND SEQ                   = @p_seq
			AND YYYYMMDD              = @p_plan_start_yyyymmdd
		GROUP BY SITE_ID, ITEM_ID

		union all

		--INSERT INTO #BOH
		SELECT SUM(ISNULL(PSI_BOH_QTY,0)) AS BOH, SITE_ID, ITEM_ID,  'Formation Progress' AS PSI_VALUE
		FROM SCP_PLN_PLANT_ONHAND WITH (NOLOCK, INDEX(PK_SCP_PLN_PLANT_ONHAND))

		WHERE DIVISION_ID             = @p_division_id
			AND STOCK_TYPE    IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전
			AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
			AND PLAN_TYPE             = @p_plan_type
			AND SEQ                   = @p_seq
			AND YYYYMMDD              = @p_plan_start_yyyymmdd
		GROUP BY SITE_ID, ITEM_ID
	) a


	DECLARE @arr_from_site varchar(max) , @arr_item_id varchar(max), @arr_electrode_type varchar(max)
	
	SELECT @arr_from_site 		= ISNULL(@arr_from_site + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_From_Site,',')
	SELECT @arr_item_id 		= ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_electrode_type 	= ISNULL(@arr_electrode_type + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_electype,',')

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     INSERT #TblDynamicPivot_SCP0012																												  '+CHAR(10);
	SET @mEXEC = @mEXEC+'     SELECT        																																  '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.DIVISION_ID ,                                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.PLAN_START_YYYYMMDD ,                                                                                                                     '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.PLAN_TYPE ,                                                                                                                               '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.SEQ ,                                                                                                                                     '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.OPERATION_GROUP ,                                                                                                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  C.SEGMENT2 AS OPERATION_GROUP_DESC ,                                                                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.FROM_SITE ,                                                                                                                               '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  isnull(NULLIF(A.ORIGIN_FROM_DIVISION_ID, '''') , ''-'') as  ORIGIN_FROM_DIVISION_ID ,                                                       '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  isnull(NULLIF(A.ORIGIN_TO_DIVISION_ID,'''') , ''-'') as ORIGIN_TO_DIVISION_ID ,                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.ITEM_ID,                                                                                                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.ELECTRODE_TYPE,                                                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  A.PSI_TYPE, B.SEGMENT2 AS PSI_NAME ,                                                                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  isnull(NULLIF(CASE WHEN A.PSI_TYPE=''I''                                                                                                    '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		   THEN dbo.FN_GET_LOOKUP_CODE_DESC(''PSI_INVENTORY'', A.PSI_VALUE)                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		   ELSE A.PSI_VALUE                                                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  END,''''),''-'') AS PSI_VALUE ,                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  B.DISPLAY_SEQ AS PSI_SEQ,                                                                                                                   '+CHAR(10);
	--SET @mEXEC = @mEXEC+' 		  E.DISPLAY_SEQ AS INVENTORY_SEQ,                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  E.SEGMENT3 AS INVENTORY_SEQ,                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ''D_''+ A.yyyymmdd AS yyyymmdd ,                                                                                                            '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  o.basis_yyyymm AS yyyymm ,                                                                                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC+' 			 isnull(qty,0) AS qty ,                                                                                                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.ATTRIBUTE9																																	'+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ,A.yyyymmdd AS b_yyyymmdd																																	'+CHAR(10);

	-- SET @mEXEC = @mEXEC+'  FROM SCP_ANL_PSI_PRODUCTION (NOLOCK) A                                                                                                             '+CHAR(10);
	-- SET @mEXEC = @mEXEC+'  INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd                                                                          '+CHAR(10);
	-- SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) B on B.LOOKUP_TYPE=''PSI_TYPE'' and  A.PSI_TYPE=B.SEGMENT1                                         '+CHAR(10);
	-- SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) C on C.LOOKUP_TYPE=''OPERATION_GROUP'' and  A.OPERATION_GROUP = C.SEGMENT1                         '+CHAR(10);
	-- SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) E on E.LOOKUP_TYPE=''PSI_INVENTORY'' and  A.PSI_VALUE=E.SEGMENT1                                   '+CHAR(10);
	-- SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_MST_SITE (NOLOCK) D on A.DIVISION_ID=D.DIVISION_ID and A.FROM_SITE=D.SCM_SITE_ID and A.OPERATION_GROUP = D.OPERATION_GROUP           '+CHAR(10);

	SET @mEXEC = @mEXEC+'  FROM SCP_ANL_PSI_PRODUCTION A WITH(NOLOCK)                                                                                                            '+CHAR(10);
	SET @mEXEC = @mEXEC+'  INNER JOIN SCM_SYS_CALENDAR_M o WITH(NOLOCK) on A.yyyymmdd = o.basis_yyyymmdd                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) on B.LOOKUP_TYPE=''PSI_TYPE'' and  A.PSI_TYPE=B.SEGMENT1                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) on C.LOOKUP_TYPE=''OPERATION_GROUP'' and  A.OPERATION_GROUP = C.SEGMENT1                         '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E WITH(NOLOCK) on E.LOOKUP_TYPE=''PSI_INVENTORY'' and  A.PSI_VALUE=E.SEGMENT1                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_MST_SITE D WITH(NOLOCK) on A.DIVISION_ID=D.DIVISION_ID and A.FROM_SITE=D.SCM_SITE_ID and A.OPERATION_GROUP = D.OPERATION_GROUP           '+CHAR(10);
	
	SET @mEXEC = @mEXEC+'  WHERE 1=1                                                                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd				>= '''+@p_from_yyyymmdd+'''                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd				<= '''+@p_to_yyyymmdd+'''                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.division_id          = '''+@p_division_id   +'''                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.operation_group      = '''+@p_operation_group+'''                                                                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_start_yyyymmdd  = '''+@p_plan_start_yyyymmdd  +'''                                                                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_type            = '''+@p_plan_type +'''                                                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.seq       = '+@p_seq+'                                                                                                                    '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.PSI_VALUE <> ''ISSUM''                                                                                                                    '+CHAR(10);
    IF NOT(@p_From_Site IS NULL  OR  @p_From_Site ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( from_site       IN ('+@arr_from_site+') )				                          '+CHAR(10); END;
	IF NOT(@p_item_id IS NULL    OR  @p_item_id   ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( item_id         IN ('+@arr_item_id+') )								          '+CHAR(10); END;
	IF NOT(@p_electype IS NULL   OR  @p_electype  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( electrode_type  IN ('+@arr_electrode_type+') )							      '+CHAR(10); END;

	EXEC (@mEXEC);

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


	/********************************************************************************
	 * LINE PROD(%) 처리
	 ********************************************************************************/
	 /*
	 SELECT
			  A.DIVISION_ID ,
			  isnull(NULLIF(A.ORIGIN_FROM_DIVISION_ID, '') , '-') as  ORIGIN_FROM_DIVISION_ID ,
			  A.OPERATION_GROUP ,
			  A.FROM_SITE ,
			  A.ATTRIBUTE9,
			  A.PSI_TYPE,
			  isnull(NULLIF(CASE WHEN A.PSI_TYPE='I' THEN dbo.FN_GET_LOOKUP_CODE_DESC('PSI_INVENTORY', A.PSI_VALUE) ELSE A.PSI_VALUE END,''),'-') AS PSI_VALUE,
			  CASE WHEN f.working_time <= 0.0 THEN 0
					ELSE ISNULL( ( ( round(sum(a.qty * (g.tact_time/60)),0) / f.working_time ) ) ,0 ) *100
				END AS qty,
			  A.yyyymmdd AS b_yyyymmdd,
			  o.basis_yyyymm AS yyyymm ,
			  o.iso_week
	 INTO #TblDynamicPivot_SCP0012_TEMP
	 FROM SCP_ANL_PSI_PRODUCTION (NOLOCK) A
	 INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd
	 JOIN scp_anl_working_time f ON a.ORIGIN_FROM_DIVISION_ID = f.division_id and a.ATTRIBUTE9 = f.operation_id
							and a.FROM_SITE=f.scm_site_id
							and a.PSI_VALUE = f.line_id
							and a.yyyymmdd= f.yyyymmdd
	 JOIN scp_anl_tact_time g ON a.ORIGIN_FROM_DIVISION_ID = g.division_id and a.ATTRIBUTE9 = g.operation_id
							and a.FROM_SITE=g.scm_site_id
							and a.PSI_VALUE = g.line_id
							and a.ITEM_ID = g.item_id
							and a.yyyymmdd= g.yyyymmdd
	 WHERE 1=1
		  AND a.yyyymmdd				>= @p_from_yyyymmdd
		  AND a.yyyymmdd				<= @p_to_yyyymmdd
		  AND a.division_id          = @p_division_id
		  AND a.operation_group      = @p_operation_group
		  AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		  AND a.plan_type            = @p_plan_type
		  AND a.seq       = @p_seq
		  AND a.PSI_VALUE <> 'ISSUM'
		  AND A.PSI_TYPE='P'
	GROUP BY a.division_id, a.ORIGIN_FROM_DIVISION_ID, a.operation_group ,a.FROM_SITE ,a.ATTRIBUTE9 ,A.PSI_TYPE, a.PSI_VALUE, a.yyyymmdd,o.basis_yyyymm,o.iso_week, f.working_time
	;
	*/
	/*
	SELECT
			A.DIVISION_ID
		   , A.ORIGIN_FROM_DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.FROM_SITE
		   , A.ATTRIBUTE9
		   , A.PSI_TYPE
		   , A.PSI_VALUE
		   , CASE WHEN d.working_time <= 0.0 THEN 0
				ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
			END AS qty
			,a.B_yyyymmdd
			, c.basis_yyyymm AS yyyymm
			, c.iso_week
	INTO #TblDynamicPivot_SCP0012_TEMP
	FROM #TblDynamicPivot_SCP0012 A WITH(NOLOCK)
	JOIN scm_sys_calendar_m c ON a.B_yyyymmdd = c.basis_yyyymmdd
	JOIN scp_anl_working_time d ON a.ORIGIN_FROM_DIVISION_ID = d.division_id and a.ATTRIBUTE9 = d.operation_id
						and a.FROM_SITE=d.scm_site_id
						and a.PSI_VALUE = d.line_id
						and a.B_yyyymmdd= d.yyyymmdd
	JOIN scp_anl_tact_time e ON a.ORIGIN_FROM_DIVISION_ID = e.division_id and a.ATTRIBUTE9 = e.operation_id
						and a.FROM_SITE=e.scm_site_id
						and a.PSI_VALUE = e.line_id
						and a.ITEM_ID = e.item_id
						and a.B_yyyymmdd= e.yyyymmdd
	WHERE a.PSI_TYPE='P'
	GROUP BY a.division_id, a.ORIGIN_FROM_DIVISION_ID, a.operation_group ,a.FROM_SITE ,a.ATTRIBUTE9 ,A.PSI_TYPE, a.PSI_VALUE, a.B_yyyymmdd,c.basis_yyyymm,c.iso_week, d.working_time
	;
	*/

	/********************************************************************************
	 * 임시테이블만들기
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0012_02') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0012_02;

	CREATE TABLE #TblDynamicPivot_SCP0012_02 (
		 division_id				NVARCHAR(60)
		,PLAN_START_YYYYMMDD		NVARCHAR(10)
		,PLAN_TYPE					NVARCHAR(100)
		,SEQ						int
		,OPERATION_GROUP			NVARCHAR(20)
		,OPERATION_GROUP_DESC		NVARCHAR(300)
		,FROM_SITE					NVARCHAR(60)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(60)
		,ORIGIN_TO_DIVISION_ID		NVARCHAR(60)
		,ITEM_ID					NVARCHAR(100)
		,ELECTRODE_TYPE				NVARCHAR(60)
		,PSI_TYPE					NVARCHAR(20)
		,PSI_NAME					NVARCHAR(100)
		,PSI_VALUE					NVARCHAR(100)
		,PSI_SEQ					NVARCHAR(100)
		,INVENTORY_SEQ				NVARCHAR(100)
		,yyyymmdd					NVARCHAR(10)
		,yyyymm						NVARCHAR(10)
		,qty						BIGINT
		,iso_week					INT
	);

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     insert into #TblDynamicPivot_SCP0012_02			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     SELECT  A.DIVISION_ID ,           				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.PLAN_START_YYYYMMDD ,    					'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.PLAN_TYPE ,             					'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.SEQ ,                     					'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.OPERATION_GROUP ,         					'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  OPERATION_GROUP_DESC ,      					'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.FROM_SITE ,                					'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  ORIGIN_FROM_DIVISION_ID ,     				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  ORIGIN_TO_DIVISION_ID ,         				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.ITEM_ID,                      				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.ELECTRODE_TYPE,               				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  A.PSI_TYPE									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	  ,PSI_NAME ,                     				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  PSI_VALUE ,                      				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  PSI_SEQ,                          			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  INVENTORY_SEQ,                     			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  yyyymmdd ,                        			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  yyyymm ,                              		'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  qty ,                                  		'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     	  iso_week    									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     FROM #TblDynamicPivot_SCP0012 a					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     union all											'+CHAR(10);
	--LINE PROD(%)
	/*
	SET @mEXEC = @mEXEC+'     SELECT A.DIVISION_ID								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.PLAN_START_YYYYMMDD					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.PLAN_TYPE							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.SEQ									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.OPERATION_GROUP						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.OPERATION_GROUP_DESC					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.FROM_SITE							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.ORIGIN_FROM_DIVISION_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.ORIGIN_TO_DIVISION_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.ITEM_ID								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.ELECTRODE_TYPE						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.PSI_TYPE								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.PSI_NAME								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , ''Line Total Load Engine (%)'' AS PSI_VALUE	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.PSI_SEQ								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , ''N'' AS INVENTORY_SEQ					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.yyyymmdd								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.yyyymm								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , B.qty									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		   , A.iso_week								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	FROM #TblDynamicPivot_SCP0012 A WITH(NOLOCK)	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	JOIN #TblDynamicPivot_SCP0012_TEMP B WITH(NOLOCK)				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		 ON A.DIVISION_ID=B.DIVISION_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		AND A.ORIGIN_FROM_DIVISION_ID=B.ORIGIN_FROM_DIVISION_ID		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		AND A.OPERATION_GROUP = B.OPERATION_GROUP	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		AND A.FROM_SITE=B.FROM_SITE					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		AND A.ATTRIBUTE9 = B.ATTRIBUTE9				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		AND A.PSI_VALUE = B.PSI_VALUE				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		AND A.B_yyyymmdd = B.B_yyyymmdd				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     union all											'+CHAR(10);
	*/
	-- 생산 실적 From Site, Line, ItemID 기준
	SET @mEXEC = @mEXEC+'     SELECT distinct			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		a.division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	,a.plan_start_yyyymmdd												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,a.PLAN_TYPE																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,a.SEQ																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.operation_group																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.OPERATION_GROUP_DESC																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.FROM_SITE																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ORIGIN_FROM_DIVISION_ID																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ORIGIN_TO_DIVISION_ID																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,a.item_id																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ELECTRODE_TYPE																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_TYPE																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_NAME																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_VALUE																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_SEQ																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.INVENTORY_SEQ          																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.yyyymmdd       										'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.yyyymm																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.qty    																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.iso_week    													'+CHAR(10);
	SET @mEXEC = @mEXEC+'    FROM( 									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     SELECT distinct 									'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' ELSE r.division_id END) AS division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' WHEN '''+@p_division_id+'''=''EE_HM'' THEN ''EE_HM'' ELSE r.division_id END) AS division_id		'+CHAR(10); --div_commonization

	SET @mEXEC = @mEXEC+'     	   	,'''+@p_plan_start_yyyymmdd+''' AS plan_start_yyyymmdd												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_plan_type+''' AS PLAN_TYPE																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_seq+''' AS SEQ																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,r.SCM_SITE_ID																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,(case when SUBSTRING(r.item_id,2,1) = ''T'' or SUBSTRING(r.item_id,2,1) = ''I'' or SUBSTRING(r.item_id,2,1) = ''D'' then ''-'' else r.LINE_ID end) LINE_ID																				'+CHAR(10);
    SET @mEXEC = @mEXEC+'     		,r.item_id																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,''D_''+convert(nvarchar(8), r.plan_date,112)   yyyymmdd       										'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,c.basis_yyyymm AS yyyymm																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,r.actual_good_qty qty    																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week    													'+CHAR(10);

	--SET @mEXEC = @mEXEC+'     	FROM SCM_DNM_product_result_v r																			'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	FROM SCM_DNM_product_result_v r	WITH(NOLOCK)																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c WITH(NOLOCK) on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd					'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	WHERE 1=1																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND r.plan_date          >= convert(datetime, '''+@v_from_result+''')									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND r.plan_date          < convert(datetime, '''+@v_to_result+''' )										'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (''EE'',''EE_UC'') OR r.division_id = '''+@p_division_id+''' )							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''EE'')) OR r.division_id = '''+@p_division_id+''' )	'+CHAR(10); --div_commonization

	SET @mEXEC = @mEXEC+'     	AND r.scp_operation_group =  '''+@p_operation_group+'''													'+CHAR(10);
	IF NOT(@p_From_Site IS NULL     OR  @p_From_Site     ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( r.scm_site_id  IN ('+@arr_from_site+') )				'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL         OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( r.item_id      IN ('+@arr_item_id+') )			'+CHAR(10); END;
	IF NOT(@p_electype IS NULL  OR  @p_electype  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( r.electrode_type      IN ('+@arr_electrode_type+') )			'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     	) a			'+CHAR(10);
	IF @p_division_id IN ('EE','EE_UC')
		--BEGIN SET @mEXEC = @mEXEC+'     	JOIN #TblDynamicPivot_SCP0012 b on b.FROM_SITE = a.SCM_SITE_ID and b.PSI_VALUE = a.LINE_ID and b.ITEM_ID = a.item_id and b.PSI_TYPE = ''P''	 '+CHAR(10); END
		BEGIN SET @mEXEC = @mEXEC+'     	JOIN #TblDynamicPivot_SCP0012 b on b.FROM_SITE = a.SCM_SITE_ID and b.PSI_VALUE = a.LINE_ID and b.ITEM_ID = a.item_id and b.PSI_TYPE IN (''P'',''PA'')	 '+CHAR(10); END    -- 2022/04/29
	ELSE
		--BEGIN SET @mEXEC = @mEXEC+'     	JOIN #TblDynamicPivot_SCP0012 b on b.division_id = a.DIVISION_ID and b.FROM_SITE = a.SCM_SITE_ID and b.PSI_VALUE = a.LINE_ID and b.ITEM_ID = a.item_id and b.PSI_TYPE = ''P''	 '+CHAR(10); END
		BEGIN SET @mEXEC = @mEXEC+'     	JOIN #TblDynamicPivot_SCP0012 b on b.division_id = a.DIVISION_ID and b.FROM_SITE = a.SCM_SITE_ID and b.PSI_VALUE = a.LINE_ID and b.ITEM_ID = a.item_id and b.PSI_TYPE IN (''P'',''PA'')	 '+CHAR(10); END  -- 2022/04/29

	SET @mEXEC = @mEXEC+'     	union all																								'+CHAR(10);
		-- 출하실적 From Site, To Site, ItemID 기준
	SET @mEXEC = @mEXEC+'     	select  																						'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' ELSE sr.division_id END) AS division_id	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' WHEN '''+@p_division_id+'''=''EE_HM'' THEN ''EE_HM'' ELSE sr.division_id END) AS division_id	'+CHAR(10); --div_commonization

	SET @mEXEC = @mEXEC+'     	   	,'''+@p_plan_start_yyyymmdd+''' AS plan_start_yyyymmdd												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_plan_type+''' AS PLAN_TYPE																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_seq+''' AS SEQ																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.operation_group																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.OPERATION_GROUP_DESC																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.FROM_SITE																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.division_id as ORIGIN_FROM_DIVISION_ID															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ORIGIN_TO_DIVISION_ID																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,sr.item_id																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ELECTRODE_TYPE																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_TYPE																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_NAME																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_VALUE																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_SEQ																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,INVENTORY_SEQ           																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,''D_''+convert(nvarchar(8), sr.exfactory_date,112)   yyyymmdd       								'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,c.basis_yyyymm AS yyyymm																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,sr.exfactory_qty qty  																				'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week    													'+CHAR(10);

	--SET @mEXEC = @mEXEC+'     	from SCM_DNM_EXFACTORY_RESULT sr																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	from SCM_DNM_EXFACTORY_RESULT sr WITH(NOLOCK) 																		'+CHAR(10);

	-- 내부실적인것만
	SET @mEXEC = @mEXEC+'     	JOIN scm_mst_site ms WITH(NOLOCK)		      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	  ON sr.DIVISION_ID = ms.DIVISION_ID	      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 AND sr.FROM_SCM_SITE_ID = ms.SCM_SITE_ID	      														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 AND ms.OSP_YN = ''N''	                  															    '+CHAR(10);

	SET @mEXEC = @mEXEC+'     	JOIN (SELECT distinct  A.DIVISION_ID ,      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.PLAN_START_YYYYMMDD ,    																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.PLAN_TYPE ,             																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.SEQ ,                     																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.OPERATION_GROUP ,         																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				OPERATION_GROUP_DESC ,      																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.FROM_SITE ,                																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			ORIGIN_FROM_DIVISION_ID ,     																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			ORIGIN_TO_DIVISION_ID ,         															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.ITEM_ID,                      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.ELECTRODE_TYPE,               															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			A.PSI_TYPE																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			,PSI_NAME ,                     															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			PSI_VALUE ,                     															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			PSI_SEQ,																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				INVENTORY_SEQ																				'+CHAR(10);
	IF @p_division_id IN ('EE','EE_UC') --Division 조건 제외
		--BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.PSI_VALUE = sr.TO_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE = ''S''	 '+CHAR(10); END
		BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.PSI_VALUE = sr.TO_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE IN (''S'',''SA'')	 '+CHAR(10); END   -- 2022/04/29
	ELSE IF @p_division_id = '40' --To Site 조건 제외
		--BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.division_id = sr.DIVISION_ID and b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE = ''S''	 '+CHAR(10); END
		BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.division_id = sr.DIVISION_ID and b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE IN (''S'',''SA'')	 '+CHAR(10); END   -- 2022/04/29
	ELSE
		--BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.division_id = sr.DIVISION_ID and b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.PSI_VALUE = sr.TO_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE = ''S''	 '+CHAR(10); END
		BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.division_id = sr.DIVISION_ID and b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.PSI_VALUE = sr.TO_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE IN (''S'',''SA'')	 '+CHAR(10); END  -- 2022/04/29

	--SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c on convert(nvarchar(8), sr.exfactory_date,112)  = c.basis_yyyymmdd			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c WITH(NOLOCK) on convert(nvarchar(8), sr.exfactory_date,112)  = c.basis_yyyymmdd			'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	where 1=1																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	and sr.exfactory_date          >= convert(datetime, '''+@v_from_result+''')								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND sr.exfactory_date          < convert(datetime, '''+@v_to_result+''' )								'+CHAR(10);
	-- 2019/10/21 추가(출하실적 삭제수량 제외)
	SET @mEXEC = @mEXEC+'     	AND sr.EXFACTORY_STATUS IN (''D20'',''D30'',''D40'')													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (''EE'',''EE_UC'') OR sr.division_id = '''+@p_division_id+''' )						'+CHAR(10);
	IF NOT(@p_From_Site IS NULL     OR  @p_From_Site     ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( sr.FROM_SCM_SITE_ID  IN ('+@arr_from_site+') )				'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL         OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( sr.item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	IF NOT(@p_electype IS NULL  OR  @p_electype  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( b.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;


	---------------------------------------------------  2022/04/15
	SET @mEXEC = @mEXEC+'     	union all																								'+CHAR(10);

	-- 외주(협력사) 출하실적 추가 ... lwy
	SET @mEXEC = @mEXEC+'     	select  																								'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' ELSE sr.division_id END) AS division_id	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' WHEN '''+@p_division_id+'''=''EE_HM'' THEN ''EE_HM'' ELSE sr.division_id END) AS division_id	'+CHAR(10); --div_commonization

	SET @mEXEC = @mEXEC+'     	   	,'''+@p_plan_start_yyyymmdd+''' AS plan_start_yyyymmdd												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_plan_type+''' AS PLAN_TYPE																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_seq+''' AS SEQ																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.operation_group																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.OPERATION_GROUP_DESC																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.FROM_SITE																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.division_id as ORIGIN_FROM_DIVISION_ID															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ORIGIN_TO_DIVISION_ID																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,sr.ITEM_ID																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ELECTRODE_TYPE																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_TYPE																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_NAME																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_VALUE																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_SEQ																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,INVENTORY_SEQ           																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,''D_''+convert(nvarchar(8), sr.SHIP_DATE,112)   yyyymmdd       									'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,c.basis_yyyymm AS yyyymm																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,sr.SHIP_QTY qty  																					'+CHAR(10);

  --SET @mEXEC = @mEXEC+'     		,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week    													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,RIGHT(c.basis_yyyymm, 4) + c.iso_week AS iso_week    												'+CHAR(10);    --lwy
	--SET @mEXEC = @mEXEC+'     	  ,ms.OSP_YN    									'+CHAR(10);

--	SET @mEXEC = @mEXEC+'     	from SCM_DNM_SCS_SHIP_RESULT sr																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	from SCM_DNM_SCS_SHIP_RESULT sr	 WITH(NOLOCK)																		'+CHAR(10);

	-- 외주 인것만 ::  ms.OSP_YN = ''Y''
	SET @mEXEC = @mEXEC+'     	JOIN scm_mst_site ms WITH(NOLOCK)		      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	  ON sr.DIVISION_ID = ms.DIVISION_ID	      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 AND sr.SCM_SITE_ID = ms.SCM_SITE_ID	      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 AND ms.OSP_YN = ''Y''	                  															    '+CHAR(10);

	SET @mEXEC = @mEXEC+'     	JOIN (SELECT distinct  A.DIVISION_ID ,      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.PLAN_START_YYYYMMDD ,    																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.PLAN_TYPE ,             																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.SEQ ,                     																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.OPERATION_GROUP ,         																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				 OPERATION_GROUP_DESC ,      																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.FROM_SITE ,                																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 ORIGIN_FROM_DIVISION_ID ,     																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 ORIGIN_TO_DIVISION_ID ,         															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.ITEM_ID,                      															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.ELECTRODE_TYPE,               															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 A.PSI_TYPE,																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 PSI_NAME,                     																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 PSI_VALUE,                     															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	 			 PSI_SEQ,																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				 INVENTORY_SEQ																				'+CHAR(10);

	SET @mEXEC = @mEXEC+'               FROM #TblDynamicPivot_SCP0012 a 	                                                            '+CHAR(10);

	SET @mEXEC = @mEXEC+'     		 ) b 		              						   												    '+CHAR(10);
	SET @mEXEC = @mEXEC+'     		 on  b.DIVISION_ID	= sr.DIVISION_ID 		              						   				    '+CHAR(10);
	SET @mEXEC = @mEXEC+'     		 and b.FROM_SITE	= sr.SCM_SITE_ID	              						   				        '+CHAR(10);
	SET @mEXEC = @mEXEC+'     		 and b.PSI_VALUE	= sr.TO_SITE 	              						   				            '+CHAR(10);
	SET @mEXEC = @mEXEC+'     		 and b.ITEM_ID		= sr.ITEM_ID 	              						   				            '+CHAR(10);
	--SET @mEXEC = @mEXEC+'     		 and b.PSI_TYPE		= ''S'' 		           						   				                '+CHAR(10);
	SET @mEXEC = @mEXEC+'     		 and b.PSI_TYPE		IN (''S'',''SA'') 		           						   				        '+CHAR(10);   -- 2022/04/29

	--SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c on convert(nvarchar(8), sr.SHIP_DATE,112)  = c.basis_yyyymmdd					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c WITH(NOLOCK) on convert(nvarchar(8), sr.SHIP_DATE,112)  = c.basis_yyyymmdd					'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	where 1=1																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	and sr.SHIP_DATE          >= convert(datetime, '''+@v_from_result+''')									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND sr.SHIP_DATE          < convert(datetime, '''+@v_to_result+''' )									'+CHAR(10);

	--SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (''EE'',''EE_UC'') OR sr.division_id = '''+@p_division_id+''' )						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''EE'')) OR sr.division_id = '''+@p_division_id+''' )	'+CHAR(10); --div_commonization

	IF NOT(@p_From_Site IS NULL OR @p_From_Site ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( sr.SCM_SITE_ID   IN ('+@arr_from_site+') )	  '+CHAR(10); END;
	IF NOT(@p_item_id   IS NULL OR  @p_item_id  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( sr.ITEM_ID       IN ('+@arr_item_id+') )		  '+CHAR(10); END;
	IF NOT(@p_electype  IS NULL OR  @p_electype ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( b.electrode_type IN ('+@arr_electrode_type+') ) '+CHAR(10); END;

	---------------------------------------------------  2022/04/15


	EXEC (@mEXEC);
	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------
	IF( @debug_mode ='T')
		BEGIN
			DECLARE @POS2 INT =1;
			DECLARE @LEN2 INT =LEN(@mEXEC);
			WHILE @POS2 <= @LEN2
				BEGIN
					PRINT SUBSTRING(@mEXEC,@POS2,4000);
					SET @POS2 = @POS2+4000;
				END;
		END;

 ---------------------------------------------------------------------------------------------------------------------
 ---### Begin 2023.07.05 활성화코드 분리 대응 : 모든 Cell Measure CP 기준 조회 (CA->CP 치환 적용) --> 2023.07월은 국내만.
 ---------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#tmp_CellProduct_INFO') IS NOT NULL
		DROP TABLE #tmp_CellProduct_INFO;

	SELECT M.DIVISION_ID
		  ,M.PLANT_ID
		  ,M.ITEM_ID_ASSY
		  ,M.ITEM_ID_PROD
		  ,FI.TCO_CELL_YN
		  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
										  ,M.ITEM_ID_ASSY
										  ,M.PLANT_ID
								  ORDER BY FI.TCO_CELL_YN  -- TCO보다 CP 우선 선택
										  ,M.ITEM_ID_PROD) PRIORITY_1ST
		  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
										  ,M.ITEM_ID_ASSY
								  ORDER BY FI.TCO_CELL_YN  -- TCO보다 CP 우선 선택
										  ,M.ITEM_ID_PROD) PRIORITY_2ND
		  ,ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
								  ORDER BY FI.TCO_CELL_YN  -- TCO보다 CP 우선 선택
										  ,M.ITEM_ID_PROD) PRIORITY_3RD
	 INTO #tmp_CellProduct_INFO
	 FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID = M.DIVISION_ID
				 AND FI.ITEM_ID		= M.ITEM_ID_PROD
	WHERE 1=1
	  AND M.VALID_YN = 'Y'
	;


IF OBJECT_ID('TEMPDB..#TblDynamicPivot_SCP0012_02_Final') IS NOT NULL
DROP TABLE #TblDynamicPivot_SCP0012_02_Final;

 SELECT
		X.DIVISION_ID
	   ,X.PLAN_START_YYYYMMDD
	   ,X.PLAN_TYPE
	   ,X.SEQ
	   ,X.OPERATION_GROUP
	   ,X.OPERATION_GROUP_DESC
	   ,X.FROM_SITE
	   ,X.ORIGIN_FROM_DIVISION_ID
	   ,X.ORIGIN_TO_DIVISION_ID
	   ,X.ITEM_ID	AS ITEM_ID_ORG
	   ,CASE WHEN X.OPERATION_GROUP = 'A'		AND
				  ISNULL(C1.ITEM_ID_PROD, ISNULL(C2.ITEM_ID_PROD, ISNULL(C3.ITEM_ID_PROD,'-'))) != '-'
			 THEN ISNULL(C1.ITEM_ID_PROD, ISNULL(C2.ITEM_ID_PROD, ISNULL(C3.ITEM_ID_PROD,'-')))
			 ELSE X.ITEM_ID
		END			AS ITEM_ID
	   ,X.ELECTRODE_TYPE
	   ,X.PSI_TYPE
	   ,X.PSI_NAME
	   ,X.PSI_VALUE
	   ,X.PSI_SEQ
	   ,X.INVENTORY_SEQ
	   ,X.YYYYMMDD
	   ,X.YYYYMM
	   ,X.QTY
	   ,X.ISO_WEEK
   INTO #TblDynamicPivot_SCP0012_02_Final
   FROM #TblDynamicPivot_SCP0012_02  X
	   INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
			   ON FS.DIVISION_ID  = X.DIVISION_ID
			  AND FS.SCM_SITE_ID  = X.FROM_SITE
	   LEFT  JOIN #tmp_CellProduct_INFO C1
			   ON C1.DIVISION_ID	= X.DIVISION_ID
			  AND C1.PLANT_ID		= FS.PLANT_ID
			  AND C1.ITEM_ID_ASSY	= X.ITEM_ID
			  AND C1.PRIORITY_1ST	= 1
	   LEFT  JOIN #tmp_CellProduct_INFO C2
			   ON C2.DIVISION_ID	= X.DIVISION_ID
			  AND C2.ITEM_ID_ASSY	= X.ITEM_ID
			  AND C2.PRIORITY_2ND	= 1
	   LEFT  JOIN #tmp_CellProduct_INFO C3
			   ON C3.ITEM_ID_ASSY	= X.ITEM_ID
			  AND C3.PRIORITY_3RD	= 1
 WHERE 1=1

 --------------------------------------------------------------------------------------------------------------------------
 ---### End 2023.07.05 활성화코드 분리 대응 : 모든 Cell Measure CP 기준 조회 (CA->CP 치환 적용) --> 2023.07월은 국내만.
 --------------------------------------------------------------------------------------------------------------------------

 /********************************************************************************
 * PIVOIT처리
 ********************************************************************************/
 begin
	DECLARE @mQry_sum NVARCHAR(MAX);

	-- PIVOIT 대상 날짜문자열 생성
	SET @mQry_sum = '';

	SELECT  @mQry_sum = @mQry_sum+','+
		CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END )  AS ' + yyyymmdd
			 WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 6) THEN QTY END ) AS ' + yyyymmdd
			 WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END) AS ' + yyyymmdd
		END +''+CHAR(10)
	FROM (
		SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
			, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
		FROM [dbo].[scm_sys_calendar_m] a
		WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
		GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
		UNION ALL
		SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
		  ,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
		FROM [dbo].[scm_sys_calendar_m] a
		WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
		GROUP BY a.basis_yyyymm, a.month_name
		UNION ALL
		SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
		  , a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
		FROM [dbo].[scm_sys_calendar_m] a
		WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
		GROUP BY a.basis_yyyymmdd
	) AS A
	ORDER BY sort_order_no  ;

	  DECLARE @arr_cell_type_gr varchar(max)
	  SELECT @arr_cell_type_gr     = ISNULL(@arr_cell_type_gr + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_cell_type_gr,',')

	  SET @mEXEC = '';
	  SET @mEXEC    = ' SELECT isnull(c.segment2,''-'') ''CELL_TYPE_GROUP_CODE'', a.* FROM (';
  SET @mEXEC = @mEXEC+'  SELECT
                         A.PSI_SEQ
                         ,A.INVENTORY_SEQ
                         ,A.DIVISION_ID
                         ,A.PLAN_START_YYYYMMDD
                         ,A.PLAN_TYPE
                         ,A.SEQ
                         ,A.OPERATION_GROUP
                         ,A.OPERATION_GROUP_DESC
                         ,A.ORIGIN_FROM_DIVISION_ID
                         ,A.FROM_SITE
                         ,(SELECT TOP 1 X.SITE_DESCRIPTION FROM SCM_MST_SITE X WITH (NOLOCK) WHERE X.SCM_SITE_ID = A.FROM_SITE) AS SITE_DESCRIPTION
                         ,A.ITEM_ID
                        ,(SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.item_id) AS NICK_NAME
                        ,(CASE WHEN A.ELECTRODE_TYPE IS NULL THEN ''-'' WHEN A.ELECTRODE_TYPE = '''' THEN ''-''  ELSE A.ELECTRODE_TYPE END) as ELECTRODE_TYPE
                        --,ISNULL((select sum(isnull(x.BOH,0))    from #BOH x with (nolock)    where   x.site_id= A.FROM_SITE  and x.item_id = A.ITEM_ID),0) AS BOH
						,ISNULL((select sum(isnull(x.BOH,0))    from #BOH x with (nolock)    where   x.site_id= A.FROM_SITE  and x.item_id = A.ITEM_ID AND A.PSI_VALUE=X.PSI_VALUE),0) AS BOH
                        ,A.ORIGIN_TO_DIVISION_ID
                        ,A.PSI_TYPE
                        ,A.PSI_NAME
                        ,(CASE WHEN A.PSI_VALUE is null then ''ISSUM'' ELSE A.PSI_VALUE END) AS ''PSI_VALUE''
                        ' +@mQry_sum + CHAR(10);
  -- 20230705 활성화코드 분리 대응 - 변경전 참조 SET @mEXEC = @mEXEC+'    FROM #TblDynamicPivot_SCP0012_02 A WITH (NOLOCK) '+CHAR(10);
  SET @mEXEC = @mEXEC+'    FROM #TblDynamicPivot_SCP0012_02_FInal A WITH (NOLOCK) '+CHAR(10);   -- 20230705 활성화코드 분리 대응 - 변경후 참조 (CA->CP 치환적용)
  SET @mEXEC = @mEXEC+'  GROUP BY A.DIVISION_ID ,
                               A.PLAN_START_YYYYMMDD ,
                               A.PLAN_TYPE ,
                               A.SEQ ,
                               A.OPERATION_GROUP,
                               A.OPERATION_GROUP_DESC,
                               A.PSI_NAME ,
                               A.ELECTRODE_TYPE,
                               A.ORIGIN_FROM_DIVISION_ID,
                               A.ORIGIN_TO_DIVISION_ID ,  '+CHAR(10);
  SET @mEXEC = @mEXEC+'  ROLLUP (A.PSI_SEQ,A.INVENTORY_SEQ, A.FROM_SITE , A.ITEM_ID , A.PSI_TYPE, A.PSI_VALUE ) '+CHAR(10);
  SET @mEXEC = @mEXEC+' ) A  ' +CHAR(10);
  SET @mEXEC = @mEXEC+' LEFT OUTER JOIN SCP_MST_FINAL_ITEM b on a.division_id = b.division_id and a.item_id = b.item_id and a.operation_group = b.operation_group	'+CHAR(10);
  SET @mEXEC = @mEXEC+' LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL c on c.LOOKUP_TYPE = ''CELL_TYPE_GROUP_CODE'' and c.segment1 = b.CELL_TYPE_GROUP_CODE			'+CHAR(10);
  SET @mEXEC = @mEXEC+' WHERE A.DIVISION_ID           IS NOT NULL
                        AND A.PLAN_START_YYYYMMDD     IS NOT NULL
                        AND A.PLAN_TYPE               IS NOT NULL
                        AND A.SEQ                     IS NOT NULL
                        AND A.OPERATION_GROUP         IS NOT NULL
                        AND A.FROM_SITE               IS NOT NULL
                        AND A.ITEM_ID                 IS NOT NULL
                        AND A.ELECTRODE_TYPE          IS NOT NULL
                        AND A.PSI_TYPE                IS NOT NULL
                        AND A.PSI_NAME                IS NOT NULL
                        AND NOT (A.PSI_TYPE=''I'' AND A.PSI_VALUE = ''ISSUM'' AND (A.INVENTORY_SEQ = ''N'' OR A.INVENTORY_SEQ = ''Z''))
						AND NOT (A.PSI_TYPE=''P'' AND A.PSI_VALUE = ''ISSUM'' AND A.INVENTORY_SEQ IS NOT NULL AND A.INVENTORY_SEQ = ''N'')
						AND NOT (A.PSI_TYPE=''PA'' AND A.PSI_VALUE = ''ISSUM'' AND A.INVENTORY_SEQ IS NOT NULL AND A.INVENTORY_SEQ = ''N'')
                        AND A.ORIGIN_FROM_DIVISION_ID IS NOT NULL
                        AND A.ORIGIN_TO_DIVISION_ID   IS NOT NULL  '+CHAR(10);
 IF NOT(@p_cell_type_gr IS NULL OR  @p_cell_type_gr    ='') BEGIN SET @mEXEC = @mEXEC+' and ( b.CELL_TYPE_GROUP_CODE  IN ('+@arr_cell_type_gr+') )					'+CHAR(10); END;
  SET @mEXEC = @mEXEC+' ORDER BY  A.DIVISION_ID , A.OPERATION_GROUP, A.FROM_SITE , A.ITEM_ID, A.ELECTRODE_TYPE, A.PSI_SEQ, A.INVENTORY_SEQ ASC /*, A.PSI_VALUE*/ '+CHAR(10);
  ;

  EXEC (@mEXEC);

 END

	--임시테이블 삭제
	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0012') is not null
		DROP TABLE #TblDynamicPivot_SCP0012

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0012_TEMP') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0012_TEMP;

	IF OBJECT_ID('tempdb.dbo.#BOH') is not null
		DROP TABLE #BOH

	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0012_02') is not null
		DROP TABLE #TblDynamicPivot_SCP0012_02

	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0012_02_Final') is not null
		DROP TABLE #TblDynamicPivot_SCP0012_02_Final

END

