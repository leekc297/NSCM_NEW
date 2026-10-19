/*
 * Program ID   : SCP0003_GET_PRODUCTION_CAPACITY
 * Description  : Production Capacity QTY 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/08   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[DM0022_GET_PCAPACITY]

  @p_from_yyyymmdd  NVARCHAR(MAX),
  @p_to_yyyymmdd    NVARCHAR(MAX),
  @p_division_id	NVARCHAR(MAX),
  @p_plant_site		NVARCHAR(MAX),
  @p_factory_id		NVARCHAR(MAX),
  @p_operation_id	NVARCHAR(MAX),
  @p_line_id		NVARCHAR(MAX),
  @p_program_id		NVARCHAR(MAX) = 'SCP0003' ,
  @p_sheet_name		NVARCHAR(MAX) = 'Production Capacity', 
  @p_user_id		NVARCHAR(MAX) = '20140001'

AS  
  
BEGIN

  SET NOCOUNT ON;
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

  DECLARE @v_cnt_usr_measure	INT =0;

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*) 
								FROM scm_mst_titleset_user with(nolock) 
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name 
								 AND user_id     =  @p_user_id
							  )
  	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	--IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblDynamicPivot_SCP0003_01%')
	--	   DROP TABLE #TblDynamicPivot_SCP0003_01
    
	--CREATE TABLE #TblDynamicPivot_SCP0003_01 (
	--	     division_id	  NVARCHAR(60)
	--	   , scm_site_id	  NVARCHAR(60)
 --          , company_id		  NVARCHAR(60)
	--	   , site_id		  NVARCHAR(60)
	--	   , plant_id		  NVARCHAR(60)
	--	   , factory_id		  NVARCHAR(100)
	--	   , operation_id	  NVARCHAR(100)
	--	   , line_id		  NVARCHAR(100)
	--	   , item_id		  NVARCHAR(500)
	--	   , measure		  NVARCHAR(100)
	--	   , basis_yyyymmdd	  NVARCHAR(20)
	--	   , value			  DECIMAL(20,10)

	--);

   /********************************************************************************
	* 데이타조회, 임시테이블에 저장 (TACT_TIME)
	********************************************************************************/
	--INSERT INTO  #TblDynamicPivot_SCP0003_01 (division_id, scm_site_id, company_id, site_id, plant_id, factory_id, operation_id, line_id, item_id, measure, basis_yyyymmdd, value)
    SELECT  
		 t.division_id
		--,s.scm_site_id
		,t.company_id
		,t.site_id
		,t.PLANT_ID
		,t.factory_id
		,t.operation_id
		,t.line_id	
		,t.item_id
		--,'TACT_TIME' as measure
		--,'D_'+ q.basis_yyyymmdd as basis_yyyymmdd
		--,dbo.FN_GET_ITEM_LINE_TACT_TIME(t.division_id, s.scm_site_id, t.item_id, t.line_id, t.operation_id, q.basis_yyyymmdd ) AS value 
	--	select count(*)
	FROM SCM_MST_TACT_TIME_SN T WITH(NOLOCK)
	JOIN SCM_MST_SITE S WITH(NOLOCK) ON t.company_id = s.company_id AND t.division_id = s.division_id AND t.site_id = s.site_id AND t.PLANT_ID = s.PLANT_ID
	--JOIN (SELECT basis_yyyymmdd,calendar_yyyy FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
	--	   WHERE basis_yyyymmdd >= @p_from_yyyymmdd
	--	     --AND basis_yyyymmdd <= @p_to_yyyymmdd  ) q  on ( t.month = q.basis_yyyymm )
	--		AND basis_yyyymmdd <= @p_to_yyyymmdd  ) q  on ( SUBSTRING(t.month,1,4)  = q.calendar_yyyy )
	--WHERE 1=1
	--AND q.basis_yyyymmdd >= @p_from_yyyymmdd
 --   AND q.basis_yyyymmdd <= @p_to_yyyymmdd
	--AND (( @p_division_id IS NULL OR  @p_division_id='' ) OR t.division_id  IN (SELECT token FROM dbo.String_Split(@p_division_id ,',')) )
	--AND (( @p_plant_site IS NULL OR  @p_plant_site='' ) OR s.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site ,',')) )  
	--AND (( @p_factory_id IS NULL OR  @p_factory_id='' ) OR t.factory_id  IN (SELECT token FROM dbo.String_Split(@p_factory_id ,',')) )
	--AND (( @p_operation_id IS NULL OR  @p_operation_id='' ) OR t.operation_id  IN (SELECT token FROM dbo.String_Split(@p_operation_id ,',')) )
	--AND (( @p_line_id IS NULL OR  @p_line_id='' ) OR t.line_id  IN (SELECT token FROM dbo.String_Split(@p_line_id ,',')) )
	;

	return 0
   /********************************************************************************
	* 데이타조회, 임시테이블에 저장(YIELD)
    ********************************************************************************/
    INSERT INTO  #TblDynamicPivot_SCP0003_01 (division_id, scm_site_id, company_id, site_id,plant_id, factory_id, operation_id, line_id, item_id, measure, basis_yyyymmdd, value)
		SELECT 
		 t.division_id
		,s.scm_site_id
		,t.company_id
		,t.site_id
		,t.PLANT_ID
		,t.factory_id
		,t.operation_id
		,t.line_id	
		,t.item_id
		,'YIELD' as measure
		,'D_'+ q.basis_yyyymmdd as basis_yyyymmdd
		,dbo.FN_GET_ITEM_LINE_YIELD(t.division_id, s.scm_site_id, t.item_id, t.line_id, t.operation_id, q.basis_yyyymmdd ) * 100 AS value 
	FROM SCM_MST_YIELD_SN t WITH(NOLOCK)
	JOIN  (SELECT basis_yyyymmdd,calendar_yyyy FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		   WHERE basis_yyyymmdd >= @p_from_yyyymmdd
		   -- AND basis_yyyymmdd <= @p_to_yyyymmdd ) q on ( t.month = q.basis_yyyymm )
		   AND basis_yyyymmdd <= @p_to_yyyymmdd  ) q  on ( SUBSTRING(t.month,1,4)  = q.calendar_yyyy )
	JOIN SCM_MST_SITE S WITH(NOLOCK) ON t.company_id = s.company_id AND t.division_id = s.division_id AND t.site_id = s.site_id AND t.PLANT_ID = s.PLANT_ID
	WHERE 1=1
	AND q.basis_yyyymmdd >= @p_from_yyyymmdd
    AND q.basis_yyyymmdd <= @p_to_yyyymmdd
    AND (( @p_division_id IS NULL OR  @p_division_id='' ) OR t.division_id  IN (SELECT token FROM dbo.String_Split(@p_division_id ,',')) )
	AND (( @p_plant_site IS NULL OR  @p_plant_site='' ) OR s.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site ,',')) )  
	AND (( @p_factory_id IS NULL OR  @p_factory_id='' ) OR t.factory_id  IN (SELECT token FROM dbo.String_Split(@p_factory_id ,',')) )
	AND (( @p_operation_id IS NULL OR  @p_operation_id='' ) OR t.operation_id  IN (SELECT token FROM dbo.String_Split(@p_operation_id ,',')) )
	AND (( @p_line_id IS NULL OR  @p_line_id='' ) OR t.line_id  IN (SELECT token FROM dbo.String_Split(@p_line_id ,',')) )
    ;
    /********************************************************************************
	* 데이타조회, 임시테이블에 저장(WORKING_TIME)
    ********************************************************************************/
    INSERT INTO  #TblDynamicPivot_SCP0003_01 (division_id, scm_site_id, company_id, site_id,plant_id, factory_id, operation_id, line_id, item_id, measure, basis_yyyymmdd, value)
	SELECT  
		 t.division_id
		,s.scm_site_id
		,t.company_id
		,t.site_id
		,t.plant_id
		,t.factory_id
		,t.operation_id
		,t.line_id
		,y.ITEM_ID AS item_id
		,'WORKING_TIME' as measure
		,'D_'+ q.basis_yyyymmdd as basis_yyyymmdd
		,dbo.[FN_GET_LINE_WORKTIME_MIN](t.division_id, s.scm_site_id, t.line_id, t.operation_id, q.basis_yyyymmdd ) AS value 
	FROM SCM_MST_EQUIPMENT_SN t WITH(NOLOCK)
	JOIN SCM_MST_SITE S WITH(NOLOCK) on t.company_id = s.company_id and t.division_id = s.division_id and t.site_id = s.site_id and t.plant_id = s.plant_id 
	--JOIN #TblDynamicPivot_SCP0003_01 Y ON  t.division_id = y.division_id and s.scm_site_id = y.scm_site_id and t.factory_id = y.factory_id and t.operation_id = y.operation_id and t.line_id = y.line_id
	JOIN SCM_MST_YIELD_SN Y WITH(NOLOCK)  ON  t.company_id = y.company_id and t.division_id = y.division_id and t.site_id = y.site_id and t.plant_id =y.plant_id and t.factory_id = y.factory_id and t.operation_id = y.operation_id and t.line_id = y.line_id
	JOIN  (SELECT basis_yyyymmdd,calendar_yyyy FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
		   WHERE basis_yyyymmdd >= @p_from_yyyymmdd
		  --  AND basis_yyyymmdd <= @p_to_yyyymmdd ) q on ( y.month = q.basis_yyyymm )
		  AND basis_yyyymmdd <= @p_to_yyyymmdd  ) q  on ( SUBSTRING(y.month,1,4)  = q.calendar_yyyy )
	WHERE 1=1
	AND q.basis_yyyymmdd >= @p_from_yyyymmdd
    AND q.basis_yyyymmdd <= @p_to_yyyymmdd	
    AND (( @p_division_id IS NULL OR  @p_division_id='' ) OR t.division_id  IN (SELECT token FROM dbo.String_Split(@p_division_id ,',')) )
	AND (( @p_plant_site IS NULL OR  @p_plant_site='' ) OR s.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site ,',')) )  
	AND (( @p_factory_id IS NULL OR  @p_factory_id='' ) OR t.factory_id  IN (SELECT token FROM dbo.String_Split(@p_factory_id ,',')) )
	AND (( @p_operation_id IS NULL OR  @p_operation_id='' ) OR t.operation_id  IN (SELECT token FROM dbo.String_Split(@p_operation_id ,',')) )
	AND (( @p_line_id IS NULL OR  @p_line_id='' ) OR t.line_id  IN (SELECT token FROM dbo.String_Split(@p_line_id ,',')) )
    ;
   /********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblDynamicPivot_SCP0003_02%')
		   DROP TABLE #TblDynamicPivot_SCP0003_02
    
	CREATE TABLE #TblDynamicPivot_SCP0003_02 (
			 key_idx		  NVARCHAR(1000)
 		   , company_id		  NVARCHAR(60)
		   , site_id		  NVARCHAR(60)
		   , plant_id		  NVARCHAR(60)
		   , division_id	  NVARCHAR(60)
		   , scm_site_id	  NVARCHAR(60) 
		   , factory_id		  NVARCHAR(100)
		   , operation_id	  NVARCHAR(100)
		   , line_id		  NVARCHAR(100)
		   , item_id		  NVARCHAR(500)
		   , division_name    NVARCHAR(500)
		   , site_description NVARCHAR(500)
		   , factory_name	  NVARCHAR(500)
		   , operation_name   NVARCHAR(500)
		   , line_name		  NVARCHAR(500)
		   , project_name     NVARCHAR(500)
		   , user_sort_order_no INT		
		   , measure		NVARCHAR(60)
		   , basis_yyyymmdd	  NVARCHAR(20)
		   , value			  DECIMAL(20,10)
	  );
	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
    ********************************************************************************/
	INSERT INTO  #TblDynamicPivot_SCP0003_02 (key_idx, company_id ,site_id, plant_id ,division_id, scm_site_id, factory_id, operation_id, line_id, item_id
											 ,division_name,site_description,factory_name,operation_name,line_name,project_name , user_sort_order_no
											 ,measure, basis_yyyymmdd, value )
	SELECT 
	 (m.division_id + m.scm_site_id + m.factory_id + m.operation_id + m.line_id 
	 + ISNULL(( SELECT top 1 pi.project_code FROM scm_mst_project_item pi(NOLOCK),scm_mst_project pp(NOLOCK)
			    	WHERE pi.project_code = pp.project_code AND pi.item_id = m.item_id)
				, '-')   
	 + m.item_id ) as key_idx
	,m.company_id ,m.site_id, m.plant_id ,m.division_id, m.scm_site_id, m.factory_id, m.operation_id, m.line_id, m.item_id
	,m.division_name,m.site_description,m.factory_name,m.operation_name,m.line_name
	,( SELECT TOP 1 pp.project_name FROM scm_mst_project_item pi(NOLOCK),scm_mst_project pp(NOLOCK)
		WHERE pi.project_code = pp.project_code	AND pi.item_id = m.item_id ) AS project_name
	,m.user_sort_order_no
	,m.column_name
	,n.basis_yyyymmdd
	,n.value 
	FROM 
	   (SELECT  
	         c.company_id 
			,c.site_id
			,c.plant_id
			,c.division_id
			,c.scm_site_id
			,c.factory_id
			,c.operation_id
			,c.line_id
			,c.item_id
			,dbo.FN_GET_DIVISION_NAME ( c.division_id ) as division_name
		    ,dbo.FN_GET_SCM_SITE_DESCRIPTION ( c.division_id, c.scm_site_id ) as site_description
			,f.factory_name
			,o.operation_name
			,l.line_name
			,ISNULL(u.sort_order_no,b.sort_order_no ) AS user_sort_order_no
			,b.column_name
			,c.basis_yyyymmdd
			
	     FROM  scm_mst_sheet_measure b WITH(NOLOCK)
		 LEFT OUTER JOIN  scm_mst_titleset_user u WITH(NOLOCK) ON u.program_id = b.program_id AND u.sheet_name = b.sheet_name AND u.column_name = b.column_name AND u.user_id = @p_user_id
	     ,( SELECT division_id, scm_site_id, company_id, site_id ,plant_id, factory_id, operation_id, line_id, item_id, measure, basis_yyyymmdd
			FROM #TblDynamicPivot_SCP0003_01 t WITH(NOLOCK)  
			WHERE 1=1
			--AND (isnull(@p_division_id , '' ) = '' OR t.division_id  IN (SELECT token FROM dbo.String_Split(@p_division_id ,',')) )
			--AND (isnull(@p_plant_site , '' ) = '' OR t.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site ,',')) )  
			--AND (isnull(@p_factory_id , '' ) = '' OR t.FACTORY_ID  IN (SELECT token FROM dbo.String_Split(@p_factory_id ,',')) )
			--AND (isnull(@p_operation_id , '' ) = '' OR t.OPERATION_ID  IN (SELECT token FROM dbo.String_Split(@p_operation_id ,',')) )
			--AND (isnull(@p_line_id , '' ) = '' OR t.LINE_ID  IN (SELECT token FROM dbo.String_Split(@p_line_id ,',')) )
			--AND t.basis_yyyymmdd >= @p_from_yyyymmdd
   --         AND t.basis_yyyymmdd <= @p_to_yyyymmdd	
		  ) C
		 JOIN SCM_MST_FACTORY_SN f WITH(NOLOCK) on c.company_id = f.company_id AND c.division_id = f.division_id AND c.site_id = f.site_id AND c.plant_id = f.plant_id AND  c.factory_id = f.factory_id 
		 JOIN SCM_MST_OPERATION_SN o WITH(NOLOCK) on c.company_id = o.company_id AND c.division_id = o.division_id AND c.site_id = o.site_id AND c.operation_id = o.operation_id
		 JOIN SCM_MST_LINE_SN L WITH(NOLOCK) on c.company_id = l.company_id AND c.division_id = l.division_id AND c.site_id = l.site_id AND c.plant_id = l.plant_id AND  c.factory_id = l.factory_id  AND c.operation_id = l.operation_id AND c.line_id = l.line_id		  
		 WHERE b.program_id       = @p_program_id
		 AND   b.sheet_name       = @p_sheet_name
		 AND   b.valid_yn		 = 'Y'
		 AND ( @v_cnt_usr_measure = 0 
		        OR EXISTS (SELECT 1 
				             FROM scm_mst_titleset_user WITH(NOLOCK)  
				            WHERE program_id  = @p_program_id 
							  AND sheet_name  = @p_sheet_name 
							  AND user_id     = @p_user_id 
							  AND column_name = b.column_name) 
			  )
		 GROUP BY  
	         c.company_id 			,c.site_id			,c.plant_id			,c.division_id			,c.scm_site_id
			,c.factory_id			,c.operation_id		,c.line_id			,c.item_id 
			--,dbo.FN_GET_DIVISION_NAME ( c.division_id )		    
			--,dbo.FN_GET_SCM_SITE_DESCRIPTION ( c.division_id, c.scm_site_id )
			,f.factory_name			,o.operation_name	,l.line_name		,ISNULL(u.sort_order_no,b.sort_order_no )
			,b.column_name			,basis_yyyymmdd		
		) m
	    LEFT OUTER JOIN #TblDynamicPivot_SCP0003_01 n ON m.division_id  = n.division_id
													 AND m.scm_site_id  = n.scm_site_id
													 AND m.company_id   = n.company_id
													 AND m.site_id	    = n.site_id
													 AND m.plant_id     = n.plant_id
													 AND m.factory_id   = n.factory_id
													 AND m.operation_id = n.operation_id
													 AND m.line_id		= n.line_id
													 AND m.item_id      = n.item_id
													 AND m.column_name  = n.measure
													 AND m.basis_yyyymmdd   = n.basis_yyyymmdd
        where 1=1
		--AND (isnull(@p_division_id , '' ) = '' OR m.division_id  IN (SELECT token FROM dbo.String_Split(@p_division_id ,',')) )
		--AND (isnull(@p_plant_site , '' ) = '' OR m.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site ,',')) )  
		--AND (isnull(@p_factory_id , '' ) = '' OR m.FACTORY_ID  IN (SELECT token FROM dbo.String_Split(@p_factory_id ,',')) )
		--AND (isnull(@p_operation_id , '' ) = '' OR m.OPERATION_ID  IN (SELECT token FROM dbo.String_Split(@p_operation_id ,',')) )
		--AND (isnull(@p_line_id , '' ) = '' OR m.LINE_ID  IN (SELECT token FROM dbo.String_Split(@p_line_id ,',')) )
		--AND m.basis_yyyymmdd >= @p_from_yyyymmdd
  --      AND m.basis_yyyymmdd <= @p_to_yyyymmdd														 													 
    ;
	
  /********************************************************************************
	* PIVOIT처리
	********************************************************************************/		
	BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQuery = '';
		SELECT @mQuery = @mQuery + '[' + basis_yyyymmdd + '], '
		FROM ( 
			SELECT 'W_'+a.basis_yyyymm + a.iso_week AS basis_yyyymmdd        
				, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

			UNION ALL

			SELECT 'M_'+a.basis_yyyymm  AS basis_yyyymmdd
					,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name		

			UNION ALL

			SELECT 'D_'+a.basis_yyyymmdd   AS basis_yyyymmdd      
					, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd		
				  	
		) AS A
		ORDER BY sort_order_no  ;

		IF( LEN(@mQuery)>0)
			SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);
			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'      SELECT  distinct ';
			SET @mEXEC = @mEXEC+'		  	 key_idx ';
			SET @mEXEC = @mEXEC+' 			,division_id ';
			SET @mEXEC = @mEXEC+' 			,scm_site_id	';
			SET @mEXEC = @mEXEC+' 			,factory_id	';
			SET @mEXEC = @mEXEC+' 			,operation_id	';
			SET @mEXEC = @mEXEC+' 			,line_id	';
			SET @mEXEC = @mEXEC+' 			,item_id ';
			SET @mEXEC = @mEXEC+' 			,division_name';
			SET @mEXEC = @mEXEC+' 			,site_description';
			SET @mEXEC = @mEXEC+' 			,factory_name ';
			SET @mEXEC = @mEXEC+' 			,operation_name ';
			SET @mEXEC = @mEXEC+' 			,line_name ';
			SET @mEXEC = @mEXEC+'			,project_name  ';
			SET @mEXEC = @mEXEC+'			,user_sort_order_no ';
			SET @mEXEC = @mEXEC+' 			,measure';
			SET @mEXEC = @mEXEC+' 			,'+@mQuery	;
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0003_02';
			SET @mEXEC = @mEXEC+'       PIVOT ( ';
			SET @mEXEC = @mEXEC+'               SUM(value) FOR  basis_yyyymmdd IN ('+ @mQuery +') ';
			SET @mEXEC = @mEXEC+'             ) AS A'  ;		
			SET @mEXEC = @mEXEC+'	    ORDER BY division_id ,scm_site_id,factory_id,operation_id,line_id,item_id, user_sort_order_no ';

			--PRINT @mEXEC;
			
			EXEC (@mEXEC);

			--임시테이블 삭제
		DROP TABLE #TblDynamicPivot_SCP0003_01
		DROP TABLE #TblDynamicPivot_SCP0003_02
	end
				  
END
