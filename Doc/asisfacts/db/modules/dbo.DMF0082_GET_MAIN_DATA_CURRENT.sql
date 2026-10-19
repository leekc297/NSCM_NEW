
/*=====================================================================================================================================================
 * Program ID  : DMF0082_GET_MAIN_DATA_CURRENT                                                 
 * Description : Procedure 작성 가이드                                                             
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *=====================================================================================================================================================
 * Date				In Charge    Description                                                            
 *=====================================================================================================================================================
 * 2026.01.09		park.choyi	Initial Release 

EXEC DMF0082_GET_MAIN_DATA_CURRENT '40','ALL','ALL','ALL','20260101','20260731','ALL','','Current','Y','park.choyi','ADMIN'
*===================================================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0082_GET_MAIN_DATA_CURRENT]
	  @p_division_id    NVARCHAR(30)
	, @p_team_id        NVARCHAR(4000)
	, @p_customer       NVARCHAR(4000)
	, @p_biz_type       NVARCHAR(4000)
	, @p_from_yyyymmdd  NVARCHAR(8)
	, @p_to_yyyymmdd    NVARCHAR(8)
	, @p_scm_site_id    NVARCHAR(4000)
	, @p_item_id        NVARCHAR(4000)
	, @p_version_type   NVARCHAR(4000)
	, @p_qty_yn		  NVARCHAR(1)
	, @p_created_by	  NVARCHAR(50)
	, @p_user_group     NVARCHAR(50)
AS  

BEGIN
    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	--=============================================================================================================================
	-- LOG 용 변수 설정	(START) -- [E20250915-000105]_로그를 찍기위해서 LOG용 변수 추가 (START)
	--=============================================================================================================================
    DECLARE @v_program_name			NVARCHAR(150) = 'DMF0082_GET_MAIN_DATA_CURRENT';
    DECLARE @v_log_type				NVARCHAR(30);
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;	
	--=============================================================================================================================
	-- LOG 용 변수 설정	(END)  -- [E20250915-000105]_로그를 찍기위해서 LOG용 변수 추가 (END)
	--=============================================================================================================================	
PRINT @v_program_name + ' : A001--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'DMF0082_GET_MAIN_DATA_CURRENT 조회쿼리 시작';
	--=============================================================================================================================
	-- 사용자 컬럼 및 메저 세팅 관련 변수 (START)
	--=============================================================================================================================
	DECLARE @V_USER_COL_CNT	INT;
	DECLARE @V_USER_MEA_CNT	INT;
	DECLARE @VA_PROGRAM_ID	NVARCHAR(50)
	DECLARE @VA_SHEET_NAME	NVARCHAR(50)
	SET		@VA_PROGRAM_ID = 'DMF0082'
	SET		@VA_SHEET_NAME = 'FcstNPrice' 
	--=============================================================================================================================
	-- 사용자 컬럼 및 메저 세팅 관련 변수 (END)
	--=============================================================================================================================	
	--=============================================================================================================================
	-- 시작 LOG (START)  -- [E20250915-000105]_로그를 찍기위해서 LOG 추가 (START)
	--=============================================================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
	SET @v_description	= '';
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_created_by;
	--=============================================================================================================================
	-- 시작 LOG (END)  -- [E20250915-000105]_로그를 찍기위해서 LOG 추가 (END)
	--=============================================================================================================================
	--=============================================================================================================================
	-- 사용자 컬럼 및 메저 세팅 시작 (START)
	--=============================================================================================================================
PRINT @v_program_name + ' : A002--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'사용자 컬럼 처리 (START)';
	-------------------------------------------------------------------------------------------------------------------------------
	-- 사용자 컬럼 처리 (START)
	-------------------------------------------------------------------------------------------------------------------------------
    SELECT @V_USER_COL_CNT = COUNT(*)
	  FROM SCM_MST_TITLESET_USER U WITH(NOLOCK)
	 WHERE 1 = 1
	   AND U.PROGRAM_ID		= @VA_PROGRAM_ID
	   AND U.SHEET_NAME		= @VA_SHEET_NAME
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	   AND U.USER_ID		= @p_created_by;
		
	IF @V_USER_COL_CNT = 0
	BEGIN
	    INSERT INTO SCM_MST_TITLESET_USER
		( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
		, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
		, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
		SELECT @p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'C', C.COLUMN_NAME
			 , C.SORT_ORDER_NO, 'N', '', @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
			 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
		  FROM SCM_MST_SHEET_COLUMNS C WITH(NOLOCK)
		 WHERE 1 = 1
		   AND C.PROGRAM_ID		= @VA_PROGRAM_ID
		   AND C.SHEET_NAME		= @VA_SHEET_NAME
		   AND C.DEFAULT_FLAG	= 'Y'
		   AND C.VALID_YN		= 'Y'	;
	END;	 
	-------------------------------------------------------------------------------------------------------------------------------
	-- 사용자 컬럼 처리 (END)
	-------------------------------------------------------------------------------------------------------------------------------	
PRINT @v_program_name + ' : A002--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'사용자 컬럼 처리 (END)';
PRINT @v_program_name + ' : A003--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'사용자 메저 처리 (START)';
	-------------------------------------------------------------------------------------------------------------------------------
	-- 사용자 메저 처리 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	SELECT @V_USER_MEA_CNT = COUNT(*)
	  FROM SCM_MST_TITLESET_USER U WITH(NOLOCK)
	 WHERE 1 = 1
	   AND U.PROGRAM_ID		= @VA_PROGRAM_ID
	   AND U.SHEET_NAME		= @VA_SHEET_NAME
	   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	   AND U.USER_ID		= @p_created_by;

	IF @V_USER_MEA_CNT = 0
	BEGIN	    
		INSERT INTO SCM_MST_TITLESET_USER
		( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
		, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
		, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
		SELECT @p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME
			 , C.SORT_ORDER_NO, 'N', '', @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
			 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
		  FROM SCM_MST_SHEET_MEASURE C WITH(NOLOCK)
		 WHERE 1 = 1
		   AND C.PROGRAM_ID  = @VA_PROGRAM_ID
		   AND C.SHEET_NAME  = @VA_SHEET_NAME
		   AND C.DEFAULT_FLAG = 'Y'
		   AND C.VALID_YN     = 'Y'	;			
	END; 
	-------------------------------------------------------------------------------------------------------------------------------
	-- 사용자 메저 처리 (END)
	-------------------------------------------------------------------------------------------------------------------------------	
	--=============================================================================================================================
	-- 사용자 컬럼 및 메저 세팅 시작 (END)
	--=============================================================================================================================
PRINT @v_program_name + ' : A003--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'사용자 메저 처리 (END)';		
PRINT @v_program_name + ' : A004--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'BUCKET ▶ @V_PV_COL_LIST , @V_PV_LIST 만들기 (START)' ;
	--=============================================================================================================================
	-- BUCKET 관련 변수 (START)
	--=============================================================================================================================
	DECLARE @V_EXP_YYYYMMDD		NVARCHAR(8);
	DECLARE @V_PV_LIST			NVARCHAR(MAX);
	DECLARE @V_PV_COL_LIST		NVARCHAR(MAX);
    DECLARE @V_PV_COLUMN_NAME	NVARCHAR(100);
    DECLARE @V_PV_NAME			NVARCHAR(50);
    DECLARE @V_SORT_ORDER_NO	NVARCHAR(50);
	--=============================================================================================================================
	-- BUCKET 관련 변수 (END)
	--=============================================================================================================================
	--=============================================================================================================================
	-- BUCKET 관련 세팅 시작 (START)
	--=============================================================================================================================
	SET @V_EXP_YYYYMMDD = CONVERT(NVARCHAR(8), DATEADD(WEEK, 50, @p_from_yyyymmdd), 112);
	
	SELECT @V_PV_LIST = '', @V_PV_COL_LIST = ''
	DECLARE C_BUCKET CURSOR LOCAL FAST_FORWARD FOR   --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가

	SELECT '[D_' + A.BASIS_YYYYMMDD + '] AS D_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
		  ,'[D_' + A.BASIS_YYYYMMDD + ']' AS PV_NAME
		  , A.BASIS_YYYYMMDD + '_' + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
	  FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
	 WHERE A.BASIS_YYYYMMDD >= @p_from_yyyymmdd 
	   AND A.BASIS_YYYYMMDD <= @V_EXP_YYYYMMDD   
	UNION ALL
	SELECT '[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + '] AS W_' + A.BASIS_YYYYMM + A.ISO_WEEK  AS COLUMN_NAME
		  ,'[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + ']' AS PV_NAME
		  , A.BASIS_START_DATE + '_' + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
	  FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
	 WHERE A.BASIS_YYYYMMDD >= @p_from_yyyymmdd 
	   AND A.BASIS_YYYYMMDD <= @p_to_yyyymmdd 
	 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
	UNION ALL
	SELECT '[M_' + A.BASIS_YYYYMM + '] AS M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
		  ,'[M_' + A.BASIS_YYYYMM + ']' AS PV_NAME
		  , MIN(A.BASIS_START_DATE) + '_' + CONVERT(CHAR(2), 1) AS SORT_ORDER_NO
	  FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
	 WHERE A.BASIS_YYYYMMDD >= @p_from_yyyymmdd 
	   AND A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
	 GROUP BY A.BASIS_YYYYMM
	 ORDER BY SORT_ORDER_NO;

	OPEN C_BUCKET;
	FETCH NEXT FROM C_BUCKET INTO @V_PV_COLUMN_NAME, @V_PV_NAME, @V_SORT_ORDER_NO

	WHILE @@FETCH_STATUS = 0   
	BEGIN  
		SELECT @V_PV_COL_LIST	= @V_PV_COL_LIST + CASE WHEN @V_PV_COL_LIST <> '' THEN ',' ELSE '' END + @V_PV_COLUMN_NAME
			 , @V_PV_LIST		= @V_PV_LIST     + CASE WHEN @V_PV_LIST     <> '' THEN ',' ELSE '' END + @V_PV_NAME
		FETCH NEXT FROM C_BUCKET INTO @V_PV_COLUMN_NAME, @V_PV_NAME, @V_SORT_ORDER_NO
	END;

    CLOSE C_BUCKET;  
    DEALLOCATE C_BUCKET;
	
	--=============================================================================================================================
	-- BUCKET 관련 세팅 종료 (END)
	--=============================================================================================================================	
PRINT @v_program_name + ' : A004--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'BUCKET ▶ @V_PV_COL_LIST , @V_PV_LIST 만들기 (START)' ;
PRINT @v_program_name + ' : A005--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'Version 관련 세팅  (START)' ;
	--=============================================================================================================================
	-- Version 관련 세팅 시작 (START)
	--=============================================================================================================================
	
	--=============================================================================================================================
	-- Version 관련 세팅 시작 (END)
	--=============================================================================================================================
PRINT @v_program_name + ' : A005--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'Version 관련 세팅  (END)' ;
PRINT @v_program_name + ' : A006--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSiteItem (START)' ;
	--=============================================================================================================================
	-- #TempSiteItem 만들기 시작 (START)
	--=============================================================================================================================
	-------------------------------------------------------------------------------------------------------------------------------
	--  #TempSiteItem 만들기 
	-- 1. #TEMP_DM_MST_ITEM_SINGLE_V 만들기 위해서 ORI_V , A_V , B_V 3개 만들기 그 후 최종적으로 완성 
	-- 2. #TempSiteItemAll에서 위에서 만든 #TEMP_DM_MST_ITEM_SINGLE_V 사용해서 만들기 
	-- 3. #TempSiteItemAll를 만든뒤 최종적으로 #TempSiteItem 만들기 
	-------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------
	--  #TempSiteItem 관련 TEMP 테이블 DROP (START)
	-------------------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U')		IS NOT NULL DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V
    IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U')	IS NOT NULL DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V
    IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U')	IS NOT NULL DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V
    IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U')	IS NOT NULL DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V
	IF OBJECT_ID (N'tempdb..#TempSiteItemAll', N'U')				IS NOT NULL DROP TABLE #TempSiteItemAll
	IF OBJECT_ID (N'tempdb..#TempSiteItem', N'U')					IS NOT NULL DROP TABLE #TempSiteItem
	-------------------------------------------------------------------------------------------------------------------------------
	--  #TempSiteItem 관련 TEMP 테이블 DROP (END)
	-------------------------------------------------------------------------------------------------------------------------------	
	-------------------------------------------------------------------------------------------------------------------------------
	--  #TempSiteItem 관련 TEMP 테이블 생성 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	CREATE TABLE #TempSiteItemAll
	( DIVISION_ID                   NVARCHAR(10)
	, PROJECT_CODE                  NVARCHAR(100)
	, SCM_SITE_ID                   NVARCHAR(100)
	, ITEM_ID                       NVARCHAR(100)
	, NICK_NAME                     NVARCHAR(100)
	, PROJECT_NAME                  NVARCHAR(100)
	, CELL_MODEL                    NVARCHAR(100)
	--, BIZ_TYPE                      NVARCHAR(100)
	, END_CUSTOMER                  NVARCHAR(100)
	, SOLDTO_CUSTOMER               NVARCHAR(100)
	, COUNTRY                       NVARCHAR(100)
	, COUNTRY_NAME                  NVARCHAR(100)
	, CITY                          NVARCHAR(100)
	, CITY_NAME                     NVARCHAR(100)
	, OWNER                         NVARCHAR(100)
	, PROJECT_OWNER                 NVARCHAR(100)
	, USER_ID                       NVARCHAR(100)
	, ITEM_NAME                     NVARCHAR(100)
	, ITEM_TYPE                     NVARCHAR(100)
	--, PROJECT_STATUS                NVARCHAR(100)
	, CUST_GROUP                    NVARCHAR(100)
	, CUST_GROUP_DTL                NVARCHAR(100)
	, APPLICATION                   NVARCHAR(100)
	, ROUTE                         NVARCHAR(100)
	, MDM_PROJECT_NAME              NVARCHAR(100)
	, MIN_CAPACITY                  NVARCHAR(100)
	, FORECAST_INFO_BIZ_TYPE        NVARCHAR(100)
	, FORECAST_INFO_PRODUCT_GROUP   NVARCHAR(100)
	, CELL_TYPE                     NVARCHAR(100)
	, FORECAST_INFO_CELL_PACK_COUNT NUMERIC(20,10)
	, FORECAST_INFO_ALL             NVARCHAR(100)
	, FORECAST_INFO_SPEC            NVARCHAR(100)
	, FORECAST_INFOR_VERSION        NVARCHAR(100)
	, CELL_MODEL_NICK_NAME          NVARCHAR(100)
	, VMI_YN                        NVARCHAR(100)
	, DMS_SALES                     NVARCHAR(100)
	, DMS_CUSTOMER                  NVARCHAR(100)
	, DEPT_ID                       NVARCHAR(100)
	, DEPT_NAME_KO                  NVARCHAR(100)
	--, CELL_PER_CAR                  NUMERIC
	--, CELL_PER_MODULE               NUMERIC
	--, MODULE_PER_CAR                NUMERIC
	--, ITEM_CLASS_NAME               NVARCHAR(100)
	--, ENERGE                        NVARCHAR(100) --2026.01.09 필요없을듯
	--, CELL_QUANTITY                 NVARCHAR(100)
	, ITEM_VALID_YN	                NVARCHAR(1)		
	--, PROJECT_S_OP_REPORT	        NVARCHAR(100) --2026.01.09 필요없을듯
	) 
	-------------------------------------------------------------------------------------------------------------------------------
	--  #TempSiteItem 관련 TEMP 테이블 생성 (END)
	-------------------------------------------------------------------------------------------------------------------------------	
	/*
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------	
PRINT @v_program_name + ' : A006_1--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_ORI_V  (START)' ;
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_ORI_V 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	SELECT T1.DIVISION_ID              ,T1.ITEM_ID                       ,T1.ITEM_NAME          ,T1.ITEM_CLASS             ,T1.ITEM_CLASS_NAME        ,T1.NICK_NAME
	      ,T1.ITEM_TYPE                ,T1.MATERIAL_CLASS_NAME           ,T1.ITEM_UOM           ,T1.SPEC                   ,T1.MDM_PROJECT_NAME       ,T1.MIN_CAPACITY
		  ,T1.ACTIVE_FLAG              --,T1.ENERGE                        
		  ,T1.CELL_QUANTITY      ,T1.SCP_EXTRA_SPEC         ,T1.FORECAST_INFO_BIZ_TYPE ,T1.FORECAST_INFO_PRODUCT_GROUP
		  ,T1.FORECAST_INFO_CELL_MODEL ,T1.FORECAST_INFO_CELL_PACK_COUNT ,T1.FORECAST_INFO_SPEC ,T1.FORECAST_INFOR_VERSION ,T1.CELL_TYPE
	 INTO #TEMP_DM_MST_ITEM_SINGLE_ORI_V
	 FROM SCM_ITEM_M_SN T1 WITH (NOLOCK)		
	WHERE DIVISION_ID = @P_DIVISION_ID 
	  AND ACTIVE_FLAG = 'Y'	
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_ORI_V 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_1--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_ORI_V  (END)' ;
PRINT @v_program_name + ' : A006_2--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_A_V  (START)' ;
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_A_V 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1	
						  WHEN T1.ITEM_TYPE = 'H' THEN 2	
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )  
									WHEN 1 THEN 'P' 
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 --, MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC		
	INTO #TEMP_DM_MST_ITEM_SINGLE_A_V
	FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T1 WITH(NOLOCK)				
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_A_V 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_2--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_A_V  (END)' ;
PRINT @v_program_name + ' : A006_3--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_B_V  (START)' ;
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_B_V 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	SELECT DIVISION_ID
		 , LEFT(ITEM_ID, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	  INTO #TEMP_DM_MST_ITEM_SINGLE_B_V
	  FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T2 WITH(NOLOCK) 
	 GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_B_V 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_3--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_B_V  (END)' ;
PRINT @v_program_name + ' : A006_4--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_V  (START)' ;
	-------------------------------------------------------------------------------------------------------------------------------
	--#TEMP_DM_MST_ITEM_SINGLE_V 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	SELECT DIVISION_ID					,ITEM_ID			, ITEM_NAME				, ITEM_CLASS					, ITEM_CLASS_NAME
		 , NICK_NAME					,ITEM_TYPE			, MATERIAL_CLASS_NAME	, ITEM_UOM						, SPEC
		 , MDM_PROJECT_NAME				, MIN_CAPACITY		, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP	, FORECAST_INFO_CELL_MODEL
		 , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG					, CELL_TYPE
		 --, CASE WHEN ISNUMERIC(ENERGE) > 0 THEN ROUND((CONVERT(NUMERIC(15,3), ENERGE))/1000, 4) ELSE NULL END AS ENERGE -- WH → KWH 환산
		 , CELL_QUANTITY, SCP_EXTRA_SPEC 
	  INTO #TEMP_DM_MST_ITEM_SINGLE_V
	  FROM (SELECT T1.DIVISION_ID					, T1.ITEM_ID			, T1.ITEM_NAME				, T1.ITEM_CLASS					, T1.ITEM_CLASS_NAME
				 , T1.NICK_NAME						, T1.ITEM_TYPE			, T1.MATERIAL_CLASS_NAME	, T1.ITEM_UOM					, T1.SPEC
				 , T1.MDM_PROJECT_NAME				, T1.MIN_CAPACITY		, T2.FORECAST_INFO_BIZ_TYPE	, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
				 , T2.FORECAST_INFO_CELL_PACK_COUNT	, T2.FORECAST_INFO_SPEC	, T2.FORECAST_INFOR_VERSION	, T1.ACTIVE_FLAG				, T2.CELL_TYPE
				 --, T1.ENERGE
				 , T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
			  FROM #TEMP_DM_MST_ITEM_SINGLE_A_V T1 WITH(NOLOCK)					
			 INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_B_V T2 
					 ON T1.DIVISION_ID				= T2.DIVISION_ID
					AND SUBSTRING(T1.ITEM_ID,1,12)	= T2.ITEM_ID
			 WHERE 1=1 ) T2	
	INNER JOIN ( SELECT DISTINCT '%'+TOKEN+'%' TST FROM DBO.STRING_SPLIT(@P_ITEM_ID, ',') ) B
			ON T2.ITEM_ID LIKE B.TST OR	T2.NICK_NAME LIKE B.TST 						
	WHERE DIVISION_ID = @P_DIVISION_ID					
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME
		   , MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
		   , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE--, ENERGE
		   , CELL_QUANTITY, SCP_EXTRA_SPEC 
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_4--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_V  (END)' ;
PRINT @v_program_name + ' : A006_5--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_V  (START)' ;
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_V 인덱스 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
	( DIVISION_ID ASC, ITEM_ID ASC) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]	;
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TEMP_DM_MST_ITEM_SINGLE_V 인덱스 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_5--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TEMP_DM_MST_ITEM_SINGLE_V  (END)' ;	
PRINT @v_program_name + ' : A006_6--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSiteItemAll  (START)' ;
*/
    
	-- 2026.01.13 #TEMP_DM_MST_ITEM_SINGLE_V 는 DM_MST_ITEM_SINGLE_V 으로 대체
	SELECT *
	INTO   #TEMP_DM_MST_ITEM_SINGLE_V
	FROM   [DM_MST_ITEM_SINGLE_V] WITH(NOLOCK)
	WHERE  DIVISION_ID = '40'
	AND    ACTIVE_FLAG = 'Y'
	;

	-------------------------------------------------------------------------------------------------------------------------------
	-- #TempSiteItem 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO #TempSiteItemAll
	SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME
		 , F.PROJECT_CODE, F.ATTRIBUTE5 AS CELL_MODEL--, '' AS BIZ_TYPE
		 , S.END_CUSTOMER, S.SOLDTO_CUSTOMER
		 , I.COUNTRY, I.COUNTRY_NAME, H.CITY, H.CITY_NAME	  
		 , ( SELECT DISTINCT STUFF(( SELECT ',' + USER_NAME_EN FROM (SELECT ZA.USER_NAME_EN FROM SCM_MST_SSO_USER_INFO ZA WITH(NOLOCK),( SELECT TOKEN FROM DBO.STRING_SPLIT(F.OWNER,',') ) ZB WHERE ZA.USER_ID = ZB.TOKEN ) XB  FOR XML PATH('') ),1,1,'') AS NAME FROM (SELECT ZA.USER_NAME_EN  FROM SCM_MST_SSO_USER_INFO ZA WITH(NOLOCK)  ,( SELECT TOKEN FROM DBO.STRING_SPLIT(F.OWNER,',') ) ZB WHERE ZA.USER_ID = ZB.TOKEN) XA ) AS OWNER
		 , J.USER_NAME_EN AS PROJECT_OWNER, J.USER_ID, T2.ITEM_NAME, T2.ITEM_TYPE--, '' AS PROJECT_STATUS 
		 , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE, T2.MDM_PROJECT_NAME  
		 , T2.MIN_CAPACITY, CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE T2.FORECAST_INFO_BIZ_TYPE END AS FORECAST_INFO_BIZ_TYPE
		 , T2.FORECAST_INFO_PRODUCT_GROUP, LOOK.NAME AS CELL_TYPE, CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.CELL_PACK_COUNT ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
		 , T2.FORECAST_INFO_SPEC + T2.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL, T2.FORECAST_INFO_SPEC AS FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION AS FORECAST_INFOR_VERSION
		 , ISNULL(T4.NICK_NAME,'') AS CELL_MODEL_NICK_NAME, S.VMI_YN, ISNULL(F.ATTRIBUTE1,'') AS DMS_SALES, ISNULL(F.ATTRIBUTE2,'') AS DMS_CUSTOMER, TEAM.DEPT_ID
		 , TEAM.DEPT_NAME_KO
		 --, F.CELL_PER_CAR, F.CELL_PER_MODULE, F.CELL_PER_CAR / IIF(ISNULL(F.CELL_PER_MODULE, 0) = 0, 1, F.CELL_PER_MODULE) AS MODULE_PER_CAR, T2.ITEM_CLASS_NAME
		 --, T2.ENERGE, T2.CELL_QUANTITY
		 , F.VALID_YN--, F.PROJECT_S_OP_REPORT 
	  FROM SCM_MST_SITE_ITEM F WITH(NOLOCK)
	 INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK) ON F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID						
	 INNER JOIN ( SELECT DISTINCT '%'+TOKEN+'%' TST FROM DBO.STRING_SPLIT(@P_ITEM_ID,',') ) B ON F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST 
	 INNER JOIN SCM_MST_SITE S WITH(NOLOCK) ON F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID AND S.SITE_TYPE = 'SALES'
	 INNER JOIN SCM_MST_CITY H WITH(NOLOCK) ON S.CITY = H.CITY
	 INNER JOIN SCM_MST_COUNTRY I WITH(NOLOCK) ON S.COUNTRY = I.COUNTRY
	  LEFT JOIN ( SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
				    FROM SCM_MST_SSO_USER_INFO B WITH(NOLOCK)
				   INNER JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID ) AS TEAM ON TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](F.OWNER, ','))
	  LEFT JOIN SCM_MST_SSO_USER_INFO J WITH(NOLOCK) ON SUBSTRING( F.OWNER, 0, CASE WHEN CHARINDEX(',',F.OWNER) = 0 THEN LEN(F.OWNER)+1 ELSE CHARINDEX(',',F.OWNER) END ) = J.USER_ID
	  LEFT JOIN SCM_MST_SSO_DEPT_INFO K WITH(NOLOCK) ON CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID ELSE S.DEPT_ID END  = K.DEPT_ID
	  LEFT JOIN ( SELECT SEGMENT1 AS CODE, SEGMENT2  AS NAME
				    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				   WHERE LOOKUP_TYPE = 'CELL_TYPE') LOOK ON LOOK.CODE = T2.CELL_TYPE
	  LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V T4 WITH(NOLOCK) ON T2.DIVISION_ID = T4.DIVISION_ID AND ISNULL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID
	  LEFT JOIN ( SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK 
				    FROM ( SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT
							    , RANK()OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) MODEL_RANK 
						     FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
						    WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' 
							  AND SEGMENT1 = '40') A
				   WHERE MODEL_RANK = '1') LOOKA ON LOOKA.MODEL = F.ITEM_ID								
	 WHERE F.DIVISION_ID = '40'					
	   AND CASE WHEN @P_SCM_SITE_ID = 'ALL' THEN @P_SCM_SITE_ID	ELSE F.SCM_SITE_ID END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,','))
	   AND CASE WHEN @P_CUSTOMER = 'ALL' THEN @P_CUSTOMER ELSE F.PROJECT_CODE END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_CUSTOMER,','))
	   AND CASE WHEN @P_BIZ_TYPE = 'ALL' THEN @P_BIZ_TYPE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE T2.FORECAST_INFO_BIZ_TYPE END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_BIZ_TYPE,','))  
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TempSiteItem 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_6--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSiteItemAll  (END)' ;
PRINT @v_program_name + ' : A006_7--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSiteItem  (START)' ;
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TempSiteItem 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME,PROJECT_NAME
		 , MAX(CELL_MODEL                   )   CELL_MODEL                   
		 --, MAX(BIZ_TYPE                     )   BIZ_TYPE                     
		 , MAX(END_CUSTOMER                 )   END_CUSTOMER                 
		 , MAX(SOLDTO_CUSTOMER              )   SOLDTO_CUSTOMER              
		 , MAX(COUNTRY                      )   COUNTRY     
		 , MAX(COUNTRY_NAME                 )   COUNTRY_NAME                 
		 , MAX(CITY                         )   CITY                         
		 , MAX(CITY_NAME                    )   CITY_NAME                    
		 , MAX(OWNER                        )   OWNER                        
		 , MAX(PROJECT_OWNER                )   PROJECT_OWNER                
		 , MAX(USER_ID                      )   USER_ID                      
		 , MAX(ITEM_NAME                    )   ITEM_NAME                    
		 , MAX(ITEM_TYPE                    )   ITEM_TYPE                    
		 --, MAX(PROJECT_STATUS               )   PROJECT_STATUS               
		 , MAX(CUST_GROUP                   )   CUST_GROUP                   
		 , MAX(CUST_GROUP_DTL               )   CUST_GROUP_DTL               
		 , MAX(APPLICATION                  )   APPLICATION                  
		 , MAX(ROUTE                        )   ROUTE                        
		 , MAX(MDM_PROJECT_NAME             )   MDM_PROJECT_NAME             
		 , MAX(MIN_CAPACITY                 )   MIN_CAPACITY                 
		 , MAX(FORECAST_INFO_BIZ_TYPE       )   FORECAST_INFO_BIZ_TYPE       
		 , MAX(FORECAST_INFO_PRODUCT_GROUP  )   FORECAST_INFO_PRODUCT_GROUP  
		 , MAX(CELL_TYPE                    )   CELL_TYPE                    
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT)   FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_ALL            )   FORECAST_INFO_ALL            
		 , MAX(FORECAST_INFO_SPEC           )   FORECAST_INFO_SPEC           
		 , MAX(FORECAST_INFOR_VERSION       )   FORECAST_INFOR_VERSION       
		 , MAX(CELL_MODEL_NICK_NAME         )   CELL_MODEL_NICK_NAME         
		 , MAX(VMI_YN                       )   VMI_YN                       
		 , MAX(DMS_SALES                    )   DMS_SALES                    
		 , MAX(DMS_CUSTOMER                 )   DMS_CUSTOMER                 
		 , MAX(DEPT_ID                      )   DEPT_ID                      
		 , MAX(DEPT_NAME_KO                 )   DEPT_NAME_KO                 
		 --, MAX(CELL_PER_CAR                 )   CELL_PER_CAR                 
		 --, MAX(CELL_PER_MODULE              )   CELL_PER_MODULE                 
		 --, MAX(MODULE_PER_CAR               )   MODULE_PER_CAR                 
		 --, MAX(ITEM_CLASS_NAME              )   ITEM_CLASS_NAME
		 --, MAX(ENERGE							)	ENERGE
		 --, MAX(CELL_QUANTITY					)	CELL_QUANTITY
		 , MAX(ITEM_VALID_YN)						ITEM_VALID_YN	
		-- , MAX(PROJECT_S_OP_REPORT)				PROJECT_S_OP_REPORT
	  INTO #TEMPSITEITEM
	  FROM #TEMPSITEITEMALL WITH(NOLOCK)
	 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TempSiteItem 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_7--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSiteItem  (END)' ;
