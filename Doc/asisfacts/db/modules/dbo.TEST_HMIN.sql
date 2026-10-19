
CREATE PROCEDURE [dbo].[TEST_HMIN]
    @p_division_id    NVARCHAR(30),
    @p_scm_site_id    NVARCHAR(4000),
    @p_plant_site_id  NVARCHAR(4000),
    @p_team_id        NVARCHAR(4000),
    @p_customer       NVARCHAR(4000),
    @p_biz_type       NVARCHAR(4000),
    @p_project_code   NVARCHAR(4000),
    @p_item_id        NVARCHAR(4000),
    @p_from_yyyymmdd  NVARCHAR(8),
    @p_to_yyyymmdd    NVARCHAR(8),
    @p_created_by	  NVARCHAR(50),
	@p_user_group     NVARCHAR(50),
	@p_item_type      NVARCHAR(1000),
	@p_owner          NVARCHAR(1000),
	@p_qty_yn         NVARCHAR(01),
	@p_cell_yn        NVARCHAR(01),
	@p_invalid_exec	  NVARCHAR(1),   -- [C20200612-000174] ESS사업부 New Model Flag
	@p_AS_YN		NVARCHAR(1),	
	@p_user_dept_id   NVARCHAR(50),	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가	
	-- mkt fcst 미등록 제외가 체크가 될 경우 Y로 들어옴
  --,@p_debug         NVARCHAR(MAX) OUTPUT
    @p_sender_code		NVARCHAR(4000)	-- SENDER_CODE 추가
AS  
  
BEGIN
    SET NOCOUNT ON;
