

/*
 * Program ID   : SCP0030_GET_MODEL_ALLOCATION
 * Description  : Model Allocation 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/09   hwyoon			Initial Release [PJ20189106] 전지GSCM 고도화
 *
 */

CREATE PROCEDURE [dbo].[SCP0046_GET_MODEL_ALLOCATION]
	@p_division_id	NVARCHAR(50)='',
	@p_cell_plant_site_id	NVARCHAR(MAX)='',
	@p_cell_item_id			NVARCHAR(MAX)='',
	@p_cell_line_id			NVARCHAR(MAX)='',
	@p_elec_plant_site_id	NVARCHAR(MAX)='',
	@p_elec_item_id			NVARCHAR(MAX)='',
	@p_elec_line_id			NVARCHAR(MAX)='',
	@p_from_yyyymmdd		NVARCHAR(8)='',
	@p_to_yyyymmdd			NVARCHAR(8)='',
	@p_program_id			NVARCHAR(300)='SCP0046',
	@p_sheet_name			NVARCHAR(150)='Model Allocation',
	@p_user_id				NVARCHAR(300)='',
	@debug_mode				NVARCHAR(1)='T'
AS
BEGIN
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	-- ROW DATA 용
	IF OBJECT_ID('tempdb..#TblDynamic_BASE_ROW') IS NOT NULL	
		DROP TABLE #TblDynamic_BASE_ROW;

	
	SELECT A.DIVISION_ID
		   , A.CELL_PLANT_SITE_ID
		   , A.CELL_ITEM_ID
		   , ISNULL(i.nick_name, '')  AS CELL_NICK_NAME
		   , A.CELL_LINE_ID
		   , A.ELEC_PLANT_SITE_ID
		   , A.ELEC_ITEM_ID
		   , A.ELEC_LINE_ID
		   , A.TR_MODE
		   , A.YYYYMMDD
		   , A.VALID_YN
	INTO #TblDynamic_BASE_ROW
	FROM SCP_MST_MODEL_ALLOCATION A WITH(NOLOCK)
	LEFT JOIN (SELECT item_id, MAX(ISNULL(nick_name,'')) AS nick_name
				FROM   DBO.SCM_MST_ITEM_SN WITH(NOLOCK)
				WHERE  nick_name IS NOT NULL 
				GROUP BY item_id
				) i ON  A.CELL_ITEM_ID = i.item_id
	WHERE A.DIVISION_ID = @p_division_id
	AND A.YYYYMMDD >= @p_from_yyyymmdd
	AND A.YYYYMMDD <= @p_to_yyyymmdd
	AND ( ( @p_cell_plant_site_id IS NULL OR @p_cell_plant_site_id ='' ) OR A.CELL_PLANT_SITE_ID         IN (SELECT token FROM dbo.String_Split(@p_cell_plant_site_id    ,',')) )
	AND ( ( @p_cell_item_id IS NULL OR @p_cell_item_id ='' ) OR A.CELL_ITEM_ID         IN (SELECT token FROM dbo.String_Split(@p_cell_item_id    ,',')) )
	AND ( ( @p_cell_line_id IS NULL OR @p_cell_line_id ='' ) OR A.CELL_LINE_ID         IN (SELECT token FROM dbo.String_Split(@p_cell_line_id    ,',')) )
	AND ( ( @p_elec_plant_site_id IS NULL OR @p_elec_plant_site_id ='' ) OR A.ELEC_PLANT_SITE_ID         IN (SELECT token FROM dbo.String_Split(@p_elec_plant_site_id    ,',')) )
	AND ( ( @p_elec_item_id IS NULL OR @p_elec_item_id ='' ) OR A.ELEC_ITEM_ID         IN (SELECT token FROM dbo.String_Split(@p_elec_item_id    ,',')) )
	--AND ( ( @p_elec_line_id IS NULL OR @p_elec_line_id ='' ) OR A.ELEC_LINE_ID         IN (SELECT token FROM dbo.String_Split(@p_elec_line_id    ,',')) )
	;


	/********************************************************************************      
	* PIVOIT처리      
	********************************************************************************/
	BEGIN
		DECLARE @mQry_sum NVARCHAR(MAX);
		DECLARE @mEXEC NVARCHAR(MAX);
		DECLARE @mDAY_QTY NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';
		SET @mQry_sum = '';

		SELECT  @mQry_sum = @mQry_sum+','+  'MAX(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN VALID_YN END) AS ' + 'D_'+yyyymmdd  +CHAR(10)
		FROM ( 
			SELECT a.basis_yyyymmdd   AS yyyymmdd      
					, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM [dbo].[scm_sys_calendar_m] a 
				WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd	
		) AS A
		
		SET @mEXEC = '';
		SET @mEXEC = @mEXEC+'       SELECT															'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	 A.DIVISION_ID												'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	,A.CELL_PLANT_SITE_ID													'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	,A.CELL_ITEM_ID		'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	,A.CELL_NICK_NAME		'+CHAR(10);
		SET @mEXEC = @mEXEC+' 			,A.CELL_LINE_ID												'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	,A.ELEC_PLANT_SITE_ID													'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	,A.ELEC_ITEM_ID													'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	,A.ELEC_LINE_ID												'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	,A.TR_MODE													'+CHAR(10);
		SET @mEXEC = @mEXEC+'       	'+@mQry_sum+CHAR(10);
		SET @mEXEC = @mEXEC+'       FROM #TblDynamic_BASE_ROW A WITH(NOLOCK)								'+CHAR(10);
		SET @mEXEC = @mEXEC+'		GROUP BY  A.DIVISION_ID, A.CELL_PLANT_SITE_ID, A.CELL_ITEM_ID, A.CELL_NICK_NAME, A.CELL_LINE_ID, A.ELEC_PLANT_SITE_ID, A.ELEC_ITEM_ID, A.ELEC_LINE_ID, A.TR_MODE '+CHAR(10);
		SET @mEXEC = @mEXEC+'		ORDER BY  A.DIVISION_ID, A.CELL_ITEM_ID, A.CELL_PLANT_SITE_ID, A.CELL_LINE_ID, A.ELEC_PLANT_SITE_ID'+CHAR(10);
		
			
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
	IF OBJECT_ID('tempdb..#TblDynamic_BASE_ROW') IS NOT NULL	
		DROP TABLE #TblDynamic_BASE_ROW;


END