PRINT @v_program_name + ' : A006_8--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSiteItem 인덱스  (START)' ;
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TempSiteItem 인덱스 만들기 (START)
	-------------------------------------------------------------------------------------------------------------------------------
	CREATE INDEX [IDX1_TEMPSITEITEM] ON [#TEMPSITEITEM]	(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID)
	-------------------------------------------------------------------------------------------------------------------------------
	-- #TempSiteItem 인덱스 만들기 (END)
	-------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A006_8--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSiteItem 인덱스  (END)' ;
	--=============================================================================================================================
	-- #TempSiteItem 만들기 시작 (END)
	--=============================================================================================================================

	/* 조회 할 때 쓸 날짜 관련 변수 */
    DECLARE @V_FROM_YYYYMMDD     AS NVARCHAR(8);
    DECLARE @V_TO_YYYYMMDD       AS NVARCHAR(8);
    DECLARE @V_FROM_RESULT       AS NVARCHAR(8);
    DECLARE @V_TO_RESULT         AS NVARCHAR(8);
  	DECLARE @V_USER_TIME_ZONE    AS NVARCHAR(50);  

    SET @V_FROM_YYYYMMDD  = ''; --MKT FCST PLAN FROM 주차 월요일
    SET @V_TO_YYYYMMDD    = ''; --MKT FCST PLAN TO 주차 월요일
    SET @V_FROM_RESULT    = ''; --MKT FCST RESULT FROM 주차 월요일
    SET @V_TO_RESULT      = ''; --MKT FCST RESULT TO 주차 월요일
    SET @V_USER_TIME_ZONE = '';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	/* 조회 할 때 쓸 날짜 변수 세팅 시작 */
	/* 조회 할 때 쓸 날짜 변수 세팅 시작 */
	/* 조회 할 때 쓸 날짜 변수 세팅 시작 */

	  BEGIN
	  SELECT @V_USER_TIME_ZONE = U.TIMEZONE
	  FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
	  WHERE  U.UserID = @p_created_by;
	  END

	  -- @V_FROM_YYYYMMDD : (USER 시차를 고려한) 당주 월요일
	  SELECT @V_FROM_YYYYMMDD = MIN(C.BASIS_YYYYMMDD)
	  FROM   [DBO].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
		   , (SELECT DISTINCT ISO_YYYYWW		    		
			  FROM   [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) 
			  WHERE  1 = 1
			  AND    BASIS_YYYYMMDD = CONVERT(CHAR(8), DBO.FN_MULTY_TIME(@V_USER_TIME_ZONE), 112)
			  --AND    BASIS_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(MM, @V_USER_COL_CNT, DBO.FN_MULTY_TIME(@V_USER_TIME_ZONE)), 112)
			 ) T
	  WHERE  1 = 1
	  AND    C.ISO_YYYYWW = T.ISO_YYYYWW ;

	  -- FROM 실적 : FROM 조회 구간 월요일부터
	  SELECT @V_FROM_RESULT = C.BASIS_START_DATE
	  FROM   [DBO].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd; 
  
	  -- TO 실적 : TO 조회 구간 월요일 전까지
	  SELECT @V_TO_RESULT = C.BASIS_START_DATE
	  FROM   [DBO].[SCM_SYS_CALENDAR_M]      C	WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd; 

	  IF @V_FROM_YYYYMMDD > @V_FROM_RESULT
		  BEGIN -- 실적 보여줌
		  SET @V_TO_YYYYMMDD   = @p_to_yyyymmdd;   
		  SET @V_TO_RESULT     = @V_FROM_YYYYMMDD; -- TO 실적 : 당주 월요일 전까지 
		  END;
	  ELSE IF @V_FROM_YYYYMMDD <= @V_FROM_RESULT
		  BEGIN -- 실적 없음
		  SET @V_TO_YYYYMMDD   = @p_to_yyyymmdd;
		  SET @V_FROM_RESULT = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112);
		  SET @V_TO_RESULT = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, -6, CURRENT_TIMESTAMP), 112);
		  END;
	  ELSE IF @V_FROM_YYYYMMDD > @V_TO_RESULT
		  BEGIN -- 실적만 보여줌
		  SET @V_FROM_YYYYMMDD = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112);
		  SET @V_TO_YYYYMMDD = '19000101'; --CONVERT(CHAR(8), DATEADD(MM, -6, CURRENT_TIMESTAMP), 112);
		  SET @V_FROM_RESULT = @p_from_yyyymmdd; -- FROM 실적 : FROM 조회 구간부터
		  SET @V_TO_RESULT = @p_to_yyyymmdd; -- TO 실적 : TO 조회 구간까지  
		  END;
	  ELSE IF @V_FROM_YYYYMMDD = @V_TO_RESULT
		  BEGIN -- 실적 없음
		  SET @V_TO_YYYYMMDD = @V_FROM_YYYYMMDD
		  SET @V_FROM_RESULT = @p_from_yyyymmdd;
		  SET @V_TO_RESULT = @p_to_yyyymmdd;
		  END;

	--SELECT N'날짜 변수', @V_FROM_YYYYMMDD AS V_FROM_YYYYMMDD, @V_TO_YYYYMMDD AS V_TO_YYYYMMDD, @V_FROM_RESULT AS V_FROM_RESULT, @V_TO_RESULT AS V_TO_RESULT -- 테스트
