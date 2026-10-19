



/*
 * Program ID   : SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN
 * Description  : SCP0113 LONG-TERM STOCK Management Main View
 * Program History
 *===================================================================================================
 * Date         In Charge			Description
 *===================================================================================================
 * 2024/09/13   Quoc Tan (Tanvq1)    Add new procedures to get Long-Term Stock Data for SCP0113 LONG-TERM STOCK Management Main View
 * 2024/09/25	Quoc Tan (Tanvq1)	 Update fixed monthly qty columns to flexiable colums base on plan_date and end_month
 * 2024/09/30	Haru				 Add Search by Plant Id
 * 2024/10/22	Haru				 Add new Column REMAIN_AMT
 * 2024/10/30	Quoc Tan (Tanvq1)	 Add new Column BASE_YYYYMM
 * 2024/11/15	Quoc Tan (Tanvq1)	 Add new Column EX_TO_BAMT, USD_AMT, REMAIN_AMT_USD
 * 2024/11/20	Quoc Tan (Tanvq1)	 Add new Column PIC, USER_ID, UPDATE_DATE
 * 2024/11/29	Quoc Tan (Tanvq1)	 Add new Column MIN_EXHT_YYYYMM, IMPU_DEPT_NM, 
 * 2024/11/29	Haru				 Add new Column REMAIN_LONG_TERM_QTY, REMAIN_LONG_TERM_EXPECT_QTY 
 * 2025/01/20   OIJ					 Add new Column NEW_LONG_TERM_EXPECT_QTY, NEW_LONG_TERM_EXPECT_AMT, NORMAL_QTY, RESULT_PRICE, RESULT_NORMAL_QTY, RESULT_LONG_TERM_EXPECT_QTY, RESULT_LONG_TERM_QTY, RESULT_LONG_TERM_AMT
 */		

-- EXEC [SCP0113_GET_LGTM_PLAN_MAIN_DATA_FOR_N] '20250331', '', '', '', '','ACEP2065I-B1', '202506' , ''

