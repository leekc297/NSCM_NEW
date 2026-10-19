

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

CREATE PROCEDURE [dbo].[SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_BACKUP]
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

    -- Extract the year and month from start_date
    --SET @start_yyyymm = CAST(LEFT(@p_plan_date, 6) AS INT);
	IF OBJECT_ID('tempdb..#ResultTable') IS NOT NULL 
		DROP TABLE #ResultTable
	CREATE TABLE #ResultTable (EndingInvMonth NVARCHAR(6));

	-- Execute the procedure and insert the result into the table
	INSERT INTO #ResultTable
	EXEC dbo.SCP0113_GET_BASE_MONTH @p_plan_date;

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
            ', COALESCE(MAX(CASE WHEN PLAN_YYYYMM = ' + CAST(PLAN_YYYYMM AS NVARCHAR(6)) + ' THEN B.QTY END), NULL) AS QTY_' +  --B is SCP_ANL_LGTM_INV_MGMT_PLAN table in @sql 
            CAST(ROW_NUMBER() OVER (ORDER BY PLAN_YYYYMM) AS NVARCHAR(10))
        FROM MonthList
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '');	


		
	SET @sql = N'
	IF OBJECT_ID(''tempdb..#Temp_MGMT_PLAN_Last_Update'') IS NOT NULL 
		DROP TABLE #Temp_MGMT_PLAN_Last_Update

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
	Into #Temp_MGMT_PLAN_Last_Update
	from SCP_ANL_LGTM_INV_MGMT_PLAN
	Where 1=1       
	AND PLAN_START_YYYYMMDD = @p_plan_date
	AND ( ISNULL(@p_division_id, '''') = '''' OR DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,'','')) )
	AND ( ISNULL(@p_item_id	, '''')	= '''' OR ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,'','')) )
	AND PLAN_YYYYMM           >= @start_yyyymm
	AND PLAN_YYYYMM			<=  @p_end_month
	AND ( ISNULL(@p_plant_id	, '''')	= '''' OR PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id,'','')) )
	
	
	IF OBJECT_ID(''tempdb..#CUR'') IS NOT NULL 
		DROP TABLE #CUR
	SELECT YYYYMM, WAERS, MAX(EX_TO_BAMT)  AS EX_TO_BAMT		
	INTO #CUR
								  FROM   SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)			
								  WHERE  YYYYMM >= SUBSTRING(CONVERT(NVARCHAR, GETDATE()-180,112),1,6)			
								  AND    WAERS = ''USD''		
								  GROUP BY YYYYMM, WAERS
				

				SELECT
					   A.PLAN_DATE
					  ,A.BASE_YYYYMM
					  ,A.END_MONTH
					  ,A.DIV
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
					  ,B.IMPU_DEPT_NM
					  ,C.ATTRIBUTE1 AS OCCR_RSN_CD
					  ,B.OCCR_RSN_CTN
					  ,D.ATTRIBUTE1 AS EXHT_TP_CD
					  ,B.EXHT_TP_CTN
					  ,' + @cols + '
					  ,E.LAST_UPDATED_BY        AS USER_ID
       				  ,E.LAST_UPDATE_DATE   AS UPDATE_DATE

					FROM SCM_LGTM_MGMT_V A

					LEFT JOIN SCP_ANL_LGTM_INV_MGMT_PLAN B WITH(NOLOCK)
					ON  B.PLAN_START_YYYYMMDD = A.PLAN_DATE
					AND B.PLAN_TP_CD			= A.PLAN_TP_CD
					AND B.DATA_TP_CD			= A.DATA_TP_CD
					AND B.SRCE_TP_CD			= A.SRCE_TP_CD
					AND B.DIVISION_ID			= A.DIV
					AND B.PLANT_ID				= A.PLANT_ID
					AND B.ITEM_ID				= A.ITEM_ID
					AND B.PLAN_YYYYMM           >= @start_yyyymm
					AND B.PLAN_YYYYMM			<=  @p_end_month					

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
					  AND E.RowNumber = 1


					WHERE 1=1
					AND A.PLAN_DATE = @p_plan_date
					AND ( ISNULL(@p_division_id, '''') = '''' OR A.DIV	IN (SELECT token FROM dbo.String_Split(@p_division_id,'','')) )
					AND ( ISNULL(@p_creation_type, '''') = '''' OR A.CREATION_TYPE	IN (SELECT token FROM dbo.String_Split(@p_creation_type,'','')) )
					AND ( ISNULL(@p_group_code, '''')	= '''' OR A.GROUP_CODE IN (SELECT token FROM dbo.String_Split(@p_group_code,'','')) )
					AND ( ISNULL(@p_item_type, '''')	= '''' OR A.ITEM_TYPE	 IN (SELECT token FROM dbo.String_Split(@p_item_type,'','')) )
					AND ( ISNULL(@p_item_id	, '''')	= '''' OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,'','')) )
					AND A.END_MONTH = @p_end_month
					AND ( ISNULL(@p_plant_id	, '''')	= '''' OR A.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id,'','')) )
                     
                    AND A.LONG_TERM_QTY >= 0
					GROUP BY   A.PLAN_DATE
							  ,A.BASE_YYYYMM
							  ,A.END_MONTH
							  ,A.DIV
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
							  ,B.IMPU_DEPT_NM
							  ,C.ATTRIBUTE1 
							  ,B.OCCR_RSN_CTN
							  ,D.ATTRIBUTE1
							  ,B.EXHT_TP_CTN
							  ,E.LAST_UPDATED_BY  
							  ,E.LAST_UPDATE_DATE

					ORDER BY  A.PLAN_DATE
							  ,A.BASE_YYYYMM
							  ,A.END_MONTH
							  ,A.DIV
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
							  ,A.ITEM_NAME;' 	
			  
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
							
END

