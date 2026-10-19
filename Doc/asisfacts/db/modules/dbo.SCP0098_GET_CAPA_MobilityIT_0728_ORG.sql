

/*
 * Program ID   : SCP0098_GET_CAPA_MobilityIT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/19   khj79          최초작성 - SCP0049_GET_CAPA 참조 => SCP0013 ,Production Plan Line 참조
 * 2020/08/21   khj79          최초작성 - SCP0049_GET_CAPA 참조 => Line Assign / Operation / LOCATION_GROUP_ROUTE
 * 2023/08/23   vadabi3        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 PIVOT
 * 2023/09/06   vadabi3        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 Version 2 - 조회 대상 개선
 * 2023/12/07   vadabi3        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 속도개선
 * 2023/02/06   vadabi3        E20240207-001060 소형 CAPA 엑셀 다운로드 및 Plant 검색조건 수정 - plant site 조건 검색 미적용 수정
 * 2024/04/01   leejsthira2    오창, 월요일 조건으로 무조건 생산준비율 반영
 ---------------------------------------------------------------------------------------------------------------

	EXEC SCP0098_GET_CAPA_MobilityIT
		 @p_today_yyyymmdd		= '20230901'	
		,@p_from_yyyymmdd		= '20230901'
		,@p_to_yyyymmdd		    = '20241231'
		,@p_division_id			= '40'
		,@p_plant_id			= ''
		,@p_line_id				= 'M2C07'
		,@p_operation_id		= ''
		,@p_model_id			= ''
		,@p_item_id				= ''
		,@p_nick_name			= ''
		,@p_bucket				= 'M'
		,@p_user_id				= 'eunseopark'
		,@debug_mode			= 'T'

		select distinct prod_ready_rate 
		from scp_mst_capa_work 
		where measure = 'NO_WORK' 
		and line_id = 'M2C07'
*/

--CREATE PROCEDURE [dbo].[SCP0098_GET_CAPA_MobilityIT]
CREATE PROCEDURE [dbo].[SCP0098_GET_CAPA_MobilityIT_0728_ORG]
	 @p_today_yyyymmdd		NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd  		NVARCHAR(8)
	,@p_division_id			NVARCHAR(20)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_line_id				NVARCHAR(MAX)
	,@p_operation_id		NVARCHAR(MAX)
	,@p_model_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_nick_name			NVARCHAR(MAX)
	,@p_bucket				NVARCHAR(15)
	,@p_user_id				NVARCHAR(30)
	,@debug_mode			CHAR(1)
