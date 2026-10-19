



/*
 * Program ID   : SCM0002_GET_PROJECT_ROUTE_LIST_FORSAVE_POPUP
 * Description  : project route 입력목록 조회
 * Program History
 
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/07/25   YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/08/09	YHW				조회조건 model_id, item_id추가
 * 2018/08/20	YHW				소형 VALIDATION용 ERP ITEM 조회
 * 2018/09/19	hwyoon			Item Type = R 도 보이도록 수정
 * 2018/11/08	hwyoon			vmi에 따라 MKT measure 조절
 * 2021/10/05	khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2022/11/07   jahn1501		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_PROJECT_ROUTE_LIST_FORSAVE_POPUP]
--chaan	@p_division_id    NVARCHAR(2),
	@p_division_id    NVARCHAR(30),--chaan
	@p_model_id    NVARCHAR(200),
	@p_item_id		 NVARCHAR(200),
	@p_timeZone		 NVARCHAR(MAX),
	@debug_mode       NVARCHAR(1) ='F'
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';

	-- 시작일 설정(현재 월의 1일) ex.20180801
	SET @v_from_yyyymmdd = (
							SELECT SUBSTRING( ISNULL( (
								SELECT MIN(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]
								WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR,  dbo.FN_MULTY_TIME(@p_timeZone), 112), 0, 7) AND ISO_WEEK IN
								(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@p_timeZone), 112) ) 
								), CONVERT(VARCHAR, GETDATE(), 112)) , 0, 7) + '01'
							);

	-- 종료일 설정(12개월) ex.20190731
	SET @v_to_yyyymmdd =  (SELECT CONVERT(VARCHAR, DATEADD(DAY, -1, DATEADD(MONTH, 12, CONVERT(DATETIME, @v_from_yyyymmdd))), 112 ) );

	-- from_yyyymmdd는 현재일자의 월요일로 강제설정
	-- ex.20180806
	set @v_from_yyyymmdd= (SELECT convert(VARCHAR(8), dateadd(dd, -(dayofweek_no-1),basis_yyyymmDD),112) as basis_start_date
							 FROM (
									SELECT (CASE WHEN DAYOFWEEK_NO -1 =0 THEN 7 ELSE dayofweek_no -1 END ) dayofweek_no 
										   ,CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD
										   ,DAYOFWEEK
									  FROM scm_sys_calendar_m 
									 WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)
  								  ) f 
						  ) ;

	print '@v_from_yyyymmdd = ' +@v_from_yyyymmdd;
	print '@v_to_yyyymmdd   = ' +@v_to_yyyymmdd;


	IF ( @debug_mode ='T')
		BEGIN
			PRINT '==============PARMS INFO================';
			PRINT '@p_division_id   = ' + @p_division_id ;
			--PRINT '@p_scm_site_id   = ' + @p_scm_site_id ;
			--PRINT '@p_project_code  = ' + @p_project_code;
			PRINT '@p_model_id		= ' + @p_model_id	 ;
			PRINT '@p_item_id		= ' + @p_item_id	 ;
			PRINT '@v_from_yyyymmdd = ' + @v_from_yyyymmdd ;
			PRINT '@v_to_yyyymmdd   = ' + @v_to_yyyymmdd   ;
			PRINT '';
		END;



	/********************************************************************************
	* 임시테이블만들기 - Main 조회 테이블
	********************************************************************************/	
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCM0002_01') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCM0002_01 
	
	CREATE TABLE #TblDynamicPivot_SCM0002_01 (
		 DIVISION_ID		NVARCHAR(30)	,SCM_SITE_ID		NVARCHAR(30)
		,scm_site_name		NVARCHAR(MAX)	,project_code		NVARCHAR(50)
		,model_id			NVARCHAR(150)	,nick_name			NVARCHAR(100)
		,ITEM_ID			NVARCHAR(50)	,item_name			NVARCHAR(100)
		,operation_group_id	NVARCHAR(1)		,operation_group	NVARCHAR(50)
		,PLANT_SITE_ID		NVARCHAR(50)	,VALID_YN			NVARCHAR(1)
		,PRIORITY			int	
		,FROM_YYYYMMDD		NVARCHAR(10)	,TO_YYYYMMDD		NVARCHAR(10)	
		,ORG_FROM_YYYYMMDD	NVARCHAR(10)	,ORG_TO_YYYYMMDD	NVARCHAR(10)
	)

	DECLARE @mEXEC NVARCHAR(MAX);

	SET @mEXEC = '';

	SET @mEXEC = @mEXEC + '   INSERT #TblDynamicPivot_SCM0002_01																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   SELECT A.*																								'+CHAR(10);
	SET @mEXEC = @mEXEC + '     FROM (																									'+CHAR(10);

	SET @mEXEC = @mEXEC + '   SELECT DISTINCT U.DIVISION_ID																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,U.SCM_SITE_ID																				'+CHAR(10);
	IF (@p_division_id = '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   				,dbo.FN_GET_SCM_SITE_DESCRIPTION(U.DIVISION_ID,U.SCM_SITE_ID) AS scm_site_name			'+CHAR(10);
	END;
	ELSE IF (@p_division_id != '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   				,''-'' AS scm_site_name																	'+CHAR(10);
	END;
	SET @mEXEC = @mEXEC + '   				,U.project_code																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,U.model_id																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,dbo.fn_get_item_nickname (U.division_id, U.MODEL_ID) AS nick_name							'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,U.ITEM_ID																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,dbo.FN_GET_ITEM_NICKNAME(U.division_id, U.ITEM_ID) as item_name							'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,U.operation_group operation_group_id														'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,U.operation_group_id operation_group														'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,'''' AS PLANT_SITE_ID																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,''Y'' AS VALID_YN																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,1 AS PRIORITY																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,'''' AS FROM_YYYYMMDD																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,'''' AS TO_YYYYMMDD																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,'''' AS ORG_FROM_YYYYMMDD																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				,'''' AS ORG_TO_YYYYMMDD																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '     FROM (select distinct a.division_id																		'+CHAR(10);
	IF (@p_division_id = '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   						,project_code																	'+CHAR(10);
		SET @mEXEC = @mEXEC + '   						,a.scm_site_id																	'+CHAR(10);
	END;
	ELSE IF (@p_division_id != '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   						,''-'' project_code																'+CHAR(10);
		SET @mEXEC = @mEXEC + '   						,''-'' scm_site_id																'+CHAR(10);
	END;
	SET @mEXEC = @mEXEC + '   						,a.item_id																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,dom_exp																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,fcst_type																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,incoterms																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,measure																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,plant_site_id																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,yyyymmdd																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,qty																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		  from dm_pln_mkt_fcst a																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		  JOIN scm_mst_item_sn b ON a.division_id = b.division_id and a.item_id= b.item_id					'+CHAR(10);
	--2021/10/05 : W/S AS
	--SET @mEXEC = @mEXEC + '   		  LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN=''Y''	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		  LEFT JOIN scm_mst_site s ON s.DIVISION_ID = a.DIVISION_ID												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   								  AND s.SCM_SITE_ID = a.SCM_SITE_ID 											'+CHAR(10);
	SET @mEXEC = @mEXEC + '   								  AND (s.VMI_YN=''Y'' OR ( SITE_TYPE = ''SALES'' AND OPERATION_GROUP = ''W''))	'+CHAR(10);	
	SET @mEXEC = @mEXEC + '   		 WHERE 1=1																										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '   		   AND a.measure =''MKT_FCST''																				'+CHAR(10);
	--2021/10/05 : W/S AS
	--SET @mEXEC = @mEXEC + '   		   AND a.MEASURE = IIF( ISNULL(s.vmi_yn, ''N'') = ''Y'', ''VMI_In_Req'',  ''MKT_FCST'')							'+CHAR(10);
	--2022/11/07
	--SET @mEXEC = @mEXEC + '   		   AND a.MEASURE = IIF(ISNULL(s.OPERATION_GROUP, '''') = ''W'', ''AS_In_Req'', IIF(s.vmi_yn = ''Y'', ''VMI_In_Req'',  ''MKT_FCST''))	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '''') = ''W'' THEN ''AS_In_Req'' WHEN S.vmi_yn = ''Y'' THEN ''VMI_In_Req'' WHEN ISNULL(a.attribute10, '''') = '''' THEN ''MKT_FCST'' END	' + CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND b.scp_operation_group_id <> ''E''																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.yyyymmdd >= '''+@v_from_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.yyyymmdd <= '''+@v_to_yyyymmdd+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.yyyymmdd != '''' and a.yyyymmdd is not null															'+CHAR(10);
	/*
	SET @mEXEC = @mEXEC + '   		 UNION ALL																										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   	    select distinct a.division_id																					'+CHAR(10);
	IF (@p_division_id = '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   						,project_code																				'+CHAR(10);
		SET @mEXEC = @mEXEC + '   						,scm_site_id																				'+CHAR(10);
	END;
	ELSE IF (@p_division_id != '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   						,''-'' project_code																			'+CHAR(10);
		SET @mEXEC = @mEXEC + '   						,''-'' scm_site_id																			'+CHAR(10);
	END;
	SET @mEXEC = @mEXEC + '   						,a.item_id																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,dom_exp																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,fcst_type																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,incoterms																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,measure																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,plant_site_id																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,yyyymmdd																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						,qty																							'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		  from dbo.DM_PLN_MKT_FCST_RESULT a																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   	      JOIN scm_mst_item_sn b ON a.division_id = b.division_id														'+CHAR(10);
	SET @mEXEC = @mEXEC + '   								and a.item_id= b.item_id																'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		 WHERE 1=1																										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.measure =''MKT_FCST''																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND b.scp_operation_group_id <> ''E''																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.yyyymmdd >= '''+@v_from_result+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.yyyymmdd <= '''+@v_to_result+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   AND a.yyyymmdd != '''' and a.yyyymmdd is not null															'+CHAR(10);
	*/
	SET @mEXEC = @mEXEC + '   	   ) t																												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   	   INNER JOIN (																										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   					SELECT division_id																					'+CHAR(10);
	IF (@p_division_id = '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   						   ,SCM_SITE_ID																				'+CHAR(10);
		SET @mEXEC = @mEXEC + '   						   ,project_code																			'+CHAR(10);
	END;
	ELSE IF (@p_division_id != '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   							,''-'' SCM_SITE_ID																		'+CHAR(10);
		SET @mEXEC = @mEXEC + '   							,''-'' project_code																		'+CHAR(10);
	END;
	SET @mEXEC = @mEXEC + '   						   ,model_id																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						   ,item_id																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						   ,operation_group																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						   ,operation_group_id																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   					  FROM (																							'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							SELECT DISTINCT																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									(CASE WHEN dbo.FN_GET_ITEM_OPERATION_GROUP(a.division_id, a.item_id) = ''E'' THEN C.ITEM_ID		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   										  ELSE b.model_id																'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									  END) AS model_id																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									,(CASE																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   										-- 전극 제외 20180517															'+CHAR(10);
	SET @mEXEC = @mEXEC + '   										--WHEN d.operation_group_id = ''E'' THEN ''Electrode''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '   										WHEN d.operation_group_id = ''A'' THEN ''Cell''									'+CHAR(10);
	SET @mEXEC = @mEXEC + '   										WHEN d.operation_group_id = ''P'' THEN ''Pack''									'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									  END ) AS operation_group_id														'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									,d.electrode_type																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									,b.child_item_id AS item_id															'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									,(SELECT rownumber																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   										FROM (																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												SELECT ROW_NUMBER() OVER (ORDER BY from_yyyymmdd) AS rownumber			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												  FROM scm_mst_site_item_priority s										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												 WHERE s.division_id   = b.division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												   AND s.item_id       = b.child_item_id								'+CHAR(10);
	IF (@p_division_id = '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   												   AND s.project_code  = a.project_code								'+CHAR(10);
		SET @mEXEC = @mEXEC + '   												   AND s.SALES_SITE_ID = a.SCM_SITE_ID /* 20180326 sales site 추가부분 */	'+CHAR(10);
	END;
	SET @mEXEC = @mEXEC + '   												   AND s.to_yyyymmdd  >= convert(varchar, getdate(),112)				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												   AND s.valid_yn = ''Y''												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												   AND s.priority = ''1''												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   											) a																			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									   WHERE rownumber =1) AS primary_plant												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   									,b.division_id																		'+CHAR(10);
	IF (@p_division_id = '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   									,a.SCM_SITE_ID																	'+CHAR(10);
		SET @mEXEC = @mEXEC + '   									,a.project_code																	'+CHAR(10);
	END;
	SET @mEXEC = @mEXEC + '   									,d.operation_group_id operation_group												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  FROM dm_pln_mkt_fcst a																	'+CHAR(10);
	-- 2021.03.30 대체 BOM 모델링
	--SET @mEXEC = @mEXEC + '   							  JOIN scm_mst_bom_sn b ON a.division_id = b.division_id								'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  JOIN SCM_MST_BOM_SN_V b ON a.division_id = b.division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												   and a.item_id     = b.model_id 										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  JOIN scm_mst_item_sn c ON b.company_id = c.company_id										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   													and b.division_id   = c.division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC + '   													and b.site_id       = c.site_id										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   													and b.child_item_id = c.item_id										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  JOIN scm_mst_final_item_v d  ON b.division_id = d.division_id  and b.child_item_id = d.item_id				'+CHAR(10);
	--2021/10/05 : W/S AS
	--SET @mEXEC = @mEXEC + '   							  LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN=''Y''	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  LEFT JOIN scm_mst_site s ON s.DIVISION_ID = a.DIVISION_ID												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   													  AND s.SCM_SITE_ID = a.SCM_SITE_ID 											'+CHAR(10);
	SET @mEXEC = @mEXEC + '   													  AND (s.VMI_YN=''Y'' OR ( SITE_TYPE = ''SALES'' AND OPERATION_GROUP = ''W''))	'+CHAR(10);	
	SET @mEXEC = @mEXEC + '   							 WHERE 1=1																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND c.item_type		<> ''r''															'+CHAR(10);
	SET @mEXEC = @mEXEC + '   								--  실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   								--Alternate Part 제외로직 추가															'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND b.alt_priority =''Y''																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND a.yyyymmdd >= '''+@v_from_yyyymmdd+'''												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND a.yyyymmdd <= '''+@v_to_yyyymmdd+'''													'+CHAR(10);
	--SET @mEXEC = @mEXEC + '   							  AND a.measure =''MKT_FCST''															'+CHAR(10);
	--2021/10/05 : W/S AS
	--SET @mEXEC = @mEXEC + '   							  AND a.MEASURE = IIF( ISNULL(s.vmi_yn, ''N'') = ''Y'', ''VMI_In_Req'',  ''MKT_FCST'')		'+CHAR(10);
	--2022/11/07
	--SET @mEXEC = @mEXEC + '   							  AND a.MEASURE = IIF(ISNULL(s.OPERATION_GROUP, '''') = ''W'', ''AS_In_Req'', IIF(s.vmi_yn = ''Y'', ''VMI_In_Req'',  ''MKT_FCST''))	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND a.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '''') = ''W'' THEN ''AS_In_Req'' WHEN S.vmi_yn = ''Y'' THEN ''VMI_In_Req'' WHEN ISNULL(a.attribute10, '''') = '''' THEN ''MKT_FCST'' END	' + CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND a.qty>0																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND a.division_id  = '''+@p_division_id+'''												'+CHAR(10);
	--IF (@p_division_id = '81')
	--BEGIN
		--SET @mEXEC = @mEXEC + '   				  AND (( '''+p_project_code+''' IS NULL OR  '''+p_project_code+''' ='''' ) OR a.project_code IN (SELECT token FROM dbo.String_Split('''+p_project_code+'''	,'','')) )	'+CHAR(10);
	--END;
	--SET @mEXEC = @mEXEC + '   					  AND (( '''+@p_model_id+'''      IS NULL OR  '''+@p_model_id+'''      ='''' ) OR b.model_id  LIKE ''%''+'''+ @p_model_id + '''+''%'' ) '+CHAR(10);
	--SET @mEXEC = @mEXEC + '   					  AND (( '''+@p_item_id+'''      IS NULL OR  '''+@p_item_id+'''      ='''' ) OR b.model_id  LIKE ''%''+'''+ @p_item_id + '''+''%'' )  '+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND d.OPERATION_GROUP_ID <> ''E''                                                                                               '+CHAR(10);
	SET @mEXEC = @mEXEC + '   								--팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정  '+CHAR(10);
	SET @mEXEC = @mEXEC + '   							  AND EXISTS (SELECT *																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   											FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)								'+CHAR(10);
	SET @mEXEC = @mEXEC + '   										   WHERE DIVISION_ID = '''+@p_division_id+'''									'+CHAR(10);
	SET @mEXEC = @mEXEC + '   											 AND PARENT_ITEM_ID= b.child_item_id										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   												--BOM을 제거모델 조회안되도록 수정										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   											 AND EFF_END_DATE >= GETDATE()												'+CHAR(10);
	SET @mEXEC = @mEXEC + '   											 AND KEY_DATE = ( SELECT MAX(KEY_DATE)										'+CHAR(10);
	SET @mEXEC = @mEXEC + '   																FROM [dbo].[SCM_MST_BOM_ENG_SN] WITH(NOLOCK)			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   															   WHERE PARENT_ITEM_ID= b.child_item_id					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   															     AND DIVISION_ID = '''+@p_division_id+''' ) )			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   						   ) m WHERE ISNULL(primary_plant,'''')=''''													'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				  ) u ON t.division_id  = u.division_id																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   					 AND t.SCM_SITE_ID  = u.SCM_SITE_ID																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   					 AND t.project_code = u.project_code																'+CHAR(10);
	SET @mEXEC = @mEXEC + '   					 AND t.item_id      = u.model_id																	'+CHAR(10);
	IF (@p_division_id = '81')
	BEGIN
		SET @mEXEC = @mEXEC + '   		 INNER JOIN scm_mst_site_item v ON t.division_id  = v.division_id											'+CHAR(10);
		SET @mEXEC = @mEXEC + '   									 and t.item_id      = v.item_id													'+CHAR(10);
		SET @mEXEC = @mEXEC + '   									 and t.scm_site_id  = v.scm_site_id												'+CHAR(10);
		SET @mEXEC = @mEXEC + '   									 and t.project_code = v.project_code											'+CHAR(10);
	END;
	SET @mEXEC = @mEXEC + '          INNER JOIN  (SELECT division_id																				'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   				   ,item_id																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   				   ,nick_name																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   				   ,item_type																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   		   				   ,ROW_NUMBER() OVER ( PARTITION BY division_id, item_id ORDER BY  CASE item_type WHEN ''P'' THEN 999 WHEN ''H'' THEN 888 WHEN ''R'' THEN 777  WHEN ''Q'' THEN 666 ELSE 0 END  DESC ) nums			'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				FROM SCM_MST_ITEM_SN 																					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				) i ON t.division_id  = i.division_id																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				   AND t.item_id      = i.item_id																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   				   AND i.nums =1																						'+CHAR(10);
	SET @mEXEC = @mEXEC + '    WHERE 1=1																											'+CHAR(10);
	SET @mEXEC = @mEXEC + '      AND i.item_type NOT IN (''Q'',''R'')																				'+CHAR(10);
	--SET @mEXEC = @mEXEC + '      AND t.measure =''MKT_FCST''																						'+CHAR(10);
	--2021/10/05 : W/S AS
	--SET @mEXEC = @mEXEC + '      AND t.measure in (''VMI_In_Req'',  ''MKT_FCST'')																	'+CHAR(10);
	SET @mEXEC = @mEXEC + '      AND t.measure in (''AS_In_Req'',''VMI_In_Req'',  ''MKT_FCST'')														'+CHAR(10);
	SET @mEXEC = @mEXEC + '      AND t.qty>0																										'+CHAR(10);
	SET @mEXEC = @mEXEC + '      AND t.division_id  = '''+@p_division_id+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC + '   	 AND (( '''+@p_model_id+'''      IS NULL OR  '''+@p_model_id+'''      ='''' ) OR u.model_id  LIKE ''%''+'''+ @p_model_id + '''+''%'' )	'+CHAR(10);
	SET @mEXEC = @mEXEC + '   	 AND (( '''+@p_item_id+'''      IS NULL OR  '''+@p_item_id+'''      ='''' ) OR u.item_id  LIKE ''%''+'''+ @p_item_id + '''+''%'' )		'+CHAR(10);
	--SET @mEXEC = @mEXEC + '      AND ( ( '''+@p_item_id+'''      IS NULL OR  '''+@p_item_id+'''      ='''' ) OR t.item_id    LIKE ''%''+'''+ @p_item_id + '''+''%''  )'+CHAR(10);
	
	--IF (@p_division_id = '81')
	--BEGIN
		--SET @mEXEC = @mEXEC + '      AND ( ( '''+p_scm_site_id+'''  IS NULL OR  '''+p_scm_site_id+'''  ='''' ) OR t.scm_site_id   IN (SELECT token FROM dbo.String_Split('''+p_scm_site_id+'''	,'','')) ) /* 20180326 sale site 추가부분 */ '+CHAR(10);
		--SET @mEXEC = @mEXEC + '      AND ( ( '''+p_project_code+''' IS NULL OR  '''+p_project_code+''' ='''' ) OR t.project_code  IN (SELECT token FROM dbo.String_Split('''+p_project_code+'''	,'','')) )			'+CHAR(10);
	--END;
	SET @mEXEC = @mEXEC + '  ) A ORDER BY A.DIVISION_ID, A.scm_site_name, A.project_code, A.model_id, A.ITEM_ID										'+CHAR(10);
	;
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

	-- 1. 입력목록 조회
	EXEC (@mEXEC);
	SELECT * FROM #TblDynamicPivot_SCM0002_01;

	/*
	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     SELECT * FROM #TblDynamicPivot_SCM0002_01 '+CHAR(10);
	;

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

	EXEC (@mEXEC);
	*/

	--2. 전체조회
	SELECT 
		CONVERT(NVARCHAR(MAX), t.priority_seq) AS priority_seq
	   ,t.division_id
 ,ISNULL(NULLIF(t.project_code,''),'-') project_code
	   ,t.item_id
	   ,ISNULL(NULLIF(t.SALES_SITE_ID,''),'-') AS scm_site_id
	   ,T.PLANT_SITE_ID 
	   ,t.priority
	   ,t.valid_yn
	   ,t.valid_yn as org_valid_yn
	   ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.from_yyyymmdd),121) AS from_yyyymmdd 
	   ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.to_yyyymmdd)  ,121) AS to_yyyymmdd 
	   ,t.created_by
	   ,t.creation_date
	   ,t.last_updated_by
	   ,t.last_update_date
	   ,s.OPERATION_GROUP
	   ,t.from_yyyymmdd AS org_from_yyyymmdd
	   ,t.to_yyyymmdd AS org_to_yyyymmdd
	   ,t.from_yyyymmdd + t.to_yyyymmdd AS merge_date
	   ,'' as is_pass_n1
	   ,'' as is_pass_n2
	   ,'' as is_pass_n3
	   ,'' as is_pass_n4
	   ,'' as is_pass_n5
	   ,'' as is_pass_n6
	   ,'' as is_pass_n7
	   , '-' ACTION_FLAG_DIV
	   , 0 ROW_COLOR_INDEX
	FROM scm_mst_site_item_priority t (NOLOCK)
	JOIN scm_mst_site s (NOLOCK) ON t.division_id = s.division_id 
								and s.OPERATION_GROUP!='E' 
								and t.PLANT_SITE_ID = s.scm_site_id
   WHERE s.site_type     = 'PLANT'
	 AND t.division_id   = @p_division_id   -- '40'
	 and t.valid_yn = 'Y'
	ORDER BY t.division_id, t.item_id, t.from_yyyymmdd  ,t.priority,t.valid_yn desc,t.to_yyyymmdd
	;

	--3. 소형 VALIDATION용 ERP ITEM 조회
	SELECT A.COMPANY_ID
		   ,A.DIVISION_ID
		   ,A.ITEM_ID
		   ,A.SITE_ID  
	FROM SCM_MST_ITEM_SN A WITH(NOLOCK)
	JOIN #TblDynamicPivot_SCM0002_01 B 
	  ON A.ITEM_ID LIKE SUBSTRING(B.ITEM_ID,1,len(B.ITEM_ID)-1)+'%'
	WHERE 1=1 
	AND A.DIVISION_ID='40'
	AND A.ACTIVE_FLAG='Y'
	;


	--임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCM0002_01') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCM0002_01;

END


