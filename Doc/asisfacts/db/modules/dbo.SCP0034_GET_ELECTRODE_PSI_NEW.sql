
/*
 * Program ID   : SCP0034_GET_ELECTRODE_PSI
 * Description  : PSI Electrode 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge Description
 *===================================================================================================
 * 2018/10/10	hwyoon		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/10/21	hwyoon		오류수정 - 출하실적 조회 시 "삭제"수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
 * 2019/12/12	hwyoon		UI Category 수정 - Operation Group 코드명 컬럼 추가 (Pack, Cell)
 * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2023/04/10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 */

CREATE PROCEDURE [dbo].[SCP0034_GET_ELECTRODE_PSI_NEW]
 @p_from_yyyymmdd		 NVARCHAR(8) ,
 @p_to_yyyymmdd			 NVARCHAR(8) ,
 @p_division_id			 NVARCHAR(10) ,
 @p_operation_group		 NVARCHAR(10) ,
 @p_From_Site			 NVARCHAR(300) ,
 @p_item_id				 NVARCHAR(300) ,
 @p_electype			 NVARCHAR(10) ,
 @p_unit				 NVARCHAR(10) ,
 @p_program_id			 NVARCHAR(10) = 'SCP0034',
 @p_plan_start_yyyymmdd  NVARCHAR(8) ,
 @p_plan_type			 NVARCHAR(10),
 @p_seq					 NVARCHAR(10),
 @p_user_id				 NVARCHAR(100),
 @debug_mode			 NVARCHAR(10) = 'F'
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

	 IF (@debug_mode ='T')
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
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	DECLARE @mEXEC NVARCHAR(MAX);

	CREATE TABLE #TblDynamicPivot_SCP0012 (
		 DIVISION_ID			NVARCHAR(60)	,PLAN_START_YYYYMMDD		NVARCHAR(10)
		,PLAN_TYPE				NVARCHAR(100)	,SEQ						INT
		,OPERATION_GROUP		NVARCHAR(20)	,OPERATION_GROUP_DESC		NVARCHAR(300)
		,FROM_SITE				NVARCHAR(60)	,ORIGIN_FROM_DIVISION_ID	NVARCHAR(60)
		,ORIGIN_TO_DIVISION_ID	NVARCHAR(60)	,ITEM_ID					NVARCHAR(100)
		,ELECTRODE_TYPE			NVARCHAR(60)	,PSI_TYPE					NVARCHAR(20)
		,PSI_NAME				NVARCHAR(100)	,PSI_VALUE					NVARCHAR(100)
		,PSI_SEQ				NVARCHAR(100)	,INVENTORY_SEQ				NVARCHAR(100)
		,YYYYMMDD				NVARCHAR(10)	,YYYYMM						NVARCHAR(10)
		,QTY					BIGINT			,ISO_WEEK					INT
		,UNIT					NVARCHAR(10)
	);

