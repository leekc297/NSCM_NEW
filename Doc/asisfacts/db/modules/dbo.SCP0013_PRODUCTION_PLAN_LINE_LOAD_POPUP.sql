


/*
 * Program ID   : SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP
 * Description  : Production Plan Line 별 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/02/22	hwyoon			[CSR ID:3929975] 각 라인/동별 부하율 팝업 창 설계 관련 사항의 건
 * 2019/06/07	hwyoon			[CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
 * 2021.10.14   KMJ			    PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 평균 소숫점 2자리
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 *
 ex)
   EXEC SCP0013_GET_PRODUCTION_PLAN_LINEBY @p_division_id='82', @p_operation_group='P', @p_scm_site_id='', @p_line_id='-', @p_item_id='', @p_from_yyyymmdd='20180514', @p_to_yyyymmdd='20181118', @p_plan_start_yyyymmdd='20180514', @p_plan_type='MA', @p_seq='1', @p_program_id='SCP0013', @p_sheet_name='LINE', @p_user_id='pasun2', @debug_mode='T'
 */

CREATE PROCEDURE [dbo].[SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP]

	 @p_division_id			NVARCHAR(50) 
	,@p_operation_group		NVARCHAR(10) 
	,@p_scm_site_id			NVARCHAR(MAX) 
	,@p_line_id				NVARCHAR(MAX) 
	,@p_from_yyyymmdd		NVARCHAR(8)
    ,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(2)
	,@debug_mode			NVARCHAR(1)

AS  