CREATE PROCEDURE [dbo].[SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN]
	@p_plan_date			NVARCHAR(8),
	@p_division_id			NVARCHAR(500),	
	@p_creation_type		NVARCHAR(500),
	@p_group_code			NVARCHAR(500),
	@p_item_type			NVARCHAR(500),
	@p_item_id				NVARCHAR(500),
	@p_end_month			NVARCHAR(6),
	@p_plant_id				NVARCHAR(500),
	@debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	--DECLARE @year INT = CAST(LEFT(@p_plan_date, 4) AS INT);
 --   DECLARE @month INT = CAST(SUBSTRING(@p_plan_date, 5, 2) AS INT) - 1;
	DECLARE @sql NVARCHAR(MAX);
    DECLARE @cols NVARCHAR(MAX);
    DECLARE @start_yyyymm INT;
    DECLARE @end_yyyymm INT;
	DECLARE @EDIT_PERID INT;

    -- Extract the year and month from start_date
    --SET @start_yyyymm = CAST(LEFT(@p_plan_date, 6) AS INT);
	IF OBJECT_ID('tempdb..#ResultTable') IS NOT NULL 
		DROP TABLE #ResultTable
	CREATE TABLE #ResultTable (EndingInvMonth NVARCHAR(6));

	-- Execute the procedure and insert the result into the table
	INSERT INTO #ResultTable
	EXEC dbo.SCP0113_GET_BASE_MONTH @p_plan_date;


	IF OBJECT_ID('tempdb..#StdTempTable') IS NOT NULL 
		DROP TABLE #StdTempTable

	CREATE TABLE #StdTempTable (
				PLAN_DATE				NVARCHAR(50)
				, END_MONTH				NVARCHAR(50)
				, DIV				NVARCHAR(50)
				, COMPANY_ID				NVARCHAR(50)
				, PLANT_ID				NVARCHAR(50)
				, PLAN_TP_CD				NVARCHAR(50)
				, DATA_TP_CD				NVARCHAR(50)
				, SRCE_TP_CD				NVARCHAR(50)
				, ITEM_TYPE				NVARCHAR(50)
				, CREATION_TYPE				NVARCHAR(50)
				, GROUP_CODE				NVARCHAR(50)
				, MKT_DEPT				NVARCHAR(50)
				, END_CUSTOMER				NVARCHAR(300)
				, ITEM_ID				NVARCHAR(50)
				, ITEM_NAME				NVARCHAR(150)
				, UOM				NVARCHAR(50)
				, RTF				NVARCHAR(50)
				, PRICE   				numeric(38, 6)
				, AMT				numeric(38, 6)
				, TOTAL				numeric(38, 6)
				, LONG_TERM_QTY				numeric(38, 6)
				, LONG_TERM_EXPECT_QTY				numeric(38, 6)
				, NEW_LONG_TERM_EXPECT_QTY				numeric(38, 6)
				, NEW_LONG_TERM_EXPECT_AMT				numeric(38, 6)
				, NORMAL_QTY				numeric(38, 6)
				, RESULT_PRICE				numeric(38, 6)
				, RESULT_NORMAL_QTY				numeric(38, 6)
				, RESULT_LONG_TERM_EXPECT_QTY				numeric(38, 6)
				, RESULT_LONG_TERM_QTY				numeric(38, 6)
				, RESULT_LONG_TERM_AMT				numeric(38, 6)
				, BASE_YYYYMM				NVARCHAR(50)
				, PIC				NVARCHAR(50)
				, MIN_EXHT_YYYYMM				NVARCHAR(50)
				);

	--SELECT  @EDIT_PERID = SEGMENT1
	--FROM   SCM_ADM_LOOKUP_MASTER_DETAIL SAD
	--WHERE  LOOKUP_TYPE = 'SCM_LGTM_PLAN_EDIT_PERIOD' AND VALID_YN = 'Y'

	----UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
	----SET SEGMENT1 = 60
	----WHERE  LOOKUP_TYPE = 'SCM_LGTM_PLAN_EDIT_PERIOD' AND VALID_YN = 'Y'

	--IF GETDATE() - DATEADD(DAY, @EDIT_PERID, CONVERT(DATETIME, @p_plan_date)) < 0
	--	BEGIN --EDITABLE
	--		INSERT INTO #StdTempTable
	--		EXEC dbo.[SCP0113_GET_LGTM_PLAN_MAIN_DATA] @p_plan_date, @p_division_id, @p_group_code, @p_item_id, @p_end_month
	--	END
	--ELSE
		BEGIN
			INSERT INTO #StdTempTable
			EXEC dbo.[SCP0113_GET_LGTM_PLAN_MAIN_DATA_FOR_N] @p_plan_date, @p_division_id, @p_group_code, @p_item_id, @p_end_month
		END

	--INSERT INTO #StdTempTable
	--EXEC dbo.[SCP0113_GET_LGTM_PLAN_MAIN_DATA] @p_plan_date, @p_division_id, @p_group_code, @p_item_id, @p_end_month

	-- Extract the value from the result table and assign it to the variable
	SELECT @start_yyyymm = CAST(EndingInvMonth AS INT)
	FROM #ResultTable;	
	
	-- SET @start_yyyymm = @start_yyyymm + 1;
    SET @start_yyyymm = CAST(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, 1, CONVERT(DATETIME, CONCAT(@start_yyyymm , '01'))),112),1,6) AS INT);
	SET @end_yyyymm = CAST(@p_end_month AS INT);

    -- Generate dynamic column names based on the date range
	WITH MonthList AS (
        SELECT CAST(@start_yyyymm AS INT) AS PLAN_YYYYMM
        UNION ALL
        SELECT 
            CASE 
                WHEN (PLAN_YYYYMM % 100) < 12 THEN PLAN_YYYYMM + 1 
                ELSE ((PLAN_YYYYMM / 100) + 1) * 100 + 1  -- Increment year and reset month
            END
        FROM MonthList
        WHERE PLAN_YYYYMM < @end_yyyymm
    )
    select @cols = STUFF((
        SELECT 
            ', COALESCE(MAX(CASE WHEN B.PLAN_YYYYMM = ''' + CAST(PLAN_YYYYMM AS NVARCHAR(6)) + ''' AND B.EDIT_TYPE = ''0'' THEN B.QTY WHEN F.PLAN_YYYYMM = ''' + CAST(PLAN_YYYYMM AS NVARCHAR(6)) + ''' AND F.EDIT_TYPE = ''1'' THEN F.QTY ELSE 0 END), NULL) AS QTY_' +  
            CAST(ROW_NUMBER() OVER (ORDER BY PLAN_YYYYMM) AS NVARCHAR(10)) + char(13) + char(10) 
        FROM MonthList
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '');	

	IF OBJECT_ID('tempdb..#Temp_INV_MGMT_PLAN') IS NOT NULL 
		DROP TABLE #Temp_INV_MGMT_PLAN

	SELECT *
	Into #Temp_INV_MGMT_PLAN
	FROM(
	SELECT COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, PLAN_TP_CD, '' AS DATA_TP_CD, '' AS SRCE_TP_CD, DIVISION_ID, ITEM_ID, 'OCCR_RSN_01' AS OCCR_RSN_CD,
	   OCCR_RSN_CTN, EXHT_TP_CD, EXHT_TP_CTN, '' AS IMPU_DEPT_NM, SUBSTRING(PLAN_YYYYMMDD,1,6) AS PLAN_YYYYMM, QTY, '1' AS EDIT_TYPE
	 FROM SCP_ANL_LGTM_PCY_INV_MGMT_PLAN P WITH(NOLOCK)
    WHERE PLAN_TP_CD = 'S'
	UNION ALL	
	SELECT B.COMPANY_ID, B.PLANT_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TP_CD, B.DATA_TP_CD, B.SRCE_TP_CD, B.DIVISION_ID,  B.ITEM_ID, B.OCCR_RSN_CD,
									B.OCCR_RSN_CTN, B.EXHT_TP_CD, B.EXHT_TP_CTN, B.IMPU_DEPT_NM, B.PLAN_YYYYMM, B.QTY, '0' AS EDIT_TYPE
	 FROM  SCP_ANL_LGTM_INV_MGMT_PLAN B
	LEFT JOIN (SELECT COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD,  DIVISION_ID, ITEM_ID, SUM(ISNULL(QTY, 0)) AS TOT_QTY FROM SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
				GROUP BY COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD,  DIVISION_ID, ITEM_ID) X
	 ON B.ITEM_ID = X.ITEM_ID
	AND B.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
	AND B.PLANT_ID = X.PLANT_ID
	AND B.DIVISION_ID = X.DIVISION_ID
	AND B.COMPANY_ID = X.COMPANY_ID
	WHERE X.TOT_QTY IS NULL
	AND B.PLAN_START_YYYYMMDD = @p_plan_date
	AND PLAN_YYYYMM <= @end_yyyymm
	)A
	WHERE 1=1
	AND A.PLAN_START_YYYYMMDD = @p_plan_date
	AND ( ISNULL(@p_division_id, '') = '' OR A.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
	AND ( ISNULL(@p_item_id	, '')	= '' OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	AND ( ISNULL(@p_plant_id, '')	= '' OR A.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )			

	IF OBJECT_ID('tempdb..#Temp_MGMT_PLAN_Last_Update') IS NOT NULL 
		DROP TABLE #Temp_MGMT_PLAN_Last_Update

	SELECT * 
		Into #Temp_MGMT_PLAN_Last_Update
	FROM(
	SELECT	
	   PLAN_START_YYYYMMDD
      ,PLAN_TP_CD
      ,DATA_TP_CD
      ,SRCE_TP_CD
      ,DIVISION_ID
      ,PLANT_ID
      ,ITEM_ID
      ,OCCR_RSN_CD
      ,OCCR_RSN_CTN
      ,EXHT_TP_CD
      ,EXHT_TP_CTN
	  ,LAST_UPDATED_BY
      ,LAST_UPDATE_DATE
	  ,ROW_NUMBER() OVER (PARTITION BY  PLAN_START_YYYYMMDD
						  ,PLAN_TP_CD
						  ,DATA_TP_CD
						  ,SRCE_TP_CD
						  ,DIVISION_ID
						  ,PLANT_ID
						  ,ITEM_ID
						  ,OCCR_RSN_CD
						  ,OCCR_RSN_CTN
						  ,EXHT_TP_CD
						  ,EXHT_TP_CTN ORDER BY LAST_UPDATE_DATE desc) AS RowNumber
	from SCP_ANL_LGTM_INV_MGMT_PLAN
	Where 1=1       
	AND PLAN_START_YYYYMMDD = @p_plan_date
	AND ( ISNULL(@p_division_id, '') = '' OR DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
	AND ( ISNULL(@p_item_id	, '')	= '' OR ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	AND PLAN_YYYYMM           >= @start_yyyymm
	AND PLAN_YYYYMM			<=  @p_end_month
	AND ( ISNULL(@p_plant_id	, '')	= '' OR PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
	) G
	WHERE G.ROWNUMBER = 1

	IF OBJECT_ID('tempdb..#CUR') IS NOT NULL 
		DROP TABLE #CUR

	SELECT YYYYMM, WAERS, MAX(EX_TO_BAMT)  AS EX_TO_BAMT		
	INTO #CUR
								  FROM   SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)			
								  WHERE  YYYYMM >= SUBSTRING(CONVERT(NVARCHAR, GETDATE()-180,112),1,6)			
								  AND    WAERS = 'USD'		
								  GROUP BY YYYYMM, WAERS
				

	SET @sql = 'SELECT
					   A.PLAN_DATE
					  ,A.BASE_YYYYMM
					  ,A.END_MONTH
					  ,A.DIV
					  ,A.COMPANY_ID
					  ,A.PLANT_ID
					  ,A.PLAN_TP_CD
					  ,A.DATA_TP_CD
					  ,A.SRCE_TP_CD
					  ,A.ITEM_TYPE
					  ,A.CREATION_TYPE
					  ,A.GROUP_CODE
					  ,A.MKT_DEPT
					  ,A.END_CUSTOMER
					  ,A.ITEM_ID
					  ,A.ITEM_NAME
					  ,A.UOM
					  ,A.PIC
					  ,A.RTF
					  ,A.PRICE
					  ,A.AMT
					  ,CUR.EX_TO_BAMT				
					  ,A.AMT / CUR.EX_TO_BAMT AS USD_AMT	
					  --Calculate Remain Value
					  ,A.TOTAL -  COALESCE(SUM(B.QTY),0) AS REMAIN
					  ,CASE
							WHEN (A.LONG_TERM_QTY - COALESCE(SUM(B.QTY),0)) > 0 THEN A.LONG_TERM_QTY - COALESCE(SUM(B.QTY),0)
							ELSE 0
						END AS REMAIN_LONG_TERM_QTY 
					  ,CASE
						   WHEN (A.LONG_TERM_QTY - COALESCE(SUM(B.QTY),0)) > 0 THEN A.LONG_TERM_EXPECT_QTY
						   ELSE A.LONG_TERM_QTY +  A.LONG_TERM_EXPECT_QTY -  COALESCE(SUM(B.QTY),0)
						END AS REMAIN_LONG_TERM_EXPECT_QTY 
					  ,(A.TOTAL -  COALESCE(SUM(B.QTY),0)) * A.PRICE AS REMAIN_AMT
					  ,(A.TOTAL -  COALESCE(SUM(B.QTY),0)) * A.PRICE / CUR.EX_TO_BAMT AS REMAIN_AMT_USD
					  ,A.TOTAL
					  ,A.LONG_TERM_QTY
					  ,A.LONG_TERM_EXPECT_QTY
                      -- 2025.01.05 oij
                      ,A.NEW_LONG_TERM_EXPECT_QTY
                      ,A.NEW_LONG_TERM_EXPECT_AMT  
					  ,A.NORMAL_QTY
					  ,A.RESULT_PRICE
					  ,A.RESULT_NORMAL_QTY
					  ,A.RESULT_LONG_TERM_EXPECT_QTY
					  ,A.RESULT_LONG_TERM_QTY
					  ,A.RESULT_LONG_TERM_AMT
                      -- 2025.01.05 oij
					  ,A.MIN_EXHT_YYYYMM
					  ,CASE WHEN F.EDIT_TYPE = 1 THEN F.IMPU_DEPT_NM ELSE B.IMPU_DEPT_NM END IMPU_DEPT_NM
					  ,C.ATTRIBUTE1 AS OCCR_RSN_CD
					  ,CASE WHEN F.EDIT_TYPE = 1 THEN MAX(F.OCCR_RSN_CTN) ELSE MAX(B.OCCR_RSN_CTN) END  OCCR_RSN_CTN
					  ,MAX(D.ATTRIBUTE1) AS EXHT_TP_CD
					  ,CASE WHEN F.EDIT_TYPE = 1 THEN MAX(F.EXHT_TP_CTN) ELSE MAX(B.EXHT_TP_CTN) END  EXHT_TP_CTN
					  ,' + @cols + '
					  ,E.LAST_UPDATED_BY        AS USER_ID
       				  ,E.LAST_UPDATE_DATE   AS UPDATE_DATE
					  ,IIF(B.EDIT_TYPE IS NOT NULL, B.EDIT_TYPE, F.EDIT_TYPE) AS EDIT_TYPE

					FROM #StdTempTable A

					LEFT JOIN #Temp_INV_MGMT_PLAN B
					ON  B.PLAN_START_YYYYMMDD   = A.PLAN_DATE
					AND B.SRCE_TP_CD			= A.SRCE_TP_CD
					AND B.DATA_TP_CD			= A.DATA_TP_CD
					AND B.DIVISION_ID			= A.DIV
					AND B.PLANT_ID				= A.PLANT_ID
					AND B.ITEM_ID				= A.ITEM_ID
					--AND B.PLAN_YYYYMM			= A.END_MONTH
					AND B.COMPANY_ID			= A.COMPANY_ID
					AND B.PLANT_ID				= A.PLANT_ID
					AND B.EDIT_TYPE = ''0''

					LEFT JOIN #Temp_INV_MGMT_PLAN F
					ON  F.PLAN_START_YYYYMMDD   = A.PLAN_DATE
					AND F.DIVISION_ID			= A.DIV
					AND F.PLANT_ID				= A.PLANT_ID
					AND F.ITEM_ID				= A.ITEM_ID
					AND F.SRCE_TP_CD			= ''''
					AND F.DATA_TP_CD			= ''''
					AND F.EDIT_TYPE = ''1''

					LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
					ON C.SEGMENT1 = B.OCCR_RSN_CD
                    AND C.LOOKUP_TYPE = ''SCM_LGTM_OCCR_RSN_CD''

					LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
					ON D.SEGMENT1 = B.EXHT_TP_CD
                    AND D.LOOKUP_TYPE = ''SCM_LGTM_EXHT_TP_CD''

					LEFT OUTER JOIN #CUR  CUR WITH(NOLOCK)			
					ON A.BASE_YYYYMM = CUR.YYYYMM		
					
					LEFT JOIN #Temp_MGMT_PLAN_Last_Update E
					ON B.PLAN_START_YYYYMMDD = E.PLAN_START_YYYYMMDD
					  AND B.PLAN_TP_CD = E.PLAN_TP_CD
					  AND B.DATA_TP_CD = E.DATA_TP_CD
					  AND B.SRCE_TP_CD = E.SRCE_TP_CD
					  AND B.DIVISION_ID = E.DIVISION_ID
					  AND B.PLANT_ID = E.PLANT_ID
					  AND B.ITEM_ID = E.ITEM_ID
					  AND B.OCCR_RSN_CD = E.OCCR_RSN_CD
					  AND B.OCCR_RSN_CTN = E.OCCR_RSN_CTN
					  AND B.EXHT_TP_CD = E.EXHT_TP_CD
					  AND B.EXHT_TP_CTN = E.EXHT_TP_CTN

					WHERE 1=1
					AND A.PLAN_DATE = @p_plan_date
					AND ( ISNULL(@p_division_id, '''') = '''' OR A.DIV	IN (SELECT token FROM dbo.String_Split(@p_division_id,'','')) )
					AND ( ISNULL(@p_creation_type, '''') = '''' OR A.CREATION_TYPE	IN (SELECT token FROM dbo.String_Split(@p_creation_type,'','')) )
					AND ( ISNULL(@p_group_code, '''')	= '''' OR A.GROUP_CODE IN (SELECT token FROM dbo.String_Split(@p_group_code,'','')) )
					AND ( ISNULL(@p_item_type, '''')	= '''' OR A.ITEM_TYPE	 IN (SELECT token FROM dbo.String_Split(@p_item_type,'','')) )
					AND ( ISNULL(@p_item_id	, '''')	= '''' OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,'','')) )
					--AND A.END_MONTH = @p_end_month
					AND ( ISNULL(@p_plant_id	, '''')	= '''' OR A.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id,'','')) )
                     
                    AND A.LONG_TERM_QTY >= 0
					GROUP BY   A.PLAN_DATE, A.BASE_YYYYMM, A.END_MONTH, A.DIV, A.COMPANY_ID, A.PLANT_ID, A.PLAN_TP_CD, A.DATA_TP_CD
							  ,A.SRCE_TP_CD, A.ITEM_TYPE, A.CREATION_TYPE, A.GROUP_CODE, A.MKT_DEPT, A.END_CUSTOMER
							  ,A.ITEM_ID, A.ITEM_NAME, A.UOM, A.PIC, A.RTF, A.PRICE, A.AMT
							  ,CUR.EX_TO_BAMT	
							  ,A.TOTAL
							  ,A.LONG_TERM_QTY
							  ,A.LONG_TERM_EXPECT_QTY
                              ,A.NEW_LONG_TERM_EXPECT_QTY
                              ,A.NEW_LONG_TERM_EXPECT_AMT   
							  ,A.NORMAL_QTY
							  ,A.RESULT_PRICE
							  ,A.RESULT_NORMAL_QTY
							  ,A.RESULT_LONG_TERM_EXPECT_QTY
							  ,A.RESULT_LONG_TERM_QTY
							  ,A.RESULT_LONG_TERM_AMT
							  ,A.MIN_EXHT_YYYYMM
							  ,CASE WHEN F.EDIT_TYPE = 1 THEN F.IMPU_DEPT_NM ELSE B.IMPU_DEPT_NM END
							  ,C.ATTRIBUTE1 
							  ,E.LAST_UPDATED_BY  
							  ,E.LAST_UPDATE_DATE
							  ,F.EDIT_TYPE
							  ,IIF(B.EDIT_TYPE IS NOT NULL, B.EDIT_TYPE, F.EDIT_TYPE) 
					ORDER BY  A.PLAN_DATE
							  ,A.BASE_YYYYMM
							  ,A.END_MONTH
							  ,A.DIV
							  ,A.COMPANY_ID
							  ,A.PLANT_ID
							  ,A.PLAN_TP_CD
							  ,A.DATA_TP_CD
							  ,A.SRCE_TP_CD
							  ,A.ITEM_TYPE
							  ,A.CREATION_TYPE
							  ,A.GROUP_CODE
							  ,A.MKT_DEPT
							  ,A.END_CUSTOMER
							  ,A.ITEM_ID
							  ,A.ITEM_NAME'
 	
                PRINT LEN(@sql);
			  PRINT SUBSTRING(@sql, 1, 8000);

	EXEC sp_executesql @sql, N'@p_plan_date			NVARCHAR(8),
								@p_division_id			NVARCHAR(500),	
								@p_creation_type		NVARCHAR(500),
								@p_group_code			NVARCHAR(500),
								@p_item_type			NVARCHAR(500),
								@p_item_id				NVARCHAR(500),
								@p_end_month			NVARCHAR(6),
								@p_plant_id				NVARCHAR(500),
								@start_yyyymm			NVARCHAR(6)' ,
							@p_plan_date,
							@p_division_id,	
							@p_creation_type,
							@p_group_code,
							@p_item_type,
							@p_item_id,
							@p_end_month,
							@p_plant_id, 
							@start_yyyymm;

	DROP TABLE #ResultTable
	DROP TABLE #Temp_MGMT_PLAN_Last_Update
	DROP TABLE #Temp_INV_MGMT_PLAN
							
END

