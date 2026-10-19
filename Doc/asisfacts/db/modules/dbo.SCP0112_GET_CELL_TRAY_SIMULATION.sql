
/*
 * Program ID   : SCP0111_CellTraySimulatio
 * Description  : SCP0112 Cell Tray Simulation 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/09/11   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - SCP0112 Cell Tray Simulation 조회
 */

 CREATE PROCEDURE [dbo].[SCP0112_GET_CELL_TRAY_SIMULATION]
   @p_division_id			NVARCHAR(MAX)
  ,@p_plan_start_yyyymmdd	NVARCHAR(8)
  ,@p_plan_type				NVARCHAR(50)
  ,@p_from_yyyymmdd			NVARCHAR(MAX)
  ,@p_to_yyyymmdd			NVARCHAR(MAX)
  ,@p_to_site				NVARCHAR(MAX)

AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--DECLARE @p_division_id NVARCHAR(MAX);
	--DECLARE @p_plan_start_yyyymmdd	NVARCHAR(8);
	--DECLARE @p_plan_type				NVARCHAR(50)='';
	--DECLARE @p_from_yyyymmdd			NVARCHAR(MAX);
	--DECLARE @p_to_yyyymmdd				NVARCHAR(MAX);
	--DECLARE @p_to_site				NVARCHAR(MAX);

	--SET @p_division_id = '82';
	--SET @p_plan_start_yyyymmdd = '20240923';
	--SET @p_plan_type = 'FN';
	--SET @p_from_yyyymmdd = '20240901';
	--SET @p_to_yyyymmdd = '20250921';
	--SET @p_to_site = 'KR32625300_82-P';

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = ',' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @from_site_max_loop_cnt		INTEGER = 0; 
	DECLARE @from_site_mst_loop_cnt		INTEGER = 0;


	--GROUP 조회
	DECLARE @COLUMNS NVARCHAR(MAX)
	DECLARE @COLUMN_WEEK NVARCHAR(MAX)
	DECLARE @COLUMNS_FROM_SITE NVARCHAR(MAX)
	DECLARE @COLUMN_FROM_SITE NVARCHAR(MAX)
	DECLARE @SQL     NVARCHAR(MAX)

	SET @COLUMNS = '';
	SET @COLUMN_WEEK = '';
	SET @COLUMNS_FROM_SITE = '';
	SET @COLUMN_FROM_SITE = '';
	SET @SQL = '';

	--주차별
	SELECT @COLUMNS = @COLUMNS +  WEEK + ','
	  FROM (
			 SELECT DISTINCT
					'W_' + WEEK AS WEEK
					, CASE WHEN RIGHT(WEEK, 4) = '1201' THEN LEFT(WEEK, 4) + '1299' ELSE WEEK END  AS SORT_ORDER_NO	-- 마지막 주차의 sort를 위해 추가 
			   FROM SCP_ANL_CELL_Tray_Simulation_Weekly  WITH(NOLOCK)
			  WHERE 1=1
				AND DIVISION_ID			= @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE			= @p_plan_type
				AND LEFT( WEEK, 6) BETWEEN LEFT(@p_from_yyyymmdd, 6) AND LEFT(@p_to_yyyymmdd, 6)
				AND TO_SITE = @p_to_site
		   ) AS WEEKS
	 --ORDER BY WEEK
	 ORDER BY SORT_ORDER_NO

	--FROM_SITE 별
	SELECT @COLUMNS_FROM_SITE = @COLUMNS_FROM_SITE +  FROM_SITE + ','
	  FROM (
			 SELECT DISTINCT FROM_SITE
			   FROM SCP_ANL_CELL_Tray_Simulation_Weekly  WITH(NOLOCK)
			  WHERE 1=1
				AND DIVISION_ID			= @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE			= @p_plan_type
				AND LEFT( WEEK, 6) BETWEEN LEFT(@p_from_yyyymmdd, 6) AND LEFT(@p_to_yyyymmdd, 6)
				AND TO_SITE = @p_to_site
		   ) AS FROM_SITE_ALL
	 ORDER BY FROM_SITE

	--SELECT @COLUMNS ; SELECT @COLUMNS_FROM_SITE ;  RETURN;

	IF (LEN(@COLUMNS) > 0)
	BEGIN

		
		/********************************************************************************      
		* 임시테이블만들기      
		********************************************************************************/      
		IF OBJECT_ID('tempdb..#TblCellTraySimulation_Temp') IS NOT NULL      
			DROP TABLE #TblCellTraySimulation_Temp;     
			
		CREATE TABLE #TblCellTraySimulation_Temp
		(
			 DIVISION_ID				NVARCHAR(10)
			,PLAN_START_YYYYMMDD		NVARCHAR(8)
			,PLAN_TYPE					NVARCHAR(2)
			,FROM_SITE					NVARCHAR(30)
			,TO_SITE					NVARCHAR(30)
			,FROM_SITE_DESCRIPTION		NVARCHAR(100)
			,TO_SITE_DESCRIPTION		NVARCHAR(100)
			,MEASURE_TYPE				NVARCHAR(100)
			,MEASURE_NAME				NVARCHAR(100)
			,MEASURE_NAME2				NVARCHAR(100)
			,MEASURE_VALUE				NVARCHAR(100)
			,BOH_QTY					numeric(20,10)
			,SEQ_FLAG					NVARCHAR(5)
			,QTY						BIGINT
			,WEEK						NVARCHAR(10)
		);

		
		/********************************************************************************      
		1. Semi WH In, Usage, Stock OSP 생성
		********************************************************************************/  
		SET @SQL = @SQL + '			INSERT #TblCellTraySimulation_Temp '+CHAR(10);
		SET @SQL = @SQL + '			SELECT a.DIVISION_ID '+CHAR(10);
		SET @SQL = @SQL + '				 , a.PLAN_START_YYYYMMDD '+CHAR(10);
		SET @SQL = @SQL + '				 , a.PLAN_TYPE '+CHAR(10);
		SET @SQL = @SQL + '				 , a.FROM_SITE '+CHAR(10);
		SET @SQL = @SQL + '				 , a.TO_SITE '+CHAR(10);
		SET @SQL = @SQL + '				 , b.SITE_DESCRIPTION AS FROM_SITE_DESCRIPTION '+CHAR(10);
		SET @SQL = @SQL + '				 , c.SITE_DESCRIPTION AS TO_SITE_DESCRIPTION '+CHAR(10);
		SET @SQL = @SQL + '				 , a.MEASURE AS MEASURE_TYPE '+CHAR(10);
		SET @SQL = @SQL + '				 , CASE WHEN a.MEASURE = ''BOH_STOCK_OSP'' THEN ''Stock'' ELSE d.COLUMN_LABEL_NAME END AS MEASURE_NAME '+CHAR(10);
		SET @SQL = @SQL + '				 , CASE WHEN a.MEASURE = ''BOH_STOCK_OSP'' THEN ''Full'' ELSE d.COLUMN_LABEL_NAME END AS MEASURE_NAME2 '+CHAR(10);
		SET @SQL = @SQL + '				 , d.COLUMN_LABEL_NAME AS MEASURE_VALUE '+CHAR(10);
		SET @SQL = @SQL + '				 , CONVERT (BIGINT, a.BOH_QTY) AS BOH_QTY '+CHAR(10);
		SET @SQL = @SQL + '				 , a.SEQ_FLAG '+CHAR(10);
		--SET @SQL = @SQL + '				 , CASE WHEN b.SITE_DESCRIPTION LIKE ''%ESNJ%'' THEN CEILING(a.QTY / 252) '+CHAR(10);
		--SET @SQL = @SQL + '				 		WHEN b.SITE_DESCRIPTION LIKE ''%ESNB%'' THEN CEILING(a.QTY / 288) '+CHAR(10);
		--SET @SQL = @SQL + '				 		ELSE a.QTY END AS QTY '+CHAR(10);
		SET @SQL = @SQL + '				 , a.QTY '+CHAR(10);
		SET @SQL = @SQL + '				 , ''W_'' + a.WEEK AS WEEK '+CHAR(10);
		SET @SQL = @SQL + '			  FROM SCP_ANL_CELL_Tray_Simulation_Weekly a WITH(NOLOCK) '+CHAR(10);
		SET @SQL = @SQL + '			  LEFT JOIN SCM_MST_SITE b WITH(NOLOCK) ON b.DIVISION_ID = a.DIVISION_ID AND b.SCM_SITE_ID = a.FROM_SITE  '+CHAR(10);
		SET @SQL = @SQL + '			  LEFT JOIN SCM_MST_SITE c WITH(NOLOCK) ON c.DIVISION_ID = a.DIVISION_ID AND c.SCM_SITE_ID = a.TO_SITE  '+CHAR(10);
		SET @SQL = @SQL + '			  LEFT JOIN SCM_MST_SHEET_MEASURE d WITH(NOLOCK) ON d.PROGRAM_ID = ''SCP0112'' AND d.COLUMN_NAME = a.MEASURE '+CHAR(10);
		SET @SQL = @SQL + '			  WHERE 1=1 '+CHAR(10);
		SET @SQL = @SQL + '			    AND a.DIVISION_ID = ''' + @p_division_id + ''''+CHAR(10);
		SET @SQL = @SQL + '			    AND a.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + ''''+CHAR(10);
		SET @SQL = @SQL + '			    AND a.PLAN_TYPE = ''' + @p_plan_type + ''''+CHAR(10);
		SET @SQL = @SQL + '			    AND LEFT(WEEK, 6) BETWEEN LEFT(''' + @p_from_yyyymmdd  + ''', 6) AND LEFT(''' + @p_to_yyyymmdd + ''', 6) '+CHAR(10);
		SET @SQL = @SQL + '			    AND a.TO_SITE = ''' + @p_to_site + ''''+CHAR(10);

		EXEC(@SQL);

		DECLARE @CNT int;
		SET @CNT = 0;

		-- LOOP 길이를 판단
		SET @from_site_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@COLUMNS_FROM_SITE, @v_delimiter);
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@COLUMNS, @v_delimiter);

		-- FROM_SITE 별 loop
		WHILE LEN(@COLUMNS_FROM_SITE) > 0 AND @from_site_mst_loop_cnt < @from_site_max_loop_cnt
		BEGIN

			SET @from_site_mst_loop_cnt = @from_site_mst_loop_cnt + 1;
			SET @COLUMN_FROM_SITE = [dbo].[SCM_ARR_SPL_VAL](@COLUMNS_FROM_SITE, @v_delimiter , @from_site_mst_loop_cnt) ;
			SET @mst_loop_cnt = 0;	--주차 초기화

			IF (@COLUMN_FROM_SITE = '') CONTINUE;

			-- 주차별로 없는 데이터 생성
			WHILE LEN(@COLUMNS) > 0 AND @mst_loop_cnt < @max_loop_cnt
			BEGIN

				SET @mst_loop_cnt = @mst_loop_cnt + 1;

				SET @COLUMN_WEEK = [dbo].[SCM_ARR_SPL_VAL](@COLUMNS, @v_delimiter , @mst_loop_cnt) ;

				IF (@COLUMN_WEEK = '') CONTINUE;

				--SEMI_WH_IN 정보 유무판단
				SELECT @CNT = COUNT(*) 
				FROM #TblCellTraySimulation_Temp WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE =  @p_plan_type
				AND FROM_SITE = @COLUMN_FROM_SITE
				AND TO_SITE = @p_to_site
				AND MEASURE_TYPE = 'SEMI_WH_IN'
				AND WEEK = @COLUMN_WEEK

				-- 해당주차 데이터 없을 경우, 생성
				IF (@CNT = 0)
				BEGIN
						
					INSERT #TblCellTraySimulation_Temp
					SELECT TOP 1 a.DIVISION_ID
						, a.PLAN_START_YYYYMMDD 
						, a.PLAN_TYPE 
						, a.FROM_SITE
						, a.TO_SITE
						, a.FROM_SITE_DESCRIPTION 
						, a.TO_SITE_DESCRIPTION 
						, a.MEASURE_TYPE 
						, a.MEASURE_NAME 
						, a.MEASURE_NAME2
						, a.MEASURE_VALUE 
						, 0 AS BOH_QTY 
						, a.SEQ_FLAG 
						, NULL AS QTY	--PW BOH
						, @COLUMN_WEEK 
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					WHERE DIVISION_ID = @p_division_id
					AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND PLAN_TYPE =  @p_plan_type
					AND FROM_SITE = @COLUMN_FROM_SITE
					AND TO_SITE = @p_to_site
					AND MEASURE_TYPE = 'SEMI_WH_IN'
					;

				END;

				--USAGE 정보 유무판단
				SELECT @CNT = COUNT(*) 
				FROM #TblCellTraySimulation_Temp WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE =  @p_plan_type
				AND FROM_SITE = @COLUMN_FROM_SITE
				AND TO_SITE = @p_to_site
				AND MEASURE_TYPE = 'USAGE'
				AND WEEK = @COLUMN_WEEK

				-- 해당주차 데이터 없을 경우, 생성
				IF (@CNT = 0)
				BEGIN
						
					INSERT #TblCellTraySimulation_Temp
					SELECT TOP 1 a.DIVISION_ID
						, a.PLAN_START_YYYYMMDD 
						, a.PLAN_TYPE 
						, a.FROM_SITE
						, a.TO_SITE
						, a.FROM_SITE_DESCRIPTION 
						, a.TO_SITE_DESCRIPTION 
						, a.MEASURE_TYPE 
						, a.MEASURE_NAME 
						, a.MEASURE_NAME2
						, a.MEASURE_VALUE 
						, 0 AS BOH_QTY 
						, a.SEQ_FLAG 
						, NULL AS QTY	--PW BOH
						, @COLUMN_WEEK 
						FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
						AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND PLAN_TYPE =  @p_plan_type
						AND FROM_SITE = @COLUMN_FROM_SITE
						AND TO_SITE = @p_to_site
						AND MEASURE_TYPE = 'USAGE'
						;

				END;

				--BOH_STOCK_OSP 정보 유무판단
				SELECT @CNT = COUNT(*) 
				FROM #TblCellTraySimulation_Temp WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE =  @p_plan_type
				AND FROM_SITE = @COLUMN_FROM_SITE
				AND TO_SITE = @p_to_site
				AND MEASURE_TYPE = 'BOH_STOCK_OSP'
				AND WEEK = @COLUMN_WEEK

				-- 해당주차 데이터 없을 경우, 생성
				IF (@CNT = 0)
				BEGIN
						
					INSERT #TblCellTraySimulation_Temp
					SELECT TOP 1 a.DIVISION_ID
						, a.PLAN_START_YYYYMMDD 
						, a.PLAN_TYPE 
						, a.FROM_SITE
						, a.TO_SITE
						, a.FROM_SITE_DESCRIPTION 
						, a.TO_SITE_DESCRIPTION 
						, a.MEASURE_TYPE 
						, a.MEASURE_NAME 
						, a.MEASURE_NAME2
						, a.MEASURE_VALUE 
						, a.BOH_QTY 
						, a.SEQ_FLAG 
						, NULL AS QTY	--PW BOH
						, @COLUMN_WEEK 
						FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
						AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND PLAN_TYPE =  @p_plan_type
						AND FROM_SITE = @COLUMN_FROM_SITE
						AND TO_SITE = @p_to_site
						AND MEASURE_TYPE = 'BOH_STOCK_OSP'
						;

				END;

			END;

		END;

		--SELECT * FROM #TblCellTraySimulation_Temp ORDER BY TO_SITE, FROM_SITE, SEQ_FLAG, WEEK; return;

		/********************************************************************************      
		2. Ship_Available(CNTR) 생성
		********************************************************************************/  
		INSERT #TblCellTraySimulation_Temp
		SELECT a.DIVISION_ID
			, a.PLAN_START_YYYYMMDD 
			, a.PLAN_TYPE 
			, a.FROM_SITE
			, a.TO_SITE
			, a.FROM_SITE_DESCRIPTION 
			, a.TO_SITE_DESCRIPTION 
			, 'SHIP_AVAILABLE' AS MEASURE_TYPE 
			, 'Ship_Available(CNTR)' AS MEASURE_NAME 
			, 'Ship_Available(CNTR)' AS MEASURE_NAME2 
			, 'Ship_Available(CNTR)' AS MEASURE_VALUE 
			, 0 AS BOH_QTY 
			, '130' AS SEQ_FLAG 
			, 0 AS QTY
			, a.WEEK 
		FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
		WHERE 1=1 
		AND a.MEASURE_TYPE = 'USAGE'


		/********************************************************************************      
		3. Ship_Expected(Box) 생성
		********************************************************************************/  
		INSERT #TblCellTraySimulation_Temp
		SELECT a.DIVISION_ID
			, a.PLAN_START_YYYYMMDD 
			, a.PLAN_TYPE 
			, a.FROM_SITE
			, a.TO_SITE
			, a.FROM_SITE_DESCRIPTION 
			, a.TO_SITE_DESCRIPTION 
			, 'SHIP_EXPECTED' AS MEASURE_TYPE 
			, 'Ship_Expected(Box)' AS MEASURE_NAME 
			, 'Ship_Expected(Box)' AS MEASURE_NAME2 
			, 'Ship_Expected(Box)' AS MEASURE_VALUE 
			, 0 AS BOH_QTY 
			, '140' AS SEQ_FLAG 
			, 0 AS QTY
			, a.WEEK 
		FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
		WHERE 1=1 
		AND a.MEASURE_TYPE = 'SHIP_AVAILABLE'


		/********************************************************************************      
		4. STOCK - Packer, WH, Intransit, SUM 생성
		********************************************************************************/  
		--4.1 PW (전 주차 생성)
		INSERT #TblCellTraySimulation_Temp
		SELECT a.DIVISION_ID
			, a.PLAN_START_YYYYMMDD 
			, a.PLAN_TYPE 
			, a.FROM_SITE
			, a.TO_SITE
			, a.FROM_SITE_DESCRIPTION 
			, a.TO_SITE_DESCRIPTION 
			, 'STOCK_Packer' AS MEASURE_TYPE 
			, 'Stock' AS MEASURE_NAME 
			, 'Empty' AS MEASURE_NAME2
			, 'Packer' AS MEASURE_VALUE 
			, ISNULL(b.ATTRIBUTE1, 0) AS BOH_QTY 
			, '220' AS SEQ_FLAG 
			, NULL AS QTY	--Packer
			, a.WEEK 
		FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL b ON b.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' AND b.segment1 = a.FROM_SITE AND b.segment2 = a.TO_SITE
		WHERE 1=1 
		AND a.MEASURE_TYPE = 'USAGE'

		--4.2 BNP  
		INSERT #TblCellTraySimulation_Temp
		SELECT a.DIVISION_ID
			, a.PLAN_START_YYYYMMDD 
			, a.PLAN_TYPE 
			, a.FROM_SITE
			, a.TO_SITE
			, a.FROM_SITE_DESCRIPTION 
			, a.TO_SITE_DESCRIPTION 
			, 'STOCK_WH' AS MEASURE_TYPE 
			, 'Stock' AS MEASURE_NAME 
			, 'Empty' AS MEASURE_NAME2
			, 'WH' AS MEASURE_VALUE 
			, ISNULL(b.ATTRIBUTE2, 0) AS BOH_QTY 
			, '230' AS SEQ_FLAG 
			, NULL AS QTY	--WH
			, a.WEEK 
		FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL b ON b.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' AND b.segment1 = a.FROM_SITE AND b.segment2 = a.TO_SITE
		WHERE 1=1 
		AND a.MEASURE_TYPE = 'BOH_STOCK_OSP'

		--4.3 SHIP  
		INSERT #TblCellTraySimulation_Temp
		SELECT a.DIVISION_ID
			, a.PLAN_START_YYYYMMDD 
			, a.PLAN_TYPE 
			, a.FROM_SITE
			, a.TO_SITE
			, a.FROM_SITE_DESCRIPTION 
			, a.TO_SITE_DESCRIPTION 
			, 'STOCK_Intransit' AS MEASURE_TYPE 
			, 'Stock' AS MEASURE_NAME 
			, 'Empty' AS MEASURE_NAME2
			, 'Intransit' AS MEASURE_VALUE 
			, ISNULL(b.ATTRIBUTE3, 0) AS BOH_QTY 
			, '240' AS SEQ_FLAG 
			, NULL AS QTY	--Intransit
			, a.WEEK 
		FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL b ON b.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' AND b.segment1 = a.FROM_SITE AND b.segment2 = a.TO_SITE
		WHERE 1=1 
		AND a.MEASURE_TYPE = 'BOH_STOCK_OSP'

		--4.4 SUM  
		INSERT #TblCellTraySimulation_Temp
		SELECT a.DIVISION_ID
			, a.PLAN_START_YYYYMMDD 
			, a.PLAN_TYPE 
			, a.FROM_SITE
			, a.TO_SITE
			, a.FROM_SITE_DESCRIPTION 
			, a.TO_SITE_DESCRIPTION 
			, 'STOCK_SUM' AS MEASURE_TYPE 
			, 'Stock' AS MEASURE_NAME 
			, 'Empty' AS MEASURE_NAME2
			, 'SUM' AS MEASURE_VALUE 
			, CONVERT (BIGINT, ISNULL(b.ATTRIBUTE1, 0)) + CONVERT (BIGINT, ISNULL(b.ATTRIBUTE2, 0)) + CONVERT (BIGINT, ISNULL(b.ATTRIBUTE3, 0)) AS BOH_QTY 
			, '250' AS SEQ_FLAG 
			, NULL AS QTY	--SUM BOH
			, a.WEEK 
		FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL b ON b.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' AND b.segment1 = a.FROM_SITE AND b.segment2 = a.TO_SITE
		WHERE 1=1 
		AND a.MEASURE_TYPE = 'BOH_STOCK_OSP'

		--SELECT * FROM #TblCellTraySimulation_Temp ORDER BY TO_SITE, FROM_SITE, SEQ_FLAG, WEEK; return;

		
		/********************************************************************************      
		5. SHIP_AVAILABLE QTY, STOCK_PW(Packer) QTY, Ship_Expected(Box) QTY, SUM 재계산
		********************************************************************************/ 
		-- LOOP 길이를 판단
		SET @from_site_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@COLUMNS_FROM_SITE, @v_delimiter);
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@COLUMNS, @v_delimiter);

		DECLARE @PRE_WEEK NVARCHAR(10)
		DECLARE @PLT_QTY int
		SET @PRE_WEEK = '';
		SET @PLT_QTY = 0;

		SET @mst_loop_cnt = 0;
		SET @from_site_mst_loop_cnt = 0;

		-- FROM_SITE 별로 데이터 갱신
		WHILE LEN(@COLUMNS_FROM_SITE) >  0 AND @from_site_mst_loop_cnt < @from_site_max_loop_cnt
		BEGIN

			SET @from_site_mst_loop_cnt = @from_site_mst_loop_cnt + 1;
			SET @COLUMN_FROM_SITE = [dbo].[SCM_ARR_SPL_VAL](@COLUMNS_FROM_SITE, @v_delimiter , @from_site_mst_loop_cnt) ;
			SET @mst_loop_cnt = 0;	--주차 초기화

			IF (@COLUMN_FROM_SITE = '') CONTINUE;

			-- 주차별 데이터 갱신
			WHILE LEN(@COLUMNS) > 0 AND @mst_loop_cnt < @max_loop_cnt
			BEGIN

				SET @mst_loop_cnt = @mst_loop_cnt + 1;

				SET @COLUMN_WEEK = [dbo].[SCM_ARR_SPL_VAL](@COLUMNS, @v_delimiter , @mst_loop_cnt) ;

				IF @mst_loop_cnt = 1	-- 첫번째 주차는 PW BOH 참조
				BEGIN
				
					--SHIP_AVAILABLE 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = (b.Packer + b.USAGE_QTY) / 72
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(y.ATTRIBUTE1, 0) AS Packer, ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL y ON y.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' AND y.segment1 = x.FROM_SITE AND y.segment2 = x.TO_SITE
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) b
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'SHIP_AVAILABLE'
					AND a.WEEK = @COLUMN_WEEK

					--STOCK_PW(Packer) QTY 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = (b.Packer + b.USAGE_QTY) - (c.SHIP_AVAILABLE_QTY * 72)
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(y.ATTRIBUTE1, 0) AS Packer, ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL y ON y.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' AND y.segment1 = x.FROM_SITE AND y.segment2 = x.TO_SITE
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) b
					, (SELECT ISNULL(x.QTY, 0) AS SHIP_AVAILABLE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
							AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'SHIP_AVAILABLE'
							AND x.WEEK = @COLUMN_WEEK) c
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'STOCK_Packer'
					AND a.WEEK = @COLUMN_WEEK

					--BOH_STOCK_OSP Pakcer 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = a.BOH_QTY + c.SEMI_WH_IN_QTY - b.USAGE_QTY
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(x.QTY, 0) AS SEMI_WH_IN_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'SEMI_WH_IN'
							AND x.WEEK = @COLUMN_WEEK) c	--첫 주차의 SEMI_WH_IN
					, (SELECT ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) b
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'BOH_STOCK_OSP'
					AND a.WEEK = @COLUMN_WEEK

					--SUM QTY 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = (a.BOH_QTY + b.USAGE_QTY) - (c.SHIP_AVAILABLE_QTY * 72)
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL y ON y.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' AND y.segment1 = x.FROM_SITE AND y.segment2 = x.TO_SITE
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) b
					, (SELECT ISNULL(x.QTY, 0) AS SHIP_AVAILABLE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
							AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'SHIP_AVAILABLE'
							AND x.WEEK = @COLUMN_WEEK) c
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'STOCK_SUM'
					AND a.WEEK = @COLUMN_WEEK
					;

				END
				ELSE
				BEGIN

					-- SHIP_AVAILABLE 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = (b.PRE_PW + c.USAGE_QTY) / 72
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(x.QTY, 0) AS PRE_PW
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'STOCK_Packer'
							AND x.WEEK = @PRE_WEEK) b	--이전 주차의 STOCK_PW
					, (SELECT ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) c	--이번 주차의 USAGE
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'SHIP_AVAILABLE'
					AND a.WEEK = @COLUMN_WEEK
					;


					-- BOH_PW QTY 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = (b.PRE_PW + c.USAGE_QTY) - (d.CONTAINER_QTY * 72)
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(x.QTY, 0) AS PRE_PW
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'STOCK_Packer'
							AND x.WEEK = @PRE_WEEK) b	--이전 주차의 STOCK_PW
					, (SELECT ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) c	--이번 주차의 USAGE_QTY
					, (SELECT ISNULL(x.QTY, 0) AS CONTAINER_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'SHIP_AVAILABLE'
							AND x.WEEK = @COLUMN_WEEK) d	--이번 주차의 SHIP_AVAILABLE_QTY
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'STOCK_Packer'
					AND a.WEEK = @COLUMN_WEEK

					-- Ship_Expected(Box) 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = b.PRE_CONTAINER_QTY * 72
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(x.QTY, 0) AS PRE_CONTAINER_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'SHIP_AVAILABLE'
							AND x.WEEK = @PRE_WEEK) b	--이전 주차의 SHIP_AVAILABLE_QTY
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'SHIP_EXPECTED'
					AND a.WEEK = @COLUMN_WEEK
					;

					--BOH_STOCK_OSP 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = b.PRE_Packer + c.SEMI_WH_IN_QTY - d.USAGE_QTY 
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(x.QTY, 0) AS PRE_Packer
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'BOH_STOCK_OSP'
							AND x.WEEK = @PRE_WEEK) b	--이전 주차의 BOH_STOCK_OSP Packer
					, (SELECT ISNULL(x.QTY, 0) AS SEMI_WH_IN_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'SEMI_WH_IN'
							AND x.WEEK = @COLUMN_WEEK) c	--이번 주차의 SEMI_WH_IN
					, (SELECT ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) d	--이번 주차의 USAGE
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'BOH_STOCK_OSP'
					AND a.WEEK = @COLUMN_WEEK
					;

					--SUM QTY 변경
					UPDATE #TblCellTraySimulation_Temp
					SET #TblCellTraySimulation_Temp.QTY = (b.PRE_SUM + c.USAGE_QTY) - (d.SHIP_AVAILABLE_QTY * 72)
					FROM #TblCellTraySimulation_Temp a WITH(NOLOCK)
					, (SELECT ISNULL(x.QTY, 0) AS PRE_SUM
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'STOCK_SUM'
							AND x.WEEK = @PRE_WEEK) b	--이전 주차의 STOCK_SUM
					, (SELECT ISNULL(x.QTY, 0) AS USAGE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE x.DIVISION_ID = @p_division_id
							AND x.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND x.PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'USAGE'
							AND x.WEEK = @COLUMN_WEEK) c	--이번 주차의 USAGE
					, (SELECT ISNULL(x.QTY, 0) AS SHIP_AVAILABLE_QTY
						FROM #TblCellTraySimulation_Temp x WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
							AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND PLAN_TYPE =  @p_plan_type
							AND x.FROM_SITE = @COLUMN_FROM_SITE
							AND x.TO_SITE = @p_to_site
							AND x.MEASURE_TYPE = 'SHIP_AVAILABLE'
							AND x.WEEK = @COLUMN_WEEK) d
					WHERE a.DIVISION_ID = @p_division_id
					AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND a.PLAN_TYPE =  @p_plan_type
					AND a.FROM_SITE = @COLUMN_FROM_SITE
					AND a.TO_SITE = @p_to_site
					AND a.MEASURE_TYPE = 'STOCK_SUM'
					AND a.WEEK = @COLUMN_WEEK
					;

				END

				--이전 주차 설정
				SET @PRE_WEEK = @COLUMN_WEEK;

			END;--@COLUMNS

		END;--@COLUMNS_FROM_SITE

		


		SET @COLUMNS = LEFT(@COLUMNS, LEN(@COLUMNS) - 1)

		
		SET @SQL = @SQL + 'SELECT * '+CHAR(10);
		SET @SQL = @SQL + '  FROM #TblCellTraySimulation_Temp AS result WITH(NOLOCK) '+CHAR(10);
		--SET @SQL = @SQL + '  FROM ( '+CHAR(10);
		--SET @SQL = @SQL + '			SELECT * '+CHAR(10);
		--SET @SQL = @SQL + '			  FROM #TblCellTraySimulation_Temp a WITH(NOLOCK) '+CHAR(10);
		--SET @SQL = @SQL + '		  ) AS result '+CHAR(10);
		SET @SQL = @SQL + '	PIVOT ( '+CHAR(10);
		SET @SQL = @SQL + '		    MAX(QTY) '+CHAR(10);
		SET @SQL = @SQL + '		    FOR WEEK IN (' + @COLUMNS + ') '+CHAR(10);
		SET @SQL = @SQL + '		  ) AS PIVOT_RESULT '+CHAR(10);
		SET @SQL = @SQL + '	ORDER BY TO_SITE, FROM_SITE, SEQ_FLAG    '+CHAR(10);

		--PRINT(@SQL);
		EXEC(@SQL);



		--임시테이블 삭제      
		IF OBJECT_ID('tempdb.dbo.#TblCellTraySimulation_Temp') is not null       
			DROP TABLE #TblCellTraySimulation_Temp   

	END
	BEGIN

		-- 조회데이터가 없을 경우
		SELECT *
		  FROM SCP_ANL_CELL_Tray_Simulation_Weekly WITH(NOLOCK)
		 WHERE 1=1
				AND DIVISION_ID			= @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE			= @p_plan_type
				AND LEFT( WEEK, 6) BETWEEN LEFT(@p_from_yyyymmdd, 6) AND LEFT(@p_to_yyyymmdd, 6)
				AND TO_SITE != @p_to_site

	END

END
