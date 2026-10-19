
/*
 * Program ID   : SSP0009_GET_SHIPMENT_PLAN_FG
 * Description  : Shipment Plan(SSP) 조회
 * Program History
 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/19   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/19   hwyoon			itemType 조회 수정
 * 2018/0620	KYH				데이터 조회쿼리 수정 (성능관련)
 * 2018/07/05   ygkim			@p_electrode_type 파라미터 추가, ORIGIN_DIVISION_ID, ELECTRODE_TYPE 컬럼 추가
 * 2018/08/10   ygkim			#TblDynamicPivot_SSP0009_02 measure_order_no 데이터 타입 INT로 변경
 * 2018/08/21	YHW				조인조건 수정(데이터 출력 오류 수정)
 * 2018/08/22	YHW				TEAM, OWNER 조회 수정
 * 2018/09/14   ygkim			속도 개선(함수 제거)

    EXEC SSP0009_GET_SHIPMENT_PLAN_FG @p_from_yyyymmdd='20180430', @p_to_yyyymmdd='20180506', @p_division_id='81', @p_biz_type='A', @p_project_code='', @p_item_id='', @p_plan_start_yyyymmdd='20180430', @p_plan_type='PR', @p_seq='1', @p_program_id='SCP0009', @p_sheet_name='Shipment Plan FG', @p_user_id='kaiser99' ,@debug_mode ='T'
 */