PRINT @VA_PROGRAM_ID + ' : A007--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'날짜 변수 ▶ '+' @V_FROM_YYYYMMDD : '+ @V_FROM_YYYYMMDD+' @V_TO_YYYYMMDD : ' + @V_TO_YYYYMMDD + ' @V_FROM_RESULT : ' + @V_FROM_RESULT + ' @V_TO_RESULT : ' + @V_TO_RESULT;
PRINT @VA_PROGRAM_ID + ' : A007--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'날짜 변수 ▶ @V_FROM_YYYYMMDD , @V_TO_YYYYMMDD, @V_FROM_RESULT, @V_TO_RESULT 만들기 성공';

	/* 조회 할 때 쓸 날짜 변수 세팅 종료 */
	/* 조회 할 때 쓸 날짜 변수 세팅 종료 */
	/* 조회 할 때 쓸 날짜 변수 세팅 종료 */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	/* 조회 할 때 쓸 MKT_FCST, SALE_PRICE 의 RAW DATA 는 #TempFcstNPrice 에 넣는다. */

	/*  최종적으로 #TempFcstNPrice 만듬 */
	IF OBJECT_ID (N'tempdb..#TempSelectMeasure', N'U')         IS NOT NULL DROP TABLE #TempSelectMeasure
	IF OBJECT_ID (N'dbo.#TempSelectMeasure', N'U')		       IS NOT NULL DROP TABLE #TempSelectMeasure
	IF OBJECT_ID (N'tempdb..#T_LAST_DATA_SETUP_FCST', N'U')    IS NOT NULL DROP TABLE #T_LAST_DATA_SETUP_FCST
	IF OBJECT_ID (N'dbo.#T_LAST_DATA_SETUP_FCST', N'U')        IS NOT NULL DROP TABLE #T_LAST_DATA_SETUP_FCST
	IF OBJECT_ID (N'tempdb..#T_LAST_DATA_SETUP_PRICE', N'U')   IS NOT NULL DROP TABLE #T_LAST_DATA_SETUP_PRICE
	IF OBJECT_ID (N'dbo.#T_LAST_DATA_SETUP_PRICE', N'U')       IS NOT NULL DROP TABLE #T_LAST_DATA_SETUP_PRICE
	IF OBJECT_ID (N'tempdb..#T_LAST_DATA_SETUP_PRICE_C', N'U') IS NOT NULL DROP TABLE #T_LAST_DATA_SETUP_PRICE_C --PRICE Version 관련 테이블
	IF OBJECT_ID (N'dbo.#T_LAST_DATA_SETUP_PRICE_C', N'U')	   IS NOT NULL DROP TABLE #T_LAST_DATA_SETUP_PRICE_C --PRICE Version 관련 테이블
	--IF OBJECT_ID (N'tempdb..#T_EDI_SENDER', N'U')	           IS NOT NULL DROP TABLE #T_EDI_SENDER -- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
	--IF OBJECT_ID (N'dbo.#T_EDI_SENDER', N'U')		           IS NOT NULL DROP TABLE #T_EDI_SENDER -- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
	IF OBJECT_ID (N'tempdb..#T_WS_FCST', N'U')			       IS NOT NULL DROP TABLE #T_WS_FCST
	IF OBJECT_ID (N'dbo.#T_WS_FCST', N'U')		               IS NOT NULL DROP TABLE #T_WS_FCST
	IF OBJECT_ID (N'tempdb..#TempFcstNPrice', N'U')            IS NOT NULL DROP TABLE #TempFcstNPrice
	IF OBJECT_ID (N'dbo.#TempFcstNPrice', N'U')	               IS NOT NULL DROP TABLE #TempFcstNPrice
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- #TempSelectMeasure 만들기 시작

	CREATE TABLE #TempSelectMeasure
	(
	  PROGRAM_ID    NVARCHAR(100)
	, SHEET_NAME    NVARCHAR(100)
	, USER_ID       NVARCHAR(100)
	, MEASURE_GROUP NVARCHAR(100)
	, MEASURE       NVARCHAR(100)
	, RESULT_MEASURE NVARCHAR(100) -- 2025.03.13 RESULT_MEASURE 추가
	, SORT_ORDER_NO NVARCHAR(100)
	) ;

	INSERT INTO #TempSelectMeasure
		SELECT DISTINCT U.PROGRAM_ID    AS PROGRAM_ID
					  , U.SHEET_NAME    AS SHEET_NAME
					  , U.USER_ID       AS [USER_ID]
					  , U.COLUMN_NAME   AS MEASURE_GROUP
					  , U.COLUMN_NAME   AS MEASURE
					  , ISNULL(SMSM.ATTRIBUTE5, U.COLUMN_NAME) AS RESULT_MEASURE -- 2025.03.13 RESULT_MEASURE 추가
					  , U.SORT_ORDER_NO AS SORT_ORDER_NO
		FROM [DBO].[SCM_MST_TITLESET_USER] U    WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))		
		JOIN [DBO].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
			ON  U.PROGRAM_ID                    = SMSM.PROGRAM_ID
			AND U.SHEET_NAME                    = SMSM.SHEET_NAME
			AND U.COLUMN_NAME                   = SMSM.COLUMN_NAME
			AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
			AND SMSM.VALID_YN                   = 'Y'	
		WHERE 1 = 1
		AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
		AND U.PROGRAM_ID                    = @VA_PROGRAM_ID --'DMF0082'
		AND U.SHEET_NAME                    = @VA_SHEET_NAME --'FcstNPrice'
		AND U.USER_ID	                    = @p_created_by

	  --SELECT '#TempSelectMeasure', * FROM #TempSelectMeasure -- 테스트
