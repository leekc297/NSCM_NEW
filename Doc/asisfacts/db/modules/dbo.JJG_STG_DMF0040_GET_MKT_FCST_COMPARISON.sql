/*
 * Program ID   : DMF0040_GET_MKT_FCST_COMPARISON
 * Description  : MKT FCST Comparison 조회 (2개의 version으로 고객 수요 비교 화면용)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/07   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180618		KHSONG			QTY <> 0 으로 수정
 * 20180706						속도개선버젼
 * 2018/07/31   Son Young Suk	검색조건 project(코드,네임 라이크 검색), model/item(코드,닉네임 라이크 검색)으로 수정 
 * 2018/08/01   Son Young Suk	검색조건 version 검색할때 current 빠지게 처리
 * 20180808	    KHSONG			MODIFY  실적구간 중복되어 between 에서 수식으로 수정/p_from 변수사용
 * 20180809		ytchoi			조건수정으로 속도개선
 * 20180809     JYE				멀티 오너 수정
 * 20180810		ytchoi			조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
 * 20180816     KHSONG          VALID_YN 조건추가
 * 20180817     KHSONG          TEAM조건 인입시 속도가 느려서 수정함
 * 20180911     Son Young Suk   조회 컬럼 CELL_TYPE 추가 DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회
 * 20181101     khsong          특정기간(20181101-20190531) 조회시 에러발생으로 BUCKET_PER null조건추가
 * 181102                       속도개선을 의해서 추가
 * 20181116     JYE				PRIORITY 추가
 * 20181207     KHSONG          고객 수요 비교 화면용으로 변환
 * 20190118 KHSONG 중복제거위한 DISTINCT추가
 * 20190911 KHSONG ITEM_ID 검색조건 보완
 * 20200624	hwi1993		성능개선을 위해 with 문을 중간에 끊고, # 테이블로 변경함.
 * 20211125		hwi1993		[C20211109-000439] [SCM PI팀] MKT FCST Comparison 내 W/S팀 수요 구현요청
 * 2021.11.25	hwi1993		프로시저 이름 변경함.
 * 2022.04.18	rosia27		[과제PJ20216891R]GM_JV
 * 2022.04.27	hwi1993		[] 자동차 사업부 vmi 는 mkt fcst 메저를 사용하는 관계로 관련 로직 수정
 * 2022.06.23	kdw2819		[C20220620-000557] GSCM DM 영역내, Version에 주차표기
 * 2022.07.26	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 * 2022.09.15	KDW2819		[C20220831-000365]MKT FCST Comparison 조회 로직 개선 요청 건
 * 2022.09.29	kdw2819		[C20220929-000253]MKT FCST Comparison Project 코드 조회 오류 건
 * 2023.10.25    HMIN       [E20231017-000634] [영업/마케팅 PI팀] MKT FCST Report 화면 칼럼추가 (SCP테이블정보) (요청자: 오윤종님)
 * 2024.02.15    hmin       [E20240201-001467] MKT FCST Comparison 화면 정렬 Order 개선
 */
CREATE PROCEDURE [dbo].[JJG_STG_DMF0040_GET_MKT_FCST_COMPARISON]  
  @p_division_id    NVARCHAR(MAX),
  @p_scm_site_id    NVARCHAR(MAX),
  @p_plant_site_id  NVARCHAR(MAX),
  @p_team_id        NVARCHAR(MAX),
  @p_customer       NVARCHAR(MAX),
  @p_biz_type       NVARCHAR(MAX),
  @p_project_code   NVARCHAR(MAX),
  @p_item_id        NVARCHAR(MAX),
  @p_from_yyyymmdd  NVARCHAR(8),
  @p_to_yyyymmdd    NVARCHAR(8),
  @p_created_by		NVARCHAR(50),
  @p_version_no     NVARCHAR(MAX),
  @p_item_type      NVARCHAR(MAX),
  @p_owner          NVARCHAR(MAX),
  @p_diff_only      NVARCHAR(MAX),  -- 'True' or 'False'
  --,@p_debug         NVARCHAR(MAX) OUTPUT
  @p_bucket			NVARCHAR(20)
AS  
  