CREATE PROCEDURE [dbo].[SSP0009_GET_SHIPMENT_PLAN_FG]
	@p_from_yyyymmdd		NVARCHAR(MAX),
	@p_to_yyyymmdd			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_biz_type				NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_plan_start_yyyymmdd  NVARCHAR(8),
	@p_plan_type			NVARCHAR(50),
	@p_seq					NVARCHAR(50),
	@p_electrode_type		NVARCHAR(60) = '',
	@p_program_id			NVARCHAR(MAX) = 'SSP0009' ,
	@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan FG' ,
	@p_user_id				NVARCHAR(MAX),
	@debug_mode             NVARCHAR(MAX) ='T'
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	declare @v_data_cnt nvarchar(8);
	set @v_data_cnt =0;
	
	DECLARE @v_cnt_usr_measure	nvarchar =0;

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

    DECLARE @arr_project_code varchar(max) , @arr_item_id varchar(max), @arr_electrode_type varchar(max)
	SELECT @arr_project_code = ISNULL(@arr_project_code + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_project_code,',')
	SELECT @arr_item_id     = ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_electrode_type     = ISNULL(@arr_electrode_type + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_electrode_type,',')
	DECLARE @mEXEC NVARCHAR(MAX);

   /********************************************************************************
	* 임시테이블만들기 - Header 부분
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0009_02') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0009_02

	CREATE TABLE #TblDynamicPivot_SSP0009_02 (
	  yyyymmdd		 NVARCHAR(8)
	 ,division_id	 NVARCHAR(128)	,biz_type	      NVARCHAR(128)	,project_code		NVARCHAR(128)
	 ,item_id		 NVARCHAR(128)	,to_site	      NVARCHAR(128)	,from_site			NVARCHAR(128)
	 ,incoterms		 NVARCHAR(128)	,bod_id			  NVARCHAR(128)	,measure			NVARCHAR(128)
	 ,measure_label	 NVARCHAR(128)	,measure_order_no INT--NVARCHAR(128)	
	 ,transport_mode NVARCHAR(128)	,lt_day		      NVARCHAR(128)	
	 ,origin_from_division_id	NVARCHAR(128)	,origin_to_division_id	NVARCHAR(128) ,electrode_type	NVARCHAR(128)
	)

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     INSERT #TblDynamicPivot_SSP0009_02																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   SELECT   distinct																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				  a.yyyymmdd																									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, a.division_id		, a.biz_type		, a.project_code														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, a.item_id			, a.to_site			, a.from_site 															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   			    , a.incoterms		, a.bod_id 			, a.measure																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, b.column_label_name as measure_label 	, isnull(d.sort_order_no, b.sort_order_no ) AS measure_order_no		 	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, c.transport_mode	, c.lt_total AS lt_day																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.origin_from_division_id,''''),''-'') origin_from_division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.origin_to_division_id,''''),''-'') origin_to_division_id										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.electrode_type,''''),''-'') electrode_type													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   FROM SSP_ANL_SHIPMENT_PLAN_FG a																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   JOIN SCM_MST_SHEET_MEASURE b on a.MEASURE = b.COLUMN_NAME																	'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   LEFT JOIN scp_mst_bod_n_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'     	   LEFT JOIN scp_mst_bod_n_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'     	   LEFT JOIN scp_mst_bod_n_v c ON a.origin_from_division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     											  AND d.column_name = b.column_name AND d.user_id =  '''+@p_user_id+''' 				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   WHERE 1=1																													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.program_id       =   '''+@p_program_id+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.sheet_name       =   '''+@p_sheet_name+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.valid_yn		   =   ''Y''																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND ('''+@v_cnt_usr_measure+''' = 0 OR EXISTS (SELECT 1																		'+CHAR(10);			
	SET @mEXEC = @mEXEC+'     	   										FROM scm_mst_titleset_user  															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										WHERE program_id  = '''+@p_program_id+''' 												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND sheet_name  = '''+@p_sheet_name+''' 												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND user_id     = '''+@p_user_id+''' 													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND column_name = b.column_name) 														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     				)																													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 >= '''+@p_from_yyyymmdd+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 <= '''+@p_to_yyyymmdd+'''																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.division_id         = '''+@p_division_id+'''																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.biz_type			  = '''+@p_biz_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_type           = '''+@p_plan_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.seq                 = '''+@p_seq+'''																					'+CHAR(10);
	IF NOT(@p_project_code IS NULL OR  @p_project_code    ='') BEGIN SET @mEXEC = @mEXEC+' AND ( a.project_code  IN ('+@arr_project_code+') )					'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL      OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+' AND ( a.item_id       IN ('+@arr_item_id+') )						'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( a.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     	   UNION ALL																													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   SELECT   distinct																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  r.exfactory_date as yyyymmdd																							'+CHAR(10);

	SET @mEXEC = @mEXEC+'     			, case when '''+@p_division_id+''' = ''EE'' then ''EE'' else r.division_id end as division_id				'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   		, r.division_id		, a.biz_type		, r.project_code																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, a.biz_type		, r.project_code																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, r.item_id			, r.to_scm_site_id as to_site			, r.from_scm_site_id as from_site 							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, a.incoterms		, a.bod_id 			, a.measure																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, b.column_label_name as measure_label 	, isnull(d.sort_order_no, b.sort_order_no ) AS measure_order_no					'+CHAR(10); 
	SET @mEXEC = @mEXEC+'     	   		, c.transport_mode	, c.lt_total AS lt_day																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	    , ISNULL(NULLIF(a.origin_from_division_id,''''),''-'') origin_from_division_id											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, ISNULL(NULLIF(a.origin_to_division_id,''''),''-'') origin_to_division_id												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, ISNULL(NULLIF(a.electrode_type,''''),''-'') electrode_type															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   FROM SSP_ANL_SHIPMENT_PLAN_FG a																								'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   JOIN SCM_DNM_EXFACTORY_RESULT r ON a.division_id =  r.division_id  and a.project_code = r.project_code						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   JOIN SCM_DNM_EXFACTORY_RESULT r ON a.project_code = r.project_code															'+CHAR(10);
	IF (@p_division_id != 'EE')	BEGIN SET @mEXEC = @mEXEC+' AND  a.division_id =  r.division_id																	'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     	   								and a.item_id = r.item_id and a.from_site = r.from_scm_site_id and a.to_site = r.to_scm_site_id	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   			and a.incoterms = r.incoterms									 			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   JOIN SCM_MST_SHEET_MEASURE b ON a.MEASURE = b.COLUMN_NAME																	'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   LEFT JOIN scp_mst_bod_n_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'     	LEFT JOIN scp_mst_bod_n_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'     	LEFT JOIN scp_mst_bod_n_v c ON a.origin_from_division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			  								 AND d.column_name = b.column_name AND d.user_id = '''+@p_user_id+''' 					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   WHERE 1=1																													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.program_id       =   '''+@p_program_id+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.sheet_name       =   '''+@p_sheet_name+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.valid_yn		   =   ''Y''																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND ('''+@v_cnt_usr_measure+''' = 0 OR EXISTS (SELECT 1																		'+CHAR(10);									
	SET @mEXEC = @mEXEC+'     	   										FROM scm_mst_titleset_user  															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										WHERE program_id  = '''+@p_program_id+''' 												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND sheet_name  = '''+@p_sheet_name+''' 												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND user_id     = '''+@p_user_id+''' 													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND column_name = b.column_name) 														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				)																												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 >= '''+@p_from_yyyymmdd+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 <= '''+@p_to_yyyymmdd+'''																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	 >= convert(datetime, '''+@v_from_result+''')															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	 < convert(datetime, '''+@v_to_result+''' )																'+CHAR(10); -- equal 표시 주의할것	
	--SET @mEXEC = @mEXEC+'     	   AND a.division_id         = '''+@p_division_id+'''																			'+CHAR(10);

	IF @p_division_id != 'EE'  BEGIN	SET @mEXEC = @mEXEC+'  AND a.division_id         = '''+@p_division_id+'''												'+CHAR(10); END;

	SET @mEXEC = @mEXEC+'     	   AND a.biz_type			  = '''+@p_biz_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_type           = '''+@p_plan_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.seq                 = '''+@p_seq+'''																					'+CHAR(10); 
	IF NOT(@p_project_code IS NULL OR  @p_project_code    ='') BEGIN SET @mEXEC = @mEXEC+' AND ( r.project_code  IN ('+@arr_project_code+') )					'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL      OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+' AND ( r.item_id       IN ('+@arr_item_id+') )						'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( a.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;					
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
	* 임시테이블만들기 - Qty 부분
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0009_03') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0009_03

	CREATE TABLE #TblDynamicPivot_SSP0009_03 (
	  division_id	NVARCHAR(128)	,project_code		NVARCHAR(128)	,item_id	NVARCHAR(128)	
	 ,from_site		NVARCHAR(128)   ,to_site			NVARCHAR(128)	,measure	NVARCHAR(128)
	 ,yyyymmdd		NVARCHAR(8)     ,qty				NUMERIC(20,10)
	 ,incoterms		NVARCHAR(128)	,transport_mode		NVARCHAR(128)	
	 ,origin_from_division_id	NVARCHAR(128)	,origin_to_division_id	NVARCHAR(128) ,electrode_type	NVARCHAR(128)
	)
	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     INSERT #TblDynamicPivot_SSP0009_03																						'+CHAR(10);
								    -- 계획
	SET @mEXEC = @mEXEC+'    		SELECT d.division_id  ,d.project_code  ,d.ITEM_ID																	'+CHAR(10);		
	SET @mEXEC = @mEXEC+'    			  ,d.from_site	  ,d.to_site	   ,d.measure																	'+CHAR(10);				
	SET @mEXEC = @mEXEC+'    			  ,d.yyyymmdd	  ,d.qty																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'    			  ,d.incoterms	  ,c.transport_mode																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(d.origin_from_division_id,''''),''-'') origin_from_division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(d.origin_to_division_id,''''),''-'') origin_to_division_id										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(d.electrode_type,''''),''-'') electrode_type													'+CHAR(10);
	SET @mEXEC = @mEXEC+'    		FROM SSP_ANL_SHIPMENT_PLAN_FG d																						'+CHAR(10);
	--SET @mEXEC = @mEXEC+'    		LEFT JOIN scp_mst_bod_n_v c ON d.division_id = c.division_id AND  d.bod_id = c.bod_id AND d.from_site = c.from_site   '+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'  		LEFT JOIN scp_mst_bod_n_v c ON d.division_id = c.division_id AND  d.bod_id = c.bod_id AND d.from_site = c.from_site   '+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'  		LEFT JOIN scp_mst_bod_n_v c ON d.origin_from_division_id = c.division_id AND  d.bod_id = c.bod_id AND d.from_site = c.from_site   '+CHAR(10);

	SET @mEXEC = @mEXEC+'    		WHERE 1=1																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.yyyymmdd			 >= '''+@p_from_yyyymmdd+'''																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.yyyymmdd			 <= '''+@p_to_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.division_id         = '''+@p_division_id+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.biz_type			  = '''+@p_biz_type+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.plan_type           = '''+@p_plan_type+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.seq                 = '''+@p_seq+'''																			'+CHAR(10);
	IF NOT(@p_project_code IS NULL  OR  @p_project_code  ='') BEGIN SET @mEXEC = @mEXEC+' AND ( d.project_code  IN ('+@arr_project_code+') )			'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL       OR  @p_item_id       ='') BEGIN SET @mEXEC = @mEXEC+' AND ( d.item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( d.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;					
	SET @mEXEC = @mEXEC+'     	   	UNION ALL																											'+CHAR(10);
								    -- 출하실적	
	SET @mEXEC = @mEXEC+'     		SELECT 																												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			  case when '''+@p_division_id+''' = ''EE'' then ''EE'' else r.division_id end as division_id				'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   		   r.division_id  ,r.project_code  ,r.item_id																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,r.project_code  ,r.item_id																	'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   		  ,r.from_scm_site_id as from_site	  ,r.to_scm_site_id as to_site		  ,''SHIP_PLAN'' as measure 			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,r.exfactory_date as yyyymmdd	  ,SUM(r.exfactory_qty) as qty 													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,r.incoterms	   ,r.transport_mode 																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	    , ISNULL(NULLIF(a.origin_from_division_id,''''),''-'') origin_from_division_id											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, ISNULL(NULLIF(a.origin_to_division_id,''''),''-'') origin_to_division_id												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		, ISNULL(NULLIF(a.electrode_type,''''),''-'') electrode_type															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   FROM SSP_ANL_SHIPMENT_PLAN_FG a																								'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   JOIN SCM_DNM_EXFACTORY_RESULT r ON a.division_id =  r.division_id  and a.project_code = r.project_code						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   JOIN SCM_DNM_EXFACTORY_RESULT r ON a.project_code = r.project_code															'+CHAR(10);
	IF (@p_division_id != 'EE')	BEGIN SET @mEXEC = @mEXEC+' AND  a.division_id =  r.division_id																	'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     	   			and a.item_id = r.item_id and a.from_site = r.from_scm_site_id and a.to_site = r.to_scm_site_id 					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   			and a.incoterms = r.incoterms									 			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   JOIN SCM_MST_SHEET_MEASURE b ON a.MEASURE = b.COLUMN_NAME																	'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   LEFT JOIN scp_mst_bod_n_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'     	LEFT JOIN scp_mst_bod_n_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'     	LEFT JOIN scp_mst_bod_n_v c ON a.origin_from_division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site			'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     			  								 AND d.column_name = b.column_name AND d.user_id = '''+@p_user_id+''' 					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   WHERE 1=1																													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.program_id       =   '''+@p_program_id+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.sheet_name       =   '''+@p_sheet_name+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND b.valid_yn		   =   ''Y''																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND ('''+@v_cnt_usr_measure+''' = 0 OR EXISTS (SELECT 1																		'+CHAR(10);									
	SET @mEXEC = @mEXEC+'     	   										FROM scm_mst_titleset_user  															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										WHERE program_id  = '''+@p_program_id+''' 												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND sheet_name  = '''+@p_sheet_name+''' 												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND user_id     = '''+@p_user_id+''' 													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										AND column_name = b.column_name) 														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				)																												'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 >= '''+@p_from_yyyymmdd+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 <= '''+@p_to_yyyymmdd+'''																			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	 >= convert(datetime, '''+@v_from_result+''')															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	 < convert(datetime, '''+@v_to_result+''' )																'+CHAR(10); -- equal 표시 주의할것	
	--SET @mEXEC = @mEXEC+'     	   AND a.division_id         = '''+@p_division_id+'''																			'+CHAR(10);

	IF @p_division_id != 'EE'  BEGIN	SET @mEXEC = @mEXEC+'  AND a.division_id         = '''+@p_division_id+'''												'+CHAR(10); END;

	SET @mEXEC = @mEXEC+'     	   AND a.biz_type			  = '''+@p_biz_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_type           = '''+@p_plan_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.seq                 = '''+@p_seq+'''																					'+CHAR(10); 
	IF NOT(@p_project_code IS NULL OR  @p_project_code    ='') BEGIN SET @mEXEC = @mEXEC+' AND ( r.project_code  IN ('+@arr_project_code+') )					'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL      OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+' AND ( r.item_id       IN ('+@arr_item_id+') )						'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( a.electrode_type      IN ('+@arr_electrode_type+') )	 '+CHAR(10); END;		
	
	SET @mEXEC = @mEXEC+'  			GROUP BY  r.division_id ,r.project_code ,r.item_id ,r.from_scm_site_id  ,r.to_scm_site_id  ,r.exfactory_date ,r.incoterms	   ,r.transport_mode, a.origin_from_division_id, a.origin_to_division_id, a.electrode_type	 '+CHAR(10);

	/*
	SET @mEXEC = @mEXEC+'     	   		  ,''-'' origin_from_division_id, ''-'' origin_to_division_id, ''-'' electrode_type								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	FROM scm_dnm_exfactory_result r 																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	WHERE 1=1 																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND r.exfactory_date >= convert(datetime, '''+@v_from_result+''') 													'+CHAR(10);
														-- equal 표시 주의할것								  						
	SET @mEXEC = @mEXEC+'     	   	AND r.exfactory_date < convert(datetime, '''+@v_to_result+''' )														'+CHAR(10); 
	--SET @mEXEC = @mEXEC+'     	   	AND r.division_id         = '''+@p_division_id+'''																	'+CHAR(10);
	IF @p_division_id != 'EE' BEGIN	SET @mEXEC = @mEXEC+'  AND r.division_id         = '''+@p_division_id+'''											'+CHAR(10); END;

    IF NOT(@p_project_code IS NULL  OR  @p_project_code  ='') BEGIN SET @mEXEC = @mEXEC+' AND ( r.project_code  IN ('+@arr_project_code+') )			'+CHAR(10); END;
	IF NOT(@p_item_id IS NULL       OR  @p_item_id       ='') BEGIN SET @mEXEC = @mEXEC+'  AND ( r.item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	
	SET @mEXEC = @mEXEC+'  			GROUP BY  r.division_id ,r.project_code ,r.item_id ,r.from_scm_site_id  ,r.to_scm_site_id  ,r.exfactory_date ,r.incoterms	   ,r.transport_mode	 '+CHAR(10);
	*/

	EXEC (@mEXEC);

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
	* 임시테이블만들기- Main 조회 테이블
	********************************************************************************/	
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0009_01') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0009_01
	
	SELECT 
	          (m.division_id + m.biz_type + m.project_code  + m.item_id + m.to_site + m.incoterms ) as key_idx
			, m.division_id		
			, m.biz_type	
			, m.project_code
			, m.item_id			
			, m.to_site	
			, case when RIGHT(m.to_site,2) = '-S' then LEFT(m.to_site , LEN(m.to_site) - 2) else m.to_site end to_site2
			, m.incoterms
			, m.from_site 
			, m.transport_mode	
			, m.lt_day
			, m.origin_from_division_id
			, m.origin_to_division_id
			, m.electrode_type
			, m.measure	
			, m.measure_label 
			, m.measure_order_no		 -- USER MEASURE 정보 , b.sort_order_no as measure_order_no 
			, m.bod_id 
			, @p_from_yyyymmdd as from_yyyymmdd
			, @p_to_yyyymmdd as to_yyyymmdd
			, @p_plan_start_yyyymmdd AS plan_start_yyyymmdd
			, @p_plan_type as plan_type
			, @p_seq as seq	
			,'D_'+m.yyyymmdd AS yyyymmdd
			, o.basis_yyyymm AS yyyymm
			--, RIGHT(o.basis_yyyymm,2)+o.iso_week AS iso_week
			, RIGHT(o.basis_yyyymm, 4) + o.iso_week AS iso_week
			, n.qty
		  -- Main
	INTO  #TblDynamicPivot_SSP0009_01
	FROM(		   
			SELECT   distinct
					  m.yyyymmdd		, m.division_id		, m.biz_type		, m.project_code
					, m.item_id			, m.to_site			, m.from_site 
				    , m.incoterms		, m.bod_id 			, m.measure
					, m.measure_label 	, m.measure_order_no		 
					, m.transport_mode	, m.lt_day
					, m.origin_from_division_id, m.origin_to_division_id, m.electrode_type
			--Header
			FROM #TblDynamicPivot_SSP0009_02 m
	) m
	LEFT OUTER JOIN (	SELECT   n.division_id  ,n.project_code  ,n.item_id		
								,n.from_site	,n.to_site	     ,n.measure				
								,n.yyyymmdd	    ,n.qty	         ,n.incoterms	  
								,n.transport_mode
								,n.origin_from_division_id, n.origin_to_division_id, n.electrode_type
					   -- Qty
					   FROM #TblDynamicPivot_SSP0009_03 n
					) n ON m.division_id     = n.division_id			                                  	
						AND m.PROJECT_CODE	 = n.PROJECT_CODE
						AND m.item_id		 = n.item_id
						AND m.FROM_SITE		 = n.FROM_SITE
						AND m.to_site		 = n.to_site
						AND m.measure		 = n.measure
						AND m.yyyymmdd		 = n.yyyymmdd
						AND isnull(m.incoterms,'-')        = isnull(n.incoterms,'-') 
						AND isnull(m.transport_mode,'-')   = isnull(n.transport_mode,'-') 
						AND m.origin_from_division_id = n.origin_from_division_id
						AND m.origin_to_division_id = n.origin_to_division_id
						AND m.electrode_type = n.electrode_type
	INNER JOIN scm_sys_calendar_m o on m.yyyymmdd = o.basis_yyyymmdd	

	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/		
		BEGIN
			DECLARE @mQry_sum NVARCHAR(MAX);
			DECLARE @mDAY_QTY NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mDAY_QTY='QTY';
		SET @mQry_sum = '';

		    SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'convert(numeric(15,2),SUM(CASE WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+' END)) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'convert(numeric(15,2),SUM(CASE WHEN iso_week=RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+' END)) AS ' + yyyymmdd
											        WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'convert(numeric(15,2),SUM(CASE WHEN yyyymmdd='''+yyyymmdd+''' THEN '+@mDAY_QTY+'  END)) AS ' + yyyymmdd
									           END +''+CHAR(10)

		    --SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+' END) AS ' + yyyymmdd
						--							WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week=RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+' END) AS ' + yyyymmdd
						--					        WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd='''+yyyymmdd+''' THEN '+@mDAY_QTY+'  END) AS ' + yyyymmdd
						--			           END +''+CHAR(10)
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

			
			SET @mEXEC = @mEXEC+'      SELECT a.*																							'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(b.PROJECT_NAME, ''-'') PROJECT_NAME													'+CHAR(10);
			--SET @mEXEC = @mEXEC+'			  , ISNULL(b.PROJECT_OWNER, ''-'') PROJECT_OWNER												'+CHAR(10);
			IF @p_division_id != 'EE'
				SET @mEXEC = @mEXEC+'			  , ISNULL(CASE WHEN a.division_id <> ''40'' THEN b.PROJECT_OWNER ELSE f.USER_NAME_EN end, ''-'') AS PROJECT_OWNER												'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'			  , ISNULL(CASE WHEN a.origin_to_division_id <> ''40'' THEN b.PROJECT_OWNER ELSE f.USER_NAME_EN end, ''-'') AS PROJECT_OWNER												'+CHAR(10);
			--SET @mEXEC = @mEXEC+'			  , ISNULL(c.ITEM_TYPE, ''-'') ITEM_TYPE														'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(dbo.FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', c.ITEM_TYPE) ,''-'') ITEM_TYPE		'+CHAR(10);
			--SET @mEXEC = @mEXEC+'			  , ISNULL(e.DEPT_NAME_KO, ''-'') DEPT_NAME_KO													'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(g.DEPT_NAME_KO, ''-'') DEPT_NAME_KO	'+CHAR(10);
			SET @mEXEC = @mEXEC+'	   from (																								'+CHAR(10);

			SET @mEXEC = @mEXEC+'      SELECT																								'+CHAR(10);
			SET @mEXEC = @mEXEC+'      		  key_idx																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, division_id																					'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, biz_type																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, dbo.FN_GET_LOOKUP_CODE_DESC(''BIZ_TYPE'', BIZ_TYPE) AS biz_type_name							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, project_code																					'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			, isnull(DBO.FN_GET_PROJECT_NAME(DIVISION_ID, PROJECT_CODE),''-'') as project_name				'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, item_id																						'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			, (case when dbo.FN_GET_ITEM_NICKNAME( division_id, item_id ) ='''' then ''-''					'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			   else dbo.FN_GET_ITEM_NICKNAME( division_id, item_id ) end) AS nick_name						'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,(SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') NICK_NAME FROM SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = a.item_id)	nick_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, to_site, to_site2																						'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			, dbo.FN_GET_SCM_SITE_DESCRIPTION(division_id, to_site) as to_site_name							'+CHAR(10);
			IF @p_division_id != 'EE'
				--SET @mEXEC = @mEXEC+' 			, dbo.FN_GET_SCM_SITE_DESCRIPTION(division_id, DBO.FN_GET_SITE_NAME_SHIPMENT(TO_SITE) ) as to_site_name							'+CHAR(10);
				SET @mEXEC = @mEXEC+'			,(select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = TO_SITE2) to_site_name '+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+' 			, to_site as to_site_name							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, incoterms																						'+CHAR(10);
			--SET @mEXEC = @mEXEC+'			, case dbo.FN_GET_SITE_CUSTOMER_INFO(division_id, to_site, ''SOLDTO_DESCRIPTION'' ) when '''' then ''-'' else dbo.FN_GET_SITE_CUSTOMER_INFO(division_id, to_site, ''SOLDTO_DESCRIPTION'' ) end as SOLDTO_DESCRIPTION '+CHAR(10);
			--SET @mEXEC = @mEXEC+'			, case dbo.FN_GET_SITE_CUSTOMER_INFO(division_id, to_site, ''SHIPTO_DESCRIPTION'' ) when '''' then ''-'' else dbo.FN_GET_SITE_CUSTOMER_INFO(division_id, to_site, ''SHIPTO_DESCRIPTION'' ) end as SHIPTO_DESCRIPTION '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, from_site																						'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			, ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(division_id, FROM_SITE) ,''-'') as  from_site_name		'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,isnull((select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = FROM_SITE),''-'') from_site_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, bod_id																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, ISNULL(transport_mode , ''-'') as transport_mode												'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, ISNULL(lt_day , 0) as lt_day																	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, origin_from_division_id, origin_to_division_id, electrode_type								'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, cast( round( [dbo].[FN_GET_SSP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd, plan_type, seq, to_site , item_id,from_yyyymmdd) , 1) as int) as boh '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			, DATEADD(DAY, (SELECT ISNULL(SHIP_FROZEN, 0) AS SHIP_FROZEN FROM SCM_MST_SITE WHERE DIVISION_ID='''+ @p_division_id + ''' AND SCM_SITE_ID=FROM_SITE) , CONVERT(DATE, '''+ @p_plan_start_yyyymmdd  +''', 112)) AS SHIP_FROZEN '   +CHAR(10);
			IF @p_division_id != 'EE'
				BEGIN SET @mEXEC = @mEXEC+' 			, DATEADD(DAY, (SELECT ISNULL(SHIP_FROZEN, 0) AS SHIP_FROZEN FROM SCM_MST_SITE WHERE DIVISION_ID= division_id AND SCM_SITE_ID=FROM_SITE) , CONVERT(DATE, '''+ @p_plan_start_yyyymmdd  +''', 112)) AS SHIP_FROZEN '   +CHAR(10); END
			ELSE
				BEGIN SET @mEXEC = @mEXEC+' 			, DATEADD(DAY, (SELECT ISNULL(SHIP_FROZEN, 0) AS SHIP_FROZEN FROM SCM_MST_SITE WHERE DIVISION_ID= origin_from_division_id AND SCM_SITE_ID=FROM_SITE) , CONVERT(DATE, '''+ @p_plan_start_yyyymmdd  +''', 112)) AS SHIP_FROZEN '   +CHAR(10); END
			SET @mEXEC = @mEXEC+' 			, measure																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, measure_order_no																				'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, measure_label 																				'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, plan_start_yyyymmdd, plan_type, seq, from_yyyymmdd,to_yyyymmdd								'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			'+@mQry_sum		
																							 +CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0009_01 a																	'+CHAR(10);
			SET @mEXEC = @mEXEC+'	   GROUP BY key_idx, division_id, biz_type, project_code, item_id,to_site,to_site2,incoterms,  from_site,bod_id ,transport_mode, lt_day, origin_from_division_id, origin_to_division_id, electrode_type,measure,measure_order_no,measure_label ,plan_start_yyyymmdd, plan_type, seq,from_yyyymmdd,to_yyyymmdd'+CHAR(10) ;
			--SET @mEXEC = @mEXEC+'	   ORDER BY division_id, biz_type, item_id, to_site,project_code, incoterms, from_site, bod_id, measure_order_no  '+CHAR(10);
			
			SET @mEXEC = @mEXEC+'      ) a																									'+CHAR(10);
			SET @mEXEC = @mEXEC+'      LEFT JOIN (SELECT DIVISION_ID																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_CODE																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_OWNER																	'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC ) NUMS											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					FROM SCM_MST_PROJECT WITH(NOLOCK)														'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 ) b  on a.DIVISION_ID	= b.DIVISION_ID 													'+CHAR(10);
			SET @mEXEC = @mEXEC+'					 and a.PROJECT_CODE	= b.PROJECT_CODE													'+CHAR(10);
			SET @mEXEC = @mEXEC+'					 and b.NUMS=1																			'+CHAR(10);
			SET @mEXEC = @mEXEC+'      LEFT JOIN (SELECT DIVISION_ID																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ITEM_ID																			'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ITEM_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , NICK_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ITEM_TYPE																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, ITEM_ID ORDER BY  CASE ITEM_TYPE WHEN ''P'' THEN 999 WHEN ''H'' THEN 888 WHEN ''R'' THEN 777  WHEN ''Q'' THEN 666 ELSE 0 END  DESC ) NUMS																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'					FROM SCM_MST_ITEM_SN WITH(NOLOCK)														'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 ) c  on a.division_id=c.division_id														'+CHAR(10);
			SET @mEXEC = @mEXEC+'				     and a.item_id=c.item_id																'+CHAR(10);
			SET @mEXEC = @mEXEC+'				     and c.nums=1																			'+CHAR(10);
			--SET @mEXEC = @mEXEC+'      INNER JOIN scm_mst_site d  on a.DIVISION_ID=d.DIVISION_ID											'+CHAR(10);
			--SET @mEXEC = @mEXEC+'								 and a.TO_SITE=d.SCM_SITE_ID												'+CHAR(10);
			--SET @mEXEC = @mEXEC+'      INNER JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID											'+CHAR(10);

			/*
			IF @p_division_id != 'EE'
			BEGIN
				SET @mEXEC = @mEXEC+'      INNER JOIN scm_mst_site d  on a.DIVISION_ID=d.DIVISION_ID and a.TO_SITE=d.SCM_SITE_ID											'+CHAR(10);
				SET @mEXEC = @mEXEC+'      LEFT JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID											'+CHAR(10);
			END
			ELSE
			BEGIN
				--SET @mEXEC = @mEXEC+'      INNER JOIN scm_mst_site d  on a.origin_from_division_id=d.DIVISION_ID and d.SCM_SITE_ID = DBO.FN_GET_SITE_NAME_SHIPMENT(a.TO_SITE)											'+CHAR(10);
				--SET @mEXEC = @mEXEC+'      INNER JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID											'+CHAR(10);
				SET @mEXEC = @mEXEC+'      LEFT JOIN scm_mst_site d  on a.origin_from_division_id=d.DIVISION_ID and d.SCM_SITE_ID = DBO.FN_GET_SITE_NAME_SHIPMENT(a.TO_SITE)											'+CHAR(10);
				SET @mEXEC = @mEXEC+'      LEFT JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID											'+CHAR(10);
			END
			*/

			/********** DEPT NAME START **********/
			SET @mEXEC = @mEXEC+'			LEFT JOIN SCM_MST_SITE d 					'+CHAR(10);
			IF @p_division_id != 'EE'
			BEGIN
				SET @mEXEC = @mEXEC+'			   ON d.division_id	= a.division_id 					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  AND d.SCM_SITE_ID	= a.TO_SITE 					'+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'			   on d.division_id	= a.origin_to_division_id 					'+CHAR(10);
				--SET @mEXEC = @mEXEC+'			  and d.scm_site_id	= DBO.FN_GET_SITE_NAME_SHIPMENT(a.TO_SITE)					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  and d.scm_site_id	= a.TO_SITE2					'+CHAR(10);
			END
			SET @mEXEC = @mEXEC+'				  AND d.VALID_YN       = ''Y'' 					'+CHAR(10);


			SET @mEXEC = @mEXEC+'			LEFT JOIN SCM_MST_SITE_ITEM e 					'+CHAR(10);
			IF @p_division_id != 'EE'
			BEGIN
				SET @mEXEC = @mEXEC+'			    on e.division_id	= a.division_id 					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			    and e.scm_site_id	= a.TO_SITE					'+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'			    on e.division_id	= a.origin_to_division_id 					'+CHAR(10);
				--SET @mEXEC = @mEXEC+'			    and e.scm_site_id	= DBO.FN_GET_SITE_NAME_SHIPMENT(a.TO_SITE)					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			    and e.scm_site_id	= a.TO_SITE2					'+CHAR(10);
			END
			SET @mEXEC = @mEXEC+'					and e.project_code	= a.project_code 					'+CHAR(10);
			SET @mEXEC = @mEXEC+'					and e.item_id		= a.item_id 					'+CHAR(10);
			SET @mEXEC = @mEXEC+'					and e.VALID_YN		=''Y'' 					'+CHAR(10);

			SET @mEXEC = @mEXEC+'			LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] f WITH(NOLOCK) 					'+CHAR(10);
			SET @mEXEC = @mEXEC+'				   ON  substring( e.OWNER, 0, case when charindex('','',e.OWNER) = 0 then len(e.OWNER)+1 else charindex('','',e.OWNER) end ) = f.USER_ID 					'+CHAR(10);

			SET @mEXEC = @mEXEC+'			LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] g WITH(NOLOCK) 					'+CHAR(10);
			IF @p_division_id != 'EE'
				SET @mEXEC = @mEXEC+'				   ON  CASE WHEN a.DIVISION_ID = ''40'' THEN f.DEPT_ID ELSE d.DEPT_ID END  = g.DEPT_ID 					'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'				   ON  CASE WHEN a.origin_to_division_id = ''40'' THEN f.DEPT_ID ELSE d.DEPT_ID END  = g.DEPT_ID 					'+CHAR(10);
			/********** DEPT NAME END **********/


			SET @mEXEC = @mEXEC+'      ORDER BY a.division_id, a.biz_type, a.item_id, a.to_site,project_code, a.incoterms, a.from_site, a.bod_id, a.measure_order_no		'+CHAR(10);
			
			
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
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0009_01') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0009_01;
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0009_02') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0009_02
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0009_03') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0009_03
	
	-- 수정가능여부 구간 조회
	/*
	DECLARE @todayLimit date = convert(date , getdate() , 112 );

	SELECT
		case
			when DATEDIFF(week , @todayLimit , @p_plan_start_yyyymmdd) < 0 then 'N'
			when a.PLAN_TYPE ='FN' then 'N'	
			when a.PLAN_TYPE ='MA' and confirm_yn='Y' then 'Y'
			when a.PLAN_TYPE ='SE' then 'Y'
			when a.PLAN_TYPE ='PR' then 'N'
			else 'N'
		end as is_editable
		--'Y' as is_editable
		, convert(date , @p_plan_start_yyyymmdd, 112) as plan_start_date
	FROM (
		SELECT   d.division_id
				,p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(CONVERT(NVARCHAR,d.plan_seq),2)  AS plan_version_id
				,p.plan_name
				,d.plan_seq
				,d.plan_type	
				,vv.CONFIRM_FLAG
				,p.plan_name as plan_start_yyyymmdd
				,CASE WHEN ISNULL(d.CONFIRM_FLAG,'')='' THEN 'N' ELSE d.CONFIRM_FLAG END AS confirm_yn		
		FROM scm_mst_plan_detail d
		inner join scm_mst_modeling m on m.modeling_id = d.modeling_id	and m.plan_cycle  = 'WEEKLY' and m.division_id = d.division_id	and m.modeling_id = d.modeling_id
		inner join scm_mst_plan p on p.division_id = d.division_id	and p.plan_cycle  = m.plan_cycle and p.plan_id     = d.plan_id
		inner join SCP_PLAN_VERSION_V vv on d.division_id = vv.division_id and d.plan_type   = vv.plan_type	and d.plan_seq    = vv.plan_seq	and p.plan_name   = vv.plan_start_yyyymmdd
		WHERE 1=1
		  and d.division_id = @p_division_id
		  and d.plan_type   = @p_plan_type
		  and d.plan_seq    = @p_seq
		  and p.plan_name   = @p_plan_start_yyyymmdd	) a
	 ,(SELECT basis_start_date FROM scm_sys_calendar_m WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112) ) b
	;

	/*
	declare @p_item_id nvarchar(100)='ACEN1042I-A1',
	@p_project_code nvarchar(100) ='A15HC2006'
	*/
	-- 05/25
	-- FIX 추가관련
	/*
	SELECT 
		(a.division_id + a.biz_type + a.project_code  + a.item_id + a.to_site + a.incoterms) as key_idx 
		, FIX_ID
		,from_site
		,incoterms
		,bod_id
		,'D_'+yyyymmdd AS yyyymmdd
	from SSP_ANL_SHIPMENT_PLAN_FIX a
	where division_id = @p_division_id
	and biz_type= @p_biz_type
	and a.yyyymmdd >= @p_from_yyyymmdd
	and a.yyyymmdd <= @p_to_yyyymmdd
	and ( (@p_item_id is null or @p_item_id = '') or a.ITEM_ID in (select token from dbo.String_Split(@p_item_id, ',')) )
	and ( (@p_project_code is null or @p_item_id = '') or a.ITEM_ID in (select token from dbo.String_Split(@p_item_id, ',')) )
	order by
		key_idx, division_id, biz_type, item_id, to_site,project_code, incoterms, from_site, bod_id
	;
	*/

	*/
END