PRINT @VA_PROGRAM_ID + ' : A008--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempSelectMeasure 만들기 성공';
	------------------------------------------------------------------------------------------------
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT Fcst AMT/QTY) 
	--실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 START
	------------------------------------------------------------------------------------------------
	IF EXISTS (SELECT 1
				 FROM #TempSelectMeasure A
				WHERE 1=1
				  AND A.MEASURE IN ('LOC', 'KRW', 'FCST_GAP' ))  --'FCST_GAP' 추가 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)  
	BEGIN
		;WITH W_TARGET_MEASURE AS
		(SELECT A.PROGRAM_ID	
			  , A.SHEET_NAME
			  , 'LOC' AS TARGET_MEASURE
			  , A.COLUMN_NAME AS MEASURE_GROUP
			  , A.COLUMN_NAME AS MEASURE
			  , A.COLUMN_NAME AS RESULT_MEASURE
			  , A.SORT_ORDER_NO
		  FROM DBO.SCM_MST_SHEET_MEASURE A WITH(NOLOCK)
		 WHERE 1=1
		   AND A.PROGRAM_ID  = @VA_PROGRAM_ID
		   AND A.SHEET_NAME =  @VA_SHEET_NAME
		   AND A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_LOC')
		 UNION ALL
		SELECT A.PROGRAM_ID	
			 , A.SHEET_NAME
			 , 'KRW' AS TARGET_MEASURE
			 , A.COLUMN_NAME AS MEASURE_GROUP
			 , A.COLUMN_NAME AS MEASURE
			 , A.COLUMN_NAME AS RESULT_MEASURE
			 , A.SORT_ORDER_NO
		  FROM DBO.SCM_MST_SHEET_MEASURE A WITH(NOLOCK)
		 WHERE 1=1
		   AND A.PROGRAM_ID  = @VA_PROGRAM_ID
		   AND A.SHEET_NAME = @VA_SHEET_NAME
		   AND A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_KRW')
		-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)  START -----
		 UNION ALL
		SELECT A.PROGRAM_ID	
			 , A.SHEET_NAME
			 , 'FCST_GAP' AS TARGET_MEASURE
			 , A.COLUMN_NAME AS MEASURE_GROUP
			 , A.COLUMN_NAME AS MEASURE
			 , A.COLUMN_NAME AS RESULT_MEASURE
			 , A.SORT_ORDER_NO
		  FROM DBO.SCM_MST_SHEET_MEASURE A WITH(NOLOCK)
		 WHERE 1=1
		   AND A.PROGRAM_ID  = @VA_PROGRAM_ID
		   AND A.SHEET_NAME = @VA_SHEET_NAME
		   AND A.COLUMN_NAME IN ('MKT_FCST', 'SCM_FCST')
		-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)  END -----
		)
		INSERT INTO #TempSelectMeasure
		(  PROGRAM_ID    
		 , SHEET_NAME    
		 , USER_ID       
		 , MEASURE_GROUP 
		 , MEASURE       
		 , RESULT_MEASURE
		 , SORT_ORDER_NO 
		)
		SELECT DISTINCT 
			   W.PROGRAM_ID
			 , W.SHEET_NAME
			 , 'DM_ADMIN'		  AS USER_ID --USER_ID를 기준으로 단가 계산후 메저를 삭제함(사용자가 선택하지 않은 메저가 화면에 조회되면 안되므로)
			 , W.MEASURE_GROUP
			 , W.MEASURE
			 , W.RESULT_MEASURE
			 , W.SORT_ORDER_NO
		  FROM W_TARGET_MEASURE W
		  JOIN #TempSelectMeasure T
		    ON (W.PROGRAM_ID = T.PROGRAM_ID
		   AND W.SHEET_NAME = T.SHEET_NAME
		   AND W.TARGET_MEASURE = T.MEASURE) 
		 WHERE 1=1
		   AND NOT EXISTS (SELECT 1
							 FROM #TempSelectMeasure X
							WHERE 1=1
							  AND X.MEASURE = W.MEASURE)
	END
	------------------------------------------------------------------------------------------------
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT Fcst AMT/QTY) 
	--실적구간 LOC,KRW를 계산하기 위해 필수 메저 RTF_SYS_RP, MKT_AMT_LOC, MKT_AMT_KRW 를 메저에 강제 등록 END
	------------------------------------------------------------------------------------------------
	
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START----------------------------------------------
	--LOC를 기준으로 CURRENCY를 일괄 업데이트 하기 때문에 무조건 해당 메저 INSERT
	--DM_PLN_CFM_SELLING_PRICE 테이블로 JOIN 해서 업데이트 하면 속도가 너무 느림

	INSERT INTO #TempSelectMeasure
		(  PROGRAM_ID    
		 , SHEET_NAME    
		 , USER_ID       
		 , MEASURE_GROUP 
		 , MEASURE       
		 , RESULT_MEASURE
		 , SORT_ORDER_NO 
		)
		SELECT A.PROGRAM_ID	
			  , A.SHEET_NAME
			  , 'DM_ADMIN'
			  , A.COLUMN_NAME AS MEASURE_GROUP
			  , A.COLUMN_NAME AS MEASURE
			  , A.COLUMN_NAME AS RESULT_MEASURE
			  , A.SORT_ORDER_NO
		  FROM DBO.SCM_MST_SHEET_MEASURE A WITH(NOLOCK)
		 WHERE 1=1
		   AND A.PROGRAM_ID  = @VA_PROGRAM_ID
		   AND A.SHEET_NAME =  @VA_SHEET_NAME
		   AND A.COLUMN_NAME = 'LOC'
		   AND NOT EXISTS (SELECT 1
							 FROM #TempSelectMeasure X
							WHERE 1=1
							  AND X.MEASURE = A.COLUMN_NAME)
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END----------------------------------------------


	-- #TempSelectMeasure 만들기 종료

	-- #T_LAST_DATA_SETUP_FCST 만들기 시작
		CREATE TABLE #T_LAST_DATA_SETUP_FCST (  
			    DIVISION_ID     NVARCHAR(30)		  
			  , PROJECT_CODE    NVARCHAR(50)  
			  , SCM_SITE_ID     NVARCHAR(30)  		  
			  , ITEM_ID         NVARCHAR(50)  
			  , DOM_EXP         NVARCHAR(3)  
			  , FCST_TYPE       NVARCHAR(20)  
			  , INCOTERMS       NVARCHAR(10)  		  
			  , MEASURE         NVARCHAR(50)  		  
			  , CREATE_DATE	    NVARCHAR(8)
			  , LAST_UPDATED_BY	NVARCHAR(300)		  
		)

	-- #T_LAST_DATA_SETUP_PRICE 만들기 시작
		CREATE TABLE #T_LAST_DATA_SETUP_PRICE (  
			    DIVISION_ID     NVARCHAR(30)		  
			  , PROJECT_CODE    NVARCHAR(50)  
			  , SCM_SITE_ID     NVARCHAR(30)  		  
			  , ITEM_ID         NVARCHAR(50)  
			  , DOM_EXP         NVARCHAR(3)  
			  , FCST_TYPE       NVARCHAR(20)  
			  , INCOTERMS       NVARCHAR(10)  		  
			  , MEASURE         NVARCHAR(50)  		  
			  , CREATE_DATE	    NVARCHAR(8)
			  , LAST_UPDATED_BY	NVARCHAR(300)		  
		)

		IF ( @P_VERSION_TYPE LIKE '%CURRENT%' )
		BEGIN
PRINT @VA_PROGRAM_ID + ' : A009--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#T_LAST_DATA_SETUP_FCST 만들기 시작';
			--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START ---------------------------------------------------------------------
			--기존 쿼리 주석 처리 후 일괄 변경
			--1.LAST_UPDATE_DATE 값을 가져올 때, CASE WHEN 에 소형사업부에서 사용하지 않는 메저들만 있어서 해당 로직 제거
			--2.가장 최근 데이터를 입력한 사용자ID가 아니라 MAX사용자ID로 가져와서 수정함

			INSERT INTO #T_LAST_DATA_SETUP_FCST
			SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
				 , X.LAST_UPDATE_DATE,X.LAST_UPDATED_BY
			FROM (
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE				
	 						 , CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) AS LAST_UPDATE_DATE
	 						 , A.LAST_UPDATED_BY AS LAST_UPDATED_BY 
							 , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
													  ORDER BY A.LAST_UPDATE_DATE) AS RN
						FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
						INNER JOIN #TempSelectMeasure B 
						ON A.MEASURE = (CASE WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
											 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'															
							            ELSE B.MEASURE END)
						WHERE A.DIVISION_ID = @P_DIVISION_ID
						AND A.YYYYMMDD >= CONVERT(NVARCHAR, DATEADD(YY, -1, @p_from_yyyymmdd ), 112)
						AND A.YYYYMMDD <= @p_to_yyyymmdd
						--AND A.QTY <> 0
						) X
			WHERE ISNULL(X.PROJECT_CODE, '') <> ''
			AND ISNULL(X.SCM_SITE_ID, '') <> ''
			AND ISNULL(X.ITEM_ID, '') <> ''
			AND X.RN = 1

			-- #T_LAST_DATA_SETUP_FCST 만들기 종료
			--SELECT * FROM #T_LAST_DATA_SETUP_FCST
PRINT @VA_PROGRAM_ID + ' : A009--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#T_LAST_DATA_SETUP_FCST 만들기 종료';
PRINT @VA_PROGRAM_ID + ' : A010--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#T_LAST_DATA_SETUP_PRICE 만들기 시작';

			INSERT INTO #T_LAST_DATA_SETUP_PRICE
			SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
				 , X.LAST_UPDATE_DATE,X.LAST_UPDATED_BY
			FROM (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE				
	 				   , CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) AS LAST_UPDATE_DATE
	 				   , A.LAST_UPDATED_BY AS LAST_UPDATED_BY 
					   , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
												ORDER BY A.LAST_UPDATE_DATE) AS RN
					FROM DM_PLN_CFM_SELLING_PRICE A WITH(NOLOCK)
					INNER JOIN #TempSelectMeasure B 
					ON A.MEASURE = B.MEASURE
					WHERE A.DIVISION_ID = @P_DIVISION_ID
					AND A.YYYYMMDD >= CONVERT(NVARCHAR, DATEADD(YY, -1, @p_from_yyyymmdd ), 112)
					AND A.YYYYMMDD <= @p_to_yyyymmdd
					--AND A.QTY <> 0
				   ) X
			WHERE ISNULL(X.PROJECT_CODE, '') <> ''
			AND ISNULL(X.SCM_SITE_ID, '') <> ''
			AND ISNULL(X.ITEM_ID, '') <> ''
			AND X.RN = 1
		
PRINT @VA_PROGRAM_ID + ' : A011--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#T_LAST_DATA_SETUP_PRICE 만들기 종료';
		END
		CREATE TABLE #T_WS_FCST (
		FCST_TYPE		NVARCHAR(20)
		)

		INSERT INTO #T_WS_FCST ( FCST_TYPE )
		SELECT SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL ( NOLOCK )
		WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE'
		--SELECT * FROM #T_WS_FCST
PRINT @VA_PROGRAM_ID + ' : A016--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'#T_WS_FCST 만들기 성공';
		 
		--#TempFcstNPrice 임시테이블
		CREATE TABLE #TempFcstNPrice
		( DIVISION_ID                   NVARCHAR(100)
		, PROJECT_CODE                  NVARCHAR(100) -- 2026.01.13 삭제대상(UI 컬럼 없음. 40 제외)
		, END_CUSTOMER                  NVARCHAR(100)
		, SCM_SITE_ID                   NVARCHAR(100)
		, ITEM_ID                       NVARCHAR(100)
		, DOM_EXP                       NVARCHAR(100)
		, FCST_TYPE                     NVARCHAR(100)
		, INCOTERMS                     NVARCHAR(100)
		, MEASURE                       NVARCHAR(100)
		, PLANT_SITE_ID                 NVARCHAR(100) -- 2026.01.13 삭제대상(UI 컬럼 없음. 40 제외)
		, CELL_PROD_SITE_ID             NVARCHAR(100)
		, YYYYMMDD                      NVARCHAR(100)
		, QTY                           NUMERIC(30,10)
		, SOLDTO_CUSTOMER               NVARCHAR(100)
		, MEASURE_GROUP                 NVARCHAR(100)
		, CELL_MODEL                    NVARCHAR(100) -- 2026.01.13 UI FORECAST_INFO_CELL_MODEL 컬럼
		, NICK_NAME                     NVARCHAR(100)
		, DMS_SALES                     NVARCHAR(100)
		, DMS_CUSTOMER                  NVARCHAR(100)
		, OWNER                         NVARCHAR(100)
		, DEPT_ID                       NVARCHAR(100) -- 2026.01.13 UI TEAM_ID 컬럼
		, DEPT_NAME_KO                  NVARCHAR(100) -- 2026.01.13 UI 컬럼은 없으나 일단 삭제 보류
		, FORECAST_INFO_CELL_PACK_COUNT NUMERIC(20,10)
		, ITEM_TYPE                     NVARCHAR(100) -- 2026.01.13 삭제대상(UI 컬럼 없음)
		, PROJECT_NAME                  NVARCHAR(100) -- 2026.01.13 삭제대상(UI 컬럼 없음)
		, PROJECT_OWNER                 NVARCHAR(100)
		--, BIZ_TYPE                      NVARCHAR(100)
		, COUNTRY_NAME                  NVARCHAR(100)
		, CITY_NAME                     NVARCHAR(100)
		--, PROJECT_STATUS                NVARCHAR(100) -- 2026.01.13 삭제대상(UI 컬럼 없음)
		, ITEM_NAME                     NVARCHAR(100)
		, VMI_YN                        NVARCHAR(100)
		, CUST_GROUP                    NVARCHAR(100)
		, CUST_GROUP_DTL                NVARCHAR(100)
		, APPLICATION                   NVARCHAR(100)
		, ROUTE                         NVARCHAR(100)
		, MDM_PROJECT_NAME              NVARCHAR(100)
		, MIN_CAPACITY                  NVARCHAR(100)
		, FORECAST_INFO_BIZ_TYPE        NVARCHAR(100)
		, CELL_TYPE                     NVARCHAR(100)
		, FORECAST_INFO_ALL             NVARCHAR(100)
		, FORECAST_INFO_SPEC            NVARCHAR(100)
		, FORECAST_INFOR_VERSION        NVARCHAR(100)
		, CELL_MODEL_NICK_NAME          NVARCHAR(100)
		--, CELL_PER_CAR                  NUMERIC -- 2026.01.13 삭제대상(UI 컬럼 없음)
		--, CELL_PER_MODULE               NUMERIC -- 2026.01.13 삭제대상(UI 컬럼 없음)
		--, MODULE_PER_CAR                NUMERIC -- 2026.01.13 삭제대상(UI 컬럼 없음)
		, SORT_ORDER_NO                 NVARCHAR(100)
		--, ENERGE                        NVARCHAR(100) -- 2026.01.13 삭제대상(40 제외)
		--, CELL_QUANTITY                 NVARCHAR(100) -- 2026.01.13 삭제대상(UI 컬럼 없음)
		--, AS_FROM_SITE	                NVARCHAR(100) -- 2026.01.13 삭제대상(40 제외 )
		, CREATE_DATE	                NVARCHAR(8)
		, LAST_UPDATED_BY		        NVARCHAR(300)
		--, SENDER_CODE	                NVARCHAR(10) -- 2026.01.13 삭제대상(UI 컬럼 없음)
		--, SENDER_NAME	                NVARCHAR(100) -- 2026.01.13 삭제대상(데이터가 공백으로만 존재 함)
		--, PROJECT_S_OP_REPORT	        NVARCHAR(100) -- 2026.01.13 삭제대상(UI 컬럼 없음)
		, NOTATION			            NVARCHAR(8)
		, CURRENCY						NVARCHAR(10)
		, VERSION_NO					NVARCHAR(100) --Version 관련
		, CUTOFF_YYYYMMDD				NVARCHAR(8) --Version 관련
		)

	IF ( @P_VERSION_TYPE LIKE '%CURRENT%' )
	BEGIN
