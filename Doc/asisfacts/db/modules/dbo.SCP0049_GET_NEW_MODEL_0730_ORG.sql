


/*
 * Program ID   : SCP0049_GET_NEW_MODEL
 * Description  : Master Data Management New Model 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/08/13   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2020/10/13   khj79          PRIORITY 수정
 * 2021/03/17	khj79		   operation 전부 조회도록 수정 (ex> FLOW_ID : E2000E2300E3000E4000 )
 * 2021/06/17	khj79		   Pilot L38 라인할당 요청의 건
 * 2021/07/08   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 2년(24+5) 조회 변경
 * 2021/07/20   KMJ            [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 하위 ITEM 조회 수정
 * 2023/06/16	LJS			   활성화 코드 구분 처리

 DECLARE	 @p_today_yyyymmdd		NVARCHAR(8) = '20200813'
	,@p_division_id			NVARCHAR(20) = '81'
	,@p_plant_id			NVARCHAR(MAX) = 'A040'
	,@p_group_id			NVARCHAR(MAX) = 'A'
	,@p_factory_id			NVARCHAR(MAX) = 'A1'
	,@p_line_id				NVARCHAR(MAX) = ''
	,@p_operation_id		NVARCHAR(MAX) = ''
	,@p_model_id			NVARCHAR(30) = 'ACEN1063I-A3'
	,@p_item_id				NVARCHAR(30) = 'ACEN1063I-A3'
	,@p_nick_name			NVARCHAR(30) = ''
	,@debug_mode			CHAR(1) = ''

 */

