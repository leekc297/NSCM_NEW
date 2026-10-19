


/*      
 * Program ID   : [PR_SCP_ANL_CAPA_BALANCE_40]  
 * Description  : Capa Balance (SMALL) 을 리포트용 테이블 SCP_ANL_CAPA_BALANCE_REPORT_SMALL에 저장함.
 * Exec :
			 EXEC	 [dbo].[PR_SCP_ANL_CAPA_BALANCE_40]
		
					@p_division_id = N'40',	
					@p_plan_start_yyyymmdd = N'20210906',
					@p_plan_type = N'MA',
					@p_seq = N'2', 	
					@debug_mode = N'T'

 * Program History      
 *===================================================================================================      
 *   Date	    	In Charge	    Description      
 *===================================================================================================      
 * 2021.07.16  hongju.lee		Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) 
 * 2021.08.20  hongju.lee		월/Line별 Type 및 Capa관련 수정
 * 2021.08.25  hongju.lee       PSI관련 Cell Item Id 칼럼 추가, 정렬순서 수정
 * 2021.08.30  hongju.lee       CAPA QTY를 ITEM,TYPE별로 구분
 * 2021.09.13  hongju.lee       PRODUCTION을 가져오는 조건에  '' Operation_Id IN ('A3000','A9000') '' 조건 추가
 * 2022.04.18  sclee.lee        PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - division_id 데이터타입 변경 NVARCHAR(2) -> NVARCHAR(10)
 * 2022.06.27  sclee.lee        PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2022.08.03  hrkim		    PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 활성화코드 분리 대응 - 나누기 0오류 임시 조치
 * 2025.08.01  hrkim		    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경 
 */      

CREATE PROCEDURE [dbo].[PR_SCP_ANL_CAPA_BALANCE_40]      
	
    -- PJ20216891
	@p_division_id				    NVARCHAR(10),	
	-- @p_division_id				    NVARCHAR(2),	
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type				    NVARCHAR(50),
	@p_seq						        NVARCHAR(50),
	@debug_mode					NVARCHAR(1)   = 'F'
