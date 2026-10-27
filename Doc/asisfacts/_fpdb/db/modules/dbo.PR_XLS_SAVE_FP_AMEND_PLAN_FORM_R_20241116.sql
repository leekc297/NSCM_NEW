
/*
 * Program ID   : PR_XLS_SAVE_FP_AMEND_PLAN_FORM_R
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec PR_XLS_SAVE_FP_AMEND_PLAN_FORM_R 'seon.beck', 'UC1-20241014-02'

 */

create PROCEDURE [dbo].[PR_XLS_SAVE_FP_AMEND_PLAN_FORM_R_20241116]
	@p_user_id					NVARCHAR(MAX)    
,	@p_intg_plan_id				NVARCHAR(MAX)    
--,   @p_return					NVARCHAR(max) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_descr			NVARCHAR(max)

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
			   and instance_type = 'F'
		   )

	if object_id('tempdb..#BUF_AMEND_PLAN_R_XLS') is not null
		drop table #BUF_AMEND_PLAN_R_XLS

	if object_id('tempdb..#INVALID_MSG') is not null
		drop table #INVALID_MSG

	if object_id('tempdb..#SCM_YIELD_M') is not null
		drop table #SCM_YIELD_M

	create table #BUF_AMEND_PLAN_R_XLS (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	        , [INSTANCE_ID]				[nvarchar](30) 
	        , [FP_PLAN_ID]				[nvarchar](30) 
	        , [COMPANY_ID]				[nvarchar](30) 
	        , [DIVISION_ID]				[nvarchar](30) 
	        , [SITE_ID]					[nvarchar](30) 
	        , [PLANT_ID]				[nvarchar](30) 
	        , [ITEM_ID]					[nvarchar](150)
	        , [OPERATION_ID]			[nvarchar](30) 
	        , [FACTORY_ID]				[nvarchar](30) 
	        , [LOCATION]				[nvarchar](30) 
	        , [PRODUCTION_TYPE]			[nvarchar](30) 
	        , [MARKET]					[nvarchar](30) 
	        , [LINE_ID]					[nvarchar](30) 
	        , [ELECTRODE_TYPE]			[nvarchar](50) 
	        , [CUSTOMER_ID]				[nvarchar](50) 
	        , [PLAN_DATE]				[datetime] 
	        , [TOP_ITEM_ID]				[nvarchar](150)
	        , [QTY]						[numeric](20, 10)
	        , [CELL_GROUP_CODE]			[nvarchar](150)
			, INSERT_ID                 nvarchar(150)
			, INSERT_TIME               datetime
			, UPDATE_ID                 nvarchar(150)
			, UPDATE_TIME               datetime
			, _MSG                      nvarchar(max)
			, _VALID                    nvarchar(max)
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

	declare @INSTANCE_ID				[nvarchar](30) 
	declare @FP_PLAN_ID					[nvarchar](30) 
	declare @COMPANY_ID					[nvarchar](30) 
	declare @DIVISION_ID				[nvarchar](30) 
	declare @SITE_ID					[nvarchar](30) 
	declare @PLANT_ID					[nvarchar](30) 
	declare @ITEM_ID					[nvarchar](150)
	declare @OPERATION_ID				[nvarchar](30) 
	declare @FACTORY_ID					[nvarchar](30) 
	declare @LOCATION					[nvarchar](30) 
	declare @PRODUCTION_TYPE			[nvarchar](30) 
	declare @MARKET						[nvarchar](30) 
	declare @LINE_ID					[nvarchar](30) 
	declare @ELECTRODE_TYPE				[nvarchar](50) 
	declare @CUSTOMER_ID				[nvarchar](50) 
	declare @PLAN_DATE					[datetime] 	   
	declare @TOP_ITEM_ID				[nvarchar](150)
	declare @QTY						[numeric](20, 10)
	declare @CELL_GROUP_CODE			[nvarchar](150)
	declare @INSERT_ID					nvarchar(150)   
	declare @INSERT_TIME				datetime
	declare @UPDATE_ID					nvarchar(150)
	declare @UPDATE_TIME				datetime	
	declare @_MSG                       nvarchar(max)
	declare @_VALID                     nvarchar(max)
	declare @IN_QTY						[numeric](20, 10)

	declare @YIELD                      numeric(20, 10)
	declare @CHILD_YIELD                numeric(20, 10)
	DECLARE @ACCUM_QTY					numeric(20, 10)
	declare @XLS_OUT_QTY                numeric(20, 10)

	declare @INVALID_COUNT              int
	declare @INVALID_MSG                nvarchar(max)

	BEGIN TRY		

