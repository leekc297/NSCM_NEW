

/*
 * Program ID   : PR_SCP_XLS_EXCEL_BODY_QUERY
 * Description  : SCP SIMULATION EXCEL SHEET BODY QUERY
 * OutTable     :
 * Execute      : 
                 

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.03.11   KSK         BODY Query에서 분리 생성
 */

CREATE PROCEDURE [dbo].[PR_SCP_XLS_EXCEL_BODY_XLSPSI21]
(
  @p_item_list    VARCHAR(MAX)  ='',   
  @p_query_type    VARCHAR(MAX)  ='',  
  @p_planner_id    VARCHAR(MAX)  =''  
 )
AS
BEGIN
 
	declare  @p_division_id   VARCHAR(10) = '40'
	

	DECLARE @p_plan_start_yyyymmdd  NVARCHAR(0008) = NULL;
	DECLARE @p_plan_type            NVARCHAR(4000) = 'MA';
	DECLARE @p_seq                  NVARCHAR(0008) = NULL;
	
	DECLARE @eng_plan_id			NVARCHAR(0015) = NULL;

	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(0008);
	DECLARE @v_plan_end_yyyymmdd    NVARCHAR(0008);
	DECLARE @v_plan_end_yyyymmdd_2    NVARCHAR(0008);
	
	DECLARE @v_seq                  NVARCHAR(0008)
	DECLARE @v_cols                 NVARCHAR(MAX);
	DECLARE @v_cols2                NVARCHAR(MAX);
	DECLARE @v_cols3                NVARCHAR(MAX);
	DECLARE @SQL                    NVARCHAR(MAX);

	DECLARE @v_frozen_end_yyyymmdd  NVARCHAR(0008);
	DECLARE @v_frozen_days          integer = 21;
	DECLARE @v_wcols                NVARCHAR(MAX);
	DECLARE @v_wcols2               NVARCHAR(MAX);
	DECLARE @v_wcols3               NVARCHAR(MAX);

	DECLARE @v_frozen_area_last_yyyymmdd NVARCHAR(0008) = '';
	--  * 2021.03.23   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가 - END

	-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - start
	DECLARE @p_create_to_yyyymmdd_1 NVARCHAR(0008);
	DECLARE @p_create_to_yyyymmdd_2 NVARCHAR(0008);

	--  Plan End Date
	DECLARE @v_pet_date		NVARCHAR(12) = '';
	DECLARE @v_bp_flag		NVARCHAR(8) = '';
	DECLARE @v_bp_days		INT = 0;
	DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';

	SELECT @v_pet_date = p.horizon_end_date,
		   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
		   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.division_id = @p_division_id
	AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
	;

	SET @p_plan_start_yyyymmdd  = NULL;  --'20210510';

	SET @p_plan_type            = 'MA';
	SET @p_seq                  = NULL;  --'3';
	SET @eng_plan_id            = NULL; 

	SET @v_plan_start_yyyymmdd  = NULL;
	SET @v_plan_end_yyyymmdd    = NULL;
	SET @v_seq                  = NULL;
	SET @v_cols                 = NULL;
	SET @v_cols2                = NULL;
	SET @SQL                    = NULL;

	SET @v_plan_start_yyyymmdd = '';
	SET @v_seq = '';
	SET @v_cols = '';
	SET @v_cols2 = '';

	-- 파라미터 확인 
	SELECT    @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			, @v_seq = SUBSTRING(MAX(ENG_PLAN_ID), CHARINDEX('MA::', MAX(ENG_PLAN_ID)) + 4, 1)
			, @eng_plan_id = MAX(ENG_PLAN_ID)
		FROM DBO.SCP_PLAN_PARAMETER_V WITH (NOLOCK)
		WHERE MASTER_ID = '40::WEEKLY'
		AND ENG_PLAN_ID LIKE '%MA%'
	;

	IF @p_plan_start_yyyymmdd IS NULL
		SET @p_plan_start_yyyymmdd = @v_plan_start_yyyymmdd ;

	IF @p_seq IS NULL
		SET @p_seq = @v_seq ;


	IF @p_query_type = ''		-- SHIP REQ Sheet
		BEGIN

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 364 -> 364+182
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

		-----------------
		-- Frozen 구간
		-----------------
		-- 2020.02.03 :: 소형 SHIPMENT PLAN 입력 SIMULATION 추가 - ship frozen 구간을 week plan 으로 변경 
		-- Frozen 구간을 위한 변수추가
		SET @v_frozen_end_yyyymmdd  = '';
		SET @v_frozen_days          = 7;
		SET @v_wcols                = '';
		SET @v_wcols2               = '';

