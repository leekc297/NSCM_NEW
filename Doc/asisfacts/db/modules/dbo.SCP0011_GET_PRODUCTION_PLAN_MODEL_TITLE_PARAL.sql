

/*
 * Program ID   : [SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL]
 * Description  : Production Plan MODEL QTY 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/11   PJS			   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/27   PJS			   key_idx수정, BOH 제거
 * 2018/07/11   byunghunjung   EE 사업부 실적 추가
 * 2018/07/18   YHW			   전극용 조회항목 추가
 * 2018/08/31	YHW			   NICK NAME 조회항목 추가
 * 2018/09/27   ygkim		   생산 실적 조건 추가 (LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회, 외주PACKER의 업체코드)
 * 2021/06/25   kmj			   UI 속도 개선 반영
 * 2021.07.22   LWY			   PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
                                 - scp_anl_production_plan / hist_scp_anl_production_plan 분리작업
 * 2021.10.07   KMJ			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선으로 Bucket별 조회로 수정
 * 2021.11.24   khj79		   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
 * 2022.05.13   LSC            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2022.08.31   LWY            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Isuzu 추가
 * 2023.01.02   LWY            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회기준 변경(main / hist) - 당주,전주(main) / 당주,전주 이전(hist)
 * 2023/04/10   LWY			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023.07.26   vadabi3		   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Model, Material 개선
----------------------------------------------------------------------------------------------------------------------------------------
    EXEC SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL 
	  @p_division_id='81'
	, @p_operation_group='P'
	, @p_scm_site_id=''
	, @p_model_id=''
	, @p_item_id=''
	, @p_from_yyyymmdd='20180201'
	, @p_to_yyyymmdd='20180331'
	, @p_plan_start_yyyymmdd='20180326'
	, @p_plan_type='PR'
	, @p_seq='1'
	, @p_program_id='SCP0011'
	, @p_sheet_name='MODEL'
	, @p_user_id='20140001'
	, @p_electrode_type=''
	, @p_nick_name=''
	, @p_bucket=''
	, @p_chk_all=''
	, @debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL]
	 @p_division_id			NVARCHAR(MAX) 
	,@p_operation_group		NVARCHAR(MAX) 
	,@p_scm_site_id			NVARCHAR(MAX) 
	,@p_model_id		    NVARCHAR(300) 
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)	
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(50)
	,@p_program_id			NVARCHAR(300) ='SCP0011'
	,@p_sheet_name			NVARCHAR(150) ='MODEL'
	,@p_user_id				NVARCHAR(150) 
	,@p_electrode_type		NVARCHAR(30) = ''
	,@p_nick_name			NVARCHAR(50) = ''
	,@p_bucket				NVARCHAR(10)
	,@p_chk_all				NVARCHAR(1) -- 2021.11.24 :  체크 시 bucket='daily' 조회	
	,@debug_mode			NVARCHAR(20)  ='T'

AS  
  
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_cnt_usr_measure	INT =0;
	DECLARE @v_min_yyyymmdd      AS NVARCHAR(8);   -- 2021/07/22

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


	DECLARE @arr_scm_site_id varchar(max) , @arr_item_id varchar(max) , @arr_electrode_type varchar(max)
	SELECT @arr_scm_site_id = ISNULL(@arr_scm_site_id + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_scm_site_id,',')
	SELECT @arr_item_id     = ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_electrode_type     = ISNULL(@arr_electrode_type + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_electrode_type,',')
	
	DECLARE @arr_model_id varchar(max);
	SELECT @arr_model_id	= ISNULL(@arr_model_id	+ ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_model_id,',')
	
	DECLARE @mEXEC NVARCHAR(MAX);

	 -- 2021.11.24 : 체크 시 bucket='daily' 조회
	IF(@p_chk_all = 'Y')	SET @p_bucket = 'DAILY' ;

	/********************************************************************************
	* 임시테이블만들기 - nick name 조회 시
	********************************************************************************/  
 	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_NICKITEM') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0011_NICKITEM
  
	  IF( ISNULL(@p_nick_name ,'') != '') 
	  BEGIN
			SELECT distinct ITEM_ID 
			INTO #TblDynamicPivot_SCP0011_NICKITEM
			FROM SCM_MST_ITEM_SN 
			WHERE 1=1
			AND NICK_NAME IS NOT NULL
			AND NICK_NAME LIKE '%'+@p_nick_name+'%'
	  END;


	/********************************************************************************
	* 임시테이블만들기 - Header 부분
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_02') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0011_02 

	CREATE TABLE #TblDynamicPivot_SCP0011_02 (
	 division_id	NVARCHAR(128)	,operation_group	NVARCHAR(128)
	,scm_site_id	NVARCHAR(128)	,item_id			NVARCHAR(128)
	,operation_id	NVARCHAR(128)	,line_id			NVARCHAR(128)
	,measure		NVARCHAR(128)	
	,origin_division_id	NVARCHAR(30)	,electrode_type	NVARCHAR(30)
	)
	/*	CREATE TABLE #TblDynamicPivot_SCP0011_02 (
	 division_id	NVARCHAR(128)	,operation_group	NVARCHAR(128)
	,scm_site_id	NVARCHAR(128)	,item_id			NVARCHAR(128)
	,operation_id	NVARCHAR(128)	,line_id			NVARCHAR(128)
	,measure		NVARCHAR(128)	,yyyymmdd			NVARCHAR(8)
	,origin_division_id	NVARCHAR(30)	,electrode_type	NVARCHAR(30)
	)*/

	
	-- 2022.08.31 start
	IF OBJECT_ID('tempdb..#ISUZU') IS NOT NULL
	BEGIN
		DROP TABLE #ISUZU;
	END  
	
	-- ISUZU item
	SELECT A.ITEM_ID
	INTO #ISUZU
	FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
	INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
	WHERE A.IS_YN = 'Y'
	;
	-- 2022.08.31 end


	-- 2023.01.02
	--SELECT @v_min_yyyymmdd = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](@p_program_id, @p_division_id, @p_plan_type, @p_operation_group, @p_seq);
	SELECT @v_min_yyyymmdd = replace(convert(char(10),dateadd(d,datepart(dw,GETDATE()) * -1 - 5,GETDATE()),120),'-',''); -- previous monday


	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     INSERT #TblDynamicPivot_SCP0011_02	 '+CHAR(10);
											-- 계획 구간
	SET @mEXEC = @mEXEC+'     				SELECT p.division_id, p.operation_group,p.scm_site_id, p.item_id,p.operation_id, p.line_id, p.measure	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     					   , p.ORIGIN_DIVISION_ID, p.ELECTRODE_TYPE																		'+CHAR(10);
	
	IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
	BEGIN
		SET @mEXEC = @mEXEC+'     				FROM scp_anl_production_plan p with(nolock)																		'+CHAR(10);
	END
	ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
	BEGIN
		SET @mEXEC = @mEXEC+'     FROM hist_scp_anl_production_plan p with(nolock)																				'+CHAR(10);
	END

	
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
	IF NOT(@p_electrode_type IS NULL  OR  @p_electrode_type  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( electrode_type      IN ('+@arr_electrode_type+') )	'+CHAR(10); END;
	--SET @mEXEC = @mEXEC+'     				GROUP BY division_id, operation_group,scm_site_id, item_id, line_id, operation_id, measure  				'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     						 , origin_division_id, electrode_type																		'+CHAR(10);

	SET @mEXEC = @mEXEC+'     				UNION ALL																											'+CHAR(10);
	                                        -- anl 테이블에는 과거구간 YYYYMMDD가 없으므로 실적 테이블에서 YYYYMMDD를 조회하여 추가해준다.
	--SET @mEXEC = @mEXEC+'     				SELECT    r.division_id																								'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     				SELECT   case when '''+@p_division_id+''' = ''EE'' then ''EE'' when '''+@p_division_id+''' = ''EE_UC'' then ''EE_UC'' else r.division_id end as division_id		'+CHAR(10);	
	--SET @mEXEC = @mEXEC+'     				SELECT   case when '''+@p_division_id+''' = ''EE'' then ''EE'' when '''+@p_division_id+''' = ''EE_UC'' then ''EE_UC'' when '''+@p_division_id+''' = ''EE_HM'' then ''EE_HM'' else r.division_id end as division_id		'+CHAR(10); --div_commonization
	SET @mEXEC = @mEXEC+'     SELECT '''+@p_division_id+'''  as division_id	'+CHAR(10); --div_commonization
	SET @mEXEC = @mEXEC+'     						, r.scp_operation_group as operation_group																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     						, r.scm_site_id	,r.item_id	        ,r.operation_id	    ,r.line_id											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     						, ''PROD_PLAN_ENGINE'' AS measure							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     						, r.division_id as origin_division_id, r.ELECTRODE_TYPE																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				FROM SCM_DNM_product_result_v r																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				WHERE 1=1																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND r.plan_date >= convert(datetime, '''+@v_from_result+''')														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				AND r.plan_date < convert(datetime, '''+@v_to_result+''' )														    '+CHAR(10);	-- equal 표시 주의할것	
	--SET @mEXEC = @mEXEC+'     				AND division_id         = '''+@p_division_id+'''																	'+CHAR(10);
	IF (@p_division_id = 'EE')			BEGIN SET @mEXEC = @mEXEC+' AND division_id  IN (''40'',''81'',''82'')												    '+CHAR(10); END;
	    ELSE IF (@p_division_id = 'EE_UC')	BEGIN SET @mEXEC = @mEXEC+' AND division_id  = ''81_UC''													    '+CHAR(10); END;
		ELSE IF (@p_division_id = 'EE_HM')	BEGIN SET @mEXEC = @mEXEC+' AND division_id  = ''81_HM''													    '+CHAR(10); END;
		ELSE IF (@p_division_id = 'EE_ST')	BEGIN SET @mEXEC = @mEXEC+' AND division_id  = ''81_ST''													    '+CHAR(10); END;
	ELSE 								BEGIN SET @mEXEC = @mEXEC+' AND division_id  = '''+@p_division_id+'''														    '+CHAR(10); END;
	
	SET @mEXEC = @mEXEC+'					AND r.scp_operation_group = '''+@p_operation_group+'''																'+CHAR(10);	
	SET @mEXEC = @mEXEC+'					AND r.scm_site_id is not null		'+CHAR(10);	
	SET @mEXEC = @mEXEC+'					AND (left(r.operation_id,5) IN (--LOOKUP_TYPE ''SCP_PLAN_OPERATION'' 에 정의된 공정만 조회                          '+CHAR(10);
	SET @mEXEC = @mEXEC+'									                            SELECT segment1 AS operation_id                                         '+CHAR(10);
	SET @mEXEC = @mEXEC+'									                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)                          '+CHAR(10);
	SET @mEXEC = @mEXEC+'									                            WHERE lookup_type = ''SCP_PLAN_OPERATION''                              '+CHAR(10);
	SET @mEXEC = @mEXEC+'									                              AND SEGMENT1 <> ''F6000'' )                                           '+CHAR(10);
	
	-- 2022.08.31 start
	SET @mEXEC = @mEXEC+'		OR ( LEFT(r.operation_id,5) = ''P5000''													'+CHAR(10);
	SET @mEXEC = @mEXEC+'		AND EXISTS (																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'					SELECT 1 FROM   #ISUZU A WHERE  A.ITEM_ID = r.ITEM_ID						'+CHAR(10);
	SET @mEXEC = @mEXEC+'					)																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'			)																					'+CHAR(10);
	-- 2022.08.31 end
	
	SET @mEXEC = @mEXEC+'					   OR r.operation_id IN (--외주PACKER의 업체코드																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'									          SELECT plant_id  AS operation_id															'+CHAR(10);
	SET @mEXEC = @mEXEC+'									          FROM SCM_MST_SITE WITH(NOLOCK)															'+CHAR(10);
	SET @mEXEC = @mEXEC+'									          WHERE 1=1																					'+CHAR(10);
	
	IF (@p_division_id = 'EE')			BEGIN SET @mEXEC = @mEXEC+'             AND division_id  IN (''40'',''81'',''82'')												    '+CHAR(10); END;
	ELSE IF (@p_division_id = 'EE_UC')	BEGIN SET @mEXEC = @mEXEC+'             AND division_id  = ''81_UC''													    '+CHAR(10); END;
	ELSE 								BEGIN SET @mEXEC = @mEXEC+'             AND division_id  = '''+@p_division_id+'''												'+CHAR(10); END;

	
	SET @mEXEC = @mEXEC+'									            AND site_type   = ''PLANT''																'+CHAR(10);
	SET @mEXEC = @mEXEC+'									            AND osp_yn      = ''Y''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'									            AND valid_yn    = ''Y''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'					))																													'+CHAR(10);
	IF NOT(@p_scm_site_id IS NULL     OR  @p_scm_site_id     ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( scm_site_id  IN ('+@arr_scm_site_id+') )				'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL         OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL  OR  @p_electrode_type  ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( r.electrode_type      IN ('+@arr_electrode_type+') )	'+CHAR(10); END;
	--SET @mEXEC = @mEXEC+'     				GROUP BY division_id, scp_operation_group, scm_site_id, item_id, line_id, operation_id 										'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     						, electrode_type																		'+CHAR(10);
	
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

	/********************************************************************************
	* 임시테이블만들기 - Main 조회 테이블
	********************************************************************************/	
	--IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblDynamicPivot_SCP0011_01%')
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_01') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCP0011_01 

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
    SELECT ( m.division_id + m.operation_group + m.scm_site_id + m.item_id+m.measure ) AS key_idx
			,m.division_id
			,m.operation_group
			,m.scm_site_id
			,m.item_id
			,@p_plan_type AS plan_type
			,@p_seq AS plan_seq	
			,m.measure
			,m.measure_name
			,m.user_sort_order_no
			,@p_from_yyyymmdd AS from_yyyymmdd
			,@p_to_yyyymmdd AS to_yyyymmdd
			,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			--,'D_'+m.yyyymmdd AS yyyymmdd
			--,o.basis_yyyymm AS yyyymm
			--,RIGHT(o.basis_yyyymm,4)+o.iso_week AS iso_week
			--,0 qty
			,m.origin_division_id
			,m.electrode_type
	  -- Main : #TblDynamicPivot_SCP0011_01
	  INTO  #TblDynamicPivot_SCP0011_01
	  FROM(
			SELECT
					 c.division_id			 
					,c.operation_group
					,c.scm_site_id
					,c.item_id
					,c.LINE_ID
					,c.operation_id
					,a.column_name	AS measure
					,a.column_label_name	AS measure_name
					,isnull(b.sort_order_no,a.sort_order_no ) AS user_sort_order_no
					--,c.yyyymmdd
					,c.origin_division_id
					,c.electrode_type
			   FROM scm_mst_sheet_measure a LEFT OUTER JOIN
					scm_mst_titleset_user b ON b.program_id  = a.program_id
										   AND b.sheet_name  = a.sheet_name
										   AND b.column_name = a.column_name
										   AND b.user_id     = @p_user_id
				  ,(   -- Header : #TblDynamicPivot_SCP0011_02
				       SELECT c.division_id, c.operation_group, c.scm_site_id,  c.item_id, c.operation_id, c.line_id, c.measure,  c.origin_division_id, c.electrode_type
					   FROM #TblDynamicPivot_SCP0011_02 c
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
					 ,c.item_id					     ,c.line_id					         ,c.operation_id
					 ,a.column_name					 ,a.column_label_name				 
					 ,c.origin_division_id			 ,c.electrode_type
					 ,ISNULL(b.sort_order_no,a.sort_order_no )
			) m
			--(SELECT basis_yyyymm, ISO_WEEK FROM scm_sys_calendar_m WHERE basis_yyyymmdd = @p_plan_start_yyyymmdd) o
			
			 ;

		/* 임시테이블 #TblDynamicPivot_SCP0011_01 인덱스 생성*/
		--create clustered index tmpidx_TblDynamicPivot_SCP0011_01 on #TblDynamicPivot_SCP0011_01(key_idx, division_id, operation_group,scm_site_id, item_id, measure,measure_name,user_sort_order_no,plan_start_yyyymmdd,plan_type,plan_seq,from_yyyymmdd,to_yyyymmdd,yyyymm,iso_week,yyyymmdd)

		/********************************************************************************
		* PIVOIT처리
		********************************************************************************/		
		BEGIN
			DECLARE @mQry_sum NVARCHAR(MAX);
			DECLARE @mDAY_QTY NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';

		    SELECT  @mQry_sum = @mQry_sum+', ''0'' '+yyyymmdd+''+CHAR(10)
			FROM (
					SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
						, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a
					WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					AND (@p_bucket= 'DAILY' OR @p_bucket = 'WEEKLY')
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
					AND @p_bucket = 'DAILY'
					GROUP BY a.basis_yyyymmdd

				) AS A
			ORDER BY sort_order_no  ;
			
		

			SET @mEXEC = '';
			SET @mEXEC = @mEXEC+' SELECT * FROM ( ';
			SET @mEXEC = @mEXEC+'     SELECT  '+CHAR(10);
			SET @mEXEC = @mEXEC+'      		 key_idx '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,division_id '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,dbo.fn_get_division_name(division_id) AS division_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,division_id AS division_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,operation_group '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_lookup_code_desc(''OPERATION_GROUP'',operation_group) operation_group_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,scm_site_id '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,dbo.fn_get_scm_site_description(division_id, scm_site_id) AS scm_site_description  '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,DBO.FN_GET_ITEM_PROD_OP(DIVISION_ID, operation_group, ITEM_ID) AS MODEL_ID							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,item_id '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(NULLIF(dbo.fn_get_item_nickname (division_id, item_id ),''''),''-'') AS nick_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,[dbo].[FN_GET_SCP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd,PLAN_TYPE,plan_seq	,scm_site_id,item_id,from_yyyymmdd) as boh '
			SET @mEXEC = @mEXEC+' 			,measure '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,user_sort_order_no '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,plan_start_yyyymmdd,PLAN_TYPE, plan_seq,from_yyyymmdd,to_yyyymmdd '+CHAR(10)
			SET @mEXEC = @mEXEC+' 			,origin_division_id ,electrode_type '+CHAR(10)
			SET @mEXEC = @mEXEC+' 			'+@mQry_sum	+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			into #testpjs001'+CHAR(10)
			SET @mEXEC = @mEXEC+'      FROM #TblDynamicPivot_SCP0011_01 '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 	   WHERE origin_division_id NOT IN (''EE'',''EE_UC'') '+CHAR(10) ;			
			SET @mEXEC = @mEXEC+' 	   WHERE origin_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''EE'')) '+CHAR(10) ; --div_commonization
			
			IF( ISNULL(@p_nick_name ,'') != '') 
			BEGIN
			SET @mEXEC = @mEXEC+'		AND item_id in (select item_id from #TblDynamicPivot_SCP0011_NICKITEM)												'+CHAR(10);
			END;
			SET @mEXEC = @mEXEC+'	   GROUP BY key_idx, division_id, operation_group,scm_site_id, item_id, measure,measure_name,user_sort_order_no,plan_start_yyyymmdd,plan_type,plan_seq,from_yyyymmdd,to_yyyymmdd,origin_division_id ,electrode_type'+CHAR(10);
			
			SET @mEXEC = @mEXEC+' ) DATA ';

			IF (NOT(@p_model_id IS NULL OR @p_model_id =''))
			BEGIN
			SET @mEXEC = @mEXEC + ' WHERE MODEL_ID IN ('+@arr_model_id+') '+CHAR(10);
			END;

			
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
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_01') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0011_01;
	    IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_02') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0011_02;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_03') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0011_03;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0011_NICKITEM') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0011_NICKITEM;
END


;

