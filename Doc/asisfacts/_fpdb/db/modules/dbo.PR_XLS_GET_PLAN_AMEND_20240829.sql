
/*
 * Program ID   : PR_XLS_GET_PLAN_AMEND
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 
 * 
 ex) 
  exec PR_XLS_GET_PLAN_AMEND 'UC_E_PRE_A', 'UC_E_PRE_A-20240803-01'
  exec PR_XLS_GET_PLAN_AMEND 'UC_CELL_A' , 'UC_CELL_A-20240806-02'
  exec PR_XLS_GET_PLAN_AMEND 'UC_FORM_A' ,  'UC_FORM_A-20240806-01'
 */

create PROCEDURE [dbo].[PR_XLS_GET_PLAN_AMEND_20240829]
  	@p_instance_id              nvarchar(max)    --UC_E_PRE_A / UC_CELL_A / UC_FORM_A
,	@p_fp_plan_id				NVARCHAR(MAX)    --UC_E_PRE_A-20240803-01 / UC_CELL_A-20240806-02 / UC_FORM_A-20240806-01'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_instance_id			nvarchar(max)
	DECLARE @v_fp_plan_id			nvarchar(max)
	declare @v_shop_group			nvarchar(1)
	DECLARE @v_yyyymmdd_from	    datetime
	DECLARE @v_yyyymmdd_to		    datetime

	set @v_instance_id  = @p_instance_id
	set @v_fp_plan_id	= @p_fp_plan_id



	if object_id('tempdb..#AMEND_PLAN') is not null
		drop table #AMEND_PLAN

	create table #AMEND_PLAN (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, INSTANCE_ID               nvarchar(30)             
			, FP_PLAN_ID 				nvarchar(30)
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, CATEGORY_ID               nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, LOCATION 					nvarchar(30)
			, OPERATION_ID 				nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ELECTRODE_TYPE 			nvarchar(30)
            , EQUIPMENT_ID              nvarchar(30)
			, PLAN_DATE 				datetime
			, MODEL_ID                  nvarchar(30)
			, ITEM_ID 					nvarchar(150)
			, PRODUCTION_TYPE			nvarchar(30)
			, MARKET 					nvarchar(30)
			, VERSION 					nvarchar(10)
			, PLM_EC_NO  				nvarchar(50)
			, CELL_OUT_QTY              numeric(20, 10)
            , ITEM_TYPE                 nvarchar(150)
			, SEQ                       int
			, CUSTOMER_ID               nvarchar(50)
			, BOH_QTY                   nvarchar(100)
			, MODE                      nvarchar(1)   default 'P'
			)
			;

	BEGIN TRY		

		select TOP 1 @v_shop_group= instance_type
		 from [dbo].[FP_INSTANCE_INFO_V]
		where instance_id = @v_instance_id

		if @v_shop_group = 'E'
		begin

		    insert into #AMEND_PLAN
			     (
                   INSTANCE_ID       
                 , FP_PLAN_ID 		
                 , COMPANY_ID        
                 , DIVISION_ID 		
                 , CATEGORY_ID       
                 , SITE_ID 			
                 , PLANT_ID 			
                 , FACTORY_ID 		
                 , LOCATION 			
                 , OPERATION_ID 		
                 , LINE_ID 			
                 , ELECTRODE_TYPE 	
                 , EQUIPMENT_ID      
                 , PLAN_DATE 		
                 , MODEL_ID          
                 , ITEM_ID 			
                 , PRODUCTION_TYPE	
                 , MARKET 			
                 , VERSION 			
                 , PLM_EC_NO  		
                 , CELL_OUT_QTY      
                 , ITEM_TYPE         
                 , SEQ               
                 , CUSTOMER_ID       
                 , BOH_QTY           
				 )
			SELECT x.[INSTANCE_ID]                                
				 , x.[FP_PLAN_ID]
				 , x.[COMPANY_ID]
				 , x.[DIVISION_ID]
                 , 'PLAN' as CATEGORY_ID
				 , x.[SITE_ID]
				 , x.[PLANT_ID]
				 , x.[FACTORY_ID]
				 , x.[LOCATION]
				 , x.[OPERATION_ID]
				 , x.[LINE_ID]
				 , x.[ELECTRODE_TYPE]
				 , x.[EQUIPMENT_ID]
				 , x.[PLAN_DATE]
				 , x.[WORK_REQUEST_MODEL_ID] AS MODEL_ID
				 , x.[ITEM_ID]
				 , x.[PRODUCTION_TYPE]
				 , x.[MARKET]
				 , x.[VERSION]
				 , x.[PLM_EC_NO]
				 , x.[ADJUST_OUT_QTY_CELL] AS CELL_OUT_QTY
				 , null as ITEM_TYPE
				 , x.[SEQ]
				 , '-'					AS CUSTOMER_ID
				 , null					as BOH_QTY
			  FROM [dbo].[FP_AMEND_DAILY_PLAN_R] as x with(nolock)
			 where 1 = 1
			   and x.instance_id = @v_instance_id
			   and x.fp_plan_id  = @v_fp_plan_id
			   and x.production_type = 'MASS'


		end
		else if @v_shop_group = 'A'
		begin

		    insert into #AMEND_PLAN
			     (
                   INSTANCE_ID       
                 , FP_PLAN_ID 		
                 , COMPANY_ID        
                 , DIVISION_ID 		
                 , CATEGORY_ID       
                 , SITE_ID 			
                 , PLANT_ID 			
                 , FACTORY_ID 		
                 , LOCATION 			
                 , OPERATION_ID 		
                 , LINE_ID 			
                 , ELECTRODE_TYPE 	
                 , EQUIPMENT_ID      
                 , PLAN_DATE 		
                 , MODEL_ID          
                 , ITEM_ID 			
                 , PRODUCTION_TYPE	
                 , MARKET 			
                 , VERSION 			
                 , PLM_EC_NO  		
                 , CELL_OUT_QTY      
                 , ITEM_TYPE         
                 , SEQ               
                 , CUSTOMER_ID       
                 , BOH_QTY           
				 )
			SELECT x.[INSTANCE_ID]
				 , x.[FP_PLAN_ID]
				 , x.[COMPANY_ID]
				 , x.[DIVISION_ID]
                 , x.[CATEGORY_ID]
				 , x.[SITE_ID]
				 , x.[PLANT_ID]
				 , x.[FACTORY_ID]
				 , x.[LOCATION]
				 , x.[OPERATION_ID]
				 , x.[LINE_ID]
				 , x.[ELECTRODE_TYPE]
				 , '-'				as EQUIPMENT_ID
				 , x.[PLAN_DATE]
				 , x.[TOP_ITEM_ID]	AS MODEL_ID
				 , x.[ITEM_ID]
				 , x.[PRODUCTION_TYPE]
				 , x.[MARKET]
				 , x.[VERSION]
				 , x.[PLM_EC_NO]
				 , x.[CELL_OUT_QTY] 
				 , x.[ITEM_TYPE]
				 , x.[DATE_SEQ]		AS SEQ
				 , '-'				AS CUSTOMER_ID
				 , null				as BOH_QTY
			  FROM [dbo].[FP_AMEND_PLAN_CELL_R] as x with(nolock)
			 where 1 = 1
			   and x.instance_id = @v_instance_id
			   and x.fp_plan_id  = @v_fp_plan_id
			   and x.production_type = 'MASS'

		end
		else if @v_shop_group = 'F'
		begin

		    insert into #AMEND_PLAN
			     (
                   INSTANCE_ID       
                 , FP_PLAN_ID 		
                 , COMPANY_ID        
                 , DIVISION_ID 		
                 , CATEGORY_ID       
                 , SITE_ID 			
                 , PLANT_ID 			
                 , FACTORY_ID 		
                 , LOCATION 			
                 , OPERATION_ID 		
                 , LINE_ID 			
                 , ELECTRODE_TYPE 	
                 , EQUIPMENT_ID      
                 , PLAN_DATE 		
                 , MODEL_ID          
                 , ITEM_ID 			
                 , PRODUCTION_TYPE	
                 , MARKET 			
                 , VERSION 			
                 , PLM_EC_NO  		
                 , CELL_OUT_QTY      
                 , ITEM_TYPE         
                 , SEQ               
                 , CUSTOMER_ID       
                 , BOH_QTY           
				 )
			SELECT x.[INSTANCE_ID]
				 , x.[FP_PLAN_ID]
				 , x.[COMPANY_ID]
				 , x.[DIVISION_ID]
                 , x.[CATEGORY_ID]
				 , x.[SITE_ID]
				 , x.[PLANT_ID]
				 , x.[FACTORY_ID]
				 , x.[LOCATION]
				 , x.[OPERATION_ID]
				 , x.[LINE_ID]
				 , x.[ELECTRODE_TYPE]
				 , '-'				as EQUIPMENT_ID
				 , x.[PLAN_DATE]
				 , x.[TOP_ITEM_ID]	AS MODEL_ID
				 , x.[ITEM_ID]
				 , x.[PRODUCTION_TYPE]
				 , x.[MARKET]
				 , '-'				as VERSION
				 , '-'				as PLM_EC_NO
				 , x.[OUT_QTY]		as CELL_OUT_QTY
				 , null				as ITEM_TYPE
				 , 0				as SEQ
				 , x.CUSTOMER_ID
	             , replace(concat(x.BOH_QTY , '(' , x.ORG_BOH_QTY , ')'),'.0000000000','') as BOH_QTY
			  FROM [dbo].[FP_AMEND_PLAN_FORM_R] as x with(nolock)
			 where 1 = 1
			   and x.instance_id = @v_instance_id
			   and x.fp_plan_id  = @v_fp_plan_id
			   and x.factory_id != '-'

		end

		select @v_yyyymmdd_from = min(plan_date)
		     , @v_yyyymmdd_to   = max(plan_date)
		  from #AMEND_PLAN
		

		-- 없는 일자 데이터 생성
		insert into #AMEND_PLAN
			 (
               INSTANCE_ID       
             , FP_PLAN_ID 		
             , COMPANY_ID        
             , DIVISION_ID 		
             , CATEGORY_ID       
             , SITE_ID 			
             , PLANT_ID 			
             , FACTORY_ID 		
             , LOCATION 			
             , OPERATION_ID 		
             , LINE_ID 			
             , ELECTRODE_TYPE 	
             , EQUIPMENT_ID      
             , PLAN_DATE 		
             , MODEL_ID          
             , ITEM_ID 			
             , PRODUCTION_TYPE	
             , MARKET 			
             , VERSION 			
             , PLM_EC_NO  		
             , CELL_OUT_QTY      
             , ITEM_TYPE         
             , SEQ               
             , CUSTOMER_ID       
             , BOH_QTY   
			 , MODE
			 )
	    select 
		       X.INSTANCE_ID       
			 , X.FP_PLAN_ID 		
			 , X.COMPANY_ID        
			 , X.DIVISION_ID 		
			 , X.CATEGORY_ID       
			 , X.SITE_ID 			
			 , X.PLANT_ID 			
			 , X.FACTORY_ID 		
			 , X.LOCATION 			
			 , X.OPERATION_ID 		
			 , X.LINE_ID 			
			 , X.ELECTRODE_TYPE 	
			 , X.EQUIPMENT_ID      
			 , X.PLAN_DATE 		
			 , X.MODEL_ID          
			 , X.ITEM_ID 			
			 , X.PRODUCTION_TYPE	
			 , X.MARKET 			
			 , X.VERSION 			
			 , X.PLM_EC_NO  		
			 , 0 as CELL_OUT_QTY      
			 , null as ITEM_TYPE         
			 , 0 AS SEQ               
			 , '-' AS CUSTOMER_ID       
			 , null as BOH_QTY     
			 , 'X'
		  from (
				SELECT B.instance_id
			         , B.fp_plan_id
			         , B.category_id
			         , B.COMPANY_ID       
			         , B.DIVISION_ID 		
			         , B.SITE_ID 			
			         , B.PLANT_ID 		
			         , B.FACTORY_ID 		
					 , B.OPERATION_ID 	
					 , B.LINE_ID 
					 , B.equipment_id
					 , B.ELECTRODE_TYPE 
					 , B.location
					 , B.production_type
					 , B.market
					 , B.model_id
					 , B.item_id
					 , B.plm_ec_no
					 , B.version
					 , A.PLAN_DATE
					FROM (
						SELECT C.dt AS plan_date
						FROM TH_UIS_CAL AS C WITH(NOLOCK)
						WHERE 1 = 1
							AND C.dt >= @v_yyyymmdd_from
							AND C.dt <= @v_yyyymmdd_to
						) A,
						(
						SELECT DISTINCT
						       INSTANCE_ID
							 , FP_PLAN_ID
							 , CATEGORY_ID
							 , COMPANY_ID        
			                 , DIVISION_ID 		
			                 , SITE_ID 			
			                 , PLANT_ID 			
			                 , FACTORY_ID 		
			                 , OPERATION_ID 		
			                 , LINE_ID 
							 , EQUIPMENT_ID
			                 , ELECTRODE_TYPE 
							 , LOCATION
							 , PRODUCTION_TYPE
							 , MARKET
							 , MODEL_ID
							 , ITEM_ID
							 , PLM_EC_NO
							 , VERSION
						FROM #AMEND_PLAN AS X 
						) B
		      ) as x
		WHERE 1 = 1
		  AND NOT EXISTS (
						  SELECT 'X'
						    FROM #AMEND_PLAN AS Z 
						   WHERE 1 = 1
						     AND Z.INSTANCE_ID         = X.INSTANCE_ID
						     AND Z.FP_PLAN_ID		   = X.FP_PLAN_ID
						     AND Z.CATEGORY_ID		   = X.CATEGORY_ID
						     AND Z.COMPANY_ID          = X.COMPANY_ID       
						     AND Z.DIVISION_ID 		   = X.DIVISION_ID 		
						     AND Z.SITE_ID 			   = X.SITE_ID 			
						     AND Z.PLANT_ID 		   = X.PLANT_ID 		
						     AND Z.FACTORY_ID 		   = X.FACTORY_ID 		
						     AND Z.OPERATION_ID 	   = X.OPERATION_ID 	
							 AND Z.LINE_ID 			   = X.LINE_ID 
							 AND Z.EQUIPMENT_ID		   = X.EQUIPMENT_ID
							 AND Z.ELECTRODE_TYPE 	   = X.ELECTRODE_TYPE 
							 AND Z.LOCATION			   = X.LOCATION
							 AND Z.PRODUCTION_TYPE	   = X.PRODUCTION_TYPE
							 AND Z.MARKET			   = X.MARKET
							 AND Z.MODEL_ID			   = X.MODEL_ID
							 AND Z.ITEM_ID			   = X.ITEM_ID
							 AND Z.PLM_EC_NO		   = X.PLM_EC_NO
							 AND Z.VERSION			   = X.VERSION
							 AND Z.PLAN_DATE           = X.PLAN_DATE
			             )
			;

               

		select 
               
               CASE WHEN x.OPERATION_ID    = 'A5000' THEN 'Notching'
                    WHEN x.OPERATION_ID    IN ('A7000','A8000') THEN 'L&S'
                    WHEN x.OPERATION_ID    = 'A9000' THEN 'PKG'
                    WHEN x.OPERATION_ID    = 'E2000' THEN 'Coating'
                    WHEN x.OPERATION_ID    = 'E3000' THEN 'R/P'
                    WHEN x.OPERATION_ID    = 'F6000' THEN 'EOL'
                    ELSE x.OPERATION_ID
                END
                + IIF(x.ELECTRODE_TYPE = '-','',' (' + x.ELECTRODE_TYPE + ')')
                + REPLACE(CONCAT('#', SUBSTRING( x.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', x.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                + RIGHT(y.NICK_NAME,3)
                + FORMAT(x.PLAN_DATE,'yyyy-MM-dd')
                + x.ITEM_ID
                AS KEYS
             , x.INSTANCE_ID           
			 , x.FP_PLAN_ID 			
			 , x.COMPANY_ID            
			 , x.DIVISION_ID 			
			 , x.CATEGORY_ID           
			 , x.SITE_ID 				
			 , x.PLANT_ID 				
			 , x.FACTORY_ID 			
			 , x.LOCATION 				
			 , x.OPERATION_ID 			
			 , x.LINE_ID 				
			 , x.ELECTRODE_TYPE 		
			 , x.EQUIPMENT_ID          
			 , x.PLAN_DATE 			
			 , x.MODEL_ID              
			 , x.ITEM_ID 				
			 , x.PRODUCTION_TYPE		
			 , x.MARKET 				
			 , x.VERSION 				
			 , x.PLM_EC_NO  			
			 , x.CELL_OUT_QTY          
			 , x.ITEM_TYPE             
			 , x.SEQ                   
			 , x.CUSTOMER_ID           
			 , x.BOH_QTY               
		     , y.NICK_NAME
			 , z.LINE_NAME
			 , t.OPERATION_NAME	
			 , x.MODE
		  from #AMEND_PLAN as x
			   left outer join SCM_ITEM_M as y with(nolock)
			on x.company_id = y.company_id
		   and x.division_id = y.division_id
		   and x.site_id = y.site_id
		   and x.model_id = y.item_id
			   left outer join scm_line_m as z with(nolock)
			on x.company_id = z.company_id
		   and x.division_id = z.division_id
		   and x.site_id = z.site_id
		   and x.plant_id = z.plant_id
		   and x.factory_id = z.factory_id
		   and x.operation_id = z.operation_id
		   and x.line_id = z.line_id
		   and x.electrode_type = z.electrode_type
			   left outer join scm_operation_m as t with(nolock)
			on x.company_id = t.company_id
		   and x.division_id = t.division_id
		   and x.site_id = t.site_id
		   and x.operation_id = t.operation_id

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#AMEND_PLAN') is not null
			drop table #AMEND_PLAN

	END CATCH

		if object_id('tempdb..#AMEND_PLAN') is not null
		drop table #AMEND_PLAN

END



