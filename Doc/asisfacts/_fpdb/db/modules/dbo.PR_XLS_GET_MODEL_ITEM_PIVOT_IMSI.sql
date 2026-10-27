
/*
 * Program ID   : PR_XLS_GET_MODEL_ITEM_PIVOT_IMSI
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.22   FP Pjt.         Create.
 * 2024.10.23   shineuiho67     파라메터를 월->일로 변경(피벗테이블의 한계 8K 가 있어서, 엑셀시트에서 필요한 일수는 450일 정도인데, 이것을 반반으로 나누어서 2번에 걸쳐서 호출 함)
 * 
 ex) 
   exec PR_XLS_GET_MODEL_ITEM_PIVOT_IMSI @p_apl_code = 'UC1', @p_yyyymmdd_from = '20241001', @p_yyyymmdd_to = '20251131', @p_ProcessData  = 'PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG,PKG', @p_ElectrodeData = '-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-', @p_LineData = '#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#1,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#2,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#3,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#4,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#5,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#6,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#7,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#8,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#9,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10', @p_ModelData = '210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400,210,220,230,240,250,260,270,280,290,300,310,320,330,340,350,360,370,380,390,400';
   exec PR_XLS_GET_MODEL_ITEM_PIVOT_IMSI @p_apl_code = 'UC1', @p_yyyymmdd_from = '20241001', @p_yyyymmdd_to = '20251131', @p_ProcessData  = 'Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating,Coating', @p_ElectrodeData = 'Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode,Cathode', @p_LineData = '#1,#1,#1,#1,#2,#2,#2,#2,#3,#3,#3,#3,#4,#4,#4,#4', @p_ModelData = '140,180,160,170,140,180,160,170,140,180,160,170,140,180,160,170';
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_MODEL_ITEM_PIVOT_IMSI]
    @p_apl_code             nvarchar(max)  = 'UC1'
,	@p_yyyymmdd_from	    NVARCHAR(MAX)
,	@p_yyyymmdd_to	     	NVARCHAR(MAX)
,   @p_ProcessData          NVARCHAR(MAX)  -- 공정 데이터를 ','로 구분한 문자열
,   @p_ElectrodeData        NVARCHAR(MAX)  -- 전극구분 데이터를 ','로 구분한 문자열
,   @p_LineData             NVARCHAR(MAX)  -- 라인 데이터를 ','로 구분한 문자열
,   @p_ModelData            NVARCHAR(MAX)  -- 모델 데이터를 ','로 구분한 문자열

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
    DECLARE @v_yyyymmdd_from		nvarchar(max)
	DECLARE @v_yyyymmdd_to			nvarchar(max)
	DECLARE @v_yyyymm_from			nvarchar(max)
	DECLARE @v_yyyymm_to			nvarchar(max)
    DECLARE @v_ProcessData			nvarchar(max)
    DECLARE @v_ElectrodeData	    nvarchar(max)
    DECLARE @v_LineData			    nvarchar(max)
    DECLARE @v_ModelData			nvarchar(max)
    DECLARE @columns                nvarchar(MAX);
    DECLARE @sql                    nvarchar(MAX);
    DECLARE @sql2                   nvarchar(MAX);

    declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)
    
	set @v_apl_code			= @p_apl_code
    set @v_yyyymmdd_from	= @p_yyyymmdd_from
	set @v_yyyymmdd_to		= @p_yyyymmdd_to 

    set @v_ProcessData		= @p_ProcessData
    set @v_ElectrodeData	= @p_ElectrodeData
    set @v_LineData		    = @p_LineData
    set @v_ModelData		= @p_ModelData
    
    
    BEGIN TRY		
        
        -- 시작일자와 종료일자 계산
        DECLARE @StartDate DATE = convert(date, @v_yyyymmdd_from, 12)
        DECLARE @EndDate DATE = convert(date, @v_yyyymmdd_to, 12)

        if object_id('tempdb..#ProcessTable') is not null
		drop table #ProcessTable

        if object_id('tempdb..#fp_plan_model_change_m') is not null
		drop table #fp_plan_model_change_m

        create table #fp_plan_model_change_m (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, [COMPANY_ID]				[nvarchar](30) NOT NULL
			, [DIVISION_ID]				[nvarchar](30) NOT NULL
			, [SITE_ID]					[nvarchar](30) NOT NULL
			, [PLANT_ID]				[nvarchar](30) NOT NULL
			, [FACTORY_ID]				[nvarchar](30) NOT NULL
			, [MODEL_ID]				[nvarchar](150) NOT NULL
			, [LINE_ID]					[nvarchar](30) NOT NULL
			, [OPERATION_ID]			[nvarchar](30) NOT NULL
			, [ITEM_ID]					[nvarchar](150) NOT NULL  
			, [PRODUCTION_TYPE]			[nvarchar](30) NOT NULL
			, [ELECTRODE_TYPE]			[nvarchar](30) NOT NULL
			, [VERSION]					[nvarchar](10) NOT NULL
			, [EFF_START_DATE]			[datetime] NOT NULL
			, [PRIORITY]				[int] NOT NULL
			, [INV_APL_FLAG]			[nvarchar](1) NOT NULL
			)
			;

        -- 공정, 전극구분, 라인 데이터를 임시 테이블에 삽입
        CREATE TABLE #ProcessTable (
            Process NVARCHAR(50),
            Electrode NVARCHAR(50),
            Line NVARCHAR(50),
            Model NVARCHAR(50),
            id  int identity(1,1)
        );

        select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'
		
		insert into #fp_plan_model_change_m
	         (
			   [COMPANY_ID]		
			 , [DIVISION_ID]		
			 , [SITE_ID]			
			 , [PLANT_ID]		
			 , [FACTORY_ID]		
			 , [MODEL_ID]		
			 , [LINE_ID]			
			 , [OPERATION_ID]	
			 , [ITEM_ID]			
			 , [PRODUCTION_TYPE]	
			 , [ELECTRODE_TYPE]	
			 , [VERSION]			
			 , [EFF_START_DATE]	
			 , [PRIORITY]		
			 , [INV_APL_FLAG]	
			 )
		select X.[COMPANY_ID]
		     , X.[DIVISION_ID]
		     , X.[SITE_ID]
		     , X.[PLANT_ID]
		     , X.[FACTORY_ID]
		     , X.[MODEL_ID]
		     , X.[LINE_ID]
		     , X.[OPERATION_ID]
		     , X.[ITEM_ID]
		     , X.[PRODUCTION_TYPE]
		     , X.[ELECTRODE_TYPE]
		     , X.[VERSION]
		     , CAL.DT AS EFF_START_DATE
		     , MIN(X.[PRIORITY]) as PRIIORITY
		     , MAX(X.[INV_APL_FLAG]) as INV_APL_FLAG
		  FROM FP_PLAN_MODEL_CHANGE_M as X WITH(NOLOCK)
			   JOIN TH_UIS_CAL as CAL with(nolock)
		    ON CAL.DT	>= X.EFF_START_DATE 
		   AND CAL.DT	<= X.EFF_END_DATE
	     WHERE 1 = 1
		   AND X.COMPANY_ID		= @v_company_id	
		   AND X.DIVISION_ID	= @v_division_id	
		   AND X.SITE_ID		= @v_site_id		
		   AND X.PLANT_ID		IN (@v_plant_id, @v_elec_plant_id)
		   AND X.OPERATION_ID	in ('E2000', 'A5000', 'A8000', 'A9000', 'F6000')
		   AND CAL.DT  BETWEEN @v_yyyymmdd_from and @v_yyyymmdd_to
		   and X.ACTIVE_FLAG = 'Y'
		   AND NOT EXISTS (
			 		        SELECT 1
				              FROM FP_PLAN_MODEL_CHANGE_EXCEPT_M AS Y WITH(NOLOCK)
							 WHERE 1 = 1
							   AND Y.company_id			= @v_company_id	
							   AND Y.division_id		= @v_division_id
				               AND Y.site_id			= @v_site_id	
				               AND Y.plant_id			IN (@v_plant_id, @v_elec_plant_id)
							   AND Y.operation_id		IN ('E2000', 'A5000', 'A8000', 'A9000', 'F6000')
							   AND Y.EFF_START_DATE		BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to
							   AND y.ACTIVE_FLAG		= 'Y'
							   AND X.factory_id			= y.factory_id
							   AND x.line_id			= y.line_id
							   AND x.operation_id		= y.operation_id
							   AND cal.dt				= y.eff_start_date
						  )
	     group by 
		       X.[COMPANY_ID]
		     , X.[DIVISION_ID]
		     , X.[SITE_ID]
		     , X.[PLANT_ID]
		     , X.[FACTORY_ID]
		     , X.[MODEL_ID]
		     , X.[LINE_ID]
		     , X.[OPERATION_ID]
		     , X.[ITEM_ID]
		     , X.[PRODUCTION_TYPE]
		     , X.[ELECTRODE_TYPE]
		     , X.[VERSION]
		     , CAL.DT

         UNION ALL 
		SELECT Y.[COMPANY_ID]
			 , Y.[DIVISION_ID]
			 , Y.[SITE_ID]
			 , Y.[PLANT_ID]
			 , Y.[FACTORY_ID]
			 , Y.[MODEL_ID]
			 , Y.[LINE_ID]
			 , Y.[OPERATION_ID]
			 , Y.[ITEM_ID]
			 , Y.[PRODUCTION_TYPE]
			 , Y.[ELECTRODE_TYPE]
			 , Y.[VERSION]
			 , Y.[EFF_START_DATE] 
			 , [PRIORITY]		
			 , [INV_APL_FLAG]	
		  FROM FP_PLAN_MODEL_CHANGE_EXCEPT_M AS Y WITH(NOLOCK)
		 where 1 = 1
		   AND Y.company_id			= @v_company_id	
		   AND Y.division_id		= @v_division_id
		   AND Y.site_id			= @v_site_id	
		   AND Y.plant_id			IN (@v_plant_id, @v_elec_plant_id)
		   AND Y.operation_id		IN ('E2000', 'A5000', 'A8000', 'A9000', 'F6000')
		   AND Y.EFF_START_DATE		BETWEEN @v_yyyymmdd_from AND @v_yyyymmdd_to
		   AND Y.ACTIVE_FLAG		= 'Y';
          
    

        WITH ProcessCTE AS (
            SELECT value AS Process, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM dbo.fn_splitstring(@v_ProcessData, ',')
        )
        ,
        ElectrodeCTE AS (
            SELECT value AS Electrode, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM dbo.fn_splitstring(@v_ElectrodeData, ',')
        ),
        LineCTE AS (
            SELECT value AS Line, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM dbo.fn_splitstring(@v_LineData, ',')
        ),
        ModelCTE AS (
            SELECT value AS Model, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM dbo.fn_splitstring(@v_ModelData, ',')
        )

        --select * from ProcessCTE;
        --select * from ElectrodeCTE;
        --select * from LineCTE;
        --select * from ModelCTE;


        -- RowNum을 기준으로 각 데이터를 순차적으로 매칭하여 삽입
        INSERT INTO #ProcessTable (Process, Electrode, Line, Model)
        SELECT p.Process, e.Electrode, l.Line, m.Model
        FROM ProcessCTE p 
        INNER JOIN ElectrodeCTE e ON p.RowNum = e.RowNum
        INNER JOIN LineCTE      l ON p.RowNum = l.RowNum
        INNER JOIN ModelCTE     m ON p.RowNum = m.RowNum
        option (maxrecursion 300)  ;

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

      --  select * FROM  #fp_plan_model_change_m ;

      set @sql = '
      select  ' + @columns + ' from 
        
        #ProcessTable as SPT
        left join 
        (
        SELECT PROCESS,Electrode,Line,Model, ' + @columns + '
         FROM (

            SELECT PT.Process
                ,PT.Electrode
                ,PT.Line
                ,PT.Model
                ,ST.item_id
                ,ST.plan_date
            FROM
                (SELECT Process, Electrode, Line, Model from #ProcessTable) AS PT
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
                            ,right(model_id,3) as SourceModel
                            ,FORMAT(CONVERT(DATE, EFF_START_DATE, 112),''yyyy-MM-dd'') AS plan_date
                            ,max(ISNULL([ITEM_ID], '''')) AS ITEM_ID
                        FROM  #fp_plan_model_change_m as m       
                        WHERE 1 = 1    
                        GROUP BY
                              [OPERATION_ID], [ELECTRODE_TYPE], [LINE_ID], right(model_id,3), [EFF_START_DATE]
                ) AS ST  
                ON PT.Process       = ST.SourceProcess        
                AND PT.Electrode    = ST.SourceElectrode      
                AND PT.Line         = ST.SourceLine    
                AND PT.Model        = ST.SourceModel    
            ) as WD
            ';

          set @sql2 = 'PIVOT
            (              
                max(ITEM_ID)
                FOR [plan_date] IN ( ' + @columns + ' )      
            ) PVT   
           ) PVT_DATA
           ON SPT.Process       = PVT_DATA.PROCESS        
           AND SPT.Electrode    = PVT_DATA.Electrode      
           AND SPT.Line         = PVT_DATA.Line    
           AND SPT.Model        = PVT_DATA.Model
           order by SPT.id
           ;';
           
        set @sql =  @sql + @sql2    

        print @sql + ' ' + @sql2

        -- 동적으로 생성된 SQL 실행
        EXEC sp_executesql @sql, N'@StartDate DATE, @EndDate DATE', @StartDate, @EndDate;

       PRINT 'OK'
     
	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

        if object_id('tempdb..#ProcessTable') is not null
		drop table #ProcessTable

        if object_id('tempdb..#fp_plan_model_change_m') is not null
		drop table #fp_plan_model_change_m
        	
	END CATCH

        if object_id('tempdb..#ProcessTable') is not null
		drop table #ProcessTable

        if object_id('tempdb..#fp_plan_model_change_m') is not null
		drop table #fp_plan_model_change_m
END

