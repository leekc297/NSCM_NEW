
/*
 * Program ID   : DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT
 * Description  : Capacity Allocation 신규입력용 SALES LIST 조회
 * Comments     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/08/24	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/05	YHW				조회조건 변경 및 조회 항목 데이터 수정
 * 2018/11/05	YHW				조회쿼리 성능개선
 * ex )
 EXEC DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT @p_division_id='40',@p_from_yyyymm='201808', @p_to_yyyymm='201907', @p_item_id='MCCM120510A1,MCCE132502A1',@debug_mode='T' 
 */
CREATE PROCEDURE [dbo].[DM0036_GET_CAPACITY_ALLOCATION_RATE_INPUT]
   @p_division_id	NVARCHAR(2)
  ,@p_from_yyyymm	NVARCHAR(6)
  ,@p_to_yyyymm		NVARCHAR(6)
  ,@p_item_id		NVARCHAR(MAX)
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


	declare @pv_division_id	NVARCHAR(2) = '';
	declare @pv_from_yyyymm	NVARCHAR(6) = '';
	declare @pv_to_yyyymm	NVARCHAR(6) = '';
	declare @pv_item_id		NVARCHAR(MAX)='';

	SET @pv_division_id		= @p_division_id;
	SET @pv_from_yyyymm		= @p_from_yyyymm;
	SET @pv_to_yyyymm		= @p_to_yyyymm;
	SET @pv_item_id			= @p_item_id;


	/********************************************************************************

	* 임시테이블만들기

	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_DM0036_01') IS NOT NULL
	DROP TABLE #TblDynamicPivot_DM0036_01
 
	--SALES SITE 조회
	SELECT DISTINCT A.DIVISION_ID
					, A.ITEM_ID
					, A.NICK_NAME
					, A.SCM_SITE_ID
					--, ISNULL(NULLIF(B.PROJECT_CODE,''),'-') PROJECT_CODE
					, A.PROJECT_CODE
					--, D.DEPT_NAME_KO
					, (Select TOP 1 TOKEN from dbo.UF_FX_String_Split (D.DEPT_NAME_KO,'.') as P ORDER BY P.NR DESC) AS DEPT_NAME_KO
					--, E.DEPT_NAME_KO UPPER_DEPT_NAME_KO
					, (Select TOP 1 TOKEN from dbo.UF_FX_String_Split (E.DEPT_NAME_KO,'.') as P ORDER BY P.NR DESC) AS UPPER_DEPT_NAME_KO
					, MONTH
					, CAPACITY_RATE
	INTO #TblDynamicPivot_DM0036_01
	FROM (
		SELECT A.DIVISION_ID
				, A.ITEM_ID MODEL_ID
				, A.ITEM_ID
				, C.NICK_NAME
				, B.SCM_SITE_ID
				, A.PROJECT_CODE
				, MAX(A.OWNER) OWNER, '999912' MONTH
				, 0 CAPACITY_RATE
				, 1 TYPE
			FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
			JOIN SCM_MST_SITE B WITH(NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.SITE_TYPE = 'SALES' AND B.VALID_YN='Y'
			JOIN SCM_MST_ITEM_SN C ON C.DIVISION_ID = A.DIVISION_ID AND C.ITEM_ID = A.ITEM_ID AND C.SCP_OPERATION_GROUP = 'A'
			WHERE A.DIVISION_ID = @pv_division_id
			AND A.ITEM_ID in (SELECT token FROM dbo.String_Split(@pv_item_id		,','))
			AND A.VALID_YN = 'Y'
		GROUP BY A.DIVISION_ID, A.ITEM_ID, C.NICK_NAME, B.SCM_SITE_ID, A.PROJECT_CODE
		UNION ALL
		select A.DIVISION_ID
				, B.MODEL_ID
				, A.ITEM_ID
				, E.NICK_NAME
				, C.SCM_SITE_ID
				, C.PROJECT_CODE
				, MAX(ISNULL(C.OWNER,'')) OWNER
				, '999912' MONTH, 0 CAPACITY_RATE
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
		AND A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@pv_item_id		,','))
		GROUP BY A.DIVISION_ID, A.ITEM_ID, E.NICK_NAME, C.SCM_SITE_ID, B.MODEL_ID, C.PROJECT_CODE
		/*
		SELECT A.DIVISION_ID
				, A.MODEL_ID
				, A.CHILD_ITEM_ID AS ITEM_ID
				, E.NICK_NAME
				, C.SCM_SITE_ID
				, C.PROJECT_CODE
				, MAX(C.OWNER) OWNER, '999912' MONTH
				, 0 CAPACITY_RATE
				, 2 TYPE
		FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
		JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B ON B.DIVISION_ID=A.DIVISION_ID AND B.MODEL_ID=A.MODEL_ID AND B.OPERATION_GROUP_ID='P'
		JOIN SCM_MST_SITE_ITEM C ON C.DIVISION_ID=B.DIVISION_ID AND C.ITEM_ID=B.MODEL_ID AND C.VALID_YN = 'Y'
		JOIN SCM_MST_SITE D ON D.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID AND D.SITE_TYPE='SALES' AND D.VALID_YN = 'Y'
		JOIN SCM_MST_ITEM_SN E ON E.DIVISION_ID = D.DIVISION_ID AND E.ITEM_ID=A.CHILD_ITEM_ID
		WHERE 1=1
		AND A.division_id   = @p_division_id
		AND A.child_item_id IN (SELECT token FROM dbo.String_Split(@p_item_id		,','))
		GROUP BY A.DIVISION_ID, A.MODEL_ID, A.CHILD_ITEM_ID, E.NICK_NAME, C.SCM_SITE_ID, C.PROJECT_CODE
		*/
	) A
	--LEFT JOIN DM_PLN_MKT_FCST B WITH(NOLOCK)
		--ON B.DIVISION_ID=A.DIVISION_ID
		--AND B.SCM_SITE_ID=A.SCM_SITE_ID
		--AND B.ITEM_ID=A.MODEL_ID
		--AND B.MEASURE='RTF'
		--AND B.YYYYMMDD >= @v_from_yyyymmdd
		--AND B.YYYYMMDD <= @v_to_yyyymmdd
	LEFT JOIN SCM_MST_SSO_USER_INFO C WITH(NOLOCK)
		ON substring( A.OWNER, 0, case when charindex(',',A.OWNER) = 0 then len(A.OWNER)+1 else charindex(',',A.OWNER) end ) = C.USER_ID
	LEFT JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK)
		ON C.DEPT_ID = D.DEPT_ID
	LEFT JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
		ON E.DEPT_ID = D.UPPER_DEPT_ID 
	WHERE 1=1
	--AND B.YYYYMMDD  >= @v_from_yyyymmdd
	--AND B.YYYYMMDD <= @v_to_yyyymmdd
   ;

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

		SELECT  @mQuery_cal = @mQuery_cal+ 'SUM(CASE WHEN MONTH= '''+month+''' THEN CAPACITY_RATE END) AS [M_'+month + '],'
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
		SET @mEXEC = @mEXEC + ' 		SELECT  DIVISION_ID, ITEM_ID, NICK_NAME, UPPER_DEPT_NAME_KO, DEPT_NAME_KO, PROJECT_CODE, SCM_SITE_ID, 1 LEVEL	' + CHAR(10);
		SET @mEXEC = @mEXEC + '  			,'+@mQuery_cal + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_DM0036_01																					' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 		GROUP BY DIVISION_ID, ITEM_ID, NICK_NAME, UPPER_DEPT_NAME_KO, DEPT_NAME_KO, PROJECT_CODE, SCM_SITE_ID			' + CHAR(10);
		--SET @mEXEC = @mEXEC + ' 		PIVOT (																											' + CHAR(10);
		--SET @mEXEC = @mEXEC + ' 				SUM(CAPACITY_RATE) FOR  month IN ('+@mQuery+')																	' + CHAR(10);
		--SET @mEXEC = @mEXEC + ' 				) AS A																									' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	)																													' + CHAR(10);
		SET @mEXEC = @mEXEC + ' 	SELECT DIVISION_ID, ITEM_ID, NICK_NAME, UPPER_DEPT_NAME_KO, DEPT_NAME_KO, PROJECT_CODE, SCM_SITE_ID, LEVEL, ''Y'' VALID_YN			' + CHAR(10);
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
								  
END