PRINT '-------------SHIP Plan : 010 ' +  CONVERT(CHAR(23), getdate(), 21)
	
	    insert into #BUF_AMEND_PLAN_R_XLS       
		     ( 									 	
               [INSTANCE_ID]						  
             , [FP_PLAN_ID]						
             , [COMPANY_ID]						  
             , [DIVISION_ID]						
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
             , [CUSTOMER_ID]						 
             , [PLAN_DATE]							 
             , [TOP_ITEM_ID]						  
             , [QTY]								  
             , [CELL_GROUP_CODE]						
             , INSERT_ID			
			 , INSERT_TIME		     
             , UPDATE_ID			     
             , UPDATE_TIME		     
             , _MSG               
             , _VALID             					
			 )
		SELECT 
               A.[INSTANCE_ID]		
             , A.[FP_PLAN_ID]			
             , A.[COMPANY_ID]			
             , A.[DIVISION_ID]		
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
             , A.[CUSTOMER_ID]		
             , A.[PLAN_DATE]			
             , A.[TOP_ITEM_ID]		
             , A.[QTY]				
             , A.[CELL_GROUP_CODE]	
 			 , A.JOB_USER_ID             
             , dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME           
             , A.JOB_USER_ID             
             , dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME   
             , CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END) 
                    ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)         
                END AS _MSG                                                                         
             , CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID   
          FROM (            
                 SELECT TT.* 
                      , MSG1   
                        + (CASE WHEN (MSG1 = '')                                                                                                                                THEN MSG2  ELSE (CASE WHEN MSG2 = ''  THEN '' ELSE ',' + MSG2  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                                                  THEN MSG3  ELSE (CASE WHEN MSG3 = ''  THEN '' ELSE ',' + MSG3  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                                                    THEN MSG4  ELSE (CASE WHEN MSG4 = ''  THEN '' ELSE ',' + MSG4  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                                                      THEN MSG5  ELSE (CASE WHEN MSG5 = ''  THEN '' ELSE ',' + MSG5  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                                                        THEN MSG6  ELSE (CASE WHEN MSG6 = ''  THEN '' ELSE ',' + MSG6  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '')                                                          THEN MSG7  ELSE (CASE WHEN MSG7 = ''  THEN '' ELSE ',' + MSG7  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '')                                            THEN MSG8  ELSE (CASE WHEN MSG8 = ''  THEN '' ELSE ',' + MSG8  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '')                              THEN MSG9  ELSE (CASE WHEN MSG9 = ''  THEN '' ELSE ',' + MSG9  END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 ='')                 THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 ='' AND MSG10 = '')  THEN MSG11 ELSE (CASE WHEN MSG11 = '' THEN '' ELSE ',' + MSG11 END) END) 
                        + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 ='' AND MSG10 = ''  AND MSG11 = '')  THEN MSG12 ELSE (CASE WHEN MSG12 = '' THEN '' ELSE ',' + MSG12 END) END) 
                        + ' Not Found' AS __MSG 
                   FROM (                        
                         SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID              
                              , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 
                              , A.ITEM_ID, B.NICK_NAME, B.ITEM_TYPE, A.TOP_ITEM_ID 
                              , A.OPERATION_ID, A.FACTORY_ID            
                              , A.PRODUCTION_TYPE, A.MARKET             
                              , A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION 
                              , A.CUSTOMER_ID      
                              , A.PLAN_DATE, A.QTY 
                              , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER , A.CELL_GROUP_CODE
                              , CASE WHEN A.COMPANY_ID IS NULL THEN 'Building' ELSE '' END AS MSG1    
                              , CASE WHEN B.ITEM_ID IS NULL THEN 'Material' ELSE '' END AS MSG2       
                              , CASE WHEN C.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG3 
                              , CASE WHEN D.LINE_ID IS NULL THEN 'Line - Electrode Type - Location' ELSE '' END AS MSG4 
                              , '' AS MSG5   
                              , CASE WHEN F.CODE_ID IS NULL THEN 'Market' ELSE '' END AS MSG6 
                              , '' AS MSG7   
                              , '' AS MSG8   
                              , '' AS MSG9  
                              , CASE WHEN A.QTY > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN 'Line Assign' ELSE '' END ) ELSE '' END AS MSG10 
                              , CASE WHEN A.QTY > 0 THEN ( CASE WHEN K.KEY_VALUE = 'DAILY_CAPA' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN 'Daily Capa' ELSE '' END) 
                                                           ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN 'Tact Time' ELSE '' END) END ) ELSE '' END AS MSG11 
                              , CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG12  
                              , CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE 
                 	                      ORDER BY A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE)>1 THEN 'Data Overlap' 
                 	                 ELSE '' END AS MSG99          
                           FROM (                                   
                                 SELECT A.INSTANCE_ID
								      , A.FP_PLAN_ID 
                                      , A.COMPANY_ID
									  , A.DIVISION_ID
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
									  , A.CUSTOMER_ID 
                                      , A.MODEL_ID AS TOP_ITEM_ID                              
                                      , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
									  , A.QTY 
                                      , a.insert_id as JOB_USER_ID
									  , getdate() as JOB_TIME
									  , 'EXCEL' as JOB_TYPE
									  , null as JOB_ORDER
									  , null as CELL_GROUP_CODE     
                                 FROM   BUF_AMEND_PLAN_R_XLS A WITH(NOLOCK)  
                                 LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK) 
                                 ON    A.COMPANY_ID  = B.COMPANY_ID          
                                 AND   A.FACTORY_ID  = B.FACTORY_ID           
                                 AND   B.ACTIVE_FLAG = 'Y'                  
                                 WHERE A.insert_id = @v_user_id  
				                 and a.instance_id = @v_instance_id
				                 and a.fp_plan_id = @v_fp_plan_id
                                ) A               
                                LEFT OUTER JOIN ( 
                                                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,A.ITEM_ID, 
                                                        (CASE WHEN LEFT(A.FLOW_ID,5) = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN C.LEVEL_3_NAME 
                                                             WHEN LEFT(A.FLOW_ID,5) = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-') 
                                                             ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, 
                                                             ISNULL(A.NICK_NAME,'-') AS NICK_NAME 
                                                   FROM SCM_ITEM_M A WITH(NOLOCK)    
                                                      , SCM_ITEM_CLASS_M C WITH(NOLOCK) 
                                                  WHERE	A.ITEM_CLASS  = C.CLASS_ID    
                                ) B                                         
                            ON  A.COMPANY_ID      = B.COMPANY_ID        
                            AND A.DIVISION_ID     = B.DIVISION_ID       
                            AND A.SITE_ID         = B.SITE_ID           
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
                            AND C.ACTIVE_FLAG     = 'Y'                    
                                LEFT OUTER JOIN (                                
                                                 SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID 
                                                 FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           
                                                 WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE' 
                                                 AND    A.ACTIVE_FLAG = 'Y' 
                                ) E                                
                            ON  A.PRODUCTION_TYPE = E.CODE_ID  
                            AND A.DIVISION_ID = E.SEGMENT1     
                            AND (CASE WHEN A.SITE_ID <> 'A004' AND A.PRODUCTION_TYPE IN ('E-TEST','D-TEST') THEN 'XX' ELSE A.PRODUCTION_TYPE END ) = E.CODE_ID 
                                LEFT OUTER JOIN (                               
                                                 SELECT A.SEGMENT1 AS CODE_ID               
                                                 FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) 
                                                 WHERE  A.LOOKUP_TYPE_CODE = 'DEMAND_MARKET_TYPE' 
                                                 AND    A.ACTIVE_FLAG = 'Y'                       
                                ) F                       
                            ON  A.MARKET = F.CODE_ID  
                                LEFT OUTER JOIN (         
                                                 SELECT DISTINCT H.* 
                                                   FROM (              
                                                         SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID  
                                                           FROM FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H A WITH(NOLOCK)  
                                                          WHERE A.CELL_PLAN_ID = (
											  	  	                              SELECT MAX(CELL_PLAN_ID) AS CELL_PLAN_ID 
                                                                                        FROM FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H A WITH(NOLOCK)  
                                                                                       WHERE 1 = 1 
			                			                 						         AND SITE_ID = 'A003'  
			                			                 						         AND DIVISION_ID = N'81_UC' 
                                                                                  )                             
                                                          UNION ALL                                              
                                                         SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID 
                                                              , ISNULL(A.MODEL,A.ITEM_ID) AS ITEM_ID                 
                                                           FROM FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)  
                                                          WHERE A.DUE_DATE >= (
														                       SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) 
                                                                                 FROM SCM_FP_PLAN_H  with(nolock)
			                			                 					    where 1 = 1
			                			                 					      and instance_id = @v_instance_id
                                                                                  and PLAN_ID = @v_fp_plan_id 
											  	  						      )  
                                                          UNION ALL                                               
                                                         SELECT DISTINCT C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.CHILD_ITEM_ID AS ITEM_ID 
                                                           FROM FP_RELEASE_FULL_PLAN_H A WITH(NOLOCK) 
                                                              , (                                     
                                                                 SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID 
                                                                      , MAX(AMEND_PLAN_ID) AS AMEND_PLAN_ID     
                                                                   FROM FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) 
                                                                      , (                   
                                                                         SELECT INSTANCE_ID 
                                                                              , DIVISION_ID  
                                                                              , FACTORY_ID   
                                                                              , MAX(INSTANCE_DATE) AS INSTANCE_DATE     
                                                                           FROM FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)   
                                                                          WHERE A.INSTANCE_DATE <= GETDATE()            
                                                                          GROUP BY INSTANCE_ID, DIVISION_ID, FACTORY_ID 
                                                                        ) B                               
                                                                  WHERE A.INSTANCE_ID    = B.INSTANCE_ID    
                                                                    AND A.INSTANCE_DATE  = B.INSTANCE_DATE 
                                                                    AND A.DIVISION_ID    = B.DIVISION_ID   
                                                                    AND A.FACTORY_ID     = B.FACTORY_ID    
                                                                    AND A.INSTANCE_ID    = (
																	                        SELECT MAX(SL.ATTRIBUTE1) AS PACK_INST 
																							  FROM SCM_SYS_LOOKUP_VALUE SL WITH(NOLOCK) 
																							 WHERE SL.LOOKUP_TYPE_CODE = 'FORMATION_ID_MAPPING' 
																							   AND SL.SEGMENT2 = @v_instance_id
																							) 
                                                                  GROUP BY 
											  	  			            A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID 
                                                                ) B 
                                                              , SCM_BOM_M C WITH(NOLOCK)           
                                                          WHERE A.INSTANCE_ID   = B.INSTANCE_ID    
                                                            AND A.AMEND_PLAN_ID = B.AMEND_PLAN_ID  
                                                            AND A.DIVISION_ID   = C.DIVISION_ID    
                                                            AND A.ITEM_ID       = C.PARENT_ITEM_ID 
                                                            AND C.EFF_END_DATE >= GETDATE()        
                                                        ) H 
                                ) H        
                            ON  A.COMPANY_ID  = H.COMPANY_ID  
                            AND A.DIVISION_ID = H.DIVISION_ID 
                            AND A.SITE_ID     = H.SITE_ID     
                            AND A.TOP_ITEM_ID = H.ITEM_ID     
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
                                LEFT OUTER JOIN (                         
                                                 SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID 
                                                   FROM FP_USER_ROLE_INFO_V R WITH(NOLOCK)       
                                                  WHERE 1 = 1                                      
                                                    AND R.USER_ID     = @v_user_id     
                                                    AND R.SAVE_FLAG   = 'Y'                    
                                                    AND R.INSTANCE_ID = @v_instance_id
                                ) R      
                            ON  1 = 1 
                            AND A.COMPANY_ID    = R.COMPANY_ID   
                            AND A.DIVISION_ID   = R.DIVISION_ID  
                            AND A.SITE_ID       = R.SITE_ID      
                            AND A.PLANT_ID      = R.PLANT_ID     
                            AND A.FACTORY_ID    = R.FACTORY_ID   
                            AND A.OPERATION_ID  = R.OPERATION_ID 
                            AND A.LINE_ID       = R.LINE_ID      

				        ) TT           
               ) A  
		 --where CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END = 'Y'	   

