
/*
 * Program ID   : PR_XLS_SAVE_FP_AMEND_DAILY_PLAN_R
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
 exec PR_XLS_SAVE_FP_AMEND_DAILY_PLAN_R 'crjung', 'UC_E_PRE_A', 'UC_E_PRE_A-20240803-01'
 */

create PROCEDURE [dbo].[PR_XLS_SAVE_FP_AMEND_DAILY_PLAN_R_20240822]
	@p_user_id					NVARCHAR(MAX)    
, 	@p_instance_id              nvarchar(max)    --UC_E_PRE_A
,	@p_fp_plan_id				NVARCHAR(MAX)    --UC_E_PRE_A-20240803-01
,   @p_return                   nvarchar(max) = 'OK' OUTPUT 
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_user_id			nvarchar(max)
	DECLARE @v_instance_id		nvarchar(max)
	DECLARE @v_fp_plan_id		nvarchar(max)

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

	set @v_user_id		= @p_user_id
	set @v_instance_id  = @p_instance_id
	set @v_fp_plan_id	= @p_fp_plan_id

	if object_id('tempdb..#BUF_AMEND_DAILY_PLAN_R_XLS') is not null
		drop table #BUF_AMEND_DAILY_PLAN_R_XLS

	if object_id('tempdb..#FP_AMEND_DAILY_BOR_r') is not null
		drop table #FP_AMEND_DAILY_BOR_r

	create table #BUF_AMEND_DAILY_PLAN_R_XLS (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, INSTANCE_ID               nvarchar(30)             
			, FP_PLAN_ID 				nvarchar(30)
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, LOCATION 					nvarchar(30)
			, OPERATION_ID 				nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ELECTRODE_TYPE 			nvarchar(30)
			, EQUIPMENT_ID 				nvarchar(30)
			, PLAN_DATE 				datetime
			, top_item_id               nvarchar(30)
			, ITEM_ID 					nvarchar(150)
			, PRODUCTION_TYPE			nvarchar(30)
			, MARKET 					nvarchar(30)
			, seq                       int
			, ADJUST_IN_QTY_BATCH		numeric(20, 10)
			, ADJUST_IN_QTY				numeric(20, 10)
			, ADJUST_IN_QTY_M			numeric(20, 10)
			, ADJUST_IN_QTY_CELL		numeric(20, 10)
			, ADJUST_IN_QTY_JR			numeric(20, 10)
			, ADJUST_OUT_QTY_BATCH		numeric(20, 10)
			, ADJUST_OUT_QTY			numeric(20, 10)
			, ADJUST_OUT_QTY_M			numeric(20, 10)
			, ADJUST_OUT_QTY_CELL		numeric(20, 10)
			, ADJUST_OUT_QTY_JR			numeric(20, 10)
			, INSERT_ID                 nvarchar(150)
			, INSERT_TIME               datetime
			, UPDATE_ID                 nvarchar(150)
			, UPDATE_TIME               datetime
			, WORK_REQUEST_MODEL_ID 	nvarchar(50)
			, VERSION 					nvarchar(10)
			, PROD_SEQ 					nvarchar(50)
			, PLM_EC_NO  				nvarchar(50)
			, _MSG                      nvarchar(max)
			, _VALID                    nvarchar(max)
			, JUMBOROLL_CELL_M			NUMERIC(18, 5)
			, PANCAKE_M_BATCH			NUMERIC(18, 5)
			, CELL_BATCH				NUMERIC(18, 5)
			, JUMBOROLL_M_BATCH			NUMERIC(18, 5)
			, PANCAKE_CELL_M			NUMERIC(18, 5)
			, BATCH_POINT               INT
			)
			;

	create table #FP_AMEND_DAILY_BOR_r (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, INSTANCE_ID               nvarchar(30)             
			, FP_PLAN_ID 				nvarchar(30)
			, COMPANY_ID                nvarchar(30)
			, DIVISION_ID 				nvarchar(30)
			, SITE_ID 					nvarchar(30)
			, PLANT_ID 					nvarchar(30)
			, FACTORY_ID 				nvarchar(30)
			, LOCATION 					nvarchar(30)
			, OPERATION_ID 				nvarchar(30)
			, LINE_ID 					nvarchar(30)
			, ELECTRODE_TYPE 			nvarchar(30)
			, EQUIPMENT_ID 				nvarchar(30)
			, ITEM_ID 					nvarchar(150)
			, CALC_TYPE                 nvarchar(30)
			, CALC_VERSION              nvarchar(30)
			, WORK_REQUEST_MODEL_ID     nvarchar(50)
			, VERSION                   nvarchar(10)
			, PLM_EC_NO                 nvarchar(50)
            , START_DATE                nvarchar(10)
			, END_DATE                  nvarchar(10)
			, YIELD                     numeric(20,10)
			, CHILD_YIELD               numeric(20,10)

			)
			;

	declare @INSTANCE_ID				nvarchar(30)             
	declare @FP_PLAN_ID 				nvarchar(30)
	declare @company_id					nvarchar(30)
	declare @DIVISION_ID 				nvarchar(30)
	declare @SITE_ID 					nvarchar(30)
	declare @PLANT_ID 					nvarchar(30)
	declare @FACTORY_ID 				nvarchar(30)
	declare @LOCATION 					nvarchar(30)
	declare @OPERATION_ID 				nvarchar(30)
	declare @LINE_ID 					nvarchar(30)
	declare @ELECTRODE_TYPE 			nvarchar(30)
	declare @EQUIPMENT_ID 				nvarchar(30)
	declare @PLAN_DATE 					datetime
	declare @top_item_id				nvarchar(30)
	declare @ITEM_ID 					nvarchar(150)
	declare @PRODUCTION_TYPE			nvarchar(30)
	declare @MARKET 					nvarchar(30)
	declare @seq						int
	declare @ADJUST_IN_QTY_BATCH		numeric(20, 10)
	declare @ADJUST_IN_QTY				numeric(20, 10)
	declare @ADJUST_IN_QTY_M			numeric(20, 10)
	declare @ADJUST_IN_QTY_CELL			numeric(20, 10)
	declare @ADJUST_IN_QTY_JR			numeric(20, 10)
	declare @ADJUST_OUT_QTY_BATCH		numeric(20, 10)
	declare @ADJUST_OUT_QTY				numeric(20, 10)
	declare @ADJUST_OUT_QTY_M			numeric(20, 10)
	declare @ADJUST_OUT_QTY_CELL		numeric(20, 10)
	declare @ADJUST_OUT_QTY_JR			numeric(20, 10)
	declare @INSERT_ID					nvarchar(150)
	declare @INSERT_TIME				datetime
	declare @UPDATE_ID					nvarchar(150)
	declare @UPDATE_TIME				datetime
	declare @WORK_REQUEST_MODEL_ID 		nvarchar(50)
	declare @VERSION 					nvarchar(10)
	declare @PROD_SEQ 					nvarchar(50)
	declare @PLM_EC_NO  				nvarchar(50)
	declare @_MSG                       nvarchar(max)
	declare @_VALID                     nvarchar(max)
	declare @JUMBOROLL_CELL_M	        numeric(18, 5)
	declare @PANCAKE_M_BATCH				numeric(18, 5)
	declare @CELL_BATCH					numeric(18, 5)
	declare @JUMBOROLL_M_BATCH			numeric(18, 5)
	declare @PANCAKE_CELL_M				numeric(18, 5)
	declare @BATCH_POINT                int

	declare @YIELD                      numeric(20, 10)
	declare @CHILD_YIELD                numeric(20, 10)

	declare @INVALID_COUNT                int

	BEGIN TRY		
	
	    insert into #BUF_AMEND_DAILY_PLAN_R_XLS
		     ( 
		       INSTANCE_ID           
             , FP_PLAN_ID 			
             , company_id            
             , DIVISION_ID 			
             , SITE_ID 				
             , PLANT_ID 				
             , FACTORY_ID 			
             , LOCATION 				
             , OPERATION_ID 			
             , LINE_ID 				
             , ELECTRODE_TYPE 		
             , EQUIPMENT_ID 			
             , PLAN_DATE 			
             , top_item_id           
             , ITEM_ID 				
             , PRODUCTION_TYPE		
             , MARKET 				
             , seq                   
    --         , ADJUST_IN_QTY_BATCH	
			 --, ADJUST_IN_QTY
    --         , ADJUST_IN_QTY_M		
    --         , ADJUST_IN_QTY_CELL	
    --         , ADJUST_IN_QTY_JR		
    --         , ADJUST_OUT_QTY_BATCH	
			 --, ADJUST_OUT_QTY
    --         , ADJUST_OUT_QTY_M		
             , ADJUST_OUT_QTY_CELL	
             --, ADJUST_OUT_QTY_JR		
             , INSERT_ID             
             , INSERT_TIME           
             , UPDATE_ID             
             , UPDATE_TIME           
             , WORK_REQUEST_MODEL_ID 
             , VERSION 				
             , PROD_SEQ 				
             , PLM_EC_NO  			
             , _MSG                  
             , _VALID   
			 , JUMBOROLL_CELL_M	
			 , PANCAKE_M_BATCH	
			 , CELL_BATCH		
			 , JUMBOROLL_M_BATCH	
			 , PANCAKE_CELL_M	
			 , batch_point
			 )
		SELECT 
               A.INSTANCE_ID           
             , A.FP_PLAN_ID 			
             , A.COMPANY_ID            
             , A.DIVISION_ID 			
             , A.SITE_ID 				
             , A.PLANT_ID 				
             , A.FACTORY_ID 			
             , A.LOCATION 				
             , A.OPERATION_ID 			
             , A.LINE_ID 				
             , A.ELECTRODE_TYPE 		
             , A.EQUIPMENT_ID 			
             , A.PLAN_DATE 			
             , A.top_item_id           
             , A.ITEM_ID 				
             , A.PRODUCTION_TYPE		
             , A.MARKET 				
             , A.seq                   
    --         , ROUND(A.ADJUST_IN_QTY_CELL/b.cell_batch, convert(int, c.ATTRIBUTE14))	AS ADJUST_IN_QTY_BATCH	
			 --, CEILING(A.ADJUST_IN_QTY_CELL/b.Pancake_cell_m)			AS ADJUST_IN_QTY
    --         , CEILING(A.ADJUST_IN_QTY_CELL/b.Pancake_cell_m)			AS ADJUST_IN_QTY_M		
    --         , CEILING(A.ADJUST_IN_QTY_CELL)							AS ADJUST_IN_QTY_CELL	
    --         , CEILING(A.ADJUST_IN_QTY_CELL/b.JumboRoll_cell_m)			AS ADJUST_IN_QTY_JR		
    --         , ROUND(A.ADJUST_OUT_QTY_CELL/b.cell_batch, convert(int,c.ATTRIBUTE14))	AS ADJUST_OUT_QTY_BATCH	
			 --, CEILING(A.ADJUST_OUT_QTY_CELL/b.Pancake_cell_m)			AS ADJUST_OUT_QTY
    --         , CEILING(A.ADJUST_OUT_QTY_CELL/b.Pancake_cell_m)			AS ADJUST_OUT_QTY_M	
             , CEILING(A.ADJUST_OUT_QTY_CELL)							AS ADJUST_OUT_QTY_CELL	
             --, CEILING(A.ADJUST_OUT_QTY_CELL/b.JumboRoll_cell_m)		AS ADJUST_OUT_QTY_JR	
             , A.JOB_USER_ID             
             , dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME           
             , A.JOB_USER_ID             
             , dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME           
             , A.WORK_REQUEST_MODEL_ID 
             , A.VERSION 				
             , A.PROD_SEQ 				
             , A.PLM_EC_NO  			
		     , CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
		            ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
		       END AS _MSG
		     , CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
			 , b.JUMBOROLL_CELL_M	
			 , b.PANCAKE_M_BATCH	
			 , b.CELL_BATCH		
			 , b.JUMBOROLL_M_BATCH	
			 , b.PANCAKE_CELL_M	
			 , convert(int,c.ATTRIBUTE14) as batch_point
		  FROM (
		         SELECT 
                        TT.* 			
		              , MSG1
		                + (CASE WHEN (MSG1 = '')                                                                                                                                                                             THEN MSG2  ELSE (CASE WHEN MSG2 = ''  THEN '' ELSE ',' + MSG2  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                                                                                               THEN MSG3  ELSE (CASE WHEN MSG3 = ''  THEN '' ELSE ',' + MSG3  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                                                                                                 THEN MSG4  ELSE (CASE WHEN MSG4 = ''  THEN '' ELSE ',' + MSG4  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                                                                                                   THEN MSG5  ELSE (CASE WHEN MSG5 = ''  THEN '' ELSE ',' + MSG5  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                                                                                                     THEN MSG6  ELSE (CASE WHEN MSG6 = ''  THEN '' ELSE ',' + MSG6  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '')                                                                                                       THEN MSG7  ELSE (CASE WHEN MSG7 = ''  THEN '' ELSE ',' + MSG7  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '')                                                                                         THEN MSG8  ELSE (CASE WHEN MSG8 = ''  THEN '' ELSE ',' + MSG8  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '')                                                                           THEN MSG9  ELSE (CASE WHEN MSG9 = ''  THEN '' ELSE ',' + MSG9  END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '')                                                             THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '')                                              THEN MSG11 ELSE (CASE WHEN MSG11 = '' THEN '' ELSE ',' + MSG11 END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '' AND MSG11 = '')                               THEN MSG12 ELSE (CASE WHEN MSG12 = '' THEN '' ELSE ',' + MSG12 END) END)
		                + (CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '' AND MSG11 = '' AND MSG11 = '')                THEN MSG13 ELSE (CASE WHEN MSG13 = '' THEN '' ELSE ',' + MSG13 END) END)
		                + ' Not Found' AS __MSG
		           FROM (
		                  SELECT DISTINCT A.INSTANCE_ID
						       , A.FP_PLAN_ID
		                       , A.COMPANY_ID
							   , A.DIVISION_ID
							   , A.SITE_ID
							   , A.PLANT_ID
		                       , A.FACTORY_ID
							   , A.LOCATION
		                       , A.OPERATION_ID
							   , A.LINE_ID
							   , D.LINE_NAME
							   , A.ELECTRODE_TYPE
							   , A.EQUIPMENT_ID
		                       , A.PLAN_DATE
		                       , A.TOP_ITEM_ID
							   , A.ITEM_ID
							   , B.NICK_NAME
		                       , A.PRODUCTION_TYPE
							   , A.MARKET
		                       , A.SEQ
							   , A.QTY
		                       , A.ADJUST_IN_QTY_BATCH
							   , A.ADJUST_IN_QTY_M
							   , A.ADJUST_IN_QTY_CELL
							   , A.ADJUST_IN_QTY_JR
							   , A.ADJUST_OUT_QTY_BATCH
							   , A.ADJUST_OUT_QTY_M
							   , A.ADJUST_OUT_QTY_CELL
							   , A.ADJUST_OUT_QTY_JR
		                       , A.JOB_USER_ID
							   , A.JOB_TIME
							   , A.JOB_TYPE
							   , A.JOB_ORDER
		                       , CASE WHEN A.COMPANY_ID IS NULL THEN 'Building' ELSE ''	END				AS MSG1
		                       , CASE WHEN B.ITEM_ID IS NULL THEN 'Material' ELSE '' END				AS MSG2
		                       , CASE WHEN C.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END			AS MSG3
		                       , CASE WHEN D.LINE_ID IS NULL THEN 'Line - Electrode Type' ELSE '' END AS MSG4
		                       , CASE WHEN E.CODE_ID IS NULL THEN 'Production Type' ELSE '' END AS MSG5
		                       , CASE WHEN F.CODE_ID IS NULL THEN 'Market' ELSE '' END AS MSG6
		                       , CASE WHEN L.EQUIPMENT_ID IS NULL THEN 'Equipment' ELSE '' END AS MSG7
		                       , '' AS MSG8
		                       , (CASE WHEN A.PRODUCTION_TYPE = '4M-VALID' THEN CASE WHEN O.VERSION IS NULL THEN 'PDS Target Version' ELSE '' END ELSE '' END) AS MSG9 
							 --  , '' AS MSG9
		                       , CASE WHEN A.ADJUST_OUT_QTY_CELL > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN 'Line Assign' ELSE '' END ) ELSE '' END AS MSG10
		                       , CASE WHEN A.ADJUST_OUT_QTY_CELL > 0 THEN ( CASE WHEN K.KEY_VALUE = 'DAILY_CAPA' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN 'Daily Capa' ELSE '' END)
		                              ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN 'Tact Time' ELSE '' END) END ) ELSE '' END AS MSG11
		                       , CASE WHEN A.ADJUST_OUT_QTY_CELL > 0 AND ( N.VERSION IS NULL OR N.ACTIVE_FLAG <> 'Y' ) THEN 'Model Measure Conversion' ELSE '' END AS MSG12 
		                       , CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG13
							 --  , '' AS MSG13
		                       , CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
		                                   ORDER BY A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO)>1 THEN 'Data Overlap'
		                              ELSE '' END AS MSG99
		                       , A.WORK_REQUEST_MODEL_ID
							   , A.VERSION
							   , A.PROD_SEQ
							   , A.PLM_EC_NO 
		                    FROM (
		                           SELECT A.INSTANCE_ID, A.FP_PLAN_ID
		                                , ISNULL(B.COMPANY_ID,'-') AS COMPANY_ID
										, ISNULL(B.DIVISION_ID,'-') AS DIVISION_ID
										, ISNULL(B.SITE_ID,'-') AS SITE_ID
										, ISNULL(B.PLANT_ID,'-') AS PLANT_ID
		                                , A.FACTORY_ID
										, A.LOCATION
		                                , A.OPERATION_ID, A.LINE_ID
										, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
		                                , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
		                                , A.TOP_ITEM_ID
										, A.ITEM_ID
		                                , A.PRODUCTION_TYPE
										, A.MARKET
		                                , A.SEQ
										, A.QTY
		                                , A.ADJUST_IN_QTY_BATCH
										, A.ADJUST_IN_QTY_M
										, A.ADJUST_IN_QTY_CELL
										, A.ADJUST_IN_QTY_JR
										, A.ADJUST_OUT_QTY_BATCH
										, A.ADJUST_OUT_QTY_M
										, A.ADJUST_OUT_QTY_CELL
										, A.ADJUST_OUT_QTY_JR
		                                , A.JOB_USER_ID
										, A.JOB_TIME
										, A.JOB_TYPE
										, A.JOB_ORDER
		                                , A.WORK_REQUEST_MODEL_ID
										, A.VERSION
										, A.PROD_SEQ
										, A.PLM_EC_NO 
		                             FROM BUF_AMEND_DAILY_PLAN_R_XLS A WITH(NOLOCK)
		                                  LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)
		                               ON A.DIVISION_ID = B.DIVISION_ID
		                              AND A.SITE_ID     = B.SITE_ID
		                              AND A.PLANT_ID    = B.PLANT_ID
		                              AND A.FACTORY_ID  = B.FACTORY_ID
		                              AND B.ACTIVE_FLAG = 'Y'
		                            WHERE A.JOB_USER_ID = @v_user_id
		                              AND A.INSTANCE_ID = @v_instance_id
									  AND A.FP_PLAN_ID  = @v_fp_plan_id
		                         ) A
		                         LEFT OUTER JOIN (
		                                           SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID
												        , A.ITEM_ID
														, ISNULL(A.NICK_NAME,'-') AS NICK_NAME
		                                                , A.APPLIED_MODEL
		                                             FROM SCM_ITEM_M A WITH(NOLOCK),
		                                                  SCM_ITEM_CLASS_M C WITH(NOLOCK)
		                                            WHERE A.ITEM_CLASS  = C.CLASS_ID
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
		                     AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE
		                     AND D.ACTIVE_FLAG     = 'Y'
		                         LEFT OUTER JOIN (
		                                           SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID, A.ATTRIBUTE5 AS _4MCC_VERSION_FLAG, A.ATTRIBUTE6 AS _4MCC_VERSION_FLAG2 
		                                           FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
		                                           WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
		                                           AND    A.ACTIVE_FLAG = 'Y'
		                                         ) E
		                     ON  A.PRODUCTION_TYPE = E.CODE_ID
		                     AND A.DIVISION_ID = E.SEGMENT1
		                     AND (CASE WHEN (A.SITE_ID <> 'A004' AND A.DIVISION_ID <> '81_UC') AND A.PRODUCTION_TYPE IN ('E-TEST','D-TEST') THEN 'XX' ELSE A.PRODUCTION_TYPE END ) = E.CODE_ID
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
		                        LEFT OUTER JOIN SCM_EQUIPMENT_M L WITH(NOLOCK)
		                    ON  A.COMPANY_ID      = L.COMPANY_ID
		                    AND A.DIVISION_ID     = L.DIVISION_ID
		                    AND A.SITE_ID         = L.SITE_ID
		                    AND A.PLANT_ID        = L.PLANT_ID
		                    AND A.FACTORY_ID      = L.FACTORY_ID
		                    AND A.OPERATION_ID    = L.OPERATION_ID
		                    AND A.LINE_ID		      = L.LINE_ID
		                    AND A.EQUIPMENT_ID    = L.EQUIPMENT_ID
		                    AND L.ACTIVE_FLAG 	  = 'Y'
		                        LEFT OUTER HASH JOIN (
		                                               SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.OPERATION, A.ITEM_ID, A.VERSION 
		                                                    , B.LINE_ID, B.ELECTRODE_TYPE, ISNULL(B.ACTIVE_FLAG, 'Y') AS ACTIVE_FLAG 
		                                                 FROM (
		                                                        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, VERSION
		                                                        FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
		                                                        WHERE  A.OPERATION = 'E2000' 
		                                                        AND    A.VALUE > 0
		                                                        AND    A.CATEGORY IN (  'Jumbo Roll (cell/m)'
		                                                        , 'Lane Number'
		                                                        , 'Pancake (m/batch)'
		                                                        , 'cell/batch'
		                                                        , 'Jumbo Roll (m/batch)'
		                                                        , 'Pancake (cell/m)' )
		                                                        GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, VERSION
		                                                        HAVING COUNT(1) = 6
		                                                      ) A
		                                                      LEFT OUTER JOIN SCM_ITEM_CONV_CALC_USE_M B WITH(NOLOCK) 
		                                                  ON  A.COMPANY_ID = B.COMPANY_ID 
		                                                  AND A.FACTORY_ID = B.FACTORY_ID 
		                                                  AND A.MODEL_ID   = B.MODEL_ID 
		                                                  AND A.VERSION    = B.VERSION 
		                                                  AND A.OPERATION  = B.OPERATION_ID 
		                                                  AND A.ITEM_ID    = B.ITEM_ID 
		                                             ) N
		                    ON  A.COMPANY_ID    = N.COMPANY_ID
		                    AND A.DIVISION_ID   = N.DIVISION_ID
		                    AND A.SITE_ID       = N.SITE_ID
		                    AND A.PLANT_ID      = N.PLANT_ID
		                    AND A.FACTORY_ID    = N.FACTORY_ID
		                    AND A.OPERATION_ID  = N.OPERATION
		                    AND A.ITEM_ID       = N.ITEM_ID
		                    AND A.WORK_REQUEST_MODEL_ID = N.MODEL_ID
		                    AND A.VERSION       = N.VERSION
		                    AND A.LINE_ID        = N.LINE_ID 
		                    AND A.ELECTRODE_TYPE = N.ELECTRODE_TYPE 
		                        LEFT OUTER JOIN ( 
		                                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET, A.VERSION 
		                                            FROM FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK) 
		                                                 INNER JOIN FP_INSTANCE_LINE_V B WITH(NOLOCK) 
		                                             ON  1 = 1 
		                                             AND A.COMPANY_ID   = B.COMPANY_ID 
		                                             AND A.DIVISION_ID  = B.DIVISION_ID 
		                                             AND A.SITE_ID      = B.SITE_ID 
		                                             AND A.PLANT_ID     = B.PLANT_ID 
		                                             AND A.FACTORY_ID   = B.FACTORY_ID 
		                                             AND A.OPERATION_ID = B.OPERATION_ID 
		                                             AND A.LINE_ID      = B.LINE_ID 
		                                             AND B.INSTANCE_ID  = @v_instance_id
		                                           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET, A.VERSION 
		                                        ) O 
		                    ON  A.COMPANY_ID      = O.COMPANY_ID 
		                    AND A.DIVISION_ID     = O.DIVISION_ID 
		                    AND A.SITE_ID         = O.SITE_ID 
		                    AND A.PLANT_ID        = O.PLANT_ID 
		                    AND A.FACTORY_ID      = O.FACTORY_ID 
		                    AND A.OPERATION_ID    = O.OPERATION_ID 
		                    AND A.LINE_ID         = O.LINE_ID 
		                    AND A.ITEM_ID         = O.ITEM_ID 
		                    AND A.PRODUCTION_TYPE = O.PRODUCTION_TYPE 
		                    AND A.MARKET          = O.MARKET 
		                    AND A.LINE_ID         = O.LINE_ID 
		                    AND A.VERSION         = O.VERSION 
		                        LEFT OUTER JOIN (
		                                          SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
		                                          FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)
		                                          WHERE	1=1
		                                          AND		R.USER_ID	= @v_user_id
		                                          AND		R.SAVE_FLAG	= 'Y'
		                                          AND		R.INSTANCE_ID = @v_instance_id
		                                        ) R
		                    ON	1 = 1
		                    AND	A.COMPANY_ID		= R.COMPANY_ID
		                    AND	A.DIVISION_ID		= R.DIVISION_ID
		                    AND	A.SITE_ID			= R.SITE_ID
		                    AND	A.PLANT_ID			= R.PLANT_ID
		                    AND	A.FACTORY_ID		= R.FACTORY_ID
		                    AND	A.OPERATION_ID		= R.OPERATION_ID
		                    AND	A.LINE_ID			= R.LINE_ID

				        ) TT
		       ) A
			   left outer join (
							   select COMPANY_ID, FACTORY_ID, MODEL_ID, VERSION, OPERATION, ITEM_ID, JumboRoll_cell_m, Pancake_m_batch, cell_batch, JumboRoll_m_batch, Pancake_cell_m
								 from (
										SELECT COMPANY_ID, FACTORY_ID, MODEL_ID, VERSION, OPERATION, ITEM_ID
											 , max(case when category = 'Jumbo Roll (cell/m)'	then value end) as JumboRoll_cell_m
                       						 , max(case when category = 'Pancake (m/batch)'	then value end)		as Pancake_m_batch	
                       						 , max(case when category = 'cell/batch'			then value end) as cell_batch			
                       						 , max(case when category = 'Jumbo Roll (m/batch)' then value end)	as JumboRoll_m_batch 
                       						 , max(case when category = 'Pancake (cell/m)'		then value end) as Pancake_cell_m		
                       					FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
                       					WHERE  A.OPERATION = 'E2000' 
                       					AND    A.VALUE > 0
                       					AND    A.CATEGORY IN (  'Jumbo Roll (cell/m)'
                       					, 'Lane Number'
                       					, 'Pancake (m/batch)'
                       					, 'cell/batch'
                       					, 'Jumbo Roll (m/batch)'
                       					, 'Pancake (cell/m)' )
									   group by COMPANY_ID, FACTORY_ID, MODEL_ID, VERSION, OPERATION, ITEM_ID
                                     ) as x
							   ) as b 
            on a.company_id = b.company_id
		   and a.factory_id = b.factory_id
		   and a.WORK_REQUEST_MODEL_ID = b.model_id
		   and a.version = b.version
		   and a.operation_id = b.operation
		   and a.item_id = b.item_id
			   left outer join SCM_SYS_LOOKUP_VALUE as C with(nolock)
		    on c.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
		   and c.ACTIVE_FLAG = 'Y'
		   and c.SEGMENT1 = a.instance_id
         where CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END = 'Y'
		 --ORDER BY A.JOB_ORDER


		select @INVALID_COUNT = count(*)
		  from #BUF_AMEND_DAILY_PLAN_R_XLS
		 where _VALID = 'N'
		
		if @INVALID_COUNT > 0
		BEGIN
			RAISERROR  ('Invalid data included in buf table. ', 16, 1 ); 
		
		END

		insert into #FP_AMEND_DAILY_BOR_r
				 (
				   INSTANCE_ID           
				 , FP_PLAN_ID 			
				 , COMPANY_ID            
				 , DIVISION_ID 			
				 , SITE_ID 				
				 , PLANT_ID 				
				 , FACTORY_ID 			
				 , LOCATION 				
				 , OPERATION_ID 			
				 , LINE_ID 				
				 , ELECTRODE_TYPE 		
				 , EQUIPMENT_ID 			
				 , ITEM_ID 	
				 , CALC_TYPE
				 , CALC_VERSION
				 , WORK_REQUEST_MODEL_ID
				 , VERSION
				 , PLM_EC_NO
				 , START_DATE            
				 , END_DATE              
				 , YIELD                 
				 , CHILD_YIELD        
				 )
			SELECT A.INSTANCE_ID
			     , A.FP_PLAN_ID
			     , A.COMPANY_ID
			     , A.DIVISION_ID
			     , A.SITE_ID
			     , A.PLANT_ID
			     , A.FACTORY_ID
			     , A.LOCATION
			     , A.OPERATION_ID
			     , A.LINE_ID
			     , A.ELECTRODE_TYPE
			     , A.EQUIPMENT_ID
			     , A.ITEM_ID
				 , A.CALC_TYPE
				 , A.CALC_VERSION
				 , A.WORK_REQUEST_MODEL_ID
				 , A.VERSION
				 , A.PLM_EC_NO
			     , CONVERT(VARCHAR,A.START_DATE,112) AS START_DATE
			     , CONVERT(VARCHAR,A.END_DATE,112) AS END_DATE
			     , A.YIELD AS YIELD
			     , A.CHILD_YIELD AS CHILD_YIELD
			  FROM FP_AMEND_DAILY_BOR_r A WITH(NOLOCK)
			 WHERE A.INSTANCE_ID = @v_instance_id
			   AND A.FP_PLAN_ID  = @p_fp_plan_id
			 ORDER BY 
			       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
			     , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
			     , A.EQUIPMENT_ID, A.ITEM_ID, START_DATE


		SELECT @INX			= 1
			  ,@MAX_NUM		= COUNT(*)
		  FROM #BUF_AMEND_DAILY_PLAN_R_XLS
	  
		IF @MAX_NUM = 0
		BEGIN
			RETURN 0;
		END

		WHILE @INX <= @MAX_NUM
		BEGIN


		

			SELECT  @INSTANCE_ID			 = INSTANCE_ID			
				  , @FP_PLAN_ID 			 = FP_PLAN_ID 			
				  , @COMPANY_ID				 = COMPANY_ID				
				  , @DIVISION_ID 			 = DIVISION_ID 			
				  , @SITE_ID 				 = SITE_ID 				
				  , @PLANT_ID 				 = PLANT_ID 				
				  , @FACTORY_ID 			 = FACTORY_ID 			
				  , @LOCATION 				 = LOCATION 				
				  , @OPERATION_ID 			 = OPERATION_ID 			
				  , @LINE_ID 				 = LINE_ID 				
				  , @ELECTRODE_TYPE 		 = ELECTRODE_TYPE 		
				  , @EQUIPMENT_ID 			 = EQUIPMENT_ID 			
				  , @PLAN_DATE 				 = PLAN_DATE 				
				  , @top_item_id			 = top_item_id			
				  , @ITEM_ID 				 = ITEM_ID 				
				  , @PRODUCTION_TYPE		 = PRODUCTION_TYPE		
				  , @MARKET 				 = MARKET 				
				  , @seq					 = seq					
				  , @ADJUST_IN_QTY_BATCH	 = ADJUST_IN_QTY_BATCH	
				  , @ADJUST_IN_QTY			 = ADJUST_IN_QTY			
				  , @ADJUST_IN_QTY_M		 = ADJUST_IN_QTY_M		
				  , @ADJUST_IN_QTY_CELL		 = ADJUST_IN_QTY_CELL		
				  , @ADJUST_IN_QTY_JR		 = ADJUST_IN_QTY_JR		
				  , @ADJUST_OUT_QTY_BATCH	 = ADJUST_OUT_QTY_BATCH	
				  , @ADJUST_OUT_QTY			 = ADJUST_OUT_QTY			
				  , @ADJUST_OUT_QTY_M		 = ADJUST_OUT_QTY_M		
				  , @ADJUST_OUT_QTY_CELL	 = ADJUST_OUT_QTY_CELL	
				  , @ADJUST_OUT_QTY_JR		 = ADJUST_OUT_QTY_JR		
				  , @INSERT_ID				 = INSERT_ID				
				  , @INSERT_TIME			 = INSERT_TIME			
				  , @UPDATE_ID				 = UPDATE_ID				
				  , @UPDATE_TIME			 = UPDATE_TIME			
				  , @WORK_REQUEST_MODEL_ID 	 = WORK_REQUEST_MODEL_ID 	
				  , @VERSION 				 = VERSION 				
				  , @PROD_SEQ 				 = PROD_SEQ 				
				  , @PLM_EC_NO  			 = PLM_EC_NO  			
				  , @_MSG                    = _MSG                    
				  , @_VALID                  = _VALID  
				  , @JUMBOROLL_CELL_M	     = JUMBOROLL_CELL_M	
				  , @PANCAKE_M_BATCH		 = PANCAKE_M_BATCH	
				  , @CELL_BATCH				 = CELL_BATCH			
				  , @JUMBOROLL_M_BATCH		 = JUMBOROLL_M_BATCH	
				  , @PANCAKE_CELL_M			 = PANCAKE_CELL_M		
				  , @BATCH_POINT        	 = BATCH_POINT        
			   FROM #BUF_AMEND_DAILY_PLAN_R_XLS 
			  WHERE TID						= @INX


			-- YIELD 적용

			SET @YIELD			= 1
			SET @CHILD_YIELD	= 1

			SELECT TOP 1
			       @YIELD			= YIELD
			     , @CHILD_YIELD		= CHILD_YIELD
			  from #FP_AMEND_DAILY_BOR_r a with(nolock)
			 WHERE A.INSTANCE_ID			= @INSTANCE_ID
			   AND A.FP_PLAN_ID				= @FP_PLAN_ID
			   AND FACTORY_ID				= @FACTORY_ID
			   AND LOCATION					= @LOCATION
			   AND OPERATION_ID				= @OPERATION_ID
			   AND LINE_ID					= @LINE_ID
			   AND ELECTRODE_TYPE			= @ELECTRODE_TYPE
			   AND EQUIPMENT_ID				= @EQUIPMENT_ID
			   AND ITEM_ID					= @ITEM_ID
			   AND CALC_TYPE				= @PRODUCTION_TYPE
			   AND CALC_VERSION				= @VERSION
			   AND @PLAN_DATE				BETWEEN START_DATE AND END_DATE 
			   AND WORK_REQUEST_MODEL_ID	= @WORK_REQUEST_MODEL_ID
			   and version                  = @version
			   and plm_ec_no                = @PLM_EC_NO

