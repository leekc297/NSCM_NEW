/*
 * Program ID   : SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL
 * Description  : Production Plan MODEL HEADER 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/11   PJS			   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/04   ygkim		   @p_electrode_type 파라미터 추가, ORIGIN_DIVISION_ID, ELECTRODE_TYPE 컬럼 추가
 * 2018/07/12   hwyoon		   집계쿼리 origin_division_id 수정
 * 2018/09/03   ygkim		   NICK NAME 조회항목 추가
 * ex)
    EXEC SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL @p_division_id='81', @p_operation_group='P', @p_scm_site_id='', @p_item_id='', @p_from_yyyymmdd='20180201', @p_to_yyyymmdd='20180331', @p_plan_start_yyyymmdd='20180326', @p_plan_type='PR', @p_seq='1', @p_program_id='SSP0007', @p_sheet_name='MODEL', @p_user_id='20140001', @debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL]
	 @p_division_id			NVARCHAR(MAX) 
	,@p_operation_group		NVARCHAR(MAX) 
	,@p_scm_site_id			NVARCHAR(MAX) 
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)	
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(50)
	,@p_electrode_type		NVARCHAR(60) = ''
	,@p_program_id			NVARCHAR(300) ='SSP0007'
	,@p_sheet_name			NVARCHAR(150) ='MODEL'
	,@p_user_id				NVARCHAR(150) 
	,@p_nick_name			NVARCHAR(50) = ''
	,@debug_mode			NVARCHAR(20)  ='T'

AS  
  
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

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
		END;


	DECLARE @arr_scm_site_id varchar(max) , @arr_item_id varchar(max), @arr_electrode_type varchar(max)
	SELECT @arr_scm_site_id = ISNULL(@arr_scm_site_id + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_scm_site_id,',')
	SELECT @arr_item_id     = ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_electrode_type     = ISNULL(@arr_electrode_type + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_electrode_type,',')
	DECLARE @mEXEC NVARCHAR(MAX);

	/********************************************************************************
	* 임시테이블만들기 - nick name 조회 시
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0007_NICKITEM') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0007_NICKITEM
  
	  IF( ISNULL(@p_nick_name ,'') != '') 
	  BEGIN
			SELECT distinct ITEM_ID 
			INTO #TblDynamicPivot_SSP0007_NICKITEM
			FROM SCM_MST_ITEM_SN 
			WHERE 1=1
			AND NICK_NAME IS NOT NULL
			AND NICK_NAME LIKE '%'+@p_nick_name+'%'
	  END;

	/********************************************************************************
	* 임시테이블만들기 - Header 부분
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0007_02') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0007_02 

	CREATE TABLE #TblDynamicPivot_SSP0007_02 (
	 division_id	NVARCHAR(128)	,operation_group	NVARCHAR(128)
	,scm_site_id	NVARCHAR(128)	,item_id			NVARCHAR(128)
	,operation_id	NVARCHAR(128)	,line_id			NVARCHAR(128)
	,origin_division_id	NVARCHAR(128)	,electrode_type			NVARCHAR(128)
	,measure		NVARCHAR(128)	,yyyymmdd			NVARCHAR(8)
	)

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     INSERT #TblDynamicPivot_SSP0007_02	 '+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   SELECT c.division_id, c.operation_group, c.scm_site_id, c.item_id, c.operation_id, c.line_id, ISNULL(NULLIF(c.origin_division_id,''''),''-'') origin_division_id, ISNULL(NULLIF(c.electrode_type,''''),''-'') electrode_type,  c.measure,  c.yyyymmdd			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   SELECT c.division_id, c.operation_group, c.scm_site_id, c.item_id, c.operation_id, c.line_id, ISNULL(NULLIF(c.origin_division_id,''''),c.division_id) origin_division_id, ISNULL(NULLIF(c.electrode_type,''''),''-'') electrode_type,  c.measure,  c.yyyymmdd			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   FROM(																													    '+CHAR(10);
											-- 계획 구간
	SET @mEXEC = @mEXEC+'     				SELECT p.division_id, p.operation_group,p.scm_site_id, p.item_id,p.operation_id, p.line_id,p.origin_division_id, p.electrode_type, p.measure,  p.yyyymmdd	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				FROM ssp_anl_production_plan p																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				WHERE 1=1																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND yyyymmdd            >= '''+@p_from_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND yyyymmdd            <= '''+@p_to_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND division_id         = '''+@p_division_id+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND plan_type           = '''+@p_plan_type+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND seq                 = '''+@p_seq +'''																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND operation_group     = '''+@p_operation_group+'''																'+CHAR(10);
	IF NOT(@p_scm_site_id IS NULL     OR  @p_scm_site_id     ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( scm_site_id  IN ('+@arr_scm_site_id+') )				'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL         OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( p.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     				GROUP BY division_id, operation_group,scm_site_id, item_id, line_id, operation_id,p.origin_division_id, p.electrode_type,measure,  yyyymmdd				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				UNION ALL																											'+CHAR(10);
	                                        -- anl 테이블에는 과거구간 YYYYMMDD가 없으므로 실적 테이블에서 YYYYMMDD를 조회하여 추가해준다.
	--SET @mEXEC = @mEXEC+'     				SELECT    r.division_id																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				SELECT   case when '''+@p_division_id+''' = ''EE'' then ''EE'' else r.division_id end as division_id				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     						, r.scp_operation_group as operation_group																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     						, r.scm_site_id	,r.item_id	        ,r.operation_id	    ,r.line_id, r.division_id as origin_division_id, r.electrode_type											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     						, ''PROD_PLAN_ENGINE'' AS measure	,convert(VARCHAR(8) ,r.plan_date,112) AS yyyymmdd						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				FROM SCM_DNM_product_result_v r																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				WHERE 1=1																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND r.plan_date >= convert(datetime, '''+@v_from_result+''')														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND r.plan_date < convert(datetime, '''+@v_to_result+''' )														    '+CHAR(10);	-- equal 표시 주의할것	
	--SET @mEXEC = @mEXEC+'     				AND division_id         = '''+@p_division_id+'''																	'+CHAR(10);
	IF (@p_division_id != 'EE')	BEGIN SET @mEXEC = @mEXEC+' AND division_id  = '''+@p_division_id+'''														    '+CHAR(10); END;
	SET @mEXEC = @mEXEC+'					AND r.scp_operation_group = '''+@p_operation_group+'''																'+CHAR(10);	
	SET @mEXEC = @mEXEC+'					AND r.scm_site_id is not null		'+CHAR(10);	
	IF NOT(@p_scm_site_id IS NULL     OR  @p_scm_site_id     ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( scm_site_id  IN ('+@arr_scm_site_id+') )				'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL         OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( r.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     				GROUP BY division_id, scp_operation_group, scm_site_id, item_id, line_id,r.electrode_type, operation_id, r.plan_date										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			) c																														'+CHAR(10);
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
	-----------------------------------------------------------

	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------	
	IF( @debug_mode ='T')
			BEGIN				
				SET @POS =1;
				SET @LEN =LEN(@mEXEC);
				WHILE @POS <= @LEN
					BEGIN
						PRINT SUBSTRING(@mEXEC,@POS,4000);
						SET @POS = @POS+4000;
					END;
			END;
	-----------------------------------------------------------

	/********************************************************************************
	* 임시테이블만들기 - Main 조회 테이블
	********************************************************************************/	
	--IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblDynamicPivot_SSP0007_01%')
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0007_01') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0007_01 

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
    SELECT ( m.division_id + m.operation_group + m.scm_site_id + m.item_id +m.measure) AS key_idx
			,m.division_id
			,m.operation_group
			,m.scm_site_id
			,m.item_id
			,@p_plan_type AS plan_type
			,@p_seq AS plan_seq	
			,m.origin_division_id
			,m.electrode_type
			,m.measure
			,m.measure_name
			,m.user_sort_order_no
			,@p_from_yyyymmdd AS from_yyyymmdd
			,@p_to_yyyymmdd AS to_yyyymmdd
			,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			,'D_'+m.yyyymmdd AS yyyymmdd
			,o.basis_yyyymm AS yyyymm
			,RIGHT(o.basis_yyyymm,4)+o.iso_week AS iso_week
			,null qty
	  -- Main : #TblDynamicPivot_SSP0007_01
	  INTO  #TblDynamicPivot_SSP0007_01
	  FROM(
			SELECT
					 c.division_id			 
					,c.operation_group
					,c.scm_site_id
					,c.item_id
					,c.LINE_ID
					,c.operation_id
					,c.origin_division_id
					,c.electrode_type
					,a.column_name	AS measure
					,a.column_label_name	AS measure_name
					,isnull(b.sort_order_no,a.sort_order_no ) AS user_sort_order_no
					,c.yyyymmdd
			   FROM scm_mst_sheet_measure a LEFT OUTER JOIN
					scm_mst_titleset_user b ON b.program_id  = a.program_id
										   AND b.sheet_name  = a.sheet_name
										   AND b.column_name = a.column_name
										   AND b.user_id     = @p_user_id
				  ,(   -- Header : #TblDynamicPivot_SSP0007_02
				       SELECT c.division_id, c.operation_group, c.scm_site_id,  c.item_id, c.operation_id, c.line_id, c.origin_division_id, c.electrode_type,  c.measure,  c.yyyymmdd
					   FROM #TblDynamicPivot_SSP0007_02 c
					) c
			WHERE 1=1
			  AND a.program_id       =  @p_program_id
			  AND a.sheet_name       =  @p_sheet_name
			  AND a.valid_yn		 =	'Y'
			  AND ( @p_operation_group = 'A'  OR ISNULL(A.ATTRIBUTE1,'') <>'A')
			  AND ( @v_cnt_usr_measure = 0
					OR EXISTS (SELECT 1
								 FROM scm_mst_titleset_user
								WHERE program_id  = @p_program_id
								  AND sheet_name  = @p_sheet_name
								  AND user_id     = @p_user_id
								  AND column_name = a.column_name)
				  )
			GROUP BY  c.division_id					 ,c.operation_group					 ,c.scm_site_id
					 ,c.item_id					     ,c.line_id					         ,c.origin_division_id
					 ,c.electrode_type				 ,c.operation_id
					 ,a.column_name					 ,a.column_label_name				 ,c.yyyymmdd
					 ,ISNULL(b.sort_order_no,a.sort_order_no )
			) m
			--LEFT OUTER JOIN (  -- QTY : #TblDynamicPivot_SSP0007_03
			--					SELECT n.division_id ,n.operation_group, n.scm_site_id, n.item_id, n.operation_id, n.line_id, n.measure, n.yyyymmdd, n.qty			
			--					 FROM #TblDynamicPivot_SSP0007_03 n
			--			    ) n ON m.division_id     = n.division_id			                                  	
			--				   AND m.operation_group = n.operation_group
			--				   AND m.scm_site_id	 = n.scm_site_id
			--				   AND m.item_id		 = n.item_id
			--				   AND m.operation_id	 = n.operation_id
			--				   AND m.line_id		 = n.line_id
			--				   AND m.measure		 = n.measure
			--				   AND m.yyyymmdd		 = n.yyyymmdd
			INNER JOIN scm_sys_calendar_m o ON m.yyyymmdd = o.basis_yyyymmdd
			
			 ;

		/* 임시테이블 #TblDynamicPivot_SSP0007_01 인덱스 생성*/
		--create clustered index tmpidx_TblDynamicPivot_SSP0007_01 on #TblDynamicPivot_SSP0007_01(key_idx, division_id, operation_group,scm_site_id, item_id, measure,measure_name,user_sort_order_no,plan_start_yyyymmdd,plan_type,plan_seq,from_yyyymmdd,to_yyyymmdd,yyyymm,iso_week,yyyymmdd)

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/		
		BEGIN
			DECLARE @mQry_sum NVARCHAR(MAX);
			DECLARE @mDAY_QTY NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';

		    SELECT  @mQry_sum = @mQry_sum+', '''' '+yyyymmdd+''+CHAR(10)
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
			SET @mEXEC = @mEXEC+'     SELECT  '+CHAR(10);
			SET @mEXEC = @mEXEC+'      		 key_idx '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,division_id '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_division_name(division_id) AS division_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,operation_group '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_lookup_code_desc(''OPERATION_GROUP'',operation_group) operation_group_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,scm_site_id '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_scm_site_description(division_id, scm_site_id) AS scm_site_description '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(NULLIF(dbo.fn_get_item_nickname (division_id, item_id ),''''),''-'') AS nick_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(NULLIF(origin_division_id,''''),''-'') AS origin_division_id '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(NULLIF(electrode_type,''''),''-'') AS electrode_type '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,[dbo].[FN_GET_SSP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd,PLAN_TYPE,plan_seq	,scm_site_id,item_id,from_yyyymmdd) as boh '
			SET @mEXEC = @mEXEC+' 			,measure '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,user_sort_order_no '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,plan_start_yyyymmdd,PLAN_TYPE, plan_seq,from_yyyymmdd,to_yyyymmdd '+CHAR(10)
			SET @mEXEC = @mEXEC+' 			'+@mQry_sum	+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			into #testpjs001'+CHAR(10)
			SET @mEXEC = @mEXEC+'      FROM #TblDynamicPivot_SSP0007_01 '+CHAR(10);
			IF( ISNULL(@p_nick_name ,'') != '') 
			BEGIN
			SET @mEXEC = @mEXEC+'		WHERE item_id in (select item_id from #TblDynamicPivot_SSP0007_NICKITEM)												'+CHAR(10);
			END;

			SET @mEXEC = @mEXEC+'	   GROUP BY key_idx, division_id, operation_group,scm_site_id, item_id,origin_division_id,electrode_type, measure,measure_name,user_sort_order_no,plan_start_yyyymmdd,plan_type,plan_seq,from_yyyymmdd,to_yyyymmdd'+CHAR(10);
			SET @mEXEC = @mEXEC+'	   ORDER BY division_id, operation_group, scm_site_id, item_id, user_sort_order_no '+CHAR(10);

			
			-----------------------------------------------------------
			-- DEBUG QRY 출력
			-----------------------------------------------------------	
			IF( @debug_mode ='T')
				BEGIN				
					SET @POS =1;
					SET @LEN =LEN(@mEXEC);
					WHILE @POS <= @LEN
						BEGIN
							PRINT SUBSTRING(@mEXEC,@POS,4000);
							SET @POS = @POS+4000;
						END;
				END;
			-----------------------------------------------------------
			
			EXEC (@mEXEC);
		END;

		--임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0007_01') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0007_01;
	    IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0007_02') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0007_02;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0007_03') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0007_03;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0007_NICKITEM') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0007_NICKITEM;
END


;