AS
BEGIN


	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- #######################################################################
	-- Declare
	-- #######################################################################
	declare @v_program_id nvarchar(max) = 'SCP0098'
	declare @v_sheet_name nvarchar(max) = 'CAPA_SMALL'
	DECLARE @p_factory_id			NVARCHAR(MAX)
	DECLARE @p_today_yyyymm			NVARCHAR(6)
	SELECT @p_today_yyyymm = substring(@p_today_yyyymmdd,1,6)

	IF @p_plant_id = 'ALL'
	SET @p_plant_id = null;

	-- 쿼리 실행용 변수
	DECLARE @MEXEC		NVARCHAR(MAX);

	-- 날짜 조건용 변수 설정
	DECLARE @v_start_day		NVARCHAR(8);	--시작 일자(현재 달)
	DECLARE @v_end_day			NVARCHAR(8);	--마지막 일자
	DECLARE @v_start_month		NVARCHAR(6);	--시작 월(현재월 +1 년)
	DECLARE @v_end_month		NVARCHAR(6);	--마지막 월
	DECLARE @v_start_year		NVARCHAR(4);	--시작 연도(현재년 +1)
	DECLARE @v_end_year			NVARCHAR(4);	--마지막 년도(현재년+3)

	DECLARE @v_check_daily		CHAR(1) = 'N';

	-- #######################################################################
	-- 조회 날짜 설정
	-- #######################################################################
		SET @v_start_month	= CONVERT(NVARCHAR(6), @p_from_yyyymmdd); -- 현재일 
		SET @v_end_month	= CONVERT(NVARCHAR(6), @p_to_yyyymmdd);  -- 조회일자가 기준을 넘을 경우 Y+1 으로 조회

		DECLARE @p_today_yyyymm_firstDay nvarchar(8)
		DECLARE @p_today_yyyymm_firstDay_daily nvarchar(11)
		SELECT @p_today_yyyymm_firstDay = CONCAT(@p_today_yyyymm, '01')
		SELECT @p_today_yyyymm_firstDay_daily = CONCAT('D_', @p_today_yyyymm_firstDay)


	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT '@v_start_day			=' +@v_start_day;
		PRINT '@v_end_day			=' +@v_end_day;
		PRINT '----------------------------------';
		PRINT '@v_start_month		=' +@v_start_month;
		PRINT '@v_end_month			=' +@v_end_month;
		PRINT '----------------------------------';
		PRINT '@v_start_year		=' +@v_start_year;
		PRINT '@v_end_year			=' +@v_end_year;
		PRINT '----------------------------------';
	END;


	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST_YYYYMM') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST_YYYYMM;

	IF OBJECT_ID('TEMPDB..#TMP_LAST') IS NOT NULL
		DROP TABLE #TMP_LAST;;						

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE_DISTINCT') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT;
					
	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD_CALC') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD_CALC;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_PIVOT;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_WORK_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_WORK_PIVOT;;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA_DAY') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA_DAY;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE;
		
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_MEASURE;
		
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_DATA;

	IF OBJECT_ID('TEMPDB..#TARGET_MEASURES') IS NOT NULL
		DROP TABLE #TARGET_MEASURES;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_DATA;

	IF OBJECT_ID('TEMPDB..#TMP_LIST') IS NOT NULL
		DROP TABLE #TMP_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_NO_WORK') IS NOT NULL
		DROP TABLE #TMP_NO_WORK;

	IF OBJECT_ID('TEMPDB..#TMP_PIVOT_RESULT') IS NOT NULL
		DROP TABLE #TMP_PIVOT_RESULT;

	IF OBJECT_ID('TEMPDB..#TMP_OEE') IS NOT NULL
		DROP TABLE #TMP_OEE;

	IF OBJECT_ID('TEMPDB..#TMP_OEE_TERM') IS NOT NULL
		DROP TABLE #TMP_OEE_TERM;

	IF OBJECT_ID('TEMPDB..#TMP_PROD_READY_RATE') IS NOT NULL
		DROP TABLE #TMP_PROD_READY_RATE;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_NOWORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_NOWORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_LOADRATE') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_LOADRATE;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_RAMPUP') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_RAMPUP;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD;
	
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST_YYYYMM') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST_YYYYMM;

	IF OBJECT_ID('TEMPDB..#TMP_LAST') IS NOT NULL
		DROP TABLE #TMP_LAST;;						

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE_DISTINCT') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT;
					
	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD_CALC') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD_CALC;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_PIVOT;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_WORK_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_WORK_PIVOT;;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA_DAY') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA_DAY;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE;
			
    IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_MEASURE;
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_DATA;

	IF OBJECT_ID('TEMPDB..#TARGET_MEASURES') IS NOT NULL
		DROP TABLE #TARGET_MEASURES;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_DATA;

	IF OBJECT_ID('TEMPDB..#TMP_LIST') IS NOT NULL
		DROP TABLE #TMP_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_NO_WORK') IS NOT NULL
		DROP TABLE #TMP_NO_WORK;

	IF OBJECT_ID('TEMPDB..#TMP_PIVOT_RESULT') IS NOT NULL
		DROP TABLE #TMP_PIVOT_RESULT;

	IF OBJECT_ID('TEMPDB..#TMP_OEE') IS NOT NULL
		DROP TABLE #TMP_OEE;

	IF OBJECT_ID('TEMPDB..#TMP_OEE_TERM') IS NOT NULL
		DROP TABLE #TMP_OEE_TERM;

	IF OBJECT_ID('TEMPDB..#TMP_PROD_READY_RATE') IS NOT NULL
		DROP TABLE #TMP_PROD_READY_RATE;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_NOWORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_NOWORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_LOADRATE') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_LOADRATE;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_RAMPUP') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_RAMPUP;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD;				

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST_YYYYMM_TERM') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_NOWORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_NOWORK;

	IF OBJECT_ID('TEMPDB..#TMP_SCM_ITEM_M_SN') IS NOT NULL
		DROP TABLE #TMP_SCM_ITEM_M_SN;


	BEGIN


	-- #######################################################################
	-- W_CAPA_OP_LIST =>   ('A3000','A9000') 로 대체
	-- #######################################################################

		--;WITH W_CAPA_OP_LIST AS
		--(
		--		SELECT DISTINCT  b.segment4 AS OPERATION_ID
		--		  FROM scm_adm_lookup_master_detail     a WITH(NOLOCK)
		--	INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
		--			ON  a.segment1= b.segment1
		--    		AND a.lookup_type = 'LOCATION_GROUP'
		--    		AND a.segment4    = 'Y' -- Capa 공정 여부 
		--		 -- AND a.segment5    = 'N' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
		--    		AND a.valid_yn    = 'Y'
		--    		AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
		--    		AND b.valid_yn    = 'Y'
		--		  --AND b.segment3    = 'Y' -- Capa 세부 공정 여부
		--    		AND a.segment3 != 'E'
		--)


		select *
		INTO  #TMP_SCM_ITEM_M_SN
		from SCM_ITEM_M_SN C WITH (NOLOCK)
		WHERE 1 = 1
		AND C.ITEM_CLASS						= 'ES1901'
		AND C.ACTIVE_FLAG 						= 'Y'


	-- #######################################################################
	-- #TMP_SCP0098_ITEM_LIST_ALL) LOCATION_GROUP_ROUTE
	-- #######################################################################
				SELECT DISTINCT
					   A.DIVISION_ID
					 , A.COMPANY_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.OPERATION_GROUP_ID
					 , A.FACTORY_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , B.ITEM_ID
					 , C.ITEM_CLASS
				INTO #TMP_SCP0098_ITEM_LIST
				FROM (
					SELECT DISTINCT
						   DIVISION_ID
						 , COMPANY_ID
						 , SITE_ID
						 , PLANT_ID
						 , OPERATION_GROUP_ID
						 , FACTORY_ID
						 , OPERATION_ID
						 , LINE_ID
					  FROM SCM_LINE_HIERARCHY_V_SN WITH (NOLOCK)
					  WHERE OPERATION_ID IN ('A3000','A9000')
						AND (( @p_division_id		IS NULL OR @p_division_id		='') OR DIVISION_ID  								IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id		, ',')))
						AND (( @p_plant_id			IS NULL OR @p_plant_id			='') OR concat(PLANT_ID, '-', OPERATION_GROUP_ID)   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id			, ',')))
						AND (( @p_line_id			IS NULL OR @p_line_id			='') OR LINE_ID      								IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_line_id			, ',')))
					 ) A

				LEFT OUTER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B WITH (NOLOCK)
						  ON  1=1
						 AND A.DIVISION_ID 						= B.DIVISION_ID
						 AND A.SITE_ID 							= B.SITE_ID
						 AND A.PLANT_ID 						= B.PLANT_ID
						 AND A.FACTORY_ID 						= B.FACTORY_ID
						 AND A.LINE_ID 							= B.LINE_ID
						 AND A.OPERATION_ID 					= B.OPERATION_ID
						 AND B.MONTH BETWEEN		@v_start_month and @v_end_month
						 AND (( @p_item_id			IS NULL OR @p_item_id			='') OR B.ITEM_ID     			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id			, ',')))
				         AND B.ITEM_ID NOT LIKE 'AJR%'
						 AND B.ITEM_ID IS NOT NULL
				LEFT OUTER JOIN #TMP_SCM_ITEM_M_SN C WITH (NOLOCK)
						  ON 1=1
						 AND B.COMPANY_ID 						= C.COMPANY_ID
						 AND B.DIVISION_ID 						= C.DIVISION_ID
						 AND B.SITE_ID 							= C.SITE_ID
						 AND B.ITEM_ID 							= C.ITEM_ID
						 AND C.ITEM_CLASS						= 'ES1901'
						 AND C.ACTIVE_FLAG 						= 'Y'
						 AND PRIORITY NOT IN ('0','9')
			   WHERE 1=1
				

	IF OBJECT_ID('TEMPDB..#TMP_SCM_ITEM_M_SN') IS NOT NULL
		DROP TABLE #TMP_SCM_ITEM_M_SN;
	-- #######################################################################
	-- #TMP_SCP0098_ITEM_LIST_YYYYMM
	-- #######################################################################
			SELECT A.DIVISION_ID
				  ,A.SITE_ID		
				  ,A.PLANT_ID		
				  ,A.FACTORY_ID	
				  ,A.OPERATION_ID	
				  ,A.LINE_ID		
				  ,A.ITEM_ID		
			      ,B.MONTH AS YYYYMM
			  INTO #TMP_SCP0098_ITEM_LIST_YYYYMM
			  FROM SCM_MST_ITEM_LINE_ASSIGN_SN  B WITH (NOLOCK)
		 INNER JOIN #TMP_SCP0098_ITEM_LIST A   ON A.COMPANY_ID	= B.COMPANY_ID
												AND A.DIVISION_ID	= B.DIVISION_ID
												AND A.SITE_ID		= B.SITE_ID
												AND A.PLANT_ID		= B.PLANT_ID
												AND A.FACTORY_ID	= B.FACTORY_ID
												AND A.OPERATION_ID	= B.OPERATION_ID
												AND A.LINE_ID		= B.LINE_ID
												AND A.ITEM_ID		= B.ITEM_ID
				WHERE B.MONTH between @v_start_month and @v_end_month
			

		IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST_ALL') IS NOT NULL
			DROP TABLE #TMP_SCP0098_ITEM_LIST_ALL;




	-- #######################################################################
	-- #TMP_SCP0098_STD_LINE_DATA) Line List
	-- #######################################################################
		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.COMPANY_ID
			 , A.SITE_ID
			 , A.PLANT_ID
			 , A.FACTORY_ID
			 , A.OPERATION_ID
			 , A.LINE_ID
			 , ISNULL(B.SITE_NAME		   ,'-')   AS SITE_NAME 
			 , ISNULL(B.FACTORY_NAME	   ,'-')   AS FACTORY_NAME 
			 , B.OPERATION_GROUP_ID
			 , ISNULL(B.OPERATION_GROUP	   ,'-')   AS OPERATION_GROUP_NAME 
			 , ISNULL(B.LINE_NAME		   ,'-')   AS LINE_NAME 
			 , ISNULL(B.OPERATION_NAME	   ,'-')   AS OPERATION_NAME 
		  INTO #TMP_SCP0098_STD_LINE_DATA
		  FROM #TMP_SCP0098_ITEM_LIST A
     LEFT JOIN SCM_LINE_HIERARCHY_V_SN B ON A.COMPANY_ID	= B.COMPANY_ID
		                                AND A.DIVISION_ID	= B.DIVISION_ID
										AND A.SITE_ID		= B.SITE_ID
										AND A.PLANT_ID		= B.PLANT_ID
										AND A.FACTORY_ID	= B.FACTORY_ID
										AND A.OPERATION_ID	= B.OPERATION_ID
										AND A.LINE_ID		= B.LINE_ID





	-- #######################################################################
	-- #TMP_SCP0098_STD_ITEM_DATA) Item List
	-- #######################################################################
		SELECT A.DIVISION_ID
			 , A.COMPANY_ID
			 , A.SITE_ID
			 , A.PLANT_ID
			 , A.FACTORY_ID
			 , A.OPERATION_ID
			 , A.LINE_ID
			 , ISNULL(B.SITE_NAME		   ,'-')   AS SITE_NAME 
			 , ISNULL(B.FACTORY_NAME	   ,'-')   AS FACTORY_NAME 
			 , B.OPERATION_GROUP_ID
			 , ISNULL(B.OPERATION_GROUP	   ,'-')   AS OPERATION_GROUP_NAME 
			 , ISNULL(B.LINE_NAME		   ,'-')   AS LINE_NAME 
			 , ISNULL(B.OPERATION_NAME	   ,'-')   AS OPERATION_NAME 	
			 , A.ITEM_ID
			 , ISNULL(dbo.FN_GET_ITEM_NICKNAME(A.division_id, A.item_id) ,'-') as item_name
		  INTO #TMP_SCP0098_STD_ITEM_DATA
		  FROM #TMP_SCP0098_ITEM_LIST A
     LEFT JOIN SCM_LINE_HIERARCHY_V_SN B WITH (NOLOCK) 
	                                     ON A.COMPANY_ID	= B.COMPANY_ID
		                                AND A.DIVISION_ID	= B.DIVISION_ID
										AND A.SITE_ID		= B.SITE_ID
										AND A.PLANT_ID		= B.PLANT_ID
										AND A.FACTORY_ID	= B.FACTORY_ID
										AND A.OPERATION_ID	= B.OPERATION_ID
										AND A.LINE_ID		= B.LINE_ID


		IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST') IS NOT NULL
			DROP TABLE #TMP_SCP0098_ITEM_LIST;

	-- #######################################################################
	-- #TARGET_MEASURES
	-- #######################################################################
		;WITH USER_MEASURES AS 
		(
				--- user별 설정한 조회 대상 measure 
				SELECT UM.COLUMN_NAME		AS MEASURE_UI 
					  ,M.COLUMN_LABEL_NAME	AS MEASURE_NAME 
					  ,UM.SORT_ORDER_NO
				  FROM SCM_MST_TITLESET_USER UM WITH(NOLOCK) 
				 INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
							  ON M.PROGRAM_ID = @v_program_id
							 AND M.SHEET_NAME =@v_sheet_name
							 AND M.VALID_YN = 'Y'
							 AND M.COLUMN_NAME = UM.COLUMN_NAME 
				  WHERE 1=1
					AND UM.USER_ID = @P_USER_ID
					AND UM.PROGRAM_ID = @v_program_id
					AND UM.SHEET_NAME = @v_sheet_name
		)
		,TARGET_MEASURES AS
		 (
				--- user별 설정한 조회 대상 measure 
				SELECT UM.MEASURE_UI
					  ,UM.MEASURE_NAME 
					  ,UM.SORT_ORDER_NO
				  FROM USER_MEASURES UM WITH (NOLOCK)

				UNION ALL
				--- user별 설정한 measure정보가 없을 경우 default measure를 보여준다. 
				SELECT M.COLUMN_NAME		AS MEASURE_UI
					  ,M.COLUMN_LABEL_NAME	AS MEASURE_NAME 
					  ,M.SORT_ORDER_NO
				 FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
				WHERE 1=1
				  AND M.PROGRAM_ID = @v_program_id
				  AND M.SHEET_NAME = @v_sheet_name
				  AND M.VALID_YN   = 'Y'
				  AND M.DEFAULT_FLAG = 'Y'
				  AND NOT EXISTS (SELECT 1
								   FROM USER_MEASURES 
								   WHERE 1=1
								  )
		)
		SELECT TM.MEASURE_UI
			  ,TM.MEASURE_NAME 
			  ,SUBSTRING(TM.MEASURE_UI, 1, CHARINDEX('_', TM.MEASURE_UI)-1)						AS MEASURE_DB 
			  ,SUBSTRING(TM.MEASURE_UI, CHARINDEX('_', TM.MEASURE_UI)+1, LEN(TM.MEASURE_UI) )	AS COL_DIV
			  ,TM.SORT_ORDER_NO
		  INTO #TARGET_MEASURES 
		  FROM TARGET_MEASURES TM


	-- #######################################################################
	-- #TMP_LIST) 
	-- 1) Line / Measure Cross = NO work, Ramp up, Load Rate
	-- 2) ITEM / Measure Cross = Daily Capa
	-- #######################################################################
			  SELECT 
					 T.DIVISION_ID
				   , T.COMPANY_ID
				   , T.SITE_ID AS SCM_SITE
				   , T.SITE_NAME
				   , T.PLANT_ID
				   , T.OPERATION_GROUP_ID
				   , T.FACTORY_ID
				   , T.FACTORY_NAME
				   , T.OPERATION_ID
				   , T.OPERATION_NAME
				   , T.LINE_ID
				   , T.LINE_NAME
				   , M.*
				   , '-' AS ITEM_ID
				   , '-' AS ITEM_NAME
			INTO #TMP_SCP0098_STD_LINE_MEASURE
			FROM #TMP_SCP0098_STD_LINE_DATA T
		 CROSS JOIN #TARGET_MEASURES M
		 WHERE M.MEASURE_UI != 'DAILY_CAPA'



		SELECT 
			   A.DIVISION_ID
			 , A.COMPANY_ID
			 , A.SCM_SITE
			 , A.PLANT_ID
			 , A.FACTORY_ID
			 , A.OPERATION_GROUP_ID
			 , A.OPERATION_ID
			 , A.LINE_ID
			 , A.MEASURE_UI
			 , MAX(SITE_NAME		 )   AS SITE_NAME
			 , MAX(FACTORY_NAME		 )   AS FACTORY_NAME
			 , MAX(LINE_NAME		 )   AS LINE_NAME
			 , MAX(OPERATION_NAME	 )   AS OPERATION_NAME
			 , MAX(MEASURE_NAME) AS MEASURE_NAME
			 , MAX(SORT_ORDER_NO) AS SORT_ORDER_NO
		  INTO #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT
		  FROM #TMP_SCP0098_STD_LINE_MEASURE A
        GROUP BY 	   A.DIVISION_ID
					 , A.COMPANY_ID
					 , A.SCM_SITE
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.OPERATION_GROUP_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.MEASURE_UI










	-- #######################################################################
			  SELECT 
					 T.DIVISION_ID
				   , T.COMPANY_ID
				   , T.SITE_ID AS SCM_SITE
				   , T.SITE_NAME
				   , T.PLANT_ID
				   , T.OPERATION_GROUP_ID
				   , T.FACTORY_ID
				   , T.FACTORY_NAME
				   , T.OPERATION_ID
				   , T.OPERATION_NAME
				   , T.LINE_ID
				   , T.LINE_NAME
				   , M.*
				   , T.ITEM_ID AS ITEM_ID
				   , ISNULL(T.ITEM_NAME,'-') AS ITEM_NAME
				INTO #TMP_SCP0098_STD_ITEM_MEASURE
			   FROM #TMP_SCP0098_STD_ITEM_DATA T
		 CROSS JOIN #TARGET_MEASURES M
		 WHERE M.MEASURE_UI = 'DAILY_CAPA'
		  AND (( @p_nick_name		IS NULL OR @p_nick_name			='') OR item_name  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_nick_name			, ',')))


	/********************************************************************************
	* PROD_READY_RATE
	1, PROD_READY_RATE 변경 가능성 없음으로 추정
	2, TODAY 기준으로 생산준비율 조회
	3, 추후 기간별 생산준비율 관리가 필요할 시 개선 필요
	********************************************************************************/
	-- #######################################################################
	-- #TMP_PROD_READY_RATE 
	-- #######################################################################
	 SELECT   DIVISION_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, CASE WHEN PROD_READY_RATE IS NOT NULL THEN CONVERT(NUMERIC(10,3), PROD_READY_RATE)
			       ELSE PROD_READY_RATE
				   END AS PROD_READY_RATE

		 INTO #TMP_PROD_READY_RATE
	     FROM SCP_MST_CAPA_WORK WITH (NOLOCK)
	    WHERE MEASURE = 'NO_WORK'
		AND YYYYMMDD = @p_today_yyyymm_firstDay



	/********************************************************************************
	* #TMP_MEASURE_CAPA_WORK = ( LINE + NO_WORK, LOAD_RATE, RAMP_UP) 
	********************************************************************************/
		  SELECT W.DIVISION_ID
				,W.PLANT_ID
				,W.FACTORY_ID
				,W.OPERATION_ID
				,W.LINE_ID
				,CONCAT('D_', YYYYMMDD) AS BASIS_YYYYMMDD
				,W.MEASURE
				,CASE 
				 WHEN W.VALUE IS NOT NULL AND MEASURE = 'LOAD_RATE' THEN CONVERT(NUMERIC(13,3), W.VALUE)  
				 WHEN W.VALUE IS NOT NULL AND MEASURE = 'RAMP_UP' THEN CONVERT(NUMERIC(13,3), W.VALUE)  
				 ELSE W.VALUE
				 END AS VALUE
		  INTO #TMP_MEASURE_CAPA_WORK
		  FROM SCP_MST_CAPA_WORK W WITH(NOLOCK)	
	INNER JOIN #TMP_SCP0098_STD_LINE_DATA D  ON W.DIVISION_ID  = D.DIVISION_ID
											and  W.PLANT_ID		= D.PLANT_ID
											and  W.FACTORY_ID	= D.FACTORY_ID
											and  W.OPERATION_ID	= D.OPERATION_ID
											and  W.LINE_ID		= D.LINE_ID		
		WHERE 1 =1  
		and W.YYYYMMDD between @p_from_yyyymmdd and @p_to_yyyymmdd



	--CREATE INDEX IDX_TMP_MEASURE_CAPA_WORK		 ON #TMP_MEASURE_CAPA_WORK		(measure);
	/********************************************************************************
	* #TMP_MEASURE_CAPA_WORK_DAILYCASPA
	********************************************************************************/
	select *  
	INTO #TMP_MEASURE_CAPA_WORK_DAILYCAPA
	FROM #TMP_MEASURE_CAPA_WORK 
	WHERE measure = 'DAILY_CAPA'

	/********************************************************************************
	*#TMP_DAILYCAPA_DAY 
	********************************************************************************/
	select CONCAT('D_', basis_yyyymmdd) AS basis_yyyymmdd
	     , 'DAILY_CAPA' AS MEASURE
		 , substring(BASIS_YYYYMMDD,1,6) AS YYYYMMDD
	INTO #TMP_DAILYCAPA_DAY
	from SCM_SYS_CALENDAR_M
	where basis_yyyymmdd between @p_from_yyyymmdd and @p_to_yyyymmdd
	order by basis_yyyymmdd


	
	/********************************************************************************
	* #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM
	********************************************************************************/
	;WITH W_YYYYMMDD AS
	(
		--SELECT DISTINCT MEASURE
		--    , BASIS_YYYYMMDD 
		--FROM #TMP_MEASURE_CAPA_WORK_DAILYCAPA

		SELECT DISTINCT YYYYMMDD  FROM #TMP_DAILYCAPA_DAY
	)
	,W_ITEM_LIST AS
	(
	   SELECT DISTINCT DIVISION_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ITEM_ID
			FROM #TMP_SCP0098_ITEM_LIST_YYYYMM
	)

	SELECT A.*
		 , W_YYYYMMDD.YYYYMMDD AS YYYYMM
    INTO #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM
	FROM W_ITEM_LIST A
	CROSS JOIN W_YYYYMMDD


	/********************************************************************************
	* #TMP_MEASURE_CAPA
	********************************************************************************/
		  SELECT B.DIVISION_ID
				,B.PLANT_ID
				,B.FACTORY_ID
				,B.OPERATION_ID
				,B.LINE_ID
				,B.ITEM_ID
				,ISNULL(W.YYYYMM, B.YYYYMM) AS YYYYMM
				,CONCAT('M_', ISNULL(W.YYYYMM, B.YYYYMM)) AS BASIS_YYYYMM
				,CASE
				 WHEN W.VALUE IS NOT NULL 
				 THEN CONVERT(NUMERIC(13,0), ISNULL(W.VALUE,0)) 
				 ELSE W.VALUE
				 END AS VALUE
		INTO #TMP_MEASURE_CAPA
		FROM #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM B
	LEFT JOIN SCP_MST_CAPA W WITH(NOLOCK) ON  W.DIVISION_ID	= B.DIVISION_ID
										AND W.PLANT_ID		= B.PLANT_ID
										AND W.FACTORY_ID	= B.FACTORY_ID
										AND W.OPERATION_ID	= B.OPERATION_ID
										AND W.LINE_ID		= B.LINE_ID
										AND W.ITEM_ID		= B.ITEM_ID
										AND W.YYYYMM	    = B.YYYYMM
		WHERE 1 =1  
		and B.YYYYMM between @v_start_month and @v_end_month



    
	/********************************************************************************
	* NO WORK + Next Day
	********************************************************************************/
	SELECT *
	     , concat('D_',CONVERT(CHAR(8), DATEADD(DAY, 1, substring(BASIS_YYYYMMDD,3,8)), 112))  AS BASIS_YYYYMMDD_NEXT 
	INTO #TMP_MEASURE_CAPA_NOWORK
	FROM  #TMP_MEASURE_CAPA_WORK 
	where MEASURE = 'NO_WORK' 
	and value = 1



	/********************************************************************************
	* OEE = Capa/일
	********************************************************************************/
	 ;SELECT   B.DIVISION_ID
			, B.PLANT_ID
			, B.FACTORY_ID
			, B.OPERATION_ID
			, B.LINE_ID
			, B.ITEM_ID
			, B.YYYYMM
			, W.VALUE
		 INTO #TMP_OEE_TERM
		FROM #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM B
	LEFT JOIN SCP_MST_CAPA W WITH(NOLOCK) ON  W.DIVISION_ID	= B.DIVISION_ID
										AND W.PLANT_ID		= B.PLANT_ID
										AND W.FACTORY_ID	= B.FACTORY_ID
										AND W.OPERATION_ID	= B.OPERATION_ID
										AND W.LINE_ID		= B.LINE_ID
										AND W.ITEM_ID		= B.ITEM_ID
										AND W.YYYYMM	    = B.YYYYMM
		WHERE 1 =1  
		and B.YYYYMM between @v_start_month and @v_end_month





	/********************************************************************************
	* Daily Cala Value Calc
	********************************************************************************/
	;WITH W_YYYYMMDD AS
	(
		--SELECT DISTINCT MEASURE
		--    , BASIS_YYYYMMDD 
		--FROM #TMP_MEASURE_CAPA_WORK_DAILYCAPA
		SELECT basis_yyyymmdd,YYYYMMDD, MEASURE FROM #TMP_DAILYCAPA_DAY
	)
	select       A.DIVISION_ID
				,A.PLANT_ID
				,A.FACTORY_ID
				,A.OPERATION_ID
				,A.LINE_ID
				,A.ITEM_ID
				,A.VALUE
	     , W_YYYYMMDD.MEASURE
		 , W_YYYYMMDD.BASIS_YYYYMMDD
    INTO #SCP_MST_CAPA_YYYYMMDD
	FROM #TMP_MEASURE_CAPA A
	CROSS JOIN W_YYYYMMDD
	WHERE  A.YYYYMM  = YYYYMMDD



	ALTER TABLE #SCP_MST_CAPA_YYYYMMDD ADD NO_WORK				NUMERIC(13,2) DEFAULT 0
	ALTER TABLE #SCP_MST_CAPA_YYYYMMDD ADD NO_WORK_NEXTDAY		NUMERIC(13,2) DEFAULT 0
	ALTER TABLE #SCP_MST_CAPA_YYYYMMDD ADD LOAD_RATE			NUMERIC(13,3) DEFAULT 100	-- 가동율
	ALTER TABLE #SCP_MST_CAPA_YYYYMMDD ADD RAMP_UP				NUMERIC(13,3) DEFAULT 1.0	-- Ramp up
	ALTER TABLE #SCP_MST_CAPA_YYYYMMDD ADD PROD_RATE			NUMERIC(13,3) DEFAULT 100	-- 생산준비율
	ALTER TABLE #SCP_MST_CAPA_YYYYMMDD ADD VALUE_CALC			NUMERIC(13,3) DEFAULT 0     -- Capa/일 계산결과

	

		 select *
		 into #TMP_MEASURE_CAPA_WORK_NOWORK
		 froM #TMP_MEASURE_CAPA_WORK
		 WHERE MEASURE = 'NO_WORK'

		select *
		 into #TMP_MEASURE_CAPA_WORK_LOADRATE
		 froM #TMP_MEASURE_CAPA_WORK
		 WHERE MEASURE = 'LOAD_RATE'

		select *
		 into #TMP_MEASURE_CAPA_WORK_RAMPUP
		 froM #TMP_MEASURE_CAPA_WORK
		 WHERE MEASURE = 'RAMP_UP'


	CREATE INDEX IDX_MEASURE_CAPA_WORK_NOWORK		 ON #TMP_MEASURE_CAPA_WORK_NOWORK		(DIVISION_ID,PLANT_ID,FACTORY_ID,OPERATION_ID,LINE_ID,BASIS_YYYYMMDD);
	CREATE INDEX IDX_MEASURE_CAPA_WORK_LOADRATE		 ON #TMP_MEASURE_CAPA_WORK_LOADRATE		(DIVISION_ID,PLANT_ID,FACTORY_ID,OPERATION_ID,LINE_ID,BASIS_YYYYMMDD);
	CREATE INDEX IDX_MEASURE_CAPA_WORK_RAMPUP		 ON #TMP_MEASURE_CAPA_WORK_RAMPUP		(DIVISION_ID,PLANT_ID,FACTORY_ID,OPERATION_ID,LINE_ID,BASIS_YYYYMMDD);
	CREATE INDEX IDX_SCP_MST_CAPA_YYYYMMDD			 ON #SCP_MST_CAPA_YYYYMMDD (DIVISION_ID,PLANT_ID,FACTORY_ID,OPERATION_ID,LINE_ID,BASIS_YYYYMMDD);
	



		--------------------------------------------------------------------
			;UPDATE #SCP_MST_CAPA_YYYYMMDD 
			SET #SCP_MST_CAPA_YYYYMMDD.NO_WORK = CA.VALUE
			FROM #SCP_MST_CAPA_YYYYMMDD A, 
				#TMP_MEASURE_CAPA_WORK_NOWORK CA
			WHERE  A.DIVISION_ID= CA.DIVISION_ID
			and  A.PLANT_ID		= CA.PLANT_ID
			and  A.FACTORY_ID	= CA.FACTORY_ID
			and  A.OPERATION_ID	= CA.OPERATION_ID
			and  A.LINE_ID		= CA.LINE_ID
			and  A.BASIS_YYYYMMDD= CA.BASIS_YYYYMMDD

		--------------------------------------------------------------------
			;UPDATE #SCP_MST_CAPA_YYYYMMDD 
			SET #SCP_MST_CAPA_YYYYMMDD.LOAD_RATE = CA.VALUE
			FROM #SCP_MST_CAPA_YYYYMMDD A, 
				#TMP_MEASURE_CAPA_WORK_LOADRATE CA
			WHERE  A.DIVISION_ID	= CA.DIVISION_ID
			and  A.PLANT_ID		= CA.PLANT_ID
			and  A.FACTORY_ID	= CA.FACTORY_ID
			and  A.OPERATION_ID	= CA.OPERATION_ID
			and  A.LINE_ID		= CA.LINE_ID
			and  A.BASIS_YYYYMMDD= CA.BASIS_YYYYMMDD


			--------------------------------------------------------------------
			;UPDATE #SCP_MST_CAPA_YYYYMMDD 
			SET #SCP_MST_CAPA_YYYYMMDD.RAMP_UP = CA.VALUE
			FROM #SCP_MST_CAPA_YYYYMMDD A, 
				#TMP_MEASURE_CAPA_WORK_RAMPUP CA
			WHERE  A.DIVISION_ID= CA.DIVISION_ID
			and  A.PLANT_ID		= CA.PLANT_ID
			and  A.FACTORY_ID	= CA.FACTORY_ID
			and  A.OPERATION_ID	= CA.OPERATION_ID
			and  A.LINE_ID		= CA.LINE_ID
			and  A.BASIS_YYYYMMDD= CA.BASIS_YYYYMMDD


			--------------------------------------------------------------------
			-- PROD_RATE 기간으로 관리 안함 +  변경 가능성 없음
		
			;UPDATE #SCP_MST_CAPA_YYYYMMDD 
			SET #SCP_MST_CAPA_YYYYMMDD.PROD_RATE = CA.PROD_READY_RATE
			FROM #SCP_MST_CAPA_YYYYMMDD A, 
				#TMP_PROD_READY_RATE CA
			WHERE  A.DIVISION_ID= CA.DIVISION_ID
			and  A.PLANT_ID		= CA.PLANT_ID
			and  A.FACTORY_ID	= CA.FACTORY_ID
			and  A.OPERATION_ID	= CA.OPERATION_ID
			and  A.LINE_ID		= CA.LINE_ID


			--------------------------------------------------------------------
			-- NO_WORK_NEXTDAY
			;UPDATE #SCP_MST_CAPA_YYYYMMDD 
			SET #SCP_MST_CAPA_YYYYMMDD.NO_WORK_NEXTDAY = 1
			FROM #SCP_MST_CAPA_YYYYMMDD A, 
				#TMP_MEASURE_CAPA_NOWORK CA
			WHERE  A.DIVISION_ID= CA.DIVISION_ID
			and  A.PLANT_ID		= CA.PLANT_ID
			and  A.FACTORY_ID	= CA.FACTORY_ID
			and  A.OPERATION_ID	= CA.OPERATION_ID
			and  A.LINE_ID		= CA.LINE_ID
			and  A.BASIS_YYYYMMDD= CA.BASIS_YYYYMMDD_NEXT


			--------------------------------------------------------------------
