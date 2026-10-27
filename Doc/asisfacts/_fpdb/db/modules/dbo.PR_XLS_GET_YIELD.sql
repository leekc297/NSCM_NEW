
/*
 * Program ID   : PR_XLS_GET_YIELD
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_YIELD] 'UC1', '202408' , '202409'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_YIELD]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymm_from			NVARCHAR(MAX)
,	@p_yyyymm_to			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymm_from			nvarchar(max)
	DECLARE @v_yyyymm_to			nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymm_from		= @p_yyyymm_from --format( convert(datetime, @p_yyyymmdd_rom), 'yyyyMMdd')
	set @v_yyyymm_to		= @p_yyyymm_to --format( convert(datetime, @p_cutoff_date_to), 'yyyyMMdd')

	if object_id('tempdb..#yield') is not null
		drop table #yield

	create table #yield (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, OPERATION_ID 				nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ITEM_ID 					nvarchar(150)
			, PLAN_DATE 		   		datetime
			, YIELD                     numeric(20, 10)
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

	   insert into #yield
	        (
			  COMPANY_ID        
			, DIVISION_ID 		
			, SITE_ID 			
			, PLANT_ID 			
			, FACTORY_ID 		
			, OPERATION_ID 		
			, LINE_ID 			
			, ITEM_ID 			
			, PLAN_DATE 		
			, YIELD  
			)
	   select 
		      X.COMPANY_ID    
		    , X.DIVISION_ID 	
		    , X.SITE_ID     	
		    , X.PLANT_ID    	
		    , X.FACTORY_ID  	
		    , X.OPERATION_ID	
		    , X.LINE_ID     	
		    , X.ITEM_ID     	
		    , X.PLAN_DATE		
		    , ISNULL( ISNULL( y.YIELD, ( CASE WHEN x.YIELD = 0 THEN 1 ELSE x.YIELD END)) ,1) 
		 from (
		       select X.COMPANY_ID  
		       	    , X.DIVISION_ID 
		       	    , X.SITE_ID     
		       	    , X.PLANT_ID    
		       	    , X.FACTORY_ID  
		       	    , X.OPERATION_ID
		       	    , X.LINE_ID     
		       	    , X.ITEM_ID     
		       	    , CAL.DT AS PLAN_DATE
		       	    , CASE WHEN MAX(X.YIELD) = 0 THEN 1 ELSE MAX(X.YIELD) END AS YIELD
		         FROM SCM_YIELD_M as X WITH(NOLOCK)
				      JOIN TH_UIS_CAL as CAL with(nolock)
				   on X.month = cal.yyyymm
				where 1 = 1
				  and X.company_id	= @v_company_id	
				  and X.division_id	= @v_division_id	
				  and X.site_id		= @v_site_id		
				  and X.plant_id		IN (@v_plant_id, @v_elec_plant_id)
				  and X.operation_id	in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
		          AND X.month  between @v_yyyymm_from and @v_yyyymm_to
		        group by X.COMPANY_ID  
		       	    , X.DIVISION_ID 
		       	    , X.SITE_ID     
		       	    , X.PLANT_ID    
		       	    , X.FACTORY_ID  
		       	    , X.OPERATION_ID
		       	    , X.LINE_ID     
		       	    , X.ITEM_ID     
		       	    , CAL.DT
		      ) as x
			  left outer join (
			 		           SELECT EX.COMPANY_ID  
					                , EX.DIVISION_ID 
					                , EX.SITE_ID     
					                , EX.PLANT_ID    
					                , EX.FACTORY_ID  
					                , EX.OPERATION_ID
					                , EX.LINE_ID     
					                , EX.ITEM_ID     
					                , CAL.DT AS PLAN_DATE
				                    , (CASE WHEN MAX(EX.YIELD) = 0 THEN 1 ELSE MAX(EX.YIELD) END) AS YIELD
				                 FROM SCM_YIELD_EXCEPT_M AS EX WITH(NOLOCK)
									  JOIN TH_UIS_CAL as CAL with(nolock)
								   on cal.dt between EX.start_time and EX.end_time
								where 1 = 1
								  and company_id	= @v_company_id	
								  and division_id	= @v_division_id
				                  and site_id		= @v_site_id	
				                  and plant_id		IN (@v_plant_id, @v_elec_plant_id)
								  and operation_id	in ('E2000', 'E3000', 'A5000', 'A8000', 'A9000', 'F6000')
								  AND cal.YYYYMM  between @v_yyyymm_from and @v_yyyymm_to
				                group by 
								      EX.COMPANY_ID  
					                , EX.DIVISION_ID 
					                , EX.SITE_ID     
					                , EX.PLANT_ID    
					                , EX.FACTORY_ID  
					                , EX.OPERATION_ID
					                , EX.LINE_ID     
					                , EX.ITEM_ID     
					                , CAL.DT
			  ) y
		   ON X.COMPANY_ID		= Y.COMPANY_ID  
		  AND X.DIVISION_ID 	= Y.DIVISION_ID 
		  AND X.SITE_ID     	= Y.SITE_ID     
		  AND X.PLANT_ID    	= Y.PLANT_ID    
		  AND X.FACTORY_ID  	= Y.FACTORY_ID  
		  AND X.OPERATION_ID	= Y.OPERATION_ID
		  AND X.LINE_ID     	= Y.LINE_ID     
		  AND X.ITEM_ID     	= Y.ITEM_ID     
		  AND X.PLAN_DATE		= Y.PLAN_DATE

	   -- Yield 없는 일자 데이터 생성
	   insert into #yield
	        (
			  COMPANY_ID        
			, DIVISION_ID 		
			, SITE_ID 			
			, PLANT_ID 			
			, FACTORY_ID 		
			, OPERATION_ID 		
			, LINE_ID 			
			, ITEM_ID 			
			, PLAN_DATE 		
			, YIELD  
			)
	   select 
		      X.COMPANY_ID    
			, X.DIVISION_ID 	
			, X.SITE_ID 		
			, X.PLANT_ID 		
			, X.FACTORY_ID 	
			, X.OPERATION_ID 	
			, X.LINE_ID 		
			, X.ITEM_ID 		
			, X.PLAN_DATE 	
			, 1 as yield 
		 from (
				SELECT B.COMPANY_ID      
			         , B.DIVISION_ID 		
			         , B.SITE_ID 			
			         , B.PLANT_ID 			
			         , B.FACTORY_ID 		
			         , B.OPERATION_ID 		
			         , B.LINE_ID 			
			         , B.ITEM_ID 		
					 , A.PLAN_DATE 	
				FROM (
						SELECT C.dt AS plan_date
						FROM TH_UIS_CAL AS C WITH(NOLOCK)
						WHERE 1 = 1
							AND C.yyyymm >= @v_yyyymm_from
							AND C.yyyymm <= @v_yyyymm_to
						) A,
						(
						 SELECT distinct 
						        COMPANY_ID    
							  , DIVISION_ID 	
							  , SITE_ID 		
							  , PLANT_ID 		
							  , FACTORY_ID 	
							  , OPERATION_ID 	
							  , LINE_ID 		
							  , ITEM_ID 		
						   FROM #yield

						) B
		      ) as x
		WHERE 1 = 1
		  AND NOT EXISTS (
						  SELECT 'X'
						    FROM #yield AS Z 
						   WHERE 1 = 1
						     AND Z.COMPANY_ID       = x.COMPANY_ID     
						     AND Z.DIVISION_ID 	    = x.DIVISION_ID 	
						     AND Z.SITE_ID 		    = x.SITE_ID 		
						     AND Z.PLANT_ID 		= x.PLANT_ID 		 	
						     AND Z.FACTORY_ID 	    = x.FACTORY_ID 	
						     AND Z.OPERATION_ID 	= x.OPERATION_ID 	 	
						     and z.LINE_ID 		    = x.LINE_ID 		
						     and z.ITEM_ID 		    = x.ITEM_ID 		
						     and z.PLAN_DATE 	    = x.PLAN_DATE 	
			             )
			;

		select * from #yield order by tid

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#yield') is not null
			drop table #yield

	END CATCH

	if object_id('tempdb..#yield') is not null
	drop table #yield

END



