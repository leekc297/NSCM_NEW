


/*
 * Program ID   : SCP0091_GET_VALIDATION_SHIPMENT_DATA => SCP0091_GET_VALIDATION_SHIPMENT_REPORT
 * Description  : 운송중재고 Report
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/03/22   vadabi3	최조생성
 * 2022/07/07   vadabi3	plant_site_id ( LIKE => IN )
 * 2022/07/14   vadabi3 Shipment no 로만 매핑 
 * 2022/08/07   vadabi3 Shipment no => FN_GET_SHIPMENT_NO_DISPLAY
 * 2022/08/08   vadabi3 RESULT DATE 범위 일 때 정렬순서 적용
 * 2023/03/29   vadabi3 F_DEST_ETA_DATE 개선
 ----------------------------------------------------------------------------------------------------
 EXEC SCP0091_GET_VALIDATION_SHIPMENT_REPORT 
 @p_division_id='81'
,@p_plant_site_id=''
,@p_sales_site_id=''
,@p_project_code=''
,@p_item_id=''
,@p_from_yyyymmdd='20220906'
,@p_to_yyyymmdd='20220906'
,@p_result_type='I'
,@p_bucket_type='DAILY'
,@p_period_from='20220906'
,@p_period_to='20230906'
,@p_user_id='vadabi3'
,@p_operation_group=NULL

  *===================================================================================================
 참고 = SCP0077_GET_SHIPPING_RESULT_CHECK
 */

