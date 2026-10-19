
/*
 * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG
 * Description  : Shipment Plan 조회

  EXEC SCP0009_GET_SHIPMENT_PLAN_FG
 @p_from_yyyymmdd='20230403'
 , @p_to_yyyymmdd='20240331'
 , @p_division_id='81'
 , @p_biz_type='A'
 , @p_project_code=''
 , @p_item_id=''
 , @p_electype=''
 , @p_plan_start_yyyymmdd='20230410'
 , @p_plan_type='BP'
 , @p_seq='1'
 , @p_fromsite=''
 , @p_team_id=''
 , @p_tosite=''
 , @p_bucket='WEEKLY'
 , @p_to_period='20240331'
 , @p_chk_all='N'
 , @p_program_id='SCP0009'
 , @p_sheet_name='Shipment Plan FG'
 , @p_user_id='vadabi3'
 , @debug_mode='F'
 */

CREATE PROCEDURE [dbo].[SCP0009_GET_SHIPMENT_PLAN_FG_NEW]
	@p_from_yyyymmdd		NVARCHAR(8),
	@p_to_yyyymmdd			NVARCHAR(8),
	@p_division_id			NVARCHAR(30),
	@p_biz_type				NVARCHAR(30),
	@p_project_code			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_electype				NVARCHAR(30) ,
	@p_plan_start_yyyymmdd  NVARCHAR(8),
	@p_plan_type			NVARCHAR(10),
	@p_seq					NVARCHAR(10),
	@p_fromsite				NVARCHAR(MAX),
	@p_team_id              NVARCHAR(MAX),
	@p_tosite				NVARCHAR(MAX),
	@p_bucket				NVARCHAR(10),	-- 2021.10.05 : UI 속도 개선 (bucket 별 컬럼 설정 변경하여 조회되도록 수정 함)
	@p_to_period			NVARCHAR(8),	-- 2021.10.05 : UI 속도 개선 (bucket 별 컬럼 설정 변경하여 조회되도록 수정 함)
	@p_chk_all				NVARCHAR(1), -- 2021.11.24 :  체크 시 bucket='daily' 조회
	@p_program_id			NVARCHAR(10) = 'SCP0009' ,
	@p_sheet_name			NVARCHAR(30) = 'Shipment Plan FG' ,
	@p_user_id				NVARCHAR(30),
	@debug_mode             NVARCHAR(1) ='F'

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	declare @v_data_cnt nvarchar(8);
	set @v_data_cnt =0;

	DECLARE @v_cnt_usr_measure	INTEGER =0;
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8);
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8);
	DECLARE @v_from_result       AS NVARCHAR(8);
	DECLARE @v_to_result         AS NVARCHAR(8);
	DECLARE @v_min_yyyymmdd      AS NVARCHAR(8);   -- 2021/07/21
	DECLARE @v_RSLT_FLAG AS NVARCHAR(1) = 'Y';   -- 2021/07/21
	DECLARE @DIV_ENERGY  AS NVARCHAR(MAX) = '82';

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*)
								FROM scm_mst_titleset_user
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  )

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

		  SET @v_RSLT_FLAG = 'N';  -- 2021/07/21 // 계획만 조회

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

    DECLARE @arr_project_code varchar(max) , @arr_item_id varchar(max) , @arr_electrode_type varchar(max) , @arr_fromsite varchar(max), @arr_tosite varchar(max)
	SELECT @arr_project_code = ISNULL(@arr_project_code + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_project_code,',')
	SELECT @arr_item_id     = ISNULL(@arr_item_id + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_item_id,',')
	SELECT @arr_electrode_type   = ISNULL(@arr_electrode_type + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_electype,',')
	SELECT @arr_fromsite     = ISNULL(@arr_fromsite + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_fromsite,',')
	SELECT @arr_tosite     = ISNULL(@arr_tosite + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_tosite,',')

	DECLARE @mEXEC NVARCHAR(MAX);

	-- 2021.11.24 : 체크 시 bucket='daily' 조회
	IF(@p_chk_all = 'Y')	SET @p_bucket = 'DAILY' ;

	/********************************************************************************
	* 임시테이블만들기 - Header 부분
	********************************************************************************/

	-- ##############################################################################
	-- MEASURE 정보 생성
	-- ##############################################################################
	IF OBJECT_ID('tempdb..#TMP_SCP0009_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0009_MEASURE

	SELECT M.COLUMN_NAME
		 , M.COLUMN_LABEL_NAME
		 , ISNULL(T.SORT_ORDER_NO, M.SORT_ORDER_NO ) MEASURE_ORDER_NO
	  INTO #TMP_SCP0009_MEASURE
	  FROM SCM_MST_SHEET_MEASURE M
      LEFT JOIN ( SELECT *
				    FROM SCM_MST_TITLESET_USER
				   WHERE PROGRAM_ID = @p_program_id
					 AND SHEET_NAME	= @p_sheet_name
					 AND USER_ID	= @p_user_id
				) T
		ON M.PROGRAM_ID		= T.PROGRAM_ID
	   AND M.SHEET_NAME		= T.SHEET_NAME
	   AND M.COLUMN_NAME	= T.COLUMN_NAME

	 WHERE M.PROGRAM_ID = @p_program_id
	   AND M.SHEET_NAME = @p_sheet_name
	   AND M.VALID_YN	= 'Y'
	   AND (@v_cnt_usr_measure  = 0 OR T.column_name IS NOT NULL)

	   PRINT '1. Make Measure Info End. '+CONVERT(CHAR(23), GETDATE(), 21);


	-- ##############################################################################
	-- 기준 정보 생성
	-- 0 값 포함 조회 한다.
	-- ##############################################################################
	IF OBJECT_ID('tempdb..#TMP_SCP0009_STD') IS NOT NULL
		DROP TABLE #TMP_SCP0009_STD

	CREATE TABLE #TMP_SCP0009_STD (
		 DIVISION_ID				NVARCHAR(128)
		,BIZ_TYPE					NVARCHAR(128)
		,PROJECT_CODE				NVARCHAR(128)
		,ITEM_ID					NVARCHAR(128)
		,TO_SITE					NVARCHAR(128)
		,FROM_SITE					NVARCHAR(128)
		,INCOTERMS					NVARCHAR(128)
		,BOD_ID						NVARCHAR(128)
		,MEASURE					NVARCHAR(128)
		,MEASURE_LABEL				NVARCHAR(128)
		,MEASURE_ORDER_NO			NVARCHAR(128)
		,TRANSPORT_MODE				NVARCHAR(128)
		,LT_DAY						NVARCHAR(128)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(30)
		,ORIGIN_TO_DIVISION_ID		NVARCHAR(30)
		,ELECTRODE_TYPE				NVARCHAR(30)
		,PLAN_START_YYYYMMDD		NVARCHAR(128)
		,PLAN_TYPE					NVARCHAR(128)
		,SEQ						NVARCHAR(128)
	)

	-- 2023.01.02
	--SELECT @v_min_yyyymmdd = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](@p_program_id, @p_division_id, @p_plan_type, @p_biz_type, @p_seq);
	SELECT @v_min_yyyymmdd = replace(convert(char(10),dateadd(d,datepart(dw,GETDATE()) * -1 - 5,GETDATE()),120),'-',''); -- previous monday

	-- Dynamic Query 로 변경해 보았으나 속도 문제로 IF/ELSE 로 분기
	IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_STD
		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.BIZ_TYPE
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , A.FROM_SITE
			 , A.INCOTERMS
			 , A.BOD_ID
			 , A.MEASURE
			 , B.COLUMN_LABEL_NAME				AS MEASURE_LABEL
			 , B.MEASURE_ORDER_NO				AS MEASURE_ORDER_NO
			 , C.TRANSPORT_MODE
			 , C.LT_TOTAL AS LT_DAY
			 , ISNULL(NULLIF(A.ORIGIN_FROM_DIVISION_ID,''),'-')		AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID,''),'-')		AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')				AS ELECTRODE_TYPE
			 , @p_plan_start_yyyymmdd			AS PLAN_START_YYYYMMDD
			 , @p_plan_type						AS PLAN_TYPE
			 , @p_seq							AS SEQ

		  FROM ( SELECT DISTINCT
						A.DIVISION_ID
					  , A.BIZ_TYPE
					  , A.PROJECT_CODE
					  , A.ITEM_ID
					  , A.TO_SITE
					  , A.FROM_SITE
					  , A.INCOTERMS
					  , A.BOD_ID
					  , A.MEASURE
					  , A.ORIGIN_FROM_DIVISION_ID
					  , A.ORIGIN_TO_DIVISION_ID
					 , A.ELECTRODE_TYPE
				   FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
				  WHERE 1=1
					-- BOD 2단계 개발 : FROM , TO 로 변경
					--AND A.YYYYMMDD				= @p_plan_start_yyyymmdd
					AND A.YYYYMMDD				>= @v_from_yyyymmdd
					AND A.YYYYMMDD				<= @v_to_yyyymmdd
					AND A.DIVISION_ID			= @p_division_id
					AND A.BIZ_TYPE				= @p_biz_type
					AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
					AND A.PLAN_TYPE				= @p_plan_type
					AND A.SEQ					= @p_seq
					AND (( @p_project_code	IS NULL OR @p_project_code	='') OR A.PROJECT_CODE		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_project_code	, ',')))
				   --AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id		, ',')))
				   --AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID			LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))
				   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID			IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))
				   AND (( @p_fromsite		IS NULL OR @p_fromsite		='') OR A.FROM_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_fromsite		, ',')))
				   AND (( @p_tosite			IS NULL OR @p_tosite		='') OR A.TO_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_tosite		, ',')))
				   AND (( @p_electype		IS NULL OR @p_electype		='') OR A.ELECTRODE_TYPE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_electype		, ',')))
				) A
		 INNER JOIN #TMP_SCP0009_MEASURE B
			ON A.MEASURE = B.COLUMN_NAME

		-- BOD 2단계 개발 : VIEW 수정
