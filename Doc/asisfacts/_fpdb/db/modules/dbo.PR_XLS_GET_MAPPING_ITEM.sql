
/*
 * Program ID   : PR_XLS_GET_MAPPING_ITEM
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 2024.09.26   FP Pjt.         except 테이블 적용.
 * 
 ex) 
 exec [dbo].[PR_XLS_GET_MAPPING_ITEM] 'UC1', '202408' , '202408'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_MAPPING_ITEM]
    @p_apl_code             nvarchar(max)  = 'UC1'
,	@p_yyyymm_from			NVARCHAR(MAX)
,	@p_yyyymm_to			NVARCHAR(MAX)
AS
/*
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    DECLARE	 @v_apl_code		   NVARCHAR(MAX)
	DECLARE  @v_cutoff_date_from   nvarchar(max)
	DECLARE  @v_cutoff_date_to     nvarchar(max)

    declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

    set @v_apl_code			= @p_apl_code
	set @v_cutoff_date_from = @p_cutoff_date_from --format( convert(datetime, @p_cutoff_date_from), 'yyyyMMdd')
	set @v_cutoff_date_to	= @p_cutoff_date_to --format( convert(datetime, @p_cutoff_date_to), 'yyyyMMdd')
    

	BEGIN TRY		

        -- Tally Table 생성 (22*22 = 484, 1부터 484까지 숫자가 포함된 임시 테이블을 생성)

        WITH Tally AS (
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
            FROM (VALUES       (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS x(n)
            CROSS JOIN (VALUES (0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) AS y(n)

        )
        SELECT 
               CASE WHEN YY.OPERATION_ID    = 'A5000' THEN 'Notching'
                    WHEN YY.OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                    WHEN YY.OPERATION_ID    = 'A9000' THEN 'PKG'
                    WHEN YY.OPERATION_ID    = 'E2000' THEN 'Coating'
                    WHEN YY.OPERATION_ID    = 'E3000' THEN 'R/P'
                    WHEN YY.OPERATION_ID    = 'F6000' THEN 'EOL'
                    ELSE YY.OPERATION_ID
                END 
                + IIF(YY.ELECTRODE_TYPE = '-','',' (' + YY.ELECTRODE_TYPE + ')')
                + REPLACE(CONCAT('#', SUBSTRING( YY.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', YY.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                + RIGHT(YY.NICK_NAME,3)
                + YY.DATE
                AS KEYS_MODEL
                ,CASE WHEN YY.OPERATION_ID    = 'A5000' THEN 'Notching'
                    WHEN YY.OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                    WHEN YY.OPERATION_ID    = 'A9000' THEN 'PKG'
                    WHEN YY.OPERATION_ID    = 'E2000' THEN 'Coating'
                    WHEN YY.OPERATION_ID    = 'E3000' THEN 'R/P'
                    WHEN YY.OPERATION_ID    = 'F6000' THEN 'EOL'
                    ELSE YY.OPERATION_ID
                END 
                + IIF(YY.ELECTRODE_TYPE = '-','',' (' + YY.ELECTRODE_TYPE + ')')
                + REPLACE(CONCAT('#', SUBSTRING( YY.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', YY.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                + YY.DATE
                AS KEYS
                , YY.FACTORY_ID
                , YY.MODEL_ID
                , YY.LINE_ID
                , YY.OPERATION_ID
                , YY.ITEM_ID
                , YY.NICK_NAME
                , YY.PRODUCTION_TYPE
                , YY.ELECTRODE_TYPE
                , YY.VERSION
                , YY.PRIORITY
                , YY.INV_APL_FLAG
                , YY.DATE AS EFF_DATE
        FROM    (
                -- 본문 쿼리
                
                SELECT
                        Y.FACTORY_ID
                        , Y.MODEL_ID
                        , Y.LINE_ID
                        , Y.OPERATION_ID
                        , Y.ITEM_ID
                        , Z.NICK_NAME
                        , Y.PRODUCTION_TYPE
                        , Y.ELECTRODE_TYPE
                        , Y.VERSION
                        , Y.PRIORITY
                        , Y.INV_APL_FLAG
                        , format(DATEADD(DAY, T.N - 1, Y.eff_start_date),'yyyy-MM-dd') AS Date
                        
                FROM    FP_PLAN_MODEL_CHANGE_M Y with(nolock)
                JOIN    Tally T ON T.N <= DATEDIFF(DAY, Y.eff_start_date, Y.eff_end_date) + 1
                
                left join scm_item_m as z with(nolock)
		        on  Y.division_id   = z.division_id
		        and Y.company_id    = z.company_id
		        and Y.item_id       = z.item_id

                WHERE   Y.ACTIVE_FLAG   = 'Y'
                and     Y.operation_id <> 'E0500'
               

                ) YY
        WHERE   YY.DATE BETWEEN @v_cutoff_date_from AND @v_cutoff_date_to
        ORDER BY 2;

	END TRY

	BEGIN CATCH
	    PRINT ERROR_MESSAGE()


	END CATCH

END
*/

BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymmdd_from		nvarchar(max)
	DECLARE @v_yyyymmdd_to			nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymmdd_from	= @p_yyyymm_from + '01' --format( convert(datetime, @p_yyyymmdd_rom), 'yyyyMMdd')
	set @v_yyyymmdd_to		= EOMONTH( @p_yyyymm_to + '01')--format( convert(datetime, @p_cutoff_date_to), 'yyyyMMdd')

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

	BEGIN TRY	
			
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
          
        SELECT 

               CASE WHEN YY.OPERATION_ID    = 'A5000' THEN 'Notching'
                    WHEN YY.OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                    WHEN YY.OPERATION_ID    = 'A9000' THEN 'PKG'
                    WHEN YY.OPERATION_ID    = 'E2000' THEN 'Coating'
                    WHEN YY.OPERATION_ID    = 'E3000' THEN 'R/P'
                    WHEN YY.OPERATION_ID    = 'F6000' THEN 'EOL'
                    ELSE YY.OPERATION_ID
                END 
                + IIF(YY.ELECTRODE_TYPE = '-','',' (' + YY.ELECTRODE_TYPE + ')')
                + REPLACE(CONCAT('#', SUBSTRING( YY.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', YY.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                + RIGHT(YY.NICK_NAME,3)
                + format(YY.EFF_START_DATE, 'yyyy-MM-dd')
                AS KEYS_MODEL
                ,CASE WHEN YY.OPERATION_ID    = 'A5000' THEN 'Notching'
                    WHEN YY.OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                    WHEN YY.OPERATION_ID    = 'A9000' THEN 'PKG'
                    WHEN YY.OPERATION_ID    = 'E2000' THEN 'Coating'
                    WHEN YY.OPERATION_ID    = 'E3000' THEN 'R/P'
                    WHEN YY.OPERATION_ID    = 'F6000' THEN 'EOL'
                    ELSE YY.OPERATION_ID
                END 
                + IIF(YY.ELECTRODE_TYPE = '-','',' (' + YY.ELECTRODE_TYPE + ')')
                + REPLACE(CONCAT('#', SUBSTRING( YY.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', YY.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                + format(YY.EFF_START_DATE, 'yyyy-MM-dd')
                AS KEYS
                , YY.FACTORY_ID
                , YY.MODEL_ID
                , YY.LINE_ID
                , YY.OPERATION_ID
                , YY.ITEM_ID
                , YY.NICK_NAME
                , YY.PRODUCTION_TYPE
                , YY.ELECTRODE_TYPE
                , YY.VERSION
                , YY.PRIORITY
                , YY.INV_APL_FLAG
                , YY.EFF_START_DATE as EFF_DATE
        FROM    (
		            SELECT y.*, z.nick_name FROM #fp_plan_model_change_m as y--ORDER BY tid
                        left join scm_item_m as z with(nolock)
		            on  Y.division_id   = z.division_id
		            and Y.company_id    = z.company_id
					and Y.site_id       = z.site_id
		            and Y.item_id       = z.item_id
                ) AS YY
        WHERE   1=1 
        ORDER BY 2;
        

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#fp_plan_model_change_m') is not null
			drop table #fp_plan_model_change_m

	END CATCH

	if object_id('tempdb..#fp_plan_model_change_m') is not null
	drop table #fp_plan_model_change_m

END