PRINT @VA_PROGRAM_ID + ' : A017--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#TempFcstNPrice 만들기 시작 - VERSION - CURRENT';
			-- #TempFcstNPrice 만들기
			INSERT INTO #TempFcstNPrice 
			( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
			, CELL_PROD_SITE_ID , YYYYMMDD                      , QTY		             , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID           
			, DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER        --, BIZ_TYPE	          
			, SOLDTO_CUSTOMER    , COUNTRY_NAME     , CITY_NAME               --, PROJECT_STATUS    
			, ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE		    
			, FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME   --, CELL_PER_CAR         , CELL_PER_MODULE    , MODULE_PER_CAR     
			, SORT_ORDER_NO    --, ENERGE  		, CELL_QUANTITY     , AS_FROM_SITE      
			, CREATE_DATE		            , LAST_UPDATED_BY        --, SENDER_CODE            , SENDER_NAME          --, PROJECT_S_OP_REPORT
			, CURRENCY           , VERSION_NO       , CUTOFF_YYYYMMDD  		, NOTATION)      

			/* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
			-- 기본적인 MEASURE 포함
			-- MKT_FCST [R+P]의 P부분 (기준일 이후)
			-- RTF [R+P] 의 P 부분 (기준일 이후)
			SELECT A.DIVISION_ID
				 , A.PROJECT_CODE 
				 , A.END_CUSTOMER
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS					 
				 , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
				 , A.PLANT_SITE_ID
				 , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
				 , A.YYYYMMDD
				 , A.QTY
				 , B.MEASURE_GROUP
				 , C.CELL_MODEL			 
				 , C.NICK_NAME
				 , C.DMS_SALES
				 , C.DMS_CUSTOMER
				 , C.[OWNER]
				 , C.DEPT_ID
				 , C.DEPT_NAME_KO
				 , C.FORECAST_INFO_CELL_PACK_COUNT
				 , C.ITEM_TYPE
				 , C.PROJECT_NAME
				 , C.PROJECT_OWNER
				 --, C.BIZ_TYPE
				 , C.SOLDTO_CUSTOMER
				 , C.COUNTRY_NAME
				 , C.CITY_NAME
				 --, C.PROJECT_STATUS
				 , C.ITEM_NAME
				 , C.VMI_YN
				 , C.CUST_GROUP
				 , C.CUST_GROUP_DTL
				 , C.[APPLICATION]
				 , C.[ROUTE]
				 , C.MDM_PROJECT_NAME
				 , C.MIN_CAPACITY
				 , C.FORECAST_INFO_BIZ_TYPE
				 , C.CELL_TYPE
				 , C.FORECAST_INFO_ALL
				 , C.FORECAST_INFO_SPEC
				 , C.FORECAST_INFOR_VERSION
				 , C.CELL_MODEL_NICK_NAME
				 --, C.CELL_PER_CAR
				--, C.CELL_PER_MODULE
				--, C.MODULE_PER_CAR
				 , B.SORT_ORDER_NO
				 --, C.ENERGE
				 --, C.CELL_QUANTITY
				 --, A.ATTRIBUTE10 AS AS_FROM_SITE				 
				 -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
				 , LD.CREATE_DATE
				 , LD.LAST_UPDATED_BY
				 --, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
					--AND QTY <> 0) AS CREATE_DATE
				 --, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE) AS LAST_UPDATED_BY	 	
				 
				 -- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
				 --, '' AS SENDER_CODE--, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_CODE	
				 --, '' AS SENDER_NAME--, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_NAME		
				 --, C.PROJECT_S_OP_REPORT
				 , '' AS CURRENCY
				 , 'CURRENT' AS VERSION_NO
				 ,  NULL     AS CUTOFF_YYYYMMDD
				 --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
				 , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
			FROM DM_PLN_CFM_MKT_DEMAND_PLAN AS A WITH(NOLOCK)
			INNER JOIN #TempSelectMeasure AS B WITH(NOLOCK)
			ON A.MEASURE = (CASE WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'	
			                     WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP'
							ELSE B.MEASURE END)
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START---------
			OUTER APPLY (SELECT TOP(1) CREATE_DATE, LAST_UPDATED_BY
							FROM #T_LAST_DATA_SETUP_FCST LD WITH(NOLOCK) 
							WHERE LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID 
							AND LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
							--AND A.QTY <> 0 -- 0인 수량은 CREATE_DATE, LAST_UPDATED_BY가 NULL이 되어 PIVOT 에서 동일 KEY 인데 분리되는 현상 발생되어 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화
							ORDER BY LD.CREATE_DATE DESC) LD
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END---------

			INNER JOIN #TempSiteItem AS C  WITH(NOLOCK) 
			ON	A.DIVISION_ID	= C.DIVISION_ID
			AND	A.PROJECT_CODE	= C.PROJECT_CODE
			AND	A.SCM_SITE_ID	= C.SCM_SITE_ID
			AND	A.ITEM_ID		= C.ITEM_ID
			AND	C.ITEM_VALID_YN = 'Y'
			INNER JOIN #T_WS_FCST D WITH(NOLOCK) 
			ON A.FCST_TYPE = D.FCST_TYPE
			WHERE 1=1
			AND A.DIVISION_ID  = @P_DIVISION_ID
			AND CASE WHEN @P_SCM_SITE_ID   = 'ALL' THEN @P_SCM_SITE_ID   ELSE A.SCM_SITE_ID   END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,   ','))
			--AND A.MEASURE IN ('') -- 필요한 경우 추가
			--AND A.MEASURE NOT IN ('') -- 필요한 경우 추가
			AND A.YYYYMMDD BETWEEN @V_FROM_YYYYMMDD AND @V_TO_YYYYMMDD
			--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
			--AND A.QTY <> 0
			AND (
					(A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
					OR
					(A.MEASURE = 'SCM_FCST')
				)
			--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

			UNION ALL

			SELECT A.DIVISION_ID
				 , A.PROJECT_CODE 
				 , A.END_CUSTOMER
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS					 
				 , 'MKT_FCST_PP' AS MEASURE
				 , A.PLANT_SITE_ID
				 , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
				 , A.YYYYMMDD
				 , A.QTY
				 , B.MEASURE_GROUP	
				 , C.CELL_MODEL			 
				 , C.NICK_NAME
				 , C.DMS_SALES
				 , C.DMS_CUSTOMER
				 , C.[OWNER]
				 , C.DEPT_ID
				 , C.DEPT_NAME_KO
				 , C.FORECAST_INFO_CELL_PACK_COUNT
				 , C.ITEM_TYPE
				 , C.PROJECT_NAME
				 , C.PROJECT_OWNER
				 --, C.BIZ_TYPE
				 , C.SOLDTO_CUSTOMER
				 , C.COUNTRY_NAME
				 , C.CITY_NAME
				 --, C.PROJECT_STATUS
				 , C.ITEM_NAME
				 , C.VMI_YN
				 , C.CUST_GROUP
				 , C.CUST_GROUP_DTL
				 , C.[APPLICATION]
				 , C.[ROUTE]
				 , C.MDM_PROJECT_NAME
				 , C.MIN_CAPACITY
				 , C.FORECAST_INFO_BIZ_TYPE
				 , C.CELL_TYPE
				 , C.FORECAST_INFO_ALL
				 , C.FORECAST_INFO_SPEC
				 , C.FORECAST_INFOR_VERSION
				 , C.CELL_MODEL_NICK_NAME
				 --, C.CELL_PER_CAR
				 --, C.CELL_PER_MODULE
				 --, C.MODULE_PER_CAR
				 , B.SORT_ORDER_NO
				 --, C.ENERGE
				 --, C.CELL_QUANTITY
				 --, A.ATTRIBUTE10 AS AS_FROM_SITE
				 -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
				 , LD.CREATE_DATE
				 , LD.LAST_UPDATED_BY
				 --, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
					--AND QTY <> 0) AS CREATE_DATE
				 --, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE) AS LAST_UPDATED_BY	
				 -- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
				 --, '' AS SENDER_CODE--, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_CODE	
				 --, '' AS SENDER_NAME--, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_NAME		
				 --, C.PROJECT_S_OP_REPORT
				 , '' AS CURRENCY
				 , 'CURRENT' AS VERSION_NO
				 ,  NULL     AS CUTOFF_YYYYMMDD
				  --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
				 , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
			FROM DM_PLN_CFM_MKT_DEMAND_PLAN AS A WITH(NOLOCK)
			INNER JOIN #TempSelectMeasure AS B WITH(NOLOCK)
			ON  A.MEASURE = 'MKT_FCST'
			AND B.MEASURE = 'MKT_FCST_PP'
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START---------
			OUTER APPLY (SELECT TOP(1) CREATE_DATE, LAST_UPDATED_BY
							FROM #T_LAST_DATA_SETUP_FCST LD WITH(NOLOCK) 
							WHERE LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID 
							AND LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
							--AND A.QTY <> 0 -- 0인 수량은 CREATE_DATE, LAST_UPDATED_BY가 NULL이 되어 PIVOT 에서 동일 KEY 인데 분리되는 현상 발생되어 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화
							ORDER BY LD.CREATE_DATE DESC) LD
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END---------

			INNER JOIN #TempSiteItem AS C  WITH(NOLOCK) 
			ON	A.DIVISION_ID	= C.DIVISION_ID
			AND	A.PROJECT_CODE	= C.PROJECT_CODE
			AND	A.SCM_SITE_ID	= C.SCM_SITE_ID
			AND	A.ITEM_ID		= C.ITEM_ID
			AND	C.ITEM_VALID_YN = 'Y'
			INNER JOIN #T_WS_FCST D WITH(NOLOCK) 
			ON A.FCST_TYPE = D.FCST_TYPE
			WHERE 1=1
			AND A.DIVISION_ID  = @P_DIVISION_ID
			AND CASE WHEN @P_SCM_SITE_ID   = 'ALL' THEN @P_SCM_SITE_ID   ELSE A.SCM_SITE_ID   END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,   ','))
			--AND A.MEASURE IN ('') -- 필요한 경우 추가
			--AND A.MEASURE NOT IN ('') -- 필요한 경우 추가
			AND A.YYYYMMDD BETWEEN @V_FROM_YYYYMMDD AND @V_TO_YYYYMMDD
			AND A.QTY <> 0

			UNION ALL

			SELECT A.DIVISION_ID
				 , A.PROJECT_CODE 
				 , A.END_CUSTOMER
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS					 
				 , A.MEASURE
				 , A.PLANT_SITE_ID
				 , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
				 , A.YYYYMMDD
				 , ISNULL(A.PRICE,0) AS QTY
				 , B.MEASURE_GROUP	
				 , C.CELL_MODEL			 
				 , C.NICK_NAME
				 , C.DMS_SALES
				 , C.DMS_CUSTOMER
				 , C.[OWNER]
				 , C.DEPT_ID
				 , C.DEPT_NAME_KO
				 , C.FORECAST_INFO_CELL_PACK_COUNT
				 , C.ITEM_TYPE
				 , C.PROJECT_NAME
				 , C.PROJECT_OWNER
				 --, C.BIZ_TYPE
				 , C.SOLDTO_CUSTOMER
				 , C.COUNTRY_NAME
				 , C.CITY_NAME
				 --, C.PROJECT_STATUS
				 , C.ITEM_NAME
				 , C.VMI_YN
				 , C.CUST_GROUP
				 , C.CUST_GROUP_DTL
				 , C.[APPLICATION]
				 , C.[ROUTE]
				 , C.MDM_PROJECT_NAME
				 , C.MIN_CAPACITY
				 , C.FORECAST_INFO_BIZ_TYPE
				 , C.CELL_TYPE
				 , C.FORECAST_INFO_ALL
				 , C.FORECAST_INFO_SPEC
				 , C.FORECAST_INFOR_VERSION
				 , C.CELL_MODEL_NICK_NAME
				 --, C.CELL_PER_CAR
				 --, C.CELL_PER_MODULE
				 --, C.MODULE_PER_CAR
				 , B.SORT_ORDER_NO
				 --, C.ENERGE
				 --, C.CELL_QUANTITY
				 --, '' AS AS_FROM_SITE	
				 -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
				 , LD.CREATE_DATE
				 , LD.LAST_UPDATED_BY
				 --, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_PRICE WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
					--AND A.PRICE <> 0) AS CREATE_DATE
				 --, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_PRICE WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE) AS LAST_UPDATED_BY	
				 -- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
				 --, '' AS SENDER_CODE--, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_CODE	
				 --, '' AS SENDER_NAME--, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_NAME		
				 --, C.PROJECT_S_OP_REPORT
				 , A.CURRENCY
				 , 'CURRENT' AS VERSION_NO
				 ,  NULL     AS CUTOFF_YYYYMMDD
				  --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
				 , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
			FROM DM_PLN_CFM_SELLING_PRICE AS A WITH(NOLOCK)
			INNER JOIN #TempSelectMeasure B WITH(NOLOCK)
			ON  A.MEASURE		=  B.MEASURE	
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START---------
			OUTER APPLY (SELECT TOP(1) CREATE_DATE, LAST_UPDATED_BY
							FROM #T_LAST_DATA_SETUP_PRICE LD WITH(NOLOCK) 
							WHERE LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID 
							AND LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
							--AND A.QTY <> 0 -- 0인 수량은 CREATE_DATE, LAST_UPDATED_BY가 NULL이 되어 PIVOT 에서 동일 KEY 인데 분리되는 현상 발생되어 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화
							ORDER BY LD.CREATE_DATE DESC) LD
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END---------

			INNER JOIN #TempSiteItem AS C  WITH(NOLOCK) 
			ON	A.DIVISION_ID	= C.DIVISION_ID
			AND	A.PROJECT_CODE	= C.PROJECT_CODE
			AND	A.SCM_SITE_ID	= C.SCM_SITE_ID
			AND	A.ITEM_ID		= C.ITEM_ID
			AND	C.ITEM_VALID_YN = 'Y'
			INNER JOIN #T_WS_FCST D WITH(NOLOCK) 
			ON A.FCST_TYPE = D.FCST_TYPE
			WHERE 1=1
			AND A.DIVISION_ID  = @P_DIVISION_ID
			AND CASE WHEN @P_SCM_SITE_ID   = 'ALL' THEN @P_SCM_SITE_ID   ELSE A.SCM_SITE_ID   END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,   ','))
			--AND A.MEASURE IN ('') -- 필요한 경우 추가
			--AND A.MEASURE NOT IN ('') -- 필요한 경우 추가
			--AND A.YYYYMMDD BETWEEN @V_FROM_YYYYMMDD AND @V_TO_YYYYMMDD
			--AND A.YYYYMMDD BETWEEN @P_FROM_YYYYMMDD AND @V_TO_YYYYMMDD -- 주석처리 : [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경
			AND A.YYYYMMDD BETWEEN @V_TO_RESULT AND @V_TO_YYYYMMDD --계획구간만 : [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경
			--AND A.QTY <> 0


			UNION ALL
			
			/* DM_PLN_MKT_FCST_RESULT  테이블 기준 MEASURE */
			-- 2025.03.13 실적 (MKT_AMT_KRW,MKT_AMT_LOC Measure는 DM_PLN_SALES_PLAN_RESULT 테이블에서 가져옴) Start
			SELECT A.DIVISION_ID
					, A.PROJECT_CODE 
					, A.PROJECT_CODE AS END_CUSTOMER
					, A.SCM_SITE_ID
					, A.ITEM_ID
					, A.DOM_EXP
					, A.FCST_TYPE
					, A.INCOTERMS					 
					, B.MEASURE AS MEASURE -- 확인필요
					, A.PLANT_SITE_ID
					--, '-' AS CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (주석처리)
					, A.CELL_PROD_SITE_ID							-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
					, A.YYYYMMDD
					, A.QTY
					, B.MEASURE_GROUP	
					, C.CELL_MODEL			 
					, C.NICK_NAME
					, C.DMS_SALES
					, C.DMS_CUSTOMER
					, C.[OWNER]
					, C.DEPT_ID
					, C.DEPT_NAME_KO
					, C.FORECAST_INFO_CELL_PACK_COUNT
					, C.ITEM_TYPE
					, C.PROJECT_NAME
					, C.PROJECT_OWNER
					--, C.BIZ_TYPE
					, C.SOLDTO_CUSTOMER
					, C.COUNTRY_NAME
					, C.CITY_NAME
					--, C.PROJECT_STATUS
					, C.ITEM_NAME
					, C.VMI_YN
					, C.CUST_GROUP
					, C.CUST_GROUP_DTL
					, C.[APPLICATION]
					, C.[ROUTE]
					, C.MDM_PROJECT_NAME
					, C.MIN_CAPACITY
					, C.FORECAST_INFO_BIZ_TYPE
					, C.CELL_TYPE
					, C.FORECAST_INFO_ALL
					, C.FORECAST_INFO_SPEC
					, C.FORECAST_INFOR_VERSION
					, C.CELL_MODEL_NICK_NAME
					--, C.CELL_PER_CAR
					--, C.CELL_PER_MODULE
					--, C.MODULE_PER_CAR
					, B.SORT_ORDER_NO
					--, C.ENERGE
					--, C.CELL_QUANTITY
					--, A.ATTRIBUTE10 AS AS_FROM_SITE
					-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
					, LD.CREATE_DATE
					, LD.LAST_UPDATED_BY
					--, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
					--AND QTY <> 0) AS CREATE_DATE
					--, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
					--WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID 
					--AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE) AS LAST_UPDATED_BY
					-- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
					--, '' AS SENDER_CODE--, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_CODE	
					--, '' AS SENDER_NAME--, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_NAME		
					--, C.PROJECT_S_OP_REPORT
					, IIF(A.MEASURE LIKE 'VMI%', '', A.CURRENCY) AS CURRENCY		--실적데이터도 통화를 보여주기 위해 테이블 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경
					--, '' AS CURRENCY  --주석처리 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경
					, 'CURRENT' AS VERSION_NO
					,  NULL     AS CUTOFF_YYYYMMDD
					 --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
					, CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC', 'MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
			FROM DM_PLN_SALES_PLAN_RESULT AS A WITH(NOLOCK) --DM_PLN_MKT_FCST_RESULT AS A WITH(NOLOCK) --실적데이터도 통화를 보여주기 위해 테이블 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경
			INNER JOIN #TempSelectMeasure AS B WITH(NOLOCK)
			ON  A.MEASURE =  B.RESULT_MEASURE
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START---------
			OUTER APPLY (SELECT TOP(1) CREATE_DATE, LAST_UPDATED_BY
							FROM #T_LAST_DATA_SETUP_FCST LD WITH(NOLOCK) 
							WHERE LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID 
							AND LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
							--AND A.QTY <> 0 -- 0인 수량은 CREATE_DATE, LAST_UPDATED_BY가 NULL이 되어 PIVOT 에서 동일 KEY 인데 분리되는 현상 발생되어 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화
							ORDER BY LD.CREATE_DATE DESC) LD
			-- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END---------

			INNER JOIN #TempSiteItem AS C  WITH(NOLOCK) 
			ON	A.DIVISION_ID	= C.DIVISION_ID
			AND	A.PROJECT_CODE	= C.PROJECT_CODE
			AND	A.SCM_SITE_ID	= C.SCM_SITE_ID
			AND	A.ITEM_ID		= C.ITEM_ID
			AND	C.ITEM_VALID_YN = 'Y'
			INNER JOIN #T_WS_FCST D WITH(NOLOCK) 
			ON A.FCST_TYPE = D.FCST_TYPE
			WHERE 1=1
			AND A.DIVISION_ID = @P_DIVISION_ID
			AND CASE WHEN @P_SCM_SITE_ID   = 'ALL' THEN @P_SCM_SITE_ID ELSE A.SCM_SITE_ID END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,   ','))
			AND A.YYYYMMDD >= @P_FROM_YYYYMMDD AND A.YYYYMMDD < @V_TO_RESULT
			AND A.QTY <> 0
		
			UPDATE A
			   SET A.CURRENCY = SP.CURRENCY
			  FROM #TempFcstNPrice A 
			  JOIN (SELECT DISTINCT SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID   
						,SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CURRENCY, SP.CELL_PROD_SITE_ID 
					  --FROM DBO.DM_PLN_CFM_SELLING_PRICE SP WITH(NOLOCK)
					  FROM #TempFcstNPrice SP -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
					 WHERE 1=1
					   AND SP.DIVISION_ID = @P_DIVISION_ID
					   AND CASE WHEN @P_SCM_SITE_ID   = 'ALL' THEN @P_SCM_SITE_ID ELSE SP.SCM_SITE_ID END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_SCM_SITE_ID,   ','))
					   AND SP.YYYYMMDD BETWEEN @V_TO_RESULT AND @V_TO_YYYYMMDD
					   AND SP.MEASURE = 'LOC') SP
				ON (A.DIVISION_ID = SP.DIVISION_ID
				AND A.PROJECT_CODE = SP.PROJECT_CODE
				AND A.SCM_SITE_ID = SP.SCM_SITE_ID
				AND A.PLANT_SITE_ID = SP.PLANT_SITE_ID
				AND A.ITEM_ID = SP.ITEM_ID
				AND A.INCOTERMS = SP.INCOTERMS
				AND A.DOM_EXP = SP.DOM_EXP
				AND A.FCST_TYPE = SP.FCST_TYPE
				AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID)
			  WHERE 1=1
			    AND A.YYYYMMDD BETWEEN @P_FROM_YYYYMMDD AND @V_TO_YYYYMMDD -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
				AND ISNULL(A.CURRENCY,'') = ''
				AND A.MEASURE NOT LIKE 'VMI%';
			
			-----------------------------------------------------------------------------------------------------------
			-- #TempFcstNPrice 에 INSERT 한 메저들을 이용하여 판가 실적 계산
			-- LOC = MKT_AMT_LOC/RTF_SYS_RP
			-- KRW = MKT_AMT_KRW/RTF_SYS_RP
			-----------------------------------------------------------------------------------------------------------
			INSERT INTO #TempFcstNPrice 
			( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
			, CELL_PROD_SITE_ID , YYYYMMDD                      , QTY		             , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID           
			, DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER        --, BIZ_TYPE	          
			, SOLDTO_CUSTOMER    , COUNTRY_NAME     , CITY_NAME               --, PROJECT_STATUS    
			, ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE		    
			, FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME   --, CELL_PER_CAR         , CELL_PER_MODULE    , MODULE_PER_CAR     
			, SORT_ORDER_NO    --, ENERGE                , CELL_QUANTITY   	, AS_FROM_SITE      
			, CREATE_DATE		            , LAST_UPDATED_BY        --, SENDER_CODE            , SENDER_NAME          --, PROJECT_S_OP_REPORT
			, CURRENCY           , VERSION_NO       , CUTOFF_YYYYMMDD  		, NOTATION)      
			--기존 소스 개선 및 FCST GAP 추가 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST) START -------------------
			SELECT A.DIVISION_ID
				, A.PROJECT_CODE 
				, A.PROJECT_CODE AS END_CUSTOMER
				, A.SCM_SITE_ID
				, A.ITEM_ID
				, A.DOM_EXP
				, A.FCST_TYPE
				, A.INCOTERMS					 
				, D.MEASURE
				, A.PLANT_SITE_ID
				 --, '-' AS CELL_PROD_SITE_ID						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (주석처리)
				 , A.CELL_PROD_SITE_ID								-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
				, A.YYYYMMDD
				, CASE D.MEASURE WHEN 'LOC' THEN IIF(SUM(IIF(A.MEASURE = 'RTF_SYS_RP', A.QTY, 0)) <> 0, SUM(IIF(A.MEASURE = 'MKT_AMT_LOC', A.QTY, 0)) / SUM(IIF(A.MEASURE = 'RTF_SYS_RP', A.QTY, 0)), 0)
								 WHEN 'KRW' THEN IIF(SUM(IIF(A.MEASURE = 'RTF_SYS_RP', A.QTY, 0)) <> 0, SUM(IIF(A.MEASURE = 'MKT_AMT_KRW', A.QTY, 0)) / SUM(IIF(A.MEASURE = 'RTF_SYS_RP', A.QTY, 0)), 0)
				  END AS QTY 
				, MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
				, MAX(A.CELL_MODEL) AS CELL_MODEL		 
				, MAX(A.NICK_NAME) AS NICK_NAME
				, MAX(A.DMS_SALES) AS DMS_SALES 
				, MAX(A.DMS_CUSTOMER) AS DMS_CUSTOMER
				, MAX(A.[OWNER]) AS [OWNER]
				, MAX(A.DEPT_ID) AS DEPT_ID
				, MAX(A.DEPT_NAME_KO) AS DEPT_NAME_KO
				, MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
				, MAX(A.ITEM_TYPE) AS ITEM_TYPE
				, MAX(A.PROJECT_NAME) AS PROJECT_NAME
				, MAX(A.PROJECT_OWNER) AS PROJECT_OWNER
				--, MAX(A.BIZ_TYPE) AS BIZ_TYPE
				, MAX(A.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
				, MAX(A.COUNTRY_NAME) AS COUNTRY_NAME
				, MAX(A.CITY_NAME) AS CITY_NAME
				--, MAX(A.PROJECT_STATUS) AS PROJECT_STATUS
				, MAX(A.ITEM_NAME) AS ITEM_NAME
				, MAX(A.VMI_YN) AS VMI_YN
				, MAX(A.CUST_GROUP) AS CUST_GROUP
				, MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL
				, MAX(A.[APPLICATION]) AS [APPLICATION]
				, MAX(A.[ROUTE]) AS [ROUTE]
				, MAX(A.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
				, MAX(A.MIN_CAPACITY) AS MIN_CAPACITY
				, MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
				, MAX(A.CELL_TYPE) AS CELL_TYPE
				, MAX(A.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL
				, MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
				, MAX(A.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
				, MAX(A.CELL_MODEL_NICK_NAME) AS CELL_MODEL_NICK_NAME
				--, MAX(A.CELL_PER_CAR) AS CELL_PER_CAR
				--, MAX(A.CELL_PER_MODULE) AS CELL_PER_MODULE
				--, MAX(A.MODULE_PER_CAR) AS MODULE_PER_CAR
				, MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO
				--, MAX(A.ENERGE) AS ENERGE
				--, MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
				--, MAX(A.AS_FROM_SITE) AS AS_FROM_SITE
				, MAX(A.CREATE_DATE) AS CREATE_DATE
				, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY	
				--, MAX(A.SENDER_CODE) AS  SENDER_CODE
				--, MAX(A.SENDER_NAME) AS  SENDER_NAME                  
				--, MAX(A.PROJECT_S_OP_REPORT) AS  PROJECT_S_OP_REPORT
				, MAX(A.CURRENCY) AS CURRENCY
				, 'CURRENT' AS VERSION_NO
				,  NULL     AS CUTOFF_YYYYMMDD
				--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
				, CASE WHEN D.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
		   FROM #TempFcstNPrice AS A WITH(NOLOCK) 
		   JOIN #TempSelectMeasure AS D WITH(NOLOCK)
			 ON  D.MEASURE   IN ( 'LOC', 'KRW')	
		  WHERE 1=1
		    AND A.MEASURE IN ('RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW')
			AND A.YYYYMMDD >= @P_FROM_YYYYMMDD 
			AND A.YYYYMMDD < @V_TO_RESULT
		  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
				, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
				, A.CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
				, A.CURRENCY, A.YYYYMMDD, D.MEASURE
		-----------------------------------------------------------------------------------------------------------
		-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT FCST Amt. /RTF[R+P])  END			
		-----------------------------------------------------------------------------------------------------------
			
PRINT @VA_PROGRAM_ID + ' : A018--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'#TempFcstNPrice 만들기 종료 - VERSION - CURRENT';
		--SELECT '#TempFcstNPrice',* FROM #TempFcstNPrice -- 테스트
	END


	-----------------------------------------------------------------------------------------------
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 START
	--Unit Price 계산 후 불필요 MEASURE 삭제 (삭제하지 않으면 화면에서 보임)
	-----------------------------------------------------------------------------------------------
	DELETE A
	FROM #TempFcstNPrice     A
	JOIN #TempSelectMeasure  B
	  ON (A.MEASURE = B.MEASURE)
	WHERE 1=1
	AND B.USER_ID = 'DM_ADMIN'
	-----------------------------------------------------------------------------------------------
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 END
	-----------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

	/* 최종적으로 동적쿼리로 조회 할 쿼리문을 완성 후 실행한다. */
	
	/* 동적쿼리에서 사용 할 동적 컬럼을 만드는 커서 */
	/* C_TITLE : 선택한 bucket의 값인 MONTH 혹은 WEEK를 이용해서 동적인 컬럼을 만드는 커서 */

	/* @v_group_id 권한 그룹*/

	/* 동적쿼리에서만 사용 하는 임시테이블 */
	IF OBJECT_ID (N'tempdb..#CAL_MONTH_END_DATE', N'U')	   IS NOT NULL DROP TABLE #CAL_MONTH_END_DATE
	IF OBJECT_ID (N'dbo.#CAL_MONTH_END_DATE', N'U')		   IS NOT NULL DROP TABLE #CAL_MONTH_END_DATE
	IF OBJECT_ID (N'tempdb..#CAL_WEEK_END_DATE', N'U')	   IS NOT NULL DROP TABLE #CAL_WEEK_END_DATE
	IF OBJECT_ID (N'dbo.#CAL_WEEK_END_DATE', N'U')		   IS NOT NULL DROP TABLE #CAL_WEEK_END_DATE

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
	/* C_TITLE : 선택한 bucket의 값인 MONTH 혹은 WEEK를 이용해서 동적인 컬럼을 만드는 커서 - 시작 */ 
	
	/* C_TITLE 커서 시작 */
	/* C_TITLE 커서 시작 */
	/* C_TITLE 커서 시작 */

	/* C_TITLE 커서에서만 사용 될 지역변수 */
	--현재 쿼리 보면 @V_CUR_COLUMN_NAME 만 실사용 된다.
	DECLARE @V_CUR_COLUMN_NAME       AS NVARCHAR(100)
    DECLARE @V_CUR_PROGRAM_ID        AS NVARCHAR(10)
    DECLARE @V_CUR_SHEET_NAME        AS NVARCHAR(100)
    DECLARE @V_CUR_SORT_ORDER_NO     AS NVARCHAR(50)

	/* C_TITLE 커서에서 완성 된 후 동적쿼리에서 쓰여질 변수 */
    DECLARE @V_COLUMN            AS NVARCHAR(1000)
    DECLARE @V_GROUPBY           AS NVARCHAR(1000)
    DECLARE @V_ORDERBY           AS NVARCHAR(1000)
    SET @V_COLUMN  = ''; --필수
    SET @V_GROUPBY = '';
    SET @V_ORDERBY = '';

	DECLARE C_TITLE CURSOR LOCAL FAST_FORWARD FOR --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME   
				, (CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
						WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
						ELSE U.SORT_ORDER_NO END) AS SORT_ORDER_NO
		FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
				, [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = @VA_PROGRAM_ID
		AND    U.SHEET_NAME  = @VA_SHEET_NAME
		AND    U.USER_ID     = @p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
		UNION ALL
		/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME 
				, CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  ISNULL(U.SORT_ORDER_NO,85) - 0.5 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO      
		FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
		LEFT OUTER JOIN [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			ON     U.PROGRAM_ID  = C.PROGRAM_ID
			AND    U.SHEET_NAME  = C.SHEET_NAME 
			AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
			AND	   U.COLUMN_NAME IN ('ITEM_ID') 
			AND    U.USER_ID = @p_created_by
		WHERE  1 = 1    
		AND    C.PROGRAM_ID  = @VA_PROGRAM_ID
		AND    C.SHEET_NAME  = @VA_SHEET_NAME
		AND    C.DEFAULT_FLAG = ''
		AND    C.VALID_YN     = 'Y'
		ORDER BY SORT_ORDER_NO ;
	
	OPEN C_TITLE;
	
PRINT @VA_PROGRAM_ID + ' : A025--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#C_TITLE 커서 실행 시작';

	FETCH NEXT FROM C_TITLE INTO @V_CUR_PROGRAM_ID, @V_CUR_SHEET_NAME, @V_CUR_COLUMN_NAME, @V_CUR_SORT_ORDER_NO
	  WHILE @@FETCH_STATUS = 0   
	  BEGIN  
		IF @V_COLUMN = ''
			BEGIN
				SET @V_COLUMN  =  @V_CUR_COLUMN_NAME;
				SET @V_GROUPBY = ' GROUP BY ' + @V_CUR_COLUMN_NAME;
				SET @V_ORDERBY = ' ORDER BY SORT_KEY, ' + CASE WHEN @V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN @V_CUR_COLUMN_NAME ELSE '' END
			END;
		ELSE
			BEGIN
				SET @V_COLUMN  = @V_COLUMN  + ', ' + @V_CUR_COLUMN_NAME;
				SET @V_GROUPBY = @V_GROUPBY + ', ' + @V_CUR_COLUMN_NAME;
				SET @V_ORDERBY = @V_ORDERBY + CASE WHEN @V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN ', ' + @V_CUR_COLUMN_NAME ELSE '' END
			END;
    
		FETCH NEXT FROM C_TITLE INTO @V_CUR_PROGRAM_ID, @V_CUR_SHEET_NAME, @V_CUR_COLUMN_NAME, @V_CUR_SORT_ORDER_NO
	  END;
  
	  --[E20240812-000094]_해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가 START
	  SET @V_COLUMN = @V_COLUMN + ',[NOTATION]'			
	  --[E20240812-000094]_해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가 END

	  SET @V_GROUPBY = @V_GROUPBY + ', EDIT_FLAG, SORT_ORDER_NO';
	  SET @V_ORDERBY = REPLACE(@V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMERIC(10,2))');
	  SET @V_ORDERBY = REPLACE(@V_ORDERBY, ', MEASURE', '');

	  CLOSE C_TITLE;  
	  DEALLOCATE C_TITLE;

	  --SELECT 'C_TITLE',@V_COLUMN AS V_COLUMN,@V_GROUPBY AS V_GROUPBY,@V_ORDERBY AS V_ORDERBY -- 테스트
	  
PRINT @VA_PROGRAM_ID + ' : A026--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#C_TITLE 커서 실행 종료';

	/* C_TITLE 커서 종료 */
	/* C_TITLE 커서 종료 */
	/* C_TITLE 커서 종료 */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
	DECLARE @V_GROUP_ID nvarchar(50) = '';
	---------------------------------------------------------------------------------
	--            권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT1 = @P_USER_GROUP
						AND SEGMENT2 = 'ALL'
						--AND SEGMENT3 = LEFT(@P_DIVISION_ID,2)
			  ),0) > 0
		BEGIN
			SET @V_GROUP_ID = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--           권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------
	--사용자의 요건: 소형사업부 계획수립 Timeline 단축으로 MKT FCST / SCM FCST가 월요일에 진행됨에 따라
	--MKT FCST 입력 제한을 시간 단위로 제한할 수 있도록 기능 개발 필요
	--[Timeline 단축에 따른 월요일 MKT FCST, SCM FCST 입력 시간 변경]
	--기존 월 24시 DM cutoff → 기존에는 화요일에 SCM_FCST만 입력 가능하도록 되어 있었으나, 
	--변경 월 15시 DM Cutoff → 월 15시 30분 ~ 17시 30분 까지 SCM FCST 수정하고자 함

	--기존 룩업은 모든 메져에 날짜가 적혀있었는데, 의미없음. 실제 제한을 하는 메져만 일자를 두는것으로 룩업구성 변경함
	--룩업명: GET_ADMIN_GROUP_MEASURE 
	
	IF OBJECT_ID (N'tempdb..#TEMP_INTO_GROUP_MEASURE', N'U')     
		IS NOT NULL DROP TABLE #TEMP_INTO_GROUP_MEASURE	

	IF OBJECT_ID (N'tempdb..#TEMP_ADMIN_GROUP_MEASURE', N'U')     
		IS NOT NULL DROP TABLE #TEMP_ADMIN_GROUP_MEASURE
		
	--1). GET_ADMIN_GROUP_MEASURE 룩업에서 데이터를 TEMP로 담는다 
	SELECT B.USER_GROUP, B.DIVISION_ID, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME, TOKEN AS LIMIT_MEASURE
	INTO #TEMP_INTO_GROUP_MEASURE
	FROM (	SELECT A.SEGMENT1 AS USER_GROUP, A.SEGMENT3 AS DIVISION_ID, A.SEGMENT4 AS MEASURE, TOKEN AS DAYS
					, A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME, A.ATTRIBUTE4 AS LIMIT_MEASURE
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
			CROSS APPLY STRING_SPLIT(A.ATTRIBUTE1, ',')
			WHERE A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE' 
			AND A.VALID_YN = 'Y'
			AND A.SEGMENT1 = @p_user_group
			AND A.SEGMENT2 = @VA_PROGRAM_ID
			AND A.SEGMENT3 = @p_division_id
		) B
	CROSS APPLY STRING_SPLIT(B.LIMIT_MEASURE, ',')
	WHERE B.DAYS = CASE WHEN ISNULL(REPLACE(B.DAYS,' ',''),'') = '' THEN B.DAYS ELSE CASE WHEN(DATEPART(WEEKDAY,GETDATE()) = '1') THEN N'SUN' --일
																						  WHEN(DATEPART(WEEKDAY,GETDATE()) = '2') THEN N'MON' --월
																						  WHEN(DATEPART(WEEKDAY,GETDATE()) = '3') THEN N'TUE' --화
																						  WHEN(DATEPART(WEEKDAY,GETDATE()) = '4') THEN N'WED' --수
																						  WHEN(DATEPART(WEEKDAY,GETDATE()) = '5') THEN N'THU' --목
																						  WHEN(DATEPART(WEEKDAY,GETDATE()) = '6') THEN N'FRI' --금
																						  WHEN(DATEPART(WEEKDAY,GETDATE()) = '7') THEN N'SAT' --토
																					 END 
				   END
	AND B.FROM_TIME <= CASE WHEN ISNULL(REPLACE(B.FROM_TIME,' ',''),'') = '' THEN B.FROM_TIME ELSE LEFT(REPLACE(CONVERT(CHAR(8), GETDATE(), 24), ':', ''), 4) END
	AND B.TO_TIME >= CASE WHEN ISNULL(REPLACE(B.TO_TIME,' ',''),'') = '' THEN B.TO_TIME ELSE LEFT(REPLACE(CONVERT(CHAR(8), GETDATE(), 24), ':', ''), 4) END

	--2). 실제 관리하는 MEASURE와 권한이 가진 메져가 다른 경우가 있을수 있으므로, 해당 화면 기준으로 메져를 구한다음에 위에서 구한 메져로 EDIT_FLAG로 붙여준다 
	SELECT A.MEASURE
		 , CASE WHEN ISNULL(B.MEASURE, '') = '' THEN 'N' ELSE 'Y' END AS EDIT_FLAG 
	INTO #TEMP_ADMIN_GROUP_MEASURE
	FROM
	(	SELECT A.SEGMENT4 AS MEASURE
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
		WHERE A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE' 
		AND A.VALID_YN = 'Y'
		AND A.SEGMENT2 = @VA_PROGRAM_ID--'DMF0082'
		GROUP BY A.SEGMENT4 ) A
	LEFT OUTER JOIN (	SELECT B.MEASURE FROM #TEMP_INTO_GROUP_MEASURE B WITH(NOLOCK) 
						GROUP BY B.MEASURE ) B 
				 ON A.MEASURE = B.MEASURE
	
	--3). #TEMP_INTO_GROUP_MEASURE 테이블에 적재한 데이터 중 LIMIT_MEASURE가 존재하는 경우 해당 메져의 FLAG는 N으로 변경해준다
	IF ( SELECT COUNT(A.LIMIT_MEASURE) FROM #TEMP_INTO_GROUP_MEASURE A WHERE ISNULL(A.LIMIT_MEASURE, '') != '') >= 1
	BEGIN
		UPDATE A
		SET A.EDIT_FLAG = 'N'
		FROM #TEMP_ADMIN_GROUP_MEASURE A
		INNER JOIN #TEMP_INTO_GROUP_MEASURE B
				ON A.MEASURE = B.LIMIT_MEASURE
	END

	IF OBJECT_ID (N'tempdb..#TEMP_INTO_GROUP_MEASURE', N'U')     
		IS NOT NULL DROP TABLE #TEMP_INTO_GROUP_MEASURE	

	--[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 END
	-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--#CAL_MONTH_END_DATE 만들기 시작
		SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
		INTO #CAL_MONTH_END_DATE
          FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) 
         WHERE BASIS_YYYYMMDD BETWEEN  @p_from_yyyymmdd AND @p_to_yyyymmdd 
         GROUP BY BASIS_YYYYMM
		 --SELECT * FROM #CAL_MONTH_END_DATE
PRINT @VA_PROGRAM_ID + ' : A027--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#CAL_MONTH_END_DATE 만들기 성공';

		--#CAL_WEEK_END_DATE 만들기 시작
		SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
		INTO #CAL_WEEK_END_DATE
          FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) 
         WHERE BASIS_YYYYMMDD BETWEEN  @p_from_yyyymmdd AND @p_to_yyyymmdd 
         GROUP BY ISO_YYYYWW+PARTIAL_WEEK_NAME
		 --SELECT * FROM #CAL_WEEK_END_DATE