PRINT ( 'A1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
	
    --DECLARE @v_sql_text_result   AS NVARCHAR(MAX);
    DECLARE @v_sql_text          AS NVARCHAR(MAX);
    DECLARE @V_PV_LIST			 AS NVARCHAR(MAX);
	DECLARE @V_PV_COL_LIST		 AS NVARCHAR(MAX);
	DECLARE @v_column_name		 AS NVARCHAR(100)
    DECLARE @v_column            AS NVARCHAR(1000);
    DECLARE @v_groupby           AS NVARCHAR(1000);
    DECLARE @v_orderby           AS NVARCHAR(1000);
    DECLARE @v_column_text       AS NVARCHAR(1000);
    DECLARE @v_PV_column_name    AS NVARCHAR(100);
    DECLARE @v_PV_NAME			 AS NVARCHAR(50);
    DECLARE @v_column_type       AS NVARCHAR(50);
    DECLARE @v_column_value      AS NVARCHAR(50);
    DECLARE @v_sort_order_no     AS NVARCHAR(50);
    DECLARE @v_day_code          AS NVARCHAR(50);  
    DECLARE @p_param_list        AS NVARCHAR(4000);
    DECLARE @p_end_week          AS NVARCHAR(6);
    DECLARE @v_program_id        AS NVARCHAR(10);
    DECLARE @v_sheet_name        AS NVARCHAR(100);
    DECLARE @v_groupby_column    AS NVARCHAR(100);
    DECLARE @v_from_yyyymmdd     AS NVARCHAR(8);
    DECLARE @v_to_yyyymmdd       AS NVARCHAR(8);
    DECLARE @v_from_result       AS NVARCHAR(8);
    DECLARE @v_to_result         AS NVARCHAR(8);
    DECLARE @v_user_col_cnt      AS INT;
	DECLARE @v_user_mea_cnt      AS INT;
	DECLARE @v_dept_id           AS NVARCHAR(50);  
	DECLARE @v_user_time_zone    AS NVARCHAR(50);  
	--DECLARE @TQTY				 AS NVARCHAR(1000)='';	-- 20180810
	--DECLARE @FQTY				 AS NVARCHAR(1000)='';	-- 20180810	
  
	----20180626, lsh
	DECLARE @v_owner_sml_text	 AS NVARCHAR(1000);
	DECLARE @v_owner_def_text	 AS NVARCHAR(1000);

	DECLARE @va_program_id	   NVARCHAR(50)
	DECLARE @va_sheet_name	   NVARCHAR(50)
	SET @va_program_id = 'DMF0003'
	SET @va_sheet_name = 'Mkt Fcst'

	DECLARE @nsql2 nvarchar(MAX); -- order by 정보 add son young suk 20180727

	SET @v_dept_id = '';
	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_user_group = 'ADMIN' OR @p_user_group = 'DM ADMIN' OR @p_user_group = 'DM Planner (W/S)' OR @p_user_group = 'SCM PI Admin'  -- 20200217 KHSONG 'SCM PI Admin' ADD
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 IN ('ALL','DMF0003')  -- Program_Id = 'DMF0003' 인 경우 MKT FCST 입력화면에 추가로 부여한 권한그룹
						AND SEGMENT1 = @p_user_group
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	SELECT @V_PV_LIST = '', @V_PV_COL_LIST = ''
	DECLARE c_bucket CURSOR FAST_FORWARD FOR 
		SELECT 
			 '[D_' + a.basis_yyyymmdd + '] AS D_' + A.BASIS_YYYYMMDD  AS column_name
			 ,'[D_' + a.basis_yyyymmdd + ']' AS PV_name
			 , a.basis_yyyymmdd + '_' + CONVERT(CHAR(2), 31) AS sort_order_no
		FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
		WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd -- '20171101'  CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
		AND    a.basis_yyyymmdd <= @p_to_yyyymmdd   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
		UNION ALL
		SELECT '[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + '] AS W_' + a.basis_yyyymm + a.iso_week  AS column_name
			 ,'[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + ']' AS PV_name
			 , a.basis_start_date + '_' + CONVERT(CHAR(2), 21) AS sort_order_no
		FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
		WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
		AND    a.basis_yyyymmdd <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
		GROUP BY a.basis_yyyymm
			   , a.iso_week    
			   , a.basis_start_date
		UNION ALL
		SELECT '[M_' + A.BASIS_YYYYMM + '] AS M_' + a.basis_yyyymm  AS column_name
			  , '[M_' + A.BASIS_YYYYMM + ']' AS PV_name
			  , MIN(a.basis_start_date) + '_' + CONVERT(CHAR(2), 1) AS sort_order_no
		FROM    [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
		WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
		AND    a.basis_yyyymmdd <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
		GROUP BY a.basis_yyyymm
		ORDER BY sort_order_no  
		;

	OPEN c_bucket;
	FETCH NEXT FROM c_bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
		WHILE @@FETCH_STATUS = 0   
		BEGIN  
			SELECT @V_PV_COL_LIST	= @V_PV_COL_LIST + CASE WHEN @V_PV_COL_LIST <> '' THEN ',' ELSE '' END + @v_PV_column_name
				   , @V_PV_LIST		= @V_PV_LIST + CASE WHEN @V_PV_LIST <> '' THEN ',' ELSE '' END + @v_PV_name
    
			FETCH NEXT FROM c_Bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
		END;

    CLOSE c_bucket;  
    DEALLOCATE c_bucket;

	
PRINT ( 'B1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
  
    SET @v_column_name = '';
    SET @v_column = '';
    SET @v_groupby = '';
	SET @v_user_col_cnt = 0;
	SET @v_user_mea_cnt = 0;

    SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @va_program_id
    AND    U.SHEET_NAME = @va_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = @p_created_by;
		
	IF @v_user_col_cnt = 0
	BEGIN
	    INSERT INTO [dbo].[SCM_MST_TITLESET_USER]
		( USER_ID
		, PROGRAM_ID
		, SHEET_NAME
		, USER_INQUIRY_COLUMN_TYPE_CODE
		, COLUMN_NAME
		, SORT_ORDER_NO
		, SUB_TOTAL_FLAG
		, DATA_SORT_METHOD_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE
		)
		SELECT @p_created_by
		     , C.PROGRAM_ID
			 , C.SHEET_NAME
			 , 'C'
			 , C.COLUMN_NAME
			 , C.SORT_ORDER_NO
			 , 'N'
			 , ''
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = @va_program_id
		AND    C.SHEET_NAME  = @va_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'	;
	END;

	--IF NOT EXISTS ( 
	--	SELECT * 
	--	FROM SCM_MST_TITLESET_USER U
	--	WHERE U.PROGRAM_ID = @va_program_id
	--		AND    U.SHEET_NAME = @va_sheet_name
	--		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	--		AND    U.USER_ID    = @p_created_by
	--		AND COLUMN_NAME = 'ATTR1' 
	--		)
	--BEGIN
	--	 INSERT INTO [dbo].[SCM_MST_TITLESET_USER]
	--		( USER_ID
	--		, PROGRAM_ID
	--		, SHEET_NAME
	--		, USER_INQUIRY_COLUMN_TYPE_CODE
	--		, COLUMN_NAME
	--		, SORT_ORDER_NO
	--		, SUB_TOTAL_FLAG
	--		, DATA_SORT_METHOD_CODE
	--		, CREATED_BY
	--		, CREATION_DATE
	--		, LAST_UPDATED_BY
	--		, LAST_UPDATE_DATE
	--		)
	--	SELECT @p_created_by
	--	     , C.PROGRAM_ID
	--		 , C.SHEET_NAME
	--		 , 'C'
	--		 , C.COLUMN_NAME
	--		 , C.SORT_ORDER_NO
	--		 , 'N'
	--		 , ''
	--		 , @p_created_by
	--		 , CONVERT(varchar(19), GETDATE(), 121)
	--		 , @p_created_by
	--		 , CONVERT(varchar(19), GETDATE(), 121)
	--	FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
	--	WHERE  1 = 1
	--	AND    C.PROGRAM_ID  = @va_program_id
	--	AND    C.SHEET_NAME  = @va_sheet_name
	--	AND    C.VALID_YN     = 'Y'
	--	AND	   C.COLUMN_NAME = 'ATTR1'	;
	--END

	SELECT @v_user_mea_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @va_program_id
    AND    U.SHEET_NAME = @va_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = @p_created_by;

	IF @v_user_mea_cnt = 0
	BEGIN	    
		INSERT INTO [dbo].[SCM_MST_TITLESET_USER]
		( USER_ID
		, PROGRAM_ID
		, SHEET_NAME
		, USER_INQUIRY_COLUMN_TYPE_CODE
		, COLUMN_NAME
		, SORT_ORDER_NO
		, SUB_TOTAL_FLAG
		, DATA_SORT_METHOD_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE
		)
		SELECT @p_created_by
		     , C.PROGRAM_ID
			 , C.SHEET_NAME
			 , 'M'
			 , C.COLUMN_NAME
			 , C.SORT_ORDER_NO
			 , 'N'
			 , ''
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
			 , @p_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
		FROM   [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = @va_program_id
		AND    C.SHEET_NAME  = @va_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'	;			
	END;

	--정렬 정보 쿼리 add son young suk 20180727
	SET  @nsql2 = N'SELECT U.PROGRAM_ID
			 , U.SHEET_NAME
			 , U.COLUMN_NAME   
			 , U.SORT_ORDER_NO      
			 , U.DATA_SORT_METHOD_CODE   
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			 , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = ''DMF0003''
		AND    U.SHEET_NAME  = ''Mkt Fcst''
		AND    U.USER_ID     = ''' + @p_created_by + '''
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = ''C'' 
		AND	 ''' + @p_division_id + ''' IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,'','') )	-- 20190214
		UNION ALL
		SELECT C.PROGRAM_ID
			 , C.SHEET_NAME
			 , C.COLUMN_NAME 
			 , C.SORT_ORDER_NO             
			 , C.DATA_SORT_METHOD_CODE    
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = ''DMF0003''
		AND    C.SHEET_NAME  = ''Mkt Fcst''
		AND    C.DEFAULT_FLAG = ''''
		AND	   C.VISIBLE_FLAG = ''N''
		AND    C.VALID_YN     = ''Y''
		ORDER BY SORT_ORDER_NO';


	DECLARE c_title CURSOR FAST_FORWARD FOR 
		SELECT U.PROGRAM_ID
			 , U.SHEET_NAME
			 , U.COLUMN_NAME   
			 , (CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
						WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY' THEN '560'
						ELSE U.SORT_ORDER_NO END) AS SORT_ORDER_NO     
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			 , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = @va_program_id
		AND    U.SHEET_NAME  = @va_sheet_name
		AND    U.USER_ID     = @p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
		UNION ALL
		SELECT C.PROGRAM_ID
			 , C.SHEET_NAME
			 , C.COLUMN_NAME 
			 , C.SORT_ORDER_NO        
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @va_program_id
		AND    C.SHEET_NAME  = @va_sheet_name
		AND    C.DEFAULT_FLAG = ''
		AND    C.VALID_YN     = 'Y'
		ORDER BY SORT_ORDER_NO ;
		
	  	  

  OPEN c_title;
FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_column_name, @v_sort_order_no
  WHILE @@FETCH_STATUS = 0   
  BEGIN  
    IF @v_column = ''
	    BEGIN
	    SET @v_column =  @v_column_name;
		SET @v_groupby = ' GROUP BY ' + @v_column_name;
		SET @v_orderby = ' ORDER BY SORT_KEY, ' + CASE WHEN @V_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN @v_column_name ELSE '' END
		END;
	ELSE
	    BEGIN

		SET @v_column = @v_column + ', ' + @v_column_name;
		SET @v_groupby = @v_groupby + ', ' + @v_column_name;
		SET @v_orderby = @v_orderby + CASE WHEN @V_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN ', ' + @v_column_name ELSE '' END
	    END;
    
    FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_column_name, @v_sort_order_no
  END;
  

  SET @v_groupby = @v_groupby + ', EDIT_FLAG, SORT_ORDER_NO';
  SET @v_orderby = REPLACE(@v_orderby, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMERIC(10,2))');
  SET @v_orderby = REPLACE(@v_orderby, ', MEASURE', '');

  
  CLOSE c_title;  
  DEALLOCATE c_title;
  
  SET @v_from_yyyymmdd  = ''; --MKT Fcst Plan From 주차 월요일
  SET @v_to_yyyymmdd    = ''; --MKT Fcst Plan To 주차 월요일
  SET @v_from_result    = ''; --MKT Fcst Result From 주차 월요일
  SET @v_to_result      = ''; --MKT Fcst Result To 주차 월요일
  SET @v_user_time_zone = '';

  BEGIN
	  SELECT @v_user_time_zone = U.TIMEZONE
	  FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
	  WHERE  U.UserID = @p_created_by;
  END

  -- @v_from_yyyymmdd : (User 시차를 고려한) 당주 월요일
  SELECT @v_from_yyyymmdd = MIN(C.BASIS_YYYYMMDD)
  FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
       , (SELECT DISTINCT ISO_YYYYWW		    		
	      FROM   [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) 
		  WHERE  1 = 1
		  AND    BASIS_YYYYMMDD = CONVERT(CHAR(8), dbo.FN_MULTY_TIME(@v_user_time_zone), 112)
		  --AND    BASIS_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(MM, @v_user_col_cnt, dbo.FN_MULTY_TIME(@v_user_time_zone)), 112)
		 ) T
  WHERE  1 = 1
  AND    C.ISO_YYYYWW = T.ISO_YYYYWW ;

  -- From 실적 : From 조회 구간 월요일부터
  SELECT @v_from_result = C.BASIS_START_DATE
  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
  WHERE  1 = 1
  AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd; 
  
  -- To 실적 : To 조회 구간 월요일 전까지
  SELECT @v_to_result = C.BASIS_START_DATE
  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
  WHERE  1 = 1
  AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd; 

  IF @v_from_yyyymmdd > @v_from_result
      BEGIN -- 실적 보여줌
	  SET @v_to_yyyymmdd   = @p_to_yyyymmdd;   
      SET @v_to_result     = @v_from_yyyymmdd; -- To 실적 : 당주 월요일 전까지 
	  END;
  ELSE IF @v_from_yyyymmdd <= @v_from_result
      BEGIN -- 실적 없음
	  SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
	  SET @v_from_result = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112);
      SET @v_to_result = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, -6, CURRENT_TIMESTAMP), 112);
	  END;
  ELSE IF @v_from_yyyymmdd > @v_to_result
      BEGIN -- 실적만 보여줌
	  SET @v_from_yyyymmdd = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112);
      SET @v_to_yyyymmdd = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, -6, CURRENT_TIMESTAMP), 112);
	  SET @v_from_result = @p_from_yyyymmdd; -- From 실적 : From 조회 구간부터
	  SET @v_to_result = @p_to_yyyymmdd; -- To 실적 : To 조회 구간까지  
	  END;
  ELSE IF @v_from_yyyymmdd = @v_to_result
      BEGIN -- 실적 없음
      SET @v_to_yyyymmdd = @v_from_yyyymmdd
	  SET @v_from_result = @p_from_yyyymmdd;
	  SET @v_to_result = @p_to_yyyymmdd;
	  END;

--SELECT @v_from_yyyymmdd, @v_TO_yyyymmdd  RETURN;
--SELECT @v_to_result RETURN;


IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V

--[C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
IF OBJECT_ID (N'tempdb..#TempSelectMeasure', N'U') IS NOT NULL 		DROP TABLE #TempSelectMeasure
IF OBJECT_ID (N'tempdb..#TempSiteItemAll', N'U') IS NOT NULL 		DROP TABLE #TempSiteItemAll
IF OBJECT_ID (N'tempdb..#TempSiteItem', N'U') IS NOT NULL 			DROP TABLE #TempSiteItem
IF OBJECT_ID (N'tempdb..#TempIntransitData', N'U') IS NOT NULL 		DROP TABLE #TempIntransitData
IF OBJECT_ID (N'tempdb..#TempShipmentPlan', N'U') IS NOT NULL 		DROP TABLE #TempShipmentPlan
IF OBJECT_ID (N'tempdb..#TempMktFcstData', N'U') IS NOT NULL 		DROP TABLE #TempMktFcstData
IF OBJECT_ID (N'tempdb..#TempMktFcstDataDst', N'U') IS NOT NULL 	DROP TABLE #TempMktFcstDataDst
IF OBJECT_ID (N'tempdb..#TempSalesPrice', N'U') IS NOT NULL 		DROP TABLE #TempSalesPrice
IF OBJECT_ID (N'tempdb..#TempVmiDio', N'U') IS NOT NULL 			DROP TABLE #TempVmiDio
IF OBJECT_ID (N'tempdb..#T_SSP_SYNC', N'U') IS NOT NULL 			DROP TABLE #T_SSP_SYNC
IF OBJECT_ID (N'tempdb..#T_BNP', N'U') IS NOT NULL 					DROP TABLE #T_BNP
IF OBJECT_ID (N'tempdb..#T_WS_FCST', N'U') IS NOT NULL 				DROP TABLE #T_WS_FCST
IF OBJECT_ID (N'tempdb..#T_WS_SITE_PLANT', N'U') IS NOT NULL 		DROP TABLE #T_WS_SITE_PLANT

PRINT ( 'C1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))


	--	[C20200804-000123] 시작
	CREATE TABLE #T_SSP_SYNC (
	DIVISION_ID		NVARCHAR(30)
	,PROJECT_CODE	NVARCHAR(50)
	,SCM_SITE_ID	NVARCHAR(30)
	,ITEM_ID		NVARCHAR(50)
	,DOM_EXP		NVARCHAR(6)
	,FCST_TYPE		NVARCHAR(20)
	,INCOTERMS		NVARCHAR(10)
	,YYYYMMDD		NVARCHAR(8)
	,ATTR1			NVARCHAR(MAX)
	)

	--	[PJ20209642R] ESS PR REQUEST
	CREATE TABLE #T_BNP (
	DIVISION_ID		NVARCHAR(30)
	,PROJECT_CODE	NVARCHAR(50)
	,SCM_SITE_ID	NVARCHAR(30)
	,ITEM_ID		NVARCHAR(50)
	,DOM_EXP		NVARCHAR(6)
	,FCST_TYPE		NVARCHAR(20)
	,INCOTERMS		NVARCHAR(10)
	,YYYYMMDD		NVARCHAR(8)
	,ATTR1			NVARCHAR(MAX)
	)

	CREATE TABLE #T_WS_SITE_PLANT (
	SCM_SITE_ID	NVARCHAR(30)
	)

	CREATE TABLE #T_WS_FCST (
	FCST_TYPE		NVARCHAR(20)
	)


	IF @p_AS_YN = 'Y'
	BEGIN 
		INSERT INTO #T_WS_FCST ( FCST_TYPE )
		SELECT SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL ( NOLOCK )
		WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE2'
	END
	ELSE
	BEGIN 
		INSERT INTO #T_WS_FCST ( FCST_TYPE )
		SELECT SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL ( NOLOCK )
		WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE'
	END

	IF @p_AS_YN = 'Y'
	BEGIN 
		INSERT INTO #T_WS_SITE_PLANT ( SCM_SITE_ID )
		SELECT SEGMENT2
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL ( NOLOCK )
		WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
			AND SEGMENT3 = @P_DIVISION_ID
		union all
		SELECT SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL ( NOLOCK )
		WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
			AND SEGMENT3 = @P_DIVISION_ID
	END


	-- 일자/동기화여부^일자/동기화여부 형식으로 만든다.
	IF ( @P_DIVISION_ID = '40' )
	BEGiN
		INSERT INTO #T_SSP_SYNC ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1)
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, ISNULL(A1,'') + '^' + ISNULL(A2,'') + '^' + ISNULL( A3,'') + '^' + ISNULL( A4,'') + '^' + ISNULL( A5,'')
			+ '^' + ISNULL( A6,'') + '^' + ISNULL( A7,'') + '^' + ISNULL( A8,'') + '^' + ISNULL( A9,'') + '^' + ISNULL( A10,'')
			+ '^' + ISNULL( A11,'') + '^' + ISNULL( A12,'') + '^' + ISNULL( A13,'') + '^' + ISNULL( A14,'') + '^' + ISNULL( A15,'')
			+ '^' + ISNULL( A16,'') + '^' + ISNULL( A17,'') + '^' + ISNULL( A18,'') + '^' + ISNULL( A19,'') + '^' + ISNULL( A20,'')
			+ '^' + ISNULL( A21,'') + '^' + ISNULL( A22,'') + '^' + ISNULL( A23,'') + '^' + ISNULL( A24,'') + '^' + ISNULL( A25,'')
			+ '^' + ISNULL( A26,'') + '^' + ISNULL( A27,'') + '^' + ISNULL( A28,'') + '^' + ISNULL( A29,'') + '^' + ISNULL( A30,'')
			+ '^' + ISNULL( A31,'')
			AS ATTR1
		FROM (
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
					--, CONCAT(YYYYMMDD, '/', CASE WHEN CAST(ATTRIBUTE1 AS NUMERIC(30,10)) = QTY THEN 'A' ELSE 'P' END) AS SYNC_YN
					-- ATTR1 에 숫자가 있으면 동기화는 된 건임.
					, CONCAT(YYYYMMDD
							, '/'
							, CASE WHEN ISNUMERIC(ATTRIBUTE3) > 0 
										AND A.QTY >
										CASE WHEN ISNUMERIC(ATTRIBUTE3) > 0 THEN CAST(ATTRIBUTE3 AS NUMERIC(30,10)) ELSE 0 END
										+ CASE WHEN ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS NUMERIC(30,10)) ELSE 0 END
										THEN 'P' 
									ELSE 'A' 
									END
							) AS SYNC_YN
					, 'A' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
					ORDER BY YYYYMMDD ) AS NVARCHAR(3)) AS ROW_NUM 
				FROM DM_PLN_MKT_FCST (NOLOCK) A
				JOIN #T_WS_FCST B ON A.FCST_TYPE = B.FCST_TYPE
				WHERE A.DIVISION_ID = @P_DIVISION_ID
					AND A.MEASURE = 'MKT_FCST'
					AND A.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					AND (ISNULL(A.ATTRIBUTE4, '') <> '' OR ISNULL(A.ATTRIBUTE5, '') <> '' ) --[C20210225-000385] 동기화 기준은 ATTRIBUTE4, ATTRIBUTE5으로 구분
					AND A.QTY <> 0
					AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
								ELSE A.scm_site_id
 							END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
					AND    CASE WHEN @p_project_code = '' THEN @p_project_code			
								ELSE A.project_code
 							END  IN ( SELECT token FROM dbo.String_Split(@p_project_code,',') )
					AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id			
								ELSE A.PLANT_SITE_ID
 							END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

				) A
		PIVOT (
			MAX(SYNC_YN) FOR ROW_NUM IN (  A1, A2, A3, A4, A5, A6, A7, A8, A9, A10	, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20
										, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30, A31 )
			) AS PVT
	END
	ELSE IF ( @P_DIVISION_ID = '82' )
	BEGIN
		INSERT INTO #T_BNP ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ATTR1)
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, ISNULL(A1,'') + '^' + ISNULL(A2,'') + '^' + ISNULL( A3,'') + '^' + ISNULL( A4,'') + '^' + ISNULL( A5,'')
			+ '^' + ISNULL( A6,'') + '^' + ISNULL( A7,'') + '^' + ISNULL( A8,'') + '^' + ISNULL( A9,'') + '^' + ISNULL( A10,'')
			+ '^' + ISNULL( A11,'') + '^' + ISNULL( A12,'') + '^' + ISNULL( A13,'') + '^' + ISNULL( A14,'') + '^' + ISNULL( A15,'')
			+ '^' + ISNULL( A16,'') + '^' + ISNULL( A17,'') + '^' + ISNULL( A18,'') + '^' + ISNULL( A19,'') + '^' + ISNULL( A20,'')
			+ '^' + ISNULL( A21,'') + '^' + ISNULL( A22,'') + '^' + ISNULL( A23,'') + '^' + ISNULL( A24,'') + '^' + ISNULL( A25,'')
			+ '^' + ISNULL( A26,'') + '^' + ISNULL( A27,'') + '^' + ISNULL( A28,'') + '^' + ISNULL( A29,'') + '^' + ISNULL( A30,'')
			+ '^' + ISNULL( A31,'')
			AS ATTR1
		FROM (
			SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				, CONCAT(YYYYMMDD, '/A') AS SYNC_YN
				, 'A'+ CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
						ORDER BY YYYYMMDD ) AS NVARCHAR(3)) AS ROW_NUM 
			FROM DM_PLN_PR_DETAIL (NOLOCK) A
			WHERE A.DIVISION_ID = @P_DIVISION_ID
				AND A.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
			) A
		PIVOT (
			MAX(SYNC_YN) FOR ROW_NUM IN (  A1, A2, A3, A4, A5, A6, A7, A8, A9, A10	, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20
										, A21, A22, A23, A24, A25, A26, A27, A28, A29, A30, A31 )
			) AS PVT	
	END

--		[C20200804-000123] 끝
PRINT ( 'D1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 속도개선 - 불필요한 컬럼 제거[2021-09-15]
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
		,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY 
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
	INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							ON	T2.ITEM_ID		like  b.tst 
							OR	T2.NICK_NAME	like  b.tst 						
	WHERE DIVISION_ID = @p_division_id					
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
			,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY

	--SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
	--		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE,ENERGE, CELL_QUANTITY
	--INTO #TEMP_DM_MST_ITEM_SINGLE_V
	--FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
	--INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
	--						ON	T2.ITEM_ID		like  b.tst 
	--						OR	T2.NICK_NAME	like  b.tst 						
	--WHERE DIVISION_ID = @p_division_id
	--GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL
	--		,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE,ENERGE, CELL_QUANTITY
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
(division_id   ASC
,item_id       ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;


PRINT ( 'D2--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------◇◇◇◇

-- TEMP TABLE 생성시
 --IF OBJECT_ID (N'dbo.TEMP_SKH_0219_MKT_FCST_RESULT_TOBE', N'U') IS NOT NULL 		DROP TABLE TEMP_SKH_0219_MKT_FCST_RESULT_TOBE

 
--[C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
		CREATE TABLE #TempSelectMeasure
		(
			PROGRAM_ID nvarchar(100)
		, SHEET_NAME nvarchar(100)
		, USER_ID nvarchar(100)
		, MEASURE_GROUP nvarchar(100)
		, MEASURE nvarchar(100)
		, SORT_ORDER_NO nvarchar(100)
		) ;
		
		CREATE TABLE #TempVmiDio
		(
		KEY_JOIN	NVARCHAR(100)
		, VMI_STD_DIO	NUMERIC(17,3)
		, VMI_VAL		NVARCHAR(100)
		) ;

		IF @p_division_id = '40'
		BEGIN
			INSERT INTO #TempVmiDio ( KEY_JOIN, VMI_STD_DIO )
			SELECT A.ITEM_ID, A.VMI_STD_DIO
			FROM SCP_MST_DIO A
			JOIN (
				SELECT DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
					, MAX(YYYYMM) AS YYYYMM
				FROM SCP_MST_DIO
				WHERE DIVISION_ID ='40'
				AND TOTAL_YN = 'Y'
				AND PLANT_ID = '*'
				GROUP BY DIVISION_ID, PLANT_ID, ITEM_ID, TOTAL_YN
				) B ON A.DIVISION_ID = B.DIVISION_ID 
					AND A.PLANT_ID = B.PLANT_ID 
					AND A.ITEM_ID = B.ITEM_ID 
					AND A.TOTAL_YN = B.TOTAL_YN
					AND A.YYYYMM = B.YYYYMM
			WHERE A.DIVISION_ID = '40'
				AND A.TOTAL_YN = 'Y'
				AND A.PLANT_ID = '*'
		END
		ELSE IF ( @P_DIVISION_ID = '82' ) -- [C20201103-000114]
		BEGIN
			INSERT INTO #TempVmiDio ( KEY_JOIN, VMI_VAL )
			SELECT A.SCM_SITE_ID, A.VMI_YN + '^' + CAST(ISNULL(A.ATTRIBUTE5, '') AS NVARCHAR(6))
			FROM SCM_MST_SITE A
			WHERE DIVISION_ID = @P_DIVISION_ID

		END
					
--SELECT * FROM #TempVmiDio					
						
		CREATE TABLE #TempSiteItemAll
		(
		division_id nvarchar(10)
		, project_code nvarchar(100)
		, scm_site_id nvarchar(100)
		, item_id nvarchar(100)
		, nick_name nvarchar(100)
		, project_name nvarchar(100)
		, cell_model nvarchar(100)
		, BIZ_TYPE nvarchar(100)
		, END_CUSTOMER nvarchar(100)
		, SOLDTO_CUSTOMER nvarchar(100)
		, COUNTRY nvarchar(100)
		, COUNTRY_NAME nvarchar(100)
		, CITY nvarchar(100)
		, CITY_NAME nvarchar(100)
		, OWNER nvarchar(100)
		, PROJECT_OWNER nvarchar(100)
		, USER_ID nvarchar(100)
		, ITEM_NAME nvarchar(100)
		, ITEM_TYPE nvarchar(100)
		, PROJECT_STATUS nvarchar(100)
		, CUST_GROUP nvarchar(100)
		, CUST_GROUP_DTL nvarchar(100)
		, APPLICATION nvarchar(100)
		, ROUTE nvarchar(100)
		, MDM_PROJECT_NAME nvarchar(100)
		, MIN_CAPACITY nvarchar(100)
		, FORECAST_INFO_BIZ_TYPE nvarchar(100)
		, FORECAST_INFO_PRODUCT_GROUP nvarchar(100)
		, CELL_TYPE nvarchar(100)
		, FORECAST_INFO_CELL_PACK_COUNT numeric(20,10)  --[C20200702-000136] FORECAST_INFO_CELL_PACK_COUNT 은 numeric type
		, FORECAST_INFO_ALL nvarchar(100)
		, FORECAST_INFO_SPEC nvarchar(100)
		, FORECAST_INFOR_VERSION nvarchar(100)
		, CELL_MODEL_NICK_NAME nvarchar(100)
		, VMI_YN nvarchar(100)
		, DMS_SALES nvarchar(100)
		, DMS_CUSTOMER nvarchar(100)
		, DEPT_ID nvarchar(100)
		, DEPT_NAME_KO nvarchar(100)
		, CELL_PER_CAR numeric
		, CELL_PER_MODULE numeric
		, MODULE_PER_CAR numeric
		, ITEM_CLASS_NAME nvarchar(100)
		, ENERGE nvarchar(100)
		, CELL_QUANTITY nvarchar(100)
		, ITEM_VALID_YN		NVARCHAR(1)
		)
				

				
				
		CREATE TABLE #TempMktFcstData
		( DIVISION_ID nvarchar(100)
		, PROJECT_CODE nvarchar(100)
		, SCM_SITE_ID nvarchar(100)
		, PLANT_SITE_ID nvarchar(100)
		, ITEM_ID nvarchar(100)
		, DOM_EXP nvarchar(100)
		, FCST_TYPE nvarchar(100)
		, INCOTERMS nvarchar(100)
		, MEASURE nvarchar(100)
		, YYYYMMDD nvarchar(100)
		, QTY numeric(30,10)
		, MEASURE_GROUP nvarchar(100)
		, cell_model nvarchar(100)
		, END_CUSTOMER nvarchar(100)
		, NICK_NAME nvarchar(100)
		, DMS_SALES nvarchar(100)
		, DMS_CUSTOMER nvarchar(100)
		, OWNER nvarchar(100)
		, DEPT_ID nvarchar(100)
		, DEPT_NAME_KO nvarchar(100)
		, FORECAST_INFO_CELL_PACK_COUNT numeric(20,10)  --[C20200702-000136] FORECAST_INFO_CELL_PACK_COUNT 은 numeric type
		, ITEM_TYPE nvarchar(100)
		, PROJECT_NAME nvarchar(100)
		, PROJECT_OWNER nvarchar(100)
		, BIZ_TYPE nvarchar(100)
		, SOLDTO_CUSTOMER nvarchar(100)
		, COUNTRY_NAME nvarchar(100)
		, CITY_NAME nvarchar(100)
		, PROJECT_STATUS nvarchar(100)
		, ITEM_NAME nvarchar(100)
		, VMI_YN nvarchar(100)
		, CUST_GROUP nvarchar(100)
		, CUST_GROUP_DTL nvarchar(100)
		, APPLICATION nvarchar(100)
		, ROUTE nvarchar(100)
		, MDM_PROJECT_NAME nvarchar(100)
		, MIN_CAPACITY nvarchar(100)
		, FORECAST_INFO_BIZ_TYPE nvarchar(100)
		, CELL_TYPE nvarchar(100)
		, FORECAST_INFO_ALL nvarchar(100)
		, FORECAST_INFO_SPEC nvarchar(100)
		, FORECAST_INFOR_VERSION nvarchar(100)
		, CELL_MODEL_NICK_NAME nvarchar(100)
		, CELL_PER_CAR numeric
		, CELL_PER_MODULE numeric
		, MODULE_PER_CAR numeric
		, SORT_ORDER_NO nvarchar(100)
		, ENERGE nvarchar(100)
		, CELL_QUANTITY nvarchar(100)
		, AS_FROM_SITE	NVARCHAR(100)
		, CREATE_DATE	NVARCHAR(8)
		, LAST_UPDATED_BY		NVARCHAR(300)
		, SENDER_CODE	NVARCHAR(10)
		, SENDER_NAME	NVARCHAR(100)
		)
		
		CREATE TABLE #TempShipmentPlan (
		DIVISION_ID		NVARCHAR(30)
		, PROJECT_CODE	NVARCHAR(50)
		, SCM_SITE_ID	NVARCHAR(30)
		, ITEM_ID		NVARCHAR(50)
		, DOM_EXP		NVARCHAR(3)
		, FCST_TYPE		NVARCHAR(20)
		, INCOTERMS		NVARCHAR(10)
		, MEASURE		NVARCHAR(50)
		, PLANT_SITE_ID	NVARCHAR(30)
		, YYYYMMDD		NVARCHAR(8)
		, QTY			NUMERIC(30,10)
		, SORT_ORDER_NO	NVARCHAR(50)
		)

		CREATE TABLE #TempIntransitData (
		DIVISION_ID		NVARCHAR(30)
		, PROJECT_CODE	NVARCHAR(50)
		, SCM_SITE_ID	NVARCHAR(30)
		, ITEM_ID		NVARCHAR(50)
		, DOM_EXP		NVARCHAR(3)
		, FCST_TYPE		NVARCHAR(20)
		, INCOTERMS		NVARCHAR(10)
		, MEASURE		NVARCHAR(50)
		, PLANT_SITE_ID	NVARCHAR(30)
		, YYYYMMDD		NVARCHAR(8)
		, QTY			NUMERIC(30,10)
		, SORT_ORDER_NO	NVARCHAR(50)
		)

		--[PJ20209643]
		-- P_AS_YN = 'Y' 일 경우 이 테이블에 BOD로 연결된 SALES SITE 들을 다시 @p_scm_site_id 로 만들어준다.
		--CREATE TABLE #T_AS_SITE (
		--SCM_SITE_ID		NVARCHAR(30)
		--)

		IF ( @P_AS_YN = 'Y' )
		BEGIN
			
			DECLARE @T TAB_PIVOT_STRING

			INSERT INTO @T ( KEY_VAL )
			SELECT DISTINCT D.SCM_SITE_ID
			FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,',') A
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.TOKEN = B.SEGMENT1 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT'
			JOIN SCP_MST_BOD_N_V C ON B.SEGMENT2 = C.FROM_SITE AND C.DIVISION_ID = @P_DIVISION_ID AND CONVERT(NCHAR(8), GETDATE(), 112) BETWEEN from_yyyymmdd and to_yyyymmdd
			JOIN SCM_MST_SITE D ON C.TO_SITE = D.SCM_SITE_ID AND D.SITE_TYPE = 'SALES' AND D.VALID_YN = 'Y' AND D.DIVISION_ID = @P_DIVISION_ID
			UNION ALL
			SELECT DISTINCT A.TOKEN
			FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,',') A
			
			-- #t_AS_SITE 에 받은 값들을 원래값들과 합쳐서 @p_scm_site_id 데 다시 넣어준다.
			SELECT @p_scm_site_id = DBO.FN_GET_PIVOT_STRING(@T, ',')
		END
--select 		@p_scm_site_id

PRINT ( 'D3--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

		insert into #TempSelectMeasure

				SELECT DISTINCT U.PROGRAM_ID
						 , U.SHEET_NAME
						 , U.USER_ID
						 --, U.COLUMN_NAME AS MEASURE_GROUP
						 , CASE WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO' )  THEN 'CUST. PSI' 
								   WHEN U.COLUMN_NAME IN ( 'MKT_INV_I','MKT_PRODUCT_S','MKT_WHIN_P','MKT_DIO' )  THEN 'MKT PSI'  
								   ELSE U.COLUMN_NAME END AS MEASURE_GROUP
						 , U.COLUMN_NAME AS MEASURE
						 , U.SORT_ORDER_NO
				FROM [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
				LEFT JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] T WITH(NOLOCK) 
				ON (U.USER_ID = T.SEGMENT4)  -- 20200309 KHSONG TMM MEASURE 권한추가
					AND @p_created_by		= T.SEGMENT4  -- USER_ID
					AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
					AND T.VALID_YN			= 'Y'       -- VALID_YN 여부
				WHERE 1 = 1
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				AND U.PROGRAM_ID   = 'DMF0003'
				AND U.SHEET_NAME	= 'Mkt Fcst'
				AND U.USER_ID			= @p_created_by
				AND U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by	END  -- 20200309 KHSONG TMM MEASURE 권한추가
				--------------------------------------------------------------- 20191118 KHSONG [CSR ID:C20191031-000137] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건 (BEGIN)
				UNION ALL
				SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE, A.SORT_ORDER_NO + 0.1
				FROM 
						( SELECT U.PROGRAM_ID
								   , U.SHEET_NAME
								   , U.USER_ID
								   , 'CUST_FCST_EDI' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
								   , U.SORT_ORDER_NO
						 FROM [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
						 WHERE 1 = 1
						 AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
						 AND U.PROGRAM_ID	= 'DMF0003'
						 AND U.SHEET_NAME	= 'Mkt Fcst'
						 AND U.USER_ID			= @p_created_by
						 AND U.COLUMN_NAME = 'CUST_FCST_EDI'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
						) A,
						( 
						 SELECT 'Immidiate' MEASURE
						 UNION ALL									
						 SELECT 'Planning_Forecast' MEASURE
						 UNION ALL
						 SELECT 'Commercial_Agreement' MEASURE
						 UNION ALL
						 SELECT 'Firm_Temp' MEASURE
						 UNION ALL
						 SELECT 'Manumacturing_Material_Temp' MEASURE
						 UNION ALL
						 SELECT 'Material_Temp' MEASURE
						 UNION ALL
						 SELECT 'Backorder' MEASURE
						) B
				WHERE 1=1
				GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE, A.SORT_ORDER_NO
				--------------------------------------------------------------- CUST_FCST_EDI[Org.] MEASURE 추가
				UNION ALL
				SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE, A.SORT_ORDER_NO + 0.1
				FROM 
						( SELECT U.PROGRAM_ID
								   , U.SHEET_NAME
								   , U.USER_ID
								   , 'CUST_FCST_EDI_ORG' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
								   , U.SORT_ORDER_NO
						 FROM [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
						 WHERE 1 = 1
						 AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
						 AND U.PROGRAM_ID	= 'DMF0003'
						 AND U.SHEET_NAME	= 'Mkt Fcst'
						 AND U.USER_ID			= @p_created_by
						 AND U.COLUMN_NAME = 'CUST_FCST_EDI_ORG'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
						) A,
						( 
						 SELECT 'Immidiate[Org.]' MEASURE
						 UNION ALL									
						 SELECT 'Planning_Forecast[Org.]' MEASURE
						 UNION ALL
						 SELECT 'Commercial_Agreement[Org.]' MEASURE
						 UNION ALL
						 SELECT 'Firm_Temp[Org.]' MEASURE
						 UNION ALL
						 SELECT 'Manumacturing_Material_Temp[Org.]' MEASURE
						 UNION ALL
						 SELECT 'Material_Temp[Org.]' MEASURE
						 UNION ALL
						 SELECT 'Backorder[Org.]' MEASURE
						) B
				WHERE 1=1
				GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE, A.SORT_ORDER_NO
				--------------------------------------------------------------- 20191118 KHSONG [CSR ID:C20191031-000137] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건 (END)
				UNION ALL
				SELECT DISTINCT 'DMF0003'	AS PROGRAM_ID
						 , 'Mkt Fcst'					AS SHEET_NAME     
						 , @p_created_by			AS USER_ID
						 , 'CUST_FCST_2'			AS MEASURE_GROUP
						 , C.MEASURE				AS MEASURE
						 , (SELECT SORT_ORDER_NO FROM [dbo].[SCM_MST_TITLESET_USER] WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
							WHERE 1 = 1
							AND USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
							AND PROGRAM_ID									= 'DMF0003'
							AND SHEET_NAME									= 'Mkt Fcst'
							AND USER_ID											= @p_created_by
							AND COLUMN_NAME								= 'CUST_FCST') + 0.1 AS SORT_ORDER_NO
				FROM [dbo].[DM_MST_CUSTOMER_FCST] C  WITH(NOLOCK,INDEX (PK_DM_MST_CUSTOMER_FCST))
				WHERE 1 = 1
				AND C.MEASURE_GROUP = 'CUST_FCST'
				AND C.MEASURE      <> ''
				AND C.VALID_YN      = 'Y'
				AND EXISTS (SELECT * FROM [dbo].[SCM_MST_TITLESET_USER] X WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
								  WHERE  1 = 1
								  AND X.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
								  AND X.PROGRAM_ID									= 'DMF0003'
								  AND X.SHEET_NAME									= 'Mkt Fcst'
								  AND X.USER_ID											= @p_created_by
								  AND X.COLUMN_NAME								= 'CUST_FCST'
								  AND X.COLUMN_NAME								= C.MEASURE_GROUP)
				--------------------------------------------------------------- CUST_FCST[Org.] MEASURE 추가
				UNION ALL
				SELECT DISTINCT 'DMF0003'	AS PROGRAM_ID
						 , 'Mkt Fcst'					AS SHEET_NAME     
						 , @p_created_by			AS USER_ID
						 , 'CUST_FCST_3'			AS MEASURE_GROUP
						 , 'Customer Fcst[Org.]'	AS MEASURE
						 , (SELECT SORT_ORDER_NO FROM [dbo].[SCM_MST_TITLESET_USER] WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
							WHERE 1 = 1
							AND USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
							AND PROGRAM_ID									= 'DMF0003'
							AND SHEET_NAME									= 'Mkt Fcst'
							AND USER_ID											= @p_created_by
							AND COLUMN_NAME								= 'CUST_FCST_ORG') + 0.1 AS SORT_ORDER_NO
				FROM [dbo].[DM_MST_CUSTOMER_FCST] C  WITH(NOLOCK,INDEX (PK_DM_MST_CUSTOMER_FCST))
				WHERE 1 = 1
				AND C.MEASURE_GROUP = 'CUST_FCST'
				AND C.MEASURE      <> ''
				AND C.VALID_YN      = 'Y'
				AND EXISTS (SELECT * FROM [dbo].[SCM_MST_TITLESET_USER] X WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
								  WHERE  1 = 1
								  AND X.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
								  AND X.PROGRAM_ID									= 'DMF0003'
								  AND X.SHEET_NAME									= 'Mkt Fcst'
								  AND X.USER_ID											= @p_created_by
								  AND X.COLUMN_NAME								= 'CUST_FCST_ORG')

		-- [C20201103-000114] ess 사업부가 mkt fcst 메저를 선택했을 경우 vmi 관련 메저를 같이 넣어준다.
		IF EXISTS ( select * from #TempSelectMeasure WHERE MEASURE = 'MKT_FCST_RP' )
			AND @P_DIVISION_ID = '82'
		BEGIN
			-- 순서를 조정하기 위해 관련메저 ( MKT_FCST_RP, RTF, VMI_IN_PLAN, VMI_IN_REQ, VMI_INV ) 를 지우고, 순서맞춰서 다시 넣는다.
			-- ※ 메저 강제 Insert 시에는 대소문자 맞춰줘야 함. 안그러면 combo 에서 공백으로 처리됨
			DELETE FROM #TempSelectMeasure WHERE MEASURE IN ( 'RTF_SYS_RP', 'VMI_IN_PLAN', 'VMI_IN_REQ', 'VMI_INV')
			
			INSERT INTO #TempSelectMeasure ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO )
			SELECT A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, B.MEASURE_GROUP, B.MEASURE
				, REPLACE(A.SORT_ORDER_NO, '.0', B.SORTKEY)
			FROM #TempSelectMeasure A
			JOIN (  SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE, '.1' AS SORTKEY
					UNION ALL
					SELECT 'VMI_In_Plan' AS MEASURE_GROUP, 'VMI_In_Plan' AS MEASURE, '.2' AS SORTKEY
					UNION ALL
					SELECT 'VMI_In_Req' AS MEASURE_GROUP, 'VMI_In_Req' AS MEASURE, '.3' AS SORTKEY
					UNION ALL
					SELECT 'VMI_Inv' AS MEASURE_GROUP, 'VMI_Inv' AS MEASURE, '.4' AS SORTKEY
				) B ON 1=1
			WHERE A.MEASURE = 'MKT_FCST_RP'
		END
		

		-- MKT FCST 메저 순서 변경
		UPDATE #TempSelectMeasure
		SET SORT_ORDER_NO = REPLACE(SORT_ORDER_NO, '.0', '.9')
		WHERE MEASURE = 'MKT_FCST_RP'

--select * from #TempSelectMeasure RETURN;

PRINT ( 'D4--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

											   
	if (@p_division_id LIKE '81%' OR @p_division_id = '82')
		begin
			        
			insert into #TempSiteItemAll
			select f.division_id, f.project_code, f.scm_site_id, f.item_id, T2.nick_name, t3.project_name
					,'' cell_model  --20180809 ytchoi modify						  
					, T3.BIZ_TYPE
					, S.END_CUSTOMER
					, S.SOLDTO_CUSTOMER
					, i.COUNTRY	
					, i.COUNTRY_NAME	  
					, h.CITY
					, h.CITY_NAME	  
					--20180809 ytchoi modify(s)
					-- modify by ytchoi 180913
					,( SELECT distinct  STUFF(( SELECT ',' + user_name_en FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za WITH(NOLOCK)   ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token ) xb  FOR XML PATH('') ),1,1,'') AS NAME FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za  WITH(NOLOCK) ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token) xa ) AS OWNER
					, CASE WHEN F.division_id NOT IN ('40') THEN T3.PROJECT_OWNER ELSE j.USER_NAME_EN end AS PROJECT_OWNER -- 20180705  --20190123 KHSONG 전지재료DIV설정
					, J.USER_ID
					--20180809 ytchoi modify(e)
					, T2.ITEM_NAME       
					, T2.ITEM_TYPE 
					, T3.PROJECT_STATUS 
					, F.CUST_GROUP
					, F.CUST_GROUP_DTL
					, F.APPLICATION
					, F.ROUTE
					, T2.MDM_PROJECT_NAME  
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
	  				, T2.FORECAST_INFO_PRODUCT_GROUP
					, LOOK.NAME AS CELL_TYPE --20180911 LookUp ??? ???? CELL_TYPE ??
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.FORECAST_INFO_SPEC+T2.FORECAST_INFOR_VERSION	as FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC								as FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION							as FORECAST_INFOR_VERSION
					, ISNULL(T4.NICK_NAME,'') AS CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
					, S.VMI_YN  -- 20180719
					, ISNULL(F.attribute1,'') DMS_SALES     -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
					, ISNULL(F.attribute2,'') DMS_CUSTOMER  -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
					, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_ID ELSE k.DEPT_ID END AS DEPT_ID		-- 20180809  --20190123 KHSONG 전지재료DIV설정
					, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END AS DEPT_NAME_KO	-- 20180809  --20190123 KHSONG 전지재료DIV설정
					, F.CELL_PER_CAR, F.CELL_PER_MODULE,F.CELL_PER_CAR / IIF(ISNULL(F.CELL_PER_MODULE, 0) = 0, 1, F.CELL_PER_MODULE) AS MODULE_PER_CAR  -- 20190705 KHSONG [CSR ID:4023158]

					,T2.ITEM_CLASS_NAME  -- 20190705 KHSONG [CSR ID:4023158] measure추가를 위한 컬럼추가

					-- 20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					,F.VALID_YN
					-- 20200130 KHSONG [C20200114-000201]
				from scm_mst_site_item F WITH(NOLOCK)
				INNER JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
						ON	F.DIVISION_ID    = T2.DIVISION_ID
						AND	F.ITEM_ID        = T2.ITEM_ID
				INNER JOIN 	SCM_MST_PROJECT	T3  WITH(NOLOCK)
						ON	F.DIVISION_ID    = T3.DIVISION_ID
						AND	F.PROJECT_CODE   = T3.PROJECT_CODE						
				INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
						ON      F.ITEM_ID  like  b.tst 
						OR      T2.NICK_NAME  like  b.tst 
				INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) c  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
						ON      F.project_code  like  c.tst 
						OR      T3.project_name like  c.tst 
				--20180809 ytchoi added
				INNER JOIN 	SCM_MST_SITE	s  WITH(NOLOCK)
						ON	F.DIVISION_ID    = s.DIVISION_ID
						AND	F.SCM_SITE_ID    = s.SCM_SITE_ID
						AND S.SITE_TYPE		= 'SALES'
						AND S.VALID_YN		= 'Y'
				INNER JOIN [dbo].SCM_MST_CITY h WITH(NOLOCK)
						ON  S.CITY           = h.CITY
				INNER JOIN [dbo].[SCM_MST_COUNTRY] i WITH(NOLOCK)
						ON  S.COUNTRY        = i.COUNTRY

				-- 20180809 ADDED  -----------------
				LEFT JOIN (
							SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
								FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
									INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
										ON B.DEPT_ID = C.DEPT_ID
						) AS TEAM

						ON  TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](F.owner, ','))
				-- 20180809 ADDED  -----------------
 
				LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] j WITH(NOLOCK)
						ON  substring( F.OWNER, 0, case when charindex(',',F.OWNER) = 0 then len(F.OWNER)+1 else charindex(',',F.OWNER) end ) = j.USER_ID -- 20180816 modified by ytchoi
				LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] k WITH(NOLOCK)
						ON  CASE WHEN T3.DIVISION_ID IN ('40') THEN j.DEPT_ID ELSE S.DEPT_ID END  = k.DEPT_ID  --20190123 KHSONG 전지재료DIV설정
				LEFT JOIN ( --20180911 LookUp TABLE JOIN
						SELECT SEGMENT1  AS CODE       
								, SEGMENT2  AS NAME
						FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
						WHERE LOOKUP_TYPE = 'CELL_TYPE' 
						) LOOK
					ON LOOK.CODE = T2.CELL_TYPE
				--20180809 ytchoi added

				--20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
				LEFT JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T4  WITH(NOLOCK)
						ON	T2.DIVISION_ID    = T4.DIVISION_ID
						AND	ISNULL(T2.FORECAST_INFO_CELL_MODEL,'')        = T4.ITEM_ID
				--20180809 ytchoi added
			where f.division_id <> '40' -- hard coding  --20190123 KHSONG 전지재료DIV설정
			AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
						ELSE f.scm_site_id
 					END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
			AND    CASE WHEN @p_customer = 'ALL' THEN @p_customer			
						ELSE S.END_CUSTOMER
 					END  IN ( SELECT token FROM dbo.String_Split(@p_customer,',') )
			AND    CASE WHEN @p_item_type = 'ALL' THEN @p_item_type			
						ELSE T2.ITEM_TYPE
 					END  IN ( SELECT token FROM dbo.String_Split(@p_item_type,',') )
			AND    CASE WHEN @p_biz_type = 'ALL' THEN @p_biz_type			
						ELSE T3.BIZ_TYPE
 					END  IN ( SELECT token FROM dbo.String_Split(@p_biz_type,',') )
			AND    CASE WHEN @p_owner = '' THEN @p_owner			
						ELSE F.OWNER
 					END  IN ( SELECT token FROM dbo.String_Split(@p_owner,',') )
						   
		end
	else
		begin

			-----------------------------
					
			insert into #TempSiteItemAll
			select f.division_id, f.project_code, f.scm_site_id, f.item_id, T2.nick_name, f.project_code
				--20180809 ytchoi added
					,f.attribute5 AS cell_model  -- 20180810 ytchoi 조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
				--20180809 ytchoi added						
					, ''     AS BIZ_TYPE
					, S.END_CUSTOMER
					, S.SOLDTO_CUSTOMER
					, i.COUNTRY	
					, i.COUNTRY_NAME	  
					, h.CITY
					, h.CITY_NAME	  
					--20180723, CASE WHEN a.division_id NOT IN ('40') THEN f.PROJECT_OWNER ELSE j.USER_NAME_EN end AS OWNER  --20190123 KHSONG 전지재료DIV설정
					--20180809 ytchoi modify(s)
					-- modify by ytchoi 180913
					,( SELECT distinct  STUFF(( SELECT ',' + user_name_en FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za WITH(NOLOCK)  ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token ) xb  FOR XML PATH('') ),1,1,'') AS NAME FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za WITH(NOLOCK)  ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token) xa ) AS OWNER
					, j.USER_NAME_EN AS PROJECT_OWNER -- 20180705
					, J.USER_ID
					--20180809 ytchoi modify(e)
					, T2.ITEM_NAME       
					, T2.ITEM_TYPE 
					, '' AS PROJECT_STATUS 
					, F.CUST_GROUP
					, F.CUST_GROUP_DTL
					, F.APPLICATION
					, F.ROUTE
					-- 20180711 ??
					, T2.MDM_PROJECT_NAME  
					, T2.MIN_CAPACITY
					--[E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청(LOOKUP이용)
					--, T2.FORECAST_INFO_BIZ_TYPE
					, CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE T2.FORECAST_INFO_BIZ_TYPE END AS FORECAST_INFO_BIZ_TYPE
	  				, T2.FORECAST_INFO_PRODUCT_GROUP
					, LOOK.NAME AS CELL_TYPE --20180911 LookUp ??? ???? CELL_TYPE ??
					--[E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청(LOOKUP이용)
					--, T2.FORECAST_INFO_CELL_PACK_COUNT
					, CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.CELL_PACK_COUNT ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
					, T2.FORECAST_INFO_SPEC+T2.FORECAST_INFOR_VERSION	as FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC								as FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION							as FORECAST_INFOR_VERSION
					, ISNULL(T4.NICK_NAME,'') AS CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
					, S.VMI_YN  -- 20180719
					, ISNULL(F.attribute1,'') DMS_SALES     -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
					, ISNULL(F.attribute2,'') DMS_CUSTOMER  -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
					, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_ID ELSE k.DEPT_ID END AS DEPT_ID		-- 20180809  --20190123 KHSONG 전지재료DIV설정
					, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END AS DEPT_NAME_KO	-- 20180809  --20190123 KHSONG 전지재료DIV설정
					, F.CELL_PER_CAR, F.CELL_PER_MODULE,F.CELL_PER_CAR / IIF(ISNULL(F.CELL_PER_MODULE, 0) = 0, 1, F.CELL_PER_MODULE) AS MODULE_PER_CAR  -- 20190705 KHSONG [CSR ID:4023158]

					,T2.ITEM_CLASS_NAME  -- 20190705 KHSONG [CSR ID:4023158] measure추가를 위한 컬럼추가

					-- 20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					-- 20200130 KHSONG [C20200114-000201]
					,F.VALID_YN
				from scm_mst_site_item F WITH(NOLOCK)
				INNER JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
						ON	F.DIVISION_ID    = T2.DIVISION_ID
						AND	F.ITEM_ID        = T2.ITEM_ID						
				INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
						ON      F.ITEM_ID  like  b.tst 
						OR      T2.NICK_NAME  like  b.tst 
				INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) c  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
						ON      F.project_code  like  c.tst 
				--20180809 ytchoi added
				INNER JOIN 	SCM_MST_SITE	s  WITH(NOLOCK)
						ON	F.DIVISION_ID    = s.DIVISION_ID
						AND	F.SCM_SITE_ID    = s.SCM_SITE_ID
						AND S.SITE_TYPE = 'SALES'
				INNER JOIN [dbo].SCM_MST_CITY h WITH(NOLOCK)
						ON  S.CITY           = h.CITY
				INNER JOIN [dbo].[SCM_MST_COUNTRY] i WITH(NOLOCK)
						ON  S.COUNTRY        = i.COUNTRY

				-- 20180809 ADDED  -----------------
				LEFT JOIN (
							SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
								FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
									INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
										ON B.DEPT_ID = C.DEPT_ID
							) AS TEAM

						ON  TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](F.owner, ','))
				-- 20180809 ADDED  -----------------
 
				LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] j WITH(NOLOCK)
						ON  substring( F.OWNER, 0, case when charindex(',',F.OWNER) = 0 then len(F.OWNER)+1 else charindex(',',F.OWNER) end ) = j.USER_ID -- 20180816 modified by ytchoi
				LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] k WITH(NOLOCK)
						ON  CASE WHEN F.DIVISION_ID IN ('40') THEN j.DEPT_ID ELSE S.DEPT_ID END  = k.DEPT_ID  --20190123 KHSONG 전지재료DIV설정
				LEFT JOIN ( --20180911 LookUp ??? ??
							SELECT SEGMENT1  AS CODE       
									, SEGMENT2  AS NAME
								FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
								WHERE LOOKUP_TYPE = 'CELL_TYPE' 
							) LOOK
						ON LOOK.CODE = T2.CELL_TYPE
				--20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
				LEFT JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T4  WITH(NOLOCK)
						ON	T2.DIVISION_ID    = T4.DIVISION_ID
						AND	ISNULL(T2.FORECAST_INFO_CELL_MODEL,'')        = T4.ITEM_ID
				--20230825 JSSBAE [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청으로 추가 
				LEFT JOIN ( 
								SELECT A.MODEL
									 , A.BIZ_TYPE
									 , A.CELL_PACK_COUNT
									 , A.MODEL_RANK 
								FROM 
								(
									SELECT SEGMENT2  AS MODEL       
										 , SEGMENT3  AS BIZ_TYPE
										 , SEGMENT4  AS CELL_PACK_COUNT
										 , RANK () OVER ( 
														  PARTITION BY SEGMENT2
														  ORDER BY DISPLAY_SEQ DESC
														) MODEL_RANK 
									FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
									WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' 
									AND SEGMENT1 = '40'
								) A
								WHERE MODEL_RANK = '1'
							) LOOKA
						ON LOOKA.MODEL = F.ITEM_ID								
				--20180809 ytchoi added
			where f.division_id = '40' -- hard coding  --20190123 KHSONG 전지재료DIV설정					
			AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
						ELSE f.scm_site_id
 					END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
			AND    CASE WHEN @p_customer = 'ALL' THEN @p_customer			
						ELSE f.project_code
 					END  IN ( SELECT token FROM dbo.String_Split(@p_customer,',') )
			AND    CASE WHEN @p_item_type = 'ALL' THEN @p_item_type			
						ELSE T2.ITEM_TYPE
 					END  IN ( SELECT token FROM dbo.String_Split(@p_item_type,',') )
			/*
			AND    CASE WHEN @p_biz_type = 'ALL' THEN @p_biz_type			
						ELSE T2.FORECAST_INFO_BIZ_TYPE
 					END  IN ( SELECT token FROM dbo.String_Split(@p_biz_type,',') )   */
			--20230825 JSSBAE [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청으로 추가 
			AND	   CASE WHEN @p_biz_type = 'ALL' THEN @p_biz_type 
						WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
					    ELSE T2.FORECAST_INFO_BIZ_TYPE 
 					END  IN ( SELECT token FROM dbo.String_Split(@p_biz_type,',') )  
			AND    CASE WHEN @p_owner = '' THEN @p_owner			
						ELSE F.OWNER
 					END  IN ( SELECT token FROM dbo.String_Split(@p_owner,',') )
  	   
		end
		-- 20180730 검색조건 project 코드 네임, item 코드 닉네임 like 검색 추가

-------------------------------------------------------------------------------- 20190704 KHSONG ITEM_ID = (MCCM346010A1,MCCM346010A1-D06) 이렇게 조회시 두배로 보이는 현상으로 재 GROUP (BEGIN)

PRINT ( 'D5--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

			SELECT division_id,project_code,scm_site_id,item_id,nick_name,project_name
					,MAX(cell_model                   )   cell_model                   
					,MAX(BIZ_TYPE                     )   BIZ_TYPE                     
					,MAX(END_CUSTOMER                 )   END_CUSTOMER                 
					,MAX(SOLDTO_CUSTOMER              )   SOLDTO_CUSTOMER              
					,MAX(COUNTRY                      )   COUNTRY     
					,MAX(COUNTRY_NAME                 )   COUNTRY_NAME                 
					,MAX(CITY                         )   CITY                         
					,MAX(CITY_NAME                    )   CITY_NAME                    
					,MAX(OWNER                        )   OWNER                        
					,MAX(PROJECT_OWNER                )   PROJECT_OWNER                
					,MAX(USER_ID                      )   USER_ID                      
					,MAX(ITEM_NAME                    )   ITEM_NAME                    
					,MAX(ITEM_TYPE                    )   ITEM_TYPE                    
					,MAX(PROJECT_STATUS               )   PROJECT_STATUS               
					,MAX(CUST_GROUP                   )   CUST_GROUP                   
					,MAX(CUST_GROUP_DTL               )   CUST_GROUP_DTL               
					,MAX(APPLICATION                  )   APPLICATION                  
					,MAX(ROUTE                        )   ROUTE                        
					,MAX(MDM_PROJECT_NAME             )   MDM_PROJECT_NAME             
					,MAX(MIN_CAPACITY                 )   MIN_CAPACITY                 
					,MAX(FORECAST_INFO_BIZ_TYPE       )   FORECAST_INFO_BIZ_TYPE       
					,MAX(FORECAST_INFO_PRODUCT_GROUP  )   FORECAST_INFO_PRODUCT_GROUP  
					,MAX(CELL_TYPE                    )   CELL_TYPE                    
					,MAX(FORECAST_INFO_CELL_PACK_COUNT)   FORECAST_INFO_CELL_PACK_COUNT
					,MAX(FORECAST_INFO_ALL            )   FORECAST_INFO_ALL            
					,MAX(FORECAST_INFO_SPEC           )   FORECAST_INFO_SPEC           
					,MAX(FORECAST_INFOR_VERSION       )   FORECAST_INFOR_VERSION       
					,MAX(CELL_MODEL_NICK_NAME         )   CELL_MODEL_NICK_NAME         
					,MAX(VMI_YN                       )   VMI_YN                       
					,MAX(DMS_SALES                    )   DMS_SALES                    
					,MAX(DMS_CUSTOMER                 )   DMS_CUSTOMER                 
					,MAX(DEPT_ID                      )   DEPT_ID                      
					,MAX(DEPT_NAME_KO                 )   DEPT_NAME_KO                 

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					,MAX(CELL_PER_CAR                 )   CELL_PER_CAR                 
					,MAX(CELL_PER_MODULE              )   CELL_PER_MODULE                 
					,MAX(MODULE_PER_CAR               )   MODULE_PER_CAR                 
					-- 20190705 KHSONG [CSR ID:4023158] (END)

					,MAX(ITEM_CLASS_NAME              )   ITEM_CLASS_NAME  -- 20190705 KHSONG [CSR ID:4023158] measure추가를 위한 컬럼추가

					-- 20200130 KHSONG [C20200114-000201]
					,MAX(ENERGE							)	ENERGE
					,MAX(CELL_QUANTITY					)	CELL_QUANTITY
					-- 20200130 KHSONG [C20200114-000201]
					,MAX(ITEM_VALID_YN)						ITEM_VALID_YN	
				into #TempSiteItem
				FROM #TempSiteItemAll WITH(NOLOCK)
			GROUP BY division_id,project_code,scm_site_id,item_id,nick_name,project_name
			;

PRINT ( 'D6--' + CONVERT(NVARCHAR(30), GETDATE(), 121))		


		IF EXISTS ( SELECT * FROM #TempSelectMeasure WHERE MEASURE = 'SHIPMENT_PLAN')
		BEGIN 
		 INSERT INTO #TempIntransitData ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, YYYYMMDD, QTY, SORT_ORDER_NO )
          SELECT T.DIVISION_ID ,T.PROJECT_CODE ,T.SCM_SITE_ID ,T.PLANT_SITE_ID ,T.ITEM_ID ,T.DOM_EXP,T.FCST_TYPE     
                ,T.INCOTERMS ,T.MEASURE ,T.YYYYMMDD ,T.QTY 
				,T.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선   
           FROM   (
               SELECT a.DIVISION_ID
                     ,a.PROJECT_CODE     
                     ,a.TO_SCM_SITE_ID     AS SCM_SITE_ID
                     ,CASE WHEN a.FROM_SCM_SITE_ID IS NULL OR a.FROM_SCM_SITE_ID = '' OR a.DIVISION_ID = '82' THEN '' 
                      ELSE a.FROM_SCM_SITE_ID 
                   END                     AS PLANT_SITE_ID
                    ,a.ITEM_ID   
                    ,a.DOM_EXP
                    ,a.FCST_TYPE
					,a.INCOTERMS
                    ,'IN_TRANSIT'        AS MEASURE
                    ,case when dbo.FN_SCM_SYS_NVL( a.F_DEST_ETA_DATE, IIF( bod.lt_total IS NULL, CONVERT(NVARCHAR(8), DATEADD(DD, -7, CONVERT(DATETIME,getdate())), 112), CONVERT(NVARCHAR(8), DATEADD(d, bod.lt_total, a.plant_issue_date), 112))) < CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  
                     then CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
                     else dbo.FN_SCM_SYS_NVL( a.F_DEST_ETA_DATE, IIF( bod.lt_total IS NULL, CONVERT(NVARCHAR(8), DATEADD(DD, -7, CONVERT(DATETIME,getdate())), 112), CONVERT(NVARCHAR(8), DATEADD(d, bod.lt_total, a.plant_issue_date), 112))) 
                          end AS YYYYMMDD
                     ,SUM(a.DELIVERY_QTY)  AS QTY 
					 ,MAX(M.SORT_ORDER_NO) AS SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
                 FROM dbo.scm_dnm_intransit_c  a WITH (NOLOCK)
					INNER JOIN (
								SELECT division_id, company_id, plant_id, result_type, MAX(result_date) max_result_date  
									FROM dbo.scm_dnm_intransit_c WITH (NOLOCK)
										WHERE 1=1
										AND result_date			   >  CONVERT(NVARCHAR(8), DATEADD(DD, -7*2, CONVERT(DATETIME,getdate())), 112) -- 전전주 일요일
										AND incoterms              <> 'FOB' -- FOB는 해상재고 없음
										AND result_type            IN ('I', 'S')   -- 해상재고
										AND valid_yn                = 'Y'   -- 해상재고
								GROUP BY division_id, company_id, plant_id, result_type
								) c
						ON     a.division_id          = c.division_id
						AND    a.company_id           = c.company_id 
						AND    a.plant_id             = c.plant_id  
						AND    a.result_type          = c.result_type 
						AND    a.result_date          = c.max_result_date 
						AND    a.incoterms            <> 'FOB' -- FOB는 해상재고 없음
						--AND    a.result_type          = 'I'   -- 해상재고  --20181221 KHSONG PR_SCP_ENG_EE_PRE_SET_INTRANSITSHIPMENTS 참조하여 주석처리함
						AND    a.valid_yn             = 'Y'   -- 해상재고
					INNER JOIN ( 
								SELECT division_id, scm_site_id 
									FROM dbo.scm_mst_site WITH (NOLOCK) 
										WHERE  1 = 1
										AND    site_type   = 'SALES' 
										AND    valid_yn    = 'Y'
								) b
						ON   a.division_id       = b.division_id
						AND  a.to_scm_site_id    = b.scm_site_id
					INNER JOIN #TempSelectMeasure m WITH(NOLOCK)
						on   m.measure = 'IN_TRANSIT'
					LEFT JOIN  scp_mst_bod_N_v bod WITH (NOLOCK)
					   ON    bod.division_id = a.division_id
					   AND   bod.from_site   = a.from_scm_site_id
					   AND   bod.to_site     = a.to_scm_site_id
					   AND   bod.incoterms   = a.incoterms
					   AND   bod.transport_mode = a.transport_mode
					   AND   bod.bod_valid_yn   = 'Y'
					   AND	 A.RESULT_DATE BETWEEN BOD.FROM_YYYYMMDD AND BOD.TO_YYYYMMDD	-- 2021.08.24
				WHERE  1=1
					AND C.DIVISION_ID = @p_division_id
                 group by a.DIVISION_ID
						, a.PROJECT_CODE     
						, a.TO_SCM_SITE_ID   
						, CASE WHEN a.FROM_SCM_SITE_ID IS NULL OR a.FROM_SCM_SITE_ID = '' OR a.DIVISION_ID = '82'  THEN ''
								ELSE a.FROM_SCM_SITE_ID 
								END              
						, a.ITEM_ID   
						, a.DOM_EXP
						, a.FCST_TYPE
						, a.INCOTERMS
						,case when dbo.FN_SCM_SYS_NVL( a.F_DEST_ETA_DATE, IIF( bod.lt_total IS NULL, CONVERT(NVARCHAR(8), DATEADD(DD, -7, CONVERT(DATETIME,getdate())), 112), CONVERT(NVARCHAR(8), DATEADD(d, bod.lt_total, a.plant_issue_date), 112))) < CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  
								then CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
							else dbo.FN_SCM_SYS_NVL( a.F_DEST_ETA_DATE, IIF( bod.lt_total IS NULL, CONVERT(NVARCHAR(8), DATEADD(DD, -7, CONVERT(DATETIME,getdate())), 112), CONVERT(NVARCHAR(8), DATEADD(d, bod.lt_total, a.plant_issue_date), 112))) 
							end
						) T		
       WHERE  1 = 1
            AND  T.YYYYMMDD >= @v_from_yyyymmdd
            AND  T.YYYYMMDD <= @v_to_yyyymmdd
            AND  T.QTY            <>  0   --20180514 skh modify
			AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
						ELSE t.scm_site_id
 					END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
			AND    CASE WHEN @p_project_code = '' THEN @p_project_code			
						ELSE t.project_code
 					END  IN ( SELECT token FROM dbo.String_Split(@p_project_code,',') )
			AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id			
						ELSE T.PLANT_SITE_ID
 					END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )
		END

PRINT ( 'D7--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

		IF EXISTS ( SELECT * FROM #TempSelectMeasure WHERE MEASURE = 'SHIPMENT_PLAN')
		BEGIN 
		 INSERT INTO #TempShipmentPlan ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP		
				, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, SORT_ORDER_NO )
          SELECT T.DIVISION_ID ,T.PROJECT_CODE ,T.SCM_SITE_ID ,T.ITEM_ID ,'' AS DOM_EXP
				,T.FCST_TYPE,T.INCOTERMS ,T.MEASURE ,T.PLANT_SITE_ID ,T.YYYYMMDD 
				,SUM(T.QTY) AS QTY
				,MAX(T.SORT_ORDER_NO) AS SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
		   FROM   (
               SELECT a.DIVISION_ID
                     ,a.PROJECT_CODE     
                     ,a.TO_SITE     AS SCM_SITE_ID
                     ,CASE  WHEN a.FROM_SITE IS NULL OR a.FROM_SITE = '' OR a.DIVISION_ID IN ('82','40') THEN '' 
							ELSE a.FROM_SITE 
                   END                     AS PLANT_SITE_ID
                    ,a.ITEM_ID   
                    ,a.FCST_TYPE
                    ,a.INCOTERMS
                    ,'SHIPMENT_PLAN'        AS MEASURE
					--,CONVERT(NVARCHAR(8), DATEADD(DD, a.CUSTOMER_LT, CONVERT(DATETIME,a.YYYYMMDD)), 112) AS YYYYMMDD -- customer_lt 적용
					-- [C20210112-000446]
					,CONVERT(NVARCHAR(8), [DBO].[FN_GET_SSP_ETA_DATE](A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 112) AS YYYYMMDD
                    ,SUM(a.QTY) AS QTY
					,MAX(M.SORT_ORDER_NO) AS SORT_ORDER_NO -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
                 FROM dbo.SSP_ANL_SHIP_CONFIRM  a WITH (NOLOCK)                                                                                            
					INNER JOIN ( 
								SELECT division_id, scm_site_id 
									FROM dbo.scm_mst_site WITH (NOLOCK) 
										WHERE  1 = 1
										AND    site_type   = 'SALES' 
										AND    valid_yn    = 'Y'
								) b
						ON   a.division_id       = b.division_id
						AND  a.TO_SITE			 = b.scm_site_id
						AND  A.CHANGE_TYPE IN ('C','P')
					INNER JOIN #TempSelectMeasure m WITH(NOLOCK)
						on   m.measure = 'SHIPMENT_PLAN'
					INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)  -- 20190121 KHSONG MERGE ADD
					   ON	A.DIVISION_ID	= T2.DIVISION_ID
					  AND	A.project_code	= T2.project_code
					  AND	A.TO_SITE		= T2.SCM_SITE_ID
					  AND	A.ITEM_ID		= T2.ITEM_ID
				WHERE  1=1
				  and a.QTY <> 0
				  and a.division_id = @p_division_id
                 group by a.DIVISION_ID
						, a.PROJECT_CODE     
						, a.TO_SITE
						, CASE WHEN a.FROM_SITE IS NULL OR a.FROM_SITE = '' OR a.DIVISION_ID IN ('82','40')  THEN ''
								ELSE a.FROM_SITE 
								END              
						, a.ITEM_ID   
						, a.FCST_TYPE
						, a.INCOTERMS
						, a.YYYYMMDD
						, A.BOD_ID
						) T		
          WHERE  1 = 1
            --AND  T.YYYYMMDD >= [@v_from_yyyymmdd]
            AND  T.YYYYMMDD >= @v_from_result  -- 과거구간부터 보여줌
            AND  T.YYYYMMDD <= @v_to_yyyymmdd					
			AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
						ELSE t.scm_site_id
 					END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
			AND    CASE WHEN @p_project_code = '' THEN @p_project_code			
						ELSE t.project_code
 					END  IN ( SELECT token FROM dbo.String_Split(@p_project_code,',') )
			GROUP BY T.DIVISION_ID ,T.PROJECT_CODE ,T.SCM_SITE_ID ,T.PLANT_SITE_ID ,T.ITEM_ID ,T.FCST_TYPE     
                ,T.INCOTERMS ,T.MEASURE ,T.YYYYMMDD
		END
				;
PRINT ( 'E1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#T_EDI_SENDER', N'U')	IS NOT NULL	DROP TABLE #T_EDI_SENDER

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#T_EDI_SENDER', N'U')		IS NOT NULL	DROP TABLE #T_EDI_SENDER

		--#T_EDI_SENDER	
		CREATE TABLE #T_EDI_SENDER	(				
					SCM_SITE_ID					NVARCHAR(100)	NULL
					,SENDER_CODE 				NVARCHAR(10)	NULL
					,SENDER_NAME				NVARCHAR(200)	NULL)

		BEGIN
			INSERT INTO #T_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
			SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
			FROM SCM_MST_SITE A WITH(NOLOCK)
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
			ON A.END_CUSTOMER = B.SEGMENT2
			AND A.DIVISION_ID = B.SEGMENT1
			AND B.LOOKUP_TYPE = 'EDI_END_CUSTOMER'
			GROUP BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
		END

		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#T_LAST_DATA_SETUP', N'U') IS NOT NULL   
		DROP TABLE #T_LAST_DATA_SETUP;

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'tempdb..#T_LAST_DATA_SETUP_C', N'U') IS NOT NULL   
		DROP TABLE #T_LAST_DATA_SETUP_C;

		CREATE TABLE #T_LAST_DATA_SETUP (  
			  DIVISION_ID NVARCHAR(30)		  
			  , PROJECT_CODE NVARCHAR(50)  
			  , SCM_SITE_ID NVARCHAR(30)  		  
			  , ITEM_ID  NVARCHAR(50)  
			  , DOM_EXP  NVARCHAR(3)  
			  , FCST_TYPE  NVARCHAR(20)  
			  , INCOTERMS  NVARCHAR(10)  		  
			  , MEASURE  NVARCHAR(50)  		  
			  , CREATE_DATE	NVARCHAR(8)
			  , LAST_UPDATED_BY		NVARCHAR(300)		  
		)

		BEGIN
			INSERT INTO #T_LAST_DATA_SETUP
			SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
						, MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
			FROM (
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
	 							, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
																		 , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN
													(CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																	   MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
															 ELSE MAX(A.ATTRIBUTE9) END)
										  ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 							, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
						FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
						JOIN #TempSelectMeasure B 
						ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
															WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
															WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
															WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'															
															ELSE B.MEASURE END)
						WHERE A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD >= CONVERT(NVARCHAR, DATEADD(YY, -1, @p_from_yyyymmdd ), 112)
						AND A.YYYYMMDD <= @p_to_yyyymmdd
						--AND A.QTY <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
						UNION ALL
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
	 							, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
																		 , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN
													(CASE WHEN ISNULL(MAX(A.ATTRIBUTE9), '') = '' THEN
																	   MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112))
															 ELSE MAX(A.ATTRIBUTE9) END)
										  ELSE MAX(CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112)) END) AS LAST_UPDATE_DATE
	 							, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
						FROM DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
						JOIN #TempSelectMeasure B 
						ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
															WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
															WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
															WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'															
															ELSE B.MEASURE END)
						WHERE A.DIVISION_ID = @p_division_id
						AND A.YYYYMMDD >= CONVERT(NVARCHAR, DATEADD(YY, -1, @p_from_yyyymmdd ), 112)
						AND A.YYYYMMDD <= @p_to_yyyymmdd
						--AND A.QTY <> 0
						GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
						) X
			WHERE ISNULL(X.PROJECT_CODE, '') <> ''
			AND ISNULL(X.SCM_SITE_ID, '') <> ''
			AND ISNULL(X.ITEM_ID, '') <> ''
			GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
		END

		-- EDI LOOKUP 기간
		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#TEMP_EDI_END_CUSTOMER', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#TEMP_EDI_END_CUSTOMER', N'U')					IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER

		--#TEMP_EDI_END_CUSTOMER	
		CREATE TABLE #TEMP_EDI_END_CUSTOMER	(
			DIVISION_ID				NVARCHAR(10)	NULL,
			END_CUSTOMER			NVARCHAR(100)	NULL,
			SCM_SITE_ID				NVARCHAR(60)	NULL,			
			FROM_WEEK				INT					NULL,
			FROM_DAY					NVARCHAR(30)	NULL,			
			TO_WEEK					INT					NULL,
			TO_DAY						NVARCHAR(30)	NULL,
			ACTIVE						NVARCHAR(30)	NULL
			);

		--EDI END_CUSTOMER별 기간 설정
		BEGIN			

			INSERT INTO #TEMP_EDI_END_CUSTOMER ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
			SELECT A.DIVISION_ID AS DIVISION_ID
					 , A.END_CUSTOMER AS END_CUSTOMER
					 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
					 , (CASE WHEN ISNULL(B.SEGMENT5, 'Off') = 'Off' THEN
										  '-52'
								ELSE ISNULL(B.ATTRIBUTE1, '-1')  END) AS FROM_WEEK
					 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
					 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
					 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
					 , ISNULL(B.SEGMENT5, 'Off') AS ACTIVE
			FROM SCM_MST_SITE A WITH(NOLOCK)
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
			ON B.LOOKUP_TYPE = 'EDI_END_CUSTOMER'
				AND A.DIVISION_ID = B.SEGMENT1
				AND A.END_CUSTOMER = B.SEGMENT2
				AND B.VALID_YN = 'Y'
			WHERE ISNULL(A.END_CUSTOMER, '') <> ''
			GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

		END

		-- EDI[Org.] LOOKUP 기간
		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#TEMP_EDI_END_CUSTOMER_ORG', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER_ORG

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#TEMP_EDI_END_CUSTOMER_ORG', N'U')				IS NOT NULL	DROP TABLE #TEMP_EDI_END_CUSTOMER_ORG

		--#TEMP_EDI_END_CUSTOMER_ORG	
		CREATE TABLE #TEMP_EDI_END_CUSTOMER_ORG	(
			DIVISION_ID				NVARCHAR(10)	NULL,
			END_CUSTOMER			NVARCHAR(100)	NULL,
			SCM_SITE_ID				NVARCHAR(60)	NULL,			
			FROM_WEEK				INT					NULL,
			FROM_DAY					NVARCHAR(30)	NULL,			
			TO_WEEK					INT					NULL,
			TO_DAY						NVARCHAR(30)	NULL,
			ACTIVE						NVARCHAR(30)	NULL
			);

		--EDI END_CUSTOMER_ORG별 기간 설정
		BEGIN			

			INSERT INTO #TEMP_EDI_END_CUSTOMER_ORG ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
			SELECT A.DIVISION_ID AS DIVISION_ID
					 , A.END_CUSTOMER AS END_CUSTOMER
					 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
					 , (CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On' THEN
								 ISNULL(B.ATTRIBUTE1, '-1') 
					   ELSE '-52' END) AS FROM_WEEK
					 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
					 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
					 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
					 , ISNULL(B.SEGMENT5, 'On') AS ACTIVE
			FROM SCM_MST_SITE A WITH(NOLOCK)
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
			ON B.LOOKUP_TYPE = 'EDI_END_CUSTOMER_ORG'
				AND A.DIVISION_ID = B.SEGMENT1
				AND A.END_CUSTOMER = B.SEGMENT2
				AND B.VALID_YN = 'Y'
			WHERE ISNULL(A.END_CUSTOMER, '') <> ''
			GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

		END

		-- RPA LOOKUP 기간
		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#TEMP_RPA_END_CUSTOMER', N'U')			IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#TEMP_RPA_END_CUSTOMER', N'U')				IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER

		--#TEMP_EDI_END_CUSTOMER	
		CREATE TABLE #TEMP_RPA_END_CUSTOMER	(
			DIVISION_ID				NVARCHAR(10)	NULL,
			END_CUSTOMER			NVARCHAR(100)	NULL,
			SCM_SITE_ID				NVARCHAR(60)	NULL,			
			FROM_WEEK				INT					NULL,
			FROM_DAY					NVARCHAR(30)	NULL,			
			TO_WEEK					INT					NULL,
			TO_DAY						NVARCHAR(30)	NULL,
			ACTIVE						NVARCHAR(30)	NULL
			);

		--RPA END_CUSTOMER별 기간 설정
		BEGIN	

			INSERT INTO #TEMP_RPA_END_CUSTOMER ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
			SELECT A.DIVISION_ID AS DIVISION_ID
					 , A.END_CUSTOMER AS END_CUSTOMER
					 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
					 , (CASE WHEN ISNULL(B.SEGMENT5, 'Off') = 'Off' THEN
										  '-52'
								ELSE ISNULL(B.ATTRIBUTE1, '-1')  END) AS FROM_WEEK
					 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
					 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
					 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
					 , ISNULL(B.SEGMENT5, 'Off') AS ACTIVE
			FROM SCM_MST_SITE A WITH(NOLOCK)
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
			ON B.LOOKUP_TYPE = 'RPA_END_CUSTOMER'
				AND A.DIVISION_ID = B.SEGMENT1
				AND A.END_CUSTOMER = B.SEGMENT2
				AND B.VALID_YN = 'Y'
			WHERE ISNULL(A.END_CUSTOMER, '') <> ''
			GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

		END

		-- RPA[Org.] LOOKUP 기간
		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#TEMP_RPA_END_CUSTOMER_ORG', N'U')			IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER_ORG

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#TEMP_RPA_END_CUSTOMER_ORG', N'U')				IS NOT NULL	DROP TABLE #TEMP_RPA_END_CUSTOMER_ORG

		--#TEMP_EDI_END_CUSTOMER_ORG	
		CREATE TABLE #TEMP_RPA_END_CUSTOMER_ORG	(
			DIVISION_ID				NVARCHAR(10)	NULL,
			END_CUSTOMER			NVARCHAR(100)	NULL,
			SCM_SITE_ID				NVARCHAR(60)	NULL,			
			FROM_WEEK				INT					NULL,
			FROM_DAY					NVARCHAR(30)	NULL,			
			TO_WEEK					INT					NULL,
			TO_DAY						NVARCHAR(30)	NULL,
			ACTIVE						NVARCHAR(30)	NULL
			);

		--RPA END_CUSTOMER_ORG별 기간 설정
		BEGIN	

			INSERT INTO #TEMP_RPA_END_CUSTOMER_ORG ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
			SELECT A.DIVISION_ID AS DIVISION_ID
					 , A.END_CUSTOMER AS END_CUSTOMER
					 , ISNULL(B.SEGMENT4, '-') AS SCM_SITE_ID
					 , (CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On' THEN
								 ISNULL(B.ATTRIBUTE1, '-1') 
					   ELSE '-52' END) AS FROM_WEEK
					 , ISNULL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
					 , ISNULL(B.ATTRIBUTE3, '0') AS TO_WEEK
					 , ISNULL(B.ATTRIBUTE4, 'MON') AS TO_DAY
					 , ISNULL(B.SEGMENT5, 'On') AS ACTIVE
			FROM SCM_MST_SITE A WITH(NOLOCK)
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
			ON B.LOOKUP_TYPE = 'RPA_END_CUSTOMER_ORG'
				AND A.DIVISION_ID = B.SEGMENT1
				AND A.END_CUSTOMER = B.SEGMENT2
				AND B.VALID_YN = 'Y'
			WHERE ISNULL(A.END_CUSTOMER, '') <> ''
			GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5

		END


		IF ( @v_TO_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) )
		BEGIN
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )                 
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                     , F.INCOTERMS					 
					 , F.MEASURE
					 , F.YYYYMMDD
					 , F.QTY
					 , m.MEASURE_GROUP					 
					 , T2.cell_model  --20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, F.ATTRIBUTE10					
					, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE = F.MEASURE
					   AND QTY <> 0)
					, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE = F.MEASURE)			
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE	
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME                   
                FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)
				INNER JOIN #TempSelectMeasure                m WITH(NOLOCK)  -- 20190121 KHSONG MERGE ADD
				   ON   F.MEASURE		= m.MEASURE
				   --AND F.MEASURE IN ('CUST_FCST', 'Customer FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
				INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)  -- 20190121 KHSONG MERGE ADD
				   ON	F.DIVISION_ID	= T2.DIVISION_ID
				  AND	F.project_code	= T2.project_code
				  AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
				  AND	F.ITEM_ID		= T2.ITEM_ID
				  AND	T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE				
				WHERE 1=1
				AND F.QTY <> 0				
				AND F.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
												   , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
												   , 'Material_Temp[Org.]', 'Backorder[Org.]', 'CUST_FCST', 'Customer FCST')
				AND F.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd				
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
								ELSE F.SCM_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id, ','))
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
								ELSE F.PLANT_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id, ','))

				UNION ALL
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
						 , F.INCOTERMS					 
						 , F.MEASURE
						 , F.YYYYMMDD
						 , F.QTY
						 , m.MEASURE_GROUP					 
						 , T2.cell_model
						 , T2.END_CUSTOMER
						 , T2.NICK_NAME
						 , T2.DMS_SALES
						 , T2.DMS_CUSTOMER
						 , T2.OWNER
						 , T2.DEPT_ID
						 , T2.DEPT_NAME_KO
						 , T2.FORECAST_INFO_CELL_PACK_COUNT
						 , T2.ITEM_TYPE
						 , T2.PROJECT_NAME
						 , T2.PROJECT_OWNER
						 , T2.BIZ_TYPE
						 , T2.SOLDTO_CUSTOMER
						 , T2.COUNTRY_NAME
						 , T2.CITY_NAME
						 , T2.PROJECT_STATUS
						 , T2.ITEM_NAME
						 , T2.VMI_YN
						 , T2.CUST_GROUP
						 , T2.CUST_GROUP_DTL
						 , T2.APPLICATION
						 , T2.ROUTE
						 , T2.MDM_PROJECT_NAME
						 , T2.MIN_CAPACITY
						 , T2.FORECAST_INFO_BIZ_TYPE
						 , T2.CELL_TYPE
						 , T2.FORECAST_INFO_ALL
						 , T2.FORECAST_INFO_SPEC
						 , T2.FORECAST_INFOR_VERSION
						 , T2.CELL_MODEL_NICK_NAME					 
						 , T2.CELL_PER_CAR
						 , T2.CELL_PER_MODULE
						 , T2.MODULE_PER_CAR					
						 , M.SORT_ORDER_NO					 
						 , T2.ENERGE
						 , T2.CELL_QUANTITY					 
						 , F.ATTRIBUTE10					
						 , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
							WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
							AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS 
							AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
						, (CASE WHEN ISNULL(F.ATTRIBUTE5, '') = '' THEN
											(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) + '_EDI'
								  ELSE F.ATTRIBUTE5 + '_' + F.LAST_UPDATED_BY END) AS LAST_UPDATED_BY
						, (CASE WHEN ISNULL(F.ATTRIBUTE4, '') = '' THEN
											(SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID)
								  ELSE F.ATTRIBUTE4 END) AS SENDER_CODE					
						, (CASE WHEN ISNULL(F.ATTRIBUTE5, '') = '' THEN
											(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID)
								  ELSE F.ATTRIBUTE5 END) AS SENDER_NAME					
				FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)				 
				INNER JOIN #TempSelectMeasure                m WITH(NOLOCK)
				ON   F.MEASURE		= m.MEASURE				   
				INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
				ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND	T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
										ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
				WHERE 1=1				
				AND F.QTY <> -9999999999											   
				AND F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
				AND F.ATTRIBUTE9 >= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																	, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																												ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															AND DAYOFWEEK = C.FROM_DAY) D
													WHERE D.RK = C.FROM_WEEK)
				AND F.ATTRIBUTE9 <= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																				ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																	, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																												ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																AND DAYOFWEEK = C.TO_DAY) D 
													WHERE D.RK = C.TO_WEEK)
				AND F.YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd				
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
								ELSE F.SCM_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id, ','))
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
								ELSE F.PLANT_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id, ','))
				AND CASE WHEN (CASE WHEN F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN @p_sender_code ELSE 'ALL' END) = 'ALL' THEN 
											(CASE WHEN F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN @p_sender_code ELSE 'ALL' END)
								ELSE F.ATTRIBUTE4 END IN ( SELECT token FROM dbo.String_Split(CASE WHEN F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN @p_sender_code 
																																	ELSE 'ALL' END, ','))

				UNION ALL
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
					 , F.INCOTERMS					 
					 , F.MEASURE
					 , F.YYYYMMDD
					 , F.QTY
					 , m.MEASURE_GROUP					 
					 , T2.cell_model
					 , T2.END_CUSTOMER
					 , T2.NICK_NAME
					 , T2.DMS_SALES
					 , T2.DMS_CUSTOMER
					 , T2.OWNER
					 , T2.DEPT_ID
					 , T2.DEPT_NAME_KO
					 , T2.FORECAST_INFO_CELL_PACK_COUNT
					 , T2.ITEM_TYPE
					 , T2.PROJECT_NAME
					 , T2.PROJECT_OWNER
					 , T2.BIZ_TYPE
					 , T2.SOLDTO_CUSTOMER
					 , T2.COUNTRY_NAME
					 , T2.CITY_NAME
					 , T2.PROJECT_STATUS
					 , T2.ITEM_NAME
					 , T2.VMI_YN
					 , T2.CUST_GROUP
					 , T2.CUST_GROUP_DTL
					 , T2.APPLICATION
					 , T2.ROUTE
					 , T2.MDM_PROJECT_NAME
					 , T2.MIN_CAPACITY
					 , T2.FORECAST_INFO_BIZ_TYPE
					 , T2.CELL_TYPE
					 , T2.FORECAST_INFO_ALL
					 , T2.FORECAST_INFO_SPEC
					 , T2.FORECAST_INFOR_VERSION
					 , T2.CELL_MODEL_NICK_NAME					 
					 , T2.CELL_PER_CAR
					 , T2.CELL_PER_MODULE
					 , T2.MODULE_PER_CAR					
					 , M.SORT_ORDER_NO					 
					 , T2.ENERGE
					 , T2.CELL_QUANTITY					 
					 , F.ATTRIBUTE10					
					 , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
						WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
						AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS 
						AND MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'))
					, (CASE WHEN ISNULL(F.ATTRIBUTE5, '') = '' THEN
										(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) + '_EDI'
							  ELSE F.ATTRIBUTE5 + '_' + F.LAST_UPDATED_BY END) AS LAST_UPDATED_BY
					, (CASE WHEN ISNULL(F.ATTRIBUTE4, '') = '' THEN
										(SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID)
							  ELSE F.ATTRIBUTE4 END) AS SENDER_CODE					
					, (CASE WHEN ISNULL(F.ATTRIBUTE5, '') = '' THEN
										(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID)
							  ELSE F.ATTRIBUTE5 END) AS SENDER_NAME
                   FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)				 
				INNER JOIN #TempSelectMeasure                m WITH(NOLOCK)
				   ON   F.MEASURE		= m.MEASURE				   
				INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
				   ON	F.DIVISION_ID	= T2.DIVISION_ID
				  AND	F.project_code	= T2.project_code
				  AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
				  AND	F.ITEM_ID		= T2.ITEM_ID
				  AND	T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE		
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
									ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER_ORG C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER_ORG WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
				WHERE 1=1				
				AND F.QTY <> -9999999999											   
				AND F.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
				AND F.ATTRIBUTE9 >= (SELECT BASIS_YYYYMMDD 
												 FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																	, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																														  CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																												ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															AND DAYOFWEEK = C.FROM_DAY) D
												 WHERE D.RK = C.FROM_WEEK)
				AND F.ATTRIBUTE9 <= (SELECT BASIS_YYYYMMDD 
												 FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																				ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																	, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																														 CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																												ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															AND DAYOFWEEK = C.TO_DAY) D 
												 WHERE D.RK = C.TO_WEEK)
				AND F.YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd				
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
								ELSE F.SCM_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id, ','))
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
								ELSE F.PLANT_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id, ','))				
				AND CASE WHEN (CASE WHEN F.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN @p_sender_code ELSE 'ALL' END) = 'ALL' THEN 
											(CASE WHEN F.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN @p_sender_code ELSE 'ALL' END)
								ELSE F.ATTRIBUTE4 END IN ( SELECT token FROM dbo.String_Split(CASE WHEN F.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN @p_sender_code 
																																	ELSE 'ALL' END,','))

				UNION ALL
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
						 , F.INCOTERMS					 
						 , (CASE WHEN F.MEASURE = 'Customer FCST' THEN
											  (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]'
													   ELSE 'Cust.FCST_EXCEL[P+P]' END)
									ELSE F.MEASURE END) AS MEASURE
						 , F.YYYYMMDD
						 , F.QTY
						 , m.MEASURE_GROUP					 
						 , T2.cell_model
						, T2.END_CUSTOMER
						, T2.NICK_NAME
						, T2.DMS_SALES
						, T2.DMS_CUSTOMER
						, T2.OWNER
						, T2.DEPT_ID
						, T2.DEPT_NAME_KO
						, T2.FORECAST_INFO_CELL_PACK_COUNT
						, T2.ITEM_TYPE
						, T2.PROJECT_NAME
						, T2.PROJECT_OWNER
						, T2.BIZ_TYPE
						, T2.SOLDTO_CUSTOMER
						, T2.COUNTRY_NAME
						, T2.CITY_NAME
						, T2.PROJECT_STATUS
						, T2.ITEM_NAME
						, T2.VMI_YN
						, T2.CUST_GROUP
						, T2.CUST_GROUP_DTL
						, T2.APPLICATION
						, T2.ROUTE
						, T2.MDM_PROJECT_NAME
						, T2.MIN_CAPACITY
						, T2.FORECAST_INFO_BIZ_TYPE
						, T2.CELL_TYPE
						, T2.FORECAST_INFO_ALL
						, T2.FORECAST_INFO_SPEC
						, T2.FORECAST_INFOR_VERSION
						, T2.CELL_MODEL_NICK_NAME
						, T2.CELL_PER_CAR
						, T2.CELL_PER_MODULE
						, T2.MODULE_PER_CAR						
						, M.SORT_ORDER_NO
						, T2.ENERGE
						, T2.CELL_QUANTITY						
						, F.ATTRIBUTE10					
						, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
						  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
						  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS 
						  AND MEASURE IN ('CUST_FCST', 'Customer FCST'))
						, (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN F.LAST_UPDATED_BY + '_RPA'
													  ELSE F.LAST_UPDATED_BY + '_EXCEL' END) AS LAST_UPDATED_BY					
						, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE					
						, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
				FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)				 
				INNER JOIN #TempSelectMeasure	M WITH(NOLOCK)
				ON F.MEASURE = M.MEASURE					   
				INNER JOIN #TempSiteItem	T2  WITH(NOLOCK)
				ON F.DIVISION_ID = T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND	T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 
				ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
				WHERE 1=1				
				AND F.QTY <> 0
				AND F.MEASURE IN ('CUST_FCST', 'Customer FCST')
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																								  ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.FROM_DAY) D
																									WHERE D.RK = C.FROM_WEEK)
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																																  ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											 CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																								   ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.TO_DAY) D 
																									WHERE D.RK = C.TO_WEEK)
				AND F.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
								ELSE F.SCM_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
								ELSE F.PLANT_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )


			IF EXISTS ( SELECT * FROM #TempSelectMeasure
						   WHERE MEASURE IN ('CUST_FCST_ORG', 'Customer Fcst[Org.]') )
			BEGIN
				
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
					 , 'CUST_FCST_ORG' AS MEASURE
					 , F.YYYYMMDD
					 , F.QTY
					 , M.MEASURE_GROUP			
					 , T2.cell_model
					 , T2.END_CUSTOMER
					 , T2.NICK_NAME
					 , T2.DMS_SALES
					 , T2.DMS_CUSTOMER
					 , T2.OWNER
					 , T2.DEPT_ID
					 , T2.DEPT_NAME_KO
					 , T2.FORECAST_INFO_CELL_PACK_COUNT
					 , T2.ITEM_TYPE
					 , T2.PROJECT_NAME
					 , T2.PROJECT_OWNER
					 , T2.BIZ_TYPE
					 , T2.SOLDTO_CUSTOMER
					 , T2.COUNTRY_NAME
					 , T2.CITY_NAME
					 , T2.PROJECT_STATUS
					 , T2.ITEM_NAME
					 , T2.VMI_YN
					 , T2.CUST_GROUP
					 , T2.CUST_GROUP_DTL
					 , T2.APPLICATION
					 , T2.ROUTE
					 , T2.MDM_PROJECT_NAME
					 , T2.MIN_CAPACITY
					 , T2.FORECAST_INFO_BIZ_TYPE
					 , T2.CELL_TYPE
					 , T2.FORECAST_INFO_ALL
					 , T2.FORECAST_INFO_SPEC
					 , T2.FORECAST_INFOR_VERSION
					 , T2.CELL_MODEL_NICK_NAME					
					 , T2.CELL_PER_CAR
					 , T2.CELL_PER_MODULE
					 , T2.MODULE_PER_CAR					
					 , M.SORT_ORDER_NO					
					 , T2.ENERGE
					 , T2.CELL_QUANTITY					
					 , F.ATTRIBUTE10					
					 , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS 
					   AND MEASURE IN ('CUST_FCST', 'Customer FCST'))		
					 , (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN F.LAST_UPDATED_BY + '_RPA'
								ELSE F.LAST_UPDATED_BY + '_EXCEL' END)
					 , (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					 , (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)				  
                INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
                ON F.MEASURE = 'CUST_FCST'
					AND M.MEASURE = 'CUST_FCST_ORG'
                INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
                ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 
				ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
                WHERE 1=1
                AND F.MEASURE = 'CUST_FCST'
                AND F.QTY <> 0
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																								  ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.FROM_DAY) D
																									WHERE D.RK = C.FROM_WEEK)
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																																  ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											 CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																								   ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.TO_DAY) D 
																									WHERE D.RK = C.TO_WEEK)
                AND F.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							   ELSE F.SCM_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
						       ELSE F.PLANT_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

				UNION ALL
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
					 , (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[Org.]'
						 	    ELSE 'Cust.FCST_EXCEL[Org.]' END) AS MEASURE
					 , F.YYYYMMDD
					 , F.QTY
					 , M.MEASURE_GROUP			
					 , T2.cell_model
					 , T2.END_CUSTOMER
					 , T2.NICK_NAME
					 , T2.DMS_SALES
					 , T2.DMS_CUSTOMER
					 , T2.OWNER
					 , T2.DEPT_ID
					 , T2.DEPT_NAME_KO
					 , T2.FORECAST_INFO_CELL_PACK_COUNT
					 , T2.ITEM_TYPE
					 , T2.PROJECT_NAME
					 , T2.PROJECT_OWNER
					 , T2.BIZ_TYPE
					 , T2.SOLDTO_CUSTOMER
					 , T2.COUNTRY_NAME
					 , T2.CITY_NAME
					 , T2.PROJECT_STATUS
					 , T2.ITEM_NAME
					 , T2.VMI_YN
					 , T2.CUST_GROUP
					 , T2.CUST_GROUP_DTL
					 , T2.APPLICATION
					 , T2.ROUTE
					 , T2.MDM_PROJECT_NAME
					 , T2.MIN_CAPACITY
					 , T2.FORECAST_INFO_BIZ_TYPE
					 , T2.CELL_TYPE
					 , T2.FORECAST_INFO_ALL
					 , T2.FORECAST_INFO_SPEC
					 , T2.FORECAST_INFOR_VERSION
					 , T2.CELL_MODEL_NICK_NAME					
					 , T2.CELL_PER_CAR
					 , T2.CELL_PER_MODULE
					 , T2.MODULE_PER_CAR					
					 , M.SORT_ORDER_NO					
					 , T2.ENERGE
					 , T2.CELL_QUANTITY					
					 , F.ATTRIBUTE10					
					 , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS 
					   AND MEASURE IN ('CUST_FCST', 'Customer FCST'))
					 , (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN F.LAST_UPDATED_BY + '_RPA'
								ELSE F.LAST_UPDATED_BY + '_EXCEL' END)
					 , (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					 , (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)				  
                INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
                ON F.MEASURE = 'Customer FCST'
					AND M.MEASURE = 'Customer FCST[Org.]'
                INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
                ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 
				ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
                WHERE 1=1
                AND F.MEASURE = 'Customer FCST'
                AND F.QTY <> 0
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																								  ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.FROM_DAY) D
																									WHERE D.RK = C.FROM_WEEK)
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																																  ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											 CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																								   ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.TO_DAY) D 
																									WHERE D.RK = C.TO_WEEK)
                AND F.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							   ELSE F.SCM_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
						       ELSE F.PLANT_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

			END	
								
			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure
						WHERE MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') )
			BEGIN
				
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                 SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                     , F.INCOTERMS
					 , 
					 CASE 
						WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN M.MEASURE
						ELSE F.MEASURE
					 END
					 AS MEASURE
					 , F.YYYYMMDD
					 , 
					 CASE 
						WHEN M.MEASURE = 'MKT_FCST_RP' THEN F.QTY
						WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
							CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY / T2.CELL_PER_CAR
								ELSE
									CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY / T2.CELL_PER_CAR

										 -- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(BEGIN)
										 --WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/ ( T2.CELL_PER_CAR/ T2.CELL_PER_MODULE )
										 -- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(END)

										 -- 20200218 KHSONG C20200212-000304 (BEGIN)
										 WHEN  CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0  AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/T2.MODULE_PER_CAR --[C20200511-000360] MKT FCST[X+X] CAR - Module일 경우 = QTY / MODULE_PER_CAR
										 WHEN  CHARINDEX('Pack'  , T2.ITEM_CLASS_NAME) > 0  THEN F.QTY
										 -- 20200218 KHSONG C20200212-000304 (END)
									ELSE 0 
									END
							END
						WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND  F.DIVISION_ID LIKE '81%' THEN  
						    CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY
							 	 --WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
								 --[C20200511-000360] MKT FCST[X+X] CELL - Pack일 경우 = QTY * CELL_PER_CAR
							 	 WHEN CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
							 	 WHEN CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_CAR

							ELSE 0 
							END
						-- 20200130 KHSONG [C20200114-000201] 자동차 사업부와 ESS 사업부 구분로직 추가함
						WHEN M.MEASURE = 'MKT_FCST_RP_CELL' AND  F.DIVISION_ID = '82' THEN  
						    F.QTY * CELL_QUANTITY  -- 일단 기본적으로 곱하기설정함
						-- 20200130 KHSONG [C20200114-000201] 자동차 사업부와 ESS 사업부 구분로직 추가함

					 END 
					 AS QTY

					 --F.QTY
					 , m.MEASURE_GROUP			
					, T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, F.ATTRIBUTE10					
					, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE = 'MKT_FCST')										
					, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE = 'MKT_FCST'
					  AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
													  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
													  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE = 'MKT_FCST'))
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                   FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)				  
                  INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
				     ON F.MEASURE = 'MKT_FCST'
                    AND M.MEASURE IN  ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
				  INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					 ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND T2.ITEM_VALID_YN = 'Y'
					INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				WHERE 1=1
				AND F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP','MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'MKT_FCST' ELSE M.MEASURE END					
				AND F.QTY <> 0
				and f.YYYYMMDD between @v_from_yyyymmdd and @v_to_yyyymmdd
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )
			END

			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure
						WHERE MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') )
			BEGIN

				------------------------------------------------------------------------------------------------------------------------------------
				-- 20190705 KHSONG [CSR ID:4023158] MEASURE 추가 DM_PLN_MKT_FCST (BEGIN)
				------------------------------------------------------------------------------------------------------------------------------------
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                    , F.INCOTERMS
					,CASE 
						WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
							CASE WHEN F.MEASURE = 'RTF' THEN 'RTF_RP_CAR' WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR' 
							ELSE '' 
							END
						WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
							CASE WHEN F.MEASURE = 'RTF' THEN 'RTF_RP_CELL' WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL' 
							ELSE '' 
							END
						-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
						WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' 
							THEN 'RTF_ENERGY'
					 END
					 AS MEASURE
					, F.YYYYMMDD
					, 
					 CASE 
						WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
							 CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY / T2.CELL_PER_CAR

									-- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(BEGIN)
									--WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/ ( T2.CELL_PER_CAR/ T2.CELL_PER_MODULE )
									-- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(END)

									-- 20200218 KHSONG C20200212-000304 (BEGIN)
									WHEN  CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0  AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/ T2.MODULE_PER_CAR --[C20200511-000360] MKT FCST[X+X] CAR - Module일 경우 = QTY / MODULE_PER_CAR
									WHEN  CHARINDEX('Pack'  , T2.ITEM_CLASS_NAME) > 0  THEN F.QTY
									-- 20200218 KHSONG C20200212-000304 (END)

							 ELSE 0 
							 END
						WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') AND  F.DIVISION_ID LIKE '81%' THEN 
							 CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY
								  --WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
								  --[C20200511-000360] MKT FCST[X+X] CELL - Pack일 경우 = QTY * CELL_PER_CAR
							 	 WHEN CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
							 	 WHEN CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_CAR

							 ELSE 0 
							 END
						-- 20200130 KHSONG [C20200114-000201] 자동차 사업부와 ESS 사업부 구분로직 추가함
						WHEN M.MEASURE = 'RTF_RP_CELL' AND  F.DIVISION_ID = '82' THEN  
						    F.QTY * CELL_QUANTITY  -- 일단 기본적으로 곱하기설정함
						-- 20200130 KHSONG [C20200114-000201] 자동차 사업부와 ESS 사업부 구분로직 추가함
						-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
						WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' THEN
							CASE WHEN ISNUMERIC(T2.ENERGE) > 0
								THEN ROUND((T2.ENERGE * F.QTY)/1000, 0)
							END
					 END 
					 AS QTY
					, m.MEASURE_GROUP			
					, T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, F.ATTRIBUTE10
					, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE IN ('RTF','RTF_SYS_RP'))					
					, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE  IN ('RTF','RTF_SYS_RP')
					  AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
													  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
													  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE  IN ('RTF','RTF_SYS_RP')))
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                   FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)			  
                  INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
				     ON F.MEASURE IN ('RTF','RTF_SYS_RP')
                    AND M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY')
				  INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					 ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND T2.ITEM_VALID_YN = 'Y'
					INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				WHERE 1=1
				AND F.MEASURE = CASE WHEN M.MEASURE in ('RTF_RP_CAR','RTF_RP_CELL') THEN 'RTF' WHEN M.MEASURE in ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP' ELSE M.MEASURE END					
				AND F.QTY <> 0
				and f.YYYYMMDD between @v_from_yyyymmdd and @v_to_yyyymmdd
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

						
				------------------------------------------------------------------------------------------------------------------------------------
				-- 20190705 KHSONG [CSR ID:4023158] MEASURE 추가 DM_PLN_MKT_FCST (END)
				------------------------------------------------------------------------------------------------------------------------------------
			END

			-- 20221214 rosia27	[C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure WHERE MEASURE IN ('MKT_FCST_ENERGY') )
			BEGIN

				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                    , F.INCOTERMS
					, CASE 
						WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'MKT_FCST_RP' 
							THEN 'MKT_FCST_ENERGY'
					 END
					 AS MEASURE
					, F.YYYYMMDD
					, 
					 CASE 
						WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
							CASE WHEN ISNUMERIC(T2.ENERGE) > 0
								THEN ROUND((T2.ENERGE * F.QTY) / 1000, 0)
							END
						ELSE 0
					 END 
					 AS QTY
					, m.MEASURE_GROUP			
					, T2.cell_model	
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					,M.SORT_ORDER_NO
					,T2.ENERGE
					,T2.CELL_QUANTITY
					, F.AS_FROM_SITE
					, F.CREATE_DATE
					, F.LAST_UPDATED_BY
					, F.SENDER_CODE
					, F.SENDER_NAME
                   FROM #TempMktFcstData      F WITH(NOLOCK)			  
                  INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
				     ON F.MEASURE = 'MKT_FCST_RP'
                    AND M.MEASURE = 'MKT_FCST_ENERGY'
				  INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					 ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND T2.ITEM_VALID_YN = 'Y'
					INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				WHERE 1=1					
				AND F.QTY <> 0
				and f.YYYYMMDD between @v_from_yyyymmdd and @v_to_yyyymmdd
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )
			END
		END

				------------------------------------------------------------------------------------------------------------------------------------
				-- 20190705 KHSONG [CSR ID:4023158] MEASURE 추가 DM_PLN_MKT_FCST_RESULT (BEGIN)
				------------------------------------------------------------------------------------------------------------------------------------

		IF ( @v_from_yyyymmdd <= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) )
		BEGIN
--select 'xxx'
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )                
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
						, F.INCOTERMS						
						, F.MEASURE
						, F.YYYYMMDD, F.QTY
						, m.MEASURE_GROUP			
						, T2.cell_model	--20180809 ytchoi modify					 
						, T2.END_CUSTOMER
						, T2.NICK_NAME
						, T2.DMS_SALES
						, T2.DMS_CUSTOMER
						, T2.OWNER
						, T2.DEPT_ID
						, T2.DEPT_NAME_KO
						, T2.FORECAST_INFO_CELL_PACK_COUNT
						, T2.ITEM_TYPE
						, T2.PROJECT_NAME
						, T2.PROJECT_OWNER
						, T2.BIZ_TYPE
						, T2.SOLDTO_CUSTOMER
						, T2.COUNTRY_NAME
						, T2.CITY_NAME
						, T2.PROJECT_STATUS
						, T2.ITEM_NAME
						, T2.VMI_YN
						, T2.CUST_GROUP
						, T2.CUST_GROUP_DTL
						, T2.APPLICATION
						, T2.ROUTE
						, T2.MDM_PROJECT_NAME
						, T2.MIN_CAPACITY
						, T2.FORECAST_INFO_BIZ_TYPE
						, T2.CELL_TYPE
						, T2.FORECAST_INFO_ALL
						, T2.FORECAST_INFO_SPEC
						, T2.FORECAST_INFOR_VERSION
						, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
						-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
						, T2.CELL_PER_CAR
						, T2.CELL_PER_MODULE
						, T2.MODULE_PER_CAR
						-- 20190705 KHSONG [CSR ID:4023158] (END)
						,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
						--20200130 KHSONG [C20200114-000201]
						,T2.ENERGE
						,T2.CELL_QUANTITY
						--20200130 KHSONG [C20200114-000201]
						, F.ATTRIBUTE10					
						, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
						  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
						  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
						  AND MEASURE = (CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END))					
						, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
						  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
						  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
						  AND MEASURE = (CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END)
						  AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
														  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
														  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
														  AND MEASURE = (CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END))) AS LAST_UPDATED_BY					
						, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE						
						, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
				FROM [dbo].[DM_PLN_MKT_FCST_RESULT]   F WITH(NOLOCK)
				INNER JOIN #TempSelectMeasure              m WITH(NOLOCK)
					ON F.MEASURE		= m.MEASURE      
				--AND F.MEASURE IN ('CUST_FCST', 'Customer FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
				INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					ON	F.DIVISION_ID	= T2.DIVISION_ID
				AND	F.project_code	= T2.project_code
				AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
				AND	F.ITEM_ID		= T2.ITEM_ID
				INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				WHERE 1=1
				AND F.QTY <> 0
				AND F.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
											       , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
												   , 'Material_Temp[Org.]', 'Backorder[Org.]', 'CUST_FCST', 'Customer FCST')
				--and f.YYYYMMDD between @p_from_yyyymmdd and @v_to_result --[prepare] MKT Fcst Result 구간 변경(전주 일요일까지)
				AND f.yyyymmdd >= @p_from_yyyymmdd AND f.yyyymmdd < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

				UNION ALL
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
						, F.INCOTERMS						
						, F.MEASURE
						, F.YYYYMMDD, F.QTY
						, m.MEASURE_GROUP			
						, T2.cell_model	--20180809 ytchoi modify					 
						, T2.END_CUSTOMER
						, T2.NICK_NAME
						, T2.DMS_SALES
						, T2.DMS_CUSTOMER
						, T2.OWNER
						, T2.DEPT_ID
						, T2.DEPT_NAME_KO
						, T2.FORECAST_INFO_CELL_PACK_COUNT
						, T2.ITEM_TYPE
						, T2.PROJECT_NAME
						, T2.PROJECT_OWNER
						, T2.BIZ_TYPE
						, T2.SOLDTO_CUSTOMER
						, T2.COUNTRY_NAME
						, T2.CITY_NAME
						, T2.PROJECT_STATUS
						, T2.ITEM_NAME
						, T2.VMI_YN
						, T2.CUST_GROUP
						, T2.CUST_GROUP_DTL
						, T2.APPLICATION
						, T2.ROUTE
						, T2.MDM_PROJECT_NAME
						, T2.MIN_CAPACITY
						, T2.FORECAST_INFO_BIZ_TYPE
						, T2.CELL_TYPE
						, T2.FORECAST_INFO_ALL
						, T2.FORECAST_INFO_SPEC
						, T2.FORECAST_INFOR_VERSION
						, T2.CELL_MODEL_NICK_NAME					
						, T2.CELL_PER_CAR
						, T2.CELL_PER_MODULE
						, T2.MODULE_PER_CAR					
						, M.SORT_ORDER_NO
						, T2.ENERGE
						, T2.CELL_QUANTITY					
						, F.ATTRIBUTE10										
						, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
						  WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
						  AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
						  AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
						, (CASE WHEN ISNULL(F.ATTRIBUTE5, '') = '' THEN
											(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) + '_EDI'
								   ELSE F.ATTRIBUTE5 + '_' + F.LAST_UPDATED_BY END) AS LAST_UPDATED_BY
						, (CASE WHEN ISNULL(F.ATTRIBUTE4, '') = '' THEN
											(SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID)
								   ELSE F.ATTRIBUTE4 END) AS SENDER_CODE					
						, (CASE WHEN ISNULL(F.ATTRIBUTE5, '') = '' THEN
											(SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID)
								   ELSE F.ATTRIBUTE5 END) AS SENDER_NAME	
				FROM [dbo].[DM_PLN_MKT_FCST_RESULT]   F WITH(NOLOCK)				  
				INNER JOIN #TempSelectMeasure              m WITH(NOLOCK)
					ON F.MEASURE		= m.MEASURE					
				INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					ON	F.DIVISION_ID	= T2.DIVISION_ID
				AND	F.project_code	= T2.project_code
				AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
				AND	F.ITEM_ID		= T2.ITEM_ID
				INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
										ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_EDI_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
				WHERE 1=1
				AND F.QTY <> -9999999999											   
				AND F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
				AND F.ATTRIBUTE9 >= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																		, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																												ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															AND DAYOFWEEK = C.FROM_DAY) D
													WHERE D.RK = C.FROM_WEEK)
				AND F.ATTRIBUTE9 <= (SELECT BASIS_YYYYMMDD 
													FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																					ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																		, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
															WHERE BASIS_YYYYMMDD >= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																															CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																												ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
															AND DAYOFWEEK = C.TO_DAY) D 
													WHERE D.RK = C.TO_WEEK)
				AND F.YYYYMMDD >= @p_from_yyyymmdd AND F.YYYYMMDD < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
								ELSE F.SCM_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id, ','))
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
								ELSE F.PLANT_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id, ','))
				AND CASE WHEN (CASE WHEN F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN @p_sender_code ELSE 'ALL' END) = 'ALL' THEN 
											(CASE WHEN F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN @p_sender_code ELSE 'ALL' END)
								ELSE F.ATTRIBUTE4 END IN ( SELECT token FROM dbo.String_Split(CASE WHEN F.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN @p_sender_code 
																																	ELSE 'ALL' END, ','))

				UNION ALL
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
						 , F.INCOTERMS						
						 , (CASE WHEN F.MEASURE = 'Customer FCST' THEN
											 (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]'
													  ELSE 'Cust.FCST_EXCEL[P+P]' END)
								    ELSE F.MEASURE END) AS MEASURE
						 , F.YYYYMMDD, F.QTY
						 , M.MEASURE_GROUP			
						 , T2.cell_model
						 , T2.END_CUSTOMER
						 , T2.NICK_NAME
						 , T2.DMS_SALES
						 , T2.DMS_CUSTOMER
						 , T2.OWNER
						 , T2.DEPT_ID
						 , T2.DEPT_NAME_KO
						 , T2.FORECAST_INFO_CELL_PACK_COUNT
						 , T2.ITEM_TYPE
						 , T2.PROJECT_NAME
						 , T2.PROJECT_OWNER
						 , T2.BIZ_TYPE
						 , T2.SOLDTO_CUSTOMER
						 , T2.COUNTRY_NAME
						 , T2.CITY_NAME
						 , T2.PROJECT_STATUS
						 , T2.ITEM_NAME
						 , T2.VMI_YN
						 , T2.CUST_GROUP
						 , T2.CUST_GROUP_DTL
						 , T2.APPLICATION
						 , T2.ROUTE
						 , T2.MDM_PROJECT_NAME
						 , T2.MIN_CAPACITY
						 , T2.FORECAST_INFO_BIZ_TYPE
						 , T2.CELL_TYPE
						 , T2.FORECAST_INFO_ALL
						 , T2.FORECAST_INFO_SPEC
						 , T2.FORECAST_INFOR_VERSION
						 , T2.CELL_MODEL_NICK_NAME						 
						 , T2.CELL_PER_CAR
						 , T2.CELL_PER_MODULE
						 , T2.MODULE_PER_CAR						 
						 , M.SORT_ORDER_NO						 
						 , T2.ENERGE
						 , T2.CELL_QUANTITY						 
						 , F.ATTRIBUTE10					
						 , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
							WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
							AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
							AND MEASURE IN ('CUST_FCST', 'Customer FCST'))										
						 , (CASE WHEN F.CREATED_BY LIKE '%robot' THEN F.CREATED_BY + '_RPA'
									ELSE F.CREATED_BY + '_EXCEL' END) AS LAST_UPDATED_BY					
						 , (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE					
						 , (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
				FROM [dbo].[DM_PLN_MKT_FCST_RESULT]   F WITH(NOLOCK)				  
				INNER JOIN #TempSelectMeasure              M WITH(NOLOCK)
				ON F.MEASURE		= M.MEASURE      				
				INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
				ON F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
				INNER JOIN #T_WS_FCST T3 
				ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
				WHERE 1=1				
				AND F.QTY <> 0
				AND F.MEASURE IN ('CUST_FCST', 'Customer FCST')				
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																								  ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.FROM_DAY) D
																									WHERE D.RK = C.FROM_WEEK)
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																																  ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											 CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																								   ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.TO_DAY) D 
																									WHERE D.RK = C.TO_WEEK)
				AND F.YYYYMMDD >= @p_from_yyyymmdd AND F.YYYYMMDD < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id
								ELSE F.SCM_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id
								ELSE F.PLANT_SITE_ID END IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )				


			IF EXISTS ( SELECT * FROM #TempSelectMeasure
						   WHERE MEASURE IN ('CUST_FCST_ORG', 'Customer Fcst[Org.]') )
			BEGIN
				
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
					 , 'CUST_FCST_ORG' AS MEASURE
					 , F.YYYYMMDD
					 , F.QTY
					 , M.MEASURE_GROUP			
					 , T2.cell_model
					 , T2.END_CUSTOMER
					 , T2.NICK_NAME
					 , T2.DMS_SALES
					 , T2.DMS_CUSTOMER
					 , T2.OWNER
					 , T2.DEPT_ID
					 , T2.DEPT_NAME_KO
					 , T2.FORECAST_INFO_CELL_PACK_COUNT
					 , T2.ITEM_TYPE
					 , T2.PROJECT_NAME
					 , T2.PROJECT_OWNER
					 , T2.BIZ_TYPE
					 , T2.SOLDTO_CUSTOMER
					 , T2.COUNTRY_NAME
					 , T2.CITY_NAME
					 , T2.PROJECT_STATUS
					 , T2.ITEM_NAME
					 , T2.VMI_YN
					 , T2.CUST_GROUP
					 , T2.CUST_GROUP_DTL
					 , T2.APPLICATION
					 , T2.ROUTE
					 , T2.MDM_PROJECT_NAME
					 , T2.MIN_CAPACITY
					 , T2.FORECAST_INFO_BIZ_TYPE
					 , T2.CELL_TYPE
					 , T2.FORECAST_INFO_ALL
					 , T2.FORECAST_INFO_SPEC
					 , T2.FORECAST_INFOR_VERSION
					 , T2.CELL_MODEL_NICK_NAME					
					 , T2.CELL_PER_CAR
					 , T2.CELL_PER_MODULE
					 , T2.MODULE_PER_CAR					
					 , M.SORT_ORDER_NO					
					 , T2.ENERGE
					 , T2.CELL_QUANTITY					
					 , F.ATTRIBUTE10					
					 , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS 
					   AND MEASURE IN ('CUST_FCST', 'Customer FCST'))
					 , (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN F.LAST_UPDATED_BY + '_RPA'
								ELSE F.LAST_UPDATED_BY + '_EXCEL' END)
					 , (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					 , (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                FROM [dbo].[DM_PLN_MKT_FCST_RESULT]       F WITH(NOLOCK)				  
                INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
                ON F.MEASURE = 'CUST_FCST'
					AND M.MEASURE = 'CUST_FCST_ORG'
                INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
                ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 
				ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
                WHERE 1=1
                AND F.MEASURE = 'CUST_FCST'
                AND F.QTY <> 0
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																								  ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.FROM_DAY) D
																									WHERE D.RK = C.FROM_WEEK)
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																																  ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											 CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																								   ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.TO_DAY) D 
																									WHERE D.RK = C.TO_WEEK)
                AND F.YYYYMMDD >= @p_from_yyyymmdd AND F.YYYYMMDD < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							   ELSE F.SCM_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
						       ELSE F.PLANT_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

				UNION ALL
				SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS
					 , (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN 'Cust.FCST_RPA[Org.]'
						 	    ELSE 'Cust.FCST_EXCEL[Org.]' END) AS MEASURE
					 , F.YYYYMMDD
					 , F.QTY
					 , M.MEASURE_GROUP			
					 , T2.cell_model
					 , T2.END_CUSTOMER
					 , T2.NICK_NAME
					 , T2.DMS_SALES
					 , T2.DMS_CUSTOMER
					 , T2.OWNER
					 , T2.DEPT_ID
					 , T2.DEPT_NAME_KO
					 , T2.FORECAST_INFO_CELL_PACK_COUNT
					 , T2.ITEM_TYPE
					 , T2.PROJECT_NAME
					 , T2.PROJECT_OWNER
					 , T2.BIZ_TYPE
					 , T2.SOLDTO_CUSTOMER
					 , T2.COUNTRY_NAME
					 , T2.CITY_NAME
					 , T2.PROJECT_STATUS
					 , T2.ITEM_NAME
					 , T2.VMI_YN
					 , T2.CUST_GROUP
					 , T2.CUST_GROUP_DTL
					 , T2.APPLICATION
					 , T2.ROUTE
					 , T2.MDM_PROJECT_NAME
					 , T2.MIN_CAPACITY
					 , T2.FORECAST_INFO_BIZ_TYPE
					 , T2.CELL_TYPE
					 , T2.FORECAST_INFO_ALL
					 , T2.FORECAST_INFO_SPEC
					 , T2.FORECAST_INFOR_VERSION
					 , T2.CELL_MODEL_NICK_NAME					
					 , T2.CELL_PER_CAR
					 , T2.CELL_PER_MODULE
					 , T2.MODULE_PER_CAR					
					 , M.SORT_ORDER_NO					
					 , T2.ENERGE
					 , T2.CELL_QUANTITY					
					 , F.ATTRIBUTE10					
					 , (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS 
					   AND MEASURE IN ('CUST_FCST', 'Customer FCST'))
					 , (CASE WHEN F.LAST_UPDATED_BY LIKE '%robot' THEN F.LAST_UPDATED_BY + '_RPA'
								ELSE F.LAST_UPDATED_BY + '_EXCEL' END)
					 , (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					 , (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                FROM [dbo].[DM_PLN_MKT_FCST_RESULT]       F WITH(NOLOCK)				  
                INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
                ON F.MEASURE = 'Customer FCST'
					AND M.MEASURE = 'Customer FCST[Org.]'
                INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
                ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND T2.ITEM_VALID_YN = 'Y'
				INNER JOIN #T_WS_FCST T3 
				ON F.FCST_TYPE = T3.FCST_TYPE
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON F.DIVISION_ID = B.DIVISION_ID
					AND F.SCM_SITE_ID = B.SCM_SITE_ID
					AND B.SITE_TYPE		= 'SALES'
					AND B.VALID_YN		= 'Y'
					AND (CASE WHEN F.DIVISION_ID = '40' THEN ISNULL(B.END_CUSTOMER, '-')
									 ELSE ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') END) <> ''
				LEFT OUTER JOIN #TEMP_RPA_END_CUSTOMER_ORG C WITH(NOLOCK)
				ON F.DIVISION_ID = C.DIVISION_ID
					AND C.END_CUSTOMER = B.END_CUSTOMER
					AND C.SCM_SITE_ID = ISNULL((SELECT SCM_SITE_ID FROM #TEMP_RPA_END_CUSTOMER_ORG WITH(NOLOCK)
									 							WHERE DIVISION_ID = F.DIVISION_ID
									 							AND END_CUSTOMER = B.END_CUSTOMER
									 							AND SCM_SITE_ID = F.SCM_SITE_ID), '-')
                WHERE 1=1
                AND F.MEASURE = 'Customer FCST'
                AND F.QTY <> 0
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) >= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT RANK() OVER(ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD <= (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)
																																								  ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.FROM_DAY) D
																									WHERE D.RK = C.FROM_WEEK)
				AND CONVERT(NVARCHAR, F.LAST_UPDATE_DATE, 112) <= (SELECT BASIS_YYYYMMDD 
																									FROM (SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 2 
																																  ELSE RANK() OVER(ORDER BY BASIS_YYYYMMDD ) - 1 END) AS RK 
																														, DT.BASIS_YYYYMMDD 
																											  FROM SCM_SYS_CALENDAR_M DT WITH(NOLOCK) 
																											  WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN
																																											 CONVERT(NVARCHAR, DATEADD(DD, -1, GETDATE()), 112)																
																																								   ELSE CONVERT(NVARCHAR, GETDATE(), 112) END)
																											  AND DAYOFWEEK = C.TO_DAY) D 
																									WHERE D.RK = C.TO_WEEK)
				AND F.YYYYMMDD >= @p_from_yyyymmdd AND F.YYYYMMDD < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							   ELSE F.SCM_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
						       ELSE F.PLANT_SITE_ID END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

			END

			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure
						WHERE MEASURE IN  ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') )
			BEGIN

				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                    , F.INCOTERMS
					,CASE 
						WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN M.MEASURE
						ELSE F.MEASURE
					 END
					 AS MEASURE
					
					 , F.YYYYMMDD

					 , 
					 CASE 
						WHEN M.MEASURE = 'MKT_FCST_RP_CAR' THEN
							 CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY / T2.CELL_PER_CAR
										 -- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(BEGIN)
										 --WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/ ( T2.CELL_PER_CAR/ T2.CELL_PER_MODULE )
										 -- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(END)

										 -- 20200218 KHSONG C20200212-000304 (BEGIN)
										 WHEN  CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0  AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/ T2.MODULE_PER_CAR --[C20200511-000360] MKT FCST[X+X] CAR - Module일 경우 = QTY / MODULE_PER_CAR
										 WHEN  CHARINDEX('Pack'  , T2.ITEM_CLASS_NAME) > 0  THEN F.QTY
										 -- 20200218 KHSONG C20200212-000304 (END)
							 ELSE 0 
							 END

						WHEN M.MEASURE = 'MKT_FCST_RP_CELL' THEN
							 CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY
								  --WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
								  --[C20200511-000360] MKT FCST[X+X] CELL - Pack일 경우 = QTY * CELL_PER_CAR
							 	 WHEN CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
							 	 WHEN CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_CAR
							 ELSE 0 
							 END
					 END 
					 AS QTY

					, m.MEASURE_GROUP			
					, T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, F.ATTRIBUTE10
					, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
					   AND MEASURE = 'MKT_FCST')
					, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
					   AND MEASURE = 'MKT_FCST'
					   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
													   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
													   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
													   AND MEASURE = 'MKT_FCST'))
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE					
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                   FROM [dbo].[DM_PLN_MKT_FCST_RESULT]       F WITH(NOLOCK)				  
                  INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
				     ON F.MEASURE = 'RTF'  -- 20190722 KHSONG MKT_FCST → RTF 로 실적값 변경
                    AND M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL')
				  INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					 ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				WHERE 1=1
				AND F.MEASURE = CASE WHEN M.MEASURE IN ('MKT_FCST_RP_CAR','MKT_FCST_RP_CELL') THEN 'RTF' ELSE M.MEASURE END  -- 20190722 KHSONG MKT_FCST → RTF 로 실적값 변경
			
				AND F.QTY <> 0
				--and f.YYYYMMDD between @p_from_yyyymmdd and @v_to_result --[prepare] MKT Fcst Result 구간 변경(전주 일요일까지)
				AND f.yyyymmdd >= @p_from_yyyymmdd AND f.yyyymmdd < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

			END
                 
			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure
						WHERE MEASURE IN  ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY') )
			BEGIN
                
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                    , F.INCOTERMS
					 , 
					 CASE 
						WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
							CASE WHEN F.MEASURE = 'RTF' THEN 'RTF_RP_CAR' WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CAR' 
							ELSE ''
							END

						WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
							CASE WHEN F.MEASURE = 'RTF' THEN 'RTF_RP_CELL' WHEN F.MEASURE = 'RTF_SYS_RP' THEN 'RTF_SYS_RP_CELL' 
							ELSE '' 
							END
						-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
						WHEN M.MEASURE = 'RTF_ENERGY' AND F.MEASURE = 'RTF_SYS_RP' 
							THEN 'RTF_ENERGY'
						-- 20221214 ROSIA27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
						WHEN M.MEASURE = 'MKT_FCST_ENERGY' AND F.MEASURE = 'RTF_SYS_RP'
							THEN 'MKT_FCST_ENERGY'
					 END
					 AS MEASURE
					, F.YYYYMMDD
					, 
					 CASE 
						WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
							 CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY / T2.CELL_PER_CAR

										 -- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(BEGIN)
										 --WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/ ( T2.CELL_PER_CAR/ T2.CELL_PER_MODULE )
										 -- 20200218 KHSONG C20200212-000304 AS-IS 주석처리(END)

										 -- 20200218 KHSONG C20200212-000304 (BEGIN)
										 WHEN  CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0  AND T2.CELL_PER_CAR > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY/  T2.MODULE_PER_CAR --[C20200511-000360] MKT FCST[X+X] CAR - Module일 경우 = QTY / MODULE_PER_CAR
										 WHEN  CHARINDEX('Pack'  , T2.ITEM_CLASS_NAME) > 0  THEN F.QTY
										 -- 20200218 KHSONG C20200212-000304 (END)
							 ELSE 0 
							 END 
						WHEN M.MEASURE IN ('RTF_RP_CELL','RTF_SYS_RP_CELL') THEN
							 CASE WHEN CHARINDEX('Cell', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_CAR > 0 THEN F.QTY
								  --WHEN ( CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 OR CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 ) AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
								  --[C20200511-000360] MKT FCST[X+X] CELL - Pack일 경우 = QTY * CELL_PER_CAR
							 	 WHEN CHARINDEX('Module', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_MODULE
							 	 WHEN CHARINDEX('Pack', T2.ITEM_CLASS_NAME) > 0 AND T2.CELL_PER_MODULE > 0 THEN F.QTY * T2.CELL_PER_CAR
							 ELSE 0 
							 END
						-- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
						WHEN M.MEASURE = 'RTF_ENERGY' THEN
							CASE WHEN ISNUMERIC(T2.ENERGE) > 0 
								THEN ROUND((T2.ENERGE * F.QTY)/1000, 0)
							END
						-- 20221214 ROSIA27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
						WHEN M.MEASURE = 'MKT_FCST_ENERGY' THEN
							CASE WHEN ISNUMERIC(T2.ENERGE) > 0
								THEN ROUND((T2.ENERGE * F.QTY)/1000, 0)
							END
					 END 
					 AS QTY

					, m.MEASURE_GROUP			
					, T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, F.ATTRIBUTE10
					, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
					   AND MEASURE IN ('RTF','RTF_SYS_RP'))		
					, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
					   AND MEASURE IN ('RTF','RTF_SYS_RP')
					   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
													   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
													   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
													   AND MEASURE IN ('RTF','RTF_SYS_RP')))
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE					
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                   FROM [dbo].[DM_PLN_MKT_FCST_RESULT]       F WITH(NOLOCK)				  
                  INNER JOIN #TempSelectMeasure           m WITH(NOLOCK)
				     ON F.MEASURE IN ('RTF','RTF_SYS_RP')
                    AND M.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY')
				  INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					 ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				WHERE 1=1
				AND F.MEASURE = CASE WHEN M.MEASURE IN ('RTF_RP_CAR','RTF_RP_CELL') THEN 'RTF' WHEN M.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY') THEN 'RTF_SYS_RP' ELSE M.MEASURE END

				AND F.QTY <> 0
				--and f.YYYYMMDD between @p_from_yyyymmdd and @v_to_result --[prepare] MKT Fcst Result 구간 변경(전주 일요일까지)
				AND f.yyyymmdd >= @p_from_yyyymmdd AND f.yyyymmdd < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )
			END

				------------------------------------------------------------------------------------------------------------------------------------
				-- 20190705 KHSONG [CSR ID:4023158] MEASURE 추가 DM_PLN_MKT_FCST_RESULT (END)
				------------------------------------------------------------------------------------------------------------------------------------                

			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure
						WHERE MEASURE IN ('MKT_FCST_RP'))
			BEGIN
                
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                     , F.INCOTERMS, 'MKT_FCST_RP' MEASURE, F.YYYYMMDD, F.QTY
					 , m.MEASURE_GROUP				
					 , T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, F.ATTRIBUTE10
					, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
					   AND MEASURE = (CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END))
					, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND QTY <>0
					   AND MEASURE = (CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END)
					   AND CREATE_DATE = (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
													   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
													   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS
													   AND MEASURE = (CASE WHEN F.MEASURE = 'RTF' THEN 'MKT_FCST' ELSE F.MEASURE END)))						
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE					
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
                   FROM [dbo].[DM_PLN_MKT_FCST_RESULT]       F WITH(NOLOCK)				  
                  INNER JOIN #TempSelectMeasure                  m WITH(NOLOCK)
				     ON F.MEASURE =  'RTF'
					AND M.MEASURE = 'MKT_FCST_RP'
				  INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					 ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
				WHERE 1=1
				AND F.QTY <> 0
				--and f.YYYYMMDD between @p_from_yyyymmdd and @v_to_result --[prepare] MKT Fcst Result 구간 변경(전주 일요일까지)
				AND f.yyyymmdd >= @p_from_yyyymmdd AND f.yyyymmdd < @v_to_result
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )
--select 'aaa'
			END

--select 'bbb', * from #TempSelectMeasure

			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure
						WHERE MEASURE IN  ('IN_TRANSIT') )
			BEGIN
                
				INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                     , F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY
					 , m.MEASURE_GROUP		
					 , T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, '' AS ATTRIBUTE10
					, '' AS CREATE_DATE
					, '' AS LAST_UPDATED_BY
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
				    FROM #TempIntransitData F         WITH(NOLOCK)					
				   INNER JOIN #TempSelectMeasure                  m     WITH(NOLOCK)     
				      ON F.MEASURE =  'IN_TRANSIT' 
                     AND F.MEASURE = m.MEASURE	
				   INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
					 ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.project_code	= T2.project_code
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
                  WHERE 1=1					
				and f.YYYYMMDD between @p_from_yyyymmdd and @v_to_yyyymmdd
				AND F.DIVISION_ID = @p_division_id
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
							ELSE F.PLANT_SITE_ID
 						END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )

			END

			IF EXISTS ( SELECT *
						FROM #TempSelectMeasure
						WHERE MEASURE IN  ('SHIPMENT_PLAN') )
			BEGIN

				 /* 20190308 KHSONG [CSR ID:3940493] MKT FcstUI상 Shipping Plan Measure 추가 (SHIPMENT_PLAN) */
				 INSERT INTO #TempMktFcstData 
					(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
					, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
					, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
					, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
					, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
                SELECT SP.DIVISION_ID, SP.PROJECT_CODE , SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
				     , F.DOM_EXP  /* DOM_EXP 값을 추출  */
					 , SP.FCST_TYPE
                     , SP.INCOTERMS, SP.MEASURE, SP.YYYYMMDD, SP.QTY 
					 , m.MEASURE_GROUP		
					 , T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
					, F.ATTRIBUTE10
					, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE = F.MEASURE)
					, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP WITH(NOLOCK)
					   WHERE DIVISION_ID = F.DIVISION_ID AND PROJECT_CODE = F.PROJECT_CODE AND SCM_SITE_ID = F.SCM_SITE_ID AND ITEM_ID = F.ITEM_ID 
					   AND DOM_EXP = F.DOM_EXP AND FCST_TYPE = F.FCST_TYPE AND INCOTERMS = F.INCOTERMS AND MEASURE = F.MEASURE)
					, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_CODE
					, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = F.SCM_SITE_ID) AS SENDER_NAME
				    FROM #TempShipmentPlan SP         WITH(NOLOCK)					
				   INNER JOIN #TempSelectMeasure                  m     WITH(NOLOCK)     
							ON SP.MEASURE =  'SHIPMENT_PLAN' 
						AND SP.MEASURE = m.MEASURE	
				   INNER JOIN 	#TempSiteItem	T2  WITH(NOLOCK)
							ON	SP.DIVISION_ID	= T2.DIVISION_ID
						AND	SP.project_code	= T2.project_code
						AND	SP.SCM_SITE_ID	= T2.SCM_SITE_ID
						AND	SP.ITEM_ID		= T2.ITEM_ID
					INNER JOIN 	DM_PLN_MKT_FCST	F  WITH(NOLOCK)
						ON	SP.DIVISION_ID	= F.DIVISION_ID
						AND	SP.project_code	= F.project_code
						AND	SP.SCM_SITE_ID	= F.SCM_SITE_ID
						AND	SP.ITEM_ID		= F.ITEM_ID
					INNER JOIN #T_WS_FCST T3 ON F.FCST_TYPE = T3.FCST_TYPE
                  -- WHERE f.YYYYMMDD between [@v_from_yyyymmdd] and [@v_to_yyyymmdd]  2019.10.29 kyh
				WHERE f.YYYYMMDD between @p_from_yyyymmdd and @v_to_yyyymmdd
					and SP.QTY <> 0					
					AND F.DIVISION_ID = @p_division_id
					AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
								ELSE f.scm_site_id
 							END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
					AND    CASE WHEN @p_plant_site_id = 'ALL' THEN @p_plant_site_id		
								ELSE F.PLANT_SITE_ID
 							END  IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id,',') )
				GROUP BY 
					SP.DIVISION_ID, SP.PROJECT_CODE , SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
					, F.DOM_EXP
					, SP.FCST_TYPE
					, SP.INCOTERMS, SP.MEASURE, SP.YYYYMMDD, SP.QTY
					, m.MEASURE_GROUP		
					, T2.cell_model	--20180809 ytchoi modify					 
					, T2.END_CUSTOMER
					, T2.NICK_NAME
					, T2.DMS_SALES
					, T2.DMS_CUSTOMER
					, T2.OWNER
					, T2.DEPT_ID
					, T2.DEPT_NAME_KO
					, T2.FORECAST_INFO_CELL_PACK_COUNT
					, T2.ITEM_TYPE
					, T2.PROJECT_NAME
					, T2.PROJECT_OWNER
					, T2.BIZ_TYPE
					, T2.SOLDTO_CUSTOMER
					, T2.COUNTRY_NAME
					, T2.CITY_NAME
					, T2.PROJECT_STATUS
					, T2.ITEM_NAME
					, T2.VMI_YN
					, T2.CUST_GROUP
					, T2.CUST_GROUP_DTL
					, T2.APPLICATION
					, T2.ROUTE
					, T2.MDM_PROJECT_NAME
					, T2.MIN_CAPACITY
					, T2.FORECAST_INFO_BIZ_TYPE
					, T2.CELL_TYPE
					, T2.FORECAST_INFO_ALL
					, T2.FORECAST_INFO_SPEC
					, T2.FORECAST_INFOR_VERSION
					, T2.CELL_MODEL_NICK_NAME

					-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
					, T2.CELL_PER_CAR
					, T2.CELL_PER_MODULE
					, T2.MODULE_PER_CAR
					-- 20190705 KHSONG [CSR ID:4023158] (END)
					,M.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
					--20200130 KHSONG [C20200114-000201]
					,T2.ENERGE
					,T2.CELL_QUANTITY
					--20200130 KHSONG [C20200114-000201]
                    , F.ATTRIBUTE10
			END
		END

PRINT ( 'E2--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

					 
						select  F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE
												, MAX(F.MEASURE_GROUP)  AS MEASURE_GROUP
												, MAX(CELL_MODEL)	    AS FORECAST_INFO_CELL_MODEL
												, MAX(END_CUSTOMER)	    AS END_CUSTOMER
												, MAX(NICK_NAME)	    AS NICK_NAME
												, MAX(DMS_SALES)	    AS DMS_SALES
												, MAX(DMS_CUSTOMER)	    AS DMS_CUSTOMER
												, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
												, MAX(DEPT_ID)	        AS DEPT_ID
												, MAX(DEPT_NAME_KO)	    AS DEPT_NAME_KO
												, MAX(ITEM_TYPE)	    AS ITEM_TYPE
												, MAX(PROJECT_NAME)     AS PROJECT_NAME
												, MAX(PROJECT_OWNER)    AS PROJECT_OWNER
												, MAX(OWNER)			AS OWNER
												, MAX(BIZ_TYPE)			AS BIZ_TYPE
												, MAX(SOLDTO_CUSTOMER)  AS SOLDTO_CUSTOMER
												, MAX(COUNTRY_NAME)		AS COUNTRY_NAME
												, MAX(CITY_NAME)		AS CITY_NAME
												, MAX(PROJECT_STATUS)   AS PROJECT_STATUS
												, MAX(ITEM_NAME)		AS ITEM_NAME
												, MAX(VMI_YN)			AS VMI_YN
												, MAX(CUST_GROUP)       AS CUST_GROUP
												, MAX(CUST_GROUP_DTL)   AS CUST_GROUP_DTL
												, MAX(APPLICATION)      AS APPLICATION
												, MAX(ROUTE)            AS ROUTE
												, MAX(MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
												, MAX(MIN_CAPACITY)     AS MIN_CAPACITY
												, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
												, MAX(CELL_TYPE)		AS CELL_TYPE
												, MAX(FORECAST_INFO_ALL) AS FORECAST_INFO_ALL
												, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
												, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
												, MAX(CELL_MODEL_NICK_NAME) AS CELL_MODEL_NICK_NAME

												-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
												, MAX(CELL_PER_CAR)			AS CELL_PER_CAR
												, MAX(CELL_PER_MODULE)		AS CELL_PER_MODULE
												, MAX(MODULE_PER_CAR)		AS MODULE_PER_CAR
												-- 20190705 KHSONG [CSR ID:4023158] (END)
												, MAX(SORT_ORDER_NO)		AS SORT_ORDER_NO

												--20200130 KHSONG [C20200114-000201]
												,MAX(ENERGE)				AS ENERGE
												,MAX(CELL_QUANTITY)			AS CELL_QUANTITY
												,MAX(AS_FROM_SITE)			AS AS_FROM_SITE
												--20200130 KHSONG [C20200114-000201]
												,MAX(CREATE_DATE)	AS CREATE_DATE
												,MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY
												,MAX(SENDER_CODE)	AS SENDER_CODE
												,MAX(SENDER_NAME)	AS SENDER_NAME
							into #TempMktFcstDataDst
							from #TempMktFcstData F WITH(NOLOCK)
							GROUP BY F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE

PRINT ( 'F1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))


-- [C20201103-000114] 
IF ( @P_DIVISION_ID = '82' 
	AND EXISTS ( SELECT *
				FROM #TempSelectMeasure A
				WHERE MEASURE = 'MKT_FCST_RP'
				)
	AND EXISTS ( SELECT *
				FROM #TempMktFcstDataDst A
				JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VMI_YN = 'Y'
				WHERE MEASURE = 'MKT_FCST_RP'
				)
	)
BEGIN

	INSERT INTO #TempMktFcstDataDst (
		DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
		, MEASURE	
		, MEASURE_GROUP, FORECAST_INFO_CELL_MODEL, END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT, DEPT_ID	
		, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
		, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
		, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
		, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
		, A.MEASURE	
		, A.MEASURE_GROUP, A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME, A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT, A.DEPT_ID	
		, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
		, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
		, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
		, REPLACE(D.SORT_ORDER_NO, '.0', A.SORTKEY)
		, A.ENERGE, A.CELL_QUANTITY, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
	FROM (
		SELECT B.MEASURE, B.MEASURE_GROUP, B.SORTKEY, A.*
		FROM (
			SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
				, A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER, A.NICK_NAME, A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT, A.DEPT_ID	
				, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS
				, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
				, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR
				, A.ENERGE, A.CELL_QUANTITY, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
			FROM #TempMktFcstDataDst A
			JOIN SCM_MST_SITE D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND D.VMI_YN = 'Y'
			--WHERE A.MEASURE = 'MKT_FCST_RP'
			) A
		JOIN (	SELECT 'MKT_FCST_RP' AS MEASURE_GROUP, 'MKT_FCST_RP' AS MEASURE, '.9' AS SORTKEY
							UNION ALL
							SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE, '.1' AS SORTKEY
							UNION ALL
							SELECT 'VMI_In_Plan' AS MEASURE_GROUP, 'VMI_In_Plan' AS MEASURE, '.2' AS SORTKEY
							UNION ALL
							SELECT 'VMI_In_Req' AS MEASURE_GROUP, 'VMI_In_Req' AS MEASURE, '.3' AS SORTKEY
							UNION ALL
							SELECT 'VMI_Inv' AS MEASURE_GROUP, 'VMI_Inv' AS MEASURE, '.4' AS SORTKEY
			) B ON 1=1 -- A.MEASURE = B.MEASURE AND A.MEASURE_GROUP = B.MEASURE_GROUP
		) A
	LEFT OUTER JOIN #TempMktFcstDataDst C ON 
		A.DIVISION_ID		= C.DIVISION_ID		
		and	A.PROJECT_CODE		= C.PROJECT_CODE		
		and	A.SCM_SITE_ID		= C.SCM_SITE_ID		
		and	A.PLANT_SITE_ID		= C.PLANT_SITE_ID		
		and	A.ITEM_ID			= C.ITEM_ID			
		and	A.DOM_EXP			= C.DOM_EXP			
		and	A.FCST_TYPE			= C.FCST_TYPE			
		and	A.INCOTERMS			= C.INCOTERMS			
		and A.MEASURE			= C.MEASURE
		and A.MEASURE_GROUP		= C.MEASURE_GROUP
	LEFT OUTER JOIN #TempSelectMeasure D ON A.MEASURE = D.MEASURE AND A.MEASURE_GROUP = D.MEASURE_GROUP
	WHERE C.measure is null
	ORDER BY A.INCOTERMS, A.MEASURE
	
END

PRINT ( 'G1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

--select @p_scm_site_id
--SELECT 'x1', * FROM #TempMktFcstData
					 
		IF @p_division_id = '82' and @p_invalid_exec = 'N'  --[C20200612-000174] ESS사업부 조회 구간에 mapping되지 않은 Sales Price 데이터 제공
			BEGIN

				----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- 속도개선 - UNION [2021-09-15]
				----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				select distinct a.division_id, a.project_code, a.scm_site_id, a.plant_site_id, a.item_id/*, a.currency [C20200702-000136] Sales Price check시 currency 제외*/, a.dom_exp, a.fcst_type, a.incoterms
					, b.biz_type, b.soldto_customer, b.country, b.country_name, b.city, b.city_name, b.owner, b.project_owner, b.user_id, b.item_name, b.item_type
					, b.project_status, b.nick_name, b.dept_id, b.dept_name_ko , b.vmi_yn, b.project_name, b.end_customer, b.energe, b.cell_quantity
					, 'MKT_FCST_RP' AS MEASURE
					, 'MKT_FCST_RP' AS MEASURE_GROUP
					, CASE WHEN ISNULL(B.VMI_YN, 'N') <> 'Y' THEN CAST('00.0' AS NVARCHAR(7)) ELSE '.9' END AS SORT_ORDER_NO
				into #TempSalesPrice
				from   scm_mst_future_price a with(nolock)
				inner join #TempSiteItem b on  (a.division_id = b.division_id and  a.project_code = b.project_code and  a.scm_site_id = b.scm_site_id and  a.item_id = b.item_id) AND A.FCST_TYPE <> ''
				where yyyymmdd between @p_from_yyyymmdd and @p_to_yyyymmdd
				and   a.measure = 'LOC' 
				and   a.fcst_type <> 'ETC' -- [C20200702-000136] Fcst Type 'ETC' 는 MKT Fcst 대상이 아니므로 제외

				UNION ALL

				select distinct a.division_id, a.project_code, a.scm_site_id, a.plant_site_id, a.item_id/*, a.currency [C20200702-000136] Sales Price check시 currency 제외*/, a.dom_exp, a.fcst_type, a.incoterms
					, b.biz_type, b.soldto_customer, b.country, b.country_name, b.city, b.city_name, b.owner, b.project_owner, b.user_id, b.item_name, b.item_type
					, b.project_status, b.nick_name, b.dept_id, b.dept_name_ko , b.vmi_yn, b.project_name, b.end_customer, b.energe, b.cell_quantity
					, 'BNPIn' AS MEASURE, 'BNPIn' AS MEASURE_GROUP
					, '00.0' AS SORT_ORDER_NO
				from   scm_mst_future_price a with(nolock)
				inner join #TempSiteItem b
					on  a.division_id = b.division_id
					and  a.project_code = b.project_code
					and  a.scm_site_id = b.scm_site_id
					and  a.item_id = b.item_id
					AND A.FCST_TYPE <> ''
					AND B.ITEM_TYPE IN ( 'Q', 'R' )
				where yyyymmdd between @p_from_yyyymmdd and @p_to_yyyymmdd
				and   a.measure = 'LOC' 
				and   a.fcst_type <> 'ETC' -- [C20200702-000136] Fcst Type 'ETC' 는 MKT Fcst 대상이 아니므로 제외
				;
				----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

				UPDATE A
				SET SORT_ORDER_NO = B.SORT_ORDER_NO
				FROM #TempSalesPrice A
				JOIN #TempSelectMeasure B ON A.MEASURE = B.MEASURE AND A.MEASURE_GROUP = B.MEASURE_GROUP

				DECLARE @V_MF_ORDER NVARCHAR(10)
				SELECT @V_MF_ORDER = SORT_ORDER_NO
				FROM #TempSelectMeasure 
				WHERE MEASURE = 'MKT_FCST_RP'

				UPDATE #TempSalesPrice
				SET SORT_ORDER_NO = CASE WHEN MEASURE = 'RTF_SYS_RP' THEN REPLACE(SORT_ORDER_NO, '.0', '.1')
										WHEN MEASURE = 'VMI_In_Plan' THEN REPLACE(SORT_ORDER_NO, '.0', '.2')
										WHEN MEASURE = 'VMI_In_Req' THEN REPLACE(SORT_ORDER_NO, '.0', '.3')
										WHEN MEASURE = 'VMI_Inv' THEN REPLACE(SORT_ORDER_NO, '.0', '.4')
										WHEN MEASURE = 'MKT_FCST_RP' THEN REPLACE(SORT_ORDER_NO, '.0', '.9')
										END
				WHERE MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP', 'VMI_In_Plan', 'VMI_In_Req', 'VMI_Inv' )

				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				IF @P_AS_YN = 'Y'
				BEGIN
					IF EXISTS ( SELECT * FROM #TempSelectMeasure WHERE MEASURE IN ( 'AS_IN_REQ', 'AS_IN_PLAN', 'AS_INV' ))
					BEGIN
						INSERT INTO #TempMktFcstDataDst 
							( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, MEASURE_GROUP, FORECAST_INFO_CELL_MODEL, END_CUSTOMER
								, NICK_NAME, DMS_SALES, DMS_CUSTOMER, FORECAST_INFO_CELL_PACK_COUNT, DEPT_ID, DEPT_NAME_KO, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER, BIZ_TYPE, SOLDTO_CUSTOMER
								, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE
								, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
								, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, C.MEASURE, C.MEASURE_GROUP, A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER
								, A.NICK_NAME, A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER
								, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE
								, A.CELL_TYPE, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, C.SORT_ORDER_NO, A.ENERGE, A.CELL_QUANTITY
								, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
						FROM (
							SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.MEASURE_GROUP, A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER
								, A.NICK_NAME, A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER
								, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE
								, A.CELL_TYPE, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.SORT_ORDER_NO, A.ENERGE, A.CELL_QUANTITY
								, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
							FROM #TempMktFcstDataDst A
							JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.SCM_SITE_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' AND B.SEGMENT3 = @P_DIVISION_ID
							GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.MEASURE_GROUP, A.FORECAST_INFO_CELL_MODEL, A.END_CUSTOMER
								, A.NICK_NAME, A.DMS_SALES, A.DMS_CUSTOMER, A.FORECAST_INFO_CELL_PACK_COUNT, A.DEPT_ID, A.DEPT_NAME_KO, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER
								, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE
								, A.CELL_TYPE, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.SORT_ORDER_NO, A.ENERGE, A.CELL_QUANTITY
								, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
							) A
						JOIN ( SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO FROM #TempSelectMeasure WHERE MEASURE IN ( 'AS_IN_REQ', 'AS_IN_PLAN', 'AS_INV' )) C ON 1=1
						LEFT OUTER JOIN  ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
											FROM #TempMktFcstData A
											JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.SCM_SITE_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' AND B.SEGMENT3 = @P_DIVISION_ID
											) D ON 	A.DIVISION_ID		= D.DIVISION_ID		
													AND A.PROJECT_CODE		= D.PROJECT_CODE		
													AND A.SCM_SITE_ID		= D.SCM_SITE_ID		
													AND A.ITEM_ID			= D.ITEM_ID			
													AND A.DOM_EXP			= D.DOM_EXP			
													AND A.FCST_TYPE			= D.FCST_TYPE			
													AND A.INCOTERMS			= D.INCOTERMS			
													AND C.MEASURE			= D.MEASURE			
													AND A.PLANT_SITE_ID		= D.PLANT_SITE_ID
						WHERE D.DIVISION_ID IS NULL

					END
				END
				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			

				  SET @v_sql_text = N'
				--WITH   MKT_FCST as (
				select    
							A.DIVISION_ID
						  , A.DIVISION_ID as DIVISION_ID40
                          , CASE WHEN ''' + @p_AS_YN + N''' = N''Y'' THEN ISNULL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY
						  , A.SCM_SITE_ID
						  , A.SCM_SITE_ID AS SCM_SITE_ID40
						  , A.PLANT_SITE_ID
						  , A.PROJECT_CODE
						  , A.ITEM_ID  
						  , A.ITEM_ID  AS ITEM_ID40
						  , A.INCOTERMS
						  , A.FCST_TYPE 
						  , A.DOM_EXP
						  , A.MEASURE
						  , A.END_CUSTOMER
						  , case when (a.division_id LIKE ''81%'' OR a.division_id = ''82'') then A.END_CUSTOMER else A.PROJECT_CODE end AS END_CUSTOMER40
						  , A.NICK_NAME
						  , A.DMS_SALES
						  , A.DMS_CUSTOMER
						  , C.BASIS_YYYYMM  AS YYYYMM
						  , C.BASIS_YYYYMM + C.ISO_WEEK AS YYYYMMWW
						  , C.BASIS_YYYYMMDD AS YYYYMMDD
						  , C.DAYOFWEEK
						  , A.FORECAST_INFO_CELL_MODEL
						  , A.DEPT_ID      AS TEAM_ID
						  , A.DEPT_NAME_KO AS TEAM_NAME_KO
						  , A.ITEM_TYPE
						  , A.PROJECT_NAME
						  , A.PROJECT_OWNER
						  , A.OWNER
						  , A.BIZ_TYPE
						  , A.SOLDTO_CUSTOMER
						  , A.COUNTRY_NAME
						  , A.CITY_NAME
						  , A.PROJECT_STATUS
						  , A.ITEM_NAME
						  , A.VMI_YN
						  , A.CUST_GROUP
						  , A.CUST_GROUP_DTL
						  , A.APPLICATION
						  , A.ROUTE
						  , A.MDM_PROJECT_NAME
						  , A.MIN_CAPACITY
						  , A.FORECAST_INFO_BIZ_TYPE
						  , A.CELL_TYPE
						  , A.FORECAST_INFO_CELL_PACK_COUNT
						  , A.FORECAST_INFO_ALL
						  , A.FORECAST_INFO_SPEC
						  , A.FORECAST_INFOR_VERSION
						  , A.CELL_MODEL_NICK_NAME
						  --↓20190219 KHSONG 숫자가 아닌 MEASURE는 FORECAST_INFO_CELL_PACK_COUNT로 곱하지 않도록 수정			
						  --↓[C20200702-000136] Data Type을 Int로 변경
						  , cast(CASE WHEN ''Y'' = N''[@CellQtyYN]'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and isnull(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN d.QTY * A.FORECAST_INFO_CELL_PACK_COUNT ELSE d.QTY END as int)QTY -- 20181114
                          , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN
                          , CASE WHEN C3.WEEK_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN
							
							-- 20200309 KHSONG C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
							,CASE 
								--WHEN MA.Dept_id IS NOT NULL  and a.MEASURE_GROUP = ''CUST_FCST_2''  -- 같은부서+CustFcst
								--	THEN ''Y''
								--WHEN MA.Dept_id IS NOT NULL  and a.MEASURE_GROUP = ''CUST_FCST_3''  -- 같은부서+CustFcst
								--	THEN ''Y''
								WHEN MA.Dept_id IS NOT NULL    and a.MEASURE_GROUP not in (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'') and a.MEASURE		= M1.SEGMENT2  -- 같은부서+MktFcst등 (TMM 제외)								
									THEN ''Y''
								--WHEN (''[@v_group_id]'' =''ADMIN'') and a.MEASURE_GROUP = ''CUST_FCST_2''  -- Admin권한자+CustFcst
								--	THEN ''Y''
								--WHEN (''[@v_group_id]'' =''ADMIN'') and a.MEASURE_GROUP = ''CUST_FCST_3''  -- Admin권한자+CustFcst
								--	THEN ''Y''
								WHEN (''[@v_group_id]'' =''ADMIN'') and a.MEASURE_GROUP <> ''TMM_FCST'' and a.MEASURE		= M1.SEGMENT2  -- Admin권한자+MktFcst등 (TMM 제외)
									THEN ''Y''
								WHEN a.MEASURE_GROUP = ''TMM_FCST'' and a.PROJECT_CODE	= M2.SEGMENT2 and a.MEASURE		= M1.SEGMENT2  -- TMM MEASURE 수정권한자 조건
									THEN ''Y''
								ELSE
									''N''
							END  AS EDIT_FLAG 
						--, case when m.BUCKET_PER = ''Y'' then ''Y'' when m.BUCKET_PER = ''N'' then ''N'' else null end AS PER  -- 20181101 khsong add

						  -- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
						  , A.CELL_PER_CAR
						  , A.CELL_PER_MODULE
						  , A.MODULE_PER_CAR
						  -- 20190705 KHSONG [CSR ID:4023158] (END)
						  , A.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
						  , A.MEASURE_GROUP  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

						--20200130 KHSONG [C20200114-000201]
						,A.ENERGE
						,A.CELL_QUANTITY
						--20200130 KHSONG [C20200114-000201]
						,A.NEW_FLAG -- [C20200702-000136] New Flag 추가
						, ISNULL(VM.VMI_VAL, '''') as VMI_STD_DIO	-- [C20201103-000114]
						, ISNULL(B1.ATTR1, B2.ATTR1) AS ATTR1 ---- [C20200804-000123] 추가
						, ISNULL(BK.BUCKET, ''0000000'') AS BUCKET, AS_YN
						, A.AS_FROM_SITE
						, CASE WHEN ISNULL(A.CREATE_DATE, '''') = '''' THEN '' '' ELSE A.CREATE_DATE END AS LAST_UPDATE_DATE
						, CASE WHEN ISNULL(A.LAST_UPDATED_BY, '''') = '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY
						, CASE WHEN ISNULL(A.SENDER_CODE, '''') = '''' THEN '' '' ELSE A.SENDER_CODE END AS SENDER_CODE
						, CASE WHEN ISNULL(A.SENDER_NAME, '''') = '''' THEN '' '' ELSE A.SENDER_NAME END AS SENDER_NAME
				into #MF
				  from 
				 (  
				   select ISNULL(M.DIVISION_ID, P.DIVISION_ID) AS DIVISION_ID
							, ISNULL(M.PROJECT_CODE, P.PROJECT_CODE) AS PROJECT_CODE	
							, ISNULL(M.SCM_SITE_ID, P.SCM_SITE_ID) AS SCM_SITE_ID
							, ISNULL(M.PLANT_SITE_ID, P.PLANT_SITE_ID) AS PLANT_SITE_ID
							, ISNULL(M.ITEM_ID, P.ITEM_ID) AS ITEM_ID
							, ISNULL(M.DOM_EXP, P.DOM_EXP) AS DOM_EXP
							, ISNULL(M.FCST_TYPE, P.FCST_TYPE) AS FCST_TYPE
							, ISNULL(M.INCOTERMS, P.INCOTERMS) AS INCOTERMS
					
							, (CASE WHEN ISNULL(P.MEASURE,'''') <> '''' THEN P.MEASURE WHEN M.MEASURE IS NULL THEN ''MKT_FCST_RP'' ELSE M.MEASURE END) AS MEASURE
							, (CASE WHEN ISNULL(P.MEASURE_GROUP,'''') <> '''' THEN P.MEASURE_GROUP WHEN M.MEASURE_GROUP IS NULL THEN ''MKT_FCST_RP'' ELSE M.MEASURE_GROUP END) AS MEASURE_GROUP
							--[C20201103-000114]
							--, (CASE WHEN M.MEASURE is null THEN ''MKT_FCST_RP'' ELSE M.MEASURE END) AS MEASURE
							--, (CASE WHEN M.MEASURE_GROUP is null THEN ''MKT_FCST_RP'' ELSE M.MEASURE_GROUP END) AS MEASURE_GROUP
							, M.FORECAST_INFO_CELL_MODEL
							, ISNULL(M.END_CUSTOMER, P.END_CUSTOMER) AS END_CUSTOMER
							, ISNULL(M.NICK_NAME, P.NICK_NAME) AS NICK_NAME
							, M.DMS_SALES
							, M.DMS_CUSTOMER
							, M.FORECAST_INFO_CELL_PACK_COUNT				
							, ISNULL(M.DEPT_ID, P.DEPT_ID) AS DEPT_ID
							, ISNULL(M.DEPT_NAME_KO, P.DEPT_NAME_KO) AS DEPT_NAME_KO
							, ISNULL(M.ITEM_TYPE, P.ITEM_TYPE) AS ITEM_TYPE
							, ISNULL(M.PROJECT_NAME, P.PROJECT_NAME) AS PROJECT_NAME
							, ISNULL(M.PROJECT_OWNER, P.PROJECT_OWNER) AS PROJECT_OWNER
							, ISNULL(M.OWNER, P.OWNER) AS OWNER
							, ISNULL(M.BIZ_TYPE, P.BIZ_TYPE) AS BIZ_TYPE
							, ISNULL(M.SOLDTO_CUSTOMER, P.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
							, ISNULL(M.COUNTRY_NAME, P.COUNTRY_NAME) AS COUNTRY_NAME
							, ISNULL(M.CITY_NAME, P.CITY_NAME) AS CITY_NAME
							, ISNULL(M.PROJECT_STATUS, P.PROJECT_STATUS) AS PROJECT_STATUS
							, ISNULL(M.ITEM_NAME, P.ITEM_NAME) AS ITEM_NAME
							, ISNULL(M.VMI_YN, P.VMI_YN) AS VMI_YN
							, M.CUST_GROUP
							, M.CUST_GROUP_DTL
							, M.APPLICATION
							, M.ROUTE
							, M.MDM_PROJECT_NAME
							, M.MIN_CAPACITY
							, M.FORECAST_INFO_BIZ_TYPE
							, M.CELL_TYPE
							, M.FORECAST_INFO_ALL
							, M.FORECAST_INFO_SPEC
							, M.FORECAST_INFOR_VERSION
							, M.CELL_MODEL_NICK_NAME
							, M.CELL_PER_CAR
							, M.CELL_PER_MODULE
							, M.MODULE_PER_CAR
							, ISNULL(P.SORT_ORDER_NO, M.SORT_ORDER_NO) AS SORT_ORDER_NO
							, ISNULL(M.ENERGE, P.ENERGE) AS ENERGE
							, ISNULL(M.CELL_QUANTITY, P.CELL_QUANTITY) AS CELL_QUANTITY
							, (CASE WHEN M.DIVISION_ID is null THEN ''Y'' ELSE ''N'' END) AS NEW_FLAG -- [C20200702-000136] New Flag 추가
							, N''' + @P_AS_YN + N''' AS AS_YN
							, M.AS_FROM_SITE
							, M.CREATE_DATE
							, M.LAST_UPDATED_BY
							, M.SENDER_CODE
							, M.SENDER_NAME
					from #TempSalesPrice p
					full outer join #TempMktFcstDataDst m WITH(NOLOCK)  -- [C20200702-000136] Sales Price가 없는 경우도 있으므로 Full outer join 으로 변경
					on ( p.DIVISION_ID    = m.DIVISION_ID
					   AND p.PROJECT_CODE   = m.PROJECT_CODE
					   and p.SCM_SITE_ID    = m.SCM_SITE_ID
					   and p.PLANT_SITE_ID  = m.PLANT_SITE_ID
					   and p.ITEM_ID        = m.ITEM_ID 
					   and p.fcst_type      = m.fcst_type
					   and p.incoterms      = m.incoterms
					   and p.dom_exp        = m.dom_exp 
					   AND P.MEASURE		= M.MEASURE
					   AND 1 = CASE WHEN N''' + ISNULL(@P_AS_YN,'') + N''' = ''Y'' THEN
										CASE WHEN ISNULL(M.AS_FROM_SITE, '''') <> '''' OR M.SCM_SITE_ID IN ( SELECT SCM_SITE_ID FROM #T_WS_SITE_PLANT ) THEN 1 ELSE 0 END
								ELSE 1 END
					   
					   )			
					) a
				 LEFT JOIN #TempMktFcstData d WITH(NOLOCK)
					   ON  a.DIVISION_ID    = d.DIVISION_ID
					   AND a.PROJECT_CODE   = d.PROJECT_CODE
					   and a.SCM_SITE_ID    = d.SCM_SITE_ID
					   and a.PLANT_SITE_ID  = d.PLANT_SITE_ID
					   and a.ITEM_ID        = d.ITEM_ID
					   and a.DOM_EXP        = d.DOM_EXP
					   and a.FCST_TYPE      = d.FCST_TYPE
					   and a.INCOTERMS      = d.INCOTERMS
					   and a.MEASURE        = d.MEASURE
				LEFT OUTER JOIN [dbo].[SCM_SYS_CALENDAR_M] c WITH(NOLOCK) ON  C.BASIS_YYYYMMDD = D.YYYYMMDD	   
                LEFT OUTER JOIN (   SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
                                    FROM SCM_SYS_CALENDAR_M
                                    WHERE BASIS_YYYYMMDD BETWEEN ''' + @P_FROM_YYYYMMDD +N''' AND ''' + @P_TO_YYYYMMDD + N''' 
                                    GROUP BY BASIS_YYYYMM ) C2 ON D.YYYYMMDD = C2.MONTH_END_DATE
                LEFT OUTER JOIN (   SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
                                    FROM SCM_SYS_CALENDAR_M
                                    WHERE BASIS_YYYYMMDD BETWEEN ''' + @P_FROM_YYYYMMDD + N'''  AND ''' + @P_TO_YYYYMMDD + N''' 
                                    GROUP BY ISO_YYYYWW+PARTIAL_WEEK_NAME ) C3 ON D.YYYYMMDD = C3.WEEK_END_DATE

				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL X ON A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''
				 --LEFT JOIN DM_MST_BUCKET_CONVERSION m WITH(NOLOCK)
					--   ON a.DIVISION_ID     = m.DIVISION_ID
					--   and a.SCM_SITE_ID    = m.SCM_SITE_ID
					--   and a.INCOTERMS      = m.INCOTERMS
					--   and c.DAYOFWEEK      = m.YYYYMMDD

				 -- 20200309 KHSONG C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
				 LEFT JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M1 WITH(NOLOCK)   -- EDIT가능MEASURE
 					   ON  a.DIVISION_ID	= M1.SEGMENT1  -- DIVISION_ID
					   AND a.MEASURE		= M1.SEGMENT2  -- MEASURE
					   AND M1.LOOKUP_TYPE	= ''MKT_FCST_MEASURE''
					   AND M1.SEGMENT5		= ''Y''       -- EDIT_YN 여부
					   AND M1.VALID_YN		= ''Y''       -- VALID_YN 여부
					   --AND M1.ATTRIBUTE2   <> ''Y''       -- TMM MEASURE 가 아닌경우

				 -- 20200309 KHSONG C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
				 LEFT JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M2 WITH(NOLOCK)   -- TMM MEASURE
 					   ON  a.DIVISION_ID	= M2.SEGMENT1  -- DIVISION_ID
					   AND a.PROJECT_CODE	= M2.SEGMENT2  -- PROJECT_CODE
					   AND ''[@p_created_by]''	= M2.SEGMENT4  -- USER_ID
					   AND M2.LOOKUP_TYPE	= ''TMM_MEASURE_ADMIN''
					   AND M2.VALID_YN		= ''Y''       -- VALID_YN 여부
				LEFT JOIN #TempVmiDio VM
					ON A.SCM_SITE_ID = VM.KEY_JOIN
				LEFT OUTER JOIN #T_SSP_SYNC B1 ON A.DIVISION_ID = B1.DIVISION_ID		-- [C20200804-000123] 추가
					AND A.PROJECT_CODE	= B1.PROJECT_CODE
					AND A.SCM_SITE_ID	= B1.SCM_SITE_ID
					AND A.ITEM_ID		= B1.ITEM_ID
					AND A.DOM_EXP		= B1.DOM_EXP
					AND A.FCST_TYPE		= B1.FCST_TYPE
					AND A.INCOTERMS		= B1.INCOTERMS
					AND A.MEASURE = ''MKT_FCST_RP''
				LEFT OUTER JOIN #T_BNP B2 ON A.DIVISION_ID = B2.DIVISION_ID		-- [PJ20209642R] 추가
					AND A.PROJECT_CODE	= B2.PROJECT_CODE
					AND A.SCM_SITE_ID	= B2.SCM_SITE_ID
					AND A.ITEM_ID		= B2.ITEM_ID
					AND A.DOM_EXP		= B2.DOM_EXP
					AND A.FCST_TYPE		= B2.FCST_TYPE
					AND A.INCOTERMS		= B2.INCOTERMS
					AND A.MEASURE = ''BNPIn''
				LEFT OUTER JOIN (
						SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, CONCAT(ISNULL([SUN],0), ISNULL([MON],0) , ISNULL([TUE],0) , ISNULL([WED],0) , ISNULL([THU],0) , ISNULL([FRI],0) , ISNULL([SAT],0)) AS BUCKET
						FROM (
							SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD, CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER
							FROM DM_MST_BUCKET_CONVERSION
							) A
						PIVOT ( 
							MAX(BUCKET_PER) FOR YYYYMMDD IN ([SUN], [MON], [TUE], [WED], [THU], [FRI], [SAT])
							) AS PVT 
						WHERE DIVISION_ID = N''' + @P_DIVISION_ID + N'''
					) BK ON A.DIVISION_ID = BK.DIVISION_ID AND A.SCM_SITE_ID = BK.SCM_SITE_ID AND A.INCOTERMS = BK.INCOTERMS
				
				--부서 테이블 추가
				LEFT OUTER JOIN (
									SELECT LOOK.SEGMENT3 as Dept_ID
									FROM   [dbo].[TB_FX_User] AS USR WITH(NOLOCK)
									INNER JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] AS LOOK WITH(NOLOCK)
									ON USR.DEPT_ID = LOOK.SEGMENT1 AND LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING'' AND LOOK.VALID_YN = ''Y''
									WHERE  USR.UserID = ''[@p_created_by]''

									UNION -- 중복값 있으면 안됨

									SELECT Dept_ID
									FROM   [dbo].[TB_FX_User] WITH(NOLOCK)
									WHERE UserID = ''[@p_created_by]''
								) AS MA ON A.dept_id = MA.DEPT_id
				--부서 테이블 추가

				WHERE 1=1 

				[@v_team_id]
				'
				+ case when @P_AS_YN <> 'Y' then N' option (hash join) ' else N'' end
				+ N'
				SELECT [@V_COLUMN]
						, SORT_ORDER_NO
						, [@V_PV_COL_LIST]    
				FROM ( 
						
							SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
							FROM   #MF F					
					
							UNION ALL
							SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' + F.YYYYMMWW AS YYYYMMDD
									, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'' )
												THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)  
															ELSE 0 
														END
											ELSE SUM(F.QTY) 
										END AS QTY
							FROM #MF F
							WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																						  , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN 
																		-9999999999
															   ELSE 0 END)
							GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN

												UNION ALL
							SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' + F.YYYYMM AS YYYYMMDD
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv''  )
												THEN	CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)  
															ELSE 0 
														END
											ELSE SUM(F.QTY) 
										END AS QTY
							FROM #MF F
							WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																						  , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN 
																		-9999999999
															   ELSE 0 END)
							GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN

					) F
				PIVOT (
					SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )
					) AS PVT
				[@V_ORDERBY]

				option (hash group) 
				  '; 
  
  
			END
		ELSE
		    BEGIN

PRINT ( 'G2--' + CONVERT(NVARCHAR(30), GETDATE(), 121))


				-- AS_YN = 'Y' 이면 값이 없는 AS 관련 메저를 추가해준다.
				IF @P_AS_YN = 'Y'
				BEGIN
					IF EXISTS ( SELECT * FROM #TempSelectMeasure WHERE MEASURE IN ( 'AS_IN_REQ', 'AS_IN_PLAN', 'AS_INV' ))
					BEGIN
						INSERT INTO #TempMktFcstData 
							(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, QTY, MEASURE_GROUP, cell_model, END_CUSTOMER, NICK_NAME
							, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME
							, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
							, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY
							, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
								, C.MEASURE, A.YYYYMMDD, 0 AS QTY, C.MEASURE_GROUP, A.cell_model, A.END_CUSTOMER, A.NICK_NAME
								, A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO, A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME
								, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
								, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, C.SORT_ORDER_NO, A.ENERGE, A.CELL_QUANTITY
								, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
						FROM (
							SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
								, MAX(A.YYYYMMDD) AS YYYYMMDD, 0 AS QTY, A.cell_model, A.END_CUSTOMER, A.NICK_NAME
								, A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO, A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME
								, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
								, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.SORT_ORDER_NO, A.ENERGE, A.CELL_QUANTITY
								, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
							FROM #TempMktFcstData A
							JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.SCM_SITE_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' AND B.SEGMENT3 = @P_DIVISION_ID
							GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
								, A.cell_model, A.END_CUSTOMER, A.NICK_NAME
								, A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO, A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.BIZ_TYPE, A.SOLDTO_CUSTOMER, A.COUNTRY_NAME
								, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY, A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE
								, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.SORT_ORDER_NO, A.ENERGE, A.CELL_QUANTITY
								, A.AS_FROM_SITE, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
							) A
						JOIN ( SELECT MEASURE, MEASURE_GROUP, SORT_ORDER_NO FROM #TempSelectMeasure WHERE MEASURE IN ( 'AS_IN_REQ', 'AS_IN_PLAN', 'AS_INV' )) C ON 1=1
						LEFT OUTER JOIN  ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
											FROM #TempMktFcstData A
											JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.SCM_SITE_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' AND B.SEGMENT3 = @P_DIVISION_ID
											) D ON 	A.DIVISION_ID		= D.DIVISION_ID		
													AND A.PROJECT_CODE		= D.PROJECT_CODE		
													AND A.SCM_SITE_ID		= D.SCM_SITE_ID		
													AND A.ITEM_ID			= D.ITEM_ID			
													AND A.DOM_EXP			= D.DOM_EXP			
													AND A.FCST_TYPE			= D.FCST_TYPE			
													AND A.INCOTERMS			= D.INCOTERMS			
													AND C.MEASURE			= D.MEASURE			
													AND A.PLANT_SITE_ID		= D.PLANT_SITE_ID
						WHERE D.DIVISION_ID IS NULL

					END
				END

--select * from #TempMktFcstData where measure = 'as_in_req'
--select * from #TempSelectMeasure

PRINT ( 'G3--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
	 
				  SET @v_sql_text = N'
			
				select    
							A.DIVISION_ID
						  , A.DIVISION_ID as DIVISION_ID40
						  , A.SCM_SITE_ID
						  , A.SCM_SITE_ID AS SCM_SITE_ID40
						  , A.PLANT_SITE_ID
						  , A.PROJECT_CODE
						  , A.ITEM_ID  
						  , A.ITEM_ID  AS ITEM_ID40
						  , A.INCOTERMS
						  , A.FCST_TYPE 
						  , A.DOM_EXP
						  --, CASE WHEN A.DOM_EXP='''' THEN (SELECT DOM_EXP FROM )
						  , A.MEASURE
						  , A.END_CUSTOMER
						  , case when (a.division_id LIKE ''81%'' OR a.division_id = ''82'') then A.END_CUSTOMER else A.PROJECT_CODE end AS END_CUSTOMER40  -- 20190401 KHSONG 81,82인경우 PROJECT_CODE 를 출력하면 GROUP이 묶이지 않으므로 END_CUSTOMER 출력으로 변경함
						  , A.NICK_NAME
						  , A.DMS_SALES
						  , A.DMS_CUSTOMER
						  , C.BASIS_YYYYMM  AS YYYYMM
						  , C.BASIS_YYYYMM + C.ISO_WEEK AS YYYYMMWW
						  , C.BASIS_YYYYMMDD AS YYYYMMDD
						  , C.DAYOFWEEK
						  , A.CELL_MODEL AS FORECAST_INFO_CELL_MODEL
						  , A.DEPT_ID      AS TEAM_ID
						  , A.DEPT_NAME_KO AS TEAM_NAME_KO
						  , A.ITEM_TYPE
						  , A.PROJECT_NAME
						  , A.PROJECT_OWNER
						  , A.OWNER
						  , A.BIZ_TYPE
						  , A.SOLDTO_CUSTOMER
						  , A.COUNTRY_NAME
						  , A.CITY_NAME
						  , A.PROJECT_STATUS
						  , A.ITEM_NAME
						  , A.VMI_YN
						  , A.CUST_GROUP
						  , A.CUST_GROUP_DTL
						  , A.APPLICATION
						  , A.ROUTE
						  , A.MDM_PROJECT_NAME
						  , A.MIN_CAPACITY
						  , A.FORECAST_INFO_BIZ_TYPE
						  , A.CELL_TYPE
						  , A.FORECAST_INFO_CELL_PACK_COUNT
						  , A.FORECAST_INFO_ALL
						  , A.FORECAST_INFO_SPEC
						  , A.FORECAST_INFOR_VERSION
						  , A.CELL_MODEL_NICK_NAME
						  --↓20190219 KHSONG 숫자가 아닌 MEASURE는 FORECAST_INFO_CELL_PACK_COUNT로 곱하지 않도록 수정
						  --↓[C20200702-000136] Data Type을 Int로 변경
						  , cast(CASE WHEN ''Y'' = ''[@CellQtyYN]'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and isnull(A.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN a.QTY * A.FORECAST_INFO_CELL_PACK_COUNT ELSE a.QTY END as int)QTY -- 20181114
                          , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN
                          , CASE WHEN C3.WEEK_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN
							
							-- 20200309 KHSONG C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
							,CASE 
								--WHEN MA.Dept_id IS NOT NULL  and a.MEASURE_GROUP = ''CUST_FCST_2''  -- 같은부서+CustFcst
								--	THEN ''Y''
								--WHEN MA.Dept_id IS NOT NULL  and a.MEASURE_GROUP = ''CUST_FCST_3''  -- 같은부서+CustFcst
								--	THEN ''Y''
								WHEN MA.Dept_id IS NOT NULL    and a.MEASURE_GROUP not in (''CUST_FCST_2'',''CUST_FCST_3'',''TMM_FCST'') and a.MEASURE		= M1.SEGMENT2  -- 같은부서+MktFcst등 (TMM 제외)								
									THEN ''Y''
								--WHEN (''[@v_group_id]'' =''ADMIN'') and a.MEASURE_GROUP = ''CUST_FCST_2''  -- Admin권한자+CustFcst
								--	THEN ''Y''
								--WHEN (''[@v_group_id]'' =''ADMIN'') and a.MEASURE_GROUP = ''CUST_FCST_3''  -- Admin권한자+CustFcst
								--	THEN ''Y''
								WHEN (''[@v_group_id]'' =''ADMIN'') and a.MEASURE_GROUP <> ''TMM_FCST'' and a.MEASURE		= M1.SEGMENT2  -- Admin권한자+MktFcst등 (TMM 제외)
									THEN ''Y''
								WHEN a.MEASURE_GROUP = ''TMM_FCST'' and a.PROJECT_CODE	= M2.SEGMENT2 and a.MEASURE		= M1.SEGMENT2  -- TMM MEASURE 수정권한자 조건
									THEN ''Y''
								ELSE
									''N''
							END  AS EDIT_FLAG 
							-- [C20200713-000189] VMI 관련 수정 --> [C20201015-000200] 주석처리하고 원복함.
						  -- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
						  , A.CELL_PER_CAR
						  , A.CELL_PER_MODULE
						  , A.MODULE_PER_CAR
						  -- 20190705 KHSONG [CSR ID:4023158] (END)
						  , A.SORT_ORDER_NO  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
						  , A.MEASURE_GROUP  -- 20191119 KHSONG Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선

						--20200130 KHSONG [C20200114-000201]
						,A.ENERGE
						,A.CELL_QUANTITY
						--20200130 KHSONG [C20200114-000201]
						,''N'' AS NEW_FLAG -- [C20200702-000136] New Flag 추가
						, CASE WHEN A.DIVISION_ID = ''40'' THEN CAST(CAST(VM.VMI_STD_DIO AS INT) AS NVARCHAR(30))	-- [C20200713-000189] 
								ELSE VMI_VAL END AS VMI_STD_DIO -- [C20201103-000114]
						, ISNULL(B1.ATTR1, B2.ATTR1) AS ATTR1 ---- [C20200804-000123] 추가
						, ISNULL(BK.BUCKET, ''0000000'') AS BUCKET
						, ''' + @p_AS_YN + N''' as AS_YN
						, CASE WHEN ''' + @p_AS_YN + N''' = ''Y'' THEN ISNULL(X.DISPLAY_SEQ,999) ELSE 999 END AS SORT_KEY
						, ISNULL(A.AS_FROM_SITE,'''') AS_FROM_SITE
						, CASE WHEN ISNULL(A.CREATE_DATE, '''') = '''' THEN '' '' ELSE A.CREATE_DATE END AS LAST_UPDATE_DATE
						, CASE WHEN ISNULL(A.LAST_UPDATED_BY, '''') = '''' THEN '' '' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY
						, CASE WHEN ISNULL(A.SENDER_CODE, '''') = '''' THEN '' '' ELSE A.SENDER_CODE END AS SENDER_CODE
						, CASE WHEN ISNULL(A.SENDER_NAME, '''') = '''' THEN '' '' ELSE A.SENDER_NAME END AS SENDER_NAME
				INTO #MF
				from #TempMktFcstData a
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] c WITH(NOLOCK)
					   ON  c.BASIS_YYYYMMDD = a.YYYYMMDD
                LEFT OUTER JOIN (   SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
                                    FROM SCM_SYS_CALENDAR_M
                                    WHERE BASIS_YYYYMMDD BETWEEN ''' + @P_FROM_YYYYMMDD + N''' AND ''' + @P_TO_YYYYMMDD + N''' 
                                    GROUP BY BASIS_YYYYMM ) C2 ON A.YYYYMMDD = C2.MONTH_END_DATE
                LEFT OUTER JOIN (   SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
                                    FROM SCM_SYS_CALENDAR_M
                                    WHERE BASIS_YYYYMMDD BETWEEN ''' + @P_FROM_YYYYMMDD + N'''  AND ''' + @P_TO_YYYYMMDD + N''' 
                                    GROUP BY ISO_YYYYWW+PARTIAL_WEEK_NAME ) C3 ON A.yyyymmdd = C3.WEEK_END_DATE
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL X ON A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = ''AS_SITE_PLANT''

				 

				 --LEFT JOIN DM_MST_BUCKET_CONVERSION m WITH(NOLOCK)
					--   ON a.DIVISION_ID     = m.DIVISION_ID
					--   and a.SCM_SITE_ID    = m.SCM_SITE_ID
					--   and a.INCOTERMS      = m.INCOTERMS
					--   and c.DAYOFWEEK      = m.YYYYMMDD

				 -- 20200309 KHSONG C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
				 LEFT JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M1 WITH(NOLOCK)   -- EDIT가능MEASURE
 					   ON  a.DIVISION_ID	= M1.SEGMENT1  -- DIVISION_ID
					   AND a.MEASURE		= M1.SEGMENT2  -- MEASURE
					   AND M1.LOOKUP_TYPE	= ''MKT_FCST_MEASURE''
					   AND M1.SEGMENT5		= ''Y''       -- EDIT_YN 여부
					   AND M1.VALID_YN		= ''Y''       -- VALID_YN 여부
					   --AND M1.ATTRIBUTE2   <> ''Y''       -- TMM MEASURE 가 아닌경우

				 -- 20200309 KHSONG C20200303-000078 : DM meausre 추가의 건 / TMM MEASURE 권한추가
				 LEFT JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M2 WITH(NOLOCK)   -- TMM MEASURE
 					   ON  a.DIVISION_ID	= M2.SEGMENT1  -- DIVISION_ID
					   AND a.PROJECT_CODE	= M2.SEGMENT2  -- PROJECT_CODE
					   AND ''[@p_created_by]''	= M2.SEGMENT4  -- USER_ID
					   AND M2.LOOKUP_TYPE	= ''TMM_MEASURE_ADMIN''
					   AND M2.VALID_YN		= ''Y''       -- VALID_YN 여부
				LEFT JOIN #TempVmiDio VM
					ON A.ITEM_ID = CASE WHEN ''' + @P_DIVISION_ID + N''' = ''40'' THEN VM.KEY_JOIN ELSE A.ITEM_ID END
					AND A.SCM_SITE_ID = CASE WHEN ''' + @P_DIVISION_ID + N''' = ''40'' THEN '''' ELSE VM.KEY_JOIN END 
				LEFT OUTER JOIN #T_SSP_SYNC B1 ON A.DIVISION_ID = B1.DIVISION_ID		-- [C20200804-000123] 추가
					AND A.PROJECT_CODE	= B1.PROJECT_CODE
					AND A.SCM_SITE_ID	= B1.SCM_SITE_ID
					AND A.ITEM_ID		= B1.ITEM_ID
					AND A.DOM_EXP		= B1.DOM_EXP
					AND A.FCST_TYPE		= B1.FCST_TYPE
					AND A.INCOTERMS		= B1.INCOTERMS
					AND A.MEASURE = ''MKT_FCST_RP''
				LEFT OUTER JOIN #T_BNP B2 ON A.DIVISION_ID = B2.DIVISION_ID		-- [PJ20209642R] 추가
					AND A.PROJECT_CODE	= B2.PROJECT_CODE
					AND A.SCM_SITE_ID	= B2.SCM_SITE_ID
					AND A.ITEM_ID		= B2.ITEM_ID
					AND A.DOM_EXP		= B2.DOM_EXP
					AND A.FCST_TYPE		= B2.FCST_TYPE
					AND A.INCOTERMS		= B2.INCOTERMS
					AND A.MEASURE = ''BNPIn''
				LEFT OUTER JOIN (
						SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, CONCAT(ISNULL([SUN],0), ISNULL([MON],0) , ISNULL([TUE],0) , ISNULL([WED],0) , ISNULL([THU],0) , ISNULL([FRI],0) , ISNULL([SAT],0)) AS BUCKET
						FROM (
							SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD, CASE WHEN BUCKET_PER = ''Y'' THEN 1 ELSE 0 END AS BUCKET_PER
							FROM DM_MST_BUCKET_CONVERSION
							) A
						PIVOT ( 
							MAX(BUCKET_PER) FOR YYYYMMDD IN ([SUN], [MON], [TUE], [WED], [THU], [FRI], [SAT])
							) AS PVT 
						WHERE DIVISION_ID = N''' + @P_DIVISION_ID + N'''
					) BK ON A.DIVISION_ID = BK.DIVISION_ID AND A.SCM_SITE_ID = BK.SCM_SITE_ID AND A.INCOTERMS = BK.INCOTERMS
				
				--부서 테이블 추가
				LEFT OUTER JOIN (
									SELECT LOOK.SEGMENT3 as Dept_ID
									FROM   [dbo].[TB_FX_User] AS USR WITH(NOLOCK)
									INNER JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] AS LOOK WITH(NOLOCK)
									ON USR.DEPT_ID = LOOK.SEGMENT1 AND LOOK.LOOKUP_TYPE = ''PM_TEAM_MAPPING'' AND LOOK.VALID_YN = ''Y''
									WHERE  USR.UserID = ''[@p_created_by]''

									UNION -- 중복값 있으면 안됨

									SELECT Dept_ID
									FROM   [dbo].[TB_FX_User] WITH(NOLOCK)
									WHERE UserID = ''[@p_created_by]''
								) AS MA ON A.dept_id = MA.DEPT_id
				--부서 테이블 추가

				WHERE 1=1 
					AND 1 = CASE WHEN N''' + ISNULL(@P_AS_YN,'') + N''' = ''Y'' THEN
										CASE WHEN ISNULL(A.AS_FROM_SITE, '''') <> '''' OR A.SCM_SITE_ID IN ( SELECT SCM_SITE_ID FROM #T_WS_SITE_PLANT ) THEN 1 ELSE 0 END
								ELSE 1 END
				[@v_team_id]
				'
				+ case when @P_AS_YN <> 'Y' then N' option (hash join) ' else '' end

				+ N'
				SELECT [@V_COLUMN]
						, SORT_ORDER_NO
						, [@V_PV_COL_LIST]    
				FROM ( 
						
							SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
							FROM   #MF F					
					
							UNION ALL
							SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' + F.YYYYMMWW AS YYYYMMDD
									, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'' )
												THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)  
															ELSE 0 
														END
											ELSE SUM(F.QTY) 
										END AS QTY
							FROM #MF F
							WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																						  , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN 
																		-9999999999
															   ELSE 0 END)
							GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN

												UNION ALL
							SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' + F.YYYYMM AS YYYYMMDD
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv''  )
												THEN	CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)  
															ELSE 0 
														END
											ELSE SUM(F.QTY) 
										END AS QTY
							FROM #MF F
							WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																						  , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN 
																		-9999999999
															   ELSE 0 END)
							GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN

					) F
				PIVOT (
					SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )
					) AS PVT
				[@V_ORDERBY]

				option ( order group ) 

				  '; 
			END
  
