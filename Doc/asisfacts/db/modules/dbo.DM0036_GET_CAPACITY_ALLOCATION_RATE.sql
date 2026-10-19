


/*
 * Program ID   : DM0036_GET_CAPACITY_ALLOCATION_RATE
 * Description  : Capacity Allocation 리스트조회
 * Comments     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/08/24	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/05	YHW				조회조건 변경 및 조회 항목 데이터 수정
 * 2018/11/05	YHW				쿼리성능개선
 * ex )
 exec DM0036_GET_CAPACITY_ALLOCATION_RATE @p_division_id='40',@p_from_yyyymm='201808', @p_to_yyyymm='201907', @p_item_id='',@p_project_code='',@p_scm_site_id='',@debug_mode='T' 
 */
CREATE PROCEDURE [dbo].[DM0036_GET_CAPACITY_ALLOCATION_RATE]
   @p_division_id	NVARCHAR(2)
  ,@p_from_yyyymm	NVARCHAR(6)
  ,@p_to_yyyymm		NVARCHAR(6)
  ,@p_item_id		NVARCHAR(MAX)=''
  ,@p_project_code	NVARCHAR(MAX)=''
  ,@p_scm_site_id	NVARCHAR(MAX)=''
  ,@debug_mode		NVARCHAR(1) ='F'
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	


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
			PRINT '@p_division_id   = ' + @p_division_id ;
			PRINT '@p_from_yyyymm	= ' + @p_from_yyyymm ;
			PRINT '@p_to_yyyymm		= ' + @p_to_yyyymm	 ;
			PRINT '@p_item_id		= ' + @p_item_id	 ;
			PRINT '@p_from_yyyymm	= ' + @p_from_yyyymm ;
			PRINT '@p_to_yyyymm		= ' + @p_to_yyyymm	 ;
			PRINT '@v_from_yyyymmdd = ' + @v_from_yyyymmdd ;
			PRINT '@v_to_yyyymmdd   = ' + @v_to_yyyymmdd   ;
			PRINT '';
		END;


	/********************************************************************************

	* 임시테이블만들기

	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_DM0036_01') IS NOT NULL
	DROP TABLE #TblDynamicPivot_DM0036_01

	IF OBJECT_ID('tempdb..#TblDynamicPivot_DM0036_01_end') IS NOT NULL
	DROP TABLE #TblDynamicPivot_DM0036_01_end

	IF OBJECT_ID('tempdb..#TblDynamicPivot_DM0036_01_sales') IS NOT NULL
	DROP TABLE #TblDynamicPivot_DM0036_01_sales
 
	


	declare @pv_division_id	NVARCHAR(2) = '';
	declare @pv_from_yyyymm	NVARCHAR(6) = '';
	declare @pv_to_yyyymm		NVARCHAR(6) = '';
	declare @pv_item_id		NVARCHAR(MAX)='';
	declare @pv_project_code	NVARCHAR(MAX)='';
	declare @pv_scm_site_id	NVARCHAR(MAX)='';

	SET @pv_division_id		= @p_division_id;
	SET @pv_from_yyyymm		= @p_from_yyyymm;
	SET @pv_to_yyyymm		= @p_to_yyyymm;
	SET @pv_item_id			= @p_item_id;
	SET @pv_project_code	= @p_project_code;
	SET @pv_scm_site_id		= @p_scm_site_id;


	SELECT DISTINCT A.DIVISION_ID
					, A.ITEM_ID
					, A.NICK_NAME
					, A.SCM_SITE_ID
					, A.PROJECT_CODE
					, (Select TOP 1 TOKEN from dbo.UF_FX_String_Split (D.DEPT_NAME_KO,'.') as P ORDER BY P.NR DESC) AS DEPT_NAME_KO
					, (Select TOP 1 TOKEN from dbo.UF_FX_String_Split (E.DEPT_NAME_KO,'.') as P ORDER BY P.NR DESC) AS UPPER_DEPT_NAME_KO
					, MONTH
					, CAPACITY_RATE
					, 'Y' AS VALID_YN
	INTO #TblDynamicPivot_DM0036_01
	FROM (
		-- TYPE 1. 아이템별 전체 SALES SITE
		SELECT A.DIVISION_ID
			, A.ITEM_ID MODEL_ID
			, A.ITEM_ID
			, C.NICK_NAME
			, B.SCM_SITE_ID
			, A.PROJECT_CODE
			, MAX(ISNULL(A.OWNER,'')) OWNER
			, '999912' MONTH
			, 0 CAPACITY_RATE
			, 'Y' VALID_YN
			, 1 TYPE
			FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
			JOIN SCM_MST_SITE B WITH(NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.SITE_TYPE = 'SALES' AND B.VALID_YN='Y'
			JOIN SCM_MST_ITEM_SN C ON C.DIVISION_ID = A.DIVISION_ID AND C.ITEM_ID = A.ITEM_ID AND C.SCP_OPERATION_GROUP = 'A'
			WHERE A.DIVISION_ID = @pv_division_id
			AND ( ( @pv_item_id IS NULL OR     @pv_item_id     ='' ) OR A.ITEM_ID     IN (SELECT token FROM dbo.String_Split(@pv_item_id,',')) OR Exists (Select * from dbo.UF_FX_String_Split (@pv_item_id,',') as P Where C.NICK_NAME LIKE P.token +'%') ) -- OR C.NICK_NAME LIKE '%'+@p_item_id+'%'
			AND A.VALID_YN = 'Y'
			AND EXISTS (
						SELECT 'X' FROM DM_MST_CAPACITY_ALLOCATION D WITH(NOLOCK)
						WHERE D.DIVISION_ID = A.DIVISION_ID
						AND D.ITEM_ID=A.ITEM_ID
						)
		GROUP BY A.DIVISION_ID, A.ITEM_ID, C.NICK_NAME, B.SCM_SITE_ID, A.PROJECT_CODE
		UNION ALL
		-- TYPE 2. PACK BIZ로 들어오는 CELL들의 전체 SALES SITE
		select A.DIVISION_ID
				, B.MODEL_ID
				, A.ITEM_ID
				, E.NICK_NAME
				, C.SCM_SITE_ID
				, C.PROJECT_CODE
				, MAX(ISNULL(C.OWNER,'')) OWNER
				, '999912' MONTH, 0 CAPACITY_RATE
				, 'Y' VALID_YN
				, 2 TYPE
		from scp_mst_final_item a
		join SCM_MST_MODEL_FINAL_ITEM_BOM_V b on b.division_id = a.DIVISION_ID and b.child_item_id=a.ITEM_ID and b.OPERATION_GROUP_ID='A'
		join scp_mst_final_item F on F.DIVISION_ID = B.DIVISION_ID and F.ITEM_ID = b.MODEL_ID and F.OPERATION_GROUP = 'P'
		JOIN SCM_MST_SITE_ITEM C ON C.DIVISION_ID=B.DIVISION_ID AND C.ITEM_ID=B.MODEL_ID AND C.VALID_YN = 'Y'
		JOIN SCM_MST_SITE D ON D.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID AND D.SITE_TYPE='SALES' AND D.VALID_YN='Y'
		JOIN SCM_MST_ITEM_SN E ON E.DIVISION_ID = D.DIVISION_ID AND E.ITEM_ID=a.ITEM_ID
		where a.OPERATION_GROUP='A'
		--and a.FCST_YN='Y'
		and a.DIVISION_ID=@pv_division_id
		AND ( ( @pv_item_id IS NULL OR     @pv_item_id     ='' ) OR A.ITEM_ID     IN (SELECT token FROM dbo.String_Split(@pv_item_id,',')) OR Exists (Select * from dbo.UF_FX_String_Split (@pv_item_id,',') as P Where E.NICK_NAME LIKE P.token +'%'))
		AND EXISTS (
					SELECT 'X' FROM DM_MST_CAPACITY_ALLOCATION F WITH(NOLOCK)
					WHERE F.DIVISION_ID = A.DIVISION_ID
					AND F.ITEM_ID=A.ITEM_ID
					AND ( ( @pv_item_id IS NULL OR     @pv_item_id     ='' ) OR F.ITEM_ID     IN (SELECT token FROM dbo.String_Split(@pv_item_id,',')) )
					)
		GROUP BY A.DIVISION_ID, A.ITEM_ID, E.NICK_NAME, C.SCM_SITE_ID, B.MODEL_ID, C.PROJECT_CODE
		/*
		SELECT A.DIVISION_ID
				, A.MODEL_ID
				, A.CHILD_ITEM_ID AS ITEM_ID
				, E.NICK_NAME
				, C.SCM_SITE_ID
				, C.PROJECT_CODE
				, MAX(ISNULL(C.OWNER,'')) OWNER
				, '999912' MONTH, 0 CAPACITY_RATE
				, 'Y' VALID_YN
				, 2 TYPE
		FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
		JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B ON B.DIVISION_ID=A.DIVISION_ID AND B.MODEL_ID=A.MODEL_ID AND B.OPERATION_GROUP_ID='P'
		JOIN SCM_MST_SITE_ITEM C ON C.DIVISION_ID=B.DIVISION_ID AND C.ITEM_ID=B.MODEL_ID AND C.VALID_YN = 'Y'
		JOIN SCM_MST_SITE D ON D.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID AND D.SITE_TYPE='SALES' AND D.VALID_YN='Y'
		JOIN SCM_MST_ITEM_SN E ON E.DIVISION_ID = D.DIVISION_ID AND E.ITEM_ID=A.CHILD_ITEM_ID
		WHERE 1=1
		AND A.division_id   = @p_division_id
		AND ( ( @p_item_id IS NULL OR     @p_item_id     ='' ) OR A.child_item_id     IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) OR Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where E.NICK_NAME LIKE P.token +'%'))
		AND EXISTS (
						SELECT 'X' FROM DM_MST_CAPACITY_ALLOCATION F WITH(NOLOCK)
						WHERE F.DIVISION_ID = A.DIVISION_ID
						AND F.ITEM_ID=A.child_item_id
						AND ( ( @p_item_id IS NULL OR     @p_item_id     ='' ) OR F.ITEM_ID     IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
						)
		GROUP BY A.DIVISION_ID, A.CHILD_ITEM_ID, E.NICK_NAME, C.SCM_SITE_ID, A.MODEL_ID, C.PROJECT_CODE
		*/
		UNION ALL
		-- TYPE 3. 이미 입력된 CELL들의 전체 SALES SITE & CAPACITY RATE
		SELECT A.DIVISION_ID
				, A.ITEM_ID MODEL_ID
				, A.ITEM_ID
				, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.item_id) AS NICK_NAME
				, A.SCM_SITE_ID
				, A.END_CUSTOMER PROJECT_CODE
				, MAX(ISNULL(B.OWNER,'')) OWNER
				, A.YYYYMM MONTH
				, A.CAPACITY_RATE
				, CASE WHEN MAX(ISNULL(B.VALID_YN,'Y'))='N' OR MAX(ISNULL(C.VALID_YN,'Y'))='N' THEN 'N' ELSE 'Y' END VALID_YN
				, 3 TYPE
		FROM DM_MST_CAPACITY_ALLOCATION A WITH(NOLOCK)
		LEFT JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK) ON B.DIVISION_ID=A.DIVISION_ID AND (B.ITEM_ID = A.ITEM_ID or B.ATTRIBUTE5=A.ITEM_ID) AND B.SCM_SITE_ID=A.SCM_SITE_ID-- AND B.PROJECT_CODE = A.END_CUSTOMER
		LEFT JOIN SCM_MST_SITE C ON C.DIVISION_ID=A.DIVISION_ID AND C.SCM_SITE_ID = B.SCM_SITE_ID AND C.SITE_TYPE='SALES'
		LEFT JOIN SCM_MST_SSO_USER_INFO E WITH(NOLOCK)
			ON  substring( B.OWNER, 0, case when charindex(',',B.OWNER) = 0 then len(B.OWNER)+1 else charindex(',',B.OWNER) end ) = E.USER_ID 
		WHERE A.YYYYMM >= @pv_from_yyyymm
		  AND A.YYYYMM <= @pv_to_yyyymm
		  AND ( ( @pv_item_id IS NULL OR     @pv_item_id     ='' ) OR A.ITEM_ID     IN (SELECT token FROM dbo.String_Split(@pv_item_id,',')) OR
			Exists (Select * from dbo.UF_FX_String_Split (@pv_item_id,',') as P 
					Where (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-'  WHEN X.NICK_NAME = ''    THEN '-'  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.item_id) LIKE P.token +'%')
		  )
		  AND B.VALID_YN='Y'
		GROUP BY A.DIVISION_ID, A.ITEM_ID, A.SCM_SITE_ID, A.END_CUSTOMER, A.YYYYMM, A.CAPACITY_RATE
	) A
	LEFT JOIN SCM_MST_SSO_USER_INFO C WITH(NOLOCK)
		ON substring( A.OWNER, 0, case when charindex(',',A.OWNER) = 0 then len(A.OWNER)+1 else charindex(',',A.OWNER) end ) = C.USER_ID
	LEFT JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK)
		ON C.DEPT_ID = D.DEPT_ID
	LEFT JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
		ON E.DEPT_ID = D.UPPER_DEPT_ID 
	WHERE 1=1
   ;

	IF( ISNULL(@pv_project_code ,'') != '') 
	BEGIN
		SELECT DISTINCT ITEM_ID
		INTO #TblDynamicPivot_DM0036_01_end
		FROM #TblDynamicPivot_DM0036_01
		WHERE 1=1
		AND PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@pv_project_code,','))
	END;

	IF( ISNULL(@pv_scm_site_id ,'') != '') 
	BEGIN
		SELECT DISTINCT ITEM_ID
		INTO #TblDynamicPivot_DM0036_01_sales
		FROM #TblDynamicPivot_DM0036_01
		WHERE 1=1
		AND SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@pv_scm_site_id,','))
	END;


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

		SELECT  @mQuery_cal = @mQuery_cal+ 'SUM(CASE WHEN MONTH= '''+month+''' THEN CAPACITY_RATE END ) AS [M_'+month + '],'
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
		SET @mEXEC = @mEXEC + ' WITH DM0036 AS (																										' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		SELECT  DIVISION_ID, ITEM_ID, NICK_NAME, UPPER_DEPT_NAME_KO, DEPT_NAME_KO, PROJECT_CODE, SCM_SITE_ID, 1 LEVEL, VALID_YN	' + CHAR(10);
		SET @mEXEC = @mEXEC + '  			,'+@mQuery_cal + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_DM0036_01																					' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		WHERE 1=1																										' + CHAR(10);
		IF( ISNULL(@pv_project_code ,'') != '')
		BEGIN
			SET @mEXEC = @mEXEC + ' 	AND ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_DM0036_01_end)												' + CHAR(10);
		END;
		IF( ISNULL(@pv_scm_site_id ,'') != '')
		BEGIN
			SET @mEXEC = @mEXEC + ' 	AND ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_DM0036_01_sales)											' + CHAR(10);
		END;
		SET @mEXEC = @mEXEC + ' 		GROUP BY DIVISION_ID, ITEM_ID, NICK_NAME, UPPER_DEPT_NAME_KO, DEPT_NAME_KO, PROJECT_CODE, SCM_SITE_ID, VALID_YN	' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	)																													' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	SELECT DIVISION_ID, ITEM_ID, NICK_NAME, UPPER_DEPT_NAME_KO, DEPT_NAME_KO, PROJECT_CODE, SCM_SITE_ID, LEVEL, VALID_YN			' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		,'+@mQuery + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	FROM DM0036																											' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	UNION ALL																											' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	SELECT DIVISION_ID, ITEM_ID, NICK_NAME, ''Total'' UPPER_DEPT_NAME_KO, ''Total'' DEPT_NAME_KO, ''Total'' PROJECT_CODE, ''Total'' SCM_SITE_ID, 2 LEVEL, '''' VALID_YN	' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		, '+@mQuery_sum + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	FROM DM0036																											' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	GROUP BY DIVISION_ID, ITEM_ID, NICK_NAME																			' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	ORDER BY division_id, ITEM_ID, NICK_NAME, LEVEL, UPPER_DEPT_NAME_KO, DEPT_NAME_KO, SCM_SITE_ID, PROJECT_CODE		' + CHAR(10);

		IF( @debug_mode ='T') PRINT @mEXEC;
		EXEC (@mEXEC);

	END;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_DM0036_01') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_DM0036_01;
	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_DM0036_01_end') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_DM0036_01_end;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_DM0036_01_sales') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_DM0036_01_sales;
								  
END


