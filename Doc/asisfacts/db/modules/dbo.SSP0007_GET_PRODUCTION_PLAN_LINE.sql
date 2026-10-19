/*
 * Program ID   : SSP0007_GET_PRODUCTION_PLAN_LINE
 * Description  : Production Plan Line  조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/11   PJS    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/04   ygkim		    @p_electrode_type 파라미터 추가, ORIGIN_DIVISION_ID, ELECTRODE_TYPE 컬럼 추가
 * ex)
    EXEC SSP0007_GET_PRODUCTION_PLAN_LINE @p_division_id='81', @p_operation_group='A', @p_scm_site_id='A040-A', @p_item_id='ACEN1042I-A1', @p_from_yyyymmdd='20180402', @p_to_yyyymmdd='20180410', @p_plan_start_yyyymmdd='20180402', @p_plan_type='PR', @p_seq='1', @p_program_id='SCP0007', @p_sheet_name='LINE', @p_user_id='20140001', @debug_mode='T'

 */
CREATE PROCEDURE [dbo].[SSP0007_GET_PRODUCTION_PLAN_LINE]

	 @p_division_id			 NVARCHAR(50) 
	,@p_operation_group		 NVARCHAR(50) 
	,@p_scm_site_id			 NVARCHAR(150) 
	,@p_item_id				 NVARCHAR(300) 
	,@p_from_yyyymmdd		 NVARCHAR(8)
    ,@p_to_yyyymmdd			 NVARCHAR(8)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_plan_type			 NVARCHAR(50)
	,@p_seq					 NVARCHAR(50)
	,@p_electrode_type		NVARCHAR(60) = ''
	,@p_program_id			 NVARCHAR(300) ='SSP0007'
	,@p_sheet_name			 NVARCHAR(150) ='LINE'
	,@p_user_id				 NVARCHAR(150) 
    ,@debug_mode			 NVARCHAR(20)  ='F'

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
			PRINT '';
		END;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0007_02') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0007_02 
 
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
			,@p_plan_type AS PLAN_TYPE
			,@p_seq AS PLAN_SEQ
			,m.origin_division_id
			,m.electrode_type
			,@p_from_yyyymmdd AS from_yyyymmdd
			,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			,'D_'+m.yyyymmdd AS yyyymmdd
			,o.basis_yyyymm AS yyyymm
			,RIGHT(o.basis_yyyymm,4)+o.iso_week AS iso_week
			,n.qty
		INTO  #TblDynamicPivot_SCP0007_02 
	    FROM( SELECT 
					 c.division_id  
					,c.plan_start_yyyymmdd, c.plan_type, c.seq 
					,c.operation_group
					,c.scm_site_id
					,c.item_id
					,c.line_id
					,c.operation_id
					,ISNULL(NULLIF(c.origin_division_id,''),'-') origin_division_id
					,ISNULL(NULLIF(c.electrode_type,''),'-') electrode_type
					,a.column_name AS measure
					,a.column_label_name AS measure_name
					,ISNULL(b.sort_order_no,a.sort_order_no ) AS user_sort_order_no
					,c.yyyymmdd
			   FROM scm_mst_sheet_measure a LEFT OUTER JOIN 
					scm_mst_titleset_user b ON b.program_id  = a.program_id 
					                       AND b.sheet_name  = a.sheet_name 
										   AND b.column_name = a.column_name 
										   AND b.user_id     = @p_user_id
 				  ,(SELECT a.division_id, a.plan_start_yyyymmdd,a.plan_type,a.seq,a.operation_group,a.scm_site_id, a.item_id, a.operation_id, a.line_id, a.origin_division_id, a.ELECTRODE_TYPE,  a.measure, yyyymmdd
					  FROM ssp_anl_production_plan a
					 WHERE 1=1
					   AND yyyymmdd >= @p_from_yyyymmdd
					   AND yyyymmdd <= @p_to_yyyymmdd		
					   AND  division_id          = @p_division_id
					   AND  operation_group      = @p_operation_group
					   AND  scm_site_id          = @p_scm_site_id
					   AND  item_id              = @p_item_id
					   AND  plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
					   AND  plan_type            = @p_plan_type 
					   AND  seq                  = @p_seq 
					   AND ( (@p_electrode_type is null or @p_electrode_type = '')  OR (a.ELECTRODE_TYPE = @p_electrode_type))
					  GROUP BY  a.division_id, a.plan_start_yyyymmdd,a.plan_type,a.seq,a.operation_group,a.scm_site_id, a.item_id, a.line_id, a.operation_id,a.ORIGIN_DIVISION_ID, a.ELECTRODE_TYPE, a.measure, yyyymmdd
					   UNION ALL
					-- 생산실적	
					-- Plan 테이블에는 실적 보고자 하는 YYYYMMDD가 없으므로 생성을 위해 추가
					--SELECT   r.division_id	
					SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' ELSE r.division_id END as division_id	
							,@p_plan_start_yyyymmdd as plan_start_yyyymmdd
							,@p_plan_type as plan_type
							,@p_seq as seq
							,r.scp_operation_group as operation_group
							,r.scm_site_id
							,r.item_id
							,r.operation_id	
							,r.line_id
							--,'' origin_division_id
							,r.division_id as origin_division_id
							,r.electrode_type
							,'PROD_PLAN_ENGINE' AS measure
							,convert(VARCHAR(8), r.plan_date,112) AS yyyymmdd
					FROM SCM_DNM_product_result_v r	
					WHERE 1=1
					AND r.plan_date >= convert(datetime, @v_from_result)
					AND r.plan_date < convert(datetime, @v_to_result )	-- equal 표시 주의할것	
					--AND r.division_id           = @p_division_id
					AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' ELSE r.division_id  END ) = @p_division_id
					AND r.scp_operation_group = @p_operation_group
					AND ( ( @p_scm_site_id IS NULL     OR  @p_scm_site_id     ='' ) OR scm_site_id  IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
					AND ( ( @p_item_id IS NULL         OR  @p_item_id         ='' ) OR item_id      IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
					AND ( (@p_electrode_type is null or @p_electrode_type = '')  OR (r.ELECTRODE_TYPE = @p_electrode_type))
					GROUP BY division_id, scp_operation_group, scm_site_id, item_id, line_id, r.electrode_type, operation_id, r.plan_date
						
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
					 ,c.plan_start_yyyymmdd, c.plan_type, c.seq 
					 ,c.operation_group
					 ,c.scm_site_id
				 	 ,c.item_id
					 ,c.line_id
					 ,c.operation_id
					 ,c.ORIGIN_DIVISION_ID
					 ,c.ELECTRODE_TYPE
					 ,a.column_name
					 ,a.column_label_name
					 ,c.yyyymmdd
					 ,ISNULL(b.sort_order_no,a.sort_order_no )
			) m 
			LEFT OUTER JOIN  (  -- 계획
								SELECT a.division_id		
									  ,a.operation_group
									  ,a.scm_site_id		
									  ,a.item_id				
									  ,a.operation_id		
									  ,a.line_id	
									  ,ISNULL(NULLIF(a.origin_division_id,''),'-') ORIGIN_DIVISION_ID
									  ,ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') ELECTRODE_TYPE			
									  ,a.measure				
									  ,a.yyyymmdd	
									  ,a.qty			
								 FROM ssp_anl_production_plan a
								WHERE 1=1
								   AND a.yyyymmdd >= @v_from_yyyymmdd
						           AND a.yyyymmdd <= @v_to_yyyymmdd
								   AND  division_id          = @p_division_id
								   AND  operation_group      = @p_operation_group
								   AND  scm_site_id          = @p_scm_site_id
								   AND  item_id              = @p_item_id
								   AND  plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
								   AND  plan_type            = @p_plan_type 
								   AND  seq                  = @p_seq 
								   AND ( (@p_electrode_type is null or @p_electrode_type = '')  OR (a.ELECTRODE_TYPE = @p_electrode_type))
			
								UNION ALL

							  -- 생산실적	
								--SELECT r.division_id	
								SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' ELSE r.division_id END as division_id	
									  ,r.scp_operation_group AS operation_group	
									  ,r.scm_site_id
								      ,r.item_id
								      ,r.operation_id	
								      ,r.line_id
									  --,'-' origin_division_id
									  ,r.division_id as origin_division_id
									  ,ISNULL(NULLIF(r.electrode_type,''),'-') electrode_type
									  ,'PROD_PLAN_ENGINE' AS measure
									  ,convert(VARCHAR(8), r.plan_date,112) AS yyyymmdd
								     , r.actual_good_qty AS qty	
								 FROM SCM_DNM_product_result_v r	
								WHERE 1=1
								  AND r.plan_date          >= convert(datetime, @v_from_result)
						          AND r.plan_date          < convert(datetime, @v_to_result )	-- equal 표시 주의할것	
								  --AND r.division_id         = @p_division_id
								  AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' ELSE r.division_id  END ) = @p_division_id
								  AND r.scp_operation_group = @p_operation_group
								  AND r.scm_site_id         = @p_scm_site_id
								  AND r.item_id             = @p_item_id
								  AND ( (@p_electrode_type is null or @p_electrode_type = '')  OR (r.ELECTRODE_TYPE = @p_electrode_type))
						    ) n  ON m.division_id       = n.division_id
								AND m.operation_group   = n.operation_group
								AND m.scm_site_id 		= n.scm_site_id
								AND m.item_id     		= n.item_id
								AND m.operation_id     	= n.operation_id
								AND m.line_id     		= n.line_id
								AND m.origin_division_id = n.ORIGIN_DIVISION_ID
								AND m.ELECTRODE_TYPE = n.ELECTRODE_TYPE
								AND m.measure     		= n.measure
								AND m.yyyymmdd    		= n.yyyymmdd
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
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_division_name(division_id) AS division_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,operation_group	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_lookup_code_desc(''OPERATION_GROUP'',operation_group) operation_group_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,scm_site_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_scm_site_description(division_id,scm_site_id) AS scm_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,line_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,ISNULL(NULLIF(dbo.fn_get_item_nickname (division_id, item_id ),''''),''-'') AS nick_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,origin_division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,electrode_type	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'           ,operation_id,PLAN_TYPE, PLAN_SEQ, plan_start_yyyymmdd,from_yyyymmdd ' + CHAR(10);
			SET @mEXEC = @mEXEC+'       	,user_sort_order_no	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	'+@mQry_sum+CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0007_02 '+CHAR(10);
			SET @mEXEC = @mEXEC+'		GROUP BY  division_id, operation_group, scm_site_id, line_id , item_id ,origin_division_id,electrode_type, measure, measure_name, operation_id,PLAN_TYPE, PLAN_SEQ, plan_start_yyyymmdd,from_yyyymmdd,user_sort_order_no '+CHAR(10);
			SET @mEXEC = @mEXEC+'		ORDER BY  division_id, operation_group, scm_site_id, line_id , item_id , user_sort_order_no '+CHAR(10);
			
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
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0007_02') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0007_02 ;						  
END