BEGIN


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_BASE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_BASE

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_QTY') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_QTY
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_SUM') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_SUM

	
	CREATE TABLE #TblDynamicPivot_SCP0013_QTY (
		division_id		NVARCHAR(30),	scm_site_id			NVARCHAR(30),	operation_id	NVARCHAR(30),	line_id	NVARCHAR(50),		qty			NUMERIC(20,10)	
	   ,working_time	INT,			load_qty			NUMERIC(20,10),	from_yyyymmdd	NVARCHAR(8),	yyyymmdd NVARCHAR(10),		yyyymm		NVARCHAR(6)
	   ,iso_week		NVARCHAR(6),	origin_division_id	NVARCHAR(30),	ELECTRODE_TYPE	NVARCHAR(30),	LINE_NAME NVARCHAR(150),	FACTORY_ID NVARCHAR(30)
	   ,FACTORY_NAME	NVARCHAR(150),	TYPE				INT,			TYPE2				INT,		OSP_YN			NVARCHAR(1)
	   ,week_yyyymmdd	NVARCHAR(10),	month_yyyymmdd		NVARCHAR(10)
	)


	SELECT a.DIVISION_ID
		,a.OPERATION_GROUP
		,SCM_SITE_ID
		,a.ITEM_ID
		,LINE_ID
		,OPERATION_ID
		,YYYYMMDD
		,QTY
		,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN LEFT(a.scm_site_id , LEN(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
		,ORIGIN_DIVISION_ID
		,ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') AS ELECTRODE_TYPE
	INTO #TblDynamicPivot_SCP0013_BASE
	FROM scp_anl_production_plan a WITH(NOLOCK)	
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
	AND a.line_id			  <> '*'
	AND a.measure              = upper('PROD_PLAN_AMEND') -- 315224
	;

	--라인별 부하율
	INSERT INTO #TblDynamicPivot_SCP0013_QTY
		(division_id,	scm_site_id,		operation_id,	line_id,	qty
		,working_time,	load_qty,			from_yyyymmdd,	yyyymmdd
		,origin_division_id,	ELECTRODE_TYPE,	LINE_NAME,	FACTORY_ID
		,FACTORY_NAME,	TYPE,				TYPE2,			OSP_YN
		)
	SELECT distinct
			a.division_id
			,a.scm_site_id
			,a.operation_id	
			,a.line_id
			,sum(a.qty * (e.tact_time/60)) qty
			,d.working_time
			, CASE WHEN d.working_time <= 0.0 THEN 0
					ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100  
				END AS load_qty
			,@p_from_yyyymmdd AS from_yyyymmdd
			,'D_'+a.yyyymmdd AS yyyymmdd
			,ISNULL(NULLIF(a.origin_division_id,''),'-') origin_division_id
			,L.ELECTRODE_TYPE
			,a.line_id AS LINE_NAME
			,L.FACTORY_ID
			,ISNULL(F.FACTORY_NAME, L.FACTORY_ID) AS FACTORY_NAME
			,3 AS TYPE
			,3 AS TYPE2
			,S.OSP_YN
	FROM #TblDynamicPivot_SCP0013_BASE a
	JOIN SCM_MST_SITE S ON S.SCM_SITE_ID=a.SCM_SITE_ID2
	LEFT JOIN SCM_MST_LINE_SN L ON L.COMPANY_ID=S.COMPANY_ID 
						   AND L.DIVISION_ID=S.DIVISION_ID
						   AND L.SITE_ID=S.SITE_ID
						   AND L.PLANT_ID=S.PLANT_ID
						   AND L.OPERATION_ID=a.operation_id
						   AND L.LINE_ID=a.line_id
						   AND L.ACTIVE_FLAG='Y'
	LEFT JOIN SCM_MST_FACTORY_SN F ON F.COMPANY_ID=S.COMPANY_ID 
								   AND F.DIVISION_ID=S.DIVISION_ID
								   AND F.SITE_ID=S.SITE_ID
								   AND F.PLANT_ID=S.PLANT_ID
								   AND F.FACTORY_ID = L.FACTORY_ID
	LEFT OUTER JOIN scp_anl_working_time d ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id 
			and a.SCM_SITE_ID2=d.scm_site_id 
			and a.line_id = d.line_id 
			and a.yyyymmdd= d.yyyymmdd
	LEFT OUTER JOIN scp_anl_tact_time e ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id 
			and a.SCM_SITE_ID2=e.scm_site_id  
			and a.line_id = e.line_id 
			and a.item_id = e.item_id 
			and a.yyyymmdd= e.yyyymmdd
	WHERE 1=1 
	GROUP BY a.division_id, a.operation_group		,a.scm_site_id		,a.operation_id		,a.line_id, a.yyyymmdd --,c.basis_yyyymm,c.iso_week
				, d.working_time, S.OSP_YN
				, a.origin_division_id
				,L.ELECTRODE_TYPE,L.LINE_NAME,L.FACTORY_ID,F.FACTORY_NAME --14196 5초
	;
		

	--동별 부하율
	INSERT INTO #TblDynamicPivot_SCP0013_QTY
		(division_id,	scm_site_id,		operation_id,	line_id,	qty
		,working_time,	load_qty,			from_yyyymmdd,	yyyymmdd
		,origin_division_id,	ELECTRODE_TYPE,	LINE_NAME,	FACTORY_ID
		,FACTORY_NAME,	TYPE,				TYPE2,			OSP_YN
		)
	SELECT DIVISION_ID
			, SCM_SITE_ID
			, OPERATION_ID
			, '-' AS LINE_ID
			, SUM(QTY) AS QTY
			, SUM(WORKING_TIME) AS WORKING_TIME
			, CASE WHEN SUM(WORKING_TIME) <= 0.0 THEN 0
					ELSE ISNULL( ( round(sum(QTY),0) / SUM(WORKING_TIME)  ),0 ) *100  
				END AS load_qty
			, FROM_YYYYMMDD
			, YYYYMMDD
			, ORIGIN_DIVISION_ID
			, ELECTRODE_TYPE
			, ELECTRODE_TYPE AS LINE_NAME
			, FACTORY_ID
			, FACTORY_NAME
			, 3 AS TYPE
			, 2 AS TYPE2
			, 'N' AS OSP_YN
	FROM #TblDynamicPivot_SCP0013_QTY
	WHERE TYPE=3
	AND OSP_YN='N'
	GROUP BY DIVISION_ID, SCM_SITE_ID, OPERATION_ID, FROM_YYYYMMDD, YYYYMMDD
	, ORIGIN_DIVISION_ID, ELECTRODE_TYPE, FACTORY_ID, FACTORY_NAME
	;

	--Plant별 부하율
	INSERT INTO #TblDynamicPivot_SCP0013_QTY
		(division_id,	scm_site_id,		operation_id,	line_id,	qty
		,working_time,	load_qty,			from_yyyymmdd,	yyyymmdd
		,origin_division_id,	ELECTRODE_TYPE,	LINE_NAME,	FACTORY_ID
		,FACTORY_NAME,	TYPE,				TYPE2,			OSP_YN
		)
	SELECT DIVISION_ID
		   , SCM_SITE_ID
		   , '-' OPERATION_ID
		   , '-' AS LINE_ID
		   , SUM(QTY) AS QTY
		   , SUM(WORKING_TIME) AS WORKING_TIME
		   , CASE WHEN SUM(WORKING_TIME) <= 0.0 THEN 0
					ELSE ISNULL( ( round(sum(QTY),0) / SUM(WORKING_TIME)  ),0 ) *100  
				END AS load_qty
		   , FROM_YYYYMMDD
		   , YYYYMMDD
		   , ORIGIN_DIVISION_ID
		   , ELECTRODE_TYPE
		   , '-' AS LINE_NAME
		   , ELECTRODE_TYPE AS FACTORY_ID
		   , ELECTRODE_TYPE AS FACTORY_NAME
		   , 1 AS TYPE
		   , 1 AS TYPE2
		   , 'N' AS OSP_YN
	FROM #TblDynamicPivot_SCP0013_QTY
	WHERE TYPE=3
	AND TYPE2=3
	AND OSP_YN='N'
	GROUP BY DIVISION_ID, SCM_SITE_ID, FROM_YYYYMMDD, YYYYMMDD, ORIGIN_DIVISION_ID, ELECTRODE_TYPE --4732 4초
	;


	/********************************************************************************
	* 임시테이블 처리
	********************************************************************************/
		SELECT DIVISION_ID
		   , SCM_SITE_ID
		   , OPERATION_ID
		   , LINE_ID
		   , QTY
		   , WORKING_TIME
		   , load_qty
		   , FROM_YYYYMMDD
		   , M.YYYYMMDD
			,o.basis_yyyymm AS yyyymm
			,RIGHT(o.basis_yyyymm,4)+o.iso_week AS iso_week
		   , ORIGIN_DIVISION_ID
		   , ELECTRODE_TYPE
		   , LINE_NAME
		   , FACTORY_ID
		   , FACTORY_NAME
		   , TYPE
		   , TYPE2
		   , OSP_YN
		INTO #TblDynamicPivot_SCP0013_SUM
		FROM (
			SELECT *
			FROM #TblDynamicPivot_SCP0013_QTY
		) m
		JOIN scm_sys_calendar_m o ON RIGHT(m.yyyymmdd, 8) = o.basis_yyyymmdd
		;


	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
	DECLARE @mQry_sum NVARCHAR(MAX);
	DECLARE @mDAY_QTY NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);

	SET @mQry_sum = '';
	SET @mDAY_QTY='LOAD_QTY';
	SET @mEXEC = ''

	/* ASIS 주석
	SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'convert(numeric(15,2),''0'') AS ' + yyyymmdd
											WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'convert(numeric(15,2),''0'') AS ' + yyyymmdd
											WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'convert(numeric(15,2),SUM(CASE WHEN yyyymmdd='''+yyyymmdd+''' THEN '+@mDAY_QTY+'  END)) AS ' + yyyymmdd
										END +''+CHAR(10) 
	*/
	SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'convert(numeric(15,2),SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+'  ELSE 0 END) / '+A.CNT+') AS ' + yyyymmdd
										    WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'convert(numeric(15,2),SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN '+@mDAY_QTY+' ELSE 0 END )) AS ' + yyyymmdd
										END +''+CHAR(10)
	FROM (
			SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
				, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
				, CONVERT(NVARCHAR(10),COUNT(1)) AS CNT
				FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

			UNION ALL

			SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
					, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
					, CONVERT(NVARCHAR(10),COUNT(1)) AS CNT
			FROM [dbo].[scm_sys_calendar_m] a WITH(NOLOCK)
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd

		) AS A
	ORDER BY sort_order_no;


	SET @mEXEC = @mEXEC + '   SELECT A.DIVISION_ID					' + CHAR(10); -- division
	SET @mEXEC = @mEXEC + '   	   , A.SCM_SITE_ID                  ' + CHAR(10); -- plant site
	SET @mEXEC = @mEXEC + '   	   , A.OPERATION_ID                 ' + CHAR(10); -- operation id
	SET @mEXEC = @mEXEC + '   	   , A.LINE_ID                      ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.ORIGIN_DIVISION_ID           ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.ELECTRODE_TYPE               ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.LINE_NAME                    ' + CHAR(10); -- line
	SET @mEXEC = @mEXEC + '   	   , A.FACTORY_ID                   ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.FACTORY_NAME                 ' + CHAR(10); -- Building
	SET @mEXEC = @mEXEC + '   	   , A.TYPE                         ' + CHAR(10);
	SET @mEXEC = @mEXEC+' 		   '+@mQry_sum	;
	SET @mEXEC = @mEXEC + '   FROM #TblDynamicPivot_SCP0013_SUM A   ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   GROUP BY A.DIVISION_ID                ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.SCM_SITE_ID                  ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.OPERATION_ID                 ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.LINE_ID                      ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.ORIGIN_DIVISION_ID           ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.ELECTRODE_TYPE               ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.LINE_NAME                    ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.FACTORY_ID                   ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.FACTORY_NAME                 ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.TYPE                         ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.TYPE2                         ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   	   , A.OSP_YN                       ' + CHAR(10);
	--SET @mEXEC = @mEXEC + '   ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, A.OPERATION_ID DESC, FACTORY_ID, ELECTRODE_TYPE, LINE_ID DESC             ' + CHAR(10);
	SET @mEXEC = @mEXEC + '   ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, TYPE DESC, FACTORY_ID, A.OPERATION_ID DESC, ELECTRODE_TYPE, TYPE2 DESC, LINE_ID             ' + CHAR(10);

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

	EXEC (@mEXEC);


	/********************************************************************************
	* 임시테이블삭제
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_BASE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_BASE

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_QTY') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_QTY			
	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_SUM') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0013_SUM			


END



