/*
 * Program ID   : SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL
 * Description  : Production Plan Line Waterfall 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/24   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/29   PJS 주Sum 집계방식 변경
 * 2018/06/13   byunghunjung   속도개선
 * 2018/07/18	hwyoon			전극용 조회항목 추가
 * 2018/08/14	hwyoon			조회쿼리 수정
 EX)
  EXEC SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL @p_division_id='82', @p_operation_group='P', @p_scm_site_id='KR012031-P', @p_item_id='EH104063P3S2', @p_from_yyyymmdd='20180515', @p_to_yyyymmdd='20180515', @p_version_no='PP_W_20180423', @p_program_id='SCP0017', @p_sheet_name='LINE', @p_user_id='20140001', @debug_mode='T'

 */
CREATE PROCEDURE [dbo].[SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL]

	 @p_division_id		NVARCHAR(50) 
	,@p_operation_group	NVARCHAR(50) 
	,@p_scm_site_id		NVARCHAR(150) 
	,@p_item_id			NVARCHAR(300) 
	,@p_from_yyyymmdd	NVARCHAR(8)
    ,@p_to_yyyymmdd		NVARCHAR(8)
	,@p_version_no		NVARCHAR(15)
	,@p_program_id		NVARCHAR(300) ='SCP0017'
	,@p_sheet_name		NVARCHAR(150) ='LINE'
	,@p_user_id			NVARCHAR(150) 
	,@p_electrode_type	NVARCHAR(30) =''
    ,@debug_mode		NVARCHAR(20)  ='T'

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
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0017_02') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0017_02 
 
	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	  SELECT m.division_id
			,m.operation_group
			,m.scm_site_id
			,m.line_id
			,m.item_id
			,m.measure
			,m.measure_name
			,m.user_sort_order_no
			,m.operation_id
			,@p_from_yyyymmdd AS from_yyyymmdd
			,@p_version_no AS version_no
			,'D_'+m.yyyymmdd AS yyyymmdd
			,o.basis_yyyymm AS yyyymm
			,RIGHT(o.basis_yyyymm,4)+o.iso_week AS iso_week
			,n.qty
			,m.division_name, m.operation_group_name, m.scm_site_description
			,case when m.nick_name is null or m.nick_name =''  then '-' else m.nick_name end as nick_name
			,m.origin_division_id
			,m.electrode_type
		INTO  #TblDynamicPivot_SCP0017_02 
	    FROM(SELECT 
					 c.division_id  
					,c.version_no
					,c.operation_group
					,c.scm_site_id
					,c.item_id
					,c.line_id
					,c.operation_id
					,a.column_name	as measure
					,a.column_label_name	AS measure_name
					,ISNULL(b.sort_order_no,a.sort_order_no ) AS user_sort_order_no
					,c.yyyymmdd
					,c.division_name, c.operation_group_name, c.scm_site_description, c.nick_name
					,ISNULL(NULLIF(c.origin_division_id,''),'-') origin_division_id
					,ISNULL(NULLIF(c.electrode_type,''),'-') electrode_type
			   FROM scm_mst_sheet_measure a LEFT OUTER JOIN 
					scm_mst_titleset_user b ON b.program_id  = a.program_id 
					                       AND b.sheet_name  = a.sheet_name 
										   AND b.column_name = a.column_name 
										   AND b.user_id     = @p_user_id
 				  ,(SELECT division_id, version_no,operation_group,scm_site_id, item_id, line_id, operation_id,measure,  yyyymmdd
						 , division_name, operation_group_name, scm_site_description, nick_name
						 , origin_division_id, electrode_type
					  FROM scp_anl_production_plan_c
					 WHERE 1=1
					   AND  yyyymmdd >= @p_from_yyyymmdd
					   AND  yyyymmdd <= @p_to_yyyymmdd		
					   AND  division_id          = @p_division_id
					   AND  operation_group      = @p_operation_group
					   AND  scm_site_id          = @p_scm_site_id
					   AND  item_id              = @p_item_id
					   AND  version_no			 = @p_version_no
					   AND ( ( @p_electrode_type IS NULL  OR  @p_electrode_type  ='' OR  @p_electrode_type  ='-') OR electrode_type = @p_electrode_type) 
					  GROUP BY division_id, version_no,operation_group,scm_site_id, item_id, line_id, operation_id,measure,   yyyymmdd 
							 , division_name, operation_group_name, scm_site_description, nick_name
							 , origin_division_id, electrode_type
					) c
			WHERE a.program_id       =  @p_program_id
 			  AND a.sheet_name       =  @p_sheet_name
			  AND a.valid_yn		 =	'Y'
			  AND ( @v_cnt_usr_measure = 0 
			        OR EXISTS (SELECT 1 
					             FROM scm_mst_titleset_user  
					            WHERE program_id  = @p_program_id 
								  AND sheet_name  = @p_sheet_name 
								  AND user_id     = @p_user_id 
								  AND column_name = a.column_name) 
				)

			GROUP BY  c.division_id
					 ,c.version_no
					 ,c.operation_group
					 ,c.scm_site_id
				 	 ,c.item_id
					 ,c.line_id
					 ,c.operation_id
					 ,a.column_name
					 ,a.column_label_name
					 ,c.yyyymmdd
					 ,ISNULL(b.sort_order_no,a.sort_order_no )
					 ,c.division_name, c.operation_group_name, c.scm_site_description, c.nick_name
					 ,c.origin_division_id
					 ,c.electrode_type
			) m 
			LEFT OUTER JOIN  
			(  -- 계획
				select a.division_id		
						,a.operation_group
						,a.scm_site_id		
						,a.item_id				
						,a.operation_id		
						,a.line_id				
						,a.measure				
						,a.yyyymmdd	
						,ISNULL(NULLIF(a.ORIGIN_DIVISION_ID,''),'-') as origin_division_id
						,ISNULL(NULLIF(a.electrode_type,''),'-') electrode_type
						,a.qty			
					from scp_anl_production_plan_c a
				where 1=1
					AND a.yyyymmdd >= @p_from_yyyymmdd
					AND a.yyyymmdd <= @p_to_yyyymmdd
					AND  division_id         = @p_division_id
					AND  operation_group      = @p_operation_group
					AND  scm_site_id          = @p_scm_site_id
					AND  item_id              = @p_item_id
					AND  version_no			 = @p_version_no
					AND ( ( @p_electrode_type IS NULL  OR  @p_electrode_type  =''  OR  @p_electrode_type  ='-') OR a.electrode_type = @p_electrode_type) 
			) n  ON m.division_id = n.division_id
				AND m.operation_group    = n.operation_group
				AND m.scm_site_id 		= n.scm_site_id
				AND m.item_id     		= n.item_id
				AND m.operation_id     	= n.operation_id
				AND m.line_id     		= n.line_id
				AND m.measure     		= n.measure
				AND m.yyyymmdd    		= n.yyyymmdd
				AND m.origin_division_id	= n.origin_division_id
				AND m.electrode_type		= n.electrode_type
			INNER JOIN scm_sys_calendar_m o on m.yyyymmdd = o.basis_yyyymmdd
			-- 조회조건 추가부분 (Model Tab에서만 사용하는 REQUIREMENT , FORMATION_YIELD Measure는 *로 입력되어 Line조회시 제외함)
			WHERE m.line_id IS NOT NULL
			 AND m.line_id <> '*'
			;

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/
		BEGIN
			DECLARE @mQry_sum NVARCHAR(MAX);
			DECLARE @mEXEC NVARCHAR(MAX);
			DECLARE @mDAY_QTY NVARCHAR(MAX);

			SET @mDAY_QTY='';
			SET @mDAY_QTY =@mDAY_QTY+ 'QTY ' ;

			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
		    SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+'  END ) AS ' + yyyymmdd
												   WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+'  END ) AS ' + yyyymmdd
											        WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN '+@mDAY_QTY+' END ) AS ' + yyyymmdd
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

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+'       SELECT  '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	 division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,division_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,operation_group	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,operation_group_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,scm_site_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,scm_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,line_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,nick_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'           ,operation_id,version_no,from_yyyymmdd ' + CHAR(10);
			SET @mEXEC = @mEXEC+'       	,user_sort_order_no	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,origin_division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,electrode_type	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	'+@mQry_sum+CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0017_02 '+CHAR(10);
			SET @mEXEC = @mEXEC+'		GROUP BY  division_id, division_name,operation_group,operation_group_name, scm_site_id,scm_site_description, line_id , item_id ,nick_name, measure, measure_name, operation_id,version_no,from_yyyymmdd,user_sort_order_no '+CHAR(10);
			SET @mEXEC = @mEXEC+'				  ,origin_division_id, electrode_type '+CHAR(10);
			SET @mEXEC = @mEXEC+'		ORDER BY  division_id, operation_group, scm_site_id, line_id , item_id , user_sort_order_no '+CHAR(10);
			
			IF( @debug_mode ='T') PRINT @mEXEC;
			
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
			
		END;
	
		-- 임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0017_02') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0017_02 ;						  
END
