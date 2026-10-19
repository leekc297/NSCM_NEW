
/*
 * Program ID   : SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL
 * Description  : Shipment Plan Confrim
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/03/12   hwyoon			[PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
 * 2019/06/17	mcTheJ			[PJ20189106] 전지.GSCM 고도화 이행 삭제 Data Flag 추가 및 검색 추가
 *
 ex)
EXEC SSP0001_GET_SHIPMENT_PLAN_CONFIRM @p_division_id='40,81,82', @p_from_site='', @p_item_id='', @p_plan_start_yyyymmdd='20180515', @p_plan_type='', @p_from_yyyymmdd='20180515', @p_to_yyyymmdd='20180617', @p_user_id='addio777', @p_program_id='SSP0001', @p_sheet_name='Shipment Plan Confirm', @debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SSP0016_GET_SHIPMENT_REQUEST_PLAN_SMALL]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(2)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_program_id			NVARCHAR(MAX) = 'SSP0001' 
	,@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan Confirm'
	,@debug_mode			NVARCHAR(1)='F'
	,@delete_flag			NVARCHAR(1)
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
	IF (@debug_mode ='T')
		print '@v_cnt_usr_measure=' +convert(varchar,@v_cnt_usr_measure);


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0016_TMP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SSP0016_TMP

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0016_MEASURE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SSP0016_MEASURE

	CREATE TABLE #TblDynamicPivot_SSP0016_TMP
	(
		DIVISION_ID				NVARCHAR(60),
		PLAN_START_YYYYMMDD		NVARCHAR(16),
		PLAN_TYPE				NVARCHAR(100),
		SEQ						BIGINT,
		ITEM_ID					NVARCHAR(100),
		FROM_SITE				NVARCHAR(60),
		REQ_MST_ID				NVARCHAR(60),
		MEASURE					NVARCHAR(100),
		PSI_VALUE				NVARCHAR(300),
		measure_name			NVARCHAR(300),
		SORT_ORDER_NO			INT,
		YYYYMMDD				NVARCHAR(16),
		YYYYMM					NVARCHAR(12),
		ISO_WEEK				NVARCHAR(10),
		QTY						NUMERIC(20,10)
	);

	/* 유저 MEASURE 세팅값 추출 */ 
	SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME, ISNULL(U.sort_order_no, M.SORT_ORDER_NO)SORT_ORDER_NO, M.ATTRIBUTE1 AS PSI_VALUE
	INTO #TblDynamicPivot_SSP0016_MEASURE
	FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	LEFT JOIN SCM_MST_TITLESET_USER U ON U.program_id  = M.program_id AND U.sheet_name  = M.sheet_name
										AND U.column_name = M.column_name AND U.user_id = @p_user_id
	WHERE M.PROGRAM_ID=@p_program_id
	AND M.SHEET_NAME=@p_sheet_name
	AND M.VALID_YN='Y'
	and (@v_cnt_usr_measure=0 or ISNULL(U.SORT_ORDER_NO,0)>0)
	
	IF @delete_flag = 'Y'
	BEGIN
		INSERT INTO #TblDynamicPivot_SSP0016_TMP
		SELECT   
			A.DIVISION_ID,				A.PLAN_START_YYYYMMDD,								A.PLAN_TYPE,			A.SEQ,
			A.ITEM_ID,					A.FROM_SITE,										A.REQ_MST_ID,			A.MEASURE,
			M.PSI_VALUE,				M.column_label_name as measure_name,				m.sort_order_no,		'D_'+ A.yyyymmdd AS yyyymmdd,
			o.basis_yyyymm AS yyyymm,	RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week,	A.QTY
		FROM SSP_ANL_SHIP_REQ_D a	WITH(NOLOCK)
		JOIN #TblDynamicPivot_SSP0016_MEASURE M ON M.COLUMN_NAME=A.MEASURE
		INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd	
		WHERE 1=1 
		  AND a.yyyymmdd			  >= @p_from_yyyymmdd
		  AND a.yyyymmdd			  <= @p_to_yyyymmdd		
		  AND a.division_id	       = @p_division_id
		  AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		  AND a.plan_type            = @p_plan_type
		  AND a.seq				   = @p_seq
		  AND a.biz_type			= 'A'
		  AND ( ( @p_from_site IS NULL OR     @p_from_site	='' ) OR a.FROM_SITE	IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_from_site,',')) )
		  AND ( ( @p_item_id IS NULL OR		@p_item_id		='' ) OR a.ITEM_ID		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_item_id,',')) )
		;
	END
	ELSE
	BEGIN
		INSERT INTO #TblDynamicPivot_SSP0016_TMP
		SELECT   
			A.DIVISION_ID,				A.PLAN_START_YYYYMMDD,								A.PLAN_TYPE,			A.SEQ,
			A.ITEM_ID,					A.FROM_SITE,										A.REQ_MST_ID,			A.MEASURE,
			M.PSI_VALUE,				M.column_label_name as measure_name,				m.sort_order_no,		'D_'+ A.yyyymmdd AS yyyymmdd,
			o.basis_yyyymm AS yyyymm,	RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week,	A.QTY
		FROM SSP_ANL_SHIP_REQ a	WITH(NOLOCK)
		JOIN #TblDynamicPivot_SSP0016_MEASURE M ON M.COLUMN_NAME=A.MEASURE
		INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd	
		WHERE 1=1 
		  AND a.yyyymmdd			  >= @p_from_yyyymmdd
		  AND a.yyyymmdd			  <= @p_to_yyyymmdd		
		  AND a.division_id	       = @p_division_id
		  AND a.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
		  AND a.plan_type            = @p_plan_type
		  AND a.seq				   = @p_seq
		  AND a.biz_type			= 'A'
		  AND ( ( @p_from_site IS NULL OR     @p_from_site	='' ) OR a.FROM_SITE	IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_from_site,',')) )
		  AND ( ( @p_item_id IS NULL OR		@p_item_id		='' ) OR a.ITEM_ID		IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_item_id,',')) )
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
		SELECT  @mQuery = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END ) AS ' + yyyymmdd
											WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN  QTY  END ) AS ' + yyyymmdd
											WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  END ) AS ' + yyyymmdd
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
			SET @mEXEC = @mEXEC+'       SELECT  (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = a.item_id) as nick_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'				, S.SITE_DESCRIPTION '+CHAR(10);
			SET @mEXEC = @mEXEC+'				, S.OPERATION_GROUP AS BIZ_TYPE '+CHAR(10);
			SET @mEXEC = @mEXEC+'				, a.*			'+CHAR(10);
			SET @mEXEC = @mEXEC+'       FROM(					'+CHAR(10);
			SET @mEXEC = @mEXEC+'       SELECT					'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	 a.division_id		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.plan_start_yyyymmdd	'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.plan_type		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.seq				'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.item_id			'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.from_site		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.req_mst_id		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.measure			'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.psi_value		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.measure_name		'+CHAR(10);
			SET @mEXEC = @mEXEC+'       	,a.sort_order_no	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			'+@mQuery	;
			SET @mEXEC = @mEXEC+'       FROM #TblDynamicPivot_SSP0016_TMP a'+CHAR(10);
			SET @mEXEC = @mEXEC+' 	    WHERE 1=1	'+CHAR(10) ;
			SET @mEXEC = @mEXEC+'		GROUP BY  a.division_id, a.plan_start_yyyymmdd, a.plan_type, a.seq, a.item_id, a.from_site, a.measure, a.psi_value, a.measure_name, a.sort_order_no, a.req_mst_id '+CHAR(10);
			SET @mEXEC = @mEXEC+'	) a	'+CHAR(10);
			SET @mEXEC = @mEXEC+'	JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.DIVISION_ID=A.DIVISION_ID AND S.SCM_SITE_ID=A.FROM_SITE	'+CHAR(10);
			SET @mEXEC = @mEXEC+'	order by a.division_id, a.from_site, a.item_id, a.sort_order_no 	'+CHAR(10);

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
	
		--임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0016_TMP') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0016_TMP

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0016_MEASURE') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SSP0016_MEASURE	

END