/*		LEFT JOIN SCP_MST_BOD_N_V C
			  ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END )= C.DIVISION_ID
			  AND  A.BOD_ID = C.BOD_ID
			  AND A.FROM_SITE = C.FROM_SITE*/
		LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			   ON A.DIVISION_ID = C.DIVISION_ID
			  AND A.BOD_ID     = C.BOD_ID
			  AND A.FROM_SITE  = C.FROM_SITE
			  AND C.PLAN_SEQ   = @p_seq
			  AND C.PLAN_TYPE  = @p_plan_type
			  AND C.PLAN_NAME  = @p_plan_start_yyyymmdd
		;
	END
	ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_STD
		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.BIZ_TYPE
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , A.FROM_SITE
			 , A.INCOTERMS
			 , A.BOD_ID
			 , A.MEASURE
			 , B.COLUMN_LABEL_NAME				AS MEASURE_LABEL
			 , B.MEASURE_ORDER_NO				AS MEASURE_ORDER_NO
			 , C.TRANSPORT_MODE
			 , C.LT_TOTAL AS LT_DAY
			 , ISNULL(NULLIF(A.ORIGIN_FROM_DIVISION_ID,''),'-')		AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID,''),'-')		AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')				AS ELECTRODE_TYPE
			 , @p_plan_start_yyyymmdd			AS PLAN_START_YYYYMMDD
			 , @p_plan_type						AS PLAN_TYPE
			 , @p_seq							AS SEQ

		  FROM ( SELECT DISTINCT
						A.DIVISION_ID
					  , A.BIZ_TYPE
					  , A.PROJECT_CODE
					  , A.ITEM_ID
					  , A.TO_SITE
					  , A.FROM_SITE
					  , A.INCOTERMS
					  , A.BOD_ID
					  , A.MEASURE
					  , A.ORIGIN_FROM_DIVISION_ID
					  , A.ORIGIN_TO_DIVISION_ID
					  , A.ELECTRODE_TYPE
				   FROM HIST_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
				  WHERE 1=1
					AND A.YYYYMMDD				= @p_plan_start_yyyymmdd
					AND A.DIVISION_ID			= @p_division_id
					AND A.BIZ_TYPE				= @p_biz_type
					AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
					AND A.PLAN_TYPE				= @p_plan_type
					AND A.SEQ					= @p_seq
					AND (( @p_project_code	IS NULL OR @p_project_code	='') OR A.PROJECT_CODE		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_project_code	, ',')))
				   --AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID			LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))
				   AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID			IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))
				   AND (( @p_fromsite		IS NULL OR @p_fromsite		='') OR A.FROM_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_fromsite		, ',')))
				   AND (( @p_tosite			IS NULL OR @p_tosite		='') OR A.TO_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_tosite		, ',')))
				   AND (( @p_electype		IS NULL OR @p_electype		='') OR A.ELECTRODE_TYPE	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_electype		, ',')))
				) A
		 INNER JOIN #TMP_SCP0009_MEASURE B
			ON A.MEASURE = B.COLUMN_NAME

		-- BOD 2단계 개발 : VIEW 수정
/*		LEFT JOIN SCP_MST_BOD_N_V C
			  ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END )= C.DIVISION_ID
			  AND  A.BOD_ID = C.BOD_ID
			  AND A.FROM_SITE = C.FROM_SITE*/
		LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			   ON  A.DIVISION_ID = C.DIVISION_ID
			  AND A.BOD_ID    = C.BOD_ID
			  AND A.FROM_SITE = C.FROM_SITE
		      AND C.PLAN_SEQ  = @p_seq
		      AND C.PLAN_TYPE = @p_plan_type
		      AND C.PLAN_NAME = @p_plan_start_yyyymmdd
		;
	END



	PRINT '2. Make Std Info End. '+CONVERT(CHAR(23), GETDATE(), 21);

-- ##############################################################################
-- 기준 정보를 기준으로 계획 구간 정보 조회
-- 0 값 포함하지 않는다.
-- ##############################################################################

	IF OBJECT_ID('tempdb..#TMP_SCP0009_FG_VALUE') IS NOT NULL
		DROP TABLE #TMP_SCP0009_FG_VALUE

	CREATE TABLE #TMP_SCP0009_FG_VALUE (
		 YYYYMMDD					NVARCHAR(8)
		,DIVISION_ID				NVARCHAR(128)
		,BIZ_TYPE					NVARCHAR(128)
		,PROJECT_CODE				NVARCHAR(128)
		,ITEM_ID					NVARCHAR(128)
		,TO_SITE					NVARCHAR(128)
		,FROM_SITE					NVARCHAR(128)
		,INCOTERMS					NVARCHAR(128)
		,BOD_ID						NVARCHAR(128)
		,MEASURE					NVARCHAR(128)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(30)
		,ORIGIN_TO_DIVISION_ID		NVARCHAR(30)
		,ELECTRODE_TYPE				NVARCHAR(30)
		,TRANSPORT_MODE				NVARCHAR(128)
		,ITEM_VALUE					NUMERIC(20,10)
	)

	IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_FG_VALUE
		SELECT F.YYYYMMDD
			 , X.DIVISION_ID
			 , X.BIZ_TYPE
			 , X.PROJECT_CODE
			 , X.ITEM_ID
			 , X.TO_SITE
			 , X.FROM_SITE
			 , X.INCOTERMS
			 , X.BOD_ID
			 , X.MEASURE
			 , ISNULL(NULLIF(F.ORIGIN_FROM_DIVISION_ID,''),'-') AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(F.ORIGIN_TO_DIVISION_ID,''),'-')	AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(F.ELECTRODE_TYPE,''),'-')			AS ELECTRODE_TYPE
			 , X.TRANSPORT_MODE
			 , F.QTY AS ITEM_VALUE

		  FROM #TMP_SCP0009_STD X

		  --JOIN SCP_ANL_SHIPMENT_PLAN_FG F WITH(NOLOCK INDEX(PK_SCP_ANL_SHIPMENT_PLAN_FG))
		  INNER MERGE JOIN SCP_ANL_SHIPMENT_PLAN_FG F WITH(NOLOCK)

		     -- BOD 2단계 개발 : VIEW 수정
/*		  LEFT JOIN SCP_MST_BOD_N_V C
			ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN F.ORIGIN_FROM_DIVISION_ID ELSE F.DIVISION_ID END )= C.DIVISION_ID
		   AND F.BOD_ID		= C.BOD_ID
		   AND F.FROM_SITE	= C.FROM_SITE*/
		  LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			ON F.DIVISION_ID = C.DIVISION_ID
		   AND F.BOD_ID		 = C.BOD_ID
		   AND F.FROM_SITE	 = C.FROM_SITE
		   AND C.PLAN_SEQ    = @p_seq
		   AND C.PLAN_TYPE   = @p_plan_type
		   AND C.PLAN_NAME   = @p_plan_start_yyyymmdd

			ON X.DIVISION_ID			= F.DIVISION_ID
		   AND X.PLAN_START_YYYYMMDD	= F.PLAN_START_YYYYMMDD
		   AND X.PLAN_TYPE				= F.PLAN_TYPE
		   AND X.SEQ					= F.SEQ
		   AND X.BIZ_TYPE				= F.BIZ_TYPE
		   AND X.ITEM_ID				= F.ITEM_ID
		   AND X.PROJECT_CODE			= F.PROJECT_CODE
		   AND X.TO_SITE				= F.TO_SITE
		   AND X.INCOTERMS				= F.INCOTERMS
		   AND X.FROM_SITE				= F.FROM_SITE
		   AND X.BOD_ID					= F.BOD_ID
		   AND X.MEASURE				= F.MEASURE
		   AND ISNULL(X.TRANSPORT_MODE,'-') = ISNULL(C.TRANSPORT_MODE,'-')

		 WHERE F.YYYYMMDD				>= @p_from_yyyymmdd
		   AND F.YYYYMMDD				<= @p_to_yyyymmdd
		   AND F.DIVISION_ID			= @p_division_id
		   AND F.BIZ_TYPE				= @p_biz_type
		   AND F.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
		   AND F.PLAN_TYPE				= @p_plan_type
		   AND F.SEQ					= @p_seq
		   AND F.QTY					<> 0
		;
	END
	ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_FG_VALUE
		SELECT F.YYYYMMDD
			 , X.DIVISION_ID
			 , X.BIZ_TYPE
			 , X.PROJECT_CODE
			 , X.ITEM_ID
			 , X.TO_SITE
			 , X.FROM_SITE
			 , X.INCOTERMS
			 , X.BOD_ID
			 , X.MEASURE
			 , ISNULL(NULLIF(F.ORIGIN_FROM_DIVISION_ID,''),'-') AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(F.ORIGIN_TO_DIVISION_ID,''),'-')	AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(F.ELECTRODE_TYPE,''),'-')			AS ELECTRODE_TYPE
			 , X.TRANSPORT_MODE
			 , F.QTY AS ITEM_VALUE

		  FROM #TMP_SCP0009_STD X

		  JOIN HIST_SCP_ANL_SHIPMENT_PLAN_FG F WITH(NOLOCK)

		  -- BOD 2단계 개발 : VIEW 수정
