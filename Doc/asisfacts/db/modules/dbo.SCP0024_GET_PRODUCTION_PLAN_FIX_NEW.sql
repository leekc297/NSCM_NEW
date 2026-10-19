
/*
 * Program ID   : SCP0024_GET_PRODUCTION_PLAN_FIX
 * Description  : Production Plan Line 별 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/10   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/29   ygkim		   주차 Sum 가져오는 부분 수정
 * 2018/06/21   ygkim			fix Reason 가져오는 쿼리 수정
 * 2018/07/18   hwyoon			전극용 조회항목 추가
 ex)
   
  */

CREATE PROCEDURE [dbo].[SCP0024_GET_PRODUCTION_PLAN_FIX_NEW]
	 @p_division_id		NVARCHAR(50) 
	,@p_operation_group		NVARCHAR(50) 
	,@p_scm_site_id		NVARCHAR(MAX) 
	,@p_line_id			NVARCHAR(MAX) 
	,@p_item_id			NVARCHAR(MAX) 
	,@p_from_yyyymmdd	NVARCHAR(8)
    ,@p_to_yyyymmdd		NVARCHAR(8)
	,@p_electrode_type	NVARCHAR(30) = ''
	,@debug_mode		NVARCHAR(20)  ='T'
AS  

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0024') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0024
 
	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	 
	SELECT  
	         division_id
			,operation_group
			,scm_site_id
			,operation_id
			,line_id
			,item_id
			,measure			
			,qty
			,@p_from_yyyymmdd AS from_yyyymmdd
			,'D_'+yyyymmdd AS yyyymmdd
			,n.basis_yyyymm AS yyyymm
			,RIGHT(n.basis_yyyymm,4)+n.iso_week AS iso_week	
			,fix_reason
			,origin_division_id
			,electrode_type
	INTO #TblDynamicPivot_SCP0024
	  FROM (	 
	  SELECT 
	         division_id
			,operation_group
			,scm_site_id
			,operation_id
			,line_id
			,item_id
			--,'Prod Plan' as measure	
			,b.measure
			,yyyymmdd		
			--, Qty
			,case when b.measure = 'Fix Reason' then null else Qty end Qty
			,a.fix_reason
			,ISNULL(NULLIF(ORIGIN_DIVISION_ID,''),'-') origin_division_id
			,ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') electrode_type
	    FROM scp_anl_production_plan_fix a
			cross join (
				select 'Fix Reason' measure
				union all
				select 'Prod Plan' measure
			) b
		WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.operation_group      = @p_operation_group
			AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			AND ( ( @p_electrode_type IS NULL OR  @p_electrode_type  ='' ) OR a.ELECTRODE_TYPE  IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )

		--UNION ALL
		--SELECT 
	 --        division_id
		--	,operation_group
		--	,scm_site_id
		--	,operation_id
		--	,line_id
		--	,item_id
		--	,'Fix Reason' as measure	
		--	,yyyymmdd				
		--	,null as qty			
	 --   FROM scp_anl_production_plan_fix a
		--WHERE 1=1 
			--AND a.yyyymmdd			  >= @p_from_yyyymmdd
			--AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			--AND a.division_id	       = @p_division_id
			--AND a.operation_group      = @p_operation_group
			--AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			--AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			--AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )

		) m

		JOIN scm_sys_calendar_m n WITH(NOLOCK) on m.yyyymmdd = n.basis_yyyymmdd	
		--ORDER BY division_id, operation_group, scm_site_id, operation_id, line_id, item_id, yyyymmdd, measure desc

		;

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/
		BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mQuery = '';
		--SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
		SELECT  @mQuery = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'case when measure = ''Prod Plan'' then convert(nvarchar, convert(numeric,SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END ))) else null end AS ' + yyyymmdd
											WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'case when measure = ''Prod Plan'' then convert(nvarchar, convert(numeric,SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN  QTY  END ))) else null end AS ' + yyyymmdd
											WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'case when measure = ''Prod Plan'' then convert(nvarchar, convert(numeric,SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  END ))) else convert(nvarchar,max(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN fix_reason END )) end AS ' + yyyymmdd
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

		IF( LEN(@mQuery)>0)
			SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'       SELECT  '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	 division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_division_name(division_id) AS division_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,operation_group	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_lookup_code_desc(''OPERATION_GROUP'',operation_group) operation_group_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,scm_site_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_scm_site_description(division_id,scm_site_id) AS scm_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,operation_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,line_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_item_nickname (division_id, item_id ) AS nick_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,origin_division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,electrode_type	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			'+@mQuery	;
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0024 '+CHAR(10);
			SET @mEXEC = @mEXEC+'		GROUP BY  division_id, operation_group, scm_site_id, operation_id, line_id , item_id , measure,origin_division_id, electrode_type  '+CHAR(10);
			SET @mEXEC = @mEXEC+'		ORDER BY  division_id, operation_group, scm_site_id, operation_id, line_id , item_id , measure desc '+CHAR(10);

			EXEC (@mEXEC);

			/*
				SELECT 
				 division_id
				,operation_group
				,scm_site_id
				,operation_id
				,line_id
				,item_id
				,'Fix Reason' as measure	
				,yyyymmdd				
				,fix_reason
			FROM scp_anl_production_plan_fix a
			WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.operation_group      = @p_operation_group
			AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			*/

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

		END;
	
		 --임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0024') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0024 ;						  
END

