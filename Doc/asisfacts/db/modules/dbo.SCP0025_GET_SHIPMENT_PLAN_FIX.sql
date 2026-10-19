/*
 * Program ID   : SCP0025_GET_SHIPMENT_PLAN_FIX
 * Description  : Production Plan Line 별 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2018/05/28   byunghunjung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/31	KYH					년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월 sum값 표시2018.5월의 sum이 표시된다
 * 2018/07/02	KYH					신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
 * 2019/06/07	HWYOON				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019/07/15	HWYOON				[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - BOD 조회추가
 * 2021/07/07   khj79			    PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022/04/29   chaan				81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2023/04/10   LWY					PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)

 ex) EXEC SCP0025_GET_SHIPMENT_PLAN_FIX @p_division_id='81', @p_biz_type='P', @p_item_id='', @p_from_yyyymmdd='20180702', @p_to_yyyymmdd='20190630', @p_electype='', @p_program_id='SCP0025', @p_sheet_name='Shipment Plan Fix', @p_user_id='kaiser99', @debug_mode='T'
   
*/

CREATE PROCEDURE [dbo].[SCP0025_GET_SHIPMENT_PLAN_FIX]
--chaan	 @p_division_id		NVARCHAR(2) 
	 @p_division_id		NVARCHAR(30) --chaan
	,@p_biz_type		NVARCHAR(1) 
	,@p_item_id			NVARCHAR(MAX) 
	,@p_from_yyyymmdd	NVARCHAR(8)
    ,@p_to_yyyymmdd		NVARCHAR(8)
	,@p_electype		NVARCHAR(300)
	,@p_program_id		NVARCHAR(MAX)
	,@p_sheet_name		NVARCHAR(MAX)
	,@p_user_id			NVARCHAR(MAX)
	,@debug_mode        NVARCHAR(MAX)