PRINT '-------------SHIP Plan : 020 ' +  CONVERT(CHAR(23), getdate(), 21)

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
		         FROM #BUF_AMEND_PLAN_R_XLS AS M with(nolock)
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
				                 FROM #BUF_AMEND_PLAN_R_XLS AS M with(nolock) 
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
		SELECT @INVALID_COUNT = COUNT(*)
		  FROM #BUF_AMEND_PLAN_R_XLS
		 WHERE _VALID = 'N'
		
		if @INVALID_COUNT > 0
		BEGIN

			insert into #INVALID_MSG (ITEM_ID, _MSG)
			select distinct item_id, _msg
			  FROM #BUF_AMEND_PLAN_R_XLS
			 WHERE _VALID = 'N'

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

			--RAISERROR  ('Invalid data included in buf table. ', 16, 1 ); 
			RAISERROR  ( @INVALID_MSG, 16, 1 ); 
		
		END
		--

		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #BUF_AMEND_PLAN_R_XLS

	  
		IF @MAX_NUM = 0
		BEGIN
			RAISERROR  ( 'No data in buf table.', 16, 1 ); 
		END

PRINT '-------------SHIP Plan : 030 ' +  CONVERT(CHAR(23), getdate(), 21)
		--BEGIN TRAN

		WHILE @INX <= @MAX_NUM
		BEGIN

			SELECT  @INSTANCE_ID			= [INSTANCE_ID]	
				  , @FP_PLAN_ID				= [FP_PLAN_ID]		
				  , @COMPANY_ID				= [COMPANY_ID]		
				  , @DIVISION_ID			= [DIVISION_ID]	
				  , @SITE_ID				= [SITE_ID]		
				  , @PLANT_ID				= [PLANT_ID]		
				  , @ITEM_ID				= [ITEM_ID]		
				  , @OPERATION_ID			= [OPERATION_ID]	
				  , @FACTORY_ID				= [FACTORY_ID]		
				  , @LOCATION				= [LOCATION]		
				  , @PRODUCTION_TYPE		= [PRODUCTION_TYPE]
				  , @MARKET					= [MARKET]			
				  , @LINE_ID				= [LINE_ID]		
				  , @ELECTRODE_TYPE			= [ELECTRODE_TYPE]	
				  , @CUSTOMER_ID			= [CUSTOMER_ID]	
				  , @PLAN_DATE				= [PLAN_DATE]		
				  , @TOP_ITEM_ID			= [TOP_ITEM_ID]	
				  , @QTY					= [QTY]			
				  , @CELL_GROUP_CODE		= [CELL_GROUP_CODE]
				  , @INSERT_ID              = INSERT_ID   
				  , @INSERT_TIME 			= INSERT_TIME 
				  , @UPDATE_ID   			= UPDATE_ID   
				  , @UPDATE_TIME 			= UPDATE_TIME 
				  , @_MSG					= _MSG           
				  , @_VALID					= _VALID    
				  
			   FROM #BUF_AMEND_PLAN_R_XLS 
			  WHERE TID						= @INX


			-- YIELD 적용

			SET @YIELD			= 1
			SET @CHILD_YIELD	= 1


			SELECT @YIELD = YIELD
			  FROM #SCM_YIELD_M YYY 
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
--            +'|'+ ISNULL(@LINE_ID, 'line_id') +'|'+ ISNULL(@ELECTRODE_TYPE, 'electrode_type') +'|'+ ISNULL(@ITEM_ID, 'item_id') +'|'+ ISNULL(@PRODUCTION_TYPE,'production_type') +'|'+ ISNULL(convert(nvarchar,@YIELD), 'yield') +'|'+ ISNULL(convert(nvarchar, @CHILD_YIELD), 'child_yield')

			  --SET @ACCUM_QTY			= dbo.FN_GET_REQ_QTY_MODEL(@plant_id, @TOP_ITEM_ID, @ITEM_ID, @PLAN_DATE)
			  --SET @CELL_OUT_QTY         = case when @OPERATION_ID = 'A7000' AND @ELECTRODE_TYPE = 'Half' then CAST(FLOOR(@CELL_OUT_QTY + 1000 ) AS INT) / 1000 * 1000 else @CELL_OUT_QTY end

			  SET @IN_QTY				= CEILING(@QTY / @YIELD)
			  --

			  MERGE INTO FP_AMEND_PLAN_FORM_R A
			  USING (SELECT @INSTANCE_ID			AS INSTANCE_ID
						  , @FP_PLAN_ID				AS FP_PLAN_ID
						  , @COMPANY_ID             AS COMPANY_ID
						  , @DIVISION_ID			AS DIVISION_ID
						  , 'PLAN'                  AS CATEGORY_ID
						  , @PLANT_ID				AS PLANT_ID
						  , @ITEM_ID				AS ITEM_ID
						  , @OPERATION_ID			AS OPERATION_ID
						  , @FACTORY_ID				AS FACTORY_ID
						  , UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE
						  , @MARKET					AS MARKET
						  , @LINE_ID				AS LINE_ID
						  , @PLAN_DATE				AS PLAN_DATE
						  , @TOP_ITEM_ID			AS TOP_ITEM_ID
						  , '-'						AS PLM_EC_NO 
						  , '-'						AS VERSION
					) B
				 ON A.INSTANCE_ID		= B.INSTANCE_ID 
				AND A.FP_PLAN_ID		= B.FP_PLAN_ID
				AND A.COMPANY_ID        = B.COMPANY_ID
				AND A.DIVISION_ID		= B.DIVISION_ID
				AND A.CATEGORY_ID       = B.CATEGORY_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.OPERATION_ID		= B.OPERATION_ID 
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE 
				AND A.MARKET			= B.MARKET
				AND A.LINE_ID			= B.LINE_ID 
				AND A.PLAN_DATE			= B.PLAN_DATE
				AND A.TOP_ITEM_ID		= B.TOP_ITEM_ID 
				AND A.PLM_EC_NO			= B.PLM_EC_NO
				AND A.VERSION			= B.VERSION
			  WHEN MATCHED THEN
					UPDATE SET
					       IN_QTY				= @IN_QTY
						 , OUT_QTY				= @QTY
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
                         , CUSTOMER_ID             
                         , PLAN_DATE               
                         , TOP_ITEM_ID             
                         , CELL_GROUP_CODE         
                         , IN_QTY                  
                         , OUT_QTY                 
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
                         , B.COMPANY_ID                
                         , B.DIVISION_ID               
                         , B.CATEGORY_ID               
                         , @SITE_ID
		                 , B.PLANT_ID       
                         , B.ITEM_ID
		                 , B.OPERATION_ID
		                 , B.FACTORY_ID
		                 , @LOCATION 
                         , B.PRODUCTION_TYPE
		                 , B.MARKET 
                         , B.LINE_ID
		                 , @ELECTRODE_TYPE 
                         , @CUSTOMER_ID     
                         , B.PLAN_DATE       
                         , B.TOP_ITEM_ID     
                         , @CELL_GROUP_CODE 
                         , @IN_QTY
                         , @QTY                                              
					     , @INSERT_ID
					     , @INSERT_TIME
					     , @UPDATE_ID
					     , @UPDATE_TIME
					     , B.PLM_EC_NO
					     , B.VERSION
 	                     ); 


			SET @INX = @INX + 1

		END

