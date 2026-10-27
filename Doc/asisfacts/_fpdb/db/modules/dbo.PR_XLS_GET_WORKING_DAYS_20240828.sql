
/*
 * Program ID   : PR_XLS_GET_WORKING_DAYS
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 
 * 
 ex) 
 exec PR_XLS_GET_WORKING_DAYS '202409' , '202410'

 */

create PROCEDURE [dbo].[PR_XLS_GET_WORKING_DAYS_20240828]
	@p_yyyymm_from			NVARCHAR(MAX)
,	@p_yyyymm_to			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_yyyymm_from   nvarchar(max)
	DECLARE  @v_yyyymm_to     nvarchar(max)

	set @v_yyyymm_from	= @p_yyyymm_from	--format( convert(datetime, @p_cutoff_date_from), 'yyyyMM')
	set @v_yyyymm_to	= @p_yyyymm_to		--format( convert(datetime, @p_cutoff_date_to), 'yyyyMM')


	if object_id('tempdb..#available') is not null
		drop table #available

	create table #available (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, OPERATION_ID 				nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ELECTRODE_TYPE 			nvarchar(30)
			, PLAN_DATE 				datetime
			, not_available             numeric(20, 10)
			, available                 numeric(20, 10)
			, available_percent         numeric(20, 10)
			)
			;

	BEGIN TRY		


	   -- Working day : available / avaiable(%)
	   insert into #available
			(
			  COMPANY_ID
			, DIVISION_ID 
			, SITE_ID 
			, PLANT_ID
			, FACTORY_ID 
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, PLAN_DATE 		
			, not_available     
			, available         
			, available_percent 
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
			, X.PLAN_DATE		
			, isnull(sum(x.time_term), 0) as not_available 
			, 1440 - isnull(sum(x.time_term), 0) as available
			, (1440 - isnull(sum(x.time_term), 0)) / 1440 * 100 as available_percent
		 from (
		       SELECT YYY.COMPANY_ID 
			        , YYY.DIVISION_ID 
					, YYY.SITE_ID 
					, YYY.PLANT_ID
					, YYY.FACTORY_ID 
					, YYY.OPERATION_ID
					, YYY.LINE_ID     
		       	    , YYY.ELECTRODE_TYPE 
					, YYY.LOSS_CODE
		       	    , YYY.WORK_DATE AS PLAN_DATE
					, YYY.TIME_TERM
		         FROM SCM_WORK_CALENDAR_M as YYY WITH(NOLOCK)
				      join SCM_SYS_LOOKUP_VALUE as z with(nolock)
				   on z.lookup_type_code = 'CAPA_UI_LOSS_TYPE_DEFINIT'
				  and z.attribute1 = 'Not-Available'
				  and z.attribute3 = 'SCM_WORK_CALENDAR_M'
				  and z.active_flag = 'Y'
				  and z.segment1 = yyy.loss_code
				      join TH_UIS_CAL as CAL with(nolock)
				   on yyy.work_date = cal.dt
				where 1 = 1
				  and yyy.company_id = 'G670'
				  and yyy.division_id = '81_UC'
				  and yyy.site_id = 'A003'
				  and yyy.plant_id = 'G671'
				  and yyy.operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
				  --and yyy.loss_code = 'EL001'
		          AND cal.yyyymm  between @v_yyyymm_from and @v_yyyymm_to

		      ) as x
	    group by 
			  X.COMPANY_ID
			, X.DIVISION_ID
			, X.SITE_ID
			, X.PLANT_ID
			, X.FACTORY_ID
			, X.OPERATION_ID
			, X.LINE_ID
			, X.ELECTRODE_TYPE
			, X.PLAN_DATE


	   -- Working day 없는 일자 데이터 생성
	   insert into #available
			(
			  COMPANY_ID
			, DIVISION_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, PLAN_DATE 		
			, not_available     
			, available         
			, available_percent 
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
			, X.PLAN_DATE		
			, 0 as not_available 
			, 1440  as available
			, 100 as available_percent
		 from (
				SELECT B.COMPANY_ID        
			         , B.DIVISION_ID 		
			         , B.SITE_ID 			
			         , B.PLANT_ID 			
			         , B.FACTORY_ID 		
			         , B.OPERATION_ID 		
			         , B.LINE_ID 			
			         , B.ELECTRODE_TYPE 
					 , A.PLAN_DATE
					FROM (
						SELECT C.dt AS plan_date
						FROM TH_UIS_CAL AS C WITH(NOLOCK)
						WHERE 1 = 1
							AND C.yyyymm >= @v_yyyymm_from
							AND C.yyyymm <= @v_yyyymm_to
						) A,
						(
						--SELECT DISTINCT
						--	   COMPANY_ID        
			   --              , DIVISION_ID 		
			   --              , SITE_ID 			
			   --              , PLANT_ID 			
			   --              , FACTORY_ID 		
			   --              , OPERATION_ID 		
			   --              , LINE_ID 			
			   --              , ELECTRODE_TYPE 
						--FROM #available AS X 
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
				            and company_id = 'G670'
				            and division_id = '81_UC'
				            and site_id = 'A003'
				            and plant_id IN ('G671', 'G672')

						) B
		      ) as x
		WHERE 1 = 1
		  AND NOT EXISTS (
						  SELECT 'X'
						    FROM #available AS Z 
						   WHERE 1 = 1
						     AND Z.COMPANY_ID        	= x.COMPANY_ID        
						     AND Z.DIVISION_ID 		= x.DIVISION_ID 		
						     AND Z.SITE_ID 			= x.SITE_ID 			
						     AND Z.PLANT_ID 			= x.PLANT_ID 			
						     AND Z.FACTORY_ID 		= x.FACTORY_ID 		
						     AND Z.OPERATION_ID 		= x.OPERATION_ID 		
						     and z.LINE_ID 			= x.LINE_ID 			
						     and z.ELECTRODE_TYPE 	= x.ELECTRODE_TYPE 
						     and z.PLAN_DATE			= x.PLAN_DATE
			             )
			;

        /* 원본보존
		select 
			  COMPANY_ID
			, DIVISION_ID 
			, SITE_ID 
			, PLANT_ID
			, FACTORY_ID 
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, PLAN_DATE 		
			, not_available     
			, round(available/1440, 2) as available         
			, available_percent 
		 from #available as x
	    order by 
			  X.COMPANY_ID    
		    , X.DIVISION_ID 	
		    , X.SITE_ID     	
		    , X.PLANT_ID    	
		    , X.FACTORY_ID  	
		    , X.OPERATION_ID	
		    , X.LINE_ID     	
		    , X.ELECTRODE_TYPE
			, X.PLAN_DATE
        */

        select 
            'WD' as GUBUN
            , 'WD' + 
               CASE WHEN OPERATION_ID  = 'A5000' THEN 'Notching'
                    WHEN OPERATION_ID = 'A7000' THEN 'L&S'
                    WHEN OPERATION_ID IN ('A7000','A8000') THEN 'L&S'
                    WHEN OPERATION_ID = 'A9000' THEN 'PKG'
                    WHEN OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN OPERATION_ID = 'F6000' THEN 'EOL'
                    ELSE OPERATION_ID
            END + 
            CASE WHEN (OPERATION_ID = 'E2000' OR OPERATION_ID = 'A5000') THEN 
                 CASE WHEN ELECTRODE_TYPE = 'Anode'   THEN ' (Anode)'
                      WHEN ELECTRODE_TYPE = 'Cathode' THEN ' (Cathode)' 
                      ELSE ELECTRODE_TYPE
                 END
                 ELSE  '' 
            END +
            REPLACE(CONCAT('#', SUBSTRING( LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
            + FORMAT(PLAN_DATE,'yyyy-MM-dd')
            AS KEYS_DATE
            , 'WD' + 
               CASE WHEN OPERATION_ID  = 'A5000' THEN 'Notching'
                    WHEN OPERATION_ID = 'A7000' THEN 'L&S'
                    WHEN OPERATION_ID IN ('A7000','A8000') THEN 'L&S'
                    WHEN OPERATION_ID = 'A9000' THEN 'PKG'
                    WHEN OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN OPERATION_ID = 'F6000' THEN 'EOL'
                    ELSE OPERATION_ID
            END + 
            CASE WHEN (OPERATION_ID = 'E2000' OR OPERATION_ID = 'A5000') THEN 
                 CASE WHEN ELECTRODE_TYPE = 'Anode'   THEN ' (Anode)'
                      WHEN ELECTRODE_TYPE = 'Cathode' THEN ' (Cathode)' 
                      ELSE ELECTRODE_TYPE
                 END
                 ELSE  '' 
            END 
            AS KEYS
            , FORMAT(PLAN_DATE,'yyyy-MM-dd') AS PLAN_DATE
            , round(available/1440, 2)	as VALUE
            , COMPANY_ID
			, DIVISION_ID 
			, SITE_ID 
			, PLANT_ID
			, FACTORY_ID 
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE	
            
         from #available

		PRINT 'OK'


	END TRY

	BEGIN CATCH
	    --PRINT ERROR_NUMBER() + '|' + ERROR_MESSAGE()
		PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#available') is not null
			drop table #available

	END CATCH

	if object_id('tempdb..#available') is not null
	drop table #available

END