AS      
BEGIN      
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)
	
		
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd		  AS NVARCHAR(8)='';
	DECLARE @v_from_result            AS NVARCHAR(8)='';
	DECLARE @v_to_result                AS NVARCHAR(8)='';

    -- PJ20216891
	DECLARE @v_division_id				       NVARCHAR(10)   = @p_division_id
	-- DECLARE @v_division_id				       NVARCHAR(2)   = @p_division_id
	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)   = @p_plan_start_yyyymmdd
	DECLARE @v_plan_type				       NVARCHAR(50) = @p_plan_type
	DECLARE @v_seq						       NVARCHAR(50) = @p_seq

    SET @v_from_yyyymmdd   = @p_plan_start_yyyymmdd;
	SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, 18, convert(datetime,@p_plan_start_yyyymmdd)), 112);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_CAPA_BALANCE_40'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N''; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'  -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- FInal Operation
	------------------------------------------------------------------------------------------------------------------


	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '#[PR_SCP_ANL_CAPA_BALANCE_40]#### Start of procedure #';     
    SET @v_description = @v_division_id + ' : ' + @v_plan_start_yyyymmdd + ' : ' + @v_plan_type + ' : ' + @v_seq ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
		
	-- 시작 LOG  (END)
	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
		PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
	
		PRINT '----------------------------------';
	END;

	BEGIN TRY
		BEGIN
		/********************************************************************************      
		 * 임시테이블만들기 - 조회조건 테이블      
		 ********************************************************************************/      
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_item') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_item;    

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_cellItem') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_cellItem;    

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_LINE_LOAD') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_LINE_LOAD;  

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_LINE') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_LINE;  

		IF OBJECT_ID('tempdb..#tbl_ITEM_ID_Cell_Item_ID') IS NOT NULL	
		DROP TABLE #tbl_ITEM_ID_Cell_Item_ID

		IF OBJECT_ID('tempdb..#PACK') IS NOT NULL	
		DROP TABLE #PACK

		IF OBJECT_ID('tempdb..#TCOCELL') IS NOT NULL	
		DROP TABLE #TCOCELL

		IF OBJECT_ID('tempdb..#CELL') IS NOT NULL	
		DROP TABLE #CELL

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_item_order') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_item_order;    
	
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_CLASS_TYPE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0071_CLASS_TYPE

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_RANK') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0071_RANK

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_MEASURE') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0071_MEASURE

		--생산실적, 출하실적 용
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_RESULT') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_RESULT;

		--생산 로드율 주SUM, 월SUM
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_LINE_LOAD_BASE') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_LINE_LOAD_BASE;  
	
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_MODELNAME') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_MODELNAME;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_TEMP1') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_TEMP1;

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_LAST') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_LAST;
	
		IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL      
		DROP TABLE #SCM_MST_SITE;
	
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_INVENTORY') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_INVENTORY;
		
		IF OBJECT_ID('tempdb..#LOCATION_GROUP_LOCATION_GROUP_ROUTE') IS NOT NULL      
		DROP TABLE #LOCATION_GROUP_LOCATION_GROUP_ROUTE;
		
        -- PJ20216891
        -- ISUZU item
		IF OBJECT_ID('tempdb..#ISUZU') IS NOT NULL      
		DROP TABLE #ISUZU;
	
		/* ITEM GROUP */
		SELECT DISTINCT A.ITEM_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP
		INTO #TBL_ITEM_ID_CELL_ITEM_ID
		FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
		--JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON A.ITEM_ID=V.ITEM_ID
		WHERE A.DIVISION_ID         = @v_division_id
			AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND A.PLAN_TYPE				= @v_plan_type
			AND A.SEQ					    = @v_seq
			AND A.YYYYMMDD              >= @v_from_yyyymmdd
			AND A.YYYYMMDD              <= @v_to_yyyymmdd

		/*제품, TYPE, NICK_NAME(모델)*/
		SELECT F.ITEM_ID , L.MATERIAL_CLASS_NAME, NICK_NAME , CELL_TYPE_GROUP_CODE, TYPE
			INTO #TblDynamicPivot_SCP0071_CLASS_TYPE
			FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
			LEFT JOIN (SELECT  SEGMENT1, DESCRIPTION AS MATERIAL_CLASS_NAME
								FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							WHERE LOOKUP_TYPE ='CELL_TYPE_GROUP_CODE'
								AND VALID_YN ='Y'
							) L ON L.SEGMENT1 = F.CELL_TYPE_GROUP_CODE
			LEFT JOIN ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS TYPE 
								FROM	SCM_MST_ITEM_SN M
							WHERE  DIVISION_ID = @v_division_id
							GROUP BY ITEM_ID
							) I ON I.ITEM_ID = F.ITEM_ID
			INNER JOIN ( SELECT ITEM_ID FROM #TBL_ITEM_ID_CELL_ITEM_ID) B 
						ON	F.ITEM_ID	 = B.ITEM_ID 
		WHERE F.DIVISION_ID = @v_division_id
		
	   /*SCM_SITE (FROM SITE)*/
		SELECT DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION
		   INTO #SCM_MST_SITE
		   FROM SCM_MST_SITE S
		 WHERE S.DIVISION_ID = @v_division_id
			 AND S.OSP_YN = 'N' 
			 AND  S.OPERATION_GROUP = 'A'	

		/* P */
		SELECT A.ITEM_ID, A.CELL_ITEM_ID, Y.VALUE, A.OPERATION_GROUP, RANK() OVER(ORDER BY A.ITEM_ID ASC) AS 'RANK'
		INTO #PACK
		FROM #TBL_ITEM_ID_CELL_ITEM_ID A WITH(NOLOCK)
		CROSS APPLY (  SELECT ID,VALUE 
								FROM DBO.FN_SPLITSTRING(A.CELL_ITEM_ID,',') )  Y  
		WHERE A.OPERATION_GROUP = 'P'
	
		/* TCOCELL */
		SELECT A.ITEM_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP, ISNULL(B.RANK,RANK() OVER(ORDER BY A.ITEM_ID ASC)) AS 'RANK'
		INTO #TCOCELL
		FROM #TBL_ITEM_ID_CELL_ITEM_ID A WITH(NOLOCK)
		LEFT JOIN  #PACK B ON B.Value = A.CELL_ITEM_ID
		JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON V.ITEM_ID=A.ITEM_ID AND ISNULL(V.TCO_CELL_YN,'-')='Y'
		WHERE A.OPERATION_GROUP = 'A' 

		/* C */
		SELECT A.ITEM_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP, ISNULL(ISNULL(T.RANK,B.RANK),99999) AS 'RANK'
		INTO #CELL
		FROM #TBL_ITEM_ID_CELL_ITEM_ID A WITH(NOLOCK)
		LEFT JOIN  #PACK B ON B.Value = A.CELL_ITEM_ID
		LEFT JOIN  #TCOCELL T ON T.CELL_ITEM_ID = A.ITEM_ID
		JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON V.ITEM_ID=A.ITEM_ID AND ISNULL(V.TCO_CELL_YN,'-')='N'
		WHERE A.OPERATION_GROUP = 'A' 

		/* RANK */
		SELECT A.ITEM_ID, A.CELL_ITEM_ID, MAX(RANK) RANK
		INTO #TblDynamicPivot_SCP0071_item_order
		FROM (
			SELECT ITEM_ID, CELL_ITEM_ID, RANK
			FROM #PACK
			UNION ALL
			SELECT ITEM_ID, CELL_ITEM_ID, RANK
			FROM #TCOCELL
			UNION ALL
			SELECT ITEM_ID, CELL_ITEM_ID, RANK
			FROM #CELL
		) A
		GROUP BY A.ITEM_ID, A.CELL_ITEM_ID

		/* TACT TIME */
		SELECT *
		   INTO #TACT_TIME
		  FROM SCM_MST_TACT_TIME_VER_H_V WITH(noLock)
		WHERE DIVISION_ID = '40'
			AND MONTH >= SUBSTRING(@v_from_yyyymmdd, 1, 6)    
			AND ITEM_ID IN (SELECT ITEM_ID FROM #TBL_ITEM_ID_CELL_ITEM_ID)

		PRINT '-------------RANK'
		print CONVERT(CHAR(23), getdate(), 21)

		/* 하위 Cell Item */
		SELECT Y.Value AS SUB_CELL_ITEM_ID
		INTO #TblDynamicPivot_SCP0071_cellItem
		FROM #TblDynamicPivot_SCP0071_item_order X WITH(NOLOCK)
		CROSS APPLY (  SELECT ID,VALUE 
						FROM dbo.FN_SplitString(X.CELL_ITEM_ID,',') )  Y  
		WHERE 1=1		
		AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0071_CLASS_TYPE)
		GROUP BY Y.Value

		PRINT '-------------Cell Item'
		print CONVERT(CHAR(23), getdate(), 21)

		/* PSI PACK/CELL, TCO/CELL, CELL/CELL 세트 */
		SELECT A.ITEM_ID, A.CELL_ITEM_ID, A.RANK
				, (CASE WHEN V.OPERATION_GROUP='P' THEN 1
							WHEN V.TCO_CELL_YN='Y'	 THEN 2
				   ELSE 3
				   END) AS RANK_DETAIL
		INTO #TblDynamicPivot_SCP0071_item
		FROM #TblDynamicPivot_SCP0071_item_order A WITH(NOLOCK)
		CROSS APPLY (  SELECT ID,VALUE 
						FROM dbo.FN_SplitString(A.CELL_ITEM_ID,',') )  Y  
		JOIN #TblDynamicPivot_SCP0071_cellItem B ON Y.Value=B.SUB_CELL_ITEM_ID
		LEFT JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON V.ITEM_ID=A.ITEM_ID
		WHERE 1=1
		--AND Y.Value IN (SELECT SUB_CELL_ITEM_ID FROM #TblDynamicPivot_SCP0071_cellItem )
		GROUP BY A.ITEM_ID, A.CELL_ITEM_ID, A.RANK, V.OPERATION_GROUP, V.TCO_CELL_YN
		
        -- PJ20216891
        /* LOCATION_GROUP & LOCATION_GROUP_ROUTE */
        SELECT B.SEGMENT2
        INTO #LOCATION_GROUP_LOCATION_GROUP_ROUTE
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
        ON  A.SEGMENT1= B.SEGMENT1
        AND A.LOOKUP_TYPE = 'LOCATION_GROUP'
        AND A.SEGMENT4    = 'Y' -- CAPA 공정 여부 
        --  AND A.SEGMENT5    = 'Y' -- LINE 별 CAPA 적용 공정( CAPA공정여부가 'N'이면  LINE 별 CAPA 적용 공정이 'Y'가 될수없음)
        AND A.VALID_YN    = 'Y'
        AND B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
        AND B.VALID_YN    = 'Y'
        AND B.SEGMENT3    = 'Y' -- CAPA 세부 공정 여부 
        AND A.SEGMENT3    IN ('A', 'P')

        -- PJ20216891
        -- ISUZU item
        SELECT A.ITEM_ID
        INTO #ISUZU
        FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
        INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
        WHERE A.IS_YN = 'Y'

		PRINT '-------------Item Set'
		print CONVERT(CHAR(23), getdate(), 21)
	
		/* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅	
		SELECT M.COLUMN_NAME
			 , M.COLUMN_LABEL_NAME	AS MEASURE_LABEL
			 , M.ATTRIBUTE3			AS MEASURE_COLOR	--MEASURE 별 COLOR RGB코드
			 , M.SORT_ORDER_NO		AS SORT_ORDER_NO	-- KHJ79 : 정열을 위한 값
		INTO #TblDynamicPivot_SCP0071_MEASURE
		FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
		-- khj78 : user 정보 없음 나중에 해달라고 하면 추가
		--LEFT JOIN SCM_MST_TITLESET_USER U ON U.program_id  = M.program_id AND U.sheet_name  = M.sheet_name
		--									AND U.column_name = M.column_name AND U.user_id = @p_user_id
		--LEFT JOIN SCM_MST_SHEET_MEASURE P ON P.program_id  = M.program_id AND P.sheet_name  = M.sheet_name AND P.column_name = 'PRODUCTION'
		--LEFT JOIN SCM_MST_SHEET_MEASURE S ON S.program_id  = M.program_id AND S.sheet_name  = M.sheet_name AND S.column_name = 'SHIP_REQ'
		WHERE M.PROGRAM_ID='SCP0071'
		AND M.VALID_YN='Y'

		PRINT '-------------User Measure'
		print CONVERT(CHAR(23), getdate(), 21)
		
	-- 소형 라인별 TYPE 
	SELECT  LA.DIVISION_ID, LA.LINE_ID, LA.MONTH
     	--		,MAX(ISNULL(I.SCP_EXTRA_SPEC, '1'))  AS TYPE
       INTO #TBLDYNAMICPIVOT_SCP0071_LINE_BY_TYPE
  	  FROM   DBO.SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_ITEM_LINE_ASSIGN_M]
		LEFT OUTER JOIN SCM_MST_ITEM_SN I WITH(NOLOCK)
		ON  LA.DIVISION_ID = I.DIVISION_ID
		AND LA.COMPANY_ID = I.COMPANY_ID
		AND LA.ITEM_ID = I.ITEM_ID
	WHERE  LA.DIVISION_ID = @v_division_id
	AND    LA.ACTIVE_FLAG = 'Y'
	AND    la.month    >= SUBSTRING(@v_from_yyyymmdd,1,6)  
	AND    LA.PRIORITY NOT IN (0, 9) -- 사용 안할때 0, 9로 세팅되어있음     

/*
	AND    LA.OPERATION_ID IN  (
                                SELECT B.SEGMENT2
                                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
                                ON  A.SEGMENT1= B.SEGMENT1
                                AND A.LOOKUP_TYPE = 'LOCATION_GROUP'
                                AND A.SEGMENT4    = 'Y' -- CAPA 공정 여부 
                                --  AND A.SEGMENT5    = 'Y' -- LINE 별 CAPA 적용 공정( CAPA공정여부가 'N'이면  LINE 별 CAPA 적용 공정이 'Y'가 될수없음)
                                AND A.VALID_YN    = 'Y'
                                AND B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                AND B.VALID_YN    = 'Y'
                                AND B.SEGMENT3    = 'Y' -- CAPA 세부 공정 여부 
                                AND A.SEGMENT3    IN ('A', 'P')
                               )
*/

    -- PJ20216891	
    -- ISUZU item
    AND    (
            LA.OPERATION_ID IN (
                                SELECT SEGMENT2
                                FROM   #LOCATION_GROUP_LOCATION_GROUP_ROUTE
                               )
            OR (
                LA.OPERATION_ID = 'P5000'
                AND EXISTS (
                            SELECT 1
                            FROM   #ISUZU A
                            WHERE  A.ITEM_ID = LA.ITEM_ID
                           )
               )
           )
	GROUP BY LA.DIVISION_ID, LA.LINE_ID, LA.MONTH

       -- SITE별 월별 MAX_CAPA  
		SELECT A.PLANT_SITE_ID, A.MONTH, A.LINE_ID, A.DAILY_CAPA 
				   ,A.DAILY_CAPA * SUM(CAST(B.WORKING_TIME AS numeric ))/1440 AS CAPA, A.TYPE 
		   INTO #TblDynamicPivot_SCP0071_CAPA
		  FROM(
						SELECT PLANT_SITE_ID, T.MONTH, T.LINE_ID , MAX(T.DAILY_CAPA) DAILY_CAPA, C.TYPE
							FROM  DBO.SCM_MST_TACT_TIME_VER_H_V T WITH (NOLOCK) 
									 ,DBO.SCM_MST_ITEM_LINE_ASSIGN_SN  A WITH(NOLOCK)
									 ,  #TblDynamicPivot_SCP0071_CLASS_TYPE C WITH(NOLOCK)
						WHERE  T.DIVISION_ID  = @v_division_id
							AND  T.MONTH       >= SUBSTRING(@v_from_yyyymmdd, 1, 6)
							
/* 
							AND  T.OPERATION_ID IN  ( 
                                                     SELECT B.SEGMENT2
                                                     FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
                                                     INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
                                                     ON  A.SEGMENT1= B.SEGMENT1
                                                     AND A.LOOKUP_TYPE = 'LOCATION_GROUP'
                                                     AND A.SEGMENT4    = 'Y' -- CAPA 공정 여부 
                                                     AND A.VALID_YN    = 'Y'
                                                     AND B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                                     AND B.VALID_YN    = 'Y'
                                                     AND B.SEGMENT3    = 'Y' -- CAPA 세부 공정 여부 
                                                     AND A.SEGMENT3    IN ('A', 'P')
                                                    )
 */

                            -- PJ20216891	
                            -- ISUZU item
                            AND  (
                                  T.OPERATION_ID IN  (
                                                      SELECT SEGMENT2
                                                      FROM   #LOCATION_GROUP_LOCATION_GROUP_ROUTE
                                                     )
                                  OR (
                                      T.OPERATION_ID = 'P5000'
                                      AND EXISTS (
                                                  SELECT 1
                                                  FROM   #ISUZU A
                                                  WHERE A.ITEM_ID = T.ITEM_ID
                                                 )
                                     )
                                 )
							AND T.OPERATION_ID = A.OPERATION_ID
							--AND T.PLANT_SITE_ID = 'A010-A'
							--AND T.MONTH = '202203'
							--AND T.LINE_ID IN ( 'M1C01','M1C02')
							AND T.LINE_ID = A.LINE_ID 
							AND T.ITEM_ID = A.ITEM_ID
							AND T.MONTH  = A.MONTH 
							AND A.PRIORITY NOT IN (0,9)
							AND T.ITEM_ID = C.ITEM_ID			
					GROUP BY PLANT_SITE_ID, T.MONTH, T.LINE_ID,C.TYPE 
				) A
				INNER JOIN SCP_MST_WORKING_TIME B WITH(NOLOCK)
				   ON A.LINE_ID = B.LINE_ID
				  AND A.MONTH =  SUBSTRING(B.YYYYMMDD,1,6)
		 GROUP BY A.PLANT_SITE_ID, A.MONTH, A.LINE_ID, A.DAILY_CAPA, A.TYPE


		/********************************************************************************      
		 * 임시테이블만들기 - 본 테이블      
		 ********************************************************************************/      
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071;      

		/********************************************************************************      
		* 데이타조회, 임시테이블에 저장      
		********************************************************************************/
		DECLARE @mEXEC NVARCHAR(MAX);
	
		CREATE TABLE #TblDynamicPivot_SCP0071 (
			 DIVISION_ID		      NVARCHAR(60)	
			,OPERATION_GROUP	    NVARCHAR(60)
			,MATERIAL_CLASS_NAME NVARCHAR(60)		-- 제품 ? 원통형...
			,NICK_NAME 					  NVARCHAR(60)		-- 모델 ? M50F HM1
			,TYPE            		 		   NVARCHAR(60)		-- TYPE ? 2170, 1865
			,LINE_ID                     NVARCHAR(30)
			,CELL_ITEM_ID		      NVARCHAR(100)	
			,ITEM_ID			        NVARCHAR(100)
			,FROM_SITE			      NVARCHAR(60)
			,FROM_SITE_DESCRIPTION NVARCHAR(100)
			,MEASURE		        	NVARCHAR(100)          
			,MEASURE_LABEL		NVARCHAR(100) 
			,MEASURE_COLOR	     NVARCHAR(30)
			,SORT_ORDER_NO		NVARCHAR(100)    		
			,B_yyyymmdd			      NVARCHAR(10)
			,YYYYMMDD			        NVARCHAR(10)
			,YYYYMM				        NVARCHAR(6)
			,YYYYQQ  	                NVARCHAR(6)
			,YYYY                        NVARCHAR(4)
			,QTY				            NUMERIC(20,10)
			,ISO_WEEK			    INT
			,ACTIVATION_YIELD   NUMERIC(20,10)
			,LT_DAYS  			        INT
			,TRANSPORT_MODE_LINE NVARCHAR(60)
		);

	   INSERT INTO #TblDynamicPivot_SCP0071	
	   SELECT A.DIVISION_ID												
				, A.OPERATION_GROUP											
				, C.MATERIAL_CLASS_NAME
				, C.NICK_NAME					
				, C.TYPE
				, A.TRANSPORT_MODE_LINE AS LINE_ID
				, A.CELL_ITEM_ID	
				, A.ITEM_ID	
				, A.FROM_SITE
				, S.SITE_DESCRIPTION AS FROM_SITE_DESCRIPTION
				, A.MEASURE	   						           	   
				, M.MEASURE_LABEL	  
				, M.MEASURE_COLOR
				, M.SORT_ORDER_NO	   							
				, A.YYYYMMDD AS B_YYYYMMDD									
				, 'D_'+ A.YYYYMMDD AS YYYYMMDD							
				, O.BASIS_YYYYMM AS YYYYMM									
				, O.CALENDAR_YYYYQQ AS YYYYQQ 									
				, O.CALENDAR_YYYY AS YYYY   									
				, SUM(ISNULL(QTY,0)) AS QTY										
				, RIGHT(O.BASIS_YYYYMM, 4)+O.ISO_WEEK AS ISO_WEEK	
				,ISNULL(MIN(F.FORMATION_TOTAL_YIELD),0) AS FORMATION_TOTAL_YIELD
				,ISNULL(MAX(F.LT_FORMATION) ,0) AS LT_FORMATION		
				, A.TRANSPORT_MODE_LINE
		   FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)							
		   INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd				
		   INNER JOIN #TblDynamicPivot_SCP0071_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE				
		   INNER JOIN #TblDynamicPivot_SCP0071_CLASS_TYPE C (NOLOCK) ON C.ITEM_ID= A.ITEM_ID --AND MO.CELL_ITEM_ID = A.CELL_ITEM_ID	
		   LEFT JOIN #SCM_MST_SITE S (NOLOCK) ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE
		   LEFT JOIN SCP_MST_FORMATION F  (NOLOCK) ON F.DIVISION_Id = A.DIVISION_ID AND F.ITEM_ID= A.CELL_ITEM_ID AND F.PLANT_SITE_ID = A.FROM_SITE
			WHERE A.DIVISION_ID			=@v_division_id				
			AND A.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
			AND A.PLAN_TYPE				= @v_plan_type					
			AND A.SEQ					=@v_seq					
			AND A.YYYYMMDD >= @v_from_yyyymmdd							
			AND A.YYYYMMDD <= @v_to_yyyymmdd							
			AND M.COLUMN_NAME NOT IN ( 'BALANCE','SHIP_REQ', 'PRODUCTION',  'MODEL_INVENTORY', 'ACTIVATE_PROGRESS')
			GROUP BY  A.DIVISION_ID												
				, A.OPERATION_GROUP											
				, C.MATERIAL_CLASS_NAME
				, C.NICK_NAME						      					    
				, A.CELL_ITEM_ID	
				, C.TYPE
				, A.TRANSPORT_MODE_LINE 
				, A.ITEM_ID			
				, A.FROM_SITE
				, S.SITE_DESCRIPTION
				, A.MEASURE	   						           	   
				, M.MEASURE_LABEL	  
				, M.MEASURE_COLOR
				, M.SORT_ORDER_NO	   		
				, A.YYYYMMDD,'D_'+ A.YYYYMMDD  ,O.BASIS_YYYYMM,O.CALENDAR_YYYYQQ  ,O.CALENDAR_YYYY ,RIGHT(O.BASIS_YYYYMM, 4)+O.ISO_WEEK  
   
		  
	    SELECT A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP 
		 		   ,MATERIAL_CLASS_NAME, NICK_NAME, TYPE,  FROM_SITE, S.SITE_DESCRIPTION AS FROM_SITE_DESCRIPTION
				   ,A.MEASURE
				   ,MEASURE_LABEL           
		    	   ,MEASURE_COLOR	     	
		  		   ,SORT_ORDER_NO				
				   ,O.BASIS_YYYYMM AS  YYYYMM 
				   ,MAX(YYYYMMDD) AS YYYYMMDD
				   ,A.ITEM_ID
				   ,A.CELL_ITEM_ID
				   ,MAX(ISNULL(QTY,0)) AS QTY		
  			       ,A.TRANSPORT_MODE_LINE AS LINE_ID
		   INTO  #TblDynamicPivot_SCP0071_INVENTORY	
		 FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)							
				   INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) O ON A.YYYYMMDD = O.BASIS_YYYYMMDD	 
				   INNER JOIN #TblDynamicPivot_SCP0071_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE AND COLUMN_NAME IN ( 'MODEL_INVENTORY', 'ACTIVATE_PROGRESS'	)
				   INNER JOIN #TblDynamicPivot_SCP0071_CLASS_TYPE C (NOLOCK) ON C.ITEM_ID= A.ITEM_ID --AND MO.CELL_ITEM_ID = A.CELL_ITEM_ID	
				   LEFT JOIN #SCM_MST_SITE S (NOLOCK) ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE
  		WHERE A.DIVISION_ID = @v_division_id			
		     AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		     AND PLAN_TYPE =  @v_plan_type	
			 AND SEQ = @v_seq	
	   GROUP BY A.MEASURE, O.BASIS_YYYYMM, A.ITEM_ID, A.CELL_ITEM_ID, A.TRANSPORT_MODE_LINE,
                 A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, 
				 MATERIAL_CLASS_NAME, NICK_NAME, TYPE,  FROM_SITE, SITE_DESCRIPTION,
				 MEASURE_LABEL, MEASURE_COLOR, SORT_ORDER_NO

	   -- PRODUCTION INSERT 
	   INSERT INTO #TblDynamicPivot_SCP0071	
	   SELECT A.DIVISION_ID												
				, A.OPERATION_GROUP											
				, C.MATERIAL_CLASS_NAME
				, C.NICK_NAME					
				, C.TYPE
			    , A.TRANSPORT_MODE_LINE AS LINE_ID
				, A.CELL_ITEM_ID	
				, A.ITEM_ID	
				, A.FROM_SITE
				, S.SITE_DESCRIPTION AS FROM_SITE_DESCRIPTION
				, A.MEASURE	   						           	   
				, M.MEASURE_LABEL	  
				, M.MEASURE_COLOR
				, M.SORT_ORDER_NO	   							
				, A.YYYYMMDD AS B_YYYYMMDD									
				, 'D_'+ A.YYYYMMDD AS YYYYMMDD							
				, O.BASIS_YYYYMM AS YYYYMM									
				, O.CALENDAR_YYYYQQ AS YYYYQQ 									
				, O.CALENDAR_YYYY AS YYYY   									
				, SUM(ISNULL(QTY,0)) AS QTY										
				, RIGHT(O.BASIS_YYYYMM, 4)+O.ISO_WEEK AS ISO_WEEK	
				,ISNULL(MIN(F.FORMATION_TOTAL_YIELD),0) AS FORMATION_TOTAL_YIELD
				,ISNULL(MAX(F.LT_FORMATION) ,0) AS LT_FORMATION
			    , A.TRANSPORT_MODE_LINE
		   FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)							
		   INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd				
		   INNER JOIN #TblDynamicPivot_SCP0071_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE				
		   INNER JOIN #TblDynamicPivot_SCP0071_CLASS_TYPE C (NOLOCK) ON C.ITEM_ID= A.ITEM_ID --AND MO.CELL_ITEM_ID = A.CELL_ITEM_ID	
		   LEFT JOIN #SCM_MST_SITE S (NOLOCK) ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE
		   LEFT JOIN SCP_MST_FORMATION F  (NOLOCK) ON F.DIVISION_Id = A.DIVISION_ID AND F.ITEM_ID= A.CELL_ITEM_ID AND F.PLANT_SITE_ID = A.FROM_SITE
			WHERE A.DIVISION_ID			=@v_division_id				
			AND A.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
			AND A.PLAN_TYPE				= @v_plan_type					
			AND A.SEQ					=@v_seq					
			AND A.YYYYMMDD >= @v_from_yyyymmdd							
			AND A.YYYYMMDD <= @v_to_yyyymmdd			
			AND A.ATTRIBUTE9 IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
			-- [PJ20257329] 변경전 AND A.ATTRIBUTE9 IN ('A3000','A9000') 
			AND M.COLUMN_NAME  = 'PRODUCTION'
			GROUP BY  A.DIVISION_ID												
				, A.OPERATION_GROUP											
				, C.MATERIAL_CLASS_NAME
				, C.NICK_NAME						      					    
				, A.CELL_ITEM_ID	
				, C.TYPE
				, A.ITEM_ID			
				, A.FROM_SITE
				, S.SITE_DESCRIPTION
				, A.MEASURE	   						           	   
				, M.MEASURE_LABEL	  
				, M.MEASURE_COLOR
				, M.SORT_ORDER_NO	   		
				, A.YYYYMMDD,'D_'+ A.YYYYMMDD  ,O.BASIS_YYYYMM,O.CALENDAR_YYYYQQ  ,O.CALENDAR_YYYY ,RIGHT(O.BASIS_YYYYMM, 4)+O.ISO_WEEK 
				, A.TRANSPORT_MODE_LINE


			-- 'SHIP_REQ' INSERT
			-- YYYYMMDD를 LT_DAYS만큼 날짜 빼주고 @v_plan_start_yyyymmdd와 비교해서 p_plan_start_yyyymmdd 이전날짜가 나올경우 p_plan_start_yyyymmdd로 조정함.
			INSERT INTO #TblDynamicPivot_SCP0071
					SELECT 
						  A.DIVISION_ID												
						, A.OPERATION_GROUP											
						, A.MATERIAL_CLASS_NAME
						, A.NICK_NAME					
						, A.TYPE
						, A.TRANSPORT_MODE_LINE AS LINE_ID
						, A.CELL_ITEM_ID	
						, A.ITEM_ID	
						, A.FROM_SITE
						, A.FROM_SITE_DESCRIPTION
						, A.MEASURE	   						           	   
						, A.MEASURE_LABEL	  
						, A.MEASURE_COLOR
						, A.SORT_ORDER_NO	   							
						, A.B_YYYYMMDD									
						, A.YYYYMMDD
						, O.BASIS_YYYYMM AS YYYYMM									
						, O.CALENDAR_YYYYQQ AS YYYYQQ 									
						, O.CALENDAR_YYYY AS YYYY   									
						, (ISNULL(QTY,0)) AS QTY										
						, RIGHT(O.BASIS_YYYYMM, 4)+O.ISO_WEEK AS ISO_WEEK		
						, A.FORMATION_TOTAL_YIELD
						, A.LT_FORMATION
						, A.TRANSPORT_MODE_LINE 
					  FROM (
							   SELECT 
										  A.DIVISION_ID												
										, A.OPERATION_GROUP											
										, A.MATERIAL_CLASS_NAME
										, A.NICK_NAME					
										, A.TYPE
										, A.TRANSPORT_MODE_LINE
										, A.CELL_ITEM_ID	
										, A.ITEM_ID	
										, A.FROM_SITE
										, A.FROM_SITE_DESCRIPTION
										, A.MEASURE	   						           	   
										, A.MEASURE_LABEL	  
										, A.MEASURE_COLOR
										, A.SORT_ORDER_NO	   							
										, A.B_YYYYMMDD									
										, CASE WHEN CONVERT(DECIMAL, @v_plan_start_yyyymmdd) - CONVERT(DECIMAL, A.YYYYMMDD_LT) > 0 THEN  @v_plan_start_yyyymmdd ELSE  A.YYYYMMDD_LT  END AS YYYYMMDD
										, (ISNULL(QTY,0)) AS QTY										
										, A.FORMATION_TOTAL_YIELD
										, A.LT_FORMATION
									  FROM (
												   SELECT A.DIVISION_ID												
															, A.OPERATION_GROUP											
															, C.MATERIAL_CLASS_NAME
															, C.NICK_NAME					
															, C.TYPE
															, A.TRANSPORT_MODE_LINE
															, A.CELL_ITEM_ID	
															, A.ITEM_ID	
															, A.FROM_SITE
															, S.SITE_DESCRIPTION AS FROM_SITE_DESCRIPTION
															, A.MEASURE	   						           	   
															, M.MEASURE_LABEL	  
															, M.MEASURE_COLOR
															, M.SORT_ORDER_NO	   							
															, A.YYYYMMDD AS B_YYYYMMDD									
															, 'D_'+ A.YYYYMMDD AS YYYYMMDD							
															, REPLACE(CONVERT(VARCHAR, DATEADD(Day, MAX(F.LT_FORMATION)*-1, CONVERT(date, A.YYYYMMDD)) ),'-','')  AS YYYYMMDD_LT -- YYYYMMDD - LT_DAYS
															, SUM(ISNULL(QTY,0)) AS QTY										
															,MIN(F.FORMATION_TOTAL_YIELD) FORMATION_TOTAL_YIELD
															,MAX(F.LT_FORMATION) AS LT_FORMATION												
													   FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)							
													   INNER JOIN #TblDynamicPivot_SCP0071_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE				
													   INNER JOIN #TblDynamicPivot_SCP0071_CLASS_TYPE C (NOLOCK) ON C.ITEM_ID= A.ITEM_ID --AND MO.CELL_ITEM_ID = A.CELL_ITEM_ID	
													   INNER JOIN SCP_MST_FORMATION F  (NOLOCK) ON F.DIVISION_Id = A.DIVISION_ID AND F.ITEM_ID= A.CELL_ITEM_ID AND F.PLANT_SITE_ID = A.FROM_SITE
												 	   LEFT JOIN #SCM_MST_SITE S (NOLOCK) ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE
														WHERE A.DIVISION_ID				= @v_division_id-- '40'				
														AND A.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd --'20210712'
														AND A.PLAN_TYPE						= @v_plan_type --'PR'					
														AND A.SEQ								= @v_seq --'1'					
														AND A.YYYYMMDD >= @v_from_yyyymmdd 						
														AND A.YYYYMMDD <= @v_to_yyyymmdd 					
														AND M.COLUMN_NAME = 'SHIP_REQ'
														GROUP BY  A.DIVISION_ID												
															, A.OPERATION_GROUP											
															, C.MATERIAL_CLASS_NAME
															, C.NICK_NAME						      					    
															, A.CELL_ITEM_ID	
															, C.TYPE
															, A.TRANSPORT_MODE_LINE
															, A.ITEM_ID			
															, A.FROM_SITE
															, S.SITE_DESCRIPTION
															, A.MEASURE	   						           	   
															, M.MEASURE_LABEL	  
															, M.MEASURE_COLOR
															, M.SORT_ORDER_NO	   		
															, A.YYYYMMDD,'D_'+ A.YYYYMMDD 
											 ) A
								) A
								INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on YYYYMMDD = o.basis_yyyymmdd				
				
			-- 생산필요를 구하기 위한 SHIP_REQ수량/활성화 수율을 MEASURE 'SHIP_REQ_DIV'로 저장
  		   INSERT INTO #TblDynamicPivot_SCP0071	
		   SELECT 
						 DIVISION_ID		             
						,OPERATION_GROUP	    
						,MATERIAL_CLASS_NAME  
						,NICK_NAME 					  
						,TYPE  
						,LINE_ID
						,CELL_ITEM_ID		      
						,ITEM_ID			        
						,FROM_SITE			      
						,FROM_SITE_DESCRIPTION
						,'SHIP_REQ_DIV' AS MEASURE		        	
						,'SHIP_REQ_DIV ' + '(' + FROM_SITE_DESCRIPTION  +')'   AS MEASURE_LABEL	
						,'' AS MEASURE_COLOR	
						,'17' AS SORT_ORDER_NO		
						,B_yyyymmdd			      
						,YYYYMMDD			        
						,YYYYMM				        
						,YYYYQQ  	            
						,YYYY                 
						,ISNULL(A.QTY,0)/CASE WHEN ISNULL(ACTIVATION_YIELD,0)= 0 THEN 1 ELSE ACTIVATION_YIELD END  AS QTY	-- 	2023.08.03 나누기0 오류 임시 조치		          
						,ISO_WEEK			    
						,ACTIVATION_YIELD   
						,LT_DAYS  	
						,A.TRANSPORT_MODE_LINE
     		 FROM #TblDynamicPivot_SCP0071 A
		   WHERE MEASURE = 'SHIP_REQ'
	  
	  
		   -- LOADING 율 TIME을 구하기 위한 생산계획수량 * TACT_TIME을 'PRODUCTION_MUL' 로 저장
  		   INSERT INTO #TblDynamicPivot_SCP0071	
		   SELECT 
						 DIVISION_ID		             
						,OPERATION_GROUP	    
						,MATERIAL_CLASS_NAME  
						,NICK_NAME 					  
						,TYPE    
						,LINE_ID
						,CELL_ITEM_ID		      
						,ITEM_ID			        
						,FROM_SITE			      
						,FROM_SITE_DESCRIPTION
						,'PRODUCTION_MUL' AS MEASURE		        	
						,'PRODUCTION_MUL ' + '(' + FROM_SITE_DESCRIPTION  +')'   AS MEASURE_LABEL	
						,'' AS MEASURE_COLOR	
						,'9' AS SORT_ORDER_NO		
						,B_yyyymmdd			      
						,YYYYMMDD			        
						,YYYYMM				        
						,YYYYQQ  	            
						,YYYY                 
						--,ISNULL(A.QTY,0)*ISNULL(ACTIVATION_YIELD,0) AS QTY	
						,(SELECT TOP 1 MIN(ISNULL(TACT_TIME,0))
							 FROM #TACT_TIME B
						   WHERE  A.ITEM_ID = B.ITEM_ID
							   AND A.YYYYMM = B.MONTH
							   AND A.DIVISION_ID = B.DIVISION_ID
						 ) * ISNULL(A.QTY,0) AS QTY	
						,ISO_WEEK			    
						,ACTIVATION_YIELD   
						,LT_DAYS  	
						,A.TRANSPORT_MODE_LINE
     		 FROM #TblDynamicPivot_SCP0071 A
		   WHERE MEASURE = 'PRODUCTION'

			-- LOADING 율 TIME을 구하기 위한 Working Time(월별Capa) 을  'CAPA_MONTHLY으로' 로 저장
  		   INSERT INTO #TblDynamicPivot_SCP0071	
		   SELECT 
						 DIVISION_ID		             
						,OPERATION_GROUP	    
						,MATERIAL_CLASS_NAME  
						,NICK_NAME 					  
						,TYPE    
						,LINE_ID
						,CELL_ITEM_ID		      
						,ITEM_ID			        
						,FROM_SITE			      
						,FROM_SITE_DESCRIPTION
						,'CAPA_MONTHLY' AS MEASURE		        	
						,'CAPA_MONTHLY ' + '(' + FROM_SITE_DESCRIPTION  +')'   AS MEASURE_LABEL	
						,'' AS MEASURE_COLOR	
						,'19' AS SORT_ORDER_NO		
						,B_yyyymmdd			      
						,YYYYMMDD			        
						,YYYYMM				        
						,YYYYQQ  	            
						,YYYY                 
	        			,(SELECT TOP 1 MAX(ISNULL(CAPA,0)) AS CAPA_MONTH 
							 FROM #TblDynamicPivot_SCP0071_CAPA B
						   WHERE B.MONTH = A.yyyymm
							   AND B.LINE_ID = ISNULL(A.LINE_ID,'X')
							   AND B.TYPE = ISNULL(A.TYPE,'X')
							   ) AS QTY
						,ISO_WEEK			    
						,ACTIVATION_YIELD   
						,LT_DAYS  	
						,A.TRANSPORT_MODE_LINE
     		 FROM #TblDynamicPivot_SCP0071 A
		   WHERE MEASURE = 'PRODUCTION'
	  

	   ---------------------------------------------------------------------

		BEGIN
		PRINT '과부족 (shortage) ROW Insert';
			--------------과부족 (shortage) ROW Insert ----------------
		INSERT #TblDynamicPivot_SCP0071
		SELECT  DIVISION_ID		      
			,OPERATION_GROUP	    
			,MATERIAL_CLASS_NAME  
			,NICK_NAME 					  
			,TYPE   
			,LINE_ID
			,CELL_ITEM_ID		      
			,ITEM_ID	
			,FROM_SITE
			,FROM_SITE_DESCRIPTION
			,M.MEASURE							
			,M.MEASURE_LABEL				
			,M.MEASURE_COLOR	     	
			,M.SORT_ORDER_NO				
			,B_yyyymmdd			      
			,yyyymmdd			        
			,yyyymm				        
			,yyyyqq  	            
			,yyyy                 
			,0.0 AS qty				          
			,iso_week
			,ACTIVATION_YIELD  
			,LT_DAYS 
			,A.TRANSPORT_MODE_LINE
		   FROM #TblDynamicPivot_SCP0071 A
		  CROSS APPLY (SELECT COLUMN_NAME AS MEASURE , MEASURE_COLOR , MEASURE_LABEL , SORT_ORDER_NO
								   FROM  #TblDynamicPivot_SCP0071_MEASURE M (NOLOCK) 
								WHERE COLUMN_NAME = 'BALANCE'
							  ) M
		 WHERE A.MEASURE = 'MKT_FCST'
		 ;

		SELECT DIVISION_ID		      
			,OPERATION_GROUP	    
			,MATERIAL_CLASS_NAME  
			,NICK_NAME 					  
			,TYPE      
			,LINE_ID
			,CELL_ITEM_ID		      
			,ITEM_ID	
			,FROM_SITE
			,FROM_SITE_DESCRIPTION
			,MEASURE							
			,MEASURE_LABEL				
			,MEASURE_COLOR	     	
			,SORT_ORDER_NO				
			,B_yyyymmdd			      
			,yyyymmdd			        
			,yyyymm				        
			,yyyyqq  	            
			,yyyy                 
			,qty				          
			,iso_week			        
			,isnull(NULLIF( 
								( 
								CASE WHEN A.OPERATION_GROUP='A' THEN '1' ELSE (SELECT convert(nvarchar(50), MAX(ceiling(V.ACCUMULATED_CHILD_QTY)) ) 	
									FROM DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)				
									WHERE V.DIVISION_ID=A.DIVISION_ID 
									AND V.OPERATION_GROUP_ID='A'
									AND V.MODEL_ID  = A.ITEM_ID 
									AND V.CHILD_ITEM_ID IN ( SELECT value FROM dbo.FN_SplitString (A.CELL_ITEM_ID,',') )			--
									AND V.MODEL_ID  = A.ITEM_ID AND V.CHILD_ITEM_ID=A.CELL_ITEM_ID	
 														) END
								), '') , '1')  AS CELL_QTY   
			,ACTIVATION_YIELD  
			,LT_DAYS 
			,A.TRANSPORT_MODE_LINE
		INTO #TblDynamicPivot_SCP0071_TEMP1
	   FROM #TblDynamicPivot_SCP0071 A

   		IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0071_LAST') is not null       
		DROP TABLE #TblDynamicPivot_SCP0071_LAST;

		IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0071_TEMP2') is not null       
		DROP TABLE #TblDynamicPivot_SCP0071_TEMP2;

		SELECT A.DIVISION_ID		      
				,@v_plan_start_yyyymmdd	AS PLAN_START_YYYYMMDD
   				,@v_plan_type					AS PLAN_TYPE
				,@v_seq							AS SEQ
				,OPERATION_GROUP	    
				,MATERIAL_CLASS_NAME  
				,NICK_NAME 					  
				,TYPE 
				,LINE_ID
				,CELL_ITEM_ID		      
				,A.ITEM_ID	
				,FROM_SITE
				,FROM_SITE_DESCRIPTION
				,MEASURE							
				,MEASURE_LABEL				
				,MEASURE_COLOR	     	
				,SORT_ORDER_NO				
				,B_yyyymmdd			      
				,yyyymmdd			        
				,yyyymm				        
				,yyyyqq  	            
				,yyyy                 
				,qty				          
				,iso_week			     
				, A.QTY * A.CELL_QTY AS RESULT_QTY
				, A.CELL_QTY
				, A.ACTIVATION_YIELD
				, A.LT_DAYS
				, A.TRANSPORT_MODE_LINE
			INTO #TblDynamicPivot_SCP0071_LAST
		   FROM #TblDynamicPivot_SCP0071_TEMP1 A 
		   
		END


		PRINT '-------------DataSearch'
		print CONVERT(CHAR(23), getdate(), 21)
	
		/* LINE */
		SELECT DISTINCT A.TRANSPORT_MODE_LINE
		INTO #TblDynamicPivot_SCP0071_LINE
		FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
		LEFT JOIN #SCM_MST_SITE S WITH(NOLOCK) ON S.SCM_SITE_ID=A.TRANSPORT_MODE_LINE
		WHERE A.DIVISION_ID         = @v_division_id
			AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND A.PLAN_TYPE             = @v_plan_type
			AND A.SEQ                       = @v_seq
			AND A.YYYYMMDD             >= @v_from_yyyymmdd
			AND A.YYYYMMDD             <= @v_to_yyyymmdd
			AND A.MEASURE				= 'PRODUCTION'
			AND S.SITE_DESCRIPTION IS NULL
			--AND ISNULL(NULLIF(TRANSPORT_MODE_LINE,''),'-')!='-'
			AND NULLIF(A.TRANSPORT_MODE_LINE,'') NOT IN (SELECT SEGMENT1
																FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
																WHERE LOOKUP_TYPE='TRANSPORT_MODE_CODE'
																AND VALID_YN='Y')


	 
		PRINT '-------------Line Search'
		print CONVERT(CHAR(23), getdate(), 21)
	
	
		DECLARE @mQry_sum NVARCHAR(MAX); 
		DECLARE @mQry_max NVARCHAR(MAX); 
			
		DECLARE @mQry_isnull NVARCHAR(MAX);
		DECLARE @mQry_capa_isnull NVARCHAR(MAX); 
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mEXEC);

		-- PIVOIT 대상 날짜문자열 생성  2년치 (25개월만 가져옴)    
		SET @mQry_max = '';
		SET @mQry_sum = '';
		SET @mQry_capa_isnull = '';
		SET @mEXEC= '';

		SELECT  TOP 25  @mQry_sum = @mQry_sum+','+       
			CASE WHEN CHARINDEX('M_', YYYYMM) =1 THEN  ' ISNULL(SUM(CASE WHEN YYYYMM = '''+YYYYMM+''' THEN QTY END ),0)  AS ' + YYYYMM      
		 				WHEN CHARINDEX('Y_', YYYYMM) =1 THEN  ' ISNULL(SUM(CASE WHEN YYYYMM = '''+YYYYMM+''' THEN QTY END ),0)  AS ' + YYYYMM  	   
			END +''+CHAR(10)      
			,@mQry_isnull = @mQry_isnull+',ISNULL(A.' + A.YYYYMM +',0) AS '+YYYYMM+CHAR(10)
		FROM (       
					SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMM
							,MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE A.BASIS_YYYYMMDD  BETWEEN @v_plan_start_yyyymmdd AND  CONVERT(CHAR(8), DATEADD(MM, 24,  CONVERT(DATETIME,@v_plan_start_yyyymmdd)), 112)  
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME     
						UNION ALL
				  		SELECT 'Y_'+A.CALENDAR_YYYY  AS YYYYMM
							,'99' + MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE A.BASIS_YYYYMMDD  BETWEEN @v_plan_start_yyyymmdd AND  CONVERT(CHAR(8), DATEADD(MM, 24,  CONVERT(DATETIME,@v_plan_start_yyyymmdd)), 112)  
						GROUP BY A.CALENDAR_YYYY  
	     		) AS A     
		ORDER BY SORT_ORDER_NO ;
	 
   		SELECT  TOP 25  @mQry_max = @mQry_max+','+       
			CASE WHEN CHARINDEX('M_', YYYYMM) =1 THEN  ' ISNULL(MAX(CASE WHEN YYYYMM = '''+YYYYMM+''' THEN QTY END ),0)  AS ' + YYYYMM      
		 				WHEN CHARINDEX('Y_', YYYYMM) =1 THEN  ' ISNULL(MAX(CASE WHEN YYYYMM = '''+YYYYMM+''' THEN QTY END ),0)  AS ' + YYYYMM  	   
			END +''+CHAR(10)      
			,@mQry_capa_isnull = @mQry_capa_isnull+',ISNULL(A.' + A.YYYYMM +',0) AS '+YYYYMM+CHAR(10)
		FROM (       
					SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMM
							,MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE A.BASIS_YYYYMMDD  BETWEEN @v_plan_start_yyyymmdd AND  CONVERT(CHAR(8), DATEADD(MM, 24,  CONVERT(DATETIME,@v_plan_start_yyyymmdd)), 112)  
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME     
						UNION ALL
				  		SELECT 'Y_'+A.CALENDAR_YYYY  AS YYYYMM
							,'99' + MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO      
						FROM [DBO].[SCM_SYS_CALENDAR_M] A       
						WHERE A.BASIS_YYYYMMDD  BETWEEN @v_plan_start_yyyymmdd AND  CONVERT(CHAR(8), DATEADD(MM, 24,  CONVERT(DATETIME,@v_plan_start_yyyymmdd)), 112)  
						GROUP BY A.CALENDAR_YYYY  
	     		) AS A     
		ORDER BY SORT_ORDER_NO  ;      


		  DELETE SCP_ANL_CAPA_BALANCE_REPORT_SMALL
		  WHERE DIVISION_ID = @v_division_id
			  AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			  AND PLAN_TYPE = @v_plan_type
			  AND SEQ = @v_seq

		  -- 1-1 CAPA INSERT	   
		  SET @mEXEC = @mEXEC + '	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[TYPE],         '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [LINE_ID],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],[M0],[M1],[M2],[M3],[M4],[M5],[M6],                          '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                                                               '+CHAR(10);         
		  SET @mEXEC = @mEXEC + '  	(	 SELECT DIVISION_ID		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,OPERATION_GROUP											    '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_LABEL													'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + ' 		           ' + @mQry_sum  +' 				                                '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '  		FROM (                                                                             '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '				  SELECT  A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, A.OPERATION_GROUP, MATERIAL_CLASS_NAME, TYPE, A.LINE_ID, '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                    FROM_SITE, FROM_SITE_DESCRIPTION, ''CAPA'' AS MEASURE,  ''CAPA (''+ FROM_SITE_DESCRIPTION +'')'' AS MEASURE_LABEL, '''' AS MEASURE_COLOR, ''5'' AS SORT_ORDER_NO, ''M_''+B.YYYYMM AS YYYYMM, ''Y_''+B.YYYY AS YYYY  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                             ,(SELECT TOP 1 MAX(CAPA) FROM #TblDynamicPivot_SCP0071_CAPA C, #TBLDYNAMICPIVOT_SCP0071_LINE_BY_TYPE  L          '+CHAR(10);
		  SET @mEXEC = @mEXEC + '			   			        WHERE C.PLANT_SITE_ID = A.FROM_SITE AND  C.LINE_ID = A.LINE_ID AND C.MONTH = B.YYYYMM  AND A.TYPE = C.TYPE )  '+CHAR(10);    
		  SET @mEXEC = @mEXEC + '			   			        AS QTY                                                     '+CHAR(10);    
		  SET @mEXEC = @mEXEC + '                   FROM #TblDynamicPivot_SCP0071_LAST A 		    	'+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   INNER JOIN   #SCM_MST_SITE S ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE    	'+CHAR(10);
		  SET @mEXEC = @mEXEC + '		           ,( SELECT DISTINCT BASIS_YYYYMM  YYYYMM			'+CHAR(10);
		  SET @mEXEC = @mEXEC + '					                    ,CALENDAR_YYYY  YYYY                      '+CHAR(10);
		  SET @mEXEC = @mEXEC + '			           FROM SCM_SYS_CALENDAR_M                             '+CHAR(10);
		  SET @mEXEC = @mEXEC + '		            WHERE BASIS_YYYYMMDD >=   '''+ @v_plan_start_yyyymmdd  +'''              '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' 					      AND BASIS_YYYYMMDD <= '''+ @v_to_yyyymmdd  +'''                          '+CHAR(10);   
		  SET @mEXEC = @mEXEC + '	               ) B	,  #TBLDYNAMICPIVOT_SCP0071_LINE_BY_TYPE  L  							    '+CHAR(10);        
		  SET @mEXEC = @mEXEC + '  	              WHERE A.LINE_ID  = L.LINE_ID AND L.MONTH = B.YYYYMM                           '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	                  AND A.FROM_SITE != ''-''										 '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	                  AND MEASURE = ''PRODUCTION''							 '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	                  AND TYPE != ''TOTAL''							                 '+CHAR(10);
          SET @mEXEC = @mEXEC + ' 	              GROUP BY A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, A.OPERATION_GROUP, MATERIAL_CLASS_NAME, TYPE, A.LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO, B.YYYYMM, B.YYYY '  +CHAR(10);
		  SET @mEXEC = @mEXEC + '	) A                                                                                         '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, A.OPERATION_GROUP, MATERIAL_CLASS_NAME, TYPE, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO            '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' )    '+CHAR(10);

		  PRINT '-------------Capa Insert End'
		  print CONVERT(CHAR(23), getdate(), 21)

		  IF( @debug_mode ='T')
				BEGIN				
					SET @POS =1;
					SET @LEN =LEN(@mEXEC);
					WHILE @POS <= @LEN
						BEGIN
							PRINT SUBSTRING(@mEXEC,@POS,4000);
							SET @POS = @POS+4000;
						END;
				END;
		
		  EXEC (@mEXEC);
	  
		  SET  @mEXEC= '';
		
		  -- 1-2 TOTAL CAPA INSERT	   
		  SET @mEXEC = @mEXEC + '	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[TYPE], '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [LINE_ID],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO] )                                                           '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	(	 SELECT DIVISION_ID		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,OPERATION_GROUP											    '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_LABEL													'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '  		FROM (                                                                             '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '				  SELECT  A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, A.OPERATION_GROUP, MATERIAL_CLASS_NAME, TYPE, LINE_ID, '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                    FROM_SITE, FROM_SITE_DESCRIPTION, ''CAPA'' AS MEASURE,  ''CAPA (''+ FROM_SITE_DESCRIPTION +'')'' AS MEASURE_LABEL, '''' AS MEASURE_COLOR, ''5'' AS SORT_ORDER_NO, ''M_''+B.YYYYMM AS YYYYMM, ''Y_''+B.YYYY AS YYYY  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                             ,(SELECT TOP 1 MAX(CAPA) FROM #TblDynamicPivot_SCP0071_CAPA C WHERE C.PLANT_SITE_ID = A.FROM_SITE AND  C.LINE_ID = A.LINE_ID AND C.MONTH = B.YYYYMM  AND A.TYPE = C.TYPE )  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '			   			        AS QTY                                                     '+CHAR(10);    
		  SET @mEXEC = @mEXEC + '                   FROM #TblDynamicPivot_SCP0071_LAST A 		    	'+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   INNER JOIN   #SCM_MST_SITE S ON S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE    	'+CHAR(10);
		  SET @mEXEC = @mEXEC + '		           ,( SELECT DISTINCT BASIS_YYYYMM  YYYYMM			'+CHAR(10);
		  SET @mEXEC = @mEXEC + '					                    ,CALENDAR_YYYY  YYYY                      '+CHAR(10);
		  SET @mEXEC = @mEXEC + '			           FROM SCM_SYS_CALENDAR_M                             '+CHAR(10);
		  SET @mEXEC = @mEXEC + '		            WHERE BASIS_YYYYMMDD >=   '''+ @v_plan_start_yyyymmdd  +'''              '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' 					      AND BASIS_YYYYMMDD <= '''+ @v_to_yyyymmdd  +'''                          '+CHAR(10);   
		  SET @mEXEC = @mEXEC + '	               ) B																			 '+CHAR(10);        
		  SET @mEXEC = @mEXEC + '  	              WHERE A.FROM_SITE != ''-''										 '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	                  AND MEASURE = ''PRODUCTION''							 '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	                  AND TYPE = ''TOTAL''							                 '+CHAR(10);
          SET @mEXEC = @mEXEC + ' 	              GROUP BY A.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, A.OPERATION_GROUP, MATERIAL_CLASS_NAME, TYPE, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO, B.YYYYMM, B.YYYY '  +CHAR(10);
		  SET @mEXEC = @mEXEC + '	) A                                                                                         '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, A.OPERATION_GROUP, MATERIAL_CLASS_NAME, TYPE, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO            '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' )    '+CHAR(10);


		  PRINT '-------------Total Capa Insert End'
		  print CONVERT(CHAR(23), getdate(), 21)

		  IF( @debug_mode ='T')
				BEGIN				
					SET @POS =1;
					SET @LEN =LEN(@mEXEC);
					WHILE @POS <= @LEN
						BEGIN
							PRINT SUBSTRING(@mEXEC,@POS,4000);
							SET @POS = @POS+4000;
						END;
				END;
		
		  EXEC (@mEXEC);
	  
		  SET  @mEXEC= '';


  		   --MKT_FCST, RTF, 과부족(BALANCE), 생산계획(PRODUCTION) INSERT 
		   --BALANCE, MKT_FCST, PRODUCTION, ALLOCATION,SHIP_REQ, MODEL_INVENTORY, --ACTIVATE_PROGRESS : FORMATION_PROGRESS
		   --SHIP_PLAN
		   --SHIP_REQ
		   --MKT_FCST
		   --MODEL_INVENTORY
		   --ACTIVATE_PROGRESS
		   --FORMATION_YIELD

		  SET @mEXEC = @mEXEC + '	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[NICK_NAME],[TYPE], '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [ATTRIBUTE1],[LINE_ID],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],[M0],[M1],[M2],[M3],[M4],[M5],[M6],                          '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                                                               '+CHAR(10);         
		  SET @mEXEC = @mEXEC + '( SELECT A.*                     		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '     FROM(          		                                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '  		 SELECT DIVISION_ID		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,OPERATION_GROUP											    '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,NICK_NAME 															'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,CELL_ITEM_ID							        				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_LABEL													'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + ' 		           ' + @mQry_sum  +' 				                                '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '           FROM                                                     		             	'+CHAR(10);
		  SET @mEXEC = @mEXEC + '  		 ( SELECT A.DIVISION_ID		                                            '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,A.OPERATION_GROUP								   	        '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,NICK_NAME 															'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,CELL_ITEM_ID 		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '			     	,CASE WHEN FROM_SITE_DESCRIPTION IS NULL THEN MEASURE_LABEL  '+ CHAR(10);             
		  SET @mEXEC = @mEXEC + '				              ELSE MEASURE_LABEL  + '' (''+ FROM_SITE_DESCRIPTION  + '')''  '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					 END AS MEASURE_LABEL                                      '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					,''M_'' +YYYYMM	AS YYYYMM		                            '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					, RESULT_QTY AS QTY                                            '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '		  FROM	#TblDynamicPivot_SCP0071_LAST A                        '+ CHAR(10); 
		  SET @mEXEC = @mEXEC + '  	    WHERE  MEASURE IN (''BALANCE'', ''MKT_FCST'', ''PRODUCTION'',''PRODUCTION_MUL'', ''ALLOCATION'',''SHIP_REQ'',''SHIP_REQ_DIV'',''SHIP_PLAN'')    	  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  		  ) A                                                                                 '+ CHAR(10);
		  SET @mEXEC = @mEXEC + ' GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, MATERIAL_CLASS_NAME,    '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                 NICK_NAME, TYPE, CELL_ITEM_ID, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' 			 ) A  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	WHERE A.FROM_SITE IN ( SELECT SCM_SITE_ID FROM #SCM_MST_SITE S WHERE S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE  UNION	 SELECT ''-''  AS SCM_SITE_ID)		'+CHAR(10);
		  SET @mEXEC = @mEXEC + ' )                 '+CHAR(10);

		  PRINT '-------------Measure Insert End'
		  print CONVERT(CHAR(23), getdate(), 21)

		  IF( @debug_mode ='T')
				BEGIN				
					SET @POS =1;
					SET @LEN =LEN(@mEXEC);
					WHILE @POS <= @LEN
						BEGIN
							PRINT SUBSTRING(@mEXEC,@POS,4000);
							SET @POS = @POS+4000;
						END;
				END;
		
		  EXEC (@mEXEC);

		  -- CAPA MONTHLY추가 SUM값이 아니라 MAX값이라서 따로 INSERT
		  SET  @mEXEC= '';
		  SET @mEXEC = @mEXEC + '	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[TYPE],         '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [LINE_ID],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],[M0],[M1],[M2],[M3],[M4],[M5],[M6],                          '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                                                               '+CHAR(10);         
		  SET @mEXEC = @mEXEC + ' ( SELECT A.*                     		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '     FROM(          		                                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '  		 SELECT DIVISION_ID		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,OPERATION_GROUP											    '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_LABEL													'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + ' 		           ' + @mQry_max  +' 				                        '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '           FROM                                                     		             	'+ CHAR(10);
		  SET @mEXEC = @mEXEC + '  		 ( SELECT A.DIVISION_ID		                                            '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,A.OPERATION_GROUP								   	        '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '			     	,CASE WHEN FROM_SITE_DESCRIPTION IS NULL THEN MEASURE_LABEL  '+ CHAR(10);             
		  SET @mEXEC = @mEXEC + '				              ELSE MEASURE_LABEL  + '' (''+ FROM_SITE_DESCRIPTION  + '')''  '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					 END AS MEASURE_LABEL                                      '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					,''M_'' +YYYYMM	AS YYYYMM		                            '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					, RESULT_QTY AS QTY                                            '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '		  FROM	#TblDynamicPivot_SCP0071_LAST A                        '+ CHAR(10); 
		  SET @mEXEC = @mEXEC + '  	    WHERE  MEASURE IN (''CAPA_MONTHLY'')                     	  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  		  ) A                                                                                 '+ CHAR(10);
		  SET @mEXEC = @mEXEC + ' GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, MATERIAL_CLASS_NAME,    '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                 TYPE, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' 			 ) A  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	WHERE A.FROM_SITE IN ( SELECT SCM_SITE_ID FROM #SCM_MST_SITE S WHERE S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE  UNION	 SELECT ''-''  AS SCM_SITE_ID)		'+CHAR(10);
		  SET @mEXEC = @mEXEC + ' )                '+CHAR(10);

		  PRINT '-------------CAPA MONTHLY Insert End'
		  print CONVERT(CHAR(23), getdate(), 21)

		  IF( @debug_mode ='T')
				BEGIN				
					SET @POS =1;
					SET @LEN =LEN(@mEXEC);
					WHILE @POS <= @LEN
						BEGIN
							PRINT SUBSTRING(@mEXEC,@POS,4000);
							SET @POS = @POS+4000;
						END;
				END;
		
		  EXEC (@mEXEC);
	  
		  -- Loading율_Qty
		   INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[TYPE], 
					  [FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],[M0],[M1],[M2],[M3],[M4],[M5],[M6],     
					  [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                
		   (
				  SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP 
					   ,MATERIAL_CLASS_NAME, TYPE, FROM_SITE, FROM_SITE_DESCRIPTION
					   ,'LOADING_RATE_QTY' AS MEASURE,   'LOADING_RATE_QTY % ('+ FROM_SITE_DESCRIPTION +')'  AS MEASURE_LABEL, '' AS MEASURE_COLOR, 7 AS SORT_ORDER_NO 
					   ,CASE WHEN C_M0 = 0  THEN 0 ELSE (P_M0/C_M0)*100 END AS M0
					   ,CASE WHEN C_M1 = 0  THEN 0 ELSE (P_M1/C_M1)*100 END AS M1
					   ,CASE WHEN C_M2 = 0  THEN 0 ELSE (P_M2/C_M2)*100 END AS M2
					   ,CASE WHEN C_M3 = 0  THEN 0 ELSE (P_M3/C_M3)*100 END AS M3
					   ,CASE WHEN C_M4 = 0  THEN 0 ELSE (P_M4/C_M4)*100 END AS M4
					   ,CASE WHEN C_M5 = 0  THEN 0 ELSE (P_M5/C_M5)*100 END AS M5
					   ,CASE WHEN C_M6 = 0  THEN 0 ELSE (P_M6/C_M6)*100 END AS M6
					   ,CASE WHEN C_M7 = 0  THEN 0 ELSE (P_M7/C_M7)*100 END AS M7
					   ,CASE WHEN C_M8 = 0  THEN 0 ELSE (P_M8/C_M8)*100 END AS M8
					   ,CASE WHEN C_M9 = 0  THEN 0 ELSE (P_M9/C_M9)*100 END AS M9
					   ,CASE WHEN C_M10 = 0 THEN 0 ELSE (P_M10/C_M10)*100 END AS M10
					   ,CASE WHEN C_M11 = 0 THEN 0 ELSE (P_M11/C_M11)*100 END AS M11
					   ,CASE WHEN C_M12 = 0 THEN 0 ELSE (P_M12/C_M12)*100 END AS M12
					   ,CASE WHEN C_M13 = 0 THEN 0 ELSE (P_M13/C_M13)*100 END AS M13
					   ,CASE WHEN C_M14 = 0 THEN 0 ELSE (P_M14/C_M14)*100 END AS M14
					   ,CASE WHEN C_M15 = 0 THEN 0 ELSE (P_M15/C_M15)*100 END AS M15
					   ,CASE WHEN C_M16 = 0 THEN 0 ELSE (P_M16/C_M16)*100 END AS M16
					   ,CASE WHEN C_M17 = 0 THEN 0 ELSE (P_M17/C_M17)*100 END AS M17
					   ,CASE WHEN C_M18 = 0 THEN 0 ELSE (P_M18/C_M18)*100 END AS M18
					   ,CASE WHEN C_M19 = 0 THEN 0 ELSE (P_M19/C_M19)*100 END AS M19
					   ,CASE WHEN C_M20 = 0 THEN 0 ELSE (P_M20/C_M20)*100 END AS M20
					   ,CASE WHEN C_M21 = 0 THEN 0 ELSE (P_M21/C_M21)*100 END AS M21
					   ,CASE WHEN C_M22 = 0 THEN 0 ELSE (P_M22/C_M22)*100 END AS M22
					   ,CASE WHEN C_M23 = 0 THEN 0 ELSE (P_M23/C_M23)*100 END AS M23
					   ,CASE WHEN C_M24 = 0 THEN 0 ELSE (P_M24/C_M24)*100 END AS M24
			  FROM
					( 
      					SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, 
										MATERIAL_CLASS_NAME, TYPE, FROM_SITE, FROM_SITE_DESCRIPTION
								       ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M0 ,0) END ) AS numeric) AS C_M0           
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M1 ,0) END ) AS numeric) AS C_M1       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M2 ,0) END ) AS numeric) AS C_M2       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M3 ,0) END ) AS numeric) AS C_M3       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M4 ,0) END ) AS numeric) AS C_M4       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M5 ,0) END ) AS numeric) AS C_M5       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M6 ,0) END ) AS numeric) AS C_M6       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M7 ,0) END ) AS numeric) AS C_M7       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M8 ,0) END ) AS numeric) AS C_M8       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M9 ,0) END ) AS numeric) AS C_M9       
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M10,0) END ) AS numeric) AS C_M10      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M11,0) END ) AS numeric) AS C_M11      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M12,0) END ) AS numeric) AS C_M12      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M13,0) END ) AS numeric) AS C_M13      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M14,0) END ) AS numeric) AS C_M14      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M15,0) END ) AS numeric) AS C_M15      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M16,0) END ) AS numeric) AS C_M16      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M17,0) END ) AS numeric) AS C_M17      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M18,0) END ) AS numeric) AS C_M18      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M19,0) END ) AS numeric) AS C_M19      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M20,0) END ) AS numeric) AS C_M20      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M21,0) END ) AS numeric) AS C_M21      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M22,0) END ) AS numeric) AS C_M22      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M23,0) END ) AS numeric) AS C_M23      
									   ,CAST(SUM(CASE WHEN MEASURE = 'CAPA' THEN ISNULL(M24,0) END ) AS numeric) AS C_M24      
									   ,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M0 ,0) END ) AS numeric) AS P_M0 
									   ,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M1 ,0) END ) AS numeric) AS P_M1 
									   ,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M2 ,0) END ) AS numeric) AS P_M2 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M3 ,0) END ) AS numeric) AS P_M3  
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M4 ,0) END ) AS numeric) AS P_M4  
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M5 ,0) END ) AS numeric) AS P_M5  
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M6 ,0) END ) AS numeric) AS P_M6  
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M7 ,0) END ) AS numeric) AS P_M7  
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M8 ,0) END ) AS numeric) AS P_M8  
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M9 ,0) END ) AS numeric) AS P_M9  
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M10,0) END ) AS numeric) AS P_M10 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M11,0) END ) AS numeric) AS P_M11 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M12,0) END ) AS numeric) AS P_M12 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M13,0) END ) AS numeric) AS P_M13 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M14,0) END ) AS numeric) AS P_M14 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M15,0) END ) AS numeric) AS P_M15 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M16,0) END ) AS numeric) AS P_M16 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M17,0) END ) AS numeric) AS P_M17 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M18,0) END ) AS numeric) AS P_M18 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M19,0) END ) AS numeric) AS P_M19 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M20,0) END ) AS numeric) AS P_M20 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M21,0) END ) AS numeric) AS P_M21 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M22,0) END ) AS numeric) AS P_M22 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M23,0) END ) AS numeric) AS P_M23 
										,CAST(SUM(CASE WHEN MEASURE = 'PRODUCTION' THEN ISNULL(M24,0) END ) AS numeric) AS P_M24
								FROM  SCP_ANL_CAPA_BALANCE_REPORT_SMALL A
							 WHERE A.MEASURE IN ( 'CAPA', 'PRODUCTION')
			 					  AND DIVISION_ID = @v_division_id
								  AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								  AND PLAN_TYPE = @v_plan_type
								  AND SEQ = @v_seq
							 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, 
											 MATERIAL_CLASS_NAME,  TYPE, FROM_SITE, FROM_SITE_DESCRIPTION
					   ) A
				)
	 
		  -- Loading율_TIME
		  INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[TYPE], 
					  [FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],[M0],[M1],[M2],[M3],[M4],[M5],[M6],     
					  [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                
				(
				  SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ , '' AS OPERATION_GROUP
					   ,MATERIAL_CLASS_NAME, TYPE,  FROM_SITE, FROM_SITE_DESCRIPTION
					   ,'LOADING_RATE_TIME' AS MEASURE,   'LOADING_RATE_TIME % ('+ FROM_SITE_DESCRIPTION +')'  AS MEASURE_LABEL, '' AS MEASURE_COLOR, 8 AS SORT_ORDER_NO 
					   ,CASE WHEN C_M0 = 0  THEN 0 ELSE (P_M0/C_M0)*100 END AS M0
					   ,CASE WHEN C_M1 = 0  THEN 0 ELSE (P_M1/C_M1)*100 END AS M1
					   ,CASE WHEN C_M2 = 0  THEN 0 ELSE (P_M2/C_M2)*100 END AS M2
					   ,CASE WHEN C_M3 = 0  THEN 0 ELSE (P_M3/C_M3)*100 END AS M3
					   ,CASE WHEN C_M4 = 0  THEN 0 ELSE (P_M4/C_M4)*100 END AS M4
					   ,CASE WHEN C_M5 = 0  THEN 0 ELSE (P_M5/C_M5)*100 END AS M5
					   ,CASE WHEN C_M6 = 0  THEN 0 ELSE (P_M6/C_M6)*100 END AS M6
					   ,CASE WHEN C_M7 = 0  THEN 0 ELSE (P_M7/C_M7)*100 END AS M7
					   ,CASE WHEN C_M8 = 0  THEN 0 ELSE (P_M8/C_M8)*100 END AS M8
					   ,CASE WHEN C_M9 = 0  THEN 0 ELSE (P_M9/C_M9)*100 END AS M9
					   ,CASE WHEN C_M10 = 0 THEN 0 ELSE (P_M10/C_M10)*100 END AS M10
					   ,CASE WHEN C_M11 = 0 THEN 0 ELSE (P_M11/C_M11)*100 END AS M11
					   ,CASE WHEN C_M12 = 0 THEN 0 ELSE (P_M12/C_M12)*100 END AS M12
					   ,CASE WHEN C_M13 = 0 THEN 0 ELSE (P_M13/C_M13)*100 END AS M13
					   ,CASE WHEN C_M14 = 0 THEN 0 ELSE (P_M14/C_M14)*100 END AS M14
					   ,CASE WHEN C_M15 = 0 THEN 0 ELSE (P_M15/C_M15)*100 END AS M15
					   ,CASE WHEN C_M16 = 0 THEN 0 ELSE (P_M16/C_M16)*100 END AS M16
					   ,CASE WHEN C_M17 = 0 THEN 0 ELSE (P_M17/C_M17)*100 END AS M17
					   ,CASE WHEN C_M18 = 0 THEN 0 ELSE (P_M18/C_M18)*100 END AS M18
					   ,CASE WHEN C_M19 = 0 THEN 0 ELSE (P_M19/C_M19)*100 END AS M19
					   ,CASE WHEN C_M20 = 0 THEN 0 ELSE (P_M20/C_M20)*100 END AS M20
					   ,CASE WHEN C_M21 = 0 THEN 0 ELSE (P_M21/C_M21)*100 END AS M21
					   ,CASE WHEN C_M22 = 0 THEN 0 ELSE (P_M22/C_M22)*100 END AS M22
					   ,CASE WHEN C_M23 = 0 THEN 0 ELSE (P_M23/C_M23)*100 END AS M23
					   ,CASE WHEN C_M24 = 0 THEN 0 ELSE (P_M24/C_M24)*100 END AS M24
			  FROM
					( 
      					SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ,  
										MATERIAL_CLASS_NAME,  TYPE,  FROM_SITE, FROM_SITE_DESCRIPTION
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M0  END ) AS C_M0 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M1  END ) AS C_M1 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M2  END ) AS C_M2 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M3  END ) AS C_M3 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M4  END ) AS C_M4 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M5  END ) AS C_M5 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M6  END ) AS C_M6 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M7  END ) AS C_M7 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M8  END ) AS C_M8 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M9  END ) AS C_M9 
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M10 END ) AS C_M10
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M11 END ) AS C_M11
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M12 END ) AS C_M12
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M13 END ) AS C_M13
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M14 END ) AS C_M14
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M15 END ) AS C_M15
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M16 END ) AS C_M16
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M17 END ) AS C_M17
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M18 END ) AS C_M18
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M19 END ) AS C_M19
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M20 END ) AS C_M20
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M21 END ) AS C_M21
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M22 END ) AS C_M22
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M23 END ) AS C_M23
									   ,MAX(CASE WHEN MEASURE = 'CAPA_MONTHLY' THEN M24 END ) AS C_M24
									   ,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M0  END ) AS P_M0 
									   ,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M1  END ) AS P_M1 
									   ,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M2  END ) AS P_M2 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M3  END ) AS P_M3 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M4  END ) AS P_M4 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M5  END ) AS P_M5 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M6  END ) AS P_M6 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M7  END ) AS P_M7 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M8  END ) AS P_M8 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M9  END ) AS P_M9 
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M10 END ) AS P_M10
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M11 END ) AS P_M11
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M12 END ) AS P_M12
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M13 END ) AS P_M13
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M14 END ) AS P_M14
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M15 END ) AS P_M15
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M16 END ) AS P_M16
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M17 END ) AS P_M17
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M18 END ) AS P_M18
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M19 END ) AS P_M19
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M20 END ) AS P_M20
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M21 END ) AS P_M21
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M22 END ) AS P_M22
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M23 END ) AS P_M23
										,MAX(CASE WHEN MEASURE = 'PRODUCTION_MUL' THEN M24 END ) AS P_M24
								FROM  SCP_ANL_CAPA_BALANCE_REPORT_SMALL A
							  WHERE A.DIVISION_ID = @v_division_id
								  AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								  AND A.PLAN_TYPE = @v_plan_type
								  AND A.SEQ = @v_seq
		     					  AND A.MEASURE IN ( 'PRODUCTION_MUL', 'CAPA_MONTHLY' )
							 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ,  
											 MATERIAL_CLASS_NAME,  TYPE, FROM_SITE, FROM_SITE_DESCRIPTION
											 --LINE_ID
				   ) A
			)

		 -- 재고 중 MODEL_INVENTORY INSERT 재고 --> Formation Progress + Model Inventory
		 -- CELL_ITEM_ID --> ATTRIBUTE1
		  SET  @mEXEC= '';
		  SET @mEXEC = @mEXEC + '	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[NICK_NAME],[TYPE], '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [ATTRIBUTE1],[LINE_ID],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],[M0],[M1],[M2],[M3],[M4],[M5],[M6],                          '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                                                               '+CHAR(10);         
		  SET @mEXEC = @mEXEC + ' ( SELECT A.*                     		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '     FROM(          		                                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '  		 SELECT DIVISION_ID		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,OPERATION_GROUP											    '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,NICK_NAME 															'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,CELL_ITEM_ID   													'+ CHAR(10);           
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION								  	    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_LABEL													'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + ' 		           ' + @mQry_sum  +' 				                                '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '           FROM                                                     		             	'+ CHAR(10);
		  SET @mEXEC = @mEXEC + '  		 ( SELECT A.DIVISION_ID		                                            '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,A.OPERATION_GROUP								   	        '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,NICK_NAME 															'+ CHAR(10);           
		  SET @mEXEC = @mEXEC + '					,CELL_ITEM_ID   													'+ CHAR(10);           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '			     	,CASE WHEN FROM_SITE_DESCRIPTION IS NULL THEN MEASURE_LABEL  '+ CHAR(10);             
		  SET @mEXEC = @mEXEC + '				              ELSE MEASURE_LABEL  + '' (''+ FROM_SITE_DESCRIPTION  + '')''  '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					 END AS MEASURE_LABEL                                      '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					,''M_'' +YYYYMM	AS YYYYMM		                            '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					, QTY                                                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '		  FROM	#TblDynamicPivot_SCP0071_INVENTORY A             '+ CHAR(10); 
		  SET @mEXEC = @mEXEC + '  	    WHERE  MEASURE IN (''MODEL_INVENTORY'')                    	'+CHAR(10);
		  SET @mEXEC = @mEXEC + '  		  ) A                                                                                  '+ CHAR(10);
		  SET @mEXEC = @mEXEC + ' GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, MATERIAL_CLASS_NAME,    '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                 NICK_NAME, CELL_ITEM_ID, TYPE, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' 			 ) A  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	WHERE A.FROM_SITE IN ( SELECT SCM_SITE_ID FROM #SCM_MST_SITE S WHERE S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE  UNION	 SELECT ''-''  AS SCM_SITE_ID)		'+CHAR(10);
		  SET @mEXEC = @mEXEC + ' )                '+CHAR(10);
		  
		  PRINT '-------------INVENTORY Insert End1'
		  print CONVERT(CHAR(23), getdate(), 21)

		  IF( @debug_mode ='T')
				BEGIN				
					SET @POS =1;
					SET @LEN =LEN(@mEXEC);
					WHILE @POS <= @LEN
						BEGIN
							PRINT SUBSTRING(@mEXEC,@POS,4000);
							SET @POS = @POS+4000;
						END;
				END;
		
		  EXEC (@mEXEC);
		  
		 -- 재고 중 ACTIVATE_PROGRESS INSERT   : 재고 --> (ACTIVATE_PROGRESS)Formation Progress + Model Inventory
		  SET  @mEXEC= '';
		  SET @mEXEC = @mEXEC + '	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME], '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [NICK_NAME],[ATTRIBUTE1], [TYPE],[LINE_ID],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],[M0],[M1],[M2],[M3],[M4],[M5],[M6],                          '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                   [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                                                               '+CHAR(10);         
		  SET @mEXEC = @mEXEC + ' ( SELECT A.*                     		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '     FROM(          		                                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + '  		 SELECT DIVISION_ID		                                                '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,OPERATION_GROUP											    '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,NICK_NAME 															'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,CELL_ITEM_ID   													'+ CHAR(10);           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION								     	'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_LABEL													'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + ' 		           ' + @mQry_sum  +' 				                                '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '           FROM                                                     		             	'+ CHAR(10);
		  SET @mEXEC = @mEXEC + '  		 ( SELECT A.DIVISION_ID		                                            '+ CHAR(10);                                                                             
		  SET @mEXEC = @mEXEC + ' 				    ,PLAN_START_YYYYMMDD                                       '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,PLAN_TYPE						                                    '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,SEQ                                                                     '+ CHAR(10);                                     
		  SET @mEXEC = @mEXEC + '					,A.OPERATION_GROUP								   	        '+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,MATERIAL_CLASS_NAME										'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,NICK_NAME 															'+ CHAR(10);                                           
		  SET @mEXEC = @mEXEC + '					,CELL_ITEM_ID   													'+ CHAR(10);           
		  SET @mEXEC = @mEXEC + '					,TYPE            		 												'+ CHAR(10);                                           	  
		  SET @mEXEC = @mEXEC + '					,LINE_ID										     				    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE															'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,FROM_SITE_DESCRIPTION										'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,MEASURE																'+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '			     	,CASE WHEN FROM_SITE_DESCRIPTION IS NULL THEN MEASURE_LABEL  '+ CHAR(10);             
		  SET @mEXEC = @mEXEC + '				              ELSE MEASURE_LABEL  + '' (''+ FROM_SITE_DESCRIPTION  + '')''  '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					 END AS MEASURE_LABEL                                      '+ CHAR(10);
		  SET @mEXEC = @mEXEC + '					,MEASURE_COLOR	     										    '+ CHAR(10);                                          
		  SET @mEXEC = @mEXEC + '					,SORT_ORDER_NO				                                    '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					,''M_'' +YYYYMM	AS YYYYMM		                            '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '					, QTY                                            '+ CHAR(10);  
		  SET @mEXEC = @mEXEC + '		  FROM	#TblDynamicPivot_SCP0071_INVENTORY A             '+ CHAR(10); 
		  SET @mEXEC = @mEXEC + '  	    WHERE  MEASURE IN (''ACTIVATE_PROGRESS'')                    	'+CHAR(10);
		  SET @mEXEC = @mEXEC + '  		  ) A                                                                                  '+ CHAR(10);
		  SET @mEXEC = @mEXEC + ' GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, MATERIAL_CLASS_NAME,    '+CHAR(10);
		  SET @mEXEC = @mEXEC + '                 NICK_NAME, CELL_ITEM_ID,  TYPE, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION,MEASURE,MEASURE_LABEL,MEASURE_COLOR, SORT_ORDER_NO '+CHAR(10);
		  SET @mEXEC = @mEXEC + ' 			 ) A  '+CHAR(10);
		  SET @mEXEC = @mEXEC + '  	WHERE A.FROM_SITE IN ( SELECT SCM_SITE_ID FROM #SCM_MST_SITE S WHERE S.DIVISION_ID = A.DIVISION_ID AND S.SCM_SITE_ID = A.FROM_SITE  UNION	 SELECT ''-''  AS SCM_SITE_ID)		'+CHAR(10);
		  SET @mEXEC = @mEXEC + ' )                '+CHAR(10);
		  
		  PRINT '-------------INVENTORY Insert End2'
		  print CONVERT(CHAR(23), getdate(), 21)

		  IF( @debug_mode ='T')
				BEGIN				
					SET @POS =1;
					SET @LEN =LEN(@mEXEC);
					WHILE @POS <= @LEN
						BEGIN
							PRINT SUBSTRING(@mEXEC,@POS,4000);
							SET @POS = @POS+4000;
						END;
				END;
		
		  EXEC (@mEXEC); 


        PRINT '-------------INVENTORY Insert Start3'
		print CONVERT(CHAR(23), getdate(), 21)

		-- 재고  INSERT 
  	    INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],[NICK_NAME],
		              [TYPE], [ATTRIBUTE1], [LINE_ID],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],
					  [M0],[M1],[M2],[M3],[M4],[M5],[M6],[M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])
				    (
						     SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP 
									    ,MATERIAL_CLASS_NAME, NICK_NAME, TYPE, CELL_ITEM_ID, LINE_ID, FROM_SITE, FROM_SITE_DESCRIPTION
									    ,'INVENTORY' AS MEASURE 
										--,'INVENTORY' AS MEASURE_LABEL
			                            ,CASE WHEN FROM_SITE_DESCRIPTION IS NULL THEN 'INVENTORY'
		                                          ELSE 'INVENTORY' + ' ('+ FROM_SITE_DESCRIPTION  + ')' 
		  			                     END AS MEASURE_LABEL                    
										, '' AS MEASURE_COLOR, 17 AS SORT_ORDER_NO 
										,ISNULL(P_M0 ,0) + ISNULL(C_M0 ,0)   AS M0 
										,ISNULL(P_M1 ,0) + ISNULL(C_M1 ,0)   AS M1 
										,ISNULL(P_M2 ,0) + ISNULL(C_M2 ,0)   AS M2 
										,ISNULL(P_M3 ,0) + ISNULL(C_M3 ,0)   AS M3 
										,ISNULL(P_M4 ,0) + ISNULL(C_M4 ,0)   AS M4 
										,ISNULL(P_M5 ,0) + ISNULL(C_M5 ,0)   AS M5 
										,ISNULL(P_M6 ,0) + ISNULL(C_M6 ,0)   AS M6 
										,ISNULL(P_M7 ,0) + ISNULL(C_M7 ,0)   AS M7 
										,ISNULL(P_M8 ,0) + ISNULL(C_M8 ,0)   AS M8 
										,ISNULL(P_M9 ,0) + ISNULL(C_M9 ,0)   AS M9 
										,ISNULL(P_M10,0) + ISNULL(C_M10,0)   AS M10
										,ISNULL(P_M11,0) + ISNULL(C_M11,0)   AS M11
										,ISNULL(P_M12,0) + ISNULL(C_M12,0)   AS M12
										,ISNULL(P_M13,0) + ISNULL(C_M13,0)   AS M13
										,ISNULL(P_M14,0) + ISNULL(C_M14,0)   AS M14
										,ISNULL(P_M15,0) + ISNULL(C_M15,0)   AS M15
										,ISNULL(P_M16,0) + ISNULL(C_M16,0)   AS M16
										,ISNULL(P_M17,0) + ISNULL(C_M17,0)   AS M17
										,ISNULL(P_M18,0) + ISNULL(C_M18,0)   AS M18
										,ISNULL(P_M19,0) + ISNULL(C_M19,0)   AS M19
										,ISNULL(P_M20,0) + ISNULL(C_M20,0)   AS M20
										,ISNULL(P_M21,0) + ISNULL(C_M21,0)   AS M21
										,ISNULL(P_M22,0) + ISNULL(C_M22,0)   AS M22
										,ISNULL(P_M23,0) + ISNULL(C_M23,0)   AS M23
										,ISNULL(P_M24,0) + ISNULL(C_M24,0)   AS M24
							  FROM
							  (      			
								SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, 
													MATERIAL_CLASS_NAME, NICK_NAME, ATTRIBUTE1 AS CELL_ITEM_ID, TYPE, LINE_ID, MEASURE_LABEL, FROM_SITE, FROM_SITE_DESCRIPTION
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M0  END ) AS C_M0 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M1  END ) AS C_M1 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M2  END ) AS C_M2 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M3  END ) AS C_M3 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M4  END ) AS C_M4 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M5  END ) AS C_M5 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M6  END ) AS C_M6 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M7  END ) AS C_M7 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M8  END ) AS C_M8 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M9  END ) AS C_M9 
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M10 END ) AS C_M10
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M11 END ) AS C_M11
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M12 END ) AS C_M12
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M13 END ) AS C_M13
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M14 END ) AS C_M14
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M15 END ) AS C_M15
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M16 END ) AS C_M16
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M17 END ) AS C_M17
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M18 END ) AS C_M18
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M19 END ) AS C_M19
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M20 END ) AS C_M20
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M21 END ) AS C_M21
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M22 END ) AS C_M22
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M23 END ) AS C_M23
												   ,SUM(CASE WHEN MEASURE = 'ACTIVATE_PROGRESS' THEN M24 END ) AS C_M24
												   ,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M0  END ) AS P_M0 
												   ,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M1  END ) AS P_M1 
												   ,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M2  END ) AS P_M2 
												   ,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M3  END ) AS P_M3 
												   ,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M4  END ) AS P_M4 
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M5  END ) AS P_M5 
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M6  END ) AS P_M6 
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M7  END ) AS P_M7 
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M8  END ) AS P_M8 
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M9  END ) AS P_M9 
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M10 END ) AS P_M10
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M11 END ) AS P_M11
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M12 END ) AS P_M12
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M13 END ) AS P_M13
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M14 END ) AS P_M14
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M15 END ) AS P_M15
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M16 END ) AS P_M16
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M17 END ) AS P_M17
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M18 END ) AS P_M18
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M19 END ) AS P_M19
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M20 END ) AS P_M20
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M21 END ) AS P_M21
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M22 END ) AS P_M22
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M23 END ) AS P_M23
													,SUM(CASE WHEN MEASURE = 'MODEL_INVENTORY' THEN M24 END ) AS P_M24
											FROM  SCP_ANL_CAPA_BALANCE_REPORT_SMALL A
										  WHERE A.DIVISION_ID = '40'
											  AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
											  AND A.PLAN_TYPE = @v_plan_type
											  AND A.SEQ = @v_seq
											  AND A.MEASURE IN ( 'MODEL_INVENTORY','ACTIVATE_PROGRESS')
										 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, 
														 MATERIAL_CLASS_NAME, NICK_NAME, ATTRIBUTE1, TYPE, LINE_ID, MEASURE_LABEL, FROM_SITE, FROM_SITE_DESCRIPTION

								   ) A
							)
        PRINT '-------------INVENTORY Insert End3'
		print CONVERT(CHAR(23), getdate(), 21)

    -- 생산필요수량 INSERT  [수량(Cell) : (Ship Req(수량) / 활성화 수율) - 재고(오창+남경)]
	-- CELL_ITEM_ID --> [ATTRIBUTE1]
	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]([DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[OPERATION_GROUP],[MATERIAL_CLASS_NAME],
	              [TYPE], [ATTRIBUTE1],[FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO],
				  [M0],[M1],[M2],[M3],[M4],[M5],[M6], [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24])                                                
	 (
			 SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP 
			 	    ,MATERIAL_CLASS_NAME,  TYPE, CELL_ITEM_ID, FROM_SITE, FROM_SITE_DESCRIPTION
				    ,'PROD_REQ' AS MEASURE,   'Prod. Request' AS MEASURE_LABEL, '' AS MEASURE_COLOR, 4 AS SORT_ORDER_NO 
				    ,ISNULL(P_M0 ,0) -  ISNULL(C_M0 ,0)  AS M0 
				    ,ISNULL(P_M1 ,0) -  ISNULL(C_M1 ,0)  AS M1 
					,ISNULL(P_M2 ,0) -  ISNULL(C_M2 ,0)  AS M2 
					,ISNULL(P_M3 ,0) -  ISNULL(C_M3 ,0)  AS M3 
					,ISNULL(P_M4 ,0) -  ISNULL(C_M4 ,0)  AS M4 
					,ISNULL(P_M5 ,0) -  ISNULL(C_M5 ,0)  AS M5 
					,ISNULL(P_M6 ,0) -  ISNULL(C_M6 ,0)  AS M6 
					,ISNULL(P_M7 ,0) -  ISNULL(C_M7 ,0)  AS M7 
					,ISNULL(P_M8 ,0) -  ISNULL(C_M8 ,0)  AS M8 
					,ISNULL(P_M9 ,0) -  ISNULL(C_M9 ,0)  AS M9 
					,ISNULL(P_M10,0) -  ISNULL(C_M10,0)  AS M10
					,ISNULL(P_M11,0) -  ISNULL(C_M11,0)  AS M11
					,ISNULL(P_M12,0) -  ISNULL(C_M12,0)  AS M12
					,ISNULL(P_M13,0) -  ISNULL(C_M13,0)  AS M13
					,ISNULL(P_M14,0) -  ISNULL(C_M14,0)  AS M14
					,ISNULL(P_M15,0) -  ISNULL(C_M15,0)  AS M15
					,ISNULL(P_M16,0) -  ISNULL(C_M16,0)  AS M16
					,ISNULL(P_M17,0) -  ISNULL(C_M17,0)  AS M17
					,ISNULL(P_M18,0) -  ISNULL(C_M18,0)  AS M18
					,ISNULL(P_M19,0) -  ISNULL(C_M19,0)  AS M19
					,ISNULL(P_M20,0) -  ISNULL(C_M20,0)  AS M20
					,ISNULL(P_M21,0) -  ISNULL(C_M21,0)  AS M21
					,ISNULL(P_M22,0) -  ISNULL(C_M22,0)  AS M22
					,ISNULL(P_M23,0) -  ISNULL(C_M23,0)  AS M23
					,ISNULL(P_M24,0) -  ISNULL(C_M24,0)  AS M24
		  FROM
					(
      				SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE,  SEQ, OPERATION_GROUP, 
									MATERIAL_CLASS_NAME,  TYPE, ATTRIBUTE1 AS CELL_ITEM_ID, FROM_SITE, FROM_SITE_DESCRIPTION
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M0  END ) AS C_M0 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M1  END ) AS C_M1 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M2  END ) AS C_M2 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M3  END ) AS C_M3 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M4  END ) AS C_M4 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M5  END ) AS C_M5 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M6  END ) AS C_M6 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M7  END ) AS C_M7 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M8  END ) AS C_M8 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M9  END ) AS C_M9 
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M10 END ) AS C_M10
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M11 END ) AS C_M11
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M12 END ) AS C_M12
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M13 END ) AS C_M13
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M14 END ) AS C_M14
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M15 END ) AS C_M15
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M16 END ) AS C_M16
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M17 END ) AS C_M17
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M18 END ) AS C_M18
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M19 END ) AS C_M19
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M20 END ) AS C_M20
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M21 END ) AS C_M21
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M22 END ) AS C_M22
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M23 END ) AS C_M23
								   ,SUM(CASE WHEN MEASURE = 'INVENTORY' THEN M24 END ) AS C_M24
								   ,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M0  END ) AS P_M0 
								   ,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M1  END ) AS P_M1 
								   ,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M2  END ) AS P_M2 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M3  END ) AS P_M3 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M4  END ) AS P_M4 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M5  END ) AS P_M5 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M6  END ) AS P_M6 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M7  END ) AS P_M7 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M8  END ) AS P_M8 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M9  END ) AS P_M9 
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M10 END ) AS P_M10
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M11 END ) AS P_M11
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M12 END ) AS P_M12
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M13 END ) AS P_M13
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M14 END ) AS P_M14
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M15 END ) AS P_M15
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M16 END ) AS P_M16
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M17 END ) AS P_M17
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M18 END ) AS P_M18
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M19 END ) AS P_M19
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M20 END ) AS P_M20
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M21 END ) AS P_M21
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M22 END ) AS P_M22
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M23 END ) AS P_M23
									,SUM(CASE WHEN MEASURE = 'SHIP_REQ_DIV' THEN M24 END ) AS P_M24
							FROM  SCP_ANL_CAPA_BALANCE_REPORT_SMALL A
						  WHERE A.DIVISION_ID = @v_division_id
							  AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							  AND A.PLAN_TYPE = @v_plan_type
							  AND A.SEQ = @v_seq
							  AND A.MEASURE IN ( 'SHIP_REQ_DIV', 'INVENTORY')
						 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, 
										 MATERIAL_CLASS_NAME,  TYPE, ATTRIBUTE1, FROM_SITE, FROM_SITE_DESCRIPTION
			   ) A
		) 

		PRINT '-------------Ship Req Insert End'
		print CONVERT(CHAR(23), getdate(), 21)

	------------------ TOTAL ROW INSERT --------------
	INSERT INTO [dbo].[SCP_ANL_CAPA_BALANCE_REPORT_SMALL]
	(
	   [DIVISION_ID],[PLAN_START_YYYYMMDD],[PLAN_TYPE],[SEQ],[MATERIAL_CLASS_NAME],[TYPE], 
        [FROM_SITE],[FROM_SITE_DESCRIPTION],[MEASURE],[MEASURE_LABEL],[MEASURE_COLOR],[SORT_ORDER_NO] ,[M0],[M1],[M2],[M3],[M4],[M5],[M6],     
                  [M7],[M8],[M9],[M10],[M11],[M12],[M13],[M14],[M15],[M16],[M17],[M18],[M19],[M20],[M21],[M22],[M23],[M24]
	 )
     (
			SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ 
			 	       ,MATERIAL_CLASS_NAME,  'Total' AS TYPE,  FROM_SITE, FROM_SITE_DESCRIPTION
				       ,MEASURE,   MEASURE_LABEL, MEASURE_COLOR, SORT_ORDER_NO
					   ,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0
				FROM SCP_ANL_CAPA_BALANCE_REPORT_SMALL A
						WHERE A.DIVISION_ID = @v_division_id
							AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							AND A.PLAN_TYPE = @v_plan_type
							AND A.SEQ = @v_seq
							AND TYPE != 'Total'
							AND MATERIAL_CLASS_NAME IS NOT NULL
		GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ 
			 		   ,MATERIAL_CLASS_NAME,   FROM_SITE, FROM_SITE_DESCRIPTION
				   	   ,MEASURE,   MEASURE_LABEL, MEASURE_COLOR ,SORT_ORDER_NO  
      )
				
		PRINT '-------------TOTAL ROW INSERT End'
		print CONVERT(CHAR(23), getdate(), 21)

		--임시테이블 삭제      
		IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0071_item') is not null       
			DROP TABLE #TblDynamicPivot_SCP0071_item     

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_cellItem') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_cellItem;    

		IF OBJECT_ID('tempdb..#tbl_ITEM_ID_Cell_Item_ID') IS NOT NULL	
		DROP TABLE #tbl_ITEM_ID_Cell_Item_ID

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_LINE_LOAD') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0071_LINE_LOAD

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_LINE') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_LINE;  

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_CLASS_TYPE') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0071_CLASS_TYPE

		IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0071') is not null       
			DROP TABLE #TblDynamicPivot_SCP0071

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_RANK') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0071_RANK

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_MEASURE') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_SCP0071_MEASURE

		IF OBJECT_ID('tempdb..#PACK') IS NOT NULL	
		DROP TABLE #PACK

		IF OBJECT_ID('tempdb..#TCOCELL') IS NOT NULL	
		DROP TABLE #TCOCELL

		IF OBJECT_ID('tempdb..#CELL') IS NOT NULL	
		DROP TABLE #CELL

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_item_order') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_item_order;

		--생산실적, 출하실적 용
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_RESULT') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_RESULT;

		--생산 로드율 주SUM, 월SUM
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_LINE_LOAD_BASE') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_LINE_LOAD_BASE;  

		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0071_INVENTORY') IS NOT NULL      
		DROP TABLE #TblDynamicPivot_SCP0071_INVENTORY;
		
		IF OBJECT_ID('tempdb..#LOCATION_GROUP_LOCATION_GROUP_ROUTE') IS NOT NULL      
		DROP TABLE #LOCATION_GROUP_LOCATION_GROUP_ROUTE;
		
        -- PJ20216891
        -- ISUZU item
		IF OBJECT_ID('tempdb..#ISUZU') IS NOT NULL      
		DROP TABLE #ISUZU;

		END
    END TRY

    BEGIN CATCH                  
    --  IF @@TRANCOUNT > 0                  
    --    BEGIN                  
    --      ROLLBACK                   
    --END;                  
                        
      -- ERROR LOG                  
      SET @v_log_type = N'ERROR';                  
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
      SET @d_event_date = SYSDATETIME();                  
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                                ,@p_log_type      =@v_log_type                  
                                ,@p_log_count     =@n_log_count                   
                                ,@p_log_message   =@v_log_message                   
                                ,@p_description   =@v_description                   
                                ,@p_event_date    =@d_event_date                   
                                ,@p_user_id       =@v_batch_user                  
                                ;                  
       --      PRINT @@ERROR                  
      return -1                  
    END CATCH;   

    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'########## END of procedure ##########';                  
    SET @v_description = N'['  + @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
    return 1                
                  
    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END;                  
                  
  END;  