PRINT @VA_PROGRAM_ID + ' : A028--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#CAL_WEEK_END_DATE 만들기 성공';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
		/* 동적쿼리에서 사용될 MF_SP 임시테이블 */
PRINT @VA_PROGRAM_ID + ' : A029--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#MF_SP 임시테이블 만들기 시작';
		IF OBJECT_ID (N'tempdb..#MF_SP', N'U')         IS NOT NULL DROP TABLE #MF_SP
		SELECT    
					  A.DIVISION_ID
					, A.SCM_SITE_ID
					, A.PLANT_SITE_ID
					, A.PROJECT_CODE
					--, ISNULL(I.GROUP_ID,'') AS GROUP_ID 
					, A.ITEM_ID  
					, A.INCOTERMS
					, A.FCST_TYPE 
					, A.DOM_EXP
					, A.MEASURE
					, A.END_CUSTOMER
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
					--, A.BIZ_TYPE
					, A.SOLDTO_CUSTOMER
					, A.COUNTRY_NAME
					, A.CITY_NAME
					--, A.PROJECT_STATUS
					, A.ITEM_NAME
					, A.VMI_YN
					, A.CELL_PROD_SITE_ID
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
					, CAST(a.QTY as numeric(36,10)) AS QTY
                    , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
                    , CASE WHEN C3.WEEK_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
					, CASE 
						WHEN MA.Dept_id IS NOT NULL    and a.MEASURE_GROUP not in ('CUST_FCST_2','CUST_FCST_3','TMM_FCST') and a.MEASURE = M1.SEGMENT3  -- 같은부서+MktFcst등 (TMM 제외)										
							THEN 'Y'
						WHEN (@V_GROUP_ID ='ADMIN') and a.MEASURE_GROUP <> 'TMM_FCST' and a.MEASURE		= M1.SEGMENT3  -- Admin권한자+MktFcst등 (TMM 제외)
							THEN 'Y'
						ELSE
							'N'
					  END AS EDIT_FLAG 
					--, A.CELL_PER_CAR
					--, A.CELL_PER_MODULE
					--, A.MODULE_PER_CAR
					, A.SORT_ORDER_NO  -- Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
					, A.MEASURE_GROUP  -- Measure Join 조건이 최종데이터를 중복으로 체크하는 부분을 상단 추출로직으로 올려 속도개선
					--, A.ENERGE
					--, A.CELL_QUANTITY
					, 'N' AS NEW_FLAG
					--, ISNULL(B1.ATTR1,NULL) AS ATTR
					, ISNULL(BK.BUCKET, '0000000') AS BUCKET
					, 999 AS SORT_KEY
					--, ISNULL(A.AS_FROM_SITE,'') AS AS_FROM_SITE
					, CASE WHEN ISNULL(A.CREATE_DATE, '')     = '' THEN ' ' ELSE A.CREATE_DATE END     AS LAST_UPDATE_DATE
					, CASE WHEN ISNULL(A.LAST_UPDATED_BY, '') = '' THEN ' ' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY
					--, CASE WHEN ISNULL(A.SENDER_CODE, '')     = '' THEN ' ' ELSE A.SENDER_CODE END     AS SENDER_CODE
					--, CASE WHEN ISNULL(A.SENDER_NAME, '')     = '' THEN ' ' ELSE A.SENDER_NAME END     AS SENDER_NAME
					--, A.PROJECT_S_OP_REPORT
					, A.NOTATION
					, A.CURRENCY
					, A.VERSION_NO
					, A.CUTOFF_YYYYMMDD
		INTO #MF_SP
		FROM #TempFcstNPrice a
		INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK)ON  c.BASIS_YYYYMMDD = a.YYYYMMDD	
		--LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I WITH(NOLOCK) ON A.DIVISION_ID = I.DIVISION_ID	AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID			
		LEFT OUTER JOIN #CAL_MONTH_END_DATE C2 ON A.YYYYMMDD = C2.MONTH_END_DATE
        LEFT OUTER JOIN #CAL_WEEK_END_DATE C3 ON A.yyyymmdd = C3.WEEK_END_DATE  
		--LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL X ON A.SCM_SITE_ID = X.SEGMENT1 AND X.LOOKUP_TYPE = 'AS_SITE_PLANT'
		LEFT JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M1 WITH(NOLOCK)   -- EDIT가 가능한 MEASURE (수정 해야 하는 MEASURE가 생기면 아래 룩업에 추가해야한다)
 				ON  a.DIVISION_ID	= M1.SEGMENT2  -- DIVISION_ID		 -- 그리고 수정 해야하는 새로운 MEASURE가 생겼을때 권한그룹별이나 요일별로 관리해야 한다면 필요시 GET_ADMIN_GROUP_MEASURE 에도 넣어야 한다.
				AND a.MEASURE		= M1.SEGMENT3  -- MEASURE
				AND M1.LOOKUP_TYPE	= 'DM_UI_EDITABLE_MEASURE'
				AND M1.SEGMENT1     = 'DMF0082'
				AND M1.ATTRIBUTE2	= 'Y'       -- EDIT_YN 여부
				AND M1.VALID_YN		= 'Y'       -- VALID_YN 여부
		LEFT OUTER JOIN (
				SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, CONCAT(ISNULL([SUN],0), ISNULL([MON],0) , ISNULL([TUE],0) , ISNULL([WED],0) , ISNULL([THU],0) , ISNULL([FRI],0) , ISNULL([SAT],0)) AS BUCKET
				FROM (
					SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD, CASE WHEN BUCKET_PER = 'Y' THEN 1 ELSE 0 END AS BUCKET_PER
					FROM DM_MST_BUCKET_CONVERSION
					) A
				PIVOT ( 
					   MAX(BUCKET_PER) FOR YYYYMMDD IN ([SUN], [MON], [TUE], [WED], [THU], [FRI], [SAT])
					  ) AS PVT 
				WHERE DIVISION_ID = @P_DIVISION_ID 
			) BK ON A.DIVISION_ID = BK.DIVISION_ID AND A.SCM_SITE_ID = BK.SCM_SITE_ID AND A.INCOTERMS = BK.INCOTERMS
		--부서 테이블 추가
		LEFT OUTER JOIN (
			SELECT LOOK.SEGMENT3 as Dept_ID
			FROM   [dbo].[TB_FX_User] AS USR WITH(NOLOCK)
			INNER JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] AS LOOK WITH(NOLOCK)
			ON USR.DEPT_ID = LOOK.SEGMENT1 AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING' AND LOOK.VALID_YN = 'Y'
			WHERE  USR.UserID = @p_created_by
			UNION -- 중복값 있으면 안됨
			SELECT Dept_ID
			FROM   [dbo].[TB_FX_User] WITH(NOLOCK)
			WHERE UserID = @p_created_by
		) AS MA ON A.dept_id = MA.DEPT_id
		WHERE 1=1 
	        AND CASE WHEN @P_TEAM_ID = 'ALL' THEN @P_TEAM_ID ELSE A.DEPT_ID END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@P_TEAM_ID,',') )
			
