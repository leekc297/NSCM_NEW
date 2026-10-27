
/*
 * Program ID   : PR_XLS_GET_PROD_EFFICIENCY
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 
 * 
 ex) 
 exec PR_XLS_GET_PROD_EFFICIENCY '202409' , '202410'

 */

create PROCEDURE [dbo].[PR_XLS_GET_PROD_EFFICIENCY_20240828]
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

	if object_id('tempdb..#loading') is not null
		drop table #loading

	if object_id('tempdb..#operating') is not null
		drop table #operating

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

		create table #loading (
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
			, no_load					numeric(20, 10)
			, loading					numeric(20, 10)
			, loading_percent			numeric(20, 10)
			)
			;

		create table #operating (
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
			, no_run					numeric(20, 10)
			, no_run_pm					numeric(20, 10)
			, operating					numeric(20, 10)
			, operating_percent			numeric(20, 10)
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
					--, YYY.TIME_TERM
					, 0 as time_term
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
				  and yyy.plant_id IN ('G671', 'G672')
				  and yyy.operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
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

       -- loading
	   insert into #loading
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
			, no_load		
			, loading		
			, loading_percent
			)
       select x.COMPANY_ID        
			, x.DIVISION_ID 		
			, x.SITE_ID 			
			, x.PLANT_ID 			
			, x.FACTORY_ID 		
			, x.OPERATION_ID 		
			, x.LINE_ID 			
			, x.ELECTRODE_TYPE 	
			, x.PLAN_DATE 		
			, isnull(y.no_load, 0) as no_load	
			, x.available - isnull(y.no_load, 0) as loading
			, case when x.available = 0 then 0 else (x.available - isnull(y.no_load, 0)) / x.available * 100 end as loading_percent
	     from #available as x
		      left outer join (
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
						, isnull(sum(x.time_term), 0) as no_load 
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
							  and z.attribute1 = 'No-Load'
							  and z.attribute3 = 'SCM_WORK_CALENDAR_M'
							  and z.active_flag = 'Y'
							  and z.segment1 = yyy.loss_code
								  join TH_UIS_CAL as CAL with(nolock)
							   on yyy.work_date = cal.dt
							where 1 = 1
							  and yyy.company_id = 'G670'
							  and yyy.division_id = '81_UC'
							  and yyy.site_id = 'A003'
							  and yyy.plant_id IN ('G671', 'G672')
							  and yyy.operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
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
			  ) as y 
		   on X.COMPANY_ID        = y.COMPANY_ID    
		  and X.DIVISION_ID 	  = y.DIVISION_ID 	
		  and X.SITE_ID     	  = y.SITE_ID     	
		  and X.PLANT_ID    	  = y.PLANT_ID    	
		  and X.FACTORY_ID  	  = y.FACTORY_ID  	
		  and X.OPERATION_ID	  = y.OPERATION_ID	
		  and X.LINE_ID     	  = y.LINE_ID     	
		  and X.ELECTRODE_TYPE	  = y.ELECTRODE_TYPE
		  and X.PLAN_DATE		  = y.PLAN_DATE		


       -- Operating
	   insert into #operating
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
			, no_run	
			, no_run_pm
			, operating			
			, operating_percent	
			)
       select x.COMPANY_ID        
			, x.DIVISION_ID 		
			, x.SITE_ID 			
			, x.PLANT_ID 			
			, x.FACTORY_ID 		
			, x.OPERATION_ID 		
			, x.LINE_ID 			
			, x.ELECTRODE_TYPE 	
			, x.PLAN_DATE 
			, isnull(y.no_run, 0) as no_run
			, isnull(z.no_run_pm, 0) as no_run_pm
			, (1- isnull(y.no_run, 0)) * (x.loading - isnull(z.no_run_pm, 0)) as operating
			, case when x.loading = 0 then 0 else round((1- isnull(y.no_run, 0)) * (x.loading - isnull(z.no_run_pm, 0)) / x.loading , 2) end as operating_percent
	     from #loading as x
		      left outer join (
				  select COMPANY_ID  
					   , DIVISION_ID 
					   , SITE_ID     
					   , PLANT_ID    
					   , FACTORY_ID  
					   , OPERATION_ID
					   , LINE_ID     
					   , ELECTRODE_TYPE 
					   , cal.dt as PLAN_DATE
					   , no_run 
					from (
						   SELECT YYY.COMPANY_ID  
		       					, YYY.DIVISION_ID 
		       					, YYY.SITE_ID     
		       					, YYY.PLANT_ID    
		       					, YYY.FACTORY_ID  
		       					, YYY.OPERATION_ID
		       					, YYY.LINE_ID     
		       					, YYY.ELECTRODE_TYPE 
		       					, YYY.WORK_MONTH AS PLAN_MONTH
								, sum(YYY.LOSS_RATE) as no_run
						     FROM SCM_LOSS_M as YYY WITH(NOLOCK)
								  join SCM_SYS_LOOKUP_VALUE as z with(nolock)
							   on z.lookup_type_code = 'CAPA_UI_LOSS_TYPE_DEFINIT'
							  and z.attribute1 = 'No-Run'
							  and z.attribute3 = 'SCM_LOSS_M'
							  and z.active_flag = 'Y'
							  and z.segment1 = yyy.loss_code
							where 1 = 1
							  and yyy.company_id = 'G670'
							  and yyy.division_id = '81_UC'
							  and yyy.site_id = 'A003'
							  and yyy.plant_id IN ('G671', 'G672')
							  and yyy.operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
							  AND yyy.work_month  between @v_yyyymm_from and @v_yyyymm_to
							group by 
								  YYY.COMPANY_ID  
		       					, YYY.DIVISION_ID 
		       					, YYY.SITE_ID     
		       					, YYY.PLANT_ID    
		       					, YYY.FACTORY_ID  
		       					, YYY.OPERATION_ID
		       					, YYY.LINE_ID     
		       					, YYY.ELECTRODE_TYPE 
								, YYY.WORK_MONTH
						 ) as xx
						 join TH_UIS_CAL as CAL with(nolock)
					  on PLAN_MONTH = cal.yyyymm
			  ) as y 
		   on X.COMPANY_ID        = y.COMPANY_ID    
		  and X.DIVISION_ID 	  = y.DIVISION_ID 	
		  and X.SITE_ID     	  = y.SITE_ID     	
		  and X.PLANT_ID    	  = y.PLANT_ID    	
		  and X.FACTORY_ID  	  = y.FACTORY_ID  	
		  and X.OPERATION_ID	  = y.OPERATION_ID	
		  and X.LINE_ID     	  = y.LINE_ID     	
		  and X.ELECTRODE_TYPE	  = y.ELECTRODE_TYPE
		  and X.PLAN_DATE		  = y.PLAN_DATE		
		      left outer join (
				   select X.COMPANY_ID    
						, X.DIVISION_ID 	
						, X.SITE_ID     	
						, X.PLANT_ID    	
						, X.FACTORY_ID  	
						, X.OPERATION_ID	
						, X.LINE_ID     	
						, X.ELECTRODE_TYPE
						, X.PLAN_DATE		
						, isnull(sum(x.time_term), 0) as no_run_pm
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
								  join TH_UIS_CAL as CAL with(nolock)
							   on yyy.work_date = cal.dt
							where 1 = 1
							  and yyy.company_id = 'G670'
							  and yyy.division_id = '81_UC'
							  and yyy.site_id = 'A003'
							  and yyy.plant_id IN ('G671', 'G672')
							  and yyy.operation_id in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
							  AND cal.yyyymm  between @v_yyyymm_from and @v_yyyymm_to
							  and yyy.loss_code = 'EL011'  --No-Run : PM
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
			  ) as z
		   on X.COMPANY_ID        = z.COMPANY_ID    
		  and X.DIVISION_ID 	  = z.DIVISION_ID 	
		  and X.SITE_ID     	  = z.SITE_ID     	
		  and X.PLANT_ID    	  = z.PLANT_ID    	
		  and X.FACTORY_ID  	  = z.FACTORY_ID  	
		  and X.OPERATION_ID	  = z.OPERATION_ID	
		  and X.LINE_ID     	  = z.LINE_ID     	
		  and X.ELECTRODE_TYPE	  = z.ELECTRODE_TYPE
		  and X.PLAN_DATE		  = z.PLAN_DATE	


          /* 원본보존
		  select *
		  from #operating
          */
		 --where OPERATION_ID = 'A9000'
   --        and line_id = 'ABA01'
           --and plan_date = '2024-09-01 00:00:00.000'
         
       select 
            'PE' as GUBUN
            , 'PE' + 
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
                 CASE WHEN ELECTRODE_TYPE = 'Anode' THEN ' (Anode)'
                      WHEN ELECTRODE_TYPE = 'Cathode' THEN ' (Cathode)' 
                      ELSE ELECTRODE_TYPE
                 END
                 ELSE  '' 
            END +
            REPLACE(CONCAT('#', SUBSTRING( LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
            + FORMAT(PLAN_DATE,'yyyy-MM-dd')
            AS KEYS_DATE
            , 'PE' + 
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
            , operating_percent	as VALUE
            , DIVISION_ID 		
            , SITE_ID 			
            , PLANT_ID 			
            , FACTORY_ID 		
            , OPERATION_ID 		
            , LINE_ID 			
            , ELECTRODE_TYPE 	
            
         from #operating


		PRINT 'OK'

	END TRY

	BEGIN CATCH

	    PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#available') is not null
			drop table #available

		if object_id('tempdb..#loading') is not null
			drop table #loading

		if object_id('tempdb..#operating') is not null
			drop table #operating

	END CATCH

	if object_id('tempdb..#available') is not null
		drop table #available

	if object_id('tempdb..#loading') is not null
		drop table #loading

	if object_id('tempdb..#operating') is not null
		drop table #operating

END