CREATE PROCEDURE [dbo].[SCP0049_GET_NEW_MODEL_0730_ORG]
	 @p_today_yyyymmdd		NVARCHAR(8)
	,@p_division_id			NVARCHAR(20)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_group_id			NVARCHAR(20)
	,@p_factory_id			NVARCHAR(MAX)
	,@p_line_id				NVARCHAR(MAX)
	,@p_operation_id		NVARCHAR(MAX)
	,@p_model_id			NVARCHAR(30)
	,@p_item_id				NVARCHAR(30)
	,@p_nick_name			NVARCHAR(30)
	,@debug_mode			CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @p_start_month		NVARCHAR(6);	--시작 월(현재월 +1 년)
	DECLARE @p_end_month		NVARCHAR(6);	--마지막 월

	DECLARE @p_year				NVARCHAR(4);

	-- 쿼리 실행용 변수
	DECLARE @MEXEC				NVARCHAR(MAX);
	DECLARE @MQRY_SUM			NVARCHAR(MAX);

	SET @p_start_month = SUBSTRING(@p_today_yyyymmdd,1,6);
	SET @p_end_month   = CONVERT(NVARCHAR(6) , DATEADD(MM,41 , @p_today_yyyymmdd )  , 112);  -- 2년(24+5) 조회 변경(12 -> 24)

	SET @p_year = CONVERT(NVARCHAR(4) , DATEADD(YY,1 , @p_today_yyyymmdd )  , 112);

	DECLARE @VAR_p_plant_id		NVARCHAR(1000)	= @p_plant_id ;
	DECLARE @VAR_p_factory_id   NVARCHAR(1000)  = @p_factory_id;
	DECLARE @VAR_p_line_id		NVARCHAR(MAX)	= @p_line_id;
	DECLARE @VAR_p_operation_id	NVARCHAR(1000)	= @p_operation_id;
																	 
	DECLARE @arr_plant_id		NVARCHAR(1000)	= '';
	DECLARE @arr_factory_id		NVARCHAR(1000)  = '';
	DECLARE @arr_line_id		NVARCHAR(MAX)	= '';
	DECLARE @arr_operation_id	NVARCHAR(1000)	= '';

	DECLARE @VAR_damMixer NVARCHAR(100)	= ''; -- [E20240711-001442]신규 공정(DAM Slurry Mixing) 개발로 인한 FP WO 생성 기능 개발 요청 건

	SELECT @arr_plant_id		= ISNULL(@arr_plant_id		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_p_plant_id,',')
	SELECT @arr_factory_id		= ISNULL(@arr_factory_id	+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_p_factory_id,',')
	SELECT @arr_line_id			= ISNULL(@arr_line_id		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_p_line_id,',')
	SELECT @arr_operation_id	= ISNULL(@arr_operation_id	+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@VAR_p_operation_id,',')

	SET @arr_plant_id		= RIGHT(@arr_plant_id,		LEN(@arr_plant_id)		-1);
	SET @arr_factory_id		= RIGHT(@arr_factory_id,	LEN(@arr_factory_id)	-1);
	SET @arr_line_id		= RIGHT(@arr_line_id,		LEN(@arr_line_id)		-1);
	SET @arr_operation_id	= RIGHT(@arr_operation_id,	LEN(@arr_operation_id)	-1);

	-- [E20240711-001442]신규 공정(DAM Slurry Mixing) 개발로 인한 FP WO 생성 기능 개발 요청 건
	-- dam mixer 공정에 대한 예외 조건 추가
	if CHARINDEX('E0430', @p_operation_id) != 0
	begin
		set @VAR_damMixer = ' OR A.OPERATION_ID = ''E1000'' '
	end

	-- 조회
	BEGIN

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_NEW_MODEL') IS NOT NULL
			DROP TABLE #TMP_SCP0049_NEW_MODEL;


		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_NEW_MODEL_MONTH') IS NOT NULL
			DROP TABLE #TMP_SCP0049_NEW_MODEL_MONTH;

		CREATE TABLE #TMP_SCP0049_NEW_MODEL_MONTH
		(
		    COMPANY_ID			NVARCHAR(30)
		  , COMPANY_NAME		NVARCHAR(150)
		  , DIVISION_ID			NVARCHAR(30)
		  , DIVISION_NAME		NVARCHAR(200)
		  , SITE_ID				NVARCHAR(30)
		  , SITE_NAME			NVARCHAR(150)
		  , PLANT_ID			NVARCHAR(30)
		  , PLANT_NAME			NVARCHAR(150)
		  , OPERATION_GROUP_ID	NVARCHAR(1)
		  , OPERATION_GROUP		NVARCHAR(40)
		  , FACTORY_ID			NVARCHAR(30)
		  , FACTORY_NAME		NVARCHAR(150)
		  , OPERATION_ID		NVARCHAR(30)
		  , OPERATION_NAME		NVARCHAR(150)
		  , LINE_ID				NVARCHAR(30)
		  , LINE_NAME			NVARCHAR(150)
		  , ELECTRODE_TYPE		NVARCHAR(50)
		  , ITEM_ID				NVARCHAR(50)
		  , NICK_NAME 			NVARCHAR(50)
		  , YYYYMM				NVARCHAR(6)
		  , ITEM_CLASS			NVARCHAR(50) -- 활성화 코드 구분 처리... 20230616
		)
		;

		BEGIN -- #TMP_SCP0049_NEW_MODEL_MONTH 생성

		SET @MEXEC = '';
		SET @MEXEC = @MEXEC + '	INSERT INTO #TMP_SCP0049_NEW_MODEL_MONTH'								+CHAR(10);
		SET @MEXEC = @MEXEC + '	SELECT DISTINCT'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		A.COMPANY_ID'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.COMPANY_NAME'													+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.DIVISION_ID'													+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.DIVISION_NAME'													+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.SITE_ID'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.SITE_NAME'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.PLANT_ID'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.PLANT_NAME'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.OPERATION_GROUP_ID'												+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.OPERATION_GROUP'												+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.FACTORY_ID'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.FACTORY_NAME'													+CHAR(10);
		-- [E20240711-001442]신규 공정(DAM Slurry Mixing) 개발로 인한 FP WO 생성 기능 개발 요청 건
		--SET @MEXEC = @MEXEC + '		, A.OPERATION_ID'													+CHAR(10);
		--SET @MEXEC = @MEXEC + '		, A.OPERATION_NAME'													+CHAR(10);
		SET @MEXEC = @MEXEC + '		, (CASE WHEN B.ITEM_CLASS IN (''ES0109'') THEN ''E0430'' ELSE A.OPERATION_ID END) AS OPERATION_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC + '		, (CASE WHEN B.ITEM_CLASS IN (''ES0109'') THEN ''Dam Mixing'' ELSE A.OPERATION_NAME END) AS OPERATION_NAME ' +CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.LINE_ID'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.LINE_NAME'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, A.ELECTRODE_TYPE'													+CHAR(10);
		SET @MEXEC = @MEXEC + '		, B.ITEM_ID'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, B.NICK_NAME'														+CHAR(10);
		SET @MEXEC = @MEXEC + '		, C.YYYYMM'															+CHAR(10);
		SET @MEXEC = @MEXEC + '		, B.ITEM_CLASS ' +CHAR(10); -- 활성화 코드 구분 처리... 20230616
		SET @MEXEC = @MEXEC + '	FROM SCM_LINE_HIERARCHY_V_SN A WITH(NOLOCK)'							+CHAR(10);
		SET @MEXEC = @MEXEC + '	JOIN SCM_ITEM_M_SN B WITH(NOLOCK)'										+CHAR(10);
		SET @MEXEC = @MEXEC + '	ON A.DIVISION_ID	= B.DIVISION_ID'									+CHAR(10);
		SET @MEXEC = @MEXEC + '	AND A.SITE_ID		= B.SITE_ID'										+CHAR(10);
		SET @MEXEC = @MEXEC + '	AND ( CHARINDEX(  A.OPERATION_ID ,B.FLOW_ID ,  0 )  > 0' 				+CHAR(10);
		SET @MEXEC = @MEXEC + '			OR CHARINDEX(  A.OPERATION_ID ,B.FORMATION_FLOW_ID ,  0 )  > 0' +CHAR(10);
		SET @MEXEC = @MEXEC + '		)'																	+CHAR(10);		
		
		SET @MEXEC = @MEXEC + '	JOIN TH_UIS_CAL_SN C WITH(NOLOCK)'										+CHAR(10);
		SET @MEXEC = @MEXEC + '	ON 1=1' 																+CHAR(10);
		
		IF NOT(@p_model_id IS NULL OR @p_model_id = '')
			BEGIN -- MODEL 조회

			SET @MEXEC = @MEXEC + ' INNER  JOIN SCM_MODEL_COMP_TEMP_SN BO WITH(NOLOCK)  -- SCM_BOM_M -> SCM_MODEL_COMP_TEMP 테이블 수정: 하위 ITEM 조회 대응'+CHAR(10);
			SET @MEXEC = @MEXEC + '	ON (A.DIVISION_ID	= BO.DIVISION_ID	OR A.DIVISION_ID	= BO.CHILD_DIVISION_ID)'							  +CHAR(10);
			SET @MEXEC = @MEXEC + '	AND (A.SITE_ID		= BO.SITE_ID		OR A.SITE_ID		= BO.CHILD_SITE_ID)'								  +CHAR(10);
			SET @MEXEC = @MEXEC + '	AND (A.PLANT_ID		= BO.PLANT_ID		OR A.PLANT_ID		= BO.CHILD_PLANT_ID)'								  +CHAR(10);
			SET @MEXEC = @MEXEC + '	AND B.ITEM_ID		= BO.PARENT_ITEM_ID'

			SET @MEXEC = @MEXEC + '	WHERE 1=1'															+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND C.DAY = ''01'''													+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND B.ACTIVE_FLAG = ''Y'''											+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND C.YYYYMM >= '''+@p_start_month+''''								+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND C.YYYYMM <= '''+@p_end_month+''''								+CHAR(10);

			IF NOT(@p_division_id		IS NULL		OR  @p_division_id  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.DIVISION_ID	= '''+@p_division_id+''' )					   '+CHAR(10); END;

			IF NOT(@VAR_P_PLANT_ID		IS NULL		OR  @VAR_P_PLANT_ID  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.PLANT_ID		IN ('+@arr_plant_id  +') )					'+CHAR(10); END;

			IF NOT(@VAR_P_FACTORY_ID	IS NULL		OR  @VAR_P_FACTORY_ID  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.FACTORY_ID	IN ('+@arr_factory_id+') )					'+CHAR(10); END;
			
			SET @MEXEC = @MEXEC + '	   AND ( BO.MODEL_ID	LIKE ''%' + @p_model_id + '%'')            '+CHAR(10); 

			IF NOT(@P_NICK_NAME			IS NULL		OR  @P_NICK_NAME  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( B.NICK_NAME     LIKE ''%' + @p_nick_name+ '%'')			'+CHAR(10); END;
			
			IF NOT(@VAR_P_LINE_ID		IS NULL		OR  @VAR_P_LINE_ID  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.LINE_ID		IN ('+@arr_line_id	+') )					'+CHAR(10); END;

			IF NOT(@VAR_P_OPERATION_ID	IS NULL		OR  @VAR_P_OPERATION_ID  ='') 
			--BEGIN SET @MEXEC = @MEXEC+'AND ( A.OPERATION_ID	IN ('+@arr_operation_id +') )				'+CHAR(10);
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.OPERATION_ID		IN ('+@arr_operation_id +')' + @VAR_damMixer + ' ) '+CHAR(10); -- -- [E20240711-001442]신규 공정(DAM Slurry Mixing) 개발로 인한 FP WO 생성 기능 개발 요청 건
			END;

			IF NOT(@p_group_id		IS NULL		OR  @p_group_id  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.OPERATION_GROUP_ID= '''+@p_group_id+''' )					 '+CHAR(10); END;

			END;

		ELSE
			BEGIN -- ITEM 조회

			SET @MEXEC = @MEXEC + '	JOIN SCM_MST_BOM_ENG_SN BO WITH(NOLOCK)  -- SCM_BOM_M ( Pilot L38 라인할당 요청의 건 )'+CHAR(10);
			SET @MEXEC = @MEXEC + '	 ON A.DIVISION_ID	= BO.DIVISION_ID'												   +CHAR(10);
			SET @MEXEC = @MEXEC + '	AND A.SITE_ID		= BO.SITE_ID'													   +CHAR(10);
			SET @MEXEC = @MEXEC + '	AND A.PLANT_ID		= BO.PLANT_ID'													   +CHAR(10);
			SET @MEXEC = @MEXEC + '	AND B.ITEM_ID		= BO.PARENT_ITEM_ID'											   +CHAR(10);

			SET @MEXEC = @MEXEC + '	WHERE 1=1'																+CHAR(10);	
			SET @MEXEC = @MEXEC + '	AND C.DAY = ''01'''														+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND B.ACTIVE_FLAG = ''Y'''												+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND BO.ACTIVE_FLAG = ''Y'''												+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND BO.EFF_END_DATE >= GETDATE()'										+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND C.YYYYMM >= '''+@p_start_month+''''									+CHAR(10);
			SET @MEXEC = @MEXEC + '	AND C.YYYYMM <= '''+@p_end_month+''''									+CHAR(10);

			IF NOT(@p_division_id		IS NULL		OR  @p_division_id  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.DIVISION_ID		= '''+@p_division_id+''' )						'+CHAR(10); END;

			IF NOT(@VAR_P_PLANT_ID		IS NULL		OR  @VAR_P_PLANT_ID  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.PLANT_ID			IN ('+@arr_plant_id  +') )					'+CHAR(10); END;

			IF NOT(@VAR_P_FACTORY_ID	IS NULL		OR  @VAR_P_FACTORY_ID  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.FACTORY_ID		IN ('+@arr_factory_id+') )					'+CHAR(10); END;
			
			SET @MEXEC = @MEXEC + '	   AND ( B.ITEM_ID			LIKE ''%' + @p_item_id + '%'')				'+CHAR(10); 

			IF NOT(@P_NICK_NAME			IS NULL		OR  @P_NICK_NAME  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( B.NICK_NAME		LIKE ''%' + @p_nick_name+ '%'')			'+CHAR(10); END;
			
			IF NOT(@VAR_P_LINE_ID		IS NULL		OR  @VAR_P_LINE_ID  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.LINE_ID			IN ('+@arr_line_id	+') )					'+CHAR(10); END;

			IF NOT(@VAR_P_OPERATION_ID	IS NULL		OR  @VAR_P_OPERATION_ID  ='') 
			--BEGIN SET @MEXEC = @MEXEC+'AND ( A.OPERATION_ID		IN ('+@arr_operation_id +') )				'+CHAR(10);
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.OPERATION_ID		IN ('+@arr_operation_id +')' + @VAR_damMixer + ' ) '+CHAR(10); -- -- [E20240711-001442]신규 공정(DAM Slurry Mixing) 개발로 인한 FP WO 생성 기능 개발 요청 건
			END;

			IF NOT(@p_group_id		IS NULL		OR  @p_group_id  ='') 
			BEGIN SET @MEXEC = @MEXEC+'AND ( A.OPERATION_GROUP_ID= '''+@p_group_id+''')						'+CHAR(10); END;


			END;


		EXEC(@MEXEC);
		
		-----------------------------------------------------------
		-- DEBUG QRY 출력
		-----------------------------------------------------------	
		IF( @debug_mode ='T')
		BEGIN				
			SELECT @MEXEC AS QUERY
			DECLARE @POS INT =1;
			DECLARE @LEN INT =LEN(@MEXEC);
			WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@MEXEC,@POS,4000);
				SET @POS = @POS+4000;
			END;
		END;

			/*
			--- site 별 처리에서 인스턴스 별 처리로 변경하여 주석처리... 20230725
			--* A9000, F6000 공정 활성화 코드 구분 관련 item 정리 :: 8월 해외 확장시 국내 로직 제거 및 해외 로직에 site 조건 제거 필요!! ... 20230616
			-- 1) 국내 : A9000,F6000 의 cell assy 를 남기고 cell product 를 지운다.
			SET @MEXEC = '';
			SET @MEXEC += 'DELETE FROM #TMP_SCP0049_NEW_MODEL_MONTH ' + char(10)
			SET @MEXEC += 'WHERE  1=1 ' + char(10)
			SET @MEXEC += 'AND    OPERATION_ID IN (''A9000'',''A3000'',''F6000'') ' + char(10)
			             --AND    SITE_ID = 'A001'
			SET @MEXEC += 'AND    SITE_ID IN ( SELECT B.SEGMENT1 AS SITE_ID FROM SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK) WHERE  B.ACTIVE_FLAG = ''Y'' AND B.LOOKUP_TYPE_CODE = ''CELL_PRODUCT_ASSY'' ) ' + char(10)
			SET @MEXEC += 'AND    ITEM_CLASS != ''ES1901'' ' + char(10)
			SET @MEXEC += '; ' + char(10)
			
			EXEC(@MEXEC);

			-- 2) 해외 : A9000,F6000 의 cell assy 를 지우고 cell product 를 남긴다.
			SET @MEXEC = '';
			SET @MEXEC += 'DELETE FROM #TMP_SCP0049_NEW_MODEL_MONTH ' + char(10)
			SET @MEXEC += 'WHERE  1=1 ' + char(10)
			SET @MEXEC += 'AND    OPERATION_ID IN (''A9000'',''A3000'',''F6000'') ' + char(10)
			             --AND    SITE_ID != 'A001'
			SET @MEXEC += 'AND    SITE_ID NOT IN ( SELECT B.SEGMENT1 AS SITE_ID FROM SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK) WHERE  B.ACTIVE_FLAG = ''Y'' AND B.LOOKUP_TYPE_CODE = ''CELL_PRODUCT_ASSY'' ) ' + char(10)
			SET @MEXEC += 'AND    ITEM_CLASS = ''ES1901'' ' + char(10)
			SET @MEXEC += '; ' + char(10)

			EXEC(@MEXEC);
			*/

			/*
			---- 로직 통일화에 따라서 cell assy 만 남는걸로 통일... 20230809
			--- site 별 처리에서 인스턴스 별 처리로 변경... 20230725
			-- 1. cell assy 유효 : A9000,F6000 의 cell assy 를 남기고 cell product 를 지운다.
			SET @MEXEC = '';
			SET @MEXEC += 'DELETE FROM #TMP_SCP0049_NEW_MODEL_MONTH ' + char(10)
			SET @MEXEC += 'FROM ( ' + char(10)
			SET @MEXEC += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SET @MEXEC += '	FROM   FP_INSTANCE_LINE_V_SN A WITH(NOLOCK) ' + char(10)
			SET @MEXEC += '	WHERE  1=1 ' + char(10)
			SET @MEXEC += '	AND    A.INSTANCE_ID IN ( ' + char(10)
			SET @MEXEC += '		SELECT AA.SEGMENT1 AS INSTNACE_ID ' + char(10)
			SET @MEXEC += '		FROM   SCM_SYS_LOOKUP_VALUE_SN AA WITH(NOLOCK) ' + char(10)
			SET @MEXEC += '		WHERE  AA.LOOKUP_TYPE_CODE = ''CELL_PRODUCT_ASSY_INSTANCE'' ' + char(10)
			SET @MEXEC += '		AND    AA.ATTRIBUTE1  = ''Y'' ' + char(10)
			SET @MEXEC += '		AND    AA.ACTIVE_FLAG = ''Y'' ' + char(10)
			SET @MEXEC += '	) ' + char(10)
			SET @MEXEC += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SET @MEXEC += ') B ' + char(10)
			SET @MEXEC += 'WHERE  1=1 ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.SITE_ID        = B.SITE_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.PLANT_ID       = B.PLANT_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.FACTORY_ID     = B.FACTORY_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.OPERATION_ID   = B.OPERATION_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.LINE_ID        = B.LINE_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.OPERATION_ID IN (''A9000'',''A3000'',''F6000'') ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.ITEM_CLASS != ''ES1901'' ' + char(10)
			SET @MEXEC += '; ' + char(10)

			EXEC(@MEXEC);

			-- 2. cell product 유효 : A9000,F6000 의 cell product 를 남기고 cell assy 를 지운다.
			SET @MEXEC = '';
			SET @MEXEC += 'DELETE FROM #TMP_SCP0049_NEW_MODEL_MONTH ' + char(10)
			SET @MEXEC += 'FROM ( ' + char(10)
			SET @MEXEC += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SET @MEXEC += '	FROM   FP_INSTANCE_LINE_V_SN A WITH(NOLOCK) ' + char(10)
			SET @MEXEC += '	WHERE  1=1 ' + char(10)
			SET @MEXEC += '	AND    A.INSTANCE_ID NOT IN ( ' + char(10)
			SET @MEXEC += '		SELECT AA.SEGMENT1 AS INSTNACE_ID ' + char(10)
			SET @MEXEC += '		FROM   SCM_SYS_LOOKUP_VALUE_SN AA WITH(NOLOCK) ' + char(10)
			SET @MEXEC += '		WHERE  AA.LOOKUP_TYPE_CODE = ''CELL_PRODUCT_ASSY_INSTANCE'' ' + char(10)
			SET @MEXEC += '		AND    AA.ATTRIBUTE1  = ''Y'' ' + char(10)
			SET @MEXEC += '		AND    AA.ACTIVE_FLAG = ''Y'' ' + char(10)
			SET @MEXEC += '	) ' + char(10)
			SET @MEXEC += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SET @MEXEC += ') B ' + char(10)
			SET @MEXEC += 'WHERE  1=1 ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.SITE_ID        = B.SITE_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.PLANT_ID       = B.PLANT_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.FACTORY_ID     = B.FACTORY_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.OPERATION_ID   = B.OPERATION_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.LINE_ID        = B.LINE_ID ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.OPERATION_ID IN (''A9000'',''A3000'',''F6000'') ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.ITEM_CLASS = ''ES1901'' ' + char(10)
			SET @MEXEC += '; ' + char(10)

			EXEC(@MEXEC);
			*/

			---- 로직 통일화에 따라서 cell assy 만 남는걸로 통일... 20230809
			-- 1. cell assy 유효 : A9000,F6000 의 cell assy 를 남기고 cell product 를 지운다.
			SET @MEXEC = '';
			SET @MEXEC += 'DELETE FROM #TMP_SCP0049_NEW_MODEL_MONTH ' + char(10)
			SET @MEXEC += 'WHERE  1=1 ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.OPERATION_ID IN (''A9000'',''A3000'',''F6000'') ' + char(10)
			SET @MEXEC += 'AND    #TMP_SCP0049_NEW_MODEL_MONTH.ITEM_CLASS != ''ES1901'' ' + char(10)
			SET @MEXEC += '; ' + char(10)

			EXEC(@MEXEC);


		END; -- #TMP_SCP0049_NEW_MODEL_MONTH 생성




		SELECT A.COMPANY_ID
			 , A.COMPANY_NAME
			 , A.DIVISION_ID
			 , A.DIVISION_NAME
			 , A.SITE_ID
			 , A.SITE_NAME
			 , A.PLANT_ID
			 , A.PLANT_NAME
			 , A.OPERATION_GROUP_ID
			 , A.OPERATION_GROUP
			 , A.FACTORY_ID
			 , A.FACTORY_NAME
			 , A.OPERATION_ID
			 , A.OPERATION_NAME
			 , A.LINE_ID
			 , A.LINE_NAME
			 , A.ELECTRODE_TYPE
			 , A.ITEM_ID
			 , A.NICK_NAME
			 , 'M_' + A.YYYYMM		AS YYYYMM
			 , ISNULL(CONVERT(INT,B.LANE_QTY),0) AS LANE_QTY
			 , CONVERT(NUMERIC(20,10),B.PRIORITY) AS PRIORITY
			 , C.USER_ID_1
			 , C.USER_ID_2
			 , C.USER_ID_3
			 , C.USER_ID_4
			 , C.USER_ID_5
			 , C.USER_ID_6
			 , C.USER_ID_7
			 , C.USER_ID_8
			 , C.USER_ID_9
			 , C.USER_ID_10
		  INTO #TMP_SCP0049_NEW_MODEL
		  FROM #TMP_SCP0049_NEW_MODEL_MONTH A
		  LEFT OUTER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B WITH(NOLOCK)
		    ON 1 = 1
		   AND A.COMPANY_ID		= B.COMPANY_ID
		   AND A.DIVISION_ID	= B.DIVISION_ID
		   AND A.SITE_ID		= B.SITE_ID
		   AND A.PLANT_ID		= B.PLANT_ID
		   AND A.FACTORY_ID		= B.FACTORY_ID
		   AND A.ITEM_ID		= B.ITEM_ID
		   AND A.OPERATION_ID	= B.OPERATION_ID
		   AND A.LINE_ID		= B.LINE_ID
		   AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
		   AND A.YYYYMM			= B.MONTH
		   --AND A.ITEM_ID		= 'ACEN1063I-A3'

		  LEFT OUTER JOIN SCM_MASTER_MANAGER_M_SN C WITH(NOLOCK)
		    ON A.COMPANY_ID		= C.COMPANY_ID
		   AND A.DIVISION_ID	= C.DIVISION_ID
		   AND A.SITE_ID		= C.SITE_ID
		   AND A.PLANT_ID		= C.PLANT_ID
		   AND A.FACTORY_ID		= C.FACTORY_ID
		   AND A.OPERATION_ID	= C.OPERATION_ID
		   AND A.LINE_ID		= C.LINE_ID
		   AND A.ELECTRODE_TYPE	= C.ELECTRODE_TYPE
		   AND C.LOSS_CODE		= 'LA001'

		   
		   LEFT OUTER JOIN (SELECT	
								--DISTINCT A.*, B.LINE_ID, B.ELECTRODE_TYPE , B.OPERATION_ID
								DISTINCT A.COMPANY_ID
										, A.DIVISION_ID
										, A.SITE_ID
										, A.PLANT_ID
										, A.FACTORY_ID
										, A.ITEM_ID
										, B.LINE_ID, B.ELECTRODE_TYPE , B.OPERATION_ID , A.LANE_QTY
								FROM	SCM_ITEM_LANE_M_SN A,
										SCM_LINE_M_SN B
								WHERE	1=1
								AND		A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE
								AND		A.COMPANY_ID = B.COMPANY_ID
								AND		A.DIVISION_ID = B.DIVISION_ID
								AND		A.SITE_ID = B.SITE_ID
								AND		A.FACTORY_ID = B.FACTORY_ID
								AND		A.ACTIVE_FLAG = 'Y') T
		   ON A.COMPANY_ID		= T.COMPANY_ID
		   AND A.DIVISION_ID	= T.DIVISION_ID
		   AND A.SITE_ID		= T.SITE_ID
		   AND A.PLANT_ID		= T.PLANT_ID
		   AND A.FACTORY_ID		= T.FACTORY_ID
		   AND A.ITEM_ID =		T.ITEM_ID
		   AND A.LINE_ID		= T.LINE_ID
		   AND A.ELECTRODE_TYPE = T.ELECTRODE_TYPE
		   AND A.OPERATION_ID	= T.OPERATION_ID
		   ;

	END  -- 조회


	-- /////////////////////////// PIVOT 처리를 위한 SUM QUERY 생성
	BEGIN
		SET @MQRY_SUM = '';
			
		SELECT @MQRY_SUM = @MQRY_SUM+','+  CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN A.YYYYMM = RIGHT('''+YYYYMMDD+''',8)  THEN PRIORITY ELSE 0 END ) AS ' + YYYYMMDD
												WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN A.YYYYMM = RIGHT('''+YYYYMMDD+''',6)  THEN PRIORITY ELSE 0 END ) AS ' + YYYYMMDD
									END +''+  CHAR(10)
		 FROM ( 
				SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
					 , CONVERT(CHAR(2), '20') + MIN(A.BASIS_START_DATE)  AS SORT_ORDER_NO
				  FROM [DBO].[SCM_SYS_CALENDAR_M] A
				 WHERE A.BASIS_YYYYMM  >= @p_start_month
				   AND A.BASIS_YYYYMM  <= @p_end_month
				 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME

				  UNION ALL
				-- 쿼리를 위한 DUMMY
				 SELECT 'Y_' + A.CALENDAR_YYYY 
					 , CONVERT(CHAR(2), '30') + MIN(A.BASIS_END_DATE)   AS SORT_ORDER_NO
				  FROM [DBO].[SCM_SYS_CALENDAR_M] A
				 WHERE A.CALENDAR_YYYY  >= @p_year
				   AND A.CALENDAR_YYYY  <= @p_year
				   GROUP BY A.CALENDAR_YYYY

				) AS A
		ORDER BY SORT_ORDER_NO;
	END  -- PIVOT 처리를 위한 SUM QUERY 생성

	--PIVOT 쿼리
	BEGIN

		--IF OBJECT_ID('TEMPDB..##TMP_SCP0049_NEW_MODEL_LAST') IS NOT NULL
		--	DROP TABLE ##TMP_SCP0049_NEW_MODEL_LAST;
		-- LANE_QTY 는 전극인 경우만 보여지며 값은 동일하다.
		SET @MEXEC = '';
		SET @MEXEC = @MEXEC+'		SELECT														' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   A.DIVISION_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.COMPANY_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.SITE_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.PLANT_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.FACTORY_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.OPERATION_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.ITEM_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.NICK_NAME											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , MAX(A.LANE_QTY) AS LANE_QTY							' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.LINE_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.LINE_NAME											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.ELECTRODE_TYPE										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_1											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_2											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_3											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_4											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_5											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_6											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_7											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_8											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_9											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , A.USER_ID_10											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			' + @MQRY_SUM											  + CHAR(10);
		--SET @MEXEC = @MEXEC+'		  INTO ##TMP_SCP0049_NEW_MODEL_LAST							' + CHAR(10);
		SET @MEXEC = @MEXEC+'		  FROM #TMP_SCP0049_NEW_MODEL A								' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 GROUP BY A.DIVISION_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.COMPANY_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.SITE_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.PLANT_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.FACTORY_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.OPERATION_GROUP_ID								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.OPERATION_ID									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.ITEM_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.NICK_NAME										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.LINE_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.LINE_NAME										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.ELECTRODE_TYPE									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_1										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_2										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_3										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_4										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_5										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_6										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_7										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_8										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_9										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.USER_ID_10										' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 ORDER BY A.DIVISION_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.SITE_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.PLANT_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.FACTORY_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.LINE_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.OPERATION_ID	DESC							' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.ITEM_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.NICK_NAME										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, A.ELECTRODE_TYPE									' + CHAR(10);
		


		EXEC(@MEXEC);

	END -- PIVOT 쿼리

END  -- 종료

-- ///////////////////////////////////////// 확인 
-- SELECT * FROM #TMP_SCP0049_NEW_MODEL

-- SELECT * FROM ##TMP_SCP0049_NEW_MODEL_LAST A ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, A.NICK_NAME, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE	

