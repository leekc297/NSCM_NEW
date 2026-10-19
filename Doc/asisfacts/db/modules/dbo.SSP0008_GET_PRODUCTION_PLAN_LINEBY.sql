/*
 * Program ID   : SSP0008_GET_PRODUCTION_PLAN_LINEBY
 * Description  : Production Plan Line 별 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/12   PJS			   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/05   ygkim		   @p_electrode_type 파라미터 추가, ORIGIN_DIVISION_ID, ELECTRODE_TYPE 컬럼 추가
 * 2018/07/12   hwyoon		   EE사업부 실적 추가
 * 2018/09/03   ygkim		   NICK NAME 조회항목 추가
 ex)
   EXEC SSP0008_GET_PRODUCTION_PLAN_LINEBY @p_division_id='82', @p_operation_group='P', @p_scm_site_id='', @p_line_id='-', @p_item_id='', @p_from_yyyymmdd='20180514', @p_to_yyyymmdd='20181118', @p_plan_start_yyyymmdd='20180514', @p_plan_type='MA', @p_seq='1', @p_program_id='SSP0008', @p_sheet_name='LINE', @p_user_id='pasun2', @debug_mode='T'
  */

CREATE PROCEDURE [dbo].[SSP0008_GET_PRODUCTION_PLAN_LINEBY]

	 @p_division_id			NVARCHAR(50) 
	,@p_operation_group		NVARCHAR(50) 
	,@p_scm_site_id			NVARCHAR(MAX) 
	,@p_line_id				NVARCHAR(MAX) 
	,@p_item_id				NVARCHAR(MAX) 
	,@p_from_yyyymmdd		NVARCHAR(8)
    ,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(50)
	,@p_electrode_type		NVARCHAR(60) = ''
	,@p_program_id			NVARCHAR(300) ='SSP0008'
	,@p_sheet_name			NVARCHAR(150) ='LINE'
	,@p_user_id				NVARCHAR(100) 
	,@p_nick_name			NVARCHAR(50) = ''
    ,@debug_mode			NVARCHAR(20)  ='T'

AS  