--CREATE PROCEDURE [dbo].[SCP0091_GET_VALIDATION_SHIPMENT_REPORT]
CREATE PROCEDURE [dbo].[SCP0091_GET_VALIDATION_SHIPMENT_REPORT]
  @p_division_id     NVARCHAR(MAX),
  @p_plant_site_id   NVARCHAR(MAX),    
  @p_sales_site_id   NVARCHAR(MAX),    
  @p_project_code    NVARCHAR(MAX),
  @p_item_id		 NVARCHAR(MAX),
  @p_from_yyyymmdd	 NVARCHAR(8),
  @p_to_yyyymmdd	 NVARCHAR(8),
  @p_result_type	 NVARCHAR(1),
  @p_bucket_type	 NVARCHAR(10),
  @p_period_from	 NVARCHAR(8),
  @p_period_to	     NVARCHAR(8),
  @p_user_id	     NVARCHAR(30),
  @p_operation_group	NVARCHAR(MAX)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	--##############################################################################
	-- 변수선언
	--##############################################################################
	DECLARE @v_program_id			NVARCHAR(10)	= 'SCP0091';
	DECLARE @v_sheet_name			NVARCHAR(50)	= 'REPORT';
	DECLARE @COLUMNS			NVARCHAR(MAX)
	DECLARE @COLUMNS_DAILY		NVARCHAR(MAX)
	DECLARE @COLUMNS_WEEKLY		NVARCHAR(MAX)
	DECLARE @COLUMNS_MONTHLY	NVARCHAR(MAX)
	DECLARE @V_COLUMN_INDEX INT = 0;
	DECLARE @mEXEC_HEADER	NVARCHAR(4000) = '';
	DECLARE @mEXEC_SELECT	NVARCHAR(4000) = '';
	DECLARE @mEXEC_GROUP_BY NVARCHAR(4000) = '';
	DECLARE @mEXEC_ORDER_BY NVARCHAR(4000) = '';
	DECLARE @COL_HEADER		NVARCHAR(4000) = '';
	DECLARE @COL_SELECT		NVARCHAR(4000) = '';
	DECLARE @COL_GROUP_BY	NVARCHAR(4000) = '';
	DECLARE @COL_ORDER_BY	NVARCHAR(4000) = '';
	DECLARE @SQL				NVARCHAR(MAX)

	DECLARE @POS INT = 0;
	DECLARE @LEN INT = 0;
	DECLARE @V_CNT_USR_COLUMN	int = 0;
	DECLARE @V_INDEX INT = 0;

	DECLARE @mEXEC NVARCHAR(MAX);
	DECLARE @COL NVARCHAR(100) = '';
	DECLARE @SORT_METHOD_CODE NVARCHAR(20) = '';

	DECLARE @v_division_id			NVARCHAR(50)	= @p_division_id;
	DECLARE @v_user_id				NVARCHAR(100)	= @p_user_id;

	/*--------------------------------------------
	SHIPMENT_RESULT_TYPE
	--------------------------------------------
	I	Intransit(GTS)
	C	법인간 운송중 재고
	S	Intransit(출하실적기반:Non GTS)
	P	Plant Issue
	B	SO Reserved Stock
	*/





	--##############################################################################
	-- Monthly, Weekly, Daily
	--##############################################################################
	SET @COLUMNS = ''
	SET @COLUMNS_WEEKLY = ''
	SET @COLUMNS_MONTHLY = ''
	SET @COLUMNS_DAILY	 = ''


		/********************************************************************************
		-- WEEKLY
		********************************************************************************/
			SELECT @COLUMNS_WEEKLY = @COLUMNS_WEEKLY + '[W_' + yyyymmdd + '],'
				  FROM (
         									  SELECT 
													distinct concat(calendar.basis_yyyymm, iso_week)  as yyyymmdd
												FROM  scm_dnm_intransit_c sdic
												LEFT JOIN scp_mst_bod_n_v smbv
													ON    sdic.division_id = smbv.division_id
													AND   sdic.from_scm_site_id = smbv.from_site
													AND   sdic.to_scm_site_id = smbv.to_site
													ANd   sdic.incoterms = smbv.incoterms
													AND   sdic.transport_mode = smbv.transport_mode
													AND   smbv.bod_valid_yn = 'Y'
													AND   smbv.route_valid_yn = 'Y'
													AND   sdic.result_date >= smbv.from_yyyymmdd
													AND   sdic.result_date <= smbv.to_yyyymmdd

												LEFT JOIN scm_sys_calendar_m calendar on calendar.BASIS_yyyymmdd =  CASE 
																													when result_type = 'B' and  isnull(sdic.ATTRIBUTE3,'')= '' then F_DEST_ETA_DATE
																													WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) <  convert(char(8), convert(datetime, sdic.result_date), 112) 
																													THEN convert(char(8), convert(datetime, sdic.result_date), 112)
																													ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)
																													END
												  WHERE (isnull(@p_division_id,   '' ) = '' OR sdic.division_id   IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
													--AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id like '%' + @p_plant_site_id + '%') --sdic.from_scm_site_id 
													AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',')) ) --20220706  Equal => IN 으로 변경
													AND (isnull(@p_sales_site_id, '' ) = '' OR sdic.to_scm_site_id like '%' + @p_sales_site_id + '%') --sdic.to_scm_site_id   IN ( SELECT token FROM dbo.String_Split(@p_sales_site_id,',')) )
													AND (isnull(@p_project_code,  '' ) = '' OR sdic.project_code  IN ( SELECT token FROM dbo.String_Split(@p_project_code ,',')) )
													AND (isnull(@p_item_id,       '' ) = '' OR sdic.item_id       IN ( SELECT token FROM dbo.String_Split(@p_item_id		 ,',')) )
													AND sdic.result_date >= @p_from_yyyymmdd
													AND sdic.result_date <= @p_to_yyyymmdd
													--AND ISNULL(sdic.ATTRIBUTE3,'') >= @p_period_from
													--AND ISNULL(sdic.ATTRIBUTE3,'') <= @p_period_to
													/*
													AND sdic.RESULT_TYPE = @p_result_type
													--------------------------------------------
													SHIPMENT_RESULT_TYPE
													--------------------------------------------
													I	Intransit(GTS)
													C	법인간 운송중 재고
													S	Intransit(출하실적기반:Non GTS)
													P	Plant Issue
													B	SO Reserved Stock
													*/
													AND sdic.RESULT_TYPE in ('I','C','B')
													AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''
					   ) AS months
				 ORDER BY yyyymmdd



							--##############################################################################
							-- 20230329 Weekly 의 @p_from_yyyymmdd, @p_to_yyyymmdd 개선 / ACEH1057I-B1-000
							--##############################################################################
							IF OBJECT_ID('tempdb..#TMP_WEEKLY_TERM') IS NOT NULL	
							DROP TABLE #TMP_WEEKLY_TERM;

							 SELECT 
								distinct concat(calendar.basis_yyyymm, iso_week)  as yyyymmdd
								INTO #TMP_WEEKLY_TERM
								FROM  scm_dnm_intransit_c sdic
								LEFT JOIN scp_mst_bod_n_v smbv
									ON    sdic.division_id = smbv.division_id
									AND   sdic.from_scm_site_id = smbv.from_site
									AND   sdic.to_scm_site_id = smbv.to_site
									ANd   sdic.incoterms = smbv.incoterms
									AND   sdic.transport_mode = smbv.transport_mode
									AND   smbv.bod_valid_yn = 'Y'
									AND   smbv.route_valid_yn = 'Y'
									AND   sdic.result_date >= smbv.from_yyyymmdd
									AND   sdic.result_date <= smbv.to_yyyymmdd

								LEFT JOIN scm_sys_calendar_m calendar on calendar.BASIS_yyyymmdd =  CASE 
																									when result_type = 'B' and  isnull(sdic.ATTRIBUTE3,'')= '' then F_DEST_ETA_DATE
																									WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) <  convert(char(8), convert(datetime, sdic.result_date), 112) 
																									THEN convert(char(8), convert(datetime, sdic.result_date), 112)
																									ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)
																									END
									WHERE (isnull(@p_division_id,   '' ) = '' OR sdic.division_id   IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
									--AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id like '%' + @p_plant_site_id + '%') --sdic.from_scm_site_id 
									AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',')) ) --20220706  Equal => IN 으로 변경
									AND (isnull(@p_sales_site_id, '' ) = '' OR sdic.to_scm_site_id like '%' + @p_sales_site_id + '%') --sdic.to_scm_site_id   IN ( SELECT token FROM dbo.String_Split(@p_sales_site_id,',')) )
									AND (isnull(@p_project_code,  '' ) = '' OR sdic.project_code  IN ( SELECT token FROM dbo.String_Split(@p_project_code ,',')) )
									AND (isnull(@p_item_id,       '' ) = '' OR sdic.item_id       IN ( SELECT token FROM dbo.String_Split(@p_item_id		 ,',')) )
									AND sdic.result_date >= @p_from_yyyymmdd
									AND sdic.result_date <= @p_to_yyyymmdd
									--AND ISNULL(sdic.ATTRIBUTE3,'') >= @p_period_from
									--AND ISNULL(sdic.ATTRIBUTE3,'') <= @p_period_to
									/*
									AND sdic.RESULT_TYPE = @p_result_type
									--------------------------------------------
									SHIPMENT_RESULT_TYPE
									--------------------------------------------
									I	Intransit(GTS)
									C	법인간 운송중 재고
									S	Intransit(출하실적기반:Non GTS)
									P	Plant Issue
									B	SO Reserved Stock
									*/
									AND sdic.RESULT_TYPE in ('I','C','B')
									AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''


							DECLARE @p_from_yyyymmdd_week nvarchar(max);
							DECLARE @p_to_yyyymmdd_week nvarchar(max);

							SELECT @p_from_yyyymmdd_week = MIN(yyyymmdd) from #TMP_WEEKLY_TERM;
							SELECT @p_to_yyyymmdd_week   = MAX(yyyymmdd) from #TMP_WEEKLY_TERM;







	

	
		/********************************************************************************
		-- MONTHLY
		********************************************************************************/
				SELECT @COLUMNS_MONTHLY = @COLUMNS_MONTHLY + '[M_' + yyyymm + '],'
				  FROM (
         									  SELECT 
											  	    --distinct substring(sdic.F_DEST_ETA_DATE,1,6) as yyyymm
											        distinct
													case 
													when result_type = 'B' and  isnull(sdic.ATTRIBUTE3,'')= '' then F_DEST_ETA_DATE
													when isnull(sdic.ATTRIBUTE3,'')= '' then '' 
													when sdic.ATTRIBUTE3 ='' then ''
													else
														CASE 
														WHEN substring(convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112),1,6) <  substring(convert(char(8), convert(datetime, sdic.result_date), 112),1,6)
														then substring(convert(char(8), convert(datetime, sdic.result_date), 112),1,6)
														ELSE substring(convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112),1,6)
														END
													end yyyymm
												FROM  scm_dnm_intransit_c sdic
												LEFT JOIN scp_mst_bod_n_v smbv
													ON    sdic.division_id = smbv.division_id
													AND   sdic.from_scm_site_id = smbv.from_site
													AND   sdic.to_scm_site_id = smbv.to_site
													ANd   sdic.incoterms = smbv.incoterms
													AND   sdic.transport_mode = smbv.transport_mode
													AND   smbv.bod_valid_yn = 'Y'
													AND   smbv.route_valid_yn = 'Y'
													AND sdic.result_date >= smbv.from_yyyymmdd
													AND sdic.result_date <= smbv.to_yyyymmdd
												  WHERE (isnull(@p_division_id,   '' ) = '' OR sdic.division_id   IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
													--AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id like '%' + @p_plant_site_id + '%') --sdic.from_scm_site_id
													AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',')) ) --20220706  Equal => IN 으로 변경
													AND (isnull(@p_sales_site_id, '' ) = '' OR sdic.to_scm_site_id like '%' + @p_sales_site_id + '%') --sdic.to_scm_site_id   IN ( SELECT token FROM dbo.String_Split(@p_sales_site_id,',')) )
													AND (isnull(@p_project_code,  '' ) = '' OR sdic.project_code  IN ( SELECT token FROM dbo.String_Split(@p_project_code ,',')) )
													AND (isnull(@p_item_id,       '' ) = '' OR sdic.item_id       IN ( SELECT token FROM dbo.String_Split(@p_item_id		 ,',')) )
													AND sdic.result_date >= @p_from_yyyymmdd
													AND sdic.result_date <= @p_to_yyyymmdd
													--AND ISNULL(sdic.ATTRIBUTE3,'') >= @p_period_from
													--AND ISNULL(sdic.ATTRIBUTE3,'') <= @p_period_to
													/*
													AND sdic.RESULT_TYPE = @p_result_type
													--------------------------------------------
													SHIPMENT_RESULT_TYPE
													--------------------------------------------
													I	Intransit(GTS)
													C	법인간 운송중 재고
													S	Intransit(출하실적기반:Non GTS)
													P	Plant Issue
													B	SO Reserved Stock
													*/
													AND sdic.RESULT_TYPE in ('I','C','B')
													AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''
					   ) AS months
				 ORDER BY yyyymm
	
	

		/********************************************************************************
		-- @COLUMNS
		********************************************************************************/
		SELECT @COLUMNS_DAILY	 = @COLUMNS_DAILY + '[D_' + yyyymmdd + '],'
				  FROM (
         									  SELECT 
													--distinct sdic.F_DEST_ETA_DATE as yyyymmdd
													distinct
											        case 
													when result_type = 'B' and  isnull(sdic.ATTRIBUTE3,'')= '' then F_DEST_ETA_DATE
													when isnull(sdic.ATTRIBUTE3,'')= '' then '' 
													when sdic.ATTRIBUTE3 ='' then ''
													else 
															CASE 
															WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) < result_date THEN result_date
															ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)
															END
													end yyyymmdd
	
												FROM  scm_dnm_intransit_c sdic
												LEFT JOIN scp_mst_bod_n_v smbv
													ON    sdic.division_id = smbv.division_id
													AND   sdic.from_scm_site_id = smbv.from_site
													AND   sdic.to_scm_site_id = smbv.to_site
													ANd   sdic.incoterms = smbv.incoterms
													AND   sdic.transport_mode = smbv.transport_mode
													AND   smbv.bod_valid_yn = 'Y'
													AND   smbv.route_valid_yn = 'Y'
													AND   sdic.result_date >= smbv.from_yyyymmdd
													AND   sdic.result_date <= smbv.to_yyyymmdd
													
												  WHERE (isnull(@p_division_id,   '' ) = '' OR sdic.division_id   IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
													--AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id like '%' + @p_plant_site_id + '%') --sdic.from_scm_site_id 
													AND (isnull(@p_plant_site_id, '' ) = '' OR sdic.from_scm_site_id IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',')) ) --20220706  Equal => IN 으로 변경
													AND (isnull(@p_sales_site_id, '' ) = '' OR sdic.to_scm_site_id like '%' + @p_sales_site_id + '%') --sdic.to_scm_site_id   IN ( SELECT token FROM dbo.String_Split(@p_sales_site_id,',')) )
													AND (isnull(@p_project_code,  '' ) = '' OR sdic.project_code  IN ( SELECT token FROM dbo.String_Split(@p_project_code ,',')) )
													AND (isnull(@p_item_id,       '' ) = '' OR sdic.item_id       IN ( SELECT token FROM dbo.String_Split(@p_item_id		 ,',')) )
													AND sdic.result_date >= @p_from_yyyymmdd
													AND sdic.result_date <= @p_to_yyyymmdd
													--AND sdic.ATTRIBUTE3 >= @p_period_from
													--AND sdic.ATTRIBUTE3 <= @p_period_to
													/*
													AND sdic.RESULT_TYPE = @p_result_type
													--------------------------------------------
													SHIPMENT_RESULT_TYPE
													--------------------------------------------
													I	Intransit(GTS)
													C	법인간 운송중 재고
													S	Intransit(출하실적기반:Non GTS)
													P	Plant Issue
													B	SO Reserved Stock
													*/
													AND sdic.RESULT_TYPE in ('I','C','B')
													AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''
					   ) AS months
				 ORDER BY yyyymmdd


		SET @COLUMNS = @COLUMNS_WEEKLY + @COLUMNS_MONTHLY + @COLUMNS_DAILY;

		if len(@COLUMNS) = 0
			begin
			-- no data => no result return
			select * from scm_dnm_intransit_c sdic where sdic.result_date = '12345678'
			RETURN(-1)  
			end
		else
			begin
			SET @COLUMNS = LEFT(@COLUMNS, LEN(@COLUMNS) - 1)
			end


	--##############################################################################
	-- 사용자별 사용 컬럼 COUNT = While LOOP
	--##############################################################################
	SET @V_CNT_USR_COLUMN = (
								SELECT COUNT(1) 
								FROM SCM_MST_TITLESET_USER WITH(NOLOCK) 
								WHERE 1=1
								 AND PROGRAM_ID  =  @v_program_id
								 AND SHEET_NAME  =  @v_sheet_name
								 AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
								 AND USER_ID     =  @v_user_id
							  );



	--##############################################################################
	-- 선택 COLUMN => #tmp_SCP0091_COLUMN
	--##############################################################################

 	IF OBJECT_ID('tempdb..#tmp_SCP0091_COLUMN') IS NOT NULL	
		DROP TABLE #tmp_SCP0091_COLUMN;

		SELECT A.COLUMN_NAME AS COL
			 , ROW_NUMBER() OVER( ORDER BY ISNULL(B.SORT_ORDER_NO, A.SORT_ORDER_NO ) )	AS USER_SORT_ORDER_NO
			 , ISNULL(B.DATA_SORT_METHOD_CODE , A.DATA_SORT_METHOD_CODE ) AS DATA_SORT_METHOD_CODE
		  INTO #tmp_SCP0091_COLUMN
		  FROM SCM_MST_SHEET_COLUMNS A WITH(NOLOCK) 
	 LEFT JOIN SCM_MST_TITLESET_USER B WITH(NOLOCK) 
		    ON B.PROGRAM_ID  = A.PROGRAM_ID
		   AND B.SHEET_NAME  = A.SHEET_NAME
		   AND B.COLUMN_NAME = A.COLUMN_NAME
		   AND B.USER_ID	 = @v_user_id
		   AND B.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		 WHERE A.PROGRAM_ID	= @v_program_id
		   AND A.SHEET_NAME	= @v_sheet_name
		   AND A.VALID_YN		= 'Y'
		   AND A.VISIBLE_FLAG	= 'Y'
		   AND ISNULL(NULLIF(A.USER_SELECTABLE_FLAG,''),'Y') = 'Y'  -- COLUMN 설정 창에 보이는 것들만 조회
		   AND ( @V_CNT_USR_COLUMN = 0
					OR EXISTS (SELECT 1
							     FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
								WHERE PROGRAM_ID		= @v_program_id
								  AND SHEET_NAME		= @v_sheet_name
								  AND COLUMN_NAME		= A.COLUMN_NAME
								  AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
								  AND USER_ID			= @v_user_id
								)
				  )
			;	
	SET @V_CNT_USR_COLUMN = (SELECT COUNT(1) FROM #tmp_SCP0091_COLUMN);



--##################################################################
-- Make Column -> Loop
--##################################################################
	WHILE @v_cnt_usr_column > @V_INDEX
	BEGIN
		SELECT @COL = COL
		     , @SORT_METHOD_CODE = DATA_SORT_METHOD_CODE 
		  FROM #tmp_SCP0091_COLUMN 
		  WHERE USER_SORT_ORDER_NO = (@V_INDEX+1);

		 SET @COL_HEADER = @COL ;
		 SET @COL_SELECT = @COL ;
		 SET @COL_GROUP_BY = @COL ;
		 SET @COL_ORDER_BY = @COL ;


		IF (@V_INDEX = 0)
		BEGIN

			SET @mEXEC_HEADER	= @mEXEC_HEADER		+'	DATA.' + @COL_HEADER								+CHAR(10);
			SET @mEXEC_SELECT   = @mEXEC_SELECT		+'	' + @COL_SELECT								+CHAR(10);
			SET @mEXEC_GROUP_BY = @mEXEC_GROUP_BY	+'	' + @COL_GROUP_BY							+CHAR(10);
			SET @mEXEC_ORDER_BY	= @mEXEC_ORDER_BY	+'	' + @COL_ORDER_BY + ' ' + @SORT_METHOD_CODE	+CHAR(10);

			
		END
		ELSE
		BEGIN
			SET @mEXEC_HEADER	= @mEXEC_HEADER		+'	,DATA.' + @COL_HEADER								+CHAR(10);
			SET @mEXEC_SELECT   = @mEXEC_SELECT		+'	,' + @COL_SELECT								+CHAR(10);
			SET @mEXEC_GROUP_BY = @mEXEC_GROUP_BY	+'	,' + @COL_GROUP_BY								+CHAR(10);
			SET @mEXEC_ORDER_BY = @mEXEC_ORDER_BY	+'	,' + @COL_ORDER_BY + ' ' + @SORT_METHOD_CODE	+CHAR(10);
			
		END

		SET @V_INDEX = @V_INDEX + 1;
	END;

	--SELECT @mEXEC_HEADER;
	--SELECT @mEXEC_SELECT;
	--SELECT @mEXEC_GROUP_BY;
	--SELECT @mEXEC_ORDER_BY;





--##################################################################
-- Make QUERY
--##################################################################



	SET @mEXEC = '        select * ';
	SET @MEXEC = @MEXEC+' FROM			' + CHAR(10);
	SET @MEXEC = @MEXEC+' ( 			' + CHAR(10);

		/********************************************************************************
		-- WEEKLY
		********************************************************************************/

	SET @MEXEC = @MEXEC+' SELECT		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				' + @mEXEC_HEADER+ CHAR(10); 
	SET @MEXEC = @MEXEC+'				,DATA.delivery_qty									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,COL = COL + ''_''+ DATA.F_DEST_ETA_DATE			' + CHAR(10);
	SET @MEXEC = @MEXEC+'  FROM 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'  ( 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'  select 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			' + @mEXEC_SELECT+ CHAR(10); 
	SET @MEXEC = @MEXEC+'			,F_DEST_ETA_DATE 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			,sum(delivery_qty) as delivery_qty 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			FROM 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			( 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'			select 														' + CHAR(10);
	SET @MEXEC = @MEXEC+'				 sdic.division_id 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,cp.GROUP_CODE1 AS  CELL_GROUP 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,cp.GROUP_CODE2 AS  PACK_GROUP 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.project_code AS project_code  					' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.item_id 											' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,(SELECT TOP 1 (CASE  									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				                WHEN X.NICK_NAME IS NULL THEN ''-''  	' + CHAR(10);
	SET @MEXEC = @MEXEC+'								WHEN X.NICK_NAME='''' THEN ''-''  		' + CHAR(10);
	SET @MEXEC = @MEXEC+'								ELSE X.NICK_NAME  						' + CHAR(10);
	SET @MEXEC = @MEXEC+'								END 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'								)  										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				    FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				   WHERE X.ITEM_ID = sdic.item_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'				 ) AS nick_name 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.plant_id as plant 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.transport_mode as Trans_Mode 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) operation_group 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.from_scm_site_id 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.to_scm_site_id 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.final_incoterms		AS incoterms 				' + CHAR(10);
	--SET @MEXEC = @MEXEC+'				,CASE sdic.result_type  								' + CHAR(10);
	--SET @MEXEC = @MEXEC+'						WHEN ''S'' THEN ''-'' 							' + CHAR(10);
	--SET @MEXEC = @MEXEC+'						ELSE replace(replace(sdic.shipment_no, ''_1'','''') , ''_2'','''')     ' + CHAR(10); -- 20220707 '_1' 생략
	--SET @MEXEC = @MEXEC+'						END  shipment_no 				                ' + CHAR(10); -- 2018/09/20 
    SET @MEXEC = @MEXEC+'				,dbo.FN_GET_SHIPMENT_NO_DISPLAY(sdic.shipment_no, sdic.result_type ) AS shipment_no ' + CHAR(10); -- 20220807
	SET @MEXEC = @MEXEC+'				,sdic.delivery_qty 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,convert(char(10), convert(datetime, sdic.result_date), 23) AS result_date 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,concat(calendar.basis_yyyymm, iso_week)  as F_DEST_ETA_DATE ' + CHAR(10);
	SET @MEXEC = @MEXEC+'		FROM  scm_dnm_intransit_c sdic 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		LEFT JOIN scp_mst_bod_n_v smbv 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			ON    sdic.division_id = smbv.division_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.from_scm_site_id = smbv.from_site 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.to_scm_site_id = smbv.to_site 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			ANd   sdic.incoterms = smbv.incoterms 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.transport_mode = smbv.transport_mode 				' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   smbv.bod_valid_yn = ''Y'' 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   smbv.route_valid_yn = ''Y'' 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.result_date >= smbv.from_yyyymmdd 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.result_date <= smbv.to_yyyymmdd 						' + CHAR(10);


	SET @MEXEC = @MEXEC+'	  LEFT JOIN scm_sys_calendar_m calendar on calendar.BASIS_yyyymmdd =  CASE  						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			                                                              when result_type = ''B'' and  isnull(sdic.ATTRIBUTE3,'''')= '''' then F_DEST_ETA_DATE' + CHAR(10);
	SET @MEXEC = @MEXEC+'			                                                              WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) <  convert(char(8), convert(datetime, sdic.result_date), 112) 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'																		  THEN convert(char(8), convert(datetime, sdic.result_date), 112) 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'																		  ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112)						' + CHAR(10);
	SET @MEXEC = @MEXEC+'																		  END 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'		LEFT JOIN SCP_MST_FINAL_ITEM cp										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			on    cp.DIVISION_ID = sdic.division_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			and   cp.ITEM_ID = sdic.ITEM_ID  								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			WHERE 1 = 1						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			      [@p_division_id]			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_plant_site_id] 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_sales_site_id]		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_project_code]			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_item_id]				' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  AND sdic.result_date >= [@p_from_yyyymmdd]				' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  AND sdic.result_date <= [@p_to_yyyymmdd]					' + CHAR(10);


	SET @MEXEC = @MEXEC+'				  AND CASE 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  when result_type = ''B'' then F_DEST_ETA_DATE  		    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) <  convert(char(8), convert(datetime, sdic.result_date), 112) 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  THEN convert(char(8), convert(datetime, sdic.result_date), 112) 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  END BETWEEN [@p_period_from] AND [@p_period_to] 					' + CHAR(10);

	SET @MEXEC = @MEXEC+'		AND sdic.RESULT_TYPE in (''I'',''C'',''B'')										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''''		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) A																				' + CHAR(10);
	SET @MEXEC = @MEXEC+'		where 1 = 1						' + CHAR(10);
	SET @MEXEC = @MEXEC+'		[@p_operation_group]			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		GROUP BY						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			' + @mEXEC_GROUP_BY			  + CHAR(10); 
	SET @MEXEC = @MEXEC+'		    ,F_DEST_ETA_DATE			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) DATA							' + CHAR(10);
	SET @MEXEC = @MEXEC+'		CROSS APPLY 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		(								' + CHAR(10);
	SET @MEXEC = @MEXEC+'		SELECT ''W''					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) C (COL)						' + CHAR(10);


	SET @MEXEC = REPLACE(@MEXEC,'[@p_from_yyyymmdd]'		, ''+@p_from_yyyymmdd+''    );
	SET @MEXEC = REPLACE(@MEXEC,'[@p_to_yyyymmdd]'			, ''+@p_to_yyyymmdd+''    );
	SET @mEXEC = REPLACE(@mEXEC,'[@p_division_id]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.division_id','EQUAL', @p_division_id ));
	--SET @mEXEC = REPLACE(@mEXEC,'[@p_plant_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.from_scm_site_id', 'LIKE', @p_plant_site_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_plant_site_id]'        , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.from_scm_site_id', 'IN', @p_plant_site_id)); -- 20220706 EQUAL => IN
	SET @mEXEC = REPLACE(@mEXEC,'[@p_sales_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.to_scm_site_id', 'LIKE', @p_sales_site_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_project_code]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.project_code', 'EQUAL', @p_project_code ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_item_id]'				, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.item_id', 'EQUAL', @p_item_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_operation_group]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('operation_group', 'EQUAL', @p_operation_group ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_period_from]'			,  ''+@p_period_from+'');
	SET @mEXEC = REPLACE(@mEXEC,'[@p_period_to]'			,  ''+@p_period_to+'');
		

		/********************************************************************************
		-- MONTHLY
		********************************************************************************/
	SET @MEXEC = @MEXEC+' UNION ALL		' + CHAR(10);
	SET @MEXEC = @MEXEC+' SELECT		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				' + @mEXEC_HEADER+ CHAR(10); 
	SET @MEXEC = @MEXEC+'				,DATA.delivery_qty									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,COL = COL + ''_''+ DATA.F_DEST_ETA_DATE			' + CHAR(10);
	SET @MEXEC = @MEXEC+'  FROM 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'  ( 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'  select 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			' + @mEXEC_SELECT+ CHAR(10); 
	SET @MEXEC = @MEXEC+'			,substring(F_DEST_ETA_DATE,1,6) AS F_DEST_ETA_DATE 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			,sum(delivery_qty) as delivery_qty 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			FROM 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			( 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'			select 														' + CHAR(10);
	SET @MEXEC = @MEXEC+'				 sdic.division_id 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,cp.GROUP_CODE1 AS  CELL_GROUP 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,cp.GROUP_CODE2 AS  PACK_GROUP 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.project_code AS project_code  					' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.item_id 											' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,(SELECT TOP 1 (CASE  									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				                WHEN X.NICK_NAME IS NULL THEN ''-''  	' + CHAR(10);
	SET @MEXEC = @MEXEC+'								WHEN X.NICK_NAME='''' THEN ''-''  		' + CHAR(10);
	SET @MEXEC = @MEXEC+'								ELSE X.NICK_NAME  						' + CHAR(10);
	SET @MEXEC = @MEXEC+'								END 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'								)  										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				    FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				   WHERE X.ITEM_ID = sdic.item_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'				 ) AS nick_name 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.plant_id as plant 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.transport_mode as Trans_Mode 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) operation_group 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.from_scm_site_id 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.to_scm_site_id 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.final_incoterms		AS incoterms 				' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,dbo.FN_GET_SHIPMENT_NO_DISPLAY(sdic.shipment_no, sdic.result_type ) AS shipment_no ' + CHAR(10); -- 20220807
	SET @MEXEC = @MEXEC+'				,convert(char(10), convert(datetime, sdic.result_date), 23) AS result_date 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.delivery_qty 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				, case  												' + CHAR(10);
	SET @MEXEC = @MEXEC+'				when result_type = ''B'' then F_DEST_ETA_DATE  		    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'				when isnull(sdic.ATTRIBUTE3,'''')= '''' then ''''  		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				when sdic.ATTRIBUTE3 ='''' then '''' 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'				else  													' + CHAR(10);
	SET @MEXEC = @MEXEC+'					CASE  												' + CHAR(10);
	SET @MEXEC = @MEXEC+'					WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) <  convert(char(8), convert(datetime, sdic.result_date), 112) 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'					then convert(char(8), convert(datetime, sdic.result_date), 112) 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'					ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) 			' + CHAR(10);
	SET @MEXEC = @MEXEC+'					END 																	' + CHAR(10);
	SET @MEXEC = @MEXEC+'				end F_DEST_ETA_DATE 														' + CHAR(10);
	SET @MEXEC = @MEXEC+'		FROM  scm_dnm_intransit_c sdic 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		LEFT JOIN scp_mst_bod_n_v smbv 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			ON    sdic.division_id = smbv.division_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.from_scm_site_id = smbv.from_site 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.to_scm_site_id = smbv.to_site 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			ANd   sdic.incoterms = smbv.incoterms 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.transport_mode = smbv.transport_mode 				' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   smbv.bod_valid_yn = ''Y'' 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   smbv.route_valid_yn = ''Y'' 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.result_date >= smbv.from_yyyymmdd 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.result_date <= smbv.to_yyyymmdd 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'		LEFT JOIN SCP_MST_FINAL_ITEM cp										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			on    cp.DIVISION_ID = sdic.division_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			and   cp.ITEM_ID = sdic.ITEM_ID  								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			WHERE 1 = 1						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			      [@p_division_id]			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_plant_site_id] 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_sales_site_id]		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_project_code]			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_item_id]				' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_from_to_yyyymmdd] 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'		AND sdic.RESULT_TYPE in (''I'',''C'',''B'')										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''''		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) A																				' + CHAR(10);
	SET @MEXEC = @MEXEC+'		where F_DEST_ETA_DATE between [@p_period_from] and [@p_period_to]				' + CHAR(10);
	SET @MEXEC = @MEXEC+'		[@p_operation_group]' + CHAR(10);
	SET @MEXEC = @MEXEC+'		GROUP BY						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			' + @mEXEC_GROUP_BY			  + CHAR(10); 
	SET @MEXEC = @MEXEC+'		    ,F_DEST_ETA_DATE			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) DATA							' + CHAR(10);
	SET @MEXEC = @MEXEC+'		CROSS APPLY 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		(								' + CHAR(10);
	SET @MEXEC = @MEXEC+'		SELECT ''M''					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) C (COL)						' + CHAR(10);


	SET @MEXEC = REPLACE(@MEXEC,'[@p_period_to]'			, @p_period_to    );
	SET @MEXEC = REPLACE(@MEXEC,'[@p_period_from]'			, @p_period_from    );
	SET @mEXEC = REPLACE(@mEXEC,'[@p_division_id]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.division_id','EQUAL', @p_division_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_plant_site_id]'        , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.from_scm_site_id', 'IN', @p_plant_site_id)); -- 20220706 EQUAL => IN
	SET @mEXEC = REPLACE(@mEXEC,'[@p_sales_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.to_scm_site_id', 'LIKE', @p_sales_site_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_project_code]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.project_code', 'EQUAL', @p_project_code ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_item_id]'				, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.item_id', 'EQUAL', @p_item_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_operation_group]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('operation_group', 'EQUAL', @p_operation_group ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_from_to_yyyymmdd]'  , 'and sdic.result_date between '''+@p_from_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''');


		/********************************************************************************
		-- DAILY
		********************************************************************************/
	SET @MEXEC = @MEXEC+' UNION	ALL		' + CHAR(10);
	SET @MEXEC = @MEXEC+' SELECT		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				' + @mEXEC_HEADER+ CHAR(10); 
	SET @MEXEC = @MEXEC+'				,DATA.delivery_qty									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,COL = COL + ''_''+ DATA.F_DEST_ETA_DATE			' + CHAR(10);
	SET @MEXEC = @MEXEC+'  FROM 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'  ( 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'  select 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			' + @mEXEC_SELECT+ CHAR(10); 
	SET @MEXEC = @MEXEC+'			,F_DEST_ETA_DATE 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			,sum(delivery_qty) as delivery_qty 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			FROM 	' + CHAR(10);
	SET @MEXEC = @MEXEC+'			( 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'			select 														' + CHAR(10);
	SET @MEXEC = @MEXEC+'				 sdic.division_id 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,cp.GROUP_CODE1 AS  CELL_GROUP 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,cp.GROUP_CODE2 AS  PACK_GROUP 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.project_code AS project_code  					' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.item_id 											' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,(SELECT TOP 1 (CASE  									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				                WHEN X.NICK_NAME IS NULL THEN ''-''  	' + CHAR(10);
	SET @MEXEC = @MEXEC+'								WHEN X.NICK_NAME='''' THEN ''-''  		' + CHAR(10);
	SET @MEXEC = @MEXEC+'								ELSE X.NICK_NAME  						' + CHAR(10);
	SET @MEXEC = @MEXEC+'								END 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'								)  										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				    FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				   WHERE X.ITEM_ID = sdic.item_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'				 ) AS nick_name 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.plant_id as plant 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.transport_mode as Trans_Mode 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) operation_group 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.from_scm_site_id 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.to_scm_site_id 									' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.final_incoterms		AS incoterms 				' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,dbo.FN_GET_SHIPMENT_NO_DISPLAY(sdic.shipment_no, sdic.result_type ) AS shipment_no ' + CHAR(10); -- 20220807
	SET @MEXEC = @MEXEC+'				,convert(char(10), convert(datetime, sdic.result_date), 23) AS result_date 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				,sdic.delivery_qty 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'				, case  												' + CHAR(10);
	SET @MEXEC = @MEXEC+'				when result_type = ''B'' then F_DEST_ETA_DATE  		    ' + CHAR(10);
	SET @MEXEC = @MEXEC+'				when isnull(sdic.ATTRIBUTE3,'''')= '''' then ''''  		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				when sdic.ATTRIBUTE3 ='''' then '''' 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'				else  													' + CHAR(10);
	SET @MEXEC = @MEXEC+'					CASE  												' + CHAR(10);
	SET @MEXEC = @MEXEC+'					WHEN convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) <  convert(char(8), convert(datetime, sdic.result_date), 112) then convert(char(8), convert(datetime, sdic.result_date), 112)		' + CHAR(10);
	SET @MEXEC = @MEXEC+'					ELSE convert(char(8), convert(datetime, sdic.ATTRIBUTE3), 112) 			' + CHAR(10);
	SET @MEXEC = @MEXEC+'					END 																	' + CHAR(10);
	SET @MEXEC = @MEXEC+'				end F_DEST_ETA_DATE 														' + CHAR(10);
	SET @MEXEC = @MEXEC+'		FROM  scm_dnm_intransit_c sdic 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		LEFT JOIN scp_mst_bod_n_v smbv 										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			ON    sdic.division_id = smbv.division_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.from_scm_site_id = smbv.from_site 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.to_scm_site_id = smbv.to_site 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			ANd   sdic.incoterms = smbv.incoterms 							' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.transport_mode = smbv.transport_mode 				' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   smbv.bod_valid_yn = ''Y'' 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   smbv.route_valid_yn = ''Y'' 								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.result_date >= smbv.from_yyyymmdd 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND   sdic.result_date <= smbv.to_yyyymmdd 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'		LEFT JOIN SCP_MST_FINAL_ITEM cp										' + CHAR(10);
	SET @MEXEC = @MEXEC+'			on    cp.DIVISION_ID = sdic.division_id 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			and   cp.ITEM_ID = sdic.ITEM_ID  								' + CHAR(10);
	SET @MEXEC = @MEXEC+'			WHERE 1 = 1						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			      [@p_division_id]			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_plant_site_id] 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_sales_site_id]		' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_project_code]			' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  [@p_item_id]				' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  AND sdic.result_date >= [@p_from_yyyymmdd]				' + CHAR(10);
	SET @MEXEC = @MEXEC+'				  AND sdic.result_date <= [@p_to_yyyymmdd]					' + CHAR(10);

	SET @MEXEC = @MEXEC+'		AND sdic.RESULT_TYPE in (''I'',''C'',''B'')										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		AND dbo.fn_get_item_operation_group(sdic.division_id, sdic.item_id) != ''''		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) A																				' + CHAR(10);
	SET @MEXEC = @MEXEC+'		where 1 = 1			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		[@p_operation_group]' + CHAR(10);
	SET @MEXEC = @MEXEC+'		GROUP BY						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			' + @mEXEC_GROUP_BY			  + CHAR(10); 
	SET @MEXEC = @MEXEC+'		    ,F_DEST_ETA_DATE			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) DATA							' + CHAR(10);
	SET @MEXEC = @MEXEC+'		CROSS APPLY 					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		(								' + CHAR(10);
	SET @MEXEC = @MEXEC+'		SELECT ''D''					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		) C (COL)						' + CHAR(10);
	
		
	SET @MEXEC = REPLACE(@MEXEC,'[@p_from_yyyymmdd]'		, ''+@p_from_yyyymmdd+''    );
	SET @MEXEC = REPLACE(@MEXEC,'[@p_to_yyyymmdd]'			, ''+@p_to_yyyymmdd+''    );
	SET @mEXEC = REPLACE(@mEXEC,'[@p_division_id]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.division_id','EQUAL', @p_division_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_plant_site_id]'        , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.from_scm_site_id', 'IN', @p_plant_site_id)); -- 20220706 EQUAL => IN
	SET @mEXEC = REPLACE(@mEXEC,'[@p_sales_site_id]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.to_scm_site_id', 'LIKE', @p_sales_site_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_project_code]'		    , [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.project_code', 'EQUAL', @p_project_code ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_item_id]'				, [dbo].[FN_SCM_GET_WHERE_SQL]('sdic.item_id', 'EQUAL', @p_item_id ));
	SET @mEXEC = REPLACE(@mEXEC,'[@p_operation_group]'		, [dbo].[FN_SCM_GET_WHERE_SQL]('operation_group', 'EQUAL', @p_operation_group ));


	SET @MEXEC = @MEXEC+'		) LIST							' + CHAR(10);
	SET @MEXEC = @MEXEC+'		PIVOT ( 						' + CHAR(10);
	SET @MEXEC = @MEXEC+'			sum(delivery_qty) 			' + CHAR(10);
	SET @MEXEC = @MEXEC+'			FOR COL						' + CHAR(10);
	--SELECT @mEXEC;
	--SELECT @COLUMNS;
	SET @MEXEC = @MEXEC+'		    IN (' + @COLUMNS + ') 		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		    ) AS pivot_result			' + CHAR(10);

	-----------------------------------------------------------------------------------
	-- 20220919 SELECT Column 에 SHIPMENT_NO 없을 시 오류 조치
	--          SHIPMENT_NO 없을 시 조회 기준?        
	-----------------------------------------------------------------------------------
    DECLARE @cntOrder integer;
	SELECT @cntOrder = LEN(@mEXEC_SELECT)-LEN(REPLACE(@mEXEC_SELECT,'SHIPMENT_NO','')) 

	IF @cntOrder > 0 
		BEGIN
		SET @MEXEC = @MEXEC+'		ORDER BY SHIPMENT_NO			' + CHAR(10); -- 20220808 : RESULT DATE 범위 일 때 정렬순서 적용
		END
	ELSE
		BEGIN
		SET @MEXEC = @MEXEC+'		ORDER BY ' + @mEXEC_ORDER_BY	 + CHAR(10); -- 20220808 : RESULT DATE 범위 일 때 정렬순서 적용
		END

		

	EXEC (@mEXEC);
    --SELECT @MEXEC;
	--select @mEXEC_ORDER_BY;





	--##############################################################################
	-- 임시테이블 삭제
	--##############################################################################
	    IF OBJECT_ID('tempdb..#tmp_SCP0091_COLUMN') IS NOT NULL	
		DROP TABLE #tmp_SCP0091_COLUMN;



END


