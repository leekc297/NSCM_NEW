

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0108_GET_CAPA_LOB_CURRENT
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/09/05   hrkim        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/09/25   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Factory 제거
 * 2024.10.28	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 컬럼순서 변경 : 공정, 모델 -> 모델, 공정
 * 2024.12.12	hrkim        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - #tblSCP0108_DATE_COLS Date Columns 변경 (@V_VER_ID -> @V_START_YM)
 *																			
*/


CREATE PROCEDURE [dbo].[SCP0108_GET_CAPA_LOB_CURRENT]
	  @p_version			NVARCHAR(10)
	, @p_version_seq		TINYINT
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_nick_name			NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
    , @p_bottleneck_flag    NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

 --   DECLARE @p_version			NVARCHAR(10)		= N'202410';
	--DECLARE @p_version_seq		TINYINT             = 1;
	--DECLARE @p_division_id		NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_nick_name		NVARCHAR(MAX)		= N'F2-1,LV15A';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'-';
	--DECLARE @p_bottleneck_flag	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0108';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'CURRENT';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';


		DECLARE @V_VER_ID	NVARCHAR(6) = @p_version
		DECLARE @V_START_YM NVARCHAR(6) = CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, @V_VER_ID+'01', 112)), 112)
		DECLARE @V_START_YY NVARCHAR(6) = SUBSTRING(@V_START_YM,1, 4) 
		DECLARE @V_END_YY   NVARCHAR(6) = CONVERT(NVARCHAR(4), DATEADD(YEAR, 5, CONVERT(DATE, @V_START_YY+'0101', 112)))

		PRINT '------------------------------------------------------------------';
		PRINT '@V_VER_ID			= ' + @V_VER_ID;
		PRINT '@V_START_YM			= ' + @V_START_YM;
		PRINT '@V_START_YY			= ' + @V_START_YY;
		PRINT '@V_END_YY			= ' + @V_END_YY;
		PRINT '------------------------------------------------------------------';

		--------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Date Columns ' 
		--------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#tblSCP0108_DATE_COLS') IS NOT NULL DROP TABLE #tblSCP0108_DATE_COLS;
		SELECT DISTINCT CASE WHEN B.YYYY < CONVERT(NVARCHAR(4), DATEADD(YEAR, 3, CONVERT(DATE, SUBSTRING(@V_START_YM,1, 4)+'0101', 112))) -- 2024.12.12 @V_VER_ID -> @V_START_YM 
							 THEN B.YYYYMM
							 ELSE B.YYYY
						END  AS YYYYMM 
					   ,CASE WHEN B.YYYY < CONVERT(NVARCHAR(4), DATEADD(YEAR, 3, CONVERT(DATE, SUBSTRING(@V_START_YM,1, 4)+'0101', 112))) -- 2024.12.12 @V_VER_ID -> @V_START_YM 
							 THEN 'M_01'
							 ELSE 'Y_'
						END  AS PREFIX 
		 INTO #tblSCP0108_DATE_COLS
		 FROM SCM_MST_BUCKET B WITH(NOLOCK)
		WHERE 1=1
		  AND B.YYYY	 BETWEEN @V_START_YY 
							 AND @V_END_YY
		ORDER BY 1

		--------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Line Assign Current -  #SCP_MST_CAPA_LINE_ASSIGN ' 
		--------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LINE_ASSIGN;
		SELECT LA.NICK_NAME			AS MDL_NM
		      ,LA.DIVISION_ID
			  ,LA.COMPANY_ID
			  ,LA.SITE_ID
			  ,LA.PLANT_ID
			  ,LA.FACTORY_ID
			  ,LA.LINE_ID
			  ,LA.OPERATION_ID
			  ,LA.ELTR_LN_TP_CD
			  ,LA.YYYYMM
			  ,LA.DUMMY_YN	-- 5/14 
		 INTO #SCP_MST_CAPA_LINE_ASSIGN 
		 FROM SCP_MST_CAPA_LINE_ASSIGN LA WITH(NOLOCK)  
		WHERE 1=1
		  AND ((@p_division_id	    IS NULL OR @p_division_id	    = '') OR LA.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		  AND LA.VALID_YN	 = 'Y'  
		  AND ISNULL(LA.ASSIGN_PRIORITY, 0) != 0
		  AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR LA.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		  AND ((@p_plant_id		    IS NULL OR @p_plant_id	        = '') OR LA.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		  AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR LA.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		  AND ((@p_line_id		    IS NULL OR @p_line_id			= '') OR LA.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		  AND ((@p_operation_id	    IS NULL OR @p_operation_id		= '') OR LA.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		  AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR LA.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		  AND ((@p_nick_name	    IS NULL OR @p_nick_name   		= '') OR LA.NICK_NAME	   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_nick_name, ',')))

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 생산Capa(일) -  #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL_RAW') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW

		SELECT 
				 LS.MDL_NM
				,LS.PLANT_ID
				,LS.LINE_ID
				,LS.OPERATION_ID
				,LS.ELTR_LN_TP_CD
				,LS.DIVISION_ID
				,LS.COMPANY_ID
				,LS.SITE_ID
				,LS.FACTORY_ID
				,LS.YYYYMM
				,CONVERT(NUMERIC(20,10), LS.MSR_NVL		)	AS	MSR_NVL
		 INTO #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW 
		 FROM SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
		WHERE 1=1
		  AND ((@p_division_id	    IS NULL OR @p_division_id	    = '') OR LS.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		  AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR LS.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		  AND ((@p_plant_id		    IS NULL OR @p_plant_id	        = '') OR LS.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		  AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR LS.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		  AND ((@p_line_id		    IS NULL OR @p_line_id			= '') OR LS.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		  AND ((@p_operation_id	    IS NULL OR @p_operation_id		= '') OR LS.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		  AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR LS.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		  AND ((@p_nick_name	    IS NULL OR @p_nick_name   		= '') OR LS.MDL_NM		   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_nick_name, ',')))
		  AND ((@p_bottleneck_flag	IS NULL OR @p_bottleneck_flag	= '' OR @p_bottleneck_flag	= 'ALL') OR LS.ATTRIBUTE1 = @p_bottleneck_flag)
		  AND LS.MSR_TP_CD = 'PROD_CAPA_D'

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 생산Capa(일) -  #SCP_MST_CAPA_LOSS_PLAN_MDL' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_CAPA_LOSS_PLAN_MDL') IS NOT NULL DROP TABLE #SCP_MST_CAPA_LOSS_PLAN_MDL

		SELECT 
				 LS.MDL_NM
				,LS.PLANT_ID
				,LS.LINE_ID
				,LS.OPERATION_ID
				,LS.ELTR_LN_TP_CD
				,LS.DIVISION_ID
				,LS.COMPANY_ID
				,LS.SITE_ID
				,LS.FACTORY_ID
				,LS.YYYYMM
				,CONVERT(NUMERIC(20,10), LS.MSR_NVL		)	AS	MSR_NVL
		 INTO #SCP_MST_CAPA_LOSS_PLAN_MDL 
		 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL_RAW LS WITH(NOLOCK)
			  INNER JOIN #SCP_MST_CAPA_LINE_ASSIGN LA 
					      ON LA.MDL_NM			= LS.MDL_NM
					     AND LA.DIVISION_ID		= LS.DIVISION_ID
					     AND LA.COMPANY_ID		= LS.COMPANY_ID
					     AND LA.SITE_ID			= LS.SITE_ID
					     AND LA.PLANT_ID		= LS.PLANT_ID
					     AND LA.FACTORY_ID		= LS.FACTORY_ID
					     AND LA.LINE_ID			= LS.LINE_ID
					     AND LA.OPERATION_ID	= LS.OPERATION_ID
					     AND LA.ELTR_LN_TP_CD	= LS.ELTR_LN_TP_CD
						 AND LA.YYYYMM			= LS.YYYYMM
		WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 -  조정후 생산Capa ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#ADJ_PRDN_CAPA') IS NOT NULL DROP TABLE #ADJ_PRDN_CAPA
		SELECT '2'													AS DV
			  ,LS.DIVISION_ID
			  ,LS.SITE_ID
			  ,LS.COMPANY_ID
			  ,LS.PLANT_ID
			  ,LS.FACTORY_ID	
			  ,LS.LINE_ID
			  ,LS.MDL_NM											AS NICK_NAME 
			  ,LS.OPERATION_ID
			  ,LS.ELTR_LN_TP_CD
			  ,LS.YYYYMM
			  ,CONVERT(FLOAT,	LS.MSR_NVL)							AS PRDN_CAPA
			  ,CONVERT(FLOAT, 
				MIN(LS.MSR_NVL) OVER (PARTITION BY  LS.MDL_NM
											       ,LS.PLANT_ID
											       ,LS.FACTORY_ID	
											       ,LS.LINE_ID
											       ,LS.DIVISION_ID
											       ,LS.COMPANY_ID
											       ,LS.SITE_ID
											       ,LS.YYYYMM))		AS ADJ_PRDN_CAPA
		 INTO #ADJ_PRDN_CAPA
		 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
		WHERE 1=1

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' LOB 데이터 -  NickName 합계 추가 ' 
		-------------------------------------------------------------------------------------------------------------------
		INSERT INTO #ADJ_PRDN_CAPA
		SELECT '1'							AS DV	-- NickName 합계  
			  ,'*'							AS DIVISION_ID
			  ,'*'							AS SITE_ID
			  ,'*'							AS COMPANY_ID
			  ,'*'							AS PLANT_ID
			  ,'*'							AS FACTORY_ID	
			  ,'*'							AS LINE_ID
			  ,LS.MDL_NM					AS NICK_NAME 
			  ,LS.OPERATION_ID
			  ,LS.ELTR_LN_TP_CD
			  ,LS.YYYYMM
			  ,SUM(LS.MSR_NVL)				AS PRDN_CAPA
			  ,NULL							AS ADJ_PRDN_CAPA
		 FROM #SCP_MST_CAPA_LOSS_PLAN_MDL LS WITH(NOLOCK)
		WHERE 1=1
	 	  AND ISNULL(@p_nick_name, '') != ''
		GROUP BY LS.MDL_NM
				,LS.OPERATION_ID
				,LS.ELTR_LN_TP_CD
				,LS.YYYYMM

		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Date Columns ' 
		-------------------------------------------------------------------------------------------------------------------

		DECLARE @v_date_cols        NVARCHAR(MAX) = N'';
		DECLARE @v_bottleneck_cols  NVARCHAR(MAX) = N'';
		DECLARE @v_sql				NVARCHAR(MAX) = N'';

		SELECT @v_date_cols        = @v_date_cols + '
				,MAX(CASE WHEN CP.YYYYMM = '''+YYYYMM+'''	THEN CP.PRDN_CAPA ELSE NULL END)	AS '+PREFIX+YYYYMM
			  ,@v_bottleneck_cols  = @v_bottleneck_cols + '
				,MAX(CASE WHEN CP.YYYYMM = '''+YYYYMM+'''	AND CP.PRDN_CAPA = CP.ADJ_PRDN_CAPA AND CP.OPERATION_ID LIKE ''A%'' THEN ''Y'' ELSE NULL END)	AS '+PREFIX+YYYYMM
		 FROM #tblSCP0108_DATE_COLS A
		ORDER BY YYYYMM;

		--print @v_date_cols
		--print @v_bottleneck_cols


		print  convert(varchar(30), getdate(), 121) + N'Master 데이터 ' 
		-------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_MST_DIVISION') IS NOT NULL DROP TABLE #SCM_MST_DIVISION
		SELECT DIVISION_ID
			  ,DIVISION_NAME
		 INTO #SCM_MST_DIVISION
		 FROM SCM_MST_DIVISION WITH(NOLOCK) 

	IF OBJECT_ID('tempdb..#tblSCP0104_CODE_ALL') IS NOT NULL
		DROP TABLE #tblSCP0104_CODE_ALL;

    SELECT  *
    INTO    #tblSCP0104_CODE_ALL
    FROM    SCP_MST_CAPA_LINE WITH(NOLOCK)
    WHERE   VALID_YN = 'Y'


	IF OBJECT_ID('tempdb..#tblSCP0104_SITE') IS NOT NULL
		DROP TABLE #tblSCP0104_SITE;

    SELECT    SITE_ID
            , SITE_NAME
    INTO    #tblSCP0104_SITE
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  SITE_ID
            , SITE_NAME

--TESTING : NOK
--select * from #tblSCP0104_SITE;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_COMPANY') IS NOT NULL
		DROP TABLE #tblSCP0104_COMPANY;

    SELECT    COMPANY_ID
            , COMPANY_NAME
    INTO    #tblSCP0104_COMPANY
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  COMPANY_ID
            , COMPANY_NAME

--TESTING : NOK
--select * from #tblSCP0104_COMPANY;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_PLANT') IS NOT NULL
		DROP TABLE #tblSCP0104_PLANT;

    SELECT    PLANT_ID
            , PLANT_NAME
    INTO    #tblSCP0104_PLANT
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  PLANT_ID
            , PLANT_NAME

--TESTING : NOK
--select * from #tblSCP0104_PLANT;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_FACTORY') IS NOT NULL
		DROP TABLE #tblSCP0104_FACTORY;

    SELECT    FACTORY_ID
            , FACTORY_NAME
    INTO    #tblSCP0104_FACTORY
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  FACTORY_ID
            , FACTORY_NAME

--TESTING : NOK
--select * from #tblSCP0104_FACTORY;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_LINE') IS NOT NULL
		DROP TABLE #tblSCP0104_LINE;

    SELECT    LINE_ID
            , LINE_NAME
    INTO    #tblSCP0104_LINE
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  LINE_ID
            , LINE_NAME

--TESTING : NOK
--select * from #tblSCP0104_LINE WHERE LINE_ID = 'A3A08';return;

	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;

    SELECT    A.OPERATION_ID
            , A.OPERATION_NAME
    INTO    #tblSCP0104_OPERATION
    FROM    (
                SELECT    A.OPERATION_ID
		                , MAX(A.OPERATION_NAME) AS OPERATION_NAME
                FROM	[dbo].SCM_MST_OPERATION_SN A WITH(NOLOCK)
                GROUP BY  A.OPERATION_ID
                UNION ALL
                SELECT	  B.SEGMENT1   AS CODE
		                , B.ATTRIBUTE1 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
				                A.LOOKUP_TYPE = B.LOOKUP_TYPE
                WHERE	1=1
	                AND A.LOOKUP_GROUP  = 'SCP'
	                AND A.LOOKUP_TYPE   = 'CPS_FORMATION_OPERATION'
	                AND B.VALID_YN      = 'Y'
                GROUP BY  B.SEGMENT1
		                , B.ATTRIBUTE1
            ) A

--TESTING : NOK
--select * from #tblSCP0104_OPERATION WHERE;return;


		-------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' Final 조회 쿼리 조합  ' 
		-------------------------------------------------------------------------------------------------------------------
		SET @v_sql  = N'

			-- LOB 데이터 조회 
			SELECT CP.DV
				  ,CP.DIVISION_ID
				  ,CP.SITE_ID
				  ,CP.COMPANY_ID
				  ,CP.PLANT_ID
				  ------,CP.FACTORY_ID
				  ,CP.LINE_ID
				  ,CP.NICK_NAME
				  ,CP.OPERATION_ID
			      ,MAX(O.OPERATION_NAME)            AS OPERATION_NAME
				  ,CP.ELTR_LN_TP_CD
				  ' + @v_date_cols + '
				  ,ISNULL(MAX(DM.DIVISION_NAME), ''*'')	AS DIVISION_NAME  
				  ,ISNULL(MAX(S.SITE_NAME),		''*'')	AS SITE_NAME  
				  ,ISNULL(MAX(C.COMPANY_NAME),	''*'')	AS COMPANY_NAME  
				  ,ISNULL(MAX(P.PLANT_NAME),	''*'')	AS PLANT_NAME  
				  ,ISNULL(MAX(L.LINE_NAME),		''*'')	AS LINE_NAME  
			 FROM #ADJ_PRDN_CAPA CP
				  LEFT JOIN #SCM_MST_DIVISION DM WITH(NOLOCK)
						 ON DM.DIVISION_ID = CP.DIVISION_ID 
				  LEFT JOIN #tblSCP0104_SITE S WITH(NOLOCK) 
				  		 ON S.SITE_ID	   = CP.SITE_ID
				  LEFT JOIN #tblSCP0104_COMPANY C WITH(NOLOCK) 
				  		 ON C.COMPANY_ID   = CP.COMPANY_ID
				  LEFT JOIN #tblSCP0104_PLANT P WITH(NOLOCK) 
				  		 ON P.PLANT_ID     = CP.PLANT_ID
				  ------LEFT JOIN #tblSCP0104_FACTORY F WITH(NOLOCK) 
				  ------		 ON F.FACTORY_ID     = CP.FACTORY_ID
				  LEFT JOIN #tblSCP0104_LINE L WITH(NOLOCK) 
						 ON	L.LINE_ID	   = CP.LINE_ID
			      LEFT JOIN #tblSCP0104_OPERATION O ON
					      CP.OPERATION_ID		= O.OPERATION_ID
			WHERE 1=1
			GROUP BY CP.DV
				  ,CP.DIVISION_ID
				  ,CP.SITE_ID
				  ,CP.COMPANY_ID
				  ,CP.PLANT_ID
				  ------,CP.FACTORY_ID
				  ,CP.LINE_ID
				  ,CP.NICK_NAME
				  ,CP.OPERATION_ID
				  ,CP.ELTR_LN_TP_CD

			-- Bottle neck 정보 조회 
			SELECT CP.DV
				  ,CP.DIVISION_ID
				  ,CP.SITE_ID
				  ,CP.COMPANY_ID
				  ,CP.PLANT_ID
				  ------,CP.FACTORY_ID
				  ,CP.LINE_ID
				  ,CP.NICK_NAME
				  ,CP.OPERATION_ID
				  ,CP.ELTR_LN_TP_CD
				  ' + @v_bottleneck_cols + '
			 FROM #ADJ_PRDN_CAPA CP
			WHERE 1=1
			GROUP BY CP.DV
				  ,CP.DIVISION_ID
				  ,CP.SITE_ID
				  ,CP.COMPANY_ID
				  ,CP.PLANT_ID
				  ------,CP.FACTORY_ID
				  ,CP.LINE_ID
				  ,CP.NICK_NAME
				  ,CP.OPERATION_ID
				  ,CP.ELTR_LN_TP_CD
			';

    EXEC(@v_sql);


END

