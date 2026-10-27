
/*
 * Program ID   : PR_XLS_SAVE_FP_AMEND_PLAN_CELL_R_IMSI
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 2024.10.10   FP Pjt.         A7000 생성 로직 수정
 * 
 ex) 
  exec PR_XLS_SAVE_FP_AMEND_PLAN_CELL_R_IMSI 'seon.beck', 'UC1-20240904-08'

 */

CREATE PROCEDURE [dbo].[PR_XLS_SAVE_FP_AMEND_PLAN_CELL_R_IMSI]
	@p_user_id					NVARCHAR(MAX)    
,	@p_intg_plan_id				NVARCHAR(MAX)  
--,   @p_return					NVARCHAR(max) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_user_id			nvarchar(max)
	DECLARE @v_instance_id		nvarchar(max)
	DECLARE @v_fp_plan_id		nvarchar(max)
	DECLARE @v_intg_plan_id		nvarchar(50)

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

	set @v_user_id				= @p_user_id
	set @v_intg_plan_id			= @p_intg_plan_id

	select @v_instance_id	= instance_id
	     , @v_fp_plan_id	= plan_id
	  from scm_fp_plan_h as x with(nolock)
	 where intg_plan_id = @v_intg_plan_id
	   and instance_id in (
		    select instance_id
			  from [dbo].[FP_INSTANCE_INFO_V]
			 where instance_id = x.instance_id
			   and instance_type = 'A'
				)

	if object_id('tempdb..#BUF_AMEND_PLAN_CELL_R_XLS') is not null
		drop table #BUF_AMEND_PLAN_CELL_R_XLS

	if object_id('tempdb..#BUF_AMEND_TEMP') is not null
		drop table #BUF_AMEND_TEMP

	if object_id('tempdb..#INVALID_MSG') is not null
		drop table #INVALID_MSG

	if object_id('tempdb..#SCM_YIELD_M') is not null
		drop table #SCM_YIELD_M

	create table #BUF_AMEND_PLAN_CELL_R_XLS (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, INSTANCE_ID               nvarchar(30)             
			, FP_PLAN_ID 				nvarchar(30)
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, CATEGORY_ID               nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, ITEM_ID 					nvarchar(150)
			, OPERATION_ID 				nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, LOCATION 					nvarchar(30)
			, PRODUCTION_TYPE			nvarchar(30)
			, MARKET 					nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ELECTRODE_TYPE 			nvarchar(30)
			, PLAN_DATE 				datetime
			, TOP_ITEM_ID               nvarchar(30)
            , ITEM_TYPE                 nvarchar(150)
			, IN_QTY					numeric(20, 10)	
			, OUT_QTY					numeric(20, 10)	
			, CELL_IN_QTY				numeric(20, 10)	
			, CELL_OUT_QTY              numeric(20, 10)
			, DATE_SEQ                  int
			, INSERT_ID                 nvarchar(150)
			, INSERT_TIME               datetime
			, UPDATE_ID                 nvarchar(150)
			, UPDATE_TIME               datetime
			, PLM_EC_NO  				nvarchar(50)
			, VERSION 					nvarchar(10)
			, _MSG                      nvarchar(max)
			, _VALID                    nvarchar(max)
			)
			;

	create table #BUF_AMEND_TEMP (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, INSTANCE_ID               nvarchar(30)             
			, FP_PLAN_ID 				nvarchar(30)
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, CATEGORY_ID               nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, ITEM_ID 					nvarchar(150)
			, OPERATION_ID 				nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, LOCATION 					nvarchar(30)
			, PRODUCTION_TYPE			nvarchar(30)
			, MARKET 					nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ELECTRODE_TYPE 			nvarchar(30)
			, PLAN_DATE 				nvarchar(10)
			, TOP_ITEM_ID               nvarchar(30)
            , ITEM_TYPE                 nvarchar(150)
			, QTY						numeric(20, 10)	
			, DATE_SEQ                  int
			, PLM_EC_NO  				nvarchar(50)
			, VERSION 					nvarchar(10)
	        , [JOB_USER_ID]				[nvarchar](50) 
	        , [JOB_TIME]				[datetime] 
	        , [JOB_TYPE]				[nvarchar](50) 
	        , [JOB_ORDER]				[int] 
			)
			;

	CREATE TABLE #INVALID_MSG (
			  [ITEM_ID]					[nvarchar](max)
			, _MSG                      nvarchar(max)
			)
			;

	CREATE TABLE #SCM_YIELD_M (
			  [COMPANY_ID]				[nvarchar](30) 
			, [DIVISION_ID]				[nvarchar](30) 
			, [SITE_ID]					[nvarchar](30) 
			, [PLANT_ID]				[nvarchar](30) 
			, [FACTORY_ID]				[nvarchar](30) 
			, [OPERATION_ID]			[nvarchar](30) 
			, [LINE_ID]					[nvarchar](30) 
			, [ITEM_ID]					[nvarchar](150)
			, PLAN_DATE 				datetime	   
			, YIELD						numeric(18, 6)
			)
			;

	declare @INSTANCE_ID				nvarchar(30)       
	declare @FP_PLAN_ID 				nvarchar(30)	   
	declare @company_id					nvarchar(30)	   
	declare @DIVISION_ID 				nvarchar(30)	   
	declare @CATEGORY_ID                nvarchar(30)	   
	declare @SITE_ID 					nvarchar(30)	   
	declare @PLANT_ID 					nvarchar(30)	   
	declare @ITEM_ID 					nvarchar(150)	   
	declare @OPERATION_ID 				nvarchar(30)	   
	declare @FACTORY_ID 				nvarchar(30)	   
	declare @LOCATION 					nvarchar(30)	   
	declare @PRODUCTION_TYPE			nvarchar(30)	   
	declare @MARKET 					nvarchar(30)	   
	declare @LINE_ID 					nvarchar(30)	   
	declare @ELECTRODE_TYPE 			nvarchar(30)	   
	declare @PLAN_DATE 					datetime		   
	declare @TOP_ITEM_ID				nvarchar(30)	   
	declare @ITEM_TYPE                  nvarchar(150)	
	declare @IN_QTY						numeric(20, 10)	 
    declare @OUT_QTY					numeric(20, 10)	   
	declare @CELL_IN_QTY				numeric(20, 10)	 
    declare @CELL_OUT_QTY               numeric(20, 10)	   
    declare @DATE_SEQ                   int		
	declare @INSERT_ID					nvarchar(150)
	declare @INSERT_TIME				datetime
	declare @UPDATE_ID					nvarchar(150)
	declare @UPDATE_TIME				datetime	
	declare @PLM_EC_NO  				nvarchar(50)	   
	declare @VERSION 					nvarchar(10)	   
	declare @_MSG                       nvarchar(max)
	declare @_VALID                     nvarchar(max)

	declare @YIELD                      numeric(20, 10)
	declare @CHILD_YIELD                numeric(20, 10)
	DECLARE @ACCUM_QTY					numeric(20, 10)
	declare @XLS_OUT_QTY                numeric(20, 10)

	declare @INVALID_COUNT              int
	declare @INVALID_MSG                nvarchar(max)

	BEGIN TRY	
	

		
		insert into #BUF_AMEND_TEMP
			 ( INSTANCE_ID   
			 , FP_PLAN_ID 	
			 , COMPANY_ID    
			 , DIVISION_ID 	
			 , CATEGORY_ID   
			 , SITE_ID 		
			 , PLANT_ID 		
			 , ITEM_ID 		
			 , OPERATION_ID 	
			 , FACTORY_ID 	
			 , LOCATION 		
			 , PRODUCTION_TYPE
			 , MARKET 		
			 , LINE_ID 		
			 , ELECTRODE_TYPE
			 , PLAN_DATE 	
			 , TOP_ITEM_ID   
			 , ITEM_TYPE     
			 , QTY	
			 , DATE_SEQ  
			 , PLM_EC_NO  	
			 , VERSION 
			 , [JOB_USER_ID]		
			 , [JOB_TIME]		
			 , [JOB_TYPE]		
			 , [JOB_ORDER]		  
		
		)
		SELECT A.INSTANCE_ID
		     , A.FP_PLAN_ID
		     , B.COMPANY_ID
		     , A.DIVISION_ID
		     , A.CATEGORY_ID
		     , A.SITE_ID
		     , A.PLANT_ID
		     , A.ITEM_ID
		     , A.OPERATION_ID
		     , A.FACTORY_ID
		     , A.LOCATION
		     , A.PRODUCTION_TYPE
		     , A.MARKET
		     , A.LINE_ID
		     , A.ELECTRODE_TYPE
		     , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
		     , A.TOP_ITEM_ID
		     , A.ITEM_TYPE
		     , A.CELL_OUT_QTY AS QTY
		     , A.DATE_SEQ
		     , A.PLM_EC_NO
		     , A.VERSION 
		     , A.JOB_USER_ID
		     , A.JOB_TIME
		     , A.JOB_TYPE
		     , A.JOB_ORDER
		  FROM BUF_AMEND_PLAN_CELL_R_XLS A WITH(NOLOCK)
		       LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)
		    ON A.DIVISION_ID		= B.DIVISION_ID
		   AND A.SITE_ID			= B.SITE_ID
		   AND A.PLANT_ID			= B.PLANT_ID
		   AND A.FACTORY_ID			= B.FACTORY_ID
		   AND B.ACTIVE_FLAG		= 'Y'
		 WHERE A.JOB_USER_ID		= @v_user_id
		   and a.instance_id		= @v_instance_id
		   AND A.fp_plan_id			= @v_fp_plan_id
		   and a.operation_id		!= 'A7000'



		--A7000 : MONO Cell
	    insert into #BUF_AMEND_TEMP       
			 ( 									 	
               [INSTANCE_ID]					  
             , [FP_PLAN_ID]						
             , [COMPANY_ID]						  
             , [DIVISION_ID]					
             , [CATEGORY_ID]						
             , [SITE_ID]						
             , [PLANT_ID]								
             , [ITEM_ID]						
             , [OPERATION_ID]							
             , [FACTORY_ID]						
             , [LOCATION]							
             , [PRODUCTION_TYPE]				
             , [MARKET]							
             , [LINE_ID]						
             , [ELECTRODE_TYPE]					 
             , [PLAN_DATE]						 
             , [TOP_ITEM_ID]					  
             , [ITEM_TYPE]						  
             , QTY			
             , [DATE_SEQ]
             , [PLM_EC_NO]							
             , [VERSION]	
			 , [JOB_USER_ID]		
			 , [JOB_TIME]		
			 , [JOB_TYPE]		
			 , [JOB_ORDER]			 
			 )
		select 
               x.[INSTANCE_ID]					  
             , x.[FP_PLAN_ID]						
             , x.[COMPANY_ID]						  
             , x.[DIVISION_ID]					
             , x.[CATEGORY_ID]						
             , x.[SITE_ID]						
             , x.[PLANT_ID]								
             , y.[CHILD_ITEM_ID]						
             , 'A7000' as [OPERATION_ID]							
             , x.[FACTORY_ID]						
             , x.[LOCATION]							
             , x.[PRODUCTION_TYPE]				
             , x.[MARKET]							
             , x.[LINE_ID]						
             , z.[ELECTRODE_TYPE]					 
             , x.[PLAN_DATE]						 
             , x.[TOP_ITEM_ID]					  
             , 'Mono-Type Cell' as [ITEM_TYPE]						  
             , x.QTY				
             --, x.[DATE_SEQ]
			 , case when x.QTY = 0 then 0
			        else DENSE_RANK() OVER (PARTITION BY x.instance_id, x.fp_plan_id,  x.company_id, x.division_id, x.site_id, x.plant_id, x.operation_id, x.factory_id, x.location, x.line_id, z.electrode_type, x.plan_date
				                                ORDER BY x.ITEM_ID, x.TOP_ITEM_ID) 
					end as DATE_SEQ
             , x.[PLM_EC_NO]							
             , x.[VERSION]
			 , X.[JOB_USER_ID]		
			 , X.[JOB_TIME]		
			 , X.[JOB_TYPE]		
			 , X.[JOB_ORDER]				 
          from #BUF_AMEND_TEMP as x with(nolock)
               join scm_bom_m AS Y with(nolock)
            on x.company_id		= y.company_id
           and x.division_id	= y.division_id
           and x.SITE_ID		= y.site_id
           and x.plant_id		= y.plant_id
           and x.item_id		= y.parent_item_id
           and y.child_item_id like 'AMCMC%'
           and x.plan_date		>= y.eff_start_date
           and x.plan_date		< y.eff_end_date
		       join scm_line_m as z with(nolock)
            on x.company_id = z.company_id
		   and x.division_id = z.division_id
		   and x.site_id = z.site_id
		   and x.plant_id = z.plant_id
		   and x.factory_id = z.factory_id
		   and x.line_id = z.line_id
		   and z.operation_id = 'A7000'
		   and z.active_flag = 'Y'
         where 1 =1
           and x.operation_id	= 'A8000'


		--A7000: Half Cell
	    insert into #BUF_AMEND_TEMP       
			 ( 									 	
               [INSTANCE_ID]					  
             , [FP_PLAN_ID]						
             , [COMPANY_ID]						  
             , [DIVISION_ID]					
             , [CATEGORY_ID]						
             , [SITE_ID]						
             , [PLANT_ID]								
             , [ITEM_ID]						
             , [OPERATION_ID]							
             , [FACTORY_ID]						
             , [LOCATION]							
             , [PRODUCTION_TYPE]				
             , [MARKET]							
             , [LINE_ID]						
             , [ELECTRODE_TYPE]					 
             , [PLAN_DATE]						 
             , [TOP_ITEM_ID]					  
             , [ITEM_TYPE]						  
             , QTY			
             , [DATE_SEQ]
             , [PLM_EC_NO]							
             , [VERSION]	
			 , [JOB_USER_ID]		
			 , [JOB_TIME]		
			 , [JOB_TYPE]		
			 , [JOB_ORDER]			 
			 )
		select instance_id
		     , fp_plan_id
			 , company_id
			 , division_id
			 , category_id
			 , site_id
			 , plant_id
			 , child_item_id as item_id
			 , operation_id
			 , factory_id
			 , location
			 , production_type
			 , market
			 , line_id   --, factory_id + 'AH1' as line_id
			 , electrode_type 
			 , plan_date
			 , top_item_id
			 , max(item_type) as item_type
             , sum(QTY) as QTY
			 , case when sum(QTY) = 0 then 0 
			        else DENSE_RANK() OVER (PARTITION BY a.INSTANCE_ID, a.FP_PLAN_ID, a.FACTORY_ID, a.OPERATION_ID, a.LOCATION, a.LINE_ID, a.ELECTRODE_TYPE, a.PLAN_DATE ORDER BY A.child_item_id)
					end as date_seq
             , max(plm_ec_no) as plm_ec_no
			 --, plm_ec_no
			 , max(version) as version
			 --, version
			 , max(job_user_id) as job_user_id
			 , max(job_time) as job_time
			 , max(job_type) as job_type
			 , max(job_order) as job_order
         from (
               select 
                      x.[INSTANCE_ID]					  
                    , x.[FP_PLAN_ID]						
                    , x.[COMPANY_ID]						  
                    , x.[DIVISION_ID]					
                    , x.[CATEGORY_ID]						
                    , x.[SITE_ID]						
                    , x.[PLANT_ID]								
                    , y.[CHILD_ITEM_ID]						
                    , 'A7000' as [OPERATION_ID]							
                    , x.[FACTORY_ID]						
                    , x.[LOCATION]							
                    , x.[PRODUCTION_TYPE]				
                    , x.[MARKET]							
					, z.line_id   -- half 라인
				    , z.ELECTRODE_TYPE -- , 'Half' as [ELECTRODE_TYPE]	
                    , x.[PLAN_DATE]						 
                    , x.[TOP_ITEM_ID]					  
                    , 'HALF-Type Cell' as [ITEM_TYPE]						  
                    , x.[QTY] / z.line_count as QTY	--half-cell line 수로 나눔			
                    , x.[DATE_SEQ]
                    , x.[PLM_EC_NO]							
                    , x.[VERSION]						
			        , X.[JOB_USER_ID]		
			        , X.[JOB_TIME]		
			        , X.[JOB_TYPE]		
			        , X.[JOB_ORDER]
                 from (
						SELECT INSTANCE_ID           
							 , FP_PLAN_ID 			
							 , COMPANY_ID            
							 , DIVISION_ID 			
							 , CATEGORY_ID           
							 , SITE_ID 				
							 , PLANT_ID 				
							 , ITEM_ID 				
							 , OPERATION_ID 			
							 , FACTORY_ID 			
							 , LOCATION 				
							 , PRODUCTION_TYPE		
							 , MARKET 				
							 , LINE_ID 				
							 , ELECTRODE_TYPE 		
							 , PLAN_DATE 			
							 , TOP_ITEM_ID           
							 , ITEM_TYPE             
							 , QTY				
							 , DATE_SEQ              
							 , PLM_EC_NO  			
							 , VERSION 	
			                 , [JOB_USER_ID]		
			                 , [JOB_TIME]		
			                 , [JOB_TYPE]		
			                 , 1				as JOB_ORDER								  
						  FROM #BUF_AMEND_TEMP
                         where 1 = 1
						   and operation_id		= 'A8000'

                        UNION ALL

						SELECT INSTANCE_ID           
							 , FP_PLAN_ID 			
							 , COMPANY_ID            
							 , DIVISION_ID 			
							 , CATEGORY_ID           
							 , SITE_ID 				
							 , PLANT_ID 				
							 , ITEM_ID 				
							 , OPERATION_ID 			
							 , FACTORY_ID 			
							 , LOCATION 				
							 , PRODUCTION_TYPE		
							 , MARKET 				
							 , LINE_ID 				
							 , ELECTRODE_TYPE 		
							 , CONVERT(VARCHAR, PLAN_DATE, 112) AS PLAN_DATE	
							 , TOP_ITEM_ID           
							 , ITEM_TYPE             
							 , CELL_OUT_QTY AS QTY         
							 , DATE_SEQ              
							 , PLM_EC_NO  			
							 , VERSION 	
							 , @v_user_id		as JOB_USER_ID
							 , UPDATE_TIME		as JOB_TIME
							 , 'EXCEL'			as JOB_TYPE
							 , 1				as JOB_ORDER
						  FROM FP_AMEND_PLAN_CELL_R as x with(nolock)
						 where 1 = 1
						   and instance_id		= @v_instance_id   
						   and fp_plan_id		= @v_fp_plan_id
						   and operation_id		= 'A8000'
						   -- buf 데이터 제외
						   and not exists (
						                    select 1
											  from #BUF_AMEND_TEMP as y
											 where x.instance_id		= y.instance_id
											   and x.fp_plan_id			= y.fp_plan_id
											   and x.division_id		= y.division_id
											   and x.plant_id			= y.plant_id
											   and x.item_id			= y.item_id
											   and x.operation_id		= y.operation_id
											   and x.factory_id			= y.factory_id
											   and x.location			= y.location
											   and x.production_type	= y.production_type
											   and x.market				= y.market
											   and x.line_id			= y.line_id
											   and x.electrode_type		= y.electrode_type
											   and x.plan_date			= y.plan_date
											   and x.top_item_id		= y.top_item_id
											   and x.plm_ec_no			= y.plm_ec_no
											   and x.version			= y.version
											   and y.operation_id		= 'A8000'

						       )
						   -- buf에 해당하는 공정/일자 만
						   and exists (
						                    select 1
											  from #BUF_AMEND_TEMP as y
											 where x.instance_id		= y.instance_id
											   and x.fp_plan_id			= y.fp_plan_id
											   and x.division_id		= y.division_id
											   and x.plant_id			= y.plant_id
											   and x.item_id			= y.item_id
											   and x.operation_id		= y.operation_id
											   and x.factory_id			= y.factory_id
											   and x.location			= y.location
											   and x.production_type	= y.production_type
											   and x.market				= y.market
											  -- and x.line_id			!= y.line_id
											   and x.electrode_type		= y.electrode_type
											   and x.plan_date			= y.plan_date
											   and x.top_item_id		= y.top_item_id
											   and x.plm_ec_no			= y.plm_ec_no
											   and x.version			= y.version
											   and y.operation_id		= 'A8000'			   

						       )

					  ) as x
                      join scm_bom_m AS Y with(nolock)
                   on x.company_id = y.company_id
                  and x.division_id = y.division_id
                  and x.SITE_ID = y.site_id
                  and x.plant_id = y.plant_id
                  and x.item_id = y.parent_item_id
                  and y.child_item_id like 'AHCHC%'
                  and x.plan_date >= y.eff_start_date
                  and x.plan_date < y.eff_end_date
				  --multi half line 
				      join (select company_id, division_id, site_id, plant_id, factory_id, line_id, electrode_type
                                 , count(*) over (partition by factory_id) as line_count
                              from (
                                   select distinct company_id, division_id, site_id, plant_id, factory_id, line_id, electrode_type
                                     from FP_AMEND_PLAN_CELL_R with(nolock)
                                    where 1 = 1
                                      and instance_id	= @v_instance_id
                                      and fp_plan_id	= @v_fp_plan_id
                                      and operation_id = 'A7000'
                                      and line_id like factory_id + '_H%' 
                                   ) as line
					  ) as z
                   on x.company_id		= z.company_id
				  and x.division_id		= z.division_id
				  and x.site_id			= z.site_id
				  and x.plant_id		= z.plant_id
				  and x.factory_id		= z.factory_id
				  --
                where 1 =1
				  and z.line_count > 0

             ) as a
         group by 
	           instance_id, fp_plan_id, company_id, division_id, category_id, site_id, plant_id, line_id, child_item_id, top_item_id
	         , operation_id, factory_id, location, production_type, market, electrode_type, plan_date 
			 --, plm_ec_no, version


	
	    -- validation
	    insert into #BUF_AMEND_PLAN_CELL_R_XLS       
		     ( 									 	
               [INSTANCE_ID]					  
             , [FP_PLAN_ID]						
             , [COMPANY_ID]						  
             , [DIVISION_ID]					
             , [CATEGORY_ID]						
             , [SITE_ID]						
             , [PLANT_ID]								
             , [ITEM_ID]						
             , [OPERATION_ID]							
             , [FACTORY_ID]						
             , [LOCATION]							
             , [PRODUCTION_TYPE]				
             , [MARKET]							
             , [LINE_ID]						
             , [ELECTRODE_TYPE]					 
             , [PLAN_DATE]						 
             , [TOP_ITEM_ID]					  
             , [ITEM_TYPE]						  
             , [CELL_OUT_QTY]						
             , [DATE_SEQ]
			 , INSERT_ID             
             , INSERT_TIME           
             , UPDATE_ID             
             , UPDATE_TIME   
             , [PLM_EC_NO]							
             , [VERSION]						
             , _MSG                  			
             , _VALID   
			 )
		
		SELECT 
               A.[INSTANCE_ID]         
             , A.[FP_PLAN_ID]
             , A.[COMPANY_ID]
             , A.[DIVISION_ID]
             , A.[CATEGORY_ID]
             , A.[SITE_ID]
             , A.[PLANT_ID]
             , A.[ITEM_ID]
             , A.[OPERATION_ID]
             , A.[FACTORY_ID]
             , A.[LOCATION]
             , A.[PRODUCTION_TYPE]
             , A.[MARKET]
             , A.[LINE_ID]
             , A.[ELECTRODE_TYPE]
             , A.[PLAN_DATE]
             , A.[TOP_ITEM_ID]
             , A.[ITEM_TYPE]
             , A.QTY as CELL_OUT_QTY
             , A.[DATE_SEQ]
 			 , A.JOB_USER_ID             
             , dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME           
             , A.JOB_USER_ID             
             , dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME   
             , A.[PLM_EC_NO]
             , A.[VERSION]	
             , CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
                    ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
                    END AS _MSG
             , CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
          FROM (
                SELECT TT.*
                     , MSG1
                       + (CASE WHEN (MSG1 = '')                                                                                                                                 THEN MSG2  ELSE (CASE WHEN MSG2 = ''  THEN '' ELSE ',' + MSG2  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                                                   THEN MSG3  ELSE (CASE WHEN MSG3 = ''  THEN '' ELSE ',' + MSG3  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                                                     THEN MSG4  ELSE (CASE WHEN MSG4 = ''  THEN '' ELSE ',' + MSG4  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                                                       THEN MSG5  ELSE (CASE WHEN MSG5 = ''  THEN '' ELSE ',' + MSG5  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                                                         THEN MSG6  ELSE (CASE WHEN MSG6 = ''  THEN '' ELSE ',' + MSG6  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '')                                                           THEN MSG7  ELSE (CASE WHEN MSG7 = ''  THEN '' ELSE ',' + MSG7  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '')                                             THEN MSG8  ELSE (CASE WHEN MSG8 = ''  THEN '' ELSE ',' + MSG8  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '')                               THEN MSG9  ELSE (CASE WHEN MSG9 = ''  THEN '' ELSE ',' + MSG9  END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '')                 THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '')  THEN MSG11 ELSE (CASE WHEN MSG11 = '' THEN '' ELSE ',' + MSG11 END) END)
                       + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '' AND MSG11 = '')  THEN MSG12 ELSE (CASE WHEN MSG12 = '' THEN '' ELSE ',' + MSG12 END) END)
                       + ' Not Found' AS __MSG
                  FROM (
                         SELECT DISTINCT
                                A.INSTANCE_ID
							  , A.FP_PLAN_ID
							  , A.COMPANY_ID
							  , A.DIVISION_ID
							  , A.CATEGORY_ID
							  , A.SITE_ID
							  , A.PLANT_ID
                              , A.ITEM_ID
							  , B.NICK_NAME
							  , B.ITEM_TYPE
							  , A.TOP_ITEM_ID
                              , A.OPERATION_ID
							  , A.FACTORY_ID
                              , A.PRODUCTION_TYPE
							  , A.MARKET
                              , A.LINE_ID
							  , A.ELECTRODE_TYPE
							  , A.LOCATION
                              , A.PLAN_DATE
							  , A.QTY
							  , A.DATE_SEQ
                              , A.PLM_EC_NO
							  , A.VERSION 
                              , A.JOB_USER_ID
							  , A.JOB_TIME
							  , A.JOB_TYPE
							  , A.JOB_ORDER
                              , CASE WHEN A.COMPANY_ID IS NULL THEN 'Building' ELSE '' END AS MSG1
                              , CASE WHEN A.QTY > 0 THEN (CASE WHEN B.ITEM_ID IS NULL THEN (CASE WHEN A.PRODUCTION_TYPE IN ('TEST','D-TEST','E-TEST') AND A.TOP_ITEM_ID = A.ITEM_ID THEN '' ELSE 'BOM' END) ELSE '' END)
                                                   ELSE '' END  AS MSG2
                              , CASE WHEN C.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG3
                              , CASE WHEN D.LINE_ID IS NULL THEN 'Line - Electrode Type - Location' ELSE '' END AS MSG4
                              , CASE WHEN E.CODE_ID IS NULL THEN 'Production Type' ELSE '' END AS MSG5
                              , CASE WHEN F.CODE_ID IS NULL THEN 'Market' ELSE '' END AS MSG6
                              , CASE WHEN M.ITEM_ID IS NULL THEN 'Material' ELSE '' END AS MSG7
                              , (CASE WHEN O.IS_CELL_ASSY = 'Y' AND A.OPERATION_ID IN ('A3000','A9000') AND A.TOP_ITEM_ID = A.ITEM_ID THEN 'not allowed cell product material' ELSE '' END) AS MSG8 
                              , CASE WHEN A.QTY > 0 THEN (CASE WHEN E._4MCC_TARGET_FLAG = 'Y'  AND P.VERSION IS NULL  THEN 'VERSION' 
                                                               WHEN E._4MCC_TARGET_FLAG <> 'Y' AND A.VERSION <> '-' THEN ' - Version' 
                                                               ELSE '' END) ELSE '' END AS MSG9 
                              , CASE WHEN A.QTY > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN 'Line Assign' ELSE '' END ) ELSE '' END AS MSG10
                              , CASE WHEN A.QTY > 0 THEN ( CASE WHEN K.KEY_VALUE = 'DAILY_CAPA' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN 'Daily Capa' ELSE '' END)
                                                               ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN 'Tact Time' ELSE '' END) END ) ELSE '' END AS MSG11
					          , CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG12
                              , CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE, A.PLM_EC_NO, A.VERSION 
            		          		                     ORDER BY     A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE, A.PLM_EC_NO, A.VERSION )>1 THEN 'Data Overlap'
            		          		      ELSE '' END AS MSG99
                          FROM #BUF_AMEND_TEMP AS A
                               LEFT OUTER JOIN (
                                                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.MODEL_ID, A.ITEM_ID
                                                      , ISNULL(A.NICK_NAME,'-') AS NICK_NAME,
                                                        (CASE WHEN LEFT(A.FLOW_ID,5) = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN C.LEVEL_3_NAME
                                                        	    WHEN LEFT(A.FLOW_ID,5) = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-')
                                                              ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE
                                                   FROM SCM_ITEM_M A WITH(NOLOCK)
                                                   	  , SCM_MODEL_COMP_EFFECTIVE_DATE B WITH(NOLOCK)
                                                   	  , SCM_ITEM_CLASS_M C WITH(NOLOCK)
                                                      , (
                                                          SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID
                                                            FROM FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)
                                                           WHERE A.COMPANY_ID   = B.COMPANY_ID
                                                             AND A.DIVISION_ID  = B.DIVISION_ID
                                                             AND A.SITE_ID      = B.SITE_ID
                                                             AND A.OPERATION_ID = B.OPERATION_ID
                                                             AND A.INSTANCE_ID  = @v_instance_id
                                                             AND A.AMEND_FLAG   = 'Y'
                                                             AND B.ACTIVE_FLAG  = 'Y'
                                                        ) D
                                                  WHERE A.COMPANY_ID  = B.COMPANY_ID
                                                    AND A.DIVISION_ID = B.DIVISION_ID
                                                    AND A.SITE_ID     = B.SITE_ID
                                                    AND A.ITEM_ID     = B.CHILD_ITEM_ID
                                                    AND A.ITEM_CLASS  = C.CLASS_ID
                                                    AND A.COMPANY_ID  = D.COMPANY_ID
                                                    AND A.DIVISION_ID = D.DIVISION_ID
                                                    AND A.SITE_ID     = D.SITE_ID
                                                    AND A.FLOW_ID LIKE '%' + D.OPERATION_ID + '%'
                                                    AND A.ACTIVE_FLAG = 'Y'
                                                    AND C.USE_FLAG = 'Y'
                                                    AND B.EFF_END_DATE >= GETDATE()
                               ) B
                           ON  A.COMPANY_ID      = B.COMPANY_ID
                           AND A.DIVISION_ID     = B.DIVISION_ID
                           AND A.SITE_ID         = B.SITE_ID
                           AND A.PLANT_ID        = B.PLANT_ID
                           AND A.TOP_ITEM_ID     = B.MODEL_ID
                           AND A.ITEM_ID         = B.ITEM_ID
                               LEFT OUTER JOIN SCM_OPERATION_M C WITH(NOLOCK)
                           ON  A.COMPANY_ID      = C.COMPANY_ID
                           AND A.DIVISION_ID     = C.DIVISION_ID
                           AND A.SITE_ID         = C.SITE_ID
                           AND A.OPERATION_ID    = C.OPERATION_ID
                           AND C.ACTIVE_FLAG     = 'Y'
                               LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)
                           ON  A.COMPANY_ID      = D.COMPANY_ID
                           AND A.DIVISION_ID     = D.DIVISION_ID
                           AND A.SITE_ID         = D.SITE_ID
                           AND A.PLANT_ID        = D.PLANT_ID
                           AND A.FACTORY_ID      = D.FACTORY_ID
                           AND A.OPERATION_ID    = D.OPERATION_ID
                           AND A.LINE_ID         = D.LINE_ID
                           AND A.LOCATION        = ISNULL(D.LOCATION,'-')
                           AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE
                           AND D.ACTIVE_FLAG     = 'Y'
                               LEFT OUTER JOIN (
                                                 SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID, (CASE WHEN ATTRIBUTE5 = 'Y' AND ATTRIBUTE6 = 'Y' THEN 'Y' ELSE 'N' END) AS _4MCC_TARGET_FLAG 
                                                 FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                                                 WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                                                 AND    A.ACTIVE_FLAG = 'Y'
                               ) E
                           ON  A.PRODUCTION_TYPE = E.CODE_ID
                           AND A.DIVISION_ID = E.SEGMENT1
                           LEFT OUTER JOIN (
                               SELECT A.SEGMENT1 AS CODE_ID
                               FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                               WHERE  A.LOOKUP_TYPE_CODE = 'DEMAND_MARKET_TYPE'
                               AND    A.ACTIVE_FLAG = 'Y'
                           ) F
                           ON  A.MARKET = F.CODE_ID
                               LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)
                           ON  A.COMPANY_ID     = I.COMPANY_ID
                           AND A.DIVISION_ID    = I.DIVISION_ID
                           AND A.SITE_ID        = I.SITE_ID
                           AND A.PLANT_ID       = I.PLANT_ID
                           AND A.FACTORY_ID     = I.FACTORY_ID
                           AND A.ITEM_ID        = I.ITEM_ID
                           AND A.OPERATION_ID   = I.OPERATION_ID
                           AND A.LINE_ID        = I.LINE_ID
                           AND A.ELECTRODE_TYPE = I.ELECTRODE_TYPE
                           AND SUBSTRING(A.PLAN_DATE,1,6) = I.MONTH
                           AND I.ACTIVE_FLAG    = 'Y'
                           AND I.PRIORITY NOT IN ('0','9')
                               LEFT OUTER JOIN SCM_TACT_TIME_M J WITH(NOLOCK)
                           ON  A.COMPANY_ID      = J.COMPANY_ID
                           AND A.DIVISION_ID     = J.DIVISION_ID
                           AND A.SITE_ID         = J.SITE_ID
                           AND A.PLANT_ID        = J.PLANT_ID
                           AND A.FACTORY_ID      = J.FACTORY_ID
                           AND A.ITEM_ID         = J.ITEM_ID
                           AND A.OPERATION_ID    = J.OPERATION_ID
                           AND A.LINE_ID         = J.LINE_ID
                           AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE
                           AND SUBSTRING(A.PLAN_DATE,1,6) = J.MONTH
                               LEFT OUTER JOIN FP_INSTANCE_CONFIG_M K WITH(NOLOCK)
                           ON  A.INSTANCE_ID     = K.INSTANCE_ID
                           AND K.KEY_ID          = 'FINAL_OP_CAPA'
          	                   LEFT OUTER JOIN SCM_ITEM_M M WITH(NOLOCK)
          	               ON  A.COMPANY_ID  = M.COMPANY_ID
          	               AND A.DIVISION_ID = M.DIVISION_ID
          	               AND A.SITE_ID     = M.SITE_ID
          	               AND A.ITEM_ID     = M.ITEM_ID
          	               AND M.ACTIVE_FLAG = 'Y'
          	                   LEFT OUTER JOIN ( 
          	               	                     SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY 
          	               	                     FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK) 
          	               	                     WHERE  B.ACTIVE_FLAG = 'Y' 
          	               	                     AND    B.ATTRIBUTE1 = 'Y' 
          	               	                     AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY_INSTANCE' 
          	               	                     AND    B.SEGMENT1 IN ( 
          	               	                     	SELECT MAX(INSTANCE_ID) 
          	               	                     	FROM   BUF_AMEND_PLAN_CELL_R_XLS A WITH(NOLOCK) 
				                                  		WHERE    A.JOB_USER_ID = @v_user_id
				                                  		and a.instance_id = @v_instance_id
		                                                  AND A.fp_plan_id = @v_fp_plan_id
          	               	                     ) 
          	                                   ) O 
          	               ON  1 = 1 
          	                   LEFT OUTER JOIN ( 
          	               	                     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
          	               	                     	 , B.OPERATION_ID 
          	               	                     	 , A.MARKET, A.PRODUCTION_TYPE , A.VERSION 
          	               	                     FROM ( 
          	               	                     	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
          	               	                     		 , A.OPERATION_ID, A.LINE_ID 
          	               	                     		 , A.MARKET, A.PRODUCTION_TYPE, A.PLM_EC_NO, A.VERSION 
          	               	                     	FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK) 
          	               	                     	, ( 
          	               	                     		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID 
          	               	                     		FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) 
          	               	                     		WHERE  A.INSTANCE_ID  = @v_instance_id
          	               	                     		AND    A.OPERATION_ID IN ('A3000','A9000') 
          	               	                     		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID 
          	               	                     	) B 
          	               	                     	WHERE  1=1 
          	               	                     	AND    A.COMPANY_ID   = B.COMPANY_ID 
          	               	                     	AND    A.DIVISION_ID  = B.DIVISION_ID 
          	               	                     	AND    A.SITE_ID      = B.SITE_ID 
          	               	                     	AND    A.PLANT_ID     = B.PLANT_ID 
          	               	                     	AND    A.FACTORY_ID   = B.FACTORY_ID 
          	               	                     	AND    A.OPERATION_ID = B.OPERATION_ID 
          	               	                     	AND    A.MFG_WEEK >= (SELECT (ISO_YYYYWW) FROM TH_UIS_CAL B WITH(NOLOCK) WHERE YYYYMMDD = FORMAT(getdate(), 'yyyyMMdd') )
          	               	                     	AND    A.OPERATION_ID IN ('A3000','A9000') 
          	               	                     	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
          	               	                     		   , A.OPERATION_ID, A.LINE_ID 
          	               	                     		   , A.MARKET, A.PRODUCTION_TYPE, A.PLM_EC_NO, A.VERSION 
          	               	                     ) A 
          	               	                     LEFT OUTER JOIN ( 
          	               	                     	SELECT A.OPERATION_ID 
          	               	                     	FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK) 
          	               	                     	WHERE  A.INSTANCE_ID  = @v_instance_id
          	               	                     	AND    A.AMEND_FLAG   = 'Y' 
          	  		                               GROUP BY A.OPERATION_ID 
          	  	                                 ) B 
          	  	                             ON  1 = 1 
          	                   ) P 
          	               ON  1 = 1 
          	               AND A.COMPANY_ID      = P.COMPANY_ID 
          	               AND A.DIVISION_ID     = P.DIVISION_ID 
          	               AND A.SITE_ID         = P.SITE_ID 
          	               AND A.PLANT_ID        = P.PLANT_ID 
          	               AND A.FACTORY_ID      = P.FACTORY_ID 
          	               AND A.OPERATION_ID    = P.OPERATION_ID 
          	               AND A.MARKET          = P.MARKET 
          	               AND A.PRODUCTION_TYPE = P.PRODUCTION_TYPE 
          	               AND A.VERSION       = P.VERSION 
          	  	               LEFT OUTER JOIN (
												SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
												FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)
												WHERE	1=1
												AND		R.USER_ID		= @v_user_id
												AND		R.SAVE_FLAG		= 'Y'
												AND		R.INSTANCE_ID	= @v_instance_id
				               ) R
				           ON  1 = 1
				           AND A.COMPANY_ID			= R.COMPANY_ID
				           AND A.DIVISION_ID		= R.DIVISION_ID
				           AND A.SITE_ID			= R.SITE_ID
				           AND A.PLANT_ID			= R.PLANT_ID
				           AND A.FACTORY_ID			= R.FACTORY_ID
				           AND A.OPERATION_ID		= R.OPERATION_ID
				           AND A.LINE_ID			= R.LINE_ID

                       ) TT
		       ) A
         --where CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END = 'Y'
         --ORDER BY A.JOB_ORDER





		insert into #SCM_YIELD_M
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
		    , ISNULL( y.YIELD, x.YIELD) as YIELD
		 from (
		       select M.COMPANY_ID  
		       	    , M.DIVISION_ID 
		       	    , M.SITE_ID     
		       	    , M.PLANT_ID    
		       	    , M.FACTORY_ID  
		       	    , M.OPERATION_ID
		       	    , M.LINE_ID     
		       	    , M.ITEM_ID     
		       	    , M.PLAN_DATE
		       	    , isnull(CASE WHEN MAX(N.YIELD) = 0 THEN 1 ELSE MAX(N.YIELD) END, 1) AS YIELD
		         FROM #BUF_AMEND_PLAN_CELL_R_XLS AS M with(nolock)
		              LEFT OUTER JOIN SCM_YIELD_M as N WITH(NOLOCK)
		           ON 1 = 1
		          and M.COMPANY_ID   = N.COMPANY_ID  
		          and M.DIVISION_ID  = N.DIVISION_ID 
		          AND M.SITE_ID      = N.SITE_ID     
		          AND M.PLANT_ID     = N.PLANT_ID    
		          AND M.FACTORY_ID   = N.FACTORY_ID  
		          AND M.OPERATION_ID = N.OPERATION_ID
		          AND M.LINE_ID      = N.LINE_ID     
		          AND M.ITEM_ID      = N.ITEM_ID     
		          AND N.MONTH        = SUBSTRING((CONVERT(VARCHAR, M.PLAN_DATE ,112)),1,6)
		        group by 
				      M.COMPANY_ID  
		       	    , M.DIVISION_ID 
		       	    , M.SITE_ID     
		       	    , M.PLANT_ID    
		       	    , M.FACTORY_ID  
		       	    , M.OPERATION_ID
		       	    , M.LINE_ID     
		       	    , M.ITEM_ID     
		       	    , M.PLAN_DATE
		      ) as x
			  left outer join (
			 		           SELECT M.COMPANY_ID  
					                , M.DIVISION_ID 
					                , M.SITE_ID     
					                , M.PLANT_ID    
					                , M.FACTORY_ID  
					                , M.OPERATION_ID
					                , M.LINE_ID     
					                , M.ITEM_ID     
					                , M.PLAN_DATE
				                    , (CASE WHEN MAX(N.YIELD) = 0 THEN 1 ELSE MAX(N.YIELD) END) AS YIELD
				                 FROM #BUF_AMEND_PLAN_CELL_R_XLS AS M with(nolock) 
				                      JOIN SCM_YIELD_EXCEPT_M AS N WITH(NOLOCK)
				                  ON  M.COMPANY_ID   = N.COMPANY_ID  
				                  AND M.DIVISION_ID  = N.DIVISION_ID 
				                  AND M.SITE_ID      = N.SITE_ID     
				                  AND M.PLANT_ID     = N.PLANT_ID    
				                  AND M.FACTORY_ID   = N.FACTORY_ID  
				                  AND M.OPERATION_ID = N.OPERATION_ID
				                  AND M.LINE_ID      = N.LINE_ID     
				                  AND M.ITEM_ID      = N.ITEM_ID     
				                  AND M.PLAN_DATE BETWEEN N.START_TIME AND N.END_TIME
				                group by 
								      M.COMPANY_ID  
					                , M.DIVISION_ID 
					                , M.SITE_ID     
					                , M.PLANT_ID    
					                , M.FACTORY_ID  
					                , M.OPERATION_ID
					                , M.LINE_ID     
					                , M.ITEM_ID     
					                , M.PLAN_DATE
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

		--invalid check
        /*
		SELECT @INVALID_COUNT = COUNT(*)
		  FROM #BUF_AMEND_PLAN_CELL_R_XLS
		 WHERE _VALID = 'N'
		
		if @INVALID_COUNT > 0
		BEGIN

			insert into #INVALID_MSG (ITEM_ID, _MSG)
			select distinct item_id, _msg
			  FROM #BUF_AMEND_PLAN_CELL_R_XLS
			 WHERE _VALID = 'N'
			   --AND OPERATION_ID != 'A7000'

			select @INVALID_MSG = stuff((
					select '|' + x.ITEM_LIST
					  from (
							SELECT SS._MSG + '(' +
								   STUFF((
										  SELECT ',' + US.ITEM_ID 
											FROM #INVALID_MSG AS US
										   WHERE US._MSG = SS._MSG
											 FOR XML PATH('')
										 ), 1, 1, ''
										) + ')' as ITEM_LIST
							  FROM #INVALID_MSG AS SS
							 group by _MSG
						   ) as x
					for xml path('')
				   ), 1, 1, '') 

			RAISERROR  ( @INVALID_MSG, 16, 1 ); 
		
		END
		--

		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #BUF_AMEND_PLAN_CELL_R_XLS
	  
		IF @MAX_NUM = 0
		BEGIN
			PRINT 'NG|' + 'No data in buf table.'
			--RAISERROR  ( 'No data in buf table or check your authority.', 16, 1 ); 
			RAISERROR  ( 'No data in buf table.', 16, 1 ); 
		END

		--BEGIN TRAN

		WHILE @INX <= @MAX_NUM
		BEGIN

			SELECT  @INSTANCE_ID			= INSTANCE_ID	
				  , @FP_PLAN_ID 			= FP_PLAN_ID 	
				  , @company_id				= company_id		
				  , @DIVISION_ID 			= DIVISION_ID 	
				  , @CATEGORY_ID			= CATEGORY_ID    
				  , @SITE_ID 				= SITE_ID 		
				  , @PLANT_ID 				= PLANT_ID 		
				  , @ITEM_ID 				= ITEM_ID 		
				  , @OPERATION_ID 			= OPERATION_ID 	
				  , @FACTORY_ID 			= FACTORY_ID 	
				  , @LOCATION 				= LOCATION 		
				  , @PRODUCTION_TYPE		= PRODUCTION_TYPE
				  , @MARKET 				= MARKET 		
				  , @LINE_ID 				= LINE_ID 		
				  , @ELECTRODE_TYPE			= ELECTRODE_TYPE 
				  , @PLAN_DATE 				= PLAN_DATE 		
				  , @TOP_ITEM_ID			= TOP_ITEM_ID	
				  , @ITEM_TYPE				= ITEM_TYPE      
				  , @CELL_OUT_QTY			= CELL_OUT_QTY   
				  , @DATE_SEQ				= DATE_SEQ       
				  , @PLM_EC_NO  			= PLM_EC_NO  	
				  , @VERSION 				= VERSION 		
				  , @INSERT_ID              = INSERT_ID
				  , @INSERT_TIME			= INSERT_TIME
				  , @UPDATE_ID				= UPDATE_ID
				  , @UPDATE_TIME			= UPDATE_TIME
				  , @_MSG					= _MSG           
				  , @_VALID					= _VALID     
			   FROM #BUF_AMEND_PLAN_CELL_R_XLS 
			  WHERE TID						= @INX


			-- YIELD 적용
			SET @YIELD			= 1
			SET @CHILD_YIELD	= 1


			SELECT @YIELD = YIELD
			  FROM #SCM_YIELD_M  
			 WHERE 1 = 1
			   AND COMPANY_ID			= @COMPANY_ID   
			   AND DIVISION_ID 			= @DIVISION_ID 	
			   AND SITE_ID     			= @SITE_ID     	
			   AND PLANT_ID    			= @PLANT_ID    	
			   AND FACTORY_ID  			= @FACTORY_ID  	
			   AND OPERATION_ID			= @OPERATION_ID	
			   AND LINE_ID     			= @LINE_ID     	
			   AND ITEM_ID     			= @ITEM_ID     	
			   AND PLAN_DATE			= @PLAN_DATE	

--PRINT ISNULL(@INSTANCE_ID,'instance_id') +'|'+ ISNULL(@FP_PLAN_ID , 'fp_plan_id')+'|'+ ISNULL(@FACTORY_ID , 'factory_id') +'|'+ ISNULL(@LOCATION, 'location') +'|'+ ISNULL(@OPERATION_ID, 'operation_id')
--            +'|'+ ISNULL(@LINE_ID, 'line_id') +'|'+ ISNULL(@ELECTRODE_TYPE, 'electrode_type') +'|'+ ISNULL(@ITEM_ID, 'item_id') +'|'+ ISNULL(@PRODUCTION_TYPE,'production_type') +'|'+ ISNULL(@VERSION, 'version') +'|'+ ISNULL(convert(nvarchar,@YIELD), 'yield') +'|'+ ISNULL(convert(nvarchar, @CHILD_YIELD), 'child_yield')

			  SET @ACCUM_QTY			= dbo.FN_GET_REQ_QTY_MODEL(@plant_id, @TOP_ITEM_ID, @ITEM_ID, @PLAN_DATE)
			  SET @CELL_OUT_QTY         = case when @OPERATION_ID = 'A7000' and @line_id like @FACTORY_ID + '_H%' and @CELL_OUT_QTY > 0 --AND @ELECTRODE_TYPE = 'Half' 
			                                   then CAST(FLOOR(@CELL_OUT_QTY + 1000 ) AS INT) / 1000 * 1000 else @CELL_OUT_QTY end

			  SET @IN_QTY				= CEILING(@CELL_OUT_QTY * @ACCUM_QTY / @YIELD)
			  SET @OUT_QTY              = FLOOR(@CELL_OUT_QTY * @ACCUM_QTY)
			  SET @CELL_IN_QTY			= CEILING(@CELL_OUT_QTY/@YIELD)
			  --

			  MERGE INTO FP_AMEND_PLAN_CELL_R A
			  USING (SELECT @INSTANCE_ID			AS INSTANCE_ID
						  , @FP_PLAN_ID				AS FP_PLAN_ID
						  , @DIVISION_ID			AS DIVISION_ID
						  , @PLANT_ID				AS PLANT_ID
						  , @ITEM_ID				AS ITEM_ID
						  , @OPERATION_ID			AS OPERATION_ID
						  , @FACTORY_ID				AS FACTORY_ID
						  , @LOCATION				AS LOCATION
						  , UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE
						  , @MARKET					AS MARKET
						  , @LINE_ID				AS LINE_ID
						  , @ELECTRODE_TYPE			AS ELECTRODE_TYPE
						  , @PLAN_DATE				AS PLAN_DATE
						  , @TOP_ITEM_ID			AS TOP_ITEM_ID
						  , @PLM_EC_NO				AS PLM_EC_NO 
						  , @VERSION				AS VERSION
					) B
				 ON A.INSTANCE_ID		= B.INSTANCE_ID 
				AND A.FP_PLAN_ID		= B.FP_PLAN_ID
				AND A.DIVISION_ID		= B.DIVISION_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.OPERATION_ID		= B.OPERATION_ID 
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.LOCATION			= B.LOCATION
				AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE 
				AND A.MARKET			= B.MARKET
				AND A.LINE_ID			= B.LINE_ID 
				AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
				AND A.PLAN_DATE			= B.PLAN_DATE
				AND A.TOP_ITEM_ID		= B.TOP_ITEM_ID 
				AND A.PLM_EC_NO			= B.PLM_EC_NO
				AND A.VERSION			= B.VERSION
			  WHEN MATCHED THEN
					UPDATE SET
					       IN_QTY				= @IN_QTY
						 , OUT_QTY				= @OUT_QTY
						 , CELL_IN_QTY          = @CELL_IN_QTY
						 , CELL_OUT_QTY         = @CELL_OUT_QTY
						 , UPDATE_ID			= @UPDATE_ID
						 , UPDATE_TIME			= @UPDATE_TIME
			  WHEN NOT MATCHED THEN
					INSERT (
						   INSTANCE_ID		
						 , FP_PLAN_ID		
						 , COMPANY_ID
						 , DIVISION_ID	
						 , CATEGORY_ID
						 , SITE_ID
						 , PLANT_ID			
						 , ITEM_ID			
						 , OPERATION_ID		
						 , FACTORY_ID		
						 , LOCATION			
						 , PRODUCTION_TYPE	
						 , MARKET			
						 , LINE_ID			
						 , ELECTRODE_TYPE	
						 , PLAN_DATE			
						 , TOP_ITEM_ID	
						 , ITEM_TYPE
						 , IN_QTY		
						 , OUT_QTY		
						 , CELL_IN_QTY   
						 , CELL_OUT_QTY  
						 , DATE_SEQ
						 , INSERT_ID
						 , INSERT_TIME
						 , UPDATE_ID
						 , UPDATE_TIME
						 , PLM_EC_NO
						 , VERSION
						 )
				  VALUES (
						   B.INSTANCE_ID		
						 , B.FP_PLAN_ID
						 , @COMPANY_ID
						 , B.DIVISION_ID	
						 , @CATEGORY_ID
						 , @SITE_ID
						 , B.PLANT_ID			
						 , B.ITEM_ID			
						 , B.OPERATION_ID		
						 , B.FACTORY_ID		
						 , B.LOCATION			
						 , B.PRODUCTION_TYPE	
						 , B.MARKET			
						 , B.LINE_ID			
						 , B.ELECTRODE_TYPE	
						 , B.PLAN_DATE			
						 , B.TOP_ITEM_ID		
						 , @ITEM_TYPE
						 , @IN_QTY		
						 , @OUT_QTY		
						 , @CELL_IN_QTY   
						 , @CELL_OUT_QTY  
						 , @DATE_SEQ
						 , @INSERT_ID
						 , @INSERT_TIME
						 , @UPDATE_ID
						 , @UPDATE_TIME
						 , B.PLM_EC_NO
						 , B.VERSION
						 )
			;

			SET @INX = @INX + 1
		END


		INSERT INTO HIS_AMEND_PLAN_CELL_R 
			(
			  INSTANCE_ID
			, FP_PLAN_ID
			, COMPANY_ID
			, DIVISION_ID
			, CATEGORY_ID
			, SITE_ID
			, PLANT_ID
			, TOP_ITEM_ID
			, ITEM_ID
			, OPERATION_ID
			, FACTORY_ID
			, ITEM_TYPE
			, LOCATION
			, PRODUCTION_TYPE
			, MARKET
			, LINE_ID
			, ELECTRODE_TYPE
			, PLAN_DATE
			, IN_QTY
			, OUT_QTY
			, CELL_IN_QTY
			, CELL_OUT_QTY
			, INSERT_ID
			, INSERT_TIME
			, UPDATE_ID
			, UPDATE_TIME
			, PLM_EC_NO
			, VERSION
			, JOB_USER_ID
			, JOB_TIME
			, JOB_TYPE
			)
	   SELECT x.INSTANCE_ID
	        , x.FP_PLAN_ID
		    , x.COMPANY_ID
			, x.DIVISION_ID
		    , x.CATEGORY_ID
		    , x.SITE_ID
			, x.PLANT_ID
			, x.TOP_ITEM_ID
			, x.ITEM_ID
			, x.OPERATION_ID
			, x.FACTORY_ID
			, ISNULL(x.ITEM_TYPE,'-') AS ITEM_TYPE
		    , x.LOCATION
			, x.PRODUCTION_TYPE
			, x.MARKET
		    , x.LINE_ID
			, x.ELECTRODE_TYPE
		    , x.PLAN_DATE
		    , x.IN_QTY
			, x.OUT_QTY
		    , x.CELL_IN_QTY
			, x.CELL_OUT_QTY
		    , x.INSERT_ID
			, x.INSERT_TIME
		    , x.UPDATE_ID
			, x.UPDATE_TIME
		    , x.PLM_EC_NO
		    , x.VERSION
			, @v_user_id
			, getdate()
			, 'EXCEL'
		 FROM FP_AMEND_PLAN_CELL_R as X WITH(NOLOCK)
		      JOIN #BUF_AMEND_PLAN_CELL_R_XLS as Y with(nolock)
		   on x.instance_id = y.instance_id
		  and x.fp_plan_id = y.fp_plan_id
		  and x.division_id = y.division_id
		  and x.plant_id = y.plant_id
		  and x.item_id = y.item_id
		  and x.operation_id = y.operation_id
		  and x.factory_id = y.factory_id
		  and x.location = y.location
		  and x.production_type= y.production_type
		  and x.market = y.market
		  and x.line_id = y.line_id
		  and x.electrode_type = y.electrode_type
		  and x.plan_date = y.plan_date
		  and x.top_item_id = y.top_item_id
		  and x.plm_ec_no = y.plm_ec_no
		  and x.version = y.version
		  ;


		--COMMIT TRAN

		-- Call recalculation procedure
		EXEC PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A @v_instance_id, @v_fp_plan_id, '-'
		EXEC PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B @v_instance_id, @v_fp_plan_id, '-'
*/
        SELECT 'OK' as ret, '' as msg   
		PRINT 'OK'
		--SET @p_return = 'OK' 

	END TRY

	BEGIN CATCH

		--IF @@TRANCOUNT > 0
		--	ROLLBACK TRAN

		SELECT 'NG' as ret, ERROR_MESSAGE() as msg
		PRINT 'NG|' + ERROR_MESSAGE()
		--SET @p_return = 'NG|' + ERROR_MESSAGE()


	END CATCH

	if object_id('tempdb..#BUF_AMEND_PLAN_CELL_R_XLS') is not null
		drop table #BUF_AMEND_PLAN_CELL_R_XLS

	if object_id('tempdb..#BUF_AMEND_TEMP') is not null
		drop table #BUF_AMEND_TEMP

	if object_id('tempdb..#INVALID_MSG') is not null
		drop table #INVALID_MSG

	if object_id('tempdb..#SCM_YIELD_M') is not null
		drop table #SCM_YIELD_M

END


