/*
 * Program ID   : SCP0011_GET_PRODUCTION_PLAN_LINE
 * Description  : Production Plan Line Header 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/22   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/02/13   PJS   성능개선  PIVOT제거, CASE SUM방식으로 변경
 * 2018/04/17   PJS   임시테이블 삭제 OBJECT_ID형식으로 변경
 * 2018/05/28   byunghunjung 실적 테이블 값 조회시 scp_operation_group 조회조건 추가
 * 2018/05/29   PJS 주Sum 집계방식 변경
 * 2018/07/11   byunghunjung EE 사업부 실적 추가
 * 2018/07/18   YHW				전극용 조회항목 추가
 * 2021.10.25   khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 이력 테이블 분리(SCP_ANL_PRODUCTION_PLAN / HIST_SCP_ANL_PRODUCTION_PLAN)
 * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2023/01/02   LWY             PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회기준 변경(main / hist) - 당주,전주(main) / 당주,전주 이전(hist)
 * 2023/04/10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023.07.26   vadabi3		   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Model, Material 개선
----------------------------------------------------------------------------------------------------------------------------------------
 * ex)

    EXEC SCP0011_GET_PRODUCTION_PLAN_LINE @p_division_id='81', @p_operation_group='A', @p_scm_site_id='A040-A', @p_item_id='ACEN1042I-A1', @p_from_yyyymmdd='20180402', @p_to_yyyymmdd='20180410', @p_plan_start_yyyymmdd='20180402', @p_plan_type='PR', @p_seq='1', @p_program_id='SCP0011', @p_sheet_name='LINE', @p_user_id='20140001', @debug_mode='T'

 */
