




/*
 * Program ID   : SCP0047_GET_KPI_TARGET
 * Description  : SCP KPI Target 리스트조회
 * Comments     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/12/19	YHW				Initial Release [] 전지GSCM(SCP) 운영
 * 
 */
CREATE PROCEDURE [dbo].[SCP0047_GET_KPI_TARGET]
   @p_kpi_id		NVARCHAR(100)
  ,@p_division_id	NVARCHAR(30)
  ,@p_from_yyyymm	NVARCHAR(6)
  ,@p_to_yyyymm		NVARCHAR(6)
  ,@debug_mode		NVARCHAR(1) ='F'
AS  
  
BEGIN

	DECLARE @p_from_yyyymmdd	AS NVARCHAR(8)='';
	DECLARE @p_to_yyyymmdd		AS NVARCHAR(8)='';
	DECLARE @v_from_yyyymmdd	AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd		AS NVARCHAR(8)='';

	-- 월의 시작일자 설정
	IF( ISNULL(@p_from_yyyymm ,'') ='') 
		SET @p_from_yyyymmdd =  '';
	ELSE
		SET @v_from_yyyymmdd =  @p_from_yyyymm +'01';

	-- 월의 마지막일자 설정
	IF( ISNULL(@p_to_yyyymm ,'') ='') 
		SET @p_to_yyyymmdd =  '';
	ELSE
		SET @v_to_yyyymmdd =  convert(varchar, dateadd(day,-1, dateadd(month, 1, convert(datetime,@p_to_yyyymm+'01'))) ,112) ;

	IF ( @debug_mode ='T')
		BEGIN
			PRINT '==============PARMS INFO================';
			PRINT '@p_kpi_id		= ' + @p_kpi_id ;
			PRINT '@p_division_id   = ' + @p_division_id ;
			PRINT '@p_from_yyyymm	= ' + @p_from_yyyymm ;
			PRINT '@p_to_yyyymm		= ' + @p_to_yyyymm	 ;
			PRINT '@p_from_yyyymm	= ' + @p_from_yyyymm ;
			PRINT '@p_to_yyyymm		= ' + @p_to_yyyymm	 ;
			PRINT '@v_from_yyyymmdd = ' + @v_from_yyyymmdd ;
			PRINT '@v_to_yyyymmdd   = ' + @v_to_yyyymmdd   ;
			PRINT '';
		END;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0047_LOOKUP') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0047_LOOKUP;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0047_PIVOT') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0047_PIVOT;

	declare @pv_kpi_id		NVARCHAR(100)='';
	declare @pv_division_id	NVARCHAR(30) = '';
	declare @pv_from_yyyymm	NVARCHAR(6) = '';
	declare @pv_to_yyyymm		NVARCHAR(6) = '';

	SET @pv_kpi_id			= @p_kpi_id;
	SET @pv_division_id		= @p_division_id;
	SET @pv_from_yyyymm		= @p_from_yyyymm;
	SET @pv_to_yyyymm		= @p_to_yyyymm;

	/* LOOK UP 조회 */
	SELECT A.SEGMENT1 AS KPI_ID
			, A.SEGMENT2 AS KPI_NM
			, A.SEGMENT3 AS DIVISION_ID
			, A.SEGMENT4 AS DEPT_ID
			, A.DISPLAY_SEQ
			, (Select TOP 1 TOKEN from dbo.UF_FX_String_Split (DEPT.DEPT_NAME_KO,'.') as P ORDER BY P.NR DESC) AS DEPT_NM
	INTO #TblDynamicPivot_SCP0047_LOOKUP
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
	JOIN SCM_MST_SSO_DEPT_INFO DEPT WITH(NOLOCK) ON DEPT.DEPT_ID=A.SEGMENT4
	WHERE A.LOOKUP_TYPE='SCM_KPI_GOAL'
	AND A.VALID_YN='Y'
	AND ( ( @pv_kpi_id IS NULL		OR     @pv_kpi_id      ='' ) OR A.SEGMENT1 IN (SELECT token FROM dbo.String_Split(@pv_kpi_id,',')) ) 
	AND ( ( @pv_division_id IS NULL OR     @pv_division_id ='' ) OR A.SEGMENT3 IN (SELECT token FROM dbo.String_Split(@pv_division_id,',')) )
	;


	SELECT A.KPI_ID
		, A.KPI_NM
		, A.DIVISION_ID
		, A.DEPT_ID
		, A.DEPT_NM
		, A.MONTH
		, A.KPI_TARGET
		, A.TYPE
		, A.DISPLAY_SEQ
	INTO #TblDynamicPivot_SCP0047_PIVOT
	FROM (
		-- TYPE 1. KPI별 전체 부서
		SELECT A.KPI_ID
			, A.KPI_NM
			, A.DIVISION_ID
			, A.DEPT_ID
			, A.DEPT_NM
			, '999912' MONTH
			, 0 KPI_TARGET
			, 1 TYPE
			, A.DISPLAY_SEQ
		FROM #TblDynamicPivot_SCP0047_LOOKUP A WITH(NOLOCK)
		--JOIN SCM_MST_SSO_DEPT_INFO DEPT WITH(NOLOCK) ON DEPT.DEPT_ID=A.DEPT_ID
		WHERE 1=1
		AND NOT EXISTS (
					SELECT 'X' FROM SCM_KPI_TARGET K WITH(NOLOCK)
					WHERE K.KPI_ID=A.KPI_ID
					AND K.DIVISION_ID=A.DIVISION_ID
					AND K.DEPT_ID = A.DEPT_ID
					AND K.YYYYMM >= @pv_from_yyyymm
					AND K.YYYYMM <= @pv_to_yyyymm
					)
		UNION ALL
		-- TYPE 2. 이미 입력된 KPI 목표
		SELECT A.KPI_ID
			, L.KPI_NM
			, A.DIVISION_ID
			, A.DEPT_ID
			, L.DEPT_NM
			, A.YYYYMM MONTH
			, A.KPI_TARGET
			, 2 TYPE
			, L.DISPLAY_SEQ
		FROM SCM_KPI_TARGET A WITH(NOLOCK)
		JOIN #TblDynamicPivot_SCP0047_LOOKUP L WITH(NOLOCK) ON L.KPI_ID=A.KPI_ID AND L.DIVISION_ID=A.DIVISION_ID AND L.DEPT_ID=A.DEPT_ID
		--JOIN SCM_MST_SSO_DEPT_INFO DEPT WITH(NOLOCK) ON DEPT.DEPT_ID=A.DEPT_ID
	) A


	BEGIN

		--월조회 쿼리문 생성
		DECLARE @mQuery_cal NVARCHAR(MAX);
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mQuery_sum NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

		SET @mQuery_cal = '';
		SET @mQuery = '';
		SET @mQuery_sum = '';
		SET @mEXEC = '';

		SELECT  @mQuery_cal = @mQuery_cal+ 'SUM(CASE WHEN MONTH= '''+month+''' THEN KPI_TARGET END ) AS [M_'+month + '],'
		FROM (
		SELECT a.basis_yyyymm  AS month
								,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
						GROUP BY a.basis_yyyymm, a.month_name	) AS A

		SET @mQuery_cal = LEFT(@mQuery_cal, LEN(@mQuery_cal) - 1);

		SELECT @mQuery = @mQuery + '[M_' + month + '], '
		FROM ( 	SELECT a.basis_yyyymm  AS month
						,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
				WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				GROUP BY a.basis_yyyymm, a.month_name	
				) AS A
		ORDER BY month  ;

		SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);


		SELECT @mQuery_sum = @mQuery_sum + 'SUM([M_' + month + ']) AS M_'+month+' , '
		FROM ( 	SELECT a.basis_yyyymm  AS month
						,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
				WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				GROUP BY a.basis_yyyymm, a.month_name	
				) AS A
		ORDER BY month  ;
		SET @mQuery_sum = LEFT(@mQuery_sum, LEN(@mQuery_sum) - 1);


		-- PIVOT 쿼리 실행
		SET @mEXEC = @mEXEC + ' WITH SCP0047 AS (																										' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		SELECT  KPI_ID, KPI_NM, DIVISION_ID, DEPT_ID, DEPT_NM, DISPLAY_SEQ	' + CHAR(10);
		SET @mEXEC = @mEXEC + '  			,'+@mQuery_cal + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0047_PIVOT																					' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		WHERE 1=1																										' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		GROUP BY KPI_ID, KPI_NM, DIVISION_ID, DEPT_ID, DEPT_NM, DISPLAY_SEQ	' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	)																													' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	SELECT A.KPI_ID, A.KPI_NM, A.DIVISION_ID, D.DIVISION_NAME, A.DEPT_ID, A.DEPT_NM	' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		,'+@mQuery + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	FROM SCP0047 A																											' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	JOIN SCM_MST_DIVISION D ON A.DIVISION_ID=D.DIVISION_ID																		' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	ORDER BY A.KPI_ID, A.DIVISION_ID, A.DISPLAY_SEQ																					' + CHAR(10);

		IF( @debug_mode ='T') PRINT @mEXEC;
		EXEC (@mEXEC);


	END;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0047_LOOKUP') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0047_LOOKUP;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0047_PIVOT') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0047_PIVOT;
								  
END




