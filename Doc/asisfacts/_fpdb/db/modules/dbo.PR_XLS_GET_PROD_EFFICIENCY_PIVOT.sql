
/*
 * Program ID   : PR_XLS_GET_PROD_EFFICIENCY_PIVOT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.11   FP Pjt.         Create.
 * 2024.10.18   shineuiho67     * 100 : 주석 처리 
 * 2024.12.19   shineuiho67     Round(x,4) 처리.
 * 2024.12.19   shineuiho67     데이터 표시 종료일자수정(파라메터 @p_yyyymm_to 무시하고 425일을 더해서 capa 시트의 데이터 표시 열수에 맞춘다.)
 *
 ex) 
   exec [dbo].[PR_XLS_GET_PROD_EFFICIENCY_PIVOT] 'UC1', '202407' , '202508', 'Coating,Coating','Cathode,Anode','#1,#2'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_PROD_EFFICIENCY_PIVOT]
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

    declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)
    
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
        --DECLARE @EndDate DATE = EOMONTH(DATEFROMPARTS(@EndYear, @EndMonth, 1));
        DECLARE @EndDate DATE = DATEADD(DAY, 425, DATEFROMPARTS(@StartYear, @StartMonth, 1));

        if object_id('tempdb..#ProcessTable') is not null
		drop table #ProcessTable

        if object_id('tempdb..#query_result') is not null
		drop table #query_result


        -- 공정, 전극구분, 라인 데이터를 임시 테이블에 삽입
        CREATE TABLE #ProcessTable (
            Process NVARCHAR(50),
            Electrode NVARCHAR(50),
            Line NVARCHAR(50)
        );

        create table #query_result (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, OPERATION_ID 				nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ELECTRODE_TYPE 			nvarchar(30)
			, PLAN_MONTH 				nvarchar(10)
			, value						numeric(20, 10)
			)
			;

         
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


        select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'

       -- CAPA_UI_LOSS_TYPE_DEFINIT : No-Run / Wait
	   insert into #query_result
			(
			  COMPANY_ID
			, DIVISION_ID 
			, SITE_ID 
			, PLANT_ID
			, FACTORY_ID 
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, PLAN_MONTH 		
			, value    
			)

			SELECT YYY.COMPANY_ID  
		       	, YYY.DIVISION_ID 
		       	, YYY.SITE_ID     
		       	, YYY.PLANT_ID    
		       	, YYY.FACTORY_ID  
		       	, YYY.OPERATION_ID
		       	, YYY.LINE_ID     
		       	, YYY.ELECTRODE_TYPE 
		       	, YYY.WORK_MONTH AS PLAN_MONTH
				, round(1.0 - YYY.LOSS_RATE,4) as value  
			 FROM SCM_LOSS_M as YYY WITH(NOLOCK)
			where 1 = 1
			  and yyy.company_id		= @v_company_id
			  and yyy.division_id		= @v_division_id
			  and yyy.site_id			= @v_site_id
			  and yyy.plant_id		IN (@v_plant_id, @v_elec_plant_id)
			  and yyy.operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
			  and yyy.loss_code = 'EL019'
			  AND yyy.work_month  between @v_yyyymm_from and @v_yyyymm_to

	   --
	   insert into #query_result
			(
			  COMPANY_ID
			, DIVISION_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, PLAN_MONTH 		
			, value     
			)
	   select 
		      X.COMPANY_ID
			, X.DIVISION_ID
			, X.SITE_ID
			, X.PLANT_ID
			, X.FACTORY_ID
			, X.OPERATION_ID
			, X.LINE_ID
			, X.ELECTRODE_TYPE
			, X.PLAN_MONTH		
			, 0 
		 from (
				SELECT B.COMPANY_ID        
			         , B.DIVISION_ID 		
			         , B.SITE_ID 			
			         , B.PLANT_ID 			
			         , B.FACTORY_ID 		
			         , B.OPERATION_ID 		
			         , B.LINE_ID 			
			         , B.ELECTRODE_TYPE 
					 , A.PLAN_MONTH
					FROM (
						SELECT distinct yyyymm as plan_month
						FROM TH_UIS_CAL AS C WITH(NOLOCK)
						WHERE 1 = 1
							AND C.yyyymm >= @v_yyyymm_from
							AND C.yyyymm <= @v_yyyymm_to
						) A,
						(
						 SELECT COMPANY_ID        
			                  , DIVISION_ID 		
			                  , SITE_ID 			
			                  , PLANT_ID 			
			                  , FACTORY_ID 		
			                  , OPERATION_ID 		
			                  , LINE_ID 			
			                  , ELECTRODE_TYPE 
						   FROM [dbo].[SCM_LINE_M] AS X 
						  where active_flag = 'Y'
						    and operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
				            and company_id		= @v_company_id
				            and division_id		= @v_division_id
				            and site_id			= @v_site_id
				            and plant_id IN (@v_plant_id, @v_elec_plant_id)

						) B
		      ) as x
		WHERE 1 = 1
		  AND NOT EXISTS (
						  SELECT 'X'
						    FROM #query_result AS Z 
						   WHERE 1 = 1
						     AND Z.COMPANY_ID        	= x.COMPANY_ID        
						     AND Z.DIVISION_ID 			= x.DIVISION_ID 		
						     AND Z.SITE_ID 				= x.SITE_ID 			
						     AND Z.PLANT_ID 			= x.PLANT_ID 			
						     AND Z.FACTORY_ID 			= x.FACTORY_ID 		
						     AND Z.OPERATION_ID 		= x.OPERATION_ID 		
						     and z.LINE_ID 				= x.LINE_ID 			
						     and z.ELECTRODE_TYPE 		= x.ELECTRODE_TYPE 
						     and z.PLAN_MONTH			= x.PLAN_MONTH
			             )
			;
        
        --select * from #ProcessTable
        --select * from #query_result

        set @sql = '
      
        SELECT ' + @columns + '
         FROM (

            SELECT PT.Process
                ,PT.Electrode
                ,PT.Line
                ,ST.plan_date
                ,st.val
            FROM
                (SELECT Process, Electrode, Line from #ProcessTable) AS PT
                LEFT JOIN
                (            
                SELECT
                    CASE WHEN OPERATION_ID = ''A5000'' THEN ''Notching''
                        WHEN OPERATION_ID = ''A8000'' THEN ''L&S''
                        WHEN OPERATION_ID = ''A9000'' THEN ''PKG''
                        WHEN OPERATION_ID = ''E2000'' THEN ''Coating''
                        WHEN OPERATION_ID = ''E3000'' THEN ''R/P''
                        WHEN OPERATION_ID = ''F6000'' THEN ''EOL''
                        ELSE OPERATION_ID
                        END AS SourceProcess
                    ,[ELECTRODE_TYPE]    AS SourceElectrode
                    ,REPLACE(CONCAT(''#'', SUBSTRING( LINE_ID, CAST(ISNULL(NULLIF(PATINDEX(''%[0-9]%'', LINE_ID), 0), 0) AS INT), 2)),''#0'',''#'') AS SourceLine
                    ,dt.plan_date
                    ,SUM(ISNULL([value], 0)) AS val
                FROM #query_result as rt
                     left join 
                     (
                        SELECT  left(yyyymmdd,4) + ''-'' + substring(yyyymmdd,5,2) + ''-'' + right(yyyymmdd,2) as plan_date
                               ,yyyymmdd
						    FROM TH_UIS_CAL AS C WITH(NOLOCK)
						    WHERE 1 = 1
							AND C.yyyymm >= ' + @v_yyyymm_from + '
							AND C.yyyymm <= ' + @v_yyyymm_to + '

                      ) dt
                      on rt.PLAN_MONTH = left(dt.yyyymmdd,6)

                WHERE 1 = 1    
                GROUP BY
                    [OPERATION_ID], [ELECTRODE_TYPE], [LINE_ID], dt.plan_date
                ) AS ST  
                ON PT.Process       = ST.SourceProcess        
                AND PT.Electrode    = ST.SourceElectrode      
                AND PT.Line         = ST.SourceLine    
            ) as WD
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

                
        --  exec [dbo].[PR_XLS_GET_PROD_EFFICIENCY_PIVOT] 'UC1', '202408' , '202411', 'Coating,Coating','Cathode,Anode','#1,#2'

        print @sql;

        -- 동적으로 생성된 SQL 실행
        EXEC sp_executesql @sql, N'@StartDate DATE, @EndDate DATE', @StartDate, @EndDate;

        -- 임시 테이블 삭제
        DROP TABLE #ProcessTable;

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

       	
	END CATCH

    if object_id('tempdb..#ProcessTable') is not null
		drop table #ProcessTable

    if object_id('tempdb..#query_result') is not null
		drop table #query_result
END



/*

exec [dbo].[PR_XLS_GET_PROD_EFFICIENCY_PIVOT] 'UC1', '202410' , '202411', 'Coating,Coating','Cathode,Anode','#1,#2'

*/