BEGIN
  SET NOCOUNT ON;

	DECLARE @v_sql_text          AS NVARCHAR(MAX);
	DECLARE @v_sql_text_result   AS NVARCHAR(MAX);
	DECLARE @v_sql_text3         AS NVARCHAR(MAX);
	DECLARE @v_iteration         AS NVARCHAR(MAX);
	DECLARE @v_column            AS NVARCHAR(MAX);
	DECLARE @v_groupby           AS NVARCHAR(MAX);
	DECLARE @v_orderby           AS NVARCHAR(MAX);
	DECLARE @v_column_text       AS NVARCHAR(1000);
	DECLARE @v_column_name       AS NVARCHAR(50);
	DECLARE @v_column_date       AS NVARCHAR(50);
	DECLARE @v_column_type       AS NVARCHAR(50);
	DECLARE @v_column_value      AS NVARCHAR(50);  
	DECLARE @v_sort_order_no     AS NVARCHAR(50);
	DECLARE @v_day_code          AS NVARCHAR(50);  
	DECLARE @p_param_list        AS NVARCHAR(4000);
	DECLARE @p_end_week          AS NVARCHAR(6);
	DECLARE @v_program_id        AS NVARCHAR(10);
	DECLARE @v_sheet_name        AS NVARCHAR(100);
	DECLARE @v_groupby_column    AS NVARCHAR(100);
	DECLARE @v_week_monday       AS NVARCHAR(8);
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(1000);
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(1000);
	DECLARE @v_from_yyyymmdd_f   AS NVARCHAR(1000);
	DECLARE @v_to_yyyymmdd_f     AS NVARCHAR(1000);
	DECLARE @v_from_yyyymmdd_t   AS NVARCHAR(1000); 
	DECLARE @v_to_yyyymmdd_t     AS NVARCHAR(1000);
	DECLARE @v_from_result_date  AS NVARCHAR(8);
	DECLARE @v_to_result_date    AS NVARCHAR(8);
	DECLARE @v_from_result       AS NVARCHAR(1000);
	DECLARE @v_to_result         AS NVARCHAR(1000);
	DECLARE @v_from_result_f     AS NVARCHAR(1000);
	DECLARE @v_to_result_f       AS NVARCHAR(1000);
	DECLARE @v_from_result_t     AS NVARCHAR(1000);
	DECLARE @v_to_result_t       AS NVARCHAR(1000);
	DECLARE @v_version_no        AS NVARCHAR(MAX);
	DECLARE @v_version_no_q      AS NVARCHAR(MAX);  --20181207
	DECLARE @v_user_col_cnt      AS INT;
	DECLARE @v_user_mea_cnt      AS INT;
	DECLARE @v_dept_id           AS NVARCHAR(50);  
	DECLARE @v_user_time_zone    AS NVARCHAR(50);  
  ----20180626, lsh
	DECLARE @v_owner_sml_text	 AS NVARCHAR(MAX);
	DECLARE @v_owner_def_text	 AS NVARCHAR(MAX);

	DECLARE @p_program_id        AS NVARCHAR(50);
	SET @p_program_id = 'DMF0040';
	SET @v_dept_id = '';
	DECLARE @v_group_id nvarchar(max)='';


  DECLARE c_bucket CURSOR FAST_FORWARD FOR 
    SELECT 'D_' + a.basis_yyyymmdd  AS column_name
         , a.basis_yyyymmdd         AS column_date
         , 'F.YYYYMMDD'             AS column_type
	     , 'F.QTY'                  AS column_value
	     , a.basis_yyyymmdd + '_' + CONVERT(CHAR(2), 31) AS sort_order_no
    FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
    WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd -- '20171101'  CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
    AND    a.basis_yyyymmdd <= @p_to_yyyymmdd   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)   
	AND    @p_bucket != 'ONLY_WEEKLY'
    UNION ALL
    SELECT 'W_' + a.basis_yyyymm + a.iso_week  AS column_name
         , a.basis_yyyymm + a.iso_week         AS column_date
         , 'F.YYYYMMWW'                        AS column_type
	     , 'F.QTY'                             AS column_value
	     , a.basis_start_date + '_' + CONVERT(CHAR(2), 21) AS sort_order_no
    FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
    WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
    AND    a.basis_yyyymmdd <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
	AND    @p_bucket != 'ONLY_WEEKLY'
    GROUP BY a.basis_yyyymm
           , a.iso_week    
           , a.basis_start_date   
    UNION ALL
    SELECT 'M_' + a.basis_yyyymm  AS column_name
	      , a.basis_yyyymm        AS column_date
		  , 'F.YYYYMM'            AS column_type
		  , 'F.QTY'               AS column_value
          , MIN(a.basis_start_date) + '_' + CONVERT(CHAR(2), 1) AS sort_order_no
    FROM    [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
    WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
    AND    a.basis_yyyymmdd <= @p_to_yyyymmdd --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
	AND    @p_bucket != 'ONLY_WEEKLY' 
    GROUP BY a.basis_yyyymm    
	-- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)  
    UNION ALL  
    SELECT 'W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK		AS COLUMN_NAME  
		   ,  SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK			AS COLUMN_DATE   
		   , 'F.YYYYMMWW'											AS COLUMN_TYPE
	       , 'F.QTY'												AS COLUMN_VALUE
		   , MAX(BASIS_YYYYMMDD)+ '_' +CONVERT(CHAR(2), 21)			AS SORT_ORDER_NO  
    FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)   
    WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd   
    AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd  
    AND    @p_bucket = 'ONLY_WEEKLY'  
    GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME  
	;
  SET @v_iteration = '';
  
  OPEN c_bucket;
  FETCH NEXT FROM c_bucket INTO @v_column_name, @v_column_date, @v_column_type, @v_column_value, @v_sort_order_no
  WHILE @@FETCH_STATUS = 0     
			BEGIN  
				IF SUBSTRING(@v_column_name, 2, 1) = 'B' 
					SET @v_column_text = ', MAX(CASE WHEN [@v_column_type] = [@v_column_date] THEN [@v_column_value] ELSE NULL END) AS [@v_column_name] ';
				ELSE
					--SET @v_column_text = ', SUM(CASE WHEN [@v_column_type] = [@v_column_date] THEN [@v_column_value] ELSE NULL END) AS [@v_column_name] '; --ORG
				BEGIN	--20180517, 수정
					IF SUBSTRING(@v_column_name, 1, 1) = 'M' 
						SET @v_column_text = '
							, SUM(CASE 
									WHEN [@v_column_type] = [@v_column_date] AND F.Measure NOT IN ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') THEN F.QTY 
									WHEN [@v_column_type] = [@v_column_date] AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND M_LAST_D_FLAG = ''Y'' THEN F.QTY
									WHEN [@v_column_type] = [@v_column_date] AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND M_LAST_D_FLAG <> ''Y''THEN NULL
									ELSE NULL 
								  END) AS [@v_column_name]';
					IF SUBSTRING(@v_column_name, 1, 1) = 'W'								  
						SET @v_column_text = '
							, SUM(CASE 
									WHEN [@v_column_type] = [@v_column_date] AND F.Measure NOT IN ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') THEN F.QTY 
									WHEN [@v_column_type] = [@v_column_date] AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND F.END_FLAG = ''Y'' THEN F.QTY 
									WHEN [@v_column_type] = [@v_column_date] AND F.Measure IN  ( ''BALANCE'',''VMI_Inv'',''AS_Inv'') AND F.END_FLAG <> ''Y'' THEN NULL
									ELSE NULL 
								  END) AS [@v_column_name]';
					IF SUBSTRING(@v_column_name, 1, 1) = 'D'
						SET @v_column_text = ', SUM(CASE WHEN [@v_column_type] = [@v_column_date] THEN [@v_column_value] ELSE NULL END) AS [@v_column_name] ';

				END


				SET @v_column_text = REPLACE(@v_column_text,'[@v_column_type]', @v_column_type);
				SET @v_column_text = REPLACE(@v_column_text,'[@v_column_date]', @v_column_date);
				SET @v_column_text = REPLACE(@v_column_text,'[@v_column_value]', @v_column_value);
				SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

				SELECT @v_iteration = @v_iteration + @v_column_text;	
    
				FETCH NEXT FROM c_Bucket INTO @v_column_name, @v_column_date, @v_column_type, @v_column_value, @v_sort_order_no
			END;

  --SELECT @v_iteration AS xxxx;

  CLOSE c_bucket;  
  DEALLOCATE c_bucket;

  SET @v_column_name = '';
  SET @v_column = '';
  SET @v_groupby = '';
  SET @v_user_col_cnt = 0;
  SET @v_user_mea_cnt = 0;

    SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @p_program_id
    AND    U.SHEET_NAME = 'Mkt Fcst Waterfall' 
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
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall' 
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND    C.VISIBLE_FLAG = 'Y'  --[E20240201-001467]

		UNION ALL

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
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG = ''			
		AND    C.VALID_YN     = 'Y';
    END;

	SELECT @v_user_mea_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = @p_program_id
    AND    U.SHEET_NAME = 'Mkt Fcst Waterfall'
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
		AND    C.PROGRAM_ID  = @p_program_id
		AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall' 
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'	;
			
	END;

  DECLARE c_title CURSOR FAST_FORWARD FOR 
      SELECT U.PROGRAM_ID
           , U.SHEET_NAME
           , U.COLUMN_NAME 
		   , U.DATA_SORT_METHOD_CODE
      FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
           , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
      WHERE  1 = 1
      AND    U.PROGRAM_ID  = C.PROGRAM_ID
      AND    U.SHEET_NAME  = C.SHEET_NAME
      AND    U.COLUMN_NAME = C.COLUMN_NAME
      AND    U.PROGRAM_ID  = @p_program_id
      AND    U.SHEET_NAME  = 'Mkt Fcst Waterfall'
      AND    U.USER_ID     = @p_created_by
      AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
	  AND    C.VISIBLE_FLAG = 'Y'  --[E20240201-001467] 해당조건이 있어야 정상적으로 measure sorting 됨.
	  UNION ALL
	  SELECT C.PROGRAM_ID
           , C.SHEET_NAME
           , C.COLUMN_NAME
		   , C.DATA_SORT_METHOD_CODE
      FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
      WHERE  1 = 1      
      AND    C.PROGRAM_ID  = @p_program_id
      AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'      
      AND    C.VISIBLE_FLAG = 'N'
	  AND    C.DEFAULT_FLAG = ''
	  ;

  DECLARE @v_DATA_SORT_METHOD_CODE       AS NVARCHAR(50);

  OPEN c_title;
  --20240216
  --FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_column_name--, @v_sort_order_no
  FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_column_name , @v_DATA_SORT_METHOD_CODE --, @v_sort_order_no
  WHILE @@FETCH_STATUS = 0   
  BEGIN  
    IF @v_column = ''
	    BEGIN
	    SET @v_column  =  'F.' + @v_column_name;
		SET @v_groupby = ' GROUP BY F.' + @v_column_name;
		--SET @v_orderby = ' ORDER BY F.' + @v_column_name;
		SET @v_orderby = ' ORDER BY F.' + @v_column_name + ' ' + @v_DATA_SORT_METHOD_CODE;
		END;
	ELSE
	    BEGIN
		SET @v_column  = @v_column  + ', F.' + @v_column_name;
		SET @v_groupby = @v_groupby + ', F.' + @v_column_name;
		--SET @v_orderby = @v_orderby + ', F.' + @v_column_name;
		SET @v_orderby = @v_orderby + ', F.' + @v_column_name + ' ' +  @v_DATA_SORT_METHOD_CODE;
        END;	    

	--SELECT @v_iteration = @v_iteration + @v_column_text;	
    --FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_column_name--, @v_sort_order_no
	FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_column_name , @v_DATA_SORT_METHOD_CODE--, @v_sort_order_no
  END;
  
  --Measure Sort Order No로 Sort
  SET @v_groupby = @v_groupby + ', F.VERSION_SORT';
  SET @v_orderby = @v_orderby + ', F.VERSION_SORT';  --20240222


  --SELECT @v_column;
  --SELECT @v_groupby;

  CLOSE c_title;  
  DEALLOCATE c_title;

  SET @v_week_monday      = '';
  SET @v_from_result_date = '';
  SET @v_to_result_date   = '';
  SET @v_from_yyyymmdd    = '';
  SET @v_to_yyyymmdd      = '';
  SET @v_from_yyyymmdd_f  = '';
  SET @v_to_yyyymmdd_f    = '';
  SET @v_from_yyyymmdd_t  = '';
  SET @v_to_yyyymmdd_t    = '';
  SET @v_from_result      = '';
  SET @v_to_result        = '';
  SET @v_from_result_f    = '';
  SET @v_to_result_f      = '';
  SET @v_from_result_t    = '';
  SET @v_to_result_t      = '';
  SET @v_user_time_zone   = '';

  BEGIN
	  SELECT @v_user_time_zone = U.TIMEZONE
	  FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
	  WHERE  U.UserID = @p_created_by;
  END

  SELECT @v_week_monday = MIN(C.BASIS_YYYYMMDD)  /* 현재시점의 월요일 */
  FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
       , (SELECT DISTINCT ISO_YYYYWW		    		
	      FROM   [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) 
		  WHERE  1 = 1
		  AND    BASIS_YYYYMMDD = CONVERT(CHAR(8), dbo.FN_MULTY_TIME(@v_user_time_zone), 112)
		 ) T
  WHERE  1 = 1
  AND    C.ISO_YYYYWW = T.ISO_YYYYWW ;

  SELECT @v_from_result_date = C.BASIS_START_DATE
  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
  WHERE  1 = 1
  AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd; 

  SELECT @v_to_result_date = C.BASIS_START_DATE
  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
  WHERE  1 = 1
  AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd; 
  
  SET @v_from_yyyymmdd = @v_from_result_date  /* 조회시작일 */
  SET @v_to_yyyymmdd = @v_to_result_date      /* 조회끝날짜 */
  
  IF @v_week_monday > @v_from_result_date
      BEGIN -- 실적 계획 보여줌
	  SET @v_from_yyyymmdd    = '''' + @v_week_monday + '''';
	  SET @v_to_yyyymmdd      = '''' + @p_to_yyyymmdd + '''';
	  SET @v_from_yyyymmdd_f  = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)'
	  SET @v_to_yyyymmdd_f    = '''' + @p_to_yyyymmdd + '''';
	  SET @v_from_yyyymmdd_t  = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  SET @v_to_yyyymmdd_t    = '''' + @p_to_yyyymmdd + '''';
      SET @v_from_result      = '''' + @p_from_yyyymmdd + '''';
	  SET @v_to_result        = '''' + @v_week_monday + '''';
	  SET @v_from_result_f    = '''' + @p_from_yyyymmdd + '''';
	  SET @v_to_result_f      = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  SET @v_from_result_t    = '''' + @p_from_yyyymmdd + '''';
	  SET @v_to_result_t      = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';	  
	  END;
  ELSE IF @v_week_monday <= @v_from_result_date
      BEGIN -- 실적 없음 계획만 보여줌
	  SET @v_from_yyyymmdd   = '''' + @v_week_monday + '''';
	  SET @v_to_yyyymmdd     = '''' + @p_to_yyyymmdd + '''';
	  SET @v_from_yyyymmdd_f = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)'
	  SET @v_to_yyyymmdd_f   = '''' + @p_to_yyyymmdd + '''';
	  SET @v_from_yyyymmdd_t = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  SET @v_to_yyyymmdd_t   = '''' + @p_to_yyyymmdd + '''';
	  SET @v_from_result     = '''' + '19000101' + '''';
      SET @v_to_result       = '''' + '19000101' + '''';
	  SET @v_from_result_f   = '''' + '19000101' + '''';
	  SET @v_to_result_f     = '''' + '19000101' + '''';
	  SET @v_from_result_t   = '''' + '19000101' + '''';
	  SET @v_to_result_t     = '''' + '19000101' + '''';
	  END;
  ELSE IF @v_week_monday > @v_to_result_date
      BEGIN -- 실적만 보여줌
	  SET @v_from_yyyymmdd   = '''' + '19000101' + '''';
      SET @v_to_yyyymmdd     = '''' + '19000101' + '''';
	  SET @v_from_yyyymmdd_f = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)'
	  SET @v_to_yyyymmdd_f   = '''' + @v_to_result_date + '''';
	  SET @v_from_yyyymmdd_t = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  SET @v_to_yyyymmdd_t   = '''' + @v_to_result_date + '''';
	  SET @v_from_result     = '''' + @p_from_yyyymmdd + '''';	
	  SET @v_to_result       = '''' + @v_to_result_date + '''';	
	  SET @v_from_result_f   = '''' + @v_to_result_date + '''';  
	  SET @v_to_result_f     = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)'
	  SET @v_from_result_t   = '''' + @v_to_result_date + '''';
	  SET @v_to_result_t     = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  END;
  ELSE IF @v_week_monday = @v_to_result_date
      BEGIN
	  SET @v_from_yyyymmdd   = '''' + @v_week_monday + '''';
      SET @v_to_yyyymmdd     = '''' + @v_week_monday + '''';
	  SET @v_from_yyyymmdd_f = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  SET @v_to_yyyymmdd_f   = '''' + @v_week_monday + '''';
	  SET @v_from_yyyymmdd_t = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  SET @v_to_yyyymmdd_t   = '''' + @v_week_monday + '''';
	  SET @v_from_result     = '''' + @p_from_yyyymmdd + '''';
	  SET @v_to_result       = '''' + @p_to_yyyymmdd + '''';
	  SET @v_from_result_f   = '''' + @p_from_yyyymmdd + '''';
	  SET @v_to_result_f     = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  SET @v_from_result_t   = '''' + @p_from_yyyymmdd + '''';
	  SET @v_to_result_t     = 'CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(T.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)';
	  END;

	  PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd
      PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd
      PRINT 'v_from_result =' +@v_from_result
      PRINT 'v_to_result =' +@v_to_result


	------------------------------------------------------------------------------------------------- 20190911 ADD ITEM조회조건 속도개선 (BEGIN)
	-- 20190911 KHSONG ITEM_ID = (MCCM131012A1-M01,MCCM131012A1) 이렇게 조회시 두배로 보이는 현상으로 재 GROUP (BEGIN)
	IF OBJECT_ID (N'tempdb..#TEMP_SKH_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
	DROP TABLE #TEMP_SKH_DM_MST_ITEM_SINGLE_V

	-- 20190911 마지막 자릿수에 콤마값이 들어오면 제거
	IF SUBSTRING(@p_item_id,LEN(@p_item_id),1) = ','
		BEGIN
			SET @p_item_id = SUBSTRING(@p_item_id,1,LEN(@p_item_id) - 1)
		END
	-- 20190911 마지막 자릿수에 콤마값이 들어오면 제거

	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE
		INTO #TEMP_SKH_DM_MST_ITEM_SINGLE_V
		FROM 
			(SELECT *
--			FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)    -- [20240312] View 제거후 scm_mst_site_item 조인
			FROM ( SELECT	T1.DIVISION_ID,
							T1.ITEM_ID, 
							MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
							MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
							MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
							MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
							case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
											when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
											when T1.item_type = 'Q' then 3
											else 4 end )  
															when 1 then 'P' 
															when 2 then 'H'
															when 3 then 'Q'
															else 'R' end	AS ITEM_TYPE,
							MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
							MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
							MAX(T1.SPEC								)		AS SPEC,
							MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
							MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
							MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
							MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
							MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
							MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
							MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
							MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
							MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
							MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
							MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
							MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
							MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
					  FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
					  INNER JOIN ( SELECT T3.DIVISION_ID, LEFT(T3.ITEM_ID, 12) AS ITEM_ID
										, MAX(T3.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
										, MAX(T3.FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
										, MAX(T3.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
										, MAX(T3.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
										, MAX(T3.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
										, MAX(T3.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
										, MAX(T3.CELL_TYPE) AS CELL_TYPE
									FROM  SCM_MST_ITEM_SN T3 WITH(NOLOCK) 
									INNER JOIN scm_mst_site_item T4 WITH(NOLOCK) ON T4.DIVISION_ID = T3.DIVISION_ID AND T4.ITEM_ID = T3.ITEM_ID
									WHERE T3.DIVISION_ID = @p_division_id  --'40'
									GROUP BY T3.DIVISION_ID, LEFT(T3.ITEM_ID, 12)
								) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
						   AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
					  where 1=1
					  AND T1.DIVISION_ID = @p_division_id	
					  --WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
					  --LGCE_FPDEV_TR.DBO.SCM_ITEM_M T1
					 group by T1.DIVISION_ID, T1.ITEM_ID ) T2 
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							ON	T2.ITEM_ID		like  b.tst 
							OR	T2.NICK_NAME	like  b.tst 
							AND b.tst <> '%%'					
				WHERE DIVISION_ID = @p_division_id
			) G
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MATERIAL_CLASS_NAME,ITEM_UOM,SPEC,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT
	,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,ACTIVE_FLAG,CELL_TYPE

CREATE CLUSTERED INDEX [IDX1_TEMP_SKH_DM_MST_ITEM_SINGLE_V] ON [#TEMP_SKH_DM_MST_ITEM_SINGLE_V]
(division_id   ASC
,item_id       ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;


	IF OBJECT_ID (N'tempdb..#ITEM_INPUT', N'U') IS NOT NULL 
	DROP TABLE #ITEM_INPUT;

	SELECT DISTINCT T2.ITEM_ID
		INTO #ITEM_INPUT
			FROM  	#TEMP_SKH_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
			INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
					ON	T2.ITEM_ID		like  b.tst 
					OR	T2.NICK_NAME	like  b.tst 						
			WHERE	T2.DIVISION_ID		= @p_division_id
-- 20190911 KHSONG ITEM_ID = (MCCM131012A1-M01,MCCM131012A1) 이렇게 조회시 두배로 보이는 현상으로 재 GROUP (END)
------------------------------------------------------------------------------------------------- 20190911 ADD ITEM조회조건 속도개선 (END)


--------------------------------------------------------------------------------------------------- 20190911 ADD PROJECT조회조건 속도개선 (START)
	IF OBJECT_ID (N'tempdb..#PROJECT_INPUT', N'U') IS NOT NULL 
	DROP TABLE #PROJECT_INPUT
	;
	CREATE TABLE #PROJECT_INPUT( [PROJECT_CODE] [nvarchar](30) NOT NULL		)

	IF @p_division_id IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 LIKE '81%' AND ATTRIBUTE3 = '82')
		BEGIN
			INSERT INTO #PROJECT_INPUT
			SELECT DISTINCT I.PROJECT_CODE
				
					from scm_mst_site_item I WITH(NOLOCK)
					INNER JOIN 	#TEMP_SKH_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
							ON	I.DIVISION_ID	= T2.DIVISION_ID
							AND	I.ITEM_ID		= T2.ITEM_ID
							AND I.VALID_YN		= 'Y'
					INNER JOIN 	SCM_MST_PROJECT	T3  WITH(NOLOCK)
							ON	I.DIVISION_ID	= T3.DIVISION_ID
							AND	I.PROJECT_CODE	= T3.PROJECT_CODE								
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) c
							ON	I.project_code	like  c.tst 
							OR	T3.project_name like  c.tst 	-- 20180809 ytchoi
					WHERE	I.DIVISION_ID		= @p_division_id
		END
	ELSE
		BEGIN
			INSERT INTO #PROJECT_INPUT
			SELECT DISTINCT I.PROJECT_CODE
					from scm_mst_site_item I WITH(NOLOCK)
					INNER JOIN 	#TEMP_SKH_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
							ON	I.DIVISION_ID	= T2.DIVISION_ID
							AND	I.ITEM_ID		= T2.ITEM_ID
							AND I.VALID_YN		= 'Y'
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) c
							ON	I.project_code	like  c.tst 
					WHERE	I.DIVISION_ID		= @p_division_id
		END
			;
--------------------------------------------------------------------------------------------------- 20190911 ADD PROJECT조회조건 속도개선 (END)
	SET @v_sql_text = N'

		/* [E20231017-000634] */
		--INSERT INTO #SCP_ITEM_INFO (DIVISION_ID, ITEM_ID,	  CELL_NICKNAME, BASIC_NICKNAME_CELL40, NICKNAME_40
		--					  , GROUP_CODE1, GROUP_CODE4, GROUP_CODE5,	 GROUP_CODE6, GROUP_CODE7
		--					  , CELL_TYPE_GROUP_NAME)
		--SELECT *
		SELECT DIVISION_ID, ITEM_ID, CELL_NICKNAME, BASIC_NICKNAME_CELL40, NICKNAME_40, GROUP_CODE1, GROUP_CODE4, GROUP_CODE5,	 
			    GROUP_CODE6, GROUP_CODE7 , CELL_TYPE_GROUP_NAME 
		INTO #SCP_ITEM_INFO
		FROM (
			SELECT  SCP_P.DIVISION_ID
					, SCP_P.ITEM_ID
					, SCP_P.CELL_NICKNAME
					, SCP_P.BASIC_NICKNAME_CELL40
					, SCP_P.NICKNAME_40
					, SCP_P.GROUP_CODE1
					, SCP_P.GROUP_CODE4
					, SCP_P.GROUP_CODE5
					, SCP_P.GROUP_CODE6
					, SCP_P.GROUP_CODE7
					, CASE WHEN SCP_P.LEVEL_EXCEPT = ''EC'' THEN ''POUCH''
							WHEN SCP_P.LEVEL_EXCEPT = ''AM'' THEN ''CYLINDRICAL''
							WHEN SUBSTRING(SCP_P.ITEM_ID, 3, 1) = ''M'' AND SCP_P.OPERATION_ID = ''P9500'' THEN ''POUCH''
					ELSE SCP_G.CELL_TYPE_GROUP_NAME END AS CELL_TYPE_GROUP_NAME
			FROM ( /* #TBLDYNAMICPIVOT_SCP0017_PRE */
					SELECT DIVISION_ID
						, FLOW_ID                       AS OPERATION_ID
						, ITEM_ID
						, SUBSTRING(A.ITEM_ID, 3, 1)    AS CELL_TYPE_CODE
						, SUBSTRING(A.ITEM_ID, 1, 2)    AS LEVEL_EXCEPT -- 예외적용
						, CASE WHEN SUBSTRING(A.DIVISION_ID, 1, 2) = ''81''  THEN GROUP_CODE1
								WHEN A.DIVISION_ID = ''82''                  THEN LEVEL2_CODE
							ELSE '''' END AS CELL_NICKNAME
						, CASE WHEN SUBSTRING(A.ITEM_ID, 1, 2) = ''EC'' THEN ''ESS''
								WHEN SUBSTRING(A.ITEM_ID, 1, 2) = ''AM'' THEN ''M50L''
							ELSE CASE WHEN A.OPERATION_GROUP = ''P'' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL))
									ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)) END
							END  AS BASIC_NICKNAME_CELL40
						, A.NICK_NAME  AS NICKNAME_40
						, A.GROUP_CODE4
						, A.GROUP_CODE5
						, A.GROUP_CODE6
						, A.GROUP_CODE7
						, A.GROUP_CODE1
						, CASE WHEN A.FLOW_ID IN (''A3000'', ''A9000'') THEN ''C'' ELSE ''E'' END  AS FLOW_TYPE	
					FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
					WHERE   1=1
						AND (SUBSTRING(A.ATTRIBUTE8, 1, 2) <> ''CA'' OR A.ATTRIBUTE8 = '''' OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
						AND A.DIVISION_ID = N'''+@p_division_id +N'''						
			) SCP_P
			LEFT OUTER JOIN (
							/* #TBLDYNAMICPIVOT_SCP0017_CELL_TYPE_GROUP */
							SELECT  A.CODE                    AS CELL_TYPE_CODE
								, SUBSTRING(A.NAME, 1, 1)   AS FLOW_TYPE
								, A.GROUP_CODE              AS CELL_TYPE_GROUP_CODE
								, G.NAME                    AS CELL_TYPE_GROUP_NAME
								, A.DISPLAY_SEQ		
							FROM    
							(
								SELECT    B.SEGMENT1 CODE
										, B.SEGMENT2 NAME
										, B.SEGMENT3 GROUP_CODE
										, B.DISPLAY_SEQ
								FROM    SCM_ADM_LOOKUP_MASTER A		WITH(NOLOCK)
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE			       
								AND B.VALID_YN = ''Y''
								WHERE   1=1
									AND A.LOOKUP_TYPE   = ''CELL_TYPE_ITEM_CODE''
									AND A.VALID_YN      = ''Y''
							) A
							JOIN
							(
								SELECT    B.SEGMENT1 CODE
										, B.SEGMENT2 NAME
								FROM    SCM_ADM_LOOKUP_MASTER A		WITH(NOLOCK)
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = ''Y''
								WHERE   1=1
									AND A.LOOKUP_TYPE   = ''CELL_TYPE_ITEM_GROUP''
									AND A.VALID_YN      = ''Y''
							) G ON A.GROUP_CODE = G.CODE
			) SCP_G ON SCP_G.FLOW_TYPE = SCP_P.FLOW_TYPE AND SCP_G.CELL_TYPE_CODE  = SCP_P.CELL_TYPE_CODE  
		)  T;
		/* END */
		
			SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM, B.DAYOFWEEK  
			INTO #CALENDAR  
			FROM (  
				SELECT SUBSTRING(MAX(BASIS_YYYYMMDD),1,6) + ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW,  ISO_WEEK  
				FROM SCM_SYS_CALENDAR_M  
				WHERE BASIS_YYYYMMDD >= N'''+@p_from_yyyymmdd +N'''  
				AND   BASIS_YYYYMMDD <= N'''+@p_TO_yyyymmdd +N'''  
				GROUP BY  ISO_YYYYWW, ISO_WEEK  
			) AS A  
			JOIN SCM_SYS_CALENDAR_M AS B  
				ON	A.ISO_YYYYWW = B.ISO_YYYYWW  
				AND A.ISO_WEEK = B.ISO_WEEK
			;



			SELECT
				token AS VERSION_NO
				, CASE	WHEN row_number() OVER (ORDER BY  VERSION_NO_SORT DESC) = 1 THEN ''Version(A)'' 
						WHEN row_number() OVER (ORDER BY  VERSION_NO_SORT DESC) = 2 THEN ''Version(B)''
						ELSE ''VERSION_X''
						END AS VERSION_TYPE
			INTO #Target_VERSION_NO
			FROM
				(SELECT CASE WHEN token = ''Current'' THEN ''Z'' 
							ELSE ''X''+SUBSTRING(token,6,13)
							END
							AS VERSION_NO_SORT
					,token 
					FROM (SELECT  LEFT(token,  CASE WHEN CHARINDEX(''('',token) = 0 THEN LEN(token) ELSE CHARINDEX(''('',token)-1 END) AS  TOKEN
					FROM [dbo].[String_Split](''[@p_version_no]'' ,'',''))  AS B
				) A
			;


			
			SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, T3.PROJECT_NAME
					,'''' cell_model		-- 20180809 ytchoi						  
					,S.VMI_YN, CASE WHEN S.OPERATION_GROUP = ''W'' THEN ''Y'' ELSE ''N'' END AS AS_YN, F.VALID_YN
					,F.OWNER 
					, DBO.FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''EN'')                AS OWNER_NAME
					, DBO.FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''KO'')                AS OWNER_NAME_KO
			INTO #Target_SITE_ITEM
			FROM SCM_MST_SITE_ITEM F WITH(NOLOCK)
			INNER JOIN 	#TEMP_SKH_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
					ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
			LEFT OUTER JOIN SCM_MST_PROJECT	T3  WITH(NOLOCK)
					ON	F.DIVISION_ID	= T3.DIVISION_ID
					AND	F.PROJECT_CODE	= T3.PROJECT_CODE								
					[@sp_item_id]
					[@sp_project_code]
			INNER JOIN 	SCM_MST_SITE	s  WITH(NOLOCK)
					ON	F.DIVISION_ID    = s.DIVISION_ID
					AND	F.SCM_SITE_ID    = s.SCM_SITE_ID
			WHERE F.DIVISION_ID <> ''40'' -- hard coding
					[@v_division_id]
					[@v_scm_site_id]
			UNION ALL 
			SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, F.PROJECT_CODE
					,f.attribute5 AS cell_model  -- 20180810 ytchoi 조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
					,S.VMI_YN, CASE WHEN S.OPERATION_GROUP = ''W'' THEN ''Y'' ELSE ''N'' END AS AS_YN, F.VALID_YN, F.OWNER
					, DBO.FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''EN'')                AS OWNER_NAME
					, DBO.FN_GET_DM_MKT_OWNER_NAME (F.OWNER, '','', ''KO'')                AS OWNER_NAME_KO
			FROM SCM_MST_SITE_ITEM F WITH(NOLOCK)
			INNER JOIN 	#TEMP_SKH_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
					ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					AND F.VALID_YN		= ''Y''
					[@sp_item_id]
					--[@sp_project_code]
			INNER JOIN 	SCM_MST_SITE	s  WITH(NOLOCK)
					ON	F.DIVISION_ID    = s.DIVISION_ID
					AND	F.SCM_SITE_ID    = s.SCM_SITE_ID
			WHERE F.DIVISION_ID = ''40'' -- hard coding
					[@v_division_id]
					[@v_scm_site_id]
			;

            SELECT ''Current'' AS VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY
				, T2.cell_model		-- 20180809 ytchoi
			INTO #ALL_QUERY_DATA_B	 
            FROM [dbo].[DM_PLN_MKT_FCST]       F WITH(NOLOCK)
			LEFT OUTER JOIN 	#Target_SITE_ITEM	T2  WITH(NOLOCK)
				ON	F.DIVISION_ID = T2.DIVISION_ID
				AND	F.project_code = T2.project_code
				AND	F.SCM_SITE_ID = T2.SCM_SITE_ID
				AND	F.ITEM_ID   = T2.ITEM_ID
				-- AND T2.VALID_YN = ''Y''
			INNER JOIN SCM_MST_SITE C (NOLOCK) 
				ON F.DIVISION_ID = C.DIVISION_ID 
				AND F.SCM_SITE_ID = C.SCM_SITE_ID 
				AND C.VALID_YN = ''Y''   
            WHERE F.QTY <> 0
				AND T2.VALID_YN = ''Y''
				and f.YYYYMMDD between [@v_from_yyyymmdd] and [@v_to_yyyymmdd]  /* 현재시점의 월요일 부터 조회끝날짜 */
				-- AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req'' ELSE ''MKT_FCST'' END
				AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req'' 
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''MKT_FCST'' END   
	 			[@v_division_id]
				--	[@v_current] -- 20180801 add son young suk 검색조건 version 검색할때 current 빠지게 처리  -- 20180809 ytchoi
				[@v_scm_site_id]
				[@v_plant_site_id] 
				--[@v_item_id]
	 			[@v_project_code]	  
            UNION ALL		-- 20180809 ytchoi
			SELECT ''Current'' AS VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY
				, T2.cell_model		-- 20180809 ytchoi					 
            FROM [dbo].[DM_PLN_MKT_FCST_RESULT]   F WITH(NOLOCK)
			LEFT OUTER JOIN 	#Target_SITE_ITEM	T2  WITH(NOLOCK)
				ON	F.DIVISION_ID = T2.DIVISION_ID
				AND	F.project_code = T2.project_code
				AND	F.SCM_SITE_ID = T2.SCM_SITE_ID
				AND	F.ITEM_ID   = T2.ITEM_ID
            WHERE F.QTY <> 0
				and f.YYYYMMDD >= [@v_from_result] and f.YYYYMMDD < [@v_to_result]  -- 20180808 MODIFY
				AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req'' 
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''RTF'' END    
	 			[@v_division_id]
				--	[@v_current] -- 20180801 add son young suk 검색조건 version 검색할때 current 빠지게 처리		-- 20180809 ytchoi
				[@v_scm_site_id]
				[@v_plant_site_id] 
				--[@v_item_id]
	 			[@v_project_code]	  
            UNION ALL    -- 20180809 ytchoi
            SELECT F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY
				, T2.cell_model		-- 20180809 ytchoi					 
            FROM [dbo].[DM_PLN_MKT_FCST_RESULT_C]       F WITH(NOLOCK)
			LEFT OUTER JOIN 	#Target_SITE_ITEM	T2  WITH(NOLOCK)
				ON	F.DIVISION_ID = T2.DIVISION_ID
				AND	F.project_code = T2.project_code
				AND	F.SCM_SITE_ID = T2.SCM_SITE_ID
				AND	F.ITEM_ID   = T2.ITEM_ID
            WHERE F.QTY <> 0
				and f.YYYYMMDD >= [@v_from_result_f] and f.YYYYMMDD < [@v_to_result_f]  -- 20180808 MODIFY
				AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req'' 
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''RTF'' END    
	 			[@v_division_id]
				AND F.VERSION_NO IN (SELECT VERSION_NO FROM #Target_VERSION_NO)
				[@v_scm_site_id]
				[@v_plant_site_id] 
				--[@v_item_id]
	 			[@v_project_code]	  
            UNION ALL    -- 20180809 ytchoi
            SELECT F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
                , F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY
				, T2.cell_model		-- 20180809 ytchoi					 
            FROM [dbo].[DM_PLN_MKT_FCST_C]       F WITH(NOLOCK)
			LEFT OUTER JOIN 	#Target_SITE_ITEM	T2  WITH(NOLOCK)
				ON	F.DIVISION_ID = T2.DIVISION_ID
				AND	F.project_code = T2.project_code
				AND	F.SCM_SITE_ID = T2.SCM_SITE_ID
				AND	F.ITEM_ID   = T2.ITEM_ID    
			INNER JOIN SCM_MST_SITE C (NOLOCK) 
				ON F.DIVISION_ID = C.DIVISION_ID 
				AND F.SCM_SITE_ID = C.SCM_SITE_ID 
				AND C.VALID_YN = ''Y''   
            WHERE F.QTY <> 0
				and f.YYYYMMDD >= [@v_from_yyyymmdd_f] -- CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( CAST(F.CUTOFF_YYYYMMDD as datetime), ''MON'')), 112)  /* CUTOFF DATE의 월요일 */
				and f.YYYYMMDD <= [@v_to_yyyymmdd_f]
				AND MEASURE = CASE WHEN T2.VMI_YN = ''Y'' AND F.DIVISION_ID NOT LIKE ''81%''  THEN ''VMI_In_Req'' 
                    WHEN T2.AS_YN = ''Y'' THEN ''AS_IN_REQ''
                    ELSE ''MKT_FCST'' END    
	 			[@v_division_id]
				AND F.VERSION_NO IN (SELECT VERSION_NO FROM #Target_VERSION_NO)
				[@v_scm_site_id]
				[@v_plant_site_id] 
				--[@v_item_id]
	 			[@v_project_code]	  
				;

			IF ( '''+ @p_owner + ''' <> '''')
				BEGIN
					DELETE A
					FROM #ALL_QUERY_DATA_B A
					LEFT OUTER JOIN #Target_SITE_ITEM B ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split('''+ @p_owner + ''','','') 
									) C	ON B.OWNER LIKE ''%'' + C.TOKEN + ''%''
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split('''+ @p_owner + ''','','') 
									) D	ON B.OWNER_NAME LIKE ''%'' + D.TOKEN + ''%''
					LEFT OUTER JOIN (	SELECT DISTINCT token 
										FROM dbo.String_Split('''+ @p_owner + ''','','') 
									) E	ON B.OWNER_NAME_KO LIKE ''%'' + E.TOKEN + ''%''
					WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL  AND E.TOKEN IS NULL
				END;



		WITH ALL_QUERY_DATA AS (

			[@v_diff_only]  /* @p_diff_only = False 인경우만 쿼리실행 */

			SELECT '''' VERSION_NO , DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD, ''Difference'' MEASURE, SUM( CASE WHEN V.VERSION_TYPE = ''Version(A)'' THEN QTY ELSE -QTY END) QTY, cell_model
			  FROM #ALL_QUERY_DATA_B B
				INNER JOIN #Target_VERSION_NO V
					ON B.VERSION_NO = V.VERSION_NO
			 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD,cell_model
		 )
		SELECT * INTO #ALL_QUERY_DATA from 	ALL_QUERY_DATA
		;		
-- SELECT * FROM #ALL_QUERY_DATA	 WHERE SCM_SITE_ID IN (''BMW_DE_NBH'',''Ford AS_DE_QKL'',''VW_CZ_MBV'') AND VERSION_NO <> ''Current'';		
with MKT_FCST as (
select    
           a.VERSION_NO
	      , CASE WHEN A.MEASURE = ''Version(A)'' THEN ''1''
		         WHEN A.MEASURE = ''Version(B)'' THEN ''2''
		         ELSE ''Z''
		  	   END  AS VERSION_SORT
          ,a.DIVISION_ID
		  ,a.DIVISION_ID as DIVISION_ID40
		  , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_ID ELSE k.DEPT_ID END  AS DEPT_ID		-- 20180809
	   	  , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END DEPT_NAME_KO  -- 20180809
		  , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_ID ELSE k.DEPT_ID END  AS TEAM_ID		-- 20180809
	   	  , CASE WHEN A.DIVISION_ID = ''40'' THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END TEAM_NAME_KO  -- 20180809
		  , g.END_CUSTOMER
		  , a.PROJECT_CODE AS END_CUSTOMER40
		  , f.BIZ_TYPE     AS BIZ_TYPE
		  , g.SOLDTO_CUSTOMER
		  , i.COUNTRY	
		  , i.COUNTRY_NAME	  
		  , h.CITY
		  , h.CITY_NAME	  
		  , a.SCM_SITE_ID
		  , a.SCM_SITE_ID AS SCM_SITE_ID40
		  , a.PLANT_SITE_ID
          , a.PROJECT_CODE
		  , f.PROJECT_NAME
		  , [dbo].[FN_GET_MULTI_OWNER_NAME](e.OWNER, '','', ''1'') AS OWNER  -- 20180817
		  , CASE WHEN a.division_id <> ''40'' THEN f.PROJECT_OWNER ELSE j.USER_NAME_EN end AS PROJECT_OWNER -- 20180705
		  , J.USER_ID
		  --20180809 ytchoi modify(e)
		  , a.ITEM_ID  
		  , a.ITEM_ID  AS ITEM_ID40
		  , l.ITEM_NAME       
		  , l.NICK_NAME  AS  NICK_NAME 
		  , a.INCOTERMS
		  , l.ITEM_TYPE 
		  , a.FCST_TYPE 
          , a.DOM_EXP
          , f.PROJECT_STATUS 
		  , a.MEASURE
		  , c.BASIS_YYYYMM  AS YYYYMM
		  , CASE WHEN N'''+@p_bucket+N''' = ''ONLY_WEEKLY'' THEN c.BASIS_YYYYMMWW ELSE c.BASIS_YYYYMM + c.ISO_WEEK END AS YYYYMMWW
		  , C.BASIS_YYYYMMDD AS YYYYMMDD
		  , C.DAYOFWEEK
		  , case when m.BUCKET_PER = ''Y'' then ''Y'' when m.BUCKET_PER = ''N'' then ''N'' else null end AS PER  -- 20181101 khsong add
		  , d.QTY
		  , c.END_FLAG
		  , e.CUST_GROUP
		  , e.CUST_GROUP_DTL
		  , e.APPLICATION
		  , e.ROUTE
		  -- 20180711 추가
		  , l.MDM_PROJECT_NAME  
		  , l.MIN_CAPACITY
		  , l.FORECAST_INFO_BIZ_TYPE
	  	  , l.FORECAST_INFO_PRODUCT_GROUP
		  , a.FORECAST_INFO_CELL_MODEL  AS FORECAST_INFO_CELL_MODEL		-- 20180809 ytchoi		  
		  , LOOK.NAME AS CELL_TYPE --20180911 LookUp 테이블 조인으로 CELL_TYPE 명칭
		  , l.FORECAST_INFO_CELL_PACK_COUNT
		  , l.FORECAST_INFO_SPEC+l.FORECAST_INFOR_VERSION as FORECAST_INFO_SPEC
		  , g.VMI_YN  -- 20180719
		  , CASE WHEN 
				C.BASIS_YYYYMMDD = CONVERT( VARCHAR, DATEADD(DAY,-DATEPART(DD,DATEADD(MONTH, 1, CAST(C.BASIS_YYYYMMDD as datetime) )), DATEADD(MONTH, 1, CAST(C.BASIS_YYYYMMDD as datetime) )), 112) THEN ''Y'' 
			ELSE ''N'' END M_LAST_D_FLAG 
		  , CASE WHEN a.DIVISION_ID = ''40'' THEN
		       CASE WHEN 
				(( a.MEASURE in ( ''MKT_FCST_RP'',  ''RTF'' ,  ''CUST_FCST'' ,  ''VMI_IN_Req''   )) AND (([dbo].[FN_GET_DEPT_LIST](''[@p_created_by]'', k.DEPT_ID) = ''Y''))) --20180809 ytchoi modify
			 	OR ( ( a.MEASURE in ( ''MKT_FCST_RP'',  ''RTF'' ,  ''CUST_FCST'' ,  ''VMI_IN_Req''   )) AND (''[@v_group_id]'' =''ADMIN''))
			   THEN ''Y'' ELSE ''N'' END
			END  AS EDIT_FLAG
		  
		  , CASE WHEN a.DIVISION_ID = ''40'' AND g.VMI_YN = ''Y'' AND a.MEASURE = ''VMI_In_Req'' THEN ''Y''
		         WHEN a.DIVISION_ID = ''40'' AND g.VMI_YN = ''N'' AND a.MEASURE = ''MKT_FCST_RP'' THEN ''Y'' 
			ELSE ''N'' END SCP_USE_YN
		  , e.ATTRIBUTE7 AS PRIORITY  --201811116
		--[E20231017-000634] SCP정보수집		
		, SCP.CELL_NICKNAME AS CELL_NICKNAME  --20231025
		, CASE WHEN SUBSTRING(A.DIVISION_ID, 1,2) = ''81'' OR A.DIVISION_ID = ''82'' THEN SCP.GROUP_CODE6
		  ELSE SCP.CELL_TYPE_GROUP_NAME END AS PRODUCT_LEVEL1
		, CASE WHEN SUBSTRING(A.DIVISION_ID, 1,2) = ''81'' OR A.DIVISION_ID = ''82'' THEN SCP.GROUP_CODE7
		  ELSE SCP.BASIC_NICKNAME_CELL40 END AS PRODUCT_LEVEL2
		, CASE WHEN SUBSTRING(A.DIVISION_ID, 1,2) = ''81'' THEN SCP.GROUP_CODE5
			   WHEN A.DIVISION_ID = ''82''				   THEN SCP.GROUP_CODE4
		  ELSE SCP.NICKNAME_40 END AS PRODUCT_LEVEL3		  
  from (
		select distinct  F.VERSION_NO, F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE
							 , F.INCOTERMS, F.MEASURE
						     , CELL_MODEL	 AS FORECAST_INFO_CELL_MODEL		-- 20180809 ytchoi							 
		  from #ALL_QUERY_DATA F
		  [@sp_project_code_join]
        where 1=1		-- 20180809 ytchoi
		 --[@v_version_no_q]		-- 20181207 
       ) a
 INNER JOIN  #CALENDAR c WITH(NOLOCK)
		ON 1 = 1
 LEFT JOIN #ALL_QUERY_DATA d
	   ON  a.DIVISION_ID    = d.DIVISION_ID
	   AND a.PROJECT_CODE   = d.PROJECT_CODE
	   and a.SCM_SITE_ID    = d.SCM_SITE_ID
	   and a.PLANT_SITE_ID  = d.PLANT_SITE_ID
	   and a.ITEM_ID        = d.ITEM_ID
	   and a.DOM_EXP        = d.DOM_EXP
	   and a.FCST_TYPE      = d.FCST_TYPE
	   and a.INCOTERMS      = d.INCOTERMS
	   and a.MEASURE        = d.MEASURE
	   and c.BASIS_YYYYMMDD = d.YYYYMMDD
	   and a.VERSION_NO     = d.VERSION_NO
 INNER JOIN [dbo].SCM_MST_SITE_ITEM e WITH(NOLOCK)
	   ON  a.DIVISION_ID    = e.DIVISION_ID
	   and a.SCM_SITE_ID    = e.SCM_SITE_ID
	   and a.PROJECT_CODE   = e.PROJECT_CODE
	   and a.ITEM_ID        = e.ITEM_ID
 LEFT JOIN [dbo].SCM_MST_PROJECT f WITH(NOLOCK)
	   ON  a.DIVISION_ID    = f.DIVISION_ID
	   and a.PROJECT_CODE   = f.PROJECT_CODE
 LEFT OUTER JOIN [dbo].SCM_MST_SITE g WITH(NOLOCK)
	   ON  a.DIVISION_ID    = g.DIVISION_ID
	   and a.SCM_SITE_ID    = g.SCM_SITE_ID
 LEFT OUTER JOIN [dbo].SCM_MST_CITY h WITH(NOLOCK)
	   ON  g.CITY           = h.CITY
 LEFT OUTER JOIN [dbo].[SCM_MST_COUNTRY] i WITH(NOLOCK)
	   ON  g.COUNTRY        = i.COUNTRY
 --[E20231017-000634]
 LEFT OUTER JOIN #SCP_ITEM_INFO SCP WITH (NOLOCK) ON SCP.DIVISION_ID = A.DIVISION_ID AND SCP.ITEM_ID = A.ITEM_ID
 -- 20180809 추가  -----------------
 LEFT JOIN (
	SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
	FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
	INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
	ON B.DEPT_ID = C.DEPT_ID
 ) AS TEAM
 ON              TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](e.owner, '',''))
 -- 20180809 추가  -----------------

 LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] j WITH(NOLOCK)
	   --20180724 ON  CASE WHEN a.DIVISION_ID <> ''40'' THEN F.PROJECT_OWNER ELSE e.OWNER END  = j.USER_ID
	   ON  e.OWNER			= j.USER_ID -- 20180724 add son young suk
 LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] k WITH(NOLOCK)
	   ON  CASE WHEN a.DIVISION_ID = ''40'' THEN j.DEPT_ID ELSE g.DEPT_ID END  = k.DEPT_ID
 INNER JOIN #TEMP_SKH_DM_MST_ITEM_SINGLE_V l WITH(NOLOCK)
	   ON  a.DIVISION_ID    = l.DIVISION_ID
	   and a.ITEM_ID        = l.ITEM_ID
 LEFT JOIN DM_MST_BUCKET_CONVERSION m WITH(NOLOCK)
	   ON a.DIVISION_ID     = m.DIVISION_ID
	   and a.SCM_SITE_ID    = m.SCM_SITE_ID
	   and a.INCOTERMS      = m.INCOTERMS
	   and c.DAYOFWEEK      = m.YYYYMMDD
 LEFT JOIN ( --** 20180911  Son Young Suk  조회 컬럼 CELL_TYPE 추가 DM_MST_ITEM_SINGLE_V.CELL_TYPE 사용 LookUp 테이블로 명칭 조회 LookUp 테이블 조인
			SELECT SEGMENT1  AS CODE       
					, SEGMENT2  AS NAME
			FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
			WHERE LOOKUP_TYPE = ''CELL_TYPE'' 
			) LOOK
		ON LOOK.CODE = l.CELL_TYPE

WHERE 1=1
AND d.qty is not null -- [20240312] 조건 추가함.
[@v_team_id]
[@v_item_type]

)


	--SELECT * 
	--FROM (
	--		SELECT  COLUMN_NAME, sort_order_no AS SORT_ORDER_NO_
	--		FROM   [dbo].[SCM_MST_SHEET_MEASURE] U  WITH(NOLOCK,INDEX (PK_SCM_MST_SHEET_MEASURE))
	--		WHERE  1 = 1			
	--		AND    U.PROGRAM_ID						= ''DMF0040''
	--		AND    U.SHEET_NAME						= ''Mkt Fcst Waterfall''
	--) TEMP1
	--LEFT OUTER JOIN 
	--(   
		/* 기존SQL */
		SELECT [@v_column]
			 , F.VERSION_SORT AS SORT_ORDER_NO
			   [@v_iteration]     
		FROM   MKT_FCST F 
		WHERE  1 = 1	
		-- add 181102 속도개선을 의해서 추가 
		-- [20240312] 주석처리함. AND    ( F.PER IS NOT NULL OR F.QTY IS NOT NULL )
		[@v_customer]
		[@v_biz_type]
		[@v_groupby]
    --) T ON TEMP1.COLUMN_NAME = T.MEASURE
	--WHERE 1=1
	--[E20240201-001467]
	[@v_orderby]
  '; 


  	--[E20240201-001467] 20240216------------------------------------------------------
	DECLARE @ORDER NVARCHAR(MAX)=''
	SELECT  @ORDER = @ORDER + COLUMN_NAME + ' ' + DATA_SORT_METHOD_CODE + ','
	FROM   [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
	WHERE  1 = 1
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'C'
	AND    U.PROGRAM_ID						= 'DMF0040'
	AND    U.SHEET_NAME						= 'Mkt Fcst Waterfall'
	AND    U.USER_ID						= @p_created_by
	ORDER BY SORT_ORDER_NO

	--SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'        , @v_orderby        );

	SET @ORDER		= ' ORDER BY ' + LEFT(@ORDER, LEN(@ORDER)-1) + ' , SORT_ORDER_NO ASC ';
	set @ORDER		= REPLACE(replace(@ORDER, ',VERSION_NO' ,''),',MEASURE','') ;
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'        , @ORDER        );
	
	print @ORDER;
	--end-----------------------------------------------------------------------------

  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]'      , @v_iteration    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_division_id]'    , [dbo].[FN_SCM_GET_WHERE_SQL]('F.DIVISION_ID'  , 'IN', @p_division_id));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_scm_site_id]'    , [dbo].[FN_SCM_GET_WHERE_SQL]('F.SCM_SITE_ID'  , 'IN', @p_scm_site_id)); 
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_plant_site_id]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('F.PLANT_SITE_ID', 'IN', @p_plant_site_id)); 
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_team_id]'      , [dbo].[FN_SCM_GET_WHERE_SQL]('K.DEPT_ID', 'IN', @p_team_id)); --20180809 ytchoi modify

  -- 20190911 KHSONG ITEM_ID 조회속도개선 로직추가
	SET @v_sql_text = REPLACE(@v_sql_text,'[@sp_item_id]'   ,    '
		INNER JOIN ( SELECT * FROM #ITEM_INPUT) ITEM_INPUT
		ON F.ITEM_ID = ITEM_INPUT.ITEM_ID
	');
  							  

	-- 20190911 KHSONG PROJECT 조회속도개선

	SET @v_sql_text = REPLACE(@v_sql_text,'[@sp_project_code]'   ,    '
		INNER JOIN ( SELECT * FROM #PROJECT_INPUT) PROJECT_INPUT
		ON F.PROJECT_CODE = PROJECT_INPUT.PROJECT_CODE
	');

	IF @p_project_code <> '' 
		BEGIN
			SET @v_sql_text = REPLACE(@v_sql_text,'[@sp_project_code_join]'   ,    '
					INNER JOIN ( SELECT * FROM #PROJECT_INPUT) PROJECT_INPUT
					ON F.PROJECT_CODE = PROJECT_INPUT.PROJECT_CODE
				');
		END
	ELSE
		BEGIN
			SET @v_sql_text = REPLACE(@v_sql_text,'[@sp_project_code_join]'   ,    '');
		END

  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_item_type]'      , [dbo].[FN_SCM_GET_WHERE_SQL]('L.ITEM_TYPE'    , 'IN', @p_item_type  ));


--
  IF @p_division_id <> '40'
		BEGIN
			SET @v_sql_text = REPLACE(@v_sql_text,'[@v_customer]'     , [dbo].[FN_SCM_GET_WHERE_SQL]('F.END_CUSTOMER', 'IN', @p_customer)) --20180830 오류수정 잘못된 식별자 G.END_CUSTOMER
			SET @v_sql_text = REPLACE(@v_sql_text,'[@v_project_code]' , '') --20180731, [dbo].[FN_SCM_GET_WHERE_SQL]('F.PROJECT_CODE', 'LK', @p_project_code))
		END
  ELSE
		BEGIN
			SET @v_sql_text = REPLACE(@v_sql_text,'[@v_customer]'     , [dbo].[FN_SCM_GET_WHERE_SQL]('F.END_CUSTOMER', 'IN', ''));  --20180830 오류수정 잘못된 식별자 G.END_CUSTOMER
			SET @v_sql_text = REPLACE(@v_sql_text,'[@v_project_code]' , [dbo].[FN_SCM_GET_WHERE_SQL]('F.PROJECT_CODE', 'LK', @p_customer)); 
		END
--

  IF @p_division_id <> '40'
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_biz_type]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('F.BIZ_TYPE'     , 'IN', @p_biz_type));
  ELSE 
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_biz_type]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('FORECAST_INFO_BIZ_TYPE'     , 'IN', @p_biz_type));


	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_from_yyyymmdd]'  , @v_from_yyyymmdd  );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_to_yyyymmdd]'    , @v_to_yyyymmdd    );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_column]'         , @v_column         );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_groupby]'        , @v_groupby        );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]'     , @p_created_by     );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_group_id]'       , @v_group_id      );

	SET @v_sql_text = REPLACE(@v_sql_text,'[@p_version_no]'     , @p_version_no); 

----->


  /* @p_diff_only = False 인경우만 쿼리실행 */
  IF @p_diff_only = 'False'
		  BEGIN
			  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_diff_only]'      , 
													' SELECT A.VERSION_NO, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD, v.VERSION_TYPE measure , QTY, cell_model
															FROM #ALL_QUERY_DATA_B A
															INNER JOIN #Target_VERSION_NO V
																ON A.VERSION_NO = V.VERSION_NO
														union all
													');
		  END
	  ELSE
		  BEGIN
			  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_diff_only]'      , '')
		  END
 
	  ;

  -- 0703 skh added
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_from_yyyymmdd]', @p_from_yyyymmdd);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_to_yyyymmdd]', @p_to_yyyymmdd );
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_week_monday]', @v_week_monday);

  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_from_yyyymmdd]'  , @v_from_yyyymmdd  );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_to_yyyymmdd]'    , @v_to_yyyymmdd    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_from_yyyymmdd_f]', @v_from_yyyymmdd_f);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_to_yyyymmdd_f]'  , @v_to_yyyymmdd_f  );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_from_result]'    , @v_from_result    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_to_result]'      , @v_to_result      );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_from_result_f]'  , @v_from_result_f  );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_to_result_f]'    , @v_to_result_f    );

  --------------------------------------------------------------------------------------------------------------------------------*****
  
  --SET @p_debug = @v_iteration;
  --RETURN @p_debug;
  --SELECT @v_sql_text;


EXEC SP_EXECUTESQL @v_sql_text; 
								  
-- xml확인할경우
--SELECT CONVERT(TEXT, @v_sql_text)
--FOR XML PATH('')--,ROOT('x')  

	IF OBJECT_ID (N'tempdb..#ALL_QUERY_DATA', N'U') IS NOT NULL 
		DROP TABLE #ALL_QUERY_DATA

END