/*		  LEFT JOIN SCP_MST_BOD_N_V C
			ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN F.ORIGIN_FROM_DIVISION_ID ELSE F.DIVISION_ID END )= C.DIVISION_ID
		   AND F.BOD_ID		= C.BOD_ID
		   AND F.FROM_SITE	= C.FROM_SITE*/
		  LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			ON F.DIVISION_ID = C.DIVISION_ID
		   AND F.BOD_ID		= C.BOD_ID
		   AND F.FROM_SITE	= C.FROM_SITE
		   AND C.PLAN_SEQ   = @p_seq
		   AND C.PLAN_TYPE  = @p_plan_type
		   AND C.PLAN_NAME  = @p_plan_start_yyyymmdd

			ON X.DIVISION_ID			= F.DIVISION_ID
		   AND X.PLAN_START_YYYYMMDD	= F.PLAN_START_YYYYMMDD
		   AND X.PLAN_TYPE				= F.PLAN_TYPE
		   AND X.SEQ					= F.SEQ
		   AND X.BIZ_TYPE				= F.BIZ_TYPE
		   AND X.ITEM_ID				= F.ITEM_ID
		   AND X.PROJECT_CODE			= F.PROJECT_CODE
		   AND X.TO_SITE				= F.TO_SITE
		   AND X.INCOTERMS				= F.INCOTERMS
		   AND X.FROM_SITE				= F.FROM_SITE
		   AND X.BOD_ID					= F.BOD_ID
		   AND X.MEASURE				= F.MEASURE
		   AND ISNULL(X.TRANSPORT_MODE,'-') = ISNULL(C.TRANSPORT_MODE,'-')

		 WHERE F.YYYYMMDD				>= @p_from_yyyymmdd
		   AND F.YYYYMMDD				<= @p_to_yyyymmdd
		   AND F.DIVISION_ID			= @p_division_id
		   AND F.BIZ_TYPE				= @p_biz_type
		   AND F.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
		   AND F.PLAN_TYPE				= @p_plan_type
		   AND F.SEQ					= @p_seq
		   AND F.QTY					<> 0
		;

	END



	PRINT '3. Make Plan_1 End. '+CONVERT(CHAR(23), GETDATE(), 21);

	-- ##############################################################################
	-- 0값 데이터로 누락된 MEASURE 를 생성한다.
	-- ##############################################################################
	IF OBJECT_ID('tempdb..#TMP_SCP0009_ADD_MEASURE') IS NOT NULL
			DROP TABLE #TMP_SCP0009_ADD_MEASURE ;

	SELECT ISNULL(X.YYYYMMDD,@v_from_yyyymmdd) AS YYYYMMDD
		, T.DIVISION_ID
		, T.BIZ_TYPE
		, T.PROJECT_CODE
		, T.ITEM_ID
		, T.FROM_SITE
		, T.TO_SITE
		, T.INCOTERMS
		, T.MEASURE
		, T.ORIGIN_FROM_DIVISION_ID
		, T.ORIGIN_TO_DIVISION_ID
		, T.ELECTRODE_TYPE
		, T.BOD_ID
		, T.LT_DAY
		, T.TRANSPORT_MODE
		, T.MEASURE_LABEL
		, T.MEASURE_ORDER_NO
		, ISNULL(X.ITEM_VALUE,0) AS ITEM_VALUE
	 INTO #TMP_SCP0009_ADD_MEASURE
	 FROM (
			SELECT A.DIVISION_ID
				 , A.BIZ_TYPE
				 , A.PROJECT_CODE
				 , A.ITEM_ID
				 , A.TO_SITE
				 , A.FROM_SITE
				 , A.INCOTERMS
				 , A.BOD_ID
				 , M.COLUMN_NAME AS MEASURE
				 , A.ORIGIN_FROM_DIVISION_ID
				 , A.ORIGIN_TO_DIVISION_ID
				 , A.ELECTRODE_TYPE
				 , A.TRANSPORT_MODE
				 , A.LT_DAY
				 , A.MEASURE_LABEL
				 , A.MEASURE_ORDER_NO
			  FROM #TMP_SCP0009_STD A
			   LEFT JOIN ( SELECT COLUMN_NAME
							 FROM #TMP_SCP0009_MEASURE
						) M
				ON M.COLUMN_NAME = A.MEASURE
			) T
	 LEFT JOIN #TMP_SCP0009_FG_VALUE X
	   ON T.DIVISION_ID		= X.DIVISION_ID
	  AND T.PROJECT_CODE	= X.PROJECT_CODE
	  AND T.ITEM_ID			= X.ITEM_ID
	  AND T.FROM_SITE		= X.FROM_SITE
	  AND T.TO_SITE			= X.TO_SITE
	  AND T.MEASURE			= X.MEASURE
	  AND T.ORIGIN_FROM_DIVISION_ID		= X.ORIGIN_FROM_DIVISION_ID
	  AND T.ORIGIN_TO_DIVISION_ID		= X.ORIGIN_TO_DIVISION_ID
	  AND T.ELECTRODE_TYPE				= X.ELECTRODE_TYPE
	  AND ISNULL(T.INCOTERMS,'-')		= ISNULL(X.INCOTERMS,'-')
	  AND ISNULL(T.TRANSPORT_MODE,'-')	= ISNULL(X.TRANSPORT_MODE,'-')
	  AND ISNULL(T.BOD_ID,'-')			= ISNULL(X.BOD_ID,'-') -- BOD 2단계 개발 : 조건 추가
	;

	PRINT '4. Make Plan_2 End. '+CONVERT(CHAR(23), GETDATE(), 21);


	-- ##############################################################################
	-- 최종 Plan Data 생성
	-- ##############################################################################
	IF OBJECT_ID('tempdb..#TMP_SCP0009_PLAN') IS NOT NULL
		DROP TABLE #TMP_SCP0009_PLAN ;

	SELECT (A.DIVISION_ID + A.BIZ_TYPE + A.PROJECT_CODE  + A.ITEM_ID + A.TO_SITE + A.INCOTERMS ) as key_idx
		 , A.DIVISION_ID
		 , A.BIZ_TYPE
		 , A.PROJECT_CODE
		 , A.ITEM_ID
		 , A.FROM_SITE
		 , A.TO_SITE
		 , CASE WHEN RIGHT(A.TO_SITE,2) = '-S' THEN LEFT(A.TO_SITE , LEN(A.TO_SITE) - 2) ELSE A.TO_SITE END TO_SITE2
		 , A.INCOTERMS
		 , A.MEASURE
		 , A.ORIGIN_FROM_DIVISION_ID
		 , A.ORIGIN_TO_DIVISION_ID
		 , A.ELECTRODE_TYPE
		 , A.ITEM_VALUE					AS QTY
		 , A.BOD_ID
		 , ISNULL(B.FROM_YYYYMMDD,'-')	AS BOD_FROM_YYYYMMDD
		 , ISNULL(B.TO_YYYYMMDD,'-')	AS BOD_TO_YYYYMMDD
		 , A.LT_DAY
		 , A.TRANSPORT_MODE
		 , A.MEASURE_LABEL
		 , A.MEASURE_ORDER_NO
		 , @p_from_yyyymmdd				AS FROM_YYYYMMDD
		 , @p_to_yyyymmdd				AS TO_YYYYMMDD
		 , @p_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD
		 , @p_plan_type					AS PLAN_TYPE
		 , @p_seq						AS SEQ
		 , 'D_'+A.yyyymmdd				AS YYYYMMDD
		 , C.basis_yyyymm				AS YYYYMM
		 , RIGHT(C.BASIS_YYYYMM, 4) + C.iso_week	AS ISO_WEEK
	  INTO #TMP_SCP0009_PLAN
	  FROM #TMP_SCP0009_ADD_MEASURE A

	 INNER JOIN SCM_SYS_CALENDAR_M C
	    ON A.YYYYMMDD = C.BASIS_YYYYMMDD