--		20231006 강현준. SHIP FROZEN 구간을 LOOKUP 테이블에 없으면 MST_SITE 기준으로 정의함.
		DECLARE @scp_simulator_ship_fixed_term_flag                  NVARCHAR(0001) = 'N';

		SELECT @scp_simulator_ship_fixed_term_flag = MAX(VALID_YN) 
		FROM [DBO].[SCM_ADM_LOOKUP_MASTER] WITH (NOLOCK) 
		WHERE LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM';
		
		IF ( @scp_simulator_ship_fixed_term_flag = 'Y') 
		BEGIN
			SELECT @v_frozen_days = ISNULL(MAX(CONVERT(INT, ISNULL(B.SEGMENT3, A.SHIP_FROZEN))), @v_frozen_days)
			  FROM  [DBO].[SCM_MST_SITE] A WITH (NOLOCK)
					LEFT OUTER JOIN
					[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
					ON B.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM' AND A.DIVISION_ID = B.SEGMENT1 AND A.SCM_SITE_ID = B.SEGMENT2 AND B.VALID_YN = 'Y'
			 WHERE A.DIVISION_ID = @p_division_id
			   AND A.SCM_SITE_ID IN (SELECT DISTINCT FROM_SITE
									FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] B WITH(NOLOCK)
								   WHERE DIVISION_ID = @p_division_id
									 AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									 AND PLAN_TYPE = @p_plan_type
									 AND SEQ = @p_seq
									 AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
									 AND BIZ_TYPE = 'A'
									 AND MEASURE = 'SHIP_PLAN_AMEND')
			   AND A.OPERATION_GROUP = 'A'
			   AND A.SITE_TYPE = 'PLANT'
			   AND A.VALID_YN = 'Y'
			   AND A.OSP_YN = 'N'
			;

		END

		IF ( @scp_simulator_ship_fixed_term_flag = 'N') 		
		BEGIN
			SELECT @v_frozen_days = ISNULL(MAX(CONVERT(INT, A.SHIP_FROZEN)), @v_frozen_days)
			FROM  [DBO].[SCM_MST_SITE] A WITH (NOLOCK)
			WHERE A.DIVISION_ID = @p_division_id
			AND A.SCM_SITE_ID IN (	SELECT DISTINCT FROM_SITE
									FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] B WITH(NOLOCK)
									WHERE DIVISION_ID = @p_division_id
										AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
										AND PLAN_TYPE = @p_plan_type
										AND SEQ = @p_seq
										AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
										AND BIZ_TYPE = 'A'
										AND MEASURE = 'SHIP_PLAN_AMEND')
			AND A.OPERATION_GROUP = 'A'
			AND A.SITE_TYPE = 'PLANT'
			AND A.VALID_YN = 'Y'
			AND A.OSP_YN = 'N'
			;
		END

		

		SELECT @v_frozen_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,@v_frozen_days-1,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
		;

		SET @v_frozen_area_last_yyyymmdd = @v_frozen_end_yyyymmdd;
		--SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_frozen_end_yyyymmdd, 6) + '01'),112)),112);
		--SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)),112);


		SET @v_wcols = '';
		SET @v_wcols2 = '';
		SELECT @v_wcols = @v_wcols + '[' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],', @v_wcols2 = @v_wcols2 + 'ISNULL([' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],0) AS [' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],'
		  FROM (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM
				FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
								,C.BASIS_YYYYMMDD AS E_YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
							AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
						) S1,
						(SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
							,C.BASIS_YYYYMMDD AS S_YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
							AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2
						) S2
				WHERE S1.R_NUM = S2.R_NUM
				--UNION ALL
				--SELECT CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_frozen_end_yyyymmdd ),112)),112) AS S_YYYYMMDD
				--	,@v_frozen_area_last_yyyymmdd  AS E_YYYYMMDD, 99 AS R_NUM
    --             WHERE CONVERT(DATETIME,(@v_frozen_end_yyyymmdd),112) < CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)
			   ) AS A
		 ORDER BY A.E_YYYYMMDD
		 ;

		--SET @v_wcols = SUBSTRING(@v_wcols, 1, LEN(@v_wcols) - 1);
		--SET @v_wcols2 = SUBSTRING(@v_wcols2, 1, LEN(@v_wcols2) - 1);

		-- 2021.03.08   KSW           소형 SHIPMENT PLAN 입력 SIMULATION - 일부 모델에서 MKT FCST Measure 가 조회되지 않는 오류수정
		-- 전체쿼리 수정
		declare @v_plan_end_yyyymmdd22	nvarchar(20) = '';
		SELECT @v_plan_end_yyyymmdd22 = CONVERT(VARCHAR,DATEADD(D,49,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 364 -> 364+182
		SELECT @v_plan_end_yyyymmdd22 = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd22, 6) + '01'),112)),112)),112)),112) ;

		-----------------
		-- Week Plan 기간
		-----------------
		DECLARE @v_weekplan_days integer = 7 * 8;
		DECLARE @v_weekplan_start_yyyymmdd	NVARCHAR(0008) = '';
		DECLARE @v_weekplan_end_yyyymmdd	NVARCHAR(0008) = '';

		SELECT @v_weekplan_start_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)),112) 
		SELECT @v_weekplan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,@v_weekplan_days-1,CONVERT(DATETIME,(@v_weekplan_start_yyyymmdd),112)),112)
		-- Week End 일자를 월 말일로 조정한다.
		DECLARE @v_weekplan_last_yyyymmdd	NVARCHAR(0008) = '';

		-- 다음일자가 1일 아니면
		IF (CONVERT(INTEGER, RIGHT(CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_weekplan_end_yyyymmdd),112)),112), 2)) <> 1)
		BEGIN
			SELECT @v_weekplan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(LEFT(@v_weekplan_end_yyyymmdd, 6) + '01'),112)),112)
		END

		SET @v_weekplan_last_yyyymmdd = @v_weekplan_end_yyyymmdd
		--SELECT @v_weekplan_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_weekplan_end_yyyymmdd, 6) + '01'),112)),112);
		--SELECT @v_weekplan_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_weekplan_last_yyyymmdd),112)),112);

		DECLARE @v_wpcols				NVARCHAR(MAX) = '';
		DECLARE @v_wpcols2				NVARCHAR(MAX) = '';

		SELECT @v_wpcols = @v_wpcols + '[' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],', @v_wpcols2 = @v_wpcols2 + 'ISNULL([' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],0) AS [' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],'
		  FROM (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM
				FROM (SELECT  ROW_NUMBER() OVER(ORDER BY MAX(C.BASIS_YYYYMMDD) ASC) AS R_NUM
								,MAX(C.BASIS_YYYYMMDD) AS E_YYYYMMDD
								,C.PARTIAL_WEEK_NAME
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @v_weekplan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <= @v_weekplan_last_yyyymmdd
						GROUP BY C.PARTIAL_WEEK_NAME
						) S1,
						(SELECT ROW_NUMBER() OVER(ORDER BY MIN(C.BASIS_YYYYMMDD) ASC) AS R_NUM
							,MIN(C.BASIS_YYYYMMDD) AS S_YYYYMMDD
							,C.PARTIAL_WEEK_NAME
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @v_weekplan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <= @v_weekplan_last_yyyymmdd
						GROUP BY C.PARTIAL_WEEK_NAME
						) S2
				WHERE S1.R_NUM = S2.R_NUM
				--UNION ALL
				--SELECT CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_weekplan_end_yyyymmdd ),112)),112) AS S_YYYYMMDD
				--	,@v_weekplan_last_yyyymmdd  AS E_YYYYMMDD, 99 AS R_NUM
    --             WHERE CONVERT(DATETIME,(@v_weekplan_end_yyyymmdd),112) < CONVERT(DATETIME,(@v_weekplan_last_yyyymmdd),112)
			   ) AS A
		 ORDER BY A.E_YYYYMMDD
		 ;

		 if ( len(@v_wpcols) > 0  )  SET @v_wpcols = SUBSTRING(@v_wpcols, 1, LEN(@v_wpcols) - 1);

		 if ( len(@v_wpcols2) > 0  ) SET @v_wpcols2 = SUBSTRING(@v_wpcols2, 1, LEN(@v_wpcols2) - 1);

		SET @v_wcols = @v_wcols + @v_wpcols;
		SET @v_wcols2 = @v_wcols2 + @v_wpcols2;

		-----------------
		-- Month 단위 Plan 기간
		-----------------
		DECLARE @v_month_plan_start_yyyymmdd NVARCHAR(8) = CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_weekplan_last_yyyymmdd),112)),112);

		SELECT @v_cols = @v_cols + '[' + YYYYMM + '],', @v_cols2 = @v_cols2 + 'ISNULL([' + YYYYMM + '],0) AS [' + YYYYMM + '],'
		  FROM (
				 SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 6) AS YYYYMM
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
						AND C.BASIS_YYYYMMDD > @v_weekplan_last_yyyymmdd
					AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,366+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 366 -> 366+182
			   ) AS days
		 ORDER BY YYYYMM
		 ;

		 if ( len(@v_cols) > 0) SET @v_cols = LEFT(@v_cols, LEN(@v_cols) - 1);
		 if ( len(@v_cols2) > 0)  SET @v_cols2 = LEFT(@v_cols2, LEN(@v_cols2) - 1);


        IF OBJECT_ID('tempdb..#tmp_SCM_MST_SSO_DEPT_USER_INFO') IS NOT NULL
			DROP TABLE #tmp_SCM_MST_SSO_DEPT_USER_INFO
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIP_DEPT') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIP_DEPT
		;
		
		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_PLN_STOCK_PLAN') IS NOT NULL
			DROP TABLE #tmp_PLN_STOCK_PLAN
		;
		
		  SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_ID + '|' + C.DEPT_NAME_EN AS DEPT_NAME_EN			-- DEPT_NAME_EN 식별문제로 DEPT_ID 를 붙여서 식별하는 것으로 변경 :: 2022.12.22
		  INTO #tmp_SCM_MST_SSO_DEPT_USER_INFO
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
				ON B.DEPT_ID = C.DEPT_ID
				AND B.ACTIVE_FLAG <> 'D'
			AND C.VALID_YN = 'Y'
			AND LEN(C.DEPT_ID) = 8
			AND USER_ID IN (SELECT OWNER FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VALID_YN = 'Y' AND PROJECT_CODE <> '-')
			;

		  SELECT      AA.DIVISION_ID
					, AA.PLAN_START_YYYYMMDD
					, AA.PLAN_TYPE
					, AA.SEQ
    				, AA.ITEM_ID
					, CC.DEPT_ID
					, CC.DEPT_NAME_EN
					, CC.DEPT_NAME_KO
					, AA.MEASURE
					, AA.FROM_SITE
					--, 10	AS DEPT_ORD
					, (CASE WHEN AA.MEASURE = 'MKT_FCST'  THEN 100
							WHEN AA.MEASURE = 'SHIP_REQ_TOTAL'  THEN 200			-- 추가
							WHEN AA.MEASURE = 'SHIP_REQ'  THEN 300					-- 변경
							WHEN AA.MEASURE = 'SHIP_PLAN' THEN 400					-- 변경
							WHEN AA.MEASURE = 'SHIP_PLAN_AMEND' THEN 500 END) AS XLS_ORD  -- 변경
					, AA.YYYYMMDD
					, AA.QTY
					--, 1 AS MST_SEQ
			   INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG 
			   FROM (
						SELECT    DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, BIZ_TYPE, PROJECT_CODE, ITEM_ID, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID
								, MEASURE, YYYYMMDD, QTY
						FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
						AND   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND   PLAN_TYPE = @p_plan_type
						AND   SEQ = @p_seq
						AND   BIZ_TYPE = 'A'
						AND   ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
						AND   MEASURE IN ('MKT_FCST','SHIP_REQ','SHIP_PLAN','SHIP_PLAN_AMEND') 
						UNION ALL
						SELECT    A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.BIZ_TYPE, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS, '-' AS FROM_SITE, '-' AS BOD_ID
								, 'SHIP_REQ_TOTAL' AS MEASURE, A.YYYYMMDD, SUM(ISNULL(A.QTY,0)) AS SUM_SHIP_REQ_TOTAL
						FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] A WITH(NOLOCK)
						--LEFT OUTER JOIN (
						--					SELECT DISTINCT PLANT_SITE_ID, ITEM_ID, PRIORITY
						--					FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) 
						--					WHERE DIVISION_ID = @p_division_id
						--					AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd 
						--					AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
						--					AND   VALID_YN = 'Y'
						--) B
						--ON A.FROM_SITE = B.PLANT_SITE_ID AND A.ITEM_ID = B.ITEM_ID
						WHERE A.DIVISION_ID = @p_division_id
						AND   A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND   A.PLAN_TYPE = @p_plan_type
						AND   A.SEQ = @p_seq
						AND   A.BIZ_TYPE = 'A'
						AND   A.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
						AND   A.MEASURE IN ('SHIP_REQ') 
						GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.BIZ_TYPE, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS
								,A.MEASURE, A.YYYYMMDD
					) AA
			   LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)
				 ON AA.DIVISION_ID = BB.DIVISION_ID
				AND AA.PROJECT_CODE = BB.PROJECT_CODE
				AND AA.TO_SITE = BB.SCM_SITE_ID
				AND AA.ITEM_ID = BB.ITEM_ID
			   LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH(NOLOCK)
				 ON BB.OWNER = CC.USER_ID
			  WHERE 1 = 1
				AND BB.DIVISION_ID = @p_division_id
				AND BB.VALID_YN = 'Y'
				AND BB.PROJECT_CODE <> '-'
				AND AA.DIVISION_ID = BB.DIVISION_ID
				AND AA.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND AA.PLAN_TYPE = @p_plan_type
				AND AA.SEQ       = @p_seq
				AND AA.MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL', 'SHIP_REQ', 'SHIP_PLAN','SHIP_PLAN_AMEND') 
				AND AA.QTY <> 0 
				AND AA.BIZ_TYPE = 'A'
				AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
				;


		/* #tmp_SCP_ANL_SHIPMENT_PLAN_FG상 MKT_FCST, SHIP_REQ 이것이 없는 조직에 대해서는 삭제하여 조회 되도록 함. 강현준 20231110*/ 
		DELETE FROM #tmp_SCM_MST_SSO_DEPT_USER_INFO 
		WHERE DEPT_ID IN (
							SELECT DISTINCT DEPT_ID
							FROM #tmp_SCM_MST_SSO_DEPT_USER_INFO A WITH(NOLOCK)
							WHERE NOT EXISTS (
												SELECT DISTINCT DEPT_ID
												FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG  B WITH(NOLOCK)
												WHERE MEASURE IN ('MKT_FCST','SHIP_REQ')
												AND   A.DEPT_ID = B.DEPT_ID
											)
		) ;

		/* ITEM_ID별 DEPT_ID 정의. 강현준 20231110*/ 
		SELECT DISTINCT A.ITEM_ID, B.DEPT_ID 
		INTO #tmp_SCP_ANL_SHIP_DEPT
		FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
		   , #tmp_SCM_MST_SSO_DEPT_USER_INFO B WITH(NOLOCK)
		WHERE A.MEASURE IN ('MKT_FCST','SHIP_REQ')
		AND   A.DEPT_ID = B.DEPT_ID


		-- 20231005. 강현준 (개발서버에서 iN을 활용한 ITEM 처리시 속도 저하 ==> item을 미리 변수화하여 처리)
		DECLARE @v_items                 NVARCHAR(MAX);
		SET @v_items  = '';
		SELECT @v_items = @v_items  + '''' + A.ITEM_ID_ASSY + ''','
		FROM (
				SELECT DISTINCT value AS ITEM_ID_ASSY FROM dbo.FN_SplitString(@p_item_list,',')
				UNION ALL
				select DISTINCT ITEM_ID_ASSY 
				from SCP_MST_CELL_PROD_ASSY_MAP with(nolock)
				where item_id_prod IN ( SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
		)A;


		SET @v_items = SUBSTRING(@v_items, 1, LEN(@v_items)-1);		-- ==> @v_items는 아래 쿼리에서 적용


		SELECT AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
			 , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM, ROUND(AA.QTY, 0) AS QTY, 1 AS MST_SEQ              
		INTO #tmp_MONTH_SHIPMENT_PLAN_FG_1
		FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)                
		WHERE AA.MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL','SHIP_REQ','SHIP_PLAN','SHIP_PLAN_AMEND')
		AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_plan_end_yyyymmdd
		UNION ALL
		SELECT  N1.DIVISION_ID, N1.PLAN_START_YYYYMMDD, N1.PLAN_TYPE,N1. SEQ,N1.ITEM_ID, N1.DEPT_ID, N1.DEPT_NAME_EN, N1.DEPT_NAME_KO
				,(CASE WHEN MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_PLAN_AMEND_TOTAL') THEN '-'
					   WHEN MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
				   ELSE '-'
				  END )    AS  FROM_SITE
				,N2.MEASURE, 10 AS DEPT_ORD, N2.XLS_ORD, SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM, 0 AS QTY, 1 AS MST_SEQ
		FROM (
				SELECT DISTINCT BB.DIVISION_ID
							  , @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
							  , @p_plan_type AS PLAN_TYPE
							  , @p_seq AS SEQ
							  , BB.ITEM_ID
							  , CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
				FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
				LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
				ON BB.OWNER = CC.USER_ID
				INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH (NOLOCK)
				ON BB.ITEM_ID = DD.ITEM_ID
				AND CC.DEPT_ID = DD.DEPT_ID
				INNER JOIN (
							SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
							FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
							WHERE DIVISION_ID = @p_division_id 
							AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
							AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd 
							AND   VALID_YN = 'Y' 
							) EE
				ON BB.ITEM_ID = EE.ITEM_ID
				WHERE BB.DIVISION_ID = @p_division_id
				AND BB.VALID_YN = 'Y'
				AND BB.PROJECT_CODE <> '-'
				AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
			) N1,
			(
				SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
			) N2,
			(
				SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
				AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
				AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd22
				AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
			) N3
		UNION ALL
		SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE
			   , G1.MEASURE, G2.DEPT_ORD, G1.XLS_ORD, G2.YYYYMM, (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY ELSE G2.CNT END) AS QTY
			   , 1 AS MST_SEQ
		FROM (
				SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD
			 ) G1
			,(
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
						, 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, AA.QTY, 1 AS CNT
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				LEFT OUTER JOIN (
									SELECT  SMS.SCM_SITE_ID
											, (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1 
												ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) END
											  ) AS SHIP_FROZEN
									FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
									LEFT OUTER JOIN (
														SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
														FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
														INNER JOIN
														[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
														ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														AND   A.VALID_YN = 'Y'
														AND   B.SEGMENT1 = @p_division_id
														AND   B.VALID_YN = 'Y'
													) SALM
									ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
									WHERE  1 = 1
									AND DIVISION_ID = @p_division_id
									AND OPERATION_GROUP = 'A' AND SITE_TYPE = 'PLANT' AND VALID_YN = 'Y' AND OSP_YN = 'N'
								) SF
				ON AA.FROM_SITE = SF.SCM_SITE_ID
				WHERE 1 = 1 AND AA.MEASURE IN ('SHIP_PLAN') 
				AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112) 
			 ) G2              
		UNION ALL
		SELECT DIVISION_ID ,PLAN_START_YYYYMMDD ,PLAN_TYPE ,SEQ ,ITEM_ID ,DEPT_ID ,DEPT_NAME_EN ,DEPT_NAME_KO ,FROM_SITE ,MEASURE ,DEPT_ORD ,XLS_ORD ,YYYYMM
			  ,ROUND(QTY, 0) AS QTY ,2 AS MST_SEQ 
		FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
		WHERE 1 = 1
		AND DIVISION_ID = @p_division_id 
		AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		AND PLAN_TYPE = @p_plan_type
		AND SEQ  = @p_seq
		AND MEASURE = 'SHIP_PLAN_AMEND'
		AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
		AND LAST_UPDATED_BY = @p_planner_id      



		SELECT MAX(RR.MST_SEQ) AS MST_SEQ, RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE ,RR.SEQ, RR.ITEM_ID, RR.FROM_SITE, RR.MEASURE, RR.YYYYMM              
		INTO #tmp_MONTH_SHIPMENT_PLAN_FG_2
 		FROM (
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
					  , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, ROUND(AA.QTY, 0) AS QTY, 1 AS MST_SEQ
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				WHERE AA.MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND')
				AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_plan_end_yyyymmdd
				UNION ALL
				SELECT  N1.DIVISION_ID, N1.PLAN_START_YYYYMMDD, N1.PLAN_TYPE, N1.SEQ,N1.ITEM_ID, N1.DEPT_ID, N1.DEPT_NAME_EN, N1.DEPT_NAME_KO
				     , (CASE WHEN MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_PLAN_AMEND_TOTAL') THEN '-'
					         WHEN MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
						ELSE '-'
						END )    AS  FROM_SITE
					 , N2.MEASURE, 10 AS DEPT_ORD, N2.XLS_ORD, SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM, 0 AS QTY, 1 AS MST_SEQ
				FROM (
						SELECT   DISTINCT BB.DIVISION_ID
							  , @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
							  , @p_plan_type AS PLAN_TYPE
							  , @p_seq AS SEQ
							  , BB.ITEM_ID, CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
						FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
						LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
						ON BB.OWNER = CC.USER_ID
						INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH (NOLOCK)
						ON BB.ITEM_ID = DD.ITEM_ID
						AND CC.DEPT_ID = DD.DEPT_ID
						INNER JOIN (
										SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
										FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
										WHERE DIVISION_ID = @p_division_id
										AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
										AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
										AND   VALID_YN = 'Y'
									) EE
						ON BB.ITEM_ID = EE.ITEM_ID
						WHERE BB.DIVISION_ID = @p_division_id
						AND BB.VALID_YN = 'Y'
						AND BB.PROJECT_CODE <> '-'
						AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
					) N1,
					(
						SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
					) N2,
					(
						SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @v_plan_start_yyyymmdd
						AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd22
						AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
					) N3
					UNION ALL
					SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE
						   , G1.MEASURE, G2.DEPT_ORD, G1.XLS_ORD, G2.YYYYMM, (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY ELSE G2.CNT END) AS QTY, 1 AS MST_SEQ
					FROM (
							SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD
						) G1,
						(
							SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
								  , 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, AA.QTY, 1 AS CNT
							FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
							LEFT OUTER JOIN (
												SELECT  SMS.SCM_SITE_ID
													  , (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1 
															  ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) 
														END) AS SHIP_FROZEN
												FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
												LEFT OUTER JOIN (
																	SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
																	FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
																	INNER JOIN
																	[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
																	ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
																	WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
																	AND   A.VALID_YN = 'Y'
																	AND   B.SEGMENT1 = @p_division_id
																	AND   B.VALID_YN = 'Y'
																) SALM
												ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
												WHERE  1 = 1
												AND DIVISION_ID = @p_division_id
												AND OPERATION_GROUP = 'A'
												AND SITE_TYPE = 'PLANT'
												AND VALID_YN = 'Y'
												AND OSP_YN = 'N'
											) SF
							ON AA.FROM_SITE = SF.SCM_SITE_ID
							WHERE 1 = 1
							AND AA.MEASURE IN ('SHIP_PLAN')
							AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112)
					) G2
				UNION ALL
				SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE,SEQ, ITEM_ID,DEPT_ID, DEPT_NAME_EN, DEPT_NAME_KO, FROM_SITE, MEASURE, DEPT_ORD, XLS_ORD, YYYYMM, ROUND(QTY, 0) AS QTY, 2 AS MST_SEQ
				FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
				WHERE 1 = 1
				AND DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ       = @p_seq
				AND MEASURE = 'SHIP_PLAN_AMEND'
				AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
				AND LAST_UPDATED_BY = @p_planner_id
			) RR
		GROUP BY RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE, RR.SEQ, RR.ITEM_ID, RR.FROM_SITE, RR.MEASURE, RR.YYYYMM           


		SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
			   , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM, AA.YYYYMMDD
			   , (CASE WHEN AA.MEASURE = 'SHIP_PLAN_AMEND' AND AA.YYYYMMDD BETWEEN @v_plan_start_yyyymmdd AND @v_frozen_end_yyyymmdd THEN 0
				  ELSE ROUND(AA.QTY, 0) 
				  END) AS QTY
			   , 1 AS MST_SEQ                      
		INTO #tmp_WEEK_SHIPMENT_PLAN_FG_1
		FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
		WHERE AA.MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL','SHIP_REQ','SHIP_PLAN_AMEND')
		AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
		UNION ALL
		SELECT  N1.DIVISION_ID,N1.PLAN_START_YYYYMMDD,N1.PLAN_TYPE,N1.SEQ,N1.ITEM_ID,N1.DEPT_ID,N1.DEPT_NAME_EN,N1.DEPT_NAME_KO
			  ,(CASE WHEN MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL','SHIP_PLAN_AMEND_TOTAL') THEN '-'
					 WHEN MEASURE IN ('SHIP_REQ','SHIP_PLAN','SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
				ELSE '-'
				END )    AS  FROM_SITE
			  ,N2.MEASURE,10 AS DEPT_ORD,N2.XLS_ORD,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM,N3.YYYYMMDD,0 AS QTY,1 AS MST_SEQ      
		FROM (
				SELECT   DISTINCT BB.DIVISION_ID
						, @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
						, @p_plan_type AS PLAN_TYPE
						, @p_seq AS SEQ
						, BB.ITEM_ID, CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
				FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
				LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
				ON BB.OWNER = CC.USER_ID
				INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH (NOLOCK)
				ON BB.ITEM_ID = DD.ITEM_ID
				AND CC.DEPT_ID = DD.DEPT_ID
				INNER JOIN (
							SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
							FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
							WHERE DIVISION_ID = @p_division_id
							AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
							AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
							AND   VALID_YN = 'Y'
							) EE
				ON BB.ITEM_ID = EE.ITEM_ID
				WHERE BB.DIVISION_ID = @p_division_id
				AND BB.VALID_YN = 'Y'
				AND BB.PROJECT_CODE <> '-'
				AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
			) N1,
			(
				SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
			) N2,
			(
				SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
				AND C.BASIS_YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
				AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
			) N3
		UNION ALL
		SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE, G1.MEASURE, G2.DEPT_ORD
			  , G1.XLS_ORD, G2.YYYYMM, G2.YYYYMMDD
			  , (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY
					  ELSE G2.CNT END
				) AS QTY
			  , 1 AS MST_SEQ
		FROM (
				SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD
			) G1,
			(
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
					   , 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM, AA.YYYYMMDD, AA.QTY, 1 AS CNT
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				LEFT OUTER JOIN (
									SELECT  SMS.SCM_SITE_ID
										  , (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1 
												ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) 
												END) AS SHIP_FROZEN
									FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
									LEFT OUTER JOIN (
														SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
														FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
														INNER JOIN
														[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
														ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														AND   A.VALID_YN = 'Y'
														AND   B.SEGMENT1 = @p_division_id
														AND   B.VALID_YN = 'Y'
													) SALM
									ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
									WHERE  1 = 1
									AND DIVISION_ID = @p_division_id
									AND OPERATION_GROUP = 'A'
									AND SITE_TYPE = 'PLANT'
									AND VALID_YN = 'Y'
									AND OSP_YN = 'N'
								) SF
				ON AA.FROM_SITE = SF.SCM_SITE_ID
				WHERE 1 = 1
				AND AA.MEASURE IN ('SHIP_PLAN')
				AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
			) G2
		UNION ALL
		SELECT DIVISION_ID, PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,ITEM_ID,DEPT_ID,DEPT_NAME_EN,DEPT_NAME_KO,FROM_SITE,MEASURE,DEPT_ORD,XLS_ORD,SUBSTRING(YYYYMM, 1, 6) AS YYYYMM,YYYYMM AS YYYYMMDD
		      ,ROUND(QTY, 0) AS QTY,2 AS MST_SEQ
		FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
		WHERE 1 = 1
		AND DIVISION_ID = @p_division_id
		AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		AND PLAN_TYPE = @p_plan_type
		AND SEQ       = @p_seq
		AND MEASURE = 'SHIP_PLAN_AMEND'
		AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
		AND LAST_UPDATED_BY = @p_planner_id                  



		SELECT MAX(RR.MST_SEQ) AS MST_SEQ,RR.DIVISION_ID,RR.PLAN_START_YYYYMMDD,RR.PLAN_TYPE,RR.SEQ,RR.ITEM_ID,RR.FROM_SITE,RR.MEASURE,RR.YYYYMM,RR.YYYYMMDD
		INTO #tmp_WEEK_SHIPMENT_PLAN_FG_2
		FROM (
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
					   , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, YYYYMMDD, ROUND(AA.QTY, 0) AS QTY, 1 AS MST_SEQ
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				WHERE AA.MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_REQ', 'SHIP_PLAN_AMEND')
				AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
				UNION ALL
				SELECT  N1.DIVISION_ID,N1.PLAN_START_YYYYMMDD,N1.PLAN_TYPE,N1.SEQ,N1.ITEM_ID,N1.DEPT_ID,N1.DEPT_NAME_EN,N1.DEPT_NAME_KO
					   ,(CASE WHEN MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_PLAN_AMEND_TOTAL') THEN '-'
							  WHEN MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
							  ELSE '-'             
						 END )    AS  FROM_SITE
					   ,N2.MEASURE,10 AS DEPT_ORD,N2.XLS_ORD,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM,N3.YYYYMMDD,0 AS QTY,1 AS MST_SEQ
				FROM (
						SELECT   DISTINCT BB.DIVISION_ID
								, @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
								, @p_plan_type AS PLAN_TYPE
								, @p_seq AS SEQ
								, BB.ITEM_ID, CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
						FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
						LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
						ON BB.OWNER = CC.USER_ID
						INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH(NOLOCK)
						ON BB.ITEM_ID = DD.ITEM_ID
						AND CC.DEPT_ID = DD.DEPT_ID
						INNER JOIN (
										SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
										FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
										WHERE DIVISION_ID = @p_division_id
										AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
										AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
										AND   VALID_YN = 'Y'
									) EE
						ON BB.ITEM_ID = EE.ITEM_ID
						WHERE BB.DIVISION_ID = @p_division_id
						AND BB.VALID_YN = 'Y'
						AND BB.PROJECT_CODE <> '-'
						AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
					) N1,
					(
						SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
					) N2,
					(
						SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
						AND C.BASIS_YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
						AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
					) N3
			UNION ALL
			SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE
			       , G1.MEASURE, G2.DEPT_ORD, G1.XLS_ORD, G2.YYYYMM, G2.YYYYMMDD, (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY ELSE G2.CNT END) AS QTY, 1 AS MST_SEQ
			FROM (
					SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD 
				) G1,
				(
					SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
						   , 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, YYYYMMDD, AA.QTY, 1 AS CNT
					FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
					LEFT OUTER JOIN (
										SELECT  SMS.SCM_SITE_ID
											  , (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1
												 ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) 
												 END) AS SHIP_FROZEN
										FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
										LEFT OUTER JOIN (
															SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
															FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
															INNER JOIN
															[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
															ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
															WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
															AND   A.VALID_YN = 'Y'
															AND   B.SEGMENT1 = @p_division_id
															AND   B.VALID_YN = 'Y'
														) SALM
										ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
										WHERE  1 = 1
										AND DIVISION_ID = @p_division_id
										AND OPERATION_GROUP = 'A'
										AND SITE_TYPE = 'PLANT'
										AND VALID_YN = 'Y'
										AND OSP_YN = 'N'
									) SF
					ON AA.FROM_SITE = SF.SCM_SITE_ID
					WHERE 1 = 1
					AND AA.MEASURE IN ('SHIP_PLAN')
					AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
				) G2
			UNION ALL
			SELECT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,ITEM_ID,DEPT_ID,DEPT_NAME_EN,DEPT_NAME_KO,FROM_SITE,MEASURE,DEPT_ORD,XLS_ORD
				  ,LEFT(YYYYMM, 6) AS YYYYMM,YYYYMM AS YYYYMMDD,ROUND(QTY, 0) AS QTY,2 AS MST_SEQ
			FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
			WHERE 1 = 1
			AND DIVISION_ID = @p_division_id
			AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND PLAN_TYPE = @p_plan_type
			AND SEQ       = @p_seq
			AND MEASURE = 'SHIP_PLAN_AMEND'
			AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_item_list,','))
			AND LAST_UPDATED_BY = @p_planner_id
		) RR
		GROUP BY RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE, RR.SEQ, RR.ITEM_ID, RR.FROM_SITE, RR.MEASURE, RR.YYYYMM, RR.YYYYMMDD   ;


		SELECT ITEM_ID AS ITEM_ID_PROD, 
				ITEM_ID_ASSY, SUM(QTY) AS QTY, YYYYMMDD, '-' AS FROM_SITE 
		INTO  #tmp_PLN_STOCK_PLAN
		FROM  ( 
				SELECT AAA.*, BBB.ITEM_ID_ASSY AS ASSY_ORG, CASE WHEN BBB.ITEM_ID_ASSY IS NULL THEN AAA.ITEM_ID  ELSE BBB.ITEM_ID_ASSY END AS ITEM_ID_ASSY  
				FROM ( 
						SELECT CELL_ITEM_ID AS ITEM_ID, YYYYMMDD, QTY, FROM_SITE 
						FROM    ( 
									SELECT X.CELL_ITEM_ID, X.FROM_SITE,             CONVERT(VARCHAR,X.AFTER_DTTM,112) AS YYYYMMDD,             SUM(X.AFTER_QTY) AS QTY       
									FROM (
											SELECT    CELL_ITEM_ID, SCM_SITE_ID AS FROM_SITE
													, ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END) AS AFTER_QTY
													, ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,TOTAL_LT_FORMATION+CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN DATEADD(D,TOTAL_LT_FORMATION,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'INT%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'INT%' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) THEN RECEIVING_DTTM
																ELSE RECEIVING_DTTM
														END
														) AS AFTER_DTTM
											FROM   (
													SELECT A.ITEM_ID,A.SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,'~') AS SCM_SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,2,'~') AS LOC
															,( SELECT ISNULL(S.OSP_YN,'N') FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.DIVISION_ID='40' AND S.SCM_SITE_ID =[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,'~') ) AS OSP_YN
															, A.RECEIVING_DTTM,A.QTY,A.LOT_ID,A.DESCR,Y.TCO_CELL_YN
															,(CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID
															,( SELECT CASE WHEN MAX(TCO_CELL_ITEM_ID) IS NULL THEN 'N' ELSE 'Y' END
																FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK)
																WHERE 1=1
																AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
																) AS TCO_EXIST_YN
															, ( SELECT MAX(CELL_TO_TCO_BOD_LT) FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK) WHERE 1=1 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS CELL_TO_TCO_BOD_LT
															, ( SELECT MAX(TCO_TO_CELL_BOD_LT) FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK) WHERE 1=1 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS TCO_TO_CELL_BOD_LT
															, ( SELECT MAX(CELL_TO_TCO_TOTAL_BOD_LT) FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK) WHERE 1=1 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS CELL_TO_TCO_TOTAL_BOD_LT
															, ( SELECT ISNULL(MAX(V.FORMATION_TOTAL_YIELD),1) FROM [dbo].[SCP_MST_FORMATION_V] V WITH(NOLOCK) WHERE V.DIVISION_ID = '40' AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS FORMATION_TOTAL_YIELD
															, ( SELECT ISNULL(MAX(V.TOTAL_LT_FORMATION),0) FROM [dbo].[SCP_MST_FORMATION_V] V WITH(NOLOCK) WHERE V.DIVISION_ID = '40' AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS TOTAL_LT_FORMATION
													FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN  A WITH(NOLOCK)
													INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
													ON 0 = 0 
													and a.master_id = '40::WEEKLY'
													and a.plan_id = @eng_plan_id
													AND Y.DIVISION_ID = @p_division_id
													AND A.ITEM_ID     = Y.ITEM_ID
													AND Y.OPERATION_GROUP='A'
											) XLS_BOH       
										) X 
									where CONVERT(VARCHAR,X.AFTER_DTTM,112) < @v_plan_start_yyyymmdd
									GROUP BY X.CELL_ITEM_ID, X.FROM_SITE, CONVERT(VARCHAR,X.AFTER_DTTM,112)
								) X 
								where YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112)  
						) AS AAA 
				LEFT OUTER JOIN  (
									SELECT DISTINCT PLANT_ID, ITEM_ID_ASSY, ITEM_ID_PROD, CELL_TYPE FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock)  
								) BBB
				ON AAA.ITEM_ID = BBB.ITEM_ID_PROD 
				AND SUBSTRING(AAA.FROM_SITE,1,4) = BBB.PLANT_ID  
		) CCC  
		-- CELL_ASSY(CELL의 시작공정)에 CELL_PROD(CELL의 끝공정)의 데이터는 외주 데이터이므로 제외함.
		WHERE ITEM_ID_ASSY IN ( SELECT DISTINCT ITEM_ID_ASSY FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE DIVISION_ID = @p_division_id)
		GROUP BY ITEM_ID_ASSY,YYYYMMDD, ITEM_ID

		;


		SET @SQL = '';
		SET @SQL = @SQL + 'SELECT PV1.DIVISION_ID';
		SET @SQL = @SQL + '      ,PV1.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '      ,PV1.PLAN_TYPE';
		SET @SQL = @SQL + '      ,PV1.SEQ';
		SET @SQL = @SQL + '      ,PV1.CELL_TYPE';
		SET @SQL = @SQL + '      ,PV1.ITEM_ID';
		SET @SQL = @SQL + '      ,PV1.NICK_NAME';
		SET @SQL = @SQL + '      ,PV1.DEPT_ID';
		SET @SQL = @SQL + '      ,PV1.DEPT_NAME_EN';
		SET @SQL = @SQL + '      ,PV1.DEPT_NAME_KO';
		SET @SQL = @SQL + '      ,PV1.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '      ,PV1.MEASURE';
		SET @SQL = @SQL + '      ,PV1.MEASURE_DESC';
		SET @SQL = @SQL + '      ,PV1.BOH';
		SET @SQL = @SQL + '      ,PV1.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_wcols2;
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '      ,PV1.TOTAL_QTY';
		SET @SQL = @SQL + '      ,PV1.CONFIRM_QTY';
		SET @SQL = @SQL + '      ,PV1.CONFIRM_QTY2';
		SET @SQL = @SQL + '      ,PV1.PLAN_END_YYYYMMDD';
		SET @SQL = @SQL + '      ,PV1.FROZEN';
		SET @SQL = @SQL + '  FROM (';

		-- PIVOT1 : Month Plan
		SET @SQL = @SQL + 'SELECT   P.DIVISION_ID';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE';
		SET @SQL = @SQL + '        ,P.SEQ';
		SET @SQL = @SQL + '        ,(SELECT SEGMENT2 FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)';
		SET @SQL = @SQL + '			  WHERE LOOKUP_TYPE = ''CELL_TYPE_GROUP_CODE''';
		SET @SQL = @SQL + '			    AND VALID_YN =''Y''';
		SET @SQL = @SQL + '			    AND SEGMENT1 = P.CELL_TYPE_GROUP_CODE) AS CELL_TYPE';
		SET @SQL = @SQL + '        ,P.ITEM_ID';
		SET @SQL = @SQL + '        ,P.NICK_NAME';
		SET @SQL = @SQL + '        ,P.DEPT_ID';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE <> ''INVENTORY'' THEN P.FROM_SITE	ELSE ''-''	END) AS FROM_SITE';				-- 추가
		SET @SQL = @SQL + '        ,P.MEASURE';
		SET @SQL = @SQL + '        ,P.DEPT_ORD';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''MKT_FCST'' THEN ''Forecast''  ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ'' THEN ''Ship Req.'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ_TOTAL'' THEN ''Ship Req.Total'' ';		--추가
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN_AMEND_TOTAL'' THEN ''Ship plan .Total'' ';		--추가
        SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN''        THEN ''Ship Plan (SSP)'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN_AMEND''  THEN ''Ship Plan'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''PROD_PLAN_ENGINE'' THEN ''Available(Production+L/T)'' ';
		SET @SQL = @SQL + '			      ELSE ''Inventory'' END) AS MEASURE_DESC ';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE <> ''INVENTORY'' THEN 0'
		SET @SQL = @SQL + '               ELSE ISNULL(B.QTY, 0)'
		SET @SQL = @SQL + '           END) AS BOH';
		SET @SQL = @SQL + '        ,P.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '        ,0 AS TOTAL_QTY ';
		SET @SQL = @SQL + '        ,0 AS CONFIRM_QTY ';
		SET @SQL = @SQL + '        ,0 AS CONFIRM_QTY2 ';
		SET @SQL = @SQL + '        ,''' + @v_plan_end_yyyymmdd + ''' AS PLAN_END_YYYYMMDD';

		SET @SQL = @SQL + '        ,(CASE WHEN ' + CONVERT(VARCHAR, @v_frozen_days) + ' > 0 THEN ' + CONVERT(VARCHAR, @v_frozen_days) + ' - 1 ELSE ' + CONVERT(VARCHAR, @v_frozen_days) + ' END) AS FROZEN';
		SET @SQL = @SQL + '  FROM (';
		SET @SQL = @SQL + '		SELECT P_RST.*, F.NICK_NAME, F.CELL_TYPE_GROUP_CODE';
		SET @SQL = @SQL + '		  FROM (';

		SET @SQL = @SQL + '			 SELECT  R.DIVISION_ID';
		SET @SQL = @SQL + '			        ,R.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,R.PLAN_TYPE';
		SET @SQL = @SQL + '			        ,R.SEQ';
		SET @SQL = @SQL + '			        ,R.ITEM_ID';
		SET @SQL = @SQL + '	        		,R.DEPT_ID';
		SET @SQL = @SQL + '	        		,R.DEPT_NAME_EN';
		SET @SQL = @SQL + '	        		,R.DEPT_NAME_KO';
		SET @SQL = @SQL + '	        		,R.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '			        ,R.MEASURE';
		SET @SQL = @SQL + '	        		,R.DEPT_ORD';
		SET @SQL = @SQL + '	        		,R.XLS_ORD';
		SET @SQL = @SQL + '			        ,R.YYYYMM';
		SET @SQL = @SQL + '			        ,(CASE WHEN R.MEASURE = ''SHIP_PLAN'' THEN 0 ELSE R.QTY END) AS QTY '

		SET @SQL = @SQL + '			 FROM #tmp_MONTH_SHIPMENT_PLAN_FG_1 R WITH(NOLOCK) ,    #tmp_MONTH_SHIPMENT_PLAN_FG_2 Q WITH(NOLOCK)     ';

		SET @SQL = @SQL + '			  WHERE R.MST_SEQ             = Q.MST_SEQ';
		SET @SQL = @SQL + '			    AND R.DIVISION_ID         = Q.DIVISION_ID';
		SET @SQL = @SQL + '			    AND R.PLAN_START_YYYYMMDD = Q.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			    AND R.PLAN_TYPE = Q.PLAN_TYPE';
		SET @SQL = @SQL + '			    AND R.SEQ       = Q.SEQ';
		SET @SQL = @SQL + '			    AND R.ITEM_ID   = Q.ITEM_ID';
		SET @SQL = @SQL + '			    AND R.FROM_SITE = Q.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '			    AND R.MEASURE   = Q.MEASURE';
		SET @SQL = @SQL + '			    AND R.YYYYMM    = Q.YYYYMM';
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  P.DIVISION_ID';
		SET @SQL = @SQL + '					,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '					,P.PLAN_TYPE';
		SET @SQL = @SQL + '					,P.SEQ';
		SET @SQL = @SQL + '		, (	';
	  	SET @SQL = @SQL + '			CASE (SELECT COUNT(DISTINCT( ITEM_ID_PROD)) from SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID	) ';
	 	SET @SQL = @SQL + '			WHEN  0 THEN P.ITEM_ID	';
	 	SET @SQL = @SQL + '			WHEN 1 THEN (SELECT DISTINCT ITEM_ID_PROD from SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID ) ';
	 	SET @SQL = @SQL + '			END ';
	 	SET @SQL = @SQL + '		) AS ITEM_ID ';

		SET @SQL = @SQL + '					, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '					, P.SCM_SITE_ID';				-- 추가
		SET @SQL = @SQL + '					,P.MEASURE'
		SET @SQL = @SQL + '					,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '					,900  AS XLS_ORD';
		SET @SQL = @SQL + '					,SUBSTRING(CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '	            ,SUM(ROUND(P.QTY * ISNULL(F.SSP_MODIFY_YIELD, 1), 0)) AS QTY';------EDIT BY DHJ 07/10/2023		
		SET @SQL = @SQL + '				FROM [DBO].[SCP_ANL_PRODUCTION_PLAN] P WITH (NOLOCK)';
		SET @SQL = @SQL + '				LEFT JOIN [dbo].[SCP_MST_FORMATION] F WITH (NOLOCK)';
		SET @SQL = @SQL + '				ON P.SCM_SITE_ID = F.PLANT_SITE_ID';
		SET @SQL = @SQL + '				AND P.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '				WHERE 1 = 1';
		SET @SQL = @SQL + '				AND P.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '				AND P.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '				AND P.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '				AND P.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '				AND P.OPERATION_GROUP = ''A''';
		SET @SQL = @SQL + '				AND P.MEASURE = ''PROD_PLAN_ENGINE''';

		SET @SQL = @SQL + '	 AND (P.ITEM_ID IN  ';
		SET @SQL = @SQL + '					( ';
		SET @SQL = @SQL + @v_items;			-- 20231005 강현준

		SET @SQL = @SQL + '					) ';	
		SET @SQL = @SQL + '	  )';


		SET @SQL = @SQL + '	 AND CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + 'GROUP BY P.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, P.SCM_SITE_ID, MEASURE ,CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), P.ITEM_ID ';			-- 변경

		----------------------
		-- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		----------------------
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  ''' + @p_division_id + ''' AS DIVISION_ID';
		SET @SQL = @SQL + '			        ,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '			        ,''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '			        ,E1.value AS ITEM_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '		            ,E4.PLANT_SITE_ID AS FROM_SITE';		-- 추가
		SET @SQL = @SQL + '			        ,E2.MEASURE';
		SET @SQL = @SQL + '                 ,99	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,E2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(E3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '			   FROM (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_item_list + ''','','')) E1,';
		SET @SQL = @SQL + '			        (SELECT ''PROD_PLAN_ENGINE'' AS MEASURE, 900 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) E2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) E3 , ';		-- 변경

		SET @SQL = @SQL + '			        ( ';		
		SET @SQL = @SQL + '						SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY ';		
		SET @SQL = @SQL + '						FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) ';		
		SET @SQL = @SQL + '						WHERE DIVISION_ID = ''' + @p_division_id + ''' ';		
		SET @SQL = @SQL + '		        		AND   FROM_YYYYMMDD <= ''' + @v_plan_end_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   TO_YYYYMMDD >= ''' + @v_plan_start_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   VALID_YN = ''Y'' ';
		SET @SQL = @SQL + '		        	) E4 ';
		SET @SQL = @SQL + '			        WHERE E1.value = E4.ITEM_ID ';	

		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT ''' + @p_division_id + ''' AS DIVISION_ID ';
		SET @SQL = @SQL + '					,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '					,''' + @p_plan_type + ''' AS PLAN_TYPE ';
		SET @SQL = @SQL + '					,''' + @p_seq + ''' AS SEQ ';
		SET @SQL = @SQL + '					,ITEM_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '					, ''-'' AS FROM_SITE ';				-- 추가
		SET @SQL = @SQL + '					,''INVENTORY'' AS MEASURE';
		SET @SQL = @SQL + '					,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '					,800  AS XLS_ORD';
		SET @SQL = @SQL + '					,''' + @p_plan_start_yyyymmdd + ''' AS YYYYMMDD ';
		SET @SQL = @SQL + '					,0    AS QTY';
		SET @SQL = @SQL + '			   FROM SCP_MST_FINAL_ITEM WITH (NOLOCK)';
		SET @SQL = @SQL + '			  WHERE DIVISION_ID = ''40'' AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_item_list + ''','',''))';
		SET @SQL = @SQL + '             AND OPERATION_GROUP = ''A''';


		SET @SQL = @SQL + '			  ) AS M';
		SET @SQL = @SQL + '		 PIVOT (';
		SET @SQL = @SQL + '				SUM(QTY) FOR YYYYMM IN (' + @v_cols + ')';
		SET @SQL = @SQL + '			   ) AS P_RST,';
		SET @SQL = @SQL + '            (SELECT ITEM_ID, NICK_NAME, CELL_TYPE_GROUP_CODE ';
		SET @SQL = @SQL + '               FROM DBO.SCP_MST_FINAL_ITEM F WITH (NOLOCK) ';
		SET @SQL = @SQL + '              WHERE DIVISION_ID = ''40'' AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString( ''' + @p_item_list + ''','',''))';
		SET @SQL = @SQL + '                AND OPERATION_GROUP = ''A'' ) AS F ';

		SET @SQL = @SQL + '		  WHERE 0 = 0';
		SET @SQL = @SQL + '			AND P_RST.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ' LEFT OUTER JOIN ( ';

		-- 각 아이템별 BOH 계산
		SET @SQL = @SQL + ' SELECT DISTINCT EEE.ITEM_ID_ASSY, SUM_QTY AS QTY, YYYYMMDD, EEE.ITEM_ID_PROD AS ITEM_ID, FROM_SITE  ';
		SET @SQL = @SQL + ' FROM  (  ';
		-- (PROD / ASSY), (ASSY / ASSY) 인 것   
		SET @SQL = @SQL + ' 		SELECT A.ITEM_ID_PROD, A.ITEM_ID_ASSY, A.QTY+B.QTY AS SUM_QTY, A.YYYYMMDD, A.FROM_SITE ';
		SET @SQL = @SQL + ' 		FROM  #tmp_PLN_STOCK_PLAN A WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		INNER JOIN #tmp_PLN_STOCK_PLAN B WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		ON A.ITEM_ID_ASSY = B.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' 		WHERE A.ITEM_ID_PROD <> B.ITEM_ID_ASSY '; 
		SET @SQL = @SQL + ' ) DDD  ';
		SET @SQL = @SQL + ' LEFT OUTER JOIN  (  ';
		SET @SQL = @SQL + ' 					SELECT DISTINCT ITEM_ID_ASSY, ITEM_ID_PROD  ';
		SET @SQL = @SQL + ' 					FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock)   ';
		SET @SQL = @SQL + ' 					WHERE CELL_TYPE = ''CA1'' ';
		SET @SQL = @SQL + ' 				) EEE  ';
		SET @SQL = @SQL + ' ON DDD.ITEM_ID_ASSY = EEE.ITEM_ID_ASSY  ';
		SET @SQL = @SQL + ' AND  DDD.ITEM_ID_PROD = EEE.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' UNION ALL ';
		SET @SQL = @SQL + ' SELECT DISTINCT EEE.ITEM_ID_ASSY, SUM_QTY, YYYYMMDD, EEE.ITEM_ID_PROD AS ITEM_ID, FROM_SITE   ';
		SET @SQL = @SQL + ' FROM  (  ';
		-- (PROD / ASSY), (ASSY / ASSY) 인데 이 중 (ASSY / ASSY) 수량은 중복되므로 삭제
		SET @SQL = @SQL + ' 		SELECT A.ITEM_ID_PROD, A.ITEM_ID_ASSY, A.QTY AS SUM_QTY, A.YYYYMMDD, A.FROM_SITE ';
		SET @SQL = @SQL + ' 		FROM  #tmp_PLN_STOCK_PLAN A WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		WHERE A.ITEM_ID_PROD = A.ITEM_ID_ASSY   ';
		SET @SQL = @SQL + ' 		AND	  NOT EXISTS ( ';
		SET @SQL = @SQL + ' 							SELECT B.ITEM_ID_PROD, B.ITEM_ID_ASSY, B.QTY AS SUM_QTY, B.YYYYMMDD, B.FROM_SITE ';
		SET @SQL = @SQL + ' 							FROM  #tmp_PLN_STOCK_PLAN B WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 							WHERE B.ITEM_ID_PROD <> B.ITEM_ID_ASSY  ';
		SET @SQL = @SQL + ' 							AND   B.ITEM_ID_ASSY = A.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' 						 ) ';
		SET @SQL = @SQL + ' 		UNION ALL  ';
		--  ( PROD / ASSY ) 1개만 있는 것
		SET @SQL = @SQL + ' 		SELECT A.ITEM_ID_PROD, A.ITEM_ID_ASSY, ISNULL(A.QTY,0) + ISNULL(B.QTY,0) AS SUM_QTY, A.YYYYMMDD, A.FROM_SITE ';
		SET @SQL = @SQL + ' 		FROM  #tmp_PLN_STOCK_PLAN A WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		LEFT OUTER JOIN #tmp_PLN_STOCK_PLAN B WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		ON A.ITEM_ID_ASSY = B.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' 		WHERE B.ITEM_ID_PROD IS NULL ';
		SET @SQL = @SQL + ' ) DDD  ';
		SET @SQL = @SQL + ' LEFT OUTER JOIN  (  ';
		SET @SQL = @SQL + ' 					SELECT DISTINCT ITEM_ID_ASSY, ITEM_ID_PROD  ';
		SET @SQL = @SQL + ' 					FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock)   ';
		SET @SQL = @SQL + ' 					WHERE CELL_TYPE = ''CA1'' ';
		SET @SQL = @SQL + ' 				) EEE  ';
		SET @SQL = @SQL + ' ON DDD.ITEM_ID_ASSY = EEE.ITEM_ID_ASSY  ';

		SET @SQL = @SQL + '	   ) B';
		SET @SQL = @SQL + '	ON P.ITEM_ID = B.ITEM_ID '		
		SET @SQL = @SQL + ') PV1,';

		-----------------------
		-- PIVOT2 : Frozen 구간
		-----------------------
		SET @SQL = @SQL + '(';
		SET @SQL = @SQL + 'SELECT   P.DIVISION_ID';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE';
		SET @SQL = @SQL + '        ,P.SEQ';
		SET @SQL = @SQL + '        ,P.ITEM_ID';
		SET @SQL = @SQL + '        ,P.DEPT_ID';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO';
		SET @SQL = @SQL + '        ,P.FROM_SITE';					-- 추가
		SET @SQL = @SQL + '        ,P.MEASURE';
		SET @SQL = @SQL + '        ,P.DEPT_ORD';
		SET @SQL = @SQL + '        ,P.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_wcols2;
		SET @SQL = @SQL + '  FROM (';

		SET @SQL = @SQL + '  SELECT P_RST.*';
		SET @SQL = @SQL + '    FROM (';
		SET @SQL = @SQL + '          SELECT W2.DIVISION_ID';
		SET @SQL = @SQL + '                ,W2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '                ,W2.PLAN_TYPE';
		SET @SQL = @SQL + '                ,W2.SEQ';
		SET @SQL = @SQL + '                ,W2.ITEM_ID';
		SET @SQL = @SQL + '                ,W2.DEPT_ID';
		SET @SQL = @SQL + '                ,W2.DEPT_NAME_EN';
		SET @SQL = @SQL + '                ,W2.DEPT_NAME_KO';
		SET @SQL = @SQL + '                ,W2.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '                ,W2.MEASURE';
		SET @SQL = @SQL + '                ,W2.DEPT_ORD';
		SET @SQL = @SQL + '                ,W2.XLS_ORD';
		--SET @SQL = @SQL + '                ,W2.QTY';
		SET @SQL = @SQL + '                ,(CASE WHEN W2.MEASURE = ''SHIP_PLAN'' THEN (CASE WHEN W1.S_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + ''' OR W1.E_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + ''' THEN 0 ELSE W2.QTY END) ELSE W2.QTY END) AS QTY';
		SET @SQL = @SQL + '                ,W1.S_YYYYMMDD + ''~'' + W1.E_YYYYMMDD AS W_DAY';
		SET @SQL = @SQL + '            FROM ';
		-- 이하 WEEK 플랜구분 (1 ~ 3 주, 4~마지막)
		SET @SQL = @SQL + '                 (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM';
        SET @SQL = @SQL + '                    FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM';
        SET @SQL = @SQL + '                                 ,C.BASIS_YYYYMMDD AS E_YYYYMMDD';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,' + CONVERT(VARCHAR, @v_frozen_days) + ',CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)';
		SET @SQL = @SQL + '                             AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
        SET @SQL = @SQL + '                         ) S1,';
		SET @SQL = @SQL + '                         (SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM';
		SET @SQL = @SQL + '                                ,C.BASIS_YYYYMMDD AS S_YYYYMMDD';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,' + CONVERT(VARCHAR, @v_frozen_days) + ',CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)';
		SET @SQL = @SQL + '                             AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2';
        SET @SQL = @SQL + '                         ) S2';
        SET @SQL = @SQL + '                   WHERE S1.R_NUM = S2.R_NUM';

		-- Week Plan 
        SET @SQL = @SQL + '                   UNION ALL';
		SET @SQL = @SQL + '                  SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM';
        SET @SQL = @SQL + '                    FROM (SELECT  ROW_NUMBER() OVER(ORDER BY MAX(C.BASIS_YYYYMMDD) ASC) AS R_NUM';
        SET @SQL = @SQL + '                                 ,MAX(C.BASIS_YYYYMMDD) AS E_YYYYMMDD';
		SET @SQL = @SQL + '                                 ,C.PARTIAL_WEEK_NAME';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <= ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + '                           GROUP BY C.PARTIAL_WEEK_NAME ';
        SET @SQL = @SQL + '                         ) S1,';
		SET @SQL = @SQL + '                         (SELECT ROW_NUMBER() OVER(ORDER BY MIN(C.BASIS_YYYYMMDD) ASC) AS R_NUM';
		SET @SQL = @SQL + '                                ,MIN(C.BASIS_YYYYMMDD) AS S_YYYYMMDD';
		SET @SQL = @SQL + '                                ,C.PARTIAL_WEEK_NAME';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <= ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + '                           GROUP BY C.PARTIAL_WEEK_NAME ';
        SET @SQL = @SQL + '                         ) S2';
        SET @SQL = @SQL + '                   WHERE S1.R_NUM = S2.R_NUM';

		SET @SQL = @SQL + '                 ) W1,';
		-- 이하 WEEK 구간 Measure 별 data
		SET @SQL = @SQL + '			        (SELECT R.DIVISION_ID';
		SET @SQL = @SQL + '			               ,R.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			               ,R.PLAN_TYPE';
		SET @SQL = @SQL + '			               ,R.SEQ';
		SET @SQL = @SQL + '			               ,R.ITEM_ID';
		SET @SQL = @SQL + '			               ,R.DEPT_ID';
		SET @SQL = @SQL + '			               ,R.DEPT_NAME_EN';
		SET @SQL = @SQL + '			               ,R.DEPT_NAME_KO';
		SET @SQL = @SQL + '			               ,R.FROM_SITE';			-- 추가
		SET @SQL = @SQL + '			               ,R.MEASURE';
		SET @SQL = @SQL + '			               ,R.DEPT_ORD';
		SET @SQL = @SQL + '			               ,R.XLS_ORD';
		SET @SQL = @SQL + '			               ,R.YYYYMM';
		SET @SQL = @SQL + '			               ,R.YYYYMMDD';
		SET @SQL = @SQL + '			               ,R.QTY';
		SET @SQL = @SQL + '			               ,R.MST_SEQ';
		-- -- SCP_ANL_SHIPMENT_PLAN_FG (MKT_FCST, SHIP_REQ, SHIP_PLAN, SHIP_PLAN_AMEND)

		SET @SQL = @SQL + '			 FROM #tmp_WEEK_SHIPMENT_PLAN_FG_1 R WITH(NOLOCK) ,    #tmp_WEEK_SHIPMENT_PLAN_FG_2 Q WITH(NOLOCK)     ';

		SET @SQL = @SQL + '	            		  WHERE R.MST_SEQ             = Q.MST_SEQ';
		SET @SQL = @SQL + '	            		    AND R.DIVISION_ID         = Q.DIVISION_ID';
		SET @SQL = @SQL + '	            		    AND R.PLAN_START_YYYYMMDD = Q.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            		    AND R.PLAN_TYPE = Q.PLAN_TYPE';
		SET @SQL = @SQL + '	            		    AND R.SEQ       = Q.SEQ';
		SET @SQL = @SQL + '	            		    AND R.ITEM_ID   = Q.ITEM_ID';
		SET @SQL = @SQL + '	            		    AND R.FROM_SITE = Q.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '	            		    AND R.MEASURE   = Q.MEASURE';
		SET @SQL = @SQL + '	            		    AND R.YYYYMM    = Q.YYYYMM';
		SET @SQL = @SQL + '	            		    AND R.YYYYMMDD    = Q.YYYYMMDD';		-->>>
		SET @SQL = @SQL + '	            		  UNION ALL';
		SET @SQL = @SQL + '	            		 SELECT  P.DIVISION_ID';
		SET @SQL = @SQL + '	            				,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            				,P.PLAN_TYPE';
		SET @SQL = @SQL + '	            				,P.SEQ';
		
		SET @SQL = @SQL + '		, (	';
	  	SET @SQL = @SQL + '			CASE (SELECT COUNT(DISTINCT( ITEM_ID_PROD)) FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID	) ';
	 	SET @SQL = @SQL + '			WHEN  0 THEN P.ITEM_ID	';
	 	SET @SQL = @SQL + '			WHEN 1 THEN (  SELECT DISTINCT ITEM_ID_PROD FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID ) ';
	 	SET @SQL = @SQL + '			END ';
	 	SET @SQL = @SQL + '		) AS ITEM_ID ';
		

		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '	            				, P.SCM_SITE_ID';			-- 추가
		SET @SQL = @SQL + '	            				,P.MEASURE'
		SET @SQL = @SQL + '	            				,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '	            				,900  AS XLS_ORD';
		SET @SQL = @SQL + '	            				,SUBSTRING(CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), 1, 6) AS YYYYMM';     --SUBSTRING(P.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '	            				,CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) AS YYYYMMDD';   --P.YYYYMMDD';
		SET @SQL = @SQL + '	            				,SUM(ROUND(P.QTY * ISNULL(F.SSP_MODIFY_YIELD, 1), 0)) AS QTY';------EDIT BY DHJ 07/10/2023
		SET @SQL = @SQL + '		        	            , 1 AS MST_SEQ';
		SET @SQL = @SQL + '	            			FROM [DBO].[SCP_ANL_PRODUCTION_PLAN] P WITH (NOLOCK)';
		SET @SQL = @SQL + '	            			LEFT JOIN [dbo].[SCP_MST_FORMATION] F WITH (NOLOCK)';
		SET @SQL = @SQL + '	            			ON P.SCM_SITE_ID = F.PLANT_SITE_ID';
		SET @SQL = @SQL + '	            			AND P.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '	            			WHERE 1 = 1';
		SET @SQL = @SQL + '	            			AND P.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '	            			AND P.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	            			AND P.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	            			AND P.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '	            			AND P.OPERATION_GROUP = ''A''';
		SET @SQL = @SQL + '	            			AND P.MEASURE = ''PROD_PLAN_ENGINE''';

		SET @SQL = @SQL + '	 AND (P.ITEM_ID IN  ';
		SET @SQL = @SQL + '					( ';
		SET @SQL = @SQL + @v_items;			-- 20231005 강현준

		SET @SQL = @SQL + '					) ';
		SET @SQL = @SQL + '	  )';

		SET @SQL = @SQL + '	 AND CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + 'GROUP BY P.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, P.SCM_SITE_ID, MEASURE ,CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) , P.ITEM_ID';	-- 변경

		----------------------
		-- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		----------------------
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  ''' + @p_division_id + ''' AS DIVISION_ID';
		SET @SQL = @SQL + '			        ,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '			        ,''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '			        ,E1.value AS ITEM_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '		            ,E4.PLANT_SITE_ID	AS FROM_SITE';			-- 추가
		SET @SQL = @SQL + '			        ,E2.MEASURE';
		SET @SQL = @SQL + '                 ,99	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,E2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(E3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,E3.YYYYMMDD';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_item_list + ''','','')) E1,';
		SET @SQL = @SQL + '			        (SELECT ''PROD_PLAN_ENGINE'' AS MEASURE, 900 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) E2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) E3 , ';		-- 변경
		SET @SQL = @SQL + '			        ( ';		
		SET @SQL = @SQL + '						SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY ';		
		SET @SQL = @SQL + '						FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) ';		
		SET @SQL = @SQL + '						WHERE DIVISION_ID = ''' + @p_division_id + ''' ';		
		SET @SQL = @SQL + '		        		AND   FROM_YYYYMMDD <= ''' + @v_plan_end_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   TO_YYYYMMDD >= ''' + @v_plan_start_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   VALID_YN = ''Y'' ';
		SET @SQL = @SQL + '		        	) E4 ';
		SET @SQL = @SQL + '			        WHERE E1.value = E4.ITEM_ID ';	

		SET @SQL = @SQL + '		            	  UNION ALL';
		SET @SQL = @SQL + '		            	 SELECT ''' + @p_division_id + ''' AS DIVISION_ID ';
		SET @SQL = @SQL + '		            			,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '		            			,''' + @p_plan_type + ''' AS PLAN_TYPE ';
		SET @SQL = @SQL + '		            			,''' + @p_seq + ''' AS SEQ ';
		SET @SQL = @SQL + '		            			,ITEM_ID';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '		            			, ''-'' AS FROM_SITE ';		-- 임시추가
		SET @SQL = @SQL + '		            			,''INVENTORY'' AS MEASURE';
		SET @SQL = @SQL + '		            			,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '		            			,800  AS XLS_ORD';
		SET @SQL = @SQL + '		                    	, SUBSTRING(''' + @p_plan_start_yyyymmdd + ''', 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		            			,''' + @p_plan_start_yyyymmdd + ''' AS YYYYMMDD ';
		SET @SQL = @SQL + '		            			,0    AS QTY';
		SET @SQL = @SQL + '		        	            ,1 AS MST_SEQ';
		SET @SQL = @SQL + '		            	   FROM SCP_MST_FINAL_ITEM WITH (NOLOCK)';
		SET @SQL = @SQL + '		                	  WHERE DIVISION_ID = ''40'' AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_item_list + ''','',''))';
		SET @SQL = @SQL + '                             AND OPERATION_GROUP = ''A''';
		SET @SQL = @SQL + '                 ) W2';
		SET @SQL = @SQL + '           WHERE W2.YYYYMMDD >= W1.S_YYYYMMDD AND W2.YYYYMMDD <= W1.E_YYYYMMDD';
        SET @SQL = @SQL + '			) AS M';
		SET @SQL = @SQL + '   PIVOT (';
		SET @SQL = @SQL + '          SUM(QTY) FOR W_DAY IN (' + @v_wcols + ')';
		SET @SQL = @SQL + '         ) AS P_RST';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ') PV2';
		SET @SQL = @SQL + ' WHERE PV1.DIVISION_ID         = PV2.DIVISION_ID';
		SET @SQL = @SQL + '   AND PV1.PLAN_START_YYYYMMDD = PV2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '   AND PV1.PLAN_TYPE = PV2.PLAN_TYPE';
		SET @SQL = @SQL + '   AND PV1.SEQ       = PV2.SEQ';
		SET @SQL = @SQL + '   AND PV1.ITEM_ID   = PV2.ITEM_ID';
		SET @SQL = @SQL + '   AND PV1.DEPT_ID   = PV2.DEPT_ID';
		SET @SQL = @SQL + '   AND PV1.FROM_SITE = PV2.FROM_SITE';			-- 추가
		SET @SQL = @SQL + '   AND PV1.MEASURE   = PV2.MEASURE';
		SET @SQL = @SQL + '   AND PV1.XLS_ORD   = PV2.XLS_ORD';
		SET @SQL = @SQL + ' ORDER BY PV1.ITEM_ID, PV1.DEPT_ORD, PV1.DEPT_NAME_KO, PV1.FROM_SITE, PV1.XLS_ORD;';		-- 변경

		--select @sql AS SQL;

		EXEC(@SQL);


        IF OBJECT_ID('tempdb..#tmp_SCM_MST_SSO_DEPT_USER_INFO') IS NOT NULL
			DROP TABLE #tmp_SCM_MST_SSO_DEPT_USER_INFO
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIP_DEPT') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIP_DEPT
		;

		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_PLN_STOCK_PLAN') IS NOT NULL
			DROP TABLE #tmp_PLN_STOCK_PLAN
		;

	END

	 IF @p_query_type = 'day_result'		-- RAW 차감후 결과 Sheet
		BEGIN

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 364 -> 364+182
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

		SELECT @v_cols = @v_cols + '[' + YYYYMMDD + '],', @v_cols2 = @v_cols2 + 'ISNULL([' + YYYYMMDD + '],0) AS [' + YYYYMMDD + '],'
		  FROM (
			   SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
					AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd
			   ) AS days
		 ORDER BY YYYYMMDD
		 ;		

		 
		SET @v_cols = LEFT(@v_cols, LEN(@v_cols) - 1);
		SET @v_cols2 = LEFT(@v_cols2, LEN(@v_cols2) - 1);



		SET @SQL = 'SELECT P.DIVISION_ID ';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN ';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO ';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE ';
		SET @SQL = @SQL + '        ,P.SEQ ';
		SET @SQL = @SQL + '        ,P.PROJECT_CODE ';
		SET @SQL = @SQL + '        ,P.ITEM_ID ';
		SET @SQL = @SQL + '        ,P.NICK_NAME ';
		SET @SQL = @SQL + '        ,P.FROM_SITE ';			-- 추가
		SET @SQL = @SQL + '        ,P.TO_SITE ';
		SET @SQL = @SQL + '        ,P.MEASURE ';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''MKT_FCST'' THEN ''Forcast''  ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ'' THEN ''Ship Req.'' ';
		SET @SQL = @SQL + '			      ELSE ''Ship Plan'' END) AS MEASURE_DESC ';
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '  FROM ( ';
		SET @SQL = @SQL + 'SELECT P_RST.*, F.NICK_NAME ';
		SET @SQL = @SQL + '  FROM ( ';
		SET @SQL = @SQL + '     SELECT   AA.DIVISION_ID ';
		SET @SQL = @SQL + '	        , CC.DEPT_NAME_EN ';
		SET @SQL = @SQL + '	        , CC.DEPT_NAME_KO ';
		SET @SQL = @SQL + '			, AA.PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '			, AA.PLAN_TYPE ';
		SET @SQL = @SQL + '			, AA.SEQ ';
		SET @SQL = @SQL + '			, AA.PROJECT_CODE ';
		SET @SQL = @SQL + '			, AA.ITEM_ID ';
		SET @SQL = @SQL + '			, AA.TO_SITE ';
		SET @SQL = @SQL + '			, (CASE WHEN AA.MEASURE = ''SHIP_PLAN_AMEND'' THEN DD.PLANT_SITE_ID ELSE AA.FROM_SITE END )	AS FROM_SITE  ';		-- 추가
		SET @SQL = @SQL + '			, AA.MEASURE  ';
		SET @SQL = @SQL + '			, (CASE WHEN AA.MEASURE = ''MKT_FCST'' THEN 100 ';
		SET @SQL = @SQL + '			        WHEN AA.MEASURE = ''SHIP_REQ'' THEN 200 ELSE 300 END) AS XLS_ORD ';
		SET @SQL = @SQL + '			, AA.YYYYMMDD ';
		SET @SQL = @SQL + '			, (CASE WHEN AA.FROM_SITE = DD.PLANT_SITE_ID THEN AA.QTY ELSE 0 END )	AS QTY ';		-- 변경
		SET @SQL = @SQL + '       FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK) ';
		SET @SQL = @SQL + '       LEFT  ';
		SET @SQL = @SQL + '       JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK) ';
		SET @SQL = @SQL + '         ON AA.DIVISION_ID = BB.DIVISION_ID ';
		SET @SQL = @SQL + '        AND AA.PROJECT_CODE = BB.PROJECT_CODE ';
		SET @SQL = @SQL + '        AND AA.TO_SITE = BB.SCM_SITE_ID ';
		SET @SQL = @SQL + '        AND AA.ITEM_ID = BB.ITEM_ID ';
		SET @SQL = @SQL + '       LEFT ';
		SET @SQL = @SQL + '       JOIN (SELECT distinct B.USER_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN ';
		SET @SQL = @SQL + '               FROM [SCM_MST_SSO_USER_INFO] AS B ';
		SET @SQL = @SQL + '              INNER  ';
		SET @SQL = @SQL + '                                    JOIN SCM_MST_SSO_DEPT_INFO AS C ';
		SET @SQL = @SQL + '                 ON B.DEPT_ID = C.DEPT_ID) CC ';
		SET @SQL = @SQL + '         ON BB.OWNER = CC.USER_ID ';
		SET @SQL = @SQL + '       LEFT JOIN ( ';
		SET @SQL = @SQL + '       			SELECT DISTINCT DIVISION_ID, PLANT_SITE_ID, ITEM_ID ';
		SET @SQL = @SQL + '       			FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) ';
		SET @SQL = @SQL + '      			WHERE DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '      			AND   FROM_YYYYMMDD <= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '       			AND   TO_YYYYMMDD >= ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + '       			AND   VALID_YN = ''Y'' ';
		SET @SQL = @SQL + '      		   ) DD ';
		SET @SQL = @SQL + '       ON AA.DIVISION_ID	= DD.DIVISION_ID ';
		SET @SQL = @SQL + '       AND AA.ITEM_ID = DD.ITEM_ID ';		
		SET @SQL = @SQL + '      WHERE 1 = 1   ';
		SET @SQL = @SQL + '        AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '        AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '        AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '        AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '        AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '        AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '        AND AA.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '        AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'')';
		--SET @SQL = @SQL + '        AND AA.QTY <> 0 ';		-- 2022.11.04 주석처리 :: 저장대상건이 조회되지 않는 오류수정
		SET @SQL = @SQL + '        AND AA.BIZ_TYPE = ''A''';
		SET @SQL = @SQL + '        AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_item_list + ''','',''))';
		SET @SQL = @SQL + '        AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' 
		SET @SQL = @SQL + '      ) AS M ';
		SET @SQL = @SQL + ' PIVOT ( ';
		SET @SQL = @SQL + '		SUM(QTY) FOR YYYYMMDD IN (' + @v_cols + ')';
		SET @SQL = @SQL + '	   ) AS P_RST, ';
		SET @SQL = @SQL + '    SCP_MST_FINAL_ITEM F WITH (NOLOCK) ';
		SET @SQL = @SQL + '  WHERE 0 = 0 ';
		SET @SQL = @SQL + '    AND P_RST.ITEM_ID = F.ITEM_ID ';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ' ORDER BY P.DEPT_NAME_KO, P.ITEM_ID, P.PROJECT_CODE, P.TO_SITE, P.XLS_ORD, P.FROM_SITE '	

		--select @SQL;
		EXEC(@SQL);
	END

END
