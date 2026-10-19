
/*
 * Program ID   : SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL
 * Description  : SCP0113 LONG-TERM STOCK Management PSI Detail
 * Program History
 *===================================================================================================
 * Date         In Charge			Description
 *===================================================================================================
 * 2024/09/13   Haru				Add new procedures to get Long-Term Stock Data for SCP0113 LONG-TERM STOCK Management  PSI Detail
 * 2024/09/25	Quoc Tan (Tanvq1)	Update fixed monthly qty columns to flexiable colums base on plan_date and end_month
 * 2024/11/06	Quoc Tan (Tanvq1)	Add query by division id 
 * 2024/11/14	Quoc Tan (Tanvq1)	Add Long term type column
 * 2025/01/21	OIJ	                srce_tp_cd, item_name, origin_item_name, version_no add
 */

CREATE PROCEDURE [dbo].[SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL]
	@p_plan_date			NVARCHAR(8),
	@p_plan_type			NVARCHAR(100),		
	@p_item_id				NVARCHAR(100),
	@p_end_month			NVARCHAR(6),
	@p_division_id			NVARCHAR(100),
	@p_company_id			NVARCHAR(100),
	@p_plant_id				NVARCHAR(100),
	@debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########'; 
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  
	
	--DECLARE @year INT = CAST(LEFT(@p_plan_date, 4) AS INT);
 --   DECLARE @month INT = CAST(SUBSTRING(@p_plan_date, 5, 2) AS INT) - 1;

	DECLARE @sql NVARCHAR(MAX);
    DECLARE @cols NVARCHAR(MAX);
    DECLARE @start_yyyymm INT;
    DECLARE @end_yyyymm INT;

   -- Extract the year and month from start_date
    SET @start_yyyymm = CAST(LEFT(@p_plan_date, 6) AS INT);
    SET @start_yyyymm = CAST(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, 1, CONVERT(DATETIME, CONCAT(@start_yyyymm , '01'))),112),1,6) AS INT);
    SET @end_yyyymm = CAST(@p_end_month AS INT);

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
	--SET @end_yyyymm = CAST(@p_end_month AS INT);
    -- 2025.01.21 OIJ
    SET @end_yyyymm = CAST(SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, 12, CONVERT(DATETIME, CONCAT(@start_yyyymm , '01'))),112),1,6) AS INT);
    
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
            ', FORMAT(COALESCE(MAX(CASE WHEN PLAN_YYYYMM = ' + CAST(PLAN_YYYYMM AS NVARCHAR(6)) + ' THEN A.QTY END), NULL), ''N2'') AS QTY_' +  --A is SCM_LGTM_MGMT_DETAIL2_V in @sql 
            CAST(ROW_NUMBER() OVER (ORDER BY PLAN_YYYYMM) AS NVARCHAR(10))
        FROM MonthList
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '');	



	
	-- Main Query 
	select @sql = 'SELECT  A.COMPANY_ID,
							A.PLANT_ID,
							A.PLAN_DATE,
							A.DIV,
							A.PLAN_TYPE,
							A.GROUP_CODE,
							A.MATERIAL,
                            A.MATERIAL_DESC,    -- 2025.01.21 OIJ
							A.ORIGIN_MATERIAL,
							A.SORT,
							A.DATA_TP_CD,
                            A.SRCE_TP_CD,       -- 2025.01.21 OIJ
							A.LONG_TERM_TYPE,
                            A.VERSION_NO,       -- 2025.01.21 OIJ
							'+ @cols +',
							FORMAT(COALESCE(SUM(A.QTY),0), ''N2'') AS Total
					FROM  SCM_LGTM_MGMT_DETAIL2_V A
					WHERE 1=1
						AND   A.PLAN_DATE = @p_plan_date
						AND   A.PLAN_TYPE = @p_plan_type
						AND   A.MATERIAL = @p_item_id
						AND	  A.DIV = @p_division_id
						AND	  A.COMPANY_ID = @p_company_id
						AND	  A.PLANT_ID = @p_plant_id
					GROUP BY	A.COMPANY_ID,
								A.PLANT_ID,
								A.PLAN_DATE,
								A.DIV,
								A.PLAN_TYPE,
								A.GROUP_CODE,
								A.MATERIAL,
                                A.MATERIAL_DESC,
								A.ORIGIN_MATERIAL,
								A.SORT,
								A.DATA_TP_CD,
                                A.SRCE_TP_CD,  
								A.LONG_TERM_TYPE,
                                A.VERSION_NO     
					ORDER BY	A.SORT, A.LONG_TERM_TYPE';

	EXEC sp_executesql @sql, N'@p_plan_date			NVARCHAR(8),
								@p_plan_type			NVARCHAR(100),		
								@p_item_id				NVARCHAR(100),
								@p_end_month			NVARCHAR(6),
								@p_division_id			NVARCHAR(100),
								@p_company_id			NVARCHAR(100),
								@p_plant_id			NVARCHAR(100)',

								@p_plan_date,
								@p_plan_type,		
								@p_item_id,
								@p_end_month,
								@p_division_id,
								@p_company_id,
								@p_plant_id	;
								
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------

END