PRINT @VA_PROGRAM_ID + ' : A030--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'#MF_SP 임시테이블 만들기 종료';
		--OPTION (HASH JOIN) 
		--SELECT '#MF_SP', * FROM #MF_SP
		--SELECT '#TempFcstNPrice',* FROM #TempFcstNPrice

    --2025.03.10 Philsu Park: MKT Fcst 수량 없는거 날리고 조회하는 구문 테스트.
	IF @p_qty_yn = 'Y'
	BEGIN
		DELETE  SP
		FROM    #MF_SP SP
		WHERE   NOT EXISTS (SELECT 1
							FROM ( SELECT     DIVISION_ID
											, SCM_SITE_ID
											, PROJECT_CODE
											, ITEM_ID
											, INCOTERMS
											, FCST_TYPE
											, DOM_EXP
											, END_CUSTOMER
											, CELL_PROD_SITE_ID
									FROM    #MF_SP
									WHERE   MEASURE IN('MKT_FCST','SCM_FCST') --PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : SCM_FCST - MEASURE 추가
									GROUP BY  DIVISION_ID
											, SCM_SITE_ID
											, PROJECT_CODE
											, ITEM_ID
											, INCOTERMS
											, FCST_TYPE
											, DOM_EXP
											, END_CUSTOMER
											, CELL_PROD_SITE_ID
									HAVING  SUM(QTY) <> 0
								) AS TT
							WHERE   1=1
							AND TT.DIVISION_ID          = SP.DIVISION_ID
							AND TT.SCM_SITE_ID          = SP.SCM_SITE_ID
							AND TT.PROJECT_CODE         = SP.PROJECT_CODE
							AND TT.ITEM_ID              = SP.ITEM_ID
							AND TT.INCOTERMS            = SP.INCOTERMS
							AND TT.FCST_TYPE            = SP.FCST_TYPE
							AND TT.DOM_EXP              = SP.DOM_EXP
							AND TT.END_CUSTOMER         = SP.END_CUSTOMER
							AND TT.CELL_PROD_SITE_ID    = SP.CELL_PROD_SITE_ID
							)
    END

	/* 최종적으로 실행하는 동적쿼리 */
	DECLARE @v_sql_text AS NVARCHAR(MAX);
    
	SET @v_sql_text = 
		CONVERT(NVARCHAR(MAX), '')  +
		+ N'
		SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]    
		FROM (   	SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
					FROM   #MF_SP F	
					WHERE 1=1
					--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
					AND (
							(F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST) 
							OR
							(F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') ) --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)
						)
					--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

					UNION ALL

					SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' + F.YYYYMMWW AS YYYYMMDD
							, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'' ) AND F.WEEK_END_YN = ''Y'' THEN  SUM (F.QTY)  
								   ELSE SUM(F.QTY) 
								END AS QTY
					FROM #MF_SP F
					WHERE 1=1
					  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 
					--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
					--F.QTY <> 0
					AND (
							(F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)
							OR
							(F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') ) --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)
						)
					--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
					GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN

					-------------------------------------------------------------------------------
					-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 START
					-- Weekly Sum 에서 LOC,KRW,USD 는 평균값으로 보이도록 소스 분리 
					------------------------------------------------------------------------------

					UNION ALL

					SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' + F.YYYYMMWW AS YYYYMMDD
							, AVG(QTY) AS QTY
					FROM #MF_SP F
					WHERE 1=1
					  AND F.MEASURE  IN  (''KRW'', ''USD'', ''LOC''  ) 
					GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW
					-------------------------------------------------------------------------------
					-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 END
					-- Weekly Sum 에서 LOC,KRW,USD 는 평균값으로 보이도록 소스 분리 
					------------------------------------------------------------------------------

					UNION ALL

					SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' + F.YYYYMM AS YYYYMMDD
						, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv''  ) AND F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)  
									ELSE SUM(F.QTY) 
								END AS QTY
					FROM #MF_SP F
					WHERE 1=1
					  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 
					--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
					--F.QTY <> 0
					AND (
							(F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)
							OR
							(F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') ) --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)
						)
					--[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
					GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN

					-------------------------------------------------------------------------------
					-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 START
					-- Monthly Sum 에서 LOC,KRW,USD 는 월 마지막 일자와 상관없이 일자 전체 평균값으로 보이도록 소스 분리 
					------------------------------------------------------------------------------

					UNION ALL

					SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' + F.YYYYMM AS YYYYMMDD
							, AVG(QTY) AS QTY
					FROM #MF_SP F
					WHERE 1=1
					  AND F.MEASURE IN  (''KRW'', ''USD'', ''LOC''  ) 
					GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM

					-------------------------------------------------------------------------------
					-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 END
					-- Monthly Sum 에서 LOC,KRW,USD 는 월 마지막 일자와 상관없이 일자 전체 평균값으로 보이도록 소스 분리 
					------------------------------------------------------------------------------
			) F
		PIVOT (SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )) AS PVT
		[@V_ORDERBY]
		option ( order group ) 
			'; 

  --SELECT 'v_sql_text',@v_sql_text,DATALENGTH(@v_sql_text),LEN(@v_sql_text) -- 테스트
  --SELECT @v_PV_LIST as v_PV_LIST,@v_PV_COL_LIST as v_PV_COL_LIST -- 테스트
  