BEGIN


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	DECLARE @v_cnt_usr_measure	INT =0;
	SET @v_cnt_usr_measure = (
								SELECT COUNT(*) 
								FROM scm_mst_titleset_user  
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name 
								 AND user_id     =  @p_user_id
							  )
	IF (@debug_mode ='T')
		print '@v_cnt_usr_measure=' +convert(varchar,@v_cnt_usr_measure);

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
	* 임시테이블만들기 - nick name 조회 시
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_NICKITEM_1') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0013_NICKITEM_1
  
	    SELECT distinct line_id 
		INTO #TblDynamicPivot_SCP0013_NICKITEM_1
		FROM ssp_anl_production_plan 
		WHERE 1=1
		AND division_id	         = @p_division_id
		AND operation_group      = @p_operation_group
		AND plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		AND plan_type            = @p_plan_type
		AND seq				     = @p_seq
		AND ( (@p_nick_name=NULL OR @p_nick_name='') OR   
			item_id              IN (
			SELECT distinct ITEM_ID 
			FROM SCM_MST_ITEM_SN 
			WHERE 1=1
			AND NICK_NAME IS NOT NULL
			AND NICK_NAME LIKE '%'+@p_nick_name+'%')
		)

	/********************************************************************************
	* 임시테이블만들기 - nick name 조회 시
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_NICKITEM_2') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0013_NICKITEM_2
  
	    SELECT distinct scm_site_id 
		INTO #TblDynamicPivot_SCP0013_NICKITEM_2
		FROM ssp_anl_production_plan 
		WHERE 1=1
		AND division_id	         = @p_division_id
		AND operation_group      = @p_operation_group
		AND plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		AND plan_type            = @p_plan_type
		AND seq				     = @p_seq
		AND ( (@p_nick_name=NULL OR @p_nick_name='') OR   
			item_id              IN (
			SELECT distinct ITEM_ID 
			FROM SCM_MST_ITEM_SN 
			WHERE 1=1
			AND NICK_NAME IS NOT NULL
			AND NICK_NAME LIKE '%'+@p_nick_name+'%')
		)

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0008') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0008 
    
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0008_1') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0008_1
  
		SELECT line_id 
		INTO #TblDynamicPivot_SSP0008_1
		FROM ssp_anl_production_plan 
		WHERE 1=1
		AND division_id	         = @p_division_id
		AND operation_group      = @p_operation_group
		AND plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		AND plan_type            = @p_plan_type
		AND seq				     = @p_seq	
		AND item_id              IN (SELECT token FROM dbo.String_Split(@p_item_id,','))  

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0008_2') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0008_2
  
		SELECT scm_site_id 
		INTO #TblDynamicPivot_SSP0008_2
		FROM ssp_anl_production_plan 
		WHERE 1=1
		AND division_id	         = @p_division_id
		AND operation_group      = @p_operation_group
		AND plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		AND plan_type            = @p_plan_type
		AND seq				     = @p_seq	
		AND item_id              IN (SELECT token FROM dbo.String_Split(@p_item_id,','))  
	
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_tmp') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0013_tmp

		SELECT DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,OPERATION_GROUP
			,SCM_SITE_ID
			,ITEM_ID
			,LINE_ID
			,OPERATION_ID
			,MEASURE
			,YYYYMMDD
			,QTY
			,CASE WHEN RIGHT(SCM_SITE_ID,2) = '-S' THEN LEFT(a.scm_site_id , LEN(a.scm_site_id) - 2) else a.scm_site_id end SCM_SITE_ID2
			,ORIGIN_DIVISION_ID
			,ELECTRODE_TYPE
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
		INTO #TblDynamicPivot_SCP0013_tmp
		FROM ssp_anl_production_plan a	
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

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/

	 SELECT 
			 t.division_id+t.scm_site_id+t.plan_start_yyyymmdd+plan_type+convert(varchar,plan_seq) as cp_key
			,t.division_id + t.operation_group+ t.scm_site_id+ t.item_id+t.line_id + t.operation_id as fix_key
			,t.division_id
			,t.plan_start_yyyymmdd
			,t.plan_type
			,t.plan_seq
			,t.operation_group
			,t.scm_site_id
			,t.operation_id
			,t.line_id
			,t.item_id
			,ISNULL(NULLIF(t.origin_division_id,''),'-') origin_division_id
			,ISNULL(NULLIF(t.electrode_type,''),'-') electrode_type
			,t.measure
			,m.column_label_name as measure_name
			,m.sort_order_no
			,t.qty
			,t.from_yyyymmdd
			,t.yyyymmdd
			,t.yyyymm
			,t.iso_week
	 INTO  #TblDynamicPivot_SSP0008 

	 FROM (
	     --계획 
		  SELECT distinct
				 a.division_id
				,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
				,@p_plan_type AS PLAN_TYPE
				,@p_seq AS PLAN_SEQ
				,a.operation_group
				,a.scm_site_id,a.item_id ,a.operation_id,a.line_id
				,a.origin_division_id
				,a.electrode_type
				,a.measure			
				,a.qty
				,@p_from_yyyymmdd AS from_yyyymmdd
				,'D_'+a.yyyymmdd AS yyyymmdd
				,c.basis_yyyymm AS yyyymm
				,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week		
			FROM #TblDynamicPivot_SCP0013_tmp a
			JOIN scm_mst_sheet_measure b on a.measure = b.column_name
			JOIN scm_sys_calendar_m c on a.yyyymmdd = c.basis_yyyymmdd
			WHERE 1=1 
			AND b.program_id           = @p_program_id
			AND b.sheet_name           = @p_sheet_name
			AND b.valid_yn		       = 'Y'
			AND a.measure			   = 'PROD_PLAN_AMEND'
			--AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			--AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			AND ( ( @p_electrode_type IS NULL OR         @p_electrode_type         ='' ) OR a.electrode_type         IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
		   
		   UNION 	
		   -- 생산 실적 
		   SELECT distinct 
		         --r.division_id		
				 (CASE WHEN @p_division_id='EE' THEN 'EE' ELSE r.division_id END) AS division_id
		   		,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
				,@p_plan_type AS PLAN_TYPE
				,@p_seq AS PLAN_SEQ																												
   				,r.scp_operation_group as operation_group																			
   				,r.scm_site_id	,r.item_id	,r.operation_id	 ,r.line_id		
				--,'' origin_division_id
				,r.division_id as origin_division_id
				,r.electrode_type										
   				,'PROD_PLAN_AMEND' AS measure																							
   				,r.actual_good_qty AS qty	
				,@p_from_yyyymmdd AS from_yyyymmdd
				,'D_'+convert(nvarchar(8), r.plan_date,112)  AS yyyymmdd
				,c.basis_yyyymm AS yyyymm
				,RIGHT(c.basis_yyyymm,2)+c.iso_week AS iso_week			
		   FROM SCM_DNM_product_result_v r	
		   JOIN scm_sys_calendar_m c on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd																								
		   WHERE 1=1																																				
		   AND r.plan_date          >= convert(datetime, @v_from_result)						
		   AND r.plan_date          < convert(datetime, @v_to_result )							
		   --AND r.division_id         =  @p_division_id															
		   AND ( @p_division_id='EE' OR r.division_id = @p_division_id )
		   AND r.scp_operation_group =  @p_operation_group
		   AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR r.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR r.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			AND ( ( @p_electrode_type IS NULL OR         @p_electrode_type         ='' ) OR r.electrode_type         IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )

			UNION 
			-- LINE_TOTAL_LOAD 추가
			SELECT distinct
					 a.division_id
					,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
					,@p_plan_type AS PLAN_TYPE
					,@p_seq AS PLAN_SEQ
					,a.operation_group
					,a.scm_site_id	,'-' as item_id	,a.operation_id	,a.line_id
					,a.origin_division_id
					,'-' electrode_type
					,'LINE_TOTAL_LOAD' AS measure
					, CASE WHEN d.working_time <= 0.0 THEN 0
					       ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100  
                       END AS qty
					,@p_from_yyyymmdd AS from_yyyymmdd
					,'D_'+a.yyyymmdd AS yyyymmdd
					,c.basis_yyyymm AS yyyymm
					,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			FROM #TblDynamicPivot_SCP0013_tmp a
			JOIN scm_sys_calendar_m c ON a.yyyymmdd = c.basis_yyyymmdd
			--LEFT OUTER JOIN scp_anl_working_time d ON a.division_id = d.division_id and a.operation_id = d.operation_id and a.scm_site_id = d.scm_site_id and a.line_id = d.line_id and a.yyyymmdd= d.yyyymmdd
			LEFT OUTER JOIN scp_anl_working_time d ON a.origin_division_id = d.division_id and a.operation_id = d.operation_id and a.SCM_SITE_ID2 = d.scm_site_id and a.line_id = d.line_id and a.yyyymmdd= d.yyyymmdd
			--LEFT OUTER JOIN scp_anl_tact_time e ON a.division_id = e.division_id and a.operation_id = e.operation_id and a.scm_site_id = e.scm_site_id and a.line_id = e.line_id and a.item_id = e.item_id and a.yyyymmdd= e.yyyymmdd
			LEFT OUTER JOIN scp_anl_tact_time e ON a.origin_division_id = e.division_id and a.operation_id = e.operation_id and a.SCM_SITE_ID2 = e.scm_site_id and a.line_id = e.line_id and a.item_id = e.item_id and a.yyyymmdd= e.yyyymmdd
			WHERE 1=1 
			AND a.line_id			  <> '*'
			AND a.measure              = upper('PROD_PLAN_AMEND')
			--AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
			--AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
			--AND ( ( @p_electrode_type IS NULL OR         @p_electrode_type         ='' ) OR a.electrode_type         IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
			GROUP BY a.division_id, a.operation_group		,a.scm_site_id		,a.operation_id		,a.line_id,a.origin_division_id, a.yyyymmdd,c.basis_yyyymm,c.iso_week, d.working_time
		) T
		LEFT JOIN scm_mst_sheet_measure m on t.measure = m.column_name
		WHERE 1=1 
		AND m.valid_yn		       = 'Y'
		AND m.program_id           = @p_program_id
		AND m.sheet_name           = @p_sheet_name
		AND ( @v_cnt_usr_measure = 0
					OR EXISTS (SELECT 1
								 FROM scm_mst_titleset_user
								WHERE program_id  = @p_program_id
								  AND sheet_name  = @p_sheet_name
								  AND user_id     = @p_user_id
								  AND column_name = m.column_name)
				  )
        AND ( ( @p_line_id IS NULL OR @p_line_id ='' ) OR t.line_id IN (SELECT token FROM dbo.String_Split(@p_line_id,',')) )
		AND ( ( @p_item_id IS NULL OR @p_item_id ='' ) OR t.line_id IN (SELECT line_id FROM #TblDynamicPivot_SSP0008_1) )
		AND ( ( @p_item_id IS NULL OR @p_item_id ='' ) OR t.scm_site_id IN (SELECT scm_site_id FROM #TblDynamicPivot_SSP0008_2) )
		;
		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/
		BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mQuery = '';
		SELECT  @mQuery = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END ) AS ' + yyyymmdd
											WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN  QTY  END ) AS ' + yyyymmdd
											WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  END ) AS ' + yyyymmdd
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
			SET @mEXEC = @mEXEC+'       	 cp_key,fix_key	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_division_name(division_id) AS division_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,operation_group	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_lookup_code_desc(''OPERATION_GROUP'',operation_group) operation_group_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,scm_site_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_scm_site_description(division_id,scm_site_id) AS scm_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,line_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,origin_division_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,electrode_type '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_item_nickname (division_id, item_id ) AS nick_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'           ,operation_id,PLAN_TYPE, PLAN_SEQ, plan_start_yyyymmdd,from_yyyymmdd,sort_order_no ' + CHAR(10);
			SET @mEXEC = @mEXEC+' 			'+@mQuery	;
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0008 '+CHAR(10);
			IF( ISNULL(@p_nick_name ,'') != '') 
			BEGIN
			SET @mEXEC = @mEXEC+'		WHERE line_id		in (select line_id		from #TblDynamicPivot_SCP0013_NICKITEM_1)												'+CHAR(10);
			SET @mEXEC = @mEXEC+'		AND scm_site_id in (select scm_site_id	from #TblDynamicPivot_SCP0013_NICKITEM_2)												'+CHAR(10);
			END;

			SET @mEXEC = @mEXEC+'		GROUP BY  cp_key,fix_key,division_id, operation_group, scm_site_id, line_id , item_id ,origin_division_id, electrode_type, measure, measure_name, operation_id,PLAN_TYPE, PLAN_SEQ, plan_start_yyyymmdd,from_yyyymmdd,sort_order_no '+CHAR(10);
			SET @mEXEC = @mEXEC+'		ORDER BY  division_id, operation_group, scm_site_id, line_id , operation_id , sort_order_no ASC,item_id  '+CHAR(10);
			
			--IF( @debug_mode ='T') PRINT @mEXEC;
			
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
			
			-- FIX정보 조회	
			
			SELECT division_id
					,operation_group
					,scm_site_id
					,item_id
					,line_id
					,operation_id
					,ISNULL(NULLIF(origin_division_id,''),'-') origin_division_id
					,ISNULL(NULLIF(electrode_type,''),'-') electrode_type
					,division_id + operation_group+ scm_site_id+ item_id+line_id + operation_id as fix_key
					,'D_'+yyyymmdd AS yyyymmdd
					,'W_'+b.basis_yyyymm + iso_week AS	yyyymm_week
				FROM dbo.SCP_ANL_PRODUCTION_PLAN_FIX A
				    INNER JOIN scm_sys_calendar_m B ON A.yyyymmdd =B.BASIS_YYYYMMDD
				WHERE 1=1
				AND a.yyyymmdd			  >= @p_from_yyyymmdd
				AND a.yyyymmdd			  <= @p_to_yyyymmdd		
				AND a.division_id	       = @p_division_id
				AND a.operation_group      = @p_operation_group
				AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR a.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
				--AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
				AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR a.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )
				AND ( ( @p_electrode_type IS NULL OR         @p_electrode_type         ='' ) OR a.electrode_type         IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
			   ORDER BY fix_key,yyyymmdd	
		
		END;
	
		 --임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0008') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SSP0008 ;			
		
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0008_1') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SSP0008_1 ;			
		
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0008_2') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SSP0008_2 ;						
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_NICKITEM_1') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_NICKITEM_1;				

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0013_NICKITEM_2') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0013_NICKITEM_2;				
END