PRINT ( 'H1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
 
 --RETURN;

  --SELECT @v_sql_text;
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_COL_LIST]'    , @v_PV_LIST    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_LIST]'    , @v_PV_LIST    );
  
   
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_column]'       , @v_column       );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_groupby]'      , @v_groupby      );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_team_id]'      , [dbo].[FN_SCM_GET_WHERE_SQL]('A.DEPT_ID', 'IN', @p_team_id)); --20180809 ytchoi modify
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]'   , @p_created_by   );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_group_id]'      , @v_group_id      );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'		, @v_orderby      );
  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_from_yyyymmdd]', @p_from_yyyymmdd);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_to_yyyymmdd]', @p_to_yyyymmdd);
  
	SET @v_sql_text = REPLACE(@v_sql_text,'[@CellQtyYN]'      , @p_cell_yn);	-- 20181114

	-- 개발중에는 텍스트만 확인하고 실행은 안한다.
	 

--SELECT CONVERT(TEXT, @v_sql_text)
--FOR XML PATH('')--,ROOT('x')
--SELECT LEN(@v_sql_text)

	 EXEC SP_EXECUTESQL @v_sql_text; 
	 --EXEC SP_EXECUTESQL @nsql2; -- add son young suk 20180727
	 


	-- 20181115 추가. 소형 사업부 8주 이내는 일별로만 입력되도록  20190104
	SELECT TOP 1 *
	FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
	WHERE ISO_WEEK = DATEPART(ISO_WEEK, DATEADD(WEEK, 7, GETDATE()))
		AND CALENDAR_YYYY = DATEPART(YEAR, DATEADD(WEEK, 7, GETDATE()))
	ORDER BY BASIS_YYYYMMDD

	--20211130 현재 주차
	SELECT 'M_' + A.BASIS_YYYYMM AS THIS_YYYYMM, 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK AS THIS_YYYYMMWW, A.BASIS_DATE 
			, 'M_' + B.BASIS_YYYYMM AS PRE_YYYYMM, 'W_' + B.BASIS_YYYYMM + B.ISO_WEEK AS PRE_YYYYMMWW
			, A.BASIS_YYYYMM, A.ISO_WEEK
		FROM (
			SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE 
			FROM [dbo].[SCM_SYS_CALENDAR_M] 
			WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE(), 112) 
			) A
		JOIN (
			SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE 
			FROM [dbo].[SCM_SYS_CALENDAR_M] 
			WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(DAY, -7, GETDATE()), 112) 
			) B ON 1=1

 ----xml확인할경우
 ----SELECT CONVERT(TEXT, @v_sql_text)
 ----FOR XML PATH('')--,ROOT('x')  
 
 PRINT ( 'I1--' + CONVERT(NVARCHAR(30), GETDATE(), 121))


--select @p_scm_site_id

 /*

 */
END