-- 2023.12.13 천승호 인덱스 삭제
	--CREATE CLUSTERED INDEX [IX01_##TblDynamicPivot_SCP0012] ON #TblDynamicPivot_SCP0012 (
	--	 DIVISION_ID
	--	,OPERATION_GROUP
	--	,OPERATION_GROUP_DESC
	--	,FROM_SITE
	--	,ORIGIN_FROM_DIVISION_ID
	--	,ORIGIN_TO_DIVISION_ID
	--	,ITEM_ID
	--	,ELECTRODE_TYPE
	--	,UNIT
	--	,PSI_TYPE
	--	,PSI_NAME
	--	,PSI_VALUE
	--	,PSI_SEQ
	--	,INVENTORY_SEQ
	--	,yyyymmdd
	--	,yyyymm
	--);

	/********************************************************************************
	 * BOH temp 테이블 생성
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
		DROP TABLE #BOH

	SELECT SUM(ISNULL(PSI_BOH_QTY,0)) AS BOH, SITE_ID, ITEM_ID
    INTO #BOH
    FROM SCP_PLN_PLANT_ONHAND WITH (NOLOCK)
    WHERE DIVISION_ID               = @p_division_id
		AND STOCK_TYPE    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전 제외
		AND PLAN_START_YYYYMMDD       = @p_plan_start_yyyymmdd
		AND PLAN_TYPE                 = @p_plan_type
		AND SEQ                       = @p_seq
		AND YYYYMMDD                  = @p_plan_start_yyyymmdd
    GROUP BY SITE_ID,ITEM_ID
    ;

	DECLARE @arr_from_site varchar(max) , @arr_item_id varchar(max), @arr_electrode_type varchar(max), @arr_unit varchar(max)
	SELECT @arr_from_site = ISNULL(@arr_from_site + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_From_Site,',')
	SELECT @arr_item_id = ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_electrode_type = ISNULL(@arr_electrode_type + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_electype,',')
	SELECT @arr_unit = ISNULL(@arr_unit + ',''' + D.SEGMENT2 +'''', ''''+D.SEGMENT2+'''')
						FROM dbo.String_Split(@p_unit,',') A
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D on D.LOOKUP_TYPE = 'OPERATION_GROUP' AND D.SEGMENT1=A.token AND D.VALID_YN='Y'

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
	SET @mEXEC = @mEXEC+' 		  E.DISPLAY_SEQ AS INVENTORY_SEQ,                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ''D_''+ A.yyyymmdd AS yyyymmdd ,                                                                                                            '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  o.basis_yyyymm AS yyyymm ,                                                                                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC+' 			 isnull(qty,0) AS qty ,                                                                                                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week    ,                                                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ''Electrode'' AS unit																																  '+CHAR(10);
	SET @mEXEC = @mEXEC+'  FROM SCP_ANL_PSI_ELECTRODE (NOLOCK) A                                                                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+'  INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) B on B.LOOKUP_TYPE=''PSI_TYPE'' and  A.PSI_TYPE=B.SEGMENT1                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) C on C.LOOKUP_TYPE=''OPERATION_GROUP'' and  A.OPERATION_GROUP = C.SEGMENT1                         '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) E on E.LOOKUP_TYPE=''PSI_INVENTORY'' and  A.PSI_VALUE=E.SEGMENT1                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_MST_SITE (NOLOCK) D on A.DIVISION_ID=D.DIVISION_ID and A.FROM_SITE=D.SCM_SITE_ID and A.OPERATION_GROUP = D.OPERATION_GROUP           '+CHAR(10);
	SET @mEXEC = @mEXEC+'  WHERE 1=1                                                                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd				>= '''+@p_from_yyyymmdd+'''                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd				<= '''+@p_to_yyyymmdd+'''                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.division_id          = '''+@p_division_id   +'''                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.operation_group      = '''+@p_operation_group+'''                                                                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_start_yyyymmdd  = '''+@p_plan_start_yyyymmdd  +'''                                                                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_type            = '''+@p_plan_type +'''                                                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.seq       = '+@p_seq+'                                                                                                                    '+CHAR(10);
    IF NOT(@p_From_Site IS NULL  OR  @p_From_Site ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( from_site       IN ('+@arr_from_site+') )				                          '+CHAR(10); END;
	IF NOT(@p_item_id IS NULL    OR  @p_item_id   ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( item_id         IN ('+@arr_item_id+') )								          '+CHAR(10); END;
	IF NOT(@p_electype IS NULL   OR  @p_electype  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( electrode_type  IN ('+@arr_electrode_type+') )							      '+CHAR(10); END;
	SET @mEXEC = @mEXEC+' 	  UNION ALL																																		  '+CHAR(10);
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
	SET @mEXEC = @mEXEC+' 		  E.DISPLAY_SEQ AS INVENTORY_SEQ,                                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ''D_''+ A.yyyymmdd AS yyyymmdd ,                                                                                                            '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  o.basis_yyyymm AS yyyymm ,                                                                                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC+' 			 isnull(cell_qty,0) AS qty ,                                                                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week    ,                                                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC+' 		  ''Cell'' AS unit																																  '+CHAR(10);
	SET @mEXEC = @mEXEC+'  FROM SCP_ANL_PSI_ELECTRODE (NOLOCK) A                                                                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+'  INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) B on B.LOOKUP_TYPE=''PSI_TYPE'' and  A.PSI_TYPE=B.SEGMENT1                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) C on C.LOOKUP_TYPE=''OPERATION_GROUP'' and  A.OPERATION_GROUP = C.SEGMENT1                         '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL (NOLOCK) E on E.LOOKUP_TYPE=''PSI_INVENTORY'' and  A.PSI_VALUE=E.SEGMENT1                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+'  LEFT JOIN SCM_MST_SITE (NOLOCK) D on A.DIVISION_ID=D.DIVISION_ID and A.FROM_SITE=D.SCM_SITE_ID and A.OPERATION_GROUP = D.OPERATION_GROUP           '+CHAR(10);
	SET @mEXEC = @mEXEC+'  WHERE 1=1                                                                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd				>= '''+@p_from_yyyymmdd+'''                                                                                           '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND yyyymmdd				<= '''+@p_to_yyyymmdd+'''                                                                                             '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.division_id          = '''+@p_division_id   +'''                                                                                          '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.operation_group      = '''+@p_operation_group+'''                                                                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_start_yyyymmdd  = '''+@p_plan_start_yyyymmdd  +'''                                                                                   '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.plan_type            = '''+@p_plan_type +'''                                                                                              '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	  AND a.seq       = '+@p_seq+'                                                                                                                    '+CHAR(10);
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
	 * 임시테이블만들기
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0012_02') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0012_02;

	CREATE TABLE #TblDynamicPivot_SCP0012_02 (
		 DIVISION_ID			NVARCHAR(60)	,PLAN_START_YYYYMMDD		NVARCHAR(10)
		,PLAN_TYPE				NVARCHAR(100)	,SEQ						INT
		,OPERATION_GROUP		NVARCHAR(20)	,OPERATION_GROUP_DESC		NVARCHAR(300)
		,FROM_SITE				NVARCHAR(60)	,ORIGIN_FROM_DIVISION_ID	NVARCHAR(60)
		,ORIGIN_TO_DIVISION_ID	NVARCHAR(60)	,ITEM_ID					NVARCHAR(100)
		,ELECTRODE_TYPE			NVARCHAR(60)	,PSI_TYPE					NVARCHAR(20)
		,PSI_NAME				NVARCHAR(100)	,PSI_VALUE					NVARCHAR(100)
		,PSI_SEQ				NVARCHAR(100)	,INVENTORY_SEQ				NVARCHAR(100)
		,YYYYMMDD				NVARCHAR(10)	,YYYYMM						NVARCHAR(10)
		,QTY					BIGINT			,ISO_WEEK					INT
		,UNIT					NVARCHAR(10)
	);

-- 2023.12.13 천승호 인덱스 삭제
	--CREATE CLUSTERED INDEX [IX01_##TblDynamicPivot_SCP0012_02] ON #TblDynamicPivot_SCP0012_02 (
	--	 DIVISION_ID
	--	,OPERATION_GROUP
	--	,OPERATION_GROUP_DESC
	--	,FROM_SITE
	--	,ORIGIN_FROM_DIVISION_ID
	--	,ORIGIN_TO_DIVISION_ID
	--	,ITEM_ID
	--	,ELECTRODE_TYPE
	--	,UNIT
	--	,PSI_TYPE
	--	,PSI_NAME
	--	,PSI_VALUE
	--	,PSI_SEQ
	--	,INVENTORY_SEQ
	--	,YYYYMMDD
	--	,YYYYMM
	--);

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
 	SET @mEXEC = @mEXEC+'     	  iso_week ,   									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	  unit    									    '+CHAR(10);
	SET @mEXEC = @mEXEC+'     FROM #TblDynamicPivot_SCP0012 a					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     union all											'+CHAR(10);
	-- 생산 실적 From Site, Line, ItemID 기준
	SET @mEXEC = @mEXEC+'     SELECT distinct			                        '+CHAR(10);
	SET @mEXEC = @mEXEC+'     		a.division_id								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	,a.plan_start_yyyymmdd						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,a.PLAN_TYPE								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,a.SEQ										'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.operation_group							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.OPERATION_GROUP_DESC						'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,b.FROM_SITE								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ORIGIN_FROM_DIVISION_ID					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ORIGIN_TO_DIVISION_ID					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,a.item_id									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.ELECTRODE_TYPE							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_TYPE									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_NAME									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_VALUE								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.PSI_SEQ									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,b.INVENTORY_SEQ          					'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.yyyymmdd       							'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.yyyymm									'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.qty    									'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,a.iso_week    								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,''Electrode'' AS unit    							'+CHAR(10);
	SET @mEXEC = @mEXEC+'    FROM( 												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     SELECT distinct 									'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' ELSE r.division_id END) AS division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			(CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' WHEN '''+@p_division_id+'''=''EE_HM'' THEN ''EE_HM'' ELSE r.division_id END) AS division_id		'+CHAR(10); --div_commonization
	SET @mEXEC = @mEXEC+'     	   	,'''+@p_plan_start_yyyymmdd+''' AS plan_start_yyyymmdd												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_plan_type+''' AS PLAN_TYPE																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,'''+@p_seq+''' AS SEQ																				'+CHAR(10);
   	SET @mEXEC = @mEXEC+'     		,r.SCM_SITE_ID																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,(case when SUBSTRING(r.item_id,2,1) = ''T'' or SUBSTRING(r.item_id,2,1) = ''I'' or SUBSTRING(r.item_id,2,1) = ''D'' then ''-'' else r.LINE_ID end) LINE_ID	'+CHAR(10);
    SET @mEXEC = @mEXEC+'     		,r.item_id																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,''D_''+convert(nvarchar(8), r.plan_date,112)   yyyymmdd       										'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,c.basis_yyyymm AS yyyymm																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,r.actual_good_qty qty    																			'+CHAR(10);
 	SET @mEXEC = @mEXEC+'     		,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week    													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,''Electrode'' AS unit    																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	FROM SCM_DNM_product_result_v r																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	WHERE 1=1																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND r.plan_date          >= convert(datetime, '''+@v_from_result+''')									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND r.plan_date          < convert(datetime, '''+@v_to_result+''' )										'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (''EE'',''EE_UC'') OR r.division_id = '''+@p_division_id+''' )							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''EE'')) OR r.division_id = '''+@p_division_id+''' )	'+CHAR(10); --div_commonization
	SET @mEXEC = @mEXEC+'     	AND r.scp_operation_group =  '''+@p_operation_group+'''													'+CHAR(10);
	IF NOT(@p_From_Site IS NULL OR  @p_From_Site ='') BEGIN SET @mEXEC = @mEXEC+'   AND ( r.scm_site_id     IN ('+@arr_from_site+') )	'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL   OR  @p_item_id   ='') BEGIN SET @mEXEC = @mEXEC+'   AND ( r.item_id         IN ('+@arr_item_id+') )		'+CHAR(10); END;
	IF NOT(@p_electype IS NULL  OR  @p_electype  ='') BEGIN SET @mEXEC = @mEXEC+'   AND ( r.electrode_type  IN ('+@arr_electrode_type+') )	'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     	) a																										'+CHAR(10);
	IF @p_division_id IN ('EE','EE_UC')
		BEGIN SET @mEXEC = @mEXEC+'  JOIN #TblDynamicPivot_SCP0012 b on b.FROM_SITE = a.SCM_SITE_ID and b.PSI_VALUE = a.LINE_ID and b.ITEM_ID = a.item_id and b.PSI_TYPE = ''P''	 '+CHAR(10); END
	ELSE
		BEGIN SET @mEXEC = @mEXEC+'  JOIN #TblDynamicPivot_SCP0012 b on b.division_id = a.DIVISION_ID and b.FROM_SITE = a.SCM_SITE_ID and b.PSI_VALUE = a.LINE_ID and b.ITEM_ID = a.item_id and b.PSI_TYPE = ''P''	 '+CHAR(10); END

	SET @mEXEC = @mEXEC+'     	UNION ALL																								'+CHAR(10);
		-- 출하실적 From Site, To Site, ItemID 기준
	SET @mEXEC = @mEXEC+'     	SELECT  																								'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	 (CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' ELSE sr.division_id END) AS division_id	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		 (CASE WHEN '''+@p_division_id+'''=''EE'' THEN ''EE'' WHEN '''+@p_division_id+'''=''EE_UC'' THEN ''EE_UC'' WHEN '''+@p_division_id+'''=''EE_HM'' THEN ''EE_HM'' ELSE sr.division_id END) AS division_id	'+CHAR(10); --div_commonization
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
 	SET @mEXEC = @mEXEC+'     		,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week    													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     		,''Electrode'' AS unit    																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	FROM SCM_DNM_EXFACTORY_RESULT sr																		'+CHAR(10);
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
		BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.PSI_VALUE = sr.TO_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE = ''S''	 '+CHAR(10); END
	ELSE IF @p_division_id = '40' --To Site 조건 제외
		BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.division_id = sr.DIVISION_ID and b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE = ''S''	 '+CHAR(10); END
	ELSE
		BEGIN SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 a) b on b.division_id = sr.DIVISION_ID and b.FROM_SITE = sr.FROM_SCM_SITE_ID and b.PSI_VALUE = sr.TO_SCM_SITE_ID and b.ITEM_ID = sr.item_id and b.PSI_TYPE = ''S''	 '+CHAR(10); END

	SET @mEXEC = @mEXEC+'     	JOIN scm_sys_calendar_m c on convert(nvarchar(8), sr.exfactory_date,112)  = c.basis_yyyymmdd			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	WHERE 1=1																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND sr.exfactory_date          >= convert(datetime, '''+@v_from_result+''')								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND sr.exfactory_date          < convert(datetime, '''+@v_to_result+''' )								'+CHAR(10);
	-- 2019/10/21 추가(출하실적 삭제수량 제외)
	SET @mEXEC = @mEXEC+'     	AND sr.EXFACTORY_STATUS IN (''D20'',''D30'',''D40'')													'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (''EE'',''EE_UC'') OR sr.division_id = '''+@p_division_id+''' )						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	AND ( '''+@p_division_id+''' IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''EE'')) OR sr.division_id = '''+@p_division_id+''' )		'+CHAR(10);	--div_commonization
	IF NOT(@p_From_Site IS NULL OR  @p_From_Site ='') BEGIN SET @mEXEC = @mEXEC+'   AND ( sr.FROM_SCM_SITE_ID  IN ('+@arr_from_site+') )'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL   OR  @p_item_id   ='') BEGIN SET @mEXEC = @mEXEC+'   AND ( sr.item_id           IN ('+@arr_item_id+') )	'+CHAR(10); END;
	IF NOT(@p_electype IS NULL  OR  @p_electype  ='') BEGIN SET @mEXEC = @mEXEC+'   AND ( b.electrode_type     IN ('+@arr_electrode_type+') ) '+CHAR(10); END;

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
			 WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
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

  	 SET @mEXEC    = ' SELECT * FROM (';
	 SET @mEXEC = @mEXEC+'    SELECT
								  A.PSI_SEQ
								 ,A.INVENTORY_SEQ
								 ,(CASE WHEN A.PSI_VALUE is null then 2 ELSE 1 END) AS ''SUM_SORT''
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
								 ,ISNULL((select sum(isnull(x.BOH,0))    from #BOH x with (nolock)    where   x.site_id= A.FROM_SITE  and x.item_id = A.ITEM_ID),0) AS BOH
								 ,A.ORIGIN_TO_DIVISION_ID
								 ,A.UNIT
								 ,A.PSI_TYPE
								 ,A.PSI_NAME
								 ,(CASE WHEN A.PSI_VALUE is null then ''ISSUM'' ELSE A.PSI_VALUE END) AS ''PSI_VALUE''
								 ' +@mQry_sum + CHAR(10);
     SET @mEXEC = @mEXEC+'  FROM #TblDynamicPivot_SCP0012 A WITH (NOLOCK) '+CHAR(10);
     SET @mEXEC = @mEXEC+'  GROUP BY A.DIVISION_ID ,
									 A.PLAN_START_YYYYMMDD ,
									 A.PLAN_TYPE ,
									 A.SEQ ,
									 A.OPERATION_GROUP,
									 A.OPERATION_GROUP_DESC,
									 A.PSI_NAME ,
									 A.ELECTRODE_TYPE,
									 A.ORIGIN_FROM_DIVISION_ID,
									 A.ORIGIN_TO_DIVISION_ID ,
									 A.UNIT, '+CHAR(10);
     SET @mEXEC = @mEXEC+' ROLLUP (A.PSI_SEQ,A.INVENTORY_SEQ, A.FROM_SITE , A.ITEM_ID ,UNIT, A.PSI_TYPE, A.PSI_VALUE ) '+CHAR(10);
     SET @mEXEC = @mEXEC+' ) A  ' +CHAR(10);
     SET @mEXEC = @mEXEC+'WHERE A.DIVISION_ID           IS NOT NULL
							AND A.PLAN_START_YYYYMMDD     IS NOT NULL
							AND A.PLAN_TYPE               IS NOT NULL
							AND A.SEQ                     IS NOT NULL
							AND A.OPERATION_GROUP         IS NOT NULL
							AND A.FROM_SITE               IS NOT NULL
							AND A.ITEM_ID                 IS NOT NULL
							AND A.ELECTRODE_TYPE          IS NOT NULL
							AND A.PSI_TYPE                IS NOT NULL
							AND A.PSI_NAME                IS NOT NULL
							AND NOT (A.PSI_TYPE=''I'' AND A.PSI_VALUE = ''ISSUM'' )
							AND A.ORIGIN_FROM_DIVISION_ID IS NOT NULL
							AND A.ORIGIN_TO_DIVISION_ID   IS NOT NULL  '+CHAR(10);
      IF NOT(@p_unit IS NULL   OR  @p_unit  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( unit  IN ('+@arr_unit+') )		 '+CHAR(10); END;
      SET @mEXEC = @mEXEC+' ORDER BY  A.DIVISION_ID , A.OPERATION_GROUP, A.FROM_SITE , A.ITEM_ID, A.ELECTRODE_TYPE, A.UNIT, A.PSI_SEQ, A.INVENTORY_SEQ ASC, A.SUM_SORT /*, A.PSI_VALUE*/ '+CHAR(10);
      ;

  EXEC (@mEXEC);

 END

	--임시테이블 삭제
	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0012') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0012;

	IF OBJECT_ID('tempdb.dbo.#BOH') IS NOT NULL
		DROP TABLE #BOH;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0012_02') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0012_02;

END