/*	  LEFT JOIN SCP_MST_BOD_N_V B WITH(NOLOCK)
	    ON A.BOD_ID		= B.BOD_ID*/
	  LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H B WITH(NOLOCK)
	    ON A.DIVISION_ID = B.DIVISION_ID
	   AND A.BOD_ID		 = B.BOD_ID
	   AND B.PLAN_SEQ 	 = @p_seq
	   AND B.PLAN_TYPE 	 = @p_plan_type
	   AND B.PLAN_NAME   = @p_plan_start_yyyymmdd
	;



	-- ##############################################################################
	-- 최종 Plan Data 생성 :  SHIP_PLAN, SHIP_PLAN_AMEND
	-- ##############################################################################


	IF @p_division_id = @DIV_ENERGY
	BEGIN
	insert into #TMP_SCP0009_PLAN
	select
	       DATA.key_idx
		 , DATA.DIVISION_ID
		 , DATA.BIZ_TYPE
		 , DATA.PROJECT_CODE
		 , DATA.ITEM_ID
		 , DATA.FROM_SITE
		 , DATA.TO_SITE
		 , DATA.TO_SITE2
		 , DATA.INCOTERMS
		 , DATA.MEASURE
		 , DATA.ORIGIN_FROM_DIVISION_ID
		 , DATA.ORIGIN_TO_DIVISION_ID
		 , DATA.ELECTRODE_TYPE
		 , DATA.QTY
		 , DATA.BOD_ID
		 , DATA.BOD_FROM_YYYYMMDD
		 , DATA.BOD_TO_YYYYMMDD
		 , DATA.LT_DAY
		 , DATA.TRANSPORT_MODE
		 , C.COLUMN_LABEL_NAME
		 , C.MEASURE_ORDER_NO
		 , DATA.FROM_YYYYMMDD
		 , DATA.TO_YYYYMMDD
		 , DATA.PLAN_START_YYYYMMDD
		 , DATA.PLAN_TYPE
		 , DATA.SEQ
		 , DATA.YYYYMMDD
		 , DATA.YYYYMM
		 , DATA.ISO_WEEK
	from
	(
	select
           key_idx
		 , DIVISION_ID
		 , BIZ_TYPE
		 , PROJECT_CODE
		 , A.ITEM_ID
		 , FROM_SITE
		 , TO_SITE
		 , TO_SITE2
		 , INCOTERMS
		 , CASE WHEN MEASURE = 'SHIP_PLAN' THEN 'SHIP_PLAN_ENERGY'
				WHEN MEASURE = 'SHIP_PLAN_AMEND' THEN 'SHIP_PLAN_AMEND_ENERGY'
				end as MEASURE
		 , ORIGIN_FROM_DIVISION_ID
		 , ORIGIN_TO_DIVISION_ID
		 , ELECTRODE_TYPE
		 , CASE WHEN QTY IS NOT NULL
		         AND ENERGY IS NOT NULL
				THEN ROUND( QTY * ENERGY / 1000, 4)
		        ELSE 0
		        END AS QTY
		 , BOD_ID
		 , BOD_FROM_YYYYMMDD
		 , BOD_TO_YYYYMMDD
		 , LT_DAY
		 , TRANSPORT_MODE
		 , MEASURE_LABEL
		 , MEASURE_ORDER_NO
		 , FROM_YYYYMMDD
		 , TO_YYYYMMDD
		 , PLAN_START_YYYYMMDD
		 , PLAN_TYPE
		 , SEQ
		 , YYYYMMDD
		 , YYYYMM
		 , ISO_WEEK
	from #TMP_SCP0009_PLAN A
left join  ( SELECT ITEM_ID
					, Convert(numeric(13,4),MAX(ENERGE)) AS ENERGY
				FROM SCM_ITEM_M_SN WITH(NOLOCK)
				WHERE ENERGE IS NOT NULL
					AND ENERGE != ''
			GROUP BY ITEM_ID
		 )	B ON A.ITEM_ID = b.ITEM_ID
	where measure in ('SHIP_PLAN','SHIP_PLAN_AMEND')
	AND DIVISION_ID = @DIV_ENERGY
	) data
	left join #TMP_SCP0009_MEASURE C on C.COLUMN_NAME = DATA.MEASURE
	WHERE C.COLUMN_NAME IN ('SHIP_PLAN_ENERGY','SHIP_PLAN_AMEND_ENERGY')
	END

	PRINT '5. Make Plan_3 End. '+CONVERT(CHAR(23), GETDATE(), 21);





	PRINT '======================== Result Start ==============================='

	-- 실적 포함 시
	IF(@v_RSLT_FLAG = 'Y')
	BEGIN

		-- ##############################################################################
		-- Shipment Plan (Auto & Ess) 기준 실적 가져온다. by 고C, 장C
		-- ##############################################################################

		IF OBJECT_ID('tempdb..#TMP_SCP0009_RSLT_TMP') IS NOT NULL
			DROP TABLE #TMP_SCP0009_RSLT_TMP;

		WITH RESULT_ERP_C_EXIST AS
		(
			-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       E.CONFIRM_ID              AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,       E.PROJECT_CODE            AS PROJECT_CODE
			,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY

			,       E.TO_SCM_SITE_ID AS TO_SITE -- 20220316 수정

			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1    = E.SSP_TYPE

				JOIN scm_mst_site ms WITH(NOLOCK)
				   ON E.DIVISION_ID = ms.DIVISION_ID
				AND E.FROM_SCM_SITE_ID = ms.SCM_SITE_ID
				AND ms.OSP_YN = 'N'

			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성
			AND   E.CONFIRM_ID LIKE 'C%'
			--AND   E.EXFACTORY_DATE BETWEEN @p_from_yyyymmdd  AND @p_to_yyyymmdd
			AND E.EXFACTORY_DATE	 >= convert(datetime, @V_FROM_RESULT)
			AND E.EXFACTORY_DATE	 < convert(datetime, @V_TO_RESULT )

			GROUP BY E.DIVISION_ID
			,        E.CONFIRM_ID
			,        E.ORDER_NO
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS
			,		 E.ETA_DATE
			,		 E.ETD_DATE
			,        E.PROJECT_CODE
			,        E.TO_SCM_SITE_ID  -- 20220316 수정

			-- 2022.06.09
			UNION ALL

			-- SCS (외주) 실적
			/*--------------------------------------------------------------------------
			 1. PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R  // SCM_DNM_SCS_SHIP_RESULT  i/f 테이블
			   , ATTR_05		AS CNFM_ID   -- confirm_id
				, MAX(ATTR_04)  AS SHIP_TO
				, MAX(ATTR_08)  AS TRANS_MODE
				, MAX(ATTR_09)  AS INCOTERMS
			---------------------------------------------------------------------------*/
			SELECT      E.DIVISION_ID             AS DIVISION_ID
				,       ISNULL(E.ATTRIBUTE5,'-')  AS CONFIRM_ID
				,       '-' 				      AS ERP_SO_NO
				,       E.SHIP_DATE               AS YYYYMMDD
				,       ISNULL(C.TRANSPORT_MODE,'-')  AS TRANSPORT_MODE
				,       ISNULL(C.INCOTERMS,'-')   AS INCOTERMS
				,		C.ETA_DATE				  AS ETA_DATE
				,		C.ETD_DATE 				  AS ETD_DATE
				,       ISNULL(C.PROJECT_CODE,'-')   AS PROJECT_CODE
				,       SUM(E.SHIP_QTY )          AS RESULT_QTY
				,       E.TO_SITE                 AS TO_SITE

			FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
				JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만
				ON   F.ITEM_ID = E.ITEM_ID
				AND  F.DIVISION_ID = E.DIVISION_ID

				JOIN SCM_MST_SITE FS WITH(NOLOCK)
				ON   FS.SCM_SITE_ID = E.SCM_SITE_ID
				AND  FS.DIVISION_ID = E.DIVISION_ID
				AND  FS.OSP_YN = 'Y'

				--JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)  --2022-08-19
				LEFT JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
				ON   E.DIVISION_ID	   = C.DIVISION_ID
				AND  E.PACK_MODEL_CODE = C.ITEM_ID
				AND  E.SCM_SITE_ID     = C.FROM_SITE
				AND  E.TO_SITE         = C.TO_SITE
				AND  E.ATTRIBUTE5      = C.CONFIRM_ID


			WHERE 1=1
				AND E.ATTRIBUTE5 LIKE 'C%'  -- confirm_id
				AND E.SHIP_DATE  >= convert(datetime, @V_FROM_RESULT)
				AND E.SHIP_DATE	< convert(datetime, @V_TO_RESULT )

			GROUP BY
					 E.DIVISION_ID
			,        E.ATTRIBUTE5
			,        E.SHIP_DATE
			,        E.TO_SITE
			,        C.TRANSPORT_MODE
			,        C.INCOTERMS
			,        C.PROJECT_CODE
			,        C.ETA_DATE
			,        C.ETD_DATE

		)
		, RESULT_ERP_C_NON AS
		(
			-- ERP 출하실적에서 CONFIRM_ID 없는 실적
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       '-'                       AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO
			,       E.FROM_SCM_SITE_ID        AS FROM_SITE
			,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE
			,       E.ITEM_ID                 AS ITEM_ID
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,       E.PROJECT_CODE            AS PROJECT_CODE
			,       SUM(E.EXFACTORY_QTY )     AS QTY
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만
				ON F.ITEM_ID = E.ITEM_ID
				AND F.DIVISION_ID = E.DIVISION_ID
				JOIN   SCM_MST_SITE FS WITH(NOLOCK)
					ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID
				   AND FS.DIVISION_ID = E.DIVISION_ID
				   AND FS.OSP_YN = 'N'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
						ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE
					AND L3.SEGMENT1    = E.DIVISION_ID
					AND L3.SEGMENT2    = E.SOLDTO_CODE
					AND L3.SEGMENT3    = E.SHIPTO_CODE
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성
			AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE 'C%'
			AND   E.EXFACTORY_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd
			AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외
			AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1
										 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
										WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
										  AND VALID_YN = 'Y'
									  )	-- 사외 창고 제외 LOOKUP 관리
			AND E.ORDER_TYPE_CODE NOT IN (SELECT SEGMENT1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL
									WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE'
										AND VALID_YN = 'Y'
									)	-- ERP오더타입 제외 LOOKUP 관리

			-- 추가
			AND E.EXFACTORY_DATE	 >= convert(datetime, @V_FROM_RESULT)
			AND E.EXFACTORY_DATE	 < convert(datetime, @V_TO_RESULT )

			GROUP BY E.DIVISION_ID
			,        E.ORDER_NO
			,        E.FROM_SCM_SITE_ID
			,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)
			,        E.ITEM_ID
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS
			,		 E.ETA_DATE
			,		 E.ETD_DATE
			,        E.PROJECT_CODE

			-- 2022.06.09
			UNION ALL

			SELECT      E.DIVISION_ID             AS DIVISION_ID
				,       '-'                       AS CONFIRM_ID
				,       '-' 				      AS ERP_SO_NO
				,       E.SCM_SITE_ID             AS FROM_SITE
				,       E.TO_SITE                 AS TO_SITE
				,       E.ITEM_ID                 AS ITEM_ID
				,       E.SHIP_DATE               AS YYYYMMDD
				,       ISNULL(C.TRANSPORT_MODE,'-')  AS TRANSPORT_MODE
				,       ISNULL(C.INCOTERMS,'-')   AS INCOTERMS
				,		C.ETA_DATE 				  AS ETA_DATE
				,		C.ETD_DATE 				  AS ETD_DATE
				,       ISNULL(C.PROJECT_CODE,'-')   AS PROJECT_CODE
				,       SUM(E.SHIP_QTY )          AS QTY

			FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
				JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만
				ON F.ITEM_ID = E.ITEM_ID
				AND F.DIVISION_ID = E.DIVISION_ID

				JOIN   SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.SCM_SITE_ID = E.SCM_SITE_ID
				AND FS.DIVISION_ID = E.DIVISION_ID
				AND FS.OSP_YN = 'Y'

				--JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)  --2022-08-19
				LEFT JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
				ON   E.DIVISION_ID	   = C.DIVISION_ID
				AND  E.PACK_MODEL_CODE = C.ITEM_ID
				AND  E.SCM_SITE_ID     = C.FROM_SITE
				AND  E.TO_SITE         = C.TO_SITE
				AND  E.ATTRIBUTE5      = C.CONFIRM_ID

			WHERE 1=1
				AND E.ATTRIBUTE5 NOT LIKE 'C%'  -- confirm_id
				AND E.SHIP_DATE  >= convert(datetime, @V_FROM_RESULT)
				AND E.SHIP_DATE	< convert(datetime, @V_TO_RESULT )

			GROUP BY
						E.DIVISION_ID
			,        E.SCM_SITE_ID
			,        E.TO_SITE
			,        E.ITEM_ID
			,        E.SHIP_DATE
			,        C.TRANSPORT_MODE
			,        C.INCOTERMS
			,        C.PROJECT_CODE
			,        C.ETA_DATE
			,        C.ETD_DATE

		)
		 -- 20220106 PJ20209643 소형 OSP Pack Item 처리
		, PLAN_SSP AS
		(   -- SSP출하계획 ( confirm된 계획)
			SELECT C.DIVISION_ID    AS DIVISION_ID
			,      C.ERP_SO_NO      AS ERP_SO_NO
			,      C.CONFIRM_ID     AS CONFIRM_ID
			 -- 20220106 PJ20209643 소형 OSP Pack Item 처리
			 --, c.item_id
            ,		CASE WHEN ISNULL(fi.packer_plan_item_id, '') = '' THEN C.ITEM_ID
						ELSE fi.packer_plan_item_id
					END item_id
			,      C.FROM_SITE      AS FROM_SITE
			,      C.TO_SITE        AS TO_SITE
			,      CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')
						ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER
			,      C.QTY            AS QTY
			,      C.YYYYMMDD       AS YYYYMMDD
			,      C.TRANSPORT_MODE AS TRANSPORT_MODE
			,      C.INCOTERMS      AS INCOTERMS
			,      C.ETD_DATE       AS ETD_DATE
			,      C.ETA_DATE       AS ETA_DATE
			,	   NULL				AS SHIP_TYPE
			FROM [DBO].[SSP_ANL_SHIP_CONFIRM] C WITH(NOLOCK)	--SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
				 LEFT OUTER JOIN [dbo].[SCM_MST_SITE_ITEM] SI WITH(NOLOCK)	--SCM_MST_SITE_ITEM SI WITH(NOLOCK)
							  ON SI.DIVISION_ID = C.DIVISION_ID
							 AND SI.ITEM_ID     = C.ITEM_ID
							 AND SI.SCM_SITE_ID = C.TO_SITE
							 AND SI.PROJECT_CODE = C.PROJECT_CODE
 				 LEFT OUTER JOIN [dbo].[SCM_MST_SITE] TS WITH(NOLOCK)	--SCM_MST_SITE TS WITH(NOLOCK)
							  ON TS.DIVISION_ID = C.DIVISION_ID
							 AND TS.SCM_SITE_ID = C.TO_SITE

				 -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                 LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                      ON   C.division_id = fi.division_id
                      AND  C.item_id     = fi.item_id
                      AND  fi.division_id = '40'
			WHERE CHANGE_TYPE = 'C'
			--AND   QTY > 0  -- 2022-08-11
			AND C.BIZ_TYPE = @p_biz_type
			AND C.DIVISION_ID = @p_division_id
			--AND C.YYYYMMDD >=	@V_FROM_RESULT
			--AND C.YYYYMMDD <	@V_TO_RESULT

		)

		SELECT X.DIVISION_ID
		,      MS.COMPANY_ID AS COMPANY_ID
		,      L.SEGMENT2  AS TYPE
		,	   X.ERP_SO_NO
		,      X.CONFIRM_ID
		,      X.ITEM_ID
		,      DBO.FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME

		--* 2021.11.02   LWY
		--,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.FROM_SITE),X.FROM_SITE)   AS FROM_SITE
		--,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.TO_SITE),X.TO_SITE)       AS TO_SITE
		,      X.FROM_SITE  AS FROM_SITE
		,      X.TO_SITE    AS TO_SITE


		,      X.END_CUSTOMER
		,      X.QTY
		--,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.YYYYMMDD,112), 23) AS YYYYMMDD
		,      X.YYYYMMDD  AS YYYYMMDD
		,      X.TRANSPORT_MODE
		,      X.INCOTERMS
		,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETD_DATE,112), 23) AS ETD_DATE
		,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETA_DATE,112), 23) AS ETA_DATE
		,	   X.SHIP_TYPE
		,      X.PROJECT_CODE

		INTO #TMP_SCP0009_RSLT_TMP

		FROM (
			--CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계
			SELECT P.DIVISION_ID     AS DIVISION_ID
			,     'E'				 AS TYPE
			,      R.ERP_SO_NO       AS ERP_SO_NO
			,      R.CONFIRM_ID      AS CONFIRM_ID
			,      P.ITEM_ID         AS ITEM_ID
			,      P.FROM_SITE       AS FROM_SITE

		  --,      P.TO_SITE         AS TO_SITE
			,      R.TO_SITE         AS TO_SITE  -- 20220316 수정

			,      NULL              AS END_CUSTOMER
			,      SUM(R.RESULT_QTY) AS QTY
			,      R.YYYYMMDD        AS YYYYMMDD
			,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      R.INCOTERMS       AS INCOTERMS
			,      R.ETD_DATE        AS ETD_DATE
			,      R.ETA_DATE        AS ETA_DATE
			,      NULL				 AS SHIP_TYPE
			,      R.PROJECT_CODE    AS PROJECT_CODE
			FROM  PLAN_SSP P
					JOIN RESULT_ERP_C_EXIST R
					ON R.DIVISION_ID = P.DIVISION_ID
					AND R.CONFIRM_ID = P.CONFIRM_ID
					AND R.YYYYMMDD = P.YYYYMMDD

			GROUP BY P.DIVISION_ID
			,		 R.ERP_SO_NO
			,        P.FROM_SITE
		    --,        P.TO_SITE
		    ,        R.TO_SITE   -- 20220316 수정
			,        P.ITEM_ID
			,		 R.TRANSPORT_MODE
			,		 R.INCOTERMS
			,		 R.ETD_DATE
			,		 R.ETA_DATE
			,        R.YYYYMMDD
			,        R.CONFIRM_ID
			,        R.PROJECT_CODE

		UNION ALL

			--CONFIRM_ID ,기준으로 날짜가 다른 계획정보의 FROM, TO SITE기준으로 실적 집계
			SELECT P.DIVISION_ID     AS DIVISION_ID
			,     'E'                AS TYPE
			,      R.ERP_SO_NO       AS ERP_SO_NO
			,      R.CONFIRM_ID      AS CONFIRM_ID
			,      P.ITEM_ID         AS ITEM_ID
			,      P.FROM_SITE       AS FROM_SITE
		  --,      P.TO_SITE         AS TO_SITE
			,      R.TO_SITE         AS TO_SITE  -- 20220316 수정
			,      NULL              AS END_CUSTOMER
			,      SUM(R.RESULT_QTY) AS QTY
			,      R.YYYYMMDD        AS YYYYMMDD
			,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      R.INCOTERMS       AS INCOTERMS
			,      R.ETD_DATE        AS ETD_DATE
			,      R.ETA_DATE        AS ETA_DATE
			,      NULL				 AS SHIP_TYPE
			,      R.PROJECT_CODE    AS PROJECT_CODE
			FROM  PLAN_SSP P
					JOIN RESULT_ERP_C_EXIST R
					ON R.DIVISION_ID = P.DIVISION_ID
					AND R.CONFIRM_ID = P.CONFIRM_ID
					AND R.YYYYMMDD <> P.YYYYMMDD
			GROUP BY P.DIVISION_ID
			,	     R.ERP_SO_NO
			,        P.FROM_SITE
		  --,        P.TO_SITE
		    ,        R.TO_SITE   -- 20220316 수정
			,        P.ITEM_ID
			,		 R.TRANSPORT_MODE
			,		 R.INCOTERMS
			,		 R.ETD_DATE
			,		 R.ETA_DATE
			,        R.YYYYMMDD
			,        R.CONFIRM_ID
			,        R.PROJECT_CODE

		UNION ALL

			--CONFIRM_ID 없는 실적
			SELECT R.DIVISION_ID     AS DIVISION_ID
			,     'E'                AS TYPE
			,      R.ERP_SO_NO       AS ERP_SO_NO
			,      NULL              AS CONFIRM_ID
			,      R.ITEM_ID         AS ITEM_ID
			,      R.FROM_SITE       AS FROM_SITE
			,      R.TO_SITE         AS TO_SITE
			,      NULL              AS END_CUSTOMER
			,      R.QTY             AS QTY
			,      R.YYYYMMDD        AS YYYYMMDD
			,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      R.INCOTERMS       AS INCOTERMS
			,      R.ETD_DATE        AS ETD_DATE
			,      R.ETA_DATE        AS ETA_DATE
			,      NULL              AS SHIP_TYPE
			,      R.PROJECT_CODE    AS PROJECT_CODE
			FROM  RESULT_ERP_C_NON R

		UNION ALL

			SELECT P.DIVISION_ID     AS DIVISION_ID
			,     'P'                AS TYPE
			,      P.ERP_SO_NO       AS ERP_SO_NO
			,      P.CONFIRM_ID      AS CONFIRM_ID
			,      P.ITEM_ID         AS ITEM_ID
			,      P.FROM_SITE       AS FROM_SITE
			,      P.TO_SITE         AS TO_SITE
			,      P.END_CUSTOMER    AS END_CUSTOMER
			,      P.QTY             AS QTY
			,      P.YYYYMMDD        AS YYYYMMDD
			,      P.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      P.INCOTERMS       AS INCOTERMS
			,      P.ETD_DATE        AS ETD_DATE
			,      P.ETA_DATE        AS ETA_DATE
			,      NULL              AS SHIP_TYPE
			,      NULL              AS PROJECT_CODE
			FROM  PLAN_SSP P
			--WHERE P.YYYYMMDD BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd
			WHERE 1 = 1
			  AND P.YYYYMMDD >= convert(datetime, @V_FROM_RESULT)
			  AND P.YYYYMMDD  < convert(datetime, @V_TO_RESULT )

		) X
			JOIN SCM_MST_SITE MS WITH(NOLOCK)
			  ON MS.DIVISION_ID = X.DIVISION_ID
			 AND MS.SCM_SITE_ID = X.FROM_SITE
			 AND MS.OPERATION_GROUP <> 'E'
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
   			  ON L.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE' -- LOOKUP에 등록된 공정만
			 AND L.SEGMENT1 = X.TYPE
			 AND L.VALID_YN = 'Y'
			LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK)
						ON  M.DIVISION_ID = X.DIVISION_ID
						and M.FROM_SITE = X.FROM_SITE
						and M.ITEM_ID = X.ITEM_ID
						and M.VALID_YN = 'Y'
		WHERE 1=1
		AND   X.DIVISION_ID = @p_division_id
		AND   X.TYPE = 'E'  -- Result(ERP)
		AND ( ( @p_fromsite   IS NULL OR @p_fromsite ='')  OR X.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_fromsite,',')) )
		--AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR X.ITEM_ID LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id	, ',')))
		AND (( @p_item_id		IS NULL OR @p_item_id		='') OR X.ITEM_ID			IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))
		;


		PRINT '6. Make Rslt Temp End. '+CONVERT(CHAR(23), GETDATE(), 21);

		-- ##############################################################################
		-- Final 실적정보 생성
		-- ##############################################################################

		IF OBJECT_ID('tempdb..#TMP_SCP0009_RSLT') IS NOT NULL
			DROP TABLE #TMP_SCP0009_RSLT;


		-- Final Result
		SELECT   (R.DIVISION_ID + @p_biz_type + ISNULL(R.PROJECT_CODE,'-')  + ISNULL(R.ITEM_ID,'-') + ISNULL(R.TO_SITE,'-') + ISNULL(R.INCOTERMS,'-') ) as key_idx

				, R.DIVISION_ID
				, R.BIZ_TYPE
				, R.PROJECT_CODE
				, R.ITEM_ID

				, R.FROM_SITE AS FROM_SITE
				, R.TO_SITE   AS TO_SITE
				, CASE WHEN RIGHT(R.TO_SITE,2) = '-S' THEN LEFT(R.TO_SITE , LEN(R.TO_SITE) - 2) ELSE R.TO_SITE END TO_SITE2

				, R.INCOTERMS
				, CONVERT(nvarchar(400), R.MEASURE ) AS MEASURE
				, R.DIVISION_ID	AS ORIGIN_FROM_DIVISION_ID
				, R.DIVISION_ID	AS ORIGIN_TO_DIVISION_ID
				, ISNULL(NULLIF(B.ELECTRODE_TYPE,''),'-')	AS ELECTRODE_TYPE
				, R.QTY
				, ISNULL(NULLIF(R.BOD_ID,''),'-')			AS BOD_ID
				, ISNULL(R.BOD_FROM_YYYYMMDD,'-')			AS BOD_FROM_YYYYMMDD
				, ISNULL(R.BOD_TO_YYYYMMDD,'-')				AS BOD_TO_YYYYMMDD
				, ISNULL(NULLIF(B.LT_DAY,''),'-')			AS LT_DAY
				, R.TRANSPORT_MODE
				, CONVERT(nvarchar(300), R.MEASURE_LABEL ) AS MEASURE_LABEL
				, ISNULL(NULLIF(M.MEASURE_ORDER_NO,''),'-')	AS MEASURE_ORDER_NO
				, @p_from_yyyymmdd							AS FROM_YYYYMMDD
				, @p_to_yyyymmdd							AS TO_YYYYMMDD
				, @p_plan_start_yyyymmdd					AS PLAN_START_YYYYMMDD
				, @p_plan_type								AS PLAN_TYPE
				, @p_seq									AS SEQ
				, 'D_'+R.EXFACTORY_DATE						AS YYYYMMDD
				, C.basis_yyyymm							AS YYYYMM
				, RIGHT(C.BASIS_YYYYMM, 4) + C.iso_week		AS ISO_WEEK

		  INTO #TMP_SCP0009_RSLT

		  FROM (
				SELECT
						  R.DIVISION_ID
						, @p_biz_type AS BIZ_TYPE
						, R.PROJECT_CODE
						, R.ITEM_ID
						, R.FROM_SITE
						, R.TO_SITE
						, R.INCOTERMS
						, 'SHIP_PLAN_AMEND' AS MEASURE                     -- SHIP_PLAN_AMEND 가   SHIP_PLAN 보다 문자열 길어서 TEMP INSERT 시 오류 때문에 순서바꿈
						, R.DIVISION_ID		AS ORIGIN_FROM_DIVISION_ID
						, R.DIVISION_ID		AS ORIGIN_TO_DIVISION_ID
						, R.TRANSPORT_MODE
						, 'Ship Plan Amend'	AS MEASURE_LABEL
						, R.YYYYMMDD		AS EXFACTORY_DATE	-- EXFACTORY_DATE
						, B.BOD_ID			AS BOD_ID
						, B.FROM_YYYYMMDD	AS BOD_FROM_YYYYMMDD
						, B.TO_YYYYMMDD		AS BOD_TO_YYYYMMDD
						, SUM(R.QTY)		AS QTY				-- EXFACTORY_QTY

				 FROM #TMP_SCP0009_RSLT_TMP R

				 -- BOD 2단계 개발 : VIEW 수정 및 FROM , TO 조건 추가
				 --LEFT JOIN SCP_MST_BOD_N_V B
				    LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H B WITH(NOLOCK)
					  --ON R.DIVISION_ID	= (CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN B.ORG_DIVISION_ID ELSE B.DIVISION_ID END )
					  ON R.DIVISION_ID	= (CASE WHEN @P_DIVISION_ID IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) THEN B.ORG_DIVISION_ID ELSE B.DIVISION_ID END ) --div_commonization
					 AND R.FROM_SITE		= B.FROM_SITE
					 AND R.TO_SITE			= B.TO_SITE
					 AND R.TRANSPORT_MODE   = B.TRANSPORT_MODE
					 AND R.INCOTERMS        = B.INCOTERMS
					 AND R.YYYYMMDD			>= B.FROM_YYYYMMDD
					 AND R.YYYYMMDD			<= B.TO_YYYYMMDD
					 AND B.DIVISION_ID      = @P_DIVISION_ID
					 AND B.PLAN_TYPE        = @P_PLAN_TYPE
					 AND B.PLAN_SEQ         = @P_SEQ
	   				 AND B.PLAN_NAME        = @p_plan_start_yyyymmdd

				GROUP BY  R.DIVISION_ID
						, R.PROJECT_CODE
						, R.ITEM_ID
						, R.FROM_SITE
						, R.TO_SITE
						, R.INCOTERMS
						, R.TRANSPORT_MODE
						, R.YYYYMMDD
						, B.BOD_ID
						, B.FROM_YYYYMMDD
						, B.TO_YYYYMMDD
				) R

				INNER JOIN #TMP_SCP0009_MEASURE M
				ON R.MEASURE = M.COLUMN_NAME
				JOIN scm_sys_calendar_m C
				on convert(nvarchar(8), R.EXFACTORY_DATE, 112)  = C.basis_yyyymmdd
				--JOIN SCM_MST_FINAL_ITEM_V D
				--ON  R.DIVISION_ID = D.DIVISION_ID
				--AND R.ITEM_ID = D.ITEM_ID
				--AND D.OPERATION_GROUP_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_OPERATION_GROUP_ID, ','))
				LEFT JOIN #TMP_SCP0009_STD B
				 on 1 = 1
				AND R.BOD_ID       = B.BOD_ID
				AND R.item_id	   = B.item_id
				AND R.PROJECT_CODE = B.PROJECT_CODE
				--AND 'SHIP_PLAN' = B.MEASURE

				-- 2021.12.02   LWY
				AND R.MEASURE = B.MEASURE

			;

		PRINT '7. Make Rslt End. '+CONVERT(CHAR(23), GETDATE(), 21);




		-- ##############################################################################
		-- SHIP_PLAN_AMEND -> SHIP_PLAN  Copy.......
		-- ##############################################################################

		 INSERT INTO #TMP_SCP0009_RSLT
		 SELECT
			  key_idx
			, DIVISION_ID
			, BIZ_TYPE
			, PROJECT_CODE
			, ITEM_ID
			, FROM_SITE
			, TO_SITE
			, TO_SITE2
			, INCOTERMS
			, 'SHIP_PLAN'			 -- MEASURE
			, ORIGIN_FROM_DIVISION_ID
			, ORIGIN_TO_DIVISION_ID
			, ELECTRODE_TYPE
			, QTY
			, BOD_ID
			, BOD_FROM_YYYYMMDD		-- BOD 2단계
			, BOD_TO_YYYYMMDD		-- BOD 2단계
			, LT_DAY
			, TRANSPORT_MODE
			, 'Ship Plan'			 -- MEASURE LABEL
			, M.MEASURE_ORDER_NO
			, FROM_YYYYMMDD
			, TO_YYYYMMDD
			, PLAN_START_YYYYMMDD
			, PLAN_TYPE
			, SEQ
			, YYYYMMDD
			, YYYYMM
			, ISO_WEEK

		   FROM #TMP_SCP0009_RSLT R
		   CROSS APPLY(SELECT MEASURE_ORDER_NO     -- 1건
						 FROM #TMP_SCP0009_MEASURE
						 WHERE COLUMN_NAME = 'SHIP_PLAN') M
		 ;


		IF @p_division_id = @DIV_ENERGY
		BEGIN
			 INSERT INTO #TMP_SCP0009_RSLT
			 (
				  key_idx
				 ,DIVISION_ID
				 ,BIZ_TYPE
				 ,PROJECT_CODE
				 ,ITEM_ID
				 ,FROM_SITE
				 ,TO_SITE
				 ,TO_SITE2
				 ,INCOTERMS
				 ,MEASURE
				 ,ORIGIN_FROM_DIVISION_ID
				 ,ORIGIN_TO_DIVISION_ID
				 ,ELECTRODE_TYPE
				 ,QTY
				 ,BOD_ID
				 ,BOD_FROM_YYYYMMDD
				 ,BOD_TO_YYYYMMDD
				 ,LT_DAY
				 ,TRANSPORT_MODE
				 ,MEASURE_LABEL
				 ,MEASURE_ORDER_NO
				 ,FROM_YYYYMMDD
				 ,TO_YYYYMMDD
				 ,PLAN_START_YYYYMMDD
				 ,PLAN_TYPE
				 ,SEQ
				 ,YYYYMMDD
				 ,YYYYMM
				 ,ISO_WEEK
			 )
			SELECT
				  key_idx
				 ,DIVISION_ID
				 ,BIZ_TYPE
				 ,PROJECT_CODE
				 ,ITEM_ID
				 ,FROM_SITE
				 ,TO_SITE
				 ,TO_SITE2
				 ,INCOTERMS
				 ,'SHIP_PLAN_AMEND_ENERGY' as MEASURE
				 ,ORIGIN_FROM_DIVISION_ID
				 ,ORIGIN_TO_DIVISION_ID
				 ,ELECTRODE_TYPE
				 ,ISNULL(QTY,0) * 2
				 ,BOD_ID
				 ,BOD_FROM_YYYYMMDD
				 ,BOD_TO_YYYYMMDD
				 ,LT_DAY
				 ,TRANSPORT_MODE
				 ,'Ship Plan Amend (MWh)' as MEASURE_LABEL
				 ,MEASURE_ORDER_NO
				 ,FROM_YYYYMMDD
				 ,TO_YYYYMMDD
				 ,PLAN_START_YYYYMMDD
				 ,PLAN_TYPE
				 ,SEQ
				 ,YYYYMMDD
				 ,YYYYMM
				 ,ISO_WEEK
			FROM #TMP_SCP0009_RSLT
			WHERE MEASURE = 'SHIP_PLAN_AMEND'
			AND DIVISION_ID = @DIV_ENERGY
		END

		 PRINT '8. Copy Rslt SHIP_PLAN -> SHIP_PLAN_AMEND '+CONVERT(CHAR(23), GETDATE(), 21);


	END  -- IF(@v_RSLT_FLAG = 'Y')

	PRINT '======================== Result END   ==============================='

	IF OBJECT_ID('tempdb..#TMP_SCP0009_FNL_RSLT_PLAN') IS NOT NULL
		DROP TABLE #TMP_SCP0009_FNL_RSLT_PLAN ;

	-- 2021/10/05 : UI 속도 개선
    -- RSLT + PLAN
	--IF(@v_RSLT_FLAG = 'Y')
	--BEGIN
	--	SELECT  *
	--	INTO #TMP_SCP0009_FNL_RSLT_PLAN
	--	FROM (
	--			SELECT *
	--				FROM #TMP_SCP0009_PLAN
	--			UNION
	--			SELECT *
	--				FROM #TMP_SCP0009_RSLT
	--			) b
	--	;
	--END


	SELECT *
	  INTO #TMP_SCP0009_FNL_RSLT_PLAN
	  FROM #TMP_SCP0009_PLAN
	;

	IF(@v_RSLT_FLAG = 'Y')
	BEGIN
		INSERT INTO #TMP_SCP0009_FNL_RSLT_PLAN
		SELECT *
		  FROM #TMP_SCP0009_RSLT
		;
	END

	ALTER TABLE #TMP_SCP0009_FNL_RSLT_PLAN ADD WEEK_YN CHAR(1);
	ALTER TABLE #TMP_SCP0009_FNL_RSLT_PLAN ADD MONTH_YN CHAR(1);

	-- 2021/10/05 : UI 속도 개선 ( SUM을 위한 컬럼 UPDATE)
	UPDATE A
	   SET WEEK_YN = 'Y'
	  FROM #TMP_SCP0009_FNL_RSLT_PLAN A
	  JOIN (
			SELECT ISO_WEEK , PARTIAL_WEEK_NAME,CALENDAR_YYYY , MAX(BASIS_YYYYMMDD) AS YYYYMMDD
			  FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			 WHERE BASIS_YYYYMMDD >= @p_from_yyyymmdd
			   AND BASIS_YYYYMMDD <= @p_to_period  -- 마지막 구간 오류 발생으로 1개월 더함
			  GROUP BY ISO_WEEK, PARTIAL_WEEK_NAME,CALENDAR_YYYY
			) X
			ON RIGHT(A.YYYYMMDD,8) = X.YYYYMMDD
	   WHERE MEASURE IN ( 'BALANCE' ,'WH_IN_BALANCE')
	;

	UPDATE A
	   SET MONTH_YN = 'Y'
	  FROM #TMP_SCP0009_FNL_RSLT_PLAN A
	  JOIN (
			SELECT  BASIS_YYYYMM , MAX(BASIS_YYYYMMDD) AS YYYYMMDD
			  FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			 WHERE BASIS_YYYYMMDD >= @p_from_yyyymmdd
			   AND BASIS_YYYYMMDD <= @p_to_period  -- 마지막 구간 오류 발생으로 1개월 더함
			  GROUP BY BASIS_YYYYMM
			) X
			ON RIGHT(A.YYYYMMDD,8) = X.YYYYMMDD
	   WHERE MEASURE IN ( 'BALANCE' ,'WH_IN_BALANCE')

	PRINT '9. Fianl Data  '+CONVERT(CHAR(23), GETDATE(), 21);



	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
		BEGIN
			DECLARE @mQry_sum NVARCHAR(MAX);
			DECLARE @mDAY_QTY NVARCHAR(MAX);

			-- PIVOIT 대상 날짜문자열 생성
		SET @mDAY_QTY='QTY';
		SET @mQry_sum = '';