PRINT '-------------SHIP Plan : 040 ' +  CONVERT(CHAR(23), getdate(), 21)

		-- History
		INSERT INTO HIS_AMEND_PLAN_FORM_R 
			 ( 
			   INSTANCE_ID
			 , FP_PLAN_ID 
			 , COMPANY_ID              
			 , DIVISION_ID             
			 , CATEGORY_ID             
			 , SITE_ID, PLANT_ID       
			 , ITEM_ID
			 , OPERATION_ID
			 , FACTORY_ID
			 , LOCATION 
			 , PRODUCTION_TYPE
			 , MARKET 
			 , LINE_ID
			 , ELECTRODE_TYPE 
			 , CUSTOMER_ID             
			 , PLAN_DATE               
			 , TOP_ITEM_ID             
			 , CELL_GROUP_CODE         
			 , IN_QTY                  
			 , OUT_QTY                 
			 , INSERT_ID
			 , INSERT_TIME  
			 , UPDATE_ID
			 , UPDATE_TIME  
			 , JOB_USER_ID
			 , JOB_TIME
			 , JOB_TYPE 
			 )                                    
		SELECT 
		       A.INSTANCE_ID
			 , A.FP_PLAN_ID   
		     , A.COMPANY_ID 
		     , A.DIVISION_ID           
		     , 'PLAN' AS CATEGORY_ID 
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
		     , A.CUSTOMER_ID               
		     , A.PLAN_DATE                 
		     , A.TOP_ITEM_ID               
		     , A.CELL_GROUP_CODE           
		     , A.QTY AS IN_QTY             
		     , A.QTY AS OUT_QTY            
		     , @v_user_id					AS INSERT_ID
			 , dbo.FN_SITE_TIME(A.SITE_ID)	AS INSERT_TIME 
		     , @v_user_id					AS UPDATE_ID
			 , dbo.FN_SITE_TIME(A.SITE_ID)	AS UPDATE_TIME 
		     , @v_user_id					AS JOB_USER_ID
		     , GETDATE()					AS JOB_TIME
			 , 'EXCEL'						AS JOB_TYPE 
		  FROM #BUF_AMEND_PLAN_R_XLS A WITH(NOLOCK) 



		-- fp_plan_model_change_except_m
		-- fp_plan_model_change_m에 존재하는데 fp_plan_model_change_except_m에 있을 경우 삭제
		delete T
		  from [dbo].[FP_PLAN_MODEL_CHANGE_EXCEPT_M] as T
			   join (
					select x.COMPANY_ID
						 , x.DIVISION_ID
						 , x.SITE_ID
						 , x.PLANT_ID
						 , x.FACTORY_ID
						 , x.top_item_id as MODEL_ID
						 , x.LINE_ID
						 , x.OPERATION_ID
						 , x.ITEM_ID
						 , x.PRODUCTION_TYPE
						 , x.ELECTRODE_TYPE
						 , '-' as VERSION
						 , x.PLAN_DATE as eff_start_date
					  from #BUF_AMEND_PLAN_R_XLS as x
						   left outer join fp_plan_model_change_m as y with(nolock)
						on x.FACTORY_ID = y.FACTORY_ID
					   and x.top_item_id = y.model_id
					   and x.LINE_ID = y.line_id
					   and x.OPERATION_ID = y.OPERATION_ID
					   and x.ITEM_ID = y.ITEM_ID
					   and x.PRODUCTION_TYPE = y.PRODUCTION_TYPE
					   and x.ELECTRODE_TYPE = y.ELECTRODE_TYPE
					   and '-' = y.VERSION
					   and x.PLAN_DATE between y.EFF_START_DATE and y.EFF_END_DATE
					 where y.EFF_START_DATE IS NOT NULL
					   and x.OPERATION_ID = 'F6000'
					 group by 
						   x.COMPANY_ID
						 , x.DIVISION_ID
						 , x.SITE_ID
						 , x.PLANT_ID
						 , x.FACTORY_ID
						 , x.top_item_id 
						 , x.LINE_ID
						 , x.OPERATION_ID
						 , x.ITEM_ID
						 , x.PRODUCTION_TYPE
						 , x.ELECTRODE_TYPE
						 --, x.VERSION
						 , x.PLAN_DATE
					) as S
		    on T.FACTORY_ID = S.FACTORY_ID
		   and T.MODEL_ID = S.MODEL_ID
		   and T.LINE_ID = S.LINE_ID
		   and T.OPERATION_ID = S.OPERATION_ID
		   and T.ITEM_ID = S.ITEM_ID
		   and T.PRODUCTION_TYPE = S.PRODUCTION_TYPE
		   and T.ELECTRODE_TYPE = S.ELECTRODE_TYPE
		   and T.VERSION = S.VERSION
		   and T.EFF_START_DATE = S.EFF_START_DATE

		-- fp_plan_model_change_m에 미존재하는데 수량이 0인 fp_plan_model_change_except_m에 있을 경우 삭제
		delete T
		  from [dbo].[FP_PLAN_MODEL_CHANGE_EXCEPT_M] as T
			   join (
					select x.COMPANY_ID
						 , x.DIVISION_ID
						 , x.SITE_ID
						 , x.PLANT_ID
						 , x.FACTORY_ID
						 , x.top_item_id as MODEL_ID
						 , x.LINE_ID
						 , x.OPERATION_ID
						 , x.ITEM_ID
						 , x.PRODUCTION_TYPE
						 , x.ELECTRODE_TYPE
						 , '-' as VERSION
						 , x.PLAN_DATE as eff_start_date
					  from #BUF_AMEND_PLAN_R_XLS as x
						   left outer join fp_plan_model_change_m as y with(nolock)
						on x.FACTORY_ID = y.FACTORY_ID
					   and x.top_item_id = y.model_id
					   and x.LINE_ID = y.line_id
					   and x.OPERATION_ID = y.OPERATION_ID
					   and x.ITEM_ID = y.ITEM_ID
					   and x.PRODUCTION_TYPE = y.PRODUCTION_TYPE
					   and x.ELECTRODE_TYPE = y.ELECTRODE_TYPE
					   and '-' = y.VERSION
					   and x.PLAN_DATE between y.EFF_START_DATE and y.EFF_END_DATE
					 where y.EFF_START_DATE IS NULL
					   and x.QTY = 0
					   and x.OPERATION_ID = 'F6000'
					 group by 
						   x.COMPANY_ID
						 , x.DIVISION_ID
						 , x.SITE_ID
						 , x.PLANT_ID
						 , x.FACTORY_ID
						 , x.top_item_id 
						 , x.LINE_ID
						 , x.OPERATION_ID
						 , x.ITEM_ID
						 , x.PRODUCTION_TYPE
						 , x.ELECTRODE_TYPE
						 --, x.VERSION
						 , x.PLAN_DATE
					) as S
		    on T.FACTORY_ID = S.FACTORY_ID
		   and T.MODEL_ID = S.MODEL_ID
		   and T.LINE_ID = S.LINE_ID
		   and T.OPERATION_ID = S.OPERATION_ID
		   and T.ITEM_ID = S.ITEM_ID
		   and T.PRODUCTION_TYPE = S.PRODUCTION_TYPE
		   and T.ELECTRODE_TYPE = S.ELECTRODE_TYPE
		   and T.VERSION = S.VERSION
		   and T.EFF_START_DATE = S.EFF_START_DATE

		-- fp_plan_model_change_m에 미 존재하고 fp_plan_model_change_except_m에 없을 경우 입력