PRINT @VA_PROGRAM_ID + ' : A031--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +N'동적 쿼리문 변경 시작';
    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_COL_LIST]'       , @v_PV_LIST);
	PRINT ( 'AAA1--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + ' '+ @v_PV_LIST); 

    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_LIST]'           , @v_PV_LIST);  
    PRINT ( 'AAA2--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + ' '+ @v_PV_LIST); 

    SET @v_sql_text = REPLACE(@v_sql_text,'[@V_COLUMN]'            , @V_COLUMN);
    PRINT ( 'AAA3--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + ' '+ @V_COLUMN);

    SET @v_sql_text = REPLACE(@v_sql_text,'[@V_ORDERBY]'		     , @V_ORDERBY);
    PRINT ( 'AAA4--' + CONVERT(NVARCHAR(30), GETDATE(), 121) + ' '+ @V_ORDERBY);
PRINT @VA_PROGRAM_ID + ' : A032--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'동적 쿼리문 변경 종료';

	-- 개발중에는 텍스트만 확인하고 실행은 안한다.
	/*
	SELECT CONVERT(TEXT, @v_sql_text)
	FOR XML PATH('')--,ROOT('x')
	*/
	--SELECT N'v_sql_text 길이',LEN(@v_sql_text)
	
PRINT @VA_PROGRAM_ID + ' : A033--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'첫번째 DataTable 시작';
	EXEC SP_EXECUTESQL @v_sql_text;  
PRINT @VA_PROGRAM_ID + ' : A034--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'첫번째 DataTable 종료';

PRINT @VA_PROGRAM_ID + ' : A035--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'두번째 DataTable 시작';
	
	-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가 - 기존 쿼리 주석처리 START
	-- Monthly에서 다음달부터 수정 가능하게 하기. (현재는 8주...) (즉, 이번달만 막으면 됨.)
	--SELECT TOP 1 *
	--FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
	--WHERE BASIS_YYYYMMDD =  CONVERT(VARCHAR(8),GETDATE(),112)
	--ORDER BY BASIS_YYYYMMDD
	-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가 - 기존 쿼리 주석처리 END

	---------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가 START
	---------------------------------------------------------------------------------------------------------------
	-- Monthly에서 M+4 부터 수정 가능하게 하기. ( ex) 현재 5월이면, 9월부터 수정가능)
	SELECT TOP 1 MONTH_NAME,ISO_WEEK
	FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
	WHERE BASIS_YYYYMM = FORMAT(DATEADD(MONTH, 3, GETDATE()), 'yyyyMM') 
	ORDER BY BASIS_YYYYMMDD
	---------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가 END
	---------------------------------------------------------------------------------------------------------------	
PRINT @VA_PROGRAM_ID + ' : A035--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'두번째 DataTable 종료';
PRINT @VA_PROGRAM_ID + ' : A036--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'세번째 DataTable 시작';
	-- 현재 주차
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
PRINT @VA_PROGRAM_ID + ' : A037--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'세번째 DataTable 종료';
	-------------------------------------------------------------------------------------------------------------
	--[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 (START)
	--[PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 START
	--개발시점 기준 SCP Planner 만 SCM_FCST 에 대한 수정권한 부여. (실제적으로는 ADMIN , SCM PI ADMIN 도 같이 권한 추가 했음)
PRINT @VA_PROGRAM_ID + ' : A037--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) +  N'네번째 DataTable 시작';
	--해당 부분 처럼 사용하면 룩업을 사용하는 이유가 없음
	/*
									--SCM_FCST									--MKT_FCST	
	SELECT @v_EDIT_AUTH_SCM_FCST AS EDIT_AUTH_SCM_FCST,@v_EDIT_AUTH_MKT_FCST AS EDIT_AUTH_MKT_FCST
									--LOC										--VMI_In_Req
	      ,@v_EDIT_AUTH_LOC AS EDIT_AUTH_LOC,@v_EDIT_AUTH_VMI_IN_REQ AS EDIT_AUTH_VMI_IN_REQ*/
	SELECT A.MEASURE, A.EDIT_FLAG FROM #TEMP_ADMIN_GROUP_MEASURE A; 
PRINT @VA_PROGRAM_ID + ' : A038--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'네번째 DataTable 종료';

	--[PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 END
	--[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선 (END)
	-------------------------------------------------------------------------------------------------------------

	--[PJ2025-50188] 고도화 - M+4 월부터 월간 물량 배분 로직 적용 (신규) - START
PRINT @VA_PROGRAM_ID + ' : A039--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'다섯번째 DataTable 시작';
	SELECT BASIS_YYYYMMDD,				-- UI에서 BASIS_YYYYMMDD 로 값을 가져 온다.
		   BASIS_YYYYMM,			    -- UI에서 BASIS_YYYYMM 로 값을 가져 온다.
		   CASE WHEN RIGHT(BASIS_START_DATE,2) = '01' THEN 'Y' ELSE 'N' END AS FIRST_WEEK_FLAG, -- 매월 1일이 포함된 주차를 구분하는 FLAG
		   CASE WHEN LEFT(CONVERT(VARCHAR(8),DATEADD(DAY,7,CONVERT(DATE, BASIS_START_DATE)),112),6) -- 7일 뒤에도
					 = 
					 LEFT(BASIS_START_DATE,6)														-- 같은 달이라면 N , 다른 달이되었다면 Y
					 THEN 'N' ELSE 'Y' END END_MONTH_FLAG,	--월별 마지막 주차 FLAG (해당 주차에 해당하는 일은 모두 표시되있음)
		   COUNT(*) OVER(PARTITION BY BASIS_YYYYMM) AS MONTH_DAY_CNT,   -- 해당 월의 일개수 (이 값으로 나눠야함)
		   COUNT(*) OVER(PARTITION BY ISO_YYYYWW+PARTIAL_WEEK_NAME) AS WEEK_DAY_CNT   -- 해당 주의 일개수 (이 값으로 곱해야함)
		   ,ISO_YYYYWW --[20250616] KJIYOON 
		   --BASIS_START_DATE,			-- BASIS_START_DATE (해당 주차 시작일)으로 마지막 주차를 구분하기 위해서 사용
		   --END_FLAG AS WEEK_END_FLAG,	-- 월을 구분해서 주차 별 마지막 일인지 확인하는 FLAG
		   --LAST_WEEK_FLAG,			-- 월을 구분하지 않고 주차 별 마지막 일인지 확인하는 FLAG
	FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
	WHERE BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
	ORDER BY BASIS_YYYYMMDD
PRINT @VA_PROGRAM_ID + ' : A039--'  + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'다섯번째 DataTable 종료';
	--[PJ2025-50188] 고도화 - M+4 월부터 월간 물량 배분 로직 적용 (신규) - END
END