--PRINT ISNULL(@INSTANCE_ID,'instance_id') +'|'+ ISNULL(@FP_PLAN_ID , 'fp_plan_id')+'|'+ ISNULL(@FACTORY_ID , 'factory_id') +'|'+ ISNULL(@LOCATION, 'location') +'|'+ ISNULL(@OPERATION_ID, 'operation_id')
--            +'|'+ ISNULL(@LINE_ID, 'line_id') +'|'+ ISNULL(@ELECTRODE_TYPE, 'electrode_type') +'|'+ ISNULL(@EQUIPMENT_ID, 'equipment_id') +'|'+ ISNULL(@ITEM_ID, 'item_id') +'|'+ ISNULL(@PRODUCTION_TYPE,'production_type') +'|'+ ISNULL(@VERSION, 'version') +'|'+ ISNULL(convert(nvarchar,@YIELD), 'yield') +'|'+ ISNULL(convert(nvarchar, @CHILD_YIELD), 'child_yield')


			  SET @ADJUST_IN_QTY_BATCH		= ROUND(@ADJUST_OUT_QTY_CELL/@CELL_BATCH/@YIELD/@CHILD_YIELD, @BATCH_POINT)
			  SET @ADJUST_IN_QTY			= CEILING(@ADJUST_OUT_QTY_CELL/@PANCAKE_CELL_M/@YIELD)
			  SET @ADJUST_IN_QTY_M			= CEILING(@ADJUST_OUT_QTY_CELL/@PANCAKE_CELL_M/@YIELD)
			  SET @ADJUST_IN_QTY_CELL		= CEILING(@ADJUST_OUT_QTY_CELL/@YIELD)
			  SET @ADJUST_IN_QTY_JR			= CEILING(@ADJUST_OUT_QTY_CELL/@JUMBOROLL_CELL_M/@YIELD)
			  SET @ADJUST_OUT_QTY_BATCH		= ROUND(@ADJUST_OUT_QTY_CELL/@CELL_BATCH/@YIELD/@CHILD_YIELD, @BATCH_POINT)
			  SET @ADJUST_OUT_QTY			= CEILING(@ADJUST_OUT_QTY_CELL/@PANCAKE_CELL_M)
			  SET @ADJUST_OUT_QTY_M			= CEILING(@ADJUST_OUT_QTY_CELL/@PANCAKE_CELL_M)
			  SET @ADJUST_OUT_QTY_CELL		= @ADJUST_OUT_QTY_CELL
			  SET @ADJUST_OUT_QTY_JR		= CEILING(@ADJUST_OUT_QTY_CELL/@JUMBOROLL_CELL_M)
			  --

			  MERGE INTO FP_AMEND_DAILY_PLAN_R A
			  USING (SELECT @INSTANCE_ID AS INSTANCE_ID
						  , @FP_PLAN_ID AS FP_PLAN_ID
						  , @FACTORY_ID AS FACTORY_ID
						  , @LOCATION AS LOCATION
						  , @OPERATION_ID AS OPERATION_ID
						  , @LINE_ID AS LINE_ID
						  , @ELECTRODE_TYPE AS ELECTRODE_TYPE
						  , @EQUIPMENT_ID AS EQUIPMENT_ID
						  , @PLAN_DATE AS PLAN_DATE
						  , @TOP_ITEM_ID AS TOP_ITEM_ID
						  , @ITEM_ID AS ITEM_ID
						  , UPPER(@PRODUCTION_TYPE) AS PRODUCTION_TYPE
						  , @MARKET AS MARKET
						  , @WORK_REQUEST_MODEL_ID AS WORK_REQUEST_MODEL_ID
						  , @VERSION AS VERSION
						  , @PLM_EC_NO AS PLM_EC_NO 
					) B
				 ON A.INSTANCE_ID = B.INSTANCE_ID 
				AND A.FP_PLAN_ID = B.FP_PLAN_ID
				AND A.FACTORY_ID = B.FACTORY_ID 
				AND A.LOCATION = B.LOCATION
				AND A.OPERATION_ID = B.OPERATION_ID 
				AND A.LINE_ID = B.LINE_ID 
				AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND A.EQUIPMENT_ID = B.EQUIPMENT_ID 
				AND A.PLAN_DATE = B.PLAN_DATE
				AND A.TOP_ITEM_ID = B.TOP_ITEM_ID 
				AND A.ITEM_ID = B.ITEM_ID
				AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE 
				AND A.MARKET = B.MARKET
				AND A.WORK_REQUEST_MODEL_ID = B.WORK_REQUEST_MODEL_ID
				AND A.VERSION = B.VERSION
				AND A.PLM_EC_NO = B.PLM_EC_NO
			  WHEN MATCHED THEN
					UPDATE SET SEQ = CASE WHEN CONVERT(NUMERIC(25,10),ISNULL(@ADJUST_IN_QTY_BATCH,0)) = 0 THEN 0 ELSE @SEQ END 
						 , ADJUST_IN_QTY_BATCH  = @ADJUST_IN_QTY_BATCH
						 , ADJUST_IN_QTY        = @ADJUST_IN_QTY
						 , ADJUST_IN_QTY_M      = @ADJUST_IN_QTY_M
						 , ADJUST_IN_QTY_CELL   = @ADJUST_IN_QTY_CELL
						 , ADJUST_IN_QTY_JR     = @ADJUST_IN_QTY_JR
						 , ADJUST_OUT_QTY_BATCH = @ADJUST_OUT_QTY_BATCH
						 , ADJUST_OUT_QTY       = @ADJUST_OUT_QTY
						 , ADJUST_OUT_QTY_M     = @ADJUST_OUT_QTY_M
						 , ADJUST_OUT_QTY_CELL  = @ADJUST_OUT_QTY_CELL
						 , ADJUST_OUT_QTY_JR    = @ADJUST_OUT_QTY_JR
						 , PRODUCTION_TYPE      = UPPER(@PRODUCTION_TYPE)
						 , UPDATE_ID			= @UPDATE_ID
						 , UPDATE_TIME			= @UPDATE_TIME
			  WHEN NOT MATCHED THEN
					INSERT (
						   INSTANCE_ID
						 , FP_PLAN_ID
						 , COMPANY_ID
						 , DIVISION_ID
						 , SITE_ID
						 , PLANT_ID
						 , FACTORY_ID
						 , LOCATION
						 , OPERATION_ID
						 , LINE_ID
						 , ELECTRODE_TYPE
						 , EQUIPMENT_ID
						 , PLAN_DATE
						 , TOP_ITEM_ID
						 , ITEM_ID
						 , PRODUCTION_TYPE, MARKET
						 , SEQ
						 , PLAN_IN_QTY_BATCH
						 , PLAN_IN_QTY
						 , PLAN_IN_QTY_M
						 , PLAN_IN_QTY_CELL
						 , PLAN_OUT_QTY_BATCH
						 , PLAN_OUT_QTY
						 , PLAN_OUT_QTY_M
						 , PLAN_OUT_QTY_CELL
						 , ADJUST_IN_QTY_BATCH
						 , ADJUST_IN_QTY
						 , ADJUST_IN_QTY_M
						 , ADJUST_IN_QTY_CELL
						 , ADJUST_IN_QTY_JR
						 , ADJUST_OUT_QTY_BATCH
						 , ADJUST_OUT_QTY
						 , ADJUST_OUT_QTY_M
						 , ADJUST_OUT_QTY_CELL
						 , ADJUST_OUT_QTY_JR
						 , INSERT_ID
						 , INSERT_TIME
						 , UPDATE_ID
						 , UPDATE_TIME
						 , WORK_REQUEST_MODEL_ID
						 , VERSION
						 , PROD_SEQ
						 , PLM_EC_NO
						 )
				  VALUES (
						   B.INSTANCE_ID
						 , B.FP_PLAN_ID
						 , @COMPANY_ID 
						 , @DIVISION_ID
						 , @SITE_ID
						 , @PLANT_ID
						 , B.FACTORY_ID
						 , B.LOCATION
						 , B.OPERATION_ID
						 , B.LINE_ID
						 , B.ELECTRODE_TYPE
						 , B.EQUIPMENT_ID 
						 , B.PLAN_DATE
						 , B.ITEM_ID
						 , B.ITEM_ID
						 , B.PRODUCTION_TYPE
						 , B.MARKET
						 , CASE WHEN CONVERT(NUMERIC(25,10),ISNULL(@ADJUST_IN_QTY_BATCH,0)) = 0 THEN 0 ELSE @SEQ END
						 , null
						 , null
						 , null
						 , null
						 , null
						 , null
						 , null
						 , null
						 , @ADJUST_IN_QTY_BATCH
						 , @ADJUST_IN_QTY
						 , @ADJUST_IN_QTY_M
						 , @ADJUST_IN_QTY_CELL
						 , @ADJUST_IN_QTY_JR
						 , @ADJUST_OUT_QTY_BATCH
						 , @ADJUST_OUT_QTY
						 , @ADJUST_OUT_QTY_M
						 , @ADJUST_OUT_QTY_CELL
						 , @ADJUST_OUT_QTY_JR
						 , @INSERT_ID
						 , @INSERT_TIME
						 , @UPDATE_ID
						 , @UPDATE_TIME
						 , B.WORK_REQUEST_MODEL_ID
						 , B.VERSION
						 , @PROD_SEQ
						 , B.PLM_EC_NO
						 )
			;


			SET @INX = @INX + 1

		END

	END TRY

	BEGIN CATCH

		PRINT ERROR_MESSAGE()

		if object_id('tempdb..#BUF_AMEND_DAILY_PLAN_R_XLS') is not null
			drop table #BUF_AMEND_DAILY_PLAN_R_XLS

		if object_id('tempdb..#FP_AMEND_DAILY_BOR_r') is not null
			drop table #FP_AMEND_DAILY_BOR_r

	END CATCH

	if object_id('tempdb..#BUF_AMEND_DAILY_PLAN_R_XLS') is not null
		drop table #BUF_AMEND_DAILY_PLAN_R_XLS

	if object_id('tempdb..#FP_AMEND_DAILY_BOR_r') is not null
		drop table #FP_AMEND_DAILY_BOR_r
END



