
/*
 * Program ID   : SSP0010_GET_SHIPMENT_PLAN_SEMI_SSP
 * Description  : Shipment Plan SSP 조회 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/12	KYH				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/06   ygkim          @p_electrode_type 파리미터, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID 컬럼 추가
 * 2018/08/10   ygkim			#TblDynamicPivot_SSP0010_02 measure_order_no 데이터 타입 INT로 변경
  * 2018/09/14   ygkim			속도 개선(함수제거)

 * ex)   EXEC SSP0010_GET_SHIPMENT_PLAN_SEMI_SSP @p_from_yyyymmdd='20180611', @p_to_yyyymmdd='20180805', @p_division_id='81', @p_operation_group='A', @p_item_id='', @p_plan_start_yyyymmdd='20180611', @p_plan_type='SP', @p_seq='1', @p_program_id='SSP0010', @p_sheet_name='CELL', @p_user_id='kaiser99', @debug_mode='F'
 */
CREATE PROCEDURE [dbo].[SSP0010_GET_SHIPMENT_PLAN_SEMI_SSP]
	@p_from_yyyymmdd		NVARCHAR(MAX),
	@p_to_yyyymmdd			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_operation_group		NVARCHAR(MAX),	
	@p_item_id				NVARCHAR(MAX),
	@p_plan_start_yyyymmdd  NVARCHAR(8)  ,
	@p_plan_type			NVARCHAR(50) ,
	@p_seq					NVARCHAR(50) ,
	@p_program_id			NVARCHAR(MAX) = 'SSP0010' ,
	@p_sheet_name			NVARCHAR(MAX),
	@p_user_id				NVARCHAR(MAX),
	@debug_mode				NVARCHAR(MAX) = 'T',
	@p_electrode_type		    NVARCHAR(60) = ''

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

    DECLARE @arr_item_id varchar(max), @arr_electrode_type varchar(max)
	SELECT @arr_item_id     = ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_electrode_type     = ISNULL(@arr_electrode_type + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_electrode_type,',')
	DECLARE @mEXEC NVARCHAR(MAX);

   /********************************************************************************
	* 임시테이블만들기 - Header 부분
	********************************************************************************/	
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0010_02') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0010_02

	CREATE TABLE #TblDynamicPivot_SSP0010_02 (
	  division_id	       NVARCHAR(128)	,operation_group   NVARCHAR(128)	,item_id		     NVARCHAR(128)
	 ,from_site		       NVARCHAR(128)	,transport_mode	   NVARCHAR(128)	,lt_day			     NVARCHAR(128)
	 ,measure		       NVARCHAR(128)	,measure_label	   NVARCHAR(128)	,measure_order_no	 INT --NVARCHAR(128)
	 ,to_site	           NVARCHAR(128)	,bod_id            NVARCHAR(128)	
	 ,origin_from_division_id	NVARCHAR(128)	,origin_to_division_id	NVARCHAR(128) ,electrode_type	NVARCHAR(128)
	 ,plan_start_yyyymmdd  NVARCHAR(8)	    ,plan_type		   NVARCHAR(128)	,seq		         NVARCHAR(128)	
	 ,yyyymmdd		       NVARCHAR(8)
	)
	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     INSERT #TblDynamicPivot_SSP0010_02																								'+CHAR(10);
								  -- 계획 yyyymmdd	
	SET @mEXEC = @mEXEC+'     	   SELECT   distinct																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				  a.division_id, a.operation_group	,a.item_id	, a.from_site ,c.transport_mode									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, c.lt_total AS lt_day, a.measure , b.column_label_name as measure_label 										'+CHAR(10);	
	SET @mEXEC = @mEXEC+'     	   				, isnull(d.sort_order_no, b.sort_order_no ) AS measure_order_no													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, a.to_site, a.bod_id																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.origin_from_division_id,''''),''-'') origin_from_division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.origin_to_division_id,''''),''-'') origin_to_division_id										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.electrode_type,''''),''-'') electrode_type													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, a.plan_start_yyyymmdd, a.plan_type, a.seq, a.yyyymmdd															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		FROM SSP_ANL_SHIPMENT_PLAN_SEMI a																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		JOIN SCM_MST_SHEET_MEASURE b ON a.measure = b.column_name																'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   		LEFT JOIN SCP_MST_BOD_N_V c    ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site	'+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'     		LEFT JOIN SCP_MST_BOD_N_V c    ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site		'+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'     		LEFT JOIN SCP_MST_BOD_N_V c    ON a.origin_from_division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site		'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   		LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name 				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   													AND d.column_name = b.column_name AND d.user_id = '''+@p_user_id+'''		'+CHAR(10);
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
	SET @mEXEC = @mEXEC+'     	   AND a.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_type           = '''+@p_plan_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.seq                 = '''+@p_seq+'''																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.operation_group	 = '''+@p_operation_group+'''																		'+CHAR(10);
	IF NOT(@p_item_id IS NULL      OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+' AND ( a.item_id       IN ('+@arr_item_id+') )						'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( a.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     	   UNION ALL																													'+CHAR(10);
										-- 실적 yyyymmdd
	SET @mEXEC = @mEXEC+'     	   		SELECT   DISTINCT																										'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   				  a.division_id, a.operation_group, a.item_id, a.from_site, c.transport_mode									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   			CASE WHEN '''+ @p_division_id + ''' = ''EE'' THEN ''EE'' ELSE a.division_id END AS division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, a.operation_group, a.item_id, a.from_site, c.transport_mode									'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   				, c.lt_total AS lt_day, a.measure, b.column_label_name as measure_label 										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, isnull(d.sort_order_no, b.sort_order_no ) AS measure_order_no													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, a.to_site, a.bod_id																							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.origin_from_division_id,''''),''-'') origin_from_division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.origin_to_division_id,''''),''-'') origin_to_division_id										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, ISNULL(NULLIF(a.electrode_type,''''),''-'') electrode_type													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   				, a.plan_start_yyyymmdd, a.plan_type, a.seq, r.exfactory_date as yyyymmdd										'+CHAR(10);	
	SET @mEXEC = @mEXEC+'     	   		FROM SSP_ANL_SHIPMENT_PLAN_SEMI a																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		JOIN SCM_DNM_EXFACTORY_RESULT r ON a.division_id =  r.division_id  and a.item_id = r.item_id 							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										and a.from_site = r.from_scm_site_id and a.to_site = r.to_scm_site_id					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		JOIN SCM_MST_SHEET_MEASURE b ON a.measure = b.column_name																'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   		LEFT JOIN SCP_MST_BOD_N_V c    ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site	'+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'     	   	LEFT JOIN SCP_MST_BOD_N_V c    ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site	'+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'     	   	LEFT JOIN SCP_MST_BOD_N_V c    ON a.ORIGIN_FROM_DIVISION_ID = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site	'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   		LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name 				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   												AND d.column_name = b.column_name AND d.user_id = '''+@p_user_id+'''			'+CHAR(10);
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
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	 >= convert(datetime, '''+@v_from_result+''')															'+CHAR(10);
														-- equal 표시 주의할것	
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	  < convert(datetime, '''+@v_to_result +''')															'+CHAR(10);
    SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 >= '''+@p_from_yyyymmdd+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 <= '''+@p_to_yyyymmdd+'''																			'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   AND a.division_id         = '''+@p_division_id+'''																			'+CHAR(10);

	IF @p_division_id != 'EE'  BEGIN	SET @mEXEC = @mEXEC+'  AND a.division_id         = '''+@p_division_id+'''												'+CHAR(10); END;

	SET @mEXEC = @mEXEC+'     	   AND a.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_type           = '''+@p_plan_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.seq                 = '''+@p_seq+'''																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.operation_group	 = '''+@p_operation_group+'''																		'+CHAR(10);
	IF NOT(@p_item_id IS NULL      OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+' AND ( a.item_id       IN ('+@arr_item_id+') )						'+CHAR(10); END;
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
    IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0010_03') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SSP0010_03

	CREATE TABLE #TblDynamicPivot_SSP0010_03 (
	  division_id	NVARCHAR(128)	,item_id	NVARCHAR(128)	
	 ,from_site		NVARCHAR(128)   ,to_site			NVARCHAR(128)	,measure	NVARCHAR(128)
	 ,yyyymmdd		NVARCHAR(8)     ,qty				NUMERIC(20,10)
	 ,transport_mode		NVARCHAR(128),origin_from_division_id	NVARCHAR(128)	,origin_to_division_id	NVARCHAR(128) ,electrode_type	NVARCHAR(128)	
	)
	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'     INSERT #TblDynamicPivot_SSP0010_03																						'+CHAR(10);
								    -- 계획
	SET @mEXEC = @mEXEC+'    		SELECT d.division_id  ,d.ITEM_ID																					'+CHAR(10);		
	SET @mEXEC = @mEXEC+'    			  ,d.from_site	  ,d.to_site	   ,d.measure																	'+CHAR(10);				
	SET @mEXEC = @mEXEC+'    			  ,d.yyyymmdd	  ,d.qty																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'    			  ,c.transport_mode																								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(d.origin_from_division_id,''''),''-'') origin_from_division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(d.origin_to_division_id,''''),''-'') origin_to_division_id										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(d.electrode_type,''''),''-'') electrode_type													'+CHAR(10);
	SET @mEXEC = @mEXEC+'    		FROM SSP_ANL_SHIPMENT_PLAN_SEMI d																					'+CHAR(10);
	--SET @mEXEC = @mEXEC+'    		LEFT JOIN SCP_MST_BOD_N_V c ON d.division_id = c.division_id AND  d.bod_id = c.bod_id AND d.from_site = c.from_site   '+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'    	LEFT JOIN SCP_MST_BOD_N_V c ON d.division_id = c.division_id AND  d.bod_id = c.bod_id AND d.from_site = c.from_site   '+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'    	LEFT JOIN SCP_MST_BOD_N_V c ON d.origin_from_division_id = c.division_id AND  d.bod_id = c.bod_id AND d.from_site = c.from_site   '+CHAR(10);

	SET @mEXEC = @mEXEC+'    		WHERE 1=1																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.yyyymmdd			 >= '''+@p_from_yyyymmdd+'''																'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.yyyymmdd			 <= '''+@p_to_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.division_id         = '''+@p_division_id+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.operation_group			  = '''+@p_operation_group+'''														'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''															'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.plan_type           = '''+@p_plan_type+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND d.seq                 = '''+@p_seq+'''																			'+CHAR(10);
	IF NOT(@p_item_id IS NULL       OR  @p_item_id       ='') BEGIN SET @mEXEC = @mEXEC+' AND ( d.item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	SET @mEXEC = @mEXEC+'     	   	UNION ALL																											'+CHAR(10);
								    -- 출하실적	
	SET @mEXEC = @mEXEC+'     		SELECT 																												'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   		   r.division_id  ,r.item_id																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		   r.item_id																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,CASE WHEN '''+ @p_division_id + ''' = ''EE'' THEN ''EE'' ELSE r.division_id END AS division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,r.from_scm_site_id as from_site	  ,r.to_scm_site_id as to_site		  ,''SHIP_PLAN'' as measure 			'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,r.exfactory_date as yyyymmdd	  ,SUM(r.exfactory_qty) as qty 													'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,r.transport_mode 																							'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   		  ,r.division_id origin_from_division_id, ''-'' origin_to_division_id, ''-'' electrode_type								'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(a.origin_from_division_id,''''),''-'') origin_from_division_id									'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(a.origin_to_division_id,''''),''-'') origin_to_division_id										'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		  ,ISNULL(NULLIF(a.electrode_type,''''),''-'') electrode_type													'+CHAR(10);
	/*
	SET @mEXEC = @mEXEC+'     	   	FROM scm_dnm_exfactory_result r 																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	WHERE 1=1 																											'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   	AND r.exfactory_date >= convert(datetime, '''+@v_from_result+''') 													'+CHAR(10);
														-- equal 표시 주의할것								  						
	SET @mEXEC = @mEXEC+'     	   	AND r.exfactory_date < convert(datetime, '''+@v_to_result+''' )														'+CHAR(10); 
	--SET @mEXEC = @mEXEC+'     	   	AND r.division_id         = '''+@p_division_id+'''																	'+CHAR(10);

	IF @p_division_id != 'EE'  BEGIN	SET @mEXEC = @mEXEC+'  AND r.division_id         = '''+@p_division_id+'''												'+CHAR(10); END;

	IF NOT(@p_item_id IS NULL       OR  @p_item_id       ='') BEGIN SET @mEXEC = @mEXEC+'  AND ( r.item_id      IN ('+@arr_item_id+') )					'+CHAR(10); END;
	*/
	SET @mEXEC = @mEXEC+'     	   		FROM SSP_ANL_SHIPMENT_PLAN_SEMI a																						'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		JOIN SCM_DNM_EXFACTORY_RESULT r ON a.division_id =  r.division_id  and a.item_id = r.item_id 							'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   										and a.from_site = r.from_scm_site_id and a.to_site = r.to_scm_site_id					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   		JOIN SCM_MST_SHEET_MEASURE b ON a.measure = b.column_name																'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   		LEFT JOIN SCP_MST_BOD_N_V c    ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site	'+CHAR(10);

	IF @p_division_id != 'EE'
		SET @mEXEC = @mEXEC+'     	   	LEFT JOIN SCP_MST_BOD_N_V c    ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site	'+CHAR(10);
	ELSE
		SET @mEXEC = @mEXEC+'     	   	LEFT JOIN SCP_MST_BOD_N_V c    ON a.ORIGIN_FROM_DIVISION_ID = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site	'+CHAR(10);

	SET @mEXEC = @mEXEC+'     	   		LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON d.program_id  = b.program_id AND d.sheet_name  = b.sheet_name 				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   												AND d.column_name = b.column_name AND d.user_id = '''+@p_user_id+'''			'+CHAR(10);
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
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	 >= convert(datetime, '''+@v_from_result+''')															'+CHAR(10);
														-- equal 표시 주의할것	
	SET @mEXEC = @mEXEC+'     	   AND r.exfactory_date	  < convert(datetime, '''+@v_to_result +''')															'+CHAR(10);
    SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 >= '''+@p_from_yyyymmdd+'''																		'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.yyyymmdd			 <= '''+@p_to_yyyymmdd+'''																			'+CHAR(10);
	--SET @mEXEC = @mEXEC+'     	   AND a.division_id         = '''+@p_division_id+'''																			'+CHAR(10);

	IF @p_division_id != 'EE'  BEGIN	SET @mEXEC = @mEXEC+'  AND a.division_id         = '''+@p_division_id+'''												'+CHAR(10); END;

	SET @mEXEC = @mEXEC+'     	   AND a.plan_start_yyyymmdd = '''+@p_plan_start_yyyymmdd+'''																	'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.plan_type           = '''+@p_plan_type+'''																				'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.seq                 = '''+@p_seq+'''																					'+CHAR(10);
	SET @mEXEC = @mEXEC+'     	   AND a.operation_group	 = '''+@p_operation_group+'''																		'+CHAR(10);
	IF NOT(@p_item_id IS NULL      OR  @p_item_id         ='') BEGIN SET @mEXEC = @mEXEC+' AND ( a.item_id       IN ('+@arr_item_id+') )						'+CHAR(10); END;
	IF NOT(@p_electrode_type IS NULL         OR  @p_electrode_type         ='') BEGIN SET @mEXEC = @mEXEC+'     	AND ( a.electrode_type      IN ('+@arr_electrode_type+') )					'+CHAR(10); END;

	SET @mEXEC = @mEXEC+'  			GROUP BY  r.division_id ,r.item_id ,r.from_scm_site_id  ,r.to_scm_site_id  ,r.exfactory_date ,r.transport_mode, a.origin_from_division_id, a.origin_to_division_id, a.electrode_type		'+CHAR(10);


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
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0010_01') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SSP0010_01

	SELECT   (m.division_id + m.operation_group + m.item_id + m.from_site) as key_idx
			, m.division_id	
			, m.operation_group	
			, m.item_id		
			, m.from_site
			, m.transport_mode
			, m.lt_day
			, m.measure		
			, m.measure_label 	
			, m.measure_order_no
			, m.to_site
			, m.bod_id
			, m.origin_from_division_id
			, m.origin_to_division_id
			, m.electrode_type
			, @p_from_yyyymmdd as from_yyyymmdd
			, @p_to_yyyymmdd as to_yyyymmdd
			, m.plan_start_yyyymmdd
			, m.plan_type
			, m.seq
			,'D_'+m.yyyymmdd AS yyyymmdd
			, o.basis_yyyymm AS yyyymm
			--, RIGHT(o.basis_yyyymm,2)+o.iso_week AS iso_week
			, RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week
			, n.qty
	INTO  #TblDynamicPivot_SSP0010_01
	FROM(	-- 계획 yyyymmdd
			SELECT   DISTINCT
					  m.division_id, m.operation_group	,m.item_id	, m.from_site ,m.transport_mode
					, m.lt_day, m.measure , m.measure_label, m.measure_order_no		
					, m.to_site, m.bod_id
					, m.origin_from_division_id, m.origin_to_division_id, m.electrode_type
					, @p_from_yyyymmdd as from_yyyymmdd
					, @p_to_yyyymmdd as to_yyyymmdd
					, m.plan_start_yyyymmdd, m.plan_type, m.seq, m.yyyymmdd
			FROM #TblDynamicPivot_SSP0010_02 m
	    ) m
		LEFT OUTER JOIN (       -- 계획
								SELECT n.division_id  ,n.ITEM_ID		
									  ,n.from_site	  ,n.to_site	   ,n.measure				
									  ,n.yyyymmdd	  ,n.qty			
									  ,n.transport_mode, n.origin_from_division_id, n.origin_to_division_id, n.electrode_type
								FROM #TblDynamicPivot_SSP0010_03 n
						    ) n ON m.division_id     = n.division_id			                                  	
							   AND m.item_id		 = n.item_id
							   AND m.FROM_SITE		 = n.FROM_SITE
							   AND m.to_site		 = n.to_site
							   AND m.measure		 = n.measure
							   AND m.yyyymmdd		 = n.yyyymmdd
							   AND isnull(m.transport_mode,'-')   = isnull(n.transport_mode,'-') 
							   AND m.origin_from_division_id = n.origin_from_division_id
							   AND m.origin_to_division_id = n.origin_to_division_id
							   ANd m.electrode_type = n.electrode_type
	INNER JOIN scm_sys_calendar_m o on m.yyyymmdd = o.basis_yyyymmdd			

	/********************************************************************************      
	 * BOH temp 테이블 생성  
	 ********************************************************************************/  
	IF OBJECT_ID('tempdb..#BOH_E') IS NOT NULL              
		DROP TABLE #BOH_E  
	IF OBJECT_ID('tempdb..#BOH_A') IS NOT NULL              
		DROP TABLE #BOH_A
        --dbo.FN_GET_SCP_ANL_BOH_QTY     
        --dbo.FN_GET_SCP_ANL_CHAR_BOH_QTY

	IF @p_operation_group = 'E'
		BEGIN
			select *
			into #BOH_E
			from( 
					select 'E' AS OPERATION_GROUP
							, X.site_id
							,X.item_id
							,cast(round(sum(isnull(X.psi_boh_qty,0)),1) as int)  AS psi_boh_qty
						from ssp_pln_plant_onhand X with(nolock) 
						WHERE X.DIVISION_ID =  @p_division_id
						and X.stock_type    NOT IN ( 'FOR_STOCKPLAN','FORMING','FORMED','CHARING','CHAR','A_MOVE_WH','A_OUT_WH')   --셀 활성화진행중 이후 특성,창고재고 제외 
						AND X.plan_start_yyyymmdd        = @p_plan_start_yyyymmdd  
						and X.plan_type                 = @p_plan_type  
						and X.seq                       = @p_seq  
						--and X.site_id                   = @p_scm_site_id  
						--and X.item_id                   = @p_item_id  
						and X.yyyymmdd                  = @p_plan_start_yyyymmdd  
						group by X.site_id
							,X.item_id
			) a
		END
	ELSE
		BEGIN
			select *
			into #BOH_A
			from( 
					select  'A' AS OPERATION_GROUP
						,X.site_id
						,X.item_id
						,cast(round(sum(isnull(X.psi_boh_qty,0)),1) as int)	psi_boh_qty	   
						from ssp_pln_plant_onhand X with(nolock)  
						where X.division_id               = @p_division_id  
						and X.stock_type                IN ('CHAR','A_MOVE_WH','A_OUT_WH') --특성완료재고  
						and X.plan_start_yyyymmdd       = @p_plan_start_yyyymmdd  
						and X.plan_type                 = @p_plan_type  
						and X.seq                       = @p_seq  
						--and site_id                   = @p_scm_site_id  
						--and item_id                   = @p_item_id  
						and X.yyyymmdd                  = @p_plan_start_yyyymmdd  
					group by  X.site_id
						,X.item_id
			) a
		END

	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/		
		BEGIN
			DECLARE @mQry_sum NVARCHAR(MAX);
			DECLARE @mDAY_QTY NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mDAY_QTY='QTY';
		SET @mQry_sum = '';

		    SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN '+@mDAY_QTY+' END ) AS ' + yyyymmdd
													--WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 4) THEN  '+@mDAY_QTY+'  END ) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 6) THEN  '+@mDAY_QTY+'  END ) AS ' + yyyymmdd
											        WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  '+@mDAY_QTY+'  END ) AS ' + yyyymmdd
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
			SET @mEXEC = @mEXEC+'      SELECT																									'+CHAR(10);
			SET @mEXEC = @mEXEC+'      		 key_idx																							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,division_id																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,operation_group																					'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,item_id																							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,from_site																							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,to_site																							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,bod_id																								'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(transport_mode, ''-'') as transport_mode 													'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,ISNULL(lt_day, 0) as lt_day																		'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,origin_from_division_id, origin_to_division_id, electrode_type										'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure																							'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure_order_no																					'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,measure_label 																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,plan_start_yyyymmdd, plan_type, seq,from_yyyymmdd,to_yyyymmdd										'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,dbo.fn_get_division_name(division_id) AS division_name												'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,(select TOP 1 DIVISION_NAME from SCM_MST_DIVISION where DIVISION_ID = a.division_id) division_name     '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			,(case when OPERATION_GROUP =''A'' then ''Cell'' else ''Electrode'' end) as OPERATION_GROUP_DESC 	'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,dbo.FN_GET_ITEM_NICKNAME(division_id, item_id ) AS Nick_name										'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,(SELECT TOP 1 NICK_NAME FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK) WHERE 1=1 AND ITEM_ID = a.item_id)	Nick_name '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,dbo.FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, FROM_SITE ) AS FROM_SITE_DESCRIPTION					'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,(select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = a.FROM_SITE) FROM_SITE_DESCRIPTION '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, TO_SITE ), ''-'') AS T0_SITE_DESCRIPTION		'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,isnull((select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = a.TO_SITE),''-'') T0_SITE_DESCRIPTION '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			,  cast( round(  (CASE WHEN operation_group = ''E'' THEN dbo.FN_GET_SSP_ANL_BOH_QTY      (division_id, plan_start_yyyymmdd, plan_type, seq, from_site, item_id, from_yyyymmdd ) '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			         WHEN operation_group = ''A'' THEN dbo.FN_GET_SSP_ANL_CHAR_BOH_QTY (division_id, plan_start_yyyymmdd, plan_type, seq, from_site, item_id, from_yyyymmdd )				'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 			     END ) , 1) as int) AS BOH																																					'+CHAR(10);
			IF @p_operation_group = 'E'
				BEGIN
					SET @mEXEC = @mEXEC+' 			,  isnull((SELECT psi_boh_qty
															FROM #BOH_E X WITH  (NOLOCK) 
															WHERE 0 = 0						
		 														AND  X.ITEM_ID          = a.item_id
																AND  X.site_id          = a.from_site
																AND  X.OPERATION_GROUP  = a.operation_group
																),0) AS boh							'+CHAR(10);
				END
			ELSE
				BEGIN
					SET @mEXEC = @mEXEC+' 			,  isnull((SELECT psi_boh_qty
															FROM #BOH_A X WITH  (NOLOCK) 
															WHERE 0 = 0						
		 														AND  X.ITEM_ID          = a.item_id
																AND  X.site_id          = a.from_site
																AND  X.OPERATION_GROUP  = a.operation_group
																),0) AS boh							'+CHAR(10);
				END

			--SET @mEXEC = @mEXEC+' 			, case when substring(from_site, 1, 4) = substring(to_site, 1, 4)										      '+CHAR(10);
			--SET @mEXEC = @mEXEC+' 				then	dateadd(day, isnull( (select isnull(ship_frozen , 0) as ship_frozen from scm_mst_site where division_id=''' + @p_division_id + ''' and scm_site_id= from_site ) , 0) ,  convert(date , '''+ @p_plan_start_yyyymmdd + ''', 112)) 	'+CHAR(10);
			--SET @mEXEC = @mEXEC+' 				else	(select convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112))		'  +CHAR(10);
			--SET @mEXEC = @mEXEC+' 			 end as SHIP_FROZEN																						  '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, case when substring(a.from_site, 1, 4) = substring(a.to_site, 1, 4)										      '+CHAR(10);
			IF @p_division_id = 'EE'
				BEGIN SET @mEXEC = @mEXEC+' 				then	dateadd(day, isnull( (select isnull(ship_frozen , 0) as ship_frozen from scm_mst_site where division_id = a.origin_from_division_id and scm_site_id= a.from_site ) , 0) ,  convert(date , '''+ @p_plan_start_yyyymmdd + ''', 112)) 	'+CHAR(10); END
			ELSE
				BEGIN SET @mEXEC = @mEXEC+' 				then	dateadd(day, isnull( (select isnull(ship_frozen , 0) as ship_frozen from scm_mst_site where division_id = a.division_id and scm_site_id= a.from_site ) , 0) ,  convert(date , '''+ @p_plan_start_yyyymmdd + ''', 112)) 	'+CHAR(10); END

			SET @mEXEC = @mEXEC+' 				else	(select convert(date , DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()) , 112))		'  +CHAR(10);
			SET @mEXEC = @mEXEC+' 			 end as SHIP_FROZEN																						  '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			'+@mQry_sum	;
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0010_01 a																		      '+CHAR(10);
			SET @mEXEC = @mEXEC+'	   GROUP BY key_idx, division_id, operation_group, item_id,from_site ,to_site,bod_id ,transport_mode, lt_day,     '+CHAR(10); 
			SET @mEXEC = @mEXEC+'	   			origin_from_division_id, origin_to_division_id, electrode_type,										  '+CHAR(10);
			SET @mEXEC = @mEXEC+'	   			measure,measure_order_no,measure_label ,plan_start_yyyymmdd, plan_type, seq,from_yyyymmdd,to_yyyymmdd '+CHAR(10);
			SET @mEXEC = @mEXEC+'	   ORDER BY division_id, operation_group, item_id, from_site, to_site desc,bod_id, measure_order_no				  '+CHAR(10);
			
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
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0010_01') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0010_01;        
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0010_02') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0010_02
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0010_03') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0010_03
	
	
	---- 수정가능여부 구간 조회
	--declare @todayLimit date = convert(date , getdate() , 112 );
	
	--SELECT
	--	case
	--		when DATEDIFF(week , @todayLimit , @p_plan_start_yyyymmdd) < 0 then 'N'
	--		when a.PLAN_TYPE ='FN' then 'N'			
	--		when a.PLAN_TYPE ='MA' and confirm_yn='Y' then 'Y'
	--		when a.PLAN_TYPE ='SE' then 'Y'
	--		when a.PLAN_TYPE ='PR' then 'N'		-- 2018-05-16 PR 수정 못하도록
	--		else 'N'
	--	end as is_editable
	--	--'Y' as is_editable
	--	, convert(date , @p_plan_start_yyyymmdd, 112) as plan_start_date
	--FROM (
	--		SELECT   d.division_id
	--				,p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(CONVERT(NVARCHAR,d.plan_seq),2)  AS plan_version_id
	--				,p.plan_name
	--				,d.plan_seq
	--				,d.plan_type	
	--				,vv.CONFIRM_FLAG
	--				,p.plan_name as plan_start_yyyymmdd
	--				,CASE WHEN ISNULL(d.CONFIRM_FLAG,'')='' THEN 'N' ELSE d.CONFIRM_FLAG END AS confirm_yn		
	--		FROM scm_mst_plan_detail d
	--		inner join scm_mst_modeling m on m.modeling_id = d.modeling_id	and m.plan_cycle  = 'WEEKLY' and m.division_id = d.division_id	and m.modeling_id = d.modeling_id
	--		inner join scm_mst_plan p on p.division_id = d.division_id	and p.plan_cycle  = m.plan_cycle and p.plan_id     = d.plan_id
	--		inner join SCP_PLAN_VERSION_V vv on d.division_id = vv.division_id and d.plan_type   = vv.plan_type	and d.plan_seq    = vv.plan_seq	and p.plan_name   = vv.plan_start_yyyymmdd
	--		WHERE 1=1
	--		and d.division_id = @p_division_id
	--		and d.plan_type   = @p_plan_type
	--		and d.plan_seq    = @p_seq
	--		and p.plan_name   = @p_plan_start_yyyymmdd	) a
	--   ,(SELECT basis_start_date	FROM scm_sys_calendar_m	WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)) b;
	--;

	-- 05/25
	-- FIX 추가관련
	--SELECT 
	--	(a.division_id + a.biz_type + a.item_id + a.from_site) as key_idx 
	--	, FIX_ID
	--	, to_site
	--	, bod_id
	--	,'D_'+yyyymmdd AS yyyymmdd
	--from SCP_ANL_SHIPMENT_PLAN_FIX a
	--where division_id = @p_division_id
	--and biz_type= @p_operation_group
	--and ( (@p_item_id is null or @p_item_id = '') or a.ITEM_ID in (select token from dbo.String_Split(@p_item_id, ',')) )
	--;

END

