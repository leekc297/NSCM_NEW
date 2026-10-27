CREATE PROCEDURE [dbo].[PR_SCM_IF_TARGET]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_TARGET                                                          **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2016.08.18    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_TARGET
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company        nvarchar(30)   
  DECLARE @v_division        nvarchar(30)
  DECLARE @v_corporation    nvarchar(30)
  DECLARE @v_plant           nvarchar(30)
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  DECLARE @v_plan_type      nvarchar(30)
  DECLARE @v_daydiff        Integer

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_TARGET'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)

  DECLARE @v_prod_plan_id       nvarchar(30)
  DECLARE @v_ship_plan_id       nvarchar(30)
  DECLARE @v_ship_elec_plan_id  nvarchar(30)
  DECLARE @v_srs_plan_id        nvarchar(30)
  DECLARE @v_prod_test_plan_id  nvarchar(30)
  
  DECLARE @v_demand_target  nvarchar(30)
  DECLARE @v_start_week     nvarchar(6)
  DECLARE @v_end_week       nvarchar(6)
  DECLARE @v_confirm_week   int
  DECLARE @v_instance_type  nvarchar(10)
  
  DECLARE @v_plan_date      DATE
  DECLARE @v_plan_week      nvarchar(30)
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  
  DECLARE @v_is_wo_merge    nvarchar(5)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  DECLARE @v_release_plan_id  nvarchar(30)

  DECLARE @v_fix_role_id    nvarchar(30)

  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM,
              @v_plan_type = PLAN_TYPE,
              @v_daydiff = DAYDIFF,
              @v_prod_plan_id       = SCP_PRODUCT_PLAN_ID,
              @v_ship_plan_id       = SCP_SHIPMENT_PLAN_ID,
              @v_ship_elec_plan_id  = SCP_SHIP_ELEC_PLAN_ID,
              @v_srs_plan_id        = SCP_SRS_PLAN_ID,
              @v_prod_test_plan_id  = SCP_PROD_TEST_PLAN_ID,
              @v_plan_date = PLAN_DATE,
              @v_plan_week = PLAN_WEEK,
              @key_date    = CONVERT(NVARCHAR, PLAN_DATE, 112)
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN DEMAND_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, DEMAND_HORIZON,     PLAN_START_DTTM)
                          WHEN DEMAND_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, DEMAND_HORIZON * 7, PLAN_START_DTTM)
                          WHEN DEMAND_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, DEMAND_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_TYPE,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     TOP_PLAN_ID,
                     SCP_PRODUCT_PLAN_ID,
                     SCP_SHIPMENT_PLAN_ID,
                     SCP_SHIP_ELEC_PLAN_ID,
                     SCP_SRS_PLAN_ID,
                     SCP_PROD_TEST_PLAN_ID,
                     CONVERT(DATE, PLAN_DATE) AS PLAN_DATE,
                     WEEK AS PLAN_WEEK
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
      --LOG 생성
      SET @v_message  = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112) + ' / KEY DATE : ' + @key_date
      SET @v_message += ' / day minute : ' + CONVERT(nvarchar, @v_daydiff)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      
      SELECT @v_start_week = WEEK
      FROM   SY_SCM_SYS_CALENDAR_M
      WHERE  DATE_ID = CONVERT(DATE, @plan_start_time)

      SELECT @v_end_week = WEEK
      FROM   SY_SCM_SYS_CALENDAR_M
      WHERE  DATE_ID = CONVERT(DATE, @plan_end_time - 1)    -- 하루 뺀다.

      SET @v_message  = '@v_start_week : ' + CONVERT(nvarchar, @v_start_week, 112) + ' / @v_end_week : ' + CONVERT(nvarchar, @v_end_week, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


      
      SELECT @v_demand_target = isnull(max(key_value), 'PRODUCT') 
      FROM   SY_FP_INSTANCE_CONFIG_M
      where  instance_id = @v_master_id
      and    category_id = 'DEMAND_TARGET'
      --and    key_id      = 'OFFSET'
      
      SET @v_message  = '@v_demand_target : ' + @v_demand_target
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SELECT @v_confirm_week = isnull(convert(numeric, replace(replace(key_value, 'WEEK', ''), 'W', '')), 4)
      FROM   (SELECT MAX(key_value) AS key_value
              FROM   SY_FP_INSTANCE_CONFIG_M
              WHERE  INSTANCE_ID = 'COMMON'
              AND    CATEGORY_ID = 'DPP_CONFIG'
              AND    KEY_ID = 'CONFIRM_WEEK'
             ) A

      SET @v_message  = '@v_confirm_week : ' + convert(nvarchar, @v_confirm_week)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SELECT @v_instance_type = MAX(A.INSTANCE_TYPE) 
      FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
             SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
      WHERE  A.INSTANCE_ID = @v_master_id
      AND    A.FACTORY_ID = B.FACTORY_ID
      
      SET @v_message  = '@v_instance_type : ' + @v_instance_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT  @res_category = isnull(max(key_value), 'LINE')
      FROM    SY_FP_INSTANCE_CONFIG_M
      WHERE   instance_id = @v_master_id
      AND     category_id = 'RESOURCE_CATEGORY'
      AND     KEY_ID = @v_plan_type

      --LOG 생성
      SET @v_message = '@res_category : ' + @res_category
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;

    /*
    IF @v_plan_type <> 'PRE'
    
      BEGIN

        SET @v_message  = 'NOT PRE PLAN - @v_plan_type : ' + @v_plan_type
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_message
        
      END
      
    ELSE
    */
      BEGIN

        SET @n_row_count = 0
        SET @v_table_name = 'TH_MST_SCM_DEMAND'
        
        DELETE FROM TH_MST_SCM_DEMAND
        WHERE  INSTANCE_ID = @v_master_id
        AND    DPP_PLAN_ID = @v_plan_id

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null        

        --DELETE FROM TH_MST_SCM_DEMAND
        --WHERE  KEY_DATE <= CONVERT(NVARCHAR, DATEADD(DAY, -15, CONVERT(DATE, @key_date)), 112)      
        
        -- TARGET : PRODUCT
      
        BEGIN
          
	      SET @n_row_count = 0  
          SET @v_table_name = 'TH_MST_SCM_DEMAND'
          
          INSERT INTO TH_MST_SCM_DEMAND
              (
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SHOP_GROUP_ID
               , INSTANCE_ID
               , DPP_PLAN_ID
               , FP_DEMAND_ID
               , SCP_PLAN_ID
               , SCP_TARGET_ID
               , ITEM_ID
               , SCP_WEEK
               , MFG_WEEK
               , MFG_QTY
               , WORK_ORDER_ID
               , DUE_DATE
               , DUE_FENCE_DATE
               , PRECEDE_PRODUCING_TERM
               , PRECEDE_PRODUCING_TERM_UOM
               , PRODUCTION_TYPE
               , TO_SITE_ID
               , TO_PLANT_ID
               , TO_FACTORY_ID
               , LINE_ID
               , MARKET
               , PRIORITY
               , OFFSET_INVENTORY_QTY
               , OFFSET_GI_QTY
               , OFFSET_FIX_QTY
               , CONFIRM_TYPE
               , DEMAND_TYPE
               , TARGET_TYPE
               , KEY_DATE
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME                        
              )
          /*
		  SELECT B.COMPANY_ID 		AS COMPANY_ID
               , B.DIVISION_ID 		AS DIVISION_ID
               , B.SITE_ID 			AS SITE_ID
               , B.PLANT_ID 		AS PLANT_ID
               , 'E' 				AS SHOP_GROUP_ID
               , @v_master_id 	AS INSTANCE_ID
               , @v_plan_id 		AS DPP_PLAN_ID
               , B.DIVISION_ID + '^'+ B.PLANT_ID + '^' + CONVERT(CHAR(8), NP_PLAN_DATE, 112) + '^' 
               		+ ITEM_ID + '^' + NP_ITEM_ID + '^' + A.CELL_FACTORY_ID + '^' + A.LINE_ID AS FP_DEMAND_ID
               , CELL_RELEASE_PLAN_ID AS SCP_PLAN_ID
               , B.DIVISION_ID + '^'+ B.PLANT_ID + '^' + CONVERT(CHAR(8), NP_PLAN_DATE, 112) + '^' 
               		+ ITEM_ID + '^' + NP_ITEM_ID + '^' + A.CELL_FACTORY_ID + '^' + A.LINE_ID AS SCP_TARGET_ID
               , ITEM_ID
               , D.WEEK 			AS SCP_WEEK
               , E.WEEK 			AS MFG_WEEK
               , A.ITEM_REQ_QTY 	AS MFG_QTY
               , NULL             	AS WORK_ORDER_ID
               , CONVERT(DATE, A.NP_PLAN_DATE) 		AS DUE_DATE
               , CONVERT(DATE, @plan_end_time) 	AS DUE_FENCE_DATE
               , CASE WHEN C.TOLERANCE_UOM = 'DAY' THEN CONVERT(NUMERIC(20, 10), C.KEY_VALUE)
               		  WHEN C.TOLERANCE_UOM = 'WEEK' THEN CONVERT(NUMERIC(20, 10), C.KEY_VALUE) * 7 END AS PRECEDE_PRODUCING_TERM
               , 'DAY'            	AS PRECEDE_PRODUCING_TERM_UOM
               , ISNULL(A.ATTB_01, 'MASS') AS PRODUCTION_TYPE
               , A.CELL_SITE_ID 	AS TO_SITE_ID
               , A.CELL_PLANT_ID 	AS TO_PLANT_ID
               , A.CELL_FACTORY_ID 	AS TO_FACTORY_ID
               , '-' 				AS LINE_ID
               , ISNULL(A.ATTB_02, 'D') AS MARKET
               , CONVERT(CHAR(8), NP_PLAN_DATE, 112) + ITEM_ID AS PRIORITY
               , 0 					AS OFFSET_INVENTORY_QTY
               , 0 					AS OFFSET_GI_QTY
               , 0 					AS OFFSET_FIX_QTY
               , NULL 				AS CONFIRM_TYPE
               , 'NOR' 				AS DEMAND_TYPE
               , 'PRODUCT' 			AS TARGET_TYPE
               , @key_date 			AS KEY_DATE
               , @v_proc_name 		AS INSERT_ID
               , GETDATE() 			AS INSERT_TIME
               , @v_proc_name 		AS UPDATE_ID
               , GETDATE() 			AS UPDATE_TIME                               
			FROM  	TH_BUF_EPOST_NOTCHING_MTR_PLAN A,
					SY_FP_INSTANCE_INFO_V B,
					SY_FP_INSTANCE_CONFIG_M C,
					SY_SCM_SYS_CALENDAR_M D,
					SY_SCM_SYS_CALENDAR_M E
			WHERE 	1=1
			AND 	A.INSTANCE_ID = @v_master_id
			AND 	A.INSTANCE_ID = B.INSTANCE_ID
			AND 	A.INSTANCE_ID = C.INSTANCE_ID
			AND 	A.FP_PLAN_ID = @v_plan_id
			AND 	C.CATEGORY_ID = 'DPP_CONFIG'
			AND 	C.KEY_ID = 'PRECEDE_TERM'
			AND 	C.PART_ID = B.DIVISION_ID
			AND 	D.DATE_ID = CONVERT(DATE, @plan_start_time)
			AND 	E.DATE_ID = CONVERT(DATE, A.NP_PLAN_DATE)              
			*/
			SELECT B.COMPANY_ID 		AS COMPANY_ID
               , B.DIVISION_ID 		AS DIVISION_ID
               , B.SITE_ID 			AS SITE_ID
               , B.PLANT_ID 		AS PLANT_ID
               , 'E' 				AS SHOP_GROUP_ID
               , @v_master_id 	AS INSTANCE_ID
               , @v_plan_id 		AS DPP_PLAN_ID
               , B.DIVISION_ID + '^'+ B.PLANT_ID + '^' + CONVERT(CHAR(8), ITEM_PLAN_DATE, 112) + '^' + ITEM_ID   AS FP_DEMAND_ID
               , CELL_RELEASE_PLAN_ID AS SCP_PLAN_ID
               , B.DIVISION_ID + '^'+ B.PLANT_ID + '^' + CONVERT(CHAR(8), ITEM_PLAN_DATE, 112) + '^' + ITEM_ID  AS SCP_TARGET_ID
               , ITEM_ID
               , D.WEEK 			AS SCP_WEEK
               , E.WEEK 			AS MFG_WEEK
               , CEILING(A.E4000_OUT_QTY) 	AS MFG_QTY
               , NULL             	AS WORK_ORDER_ID
               , CONVERT(DATE, A.ITEM_PLAN_DATE) 		AS DUE_DATE
               , CONVERT(DATE, @plan_end_time) 	AS DUE_FENCE_DATE
               , CASE WHEN C.TOLERANCE_UOM = 'DAY' THEN CONVERT(NUMERIC(20, 10), C.KEY_VALUE)
               		  WHEN C.TOLERANCE_UOM = 'WEEK' THEN CONVERT(NUMERIC(20, 10), C.KEY_VALUE) * 7 END AS PRECEDE_PRODUCING_TERM
               , 'DAY'            	AS PRECEDE_PRODUCING_TERM_UOM
               , 'MASS' AS PRODUCTION_TYPE
               , 'A004'	AS TO_SITE_ID
               , 'G481'	AS TO_PLANT_ID
               , '-' 	AS TO_FACTORY_ID
               , '-' 				AS LINE_ID
               , 'D' AS MARKET
               , CONVERT(CHAR(8), ITEM_PLAN_DATE, 112) + ITEM_ID AS PRIORITY
               , 0 					AS OFFSET_INVENTORY_QTY
               , 0 					AS OFFSET_GI_QTY
               , 0 					AS OFFSET_FIX_QTY
               , NULL 				AS CONFIRM_TYPE
               , 'NOR' 				AS DEMAND_TYPE
               , 'PRODUCT' 			AS TARGET_TYPE
               , @key_date 			AS KEY_DATE
               , @v_proc_name 		AS INSERT_ID
               , GETDATE() 			AS INSERT_TIME
               , @v_proc_name 		AS UPDATE_ID
               , GETDATE() 			AS UPDATE_TIME                            
			FROM  	TH_BUF_EPOST_SLITTING_PLAN A,
					SY_FP_INSTANCE_INFO_V B,
					SY_FP_INSTANCE_CONFIG_M C,
					SY_SCM_SYS_CALENDAR_M D,
					SY_SCM_SYS_CALENDAR_M E
			WHERE 	1=1
			AND 	A.INSTANCE_ID = @v_master_id
			AND 	A.INSTANCE_ID = B.INSTANCE_ID
			AND 	A.INSTANCE_ID = C.INSTANCE_ID
			AND 	A.FP_PLAN_ID = @v_plan_id
			AND 	C.CATEGORY_ID = 'DPP_CONFIG'
			AND 	C.KEY_ID = 'PRECEDE_TERM'
			AND 	C.PART_ID = B.DIVISION_ID
			AND 	D.DATE_ID = CONVERT(DATE, @plan_start_time)
			AND 	E.DATE_ID = CONVERT(DATE, A.ITEM_PLAN_DATE)    
			UNION ALL
			SELECT B.COMPANY_ID 		AS COMPANY_ID
               , B.DIVISION_ID 		AS DIVISION_ID
               , B.SITE_ID 			AS SITE_ID
               , B.PLANT_ID 		AS PLANT_ID
               , 'E' 				AS SHOP_GROUP_ID
               , @v_master_id 	AS INSTANCE_ID
               , @v_plan_id 		AS DPP_PLAN_ID
               , B.DIVISION_ID + '^'+ B.PLANT_ID + '^' + CONVERT(CHAR(8), ITEM_PLAN_DATE, 112) + '^' + ITEM_ID   AS FP_DEMAND_ID
               , CELL_RELEASE_PLAN_ID AS SCP_PLAN_ID
               , B.DIVISION_ID + '^'+ B.PLANT_ID + '^' + CONVERT(CHAR(8), ITEM_PLAN_DATE, 112) + '^' + ITEM_ID  AS SCP_TARGET_ID
               , ITEM_ID
               , D.WEEK 			AS SCP_WEEK
               , E.WEEK 			AS MFG_WEEK
               , CEILING(A.E3000_OUT_QTY) 	AS MFG_QTY
               , NULL             	AS WORK_ORDER_ID
               , CONVERT(DATE, A.ITEM_PLAN_DATE) 		AS DUE_DATE
               , CONVERT(DATE, @plan_end_time) 	AS DUE_FENCE_DATE
               , CASE WHEN C.TOLERANCE_UOM = 'DAY' THEN CONVERT(NUMERIC(20, 10), C.KEY_VALUE)
               		  WHEN C.TOLERANCE_UOM = 'WEEK' THEN CONVERT(NUMERIC(20, 10), C.KEY_VALUE) * 7 END AS PRECEDE_PRODUCING_TERM
               , 'DAY'            	AS PRECEDE_PRODUCING_TERM_UOM
               , 'MASS' AS PRODUCTION_TYPE
               , 'A004'	AS TO_SITE_ID
               , 'G481'	AS TO_PLANT_ID
               , '-' 	AS TO_FACTORY_ID
               , '-' 				AS LINE_ID
               , 'D' AS MARKET
               , CONVERT(CHAR(8), ITEM_PLAN_DATE, 112) + ITEM_ID AS PRIORITY
               , 0 					AS OFFSET_INVENTORY_QTY
               , 0 					AS OFFSET_GI_QTY
               , 0 					AS OFFSET_FIX_QTY
               , NULL 				AS CONFIRM_TYPE
               , 'NOR' 				AS DEMAND_TYPE
               , 'PRODUCT' 			AS TARGET_TYPE
               , @key_date 			AS KEY_DATE
               , @v_proc_name 		AS INSERT_ID
               , GETDATE() 			AS INSERT_TIME
               , @v_proc_name 		AS UPDATE_ID
               , GETDATE() 			AS UPDATE_TIME                            
			FROM  	TH_BUF_EPOST_ROLLPRESS_PLAN A,
					SY_FP_INSTANCE_INFO_V B,
					SY_FP_INSTANCE_CONFIG_M C,
					SY_SCM_SYS_CALENDAR_M D,
					SY_SCM_SYS_CALENDAR_M E
			WHERE 	1=1
			AND 	A.INSTANCE_ID = @v_master_id
			AND 	A.INSTANCE_ID = B.INSTANCE_ID
			AND 	A.INSTANCE_ID = C.INSTANCE_ID
			AND 	A.FP_PLAN_ID = @v_plan_id
			AND 	A.FLOW_ID = 'E2000E3000'
			AND 	C.CATEGORY_ID = 'DPP_CONFIG'
			AND 	C.KEY_ID = 'PRECEDE_TERM'
			AND 	C.PART_ID = B.DIVISION_ID
			AND 	D.DATE_ID = CONVERT(DATE, @plan_start_time)
			AND 	E.DATE_ID = CONVERT(DATE, A.ITEM_PLAN_DATE)  
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
      	
        
        -- 주차 구간 재 설정 부분
        BEGIN
        
          BEGIN
          
            SET @v_table_name = 'TH_BUF_DEMAND_WEEK'
            
            DELETE FROM TH_BUF_DEMAND_WEEK
            
            INSERT INTO TH_BUF_DEMAND_WEEK
                   (DIVISION_ID, WEEK, CONFIRM_TYPE, WEEKSTART_DATE, WEEKEND_DATE, WEEK_SEQ, EARLY_PRODUCING_DATE) 
            SELECT B.DIVISION_ID,
                   A.WEEK,
                   CASE WHEN WEEK_SEQ <= @v_confirm_week THEN 'CONFIRM'
                        ELSE 'UNCONFIRM'
                   END  CONFIRM_TYPE,
                   A.WEEKSTART_DATE, A.WEEKEND_DATE, A.WEEK_SEQ, A.WEEKSTART_DATE AS EARLY_PRODUCING_DATE
            FROM   (
                    SELECT A.WEEK, A.WEEKSTART_DATE, A.WEEKEND_DATE, CHECK_WEEK, 
                           SUM(CHECK_WEEK) OVER (ORDER BY WEEK) WEEK_SEQ 
                    FROM   (
                              SELECT A.WEEK, A.WEEKSTART_DATE, A.WEEKEND_DATE
                                    , CASE WHEN A.WEEKEND_DATE >= @v_plan_date THEN 1 ELSE 0 END AS CHECK_WEEK
                              FROM   SY_SCM_SYS_CALENDAR_M A
                              WHERE  EXISTS (
                                                SELECT 1
                                                FROM   TH_MST_SCM_DEMAND B
                                                WHERE  B.INSTANCE_ID  = @v_master_id
                                                AND    B.DPP_PLAN_ID  = @v_plan_id
                                                AND    B.MFG_WEEK     = A.WEEK
                                              )
                              AND    DAY = 'SUN'
                           ) A
                   ) A,
                   (
                   SELECT DISTINCT DIVISION_ID
                   FROM   SY_FP_INSTANCE_INFO_V
				   WHERE  1=1
				   AND 	  INSTANCE_ID = @v_master_id                 
                   ) B
            WHERE  1=1
            
            SET @n_row_count = @@ROWCOUNT

            UPDATE TH_BUF_DEMAND_WEEK
            SET    TH_BUF_DEMAND_WEEK.EARLY_PRODUCING_DATE = B.WEEKSTART_DATE
            FROM   TH_BUF_DEMAND_WEEK A,
                   (
                    SELECT WEEK, CONFIRM_TYPE, WEEKSTART_DATE, WEEK_SEQ + 1 AS WEEK_SEQ       -- 1 주 선행
                    FROM   TH_BUF_DEMAND_WEEK                                   
                   ) B
            WHERE  A.CONFIRM_TYPE = B.CONFIRM_TYPE
            AND    A.WEEK_SEQ = B.WEEK_SEQ


            -- 2017.02.03 -- 최대선행하도록 설정하기
            UPDATE TH_BUF_DEMAND_WEEK
            SET    TH_BUF_DEMAND_WEEK.EARLY_PRODUCING_DATE = B.WEEKSTART_DATE
            FROM   TH_BUF_DEMAND_WEEK A,
                   (
                    SELECT CONFIRM_TYPE, MIN(WEEKSTART_DATE) AS WEEKSTART_DATE
                    FROM   TH_BUF_DEMAND_WEEK
                    GROUP  BY CONFIRM_TYPE
                   ) B
            WHERE  A.CONFIRM_TYPE = B.CONFIRM_TYPE

            --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
            -- CONFIG 정보에서 설정된 선행 정보가 있는 애들만 다시 UPDATE 함
            UPDATE TH_BUF_DEMAND_WEEK
            SET    TH_BUF_DEMAND_WEEK.EARLY_PRODUCING_DATE = B.NEW_EARLY_DATE
            FROM   TH_BUF_DEMAND_WEEK A,
                   (
                    SELECT A.*,
                           CASE WHEN EARLY_DATE > MIN_DATE THEN EARLY_DATE ELSE MIN_DATE END NEW_EARLY_DATE
                    FROM   (
                            SELECT A.*, B.PART_ID, B.KEY_VALUE,
                                   DATEADD(DAY, CONVERT(NUMERIC, KEY_VALUE) * -7 + 1, WEEKEND_DATE) EARLY_DATE,
                                   MIN(WEEKSTART_DATE) OVER (PARTITION BY CONFIRM_TYPE) AS MIN_DATE
                            FROM   TH_BUF_DEMAND_WEEK A,
                                   SY_FP_INSTANCE_CONFIG_M B
                            WHERE  B.INSTANCE_ID    = @v_master_id
                            AND    B.CATEGORY_ID    = 'DPP_CONFIG'
                            AND    B.KEY_ID         = 'PRECEDE_TERM'
                            AND    B.TOLERANCE_UOM  = 'WEEK'
                			AND    B.KEY_VALUE      IS NOT NULL
                            AND    A.DIVISION_ID    = B.PART_ID                            
                           ) A
                   ) B
WHERE  A.WEEK = B.WEEK
            AND    A.DIVISION_ID = B.PART_ID
          
            --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
            /*
            -- 4주 확정 구간 선행 FENCE 설정 
            UPDATE TH_BUF_DEMAND_WEEK
            SET    TH_BUF_DEMAND_WEEK.EARLY_PRODUCING_DATE = B.EARLY_PRODUCING_DATE
            FROM TH_BUF_DEMAND_WEEK A,
      				  (SELECT B.INSTANCE_ID, A.DIVISION_ID, MIN(A.EARLY_PRODUCING_DATE) AS EARLY_PRODUCING_DATE
                       FROM   TH_BUF_DEMAND_WEEK A,
                              SY_FP_INSTANCE_CONFIG_M B
                       WHERE  B.INSTANCE_ID    = 'KR_E_PRE'
                       AND    A.DIVISION_ID    = B.PART_ID
                       AND    B.CATEGORY_ID    = 'DPP_CONFIG'
                       AND    B.KEY_ID         = 'IS_UNCONFIRM_PRECEDE_FINITE' 
                       AND    B.KEY_VALUE = 'N'
                       GROUP BY B.INSTANCE_ID, A.DIVISION_ID ) B
            WHERE 1=1
            AND   A.DIVISION_ID = B.DIVISION_ID
          
            --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            */
          END
        
          SET @v_table_name = 'TH_MST_SCM_DEMAND - DAILY_PLAN : MFG_WEEK'

          UPDATE TH_MST_SCM_DEMAND
          SET    TH_MST_SCM_DEMAND.MFG_WEEK = B.WEEK
          FROM   TH_MST_SCM_DEMAND A,
                 TH_BUF_DEMAND_WEEK B
          WHERE  A.INSTANCE_ID = @v_master_id
          AND    A.DPP_PLAN_ID = @v_plan_id
          AND    A.TARGET_TYPE IN ('DAILY_PLAN','SHIPMENT_ELEC')
          AND    A.DIVISION_ID = B.DIVISION_ID
          AND    A.DUE_DATE BETWEEN B.WEEKSTART_DATE AND B.WEEKEND_DATE
          --AND    A.MFG_WEEK <> B.WEEK

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          
          SET @v_table_name = 'TH_MST_SCM_DEMAND : CONFIRM_TYPE '

          UPDATE TH_MST_SCM_DEMAND
          SET    TH_MST_SCM_DEMAND.CONFIRM_TYPE = B.CONFIRM_TYPE
          FROM   TH_MST_SCM_DEMAND A,
                 TH_BUF_DEMAND_WEEK B
          WHERE  A.INSTANCE_ID = @v_master_id
          AND    A.DPP_PLAN_ID = @v_plan_id
          AND    A.DIVISION_ID = B.DIVISION_ID
          AND    A.MFG_WEEK = B.WEEK
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = ' PRECEDE_TERM TYPE - WEEK : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          
          SET @v_table_name = 'TH_MST_SCM_DEMAND : PRECEDE_PRODUCING_TERM '

          UPDATE TH_MST_SCM_DEMAND
          SET    TH_MST_SCM_DEMAND.PRECEDE_PRODUCING_TERM = DATEDIFF(DAY, B.EARLY_PRODUCING_DATE, A.DUE_DATE) + 1
          FROM   TH_MST_SCM_DEMAND A,
                 TH_BUF_DEMAND_WEEK B
          WHERE  A.INSTANCE_ID = @v_master_id
          AND    A.DPP_PLAN_ID = @v_plan_id
    	  AND    A.DIVISION_ID = B.DIVISION_ID
          AND    A.MFG_WEEK = B.WEEK
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = ' PRECEDE_TERM TYPE - WEEK : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          UPDATE TH_MST_SCM_DEMAND
          SET    TH_MST_SCM_DEMAND.PRECEDE_PRODUCING_TERM     = CONVERT(NUMERIC, B.KEY_VALUE)
               , TH_MST_SCM_DEMAND.PRECEDE_PRODUCING_TERM_UOM = B.TOLERANCE_UOM   
          FROM   TH_MST_SCM_DEMAND A
                 INNER  JOIN SY_FP_INSTANCE_CONFIG_M B
                        ON     B.INSTANCE_ID    = A.INSTANCE_ID
                        AND    B.CATEGORY_ID    = 'DPP_CONFIG'
                        AND    B.PART_ID        = A.DIVISION_ID
                        AND    B.KEY_ID         = 'PRECEDE_TERM'
                        AND    B.TOLERANCE_UOM  IN ('DAY', 'HOUR', 'MINUTE')
                        AND    B.KEY_VALUE      IS NOT NULL
                        AND    B.TOLERANCE_UOM  IS NOT NULL
          WHERE  A.INSTANCE_ID = @v_master_id
          AND    A.DPP_PLAN_ID = @v_plan_id
          AND    A.PRODUCTION_TYPE NOT IN ('TEST')        -- 2017.05.03 : TEST 는 선행제약 반영안함.. 당일만 할당

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = ' PRECEDE_TERM TYPE - DAY, HOUR, MINUTE : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          /*SET @v_table_name = 'TH_MST_SCM_DEMAND - DUE_DATE < PST'

          UPDATE TH_MST_SCM_DEMAND
          SET    DUE_DATE     = @v_plan_date
          WHERE  INSTANCE_ID  = @v_master_id
          AND    DPP_PLAN_ID  = @v_plan_id
          AND    DUE_DATE     < @v_plan_date

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null*/

        END
      
        ---------------------------------------------------------------------------------------
        -- DUE FENCE DATE를 PET로 설정
        
        BEGIN
		
          -- DUE_FENCE 를 PET 까지 설정
          SET @v_table_name = 'TH_MST_SCM_DEMAND : DUE_FENCE - PET '
          UPDATE TH_MST_SCM_DEMAND
          SET    MFG_QTY = CEILING(MFG_QTY)
               , DUE_FENCE_DATE = DATEADD(DAY, -1, CONVERT(DATE, @plan_end_time))
          WHERE  INSTANCE_ID = @v_master_id
          AND    DPP_PLAN_ID = @v_plan_id

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          -- FP_DEMAND_ID KEY 설정하기 위함
          UPDATE TH_MST_SCM_DEMAND
          SET    FP_DEMAND_ID = SCP_TARGET_ID + '::FP' + CONVERT(NVARCHAR, @v_plan_date, 12)
          WHERE  INSTANCE_ID = @v_master_id
          AND    DPP_PLAN_ID = @v_plan_id

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

    END

  END TRY  
  
  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