AS  

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0025') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0025;

	-- BOD 2단계 개발 : FROM , TO 추가
	CREATE TABLE #TblDynamicPivot_SCP0025 (
		 division_id	 NVARCHAR(128)	,biz_type			NVARCHAR(128)			,item_id		NVARCHAR(128)
		,ELECTRODE_TYPE	 NVARCHAR(128)	,ORIGIN_TO_DIVISION_ID		NVARCHAR(128)	,to_site		NVARCHAR(128)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(128) , from_site		NVARCHAR(128)	,incoterms		NVARCHAR(128)
		,project_code	 NVARCHAR(128)	,transport_mode		NVARCHAR(128)			,lt_total		INT
		,measure		NVARCHAR(128)	,qty				NUMERIC(20,0)			,from_yyyymmdd   NVARCHAR(128)
		,yyyymmdd		NVARCHAR(128)	,yyyymm				NVARCHAR(128)			,iso_week NVARCHAR(128)
		,BOD_ID			NVARCHAR(150)
		,BOD_FROM_YYYYMMDD NVARCHAR(008), BOD_TO_YYYYMMDD NVARCHAR(008)
	);
 
	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	--IF @p_division_id NOT IN ('EE','EE_UC')
	IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
	BEGIN
		INSERT #TblDynamicPivot_SCP0025
		SELECT  
	         division_id
			,biz_type
			,item_id
			,ELECTRODE_TYPE
			,ORIGIN_TO_DIVISION_ID
			,to_site
			,ORIGIN_FROM_DIVISION_ID
			,from_site
			,incoterms
			,project_code
			,transport_mode
			,lt_total
			,measure			
			,qty
			,@p_from_yyyymmdd AS from_yyyymmdd
			,'D_'+yyyymmdd AS yyyymmdd
			,n.basis_yyyymm AS yyyymm
			,RIGHT(n.basis_yyyymm, 4)+n.iso_week AS iso_week	
			,bod_id
			-- BOD 2단계 개발 : from, to추가
			,BOD_FROM_YYYYMMDD
			,BOD_TO_YYYYMMDD
		FROM (	 
			SELECT 
				 a.division_id
				,a.biz_type
				,a.item_id
				,ISNULL(NULLIF(a.electrode_type,''),'-') ELECTRODE_TYPE
				,ISNULL(NULLIF(a.ORIGIN_TO_DIVISION_ID,''), '-') as ORIGIN_TO_DIVISION_ID
				,a.to_site
				,ISNULL(NULLIF(a.ORIGIN_FROM_DIVISION_ID,'') , '-') as ORIGIN_FROM_DIVISION_ID
				,a.from_site
				,a.incoterms
				,a.project_code
				,b.transport_mode
				,b.lt_total
				,'Ship Plan' as measure	
				,yyyymmdd				
				,qty
				,a.bod_id
				-- BOD 2단계 개발 : from, to추가
				,b.from_yyyymmdd	AS BOD_FROM_YYYYMMDD
				,b.to_yyyymmdd		AS BOD_TO_YYYYMMDD
			FROM scp_anl_shipment_plan_fix a
			-- BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
			--JOIN scp_mst_bod_v b ON a.division_id = b.division_id AND a.bod_id = b.bod_id
			JOIN scp_mst_bod_n_v b ON a.division_id = b.division_id AND a.bod_id = b.bod_id
			WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.biz_type      = @p_biz_type
			AND ( ( @p_item_id	IS NULL OR  @p_item_id  ='') OR a.item_id			IN (SELECT token FROM dbo.String_Split(@p_item_id ,',')))
			--AND ( ( @p_electype IS NULL OR  @p_electype ='') OR A.ELECTRODE_TYPE	IN (SELECT token FROM dbo.String_Split(@p_electype, ',')))
			UNION ALL
			SELECT 
				 a.division_id
				,a.biz_type
				,a.item_id
				, ISNULL(NULLIF(a.ELECTRODE_TYPE,'') , '-') as ELECTRODE_TYPE
				, ISNULL(NULLIF(a.ORIGIN_TO_DIVISION_ID,'') , '-') as ORIGIN_TO_DIVISION_ID
				,a.to_site
				, ISNULL(NULLIF(a.ORIGIN_FROM_DIVISION_ID,'') , '-') as ORIGIN_FROM_DIVISION_ID
				,a.from_site
				,a.incoterms
				,a.project_code
				,b.transport_mode
				,b.lt_total
				,'Fix Reason' as measure	
				,yyyymmdd				
				,null as qty
				,a.bod_id
				-- BOD 2단계 개발 : from, to추가
				,b.from_yyyymmdd	AS BOD_FROM_YYYYMMDD
				,b.to_yyyymmdd		AS BOD_TO_YYYYMMDD
			FROM scp_anl_shipment_plan_fix a
			-- BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
			--JOIN scp_mst_bod_v b ON a.division_id = b.division_id AND a.bod_id = b.bod_id
			JOIN scp_mst_bod_n_v b ON a.division_id = b.division_id AND a.bod_id = b.bod_id
			WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.biz_type			   = @p_biz_type
			AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			--AND ( ( @p_electype IS NULL OR  @p_electype ='') OR A.ELECTRODE_TYPE	IN (SELECT token FROM dbo.String_Split(@p_electype, ',')))
		) m
		JOIN scm_sys_calendar_m n on m.yyyymmdd = n.basis_yyyymmdd	
		;
	END
	ELSE
	BEGIN
		INSERT #TblDynamicPivot_SCP0025
		SELECT  
	         division_id
			,biz_type
			,item_id
			,ELECTRODE_TYPE
			,ORIGIN_TO_DIVISION_ID
			,to_site
			,ORIGIN_FROM_DIVISION_ID
			,from_site
			,incoterms
			,project_code
			,transport_mode
			,lt_total
			,measure			
			,qty
			,@p_from_yyyymmdd AS from_yyyymmdd
			,'D_'+yyyymmdd AS yyyymmdd
			,n.basis_yyyymm AS yyyymm
			,RIGHT(n.basis_yyyymm, 4)+n.iso_week AS iso_week	
			,bod_id
			-- BOD 2단계 개발 : from, to추가
			,BOD_FROM_YYYYMMDD
			,BOD_TO_YYYYMMDD
		FROM (
			SELECT 
				 a.division_id
				,a.biz_type
				,a.item_id
				, ISNULL(NULLIF(a.ELECTRODE_TYPE , '') , '-') as ELECTRODE_TYPE
				, ISNULL(NULLIF(a.ORIGIN_TO_DIVISION_ID,'') , '-') as ORIGIN_TO_DIVISION_ID
				,a.to_site
				, ISNULL(NULLIF(a.ORIGIN_FROM_DIVISION_ID, '') , '-') as ORIGIN_FROM_DIVISION_ID
				,a.from_site
				,a.incoterms
				,a.project_code
				,b.transport_mode
				,b.lt_total
				,'Ship Plan' as measure	
				,yyyymmdd				
				,qty
				,a.bod_id
				-- BOD 2단계 개발 : from, to추가
				,b.from_yyyymmdd	AS BOD_FROM_YYYYMMDD
				,b.to_yyyymmdd		AS BOD_TO_YYYYMMDD
			FROM scp_anl_shipment_plan_fix a
			-- BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
			--JOIN scp_mst_bod_v b ON a.bod_id = b.bod_id
			JOIN scp_mst_bod_n_v b ON a.bod_id = b.bod_id
			WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.biz_type      = @p_biz_type
			AND ( ( @p_item_id	IS NULL OR  @p_item_id  ='') OR a.item_id			IN (SELECT token FROM dbo.String_Split(@p_item_id ,',')))
			AND ( ( @p_electype IS NULL OR  @p_electype ='') OR A.ELECTRODE_TYPE	IN (SELECT token FROM dbo.String_Split(@p_electype, ',')))
			UNION ALL
			SELECT 
				 a.division_id
				,a.biz_type
				,a.item_id
				, ISNULL(NULLIF(a.ELECTRODE_TYPE,'') , '-') as ELECTRODE_TYPE
				, ISNULL(NULLIF(a.ORIGIN_TO_DIVISION_ID,'') , '-') as ORIGIN_TO_DIVISION_ID
				,a.to_site
				, ISNULL(NULLIF(a.ORIGIN_FROM_DIVISION_ID,'') , '-') as ORIGIN_FROM_DIVISION_ID
				,a.from_site
				,a.incoterms
				,a.project_code
				,b.transport_mode
				,b.lt_total
				,'Fix Reason' as measure	
				,yyyymmdd				
				,null as qty
				,a.bod_id
				-- BOD 2단계 개발 : from, to추가
				,b.from_yyyymmdd	AS BOD_FROM_YYYYMMDD
				,b.to_yyyymmdd		AS BOD_TO_YYYYMMDD
			FROM scp_anl_shipment_plan_fix a
			-- BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
			--JOIN scp_mst_bod_v b ON a.bod_id = b.bod_id
			JOIN scp_mst_bod_n_v b ON a.bod_id = b.bod_id
			WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.biz_type			   = @p_biz_type
			AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			AND ( ( @p_electype IS NULL OR  @p_electype ='') OR A.ELECTRODE_TYPE	IN (SELECT token FROM dbo.String_Split(@p_electype, ',')))
		) m
		JOIN scm_sys_calendar_m n on m.yyyymmdd = n.basis_yyyymmdd	
		;

	END;

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/
		BEGIN
		DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mQuery = '';
		--SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
		SELECT  @mQuery = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'convert(nvarchar,SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END )) AS ' + yyyymmdd
											WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'convert(nvarchar,SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN  QTY  END )) AS ' + yyyymmdd
											WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'convert(nvarchar,SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  END )) AS ' + yyyymmdd
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
			SET @mEXEC = @mEXEC+'       	,biz_type	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_lookup_code_desc(''biz_type'',biz_type) biz_type_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, (case when dbo.FN_GET_ITEM_NICKNAME( division_id, item_id ) ='''' then ''-''					'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			   else dbo.FN_GET_ITEM_NICKNAME( division_id, item_id ) end) AS nick_name						'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,ORIGIN_TO_DIVISION_ID			'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,to_site	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_scm_site_description(division_id,to_site) AS to_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,ORIGIN_FROM_DIVISION_ID		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,from_site						'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,dbo.fn_get_scm_site_description(division_id,from_site) AS from_site_description	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,isnull(incoterms,''-'') as incoterms'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,isnull(project_code,''-'') as project_code '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,transport_mode '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,lt_total '+CHAR(10);
			SET @mEXEC = @mEXEC+'       	, ELECTRODE_TYPE		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	, BOD_ID		'+CHAR(10);
			-- BOD 2단계 개발 : FROM , TO 추가
			SET @mEXEC = @mEXEC+'       	, BOD_FROM_YYYYMMDD		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	, BOD_TO_YYYYMMDD		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	, measure	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			'+@mQuery	;
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0025 '+CHAR(10);
			SET @mEXEC = @mEXEC+'		GROUP BY  division_id, biz_type, item_id, to_site, from_site, incoterms  , project_code, transport_mode, lt_total,  measure , ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, BOD_ID '+CHAR(10);
			SET @mEXEC = @mEXEC+'				, BOD_FROM_YYYYMMDD , BOD_TO_YYYYMMDD		'+CHAR(10);  -- BOD 2단계 개발 : FROM , TO 추가
			--SET @mEXEC = @mEXEC+'		ORDER BY  division_id, biz_type, item_id, to_site, from_site, transport_mode, incoterms, project_code, measure desc '+CHAR(10);
			SET @mEXEC = @mEXEC+'		ORDER BY  division_id, biz_type, item_id, to_site, from_site, transport_mode, incoterms, project_code,BOD_ID, measure desc '+CHAR(10);
			
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
		
		--IF @p_division_id NOT IN ('EE','EE_UC')
		IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
		BEGIN
			SELECT 
				 a.division_id
				,a.biz_type
				,a.item_id
				, isnull(NULLIF(a.ELECTRODE_TYPE ,'') , '-') as ELECTRODE_TYPE
				, isnull(NULLIF(a.ORIGIN_TO_DIVISION_ID,'') , '-') as ORIGIN_TO_DIVISION_ID
				,a.to_site
				, isnull(NULLIF(a.ORIGIN_FROM_DIVISION_ID,'') , '-') as ORIGIN_FROM_DIVISION_ID
				,a.from_site
				,a.incoterms
				,a.project_code
				,b.transport_mode
				,b.lt_total
				,b.bod_id		-- BOD 2단계 개발
				,'Fix Reason' as measure
				,yyyymmdd				
				,fix_reason
			FROM scp_anl_shipment_plan_fix a
			-- BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v
			--JOIN scp_mst_bod_v b ON a.division_id = b.division_id AND a.bod_id = b.bod_id
			JOIN scp_mst_bod_n_v b ON a.division_id = b.division_id AND a.bod_id = b.bod_id
			WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.biz_type			   = @p_biz_type
			AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			--AND ( ( @p_electype IS NULL OR  @p_electype ='') OR A.ELECTRODE_TYPE	IN (SELECT token FROM dbo.String_Split(@p_electype, ',')))
			ORDER BY  division_id, biz_type, item_id, to_site, from_site, measure desc
		END
		ELSE
			SELECT 
				 a.division_id
				,a.biz_type
				,a.item_id
				, isnull(NULLIF(a.ELECTRODE_TYPE,'') , '-') as ELECTRODE_TYPE
				, isnull(NULLIF(a.ORIGIN_TO_DIVISION_ID, '') , '-') as ORIGIN_TO_DIVISION_ID
				,a.to_site
				, isnull(NULLIF(a.ORIGIN_FROM_DIVISION_ID, '') , '-') as ORIGIN_FROM_DIVISION_ID
				,a.from_site
				,a.incoterms
				,a.project_code
				,b.transport_mode
				,b.lt_total
				,b.bod_id		-- BOD 2단계 개발
				,'Fix Reason' as measure
				,yyyymmdd				
				,fix_reason
			FROM scp_anl_shipment_plan_fix a
			-- BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v
			--JOIN scp_mst_bod_v b ON  a.bod_id = b.bod_id
			JOIN scp_mst_bod_n_v b ON  a.bod_id = b.bod_id
			WHERE 1=1 
			AND a.yyyymmdd			  >= @p_from_yyyymmdd
			AND a.yyyymmdd			  <= @p_to_yyyymmdd		
			AND a.division_id	       = @p_division_id
			AND a.biz_type			   = @p_biz_type
			AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR a.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
			AND ( ( @p_electype IS NULL OR  @p_electype ='') OR A.ELECTRODE_TYPE	IN (SELECT token FROM dbo.String_Split(@p_electype, ',')))
			ORDER BY  division_id, biz_type, item_id, to_site, from_site, measure desc
		END;
	
		 --임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0025') IS NOT NULL
			DROP TABLE #TblDynamicPivot_SCP0025 ;
			  
END

  