CREATE PROCEDURE [dbo].[SCP0011_GET_PRODUCTION_PLAN_LINE]

	 @p_division_id			 NVARCHAR(50) 
	,@p_operation_group		 NVARCHAR(50) 
	,@p_scm_site_id			 NVARCHAR(150) 
	,@p_item_id				 NVARCHAR(300) 
	,@p_from_yyyymmdd		 NVARCHAR(8)
    ,@p_to_yyyymmdd			 NVARCHAR(8)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_plan_type			 NVARCHAR(50)
	,@p_seq					 NVARCHAR(50)
	,@p_program_id			 NVARCHAR(300) ='SCP0011'
	,@p_sheet_name			 NVARCHAR(150) ='LINE'
	,@p_user_id				 NVARCHAR(150) 
	,@p_electrode_type		 NVARCHAR(30) =''
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
	  DECLARE @v_min_yyyymmdd      AS NVARCHAR(8);   -- 2021.10.25 : 이력 테이블 분리

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

	-- 2023.01.02
	--SELECT @v_min_yyyymmdd = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](@p_program_id, @p_division_id, @p_plan_type, @p_operation_group, @p_seq);
	SELECT @v_min_yyyymmdd = replace(convert(char(10),dateadd(d,datepart(dw,GETDATE()) * -1 - 5,GETDATE()),120),'-',''); -- previous monday	

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_02') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0011_02 
 
	CREATE TABLE #TblDynamicPivot_SCP0011_02
	(
		  DIVISION_ID			NVARCHAR(010)
		, OPERATION_GROUP		NVARCHAR(010)
		, SCM_SITE_ID			NVARCHAR(100)
		, LINE_ID				NVARCHAR(100)
		, ITEM_ID				NVARCHAR(100)
		, MEASURE				NVARCHAR(100)
		, MEASURE_NAME			NVARCHAR(100)
		, USER_SORT_ORDER_NO	INT
		, OPERATION_ID			NVARCHAR(100)
		, PLAN_TYPE				NVARCHAR(010)
		, PLAN_SEQ				NVARCHAR(010)
		, FROM_YYYYMMDD			NVARCHAR(008)
		, PLAN_START_YYYYMMDD	NVARCHAR(008)
		, YYYYMMDD				NVARCHAR(020)
		, YYYYMM				NVARCHAR(006)
		, ISO_WEEK				NVARCHAR(030)
		, QTY					NUMERIC(20,10)
		, ORIGIN_DIVISION_ID	NVARCHAR(010)
		, ELECTRODE_TYPE		NVARCHAR(030)
	)
	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/

	-- 2021.10.25 : 이력 테이블 분리
	IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
	BEGIN
	  INSERT INTO #TblDynamicPivot_SCP0011_02
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
			,@p_from_yyyymmdd AS from_yyyymmdd
			,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			,'D_'+m.yyyymmdd AS yyyymmdd
			,o.basis_yyyymm AS yyyymm
			,RIGHT(o.basis_yyyymm,4)+o.iso_week AS iso_week
			,n.qty
			,m.origin_division_id
			,m.electrode_type
		--INTO  #TblDynamicPivot_SCP0011_02 
	    FROM( SELECT 
					 c.division_id  
					,c.plan_start_yyyymmdd, c.plan_type, c.seq 
					,c.operation_group
					,c.scm_site_id
					,c.item_id
					,c.line_id
					,c.operation_id
					,a.column_name AS measure
					,a.column_label_name AS measure_name
					,ISNULL(b.sort_order_no,a.sort_order_no ) AS user_sort_order_no
					,c.yyyymmdd
					,c.origin_division_id
					,c.electrode_type
			   FROM scm_mst_sheet_measure a LEFT OUTER JOIN 
					scm_mst_titleset_user b ON b.program_id  = a.program_id 
					                       AND b.sheet_name  = a.sheet_name 
										   AND b.column_name = a.column_name 
										   AND b.user_id     = @p_user_id
 				  ,(SELECT a.division_id, a.plan_start_yyyymmdd,a.plan_type,a.seq,a.operation_group,a.scm_site_id, a.item_id, a.operation_id, a.line_id, a.measure, yyyymmdd
						   , ISNULL(NULLIF(a.ORIGIN_DIVISION_ID,''),'-') origin_division_id
						   , ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') electrode_type	
					  FROM scp_anl_production_plan a
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
					   AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
					  GROUP BY  a.division_id, a.plan_start_yyyymmdd,a.plan_type,a.seq,a.operation_group,a.scm_site_id, a.item_id, a.line_id, a.operation_id, a.measure, yyyymmdd
								, a.ORIGIN_DIVISION_ID, a.ELECTRODE_TYPE
					   UNION ALL
					-- 생산실적	
					-- Plan 테이블에는 실적 보고자 하는 YYYYMMDD가 없으므로 생성을 위해 추가
					--SELECT   r.division_id
					--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE'  WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id END as division_id
					-- div_commonization
					--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id END as division_id
					SELECT   @p_division_id as division_id
							,@p_plan_start_yyyymmdd as plan_start_yyyymmdd
							,@p_plan_type as plan_type
							,@p_seq as seq
							,r.scp_operation_group as operation_group
							,r.scm_site_id
							,r.item_id
							,r.operation_id	
							,r.line_id
							,'PROD_PLAN_ENGINE' AS measure
							,convert(VARCHAR(8), r.plan_date,112) AS yyyymmdd
							--,'-' origin_division_id
							,r.division_id as origin_division_id
							,ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') electrode_type	
					FROM SCM_DNM_product_result_v r	
					WHERE 1=1
					AND r.plan_date >= convert(datetime, @v_from_result)
					AND r.plan_date <  convert(datetime, @v_to_result )	-- equal 표시 주의할것	
					--AND r.division_id         = @p_division_id
					--AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id  END ) = @p_division_id
					--div_commonization
					--AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id  END ) = @p_division_id
					AND (r.division_id	IN
						   (												
							select division_id 								
							from SCM_MST_DIVISION with(nolock)								
							where attribute4 in (								
											select attribute4				
											from SCM_MST_DIVISION with(nolock)				
											where division_id = @p_division_id			
											and   attribute3 = 'EE'				
											)				
							and attribute3 <> 'EE'								
						   ) --div_commonization	
						OR r.division_id = @p_division_id 
						   )
					AND r.scp_operation_group = @p_operation_group
					AND ( ( @p_scm_site_id IS NULL     OR  @p_scm_site_id     ='' ) OR scm_site_id  IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
					AND ( ( @p_item_id IS NULL         OR  @p_item_id         ='' ) OR item_id      IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
					AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
					GROUP BY division_id, scp_operation_group, scm_site_id, item_id, line_id, operation_id, r.plan_date
							 , r.ELECTRODE_TYPE
						
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
					 ,a.column_name
					 ,a.column_label_name
					 ,c.yyyymmdd
					 ,ISNULL(b.sort_order_no,a.sort_order_no )
					 ,c.origin_division_id
					 ,c.electrode_type
			) m 
			LEFT OUTER JOIN  (  -- 계획
								SELECT a.division_id		
									  ,a.operation_group
									  ,a.scm_site_id		
									  ,a.item_id				
									  ,a.operation_id		
									  ,a.line_id				
									  ,a.measure				
									  ,a.yyyymmdd	
									  ,a.qty
									  ,ISNULL(NULLIF(a.ORIGIN_DIVISION_ID,''),'-') origin_division_id
									  ,ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') electrode_type		
								 FROM scp_anl_production_plan a
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
								   AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
								UNION ALL

							  -- 생산실적	
							   --SELECT r.division_id	
								--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id END as division_id								
								--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id END as division_id --div_commonization
								SELECT @p_division_id as division_id --div_commonization
									  ,r.scp_operation_group AS operation_group	
									  ,r.scm_site_id
								      ,r.item_id
								      ,r.operation_id	
								      ,r.line_id
									  ,'PROD_PLAN_ENGINE' AS measure
									  ,convert(VARCHAR(8), r.plan_date,112) AS yyyymmdd
								      ,r.actual_good_qty AS qty	
									  --,'-' origin_division_id
									  ,r.division_id as origin_division_id
									  ,ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') electrode_type
								 FROM SCM_DNM_product_result_v r	
								WHERE 1=1
								  AND r.plan_date          >= convert(datetime, @v_from_result)
						          AND r.plan_date          < convert(datetime, @v_to_result )	-- equal 표시 주의할것	
								  --AND r.division_id         = @p_division_id
								  --AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id  END ) = @p_division_id								  
								  --AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id  END ) = @p_division_id --div_commonization
									AND (r.division_id	IN
										   (												
											select division_id 								
											from SCM_MST_DIVISION with(nolock)								
											where attribute4 in (								
															select attribute4				
															from SCM_MST_DIVISION with(nolock)				
															where division_id = @p_division_id			
															and   attribute3 = 'EE'				
															)				
											and attribute3 <> 'EE'								
										   ) --div_commonization	
										OR r.division_id = @p_division_id 
										   )
								  AND r.scp_operation_group = @p_operation_group
								  AND r.scm_site_id         = @p_scm_site_id
								  AND r.item_id             = @p_item_id
								  AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
						    ) n  ON m.division_id       = n.division_id
								AND m.operation_group   = n.operation_group
								AND m.scm_site_id 		= n.scm_site_id
								AND m.item_id     		= n.item_id
								AND m.operation_id     	= n.operation_id
								AND m.line_id     		= n.line_id
								AND m.measure     		= n.measure
								AND m.yyyymmdd    		= n.yyyymmdd
								AND m.origin_division_id = n.origin_division_id
								AND m.electrode_type	= n.electrode_type
			INNER JOIN scm_sys_calendar_m o on m.yyyymmdd = o.basis_yyyymmdd
			-- 조회조건 추가부분 (Model Tab에서만 사용하는 REQUIREMENT , FORMATION_YIELD Measure는 *로 입력되어 Line조회시 제외함)
			WHERE m.line_id IS NOT NULL
			 AND m.line_id <> '*'
		END
		ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
		BEGIN
			INSERT INTO #TblDynamicPivot_SCP0011_02
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
				  ,@p_from_yyyymmdd AS from_yyyymmdd
				  ,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
				  ,'D_'+m.yyyymmdd AS yyyymmdd
				  ,o.basis_yyyymm AS yyyymm
				  ,RIGHT(o.basis_yyyymm,4)+o.iso_week AS iso_week
				  ,n.qty
				  ,m.origin_division_id
				  ,m.electrode_type
			  --INTO  #TblDynamicPivot_SCP0011_02 
			  FROM( SELECT 
							 c.division_id  
							,c.plan_start_yyyymmdd, c.plan_type, c.seq 
							,c.operation_group
							,c.scm_site_id
							,c.item_id
							,c.line_id
							,c.operation_id
							,a.column_name AS measure
							,a.column_label_name AS measure_name
							,ISNULL(b.sort_order_no,a.sort_order_no ) AS user_sort_order_no
							,c.yyyymmdd
							,c.origin_division_id
							,c.electrode_type
						FROM scm_mst_sheet_measure a LEFT OUTER JOIN 
							scm_mst_titleset_user b ON b.program_id  = a.program_id 
													AND b.sheet_name  = a.sheet_name 
													AND b.column_name = a.column_name 
													AND b.user_id     = @p_user_id
 							,(SELECT a.division_id, a.plan_start_yyyymmdd,a.plan_type,a.seq,a.operation_group,a.scm_site_id, a.item_id, a.operation_id, a.line_id, a.measure, yyyymmdd
									, ISNULL(NULLIF(a.ORIGIN_DIVISION_ID,''),'-') origin_division_id
									, ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') electrode_type	
								FROM HIST_SCP_ANL_PRODUCTION_PLAN a
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
								 AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
					  GROUP BY  a.division_id, a.plan_start_yyyymmdd,a.plan_type,a.seq,a.operation_group,a.scm_site_id, a.item_id, a.line_id, a.operation_id, a.measure, yyyymmdd
								, a.ORIGIN_DIVISION_ID, a.ELECTRODE_TYPE
					   UNION ALL
					-- 생산실적	
					-- Plan 테이블에는 실적 보고자 하는 YYYYMMDD가 없으므로 생성을 위해 추가
					--SELECT   r.division_id	
					--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id END as division_id					
					--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id END as division_id --div_commonization
					SELECT   @p_division_id as division_id --div_commonization
							,@p_plan_start_yyyymmdd as plan_start_yyyymmdd
							,@p_plan_type as plan_type
							,@p_seq as seq
							,r.scp_operation_group as operation_group
							,r.scm_site_id
							,r.item_id
							,r.operation_id	
							,r.line_id
							,'PROD_PLAN_ENGINE' AS measure
							,convert(VARCHAR(8), r.plan_date,112) AS yyyymmdd
							--,'-' origin_division_id
							,r.division_id as origin_division_id
							,ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') electrode_type	
					FROM SCM_DNM_product_result_v r	
					WHERE 1=1
					AND r.plan_date >= convert(datetime, @v_from_result)
					AND r.plan_date <  convert(datetime, @v_to_result )	-- equal 표시 주의할것	
					--AND r.division_id         = @p_division_id
					--AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id  END ) = @p_division_id					
					--AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id  END ) = @p_division_id --div_commonization
					AND (r.division_id	IN
						   (												
							select division_id 								
							from SCM_MST_DIVISION with(nolock)								
							where attribute4 in (								
											select attribute4				
											from SCM_MST_DIVISION with(nolock)				
											where division_id = @p_division_id			
											and   attribute3 = 'EE'				
											)				
							and attribute3 <> 'EE'								
						   ) --div_commonization	
						OR r.division_id = @p_division_id 
						   )
					AND r.scp_operation_group = @p_operation_group
					AND ( ( @p_scm_site_id IS NULL     OR  @p_scm_site_id     ='' ) OR scm_site_id  IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
					AND ( ( @p_item_id IS NULL         OR  @p_item_id         ='' ) OR item_id      IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
					AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
					GROUP BY division_id, scp_operation_group, scm_site_id, item_id, line_id, operation_id, r.plan_date
							 , r.ELECTRODE_TYPE
						
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
					 ,a.column_name
					 ,a.column_label_name
					 ,c.yyyymmdd
					 ,ISNULL(b.sort_order_no,a.sort_order_no )
					 ,c.origin_division_id
					 ,c.electrode_type
			) m 
			LEFT OUTER JOIN  (  -- 계획
								SELECT a.division_id		
									  ,a.operation_group
									  ,a.scm_site_id		
									  ,a.item_id				
									  ,a.operation_id		
									  ,a.line_id				
									  ,a.measure				
									  ,a.yyyymmdd	
									  ,a.qty
									  ,ISNULL(NULLIF(a.ORIGIN_DIVISION_ID,''),'-') origin_division_id
									  ,ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') electrode_type		
								 FROM HIST_scp_anl_production_plan a
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
								   AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
								UNION ALL

							  -- 생산실적	
							   --SELECT r.division_id	
								--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id END as division_id								
								--SELECT CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id END as division_id --div_commonization
								SELECT @p_division_id as division_id --div_commonization
									  ,r.scp_operation_group AS operation_group	
									  ,r.scm_site_id
								      ,r.item_id
								      ,r.operation_id	
								      ,r.line_id
									  ,'PROD_PLAN_ENGINE' AS measure
									  ,convert(VARCHAR(8), r.plan_date,112) AS yyyymmdd
								      ,r.actual_good_qty AS qty	
									  --,'-' origin_division_id
									  ,r.division_id as origin_division_id
									  ,ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') electrode_type
								 FROM SCM_DNM_product_result_v r	
								WHERE 1=1
								  AND r.plan_date          >= convert(datetime, @v_from_result)
						          AND r.plan_date          < convert(datetime, @v_to_result )	-- equal 표시 주의할것	
								  --AND r.division_id         = @p_division_id
								  --AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' ELSE r.division_id  END ) = @p_division_id								  
								  --AND (CASE WHEN @p_division_id = 'EE' THEN 'EE' WHEN @p_division_id = 'EE_UC' THEN 'EE_UC' WHEN @p_division_id = 'EE_HM' THEN 'EE_HM' ELSE r.division_id  END ) = @p_division_id --div_commonization
								  AND (r.division_id	IN
										   (												
											select division_id 								
											from SCM_MST_DIVISION with(nolock)								
											where attribute4 in (								
															select attribute4				
															from SCM_MST_DIVISION with(nolock)				
															where division_id = @p_division_id			
															and   attribute3 = 'EE'				
															)				
											and attribute3 <> 'EE'								
										   ) --div_commonization	
										OR r.division_id = @p_division_id 
										   )
								  AND r.scp_operation_group = @p_operation_group
								  AND r.scm_site_id         = @p_scm_site_id
								  AND r.item_id             = @p_item_id
								  AND ( ( @p_electrode_type IS NULL OR @p_electrode_type = '' ) OR ISNULL(NULLIF(r.ELECTRODE_TYPE,''),'-') IN (SELECT token FROM dbo.String_Split(@p_electrode_type    ,',')) )
						    ) n  ON m.division_id       = n.division_id
								AND m.operation_group   = n.operation_group
								AND m.scm_site_id 		= n.scm_site_id
								AND m.item_id     		= n.item_id
								AND m.operation_id     	= n.operation_id
								AND m.line_id     		= n.line_id
								AND m.measure     		= n.measure
								AND m.yyyymmdd    		= n.yyyymmdd
								AND m.origin_division_id = n.origin_division_id
								AND m.electrode_type	= n.electrode_type
			INNER JOIN scm_sys_calendar_m o on m.yyyymmdd = o.basis_yyyymmdd
			-- 조회조건 추가부분 (Model Tab에서만 사용하는 REQUIREMENT , FORMATION_YIELD Measure는 *로 입력되어 Line조회시 제외함)
			WHERE m.line_id IS NOT NULL
			 AND m.line_id <> '*'
		END
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
			SET @mEXEC = @mEXEC+' 			,DBO.FN_GET_ITEM_PROD_OP(DIVISION_ID, operation_group, ITEM_ID) AS MODEL_ID							'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,ISNULL(NULLIF(dbo.fn_get_item_nickname (division_id, item_id ),''''),''-'') AS nick_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,measure_name	'+CHAR(10);
			SET @mEXEC = @mEXEC+'           ,operation_id,PLAN_TYPE, PLAN_SEQ, plan_start_yyyymmdd,from_yyyymmdd ' + CHAR(10);
			SET @mEXEC = @mEXEC+'       	,user_sort_order_no	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,origin_division_id	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,electrode_type	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	'+@mQry_sum+CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0011_02 '+CHAR(10);
			SET @mEXEC = @mEXEC+'		GROUP BY  division_id, operation_group, scm_site_id, line_id , item_id , measure, measure_name, operation_id,PLAN_TYPE, PLAN_SEQ, plan_start_yyyymmdd,from_yyyymmdd,user_sort_order_no '+CHAR(10);
			SET @mEXEC = @mEXEC+'				  ,origin_division_id ,electrode_type  '+CHAR(10);
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
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_02') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0011_02 ;						  
END