/*
			UPDATE #SCP_MST_CAPA_YYYYMMDD 
			SET VALUE_CALC  = CASE WHEN NO_WORK = 1 THEN 0
								   WHEN NO_WORK_NEXTDAY = 1 
								   THEN ISNULL(VALUE,0) * ISNULL(LOAD_RATE/100, 1) * ISNULL(RAMP_UP, 1)  * ISNULL(PROD_RATE/100, 1)
								   ELSE ISNULL(VALUE,0) * ISNULL(LOAD_RATE/100, 1) * ISNULL(RAMP_UP, 1)
								   END
*/
			 -- 오창, 월요일 조건으로 무조건 생산준비율 반영... 20240401
			UPDATE A 
			SET VALUE_CALC  = CASE WHEN NO_WORK = 1 THEN 0
								   WHEN NO_WORK_NEXTDAY = 1 THEN ISNULL(VALUE,0) * ISNULL(LOAD_RATE/100, 1) * ISNULL(RAMP_UP, 1)  * ISNULL(PROD_RATE/100, 1)
								   WHEN C.SITE_ID = 'A001' AND B.DAYOFWEEK = 'MON' THEN ISNULL(VALUE,0) * ISNULL(LOAD_RATE/100, 1) * ISNULL(RAMP_UP, 1)  * ISNULL(PROD_RATE/100, 1)
								   ELSE ISNULL(VALUE,0) * ISNULL(LOAD_RATE/100, 1) * ISNULL(RAMP_UP, 1)
								   END
			FROM #SCP_MST_CAPA_YYYYMMDD A, SCM_SYS_CALENDAR_M B, (
				SELECT FACTORY_ID, MAX(SITE_ID) AS SITE_ID
				FROM   SCM_MST_FACTORY_SN
				GROUP BY FACTORY_ID
			) C
			WHERE  1=1
			AND    RIGHT(A.BASIS_YYYYMMDD,8) = B.BASIS_YYYYMMDD
			AND    A.FACTORY_ID = C.FACTORY_ID


			--------------------------------------------------------------------
			select       A.DIVISION_ID
						,A.PLANT_ID
						,A.FACTORY_ID
						,A.OPERATION_ID
						,A.LINE_ID
						,A.ITEM_ID
						,VALUE_CALC AS VALUE
						, MEASURE
						, BASIS_YYYYMMDD
			INTO #SCP_MST_CAPA_YYYYMMDD_CALC
			FROM #SCP_MST_CAPA_YYYYMMDD A




			IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD') IS NOT NULL
				DROP TABLE #SCP_MST_CAPA_YYYYMMDD;

			--CREATE INDEX IDX_SCP_MST_CAPA_YYYYMMDD_CALC ON #SCP_MST_CAPA_YYYYMMDD_CALC (DIVISION_ID,PLANT_ID,FACTORY_ID,OPERATION_ID,LINE_ID,BASIS_YYYYMMDD,MEASURE);


	-- #######################################################################
	-- PIVOIT Column 처리
	-- #######################################################################
		DECLARE @mQry_field					NVARCHAR(MAX) = '';
		--DECLARE @mQry_field_clac			NVARCHAR(MAX) = '';
		DECLARE @mQry_field_capa			NVARCHAR(MAX) = '';
		DECLARE @mQry_field_last			NVARCHAR(MAX) = '';
		--DECLARE @mQry_field_group			NVARCHAR(MAX) = '';
		DECLARE @mQry_field_prodReady		NVARCHAR(MAX) = '';
		DECLARE @mQry_field_prodReadyValue  NVARCHAR(MAX) = '';
		DECLARE @mQry_field_prodReadyValueNull  NVARCHAR(MAX) = '';


		SELECT DATA.*
		INTO #TMP_FIELD
		FROM
		(
					SELECT  'M_'+A.BASIS_YYYYMM  AS YYYYMMDD,
							MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
					  FROM  [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
					 WHERE  A.BASIS_YYYYMMDD  BETWEEN  @p_from_yyyymmdd AND @p_to_yyyymmdd
				  GROUP BY  A.BASIS_YYYYMM, A.MONTH_NAME
				  -----------------------------------------------------------------------------
					UNION ALL
				  SELECT  CONCAT('W_',A.BASIS_YYYYMM, A.ISO_WEEK) AS YYYYMMDD
				         ,CONCAT(A.BASIS_START_DATE, CONVERT(CHAR(2), 21)) AS SORT_ORDER_NO
					FROM  [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
				   WHERE  A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			    GROUP BY  A.BASIS_YYYYMM
				        , A.ISO_WEEK
						, A.BASIS_START_DATE
				  -----------------------------------------------------------------------------
				  UNION ALL
					SELECT  'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD,
							A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
					FROM    [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
					WHERE   A.BASIS_YYYYMMDD  BETWEEN  @p_from_yyyymmdd AND @p_to_yyyymmdd
					GROUP BY A.BASIS_YYYYMMDD
		) AS DATA

		CREATE INDEX IDX_TMP_FIELD ON #TMP_FIELD (sort_order_no);
		CREATE INDEX IDX2_TMP_FIELD ON #TMP_FIELD (YYYYMMDD);

		SELECT  @mQry_field    = @mQry_field + ',' + yyyymmdd + CHAR(10)
		FROM    #TMP_FIELD AS A
		WHERE YYYYMMDD LIKE 'D_%'
		ORDER BY sort_order_no;

		--SELECT  @mQry_field_clac    = @mQry_field_clac + ', (  SELECT MAX(CONVERT(NUMERIC(13,2), VALUE_CALC)) 
		--														 FROM #SCP_MST_CAPA_YYYYMMDD
		--														WHERE DIVISION_ID	= A.DIVISION_ID
		--														 and  PLANT_ID		= A.PLANT_ID
		--														 and  FACTORY_ID	= A.FACTORY_ID
		--														 and  OPERATION_ID	= A.OPERATION_ID
		--														 and  LINE_ID		= A.LINE_ID
		--														 and  ITEM_ID		= A.ITEM_ID
		--														 and  BASIS_YYYYMMDD= '+yyyymmdd+'
		--														 )  as ' + yyyymmdd + CHAR(10)
	 --   FROM    #TMP_FIELD AS A
		--WHERE YYYYMMDD LIKE 'D_%'
		--ORDER BY sort_order_no;



		SELECT  @mQry_field_capa    = @mQry_field_capa + ',   0 as ' + yyyymmdd + CHAR(10)
		FROM    #TMP_FIELD AS A
		WHERE YYYYMMDD LIKE 'D_%'
		ORDER BY sort_order_no;


		SELECT  @mQry_field_last    = @mQry_field_last + ',  CASE 
		                                                     WHEN MEASURE_UI = ''NO_WORK'' AND '+yyyymmdd+' = 1 THEN ''Y'' 
															 WHEN MEASURE_UI = ''NO_WORK'' AND '+yyyymmdd+' != 1 THEN '''' 
															 ELSE CONVERT(NVARCHAR(MAX), '+yyyymmdd+') 
															 END as ' + yyyymmdd + CHAR(10)
		FROM    #TMP_FIELD AS A
		WHERE YYYYMMDD LIKE 'D_%'
		ORDER BY sort_order_no;

		--SELECT  @mQry_field_group    = @mQry_field_group + ',  MAX('+yyyymmdd+') as ' + yyyymmdd + CHAR(10)
		--FROM    #TMP_FIELD AS A
		--WHERE YYYYMMDD LIKE 'D_%'
		--ORDER BY sort_order_no;

		SELECT  @mQry_field_prodReady    = @mQry_field_prodReady + ', CASE 
																    WHEN MEASURE_UI = ''DAILY_CAPA''  
																	THEN (SELECT MAX(VALUE) 
																			FROM #TMP_OEE_TERM
																		   WHERE DIVISION_ID	= A.DIVISION_ID
																			and  PLANT_ID		= A.PLANT_ID
																			and  FACTORY_ID		= A.FACTORY_ID
																			and  OPERATION_ID	= A.OPERATION_ID
																			and  LINE_ID		= A.LINE_ID
																			and  ITEM_ID		= A.ITEM_ID
																			and  YYYYMM  		= REPLACE(''' + yyyymmdd + ''', ''M_'',''''))
																	ELSE NULL 
																	END AS ' + yyyymmdd + CHAR(10)

		FROM    #TMP_FIELD AS A
		WHERE YYYYMMDD LIKE 'M_%'
		ORDER BY sort_order_no;

		IF OBJECT_ID('TEMPDB..#TMP_FIELD') IS NOT NULL
		drop table #TMP_FIELD;


	/********************************************************************************
	* PIVOIT NO_WORK
	********************************************************************************/
		--CREATE INDEX IDX_SCP_MST_CAPA_YYYYMMDD				ON #SCP_MST_CAPA_YYYYMMDD_CALC				(DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MEASURE);
		--CREATE INDEX IDX_TMP_SCP0098_STD_ITEM_MEASURE		ON #TMP_SCP0098_STD_ITEM_MEASURE		    (DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MEASURE_UI);
		--CREATE INDEX IDX_TMP_MEASURE_CAPA_WORK				ON #TMP_MEASURE_CAPA_WORK					(DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, MEASURE);
		--CREATE INDEX IDX_SCP0098_STD_LINE_MEASURE_DISTINCT	ON #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT	(DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, MEASURE_UI);

		CREATE INDEX IDX2_TMP_MEASURE_CAPA_WORK			    ON #TMP_MEASURE_CAPA_WORK				    (BASIS_YYYYMMDD);
		CREATE INDEX IDX2_SCP_MST_CAPA_YYYYMMDD				ON #SCP_MST_CAPA_YYYYMMDD_CALC				(BASIS_YYYYMMDD);



			SET @mQry_field = RIGHT(@mQry_field, LEN(@mQry_field)-1);
			--SET @mQry_field_clac = RIGHT(@mQry_field_clac, LEN(@mQry_field_clac)-1);
			SET @mQry_field_capa = RIGHT(@mQry_field_capa, LEN(@mQry_field_capa)-1);
			SET @mQry_field_last = RIGHT(@mQry_field_last, LEN(@mQry_field_last)-1);
			--SET @mQry_field_group = RIGHT(@mQry_field_group, LEN(@mQry_field_group)-1);
			SET @mQry_field_prodReady = RIGHT(@mQry_field_prodReady, LEN(@mQry_field_prodReady)-1);

			--print @mQry_field
			SET @mEXEC       = '';
            SET @mEXEC = N'
					;--------------------------------------------------------------------------
					;SELECT DISTINCT 
							a.DIVISION_ID 
				  		   ,a.PLANT_ID 
				  		   ,a.FACTORY_ID 
				  		   ,a.OPERATION_ID 
				  		   ,a.LINE_ID  
				  		   ,a.MEASURE AS MEASURE_UI
						   --------------------------------
						   , CONVERT(nvarchar(max), '' '') as ITEM_ID
						   , CONVERT(nvarchar(max), '' '') as ITEM_NAME
						   , L.FACTORY_NAME
						   , L.LINE_NAME
						   , L.MEASURE_NAME
						   , L.SORT_ORDER_NO
						   --------------------------------
						   ,' + @mQry_field + '
					 INTO #TMP_CAPA_WORK_PIVOT
					 FROM #TMP_MEASURE_CAPA_WORK A
					 PIVOT ( 
							 MAX(VALUE) FOR  BASIS_YYYYMMDD  IN ('+ @mQry_field +') 
						   ) AS A
					INNER JOIN #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT L  ON A.DIVISION_ID	= L.DIVISION_ID
																		AND A.PLANT_ID		= L.PLANT_ID
																		AND A.FACTORY_ID	= L.FACTORY_ID
																		AND A.OPERATION_ID	= L.OPERATION_ID
																		AND A.LINE_ID		= L.LINE_ID
																		AND A.MEASURE		= L.MEASURE_UI



					;DROP TABLE #TMP_MEASURE_CAPA_WORK
					;DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT
					;--------------------------------------------------------------------------
					;SELECT DISTINCT
							a.DIVISION_ID 
				  		   ,a.PLANT_ID 
				  		   ,a.FACTORY_ID 
				  		   ,a.OPERATION_ID 
				  		   ,a.LINE_ID  
				  		   ,a.MEASURE AS MEASURE_UI
						   --------------------------------
						   , A.ITEM_ID
						   , L.ITEM_NAME
						   , L.FACTORY_NAME
						   , L.LINE_NAME
						   , L.MEASURE_NAME
						   , L.SORT_ORDER_NO
						   --------------------------------
						   ,' + @mQry_field + '
					INTO #TMP_CAPA_PIVOT
					 FROM #SCP_MST_CAPA_YYYYMMDD_CALC A
					 PIVOT ( 
							 MAX(VALUE) FOR  BASIS_YYYYMMDD  IN ('+ @mQry_field +') 
						   ) AS A
					INNER JOIN #TMP_SCP0098_STD_ITEM_MEASURE L  ON A.DIVISION_ID	= L.DIVISION_ID
																		AND A.PLANT_ID		= L.PLANT_ID
																		AND A.FACTORY_ID	= L.FACTORY_ID
																		AND A.OPERATION_ID	= L.OPERATION_ID
																		AND A.LINE_ID		= L.LINE_ID
																		AND A.ITEM_ID		= L.ITEM_ID
																	    AND A.MEASURE		= L.MEASURE_UI
                
			





				;DROP TABLE #SCP_MST_CAPA_YYYYMMDD_CALC;
				;--------------------------------------------------------------------------
				;SELECT DIVISION_ID 
				  	, PLANT_ID 
				  	, FACTORY_ID 
				  	, OPERATION_ID 
				  	, LINE_ID  
				  	, MEASURE_UI
					, ITEM_ID
					, ITEM_NAME
					, FACTORY_NAME
					, LINE_NAME
					, MEASURE_NAME
					, SORT_ORDER_NO
					,' + @mQry_field + '
					, (SELECT MAX(PROD_READY_RATE) 
						FROM #TMP_PROD_READY_RATE 
						WHERE DIVISION_ID	= DATA.DIVISION_ID
						and  PLANT_ID		= DATA.PLANT_ID
						and  FACTORY_ID		= DATA.FACTORY_ID
						and  OPERATION_ID	= DATA.OPERATION_ID
						and  LINE_ID		= DATA.LINE_ID
						) AS PRODUCT_READY
				 INTO #TMP_LAST
				 FROM
				 (
					 select * 
					 from #TMP_CAPA_PIVOT A
					 union all
					 select * 
					 from #TMP_CAPA_WORK_PIVOT where MEASURE_UI != ''DAILY_CAPA''
				 ) DATA




				;DROP TABLE #TMP_CAPA_PIVOT;
				;DROP TABLE #TMP_CAPA_WORK_PIVOT;
				;--------------------------------------------------------------------------
				; SELECT
					  DIVISION_ID 
				  	, PLANT_ID 
				  	, FACTORY_ID 
				  	, OPERATION_ID 
				  	, LINE_ID  
				  	, MEASURE_UI
					, ITEM_ID
					, ITEM_NAME
					, FACTORY_NAME
					, LINE_NAME
					, MEASURE_NAME
					, SORT_ORDER_NO
					,' + @mQry_field_prodReady + '
					,' + @mQry_field_last + '
					, PRODUCT_READY
				  FROM #TMP_LAST A
			  ORDER BY DIVISION_ID 
				  			, PLANT_ID 
				  			, FACTORY_ID 
				  			, OPERATION_ID 
				  			, LINE_ID  
				  			, SORT_ORDER_NO
							, ITEM_ID

				;DROP TABLE #TMP_LAST;
				;--------------------------------------------------------------------------
				';

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

			EXEC (@mEXEC);

	END

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST_YYYYMM') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST_YYYYMM;

	IF OBJECT_ID('TEMPDB..#TMP_LAST') IS NOT NULL
		DROP TABLE #TMP_LAST;;						

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE_DISTINCT') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT;
					
	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD_CALC') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD_CALC;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_PIVOT;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_WORK_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_WORK_PIVOT;;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA_DAY') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA_DAY;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE;
		
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_MEASURE;
		
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_DATA;

	IF OBJECT_ID('TEMPDB..#TARGET_MEASURES') IS NOT NULL
		DROP TABLE #TARGET_MEASURES;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_DATA;

	IF OBJECT_ID('TEMPDB..#TMP_LIST') IS NOT NULL
		DROP TABLE #TMP_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_NO_WORK') IS NOT NULL
		DROP TABLE #TMP_NO_WORK;

	IF OBJECT_ID('TEMPDB..#TMP_PIVOT_RESULT') IS NOT NULL
		DROP TABLE #TMP_PIVOT_RESULT;

	IF OBJECT_ID('TEMPDB..#TMP_OEE') IS NOT NULL
		DROP TABLE #TMP_OEE;

	IF OBJECT_ID('TEMPDB..#TMP_OEE_TERM') IS NOT NULL
		DROP TABLE #TMP_OEE_TERM;

	IF OBJECT_ID('TEMPDB..#TMP_PROD_READY_RATE') IS NOT NULL
		DROP TABLE #TMP_PROD_READY_RATE;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_NOWORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_NOWORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_LOADRATE') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_LOADRATE;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_RAMPUP') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_RAMPUP;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD;
	
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST_YYYYMM') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST_YYYYMM;

	IF OBJECT_ID('TEMPDB..#TMP_LAST') IS NOT NULL
		DROP TABLE #TMP_LAST;;						

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE_DISTINCT') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE_DISTINCT;
					
	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD_CALC') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD_CALC;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_PIVOT;

	IF OBJECT_ID('TEMPDB..#TMP_CAPA_WORK_PIVOT') IS NOT NULL
		DROP TABLE #TMP_CAPA_WORK_PIVOT;;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA_DAY') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA_DAY;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_MEASURE;
			
    IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_MEASURE;
	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_LINE_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_LINE_DATA;

	IF OBJECT_ID('TEMPDB..#TARGET_MEASURES') IS NOT NULL
		DROP TABLE #TARGET_MEASURES;

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_STD_ITEM_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0098_STD_ITEM_DATA;

	IF OBJECT_ID('TEMPDB..#TMP_LIST') IS NOT NULL
		DROP TABLE #TMP_LIST;

	IF OBJECT_ID('TEMPDB..#TMP_NO_WORK') IS NOT NULL
		DROP TABLE #TMP_NO_WORK;

	IF OBJECT_ID('TEMPDB..#TMP_PIVOT_RESULT') IS NOT NULL
		DROP TABLE #TMP_PIVOT_RESULT;

	IF OBJECT_ID('TEMPDB..#TMP_OEE') IS NOT NULL
		DROP TABLE #TMP_OEE;

	IF OBJECT_ID('TEMPDB..#TMP_OEE_TERM') IS NOT NULL
		DROP TABLE #TMP_OEE_TERM;

	IF OBJECT_ID('TEMPDB..#TMP_PROD_READY_RATE') IS NOT NULL
		DROP TABLE #TMP_PROD_READY_RATE;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_NOWORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_NOWORK;	

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_LOADRATE') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_LOADRATE;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_WORK_RAMPUP') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_WORK_RAMPUP;

	IF OBJECT_ID('TEMPDB..#TMP_DAILYCAPA') IS NOT NULL
		DROP TABLE #TMP_DAILYCAPA;

	IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_YYYYMMDD') IS NOT NULL
		DROP TABLE #SCP_MST_CAPA_YYYYMMDD;				

	IF OBJECT_ID('TEMPDB..#TMP_SCP0098_ITEM_LIST_YYYYMM_TERM') IS NOT NULL
		DROP TABLE #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA;

	IF OBJECT_ID('TEMPDB..#TMP_MEASURE_CAPA_NOWORK') IS NOT NULL
		DROP TABLE #TMP_MEASURE_CAPA_NOWORK;
END


