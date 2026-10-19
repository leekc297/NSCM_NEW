/*
 * Program ID   : SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL
 * Description  : Shipment Request Small
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019-04-23   mcthej          Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019-05-23   mcthej          start date 추가
 * 2019/12/02	KIMYONGHO       [C20191202-000223] GSCM Shipment Reqeust(IT&Mobile) RTF_System(SCP shipping plan) 추가 요청의 건
 *
 ex)
EXEC SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL
 */
CREATE PROCEDURE [dbo].[SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL_DETAIL_ALL]
	 @p_division_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_measure				NVARCHAR(MAX) = 'SHIP_REQ'
	,@debug_mode			NVARCHAR(1)='F'
	,@delete_flag			NVARCHAR(1)
AS
BEGIN
	

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_data_start_yyyymmdd	NVARCHAR(8) = ''; -- BOH계산을 위한 기준 일자  

	--// 3. 최근 REQ 정보 확인 /////////////////////////////////////////////////////////////////--
	SELECT 
		@v_data_start_yyyymmdd =  MAX(REQ_IN_START_DATE)  -- 해당 REQ에 입력시작일자부터 계산 
	FROM SSP_MST_SHIP_REQ WITH(NOLOCK)
	WHERE PLAN_TYPE    = 'SP'
		AND DIVISION_ID  = @p_division_id 
		--AND CONFIRM_FLAG = 'Y'
		AND PLAN_START_YYYYMMDD = (
									SELECT MAX(PLAN_START_YYYYMMDD)
									FROM SSP_MST_SHIP_REQ T WITH(NOLOCK)
									WHERE T.DIVISION_ID = @p_division_id 
										AND T.PLAN_TYPE   = 'SP'
										AND T.CUTOFF_FLAG = 'Y'
								);
	--// 3. END /////////////////////////////////////////////////////////////////////////////////--

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0016_DT_ALL') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SSP0016_DT
	
	IF OBJECT_ID('tempdb..#Temp_Table_All') IS NOT NULL	
		DROP TABLE #Temp_Table_All

	CREATE TABLE #TblDynamicPivot_SSP0016_DT_ALL
	(
		DIVISION_ID				NVARCHAR(60),
		PLAN_START_YYYYMMDD		NVARCHAR(16),
		PLAN_TYPE				NVARCHAR(100),
		SEQ						BIGINT,
		ITEM_ID					NVARCHAR(100),
		FROM_SITE				NVARCHAR(60),
		TO_SITE					NVARCHAR(MAX),
		MEASURE					NVARCHAR(100),
		BOD_ID					NVARCHAR(300),
		ROUTE_ID				BIGINT,
		INCOTERMS				NVARCHAR(20),
		TRANSPORT_MODE			NVARCHAR(100),
		BIZ_TYPE				NVARCHAR(60),
		PROJECT_CODE			NVARCHAR(100),
		FCST_TYPE				NVARCHAR(40),
		YYYYMMDD				NVARCHAR(16),
		YYYYMM					NVARCHAR(12),
		ISO_WEEK				NVARCHAR(10),
		REQ_GRP_ID				NVARCHAR(60),
		REQ_DET_ID				NVARCHAR(60),
		QTY						NUMERIC(20,10),
		LAST_UPDATE_DATE		DATETIME,
		REMARKS3				NVARCHAR(255),
		CREATED_BY				NVARCHAR(155),
		LAST_UPDATED_BY			NVARCHAR(150),
		TO_SITE1				NVARCHAR(60),
	);

	IF @delete_flag = 'Y'
	BEGIN
		INSERT INTO #TblDynamicPivot_SSP0016_DT_ALL
