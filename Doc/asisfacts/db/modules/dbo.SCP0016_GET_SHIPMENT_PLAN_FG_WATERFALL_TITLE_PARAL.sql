


/*
 * Program ID   : SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL
 * Description  : Shipment Plan Waterfall 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/06/25   HWY				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/02	HWY				쿼리 튜닝(성능 향상)
 * 2018/07/02	KYH				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
 * 2021/05/24   khj79           [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선- 부서정보 없는 경우 조회 안되는 오류 수정
 * 2021/07/07   khj79			PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2022.07.29   chaan           PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : ISO Weekly 추가에 따른 헤더 수정
 * 2023/04/10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023.06.23   KJJ				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Like 검색기능
 ==================================================================================================================================================================

 ex)   EXEC SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL @p_from_yyyymmdd='20180604', @p_to_yyyymmdd='20190602', @p_division_id='81', @p_biz_type='E', @p_project_code='', @p_item_id='', @p_version_no='SP_W_20180604', @p_program_id='SCP0016', @p_sheet_name='Shipment Plan FG', @p_user_id='kaiser99'

 */
CREATE PROCEDURE [dbo].[SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL]
	@p_from_yyyymmdd		NVARCHAR(MAX),
	@p_to_yyyymmdd			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_biz_type				NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_version_no			NVARCHAR(MAX),
	@p_electype				NVARCHAR(MAX) ,
    @p_iso					NVARCHAR(MAX),
	@p_program_id			NVARCHAR(MAX) = 'SCP0016' ,
	@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan FG' ,
	@p_user_id				NVARCHAR(MAX),
	@debug_mode				NVARCHAR(20)  ='F'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	--DECLARE @p_from_yyyymmdd		NVARCHAR(MAX)   = N'20221201'
	--DECLARE @p_to_yyyymmdd			NVARCHAR(MAX)   = N'20230716'
	--DECLARE @p_division_id			NVARCHAR(MAX)   = N'82'
	--DECLARE @p_biz_type				NVARCHAR(MAX)   = N'P'
	--DECLARE @p_project_code			NVARCHAR(MAX)   = N''
	--DECLARE @p_item_id				NVARCHAR(MAX)   = N''
	--DECLARE @p_version_no			NVARCHAR(MAX)   = N'SP_W_20220718'
	--DECLARE @p_electype				NVARCHAR(MAX)   = N''
	--DECLARE @p_iso					NVARCHAR(MAX)   = N'T'
	--DECLARE @p_program_id			NVARCHAR(MAX)   = N'SCP0016'
	--DECLARE @p_sheet_name			NVARCHAR(MAX)   = N'Shipment Plan FG'
	--DECLARE @p_user_id				NVARCHAR(MAX)   = N'iamarock'
	--DECLARE @debug_mode				NVARCHAR(20)    = N'F'


	declare @v_data_cnt nvarchar(8);
	set @v_data_cnt =0;
	
	DECLARE @v_cnt_usr_measure	NVARCHAR(MAX) ='0';

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_version_no NVARCHAR(MAX)='';
	DECLARE  @v_project_code NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	DECLARE  @v_electype NVARCHAR(MAX)='';

	--IN 조건으로 데이터를 가져옴
	SET @v_version_no = [dbo].FN_GET_IN_STR(@p_version_no);
	SET @v_project_code = [dbo].FN_GET_IN_STR(@p_project_code);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_electype = [dbo].FN_GET_IN_STR(@p_electype);

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
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0016') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0016

	create table #TblDynamicPivot_SCP0016(
		 key_idx NVARCHAR(200)
		,version_no NVARCHAR(50)
		,division_id NVARCHAR(30)
		,biz_type NVARCHAR(30)
		,project_code NVARCHAR(50)
		,item_id NVARCHAR(50)
		,ELECTRODE_TYPE NVARCHAR(50)
		,ORIGIN_TO_DIVISION_ID  NVARCHAR(50)
		,to_site NVARCHAR(30)
		,incoterms NVARCHAR(10)
		,ORIGIN_FROM_DIVISION_ID  NVARCHAR(50)
		,from_site NVARCHAR(30)
		,transport_mode NVARCHAR(50)
		,lt_day NVARCHAR(300)
		,measure NVARCHAR(50)
		,measure_label NVARCHAR(150)
		,measure_order_no INT
		,bod_id NVARCHAR(150)
		--,qty NVARCHAR(200)
		,plan_start_yyyymmdd NVARCHAR(8)
		,plan_type NVARCHAR(50)
		,seq NVARCHAR(200)
		,biz_type_name NVARCHAR(30)
		,nick_name NVARCHAR(150)
		,to_site_name NVARCHAR(150)
		,from_site_name NVARCHAR(150)
		,from_yyyymmdd NVARCHAR(8)
		,to_yyyymmdd NVARCHAR(8)
		--,yyyymmdd NVARCHAR(10)
		--,yyyymm NVARCHAR(6)
		--,iso_week NVARCHAR(6)
	);
	
 
	SET @mDQry = @mDQry + ' INSERT INTO #TblDynamicPivot_SCP0016	                          ' + char(10) ;
	SET @mDQry = @mDQry + '	 	SELECT   distinct																																																																																' + char(10) ;
	SET @mDQry = @mDQry + '	 	         (a.division_id + a.biz_type + a.project_code  + a.item_id + a.to_site + a.incoterms ) as key_idx                                                                       ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.version_no	                                                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.division_id		,a.biz_type	, a.project_code                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.item_id			                                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, ISNULL(NULLIF(a.ELECTRODE_TYPE , ''''), ''-'') as ELECTRODE_TYPE			                                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, ISNULL(NULLIF(a.ORIGIN_TO_DIVISION_ID , '''') , ''-'') as ORIGIN_TO_DIVISION_ID			                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.to_site	                                                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.incoterms                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '				, ISNULL(NULLIF(a.ORIGIN_FROM_DIVISION_ID , '''') , ''-'') as ORIGIN_FROM_DIVISION_ID																			  ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.from_site                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, c.transport_mode	                                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, c.lt_total AS lt_day                                                                                                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.measure	                                                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, b.column_label_name  as measure_label                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, isnull(d.sort_order_no, b.sort_order_no ) AS measure_order_no		                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.bod_id                                                                                                                                                                  ' + char(10) ;
	--SET @mDQry = @mDQry + '				, a.qty                                                                                                                                                                 ' + char(10) ;
	--SET @mDQry = @mDQry + '				, '''' qty                                                                                                                                                              ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.plan_start_yyyymmdd                                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.plan_type                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.seq                                                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '	 			--, isnull(a.project_name ,''-'') as project_name                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.biz_type_name                                                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.nick_name                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.to_site_name                                                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, a.from_site_name                                                                                                                                                          ' + char(10) ;
	SET @mDQry = @mDQry + '	 			--, a.soldto_description                                                                                                                                                    ' + char(10) ;
	SET @mDQry = @mDQry + '	 			--, a.shipto_description                                                                                                                                                    ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, '''+@p_from_yyyymmdd+''' as from_yyyymmdd                                                                                                                                 ' + char(10) ;
	SET @mDQry = @mDQry + '	 			, '''+@p_to_yyyymmdd+''' as to_yyyymmdd                                                                                                                                     ' + char(10) ;
	--SET @mDQry = @mDQry + '				,''D_''+a.yyyymmdd AS yyyymmdd                                                                                                                                          ' + char(10) ;
	--SET @mDQry = @mDQry + '				,o.basis_yyyymm AS yyyymm                                                                                                                                               ' + char(10) ;
	--SET @mDQry = @mDQry + '				--,RIGHT(o.basis_yyyymm,2)+o.iso_week AS iso_week                                                                                                                       ' + char(10) ;
	--SET @mDQry = @mDQry + '				,RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week                                                                                                                        ' + char(10) ;
	--SET @mDQry = @mDQry + '	    INTO  #TblDynamicPivot_SCP0016                                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + '	 	FROM SCP_ANL_SHIPMENT_PLAN_FG_C a                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '	 	JOIN scm_sys_calendar_m o on a.yyyymmdd = o.basis_yyyymmdd                                                                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + '	 	JOIN SCM_MST_SHEET_MEASURE b on a.MEASURE = b.COLUMN_NAME                                                                                                                       ' + char(10) ;
	
	-- BOD 2단계 : 시작
	--IF @p_division_id != 'EE'
	--	SET @mDQry = @mDQry + '	LEFT JOIN scp_mst_bod_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site                                                               ' + char(10) ;
	--ELSE
	--	SET @mDQry = @mDQry + '	LEFT JOIN scp_mst_bod_v c ON a.origin_from_division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site                                                    ' + char(10) ;
	
	--IF @p_division_id NOT IN ('EE','EE_UC')
	IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
		SET @mDQry = @mDQry + '	LEFT JOIN scp_mst_bod_n_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site                       ' + char(10) ;
	ELSE
		SET @mDQry = @mDQry + '	LEFT JOIN scp_mst_bod_n_v c ON a.origin_from_division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site           ' + char(10) ;
	-- BOD 2단계 : 끝
	SET @mDQry = @mDQry + '	 	LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name AND d.column_name = b.column_name AND d.user_id = '''+@p_user_id+'''   ' + char(10) ;
	SET @mDQry = @mDQry + '	 	WHERE 1=1                                                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + '	 	AND b.program_id       =   '''+@p_program_id+'''                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '	 	AND b.sheet_name       =   '''+@p_sheet_name+'''                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + '	 	AND b.valid_yn		 =	''Y''                                                                                                                                                       ' + char(10) ;

	SET @mDQry = @mDQry + '	 	AND ('''+@v_cnt_usr_measure+''' = ''0'' OR EXISTS (SELECT 1		                            ' + char(10) ;
	SET @mDQry = @mDQry + '	 											FROM scm_mst_titleset_user                                                                                                                                  ' + char(10) ;
	SET @mDQry = @mDQry + '	 										   WHERE program_id  = '''+@p_program_id+'''                                                                                                                         ' + char(10) ;
	SET @mDQry = @mDQry + '	 											 AND sheet_name  = '''+@p_sheet_name+'''                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + '	 											 AND user_id     = '''+@p_user_id+'''                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + '	 											 AND column_name = b.column_name)                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + '	 	    )	                                                                                                                                                                          ' + char(10) ;

	SET @mDQry = @mDQry + '	 	AND a.yyyymmdd >= '''+@p_from_yyyymmdd+'''                                                                                                                                              ' + char(10) ;
	SET @mDQry = @mDQry + '	 	AND a.yyyymmdd <= '''+@p_to_yyyymmdd+'''                                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + '	 	AND a.division_id  = '''+@p_division_id+'''                                                                                                                                             ' + char(10) ;
	SET @mDQry = @mDQry + '	 	AND a.biz_type     = '''+@p_biz_type+'''                                                                                                                                                ' + char(10) ;
	--SET @mDQry = @mDQry + '					AND ( ( '''+@p_version_no+'''	 IS NULL OR  '''+@p_version_no+''' = '''' )  OR a.VERSION_NO	 IN ('+@v_version_no+') )                                                                                 ' + char(10) ;
	--SET @mDQry = @mDQry + '					AND ( ( '''+@p_project_code+'''  IS NULL OR  '''+@p_project_code+''' ='''' ) OR a.project_code IN ('+@v_project_code+') )                                                                             ' + char(10) ;
	--SET @mDQry = @mDQry + '					AND ( ( '''+@p_item_id+'''       IS NULL OR  '''+@p_item_id+'''      ='''' ) OR a.item_id      IN ('+@v_item_id+') )                                                                                  ' + char(10) ;
	IF ( @p_version_no IS NOT NULL AND @p_version_no !='') SET @mDQry = @mDQry + ' 			AND  a.VERSION_NO   IN ('+ @v_version_no +')'+char(10);   
	IF ( @p_project_code IS NOT NULL AND @p_project_code !='') SET @mDQry = @mDQry + ' 		AND  a.project_code   IN ('+ @v_project_code +')'+char(10);   
	IF ( @p_item_id IS NOT NULL AND @p_item_id !='') SET @mDQry = @mDQry + ' 				AND  a.item_id   IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(''' + @p_item_id + ''', ''''))' +char(10);
	IF ( @p_electype IS NOT NULL AND @p_electype !='') SET @mDQry = @mDQry + ' 				AND  a.ELECTRODE_TYPE   IN ('+ @v_electype +')'+char(10);

	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------	
	IF( @debug_mode ='T')
		BEGIN				
			DECLARE @POS INT =1;
			DECLARE @LEN INT =LEN(@mDQry);
			WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mDQry,@POS,4000);
					SET @POS = @POS+4000;
				END;
		END;
	-----------------------------------------------------------


	EXEC (@mDQry);

	/*
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mDQry);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@mDQry,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;
	*/


	/*
	SELECT   distinct
	         (a.division_id + a.biz_type + a.project_code  + a.item_id + a.to_site + a.incoterms ) as key_idx
			, a.version_no	
			, a.division_id		,a.biz_type	, a.project_code
			, a.item_id			
			, a.to_site	
			, a.incoterms
			, a.from_site 
			, c.transport_mode	
			, c.lt_total AS lt_day
			, a.measure	
			, b.column_label_name  as measure_label
			, isnull(d.sort_order_no, b.sort_order_no ) AS measure_order_no		
			, a.bod_id 
			, a.qty
			, a.plan_start_yyyymmdd
			, a.plan_type
			, a.seq
			--, isnull(a.project_name ,'-') as project_name
			, a.biz_type_name 
			, a.nick_name
			, a.to_site_name
			, a.from_site_name
			--, a.soldto_description
			--, a.shipto_description
			, @p_from_yyyymmdd as from_yyyymmdd
			, @p_to_yyyymmdd as to_yyyymmdd
			,'D_'+a.yyyymmdd AS yyyymmdd
			,o.basis_yyyymm AS yyyymm
			--,RIGHT(o.basis_yyyymm,2)+o.iso_week AS iso_week
			,RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week
    INTO  #TblDynamicPivot_SCP0016
	FROM SCP_ANL_SHIPMENT_PLAN_FG_C a
	JOIN scm_sys_calendar_m o on a.yyyymmdd = o.basis_yyyymmdd
	JOIN SCM_MST_SHEET_MEASURE b on a.MEASURE = b.COLUMN_NAME
	LEFT JOIN scp_mst_bod_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site
	LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name AND d.column_name = b.column_name AND d.user_id = @p_user_id 
    WHERE 1=1
	AND b.program_id       =   @p_program_id
	AND b.sheet_name       =   @p_sheet_name
	AND b.valid_yn		 =	'Y'
	AND (@v_cnt_usr_measure = 0 OR EXISTS (SELECT 1											
											FROM scm_mst_titleset_user  
										   WHERE program_id  = @p_program_id 
											 AND sheet_name  = @p_sheet_name 
											 AND user_id     = @p_user_id 
											 AND column_name = b.column_name) 
	    )	
	AND a.yyyymmdd >= @p_from_yyyymmdd
	AND a.yyyymmdd <= @p_to_yyyymmdd
	AND a.division_id  = @p_division_id
	AND a.biz_type     = @p_biz_type
	AND ( ( @p_version_no	 IS NULL OR  @p_version_no = '' )  OR a.VERSION_NO	 IN (SELECT token FROM dbo.String_Split(@p_version_no ,',')) )
	AND ( ( @p_project_code  IS NULL OR  @p_project_code ='' ) OR a.project_code IN (SELECT token FROM dbo.String_Split(@p_project_code,',')) )
	AND ( ( @p_item_id       IS NULL OR  @p_item_id      ='' ) OR a.item_id      IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	*/
	

	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/		
	BEGIN
		--DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mQry_sum NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);
		DECLARE @mDAY_QTY NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성		
		SET @mQry_sum = '';
		

		IF @p_iso = 'F' -- 일반 Weekly 헤더 생성
		BEGIN
			SELECT	@mQry_sum = @mQry_sum + ', '''' ' + yyyymmdd + '' + CHAR(10)
			FROM	( 
						SELECT	  'W_'+A.BASIS_YYYYMM + A.ISO_WEEK AS YYYYMMDD
								, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
						FROM	[DBO].[SCM_SYS_CALENDAR_M] A
						WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @P_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
						UNION ALL
						SELECT	  'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
								, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
						FROM	[DBO].[SCM_SYS_CALENDAR_M] A
						WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @P_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
						UNION ALL
						SELECT	'D_'+A.BASIS_YYYYMMDD AS YYYYMMDD
								, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
						FROM	[DBO].[SCM_SYS_CALENDAR_M] A
						WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @P_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMMDD
					) AS A
			ORDER BY	SORT_ORDER_NO;
		END
		ELSE
		BEGIN		 -- ISO Weekly 헤더 생성
			SELECT	@mQry_sum = @mQry_sum + ', '''' ' + yyyymmdd + '' + CHAR(10)
			FROM	( 
						SELECT    'W_' + A.ISO_YYYYMM + A.ISO_WEEK + '_ISO' AS YYYYMMDD
								, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), 21)    AS SORT_ORDER_NO
						FROM	[DBO].[SCM_SYS_CALENDAR_M] A
						WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @P_TO_YYYYMMDD
						GROUP BY A.ISO_YYYYMM, A.ISO_WEEK
						UNION ALL
						SELECT	  'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
								, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
						FROM	[DBO].[SCM_SYS_CALENDAR_M] A
						WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @P_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
						UNION ALL
						SELECT	'D_'+A.BASIS_YYYYMMDD AS YYYYMMDD
								, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
						FROM	[DBO].[SCM_SYS_CALENDAR_M] A
						WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @P_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMMDD
					) AS A
			ORDER BY	SORT_ORDER_NO;
		END
		
			SET @mEXEC = '';

			SET @mEXEC = @mEXEC+'      SELECT a.*																							'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(b.PROJECT_NAME, ''-'') PROJECT_NAME													'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(b.PROJECT_OWNER, ''-'') PROJECT_OWNER												'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(dbo.FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', c.ITEM_TYPE) ,''-'') ITEM_TYPE		'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(e.DEPT_NAME_KO, ''-'') DEPT_NAME_KO													'+CHAR(10);
			SET @mEXEC = @mEXEC+'	   from (																								'+CHAR(10);

			SET @mEXEC = @mEXEC+'      SELECT  ';
			SET @mEXEC = @mEXEC+'      		  key_idx	';
			SET @mEXEC = @mEXEC+' 			, division_id ';
			SET @mEXEC = @mEXEC+' 			, biz_type	';
			SET @mEXEC = @mEXEC+' 			, biz_type_name ';
			SET @mEXEC = @mEXEC+' 			, project_code	';
			--SET @mEXEC = @mEXEC+' 			, project_name ';
			SET @mEXEC = @mEXEC+' 			, item_id	';
			SET @mEXEC = @mEXEC+' 			, nick_name ';
			SET @mEXEC = @mEXEC+' 			, ELECTRODE_TYPE ';
			SET @mEXEC = @mEXEC+' 			, ORIGIN_TO_DIVISION_ID ';
			SET @mEXEC = @mEXEC+' 			, to_site	';
			SET @mEXEC = @mEXEC+' 			, to_site_name	';
			SET @mEXEC = @mEXEC+' 			, incoterms	';
			--SET @mEXEC = @mEXEC+'			, case SOLDTO_DESCRIPTION when '''' then ''-'' else SOLDTO_DESCRIPTION end as SOLDTO_DESCRIPTION ';
			--SET @mEXEC = @mEXEC+'			, case SHIPTO_DESCRIPTION when '''' then ''-'' else SHIPTO_DESCRIPTION end as SHIPTO_DESCRIPTION ';
			SET @mEXEC = @mEXEC+' 			, ORIGIN_FROM_DIVISION_ID		';
			SET @mEXEC = @mEXEC+' 			, from_site		';
			SET @mEXEC = @mEXEC+' 			, ISNULL(from_site_name ,''-'') as from_site_name	';
			SET @mEXEC = @mEXEC+' 			, bod_id		';
			SET @mEXEC = @mEXEC+' 			, ISNULL(transport_mode , ''-'') as transport_mode	';
			SET @mEXEC = @mEXEC+' 			, ISNULL(lt_day , 0) as lt_day	';
			SET @mEXEC = @mEXEC+' 			,plan_start_yyyymmdd ';
			SET @mEXEC = @mEXEC+' 			,plan_type ';
			SET @mEXEC = @mEXEC+' 			,seq '; 
			SET @mEXEC = @mEXEC+' 			, cast( round( [dbo].[FN_GET_SCP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd, plan_type, seq, to_site , item_id,from_yyyymmdd) , 1) as int) as boh ';
			SET @mEXEC = @mEXEC+' 			, version_no	';
			SET @mEXEC = @mEXEC+' 			, measure	';
			SET @mEXEC = @mEXEC+' 			, measure_order_no	';
			SET @mEXEC = @mEXEC+' 			, measure_label 	';
			SET @mEXEC = @mEXEC+' 			, from_yyyymmdd	';
			SET @mEXEC = @mEXEC+' 			, to_yyyymmdd	';			
			SET @mEXEC = @mEXEC+' 			'+@mQry_sum	+CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SCP0016 t';
			--SET @mEXEC = @mEXEC+'	   GROUP BY key_idx, division_id, biz_type,biz_type_name,project_code, item_id,  nick_name, to_site,to_site_name,incoterms, from_site,from_site_name,bod_id,transport_mode,lt_day,plan_start_yyyymmdd,plan_type, seq,version_no,measure,measure_order_no,measure_label,from_yyyymmdd,to_yyyymmdd'+CHAR(10);
			--SET @mEXEC = @mEXEC+'	   ORDER BY division_id, biz_type, item_id, to_site,project_code, incoterms, from_site, bod_id, measure_order_no ,version_no  ';	

			SET @mEXEC = @mEXEC+'      ) a																									'+CHAR(10);
			SET @mEXEC = @mEXEC+'      LEFT JOIN (SELECT DIVISION_ID																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_CODE																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_OWNER																	'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC ) NUMS											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					FROM SCM_MST_PROJECT WITH(NOLOCK)														'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 ) b  on a.PROJECT_CODE	= b.PROJECT_CODE 													'+CHAR(10);
			
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'					 and a.DIVISION_ID	= b.DIVISION_ID													'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'					 and a.origin_to_division_id	= b.DIVISION_ID													'+CHAR(10);
			
			SET @mEXEC = @mEXEC+'					 and b.NUMS=1																			'+CHAR(10);
			SET @mEXEC = @mEXEC+'      LEFT JOIN (SELECT DIVISION_ID																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ITEM_ID																			'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ITEM_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , NICK_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ITEM_TYPE																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, ITEM_ID ORDER BY  CASE ITEM_TYPE WHEN ''P'' THEN 999 WHEN ''H'' THEN 888 WHEN ''R'' THEN 777  WHEN ''Q'' THEN 666 ELSE 0 END  DESC ) NUMS																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'					FROM SCM_MST_ITEM_SN WITH(NOLOCK)														'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 ) c  on a.item_id=c.item_id														'+CHAR(10);
			
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'			and a.division_id = c.division_id																'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'			and a.origin_to_division_id = c.division_id																'+CHAR(10);
			
			SET @mEXEC = @mEXEC+'				and c.nums=1																			'+CHAR(10);

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			BEGIN
				-- 2021-05-24 : 부서정보 없는 경우 조회 안되는 오류 수정
				--SET @mEXEC = @mEXEC+'      INNER JOIN scm_mst_site d  on a.DIVISION_ID=d.DIVISION_ID and a.TO_SITE=d.SCM_SITE_ID											'+CHAR(10);
				--SET @mEXEC = @mEXEC+'      INNER JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID											'+CHAR(10);
				SET @mEXEC = @mEXEC+'      LEFT JOIN scm_mst_site d  on a.DIVISION_ID=d.DIVISION_ID and a.TO_SITE=d.SCM_SITE_ID											'+CHAR(10);
				SET @mEXEC = @mEXEC+'      LEFT JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID											'+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'      LEFT JOIN scm_mst_site d  on a.origin_from_division_id=d.DIVISION_ID and d.SCM_SITE_ID = DBO.FN_GET_SITE_NAME_SHIPMENT(a.TO_SITE)											'+CHAR(10);
				SET @mEXEC = @mEXEC+'      LEFT JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID											'+CHAR(10);
			END;
			SET @mEXEC = @mEXEC+'	   ORDER BY division_id, biz_type, item_id, to_site,project_code, incoterms, from_site, bod_id, measure_order_no ,version_no  ';	


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

			--임시테이블 삭제
			DROP TABLE #TblDynamicPivot_SCP0016;
	end
	;

	

END


  
