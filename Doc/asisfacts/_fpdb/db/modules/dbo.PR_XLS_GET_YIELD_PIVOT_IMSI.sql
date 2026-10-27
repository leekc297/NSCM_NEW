
/*
 * Program ID   : PR_XLS_GET_YIELD_PIVOT_IMSI
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.07   FP Pjt.         Create.
 * 2024.11.12   shineuiho67     test 중...
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_YIELD_PIVOT_IMSI] 'UC1', '202408' , '202509', 'Coating,Coating','cathode,anode','#1,#2'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_YIELD_PIVOT_IMSI]
    @p_apl_code             nvarchar(max)  = 'UC1'
,	@p_yyyymm_from			NVARCHAR(MAX)
,	@p_yyyymm_to			NVARCHAR(MAX)
,   @p_ProcessData          NVARCHAR(MAX)  -- 공정 데이터를 ','로 구분한 문자열
,   @p_ElectrodeData        NVARCHAR(MAX)  -- 전극구분 데이터를 ','로 구분한 문자열
,   @p_LineData             NVARCHAR(MAX)  -- 라인 데이터를 ','로 구분한 문자열

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymm_from			nvarchar(max)
	DECLARE @v_yyyymm_to			nvarchar(max)
    DECLARE @v_ProcessData			nvarchar(max)
    DECLARE @v_ElectrodeData	    nvarchar(max)
    DECLARE @v_LineData			    nvarchar(max)
    DECLARE @columns                nvarchar(MAX);
    DECLARE @sql                    nvarchar(MAX);

	set @v_apl_code			= @p_apl_code
	set @v_yyyymm_from		= @p_yyyymm_from --format( convert(datetime, @p_yyyymmdd_rom), 'yyyyMMdd')
	set @v_yyyymm_to		= @p_yyyymm_to --format( convert(datetime, @p_cutoff_date_to), 'yyyyMMdd')
    set @v_ProcessData		= @p_ProcessData
    set @v_ElectrodeData	= @p_ElectrodeData
    set @v_LineData		    = @p_LineData

    
    BEGIN TRY		


        -- 시작일자와 종료일자 계산
        DECLARE @StartYear INT = CAST(LEFT(@v_yyyymm_from, 4) AS INT);
        DECLARE @StartMonth INT = CAST(RIGHT(@v_yyyymm_from, 2) AS INT);
        DECLARE @EndYear INT = CAST(LEFT(@v_yyyymm_to, 4) AS INT);
        DECLARE @EndMonth INT = CAST(RIGHT(@v_yyyymm_to, 2) AS INT);

        DECLARE @StartDate DATE = DATEFROMPARTS(@StartYear, @StartMonth, 1);
        DECLARE @EndDate DATE = EOMONTH(DATEFROMPARTS(@EndYear, @EndMonth, 1));

        if object_id('tempdb..#ProcessTable') is not null
		    drop table #ProcessTable


        -- 공정, 전극구분, 라인 데이터를 임시 테이블에 삽입
        CREATE TABLE #ProcessTable (
            Process NVARCHAR(50),
            Electrode NVARCHAR(50),
            Line NVARCHAR(50)
        );

         
        WITH ProcessCTE AS (
            SELECT value AS Process, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM dbo.fn_splitstring(@v_ProcessData, ',')
        ),
        ElectrodeCTE AS (
            SELECT value AS Electrode, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM dbo.fn_splitstring(@v_ElectrodeData, ',')
        ),
        LineCTE AS (
            SELECT value AS Line, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM dbo.fn_splitstring(@v_LineData, ',')
        )


        -- RowNum을 기준으로 각 데이터를 순차적으로 매칭하여 삽입
        INSERT INTO #ProcessTable (Process, Electrode, Line)
        SELECT p.Process, e.Electrode, l.Line
        FROM ProcessCTE p
        INNER JOIN ElectrodeCTE e ON p.RowNum = e.RowNum
        INNER JOIN LineCTE      l ON p.RowNum = l.RowNum


        -- 확인을 위해 선택 (선택사항)
        --SELECT * FROM #ProcessTable

        -- 기간 내 모든 일자를 열로 변환
        SELECT @columns = STUFF((
            SELECT DISTINCT ',' + QUOTENAME(CONVERT(VARCHAR, DATEADD(DAY, Number, @StartDate), 23))
            FROM (
                SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS Number
                FROM master.dbo.spt_values
            ) AS Numbers
        FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

      
        --set @sql = '
        with with_data as (
             SELECT             
               CASE WHEN Y.OPERATION_ID = 'A5000' THEN 'Notching'
                    WHEN Y.OPERATION_ID = 'A8000' THEN 'L&S'
                    WHEN Y.OPERATION_ID = 'A9000' THEN 'PKG'
                    WHEN Y.OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN Y.OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN Y.OPERATION_ID = 'F6000' THEN 'EOL'
                    ELSE Y.OPERATION_ID
                END as OPERATION_ID	
                ,Y.ELECTRODE_TYPE
                ,REPLACE(CONCAT('#', SUBSTRING( Y.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', Y.LINE_ID), 0), 0) AS INT), 2)),'#0','#') as LINE_ID
                ,FORMAT(CONVERT(DATE, Y.DATE, 112),'yyyy-MM-dd') AS DATE 
                ,Y.YIELD
		    from BUF_SCM_YIELD_M Y WITH(NOLOCK)
       
        )
            SELECT PT.Process
                ,PT.Electrode
                ,PT.Line
                ,ST.plan_date
                ,st.val
             into #before_pivot
            FROM
                (SELECT Process, Electrode, Line from #ProcessTable) AS PT
                LEFT JOIN
                (            
                SELECT
                    [OPERATION_ID]      AS SourceProcess,
                    [ELECTRODE_TYPE]    AS SourceElectrode,
                    [LINE_ID]           AS SourceLine,
                    [DATE]              AS plan_date,
                    SUM(ISNULL([YIELD], 0)) AS val
                FROM  with_data        
                WHERE 1 = 1    
                GROUP BY
                    [OPERATION_ID], [ELECTRODE_TYPE], [LINE_ID], [DATE]
                ) AS ST  
                ON PT.Process       = ST.SourceProcess        
                AND PT.Electrode    = ST.SourceElectrode      
                AND PT.Line         = ST.SourceLine    
				;



        set @sql = '
        SELECT ' + @columns + '
         FROM #before_pivot as WD
            PIVOT
            (              
                SUM(val)
                FOR plan_date IN ( ' + @columns + ' )      
            ) PVT
            order by 
               CASE WHEN PVT.Process = ''Notching'' THEN ''4''
                    WHEN PVT.Process = ''L&S''      THEN ''3''
                    WHEN PVT.Process = ''PKG''      THEN ''2''
                    WHEN PVT.Process = ''Coating''  THEN ''5''
                    WHEN PVT.Process = ''R/P''      THEN ''9''
                    WHEN PVT.Process = ''EOL''      THEN ''1''
                    ELSE ''99''
                    END 
                 
                ,CASE WHEN PVT.Electrode     = ''Anode''   THEN ''1''
                        WHEN PVT.Electrode   = ''Cathode'' THEN ''2''
                        ELSE ''3''                                               
                        END 
                ,cast(SUBSTRING( PVT.Line, CAST(ISNULL(NULLIF(PATINDEX(''%[0-9]%'', PVT.Line), 0), 0) AS INT), 2) as int) ;  ';


        --PRINT CAST(@sql AS NTEXT);

        -- 동적으로 생성된 SQL 실행
        EXEC sp_executesql @sql, N'@StartDate DATE, @EndDate DATE', @StartDate, @EndDate;

        -- 임시 테이블 삭제
        DROP TABLE #ProcessTable;

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

        if object_id('tempdb..#ProcessTable') is not null
		    drop table #ProcessTable
        	
	END CATCH

    if object_id('tempdb..#ProcessTable') is not null
	    drop table #ProcessTable
END



/*

exec [dbo].[PR_XLS_GET_YIELD_PIVOT_IMSI] 'UC1', '202408' , '202409', 'Coating,Coating','cathode,anode','#1,#2'

*/