SELECT 
			T0.DIVISION_ID,				T0.PLAN_START_YYYYMMDD,				T0.PLAN_TYPE,									T0.SEQ
			, T0.ITEM_ID,				T0.FROM_SITE,						T0.TO_SITE AS TO_SITE,					T0.MEASURE
			, T0.BOD_ID,				T0.ROUTE_ID,						T0.INCOTERMS,									T0.TRANSPORT_MODE
			, T0.BIZ_TYPE,				T0.PROJECT_CODE,					T0.FCST_TYPE,									'D_'+ T0.yyyymmdd AS yyyymmdd
			, T1.basis_yyyymm AS yyyymm,									RIGHT(T1.basis_yyyymm, 4)+T1.iso_week AS iso_week
			, T0.REQ_GRP_ID,			T0.REQ_DET_ID,						T0.QTY,											T0.LAST_UPDATE_DATE
			, T0.REMARKS3,				T0.CREATED_BY,						T0.LAST_UPDATED_BY,								T0.TO_SITE AS To_Site1
		FROM SSP_ANL_SHIP_REQ_D T0 WITH(NOLOCK)
		INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) T1 
			ON T0.yyyymmdd = T1.basis_yyyymmdd
		WHERE T0.DIVISION_ID  		= @p_division_id
		AND   T0.PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd
		AND   T0.SEQ = 1 
		AND   T0.QTY > 0 
		AND   T0.MEASURE  IN ( 'SHIP_REQ','RTF_SCP')
		AND ( ( @p_item_id IS NULL OR		@p_item_id		='' ) OR T0.ITEM_ID		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_item_id,',')) )
		AND   ISNULL(T0.CREATED_BY,'-') IN(  select
												distinct TT1.UserID
														from
														(
															SELECT 
																UserID
															FROM TB_FX_User
															WHERE 1 = 1
															AND  ( ( @p_user_id IS NULL OR		@p_user_id		='' )	OR UserID		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_user_id,',')) )
															UNION ALL
															SELECT 
																UserID
															FROM TB_FX_User
															WHERE 1 = 1
															AND  ( ( @p_user_id IS NULL OR		@p_user_id		='' )   OR UserName		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_user_id,',')) )
														) TT1
											 UNION SELECT '-'
														
										) 
		AND T0.YYYYMMDD >= @v_data_start_yyyymmdd
		AND T0.ATTRIBUTE2 = 'D';
	END
	ELSE
	BEGIN
		INSERT INTO #TblDynamicPivot_SSP0016_DT_ALL
	SELECT 
			T0.DIVISION_ID,				T0.PLAN_START_YYYYMMDD,				T0.PLAN_TYPE,									T0.SEQ
			, T0.ITEM_ID,				T0.FROM_SITE,						T0.TO_SITE AS TO_SITE,					T0.MEASURE
			, T0.BOD_ID,				T0.ROUTE_ID,						T0.INCOTERMS,									T0.TRANSPORT_MODE
			, T0.BIZ_TYPE,				T0.PROJECT_CODE,					T0.FCST_TYPE,									'D_'+ T0.yyyymmdd AS yyyymmdd
			, T1.basis_yyyymm AS yyyymm,									RIGHT(T1.basis_yyyymm, 4)+T1.iso_week AS iso_week
			, T0.REQ_GRP_ID,			T0.REQ_DET_ID,						T0.QTY,											T0.LAST_UPDATE_DATE
			, T0.REMARKS3,				T0.CREATED_BY,						T0.LAST_UPDATED_BY,								T0.TO_SITE AS To_Site1
		FROM SSP_ANL_SHIP_REQ T0 WITH(NOLOCK)
		INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) T1 
			ON T0.yyyymmdd = T1.basis_yyyymmdd
		WHERE T0.DIVISION_ID  		= @p_division_id
		AND   T0.PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd
		AND   T0.SEQ = 1 
		AND   T0.QTY > 0 
		AND   T0.MEASURE  IN ( 'SHIP_REQ','RTF_SCP')
     	AND ( ( @p_item_id IS NULL OR		@p_item_id		='' ) OR T0.ITEM_ID		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_item_id,',')) )
		AND   ISNULL(T0.CREATED_BY,'-') IN(  select
												distinct TT1.UserID
														from
														(
															SELECT 
																UserID
															FROM TB_FX_User
															WHERE 1 = 1
															AND  ( ( @p_user_id IS NULL OR		@p_user_id		='' )	OR UserID		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_user_id,',')) )
															UNION ALL
															SELECT 
																UserID
															FROM TB_FX_User
															WHERE 1 = 1
															AND  ( ( @p_user_id IS NULL OR		@p_user_id		='' )   OR UserName		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_user_id,',')) )
														) TT1
											 UNION SELECT '-'
														
										) 
		AND T0.YYYYMMDD >= @v_data_start_yyyymmdd;
	END;

 	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
	BEGIN
	DECLARE @mQuery NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);

	-- PIVOIT 대상 날짜문자열 생성
	SET @mQuery = '';
	SELECT  @mQuery = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY ELSE 0 END ) AS ' + yyyymmdd
										WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN  QTY ELSE 0 END ) AS ' + yyyymmdd
										WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  ELSE 0 END ) AS ' + yyyymmdd
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

	SELECT
		T0.division_id,				T0.plan_start_yyyymmdd,				T0.plan_type,				T0.seq,			T0.item_id			 
		,T0.from_site,				T0.TO_SITE,							T0.measure,					T0.bod_id			 
		,T0.route_id,				T0.incoterms,						T0.transport_mode,			T0.biz_type			 
		,T0.project_code,			T0.fcst_type,						T0.req_grp_id,				T0.RN				 
		,T0.CREATED_BY,			T0.LAST_UPDATED_BY,					T0.LAST_UPDATE_DATE,		T0.REMARKS3
	into #Temp_Table_All			
	FROM(
		SELECT
			a.division_id,	a.plan_start_yyyymmdd,	a.plan_type,		a.seq,			a.item_id,			a.from_site,		a.TO_SITE			 
			,a.measure,		a.bod_id,				a.route_id,			a.incoterms,	a.transport_mode,	a.biz_type,			a.project_code		 
			,a.fcst_type,	a.req_grp_id		  				 
			,RANK() OVER(PARTITION BY a.DIVISION_ID, a.PLAN_START_YYYYMMDD, a.PLAN_TYPE, a.SEQ, a.FROM_SITE, a.ITEM_ID, a.TO_SITE, a.project_code, a.fcst_type, a.incoterms, a.transport_mode, a.REQ_GRP_ID ORDER BY a.LAST_UPDATE_DATE desc) AS RN				 
			,a.CREATED_BY,			a.LAST_UPDATED_BY
			,max(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE		 
			,a.REMARKS3
		FROM #TblDynamicPivot_SSP0016_DT_ALL a
		WHERE 1=1
			 AND a.measure IN('SHIP_REQ','RTF_SCP')
		GROUP BY  a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq, a.item_id, a.from_site, a.to_site, a.measure  
			, a.bod_id, a.route_id, a.incoterms, a.transport_mode, a.biz_type, a.project_code, a.fcst_type, a.req_grp_id, a.CREATED_BY, a.LAST_UPDATED_BY, a.LAST_UPDATE_DATE, a.REMARKS3
	) T0

	IF( LEN(@mQuery)>0)
	SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'       SELECT  (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = a.item_id) as nick_name	'+CHAR(10);
	SET @mEXEC = @mEXEC+'				, a.transport_mode+'':''+a.bod_id+'':''+convert(nvarchar,a.route_id)+'':''+ISNULL(convert(nvarchar,V.LT_TOTAL),''0'') as BOD_TOTAL_CODE			'+CHAR(10);
	SET @mEXEC = @mEXEC+'				, ISNULL(convert(nvarchar,V.LT_TOTAL),''0'') as LT_TOTAL			'+CHAR(10);
	SET @mEXEC = @mEXEC+'				, a.*			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       FROM(					'+CHAR(10);
	SET @mEXEC = @mEXEC+'       SELECT					'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	 a.division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.plan_start_yyyymmdd	'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.plan_type		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.seq				'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.item_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.from_site		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.TO_SITE			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,(SELECT COLUMN_LABEL_NAME FROM SCM_MST_SHEET_MEASURE WHERE COLUMN_NAME = a.measure AND PROGRAM_ID  =''SSP0016'') as measure' +CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.bod_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.route_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.incoterms		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.transport_mode	'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.biz_type			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.project_code		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.fcst_type		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.req_grp_id		'+CHAR(10); 
	SET @mEXEC = @mEXEC+'       	,(SELECT UserName + ''(''+USERID+'')'' FROM TB_FX_User WHERE USERID = B.REQUEST_USER) AS REQUEST_USER				'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,(SELECT UserName + ''(''+USERID+'')'' FROM TB_FX_User WHERE USERID = B.LAST_UPDATED_BY) AS LAST_UPDATED_BY				'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,B.LAST_UPDATE_DATE		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,B.REMARKS3						'+CHAR(10);
	SET @mEXEC = @mEXEC+' 			'+@mQuery	;
	SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0016_DT_ALL a'+CHAR(10);
	SET @mEXEC = @mEXEC+'		INNER JOIN (SELECT *,  (select MAX(e.CREATED_BY) from #Temp_Table_All e where e.req_grp_id = a.req_grp_id and e.rn = (select max(f.RN) from #Temp_Table_All f where f.req_grp_id = a.req_grp_id)) as REQUEST_USER FROM #Temp_Table_All a WHERE a.RN = 1) B '+CHAR(10);
	SET @mEXEC = @mEXEC+'			ON A.req_grp_id = B.req_grp_id '+CHAR(10);
	SET @mEXEC = @mEXEC+' 	    WHERE 1=1	'+CHAR(10) ;
	SET @mEXEC = @mEXEC+' 	      AND a.measure IN (''SHIP_REQ'')	'+CHAR(10) ;
	SET @mEXEC = @mEXEC+'		GROUP BY  a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq, a.item_id, a.from_site, a.to_site, a.measure '+CHAR(10);
	SET @mEXEC = @mEXEC+'				  , a.bod_id, a.route_id, a.incoterms, a.transport_mode, a.biz_type, a.project_code, a.fcst_type, a.req_grp_id, B.REQUEST_USER,B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE,  B.REMARKS3 '+CHAR(10);
	SET @mEXEC = @mEXEC+'		UNION '+CHAR(10);
	SET @mEXEC = @mEXEC+'       SELECT					'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	 a.division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.plan_start_yyyymmdd	'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.plan_type		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.seq				'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.item_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.from_site		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.TO_SITE			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,(SELECT COLUMN_LABEL_NAME FROM SCM_MST_SHEET_MEASURE WHERE COLUMN_NAME = a.measure AND PROGRAM_ID  =''SSP0016'') as measure' +CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.bod_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.route_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.incoterms		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.transport_mode	'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.biz_type			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.project_code		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.fcst_type		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.req_grp_id		'+CHAR(10); 
	SET @mEXEC = @mEXEC+'       	,'''' AS REQUEST_USER				'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,'''' AS LAST_UPDATED_BY				'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,'''' AS LAST_UPDATE_DATE		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,'''' AS REMARKS3						'+CHAR(10);
	SET @mEXEC = @mEXEC+' 			'+@mQuery	;
	SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0016_DT_ALL a'+CHAR(10);
	SET @mEXEC = @mEXEC+' 	    WHERE 1=1	'+CHAR(10) ;
	SET @mEXEC = @mEXEC+' 	      AND a.measure IN (''RTF_SCP'')	'+CHAR(10) ;
	SET @mEXEC = @mEXEC+'		GROUP BY  a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq, a.item_id, a.from_site, a.to_site, a.measure '+CHAR(10);
	SET @mEXEC = @mEXEC+'				  , a.bod_id, a.route_id, a.incoterms, a.transport_mode, a.biz_type, a.project_code, a.fcst_type, a.req_grp_id'+CHAR(10);

	SET @mEXEC = @mEXEC+'	) a	'+CHAR(10);
	SET @mEXEC = @mEXEC+'	LEFT JOIN SCP_MST_BOD_N_V V WITH(NOLOCK) ON V.TRANSPORT_MODE=A.transport_mode	'+CHAR(10);
	SET @mEXEC = @mEXEC+'										   AND V.BOD_ID = A.bod_id	'+CHAR(10);
	SET @mEXEC = @mEXEC+'										   AND V.ROUTE_ID = A.route_id	'+CHAR(10);
	SET @mEXEC = @mEXEC+'	order by a.item_id,  a.measure, a.division_id, a.from_site, a.to_site, a.req_grp_id 	'+CHAR(10);

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


	SET @mEXEC = '';
	SET @mEXEC = @mEXEC+'       SELECT  (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = a.item_id) as nick_name '+CHAR(10);
	SET @mEXEC = @mEXEC+'				, a.*			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       FROM(					'+CHAR(10);
	SET @mEXEC = @mEXEC+'       SELECT					'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	 a.division_id		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.plan_start_yyyymmdd	'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.plan_type		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.seq				'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.item_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.from_site		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.to_site			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.measure			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.bod_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.route_id			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.incoterms		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.transport_mode	'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.biz_type			'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.project_code		'+CHAR(10);
	SET @mEXEC = @mEXEC+'       	,a.fcst_type		'+CHAR(10);
	SET @mEXEC = @mEXEC+' 			'+@mQuery	;
	SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0016_DT_ALL a'+CHAR(10);
	SET @mEXEC = @mEXEC+' 	    WHERE 1=1	'+CHAR(10) ;
	SET @mEXEC = @mEXEC+' 	      AND a.measure=''BALANCE''	'+CHAR(10) ;
	SET @mEXEC = @mEXEC+'		GROUP BY  a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq, a.item_id, a.from_site, a.to_site, a.measure '+CHAR(10);
	SET @mEXEC = @mEXEC+'				  , a.bod_id, a.route_id, a.incoterms, a.transport_mode, a.biz_type, a.project_code, a.fcst_type '+CHAR(10);
	SET @mEXEC = @mEXEC+'	) a	'+CHAR(10);
	SET @mEXEC = @mEXEC+'	order by a.division_id, a.from_site, a.item_id, a.to_site 	'+CHAR(10);

	EXEC (@mEXEC);

	END;
	
	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0016_DT_ALL') IS NOT NULL	
	DROP TABLE #TblDynamicPivot_SSP0016_DT_ALL

	IF OBJECT_ID('tempdb..#Temp_Table_All') IS NOT NULL	
	DROP TABLE #Temp_Table_All

END