SELECT  @mQry_sum = @mQry_sum+','+
	--2021/10/05 : UI 속도 개선
 --CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) THEN convert(numeric(15,2), '+@mDAY_QTY+') ELSE 0 END) AS ' + yyyymmdd
 CASE WHEN CHARINDEX('M_', yyyymmdd) =1
      THEN  'SUM(
	         CASE WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) AND MEASURE IN (''SHIP_PLAN_ENERGY'' ,''SHIP_PLAN_AMEND_ENERGY'')
			      THEN convert(numeric(15,3),'+@mDAY_QTY+')
			      WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) AND MEASURE NOT IN (''BALANCE'' ,''WH_IN_BALANCE'')
			      THEN convert(numeric(15,2),'+@mDAY_QTY+') '
		      + ' WHEN yyyymm=RIGHT('''+yyyymmdd+''',6) AND MEASURE IN ( ''BALANCE'',''WH_IN_BALANCE'') AND MONTH_YN = ''Y''
			      THEN convert(numeric(15,2),'+@mDAY_QTY+')
				  ELSE 0
				  END
				  ) AS ' + yyyymmdd
	  WHEN CHARINDEX('W_', yyyymmdd) =1
	  THEN  'SUM(
	         CASE WHEN iso_week=RIGHT('''+yyyymmdd+''',6) AND MEASURE  IN (''SHIP_PLAN_ENERGY'' ,''SHIP_PLAN_AMEND_ENERGY'')
				  THEN convert(numeric(15,3),'+@mDAY_QTY+')
			      WHEN iso_week=RIGHT('''+yyyymmdd+''',6) AND MEASURE NOT IN (''BALANCE'' ,''WH_IN_BALANCE'')
				  THEN convert(numeric(15,2),'+@mDAY_QTY+') '
		      + ' WHEN iso_week=RIGHT('''+yyyymmdd+''',6) AND MEASURE IN ( ''BALANCE'',''WH_IN_BALANCE'') AND WEEK_YN = ''Y''
			      THEN convert(numeric(15,2),'+@mDAY_QTY+')
				  ELSE 0
				  END
				  ) AS ' + yyyymmdd
	  WHEN CHARINDEX('D_', yyyymmdd) =1
	  THEN  'SUM(
	         CASE WHEN yyyymmdd='''+yyyymmdd+''' AND MEASURE IN (''SHIP_PLAN_ENERGY'' ,''SHIP_PLAN_AMEND_ENERGY'')
				  THEN convert(numeric(15,3), '+@mDAY_QTY+' )
				  WHEN yyyymmdd='''+yyyymmdd+'''
				  THEN convert(numeric(15,2), '+@mDAY_QTY+' )
				  ELSE 0
				  END
			      ) AS ' + yyyymmdd
	  END +''+CHAR(10)
			FROM (
					SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
						, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a
					WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					  AND ( @p_bucket = 'DAILY' OR @p_bucket = 'WEEKLY' )	--2021/10/05 : UI 속도 개선
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
					  AND @p_bucket = 'DAILY'	--2021/10/05 : UI 속도 개선
					GROUP BY a.basis_yyyymmdd

				) AS A
			ORDER BY sort_order_no  ;

			SET @mEXEC = '';

			-- 20230411 ENERGY (UI 셀병합 위해서 문자열 AND Null일 경우 공백으로 처리 필요)
			SET @mEXEC = @mEXEC+'      ;WITH W_ENERGY AS (
			                                              SELECT ITEM_ID
														       , convert(nvarchar(max), Convert(numeric(13,4),MAX(ENERGE))) AS ENERGY
															FROM SCM_ITEM_M_SN WITH(NOLOCK)
														   WHERE ENERGE IS NOT NULL
														     AND ENERGE != ''''
													    GROUP BY ITEM_ID)
						'+CHAR(10);
			SET @mEXEC = @mEXEC+'      SELECT a.*																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(b.PROJECT_NAME, ''-'') PROJECT_NAME								'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(EG.ENERGY,'' '') AS ENERGY								                        '+CHAR(10);
			--@p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'			  , ISNULL(CASE WHEN a.division_id <> ''40'' and a.division_id <> ''82'' THEN b.PROJECT_OWNER ELSE f.USER_NAME_EN end, ''-'') AS PROJECT_OWNER												'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'			  , ISNULL(CASE WHEN a.origin_to_division_id <> ''40'' and a.division_id <> ''82'' THEN b.PROJECT_OWNER ELSE f.USER_NAME_EN end, ''-'') AS PROJECT_OWNER												'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , CASE WHEN c.ITEM_TYPE IS NULL OR c.ITEM_TYPE = '''' THEN ''-'' ELSE dbo.FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', c.ITEM_TYPE) END ITEM_TYPE		'+CHAR(10);
			SET @mEXEC = @mEXEC+'			  , ISNULL(g.DEPT_NAME_KO, ''-'') DEPT_NAME_KO								'+CHAR(10);
			IF @p_division_id IN ('40')
			BEGIN
				SET @mEXEC = @mEXEC+'			  , ISNULL(c.CELL_TYPE, ''-'') PRODUCT_GROUP								'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ISNULL(e.ATTRIBUTE5, ''-'') CELL_MODEL									'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , CAST(ISNULL(k.CELL_PACK_COUNT, 0) AS INT) CELL_PACK_COUNT				'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ISNULL(e.Application, ''-'') APPLICATION								'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ISNULL(k.MIN_CAPACITY, ''-'') MIN_CAPACITY								'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ISNULL(d.SOLDTO_CUSTOMER, ''-'') SOLDTO_CUSTOMER						'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ISNULL(k.FORECAST_INFO_SPEC, ''-'') MODEL_SPEC							'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ISNULL(k.FORECAST_INFOR_VERSION, ''-'') MODEL_VERSION					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ISNULL(k.FORECAST_INFO_ALL, ''-'') SPEC_VERSION							'+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'			  , ''-'' PRODUCT_GROUP														'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ''-'' CELL_MODEL														'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , 0 CELL_PACK_COUNT														'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ''-'' APPLICATION														'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ''-'' MIN_CAPACITY														'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ''-'' SOLDTO_CUSTOMER													'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ''-'' MODEL_SPEC														'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ''-'' MODEL_VERSION														'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  , ''-'' SPEC_VERSION														'+CHAR(10);
			END
			SET @mEXEC = @mEXEC+'	   from (																			'+CHAR(10);

			SET @mEXEC = @mEXEC+'      SELECT																			'+CHAR(10);
			SET @mEXEC = @mEXEC+'      		  key_idx																	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, division_id																'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, biz_type																	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, dbo.FN_GET_LOOKUP_CODE_DESC(''BIZ_TYPE'', BIZ_TYPE) AS biz_type_name		'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, project_code																'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, item_id																	'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,(SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = a.item_id)	nick_name '+CHAR(10);
			SET @mEXEC = @mEXEC+'			,(SELECT TOP 1 isnull(NULLIF(SCP_EXTRA_SPEC,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.DIVISION_ID = a.DIVISION_ID AND x.ITEM_ID = a.item_id)	EXTRA_SPEC '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, to_site, to_site2																						'+CHAR(10);

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'			,(select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = TO_SITE2) to_site_name '+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+' 			, to_site as to_site_name							'+CHAR(10);

			SET @mEXEC = @mEXEC+' 			, incoterms																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, from_site																						'+CHAR(10);
			SET @mEXEC = @mEXEC+'			,isnull((select top 1 SITE_DESCRIPTION from SCM_MST_SITE  where 1=1  and SCM_SITE_ID = FROM_SITE),''-'') from_site_name '+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, A.bod_id																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, A.BOD_FROM_YYYYMMDD																			'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, A.BOD_TO_YYYYMMDD																				'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, ISNULL(transport_mode , ''-'') as transport_mode												'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, ISNULL(lt_day , 0) as lt_day																	'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, origin_from_division_id, origin_to_division_id, electrode_type								'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, cast( round( [dbo].[FN_GET_SCP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd, plan_type, seq, to_site , item_id,from_yyyymmdd) , 1) as int) as boh '+CHAR(10);
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				BEGIN SET @mEXEC = @mEXEC+' 			, CONVERT(CHAR(10),DATEADD(DAY, (SELECT ISNULL(SHIP_FROZEN, 0) AS SHIP_FROZEN FROM SCM_MST_SITE WHERE DIVISION_ID= division_id AND SCM_SITE_ID=FROM_SITE) , CONVERT(DATE, '''+@p_plan_start_yyyymmdd+''', 112)), 23) AS SHIP_FROZEN '   +CHAR(10); END
			ELSE
				BEGIN SET @mEXEC = @mEXEC+' 			, CONVERT(CHAR(10),DATEADD(DAY, (SELECT ISNULL(SHIP_FROZEN, 0) AS SHIP_FROZEN FROM SCM_MST_SITE WHERE DIVISION_ID= origin_from_division_id AND SCM_SITE_ID=FROM_SITE) , CONVERT(DATE, '''+@p_plan_start_yyyymmdd+''', 112)), 23) AS SHIP_FROZEN '   +CHAR(10); END

			SET @mEXEC = @mEXEC+' 			, measure																						'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, measure_order_no																				'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, measure_label 																				'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			, plan_start_yyyymmdd, plan_type, seq, from_yyyymmdd,to_yyyymmdd								'+CHAR(10);
			SET @mEXEC = @mEXEC+' 			'+@mQry_sum
																							 +CHAR(10);
			--2021/10/05 : UI 속도 개선
			--IF(@v_RSLT_FLAG = 'Y')
			--BEGIN
				SET @mEXEC = @mEXEC+'       FROM #TMP_SCP0009_FNL_RSLT_PLAN  a																'+CHAR(10);
			--END
			--ELSE IF(@v_RSLT_FLAG = 'N')
			--BEGIN
			--	SET @mEXEC = @mEXEC+'       FROM #TMP_SCP0009_PLAN  a																		'+CHAR(10);
			--END
			-- BOD 2단계 개발
			--SET @mEXEC = @mEXEC+'	   GROUP BY key_idx, division_id, biz_type, project_code, item_id,to_site,to_site2,incoterms,  from_site,bod_id ,transport_mode, lt_day,origin_from_division_id, origin_to_division_id, electrode_type, measure,measure_order_no,measure_label ,plan_start_yyyymmdd, plan_type, seq,from_yyyymmdd,to_yyyymmdd'+CHAR(10) ;
			SET @mEXEC = @mEXEC+'	   GROUP BY key_idx, division_id, biz_type, project_code, item_id,to_site,to_site2,incoterms,  from_site,bod_id ,transport_mode, lt_day,origin_from_division_id, origin_to_division_id, electrode_type, measure,measure_order_no,measure_label ,plan_start_yyyymmdd, plan_type, seq,from_yyyymmdd,to_yyyymmdd, BOD_FROM_YYYYMMDD, BOD_TO_YYYYMMDD '+CHAR(10) ;


			SET @mEXEC = @mEXEC+'      ) a																									'+CHAR(10);
			SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN W_ENERGY	 EG  on a.ITEM_ID	= EG.ITEM_ID AND A.DIVISION_ID = '''+@DIV_ENERGY+''' 	'+CHAR(10); -- 20230411 ENERGY / only div = 82 ess
			SET @mEXEC = @mEXEC+'      LEFT OUTER JOIN (SELECT DIVISION_ID																	'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_CODE																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , PROJECT_OWNER																	'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC ) NUMS											'+CHAR(10);
			SET @mEXEC = @mEXEC+'					FROM SCM_MST_PROJECT WITH(NOLOCK)														'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 ) b  on a.PROJECT_CODE	= b.PROJECT_CODE 				'+CHAR(10);

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'				  AND a.DIVISION_ID	= b.DIVISION_ID 				'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'				  AND a.origin_to_division_id = b.DIVISION_ID 				'+CHAR(10);

			SET @mEXEC = @mEXEC+'					 and b.NUMS=1																			'+CHAR(10);
			SET @mEXEC = @mEXEC+'      LEFT JOIN (SELECT c1.DIVISION_ID																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , c1.ITEM_ID																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , c1.ITEM_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , c1.NICK_NAME																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , c1.ITEM_TYPE																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , c2.SEGMENT2 CELL_TYPE															'+CHAR(10);
			SET @mEXEC = @mEXEC+'						 , ROW_NUMBER() OVER ( PARTITION BY c1.DIVISION_ID, c1.ITEM_ID ORDER BY  CASE c1.ITEM_TYPE WHEN ''P'' THEN 999 WHEN ''H'' THEN 888 WHEN ''R'' THEN 777  WHEN ''Q'' THEN 666 ELSE 0 END  DESC ) NUMS																		'+CHAR(10);
			SET @mEXEC = @mEXEC+'					FROM SCM_MST_ITEM_SN c1 WITH(NOLOCK)													'+CHAR(10);
			SET @mEXEC = @mEXEC+'					LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL c2 WITH(NOLOCK)									'+CHAR(10);
			SET @mEXEC = @mEXEC+'					 ON c1.CELL_TYPE = c2.SEGMENT1 															'+CHAR(10);
			SET @mEXEC = @mEXEC+'					 AND c2.LOOKUP_TYPE = ''CELL_TYPE'' 													'+CHAR(10);
			SET @mEXEC = @mEXEC+'				 ) c  on a.item_id=c.item_id																'+CHAR(10);

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'				     and a.division_id=c.division_id																'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'				     and a.origin_to_division_id=c.division_id																'+CHAR(10);
			SET @mEXEC = @mEXEC+'				     and c.nums=1																			'+CHAR(10);

			/*add start jahn1501*/
			IF @p_division_id IN ('40')
			BEGIN
				SET @mEXEC = @mEXEC+'      LEFT JOIN (SELECT DIVISION_ID																		'+CHAR(10);
				SET @mEXEC = @mEXEC+'						 , ITEM_ID																			'+CHAR(10);
				SET @mEXEC = @mEXEC+'						 , FORECAST_INFO_CELL_MODEL CELL_MODEL												'+CHAR(10);
				SET @mEXEC = @mEXEC+'						 , FORECAST_INFO_CELL_PACK_COUNT CELL_PACK_COUNT									'+CHAR(10);
				SET @mEXEC = @mEXEC+'						 , MIN_CAPACITY																		'+CHAR(10);
				SET @mEXEC = @mEXEC+'						 , FORECAST_INFO_SPEC																'+CHAR(10);
				SET @mEXEC = @mEXEC+'						 , FORECAST_INFOR_VERSION															'+CHAR(10);
				SET @mEXEC = @mEXEC+'						 , FORECAST_INFO_SPEC + FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL					'+CHAR(10);
				SET @mEXEC = @mEXEC+'					FROM DM_MST_ITEM_SINGLE_V WITH(NOLOCK)													'+CHAR(10);
				SET @mEXEC = @mEXEC+'				 ) k  on a.item_id=k.item_id																'+CHAR(10);
				SET @mEXEC = @mEXEC+'				     and a.division_id=k.division_id														'+CHAR(10);
			END
			/*end*/
			/********** DEPT NAME START **********/
			SET @mEXEC = @mEXEC+'			LEFT JOIN SCM_MST_SITE d 					'+CHAR(10);
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			BEGIN
				SET @mEXEC = @mEXEC+'			   ON d.division_id	= a.division_id 					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  AND d.SCM_SITE_ID	= a.TO_SITE 					'+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'			   on d.division_id	= a.origin_to_division_id 					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			  and d.scm_site_id	= a.TO_SITE2					'+CHAR(10);
			END
			SET @mEXEC = @mEXEC+'				  AND d.VALID_YN       = ''Y'' 					'+CHAR(10);


			SET @mEXEC = @mEXEC+'			LEFT JOIN SCM_MST_SITE_ITEM e 					'+CHAR(10);
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			BEGIN
				SET @mEXEC = @mEXEC+'			    on e.division_id	= a.division_id 					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			    and e.scm_site_id	= a.TO_SITE					'+CHAR(10);
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC+'			    on e.division_id	= a.origin_to_division_id 					'+CHAR(10);
				SET @mEXEC = @mEXEC+'			    and e.scm_site_id	= a.TO_SITE2					'+CHAR(10);
			END
			SET @mEXEC = @mEXEC+'					and e.project_code	= a.project_code 					'+CHAR(10);
			SET @mEXEC = @mEXEC+'					and e.item_id		= a.item_id 					'+CHAR(10);
			SET @mEXEC = @mEXEC+'					and e.VALID_YN		=''Y'' 					'+CHAR(10);

			SET @mEXEC = @mEXEC+'			LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] f WITH(NOLOCK) 					'+CHAR(10);
			SET @mEXEC = @mEXEC+'				   ON  substring( e.OWNER, 0, case when charindex('','',e.OWNER) = 0 then len(e.OWNER)+1 else charindex('','',e.OWNER) end ) = f.USER_ID 					'+CHAR(10);

			SET @mEXEC = @mEXEC+'			LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] g WITH(NOLOCK) 					'+CHAR(10);
			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC+'				   ON  CASE WHEN a.DIVISION_ID = ''40'' THEN f.DEPT_ID ELSE d.DEPT_ID END  = g.DEPT_ID 					'+CHAR(10);
			ELSE
				SET @mEXEC = @mEXEC+'				   ON  CASE WHEN a.origin_to_division_id = ''40'' THEN f.DEPT_ID ELSE d.DEPT_ID END  = g.DEPT_ID 					'+CHAR(10);

	        IF NOT(@p_team_id  IS NULL   OR  @p_team_id = '')
			BEGIN
			    SET @mEXEC = @mEXEC+ ' WHERE 1=1 					'+CHAR(10);
			    SET @mEXEC = @mEXEC+ [dbo].[FN_SCM_GET_WHERE_SQL]('g.DEPT_ID', 'IN', @p_team_id) +CHAR(10);
			END;

			SET @mEXEC = @mEXEC+'      ORDER BY a.division_id, a.biz_type, a.item_id, a.to_site, project_code, a.incoterms, a.from_site, a.bod_id, a.measure_order_no		'+CHAR(10);


			SET @mEXEC = @mEXEC+' OPTION (HASH GROUP) ; '+CHAR(10);


			---------------------------------------------------------
			--DEBUG QRY 출력
			---------------------------------------------------------
			IF( @debug_mode ='T')
			BEGIN
				DECLARE @POS INT =1;
				SET @POS =1;
				DECLARE @LEN INT =LEN(@mEXEC);
				WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mEXEC,@POS,4000);
					SET @POS = @POS+4000;
				END;
			END;
			---------------------------------------------------------

			EXEC (@mEXEC);
		END;


		PRINT '10. Pivot End '+CONVERT(CHAR(23), GETDATE(), 21);


		--################################################################################################
		-- Return Data 2 - IsEditable, plan_Start_Date
		--################################################################################################
		-- 속도 테스트
	-- Daily 는 parallel 처리로 title 프로시저에서 수정구간, FIX 정보를 조회한다
	-- WEEKLY, MONTHLY 는 parallel 처리하지 TITLE 프로시저도 실행하지 않는다.
	IF @p_bucket IN ( 'WEEKLY', 'MONTHLY' )
	BEGIN
			-- 수정가능여부 구간 조회
		DECLARE @todayLimit date = convert(date , getdate() , 112 );


		SELECT
			'Y' as is_editable
			, plan_name	, plan_seq , plan_type,	CONFIRM_FLAG, plan_start_yyyymmdd, PLAN_STATUS, confirm_yn, plan_type_seq, basis_start_date
			, convert(date , @p_plan_start_yyyymmdd, 112) as plan_start_date
		FROM (
			SELECT
				p.plan_name
				,d.plan_seq
				,d.plan_type
				,vv.CONFIRM_FLAG
				,p.plan_name as plan_start_yyyymmdd
				, d.PLAN_STATUS
				,CASE WHEN ISNULL(d.CONFIRM_FLAG,'')='' THEN 'N' ELSE d.CONFIRM_FLAG END AS confirm_yn
				, case d.plan_type when 'PR' then 0 when 'MA' then 1 when 'SE' then 2 when 'FN' then 3 end plan_type_seq
			FROM scm_mst_plan_detail d
			inner join scm_mst_modeling m on m.modeling_id = d.modeling_id	and m.plan_cycle = 'WEEKLY' and m.division_id = d.division_id	and m.modeling_id = d.modeling_id
			inner join scm_mst_plan p on p.division_id = d.division_id	and p.plan_cycle  = m.plan_cycle and p.plan_id     = d.plan_id
			inner join SCP_PLAN_VERSION_V vv on d.division_id = vv.division_id and d.plan_type   = vv.plan_type	and d.plan_seq    = vv.plan_seq	and p.plan_name   = vv.plan_start_yyyymmdd
			WHERE 1=1
			and d.PLAN_TYPE IN ('PR', 'MA', 'SE', 'FN', 'TE')
			and d.DISPLAY_YN='Y'
			and d.division_id = @p_division_id
			and p.plan_name   = @p_plan_start_yyyymmdd
		) a
		,(SELECT basis_start_date	FROM scm_sys_calendar_m	WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)) b;
		;



		--################################################################################################
		-- Return Data 3 - Fix 컬럼 색상 설정
		--################################################################################################
		/*
		declare @p_item_id nvarchar(100)='ACEN1042I-A1',
		@p_project_code nvarchar(100) ='A15HC2006'
		*/
		-- 05/25
		-- FIX 추가관련
		SELECT
			(a.division_id + a.biz_type + a.project_code  + a.item_id + a.to_site + a.incoterms) as key_idx
			, FIX_ID
			,from_site
			,incoterms
			,bod_id
			,'D_'+yyyymmdd AS yyyymmdd
		from SCP_ANL_SHIPMENT_PLAN_FIX a
		where division_id = @p_division_id
		and biz_type= @p_biz_type
		and a.yyyymmdd >= @p_from_yyyymmdd
		and a.yyyymmdd <= @p_to_yyyymmdd
		--and ( (@p_item_id is null or @p_item_id = '') or a.ITEM_ID LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id		, ',')))
		AND (( @p_item_id		IS NULL OR @p_item_id		='') OR A.ITEM_ID			IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))
		--and ( (@p_project_code is null or @p_item_id = '') or a.ITEM_ID LIKE (SELECT '%' + TOKEN + '%'  FROM DBO.STRING_SPLIT(@p_item_id, ',')))
		AND (( @p_project_code		IS NULL OR @p_item_id		='') OR A.ITEM_ID			IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(@p_item_id, '')))
		order by
			key_idx, division_id, biz_type, item_id, to_site,project_code, incoterms, from_site, bod_id
		;
	END

END