/*
		MERGE INTO FP_PLAN_MODEL_CHANGE_EXCEPT_M as T
		USING (
				select x.COMPANY_ID
					 , x.DIVISION_ID
					 , x.SITE_ID
					 , x.PLANT_ID
					 , x.FACTORY_ID
					 , x.TOP_ITEM_ID AS MODEL_ID
					 , x.LINE_ID
					 , x.OPERATION_ID
					 , x.ITEM_ID
					 , x.PRODUCTION_TYPE
					 , x.ELECTRODE_TYPE
					 , '-' AS VERSION
					 , x.PLAN_DATE as eff_start_date
					 , 1 as priority
					 , 'Y' as inv_apl_flag
					 , 'Y' as active_flag
					 , @v_user_id as insert_id
					 , dbo.FN_SITE_TIME(x.SITE_ID) as insert_time
					 , @v_user_id as update_id
					 , dbo.FN_SITE_TIME(x.SITE_ID) as update_time
				  from #BUF_AMEND_PLAN_R_XLS as x
					   left outer join fp_plan_model_change_m as y with(nolock)
					on x.FACTORY_ID = y.FACTORY_ID
				   and x.top_item_id = y.model_id
				   and x.LINE_ID = y.line_id
				   and x.OPERATION_ID = y.OPERATION_ID
				   and x.ITEM_ID = y.ITEM_ID
				   and x.PRODUCTION_TYPE = y.PRODUCTION_TYPE
				   and x.ELECTRODE_TYPE = y.ELECTRODE_TYPE
				   and '-' = y.VERSION
				   and x.PLAN_DATE between y.EFF_START_DATE and y.EFF_END_DATE
				 where y.EFF_START_DATE IS NULL
				   and x.QTY > 0
				   and x.OPERATION_ID = 'F6000'
				 group by 
					   x.COMPANY_ID
					 , x.DIVISION_ID
					 , x.SITE_ID
					 , x.PLANT_ID
					 , x.FACTORY_ID
					 , x.top_item_id 
					 , x.LINE_ID
					 , x.OPERATION_ID
					 , x.ITEM_ID
					 , x.PRODUCTION_TYPE
					 , x.ELECTRODE_TYPE
					 --, x.VERSION
					 , x.PLAN_DATE
			  ) AS S
		   on T.FACTORY_ID			= S.FACTORY_ID
		  --and T.MODEL_ID			= S.MODEL_ID
		  and T.LINE_ID				= S.LINE_ID
		  and T.OPERATION_ID		= S.OPERATION_ID
		  --and T.ITEM_ID				= S.ITEM_ID
		  --and T.PRODUCTION_TYPE		= S.PRODUCTION_TYPE
		  --and T.ELECTRODE_TYPE		= S.ELECTRODE_TYPE
		  --and T.VERSION				= S.VERSION
		  and T.EFF_START_DATE		= S.EFF_START_DATE
		--WHEN MATCHED THEN
		--	UPDATE SET 
		--	       T.MODEL_ID		= S.MODEL_ID
		--		 , T.ITEM_ID		= S.ITEM_ID
		--		 , T.UPDATE_ID		= S.UPDATE_ID
		--		 , T.UPDATE_TIME	= S.UPDATE_TIME
		WHEN NOT MATCHED THEN
			INSERT (
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
			     , [ACTIVE_FLAG]
			     , [INSERT_ID]
			     , [INSERT_TIME]
			     , [UPDATE_ID]
			     , [UPDATE_TIME])
		    VALUES (
				   S.[COMPANY_ID]
			     , S.[DIVISION_ID]
			     , S.[SITE_ID]
			     , S.[PLANT_ID]
			     , S.[FACTORY_ID]
			     , S.[MODEL_ID]
			     , S.[LINE_ID]
			     , S.[OPERATION_ID]
			     , S.[ITEM_ID]
			     , S.[PRODUCTION_TYPE]
			     , S.[ELECTRODE_TYPE]
			     , S.[VERSION]
			     , S.[EFF_START_DATE]
			     , S.[PRIORITY]
			     , S.[INV_APL_FLAG]
			     , S.[ACTIVE_FLAG]
			     , S.[INSERT_ID]
			     , S.[INSERT_TIME]
			     , S.[UPDATE_ID]
			     , S.[UPDATE_TIME]
				 )
				 ;
*/


			INSERT FP_PLAN_MODEL_CHANGE_EXCEPT_M (
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
			     , [ACTIVE_FLAG]
			     , [INSERT_ID]
			     , [INSERT_TIME]
			     , [UPDATE_ID]
			     , [UPDATE_TIME])
			select x.COMPANY_ID
				 , x.DIVISION_ID
				 , x.SITE_ID
				 , x.PLANT_ID
				 , x.FACTORY_ID
				 , x.TOP_ITEM_ID AS MODEL_ID
				 , x.LINE_ID
				 , x.OPERATION_ID
				 , x.ITEM_ID
				 , x.PRODUCTION_TYPE
				 , x.ELECTRODE_TYPE
				 , '-' AS VERSION
				 , x.PLAN_DATE as eff_start_date
				 , 1 as priority
				 , 'Y' as inv_apl_flag
				 , 'Y' as active_flag
				 , @v_user_id as insert_id
				 , dbo.FN_SITE_TIME(x.SITE_ID) as insert_time
				 , @v_user_id as update_id
				 , dbo.FN_SITE_TIME(x.SITE_ID) as update_time
			  from #BUF_AMEND_PLAN_R_XLS as x
				   left outer join fp_plan_model_change_m as y with(nolock)
				on x.FACTORY_ID = y.FACTORY_ID
			   and x.top_item_id = y.model_id
			   and x.LINE_ID = y.line_id
			   and x.OPERATION_ID = y.OPERATION_ID
			   and x.ITEM_ID = y.ITEM_ID
			   and x.PRODUCTION_TYPE = y.PRODUCTION_TYPE
			   and x.ELECTRODE_TYPE = y.ELECTRODE_TYPE
			   and '-' = y.VERSION
			   and x.PLAN_DATE between y.EFF_START_DATE and y.EFF_END_DATE
			 where y.EFF_START_DATE IS NULL
			   and x.QTY > 0
			   and x.OPERATION_ID = 'F6000'
			   and not exists ( select 1
				                  from FP_PLAN_MODEL_CHANGE_EXCEPT_M as ce with(nolock)
								 where 1 = 1
								   and ce.factory_id		= x.factory_id
								   and ce.model_id			= x.TOP_ITEM_ID
								   and ce.line_id			= x.line_id
								   and ce.operation_id		= x.operation_id
								   and ce.item_id			= x.item_id
								   and ce.production_type	= x.production_type
								   and ce.electrode_type	= x.electrode_type
								   and ce.version			= '-'
								   and ce.eff_start_date	= x.PLAN_DATE
							  )
			   and exists ( select 1
				                  from FP_PLAN_MODEL_CHANGE_M as c with(nolock)
								 where 1 = 1
								   and c.factory_id			= x.factory_id
								   and c.model_id			= x.TOP_ITEM_ID
								   and c.line_id			= x.line_id
								   and c.operation_id		= x.operation_id
								   and c.item_id			= x.item_id
								   and c.production_type	= x.production_type
								   and c.electrode_type		= x.electrode_type
								   and c.version			= '-'
							  )			 
			 group by 
				   x.COMPANY_ID
				 , x.DIVISION_ID
				 , x.SITE_ID
				 , x.PLANT_ID
				 , x.FACTORY_ID
				 , x.top_item_id 
				 , x.LINE_ID
				 , x.OPERATION_ID
				 , x.ITEM_ID
				 , x.PRODUCTION_TYPE
				 , x.ELECTRODE_TYPE
				 --, x.VERSION
				 , x.PLAN_DATE

PRINT '-------------SHIP Plan : 050 ' +  CONVERT(CHAR(23), getdate(), 21)

		--COMMIT TRAN

		update scm_fp_plan_h
		   set intg_recalc_flag = 'A'
		 where 1 = 1
		   and instance_id = @v_instance_id
		   and plan_id = @v_fp_plan_id

		-- Call recalculation procedure
		--EXEC PR_SCM_OF_PSI_SHORTER_LT_SIM_CALL @v_instance_id, @v_fp_plan_id, 'Y'
		--EXEC PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM @v_instance_id, @v_fp_plan_id, '-'

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

	if object_id('tempdb..#BUF_AMEND_PLAN_R_XLS') is not null
		drop table #BUF_AMEND_PLAN_R_XLS

	if object_id('tempdb..#INVALID_MSG') is not null
		drop table #INVALID_MSG

	if object_id('tempdb..#SCM_YIELD_M') is not null
		drop table #SCM_YIELD_M

END



